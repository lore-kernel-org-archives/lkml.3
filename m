Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755709AbaAVWZa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 17:25:30 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:39360 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753192AbaAVWZ0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 17:25:26 -0500
Date: Wed, 22 Jan 2014 16:25:23 -0600
From: Nishanth Menon <nm@ti.com>
To: Mark Brown <broonie@kernel.org>
CC: <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] regulator: ti-abb: Add support for interleaved LDO
 registers
Message-ID: <20140122222523.GA4999@kahuna>
References: <1389900750-27625-1-git-send-email-nm@ti.com>
 <20140121185553.GW17314@sirena.org.uk>
 <52DED341.3030503@ti.com>
 <20140121215624.GC17314@sirena.org.uk>
 <52DEF56C.1000209@ti.com>
 <20140122201932.GD17314@sirena.org.uk>
 <52E02E85.3030509@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <52E02E85.3030509@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14:48-20140122, Nishanth Menon wrote:
> On 01/22/2014 02:19 PM, Mark Brown wrote:
> > On Tue, Jan 21, 2014 at 04:32:12PM -0600, Nishanth Menon wrote:
> > 
> >> The other alternative will be to use reg-names and map individual
> >> registers (there are just setup and control registers to deal with per
> >> abb instance). That will coexist with other pinctrl, bandgap and other
> >> drivers which are not based off syscon.
> > 
> > Yes, I suspect that's going to be a lot easier to deploy given that
> > there are existing drivers using the current non-syscon setup.  I'm
> > totally fine with that approach.
> > 
> ok - thanks for confirming - this also means that existing compatible
> flags will have to change - but they were present solely to encode the
> offset of setup and control from each other.
> 
> Considering that we never had any dtsi in upstream (since they were
> all pending clock dts support for TI platforms), I will go with the
> assumption of not needing to maintain backward compatible for dtbs
> that could never have been generated in upstream kernel.

How about something like the following? If this is acceptable, I can do
a complete round of retest and ensure everything is functional on all
platforms and post it as a formal patch:

>From 510812eeb10d5dffe44aa896746468bcb7f17fe2 Mon Sep 17 00:00:00 2001
From: Nishanth Menon <nm@ti.com>
Date: Wed, 22 Jan 2014 16:06:57 -0600
Subject: [RFC PATCH] regulator: ti-abb: Add support for interleaved LDO registers

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

Signed-off-by: Nishanth Menon <nm@ti.com>
---
 .../bindings/regulator/ti-abb-regulator.txt        |    6 +-
 drivers/regulator/ti-abb-regulator.c               |   75 +++++++-------------
 2 files changed, 30 insertions(+), 51 deletions(-)

diff --git a/Documentation/devicetree/bindings/regulator/ti-abb-regulator.txt b/Documentation/devicetree/bindings/regulator/ti-abb-regulator.txt
index 2e57a33..395e279 100644
--- a/Documentation/devicetree/bindings/regulator/ti-abb-regulator.txt
+++ b/Documentation/devicetree/bindings/regulator/ti-abb-regulator.txt
@@ -2,12 +2,12 @@ Adaptive Body Bias(ABB) SoC internal LDO regulator for Texas Instruments SoCs
 
 Required Properties:
 - compatible: Should be one of:
-  - "ti,abb-v1" for older SoCs like OMAP3
-  - "ti,abb-v2" for newer SoCs like OMAP4, OMAP5
+  - "ti,abb-v1" for SoCs like OMAP3,4,5,DRA7
 - reg: Address and length of the register set for the device. It contains
   the information of registers in the same order as described by reg-names
 - reg-names: Should contain the reg names
-  - "base-address"	- contains base address of ABB module
+  - "control-address"	- contains control register address of ABB module
+  - "setup-address"	- contains setup register address of ABB module
   - "int-address"	- contains address of interrupt register for ABB module
   (also see Optional properties)
 - #address-cell: should be 0
