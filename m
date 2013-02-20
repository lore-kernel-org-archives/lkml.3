Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758785Ab3BTIoj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 03:44:39 -0500
Received: from mail-da0-f47.google.com ([209.85.210.47]:56283 "EHLO
	mail-da0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751717Ab3BTIoh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 03:44:37 -0500
Date: Wed, 20 Feb 2013 00:44:34 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Matthew Garrett <matthew.garrett@nebula.com>
Cc: platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] hp-wmi: fix handling of platform device
Message-ID: <20130220084433.GA9957@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The driver will not quite work if someone unbinds the platform device
from the platform driver via sysfs (moreover it will bomb is the driver
built into the kernel as hp_wmi_bios_remove is marked as __exit and will
not be present in the kernel).

To fix it let's use platform_driver_probe() instead of
platform_driver_register(), which disables binding/unbinding via sysfs.
This also allows us to mark hp_wmi_bios_setup as __init and discard it
once module is initialized.

Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
---

Compiled only, no hardware to run.

 drivers/platform/x86/hp-wmi.c | 69 +++++++++++++++++++------------------------
 1 file changed, 30 insertions(+), 39 deletions(-)

diff --git a/drivers/platform/x86/hp-wmi.c b/drivers/platform/x86/hp-wmi.c
index 1dde7ac..de78024 100644
--- a/drivers/platform/x86/hp-wmi.c
+++ b/drivers/platform/x86/hp-wmi.c
@@ -72,10 +72,6 @@ enum hp_wmi_event_ids {
 	HPWMI_LOCK_SWITCH = 7,
 };
 
-static int hp_wmi_bios_setup(struct platform_device *device);
-static int __exit hp_wmi_bios_remove(struct platform_device *device);
-static int hp_wmi_resume_handler(struct device *device);
-
 struct bios_args {
 	u32 signature;
 	u32 command;
@@ -157,21 +153,6 @@ struct rfkill2_device {
 static int rfkill2_count;
 static struct rfkill2_device rfkill2[HPWMI_MAX_RFKILL2_DEVICES];
 
-static const struct dev_pm_ops hp_wmi_pm_ops = {
-	.resume  = hp_wmi_resume_handler,
-	.restore  = hp_wmi_resume_handler,
-};
-
-static struct platform_driver hp_wmi_driver = {
-	.driver = {
-		.name = "hp-wmi",
-		.owner = THIS_MODULE,
-		.pm = &hp_wmi_pm_ops,
-	},
-	.probe = hp_wmi_bios_setup,
-	.remove = hp_wmi_bios_remove,
-};
-
 /*
  * hp_wmi_perform_query
  *
@@ -778,7 +759,7 @@ fail:
 	return err;
 }
 
-static int hp_wmi_bios_setup(struct platform_device *device)
+static int __init hp_wmi_bios_setup(struct platform_device *device)
 {
 	int err;
 
@@ -874,12 +855,29 @@ static int hp_wmi_resume_handler(struct device *device)
 	return 0;
 }
 
+static const struct dev_pm_ops hp_wmi_pm_ops = {
+	.resume  = hp_wmi_resume_handler,
+	.restore  = hp_wmi_resume_handler,
+};
+
+static struct platform_driver hp_wmi_driver = {
+	.driver = {
+		.name = "hp-wmi",
+		.owner = THIS_MODULE,
+		.pm = &hp_wmi_pm_ops,
+	},
+	.remove = __exit_p(hp_wmi_bios_remove),
+};
+
 static int __init hp_wmi_init(void)
 {
 	int err;
 	int event_capable = wmi_has_guid(HPWMI_EVENT_GUID);
 	int bios_capable = wmi_has_guid(HPWMI_BIOS_GUID);
 
+	if (!bios_capable && !event_capable)
+		return -ENODEV;
+
 	if (event_capable) {
 		err = hp_wmi_input_setup();
 		if (err)
@@ -887,34 +885,29 @@ static int __init hp_wmi_init(void)
 	}
 
 	if (bios_capable) {
-		err = platform_driver_register(&hp_wmi_driver);
-		if (err)
-			goto err_driver_reg;
-		hp_wmi_platform_dev = platform_device_alloc("hp-wmi", -1);
-		if (!hp_wmi_platform_dev) {
-			err = -ENOMEM;
-			goto err_device_alloc;
+		hp_wmi_platform_dev =
+			platform_device_register_simple("hp-wmi", -1, NULL, 0);
+		if (IS_ERR(hp_wmi_platform_dev)) {
+			err = PTR_ERR(hp_wmi_platform_dev);
+			goto err_destroy_input;
 		}
-		err = platform_device_add(hp_wmi_platform_dev);
+
+		err = platform_driver_probe(&hp_wmi_driver, hp_wmi_bios_setup);
 		if (err)
-			goto err_device_add;
+			goto err_unregister_device;
 	}
 
-	if (!bios_capable && !event_capable)
-		return -ENODEV;
-
 	return 0;
 
-err_device_add:
-	platform_device_put(hp_wmi_platform_dev);
-err_device_alloc:
-	platform_driver_unregister(&hp_wmi_driver);
-err_driver_reg:
+err_unregister_device:
+	platform_device_unregister(hp_wmi_platform_dev);
+err_destroy_input:
 	if (event_capable)
 		hp_wmi_input_destroy();
 
 	return err;
 }
+module_init(hp_wmi_init);
 
 static void __exit hp_wmi_exit(void)
 {
@@ -926,6 +919,4 @@ static void __exit hp_wmi_exit(void)
 		platform_driver_unregister(&hp_wmi_driver);
 	}
 }
-
-module_init(hp_wmi_init);
 module_exit(hp_wmi_exit);
-- 
1.7.11.7

-- 
Dmitry
