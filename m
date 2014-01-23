Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932210AbaAWR5h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 12:57:37 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:34277 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753713AbaAWR5f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 12:57:35 -0500
From: Nishanth Menon <nm@ti.com>
To: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>
CC: <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Nishanth Menon <nm@ti.com>
Subject: [PATCH V4] regulator: ti-abb: Add support for interleaved LDO registers
Date: Thu, 23 Jan 2014 11:57:27 -0600
Message-ID: <1390499847-8822-1-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <20140123163428.GP17314@sirena.org.uk>
References: <20140123163428.GP17314@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Certain platforms such as DRA7 have quirky memory maps such as:
PRM_ABBLDO_DSPEVE_CTRL	0x4ae07e20
PRM_ABBLDO_IVA_CTRL	0x4ae07e24
other-registers
PRM_ABBLDO_DSPEVE_SETUP	0x4ae07e30
PRM_ABBLDO_IVA_SETUP	0x4ae07e34

These need the address range allocation to be either not reserved OR
unique allocation per register instance or use something like syscon
based solution.

By going with unique allocation per register, we are able to now have
a single compatible driver for all instances on all platforms which
use the IP block.

So, introduce a new "ti,abb-v3" compatible to allow for definitions
where explicit register definitions are provided, while maintaining
backward compatibility of older predefined register offsets provided
by "ti-abb-v1" and "ti-abb-v2".

As part of this change, we rename a few variables to indicate the
appropriate meaning.

Signed-off-by: Nishanth Menon <nm@ti.com>
---
Testing code and relevant dts changes(pending 3.14-rc1 tag):
	https://github.com/nmenon/linux-2.6-playground/commits/abb-rev-v3.14-rc1-vnext-20140123

changes in v4 (since v3):
	- minor documentation fixes
	- logic fix of v3 to picking up setup and control regs
	- completed testing on OMAP3630, OMAP4430, OMAP4460, OMAP5432, DRA7

v3: https://patchwork.kernel.org/patch/3529851/
v2: https://patchwork.kernel.org/patch/3525751/
v1: https://patchwork.kernel.org/patch/3500281/

 .../bindings/regulator/ti-abb-regulator.txt        |    6 +-
 drivers/regulator/ti-abb-regulator.c               |   86 +++++++++++++-------
 2 files changed, 62 insertions(+), 30 deletions(-)

diff --git a/Documentation/devicetree/bindings/regulator/ti-abb-regulator.txt b/Documentation/devicetree/bindings/regulator/ti-abb-regulator.txt
index 2e57a33..c58db75 100644
--- a/Documentation/devicetree/bindings/regulator/ti-abb-regulator.txt
+++ b/Documentation/devicetree/bindings/regulator/ti-abb-regulator.txt
@@ -4,10 +4,14 @@ Required Properties:
 - compatible: Should be one of:
   - "ti,abb-v1" for older SoCs like OMAP3
   - "ti,abb-v2" for newer SoCs like OMAP4, OMAP5
+  - "ti,abb-v3" for a generic definition where setup and control registers are
+     provided (example: DRA7)
 - reg: Address and length of the register set for the device. It contains
   the information of registers in the same order as described by reg-names
 - reg-names: Should contain the reg names
-  - "base-address"	- contains base address of ABB module
+  - "base-address"	- contains base address of ABB module (ti,abb-v1,ti,abb-v2)
+  - "control-address"	- contains control register address of ABB module (ti,abb-v3)
+  - "setup-address"	- contains setup register address of ABB module (ti,abb-v3)
   - "int-address"	- contains address of interrupt register for ABB module
   (also see Optional properties)
 - #address-cell: should be 0
