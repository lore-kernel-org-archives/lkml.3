Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753303Ab3GHVix (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 17:38:53 -0400
Received: from mail-ee0-f41.google.com ([74.125.83.41]:34785 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753100Ab3GHViv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 17:38:51 -0400
Date: Mon, 8 Jul 2013 22:34:56 +0100
From: Frederick van der Wyck <fvanderwyck@gmail.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: Re: [PATCH] platform samsung-q10: use ACPI instead of direct EC
 calls
Message-ID: <20130708213456.GA5441@lat.lan>
References: <20130703212737.GC5579@lat.lan>
 <1373297814.24233.5.camel@x230.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1373297814.24233.5.camel@x230.lan>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 08, 2013 at 11:36:54AM -0400, Matthew Garrett wrote:

> you should be able to just use first_ec directly rather than  
> probing yourself.

Thanks, I've made that change below.

> > +	for (i = 0; i < SAMSUNGQ10_BL_MAX_INTENSITY; i++) {
> > +		status = acpi_evaluate_object(ec_handle, "_Q63", NULL, NULL);
> 
> The potential problem here is that there's no guarantee that these event
> numbers are stable, and a firmware upgrade could change them. Of course,
> that's also true of the EC registers, but we haven't had anyone complain
> about the driver suddenly breaking so I'm not hugely enthusiastic about
> replacing one fragile but seemingly working method with a fragile but
> unproven one. 

That's true. On the other hand, imitating the action of the brightness keys at
this higher level seems somewhat cleaner and has the advantage that the
brightness setting is preserved on reboot (as the smi handler stores it in
nvram). I did test that 63 and 64 are the appropriate event numbers on each of
the models in the dmi table (although I only tested one firmware version per
model).

Signed-off-by: Frederick van der Wyck <fvanderwyck@gmail.com>
---
 drivers/platform/x86/Kconfig       |    2 +-
 drivers/platform/x86/samsung-q10.c |   65 +++++++++++------------------------
 2 files changed, 22 insertions(+), 45 deletions(-)

diff --git a/drivers/platform/x86/Kconfig b/drivers/platform/x86/Kconfig
index 8577261..52aed6d 100644
--- a/drivers/platform/x86/Kconfig
+++ b/drivers/platform/x86/Kconfig
@@ -762,7 +762,7 @@ config INTEL_OAKTRAIL
 
 config SAMSUNG_Q10
 	tristate "Samsung Q10 Extras"
-	depends on SERIO_I8042
+	depends on ACPI
 	select BACKLIGHT_CLASS_DEVICE
 	---help---
 	  This driver provides support for backlight control on Samsung Q10
diff --git a/drivers/platform/x86/samsung-q10.c b/drivers/platform/x86/samsung-q10.c
index 1a90b62..9d6609d 100644
--- a/drivers/platform/x86/samsung-q10.c
+++ b/drivers/platform/x86/samsung-q10.c
@@ -14,16 +14,12 @@
 #include <linux/init.h>
 #include <linux/platform_device.h>
 #include <linux/backlight.h>
-#include <linux/i8042.h>
 #include <linux/dmi.h>
+#include <acpi/acpi_drivers.h>
 
-#define SAMSUNGQ10_BL_MAX_INTENSITY      255
-#define SAMSUNGQ10_BL_DEFAULT_INTENSITY  185
+#define SAMSUNGQ10_BL_MAX_INTENSITY 7
 
-#define SAMSUNGQ10_BL_8042_CMD           0xbe
-#define SAMSUNGQ10_BL_8042_DATA          { 0x89, 0x91 }
-
-static int samsungq10_bl_brightness;
+static acpi_handle ec_handle;
 
 static bool force;
 module_param(force, bool, 0);
@@ -33,21 +29,26 @@ MODULE_PARM_DESC(force,
 static int samsungq10_bl_set_intensity(struct backlight_device *bd)
 {
 
-	int brightness = bd->props.brightness;
-	unsigned char c[3] = SAMSUNGQ10_BL_8042_DATA;
+	acpi_status status;
+	int i;
 
-	c[2] = (unsigned char)brightness;
-	i8042_lock_chip();
-	i8042_command(c, (0x30 << 8) | SAMSUNGQ10_BL_8042_CMD);
-	i8042_unlock_chip();
-	samsungq10_bl_brightness = brightness;
+	for (i = 0; i < SAMSUNGQ10_BL_MAX_INTENSITY; i++) {
+		status = acpi_evaluate_object(ec_handle, "_Q63", NULL, NULL);
+		if (ACPI_FAILURE(status))
+			return -EIO;
+	}
+	for (i = 0; i < bd->props.brightness; i++) {
+		status = acpi_evaluate_object(ec_handle, "_Q64", NULL, NULL);
+		if (ACPI_FAILURE(status))
+			return -EIO;
+	}
 
 	return 0;
 }
 
 static int samsungq10_bl_get_intensity(struct backlight_device *bd)
 {
-	return samsungq10_bl_brightness;
+	return bd->props.brightness;
 }
 
 static const struct backlight_ops samsungq10_bl_ops = {
@@ -55,28 +56,6 @@ static const struct backlight_ops samsungq10_bl_ops = {
 	.update_status	= samsungq10_bl_set_intensity,
 };
 
-#ifdef CONFIG_PM_SLEEP
-static int samsungq10_suspend(struct device *dev)
-{
-	return 0;
-}
-
-static int samsungq10_resume(struct device *dev)
-{
-
-	struct backlight_device *bd = dev_get_drvdata(dev);
-
-	samsungq10_bl_set_intensity(bd);
-	return 0;
-}
-#else
-#define samsungq10_suspend NULL
-#define samsungq10_resume  NULL
-#endif
-
-static SIMPLE_DEV_PM_OPS(samsungq10_pm_ops,
-			  samsungq10_suspend, samsungq10_resume);
-
 static int samsungq10_probe(struct platform_device *pdev)
 {
 
@@ -93,9 +72,6 @@ static int samsungq10_probe(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, bd);
 
-	bd->props.brightness = SAMSUNGQ10_BL_DEFAULT_INTENSITY;
-	samsungq10_bl_set_intensity(bd);
-
 	return 0;
 }
 
@@ -104,9 +80,6 @@ static int samsungq10_remove(struct platform_device *pdev)
 
 	struct backlight_device *bd = platform_get_drvdata(pdev);
 
-	bd->props.brightness = SAMSUNGQ10_BL_DEFAULT_INTENSITY;
-	samsungq10_bl_set_intensity(bd);
-
 	backlight_device_unregister(bd);
 
 	return 0;
@@ -116,7 +89,6 @@ static struct platform_driver samsungq10_driver = {
 	.driver		= {
 		.name	= KBUILD_MODNAME,
 		.owner	= THIS_MODULE,
-		.pm	= &samsungq10_pm_ops,
 	},
 	.probe		= samsungq10_probe,
 	.remove		= samsungq10_remove,
@@ -172,6 +144,11 @@ static int __init samsungq10_init(void)
 	if (!force && !dmi_check_system(samsungq10_dmi_table))
 		return -ENODEV;
 
+	ec_handle = ec_get_handle();
+
+	if (!ec_handle)
+		return -ENODEV;
+
 	samsungq10_device = platform_create_bundle(&samsungq10_driver,
 						   samsungq10_probe,
 						   NULL, 0, NULL, 0);
-- 
1.7.3.4
