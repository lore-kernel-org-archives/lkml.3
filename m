Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752258Ab3JLNGs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Oct 2013 09:06:48 -0400
Received: from mga02.intel.com ([134.134.136.20]:44446 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750716Ab3JLNGp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Oct 2013 09:06:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,480,1378882800"; 
   d="scan'208";a="418170002"
From: tianyu.lan@intel.com
To: lenb@kernel.org, rjw@rjwysocki.net
Cc: Lan Tianyu <tianyu.lan@intel.com>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [Resend PATCH] ACPI/AC: Remove AC's proc directory.
Date: Sat, 12 Oct 2013 21:04:48 +0800
Message-Id: <1381583088-6305-1-git-send-email-tianyu.lan@intel.com>
X-Mailer: git-send-email 1.8.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lan Tianyu <tianyu.lan@intel.com>

AC's proc directory is not used and so remove it. Prepare for removing
/proc/acpi directory.

Signed-off-by: Lan Tianyu <tianyu.lan@intel.com>
---
Rebase on the latest linux-pm tree linux-next branch.

 drivers/acpi/ac.c | 129 ++----------------------------------------------------
 1 file changed, 3 insertions(+), 126 deletions(-)

diff --git a/drivers/acpi/ac.c b/drivers/acpi/ac.c
index 324b5a0..b9f0d5f 100644
--- a/drivers/acpi/ac.c
+++ b/drivers/acpi/ac.c
@@ -30,10 +30,6 @@
 #include <linux/types.h>
 #include <linux/dmi.h>
 #include <linux/delay.h>
-#ifdef CONFIG_ACPI_PROCFS_POWER
-#include <linux/proc_fs.h>
-#include <linux/seq_file.h>
-#endif
 #include <linux/platform_device.h>
 #include <linux/power_supply.h>
 #include <acpi/acpi_bus.h>
@@ -56,12 +52,6 @@ MODULE_AUTHOR("Paul Diefenbaugh");
 MODULE_DESCRIPTION("ACPI AC Adapter Driver");
 MODULE_LICENSE("GPL");
 
-#ifdef CONFIG_ACPI_PROCFS_POWER
-extern struct proc_dir_entry *acpi_lock_ac_dir(void);
-extern void *acpi_unlock_ac_dir(struct proc_dir_entry *acpi_ac_dir);
-static int acpi_ac_open_fs(struct inode *inode, struct file *file);
-#endif
-
 static int ac_sleep_before_get_state_ms;
 
 struct acpi_ac {
@@ -73,16 +63,6 @@ struct acpi_ac {
 
 #define to_acpi_ac(x) container_of(x, struct acpi_ac, charger)
 
-#ifdef CONFIG_ACPI_PROCFS_POWER
-static const struct file_operations acpi_ac_fops = {
-	.owner = THIS_MODULE,
-	.open = acpi_ac_open_fs,
-	.read = seq_read,
-	.llseek = seq_lseek,
-	.release = single_release,
-};
-#endif
-
 /* --------------------------------------------------------------------------
                                AC Adapter Management
    -------------------------------------------------------------------------- */
@@ -132,83 +112,6 @@ static enum power_supply_property ac_props[] = {
 	POWER_SUPPLY_PROP_ONLINE,
 };
 
-#ifdef CONFIG_ACPI_PROCFS_POWER
-/* --------------------------------------------------------------------------
-                              FS Interface (/proc)
-   -------------------------------------------------------------------------- */
-
-static struct proc_dir_entry *acpi_ac_dir;
-
-static int acpi_ac_seq_show(struct seq_file *seq, void *offset)
-{
-	struct acpi_ac *ac = seq->private;
-
-
-	if (!ac)
-		return 0;
-
-	if (acpi_ac_get_state(ac)) {
-		seq_puts(seq, "ERROR: Unable to read AC Adapter state\n");
-		return 0;
-	}
-
-	seq_puts(seq, "state:                   ");
-	switch (ac->state) {
-	case ACPI_AC_STATUS_OFFLINE:
-		seq_puts(seq, "off-line\n");
-		break;
-	case ACPI_AC_STATUS_ONLINE:
-		seq_puts(seq, "on-line\n");
-		break;
-	default:
-		seq_puts(seq, "unknown\n");
-		break;
-	}
-
-	return 0;
-}
-
-static int acpi_ac_open_fs(struct inode *inode, struct file *file)
-{
-	return single_open(file, acpi_ac_seq_show, PDE_DATA(inode));
-}
-
-static int acpi_ac_add_fs(struct acpi_ac *ac)
-{
-	struct proc_dir_entry *entry = NULL;
-
-	printk(KERN_WARNING PREFIX "Deprecated procfs I/F for AC is loaded,"
-			" please retry with CONFIG_ACPI_PROCFS_POWER cleared\n");
-	if (!acpi_device_dir(ac->adev)) {
-		acpi_device_dir(ac->adev) =
-			proc_mkdir(acpi_device_bid(ac->adev), acpi_ac_dir);
-		if (!acpi_device_dir(ac->adev))
-			return -ENODEV;
-	}
-
-	/* 'state' [R] */
-	entry = proc_create_data(ACPI_AC_FILE_STATE,
-				 S_IRUGO, acpi_device_dir(ac->adev),
-				 &acpi_ac_fops, ac);
-	if (!entry)
-		return -ENODEV;
-	return 0;
-}
-
-static int acpi_ac_remove_fs(struct acpi_ac *ac)
-{
-
-	if (acpi_device_dir(ac->adev)) {
-		remove_proc_entry(ACPI_AC_FILE_STATE,
-				  acpi_device_dir(ac->adev));
-		remove_proc_entry(acpi_device_bid(ac->adev), acpi_ac_dir);
-		acpi_device_dir(ac->adev) = NULL;
-	}
-
-	return 0;
-}
-#endif
-
 /* --------------------------------------------------------------------------
                                    Driver Model
    -------------------------------------------------------------------------- */
@@ -293,11 +196,6 @@ static int acpi_ac_probe(struct platform_device *pdev)
 	if (result)
 		goto end;
 
-#ifdef CONFIG_ACPI_PROCFS_POWER
-	result = acpi_ac_add_fs(ac);
-	if (result)
-		goto end;
-#endif
 	ac->charger.name = acpi_device_bid(adev);
 	ac->charger.type = POWER_SUPPLY_TYPE_MAINS;
 	ac->charger.properties = ac_props;
@@ -317,13 +215,9 @@ static int acpi_ac_probe(struct platform_device *pdev)
 	       acpi_device_name(adev), acpi_device_bid(adev),
 	       ac->state ? "on-line" : "off-line");
 
-      end:
-	if (result) {
-#ifdef CONFIG_ACPI_PROCFS_POWER
-		acpi_ac_remove_fs(ac);
-#endif
+end:
+	if (result)
 		kfree(ac);
-	}
 
 	dmi_check_system(ac_dmi_table);
 	return result;
@@ -366,10 +260,6 @@ static int acpi_ac_remove(struct platform_device *pdev)
 	if (ac->charger.dev)
 		power_supply_unregister(&ac->charger);
 
-#ifdef CONFIG_ACPI_PROCFS_POWER
-	acpi_ac_remove_fs(ac);
-#endif
-
 	kfree(ac);
 
 	return 0;
@@ -399,19 +289,9 @@ static int __init acpi_ac_init(void)
 	if (acpi_disabled)
 		return -ENODEV;
 
-#ifdef CONFIG_ACPI_PROCFS_POWER
-	acpi_ac_dir = acpi_lock_ac_dir();
-	if (!acpi_ac_dir)
-		return -ENODEV;
-#endif
-
 	result = platform_driver_register(&acpi_ac_driver);
-	if (result < 0) {
-#ifdef CONFIG_ACPI_PROCFS_POWER
-		acpi_unlock_ac_dir(acpi_ac_dir);
-#endif
+	if (result < 0)
 		return -ENODEV;
-	}
 
 	return 0;
 }
@@ -419,9 +299,6 @@ static int __init acpi_ac_init(void)
 static void __exit acpi_ac_exit(void)
 {
 	platform_driver_unregister(&acpi_ac_driver);
-#ifdef CONFIG_ACPI_PROCFS_POWER
-	acpi_unlock_ac_dir(acpi_ac_dir);
-#endif
 }
 module_init(acpi_ac_init);
 module_exit(acpi_ac_exit);
-- 
1.8.2.1