diff --git a/drivers/regulator/ti-abb-regulator.c b/drivers/regulator/ti-abb-regulator.c
index b187b6b..a97d0c5 100644
--- a/drivers/regulator/ti-abb-regulator.c
+++ b/drivers/regulator/ti-abb-regulator.c
@@ -54,8 +54,8 @@ struct ti_abb_info {
 
 /**
  * struct ti_abb_reg - Register description for ABB block
- * @setup_reg:			setup register offset from base
- * @control_reg:		control register offset from base
+ * @setup_off:			setup register offset from base
+ * @control_off:		control register offset from base
  * @sr2_wtcnt_value_mask:	setup register- sr2_wtcnt_value mask
  * @fbb_sel_mask:		setup register- FBB sel mask
  * @rbb_sel_mask:		setup register- RBB sel mask
@@ -64,8 +64,8 @@ struct ti_abb_info {
  * @opp_sel_mask:		control register - mask for mode to operate
  */
 struct ti_abb_reg {
-	u32 setup_reg;
-	u32 control_reg;
+	u32 setup_off;
+	u32 control_off;
 
 	/* Setup register fields */
 	u32 sr2_wtcnt_value_mask;
@@ -83,6 +83,8 @@ struct ti_abb_reg {
  * @rdesc:			regulator descriptor
  * @clk:			clock(usually sysclk) supplying ABB block
  * @base:			base address of ABB block
+ * @setup_reg:			setup register of ABB block
+ * @control_reg:		control register of ABB block
  * @int_base:			interrupt register base address
  * @efuse_base:			(optional) efuse base address for ABB modes
  * @ldo_base:			(optional) LDOVBB vset override base address
@@ -99,6 +101,8 @@ struct ti_abb {
 	struct regulator_desc rdesc;
 	struct clk *clk;
 	void __iomem *base;
+	void __iomem *setup_reg;
+	void __iomem *control_reg;
 	void __iomem *int_base;
 	void __iomem *efuse_base;
 	void __iomem *ldo_base;
@@ -118,20 +122,18 @@ struct ti_abb {
  * ti_abb_rmw() - handy wrapper to set specific register bits
  * @mask:	mask for register field
  * @value:	value shifted to mask location and written
- * @offset:	offset of register
- * @base:	base address
+ * @reg:	register address
  *
  * Return: final register value (may be unused)
  */
-static inline u32 ti_abb_rmw(u32 mask, u32 value, u32 offset,
-			     void __iomem *base)
+static inline u32 ti_abb_rmw(u32 mask, u32 value, void __iomem *reg)
 {
 	u32 val;
 
-	val = readl(base + offset);
+	val = readl(reg);
 	val &= ~mask;
 	val |= (value << __ffs(mask)) & mask;
-	writel(val, base + offset);
+	writel(val, reg);
 
 	return val;
 }
@@ -263,21 +265,19 @@ static int ti_abb_set_opp(struct regulator_dev *rdev, struct ti_abb *abb,
 	if (ret)
 		goto out;
 
-	ti_abb_rmw(regs->fbb_sel_mask | regs->rbb_sel_mask, 0, regs->setup_reg,
-		   abb->base);
+	ti_abb_rmw(regs->fbb_sel_mask | regs->rbb_sel_mask, 0, abb->setup_reg);
 
 	switch (info->opp_sel) {
 	case TI_ABB_SLOW_OPP:
-		ti_abb_rmw(regs->rbb_sel_mask, 1, regs->setup_reg, abb->base);
+		ti_abb_rmw(regs->rbb_sel_mask, 1, abb->setup_reg);
 		break;
 	case TI_ABB_FAST_OPP:
-		ti_abb_rmw(regs->fbb_sel_mask, 1, regs->setup_reg, abb->base);
+		ti_abb_rmw(regs->fbb_sel_mask, 1, abb->setup_reg);
 		break;
 	}
 
 	/* program next state of ABB ldo */
-	ti_abb_rmw(regs->opp_sel_mask, info->opp_sel, regs->control_reg,
-		   abb->base);
+	ti_abb_rmw(regs->opp_sel_mask, info->opp_sel, abb->control_reg);
 
 	/*
 	 * program LDO VBB vset override if needed for !bypass mode
@@ -288,7 +288,7 @@ static int ti_abb_set_opp(struct regulator_dev *rdev, struct ti_abb *abb,
 		ti_abb_program_ldovbb(dev, abb, info);
 
 	/* Initiate ABB ldo change */
-	ti_abb_rmw(regs->opp_change_mask, 1, regs->control_reg, abb->base);
+	ti_abb_rmw(regs->opp_change_mask, 1, abb->control_reg);
 
 	/* Wait for ABB LDO to complete transition to new Bias setting */
 	ret = ti_abb_wait_txdone(dev, abb);
@@ -490,8 +490,7 @@ static int ti_abb_init_timings(struct device *dev, struct ti_abb *abb)
 	dev_dbg(dev, "%s: Clk_rate=%ld, sr2_cnt=0x%08x\n", __func__,
 		clk_get_rate(abb->clk), sr2_wt_cnt_val);
 
-	ti_abb_rmw(regs->sr2_wtcnt_value_mask, sr2_wt_cnt_val, regs->setup_reg,
-		   abb->base);
+	ti_abb_rmw(regs->sr2_wtcnt_value_mask, sr2_wt_cnt_val, abb->setup_reg);
 
 	return 0;
 }
@@ -648,8 +647,8 @@ static struct regulator_ops ti_abb_reg_ops = {
 /* Default ABB block offsets, IF this changes in future, create new one */
 static const struct ti_abb_reg abb_regs_v1 = {
 	/* WARNING: registers are wrongly documented in TRM */
-	.setup_reg		= 0x04,
-	.control_reg		= 0x00,
+	.setup_off		= 0x04,
+	.control_off		= 0x00,
 
 	.sr2_wtcnt_value_mask	= (0xff << 8),
 	.fbb_sel_mask		= (0x01 << 2),
@@ -661,8 +660,8 @@ static const struct ti_abb_reg abb_regs_v1 = {
 };
 
 static const struct ti_abb_reg abb_regs_v2 = {
-	.setup_reg		= 0x00,
-	.control_reg		= 0x04,
+	.setup_off		= 0x00,
+	.control_off		= 0x04,
 
 	.sr2_wtcnt_value_mask	= (0xff << 8),
 	.fbb_sel_mask		= (0x01 << 2),
@@ -673,9 +672,20 @@ static const struct ti_abb_reg abb_regs_v2 = {
 	.opp_sel_mask		= (0x03 << 0),
 };
 
+static const struct ti_abb_reg abb_regs_generic = {
+	.sr2_wtcnt_value_mask	= (0xff << 8),
+	.fbb_sel_mask		= (0x01 << 2),
+	.rbb_sel_mask		= (0x01 << 1),
+	.sr2_en_mask		= (0x01 << 0),
+
+	.opp_change_mask	= (0x01 << 2),
+	.opp_sel_mask		= (0x03 << 0),
+};
+
 static const struct of_device_id ti_abb_of_match[] = {
 	{.compatible = "ti,abb-v1", .data = &abb_regs_v1},
 	{.compatible = "ti,abb-v2", .data = &abb_regs_v2},
+	{.compatible = "ti,abb-v3", .data = &abb_regs_generic},
 	{ },
 };
 
@@ -722,11 +732,29 @@ static int ti_abb_probe(struct platform_device *pdev)
 	abb->regs = match->data;
 
 	/* Map ABB resources */
-	pname = "base-address";
-	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, pname);
-	abb->base = devm_ioremap_resource(dev, res);
-	if (IS_ERR(abb->base))
-		return PTR_ERR(abb->base);
+	if (abb->regs->setup_off || abb->regs->control_off) {
+		pname = "base-address";
+		res = platform_get_resource_byname(pdev, IORESOURCE_MEM, pname);
+		abb->base = devm_ioremap_resource(dev, res);
+		if (IS_ERR(abb->base))
+			return PTR_ERR(abb->base);
+
+		abb->setup_reg = abb->base + abb->regs->setup_off;
+		abb->control_reg = abb->base + abb->regs->control_off;
+
+	} else {
+		pname = "control-address";
+		res = platform_get_resource_byname(pdev, IORESOURCE_MEM, pname);
+		abb->control_reg = devm_ioremap_resource(dev, res);
+		if (IS_ERR(abb->control_reg))
+			return PTR_ERR(abb->control_reg);
+
+		pname = "setup-address";
+		res = platform_get_resource_byname(pdev, IORESOURCE_MEM, pname);
+		abb->setup_reg = devm_ioremap_resource(dev, res);
+		if (IS_ERR(abb->setup_reg))
+			return PTR_ERR(abb->setup_reg);
+	}
 
 	pname = "int-address";
 	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, pname);
@@ -860,7 +888,7 @@ skip_opt:
 	platform_set_drvdata(pdev, rdev);
 
 	/* Enable the ldo if not already done by bootloader */
-	ti_abb_rmw(abb->regs->sr2_en_mask, 1, abb->regs->setup_reg, abb->base);
+	ti_abb_rmw(abb->regs->sr2_en_mask, 1, abb->setup_reg);
 
 	return 0;
 }
-- 
1.7.9.5

