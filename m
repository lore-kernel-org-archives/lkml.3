Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756240Ab3HZHwH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 03:52:07 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:35724 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756084Ab3HZHwF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 03:52:05 -0400
Date: Mon, 26 Aug 2013 00:51:56 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Andrey Moiseev <o2g.org.ru@gmail.com>
Cc: linux-input@vger.kernel.org, arnoques@gmail.com, russianneuromancer@ya.ru,
        ike.pan@canonical.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v8 1/1] input: ideapad_slidebar: new input driver
Message-ID: <20130826075156.GC26405@core.coreip.homeip.net>
References: <52144C19.80701@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52144C19.80701@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrey,

On Wed, Aug 21, 2013 at 09:11:53AM +0400, Andrey Moiseev wrote:
> v8: added `extended = false;` line
> 
> ideapad_slidebar is a new driver which enables slidebars on some
> Lenovo IdeaPad laptops (the slidebars work with SlideNav/Desktop
> Navigator under Windows)

Could you tell me if after applying the patch below on top of yours the
device still works?

Thanks!

-- 
Dmitry


Input: lenovo-ideapad - a few cleanups

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
---
 drivers/input/misc/Kconfig            |    7 +-
 drivers/input/misc/ideapad_slidebar.c |  130 +++++++++++++++++++--------------
 2 files changed, 79 insertions(+), 58 deletions(-)

diff --git a/drivers/input/misc/Kconfig b/drivers/input/misc/Kconfig
index b19defe..3321b60 100644
--- a/drivers/input/misc/Kconfig
+++ b/drivers/input/misc/Kconfig
@@ -676,10 +676,11 @@ config INPUT_SIRFSOC_ONKEY
 config INPUT_IDEAPAD_SLIDEBAR
 	tristate "IdeaPad Laptop Slidebar"
 	depends on INPUT
+	depends on SERIO_I8042
 	help
-	  Input driver for slidebars on some Lenovo IdeaPad laptops.
+	  Say Y here if you have an IdeaPad laptop with a slidebar.
 
-	  If you have an IdeaPad laptop with a slidebar, say Y or M here.
-	  Module name is ideapad_slidebar.
+	  To compile this driver as a module, choose M here: the
+	  module will be called ideapad_slidebar.
 
 endif
diff --git a/drivers/input/misc/ideapad_slidebar.c b/drivers/input/misc/ideapad_slidebar.c
index 5deeeff..0d5b167 100644
--- a/drivers/input/misc/ideapad_slidebar.c
+++ b/drivers/input/misc/ideapad_slidebar.c
@@ -73,6 +73,8 @@
  * 0x11   ONMOV
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/dmi.h>
@@ -82,6 +84,9 @@
 #include <linux/io.h>
 #include <linux/ioport.h>
 #include <linux/i8042.h>
+#include <linux/serio.h>
+
+#define IDEAPAD_BASE	0xff29
 
 static bool force;
 module_param(force, bool, 0);
@@ -92,9 +97,9 @@ static DEFINE_SPINLOCK(io_lock);
 static struct input_dev *slidebar_input_dev;
 static struct platform_device *slidebar_platform_dev;
 
-static unsigned char slidebar_pos_get(void)
+static u8 slidebar_pos_get(void)
 {
-	int res;
+	u8 res;
 	unsigned long flags;
 
 	spin_lock_irqsave(&io_lock, flags);
@@ -102,12 +107,13 @@ static unsigned char slidebar_pos_get(void)
 	outb(0xbf, 0xff2a);
 	res = inb(0xff2b);
 	spin_unlock_irqrestore(&io_lock, flags);
+
 	return res;
 }
 
-static unsigned char slidebar_mode_get(void)
+static u8 slidebar_mode_get(void)
 {
-	int res;
+	u8 res;
 	unsigned long flags;
 
 	spin_lock_irqsave(&io_lock, flags);
@@ -115,10 +121,11 @@ static unsigned char slidebar_mode_get(void)
 	outb(0x8b, 0xff2a);
 	res = inb(0xff2b);
 	spin_unlock_irqrestore(&io_lock, flags);
+
 	return res;
 }
 
