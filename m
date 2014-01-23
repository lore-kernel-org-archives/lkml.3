Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752734AbaAWQUP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 11:20:15 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:40118 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751407AbaAWQUM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 11:20:12 -0500
Date: Thu, 23 Jan 2014 10:20:09 -0600
From: Nishanth Menon <nm@ti.com>
To: Mark Brown <broonie@kernel.org>
CC: <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] regulator: ti-abb: Add support for interleaved LDO
 registers
Message-ID: <20140123162009.GA17432@kahuna>
References: <1389900750-27625-1-git-send-email-nm@ti.com>
 <20140121185553.GW17314@sirena.org.uk>
 <52DED341.3030503@ti.com>
 <20140121215624.GC17314@sirena.org.uk>
 <52DEF56C.1000209@ti.com>
 <20140122201932.GD17314@sirena.org.uk>
 <52E02E85.3030509@ti.com>
 <20140122222523.GA4999@kahuna>
 <20140123122959.GJ17314@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20140123122959.GJ17314@sirena.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12:29-20140123, Mark Brown wrote:
> On Wed, Jan 22, 2014 at 04:25:23PM -0600, Nishanth Menon wrote:
> 
> > How about something like the following? If this is acceptable, I can do
> > a complete round of retest and ensure everything is functional on all
> > platforms and post it as a formal patch:
> 
> Looks OK from a quick scan.  It seems nothing in mainline is using the
> -v2 binding so it's probably OK to delete it but if it's not too much
> bother it might be better to keep it since I expect some downstream
> trees might've picked that up already.
True - how about the following (formal post pending comprehensive
testing and your feedback on approach):

>From 35b0c999f7ef94bf92acc17e1086af22b187943a Mon Sep 17 00:00:00 2001
From: Nishanth Menon <nm@ti.com>
Date: Thu, 23 Jan 2014 10:00:22 -0600
Subject: [PATCH V3] regulator: ti-abb: Add support for interleaved LDO registers

Certain platforms such as DRA7 have quirky memory maps such as:
PRM_ABBLDO_DSPEVE_CTRL      0x4ae07e20
PRM_ABBLDO_IVA_CTRL 0x4ae07e24
other-registers
PRM_ABBLDO_DSPEVE_SETUP     0x4ae07e30
PRM_ABBLDO_IVA_SETUP        0x4ae07e34

These need the address range allocation to be either not reserved OR unique
allocation per register instance or use something like syscon based
solution.

By going with unique allocation per register, we are able to now have a
single compatible driver for all instances on all platforms which use
the IP block.

So, introduce a new "ti,abb-v3" compatible to allow for definitions
where explicit register definitions are provided, while maintaining
backward compatibility of older predefined register offsets provided
by "ti-abb-v1" and "ti-abb-v2".

Signed-off-by: Nishanth Menon <nm@ti.com>
---
 .../bindings/regulator/ti-abb-regulator.txt        |    6 +-
 drivers/regulator/ti-abb-regulator.c               |   91 +++++++++++++-------
 2 files changed, 67 insertions(+), 30 deletions(-)

diff --git a/Documentation/devicetree/bindings/regulator/ti-abb-regulator.txt b/Documentation/devicetree/bindings/regulator/ti-abb-regulator.txt
index 2e57a33..0d2dc26 100644
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
+  - "control-address"	- contains base address of ABB module (ti,abb-v3)
+  - "setup-address"	- contains base address of ABB module (ti,abb-v3)
   - "int-address"	- contains address of interrupt register for ABB module
   (also see Optional properties)
 - #address-cell: should be 0
