Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752716AbaCGNB2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 08:01:28 -0500
Received: from mail1.bemta5.messagelabs.com ([195.245.231.137]:30431 "EHLO
	mail1.bemta5.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751684AbaCGNB0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 08:01:26 -0500
X-Env-Sender: stwiss.opensource@diasemi.com
X-Msg-Ref: server-2.tower-178.messagelabs.com!1394197283!22969930!1
X-Originating-IP: [82.210.246.133]
X-StarScan-Received: 
X-StarScan-Version: 6.9.16; banners=-,-,-
X-VirusChecked: Checked
Message-ID: <ce5a43ad4c028b1553206ee51a27822a614f3404.1394195865.git.stwiss.opensource@diasemi.com>
In-Reply-To: <cover.1394195865.git.stwiss.opensource@diasemi.com>
References: <cover.1394195865.git.stwiss.opensource@diasemi.com>
From: "Opensource [Steve Twiss]" <stwiss.opensource@diasemi.com>
Date: Fri, 7 Mar 2014 12:37:45 +0000
Subject: [RFC V1 2/2] input: misc: da9063: OnKey driver
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: David Dajun Chen <david.chen@diasemi.com>,
        LKML-INPUT <linux-input@vger.kernel.org>,
        LKML-KERNEL <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Opensource [Steve Twiss] <stwiss.opensource@diasemi.com>

Add the OnKey driver for DA9063.


Signed-off-by: Opensource [Steve Twiss] <stwiss.opensource@diasemi.com>
---
Checks performed with next-20140307/scripts/checkpatch.pl
 da9063-onkey.c            total: 0 errors, 0 warnings, 202 lines checked
 Kconfig                   total: 0 errors, 11 warnings, 679 lines checked
 Makefile                  total: 0 errors, 0 warnings, 66 lines checked

Hello,

This is a RFC for the Dialog DA9063 Onkey driver.

Dependencies:

This driver makes use of the name field "ONKEY" as part of the
function call: platform_get_irq_byname();

This driver is therefore dependent on this change to the name field
in the properties of the the OnKey IORESOURCE_IRQ resource structure
(part of the mfd_cell Onkey resource inside da9063-core.c). This
change will be added as part of the final set when I submit all patches
as a single PATCH set.

This patch applies against kernel version linux-next next-20140307
 
Regards,
Steve Twiss, Dialog Semiconductor Ltd.



 drivers/input/misc/Kconfig        |   10 ++
 drivers/input/misc/Makefile       |    1 +
 drivers/input/misc/da9063-onkey.c |  202 +++++++++++++++++++++++++++++++++++++
 3 files changed, 213 insertions(+)
 create mode 100644 drivers/input/misc/da9063-onkey.c

diff --git a/drivers/input/misc/Kconfig b/drivers/input/misc/Kconfig
index 762e6d2..3deb008 100644
--- a/drivers/input/misc/Kconfig
+++ b/drivers/input/misc/Kconfig
@@ -522,6 +522,16 @@ config INPUT_DA9055_ONKEY
 	  To compile this driver as a module, choose M here: the module
 	  will be called da9055_onkey.
 
+config INPUT_DA9063_ONKEY
+	tristate "Dialog DA9063 OnKey"
+	depends on MFD_DA9063
+	help
+	  Support the ONKEY of Dialog DA9063 Power Management IC as an
+	  input device reporting power button statue.
+
+	  To compile this driver as a module, choose M here: the module
+	  will be called da9063-onkey.
+
 config INPUT_DM355EVM
 	tristate "TI DaVinci DM355 EVM Keypad and IR Remote"
 	depends on MFD_DM355EVM_MSP
diff --git a/drivers/input/misc/Makefile b/drivers/input/misc/Makefile
index cda71fc..f40caa7 100644
--- a/drivers/input/misc/Makefile
+++ b/drivers/input/misc/Makefile
@@ -25,6 +25,7 @@ obj-$(CONFIG_INPUT_CMA3000_I2C)		+= cma3000_d0x_i2c.o
 obj-$(CONFIG_INPUT_COBALT_BTNS)		+= cobalt_btns.o
 obj-$(CONFIG_INPUT_DA9052_ONKEY)	+= da9052_onkey.o
 obj-$(CONFIG_INPUT_DA9055_ONKEY)	+= da9055_onkey.o
+obj-$(CONFIG_INPUT_DA9063_ONKEY)	+= da9063-onkey.o
 obj-$(CONFIG_INPUT_DM355EVM)		+= dm355evm_keys.o
 obj-$(CONFIG_INPUT_GP2A)		+= gp2ap002a00f.o
 obj-$(CONFIG_INPUT_GPIO_BEEPER)		+= gpio-beeper.o
diff --git a/drivers/input/misc/da9063-onkey.c b/drivers/input/misc/da9063-onkey.c
new file mode 100644
index 0000000..654f52b
--- /dev/null
+++ b/drivers/input/misc/da9063-onkey.c
@@ -0,0 +1,202 @@
+/* da9063-onkey.c - Onkey device driver for DA9063
+ * Copyright (C) 2013  Dialog Semiconductor Ltd.
+ *
+ * This library is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU Library General Public
+ * License as published by the Free Software Foundation; either
+ * version 2 of the License, or (at your option) any later version.
+ *
+ * This library is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * Library General Public License for more details.
+ */
+
+#include <linux/module.h>
+#include <linux/errno.h>
+#include <linux/input.h>
+#include <linux/interrupt.h>
+#include <linux/platform_device.h>
+#include <linux/workqueue.h>
+#include <linux/regmap.h>
+
+#include <linux/mfd/da9063/core.h>
+#include <linux/mfd/da9063/pdata.h>
+#include <linux/mfd/da9063/registers.h>
+
+struct da9063_onkey {
+	struct	da9063 *hw;
+	struct delayed_work work;
+	struct	input_dev *input;
+	bool key_power;
+};
+
+static void da9063_poll_on(struct work_struct *work)
+{
+	struct da9063_onkey *onkey = container_of(work, struct da9063_onkey,
+						  work.work);
+	unsigned int val;
+	int poll = 1;
+	int ret;
+
+	/* poll to see when the pin is deasserted */
+	ret = regmap_read(onkey->hw->regmap, DA9063_REG_STATUS_A, &val);
+	if (ret < 0) {
+		dev_err(&onkey->input->dev,
+			"Failed to read ON status: %d\n", ret);
+		goto err_poll;
+	}
+
+	if (!(val & DA9063_NONKEY)) {
+		ret = regmap_update_bits(onkey->hw->regmap,
+					 DA9063_REG_CONTROL_B,
+					 DA9063_NONKEY_LOCK, 0);
+		if (ret < 0) {
+			dev_err(&onkey->input->dev,
+				"Failed to reset the Key Delay %d\n", ret);
+			goto err_poll;
+		}
+
+		input_report_key(onkey->input, KEY_POWER, 0);
+		input_sync(onkey->input);
+
+		/* unmask the onkey interrupt again */
+		ret = regmap_update_bits(onkey->hw->regmap,
+					 DA9063_REG_IRQ_MASK_A,
+					 DA9063_NONKEY, 0);
+		if (ret < 0) {
+			dev_err(&onkey->input->dev,
+				"Failed to unmask the onkey IRQ: %d\n", ret);
+			goto err_poll;
+		}
+
+		poll = 0;
+	}
+
+err_poll:
+	if (poll)
+		schedule_delayed_work(&onkey->work, 50);
+}
+
+static irqreturn_t da9063_onkey_irq_handler(int irq, void *data)
+{
+	struct da9063_onkey *onkey = data;
+	unsigned int val;
+	int ret;
+
+	ret = regmap_read(onkey->hw->regmap, DA9063_REG_STATUS_A, &val);
+	if (onkey->key_power && (ret >= 0) && (val & DA9063_NONKEY)) {
+		ret = regmap_update_bits(onkey->hw->regmap,
+					 DA9063_REG_IRQ_MASK_A,
+					 DA9063_NONKEY, 1);
+		if (ret < 0)
+			dev_err(&onkey->input->dev,
+				"Failed to mask the onkey IRQ: %d\n", ret);
+
+		input_report_key(onkey->input, KEY_POWER, 1);
+		input_sync(onkey->input);
+
+		schedule_delayed_work(&onkey->work, 0);
+		dev_dbg(&onkey->input->dev, "KEY_POWER pressed.\n");
+	} else {
+		input_report_key(onkey->input, KEY_SLEEP, 1);
+		input_report_key(onkey->input, KEY_SLEEP, 0);
+		input_sync(onkey->input);
+		dev_dbg(&onkey->input->dev, "KEY_SLEEP pressed.\n");
+	}
+
+	return IRQ_HANDLED;
+}
+
+static int da9063_onkey_probe(struct platform_device *pdev)
+{
+	struct da9063 *da9063 = dev_get_drvdata(pdev->dev.parent);
+	struct da9063_pdata *pdata = dev_get_platdata(da9063->dev);
+	struct da9063_onkey *onkey;
+	bool kp_tmp = true;
+	int ret = 0;
+	int irq;
+
+	if (pdata)
+		kp_tmp = pdata->key_power;
+
+	if (!kp_tmp)
+		dev_err(&pdev->dev,
+			"Software power down key is not set.\n");
+
+	onkey = devm_kzalloc(&pdev->dev, sizeof(struct da9063_onkey),
+			     GFP_KERNEL);
+	if (!onkey) {
+		dev_err(&pdev->dev, "Failed to allocate memory.\n");
+		return -ENOMEM;
+	}
+
+	INIT_DELAYED_WORK(&onkey->work, da9063_poll_on);
+
+	onkey->input = devm_input_allocate_device(&pdev->dev);
+	if (!onkey->input) {
+		dev_err(&pdev->dev, "Failed to allocated input device.\n");
+		return -ENOMEM;
+	}
+
+	irq = platform_get_irq_byname(pdev, "ONKEY");
+	if (irq < 0) {
+		dev_err(&pdev->dev, "Failed to get platform IRQ.\n");
+		return irq;
+	}
+
+	ret = devm_request_threaded_irq(&pdev->dev, irq, NULL,
+					da9063_onkey_irq_handler,
+					IRQF_TRIGGER_LOW | IRQF_ONESHOT,
+					"ONKEY", onkey);
+	if (ret) {
+		dev_err(&pdev->dev,
+			"Failed to request input device IRQ.\n");
+		return ret;
+	}
+
+	onkey->hw = da9063;
+	onkey->key_power = kp_tmp;
+	onkey->input->evbit[0] = BIT_MASK(EV_KEY);
+	onkey->input->name = DA9063_DRVNAME_ONKEY;
+	onkey->input->phys = DA9063_DRVNAME_ONKEY "/input0";
+	onkey->input->dev.parent = &pdev->dev;
+
+	if (onkey->key_power)
+		input_set_capability(onkey->input, EV_KEY, KEY_POWER);
+	input_set_capability(onkey->input, EV_KEY, KEY_SLEEP);
+
+	ret = input_register_device(onkey->input);
+	if (ret) {
+		dev_err(&pdev->dev,
+			"Failed to register input device.\n");
+		return ret;
+	}
+
+	platform_set_drvdata(pdev, onkey);
+	return ret;
+}
+
+static int da9063_onkey_remove(struct platform_device *pdev)
+{
+	struct	da9063_onkey *onkey = platform_get_drvdata(pdev);
+	cancel_delayed_work_sync(&onkey->work);
+	input_unregister_device(onkey->input);
+	return 0;
+}
+
+static struct platform_driver da9063_onkey_driver = {
+	.probe	= da9063_onkey_probe,
+	.remove	= da9063_onkey_remove,
+	.driver	= {
+		.name	= DA9063_DRVNAME_ONKEY,
+		.owner	= THIS_MODULE,
+	},
+};
+
+module_platform_driver(da9063_onkey_driver);
+
+MODULE_AUTHOR("S Twiss <stwiss.opensource@diasemi.com>");
+MODULE_DESCRIPTION("Onkey device driver for Dialog DA9063");
+MODULE_LICENSE("GPL v2");
+MODULE_ALIAS("platform:" DA9063_DRVNAME_ONKEY);
-- 
end-of-patch for RFC V1