-static void slidebar_mode_set(unsigned char mode)
+static void slidebar_mode_set(u8 mode)
 {
 	unsigned long flags;
 
@@ -130,52 +137,61 @@ static void slidebar_mode_set(unsigned char mode)
 }
 
 static bool slidebar_i8042_filter(unsigned char data, unsigned char str,
-				struct serio *port)
+				  struct serio *port)
 {
 	static bool extended = false;
 
 	/* Scancodes: e03b on move, e0bb on release */
-	if (unlikely(data == 0xe0)) {
+	if (data == 0xe0) {
 		extended = true;
+		return true;
+	}
+
+	if (!extended)
 		return false;
-	} else if (unlikely(extended && (data == 0x3b))) {
-		extended = false;
-		input_report_key(slidebar_input_dev, BTN_TOUCH, 1);
-		input_report_abs(slidebar_input_dev, ABS_X, slidebar_pos_get());
-		input_sync(slidebar_input_dev);
+
+	if (likely((data & 0x7f) != 0x3b)) {
+		serio_interrupt(port, 0xe0, 0);
 		return false;
-	} else if (unlikely(extended && (data == 0xbb))) {
-		extended = false;
+	}
+
+	if (data & 0x80) {
 		input_report_key(slidebar_input_dev, BTN_TOUCH, 0);
-		input_sync(slidebar_input_dev);
-		return false;
+	} else {
+		input_report_key(slidebar_input_dev, BTN_TOUCH, 1);
+		input_report_abs(slidebar_input_dev, ABS_X, slidebar_pos_get());
 	}
-	return false;
+	input_sync(slidebar_input_dev);
+
+	extended = false;
+	return true;
 }
 
 static ssize_t show_slidebar_mode(struct device *dev,
-				struct device_attribute *attr,
-				char *buf)
+				  struct device_attribute *attr,
+				  char *buf)
 {
 	return sprintf(buf, "%x\n", slidebar_mode_get());
 }
 
 static ssize_t store_slidebar_mode(struct device *dev,
-				struct device_attribute *attr,
-				const char *buf, size_t count)
+				   struct device_attribute *attr,
+				   const char *buf, size_t count)
 {
-	int mode;
+	u8 mode;
+	int error;
+
+	error = kstrtou8(buf, 0, &mode);
+	if (error)
+		return error;
 
-	if (!count)
-		return 0;
-	if (sscanf(buf, "%x", &mode) != 1)
-		return -EINVAL;
 	slidebar_mode_set(mode);
+
 	return count;
 }
 
