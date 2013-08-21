Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752084Ab3HUFMB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 01:12:01 -0400
Received: from mail-la0-f54.google.com ([209.85.215.54]:35500 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751773Ab3HUFL7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 01:11:59 -0400
Message-ID: <52144C19.80701@gmail.com>
Date: Wed, 21 Aug 2013 09:11:53 +0400
From: Andrey Moiseev <o2g.org.ru@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130806 Thunderbird/17.0.8
MIME-Version: 1.0
To: linux-input@vger.kernel.org
CC: dmitry.torokhov@gmail.com, arnoques@gmail.com, russianneuromancer@ya.ru,
        ike.pan@canonical.com, linux-kernel@vger.kernel.org
Subject: [PATCH v8 1/1] input: ideapad_slidebar: new input driver
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

v8: added `extended = false;` line

ideapad_slidebar is a new driver which enables slidebars on some
Lenovo IdeaPad laptops (the slidebars work with SlideNav/Desktop
Navigator under Windows)

Fixes this: https://bugzilla.kernel.org/show_bug.cgi?id=16004

Registers 'IdeaPad Slidebar' input device and
/sys/devices/platform/ideapad_slidebar/slidebar_mode
for switching slidebar's modes.

Now works on:
IdeaPad Y550, Y550P.

May work on (testing and adding new models is needed):
Ideapad Y560, Y460, Y450, Y650,
and, probably, some others.

Driver source: https://github.com/o2genum/ideapad-slidebar.git

Patch is generated against current mainline kernel.

Signed-off-by: Andrey Moiseev <o2g.org.ru@gmail.com>
---
 MAINTAINERS                           |   7 +
 drivers/input/misc/Kconfig            |   9 +
 drivers/input/misc/Makefile           |   1 +
 drivers/input/misc/ideapad_slidebar.c | 332 ++++++++++++++++++++++++++++++++++
 4 files changed, 349 insertions(+)
 create mode 100644 drivers/input/misc/ideapad_slidebar.c

diff --git a/MAINTAINERS b/MAINTAINERS
index defc053..2ff3dd8 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4096,6 +4096,13 @@ W:	http://launchpad.net/ideapad-laptop
 S:	Maintained
 F:	drivers/platform/x86/ideapad-laptop.c
 
+IDEAPAD LAPTOP SLIDEBAR DRIVER
+M:	Andrey Moiseev <o2g.org.ru@gmail.com>
+L:	linux-input@vger.kernel.org
+W:	https://github.com/o2genum/ideapad-slidebar
+S:	Maintained
+F:	drivers/input/misc/ideapad_slidebar.c
+
 IDE/ATAPI DRIVERS
 M:	Borislav Petkov <bp@alien8.de>
 L:	linux-ide@vger.kernel.org
diff --git a/drivers/input/misc/Kconfig b/drivers/input/misc/Kconfig
index 0b541cd..45729a9 100644
--- a/drivers/input/misc/Kconfig
+++ b/drivers/input/misc/Kconfig
@@ -647,4 +647,13 @@ config INPUT_SIRFSOC_ONKEY
 
 	  If unsure, say N.
 
+config INPUT_IDEAPAD_SLIDEBAR
+	tristate "IdeaPad Laptop Slidebar"
+	depends on INPUT
+	help
+	  Input driver for slidebars on some Lenovo IdeaPad laptops.
+
+	  If you have an IdeaPad laptop with a slidebar, say Y or M here.
+	  Module name is ideapad_slidebar.
+
 endif
diff --git a/drivers/input/misc/Makefile b/drivers/input/misc/Makefile
index 829de43..0ebfb6d 100644
--- a/drivers/input/misc/Makefile
+++ b/drivers/input/misc/Makefile
@@ -61,3 +61,4 @@ obj-$(CONFIG_INPUT_WISTRON_BTNS)	+= wistron_btns.o
 obj-$(CONFIG_INPUT_WM831X_ON)		+= wm831x-on.o
 obj-$(CONFIG_INPUT_XEN_KBDDEV_FRONTEND)	+= xen-kbdfront.o
 obj-$(CONFIG_INPUT_YEALINK)		+= yealink.o
+obj-$(CONFIG_INPUT_IDEAPAD_SLIDEBAR)	+= ideapad_slidebar.o
diff --git a/drivers/input/misc/ideapad_slidebar.c b/drivers/input/misc/ideapad_slidebar.c
new file mode 100644
index 0000000..1dc090d
--- /dev/null
+++ b/drivers/input/misc/ideapad_slidebar.c
@@ -0,0 +1,332 @@
+/*
+ * Input driver for slidebars on some Lenovo IdeaPad laptops
+ *
+ * Copyright (C) 2013 Andrey Moiseev <o2g.org.ru@gmail.com>
+ *
+ * Reverse-engineered from Lenovo SlideNav software (SBarHook.dll).
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the Free
+ * Software Foundation; either version 2 of the License, or (at your option)
+ * any later version.
+ *
+ * Trademarks are the property of their respective owners.
+ */
+
+/*
+ * Currently tested and works on:
+ *	Lenovo IdeaPad Y550
+ *	Lenovo IdeaPad Y550P
+ *
+ * Other models can be added easily. To test,
+ * load with 'force' parameter set 'true'.
+ *
+ * LEDs blinking and input mode are managed via sysfs,
+ * (hex, unsigned byte value):
+ * /sys/devices/platform/ideapad_slidebar/slidebar_mode
+ *
+ * The value is in byte range, however, I only figured out
+ * how bits 0b10011001 work. Some other bits, probably,
+ * are meaningfull too.
+ *
+ * Possible states:
+ *
+ * STD_INT, ONMOV_INT, OFF_INT, LAST_POLL, OFF_POLL
+ *
+ * Meaning:
+ *           released      touched
+ * STD       'heartbeat'   lights follow the finger
+ * ONMOV     no lights     lights follow the finger
+ * LAST      at last pos   lights follow the finger
+ * OFF       no lights     no lights
+ *
+ * INT       all input events are generated, interrupts are used
+ * POLL      no input events by default, to get them,
+ *	     send 0b10000000 (read below)
+ *
+ * Commands: write
+ *
+ * All      |  0b01001 -> STD_INT
+ * possible |  0b10001 -> ONMOV_INT
+ * states   |  0b01000 -> OFF_INT
+ *
+ *                      |  0b0 -> LAST_POLL
+ * STD_INT or ONMOV_INT |
+ *                      |  0b1 -> STD_INT
+ *
+ *                      |  0b0 -> OFF_POLL
+ * OFF_INT or OFF_POLL  |
+ *                      |  0b1 -> OFF_INT
+ *
+ * Any state |   0b10000000 ->  if the slidebar has updated data,
+ *				produce one input event (last position),
+ *				switch to respective POLL mode
+ *				(like 0x0), if not in POLL mode yet.
+ *
+ * Get current state: read
+ *
+ * masked by 0x11 read value means:
+ *
+ * 0x00   LAST
+ * 0x01   STD
+ * 0x10   OFF
+ * 0x11   ONMOV
+ */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/dmi.h>
+#include <linux/spinlock.h>
+#include <linux/platform_device.h>
+#include <linux/input.h>
+#include <linux/io.h>
+#include <linux/ioport.h>
+#include <linux/i8042.h>
+
+static bool force;
+module_param(force, bool, 0);
+MODULE_PARM_DESC(force, "Force driver load, ignore DMI data");
+
+static DEFINE_SPINLOCK(io_lock);
+
+static struct input_dev *slidebar_input_dev;
+static struct platform_device *slidebar_platform_dev;
+
+static unsigned char slidebar_pos_get(void)
+{
+	int res;
+	unsigned long flags;
+
+	spin_lock_irqsave(&io_lock, flags);
+	outb(0xf4, 0xff29);
+	outb(0xbf, 0xff2a);
+	res = inb(0xff2b);
+	spin_unlock_irqrestore(&io_lock, flags);
+	return res;
+}
+
+static unsigned char slidebar_mode_get(void)
+{
+	int res;
+	unsigned long flags;
+
+	spin_lock_irqsave(&io_lock, flags);
+	outb(0xf7, 0xff29);
+	outb(0x8b, 0xff2a);
+	res = inb(0xff2b);
+	spin_unlock_irqrestore(&io_lock, flags);
+	return res;
+}
+
+static void slidebar_mode_set(unsigned char mode)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&io_lock, flags);
+	outb(0xf7, 0xff29);
+	outb(0x8b, 0xff2a);
+	outb(mode, 0xff2b);
+	spin_unlock_irqrestore(&io_lock, flags);
+}
+
+static bool slidebar_i8042_filter(unsigned char data, unsigned char str,
+				struct serio *port)
+{
+	static bool extended = false;
+
+	/* Scancodes: e03b on move, e0bb on release */
+	if (unlikely(data == 0xe0)) {
+		extended = true;
+		return false;
+	} else if (unlikely(extended && (data == 0x3b))) {
+		extended = false;
+		input_report_key(slidebar_input_dev, BTN_TOUCH, 1);
+		input_report_abs(slidebar_input_dev, ABS_X, slidebar_pos_get());
+		input_sync(slidebar_input_dev);
+		return false;
+	} else if (unlikely(extended && (data == 0xbb))) {
+		extended = false;
+		input_report_key(slidebar_input_dev, BTN_TOUCH, 0);
+		input_sync(slidebar_input_dev);
+		return false;
+	}
+	return false;
+}
+
+static ssize_t show_slidebar_mode(struct device *dev,
+				struct device_attribute *attr,
+				char *buf)
+{
+	return sprintf(buf, "%x\n", slidebar_mode_get());
+}
+
+static ssize_t store_slidebar_mode(struct device *dev,
+				struct device_attribute *attr,
+				const char *buf, size_t count)
+{
+	int mode;
+
+	if (!count)
+		return 0;
+	if (sscanf(buf, "%x", &mode) != 1)
+		return -EINVAL;
+	slidebar_mode_set(mode);
+	return count;
+}
+
+static DEVICE_ATTR(slidebar_mode, S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH,
+				show_slidebar_mode, store_slidebar_mode);
+
+static struct attribute *ideapad_attrs[] = {
+	&dev_attr_slidebar_mode.attr,
+	NULL
+};
+
+static struct attribute_group ideapad_attr_group = {
+	.attrs = ideapad_attrs
+};
+
+static const struct attribute_group *ideapad_attr_groups[] = {
+	&ideapad_attr_group,
+	NULL
+};
+
+static int probe(struct platform_device* dev)
+{
+	int err;
+
+	if (!request_region(0xff29, 3, "ideapad_slidebar")) {
+		pr_err("ideapad_slidebar: IO ports are busy\n");
+		return -EBUSY;
+	}
+
+	slidebar_input_dev = input_allocate_device();
+	if (!slidebar_input_dev) {
+		pr_err("ideapad_slidebar: Not enough memory\n");
+		err = -ENOMEM;
+		goto err_release_ports;
+	}
+
+	slidebar_input_dev->name = "IdeaPad Slidebar";
+	slidebar_input_dev->id.bustype = BUS_HOST;
+	slidebar_input_dev->dev.parent = &slidebar_platform_dev->dev;
+	input_set_capability(slidebar_input_dev, EV_KEY, BTN_TOUCH);
+	input_set_capability(slidebar_input_dev, EV_ABS, ABS_X);
+	input_set_abs_params(slidebar_input_dev, ABS_X, 0, 0xff, 0, 0);
+
+	err = i8042_install_filter(slidebar_i8042_filter);
+	if (err) {
+		pr_err("ideapad_slidebar: Can't install i8042 filter \n");
+		goto err_free_dev;
+	} 
+
+	err = input_register_device(slidebar_input_dev);
+	if (err) {
+		pr_err("ideapad_slidebar: Failed to register input device\n");
+		goto err_remove_filter;
+	}
+	return 0;
+
+err_remove_filter:
+	i8042_remove_filter(slidebar_i8042_filter);
+err_free_dev:
+	input_free_device(slidebar_input_dev);
+err_release_ports:
+	release_region(0xff29, 3);
+	return err;
+}
+
+static int remove(struct platform_device *dev)
+{
+	i8042_remove_filter(slidebar_i8042_filter);
+	input_unregister_device(slidebar_input_dev);
+	release_region(0xff29, 3);
+	return 0;
+}
+
+static struct platform_driver slidebar_drv = {
+	.driver = {
+		.name = "ideapad_slidebar",
+		.owner = THIS_MODULE,
+	},
+	.probe = probe,
+	.remove = remove
+};
+
+static int __init ideapad_dmi_check(const struct dmi_system_id *id)
+{
+	pr_info("ideapad_slidebar: Laptop model '%s'\n", id->ident);
+	return 1;
+}
+
+static const struct dmi_system_id ideapad_dmi[] __initconst = {
+	{
+		.ident = "Lenovo IdeaPad Y550",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "20017"),
+			DMI_MATCH(DMI_PRODUCT_VERSION, "Lenovo IdeaPad Y550")
+		},
+		.callback = ideapad_dmi_check
+	},
+	{
+		.ident = "Lenovo IdeaPad Y550P",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "20035"),
+			DMI_MATCH(DMI_PRODUCT_VERSION, "Lenovo IdeaPad Y550P")
+		},
+		.callback = ideapad_dmi_check
+	},
+	{ NULL, }
+};
+MODULE_DEVICE_TABLE(dmi, ideapad_dmi);
+
+static int __init slidebar_init(void)
+{
+	int err;
+
+	if (!force && !dmi_check_system(ideapad_dmi)) {
+		pr_err("ideapad_slidebar: DMI didn't match\n");
+		return -ENODEV;
+	}
+
+	err = platform_driver_register(&slidebar_drv);
+	if (err) {
+		pr_err("ideapad_slidebar: Failed to register platform driver\n");
+		return err;
+	}
+
+	slidebar_platform_dev = platform_device_alloc("ideapad_slidebar", -1);
+	slidebar_platform_dev->dev.groups = ideapad_attr_groups;
+	if (!slidebar_platform_dev) {
+		pr_err("ideapad_slidebar: Not enough memory\n");
+		goto err_unregister_drv;
+	}
+
+	err = platform_device_add(slidebar_platform_dev);
+	if (err) {
+		pr_err("ideapad_slidebar: Failed to register plarform device\n");
+		goto err_free_dev;
+	}
+	return 0;
+
+err_free_dev:
+	platform_device_put(slidebar_platform_dev);
+err_unregister_drv:
+	platform_driver_unregister(&slidebar_drv);
+	return err;
+}
+
+static void __exit slidebar_exit(void)
+{
+	platform_device_unregister(slidebar_platform_dev);
+	platform_driver_unregister(&slidebar_drv);
+}
+
+module_init(slidebar_init);
+module_exit(slidebar_exit);
+
+MODULE_AUTHOR("Andrey Moiseev <o2g.org.ru@gmail.com>");
+MODULE_DESCRIPTION("Slidebar input support for some Lenovo IdeaPad laptops");
+MODULE_LICENSE("GPL");
-- 
1.8.3.4

