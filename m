Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753059AbaKJMut (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 07:50:49 -0500
Received: from mga09.intel.com ([134.134.136.24]:58684 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753030AbaKJMur (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 07:50:47 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,352,1413270000"; 
   d="scan'208";a="605276798"
From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To: Peter Huewe <peterhuewe@gmx.de>, Ashley Lai <ashley@ashleylai.com>,
        Marcel Selhorst <tpmdd@selhorst.net>
Cc: tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        josh.triplett@intel.com, christophe.ricard@gmail.com,
        jason.gunthorpe@obsidianresearch.com,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: [PATCH v6 06/10] tpm: fix race condition with sysfs attributes
Date: Mon, 10 Nov 2014 14:49:50 +0200
Message-Id: <1415623794-6090-7-git-send-email-jarkko.sakkinen@linux.intel.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1415623794-6090-1-git-send-email-jarkko.sakkinen@linux.intel.com>
References: <1415623794-6090-1-git-send-email-jarkko.sakkinen@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sysfs attributes were created into wrong place (platform device
directory) and they had a race condition where user space might
get announced about the device before sysfs were created. This
patch uses the groups field in struct device to resolve this issue.

BIOS log and PPI are still kept racy in order to not break up
backwards compatibility. Moving device sysfs attributes to a
different place should not be a problem because they are not
machine consumable anyway (which is of course wrong but what can
you do since they already exist).

Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
 drivers/char/tpm/tpm-chip.c  | 11 ++---------
 drivers/char/tpm/tpm-dev.c   |  4 ++++
 drivers/char/tpm/tpm-sysfs.c | 23 +----------------------
 drivers/char/tpm/tpm.h       |  3 +--
 4 files changed, 8 insertions(+), 33 deletions(-)

diff --git a/drivers/char/tpm/tpm-chip.c b/drivers/char/tpm/tpm-chip.c
index bd022e0..79cb3aa 100644
--- a/drivers/char/tpm/tpm-chip.c
+++ b/drivers/char/tpm/tpm-chip.c
@@ -144,13 +144,9 @@ int tpm_chip_register(struct tpm_chip *chip)
 	if (rc)
 		return rc;
 
-	rc = tpm_sysfs_add_device(chip);
-	if (rc)
-		goto del_misc;
-
 	rc = tpm_add_ppi(chip);
 	if (rc)
-		goto del_sysfs;
+		goto out_err;
 
 	chip->bios_dir = tpm_bios_log_setup(chip->devname);
 
@@ -160,9 +156,7 @@ int tpm_chip_register(struct tpm_chip *chip)
 	spin_unlock(&driver_lock);
 
 	return 0;
-del_sysfs:
-	tpm_sysfs_del_device(chip);
-del_misc:
+out_err:
 	tpm_dev_del_device(chip);
 	return rc;
 }
@@ -185,7 +179,6 @@ void tpm_chip_unregister(struct tpm_chip *chip)
 	spin_unlock(&driver_lock);
 	synchronize_rcu();
 
-	tpm_sysfs_del_device(chip);
 	tpm_remove_ppi(chip);
 
 	if (chip->bios_dir)
diff --git a/drivers/char/tpm/tpm-dev.c b/drivers/char/tpm/tpm-dev.c
index 8f4263f..42b61776 100644
--- a/drivers/char/tpm/tpm-dev.c
+++ b/drivers/char/tpm/tpm-dev.c
@@ -22,6 +22,8 @@
 #include <linux/major.h>
 #include "tpm.h"
 
+ATTRIBUTE_GROUPS(tpm_dev);
+
 struct file_priv {
 	struct tpm_chip *chip;
 
@@ -199,6 +201,8 @@ int tpm_dev_add_device(struct tpm_chip *chip)
 	else
 		chip->dev.devt = MKDEV(MAJOR(tpm_devt), chip->dev_num);
 
+	chip->dev.groups = tpm_dev_groups;
+
 	dev_set_name(&chip->dev, chip->devname);
 
 	rc = device_register(&chip->dev);
diff --git a/drivers/char/tpm/tpm-sysfs.c b/drivers/char/tpm/tpm-sysfs.c
index ee66fd4..9f5b85a 100644
--- a/drivers/char/tpm/tpm-sysfs.c
+++ b/drivers/char/tpm/tpm-sysfs.c
@@ -263,7 +263,7 @@ static ssize_t timeouts_show(struct device *dev, struct device_attribute *attr,
 }
 static DEVICE_ATTR_RO(timeouts);
 
-static struct attribute *tpm_dev_attrs[] = {
+struct attribute *tpm_dev_attrs[] = {
 	&dev_attr_pubek.attr,
 	&dev_attr_pcrs.attr,
 	&dev_attr_enabled.attr,
@@ -276,24 +276,3 @@ static struct attribute *tpm_dev_attrs[] = {
 	&dev_attr_timeouts.attr,
 	NULL,
 };
-
-static const struct attribute_group tpm_dev_group = {
-	.attrs = tpm_dev_attrs,
-};
-
-int tpm_sysfs_add_device(struct tpm_chip *chip)
-{
-	int err;
-	err = sysfs_create_group(&chip->pdev->kobj,
-				 &tpm_dev_group);
-
-	if (err)
-		dev_err(chip->pdev,
-			"failed to create sysfs attributes, %d\n", err);
-	return err;
-}
-
-void tpm_sysfs_del_device(struct tpm_chip *chip)
-{
-	sysfs_remove_group(&chip->pdev->kobj, &tpm_dev_group);
-}
diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
index 111c61d..8518c49 100644
--- a/drivers/char/tpm/tpm.h
+++ b/drivers/char/tpm/tpm.h
@@ -324,6 +324,7 @@ struct tpm_cmd_t {
 
 extern struct class *tpm_class;
 extern dev_t tpm_devt;
+extern struct attribute *tpm_dev_attrs[];
 
 ssize_t	tpm_getcap(struct device *, __be32, cap_t *, const char *);
 ssize_t tpm_transmit(struct tpm_chip *chip, const char *buf,
@@ -347,8 +348,6 @@ extern void tpm_chip_unregister(struct tpm_chip *chip);
 
 int tpm_dev_add_device(struct tpm_chip *chip);
 void tpm_dev_del_device(struct tpm_chip *chip);
-int tpm_sysfs_add_device(struct tpm_chip *chip);
-void tpm_sysfs_del_device(struct tpm_chip *chip);
 
 int tpm_pcr_read_dev(struct tpm_chip *chip, int pcr_idx, u8 *res_buf);
 
-- 
2.1.0

