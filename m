Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756292Ab3GCMtg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 08:49:36 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60725 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756072Ab3GCMsn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 08:48:43 -0400
From: Thomas Renninger <trenn@suse.de>
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        platform-driver-x86@vger.kernel.org,
        ibm-acpi-devel@lists.sourceforge.net, trenn@suse.de,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: [PATCH 3/3] platform thinkpad: Remove deprecated hotkey_report_mode parameter
Date: Wed,  3 Jul 2013 14:48:39 +0200
Message-Id: <1372855719-34315-4-git-send-email-trenn@suse.de>
X-Mailer: git-send-email 1.7.6.1
In-Reply-To: <1372855719-34315-1-git-send-email-trenn@suse.de>
References: <1372855719-34315-1-git-send-email-trenn@suse.de>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is somewhat strange that the default value to support the depracated
interface is set (1).
Anyway this exists for years. The previous patch already removed the
functionality to still export specific events through /proc. Now this param
is useless and should vanish as well.

CC: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Signed-off-by: Thomas Renninger <trenn@suse.de>
---
 Documentation/laptops/thinkpad-acpi.txt |   73 +++----------------------------
 drivers/platform/x86/thinkpad_acpi.c    |   29 ------------
 2 files changed, 6 insertions(+), 96 deletions(-)

diff --git a/Documentation/laptops/thinkpad-acpi.txt b/Documentation/laptops/thinkpad-acpi.txt
index cf7bc6c..86c5236 100644
--- a/Documentation/laptops/thinkpad-acpi.txt
+++ b/Documentation/laptops/thinkpad-acpi.txt
@@ -329,20 +329,6 @@ sysfs notes:
 
 		This attribute has poll()/select() support.
 
-	hotkey_report_mode:
-		Returns the state of the procfs ACPI event report mode
-		filter for hot keys.  If it is set to 1 (the default),
-		all hot key presses are reported both through the input
-		layer and also as ACPI events through procfs (but not
-		through netlink).  If it is set to 2, hot key presses
-		are reported only through the input layer.
-
-		This attribute is read-only in kernels 2.6.23 or later,
-		and read-write on earlier kernels.
-
-		May return -EPERM (write access locked out by module
-		parameter) or -EACCES (read-only).
-
 	wakeup_reason:
 		Set to 1 if the system is waking up because the user
 		requested a bay ejection.  Set to 2 if the system is
@@ -518,24 +504,21 @@ SW_TABLET_MODE	Tablet ThinkPads HKEY events 0x5009 and 0x500A
 Non hotkey ACPI HKEY event map:
 -------------------------------
 
-Events that are not propagated by the driver, except for legacy
-compatibility purposes when hotkey_report_mode is set to 1:
-
-0x5001		Lid closed
-0x5002		Lid opened
-0x5009		Tablet swivel: switched to tablet mode
-0x500A		Tablet swivel: switched to normal mode
-0x7000		Radio Switch may have changed state
-
 Events that are never propagated by the driver:
 
 0x2304		System is waking up from suspend to undock
 0x2305		System is waking up from suspend to eject bay
 0x2404		System is waking up from hibernation to undock
 0x2405		System is waking up from hibernation to eject bay
+0x5001		Lid closed
+0x5002		Lid opened
+0x5009		Tablet swivel: switched to tablet mode
+0x500A		Tablet swivel: switched to normal mode
 0x5010		Brightness level changed/control event
 0x6000		KEYBOARD: Numlock key pressed
 0x6005		KEYBOARD: Fn key pressed (TO BE VERIFIED)
+0x7000		Radio Switch may have changed state
+
 
 Events that are propagated by the driver to userspace:
 
@@ -574,50 +557,6 @@ operating system is to force either an immediate suspend or hibernate
 cycle, or a system shutdown.  Obviously, something is very wrong if this
 happens.
 
-Compatibility notes:
-
-ibm-acpi and thinkpad-acpi 0.15 (mainline kernels before 2.6.23) never
-supported the input layer, and sent events over the procfs ACPI event
-interface.
-
-To avoid sending duplicate events over the input layer and the ACPI
-event interface, thinkpad-acpi 0.16 implements a module parameter
-(hotkey_report_mode), and also a sysfs device attribute with the same
-name.
-
-Make no mistake here: userspace is expected to switch to using the input
-layer interface of thinkpad-acpi, together with the ACPI netlink event
-interface in kernels 2.6.23 and later, or with the ACPI procfs event
-interface in kernels 2.6.22 and earlier.
-
-If no hotkey_report_mode module parameter is specified (or it is set to
-zero), the driver defaults to mode 1 (see below), and on kernels 2.6.22
-and earlier, also allows one to change the hotkey_report_mode through
-sysfs.  In kernels 2.6.23 and later, where the netlink ACPI event
-interface is available, hotkey_report_mode cannot be changed through
-sysfs (it is read-only).
-
-If the hotkey_report_mode module parameter is set to 1 or 2, it cannot
-be changed later through sysfs (any writes will return -EPERM to signal
-that hotkey_report_mode was locked.  On 2.6.23 and later, where
-hotkey_report_mode cannot be changed at all, writes will return -EACCES).
-
-hotkey_report_mode set to 1 makes the driver export through the procfs
-ACPI event interface all hot key presses (which are *also* sent to the
-input layer).  This is a legacy compatibility behaviour, and it is also
-the default mode of operation for the driver.
-
-hotkey_report_mode set to 2 makes the driver filter out the hot key
-presses from the procfs ACPI event interface, so these events will only
-be sent through the input layer.  Userspace that has been updated to use
-the thinkpad-acpi input layer interface should set hotkey_report_mode to
-2.
-
-Hot key press events are never sent to the ACPI netlink event interface.
-Really up-to-date userspace under kernel 2.6.23 and later is to use the
-netlink interface and the input layer interface, and don't bother at all
-with hotkey_report_mode.
-
 
 Brightness hotkey notes:
 