-static DEVICE_ATTR(slidebar_mode, S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH,
-				show_slidebar_mode, store_slidebar_mode);
+static DEVICE_ATTR(slidebar_mode, S_IWUSR | S_IRUGO,
+		   show_slidebar_mode, store_slidebar_mode);
 
 static struct attribute *ideapad_attrs[] = {
 	&dev_attr_slidebar_mode.attr,
@@ -191,40 +207,42 @@ static const struct attribute_group *ideapad_attr_groups[] = {
 	NULL
 };
 
-static int probe(struct platform_device* dev)
+static int __init ideapad_probe(struct platform_device* pdev)
 {
 	int err;
 
-	if (!request_region(0xff29, 3, "ideapad_slidebar")) {
-		pr_err("ideapad_slidebar: IO ports are busy\n");
+	if (!request_region(IDEAPAD_BASE, 3, "ideapad_slidebar")) {
+		dev_err(&pdev->dev, "IO ports are busy\n");
 		return -EBUSY;
 	}
 
 	slidebar_input_dev = input_allocate_device();
 	if (!slidebar_input_dev) {
-		pr_err("ideapad_slidebar: Not enough memory\n");
+		dev_err(&pdev->dev, "Failed to allocate input device\n");
 		err = -ENOMEM;
 		goto err_release_ports;
 	}
 
 	slidebar_input_dev->name = "IdeaPad Slidebar";
 	slidebar_input_dev->id.bustype = BUS_HOST;
-	slidebar_input_dev->dev.parent = &slidebar_platform_dev->dev;
+	slidebar_input_dev->dev.parent = &pdev->dev;
 	input_set_capability(slidebar_input_dev, EV_KEY, BTN_TOUCH);
-	input_set_capability(slidebar_input_dev, EV_ABS, ABS_X);
 	input_set_abs_params(slidebar_input_dev, ABS_X, 0, 0xff, 0, 0);
 
 	err = i8042_install_filter(slidebar_i8042_filter);
 	if (err) {
-		pr_err("ideapad_slidebar: Can't install i8042 filter \n");
+		dev_err(&pdev->dev,
+			"Failed to install i8042 filter: %d\n", err);
 		goto err_free_dev;
 	}
 
 	err = input_register_device(slidebar_input_dev);
 	if (err) {
-		pr_err("ideapad_slidebar: Failed to register input device\n");
+		dev_err(&pdev->dev,
+			"Failed to register input device: %d\n", err);
 		goto err_remove_filter;
 	}
+
 	return 0;
 
 err_remove_filter:
@@ -232,15 +250,16 @@ err_remove_filter:
 err_free_dev:
 	input_free_device(slidebar_input_dev);
 err_release_ports:
-	release_region(0xff29, 3);
+	release_region(IDEAPAD_BASE, 3);
 	return err;
 }
 
-static int remove(struct platform_device *dev)
+static int ideapad_remove(struct platform_device *dev)
 {
 	i8042_remove_filter(slidebar_i8042_filter);
 	input_unregister_device(slidebar_input_dev);
-	release_region(0xff29, 3);
+	release_region(IDEAPAD_BASE, 3);
+
 	return 0;
 }
 
@@ -249,13 +268,12 @@ static struct platform_driver slidebar_drv = {
 		.name = "ideapad_slidebar",
 		.owner = THIS_MODULE,
 	},
-	.probe = probe,
-	.remove = remove
+	.remove = ideapad_remove,
 };
 
 static int __init ideapad_dmi_check(const struct dmi_system_id *id)
 {
-	pr_info("ideapad_slidebar: Laptop model '%s'\n", id->ident);
+	pr_info("Laptop model '%s'\n", id->ident);
 	return 1;
 }
 
@@ -287,34 +305,36 @@ static int __init slidebar_init(void)
 	int err;
 
 	if (!force && !dmi_check_system(ideapad_dmi)) {
-		pr_err("ideapad_slidebar: DMI didn't match\n");
+		pr_err("DMI does not match\n");
 		return -ENODEV;
 	}
 
-	err = platform_driver_register(&slidebar_drv);
-	if (err) {
-		pr_err("ideapad_slidebar: Failed to register platform driver\n");
-		return err;
-	}
-
 	slidebar_platform_dev = platform_device_alloc("ideapad_slidebar", -1);
-	slidebar_platform_dev->dev.groups = ideapad_attr_groups;
 	if (!slidebar_platform_dev) {
-		pr_err("ideapad_slidebar: Not enough memory\n");
-		goto err_unregister_drv;
+		pr_err("Not enough memory\n");
+		return -ENOMEM;
 	}
 
+	slidebar_platform_dev->dev.groups = ideapad_attr_groups;
+
 	err = platform_device_add(slidebar_platform_dev);
 	if (err) {
-		pr_err("ideapad_slidebar: Failed to register plarform device\n");
+		pr_err("Failed to register platform device\n");
 		goto err_free_dev;
 	}
+
+	err = platform_driver_probe(&slidebar_drv, ideapad_probe);
+	if (err) {
+		pr_err("Failed to register platform driver\n");
+		goto err_delete_dev;
+	}
+
 	return 0;
 
+err_delete_dev:
+	platform_device_del(slidebar_platform_dev);
 err_free_dev:
 	platform_device_put(slidebar_platform_dev);
-err_unregister_drv:
-	platform_driver_unregister(&slidebar_drv);
 	return err;
 }
 