diff --git a/drivers/regulator/ti-abb-regulator.c b/drivers/regulator/ti-abb-regulator.c
index b187b6b..aebad81 100644
--- a/drivers/regulator/ti-abb-regulator.c
+++ b/drivers/regulator/ti-abb-regulator.c
@@ -54,8 +54,6 @@ struct ti_abb_info {
 
 /**
  * struct ti_abb_reg - Register description for ABB block
- * @setup_reg:			setup register offset from base
- * @control_reg:		control register offset from base
  * @sr2_wtcnt_value_mask:	setup register- sr2_wtcnt_value mask
  * @fbb_sel_mask:		setup register- FBB sel mask
  * @rbb_sel_mask:		setup register- RBB sel mask
@@ -64,9 +62,6 @@ struct ti_abb_info {
  * @opp_sel_mask:		control register - mask for mode to operate
  */
 struct ti_abb_reg {
-	u32 setup_reg;
-	u32 control_reg;
-
 	/* Setup register fields */
 	u32 sr2_wtcnt_value_mask;
 	u32 fbb_sel_mask;
@@ -82,7 +77,8 @@ struct ti_abb_reg {
  * struct ti_abb - ABB instance data
  * @rdesc:			regulator descriptor
  * @clk:			clock(usually sysclk) supplying ABB block
- * @base:			base address of ABB block
+ * @control_reg:		control register of the ABB module
+ * @setup_reg:			setup register of the ABB module
  * @int_base:			interrupt register base address
  * @efuse_base:			(optional) efuse base address for ABB modes
  * @ldo_base:			(optional) LDOVBB vset override base address
@@ -98,7 +94,8 @@ struct ti_abb_reg {
 struct ti_abb {
 	struct regulator_desc rdesc;
 	struct clk *clk;
-	void __iomem *base;
+	void __iomem *setup_reg;
+	void __iomem *control_reg;
 	void __iomem *int_base;
 	void __iomem *efuse_base;
 	void __iomem *ldo_base;
@@ -118,20 +115,18 @@ struct ti_abb {
  * ti_abb_rmw() - handy wrapper to set specific register bits
  * @mask:	mask for register field
  * @value:	value shifted to mask location and written
- * @offset:	offset of register
- * @base:	base address
+ * @base:	register address
  *
  * Return: final register value (may be unused)
  */
-static inline u32 ti_abb_rmw(u32 mask, u32 value, u32 offset,
-			     void __iomem *base)
+static inline u32 ti_abb_rmw(u32 mask, u32 value, void __iomem *base)
 {
 	u32 val;
 
-	val = readl(base + offset);
+	val = readl(base);
 	val &= ~mask;
 	val |= (value << __ffs(mask)) & mask;
-	writel(val, base + offset);
+	writel(val, base);
 
 	return val;
 }
@@ -263,21 +258,19 @@ static int ti_abb_set_opp(struct regulator_dev *rdev, struct ti_abb *abb,
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
@@ -288,7 +281,7 @@ static int ti_abb_set_opp(struct regulator_dev *rdev, struct ti_abb *abb,
 		ti_abb_program_ldovbb(dev, abb, info);
 
 	/* Initiate ABB ldo change */
-	ti_abb_rmw(regs->opp_change_mask, 1, regs->control_reg, abb->base);
+	ti_abb_rmw(regs->opp_change_mask, 1, abb->control_reg);
 
 	/* Wait for ABB LDO to complete transition to new Bias setting */
 	ret = ti_abb_wait_txdone(dev, abb);
@@ -490,8 +483,7 @@ static int ti_abb_init_timings(struct device *dev, struct ti_abb *abb)
 	dev_dbg(dev, "%s: Clk_rate=%ld, sr2_cnt=0x%08x\n", __func__,
 		clk_get_rate(abb->clk), sr2_wt_cnt_val);
 
-	ti_abb_rmw(regs->sr2_wtcnt_value_mask, sr2_wt_cnt_val, regs->setup_reg,
-		   abb->base);
+	ti_abb_rmw(regs->sr2_wtcnt_value_mask, sr2_wt_cnt_val, abb->setup_reg);
 
 	return 0;
 }
@@ -645,25 +637,7 @@ static struct regulator_ops ti_abb_reg_ops = {
 	.get_voltage_sel = ti_abb_get_voltage_sel,
 };
 
-/* Default ABB block offsets, IF this changes in future, create new one */
-static const struct ti_abb_reg abb_regs_v1 = {
-	/* WARNING: registers are wrongly documented in TRM */
-	.setup_reg		= 0x04,
-	.control_reg		= 0x00,
-
-	.sr2_wtcnt_value_mask	= (0xff << 8),
-	.fbb_sel_mask		= (0x01 << 2),
-	.rbb_sel_mask		= (0x01 << 1),
-	.sr2_en_mask		= (0x01 << 0),
-
-	.opp_change_mask	= (0x01 << 2),
-	.opp_sel_mask		= (0x03 << 0),
-};
-
-static const struct ti_abb_reg abb_regs_v2 = {
-	.setup_reg		= 0x00,
-	.control_reg		= 0x04,
-
+static const struct ti_abb_reg abb_regs = {
 	.sr2_wtcnt_value_mask	= (0xff << 8),
 	.fbb_sel_mask		= (0x01 << 2),
 	.rbb_sel_mask		= (0x01 << 1),
@@ -674,8 +648,7 @@ static const struct ti_abb_reg abb_regs_v2 = {
 };
 
 static const struct of_device_id ti_abb_of_match[] = {
-	{.compatible = "ti,abb-v1", .data = &abb_regs_v1},
-	{.compatible = "ti,abb-v2", .data = &abb_regs_v2},
+	{.compatible = "ti,abb-v1", .data = &abb_regs},
 	{ },
 };
 
@@ -722,11 +695,17 @@ static int ti_abb_probe(struct platform_device *pdev)
 	abb->regs = match->data;
 
 	/* Map ABB resources */
-	pname = "base-address";
+	pname = "setup-address";
+	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, pname);
+	abb->setup_reg = devm_ioremap_resource(dev, res);
+	if (IS_ERR(abb->setup_reg))
+		return PTR_ERR(abb->setup_reg);
+
+	pname = "control-address";
 	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, pname);
-	abb->base = devm_ioremap_resource(dev, res);
-	if (IS_ERR(abb->base))
-		return PTR_ERR(abb->base);
+	abb->control_reg = devm_ioremap_resource(dev, res);
+	if (IS_ERR(abb->control_reg))
+		return PTR_ERR(abb->control_reg);
 
 	pname = "int-address";
 	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, pname);
@@ -860,7 +839,7 @@ skip_opt:
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
