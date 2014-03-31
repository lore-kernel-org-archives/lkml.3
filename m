Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753163AbaCaCeJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2014 22:34:09 -0400
Received: from mga02.intel.com ([134.134.136.20]:37291 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752560AbaCaCeG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2014 22:34:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,762,1389772800"; 
   d="scan'208";a="511235129"
Message-ID: <5338D410.9060406@linux.intel.com>
Date: Mon, 31 Mar 2014 10:33:52 +0800
From: "Zhu, Lejun" <lejun.zhu@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        yu-sheng Chen <verylong2@gmail.com>
Subject: Fwd: Re: [PATCH v2] input: misc: Add driver for Intel Bay Trail GPIO
 buttons
References: <5338D095.6020200@linux.intel.com>
In-Reply-To: <5338D095.6020200@linux.intel.com>
X-Forwarded-Message-Id: <5338D095.6020200@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmitry,

On 3/29/2014 4:47 AM, Dmitry Torokhov wrote:
> Hi Lejun,
> 
> On Fri, Mar 28, 2014 at 02:02:43AM +0800, Zhu, Lejun wrote:
>> +
>> +static struct soc_button_info soc_button_tbl[] = {
>> +	{"power", 0, KEY_POWER, 0, 1, -1},
>> +	{"home", 1, KEY_HOME, 0, 1, -1},
>> +	{"volume_up", 2, KEY_VOLUMEUP, 1, 0, -1},
>> +	{"volume_down", 3, KEY_VOLUMEDOWN, 1, 0, -1},
>> +	{"rotation_lock", 4, KEY_RO, 0, 0, -1},
> 
> KEY_RO is not for rotating but rather for switching one of Japanese
> layouts. I think we shoudl allow using switchws and use SW_ROTATE_LOCK
> for that.
> 
> Also I do not quite like so many static structures, what do you think
> about the version below?
> 
> Thanks!
> 

Your version looks fine. I have tested it and fixed a couple glitches
(+1 vs ++ at line 87, and check gpio < 0 at line 94).

Also, yu-sheng Chen suggests that we'd better look for PNP0C40, which is
the compatible ID defined in the spec and will probably match a broader
range of devices.

I attached the updated version below. What do you think?

Thanks.
Lejun
--

Input: misc - Add driver for Intel Bay Trail GPIO buttons

From: Lejun Zhu <lejun.zhu@linux.intel.com>

This patch adds support for the GPIO buttons on some Intel Bay Trail
tablets originally running Windows 8. The ACPI description of these
buttons follows "Windows ACPI Design Guide for SoC Platforms".

Signed-off-by: Lejun Zhu <lejun.zhu@linux.intel.com>
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
---
 drivers/input/misc/Kconfig            |  10 ++
 drivers/input/misc/Makefile           |   1 +
 drivers/input/misc/soc_button_array.c | 218
++++++++++++++++++++++++++++++++++
 3 files changed, 229 insertions(+)
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
index cda71fc..4955ad3 100644
--- a/drivers/input/misc/Makefile
+++ b/drivers/input/misc/Makefile
@@ -53,6 +53,7 @@ obj-$(CONFIG_INPUT_RETU_PWRBUTTON)	+= retu-pwrbutton.o
 obj-$(CONFIG_INPUT_GPIO_ROTARY_ENCODER)	+= rotary_encoder.o
 obj-$(CONFIG_INPUT_SGI_BTNS)		+= sgi_btns.o
 obj-$(CONFIG_INPUT_SIRFSOC_ONKEY)	+= sirfsoc-onkey.o
+obj-$(CONFIG_INPUT_SOC_BUTTON_ARRAY)	+= soc_button_array.o
 obj-$(CONFIG_INPUT_SPARCSPKR)		+= sparcspkr.o
 obj-$(CONFIG_INPUT_TWL4030_PWRBUTTON)	+= twl4030-pwrbutton.o
 obj-$(CONFIG_INPUT_TWL4030_VIBRA)	+= twl4030-vibra.o
diff --git a/drivers/input/misc/soc_button_array.c
b/drivers/input/misc/soc_button_array.c
new file mode 100644
index 0000000..08ead2a
--- /dev/null
+++ b/drivers/input/misc/soc_button_array.c
@@ -0,0 +1,218 @@
+/*
+ * Supports for the button array on SoC tablets originally running
+ * Windows 8.
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
+#define MAX_NBUTTONS	5
+
+struct soc_button_info {
+	const char *name;
+	int acpi_index;
+	unsigned int event_type;
+	unsigned int event_code;
+	bool autorepeat;
+	bool wakeup;
+};
+
+/*
+ * Some of the buttons like volume up/down are auto repeat, while others
+ * are not. To support both, we register two platform devices, and put
+ * buttons into them based on whether the key should be auto repeat.
+ */
+#define BUTTON_TYPES	2
+
+struct soc_button_data {
+	struct platform_device *children[BUTTON_TYPES];
+};
+
+/*
+ * Get the Nth GPIO number from the ACPI object.
+ */
+static int soc_button_lookup_gpio(struct device *dev, int acpi_index)
+{
+	struct gpio_desc *desc;
+	int gpio;
+
+	desc = gpiod_get_index(dev, KBUILD_MODNAME, acpi_index);
+	if (IS_ERR(desc))
+		return PTR_ERR(desc);
+
+	gpio = desc_to_gpio(desc);
+
+	gpiod_put(desc);
+
+	return gpio;
+}
+
+static struct platform_device *
+soc_button_device_create(struct pnp_dev *pdev,
+			 const struct soc_button_info *button_info,
+			 bool autorepeat)
+{
+	const struct soc_button_info *info;
+	struct platform_device *pd;
+	struct gpio_keys_button *gpio_keys;
+	struct gpio_keys_platform_data *gpio_keys_pdata;
+	int n_buttons = 0;
+	int gpio;
+	int error;
+
+	gpio_keys_pdata = devm_kzalloc(&pdev->dev,
+				       sizeof(*gpio_keys_pdata) +
+					sizeof(*gpio_keys) * MAX_NBUTTONS,
+				       GFP_KERNEL);
+	gpio_keys = (void *)(gpio_keys_pdata + 1);
+
+	for (info = button_info; info->name; info++) {
+		if (info->autorepeat != autorepeat)
+			continue;
+
+		gpio = soc_button_lookup_gpio(&pdev->dev, info->acpi_index);
+		if (gpio < 0)
+			continue;
+
+		gpio_keys[n_buttons].type = info->event_type;
+		gpio_keys[n_buttons].code = info->event_code;
+		gpio_keys[n_buttons].gpio = gpio;
+		gpio_keys[n_buttons].active_low = 1;
+		gpio_keys[n_buttons].desc = info->name;
+		gpio_keys[n_buttons].wakeup = info->wakeup;
+		n_buttons++;
+	}
+
+	if (n_buttons == 0) {
+		error = -ENODEV;
+		goto err_free_mem;
+	}
+
+	gpio_keys_pdata->buttons = gpio_keys;
+	gpio_keys_pdata->nbuttons = n_buttons;
+	gpio_keys_pdata->rep = autorepeat;
+
+	pd = platform_device_alloc("gpio-keys", PLATFORM_DEVID_AUTO);
+	if (!pd) {
+		error = -ENOMEM;
+		goto err_free_mem;
+	}
+
+	error = platform_device_add_data(pd, gpio_keys_pdata,
+					 sizeof(*gpio_keys_pdata));
+	if (error)
+		goto err_free_pdev;
+
+	error = platform_device_add(pd);
+	if (error)
+		goto err_free_pdev;
+
+	return pd;
+
+err_free_pdev:
+	platform_device_put(pd);
+err_free_mem:
+	devm_kfree(&pdev->dev, gpio_keys_pdata);
+	return ERR_PTR(error);
+}
+
+static void soc_button_remove(struct pnp_dev *pdev)
+{
+	struct soc_button_data *priv = pnp_get_drvdata(pdev);
+	int i;
+
+	for (i = 0; i < BUTTON_TYPES; i++)
+		if (priv->children[i])
+			platform_device_unregister(priv->children[i]);
+}
+
+static int soc_button_pnp_probe(struct pnp_dev *pdev,
+				const struct pnp_device_id *id)
+{
+	const struct soc_button_info *button_info = (void *)id->driver_data;
+	struct soc_button_data *priv;
+	struct platform_device *pd;
+	int i;
+	int error;
+
+	priv = devm_kzalloc(&pdev->dev, sizeof(*priv), GFP_KERNEL);
+	if (!priv)
+		return -ENOMEM;
+
+	pnp_set_drvdata(pdev, priv);
+
+	for (i = 0; i < BUTTON_TYPES; i++) {
+		pd = soc_button_device_create(pdev, button_info, i == 0);
+		if (IS_ERR(pd)) {
+			error = PTR_ERR(pd);
+			if (error != -ENODEV) {
+				soc_button_remove(pdev);
+				return error;
+			}
+		}
+
+		priv->children[i] = pd;
+	}
+
+	if (!priv->children[0] && !priv->children[1])
+		return -ENODEV;
+
+	return 0;
+}
+
+static struct soc_button_info soc_button_PNP0C40[] = {
+	{ "power", 0, EV_KEY, KEY_POWER, false, true },
+	{ "home", 1, EV_KEY, KEY_HOME, false, true },
+	{ "volume_up", 2, EV_KEY, KEY_VOLUMEUP, true, false },
+	{ "volume_down", 3, EV_KEY, KEY_VOLUMEDOWN, true, false },
+	{ "rotation_lock", 4, EV_SW, SW_ROTATE_LOCK, false, false },
+	{ }
+};
+
+static const struct pnp_device_id soc_button_pnp_match[] = {
+	{ .id = "PNP0C40", .driver_data = (long)soc_button_PNP0C40 },
+	{ .id = "" }
+};
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




