Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756240AbaC0SDr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 14:03:47 -0400
Received: from mga09.intel.com ([134.134.136.24]:53990 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756701AbaC0SDQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 14:03:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,744,1389772800"; 
   d="scan'208";a="509131304"
Message-ID: <533467C3.4030503@linux.intel.com>
Date: Fri, 28 Mar 2014 02:02:43 +0800
From: "Zhu, Lejun" <lejun.zhu@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        lejun.zhu@linux.intel.com
Subject: [PATCH v2] input: misc: Add driver for Intel Bay Trail GPIO buttons
References: <53345085.6020300@linux.intel.com>
In-Reply-To: <53345085.6020300@linux.intel.com>
X-Forwarded-Message-Id: <53345085.6020300@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for the GPIO buttons on some Intel Bay Trail
tablets originally running Windows 8. The ACPI description of these
buttons follows "Windows ACPI Design Guide for SoC Platforms".
v2:
- Change the driver name to "SoC button array".
- Use platform_device_alloc() instead of static devices. Unbind then
rebind works fine now.

Signed-off-by: Lejun Zhu <lejun.zhu@linux.intel.com>
---
 drivers/input/misc/Kconfig            |  10 ++
 drivers/input/misc/Makefile           |   1 +
 drivers/input/misc/soc_button_array.c | 209
++++++++++++++++++++++++++++++++++
 3 files changed, 220 insertions(+)
 create mode 100644 drivers/input/misc/soc_button_array.c

diff --git a/drivers/input/misc/Kconfig b/drivers/input/misc/Kconfig
index 7904ab0..c1298af 100644
--- a/drivers/input/misc/Kconfig
+++ b/drivers/input/misc/Kconfig
@@ -666,4 +666,14 @@ config INPUT_IDEAPAD_SLIDEBAR
 	  To compile this driver as a module, choose M here: the
 	  module will be called ideapad_slidebar.

+config INPUT_SOC_BUTTON_ARRAY
+	tristate "Windows-compatible SoC Button Array"
+	depends on KEYBOARD_GPIO
+	help
+	  Say Y here if you have a SoC-based tablet that originally
+	  runs Windows 8.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called soc_button_array.
+
 endif
diff --git a/drivers/input/misc/Makefile b/drivers/input/misc/Makefile
index cda71fc..850a6cd 100644
--- a/drivers/input/misc/Makefile
+++ b/drivers/input/misc/Makefile
@@ -63,3 +63,4 @@ obj-$(CONFIG_INPUT_WM831X_ON)		+= wm831x-on.o
 obj-$(CONFIG_INPUT_XEN_KBDDEV_FRONTEND)	+= xen-kbdfront.o
 obj-$(CONFIG_INPUT_YEALINK)		+= yealink.o
 obj-$(CONFIG_INPUT_IDEAPAD_SLIDEBAR)	+= ideapad_slidebar.o
+obj-$(CONFIG_INPUT_SOC_BUTTON_ARRAY)	+= soc_button_array.o
diff --git a/drivers/input/misc/soc_button_array.c
b/drivers/input/misc/soc_button_array.c
new file mode 100644
index 0000000..e8f19e0
--- /dev/null
+++ b/drivers/input/misc/soc_button_array.c
@@ -0,0 +1,209 @@
+/*
+ * soc_button_array.c: supports the button array on SoC tablets originally
+ * running Windows 8.
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
+/*
+ * Definition of buttons on the tablet. The ACPI index of each button
+ * is defined in section 2.8.7.2 of "Windows ACPI Design Guide for SoC
+ * Platforms"
+ */
+#define	MAX_NBUTTONS	5
+
+struct soc_button_info {
+	const char *name;
+	int acpi_index;
+	unsigned int event_code;
+	int repeat;
+	int wakeup;
+	int gpio;
+};
+
+static struct soc_button_info soc_button_tbl[] = {
+	{"power", 0, KEY_POWER, 0, 1, -1},
+	{"home", 1, KEY_HOME, 0, 1, -1},
+	{"volume_up", 2, KEY_VOLUMEUP, 1, 0, -1},
+	{"volume_down", 3, KEY_VOLUMEDOWN, 1, 0, -1},
+	{"rotation_lock", 4, KEY_RO, 0, 0, -1},
+};
+
+/*
+ * Some of the buttons like volume up/down are auto repeat, while others
+ * are not. To support both, we register two platform devices, and put
+ * buttons into them based on whether the key should be auto repeat.
+ */
+#define	BUTTON_TYPES	2
+
+static struct gpio_keys_button soc_buttons[BUTTON_TYPES][MAX_NBUTTONS];
+
+static struct gpio_keys_platform_data soc_button_data[BUTTON_TYPES] = {
+	{
+		.buttons	= soc_buttons[0],
+		.nbuttons	= 0,
+		.rep		= 0
+	},
+	{
+		.buttons	= soc_buttons[1],
+		.nbuttons	= 0,
+		.rep		= 1
+	}
+};
+
+static struct platform_device *soc_button_device[BUTTON_TYPES];
+
+/*
+ * Get the Nth GPIO number from the ACPI object.
+ */
+static int soc_button_lookup_gpio(struct device *dev, int acpi_index)
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
+/*
+ * Register platform device for a set of buttons.
+ */
+static int soc_button_register(int r)
+{
+	struct platform_device *pd;
+	int err;
+
+	pd = platform_device_alloc("gpio-keys", PLATFORM_DEVID_AUTO);
+	if (!pd) {
+		err = -ENOMEM;
+		goto err0;
+	}
+
+	err = platform_device_add_data(pd, &soc_button_data[r],
+					sizeof(soc_button_data[r]));
+	if (err)
+		goto err1;
+
+	err = platform_device_add(pd);
+	if (err)
+		goto err1;
+
+	soc_button_device[r] = pd;
+
+	return 0;
+
+err1:
+	platform_device_put(pd);
+err0:
+	return err;
+}
+
+static int soc_button_pnp_probe(struct pnp_dev *pdev,
+	const struct pnp_device_id *id)
+{
+	int i, j, r, ret;
+	int sz_tbl = sizeof(soc_button_tbl) / sizeof(soc_button_tbl[0]);
+	struct gpio_keys_button *gk;
+
+	/* Find GPIO number of all the buttons */
+	for (i = 0; i < sz_tbl; i++) {
+		soc_button_tbl[i].gpio = soc_button_lookup_gpio(&pdev->dev,
+						soc_button_tbl[i].acpi_index);
+	}
+
+	for (r = 0; r < BUTTON_TYPES; r++) {
+		gk = soc_buttons[r];
+		j = 0;
+
+		/* Register buttons in the correct device */
+		for (i = 0; i < sz_tbl; i++) {
+			if (soc_button_tbl[i].repeat == r &&
+			    soc_button_tbl[i].gpio > 0) {
+				gk[j].code = soc_button_tbl[i].event_code;
+				gk[j].gpio = soc_button_tbl[i].gpio;
+				gk[j].active_low = 1;
+				gk[j].desc = soc_button_tbl[i].name;
+				gk[j].type = EV_KEY;
+				gk[j].wakeup = soc_button_tbl[i].wakeup;
+				j++;
+			}
+		}
+
+		soc_button_data[r].nbuttons = j;
+
+		if (j == 0)
+			continue;
+
+		if (soc_button_register(r)) {
+			dev_err(&pdev->dev, "failed to register %d\n", r);
+			return ret;
+		}
+	}
+
+	return 0;
+}
+
+static void soc_button_remove(struct pnp_dev *pdev)
+{
+	int r;
+
+	for (r = 0; r < BUTTON_TYPES; r++) {
+		if (soc_button_device[r]) {
+			platform_device_unregister(soc_button_device[r]);
+			soc_button_device[r] = NULL;
+		}
+	}
+}
+
+static const struct pnp_device_id soc_button_pnp_match[] = {
+	{.id = "INTCFD9", .driver_data = 0},
+	{.id = ""}
+};
+
+MODULE_DEVICE_TABLE(pnp, soc_button_pnp_match);
+
+static struct pnp_driver soc_button_pnp_driver = {
+	.name		= KBUILD_MODNAME,
+	.id_table	= soc_button_pnp_match,
+	.probe          = soc_button_pnp_probe,
+	.remove		= soc_button_remove,
+};
+
+static int __init soc_button_init(void)
+{
+	return pnp_register_driver(&soc_button_pnp_driver);
+}
+
+static void __exit soc_button_exit(void)
+{
+	pnp_unregister_driver(&soc_button_pnp_driver);
+}
+
+module_init(soc_button_init);
+module_exit(soc_button_exit);
+
+MODULE_LICENSE("GPL");
-- 
1.8.3.2







