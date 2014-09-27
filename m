Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753275AbaI0BAq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 21:00:46 -0400
Received: from mout.kundenserver.de ([212.227.126.187]:64590 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751281AbaI0BAa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 21:00:30 -0400
From: Stefan Wahren <stefan.wahren@i2se.com>
To: lgirdwood@gmail.com, broonie@kernel.org, shawn.guo@linaro.org,
        robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org
Cc: festevam@gmail.com, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, kernel@pengutronix.de,
        Stefan Wahren <stefan.wahren@i2se.com>
Subject: [PATCH 2/2] regulator: add mxs regulator driver
Date: Sat, 27 Sep 2014 00:59:48 +0000
Message-Id: <1411779588-22031-3-git-send-email-stefan.wahren@i2se.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1411779588-22031-1-git-send-email-stefan.wahren@i2se.com>
References: <1411779588-22031-1-git-send-email-stefan.wahren@i2se.com>
X-Provags-ID: V02:K0:ZgU5G8GlaQXwMzn0rZHjYHU1g2dZJlGW3WqWbkRuS6W
 rRBS/maThwha3woW/MDTeCYp3LApqKruXgPLAvjFXJgiyuC/b4
 /sRKfoaPOCnrGiWwCbYphO6YFM28TLqlYYKlqKQnmZJFng+LDh
 OLxL0Us91nuwYudwfFKHdNDwNU1UJf8FRpaN+BrDByru4T+3rJ
 n3aFnsdsysUkxs0NLh2Lkch0pZxa/ryG3FSGG2fBUoiRvJYUXf
 Pw1BEHbwCzZFGr29fshycnTzOkYknGayppXd1j9azLS7QGudnK
 EkZFzLZTd5TK121+VQ8EhWm/+1IkQH1R3ohXAW2cKjwZQc4egL
 zrzwEUNyBWmOjn+NgiKsZIC/KLSTVIeb811MPqjO1vngFJA3BH
 sAiq9fc9d3l1ZcQ9Uo/aHwoa3EW2uMx1ds=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds driver support for Freescale i.MX23, i.MX28
on-chip regulators. The driver supports the following regulators:
vddd, vdda and vddio.

Signed-off-by: Stefan Wahren <stefan.wahren@i2se.com>
---
 drivers/regulator/Kconfig         |   11 ++
 drivers/regulator/Makefile        |    1 +
 drivers/regulator/mxs-regulator.c |  395 +++++++++++++++++++++++++++++++++++++
 3 files changed, 407 insertions(+)
 create mode 100644 drivers/regulator/mxs-regulator.c

diff --git a/drivers/regulator/Kconfig b/drivers/regulator/Kconfig
index a353011..f353a2b 100644
--- a/drivers/regulator/Kconfig
+++ b/drivers/regulator/Kconfig
@@ -433,6 +433,17 @@ config REGULATOR_MC13892
 	  Say y here to support the regulators found on the Freescale MC13892
 	  PMIC.
 
+config REGULATOR_MXS
+	tristate "Freescale MXS on-chip regulators"
+	depends on ARCH_MXS
+	default y if ARCH_MXS
+	help
+	  Say y here to support Freescale MXS on-chip regulators.
+
+	  The driver currently support the following voltage regulators:
+          vddd, vdda and vddio. It is recommended that this option be
+	  enabled on i.MX23, i.MX28 platform.
+
 config REGULATOR_PALMAS
 	tristate "TI Palmas PMIC Regulators"
 	depends on MFD_PALMAS
diff --git a/drivers/regulator/Makefile b/drivers/regulator/Makefile
index 25271f8..0f5b66c 100644
--- a/drivers/regulator/Makefile
+++ b/drivers/regulator/Makefile
@@ -58,6 +58,7 @@ obj-$(CONFIG_REGULATOR_MAX77802) += max77802.o
 obj-$(CONFIG_REGULATOR_MC13783) += mc13783-regulator.o
 obj-$(CONFIG_REGULATOR_MC13892) += mc13892-regulator.o
 obj-$(CONFIG_REGULATOR_MC13XXX_CORE) +=  mc13xxx-regulator-core.o
+obj-$(CONFIG_REGULATOR_MXS) += mxs-regulator.o
 obj-$(CONFIG_REGULATOR_PALMAS) += palmas-regulator.o
 obj-$(CONFIG_REGULATOR_PFUZE100) += pfuze100-regulator.o
 obj-$(CONFIG_REGULATOR_TPS51632) += tps51632-regulator.o
diff --git a/drivers/regulator/mxs-regulator.c b/drivers/regulator/mxs-regulator.c
new file mode 100644
index 0000000..63c09cc
--- /dev/null
+++ b/drivers/regulator/mxs-regulator.c
@@ -0,0 +1,395 @@
+/*
+ * Freescale STMP378X voltage regulators
+ *
+ * Embedded Alley Solutions, Inc <source@embeddedalley.com>
+ *
+ * Copyright (C) 2014 Stefan Wahren
+ * Copyright (C) 2010 Freescale Semiconductor, Inc.
+ * Copyright 2008 Embedded Alley Solutions, Inc All Rights Reserved.
+ */
+
+/*
+ * The code contained herein is licensed under the GNU General Public
+ * License. You may obtain a copy of the GNU General Public License
+ * Version 2 or later at the following locations:
+ *
+ * http://www.opensource.org/licenses/gpl-license.html
+ * http://www.gnu.org/copyleft/gpl.html
+ */
+
+#include <linux/delay.h>
+#include <linux/err.h>
+#include <linux/init.h>
+#include <linux/io.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/of_address.h>
+#include <linux/platform_device.h>
+#include <linux/regulator/driver.h>
+#include <linux/regulator/machine.h>
+#include <linux/regulator/of_regulator.h>
+#include <linux/slab.h>
+
+#define HW_POWER_STS			(0x000000c0)
+
+#define BM_POWER_STS_DC_OK		BIT(9)
+
+#define MXS_VDDIO	1
+#define MXS_VDDA	2
+#define MXS_VDDD	3
+
+struct mxs_regulator {
+	struct regulator_desc rdesc;
+	struct regulator_init_data *initdata;
+
+	const char *name;
+	void __iomem *base_addr;
+	void __iomem *power_addr;
+	unsigned int mode_mask;
+};
+
+static int mxs_set_voltage(struct regulator_dev *reg, int min_uV, int max_uV,
+			   unsigned *selector)
+{
+	struct mxs_regulator *sreg = rdev_get_drvdata(reg);
+	struct regulation_constraints *con = &sreg->initdata->constraints;
+	void __iomem *power_sts = sreg->power_addr + HW_POWER_STS;
+	unsigned long start;
+	u32 val, regs, i;
+
+	pr_debug("%s: min_uV %d, max_uV %d, min %d, max %d\n", __func__,
+		 min_uV, max_uV, con->min_uV, con->max_uV);
+
+	if (max_uV < con->min_uV || max_uV > con->max_uV)
+		return -EINVAL;
+
+	val = (max_uV - con->min_uV) * sreg->rdesc.n_voltages /
+			(con->max_uV - con->min_uV);
+
+	regs = (readl(sreg->base_addr) & ~sreg->rdesc.vsel_mask);
+
+	pr_debug("%s: %s calculated val %d\n", __func__, sreg->name, val);
+
+	writel(val | regs, sreg->base_addr);
+	for (i = 20; i; i--) {
+		/* delay for fast mode */
+		if (readl(power_sts) & BM_POWER_STS_DC_OK)
+			return 0;
+
+		udelay(1);
+	}
+
+	writel(val | regs, sreg->base_addr);
+	start = jiffies;
+	while (1) {
+		/* delay for normal mode */
+		if (readl(power_sts) & BM_POWER_STS_DC_OK)
+			return 0;
+
+		if (time_after(jiffies, start +	msecs_to_jiffies(80)))
+			break;
+
+		schedule();
+	}
+
+	return -ETIMEDOUT;
+}
+
+
+static int mxs_get_voltage(struct regulator_dev *reg)
+{
+	struct mxs_regulator *sreg = rdev_get_drvdata(reg);
+	struct regulation_constraints *con = &sreg->initdata->constraints;
+	int uV;
+	u32 val = readl(sreg->base_addr) & sreg->rdesc.vsel_mask;
+
+	pr_debug("%s: %s register val %d\n", __func__, sreg->name, val);
+
+	if (val > sreg->rdesc.n_voltages)
+		val = sreg->rdesc.n_voltages;
+
+	uV = con->min_uV + val *
+		(con->max_uV - con->min_uV) / sreg->rdesc.n_voltages;
+
+	return uV;
+}
+
+static int mxs_is_enabled(struct regulator_dev *reg)
+{
+	struct mxs_regulator *sreg = rdev_get_drvdata(reg);
+	u32 val;
+
+	if (sreg->rdesc.id == MXS_VDDIO)
+		return 1;
+
+	val = readl(sreg->base_addr) & sreg->rdesc.enable_mask;
+
+	pr_debug("%s: %s register val %d\n", __func__, sreg->name, val);
+
+	switch (sreg->rdesc.id) {
+	case MXS_VDDA:
+		val >>= 16;
+		break;
+	case MXS_VDDD:
+		val >>= 20;
+		break;
+	}
+
+	return val ? 1 : 0;
+}
+
+static int mxs_set_mode(struct regulator_dev *reg, unsigned int mode)
+{
+	struct mxs_regulator *sreg = rdev_get_drvdata(reg);
+	int ret = 0;
+	u32 val;
+
+	switch (mode) {
+	case REGULATOR_MODE_FAST:
+		val = readl(sreg->base_addr);
+		/* Disable stepping */
+		writel(val | sreg->mode_mask, sreg->base_addr);
+		break;
+
+	case REGULATOR_MODE_NORMAL:
+		val = readl(sreg->base_addr);
+		/* Enable stepping */
+		writel(val & ~sreg->mode_mask, sreg->base_addr);
+		break;
+
+	default:
+		ret = -EINVAL;
+		break;
+	}
+
+	return ret;
+}
+
+static unsigned int mxs_get_mode(struct regulator_dev *reg)
+{
+	struct mxs_regulator *sreg = rdev_get_drvdata(reg);
+	u32 val = readl(sreg->base_addr) & sreg->mode_mask;
+
+	return val ? REGULATOR_MODE_FAST : REGULATOR_MODE_NORMAL;
+}
+
+static struct regulator_ops mxs_rops = {
+	.set_voltage	= mxs_set_voltage,
+	.get_voltage	= mxs_get_voltage,
+	.set_mode	= mxs_set_mode,
+	.get_mode	= mxs_get_mode,
+};
+
+static struct regulator_desc mxs_reg_desc[] = {
+	{
+		.name = "vddio",
+		.id = MXS_VDDIO,
+		.type = REGULATOR_VOLTAGE,
+		.n_voltages = 0x10,
+		.uV_step = 50000,
+		.linear_min_sel = 0,
+		.vsel_mask = 0x1f,
+		.enable_mask = 0,
+	},
+	{
+		.name = "vdda",
+		.id = MXS_VDDA,
+		.type = REGULATOR_VOLTAGE,
+		.n_voltages = 0x1f,
+		.uV_step = 25000,
+		.linear_min_sel = 0,
+		.vsel_mask = 0x1f,
+		.enable_mask = (3 << 16),
+	},
+	{
+		.name = "vddd",
+		.id = MXS_VDDD,
+		.type = REGULATOR_VOLTAGE,
+		.n_voltages = 0x1f,
+		.uV_step = 25000,
+		.linear_min_sel = 0,
+		.vsel_mask = 0x1f,
+		.enable_mask = (3 << 20),
+	},
+};
+
+static int mxs_regulator_probe(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct device_node *np = dev->of_node;
+	struct device_node *parent;
+	struct regulator_desc *rdesc;
+	struct regulator_dev *rdev = NULL;
+	struct mxs_regulator *sreg;
+	struct regulator_init_data *initdata = NULL;
+	struct regulation_constraints *con;
+	struct regulator_config config = { };
+	void __iomem *base_addr = NULL;
+	void __iomem *power_addr = NULL;
+	int ret = 0;
+	const char *name;
+	unsigned int i;
+
+	if (!np) {
+		dev_err(dev, "missing device tree\n");
+		return -EINVAL;
+	}
+
+	initdata = of_get_regulator_init_data(dev, np);
+	if (!initdata) {
+		dev_err(dev, "missing regulator init data\n");
+		return -EINVAL;
+	}
+
+	if (of_property_read_string(np, "regulator-name", &name)) {
+		dev_err(dev, "missing property regulator-name\n");
+		return -EINVAL;
+	}
+
+	sreg = devm_kzalloc(dev, sizeof(*sreg), GFP_KERNEL);
+	if (!sreg)
+		return -EINVAL;
+
+	sreg->initdata = initdata;
+	rdesc = &sreg->rdesc;
+	memset(rdesc, 0, sizeof(*rdesc));
+
+	for (i = 0; i < ARRAY_SIZE(mxs_reg_desc); i++) {
+		if (!strcmp(mxs_reg_desc[i].name, name))
+			break;
+	}
+
+	if (i >= ARRAY_SIZE(mxs_reg_desc)) {
+		dev_err(dev, "unknown regulator %s\n", name);
+		return -EINVAL;
+	}
+
+	sreg->name = name;
+	rdesc->name = sreg->name;
+	rdesc->owner = THIS_MODULE;
+	rdesc->id = mxs_reg_desc[i].id;
+	rdesc->type = REGULATOR_VOLTAGE;
+	rdesc->linear_min_sel = mxs_reg_desc[i].linear_min_sel;
+	rdesc->n_voltages = mxs_reg_desc[i].n_voltages;
+	rdesc->uV_step = mxs_reg_desc[i].uV_step;
+	rdesc->vsel_mask = mxs_reg_desc[i].vsel_mask;
+	rdesc->enable_mask = mxs_reg_desc[i].enable_mask;
+	rdesc->enable_is_inverted = mxs_reg_desc[i].enable_is_inverted;
+	rdesc->ops = &mxs_rops;
+
+	switch (sreg->rdesc.id) {
+	case MXS_VDDIO:
+		sreg->mode_mask = BIT(17);
+		break;
+	case MXS_VDDA:
+		sreg->mode_mask = BIT(18);
+		break;
+	case MXS_VDDD:
+		sreg->mode_mask = BIT(22);
+		break;
+	}
+
+	/* get device base address */
+	base_addr = of_iomap(np, 0);
+	if (!base_addr) {
+		dev_err(dev, "unable to map base addr\n");
+		return -ENXIO;
+	}
+
+	parent = of_get_parent(np);
+	if (!parent) {
+		dev_err(dev, "unable to get power controller node\n");
+		ret = -ENXIO;
+		goto fail1;
+	}
+
+	/* get base address of power controller */
+	power_addr = of_iomap(parent, 0);
+	of_node_put(parent);
+	if (!power_addr) {
+		dev_err(dev, "unable to map power controller addr\n");
+		ret = -ENXIO;
+		goto fail1;
+	}
+
+	dev_info(dev, "%s found\n", name);
+
+	sreg->base_addr = base_addr;
+	sreg->power_addr = power_addr;
+
+	con = &initdata->constraints;
+
+	config.dev = &pdev->dev;
+	config.init_data = initdata;
+	config.driver_data = sreg;
+	config.of_node = np;
+
+	pr_debug("probing regulator %s\n", name);
+
+	rdev = devm_regulator_register(dev, rdesc, &config);
+
+	if (IS_ERR(rdev)) {
+		dev_err(dev, "failed to register %s\n", name);
+		ret = PTR_ERR(rdev);
+		goto fail2;
+	}
+
+	platform_set_drvdata(pdev, rdev);
+
+	return 0;
+fail2:
+	iounmap(power_addr);
+fail1:
+	iounmap(base_addr);
+
+	return ret;
+}
+
+static int mxs_regulator_remove(struct platform_device *pdev)
+{
+	struct regulator_dev *rdev = platform_get_drvdata(pdev);
+	struct mxs_regulator *sreg = rdev_get_drvdata(rdev);
+	void __iomem *base_addr = sreg->base_addr;
+	void __iomem *power_addr = sreg->power_addr;
+
+	regulator_unregister(rdev);
+	iounmap(power_addr);
+	iounmap(base_addr);
+
+	return 0;
+}
+
+static const struct of_device_id of_mxs_regulator_match[] = {
+	{ .compatible = "fsl,mxs-regulator" },
+	{ /* end */ }
+};
+MODULE_DEVICE_TABLE(of, of_mxs_regulator_match);
+
+static struct platform_driver mxs_regulator_driver = {
+	.driver = {
+		.name	= "mxs_regulator",
+		.owner  = THIS_MODULE,
+		.of_match_table = of_mxs_regulator_match,
+	},
+	.probe	= mxs_regulator_probe,
+	.remove = mxs_regulator_remove,
+};
+
+static int __init mxs_regulator_init(void)
+{
+	return platform_driver_register(&mxs_regulator_driver);
+}
+postcore_initcall(mxs_regulator_init);
+
+static void __exit mxs_regulator_exit(void)
+{
+	platform_driver_unregister(&mxs_regulator_driver);
+}
+module_exit(mxs_regulator_exit);
+
+MODULE_AUTHOR("Embedded Alley Solutions <source@embeddedalley.com>");
+MODULE_AUTHOR("Stefan Wahren <stefan.wahren@i2se.com>");
+MODULE_DESCRIPTION("Freescale STMP378X voltage regulators");
+MODULE_LICENSE("GPL v2");
+MODULE_ALIAS("platform:mxs_regulator");
-- 
1.7.9.5

