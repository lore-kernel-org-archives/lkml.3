Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756252Ab3JKByH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 21:54:07 -0400
Received: from mga01.intel.com ([192.55.52.88]:15399 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755992Ab3JKByF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 21:54:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1076,1371106800"; 
   d="scan'208";a="415204089"
From: tianyu.lan@intel.com
To: lenb@kernel.org, rjw@sisk.pl
Cc: Lan Tianyu <tianyu.lan@intel.com>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/5] ACPI/SBS: Remove SBS's proc directory
Date: Fri, 11 Oct 2013 09:54:09 +0800
Message-Id: <1381456451-22877-3-git-send-email-tianyu.lan@intel.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1381456451-22877-1-git-send-email-tianyu.lan@intel.com>
References: <1381456451-22877-1-git-send-email-tianyu.lan@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lan Tianyu <tianyu.lan@intel.com>

SBS's proc directory isn't useded and so remove it. Prepare for removing
/proc/acpi directory.

Signed-off-by: Lan Tianyu <tianyu.lan@intel.com>
---
 drivers/acpi/sbs.c | 325 +----------------------------------------------------
 1 file changed, 4 insertions(+), 321 deletions(-)

diff --git a/drivers/acpi/sbs.c b/drivers/acpi/sbs.c
index aef7e1c..d465ae6 100644
--- a/drivers/acpi/sbs.c
+++ b/drivers/acpi/sbs.c
@@ -30,12 +30,6 @@
 #include <linux/moduleparam.h>
 #include <linux/kernel.h>
 
-#ifdef CONFIG_ACPI_PROCFS_POWER
-#include <linux/proc_fs.h>
-#include <linux/seq_file.h>
-#include <asm/uaccess.h>
-#endif
-
 #include <linux/acpi.h>
 #include <linux/timer.h>
 #include <linux/jiffies.h>
@@ -67,11 +61,6 @@ static unsigned int cache_time = 1000;
 module_param(cache_time, uint, 0644);
 MODULE_PARM_DESC(cache_time, "cache time in milliseconds");
 
-extern struct proc_dir_entry *acpi_lock_ac_dir(void);
-extern struct proc_dir_entry *acpi_lock_battery_dir(void);
-extern void acpi_unlock_ac_dir(struct proc_dir_entry *acpi_ac_dir);
-extern void acpi_unlock_battery_dir(struct proc_dir_entry *acpi_battery_dir);
-
 #define MAX_SBS_BAT			4
 #define ACPI_SBS_BLOCK_MAX		32
 