diff --git a/drivers/regulator/ti-abb-regulator.c b/drivers/regulator/ti-abb-regulator.c
index b187b6b..134c481 100644
--- a/drivers/regulator/ti-abb-regulator.c
+++ b/drivers/regulator/ti-abb-regulator.c
@@ -54,8 +54,8 @@ struct ti_abb_info {
 
 /**
  * struct ti_abb_reg - Register description for ABB block
- * @setup_reg:			setup register offset from base
- * @control_reg:		control register offset from base
+ * @setup_off:			setup register offset from base
+ * @control_off:		setup register offset from base
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
+ * @control_reg:		setup register of ABB block
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
@@ -263,21 +265,20 @@ static int ti_abb_set_opp(struct regulator_dev *rdev, struct ti_abb *abb,
 	if (ret)
 		goto out;
 
-	ti_abb_rmw(regs->fbb_sel_mask | regs->rbb_sel_mask, 0, regs->setup_reg,
-		   abb->base);
+	ti_abb_rmw(regs->fbb_sel_mask | regs->rbb_sel_mask, 0,
+		   abb->setup_reg);
 
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
@@ -288,7 +289,7 @@ static int ti_abb_set_opp(struct regulator_dev *rdev, struct ti_abb *abb,
 		ti_abb_program_ldovbb(dev, abb, info);
 
 	/* Initiate ABB ldo change */
-	ti_abb_rmw(regs->opp_change_mask, 1, regs->control_reg, abb->base);
+	ti_abb_rmw(regs->opp_change_mask, 1, abb->control_reg);
 
 	/* Wait for ABB LDO to complete transition to new Bias setting */
 	ret = ti_abb_wait_txdone(dev, abb);
@@ -490,8 +491,8 @@ static int ti_abb_init_timings(struct device *dev, struct ti_abb *abb)
 	dev_dbg(dev, "%s: Clk_rate=%ld, sr2_cnt=0x%08x\n", __func__,
 		clk_get_rate(abb->clk), sr2_wt_cnt_val);
 
-	ti_abb_rmw(regs->sr2_wtcnt_value_mask, sr2_wt_cnt_val, regs->setup_reg,
-		   abb->base);
+	ti_abb_rmw(regs->sr2_wtcnt_value_mask, sr2_wt_cnt_val,
+		   abb->setup_reg);
 
 	return 0;
 }
@@ -648,8 +649,8 @@ static struct regulator_ops ti_abb_reg_ops = {
 /* Default ABB block offsets, IF this changes in future, create new one */
 static const struct ti_abb_reg abb_regs_v1 = {
 	/* WARNING: registers are wrongly documented in TRM */
-	.setup_reg		= 0x04,
-	.control_reg		= 0x00,
+	.setup_off		= 0x04,
+	.control_off		= 0x00,
 
 	.sr2_wtcnt_value_mask	= (0xff << 8),
 	.fbb_sel_mask		= (0x01 << 2),
@@ -661,8 +662,8 @@ static const struct ti_abb_reg abb_regs_v1 = {
 };
 
 static const struct ti_abb_reg abb_regs_v2 = {
-	.setup_reg		= 0x00,
-	.control_reg		= 0x04,
+	.setup_off		= 0x00,
+	.control_off		= 0x04,
 
 	.sr2_wtcnt_value_mask	= (0xff << 8),
 	.fbb_sel_mask		= (0x01 << 2),
@@ -673,9 +674,20 @@ static const struct ti_abb_reg abb_regs_v2 = {
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
 
@@ -719,14 +731,35 @@ static int ti_abb_probe(struct platform_device *pdev)
 	abb = devm_kzalloc(dev, sizeof(struct ti_abb), GFP_KERNEL);
 	if (!abb)
 		return -ENOMEM;
+	abb->regs = devm_kzalloc(dev, sizeof(struct ti_abb_reg), GFP_KERNEL);
+	if (!abb->regs)
+		return -ENOMEM;
 	abb->regs = match->data;
 
 	/* Map ABB resources */
-	pname = "base-address";
-	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, pname);
-	abb->base = devm_ioremap_resource(dev, res);
-	if (IS_ERR(abb->base))
-		return PTR_ERR(abb->base);
+	if (!abb->regs->setup_off && !abb->regs->control_off) {
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
@@ -860,7 +893,7 @@ skip_opt:
 	platform_set_drvdata(pdev, rdev);
 
 	/* Enable the ldo if not already done by bootloader */
-	ti_abb_rmw(abb->regs->sr2_en_mask, 1, abb->regs->setup_reg, abb->base);
+	ti_abb_rmw(abb->regs->sr2_en_mask, 1, abb->setup_reg);
 
 	return 0;
 }
-- 
1.7.9.5

-- 
Regards,
Nishanth Menon
