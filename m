Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755496AbbAIAAO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 19:00:14 -0500
Received: from mail-wi0-f181.google.com ([209.85.212.181]:45248 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754299AbbAHX77 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 18:59:59 -0500
From: Moritz Fischer <moritz.fischer@ettus.com>
To: dmitry.torokhov@gmail.com
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Moritz Fischer <moritz.fischer@ettus.com>
Subject: [PATCH v3 1/3] input: misc: Support NI Ettus Research USRP E3x0 Button
Date: Fri,  9 Jan 2015 00:59:29 +0100
Message-Id: <1420761571-22903-2-git-send-email-moritz.fischer@ettus.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1420761571-22903-1-git-send-email-moritz.fischer@ettus.com>
References: <1420761571-22903-1-git-send-email-moritz.fischer@ettus.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Moritz Fischer <moritz.fischer@ettus.com>
---
 drivers/input/misc/Kconfig       |  10 +++
 drivers/input/misc/Makefile      |   1 +
 drivers/input/misc/e3x0-button.c | 156 +++++++++++++++++++++++++++++++++++++++
 3 files changed, 167 insertions(+)

diff --git a/drivers/input/misc/Kconfig b/drivers/input/misc/Kconfig
index 23297ab..84a56b4 100644
--- a/drivers/input/misc/Kconfig
+++ b/drivers/input/misc/Kconfig
@@ -93,6 +93,16 @@ config INPUT_BMA150
 	  To compile this driver as a module, choose M here: the
 	  module will be called bma150.
 
+config INPUT_E3X0_BUTTON
+	tristate "NI Ettus Research USRP E3x0 Button support."
+	default n
+	help
+	  Say Y here to enable support for the NI Ettus Research
+	  USRP E3x0 Button.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called e3x0_button.
+
 config INPUT_PCSPKR
 	tristate "PC Speaker support"
 	depends on PCSPKR_PLATFORM
diff --git a/drivers/input/misc/Makefile b/drivers/input/misc/Makefile
index 19c7603..b1775a5 100644
--- a/drivers/input/misc/Makefile
+++ b/drivers/input/misc/Makefile
@@ -26,6 +26,7 @@ obj-$(CONFIG_INPUT_COBALT_BTNS)		+= cobalt_btns.o
 obj-$(CONFIG_INPUT_DA9052_ONKEY)	+= da9052_onkey.o
 obj-$(CONFIG_INPUT_DA9055_ONKEY)	+= da9055_onkey.o
 obj-$(CONFIG_INPUT_DM355EVM)		+= dm355evm_keys.o
+obj-$(CONFIG_INPUT_E3X0_BUTTON)		+= e3x0-button.o
 obj-$(CONFIG_INPUT_DRV260X_HAPTICS)	+= drv260x.o
 obj-$(CONFIG_INPUT_DRV2667_HAPTICS)	+= drv2667.o
 obj-$(CONFIG_INPUT_GP2A)		+= gp2ap002a00f.o
diff --git a/drivers/input/misc/e3x0-button.c b/drivers/input/misc/e3x0-button.c
new file mode 100644
index 0000000..bff65ef
--- /dev/null
+++ b/drivers/input/misc/e3x0-button.c
@@ -0,0 +1,156 @@
+/*
+ * Copyright (c) 2014, National Instruments Corp. All rights reserved.
+ *
+ * Driver for NI Ettus Research USRP E3x0 Button Driver
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; version 2 of the License.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/device.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/input.h>
+#include <linux/interrupt.h>
+#include <linux/of.h>
+#include <linux/slab.h>
+
+static irqreturn_t e3x0_button_release_handler(int irq, void *data)
+{
+	struct input_dev *idev = data;
+
+	input_report_key(idev, KEY_POWER, 0);
+	input_sync(idev);
+
+	return IRQ_HANDLED;
+}
+
+static irqreturn_t e3x0_button_press_handler(int irq, void *data)
+{
+	struct input_dev *idev = data;
+
+	input_report_key(idev, KEY_POWER, 1);
+	pm_wakeup_event(idev->dev.parent, 0);
+	input_sync(idev);
+
+	return IRQ_HANDLED;
+}
+
+static int __maybe_unused e3x0_button_suspend(struct device *dev)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+
+	if (device_may_wakeup(dev))
+		enable_irq_wake(platform_get_irq_byname(pdev, "press"));
+
+	return 0;
+}
+
+static int __maybe_unused e3x0_button_resume(struct device *dev)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+
+	if (device_may_wakeup(dev))
+		disable_irq_wake(platform_get_irq_byname(pdev, "press"));
+
+	return 0;
+}
+
+static SIMPLE_DEV_PM_OPS(e3x0_button_pm_ops,
+		e3x0_button_suspend, e3x0_button_resume);
+
+static int e3x0_button_probe(struct platform_device *pdev)
+{
+	struct input_dev *input;
+	int irq_press, irq_release;
+	int error;
+
+	irq_press = platform_get_irq_byname(pdev, "press");
+	if (irq_press < 0) {
+		dev_err(&pdev->dev, "No IRQ for 'press', error=%d\n",
+			irq_press);
+		return irq_press;
+	}
+
+	irq_release = platform_get_irq_byname(pdev, "release");
+	if (irq_release < 0) {
+		dev_err(&pdev->dev, "No IRQ for 'release', error=%d\n",
+			irq_release);
+		return irq_release;
+	}
+
+	input = devm_input_allocate_device(&pdev->dev);
+	if (!input)
+		return -ENOMEM;
+
+	input->name = "NI Ettus Research USRP E3x0 Button Driver";
+	input->phys = "e3x0_button/input0";
+	input->dev.parent = &pdev->dev;
+
+	input_set_capability(input, EV_KEY, KEY_POWER);
+
+	error = devm_request_irq(&pdev->dev, irq_press,
+					     e3x0_button_press_handler, 0,
+					     "e3x0-button", input);
+	if (error < 0) {
+		dev_err(&pdev->dev, "Failed to request 'press' IRQ#%d: %d\n",
+			irq_press, error);
+		return error;
+	}
+
+	error = devm_request_irq(&pdev->dev, irq_release,
+					     e3x0_button_release_handler, 0,
+					     "e3x0-button", input);
+	if (error < 0) {
+		dev_err(&pdev->dev, "Failed to request 'release' IRQ#%d: %d\n",
+			irq_release, error);
+		return error;
+	}
+
+	error = input_register_device(input);
+	if (error) {
+		dev_err(&pdev->dev, "Can't register input device: %d\n", error);
+		return error;
+	}
+
+	platform_set_drvdata(pdev, input);
+	device_init_wakeup(&pdev->dev, 1);
+	return 0;
+}
+
+static int e3x0_button_remove(struct platform_device *pdev)
+{
+	device_init_wakeup(&pdev->dev, 0);
+	return 0;
+}
+
+#ifdef CONFIG_OF
+static const struct of_device_id e3x0_button_match[] = {
+	{ .compatible = "ettus,e3x0-button", },
+	{}
+};
+MODULE_DEVICE_TABLE(of, e3x0_button_match);
+#endif
+
+static struct platform_driver e3x0_button_driver = {
+	.driver		= {
+		.name	= "e3x0-button",
+		.of_match_table = of_match_ptr(e3x0_button_match),
+	},
+	.probe		= e3x0_button_probe,
+	.remove		= e3x0_button_remove,
+};
+
+module_platform_driver(e3x0_button_driver);
+
+MODULE_LICENSE("GPL v2");
+MODULE_AUTHOR("Moritz Fischer <moritz.fischer@ettus.com>");
+MODULE_DESCRIPTION("NI Ettus Research USRP E3x0 Button driver");
+MODULE_ALIAS("platform:e3x0-button");
-- 
1.9.3

