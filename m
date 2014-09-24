Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753517AbaIXJGc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 05:06:32 -0400
Received: from mga03.intel.com ([134.134.136.65]:37216 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752334AbaIXJG3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 05:06:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,587,1406617200"; 
   d="scan'208";a="578105245"
From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To: tpmdd-devel@lists.sourceforge.net
Cc: Peter Huewe <peterhuewe@gmx.de>, Marcel Selhorst <tpmdd@selhorst.net>,
        linux-kernel@vger.kernel.org, jgunthorpe@obsidianresearch.com,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: [PATCH v1 01/12] tpm: prepare TPM driver for adding TPM2 support
Date: Wed, 24 Sep 2014 12:05:51 +0300
Message-Id: <1411549562-24242-2-git-send-email-jarkko.sakkinen@linux.intel.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1411549562-24242-1-git-send-email-jarkko.sakkinen@linux.intel.com>
References: <1411549562-24242-1-git-send-email-jarkko.sakkinen@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Separated allocation and registeration into two functions:
  * tpm_chip_alloc()
  * tpm_chip_register()
* Modified tpm_register_hardware() to call tpm_chip_alloc/register().
* Added tpm2 boolean flag to struct tpm_chip.
* If a chip has tpm2 flag set TCPA log is not initialized in
  tpm_chip_register().

The rationale is to introduce TPM2 support without existing drivers
getting harmed.

Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
 drivers/char/tpm/Makefile        |   2 +-
 drivers/char/tpm/tpm-chip.c      | 169 +++++++++++++++++++++++++++++++++++++++
 drivers/char/tpm/tpm-interface.c | 120 ++-------------------------
 drivers/char/tpm/tpm.h           |   9 +++
 4 files changed, 187 insertions(+), 113 deletions(-)
 create mode 100644 drivers/char/tpm/tpm-chip.c

diff --git a/drivers/char/tpm/Makefile b/drivers/char/tpm/Makefile
index 4d85dd6..837da04 100644
--- a/drivers/char/tpm/Makefile
+++ b/drivers/char/tpm/Makefile
@@ -2,7 +2,7 @@
 # Makefile for the kernel tpm device drivers.
 #
 obj-$(CONFIG_TCG_TPM) += tpm.o
-tpm-y := tpm-interface.o tpm-dev.o tpm-sysfs.o
+tpm-y := tpm-interface.o tpm-dev.o tpm-sysfs.o tpm-chip.o
 tpm-$(CONFIG_ACPI) += tpm_ppi.o
 
 ifdef CONFIG_ACPI
diff --git a/drivers/char/tpm/tpm-chip.c b/drivers/char/tpm/tpm-chip.c
new file mode 100644
index 0000000..128942b
--- /dev/null
+++ b/drivers/char/tpm/tpm-chip.c
@@ -0,0 +1,169 @@
+/*
+ * Copyright (C) 2004 IBM Corporation
+ * Copyright (C) 2014 Intel Corporation
+ *
+ * Authors:
+ * Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
+ * Leendert van Doorn <leendert@watson.ibm.com>
+ * Dave Safford <safford@watson.ibm.com>
+ * Reiner Sailer <sailer@watson.ibm.com>
+ * Kylene Hall <kjhall@us.ibm.com>
+ *
+ * Maintained by: <tpmdd-devel@lists.sourceforge.net>
+ *
+ * TPM chip management routines.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation, version 2 of the
+ * License.
+ *
+ */
+
+#include <linux/poll.h>
+#include <linux/slab.h>
+#include <linux/mutex.h>
+#include <linux/spinlock.h>
+#include <linux/freezer.h>
+#include "tpm.h"
+#include "tpm_eventlog.h"
+
+static DECLARE_BITMAP(dev_mask, TPM_NUM_DEVICES);
+static LIST_HEAD(tpm_chip_list);
+static DEFINE_SPINLOCK(driver_lock);
+
+/*
+ * tpm_chip_find_get - return tpm_chip for given chip number
+ */
+struct tpm_chip *tpm_chip_find_get(int chip_num)
+{
+	struct tpm_chip *pos, *chip = NULL;
+
+	rcu_read_lock();
+	list_for_each_entry_rcu(pos, &tpm_chip_list, list) {
+		if (chip_num != TPM_ANY_NUM && chip_num != pos->dev_num)
+			continue;
+
+		if (try_module_get(pos->dev->driver->owner)) {
+			chip = pos;
+			break;
+		}
+	}
+	rcu_read_unlock();
+	return chip;
+}
+
+
+/* In case vendor provided release function, call it too.*/
+
+void tpm_dev_vendor_release(struct tpm_chip *chip)
+{
+	if (!chip)
+		return;
+
+	clear_bit(chip->dev_num, dev_mask);
+}
+EXPORT_SYMBOL_GPL(tpm_dev_vendor_release);
+
+/*
+ * Once all references to platform device are down to 0,
+ * release all allocated structures.
+ */
+static void tpm_dev_release(struct device *dev)
+{
+	struct tpm_chip *chip = dev_get_drvdata(dev);
+
+	if (!chip)
+		return;
+
+	tpm_dev_vendor_release(chip);
+
+	chip->release(dev);
+	kfree(chip);
+}
+
+struct tpm_chip *tpm_chip_alloc(struct device *dev,
+				const struct tpm_class_ops *ops)
+{
+	struct tpm_chip *chip;
+
+	/* Driver specific per-device data */
+	chip = kzalloc(sizeof(*chip), GFP_KERNEL);
+
+	if (chip == NULL)
+		return NULL;
+
+	mutex_init(&chip->tpm_mutex);
+	INIT_LIST_HEAD(&chip->list);
+
+	chip->ops = ops;
+	chip->dev_num = find_first_zero_bit(dev_mask, TPM_NUM_DEVICES);
+
+	if (chip->dev_num >= TPM_NUM_DEVICES) {
+		dev_err(dev, "No available tpm device numbers\n");
+		kfree(chip);
+		return NULL;
+	}
+
+	set_bit(chip->dev_num, dev_mask);
+
+	scnprintf(chip->devname, sizeof(chip->devname), "%s%d", "tpm",
+		  chip->dev_num);
+
+	chip->dev = get_device(dev);
+	chip->release = dev->release;
+	dev->release = tpm_dev_release;
+	dev_set_drvdata(dev, chip);
+
+	return chip;
+}
+EXPORT_SYMBOL_GPL(tpm_chip_alloc);
+
+int tpm_chip_register(struct tpm_chip *chip)
+{
+	int rc;
+
+	rc = tpm_dev_add_device(chip);
+	if (rc)
+		return rc;
+
+	rc = tpm_sysfs_add_device(chip);
+	if (rc)
+		goto del_misc;
+
+	rc = tpm_add_ppi(&chip->dev->kobj);
+	if (rc)
+		goto del_sysfs;
+
+	if (!chip->tpm2)
+		chip->bios_dir = tpm_bios_log_setup(chip->devname);
+
+	/* Make chip available */
+	spin_lock(&driver_lock);
+	list_add_rcu(&chip->list, &tpm_chip_list);
+	spin_unlock(&driver_lock);
+
+	return 0;
+del_sysfs:
+	tpm_sysfs_del_device(chip);
+del_misc:
+	tpm_dev_del_device(chip);
+	return rc;
+}
+EXPORT_SYMBOL_GPL(tpm_chip_register);
+
+void tpm_chip_unregister(struct tpm_chip *chip)
+{
+	spin_lock(&driver_lock);
+	list_del_rcu(&chip->list);
+	spin_unlock(&driver_lock);
+	synchronize_rcu();
+
+	tpm_dev_del_device(chip);
+	tpm_sysfs_del_device(chip);
+	tpm_remove_ppi(&chip->dev->kobj);
+
+	if (!chip->tpm2)
+		tpm_bios_log_teardown(chip->bios_dir);
+}
+EXPORT_SYMBOL_GPL(tpm_chip_unregister);
diff --git a/drivers/char/tpm/tpm-interface.c b/drivers/char/tpm/tpm-interface.c
index f638f9d..3c54570 100644
--- a/drivers/char/tpm/tpm-interface.c
+++ b/drivers/char/tpm/tpm-interface.c
@@ -47,10 +47,6 @@ module_param_named(suspend_pcr, tpm_suspend_pcr, uint, 0644);
 MODULE_PARM_DESC(suspend_pcr,
 		 "PCR to use for dummy writes to faciltate flush on suspend.");
 
-static LIST_HEAD(tpm_chip_list);
-static DEFINE_SPINLOCK(driver_lock);
-static DECLARE_BITMAP(dev_mask, TPM_NUM_DEVICES);
-
 /*
  * Array with one entry per ordinal defining the maximum amount
  * of time the chip could take to return the result.  The ordinal
@@ -636,27 +632,6 @@ static int tpm_continue_selftest(struct tpm_chip *chip)
 	return rc;
 }
 
-/*
- * tpm_chip_find_get - return tpm_chip for given chip number
- */
-static struct tpm_chip *tpm_chip_find_get(int chip_num)
-{
-	struct tpm_chip *pos, *chip = NULL;
-
-	rcu_read_lock();
-	list_for_each_entry_rcu(pos, &tpm_chip_list, list) {
-		if (chip_num != TPM_ANY_NUM && chip_num != pos->dev_num)
-			continue;
-
-		if (try_module_get(pos->dev->driver->owner)) {
-			chip = pos;
-			break;
-		}
-	}
-	rcu_read_unlock();
-	return chip;
-}
-
 #define TPM_ORDINAL_PCRREAD cpu_to_be32(21)
 #define READ_PCR_RESULT_SIZE 30
 static struct tpm_input_header pcrread_header = {
@@ -893,15 +868,7 @@ void tpm_remove_hardware(struct device *dev)
 		return;
 	}
 
-	spin_lock(&driver_lock);
-	list_del_rcu(&chip->list);
-	spin_unlock(&driver_lock);
-	synchronize_rcu();
-
-	tpm_dev_del_device(chip);
-	tpm_sysfs_del_device(chip);
-	tpm_remove_ppi(&dev->kobj);
-	tpm_bios_log_teardown(chip->bios_dir);
+	tpm_chip_unregister(chip);
 
 	/* write it this way to be explicit (chip->dev == dev) */
 	put_device(chip->dev);
@@ -1041,35 +1008,6 @@ int tpm_get_random(u32 chip_num, u8 *out, size_t max)
 }
 EXPORT_SYMBOL_GPL(tpm_get_random);
 
