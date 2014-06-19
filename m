Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934105AbaFSTzk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 15:55:40 -0400
Received: from mail-we0-f170.google.com ([74.125.82.170]:44703 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753823AbaFSTzj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 15:55:39 -0400
Message-ID: <53A34031.4030004@gmail.com>
Date: Thu, 19 Jun 2014 21:55:29 +0200
From: Sorin Manolache <sorinm@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:30.0) Gecko/20100101 Icedove/30.0
MIME-Version: 1.0
To: Lan Tianyu <tianyu.lan@intel.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>
CC: Zhang Rui <rui.zhang@intel.com>, linux-kernel@vger.kernel.org,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Subject: Re: drivers/acpi/ac.c, re-enabling CONFIG_ACPI_PROCFS_POWER?
References: <53A1F65C.9090907@gmail.com> <1891948.UFv8RnVsZc@vostro.rjw.lan> <53A28408.8040001@intel.com> <53A295AA.3080904@intel.com>
In-Reply-To: <53A295AA.3080904@intel.com>
Content-Type: multipart/mixed;
 boundary="------------070705090807060000020700"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------070705090807060000020700
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 2014-06-19 09:47, Lan Tianyu wrote:
> On 2014年06月19日 14:32, Lan Tianyu wrote:
>> On 2014年06月19日 07:17, Rafael J. Wysocki wrote:
>>> On Wednesday, June 18, 2014 10:28:12 PM Sorin Manolache wrote:
>>>> Hello,
>>>>
>>>> Would it be worth considering re-enabling the old procfs interface for
>>>> ac.c? There are old tools still around (kpowersave from kde 3.5.10) that
>>>> expect /proc/acpi/ac_adapter.
>>>
>>> Can you please CC ACPI-related messages to linux-acpi@vger.kernel.org?
>>>
>>> I'm not sure how much effort that would require at this point.  Rui, Tianyu?
>>
>> I think we need to revert commit ab0fd67.
>>
>> commit ab0fd674d6cef0904baa511f22613ef6474f8169
>> Author: Lan Tianyu <tianyu.lan@intel.com>
>> Date:   Sat Oct 12 21:04:48 2013 +0800
>>
>>      ACPI / AC: Remove AC's proc directory.
>>
>>      AC's proc directory is not used and so remove it. Prepare for removing
>>      /proc/acpi directory.
>>
>>      Signed-off-by: Lan Tianyu <tianyu.lan@intel.com>
>>      Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>>
>
> Hi Sorin:
> 	Please try the patch in the attachment.
>

Hello Tianyu,

I've applied the patch to 3.15.1. The code did not compile because of 
ac->adev in acpi_ac_add_fs and acpi_ac_remove_fs. The acpi_ac structure 
contains a field "device" and not "adev". So I've modified the patch and 
I've attached it.

Now it works.

Thank you,
Sorin







>>
>>>
>>> Rafael
>>>
>>
>>
>
>



--------------070705090807060000020700
Content-Type: text/x-diff;
 name="0001-Revert-ACPI-AC-Remove-AC-s-proc-directory.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="0001-Revert-ACPI-AC-Remove-AC-s-proc-directory.patch"

>From fd72993b850325603e6e6a424d0f3f117a8fa957 Mon Sep 17 00:00:00 2001
From: Lan Tianyu <tianyu.lan@intel.com>
Date: Thu, 19 Jun 2014 14:54:22 +0800
Subject: [PATCH] Revert "ACPI / AC: Remove AC's proc directory."

This patch is to reverts commit ab0fd674d6cef0904baa511f22613ef6474f8169.
Some old tools (E,G kpowersave from kde 3.5.10) are still using
/proc/acpi/ac_adapter.
---
 drivers/acpi/ac.c | 130 +++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 128 insertions(+), 2 deletions(-)

