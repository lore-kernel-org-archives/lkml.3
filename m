Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753732AbaAMR3s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 12:29:48 -0500
Received: from smtp-out-120.synserver.de ([212.40.185.120]:1050 "EHLO
	smtp-out-087.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752849AbaAMR3p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 12:29:45 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 11731
From: Lars-Peter Clausen <lars@metafoo.de>
To: Mike Turquette <mturquette@linaro.org>
Cc: linux-kernel@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH resend] clk: axi-clkgen: Add support for v2
Date: Mon, 13 Jan 2014 18:30:07 +0100
Message-Id: <1389634207-8411-1-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.8.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for the new v2 version of the axi-clkgen core.
Unfortunately the method of accessing the registers is quite different on v2,
while the content still stays largely the same. So the patch adds a small
abstraction layer which implements the specific read and write functions for v1
and v2 in callback functions.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
 .../devicetree/bindings/clock/axi-clkgen.txt       |   2 +-
 drivers/clk/clk-axi-clkgen.c                       | 312 ++++++++++++++++++---
 2 files changed, 270 insertions(+), 44 deletions(-)

diff --git a/Documentation/devicetree/bindings/clock/axi-clkgen.txt b/Documentation/devicetree/bindings/clock/axi-clkgen.txt
index 028b493..20e1704 100644
--- a/Documentation/devicetree/bindings/clock/axi-clkgen.txt
+++ b/Documentation/devicetree/bindings/clock/axi-clkgen.txt
@@ -5,7 +5,7 @@ This binding uses the common clock binding[1].
 [1] Documentation/devicetree/bindings/clock/clock-bindings.txt
 
 Required properties:
-- compatible : shall be "adi,axi-clkgen".
+- compatible : shall be "adi,axi-clkgen-1.00.a" or "adi,axi-clkgen-2.00.a".
 - #clock-cells : from common clock binding; Should always be set to 0.
 - reg : Address and length of the axi-clkgen register set.
 - clocks : Phandle and clock specifier for the parent clock.
diff --git a/drivers/clk/clk-axi-clkgen.c b/drivers/clk/clk-axi-clkgen.c
index 8137327..1127ee4 100644
--- a/drivers/clk/clk-axi-clkgen.c
+++ b/drivers/clk/clk-axi-clkgen.c
@@ -17,23 +17,75 @@
 #include <linux/module.h>
 #include <linux/err.h>
 
-#define AXI_CLKGEN_REG_UPDATE_ENABLE	0x04
-#define AXI_CLKGEN_REG_CLK_OUT1		0x08
-#define AXI_CLKGEN_REG_CLK_OUT2		0x0c
-#define AXI_CLKGEN_REG_CLK_DIV		0x10
-#define AXI_CLKGEN_REG_CLK_FB1		0x14
-#define AXI_CLKGEN_REG_CLK_FB2		0x18
-#define AXI_CLKGEN_REG_LOCK1		0x1c
-#define AXI_CLKGEN_REG_LOCK2		0x20
-#define AXI_CLKGEN_REG_LOCK3		0x24
-#define AXI_CLKGEN_REG_FILTER1		0x28
-#define AXI_CLKGEN_REG_FILTER2		0x2c
+#define AXI_CLKGEN_V1_REG_UPDATE_ENABLE	0x04
+#define AXI_CLKGEN_V1_REG_CLK_OUT1	0x08
+#define AXI_CLKGEN_V1_REG_CLK_OUT2	0x0c
+#define AXI_CLKGEN_V1_REG_CLK_DIV	0x10
+#define AXI_CLKGEN_V1_REG_CLK_FB1	0x14
+#define AXI_CLKGEN_V1_REG_CLK_FB2	0x18
+#define AXI_CLKGEN_V1_REG_LOCK1		0x1c
+#define AXI_CLKGEN_V1_REG_LOCK2		0x20
+#define AXI_CLKGEN_V1_REG_LOCK3		0x24
+#define AXI_CLKGEN_V1_REG_FILTER1	0x28
+#define AXI_CLKGEN_V1_REG_FILTER2	0x2c
+
+#define AXI_CLKGEN_V2_REG_RESET		0x40
+#define AXI_CLKGEN_V2_REG_DRP_CNTRL	0x70
+#define AXI_CLKGEN_V2_REG_DRP_STATUS	0x74
+
+#define AXI_CLKGEN_V2_RESET_MMCM_ENABLE	BIT(1)
+#define AXI_CLKGEN_V2_RESET_ENABLE	BIT(0)
+
+#define AXI_CLKGEN_V2_DRP_CNTRL_SEL	BIT(29)
+#define AXI_CLKGEN_V2_DRP_CNTRL_READ	BIT(28)
+
+#define AXI_CLKGEN_V2_DRP_STATUS_BUSY	BIT(16)
+
+#define MMCM_REG_CLKOUT0_1	0x08
+#define MMCM_REG_CLKOUT0_2	0x09
+#define MMCM_REG_CLK_FB1	0x14
+#define MMCM_REG_CLK_FB2	0x15
+#define MMCM_REG_CLK_DIV	0x16
+#define MMCM_REG_LOCK1		0x18
+#define MMCM_REG_LOCK2		0x19
+#define MMCM_REG_LOCK3		0x1a
+#define MMCM_REG_FILTER1	0x4e
+#define MMCM_REG_FILTER2	0x4f
+
+struct axi_clkgen;
+
+struct axi_clkgen_mmcm_ops {
+	void (*enable)(struct axi_clkgen *axi_clkgen, bool enable);
+	int (*write)(struct axi_clkgen *axi_clkgen, unsigned int reg,
+		     unsigned int val, unsigned int mask);
+	int (*read)(struct axi_clkgen *axi_clkgen, unsigned int reg,
+		    unsigned int *val);
+};
 
 struct axi_clkgen {
 	void __iomem *base;
+	const struct axi_clkgen_mmcm_ops *mmcm_ops;
 	struct clk_hw clk_hw;
 };
 
