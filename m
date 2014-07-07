Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753628AbaGGPNK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 11:13:10 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:35845 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752040AbaGGPMV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 11:12:21 -0400
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>
Cc: "Ivan T. Ivanov" <iivanov@mm-sol.com>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-msm@vger.kernel.org
Subject: [PATCH 3/4] pinctrl: qcom: Add PM8941 and PM8941 pinctrl drivers
Date: Mon,  7 Jul 2014 18:11:32 +0300
Message-Id: <1404745893-6379-4-git-send-email-iivanov@mm-sol.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1404745893-6379-1-git-send-email-iivanov@mm-sol.com>
References: <1404745893-6379-1-git-send-email-iivanov@mm-sol.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Ivan T. Ivanov" <iivanov@mm-sol.com>

Add new pinctrl driver for GPIO and MPP subfunctions found in
Qualcomm PMIC chips.

Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>
---
 drivers/pinctrl/Kconfig          | 17 +++++++
 drivers/pinctrl/Makefile         |  2 +
 drivers/pinctrl/pinctrl-pm8841.c | 84 +++++++++++++++++++++++++++++++++++
 drivers/pinctrl/pinctrl-pm8941.c | 96 ++++++++++++++++++++++++++++++++++++++++
 4 files changed, 199 insertions(+)
 create mode 100644 drivers/pinctrl/pinctrl-pm8841.c
 create mode 100644 drivers/pinctrl/pinctrl-pm8941.c

diff --git a/drivers/pinctrl/Kconfig b/drivers/pinctrl/Kconfig
index 297c84d..914f43c 100644
--- a/drivers/pinctrl/Kconfig
+++ b/drivers/pinctrl/Kconfig
@@ -383,6 +383,23 @@ config PINCTRL_PALMAS
 	  open drain configuration for the Palmas series devices like
 	  TPS65913, TPS80036 etc.
 
+config PINCTRL_PM8841
+	tristate "Qualcomm PM8841 pin controller driver"
+	depends on OF
+	select PINCTRL_QPNP
+	help
+	  This is the pinctrl, pinmux, pinconf and gpiolib driver for the
+	  Qualcomm MPP subfunction block found in the Qualcomm PM8841 PMIC chip.
+
+config PINCTRL_PM8941
+	tristate "Qualcomm PM8941 pin controller driver"
+	depends on OF
+	select PINCTRL_QPNP
+	help
+	  This is the pinctrl, pinmux, pinconf and gpiolib driver for the
+	  Qualcomm MPP and GPIO subfunction block found in the Qualcomm PM8941
+	  PMIC chip.
+
 config PINCTRL_QPNP
 	bool
 	select PINMUX
diff --git a/drivers/pinctrl/Makefile b/drivers/pinctrl/Makefile
index bfbdba1..3d1fe38 100644
--- a/drivers/pinctrl/Makefile
+++ b/drivers/pinctrl/Makefile
@@ -47,6 +47,8 @@ obj-$(CONFIG_PINCTRL_STN8815)	+= pinctrl-nomadik-stn8815.o
 obj-$(CONFIG_PINCTRL_DB8500)	+= pinctrl-nomadik-db8500.o
 obj-$(CONFIG_PINCTRL_DB8540)	+= pinctrl-nomadik-db8540.o
 obj-$(CONFIG_PINCTRL_PALMAS)	+= pinctrl-palmas.o
+obj-$(CONFIG_PINCTRL_PM8841)	+= pinctrl-pm8841.o
+obj-$(CONFIG_PINCTRL_PM8941)	+= pinctrl-pm8941.o
 obj-$(CONFIG_PINCTRL_QPNP)	+= pinctrl-qpnp.o
 obj-$(CONFIG_PINCTRL_ROCKCHIP)	+= pinctrl-rockchip.o
 obj-$(CONFIG_PINCTRL_SINGLE)	+= pinctrl-single.o