@@ -84,9 +73,6 @@ MODULE_DEVICE_TABLE(acpi, sbs_device_ids);
 struct acpi_battery {
 	struct power_supply bat;
 	struct acpi_sbs *sbs;
-#ifdef CONFIG_ACPI_PROCFS_POWER
-	struct proc_dir_entry *proc_entry;
-#endif
 	unsigned long update_time;
 	char name[8];
 	char manufacturer_name[ACPI_SBS_BLOCK_MAX];
@@ -119,9 +105,6 @@ struct acpi_sbs {
 	struct acpi_device *device;
 	struct acpi_smb_hc *hc;
 	struct mutex lock;
-#ifdef CONFIG_ACPI_PROCFS_POWER
-	struct proc_dir_entry *charger_entry;
-#endif
 	struct acpi_battery battery[MAX_SBS_BAT];
 	u8 batteries_supported:4;
 	u8 manager_present:1;
@@ -482,261 +465,6 @@ static struct device_attribute alarm_attr = {
 };
 
 /* --------------------------------------------------------------------------
-                              FS Interface (/proc/acpi)
-   -------------------------------------------------------------------------- */
-
-#ifdef CONFIG_ACPI_PROCFS_POWER
-/* Generic Routines */
-static int
-acpi_sbs_add_fs(struct proc_dir_entry **dir,
-		struct proc_dir_entry *parent_dir,
-		char *dir_name,
-		const struct file_operations *info_fops,
-		const struct file_operations *state_fops,
-		const struct file_operations *alarm_fops, void *data)
-{
-	printk(KERN_WARNING PREFIX "Deprecated procfs I/F for SBS is loaded,"
-			" please retry with CONFIG_ACPI_PROCFS_POWER cleared\n");
-	if (!*dir) {
-		*dir = proc_mkdir(dir_name, parent_dir);
-		if (!*dir) {
-			return -ENODEV;
-		}
-	}
-
-	/* 'info' [R] */
-	if (info_fops)
-		proc_create_data(ACPI_SBS_FILE_INFO, S_IRUGO, *dir,
-				 info_fops, data);
-
-	/* 'state' [R] */
-	if (state_fops)
-		proc_create_data(ACPI_SBS_FILE_STATE, S_IRUGO, *dir,
-				 state_fops, data);
-
-	/* 'alarm' [R/W] */
-	if (alarm_fops)
-		proc_create_data(ACPI_SBS_FILE_ALARM, S_IRUGO, *dir,
-				 alarm_fops, data);
-	return 0;
-}
-
-/* Smart Battery Interface */
-static struct proc_dir_entry *acpi_battery_dir = NULL;
-
-static inline char *acpi_battery_units(struct acpi_battery *battery)
-{
-	return acpi_battery_mode(battery) ? " mW" : " mA";
-}
-
-
-static int acpi_battery_read_info(struct seq_file *seq, void *offset)
-{
-	struct acpi_battery *battery = seq->private;
-	struct acpi_sbs *sbs = battery->sbs;
-	int result = 0;
-
-	mutex_lock(&sbs->lock);
-
-	seq_printf(seq, "present:                 %s\n",
-		   (battery->present) ? "yes" : "no");
-	if (!battery->present)
-		goto end;
-
-	seq_printf(seq, "design capacity:         %i%sh\n",
-		   battery->design_capacity * acpi_battery_scale(battery),
-		   acpi_battery_units(battery));
-	seq_printf(seq, "last full capacity:      %i%sh\n",
-		   battery->full_charge_capacity * acpi_battery_scale(battery),
-		   acpi_battery_units(battery));
-	seq_printf(seq, "battery technology:      rechargeable\n");
-	seq_printf(seq, "design voltage:          %i mV\n",
-		   battery->design_voltage * acpi_battery_vscale(battery));
-	seq_printf(seq, "design capacity warning: unknown\n");
-	seq_printf(seq, "design capacity low:     unknown\n");
-	seq_printf(seq, "cycle count:		  %i\n", battery->cycle_count);
-	seq_printf(seq, "capacity granularity 1:  unknown\n");
-	seq_printf(seq, "capacity granularity 2:  unknown\n");
-	seq_printf(seq, "model number:            %s\n", battery->device_name);
-	seq_printf(seq, "serial number:           %i\n",
-		   battery->serial_number);
-	seq_printf(seq, "battery type:            %s\n",
-		   battery->device_chemistry);
-	seq_printf(seq, "OEM info:                %s\n",
-		   battery->manufacturer_name);
-      end:
-	mutex_unlock(&sbs->lock);
-	return result;
-}
-
-static int acpi_battery_info_open_fs(struct inode *inode, struct file *file)
-{
-	return single_open(file, acpi_battery_read_info, PDE_DATA(inode));
-}
-
-static int acpi_battery_read_state(struct seq_file *seq, void *offset)
-{
-	struct acpi_battery *battery = seq->private;
-	struct acpi_sbs *sbs = battery->sbs;
-	int rate;
-
-	mutex_lock(&sbs->lock);
-	seq_printf(seq, "present:                 %s\n",
-		   (battery->present) ? "yes" : "no");
-	if (!battery->present)
-		goto end;
-
-	acpi_battery_get_state(battery);
-	seq_printf(seq, "capacity state:          %s\n",
-		   (battery->state & 0x0010) ? "critical" : "ok");
-	seq_printf(seq, "charging state:          %s\n",
-		   (battery->rate_now < 0) ? "discharging" :
-		   ((battery->rate_now > 0) ? "charging" : "charged"));
-	rate = abs(battery->rate_now) * acpi_battery_ipscale(battery);
-	rate *= (acpi_battery_mode(battery))?(battery->voltage_now *
-			acpi_battery_vscale(battery)/1000):1;
-	seq_printf(seq, "present rate:            %d%s\n", rate,
-		   acpi_battery_units(battery));
-	seq_printf(seq, "remaining capacity:      %i%sh\n",
-		   battery->capacity_now * acpi_battery_scale(battery),
-		   acpi_battery_units(battery));
-	seq_printf(seq, "present voltage:         %i mV\n",
-		   battery->voltage_now * acpi_battery_vscale(battery));
-
-      end:
-	mutex_unlock(&sbs->lock);
-	return 0;
-}
-
-static int acpi_battery_state_open_fs(struct inode *inode, struct file *file)
-{
-	return single_open(file, acpi_battery_read_state, PDE_DATA(inode));
-}
-
-static int acpi_battery_read_alarm(struct seq_file *seq, void *offset)
-{
-	struct acpi_battery *battery = seq->private;
-	struct acpi_sbs *sbs = battery->sbs;
-	int result = 0;
-
-	mutex_lock(&sbs->lock);
-
-	if (!battery->present) {
-		seq_printf(seq, "present:                 no\n");
-		goto end;
-	}
-
-	acpi_battery_get_alarm(battery);
-	seq_printf(seq, "alarm:                   ");
-	if (battery->alarm_capacity)
-		seq_printf(seq, "%i%sh\n",
-			   battery->alarm_capacity *
-			   acpi_battery_scale(battery),
-			   acpi_battery_units(battery));
-	else
-		seq_printf(seq, "disabled\n");
-      end:
-	mutex_unlock(&sbs->lock);
-	return result;
-}
-
-static ssize_t
-acpi_battery_write_alarm(struct file *file, const char __user * buffer,
-			 size_t count, loff_t * ppos)
-{
-	struct seq_file *seq = file->private_data;
-	struct acpi_battery *battery = seq->private;
-	struct acpi_sbs *sbs = battery->sbs;
-	char alarm_string[12] = { '\0' };
-	int result = 0;
-	mutex_lock(&sbs->lock);
-	if (!battery->present) {
-		result = -ENODEV;
-		goto end;
-	}
-	if (count > sizeof(alarm_string) - 1) {
-		result = -EINVAL;
-		goto end;
-	}
-	if (copy_from_user(alarm_string, buffer, count)) {
-		result = -EFAULT;
-		goto end;
-	}
-	alarm_string[count] = 0;
-	battery->alarm_capacity = simple_strtoul(alarm_string, NULL, 0) /
-					acpi_battery_scale(battery);
-	acpi_battery_set_alarm(battery);
-      end:
-	mutex_unlock(&sbs->lock);
-	if (result)
-		return result;
-	return count;
-}
-
-static int acpi_battery_alarm_open_fs(struct inode *inode, struct file *file)
-{
-	return single_open(file, acpi_battery_read_alarm, PDE_DATA(inode));
-}
-
-static const struct file_operations acpi_battery_info_fops = {
-	.open = acpi_battery_info_open_fs,
-	.read = seq_read,
-	.llseek = seq_lseek,
-	.release = single_release,
-	.owner = THIS_MODULE,
-};
-
-static const struct file_operations acpi_battery_state_fops = {
-	.open = acpi_battery_state_open_fs,
-	.read = seq_read,
-	.llseek = seq_lseek,
-	.release = single_release,
-	.owner = THIS_MODULE,
-};
-
-static const struct file_operations acpi_battery_alarm_fops = {
-	.open = acpi_battery_alarm_open_fs,
-	.read = seq_read,
-	.write = acpi_battery_write_alarm,
-	.llseek = seq_lseek,
-	.release = single_release,
-	.owner = THIS_MODULE,
-};
-
-/* Legacy AC Adapter Interface */
-
-static struct proc_dir_entry *acpi_ac_dir = NULL;
-
-static int acpi_ac_read_state(struct seq_file *seq, void *offset)
-{
-
-	struct acpi_sbs *sbs = seq->private;
-
-	mutex_lock(&sbs->lock);
-
-	seq_printf(seq, "state:                   %s\n",
-		   sbs->charger_present ? "on-line" : "off-line");
-
-	mutex_unlock(&sbs->lock);
-	return 0;
-}
-
-static int acpi_ac_state_open_fs(struct inode *inode, struct file *file)
-{
-	return single_open(file, acpi_ac_read_state, PDE_DATA(inode));
-}
-
-static const struct file_operations acpi_ac_state_fops = {
-	.open = acpi_ac_state_open_fs,
-	.read = seq_read,
-	.llseek = seq_lseek,
-	.release = single_release,
-	.owner = THIS_MODULE,
-};
-
-#endif
-
-/* --------------------------------------------------------------------------
                                  Driver Interface
    -------------------------------------------------------------------------- */
 static int acpi_battery_read(struct acpi_battery *battery)
@@ -781,12 +509,6 @@ static int acpi_battery_add(struct acpi_sbs *sbs, int id)
 		return result;
 
 	sprintf(battery->name, ACPI_BATTERY_DIR_NAME, id);
-#ifdef CONFIG_ACPI_PROCFS_POWER
-	acpi_sbs_add_fs(&battery->proc_entry, acpi_battery_dir,
-			battery->name, &acpi_battery_info_fops,
-			&acpi_battery_state_fops, &acpi_battery_alarm_fops,
-			battery);
-#endif
 	battery->bat.name = battery->name;
 	battery->bat.type = POWER_SUPPLY_TYPE_BATTERY;
 	if (!acpi_battery_mode(battery)) {
@@ -822,10 +544,6 @@ static void acpi_battery_remove(struct acpi_sbs *sbs, int id)
 			device_remove_file(battery->bat.dev, &alarm_attr);
 		power_supply_unregister(&battery->bat);
 	}
-#ifdef CONFIG_ACPI_PROCFS_POWER
-	proc_remove(battery->proc_entry);
-	battery->proc_entry = NULL;
-#endif
 }
 
 static int acpi_charger_add(struct acpi_sbs *sbs)
@@ -835,13 +553,7 @@ static int acpi_charger_add(struct acpi_sbs *sbs)
 	result = acpi_ac_get_present(sbs);
 	if (result)
 		goto end;
-#ifdef CONFIG_ACPI_PROCFS_POWER
-	result = acpi_sbs_add_fs(&sbs->charger_entry, acpi_ac_dir,
-				 ACPI_AC_DIR_NAME, NULL,
-				 &acpi_ac_state_fops, NULL, sbs);
-	if (result)
-		goto end;
-#endif
+
 	sbs->charger.name = "sbs-charger";
 	sbs->charger.type = POWER_SUPPLY_TYPE_MAINS;
 	sbs->charger.properties = sbs_ac_props;
@@ -859,10 +571,6 @@ static void acpi_charger_remove(struct acpi_sbs *sbs)
 {
 	if (sbs->charger.dev)
 		power_supply_unregister(&sbs->charger);
-#ifdef CONFIG_ACPI_PROCFS_POWER
-	proc_remove(sbs->charger_entry);
-	sbs->charger_entry = NULL;
-#endif
 }
 
 static void acpi_sbs_callback(void *context)
@@ -950,20 +658,6 @@ static int acpi_sbs_remove(struct acpi_device *device)
 	return 0;
 }
 