+static void axi_clkgen_mmcm_enable(struct axi_clkgen *axi_clkgen,
+	bool enable)
+{
+	axi_clkgen->mmcm_ops->enable(axi_clkgen, enable);
+}
+
+static int axi_clkgen_mmcm_write(struct axi_clkgen *axi_clkgen,
+	unsigned int reg, unsigned int val, unsigned int mask)
+{
+	return axi_clkgen->mmcm_ops->write(axi_clkgen, reg, val, mask);
+}
+
+static int axi_clkgen_mmcm_read(struct axi_clkgen *axi_clkgen,
+	unsigned int reg, unsigned int *val)
+{
+	return axi_clkgen->mmcm_ops->read(axi_clkgen, reg, val);
+}
+
 static uint32_t axi_clkgen_lookup_filter(unsigned int m)
 {
 	switch (m) {
@@ -156,6 +208,148 @@ static void axi_clkgen_read(struct axi_clkgen *axi_clkgen,
 	*val = readl(axi_clkgen->base + reg);
 }
 
+static unsigned int axi_clkgen_v1_map_mmcm_reg(unsigned int reg)
+{
+	switch (reg) {
+	case MMCM_REG_CLKOUT0_1:
+		return AXI_CLKGEN_V1_REG_CLK_OUT1;
+	case MMCM_REG_CLKOUT0_2:
+		return AXI_CLKGEN_V1_REG_CLK_OUT2;
+	case MMCM_REG_CLK_FB1:
+		return AXI_CLKGEN_V1_REG_CLK_FB1;
+	case MMCM_REG_CLK_FB2:
+		return AXI_CLKGEN_V1_REG_CLK_FB2;
+	case MMCM_REG_CLK_DIV:
+		return AXI_CLKGEN_V1_REG_CLK_DIV;
+	case MMCM_REG_LOCK1:
+		return AXI_CLKGEN_V1_REG_LOCK1;
+	case MMCM_REG_LOCK2:
+		return AXI_CLKGEN_V1_REG_LOCK2;
+	case MMCM_REG_LOCK3:
+		return AXI_CLKGEN_V1_REG_LOCK3;
+	case MMCM_REG_FILTER1:
+		return AXI_CLKGEN_V1_REG_FILTER1;
+	case MMCM_REG_FILTER2:
+		return AXI_CLKGEN_V1_REG_FILTER2;
+	default:
+		return 0;
+	}
+}
+
+static int axi_clkgen_v1_mmcm_write(struct axi_clkgen *axi_clkgen,
+	unsigned int reg, unsigned int val, unsigned int mask)
+{
+	reg = axi_clkgen_v1_map_mmcm_reg(reg);
+	if (reg == 0)
+		return -EINVAL;
+
+	axi_clkgen_write(axi_clkgen, reg, val);
+
+	return 0;
+}
+
+static int axi_clkgen_v1_mmcm_read(struct axi_clkgen *axi_clkgen,
+	unsigned int reg, unsigned int *val)
+{
+	reg = axi_clkgen_v1_map_mmcm_reg(reg);
+	if (reg == 0)
+		return -EINVAL;
+
+	axi_clkgen_read(axi_clkgen, reg, val);
+
+	return 0;
+}
+
+static void axi_clkgen_v1_mmcm_enable(struct axi_clkgen *axi_clkgen,
+	bool enable)
+{
+	axi_clkgen_write(axi_clkgen, AXI_CLKGEN_V1_REG_UPDATE_ENABLE, enable);
+}
+
+static const struct axi_clkgen_mmcm_ops axi_clkgen_v1_mmcm_ops = {
+	.write = axi_clkgen_v1_mmcm_write,
+	.read = axi_clkgen_v1_mmcm_read,
+	.enable = axi_clkgen_v1_mmcm_enable,
+};
+
+static int axi_clkgen_wait_non_busy(struct axi_clkgen *axi_clkgen)
+{
+	unsigned int timeout = 10000;
+	unsigned int val;
+
+	do {
+		axi_clkgen_read(axi_clkgen, AXI_CLKGEN_V2_REG_DRP_STATUS, &val);
+	} while ((val & AXI_CLKGEN_V2_DRP_STATUS_BUSY) && --timeout);
+
+	if (val & AXI_CLKGEN_V2_DRP_STATUS_BUSY)
+		return -EIO;
+
+	return val & 0xffff;
+}
+
+static int axi_clkgen_v2_mmcm_read(struct axi_clkgen *axi_clkgen,
+	unsigned int reg, unsigned int *val)
+{
+	unsigned int reg_val;
+	int ret;
+
+	ret = axi_clkgen_wait_non_busy(axi_clkgen);
+	if (ret < 0)
+		return ret;
+
+	reg_val = AXI_CLKGEN_V2_DRP_CNTRL_SEL | AXI_CLKGEN_V2_DRP_CNTRL_READ;
+	reg_val |= (reg << 16);
+
+	axi_clkgen_write(axi_clkgen, AXI_CLKGEN_V2_REG_DRP_CNTRL, reg_val);
+
+	ret = axi_clkgen_wait_non_busy(axi_clkgen);
+	if (ret < 0)
+		return ret;
+
+	*val = ret;
+
+	return 0;
+}
+
+static int axi_clkgen_v2_mmcm_write(struct axi_clkgen *axi_clkgen,
+	unsigned int reg, unsigned int val, unsigned int mask)
+{
+	unsigned int reg_val = 0;
+	int ret;
+
+	ret = axi_clkgen_wait_non_busy(axi_clkgen);
+	if (ret < 0)
+		return ret;
+
+	if (mask != 0xffff) {
+		axi_clkgen_v2_mmcm_read(axi_clkgen, reg, &reg_val);
+		reg_val &= ~mask;
+	}
+
+	reg_val |= AXI_CLKGEN_V2_DRP_CNTRL_SEL | (reg << 16) | (val & mask);
+
+	axi_clkgen_write(axi_clkgen, AXI_CLKGEN_V2_REG_DRP_CNTRL, reg_val);
+
+	return 0;
+}
+
+static void axi_clkgen_v2_mmcm_enable(struct axi_clkgen *axi_clkgen,
+	bool enable)
+{
+	unsigned int val = AXI_CLKGEN_V2_RESET_ENABLE;
+
+	if (enable)
+		val |= AXI_CLKGEN_V2_RESET_MMCM_ENABLE;
+
+	axi_clkgen_write(axi_clkgen, AXI_CLKGEN_V2_REG_RESET, val);
+}
+
+static const struct axi_clkgen_mmcm_ops axi_clkgen_v2_mmcm_ops = {
+	.write = axi_clkgen_v2_mmcm_write,
+	.read = axi_clkgen_v2_mmcm_read,
+	.enable = axi_clkgen_v2_mmcm_enable,
+};
+
 static struct axi_clkgen *clk_hw_to_axi_clkgen(struct clk_hw *clk_hw)
 {
 	return container_of(clk_hw, struct axi_clkgen, clk_hw);
@@ -184,33 +378,29 @@ static int axi_clkgen_set_rate(struct clk_hw *clk_hw,
 	filter = axi_clkgen_lookup_filter(m - 1);
 	lock = axi_clkgen_lookup_lock(m - 1);
 
-	axi_clkgen_write(axi_clkgen, AXI_CLKGEN_REG_UPDATE_ENABLE, 0);
-
 	axi_clkgen_calc_clk_params(dout, &low, &high, &edge, &nocount);
-	axi_clkgen_write(axi_clkgen, AXI_CLKGEN_REG_CLK_OUT1,
-		(high << 6) | low);
-	axi_clkgen_write(axi_clkgen, AXI_CLKGEN_REG_CLK_OUT2,
-		(edge << 7) | (nocount << 6));
+	axi_clkgen_mmcm_write(axi_clkgen, MMCM_REG_CLKOUT0_1,
+		(high << 6) | low, 0xefff);
+	axi_clkgen_mmcm_write(axi_clkgen, MMCM_REG_CLKOUT0_2,
+		(edge << 7) | (nocount << 6), 0x03ff);
 
 	axi_clkgen_calc_clk_params(d, &low, &high, &edge, &nocount);
-	axi_clkgen_write(axi_clkgen, AXI_CLKGEN_REG_CLK_DIV,
-		(edge << 13) | (nocount << 12) | (high << 6) | low);
+	axi_clkgen_mmcm_write(axi_clkgen, MMCM_REG_CLK_DIV,
+		(edge << 13) | (nocount << 12) | (high << 6) | low, 0x3fff);
 
 	axi_clkgen_calc_clk_params(m, &low, &high, &edge, &nocount);
-	axi_clkgen_write(axi_clkgen, AXI_CLKGEN_REG_CLK_FB1,
-		(high << 6) | low);
-	axi_clkgen_write(axi_clkgen, AXI_CLKGEN_REG_CLK_FB2,
-		(edge << 7) | (nocount << 6));
-
-	axi_clkgen_write(axi_clkgen, AXI_CLKGEN_REG_LOCK1, lock & 0x3ff);
-	axi_clkgen_write(axi_clkgen, AXI_CLKGEN_REG_LOCK2,
-		(((lock >> 16) & 0x1f) << 10) | 0x1);
-	axi_clkgen_write(axi_clkgen, AXI_CLKGEN_REG_LOCK3,
-		(((lock >> 24) & 0x1f) << 10) | 0x3e9);
-	axi_clkgen_write(axi_clkgen, AXI_CLKGEN_REG_FILTER1, filter >> 16);
-	axi_clkgen_write(axi_clkgen, AXI_CLKGEN_REG_FILTER2, filter);
-
-	axi_clkgen_write(axi_clkgen, AXI_CLKGEN_REG_UPDATE_ENABLE, 1);
+	axi_clkgen_mmcm_write(axi_clkgen, MMCM_REG_CLK_FB1,
+		(high << 6) | low, 0xefff);
+	axi_clkgen_mmcm_write(axi_clkgen, MMCM_REG_CLK_FB2,
+		(edge << 7) | (nocount << 6), 0x03ff);
+
+	axi_clkgen_mmcm_write(axi_clkgen, MMCM_REG_LOCK1, lock & 0x3ff, 0x3ff);
+	axi_clkgen_mmcm_write(axi_clkgen, MMCM_REG_LOCK2,
+		(((lock >> 16) & 0x1f) << 10) | 0x1, 0x7fff);
+	axi_clkgen_mmcm_write(axi_clkgen, MMCM_REG_LOCK3,
+		(((lock >> 24) & 0x1f) << 10) | 0x3e9, 0x7fff);
+	axi_clkgen_mmcm_write(axi_clkgen, MMCM_REG_FILTER1, filter >> 16, 0x9900);
+	axi_clkgen_mmcm_write(axi_clkgen, MMCM_REG_FILTER2, filter, 0x9900);
 
 	return 0;
 }
@@ -236,11 +426,11 @@ static unsigned long axi_clkgen_recalc_rate(struct clk_hw *clk_hw,
 	unsigned int reg;
 	unsigned long long tmp;
 
-	axi_clkgen_read(axi_clkgen, AXI_CLKGEN_REG_CLK_OUT1, &reg);
+	axi_clkgen_mmcm_read(axi_clkgen, MMCM_REG_CLKOUT0_1, &reg);
 	dout = (reg & 0x3f) + ((reg >> 6) & 0x3f);
-	axi_clkgen_read(axi_clkgen, AXI_CLKGEN_REG_CLK_DIV, &reg);
+	axi_clkgen_mmcm_read(axi_clkgen, MMCM_REG_CLK_DIV, &reg);
 	d = (reg & 0x3f) + ((reg >> 6) & 0x3f);
-	axi_clkgen_read(axi_clkgen, AXI_CLKGEN_REG_CLK_FB1, &reg);
+	axi_clkgen_mmcm_read(axi_clkgen, MMCM_REG_CLK_FB1, &reg);
 	m = (reg & 0x3f) + ((reg >> 6) & 0x3f);
 
 	if (d == 0 || dout == 0)
@@ -255,14 +445,45 @@ static unsigned long axi_clkgen_recalc_rate(struct clk_hw *clk_hw,
 	return tmp;
 }
 
+static int axi_clkgen_enable(struct clk_hw *clk_hw)
+{
+	struct axi_clkgen *axi_clkgen = clk_hw_to_axi_clkgen(clk_hw);
+
+	axi_clkgen_mmcm_enable(axi_clkgen, true);
+
+	return 0;
+}
+
+static void axi_clkgen_disable(struct clk_hw *clk_hw)
+{
+	struct axi_clkgen *axi_clkgen = clk_hw_to_axi_clkgen(clk_hw);
+
+	axi_clkgen_mmcm_enable(axi_clkgen, false);
+}
+
 static const struct clk_ops axi_clkgen_ops = {
 	.recalc_rate = axi_clkgen_recalc_rate,
 	.round_rate = axi_clkgen_round_rate,
 	.set_rate = axi_clkgen_set_rate,
+	.enable = axi_clkgen_enable,
+	.disable = axi_clkgen_disable,
 };
 
+static const struct of_device_id axi_clkgen_ids[] = {
+	{
+		.compatible = "adi,axi-clkgen-1.00.a",
+		.data = &axi_clkgen_v1_mmcm_ops
+	}, {
+		.compatible = "adi,axi-clkgen-2.00.a",
+		.data = &axi_clkgen_v2_mmcm_ops,
+	},
+	{ },
+};
+MODULE_DEVICE_TABLE(of, axi_clkgen_ids);
+
 static int axi_clkgen_probe(struct platform_device *pdev)
 {
+	const struct of_device_id *id;
 	struct axi_clkgen *axi_clkgen;
 	struct clk_init_data init;
 	const char *parent_name;
@@ -270,10 +491,19 @@ static int axi_clkgen_probe(struct platform_device *pdev)
 	struct resource *mem;
 	struct clk *clk;
 
+	if (!pdev->dev.of_node)
+		return -ENODEV;
+
+	id = of_match_node(axi_clkgen_ids, pdev->dev.of_node);
+	if (!id)
+		return -ENODEV;
+
 	axi_clkgen = devm_kzalloc(&pdev->dev, sizeof(*axi_clkgen), GFP_KERNEL);
 	if (!axi_clkgen)
 		return -ENOMEM;
 
+	axi_clkgen->mmcm_ops = id->data;
+
 	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	axi_clkgen->base = devm_ioremap_resource(&pdev->dev, mem);
 	if (IS_ERR(axi_clkgen->base))
@@ -289,10 +519,12 @@ static int axi_clkgen_probe(struct platform_device *pdev)
 
 	init.name = clk_name;
 	init.ops = &axi_clkgen_ops;
-	init.flags = 0;
+	init.flags = CLK_SET_RATE_GATE;
 	init.parent_names = &parent_name;
 	init.num_parents = 1;
 
+	axi_clkgen_mmcm_enable(axi_clkgen, false);
+
 	axi_clkgen->clk_hw.init = &init;
 	clk = devm_clk_register(&pdev->dev, &axi_clkgen->clk_hw);
 	if (IS_ERR(clk))
@@ -309,12 +541,6 @@ static int axi_clkgen_remove(struct platform_device *pdev)
 	return 0;
 }
 
-static const struct of_device_id axi_clkgen_ids[] = {
-	{ .compatible = "adi,axi-clkgen-1.00.a" },
-	{ },
-};
-MODULE_DEVICE_TABLE(of, axi_clkgen_ids);
-
 static struct platform_driver axi_clkgen_driver = {
 	.driver = {
 		.name = "adi-axi-clkgen",
-- 
1.8.0

