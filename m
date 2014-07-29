Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753820AbaG2OGG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 10:06:06 -0400
Received: from mail-ie0-f177.google.com ([209.85.223.177]:54114 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753753AbaG2OGD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 10:06:03 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: lee.jones@linaro.org, kernel@stlinux.com, tglx@linutronix.de,
        jason@lakedaemon.net, devicetree@vger.kernel.org
Subject: [PATCH 2/6] irqchip: Supply new driver for STi based devices
Date: Tue, 29 Jul 2014 15:05:40 +0100
Message-Id: <1406642744-22589-3-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1406642744-22589-1-git-send-email-lee.jones@linaro.org>
References: <1406642744-22589-1-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver is used to enable System Configuration Register controlled
External, CTI (Core Sight), PMU (Performance Management), and PL310 L2
Cache IRQs prior to use.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/irqchip/Kconfig  |   7 ++
 drivers/irqchip/Makefile |   1 +
 drivers/irqchip/irq-st.c | 206 +++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 214 insertions(+)
 create mode 100644 drivers/irqchip/irq-st.c

diff --git a/drivers/irqchip/Kconfig b/drivers/irqchip/Kconfig
index bbb746e..7252de9 100644
--- a/drivers/irqchip/Kconfig
+++ b/drivers/irqchip/Kconfig
@@ -91,3 +91,10 @@ config IRQ_CROSSBAR
 	  The primary irqchip invokes the crossbar's callback which inturn allocates
 	  a free irq and configures the IP. Thus the peripheral interrupts are
 	  routed to one of the free irqchip interrupt lines.
+
+config ST_IRQCHIP
+	bool
+	select REGMAP
+	select MFD_SYSCON
+	help
+	  Enables SysCfg Controlled IRQs on STi based platforms.
diff --git a/drivers/irqchip/Makefile b/drivers/irqchip/Makefile
index 62a13e5..f859c14 100644
--- a/drivers/irqchip/Makefile
+++ b/drivers/irqchip/Makefile
@@ -30,3 +30,4 @@ obj-$(CONFIG_XTENSA)			+= irq-xtensa-pic.o
 obj-$(CONFIG_XTENSA_MX)			+= irq-xtensa-mx.o
 obj-$(CONFIG_IRQ_CROSSBAR)		+= irq-crossbar.o
 obj-$(CONFIG_BRCMSTB_L2_IRQ)		+= irq-brcmstb-l2.o
+obj-$(CONFIG_ST_IRQCHIP)		+= irq-st.o
diff --git a/drivers/irqchip/irq-st.c b/drivers/irqchip/irq-st.c
new file mode 100644
index 0000000..f31126f
--- /dev/null
+++ b/drivers/irqchip/irq-st.c
@@ -0,0 +1,206 @@
+/*
+ *  drivers/irqchip/irq-st.c
+ *
+ *  Copyright (C) 2014 STMicroelectronics – All Rights Reserved
+ *
+ *  Author: Lee Jones <lee.jones@linaro.org>
+ *
+ *  This is a re-write of Christophe Kerello's PMU driver.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <dt-bindings/interrupt-controller/irq-st.h>
+#include <linux/err.h>
+#include <linux/mfd/syscon.h>
+#include <linux/of_device.h>
+#include <linux/platform_device.h>
+#include <linux/regmap.h>
+#include <linux/slab.h>
+
+#define STIH415_SYSCFG_642		0x0a8
+#define STIH416_SYSCFG_7543		0x87c
+#define STIH407_SYSCFG_5102		0x198
+#define STID127_SYSCFG_734		0x088
+
+#define ST_A9_IRQ_MASK			0x001FFFFF
+#define ST_A9_IRQ_MAX_CHANS		2
+
+#define ST_A9_IRQ_EN_CTI_0		BIT(0)
+#define ST_A9_IRQ_EN_CTI_1		BIT(1)
+#define ST_A9_IRQ_EN_PMU_0		BIT(2)
+#define ST_A9_IRQ_EN_PMU_1		BIT(3)
+#define ST_A9_IRQ_EN_pl310_L2		BIT(4)
+#define ST_A9_IRQ_EN_EXT_0		BIT(5)
+#define ST_A9_IRQ_EN_EXT_1		BIT(6)
+#define ST_A9_IRQ_EN_EXT_2		BIT(7)
+
+#define ST_A9_FIQ_N_SEL(dev, chan)	(dev << (8  + (chan * 3)))
+#define ST_A9_IRQ_N_SEL(dev, chan)	(dev << (14 + (chan * 3)))
+#define ST_A9_EXTIRQ_INV_SEL(dev)	(dev << 20)
+
+struct st_irq_syscfg {
+	struct regmap *regmap;
+	unsigned int syscfg;
+	unsigned int result;
+	bool ext_inverted;
+};
+
+static const struct of_device_id st_irq_syscfg_match[] = {
+	{
+		.compatible = "st,stih415-irq-syscfg",
+		.data = (void *)STIH415_SYSCFG_642,
+	},
+	{
+		.compatible = "st,stih416-irq-syscfg",
+		.data = (void *)STIH416_SYSCFG_7543,
+	},
+	{
+		.compatible = "st,stih407-irq-syscfg",
+		.data = (void *)STIH407_SYSCFG_5102,
+	},
+	{
+		.compatible = "st,stid127-irq-syscfg",
+		.data = (void *)STID127_SYSCFG_734,
+	},
+	{}
+};
+
+static int st_irq_xlate(struct platform_device *pdev,
+			int device, int channel, bool irq)
+{
+	struct st_irq_syscfg *ddata = dev_get_drvdata(&pdev->dev);
+
+	/* Set the device enable bit. */
+	switch (device) {
+	case ST_IRQ_SYSCFG_EXT_0 :
+		ddata->result |= ST_A9_IRQ_EN_EXT_0;
+		break;
+	case ST_IRQ_SYSCFG_EXT_1 :
+		ddata->result |= ST_A9_IRQ_EN_EXT_1;
+		break;
+	case ST_IRQ_SYSCFG_EXT_2 :
+		ddata->result |= ST_A9_IRQ_EN_EXT_2;
+		break;
+	case ST_IRQ_SYSCFG_CTI_0 :
+		ddata->result |= ST_A9_IRQ_EN_CTI_0;
+		break;
+	case ST_IRQ_SYSCFG_CTI_1 :
+		ddata->result |= ST_A9_IRQ_EN_CTI_1;
+		break;
+	case ST_IRQ_SYSCFG_PMU_0 :
+		ddata->result |= ST_A9_IRQ_EN_PMU_0;
+		break;
+	case ST_IRQ_SYSCFG_PMU_1 :
+		ddata->result |= ST_A9_IRQ_EN_PMU_1;
+		break;
+	case ST_IRQ_SYSCFG_pl310_L2 :
+		ddata->result |= ST_A9_IRQ_EN_pl310_L2;
+		break;
+	case ST_IRQ_SYSCFG_DISABLED :
+		return 0;
+	default :
+		dev_err(&pdev->dev, "Unrecognised device %d\n", device);
+		return -EINVAL;
+	}
+
+	/* Select IRQ/FIQ channel for device. */
+	ddata->result |= irq ?
+		ST_A9_IRQ_N_SEL(device, channel) :
+		ST_A9_FIQ_N_SEL(device, channel);
+
+	return 0;
+}
+
+static int st_irq_syscfg_enable(struct platform_device *pdev)
+{
+	struct device_node *np = pdev->dev.of_node;
+	struct st_irq_syscfg *ddata = dev_get_drvdata(&pdev->dev);
+	int channels, ret, i;
+	u32 device, invert;
+
+	channels = of_property_count_u32_elems(np, "st,irq-device");
+	if (channels != ST_A9_IRQ_MAX_CHANS) {
+		dev_err(&pdev->dev, "st,enable-irq-device must have 2 elems\n");
+		return -EINVAL;
+	}
+
+	channels = of_property_count_u32_elems(np, "st,fiq-device");
+	if (channels != ST_A9_IRQ_MAX_CHANS) {
+		dev_err(&pdev->dev, "st,enable-fiq-device must have 2 elems\n");
+		return -EINVAL;
+	}
+
+	for (i = 0; i < channels; i++) {
+		of_property_read_u32_index(np,"st,irq-device", i, &device);
+
+		ret = st_irq_xlate(pdev, device, i, true);
+		if (ret)
+			return ret;
+
+		of_property_read_u32_index(np,"st,fiq-device", i, &device);
+
+		ret = st_irq_xlate(pdev, device, i, false);
+		if (ret)
+			return ret;
+	}
+
+	/* External IRQs may be inverted. */
+	of_property_read_u32(np, "st,invert-ext", &invert);
+	ddata->result |= ST_A9_EXTIRQ_INV_SEL(invert);
+
+	return regmap_update_bits(ddata->regmap, ddata->syscfg,
+				  ST_A9_IRQ_MASK, ddata->result);
+}
+
+int st_irq_syscfg_probe(struct platform_device *pdev)
+{
+	struct device_node *np = pdev->dev.of_node;
+	const struct of_device_id *match;
+	struct st_irq_syscfg *ddata;
+
+	match = of_match_device(st_irq_syscfg_match, &pdev->dev);
+	if (!np)
+		return -ENODEV;
+
+	ddata = devm_kzalloc(&pdev->dev, sizeof(*ddata), GFP_KERNEL);
+	if (!ddata)
+		return -ENOMEM;
+
+	ddata->regmap = syscon_regmap_lookup_by_phandle(np, "st,syscfg");
+	if (IS_ERR(ddata->regmap)) {
+		dev_err(&pdev->dev, "syscfg phandle missing\n");
+		return PTR_ERR(ddata->regmap);
+	}
+
+	dev_set_drvdata(&pdev->dev, ddata);
+
+	return st_irq_syscfg_enable(pdev);
+}
+
+static int st_irq_syscfg_resume(struct device *dev)
+{
+	struct st_irq_syscfg *ddata = dev_get_drvdata(dev);
+
+	return regmap_update_bits(ddata->regmap, ddata->syscfg,
+				  ST_A9_IRQ_MASK, ddata->result);
+}
+
+static SIMPLE_DEV_PM_OPS(st_irq_syscfg_pm_ops, NULL, st_irq_syscfg_resume);
+
+static struct platform_driver st_irq_syscfg_driver = {
+	.driver = {
+		.name = "st_irq_syscfg",
+		.pm = &st_irq_syscfg_pm_ops,
+		.of_match_table = st_irq_syscfg_match,
+	},
+	.probe = st_irq_syscfg_probe,
+};
+
+static int __init st_irq_syscfg_init(void)
+{
+	return platform_driver_register(&st_irq_syscfg_driver);
+}
+core_initcall(st_irq_syscfg_init);
-- 
1.9.1