diff --git a/drivers/pinctrl/pinctrl-pm8841.c b/drivers/pinctrl/pinctrl-pm8841.c
new file mode 100644
index 0000000..0e46536
--- /dev/null
+++ b/drivers/pinctrl/pinctrl-pm8841.c
@@ -0,0 +1,84 @@
+/*
+ * Copyright (c) 2012-2014, The Linux Foundation. All rights reserved.
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
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/platform_device.h>
+#include <linux/pinctrl/pinctrl.h>
+#include <linux/platform_device.h>
+
+#include "pinctrl-qpnp.h"
+
+#define PM8841_MPP_CNT	4
+
+static int pm8841_pinctrl_probe(struct platform_device *qdev)
+{
+	struct device *dev = &qdev->dev;
+	struct qpnp_pinctrl_info *data;
+	struct pinctrl_pin_desc *desc;
+	struct qpnp_padinfo *pads;
+	struct resource *res;
+	int idx, number;
+
+	res = platform_get_resource(qdev, IORESOURCE_REG, 0);
+	if (!res)
+		return -ENXIO;
+
+	data = devm_kzalloc(dev, sizeof(*data), GFP_KERNEL);
+	if (!data)
+		return -ENOMEM;
+
+	pads = devm_kzalloc(dev, sizeof(*pads) * PM8841_MPP_CNT, GFP_KERNEL);
+	if (!pads)
+		return -ENOMEM;
+
+	desc = devm_kzalloc(dev, sizeof(*desc) * PM8841_MPP_CNT, GFP_KERNEL);
+	if (!desc)
+		return -ENOMEM;
+
+	data->npads = PM8841_MPP_CNT;
+	data->pads  = pads;
+	data->desc  = desc;
+	number = 0;
+
+	for (idx = 0; idx < PM8841_MPP_CNT; idx++, pads++, desc++) {
+		snprintf(pads->name, ARRAY_SIZE(pads->name), "mpp%d", idx + 1);
+		pads->base = res->start + (idx * 0x100);
+		desc->number = number++;
+		desc->name = pads->name;
+	}
+
+	return qpnp_pinctrl_probe(qdev, data);
+}
+
+static const struct of_device_id pm8841_pinctrl_of_match[] = {
+	{ .compatible = "qcom,pm8841-pinctrl", },
+	{ },
+};
+MODULE_DEVICE_TABLE(of, pm8841_pinctrl_of_match);
+
+static struct platform_driver pm8841_pinctrl_driver = {
+	.driver = {
+		.name = "pm8841-pinctrl",
+		.owner = THIS_MODULE,
+		.of_match_table = pm8841_pinctrl_of_match,
+	},
+	.probe = pm8841_pinctrl_probe,
+	.remove = qpnp_pinctrl_remove,
+};
+module_platform_driver(pm8841_pinctrl_driver);
+
+MODULE_AUTHOR("Ivan T. Ivanov <iivanov@mm-sol.com>");
+MODULE_DESCRIPTION("Qualcomm PM8841 pin control driver");
+MODULE_ALIAS("platform:pm8841-pinctrl");
+MODULE_LICENSE("GPL v2");
diff --git a/drivers/pinctrl/pinctrl-pm8941.c b/drivers/pinctrl/pinctrl-pm8941.c
new file mode 100644
index 0000000..c3817e8
--- /dev/null
+++ b/drivers/pinctrl/pinctrl-pm8941.c
@@ -0,0 +1,96 @@
+/*
+ * Copyright (c) 2012-2014, The Linux Foundation. All rights reserved.
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
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/pinctrl/pinctrl.h>
+#include <linux/platform_device.h>
+
+#include "pinctrl-qpnp.h"
+
+#define PM8941_MPP_CNT	8
+#define PM8941_GPIO_CNT	36
+#define PM8941_PAD_CNT	(PM8941_MPP_CNT + PM8941_GPIO_CNT)
+
+static int pm8941_pinctrl_probe(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct qpnp_pinctrl_info *data;
+	struct pinctrl_pin_desc *desc;
+	struct qpnp_padinfo *pads;
+	struct resource *gpios, *mpps;
+	int idx, number;
+
+	mpps = platform_get_resource(pdev, IORESOURCE_REG, 0);
+	if (!mpps)
+		return -ENXIO;
+
+	gpios = platform_get_resource(pdev, IORESOURCE_REG, 1);
+	if (!gpios)
+		return -ENXIO;
+
+	data = devm_kzalloc(dev, sizeof(*data), GFP_KERNEL);
+	if (!data)
+		return -ENOMEM;
+
+	pads = devm_kzalloc(dev, sizeof(*pads) * PM8941_PAD_CNT, GFP_KERNEL);
+	if (!pads)
+		return -ENOMEM;
+
+	desc = devm_kzalloc(dev, sizeof(*desc) * PM8941_PAD_CNT, GFP_KERNEL);
+	if (!desc)
+		return -ENOMEM;
+
+	data->npads = PM8941_PAD_CNT;
+	data->pads  = pads;
+	data->desc  = desc;
+	number = 0;
+
+	for (idx = 0; idx < PM8941_MPP_CNT; idx++, pads++, desc++) {
+		snprintf(pads->name, ARRAY_SIZE(pads->name), "mpp%d", idx + 1);
+		pads->base = mpps->start + (idx * 0x100);
+		desc->number = number++;
+		desc->name = pads->name;
+	}
+
+	for (idx = 0; idx < PM8941_GPIO_CNT; idx++, pads++, desc++) {
+		snprintf(pads->name, ARRAY_SIZE(pads->name), "gpio%d", idx + 1);
+		pads->base = gpios->start + (idx * 0x100);
+		desc->number = number++;
+		desc->name = pads->name;
+	}
+
+	return qpnp_pinctrl_probe(pdev, data);
+}
+
+static const struct of_device_id pm8941_pinctrl_of_match[] = {
+	{ .compatible = "qcom,pm8941-pinctrl", },
+	{ },
+};
+MODULE_DEVICE_TABLE(of, pm8941_pinctrl_of_match);
+
+static struct platform_driver pm8941_pinctrl_driver = {
+	.driver = {
+		.name = "pm8941-pinctrl",
+		.owner = THIS_MODULE,
+		.of_match_table = pm8941_pinctrl_of_match,
+	},
+	.probe = pm8941_pinctrl_probe,
+	.remove = qpnp_pinctrl_remove,
+};
+module_platform_driver(pm8941_pinctrl_driver);
+
+MODULE_AUTHOR("Ivan T. Ivanov <iivanov@mm-sol.com>");
+MODULE_DESCRIPTION("Qualcomm PM8841 pin control driver");
+MODULE_ALIAS("platform:pm8941-pinctrl");
+MODULE_LICENSE("GPL v2");
-- 
1.8.3.2

