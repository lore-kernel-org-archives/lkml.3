Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755667Ab3JKBx7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 21:53:59 -0400
Received: from mga11.intel.com ([192.55.52.93]:51499 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752146Ab3JKBx6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 21:53:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1076,1371106800"; 
   d="scan'208";a="409177036"
From: tianyu.lan@intel.com
To: lenb@kernel.org, rjw@sisk.pl
Cc: Lan Tianyu <tianyu.lan@intel.com>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/5] ACPI/AC: Remove AC's proc directory.
Date: Fri, 11 Oct 2013 09:54:07 +0800
Message-Id: <1381456451-22877-1-git-send-email-tianyu.lan@intel.com>
X-Mailer: git-send-email 1.8.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lan Tianyu <tianyu.lan@intel.com>

AC's proc directory is not used and so remove it. Prepare for removing
/proc/acpi directory.

Signed-off-by: Lan Tianyu <tianyu.lan@intel.com>
---
 drivers/acpi/ac.c | 128 +-----------------------------------------------------
 1 file changed, 2 insertions(+), 126 deletions(-)

diff --git a/drivers/acpi/ac.c b/drivers/acpi/ac.c
index f37beaa3..7d28e1a 100644
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
 #include <linux/power_supply.h>
 #include <acpi/acpi_bus.h>
 #include <acpi/acpi_drivers.h>
@@ -55,12 +51,6 @@ MODULE_AUTHOR("Paul Diefenbaugh");
 MODULE_DESCRIPTION("ACPI AC Adapter Driver");
 MODULE_LICENSE("GPL");
 
-#ifdef CONFIG_ACPI_PROCFS_POWER
-extern struct proc_dir_entry *acpi_lock_ac_dir(void);
-extern void *acpi_unlock_ac_dir(struct proc_dir_entry *acpi_ac_dir);
-static int acpi_ac_open_fs(struct inode *inode, struct file *file);
-#endif
-
 static int acpi_ac_add(struct acpi_device *device);
 static int acpi_ac_remove(struct acpi_device *device);
 static void acpi_ac_notify(struct acpi_device *device, u32 event);
@@ -99,16 +89,6 @@ struct acpi_ac {
 
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
@@ -160,83 +140,6 @@ static enum power_supply_property ac_props[] = {
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
-static int acpi_ac_add_fs(struct acpi_device *device)
-{
-	struct proc_dir_entry *entry = NULL;
-
-	printk(KERN_WARNING PREFIX "Deprecated procfs I/F for AC is loaded,"
-			" please retry with CONFIG_ACPI_PROCFS_POWER cleared\n");
-	if (!acpi_device_dir(device)) {
-		acpi_device_dir(device) = proc_mkdir(acpi_device_bid(device),
-						     acpi_ac_dir);
-		if (!acpi_device_dir(device))
-			return -ENODEV;
-	}
-
-	/* 'state' [R] */
-	entry = proc_create_data(ACPI_AC_FILE_STATE,
-				 S_IRUGO, acpi_device_dir(device),
-				 &acpi_ac_fops, acpi_driver_data(device));
-	if (!entry)
-		return -ENODEV;
-	return 0;
-}
-
-static int acpi_ac_remove_fs(struct acpi_device *device)
-{
-
-	if (acpi_device_dir(device)) {
-		remove_proc_entry(ACPI_AC_FILE_STATE, acpi_device_dir(device));
-
-		remove_proc_entry(acpi_device_bid(device), acpi_ac_dir);
-		acpi_device_dir(device) = NULL;
-	}
-
-	return 0;
-}
-#endif
-
 /* --------------------------------------------------------------------------
                                    Driver Model
    -------------------------------------------------------------------------- */
@@ -317,11 +220,6 @@ static int acpi_ac_add(struct acpi_device *device)
 	if (result)
 		goto end;
 
-#ifdef CONFIG_ACPI_PROCFS_POWER
-	result = acpi_ac_add_fs(device);
-#endif
-	if (result)
-		goto end;
 	ac->charger.name = acpi_device_bid(device);
 	ac->charger.type = POWER_SUPPLY_TYPE_MAINS;
 	ac->charger.properties = ac_props;
@@ -336,12 +234,8 @@ static int acpi_ac_add(struct acpi_device *device)
 	       ac->state ? "on-line" : "off-line");
 
       end:
-	if (result) {
-#ifdef CONFIG_ACPI_PROCFS_POWER
-		acpi_ac_remove_fs(device);
-#endif
+	if (result)
 		kfree(ac);
-	}
 
 	dmi_check_system(ac_dmi_table);
 	return result;
@@ -381,9 +275,6 @@ static int acpi_ac_remove(struct acpi_device *device)
 
 	if (ac->charger.dev)
 		power_supply_unregister(&ac->charger);
-#ifdef CONFIG_ACPI_PROCFS_POWER
-	acpi_ac_remove_fs(device);
-#endif
 
 	kfree(ac);
 
@@ -397,19 +288,9 @@ static int __init acpi_ac_init(void)
 	if (acpi_disabled)
 		return -ENODEV;
 
-#ifdef CONFIG_ACPI_PROCFS_POWER
-	acpi_ac_dir = acpi_lock_ac_dir();
-	if (!acpi_ac_dir)
-		return -ENODEV;
-#endif
-
 	result = acpi_bus_register_driver(&acpi_ac_driver);
-	if (result < 0) {
-#ifdef CONFIG_ACPI_PROCFS_POWER
-		acpi_unlock_ac_dir(acpi_ac_dir);
-#endif
+	if (result < 0)
 		return -ENODEV;
-	}
 
 	return 0;
 }
@@ -418,11 +299,6 @@ static void __exit acpi_ac_exit(void)
 {
 
 	acpi_bus_unregister_driver(&acpi_ac_driver);
-
-#ifdef CONFIG_ACPI_PROCFS_POWER
-	acpi_unlock_ac_dir(acpi_ac_dir);
-#endif
-
 	return;
 }
 
-- 
1.8.2.1

