Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751663AbaKWPJ5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2014 10:09:57 -0500
Received: from mail-wg0-f46.google.com ([74.125.82.46]:40294 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751467AbaKWPJy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2014 10:09:54 -0500
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>, Darren Hart <dvhart@infradead.org>
Cc: platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
        Gabriele Mazzotta <gabriele.mzt@gmail.com>,
        Alex Hung <alex.hung@canonical.com>,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
Subject: [PATCH 3/3] platform: x86: dell-laptop: Use dell-rbtn instead i8042 filter when possible
Date: Sun, 23 Nov 2014 16:09:21 +0100
Message-Id: <1416755361-17357-4-git-send-email-pali.rohar@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1416755361-17357-1-git-send-email-pali.rohar@gmail.com>
References: <1416755361-17357-1-git-send-email-pali.rohar@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Until now module dell-laptop registered rfkill device which used i8042 filter
function for receiving HW switch rfkill events (handling special keycode).

But for some dell laptops there is native ACPI driver dell-rbtn which can
receive rfkill events (without i8042 hacks). On some machines it can also
control rfkill devices, but can turn on/off all radio devices.

So this patch will combine best from both sides. It will use native ACPI driver
dell-rbtn for receiving events and dell-laptop SMBIOS interface for enabling or
disabling radio devices. If ACPI driver or device will not be available fallback
to i8042 filter function will be used.

Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
---
 drivers/platform/x86/Kconfig       |    1 +
 drivers/platform/x86/dell-laptop.c |   67 +++++++++++++++++++++++++++++++++---
 2 files changed, 63 insertions(+), 5 deletions(-)

diff --git a/drivers/platform/x86/Kconfig b/drivers/platform/x86/Kconfig
index 5a2ba64..6fbbbbb 100644
--- a/drivers/platform/x86/Kconfig
+++ b/drivers/platform/x86/Kconfig
@@ -96,6 +96,7 @@ config DELL_LAPTOP
 	depends on BACKLIGHT_CLASS_DEVICE
 	depends on RFKILL || RFKILL = n
 	depends on SERIO_I8042
+	select DELL_RBTN
 	select POWER_SUPPLY
 	select LEDS_CLASS
 	select NEW_LEDS
diff --git a/drivers/platform/x86/dell-laptop.c b/drivers/platform/x86/dell-laptop.c
index 233d2ee..5d08c81 100644
--- a/drivers/platform/x86/dell-laptop.c
+++ b/drivers/platform/x86/dell-laptop.c
@@ -30,6 +30,7 @@
 #include <linux/debugfs.h>
 #include <linux/seq_file.h>
 #include "../../firmware/dcdbas.h"
+#include "dell-rbtn.h"
 
 #define BRIGHTNESS_TOKEN 0x7d
 
@@ -583,6 +584,20 @@ static bool dell_laptop_i8042_filter(unsigned char data, unsigned char str,
 	return false;
 }
 
+static bool dell_laptop_use_rbtn;
+
+static int dell_laptop_rbtn_notifier_call(struct notifier_block *nb,
+					  unsigned long action, void *data)
+{
+	schedule_delayed_work(&dell_rfkill_work,
+			      round_jiffies_relative(HZ / 4));
+	return NOTIFY_OK;
+}
+
+static struct notifier_block dell_laptop_rbtn_notifier = {
+	.notifier_call = dell_laptop_rbtn_notifier_call,
+};
+
 static int __init dell_setup_rfkill(void)
 {
 	int status, ret, whitelisted;
@@ -659,10 +674,46 @@ static int __init dell_setup_rfkill(void)
 			goto err_wwan;
 	}
 
-	ret = i8042_install_filter(dell_laptop_i8042_filter);
-	if (ret) {
-		pr_warn("Unable to install key filter\n");
+	/*
+	 * Dell Airplane Mode Switch driver (dell-rbtn) supports ACPI devices
+	 * which can receive HW button switch events and also can control radio
+	 * devices. Somtimes ACPI device supports only reciving events (without
+	 * enable/disable software control).
+	 *
+	 * Dell SMBIOS on whitelisted models supports controlling radio devices
+	 * but does not support receiving HW button switch events. We can use
+	 * i8042 filter hook function to receive keyboard data and handle
+	 * keycode for HW button.
+	 *
+	 * Dell Airplane Mode Switch driver supports only one rfkill switch
+	 * which enable/disable all radio devices. But Dell SMBIOS supports more
+	 * granularity and can enable/disable also one type of radio device
+	 * (e.g disable only bluetooth device without touching wifi device).
+	 *
+	 * So if it is possible we will use Dell Airplane Mode Switch ACPI
+	 * driver for receiving HW events and Dell SMBIOS for setting rfkill
+	 * states. If ACPI driver or device is not available we will fallback to
+	 * i8042 filter hook function.
+	 *
+	 * To prevent duplicate rfkill devices which control and do same thing,
+	 * dell-rbtn driver will automatically remove its own rfkill devices
+	 * once function dell_rbtn_notifier_register() is called.
+	 */
+
+	ret = dell_rbtn_notifier_register(&dell_laptop_rbtn_notifier);
+	if (ret == 0) {
+		pr_info("Using dell-rbtn acpi driver for receiving events\n");
+		dell_laptop_use_rbtn = true;
+	} else if (ret != -ENODEV) {
+		pr_warn("Unable to register dell rbtn notifier\n");
 		goto err_filter;
+	} else {
+		ret = i8042_install_filter(dell_laptop_i8042_filter);
+		if (ret) {
+			pr_warn("Unable to install key filter\n");
+			goto err_filter;
+		}
+		pr_info("Using i8042 filter function for receiving events\n");
 	}
 
 	return 0;
@@ -888,7 +939,10 @@ static int __init dell_init(void)
 	return 0;
 
 fail_backlight:
-	i8042_remove_filter(dell_laptop_i8042_filter);
+	if (dell_laptop_use_rbtn)
+		dell_rbtn_notifier_unregister(&dell_laptop_rbtn_notifier);
+	else
+		i8042_remove_filter(dell_laptop_i8042_filter);
 	cancel_delayed_work_sync(&dell_rfkill_work);
 	dell_cleanup_rfkill();
 fail_rfkill:
@@ -909,7 +963,10 @@ static void __exit dell_exit(void)
 	debugfs_remove_recursive(dell_laptop_dir);
 	if (quirks && quirks->touchpad_led)
 		touchpad_led_exit();
-	i8042_remove_filter(dell_laptop_i8042_filter);
+	if (dell_laptop_use_rbtn)
+		dell_rbtn_notifier_unregister(&dell_laptop_rbtn_notifier);
+	else
+		i8042_remove_filter(dell_laptop_i8042_filter);
 	cancel_delayed_work_sync(&dell_rfkill_work);
 	backlight_device_unregister(dell_backlight_device);
 	dell_cleanup_rfkill();
-- 
1.7.9.5

