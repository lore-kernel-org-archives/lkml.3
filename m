Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752021AbaCZFBs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 01:01:48 -0400
Received: from mga02.intel.com ([134.134.136.20]:17392 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750953AbaCZFBq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 01:01:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,734,1389772800"; 
   d="scan'208";a="499659205"
Message-ID: <53325F30.4030006@linux.intel.com>
Date: Wed, 26 Mar 2014 13:01:36 +0800
From: "Zhu, Lejun" <lejun.zhu@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        lejun.zhu@linux.intel.com
Subject: [PATCH] input: misc: Add driver for Intel Bay Trail GPIO buttons
References: <533259F7.3050908@linux.intel.com>
In-Reply-To: <533259F7.3050908@linux.intel.com>
X-Forwarded-Message-Id: <533259F7.3050908@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for the GPIO buttons on some Intel Bay Trail
tablets originally running Windows 8. The ACPI description of these
buttons follows "Windows ACPI Design Guide for SoC Platforms".

Signed-off-by: Lejun Zhu <lejun.zhu@linux.intel.com>
---
 drivers/input/misc/Kconfig           |  10 ++
 drivers/input/misc/Makefile          |   1 +
 drivers/input/misc/baytrail_button.c | 198
+++++++++++++++++++++++++++++++++++
 3 files changed, 209 insertions(+)
 create mode 100644 drivers/input/misc/baytrail_button.c

diff --git a/drivers/input/misc/Kconfig b/drivers/input/misc/Kconfig
index 7904ab0..bb6fe2e 100644
--- a/drivers/input/misc/Kconfig
+++ b/drivers/input/misc/Kconfig
@@ -666,4 +666,14 @@ config INPUT_IDEAPAD_SLIDEBAR
 	  To compile this driver as a module, choose M here: the
 	  module will be called ideapad_slidebar.

+config INPUT_BAYTRAIL_BUTTON
+	tristate "Intel Baytrail Buttons"
+	depends on KEYBOARD_GPIO
+	help
+	  Say Y here if you have a Baytrail tablet that is compatible
+	  with Windows ACPI Design Guide.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called baytrail_button.
+
 endif
diff --git a/drivers/input/misc/Makefile b/drivers/input/misc/Makefile
index cda71fc..c3d6a68 100644
--- a/drivers/input/misc/Makefile
+++ b/drivers/input/misc/Makefile
@@ -63,3 +63,4 @@ obj-$(CONFIG_INPUT_WM831X_ON)		+= wm831x-on.o
 obj-$(CONFIG_INPUT_XEN_KBDDEV_FRONTEND)	+= xen-kbdfront.o
 obj-$(CONFIG_INPUT_YEALINK)		+= yealink.o
 obj-$(CONFIG_INPUT_IDEAPAD_SLIDEBAR)	+= ideapad_slidebar.o
+obj-$(CONFIG_INPUT_BAYTRAIL_BUTTON)	+= baytrail_button.o
diff --git a/drivers/input/misc/baytrail_button.c
b/drivers/input/misc/baytrail_button.c
new file mode 100644
index 0000000..e4829e1
--- /dev/null
+++ b/drivers/input/misc/baytrail_button.c
@@ -0,0 +1,198 @@
+/*
+ * baytrail_button.c: supports the GPIO buttons on some Baytrail
+ * tablets.
+ *
+ * (C) Copyright 2014 Intel Corporation
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; version 2
+ * of the License.
+ */
+
+#include <linux/module.h>
+#include <linux/input.h>
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/acpi.h>
+#include <linux/gpio/consumer.h>
+#include <linux/gpio_keys.h>
+#include <linux/input.h>
+#include <linux/platform_device.h>
+#include <linux/pnp.h>
+
+static void byt_button_device_release(struct device *);
+
+/*
+ * Definition of buttons on the tablet. The ACPI index of each button
+ * is defined in "Windows ACPI Design Guide for SoC Platforms"
+ */
+#define	MAX_NBUTTONS	5
+
+struct byt_button_info {
+	const char *name;
+	int acpi_index;
+	unsigned int event_code;
+	int repeat;
+	int wakeup;
+	int gpio;
+};
+
+static struct byt_button_info byt_button_tbl[] = {
+	{"power", 0, KEY_POWER, 0, 1, -1},
+	{"home", 1, KEY_HOME, 0, 1, -1},
+	{"volume_up", 2, KEY_VOLUMEUP, 1, 0, -1},
+	{"volume_down", 3, KEY_VOLUMEDOWN, 1, 0, -1},
+	{"rotation_lock", 4, KEY_RO, 0, 0, -1},
+};
+
+/*
+ * Some of the buttons like volume up/down are auto repeat, while others
+ * are not. To support both, we register two gpio-keys device, and put
+ * buttons into them based on whether the key should be auto repeat.
+ */
+#define	BUTTON_TYPES	2
+
+static struct gpio_keys_button byt_buttons[BUTTON_TYPES][MAX_NBUTTONS];
+
+static struct gpio_keys_platform_data byt_button_data[BUTTON_TYPES] = {
+	{
+		.buttons	= byt_buttons[0],
+		.nbuttons	= 0,
+		.rep		= 0
+	},
+	{
+		.buttons	= byt_buttons[1],
+		.nbuttons	= 0,
+		.rep		= 1
+	}
+};
+
+static struct platform_device byt_button_device[BUTTON_TYPES] = {
+	{
+		.name	= "gpio-keys",
+		.id	= PLATFORM_DEVID_AUTO,
+		.dev	= {
+			.release	= byt_button_device_release,
+			.platform_data	= &byt_button_data[0],
+		}
+	},
+	{
+		.name	= "gpio-keys",
+		.id	= PLATFORM_DEVID_AUTO,
+		.dev	= {
+			.release	= byt_button_device_release,
+			.platform_data	= &byt_button_data[1],
+		}
+	}
+};
+
+/*
+ * Get the Nth GPIO number from the ACPI object.
+ */
+static int byt_button_lookup_gpio(struct device *dev, int acpi_index)
+{
+	struct gpio_desc *desc;
+	int ret;
+
+	desc = gpiod_get_index(dev, KBUILD_MODNAME, acpi_index);
+
+	if (IS_ERR(desc))
+		return -1;
+
+	ret = desc_to_gpio(desc);
+
+	gpiod_put(desc);
+
+	return ret;
+}
+
+static int byt_button_pnp_probe(struct pnp_dev *pdev,
+	const struct pnp_device_id *id)
+{
+	int i, j, r, ret;
+	int sz_tbl = sizeof(byt_button_tbl) / sizeof(byt_button_tbl[0]);
+	struct gpio_keys_button *gk;
+
+	/* Find GPIO number of all the buttons */
+	for (i = 0; i < sz_tbl; i++) {
+		byt_button_tbl[i].gpio = byt_button_lookup_gpio(&pdev->dev,
+						byt_button_tbl[i].acpi_index);
+	}
+
+	for (r = 0; r < BUTTON_TYPES; r++) {
+		gk = byt_buttons[r];
+		j = 0;
+
+		/* Register buttons in the correct device */
+		for (i = 0; i < sz_tbl; i++) {
+			if (byt_button_tbl[i].repeat == r &&
+			    byt_button_tbl[i].gpio > 0) {
+				gk[j].code = byt_button_tbl[i].event_code;
+				gk[j].gpio = byt_button_tbl[i].gpio;
+				gk[j].active_low = 1;
+				gk[j].desc = byt_button_tbl[i].name;
+				gk[j].type = EV_KEY;
+				gk[j].wakeup = byt_button_tbl[i].wakeup;
+				j++;
+			}
+		}
+
+		byt_button_data[r].nbuttons = j;
+
+		if (j == 0)
+			continue;
+
+		ret = platform_device_register(&byt_button_device[r]);
+		if (ret) {
+			dev_err(&pdev->dev, "failed to register %d\n", r);
+			return ret;
+		}
+	}
+
+	return 0;
+}
+
+static void byt_button_device_release(struct device *dev)
+{
+	/* Nothing to do */
+}
+
+static void byt_button_remove(struct pnp_dev *pdev)
+{
+	int r;
+
+	for (r = 0; r < BUTTON_TYPES; r++) {
+		if (byt_button_data[r].nbuttons)
+			platform_device_unregister(&byt_button_device[r]);
+	}
+}
+
+static const struct pnp_device_id byt_button_pnp_match[] = {
+	{.id = "INTCFD9", .driver_data = 0},
+	{.id = ""}
+};
+
+MODULE_DEVICE_TABLE(pnp, byt_button_pnp_match);
+
+static struct pnp_driver byt_button_pnp_driver = {
+	.name		= KBUILD_MODNAME,
+	.id_table	= byt_button_pnp_match,
+	.probe          = byt_button_pnp_probe,
+	.remove		= byt_button_remove,
+};
+
+static int __init byt_button_init(void)
+{
+	return pnp_register_driver(&byt_button_pnp_driver);
+}
+
+static void __exit byt_button_exit(void)
+{
+	pnp_unregister_driver(&byt_button_pnp_driver);
+}
+
+module_init(byt_button_init);
+module_exit(byt_button_exit);
+
+MODULE_LICENSE("GPL");
-- 
1.8.3.2





