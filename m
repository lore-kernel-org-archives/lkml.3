Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754822Ab3LaQhC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Dec 2013 11:37:02 -0500
Received: from mail-wg0-f42.google.com ([74.125.82.42]:55204 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753897Ab3LaQf4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Dec 2013 11:35:56 -0500
From: jjhiblot@traphandler.com
To: nicolas.ferre@atmel.com
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        jean-jacques hiblot <jean-jacques.hiblot@jdsu.com>,
        Jean-Jacques Hiblot <jjhiblot@traphandler.com>
Subject: [PATCH 3/6] At91: dt: Added smc bus driver
Date: Tue, 31 Dec 2013 17:32:11 +0100
Message-Id: <1388507534-10570-4-git-send-email-jjhiblot@traphandler.com>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1388507534-10570-1-git-send-email-jjhiblot@traphandler.com>
References: <1388507534-10570-1-git-send-email-jjhiblot@traphandler.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: jean-jacques hiblot <jean-jacques.hiblot@jdsu.com>

The EBI/SMC external interface is used to access external peripherals (NAND
and Ethernet controller in the case of sam9261ek). Different configurations and
 timings are required for those peripherals. This bus driver can be used to
setup the bus timings/configuration from the device tree.

Signed-off-by: Jean-Jacques Hiblot <jjhiblot@traphandler.com>
---
 drivers/bus/Kconfig     |   9 +++
 drivers/bus/Makefile    |   1 +
 drivers/bus/atmel-smc.c | 182 ++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 192 insertions(+)
 create mode 100644 drivers/bus/atmel-smc.c

diff --git a/drivers/bus/Kconfig b/drivers/bus/Kconfig
index 552373c..8c944db5 100644
--- a/drivers/bus/Kconfig
+++ b/drivers/bus/Kconfig
@@ -12,6 +12,15 @@ config IMX_WEIM
 	  The WEIM(Wireless External Interface Module) works like a bus.
 	  You can attach many different devices on it, such as NOR, onenand.
 
+config ATMEL_SMC
+	bool "Atmel SMC/EBI driver"
+	depends on SOC_AT91SAM9 && OF
+	help
+	  Driver for Atmel SMC/EBI controller.
+	  Used to configure the EBI (external bus interface) when the device-
+	  tree is used. This bus supports NANDs, external ethernet controller,
+	  SRAMs, ATA devices.
+
 config MVEBU_MBUS
 	bool
 	depends on PLAT_ORION
diff --git a/drivers/bus/Makefile b/drivers/bus/Makefile
index 8947bdd..4364003 100644
--- a/drivers/bus/Makefile
+++ b/drivers/bus/Makefile
@@ -2,6 +2,7 @@
 # Makefile for the bus drivers.
 #
 
+obj-$(CONFIG_ATMEL_SMC)	+= atmel-smc.o
 obj-$(CONFIG_IMX_WEIM)	+= imx-weim.o
 obj-$(CONFIG_MVEBU_MBUS) += mvebu-mbus.o
 obj-$(CONFIG_OMAP_OCP2SCP)	+= omap-ocp2scp.o
diff --git a/drivers/bus/atmel-smc.c b/drivers/bus/atmel-smc.c
new file mode 100644
index 0000000..06e530d
--- /dev/null
+++ b/drivers/bus/atmel-smc.c
@@ -0,0 +1,182 @@
+/*
+ * EBI driver for Atmel SAM9 chips
+ * inspired by the fsl weim bus driver
+ *
+ * Copyright (C) 2013 JJ Hiblot.
+ *
+ * This file is licensed under the terms of the GNU General Public
+ * License version 2. This program is licensed "as is" without any
+ * warranty of any kind, whether express or implied.
+ */
+#include <linux/module.h>
+#include <linux/clk.h>
+#include <linux/io.h>
+#include <linux/of_device.h>
+#include <mach/at91sam9_smc.h>
+
+struct at91_smc_devtype {
+	unsigned int	cs_count;
+};
+
+static const struct at91_smc_devtype sam9261_smc_devtype = {
+	.cs_count	= 6,
+};
+
+static const struct of_device_id smc_id_table[] = {
+	{ .compatible = "atmel,at91sam9261-smc", .data = &sam9261_smc_devtype},
+	{ }
+};
+MODULE_DEVICE_TABLE(of, smc_id_table);
+
+struct smc_parameters_type {
+	const char *name;
+	u16 reg;
+	u16 width;
+	u16 shift;
+};
+
+#define SETUP	0
+#define PULSE	1
+#define CYCLE	2
+#define MODE	3
+static const struct smc_parameters_type smc_parameters[] = {
+	{"smc,ncs_read_setup",		SETUP, 6, 24},
+	{"smc,nrd_setup",		SETUP, 6, 16},
+	{"smc,ncs_write_setup",		SETUP, 6,  8},
+	{"smc,nwe_setup",		SETUP, 6,  0},
+	{"smc,ncs_read_pulse",		PULSE, 6, 24},
+	{"smc,nrd_pulse",		PULSE, 6, 16},
+	{"smc,ncs_write_pulse",		PULSE, 6,  8},
+	{"smc,nwe_pulse",		PULSE, 6,  0},
+	{"smc,read_cycle",		CYCLE, 9, 16},
+	{"smc,write_cycle",		CYCLE, 9,  0},
+	{"smc,burst_size",		MODE,  2, 28},
+	{"smc,burst_enabled",		MODE,  1, 24},
+	{"smc,tdf_mode",		MODE,  1, 20},
+	{"smc,tdf_cycles",		MODE,  4, 16},
+	{"smc,bus_width",		MODE,  2, 12},
+	{"smc,byte_access_type",	MODE,  1,  8},
+	{"smc,nwait_mode",		MODE,  2,  4},
+	{"smc,write_mode",		MODE,  1,  0},
+	{"smc,read_mode",		MODE,  1,  1},
+	{NULL}
+};
+
+/* Parse and set the timing for this device. */
+static int __init smc_timing_setup(struct device *dev, struct device_node *np,
+		void __iomem *base, const struct at91_smc_devtype *devtype)
+{
+	u32 val;
+	int ret;
+	u32 cs;
+	const struct smc_parameters_type *p = smc_parameters;
+	u32 shadow_smc_regs[5];
+
+	ret = of_property_read_u32(np, "smc,cs" , &cs);
+	if (ret < 0) {
+		dev_err(dev, "missing mandatory property : smc,cs\n");
+		return ret;
+	}
+	if (val >= devtype->cs_count) {
+		dev_err(dev, "invalid value for property smc,cs (=%d)."
+		"Must be in range 0 to %d\n", cs, devtype->cs_count-1);
+		return -EINVAL;
+	}
+
+	/* set the timing for EBI */
+	base += (0x10 * cs);
+	shadow_smc_regs[SETUP] = readl_relaxed(base + AT91_SMC_SETUP);
+	shadow_smc_regs[PULSE] = readl_relaxed(base + AT91_SMC_PULSE);
+	shadow_smc_regs[CYCLE] = readl_relaxed(base + AT91_SMC_CYCLE);
+	shadow_smc_regs[MODE] = readl_relaxed(base + AT91_SMC_MODE);
+
+	while (p->name) {
+		ret = of_property_read_u32(np, p->name , &val);
+		if (ret == -EINVAL) {
+			dev_dbg(dev, "cs %d: property %s not set.\n", cs,
+				p->name);
+			p++;
+			continue;
+		} else if (ret) {
+			dev_err(dev, "cs %d: can't get property %s.\n", cs,
+				p->name);
+			return ret;
+		}
+		if (val >= (1<<p->width)) {
+			dev_err(dev, "cs %d: property %s out of range.\n", cs,
+				p->name);
+			return -ERANGE;
+		}
+		shadow_smc_regs[p->reg] &= ~(((1<<p->width)-1) << p->shift);
+		shadow_smc_regs[p->reg] |= (val << p->shift);
+		p++;
+	}
+	writel_relaxed(shadow_smc_regs[SETUP], base + AT91_SMC_SETUP);
+	writel_relaxed(shadow_smc_regs[PULSE], base + AT91_SMC_PULSE);
+	writel_relaxed(shadow_smc_regs[CYCLE], base + AT91_SMC_CYCLE);
+	writel_relaxed(shadow_smc_regs[MODE], base + AT91_SMC_MODE);
+	return 0;
+}
+
+static int __init smc_parse_dt(struct platform_device *pdev,
+				void __iomem *base)
+{
+	struct device *dev = &pdev->dev;
+	const struct of_device_id *of_id = of_match_device(smc_id_table, dev);
+	const struct at91_smc_devtype *devtype = of_id->data;
+	struct device_node *child;
+	int ret;
+
+	for_each_child_of_node(dev->of_node, child) {
+		if (!child->name)
+			continue;
+
+		ret = smc_timing_setup(dev, child, base, devtype);
+		if (ret) {
+			dev_err(dev, "%s set timing failed.\n",
+				child->full_name);
+			return ret;
+		}
+	}
+
+	ret = of_platform_populate(dev->of_node, NULL, NULL, dev);
+	if (ret)
+		dev_err(dev, "%s fail to create devices.\n",
+			dev->of_node->full_name);
+	return ret;
+}
+
+static int __init smc_probe(struct platform_device *pdev)
+{
+	struct resource *res;
+	void __iomem *base;
+	int ret;
+
+	/* get the resource */
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	base = devm_request_and_ioremap(&pdev->dev, res);
+	if (IS_ERR(base)) {
+		dev_err(&pdev->dev, "can't map SMC base address\n");
+		return PTR_ERR(base);
+	}
+
+	/* parse the device node */
+	ret = smc_parse_dt(pdev, base);
+	if (!ret)
+		dev_info(&pdev->dev, "Driver registered.\n");
+
+	return ret;
+}
+
+static struct platform_driver smc_driver = {
+	.driver = {
+		.name		= "atmel-smc",
+		.owner		= THIS_MODULE,
+		.of_match_table	= smc_id_table,
+	},
+};
+module_platform_driver_probe(smc_driver, smc_probe);
+
+MODULE_AUTHOR("JJ Hiblot");
+MODULE_DESCRIPTION("Atmel's SMC/EBI driver");
+MODULE_LICENSE("GPL");
-- 
1.8.4.2

