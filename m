Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752224Ab3FZByQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 21:54:16 -0400
Received: from mga02.intel.com ([134.134.136.20]:22403 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751445Ab3FZBxm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 21:53:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,940,1363158000"; 
   d="scan'208";a="335543127"
From: Darren Hart <dvhart@linux.intel.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, peter.p.waskiewicz.jr@intel.com,
        andriy.shevchenko@linux.intel.com, danders@circuitco.com,
        vishal.l.verma@intel.com, dvhart@linux.intel.com
Cc: Matthew Garrett <matthew.garrett@nebula.com>,
        Grant Likely <grant.likely@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        platform-driver-x86@vger.kernel.org
Subject: [PATCH 5/8] minnowboard-gpio: Export MinnowBoard expansion GPIO
Date: Tue, 25 Jun 2013 18:53:25 -0700
Message-Id: <c7bed09378e5edf88872e277b238ecc3f52634aa.1372211451.git.dvhart@linux.intel.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <cover.1372211451.git.dvhart@linux.intel.com>
References: <cover.1372211451.git.dvhart@linux.intel.com>
In-Reply-To: <cover.1372211451.git.dvhart@linux.intel.com>
References: <cover.1372211451.git.dvhart@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Request and export the user-configurable GPIO lines to sysfs. This provides a
label readable in /debugfs/gpio and a simple interface for experimenting with
GPIO on the MinnowBoard.

This is separate from the minnowboard driver to provide users with the
flexibility to write kernel drivers for their own devices using these GPIO
lines.

Signed-off-by: Darren Hart <dvhart@linux.intel.com>
Cc: Matthew Garrett <matthew.garrett@nebula.com>
Cc: Grant Likely <grant.likely@linaro.org>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Peter Waskiewicz <peter.p.waskiewicz.jr@intel.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: platform-driver-x86@vger.kernel.org
---
 drivers/platform/x86/Kconfig            |  18 +++++
 drivers/platform/x86/Makefile           |   1 +
 drivers/platform/x86/minnowboard-gpio.c | 115 ++++++++++++++++++++++++++++++++
 3 files changed, 134 insertions(+)
 create mode 100644 drivers/platform/x86/minnowboard-gpio.c

diff --git a/drivers/platform/x86/Kconfig b/drivers/platform/x86/Kconfig
index 154dbf6..c8755cb 100644
--- a/drivers/platform/x86/Kconfig
+++ b/drivers/platform/x86/Kconfig
@@ -35,6 +35,24 @@ config MINNOWBOARD
 
 	  If you have a MinnowBoard, say Y or M here.
 
+if MINNOWBOARD
+config MINNOWBOARD_GPIO
+	tristate "MinnowBoard Expansion GPIO"
+	depends on MINNOWBOARD
+	default n
+	---help---
+	  Export the EG20T (gpio-pch) lines on the expansion connector to sysfs
+	  for easy manipulation from userspace. These will be named
+	  "minnow_gpio_pch[0-7]". If LVDS is not in use, export the E6XX
+	  (gpio-sch) lines on the expansion connector to sysfs, these will be
+	  named "minnow_gpio_aux[0-4]".
+
+	  If you have a MinnowBoard, and want to experiment with the GPIO,
+	  say Y or M here.
+
+endif # MINNOWBOARD
+
+
 config ACER_WMI
 	tristate "Acer WMI Laptop Extras"
 	depends on ACPI
diff --git a/drivers/platform/x86/Makefile b/drivers/platform/x86/Makefile
index 45ede1c..4dac9f0 100644
--- a/drivers/platform/x86/Makefile
+++ b/drivers/platform/x86/Makefile
@@ -3,6 +3,7 @@
 # x86 Platform-Specific Drivers
 #
 obj-$(CONFIG_MINNOWBOARD)	+= minnowboard.o
+obj-$(CONFIG_MINNOWBOARD_GPIO)	+= minnowboard-gpio.o
 obj-$(CONFIG_ASUS_LAPTOP)	+= asus-laptop.o
 obj-$(CONFIG_ASUS_WMI)		+= asus-wmi.o
 obj-$(CONFIG_ASUS_NB_WMI)	+= asus-nb-wmi.o
diff --git a/drivers/platform/x86/minnowboard-gpio.c b/drivers/platform/x86/minnowboard-gpio.c
new file mode 100644
index 0000000..c33c438
--- /dev/null
+++ b/drivers/platform/x86/minnowboard-gpio.c
@@ -0,0 +1,115 @@
+/*
+ * MinnowBoard Linux platform driver
+ * Copyright (c) 2013, Intel Corporation.
+ * All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
+ *
+ * Author: Darren Hart <dvhart@linux.intel.com>
+ */
+
+#include <linux/platform_device.h>
+#include <linux/module.h>
+#include <linux/gpio.h>
+#include <linux/gpio_keys.h>
+#include <linux/input.h>
+#include <linux/minnowboard.h>
+#include "minnowboard-gpio.h"
+
+static struct gpio expansion_gpios[] = {
+	{ GPIO_PCH0, GPIOF_DIR_IN | GPIOF_EXPORT | GPIOF_EXPORT_CHANGEABLE,
+	  "minnow_gpio_pch0" },
+	{ GPIO_PCH1, GPIOF_DIR_IN | GPIOF_EXPORT | GPIOF_EXPORT_CHANGEABLE,
+	  "minnow_gpio_pch1" },
+	{ GPIO_PCH2, GPIOF_DIR_IN | GPIOF_EXPORT | GPIOF_EXPORT_CHANGEABLE,
+	  "minnow_gpio_pch2" },
+	{ GPIO_PCH3, GPIOF_DIR_IN | GPIOF_EXPORT | GPIOF_EXPORT_CHANGEABLE,
+	  "minnow_gpio_pch3" },
+	{ GPIO_PCH4, GPIOF_DIR_IN | GPIOF_EXPORT | GPIOF_EXPORT_CHANGEABLE,
+	  "minnow_gpio_pch4" },
+	{ GPIO_PCH5, GPIOF_DIR_IN | GPIOF_EXPORT | GPIOF_EXPORT_CHANGEABLE,
+	  "minnow_gpio_pch5" },
+	{ GPIO_PCH6, GPIOF_DIR_IN | GPIOF_EXPORT | GPIOF_EXPORT_CHANGEABLE,
+	  "minnow_gpio_pch6" },
+	{ GPIO_PCH7, GPIOF_DIR_IN | GPIOF_EXPORT | GPIOF_EXPORT_CHANGEABLE,
+	  "minnow_gpio_pch7" },
+};
+
+static struct gpio expansion_aux_gpios[] = {
+	{ GPIO_AUX0, GPIOF_DIR_IN | GPIOF_EXPORT | GPIOF_EXPORT_CHANGEABLE,
+	  "minnow_gpio_aux0" },
+	{ GPIO_AUX1, GPIOF_DIR_IN | GPIOF_EXPORT | GPIOF_EXPORT_CHANGEABLE,
+	  "minnow_gpio_aux1" },
+	{ GPIO_AUX2, GPIOF_DIR_IN | GPIOF_EXPORT | GPIOF_EXPORT_CHANGEABLE,
+	  "minnow_gpio_aux2" },
+	{ GPIO_AUX3, GPIOF_DIR_IN | GPIOF_EXPORT | GPIOF_EXPORT_CHANGEABLE,
+	  "minnow_gpio_aux3" },
+	{ GPIO_AUX4, GPIOF_DIR_IN | GPIOF_EXPORT | GPIOF_EXPORT_CHANGEABLE,
+	  "minnow_gpio_aux4" },
+};
+
+static int __init minnow_gpio_module_init(void)
+{
+	int err;
+
+	err = -ENODEV;
+	if (!minnow_detect())
+		goto out;
+
+#ifdef MODULE
+#ifdef CONFIG_MINNOWBOARD_MODULE
+	if (request_module("minnowboard"))
+		goto out;
+#endif
+#endif
+
+	/* Auxillary Expansion GPIOs */
+	if (!minnow_lvds_detect()) {
+		pr_debug("LVDS_DETECT not asserted, configuring Aux GPIO lines\n");
+		err = gpio_request_array(expansion_aux_gpios,
+					 ARRAY_SIZE(expansion_aux_gpios));
+		if (err) {
+			pr_err("Failed to request expansion aux GPIO lines\n");
+			goto out;
+		}
+	} else {
+		pr_debug("LVDS_DETECT asserted, ignoring aux GPIO lines\n");
+	}
+
+	/* Expansion GPIOs */
+	err = gpio_request_array(expansion_gpios, ARRAY_SIZE(expansion_gpios));
+	if (err) {
+		pr_err("Failed to request expansion GPIO lines\n");
+		if (minnow_lvds_detect())
+			gpio_free_array(expansion_aux_gpios,
+					ARRAY_SIZE(expansion_aux_gpios));
+		goto out;
+	}
+
+ out:
+	return err;
+}
+
+static void __exit minnow_gpio_module_exit(void)
+{
+	if (minnow_lvds_detect())
+		gpio_free_array(expansion_aux_gpios,
+				ARRAY_SIZE(expansion_aux_gpios));
+	gpio_free_array(expansion_gpios, ARRAY_SIZE(expansion_gpios));
+}
+
+module_init(minnow_gpio_module_init);
+module_exit(minnow_gpio_module_exit);
+
+MODULE_LICENSE("GPL");
-- 
1.8.1.2