diff --git a/drivers/acpi/ac.c b/drivers/acpi/ac.c
index c67f6f5..c1a32e3 100644
--- a/drivers/acpi/ac.c
+++ b/drivers/acpi/ac.c
@@ -30,6 +30,10 @@
 #include <linux/types.h>
 #include <linux/dmi.h>
 #include <linux/delay.h>
+#ifdef CONFIG_ACPI_PROCFS_POWER
+#include <linux/proc_fs.h>
+#include <linux/seq_file.h>
+#endif
 #include <linux/platform_device.h>
 #include <linux/power_supply.h>
 #include <linux/acpi.h>
@@ -52,6 +56,7 @@ MODULE_AUTHOR("Paul Diefenbaugh");
 MODULE_DESCRIPTION("ACPI AC Adapter Driver");
 MODULE_LICENSE("GPL");
 
+
 static int acpi_ac_add(struct acpi_device *device);
 static int acpi_ac_remove(struct acpi_device *device);
 static void acpi_ac_notify(struct acpi_device *device, u32 event);
@@ -67,6 +72,13 @@ static int acpi_ac_resume(struct device *dev);
 #endif
 static SIMPLE_DEV_PM_OPS(acpi_ac_pm, NULL, acpi_ac_resume);
 
+#ifdef CONFIG_ACPI_PROCFS_POWER
+extern struct proc_dir_entry *acpi_lock_ac_dir(void);
+extern void *acpi_unlock_ac_dir(struct proc_dir_entry *acpi_ac_dir);
+static int acpi_ac_open_fs(struct inode *inode, struct file *file);
+#endif
+
+
 static int ac_sleep_before_get_state_ms;
 
 static struct acpi_driver acpi_ac_driver = {
@@ -91,6 +103,16 @@ struct acpi_ac {
 
 #define to_acpi_ac(x) container_of(x, struct acpi_ac, charger)
 
+#ifdef CONFIG_ACPI_PROCFS_POWER
+static const struct file_operations acpi_ac_fops = {
+	.owner = THIS_MODULE,
+	.open = acpi_ac_open_fs,
+	.read = seq_read,
+	.llseek = seq_lseek,
+	.release = single_release,
+};
+#endif
+
 /* --------------------------------------------------------------------------
                                AC Adapter Management
    -------------------------------------------------------------------------- */
@@ -143,6 +165,83 @@ static enum power_supply_property ac_props[] = {
 	POWER_SUPPLY_PROP_ONLINE,
 };
 
+#ifdef CONFIG_ACPI_PROCFS_POWER
+/* --------------------------------------------------------------------------
+                              FS Interface (/proc)
+   -------------------------------------------------------------------------- */
+
+static struct proc_dir_entry *acpi_ac_dir;
+
+static int acpi_ac_seq_show(struct seq_file *seq, void *offset)
+{
+	struct acpi_ac *ac = seq->private;
+
+
+	if (!ac)
+		return 0;
+
+	if (acpi_ac_get_state(ac)) {
+		seq_puts(seq, "ERROR: Unable to read AC Adapter state\n");
+		return 0;
+	}
+
+	seq_puts(seq, "state:                   ");
+	switch (ac->state) {
+	case ACPI_AC_STATUS_OFFLINE:
+		seq_puts(seq, "off-line\n");
+		break;
+	case ACPI_AC_STATUS_ONLINE:
+		seq_puts(seq, "on-line\n");
+		break;
+	default:
+		seq_puts(seq, "unknown\n");
+		break;
+	}
+
+	return 0;
+}
+
+static int acpi_ac_open_fs(struct inode *inode, struct file *file)
+{
+	return single_open(file, acpi_ac_seq_show, PDE_DATA(inode));
+}
+
+static int acpi_ac_add_fs(struct acpi_ac *ac)
+{
+	struct proc_dir_entry *entry = NULL;
+
+	printk(KERN_WARNING PREFIX "Deprecated procfs I/F for AC is loaded,"
+			" please retry with CONFIG_ACPI_PROCFS_POWER cleared\n");
+	if (!acpi_device_dir(ac->device)) {
+		acpi_device_dir(ac->device) =
+			proc_mkdir(acpi_device_bid(ac->device), acpi_ac_dir);
+		if (!acpi_device_dir(ac->device))
+			return -ENODEV;
+	}
+
+	/* 'state' [R] */
+	entry = proc_create_data(ACPI_AC_FILE_STATE,
+				 S_IRUGO, acpi_device_dir(ac->device),
+				 &acpi_ac_fops, ac);
+	if (!entry)
+		return -ENODEV;
+	return 0;
+}
+
+static int acpi_ac_remove_fs(struct acpi_ac *ac)
+{
+
+	if (acpi_device_dir(ac->device)) {
+		remove_proc_entry(ACPI_AC_FILE_STATE,
+				  acpi_device_dir(ac->device));
+		remove_proc_entry(acpi_device_bid(ac->device), acpi_ac_dir);
+		acpi_device_dir(ac->device) = NULL;
+	}
+
+	return 0;
+}
+#endif
+
 /* --------------------------------------------------------------------------
                                    Driver Model
    -------------------------------------------------------------------------- */
@@ -243,6 +342,11 @@ static int acpi_ac_add(struct acpi_device *device)
 		goto end;
 
 	ac->charger.name = acpi_device_bid(device);
+#ifdef CONFIG_ACPI_PROCFS_POWER
+	result = acpi_ac_add_fs(ac);
+	if (result)
+		goto end;
+#endif
 	ac->charger.type = POWER_SUPPLY_TYPE_MAINS;
 	ac->charger.properties = ac_props;
 	ac->charger.num_properties = ARRAY_SIZE(ac_props);
@@ -258,8 +362,12 @@ static int acpi_ac_add(struct acpi_device *device)
 	ac->battery_nb.notifier_call = acpi_ac_battery_notify;
 	register_acpi_notifier(&ac->battery_nb);
 end:
-	if (result)
+	if (result) {
+#ifdef CONFIG_ACPI_PROCFS_POWER
+		acpi_ac_remove_fs(ac);
+#endif
 		kfree(ac);
+	}
 
 	dmi_check_system(ac_dmi_table);
 	return result;
@@ -303,6 +411,10 @@ static int acpi_ac_remove(struct acpi_device *device)
 		power_supply_unregister(&ac->charger);
 	unregister_acpi_notifier(&ac->battery_nb);
 
+#ifdef CONFIG_ACPI_PROCFS_POWER
+	acpi_ac_remove_fs(ac);
+#endif
+
 	kfree(ac);
 
 	return 0;
@@ -315,9 +427,20 @@ static int __init acpi_ac_init(void)
 	if (acpi_disabled)
 		return -ENODEV;
 
+#ifdef CONFIG_ACPI_PROCFS_POWER
+	acpi_ac_dir = acpi_lock_ac_dir();
+	if (!acpi_ac_dir)
+		return -ENODEV;
+#endif
+
+
 	result = acpi_bus_register_driver(&acpi_ac_driver);
-	if (result < 0)
+	if (result < 0) {
+#ifdef CONFIG_ACPI_PROCFS_POWER
+		acpi_unlock_ac_dir(acpi_ac_dir);
+#endif
 		return -ENODEV;
+	}
 
 	return 0;
 }
@@ -325,6 +448,9 @@ static int __init acpi_ac_init(void)
 static void __exit acpi_ac_exit(void)
 {
 	acpi_bus_unregister_driver(&acpi_ac_driver);
+#ifdef CONFIG_ACPI_PROCFS_POWER
+	acpi_unlock_ac_dir(acpi_ac_dir);
+#endif
 }
 module_init(acpi_ac_init);
 module_exit(acpi_ac_exit);
-- 
1.8.4.rc0.1.g8f6a3e5.dirty



--------------070705090807060000020700--