diff --git a/drivers/platform/x86/thinkpad_acpi.c b/drivers/platform/x86/thinkpad_acpi.c
index e946c0d..be67e5e 100644
--- a/drivers/platform/x86/thinkpad_acpi.c
+++ b/drivers/platform/x86/thinkpad_acpi.c
@@ -2022,8 +2022,6 @@ static u32 hotkey_driver_mask;		/* events needed by the driver */
 static u32 hotkey_user_mask;		/* events visible to userspace */
 static u32 hotkey_acpi_mask;		/* events enabled in firmware */
 
-static unsigned int hotkey_report_mode;
-
 static u16 *hotkey_keycode_map;
 
 static struct attribute_set *hotkey_dev_attributes;
@@ -2878,18 +2876,6 @@ static void hotkey_tablet_mode_notify_change(void)
 			     "hotkey_tablet_mode");
 }
 
-/* sysfs hotkey report_mode -------------------------------------------- */
-static ssize_t hotkey_report_mode_show(struct device *dev,
-			   struct device_attribute *attr,
-			   char *buf)
-{
-	return snprintf(buf, PAGE_SIZE, "%d\n",
-		(hotkey_report_mode != 0) ? hotkey_report_mode : 1);
-}
-
-static struct device_attribute dev_attr_hotkey_report_mode =
-	__ATTR(hotkey_report_mode, S_IRUGO, hotkey_report_mode_show, NULL);
-
 /* sysfs wakeup reason (pollable) -------------------------------------- */
 static ssize_t hotkey_wakeup_reason_show(struct device *dev,
 			   struct device_attribute *attr,
@@ -2931,7 +2917,6 @@ static struct attribute *hotkey_attributes[] __initdata = {
 	&dev_attr_hotkey_enable.attr,
 	&dev_attr_hotkey_bios_enabled.attr,
 	&dev_attr_hotkey_bios_mask.attr,
-	&dev_attr_hotkey_report_mode.attr,
 	&dev_attr_hotkey_wakeup_reason.attr,
 	&dev_attr_hotkey_wakeup_hotunplug_complete.attr,
 	&dev_attr_hotkey_mask.attr,
@@ -3435,11 +3420,6 @@ static int __init hotkey_init(struct ibm_init_struct *iibm)
 		"initial masks: user=0x%08x, fw=0x%08x, poll=0x%08x\n",
 		hotkey_user_mask, hotkey_acpi_mask, hotkey_source_mask);
 
-	dbg_printk(TPACPI_DBG_INIT | TPACPI_DBG_HKEY,
-			"legacy ibm/hotkey event reporting over procfs %s\n",
-			(hotkey_report_mode < 2) ?
-				"enabled" : "disabled");
-
 	tpacpi_inputdev->open = &hotkey_inputdev_open;
 	tpacpi_inputdev->close = &hotkey_inputdev_close;
 
@@ -8829,11 +8809,6 @@ module_param(brightness_enable, uint, 0444);
 MODULE_PARM_DESC(brightness_enable,
 		 "Enables backlight control when 1, disables when 0");
 
-module_param(hotkey_report_mode, uint, 0444);
-MODULE_PARM_DESC(hotkey_report_mode,
-		 "used for backwards compatibility with userspace, "
-		 "see documentation");
-
 #ifdef CONFIG_THINKPAD_ACPI_ALSA_SUPPORT
 module_param_named(volume_mode, volume_mode, uint, 0444);
 MODULE_PARM_DESC(volume_mode,
@@ -8964,10 +8939,6 @@ static int __init thinkpad_acpi_module_init(void)
 
 	tpacpi_lifecycle = TPACPI_LIFE_INIT;
 
-	/* Parameter checking */
-	if (hotkey_report_mode > 2)
-		return -EINVAL;
-
 	/* Driver-level probe */
 
 	ret = get_thinkpad_model_data(&thinkpad_id);
-- 
1.7.6.1