-/* In case vendor provided release function, call it too.*/
-
-void tpm_dev_vendor_release(struct tpm_chip *chip)
-{
-	if (!chip)
-		return;
-
-	clear_bit(chip->dev_num, dev_mask);
-}
-EXPORT_SYMBOL_GPL(tpm_dev_vendor_release);
-
-
-/*
- * Once all references to platform device are down to 0,
- * release all allocated structures.
- */
-static void tpm_dev_release(struct device *dev)
-{
-	struct tpm_chip *chip = dev_get_drvdata(dev);
-
-	if (!chip)
-		return;
-
-	tpm_dev_vendor_release(chip);
-
-	chip->release(dev);
-	kfree(chip);
-}
-
 /*
  * Called from tpm_<specific>.c probe function only for devices
  * the driver has determined it should claim.  Prior to calling
@@ -1081,61 +1019,19 @@ struct tpm_chip *tpm_register_hardware(struct device *dev,
 				       const struct tpm_class_ops *ops)
 {
 	struct tpm_chip *chip;
+	int rc;
 
-	/* Driver specific per-device data */
-	chip = kzalloc(sizeof(*chip), GFP_KERNEL);
-
-	if (chip == NULL)
+	chip = tpm_chip_alloc(dev, ops);
+	if (!chip)
 		return NULL;
 