-static void acpi_sbs_rmdirs(void)
-{
-#ifdef CONFIG_ACPI_PROCFS_POWER
-	if (acpi_ac_dir) {
-		acpi_unlock_ac_dir(acpi_ac_dir);
-		acpi_ac_dir = NULL;
-	}
-	if (acpi_battery_dir) {
-		acpi_unlock_battery_dir(acpi_battery_dir);
-		acpi_battery_dir = NULL;
-	}
-#endif
-}
-
 #ifdef CONFIG_PM_SLEEP
 static int acpi_sbs_resume(struct device *dev)
 {
@@ -995,28 +689,17 @@ static int __init acpi_sbs_init(void)
 
 	if (acpi_disabled)
 		return -ENODEV;
-#ifdef CONFIG_ACPI_PROCFS_POWER
-	acpi_ac_dir = acpi_lock_ac_dir();
-	if (!acpi_ac_dir)
-		return -ENODEV;
-	acpi_battery_dir = acpi_lock_battery_dir();
-	if (!acpi_battery_dir) {
-		acpi_sbs_rmdirs();
-		return -ENODEV;
-	}
-#endif
+
 	result = acpi_bus_register_driver(&acpi_sbs_driver);
-	if (result < 0) {
-		acpi_sbs_rmdirs();
+	if (result < 0)
 		return -ENODEV;
-	}
+
 	return 0;
 }
 
 static void __exit acpi_sbs_exit(void)
 {
 	acpi_bus_unregister_driver(&acpi_sbs_driver);
-	acpi_sbs_rmdirs();
 	return;
 }
 
-- 
1.8.2.1

