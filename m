Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756356AbbAXAUJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 19:20:09 -0500
Received: from seldrel01.sonyericsson.com ([212.209.106.2]:1742 "EHLO
	seldrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754617AbbAXATR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 19:19:17 -0500
From: Bjorn Andersson <bjorn.andersson@sonymobile.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Rob Herring <robh+dt@kernel.org>
CC: Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Grant Likely <grant.likely@linaro.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-input@vger.kernel.org>,
        <linux-arm-msm@vger.kernel.org>,
        Courtney Cavin <courtney.cavin@sonymobile.com>
Subject: [PATCH v2 1/2] input: Add Qualcomm PM8941 power key driver
Date: Fri, 23 Jan 2015 16:19:06 -0800
Message-ID: <1422058747-13486-2-git-send-email-bjorn.andersson@sonymobile.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422058747-13486-1-git-send-email-bjorn.andersson@sonymobile.com>
References: <1422058747-13486-1-git-send-email-bjorn.andersson@sonymobile.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Courtney Cavin <courtney.cavin@sonymobile.com>

Signed-off-by: Courtney Cavin <courtney.cavin@sonymobile.com>
Signed-off-by: Bjorn Andersson <bjorn.andersson@sonymobile.com>
---
 drivers/input/misc/Kconfig         |  12 ++
 drivers/input/misc/Makefile        |   1 +
 drivers/input/misc/pm8941-pwrkey.c | 281 +++++++++++++++++++++++++++++++++++++
 3 files changed, 294 insertions(+)
 create mode 100644 drivers/input/misc/pm8941-pwrkey.c

diff --git a/drivers/input/misc/Kconfig b/drivers/input/misc/Kconfig
index 23297ab..3306592 100644
--- a/drivers/input/misc/Kconfig
+++ b/drivers/input/misc/Kconfig
@@ -105,6 +105,18 @@ config INPUT_PCSPKR
 	  To compile this driver as a module, choose M here: the
 	  module will be called pcspkr.
 
+config INPUT_PM8941_PWRKEY
+	tristate "Qualcomm PM8941 power key support"
+	depends on MFD_SPMI_PMIC
+	help
+	  Say Y here if you want support for the power key usually found
+	  on boards using a Qualcomm PM8941 compatible PMIC.
+
+	  If unsure, say Y.
+
+	  To compile this driver as a module, choose M here: the module
+	  will be called pm8941-pwrkey.
+
 config INPUT_PM8XXX_VIBRATOR
 	tristate "Qualcomm PM8XXX vibrator support"
 	depends on MFD_PM8XXX
diff --git a/drivers/input/misc/Makefile b/drivers/input/misc/Makefile
index 19c7603..c44f6c2 100644
--- a/drivers/input/misc/Makefile
+++ b/drivers/input/misc/Makefile
@@ -48,6 +48,7 @@ obj-$(CONFIG_INPUT_PCAP)		+= pcap_keys.o
 obj-$(CONFIG_INPUT_PCF50633_PMU)	+= pcf50633-input.o
 obj-$(CONFIG_INPUT_PCF8574)		+= pcf8574_keypad.o
 obj-$(CONFIG_INPUT_PCSPKR)		+= pcspkr.o
+obj-$(CONFIG_INPUT_PM8941_PWRKEY)	+= pm8941-pwrkey.o
 obj-$(CONFIG_INPUT_PM8XXX_VIBRATOR)	+= pm8xxx-vibrator.o
 obj-$(CONFIG_INPUT_PMIC8XXX_PWRKEY)	+= pmic8xxx-pwrkey.o
 obj-$(CONFIG_INPUT_POWERMATE)		+= powermate.o
diff --git a/drivers/input/misc/pm8941-pwrkey.c b/drivers/input/misc/pm8941-pwrkey.c
new file mode 100644
index 0000000..bc7ba8f
--- /dev/null
+++ b/drivers/input/misc/pm8941-pwrkey.c
@@ -0,0 +1,281 @@
+/* Copyright (c) 2010-2011, Code Aurora Forum. All rights reserved.
+ * Copyright (c) 2014, Sony Mobile Communications Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/delay.h>
+#include <linux/errno.h>
+#include <linux/input.h>
+#include <linux/interrupt.h>
+#include <linux/kernel.h>
+#include <linux/log2.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/platform_device.h>
+#include <linux/reboot.h>
+#include <linux/regmap.h>
+
+#define PON_REV2			0x01
+
+#define PON_RT_STS			0x10
+#define  PON_KPDPWR_N_SET		BIT(0)
+
+#define PON_PS_HOLD_RST_CTL		0x5a
+#define PON_PS_HOLD_RST_CTL2		0x5b
+#define  PON_PS_HOLD_ENABLE		BIT(7)
+#define  PON_PS_HOLD_TYPE_MASK		0x0f
+#define  PON_PS_HOLD_TYPE_SHUTDOWN	4
+#define  PON_PS_HOLD_TYPE_HARD_RESET	7
+
+#define PON_PULL_CTL			0x70
+#define  PON_KPDPWR_PULL_UP		BIT(1)
+
+#define PON_DBC_CTL			0x71
+#define  PON_DBC_DELAY_MASK		0x7
+
+
+struct pm8941_pwrkey {
+	struct device *dev;
+	int irq;
+	u32 baseaddr;
+	struct regmap *regmap;
+	struct input_dev *input;
+
+	unsigned int revision;
+	struct notifier_block reboot_notifier;
+};
+
+static int pm8941_reboot_notify(struct notifier_block *nb,
+				unsigned long code, void *unused)
+{
+	struct pm8941_pwrkey *pwrkey = container_of(nb, struct pm8941_pwrkey,
+						    reboot_notifier);
+	unsigned int enable_reg;
+	unsigned int reset_type;
+	int rc;
+
+	/* PMICs with revision 0 have the enable bit in same register as ctrl */
+	if (pwrkey->revision == 0)
+		enable_reg = PON_PS_HOLD_RST_CTL;
+	else
+		enable_reg = PON_PS_HOLD_RST_CTL2;
+
+	rc = regmap_update_bits(pwrkey->regmap, pwrkey->baseaddr + enable_reg,
+				PON_PS_HOLD_ENABLE, 0);
+	if (rc)
+		dev_err(pwrkey->dev, "unable to clear ps hold reset enable\n");
+
+	/*
+	 * Updates of PON_PS_HOLD_ENABLE requires 3 sleep cycles between
+	 * writes.
+	 */
+	usleep_range(100, 1000);
+
+	switch (code) {
+	case SYS_HALT:
+	case SYS_POWER_OFF:
+		reset_type = PON_PS_HOLD_TYPE_SHUTDOWN;
+		break;
+	case SYS_RESTART:
+	default:
+		reset_type = PON_PS_HOLD_TYPE_HARD_RESET;
+		break;
+	};
+
+	rc = regmap_update_bits(pwrkey->regmap,
+				pwrkey->baseaddr + PON_PS_HOLD_RST_CTL,
+				PON_PS_HOLD_TYPE_MASK, reset_type);
+	if (rc)
+		dev_err(pwrkey->dev, "unable to set ps hold reset type\n");
+
+	rc = regmap_update_bits(pwrkey->regmap, pwrkey->baseaddr + enable_reg,
+				PON_PS_HOLD_ENABLE, PON_PS_HOLD_ENABLE);
+	if (rc)
+		dev_err(pwrkey->dev, "unable to re-set enable\n");
+
+	return NOTIFY_DONE;
+}
+
+static irqreturn_t pm8941_pwrkey_irq(int irq, void *_data)
+{
+	struct pm8941_pwrkey *pwrkey = _data;
+	unsigned int sts;
+	int rc;
+
+	rc = regmap_read(pwrkey->regmap, pwrkey->baseaddr + PON_RT_STS, &sts);
+	if (rc)
+		return IRQ_HANDLED;
+
+	input_report_key(pwrkey->input, KEY_POWER, !!(sts & PON_KPDPWR_N_SET));
+	input_sync(pwrkey->input);
+
+	return IRQ_HANDLED;
+}
+
+#ifdef CONFIG_PM_SLEEP
+static int pm8941_pwrkey_suspend(struct device *dev)
+{
+	struct pm8941_pwrkey *pwrkey = dev_get_drvdata(dev);
+
+	if (device_may_wakeup(dev))
+		enable_irq_wake(pwrkey->irq);
+
+	return 0;
+}
+
+static int pm8941_pwrkey_resume(struct device *dev)
+{
+	struct pm8941_pwrkey *pwrkey = dev_get_drvdata(dev);
+
+	if (device_may_wakeup(dev))
+		disable_irq_wake(pwrkey->irq);
+
+	return 0;
+}
+#endif
+
+static SIMPLE_DEV_PM_OPS(pm8941_pwr_key_pm_ops,
+		pm8941_pwrkey_suspend, pm8941_pwrkey_resume);
+
+static int pm8941_pwrkey_probe(struct platform_device *pdev)
+{
+	struct pm8941_pwrkey *pwrkey;
+	bool pull_up;
+	u32 req_delay;
+	int rc;
+
+	if (of_property_read_u32(pdev->dev.of_node, "debounce", &req_delay))
+		req_delay = 15625;
+
+	if (req_delay > 2000000 || req_delay == 0) {
+		dev_err(&pdev->dev, "invalid debounce time: %u\n", req_delay);
+		return -EINVAL;
+	}
+
+	pull_up = of_property_read_bool(pdev->dev.of_node, "bias-pull-up");
+
+	pwrkey = devm_kzalloc(&pdev->dev, sizeof(*pwrkey), GFP_KERNEL);
+	if (!pwrkey)
+		return -ENOMEM;
+
+	pwrkey->dev = &pdev->dev;
+
+	pwrkey->regmap = dev_get_regmap(pdev->dev.parent, NULL);
+	if (!pwrkey->regmap) {
+		dev_err(&pdev->dev, "failed to locate regmap\n");
+		return -ENODEV;
+	}
+
+	pwrkey->irq = platform_get_irq(pdev, 0);
+	if (pwrkey->irq < 0) {
+		dev_err(&pdev->dev, "failed to get irq\n");
+		return pwrkey->irq;
+	}
+
+	rc = of_property_read_u32(pdev->dev.of_node, "reg", &pwrkey->baseaddr);
+	if (rc)
+		return rc;
+
+	rc = regmap_read(pwrkey->regmap, pwrkey->baseaddr + PON_REV2,
+			 &pwrkey->revision);
+	if (rc) {
+		dev_err(&pdev->dev, "failed to set debounce: %d\n", rc);
+		return rc;
+	}
+
+	pwrkey->input = devm_input_allocate_device(&pdev->dev);
+	if (!pwrkey->input) {
+		dev_dbg(&pdev->dev, "unable to allocate input device\n");
+		return -ENOMEM;
+	}
+
+	input_set_capability(pwrkey->input, EV_KEY, KEY_POWER);
+
+	pwrkey->input->name = "pm8941_pwrkey";
+	pwrkey->input->phys = "pm8941_pwrkey/input0";
+
+	req_delay = (req_delay << 6) / USEC_PER_SEC;
+	req_delay = ilog2(req_delay);
+
+	rc = regmap_update_bits(pwrkey->regmap, pwrkey->baseaddr + PON_DBC_CTL,
+			PON_DBC_DELAY_MASK, req_delay);
+	if (rc) {
+		dev_err(&pdev->dev, "failed to set debounce: %d\n", rc);
+		return rc;
+	}
+
+	rc = regmap_update_bits(pwrkey->regmap,
+			pwrkey->baseaddr + PON_PULL_CTL, PON_KPDPWR_PULL_UP,
+			pull_up ? PON_KPDPWR_PULL_UP : 0);
+	if (rc) {
+		dev_err(&pdev->dev, "failed to set pull: %d\n", rc);
+		return rc;
+	}
+
+	rc = devm_request_threaded_irq(&pdev->dev, pwrkey->irq,
+				NULL, pm8941_pwrkey_irq,
+				IRQF_ONESHOT,
+				"pm8941_pwrkey", pwrkey);
+	if (rc) {
+		dev_err(&pdev->dev, "failed requesting IRQ: %d\n", rc);
+		return rc;
+	}
+
+	rc = input_register_device(pwrkey->input);
+	if (rc) {
+		dev_err(&pdev->dev, "failed to register input device: %d\n",
+			rc);
+		return rc;
+	}
+
+	pwrkey->reboot_notifier.notifier_call = pm8941_reboot_notify,
+	rc = register_reboot_notifier(&pwrkey->reboot_notifier);
+	if (rc) {
+		dev_err(&pdev->dev, "failed to register reboot notifier: %d\n",
+			rc);
+		return rc;
+	}
+
+	platform_set_drvdata(pdev, pwrkey);
+	device_init_wakeup(&pdev->dev, 1);
+
+	return 0;
+}
+
+static int pm8941_pwrkey_remove(struct platform_device *pdev)
+{
+	struct pm8941_pwrkey *pwrkey = platform_get_drvdata(pdev);
+
+	device_init_wakeup(&pdev->dev, 0);
+	unregister_reboot_notifier(&pwrkey->reboot_notifier);
+
+	return 0;
+}
+
+static const struct of_device_id pm8941_pwr_key_id_table[] = {
+	{ .compatible = "qcom,pm8941-pwrkey" },
+	{ }
+};
+MODULE_DEVICE_TABLE(of, pm8941_pwr_key_id_table);
+
+static struct platform_driver pm8941_pwrkey_driver = {
+	.probe = pm8941_pwrkey_probe,
+	.remove = pm8941_pwrkey_remove,
+	.driver = {
+		.name = "pm8941-pwrkey",
+		.pm = &pm8941_pwr_key_pm_ops,
+		.of_match_table = of_match_ptr(pm8941_pwr_key_id_table),
+	},
+};
+module_platform_driver(pm8941_pwrkey_driver);
+
+MODULE_DESCRIPTION("PM8941 Power Key driver");
+MODULE_LICENSE("GPL v2");
-- 
1.9.1