-	mutex_init(&chip->tpm_mutex);
-	INIT_LIST_HEAD(&chip->list);
-
-	chip->ops = ops;
-	chip->dev_num = find_first_zero_bit(dev_mask, TPM_NUM_DEVICES);
-
-	if (chip->dev_num >= TPM_NUM_DEVICES) {
-		dev_err(dev, "No available tpm device numbers\n");
-		goto out_free;
+	rc = tpm_chip_register(chip);
+	if (rc) {
+		put_device(chip->dev);
+		kfree(chip);
 	}
 
-	set_bit(chip->dev_num, dev_mask);
-
-	scnprintf(chip->devname, sizeof(chip->devname), "%s%d", "tpm",
-		  chip->dev_num);
-
-	chip->dev = get_device(dev);
-	chip->release = dev->release;
-	dev->release = tpm_dev_release;
-	dev_set_drvdata(dev, chip);
-
-	if (tpm_dev_add_device(chip))
-		goto put_device;
-
-	if (tpm_sysfs_add_device(chip))
-		goto del_misc;
-
-	if (tpm_add_ppi(&dev->kobj))
-		goto del_sysfs;
-
-	chip->bios_dir = tpm_bios_log_setup(chip->devname);
-
-	/* Make chip available */
-	spin_lock(&driver_lock);
-	list_add_rcu(&chip->list, &tpm_chip_list);
-	spin_unlock(&driver_lock);
-
 	return chip;
-
-del_sysfs:
-	tpm_sysfs_del_device(chip);
-del_misc:
-	tpm_dev_del_device(chip);
-put_device:
-	put_device(chip->dev);
-out_free:
-	kfree(chip);
-	return NULL;
 }
 EXPORT_SYMBOL_GPL(tpm_register_hardware);
 
diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
index d893335..cc95a52 100644
--- a/drivers/char/tpm/tpm.h
+++ b/drivers/char/tpm/tpm.h
@@ -109,6 +109,8 @@ struct tpm_chip {
 
 	struct dentry **bios_dir;
 
+	bool tpm2; /* is this a TPM2 chip? */
+
 	struct list_head list;
 	void (*release) (struct device *);
 };
@@ -332,6 +334,13 @@ extern int tpm_pm_resume(struct device *);
 extern int wait_for_tpm_stat(struct tpm_chip *, u8, unsigned long,
 			     wait_queue_head_t *, bool);
 
+struct tpm_chip *tpm_chip_find_get(int chip_num);
+extern void tpm_dev_vendor_release(struct tpm_chip *);
+extern struct tpm_chip *tpm_chip_alloc(struct device *dev,
+				       const struct tpm_class_ops *ops);
+extern int tpm_chip_register(struct tpm_chip *chip);
+extern void tpm_chip_unregister(struct tpm_chip *chip);
+
 int tpm_dev_add_device(struct tpm_chip *chip);
 void tpm_dev_del_device(struct tpm_chip *chip);
 int tpm_sysfs_add_device(struct tpm_chip *chip);
-- 
2.1.0

