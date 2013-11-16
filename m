Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754236Ab3KPAEO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 19:04:14 -0500
Received: from mail-ee0-f42.google.com ([74.125.83.42]:45605 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753801Ab3KPABz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 19:01:55 -0500
From: Taras Kondratiuk <taras.kondratiuk@linaro.org>
To: linux-omap@vger.kernel.org
Cc: linaro-networking@linaro.org, Victor Kamensky <victor.kamensky@linaro.org>,
        Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>, Paul Walmsley <paul@pwsan.com>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        =?UTF-8?q?Beno=C3=AEt=20Cousson?= <bcousson@baylibre.com>,
        Rajendra Nayak <rnayak@ti.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [RFC 17/23] ARM: OMAP2+: raw read and write endian fix
Date: Sat, 16 Nov 2013 02:01:20 +0200
Message-Id: <1384560086-11994-18-git-send-email-taras.kondratiuk@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1384560086-11994-1-git-send-email-taras.kondratiuk@linaro.org>
References: <1384560086-11994-1-git-send-email-taras.kondratiuk@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Victor Kamensky <victor.kamensky@linaro.org>

All OMAP IP blocks expect LE data, but CPU may operate in BE mode.
Need to use endian neutral functions to read/write h/w registers.
I.e instead of __raw_read[lw] and __raw_write[lw] functions code
need to use read[lw]_relaxed and write[lw]_relaxed functions.
If the first simply reads/writes register, the second will byteswap
it if host operates in BE mode.

Changes are trivial sed like replacement of __raw_xxx functions
with xxx_relaxed variant.

Signed-off-by: Victor Kamensky <victor.kamensky@linaro.org>
Signed-off-by: Taras Kondratiuk <taras.kondratiuk@linaro.org>
---
 arch/arm/mach-omap2/board-flash.c         |    4 +--
 arch/arm/mach-omap2/clkt2xxx_dpllcore.c   |    2 +-
 arch/arm/mach-omap2/clkt2xxx_osc.c        |    8 +++---
 arch/arm/mach-omap2/clkt2xxx_sys.c        |    2 +-
 arch/arm/mach-omap2/clkt_clksel.c         |   10 +++----
 arch/arm/mach-omap2/clkt_dpll.c           |    6 ++---
 arch/arm/mach-omap2/clkt_iclk.c           |    8 +++---
 arch/arm/mach-omap2/clock.c               |   16 +++++------
 arch/arm/mach-omap2/clock36xx.c           |    6 ++---
 arch/arm/mach-omap2/cm2xxx_3xxx.h         |    4 +--
 arch/arm/mach-omap2/cm33xx.c              |    4 +--
 arch/arm/mach-omap2/cm3xxx.c              |    8 +++---
 arch/arm/mach-omap2/cm44xx.c              |    8 +++---
 arch/arm/mach-omap2/cminst44xx.c          |    4 +--
 arch/arm/mach-omap2/control.c             |   20 +++++++-------
 arch/arm/mach-omap2/dma.c                 |    4 +--
 arch/arm/mach-omap2/dpll3xxx.c            |   32 +++++++++++-----------
 arch/arm/mach-omap2/dpll44xx.c            |   12 ++++-----
 arch/arm/mach-omap2/gpmc.c                |    8 +++---
 arch/arm/mach-omap2/id.c                  |    2 +-
 arch/arm/mach-omap2/irq.c                 |    4 +--
 arch/arm/mach-omap2/mux.c                 |    8 +++---
 arch/arm/mach-omap2/omap-hotplug.c        |    4 +--
 arch/arm/mach-omap2/omap-mpuss-lowpower.c |   18 ++++++-------
 arch/arm/mach-omap2/omap-smp.c            |    4 +--
 arch/arm/mach-omap2/omap-wakeupgen.c      |   42 ++++++++++++++---------------
 arch/arm/mach-omap2/omap4-common.c        |   16 +++++------
 arch/arm/mach-omap2/omap_hwmod.c          |   10 +++----
 arch/arm/mach-omap2/omap_phy_internal.c   |    6 ++---
 arch/arm/mach-omap2/prcm_mpu44xx.c        |    4 +--
 arch/arm/mach-omap2/prm2xxx.h             |    2 +-
 arch/arm/mach-omap2/prm2xxx_3xxx.h        |    4 +--
 arch/arm/mach-omap2/prm33xx.c             |    4 +--
 arch/arm/mach-omap2/prm3xxx.h             |    2 +-
 arch/arm/mach-omap2/prm44xx.c             |    4 +--
 arch/arm/mach-omap2/prminst44xx.c         |    4 +--
 arch/arm/mach-omap2/sdrc.h                |    8 +++---
 arch/arm/mach-omap2/sdrc2xxx.c            |    4 +--
 arch/arm/mach-omap2/sr_device.c           |    2 +-
 arch/arm/mach-omap2/sram.c                |   16 +++++------
 arch/arm/mach-omap2/timer.c               |    8 +++---
 arch/arm/mach-omap2/vc.c                  |    4 +--
 arch/arm/mach-omap2/wd_timer.c            |    8 +++---
 43 files changed, 177 insertions(+), 177 deletions(-)

diff --git a/arch/arm/mach-omap2/board-flash.c b/arch/arm/mach-omap2/board-flash.c
index fc20a61..17ecd8d 100644
--- a/arch/arm/mach-omap2/board-flash.c
+++ b/arch/arm/mach-omap2/board-flash.c
@@ -160,13 +160,13 @@ static u8 get_gpmc0_type(void)
 	if (!fpga_map_addr)
 		return -ENOMEM;
 
-	if (!(__raw_readw(fpga_map_addr + REG_FPGA_REV)))
+	if (!(readw_relaxed(fpga_map_addr + REG_FPGA_REV)))
 		/* we dont have an DEBUG FPGA??? */
 		/* Depend on #defines!! default to strata boot return param */
 		goto unmap;
 
 	/* S8-DIP-OFF = 1, S8-DIP-ON = 0 */
-	cs = __raw_readw(fpga_map_addr + REG_FPGA_DIP_SWITCH_INPUT2) & 0xf;
+	cs = readw_relaxed(fpga_map_addr + REG_FPGA_DIP_SWITCH_INPUT2) & 0xf;
 
 	/* ES2.0 SDP's onwards 4 dip switches are provided for CS */
 	if (omap_rev() >= OMAP3430_REV_ES1_0)
diff --git a/arch/arm/mach-omap2/clkt2xxx_dpllcore.c b/arch/arm/mach-omap2/clkt2xxx_dpllcore.c
index d862010..83933df 100644
--- a/arch/arm/mach-omap2/clkt2xxx_dpllcore.c
+++ b/arch/arm/mach-omap2/clkt2xxx_dpllcore.c
@@ -141,7 +141,7 @@ int omap2_reprogram_dpllcore(struct clk_hw *hw, unsigned long rate,
 		if (!dd)
 			return -EINVAL;
 
-		tmpset.cm_clksel1_pll = __raw_readl(dd->mult_div1_reg);
+		tmpset.cm_clksel1_pll = readl_relaxed(dd->mult_div1_reg);
 		tmpset.cm_clksel1_pll &= ~(dd->mult_mask |
 					   dd->div1_mask);
 		div = ((curr_prcm_set->xtal_speed / 1000000) - 1);
diff --git a/arch/arm/mach-omap2/clkt2xxx_osc.c b/arch/arm/mach-omap2/clkt2xxx_osc.c
index 19f54d4..0717dff 100644
--- a/arch/arm/mach-omap2/clkt2xxx_osc.c
+++ b/arch/arm/mach-omap2/clkt2xxx_osc.c
@@ -39,9 +39,9 @@ int omap2_enable_osc_ck(struct clk_hw *clk)
 {
 	u32 pcc;
 
-	pcc = __raw_readl(prcm_clksrc_ctrl);
+	pcc = readl_relaxed(prcm_clksrc_ctrl);
 
-	__raw_writel(pcc & ~OMAP_AUTOEXTCLKMODE_MASK, prcm_clksrc_ctrl);
+	writel_relaxed(pcc & ~OMAP_AUTOEXTCLKMODE_MASK, prcm_clksrc_ctrl);
 
 	return 0;
 }
@@ -57,9 +57,9 @@ void omap2_disable_osc_ck(struct clk_hw *clk)
 {
 	u32 pcc;
 
-	pcc = __raw_readl(prcm_clksrc_ctrl);
+	pcc = readl_relaxed(prcm_clksrc_ctrl);
 
-	__raw_writel(pcc | OMAP_AUTOEXTCLKMODE_MASK, prcm_clksrc_ctrl);
+	writel_relaxed(pcc | OMAP_AUTOEXTCLKMODE_MASK, prcm_clksrc_ctrl);
 }
 
 unsigned long omap2_osc_clk_recalc(struct clk_hw *clk,
diff --git a/arch/arm/mach-omap2/clkt2xxx_sys.c b/arch/arm/mach-omap2/clkt2xxx_sys.c
index f467d07..58dd3a9 100644
--- a/arch/arm/mach-omap2/clkt2xxx_sys.c
+++ b/arch/arm/mach-omap2/clkt2xxx_sys.c
@@ -33,7 +33,7 @@ u32 omap2xxx_get_sysclkdiv(void)
 {
 	u32 div;
 
-	div = __raw_readl(prcm_clksrc_ctrl);
+	div = readl_relaxed(prcm_clksrc_ctrl);
 	div &= OMAP_SYSCLKDIV_MASK;
 	div >>= OMAP_SYSCLKDIV_SHIFT;
 
diff --git a/arch/arm/mach-omap2/clkt_clksel.c b/arch/arm/mach-omap2/clkt_clksel.c
index 0ec9f6f..7ac0050 100644
--- a/arch/arm/mach-omap2/clkt_clksel.c
+++ b/arch/arm/mach-omap2/clkt_clksel.c
@@ -97,12 +97,12 @@ static void _write_clksel_reg(struct clk_hw_omap *clk, u32 field_val)
 {
 	u32 v;
 
-	v = __raw_readl(clk->clksel_reg);
+	v = readl_relaxed(clk->clksel_reg);
 	v &= ~clk->clksel_mask;
 	v |= field_val << __ffs(clk->clksel_mask);
-	__raw_writel(v, clk->clksel_reg);
+	writel_relaxed(v, clk->clksel_reg);
 
-	v = __raw_readl(clk->clksel_reg); /* OCP barrier */
+	v = readl_relaxed(clk->clksel_reg); /* OCP barrier */
 }
 
 /**
@@ -204,7 +204,7 @@ static u32 _read_divisor(struct clk_hw_omap *clk)
 	if (!clk->clksel || !clk->clksel_mask)
 		return 0;
 
-	v = __raw_readl(clk->clksel_reg);
+	v = readl_relaxed(clk->clksel_reg);
 	v &= clk->clksel_mask;
 	v >>= __ffs(clk->clksel_mask);
 
@@ -320,7 +320,7 @@ u8 omap2_clksel_find_parent_index(struct clk_hw *hw)
 	WARN((!clk->clksel || !clk->clksel_mask),
 	     "clock: %s: attempt to call on a non-clksel clock", clk_name);
 
-	r = __raw_readl(clk->clksel_reg) & clk->clksel_mask;
+	r = readl_relaxed(clk->clksel_reg) & clk->clksel_mask;
 	r >>= __ffs(clk->clksel_mask);
 
 	for (clks = clk->clksel; clks->parent && !found; clks++) {
diff --git a/arch/arm/mach-omap2/clkt_dpll.c b/arch/arm/mach-omap2/clkt_dpll.c
index 924c230..934e8f0 100644
--- a/arch/arm/mach-omap2/clkt_dpll.c
+++ b/arch/arm/mach-omap2/clkt_dpll.c
@@ -196,7 +196,7 @@ u8 omap2_init_dpll_parent(struct clk_hw *hw)
 	if (!dd)
 		return -EINVAL;
 
-	v = __raw_readl(dd->control_reg);
+	v = readl_relaxed(dd->control_reg);
 	v &= dd->enable_mask;
 	v >>= __ffs(dd->enable_mask);
 
@@ -243,7 +243,7 @@ unsigned long omap2_get_dpll_rate(struct clk_hw_omap *clk)
 		return 0;
 
 	/* Return bypass rate if DPLL is bypassed */
-	v = __raw_readl(dd->control_reg);
+	v = readl_relaxed(dd->control_reg);
 	v &= dd->enable_mask;
 	v >>= __ffs(dd->enable_mask);
 
@@ -262,7 +262,7 @@ unsigned long omap2_get_dpll_rate(struct clk_hw_omap *clk)
 			return __clk_get_rate(dd->clk_bypass);
 	}
 
-	v = __raw_readl(dd->mult_div1_reg);
+	v = readl_relaxed(dd->mult_div1_reg);
 	dpll_mult = v & dd->mult_mask;
 	dpll_mult >>= __ffs(dd->mult_mask);
 	dpll_div = v & dd->div1_mask;
diff --git a/arch/arm/mach-omap2/clkt_iclk.c b/arch/arm/mach-omap2/clkt_iclk.c
index f10eb03..70fe2c1 100644
--- a/arch/arm/mach-omap2/clkt_iclk.c
+++ b/arch/arm/mach-omap2/clkt_iclk.c
@@ -29,9 +29,9 @@ void omap2_clkt_iclk_allow_idle(struct clk_hw_omap *clk)
 
 	r = ((__force u32)clk->enable_reg ^ (CM_AUTOIDLE ^ CM_ICLKEN));
 
-	v = __raw_readl((__force void __iomem *)r);
+	v = readl_relaxed((__force void __iomem *)r);
 	v |= (1 << clk->enable_bit);
-	__raw_writel(v, (__force void __iomem *)r);
+	writel_relaxed(v, (__force void __iomem *)r);
 }
 
 /* XXX */
@@ -41,9 +41,9 @@ void omap2_clkt_iclk_deny_idle(struct clk_hw_omap *clk)
 
 	r = ((__force u32)clk->enable_reg ^ (CM_AUTOIDLE ^ CM_ICLKEN));
 
-	v = __raw_readl((__force void __iomem *)r);
+	v = readl_relaxed((__force void __iomem *)r);
 	v &= ~(1 << clk->enable_bit);
-	__raw_writel(v, (__force void __iomem *)r);
+	writel_relaxed(v, (__force void __iomem *)r);
 }
 
 /* Public data */
diff --git a/arch/arm/mach-omap2/clock.c b/arch/arm/mach-omap2/clock.c
index 0c38ca9..5e191be 100644
--- a/arch/arm/mach-omap2/clock.c
+++ b/arch/arm/mach-omap2/clock.c
@@ -105,7 +105,7 @@ static int _wait_idlest_generic(void __iomem *reg, u32 mask, u8 idlest,
 
 	ena = (idlest) ? 0 : mask;
 
-	omap_test_timeout(((__raw_readl(reg) & mask) == ena),
+	omap_test_timeout(((readl_relaxed(reg) & mask) == ena),
 			  MAX_MODULE_ENABLE_WAIT, i);
 
 	if (i < MAX_MODULE_ENABLE_WAIT)
@@ -138,7 +138,7 @@ static void _omap2_module_wait_ready(struct clk_hw_omap *clk)
 	/* Not all modules have multiple clocks that their IDLEST depends on */
 	if (clk->ops->find_companion) {
 		clk->ops->find_companion(clk, &companion_reg, &other_bit);
-		if (!(__raw_readl(companion_reg) & (1 << other_bit)))
+		if (!(readl_relaxed(companion_reg) & (1 << other_bit)))
 			return;
 	}
 
@@ -309,13 +309,13 @@ int omap2_dflt_clk_enable(struct clk_hw *hw)
 	}
 
 	/* FIXME should not have INVERT_ENABLE bit here */
-	v = __raw_readl(clk->enable_reg);
+	v = readl_relaxed(clk->enable_reg);
 	if (clk->flags & INVERT_ENABLE)
 		v &= ~(1 << clk->enable_bit);
 	else
 		v |= (1 << clk->enable_bit);
-	__raw_writel(v, clk->enable_reg);
-	v = __raw_readl(clk->enable_reg); /* OCP barrier */
+	writel_relaxed(v, clk->enable_reg);
+	v = readl_relaxed(clk->enable_reg); /* OCP barrier */
 
 	if (clk->ops && clk->ops->find_idlest)
 		_omap2_module_wait_ready(clk);
@@ -353,12 +353,12 @@ void omap2_dflt_clk_disable(struct clk_hw *hw)
 		return;
 	}
 
-	v = __raw_readl(clk->enable_reg);
+	v = readl_relaxed(clk->enable_reg);
 	if (clk->flags & INVERT_ENABLE)
 		v |= (1 << clk->enable_bit);
 	else
 		v &= ~(1 << clk->enable_bit);
-	__raw_writel(v, clk->enable_reg);
+	writel_relaxed(v, clk->enable_reg);
 	/* No OCP barrier needed here since it is a disable operation */
 
 	if (clkdm_control && clk->clkdm)
@@ -454,7 +454,7 @@ int omap2_dflt_clk_is_enabled(struct clk_hw *hw)
 	struct clk_hw_omap *clk = to_clk_hw_omap(hw);
 	u32 v;
 
-	v = __raw_readl(clk->enable_reg);
+	v = readl_relaxed(clk->enable_reg);
 
 	if (clk->flags & INVERT_ENABLE)
 		v ^= BIT(clk->enable_bit);
diff --git a/arch/arm/mach-omap2/clock36xx.c b/arch/arm/mach-omap2/clock36xx.c
index bbd6a3f..bdd228a 100644
--- a/arch/arm/mach-omap2/clock36xx.c
+++ b/arch/arm/mach-omap2/clock36xx.c
@@ -53,15 +53,15 @@ int omap36xx_pwrdn_clk_enable_with_hsdiv_restore(struct clk_hw *clk)
 
 	/* Restore the dividers */
 	if (!ret) {
-		orig_v = __raw_readl(parent->reg);
+		orig_v = readl_relaxed(parent->reg);
 		dummy_v = orig_v;
 
 		/* Write any other value different from the Read value */
 		dummy_v ^= (1 << parent->shift);
-		__raw_writel(dummy_v, parent->reg);
+		writel_relaxed(dummy_v, parent->reg);
 
 		/* Write the original divider */
-		__raw_writel(orig_v, parent->reg);
+		writel_relaxed(orig_v, parent->reg);
 	}
 
 	return ret;
diff --git a/arch/arm/mach-omap2/cm2xxx_3xxx.h b/arch/arm/mach-omap2/cm2xxx_3xxx.h
index bfbd16f..72928a3 100644
--- a/arch/arm/mach-omap2/cm2xxx_3xxx.h
+++ b/arch/arm/mach-omap2/cm2xxx_3xxx.h
@@ -52,12 +52,12 @@
 
 static inline u32 omap2_cm_read_mod_reg(s16 module, u16 idx)
 {
-	return __raw_readl(cm_base + module + idx);
+	return readl_relaxed(cm_base + module + idx);
 }
 
 static inline void omap2_cm_write_mod_reg(u32 val, s16 module, u16 idx)
 {
-	__raw_writel(val, cm_base + module + idx);
+	writel_relaxed(val, cm_base + module + idx);
 }
 
 /* Read-modify-write a register in a CM module. Caller must lock */
diff --git a/arch/arm/mach-omap2/cm33xx.c b/arch/arm/mach-omap2/cm33xx.c
index 325a515..74a0935 100644
--- a/arch/arm/mach-omap2/cm33xx.c
+++ b/arch/arm/mach-omap2/cm33xx.c
@@ -50,13 +50,13 @@
 /* Read a register in a CM instance */
 static inline u32 am33xx_cm_read_reg(s16 inst, u16 idx)
 {
-	return __raw_readl(cm_base + inst + idx);
+	return readl_relaxed(cm_base + inst + idx);
 }
 
 /* Write into a register in a CM */
 static inline void am33xx_cm_write_reg(u32 val, s16 inst, u16 idx)
 {
-	__raw_writel(val, cm_base + inst + idx);
+	writel_relaxed(val, cm_base + inst + idx);
 }
 
 /* Read-modify-write a register in CM */
diff --git a/arch/arm/mach-omap2/cm3xxx.c b/arch/arm/mach-omap2/cm3xxx.c
index 9061c30..85d9842 100644
--- a/arch/arm/mach-omap2/cm3xxx.c
+++ b/arch/arm/mach-omap2/cm3xxx.c
@@ -388,7 +388,7 @@ void omap3_cm_save_context(void)
 		omap2_cm_read_mod_reg(OMAP3430_IVA2_MOD, CM_CLKSEL1);
 	cm_context.iva2_cm_clksel2 =
 		omap2_cm_read_mod_reg(OMAP3430_IVA2_MOD, CM_CLKSEL2);
-	cm_context.cm_sysconfig = __raw_readl(OMAP3430_CM_SYSCONFIG);
+	cm_context.cm_sysconfig = readl_relaxed(OMAP3430_CM_SYSCONFIG);
 	cm_context.sgx_cm_clksel =
 		omap2_cm_read_mod_reg(OMAP3430ES2_SGX_MOD, CM_CLKSEL);
 	cm_context.dss_cm_clksel =
@@ -418,7 +418,7 @@ void omap3_cm_save_context(void)
 		omap2_cm_read_mod_reg(PLL_MOD, OMAP3430ES2_CM_CLKSEL5);
 	cm_context.pll_cm_clken2 =
 		omap2_cm_read_mod_reg(PLL_MOD, OMAP3430ES2_CM_CLKEN2);
-	cm_context.cm_polctrl = __raw_readl(OMAP3430_CM_POLCTRL);
+	cm_context.cm_polctrl = readl_relaxed(OMAP3430_CM_POLCTRL);
 	cm_context.iva2_cm_fclken =
 		omap2_cm_read_mod_reg(OMAP3430_IVA2_MOD, CM_FCLKEN);
 	cm_context.iva2_cm_clken_pll =
@@ -519,7 +519,7 @@ void omap3_cm_restore_context(void)
 			       CM_CLKSEL1);
 	omap2_cm_write_mod_reg(cm_context.iva2_cm_clksel2, OMAP3430_IVA2_MOD,
 			       CM_CLKSEL2);
-	__raw_writel(cm_context.cm_sysconfig, OMAP3430_CM_SYSCONFIG);
+	writel_relaxed(cm_context.cm_sysconfig, OMAP3430_CM_SYSCONFIG);
 	omap2_cm_write_mod_reg(cm_context.sgx_cm_clksel, OMAP3430ES2_SGX_MOD,
 			       CM_CLKSEL);
 	omap2_cm_write_mod_reg(cm_context.dss_cm_clksel, OMAP3430_DSS_MOD,
@@ -547,7 +547,7 @@ void omap3_cm_restore_context(void)
 			       OMAP3430ES2_CM_CLKSEL5);
 	omap2_cm_write_mod_reg(cm_context.pll_cm_clken2, PLL_MOD,
 			       OMAP3430ES2_CM_CLKEN2);
-	__raw_writel(cm_context.cm_polctrl, OMAP3430_CM_POLCTRL);
+	writel_relaxed(cm_context.cm_polctrl, OMAP3430_CM_POLCTRL);
 	omap2_cm_write_mod_reg(cm_context.iva2_cm_fclken, OMAP3430_IVA2_MOD,
 			       CM_FCLKEN);
 	omap2_cm_write_mod_reg(cm_context.iva2_cm_clken_pll, OMAP3430_IVA2_MOD,
diff --git a/arch/arm/mach-omap2/cm44xx.c b/arch/arm/mach-omap2/cm44xx.c
index 535d66e..30b6d97 100644
--- a/arch/arm/mach-omap2/cm44xx.c
+++ b/arch/arm/mach-omap2/cm44xx.c
@@ -30,23 +30,23 @@
 /* Read a register in CM1 */
 u32 omap4_cm1_read_inst_reg(s16 inst, u16 reg)
 {
-	return __raw_readl(OMAP44XX_CM1_REGADDR(inst, reg));
+	return readl_relaxed(OMAP44XX_CM1_REGADDR(inst, reg));
 }
 
 /* Write into a register in CM1 */
 void omap4_cm1_write_inst_reg(u32 val, s16 inst, u16 reg)
 {
-	__raw_writel(val, OMAP44XX_CM1_REGADDR(inst, reg));
+	writel_relaxed(val, OMAP44XX_CM1_REGADDR(inst, reg));
 }
 
 /* Read a register in CM2 */
 u32 omap4_cm2_read_inst_reg(s16 inst, u16 reg)
 {
-	return __raw_readl(OMAP44XX_CM2_REGADDR(inst, reg));
+	return readl_relaxed(OMAP44XX_CM2_REGADDR(inst, reg));
 }
 
 /* Write into a register in CM2 */
 void omap4_cm2_write_inst_reg(u32 val, s16 inst, u16 reg)
 {
-	__raw_writel(val, OMAP44XX_CM2_REGADDR(inst, reg));
+	writel_relaxed(val, OMAP44XX_CM2_REGADDR(inst, reg));
 }
diff --git a/arch/arm/mach-omap2/cminst44xx.c b/arch/arm/mach-omap2/cminst44xx.c
index f0290f5..c026d3c 100644
--- a/arch/arm/mach-omap2/cminst44xx.c
+++ b/arch/arm/mach-omap2/cminst44xx.c
@@ -116,7 +116,7 @@ u32 omap4_cminst_read_inst_reg(u8 part, s16 inst, u16 idx)
 	BUG_ON(part >= OMAP4_MAX_PRCM_PARTITIONS ||
 	       part == OMAP4430_INVALID_PRCM_PARTITION ||
 	       !_cm_bases[part]);
-	return __raw_readl(_cm_bases[part] + inst + idx);
+	return readl_relaxed(_cm_bases[part] + inst + idx);
 }
 
 /* Write into a register in a CM instance */
@@ -125,7 +125,7 @@ void omap4_cminst_write_inst_reg(u32 val, u8 part, s16 inst, u16 idx)
 	BUG_ON(part >= OMAP4_MAX_PRCM_PARTITIONS ||
 	       part == OMAP4430_INVALID_PRCM_PARTITION ||
 	       !_cm_bases[part]);
-	__raw_writel(val, _cm_bases[part] + inst + idx);
+	writel_relaxed(val, _cm_bases[part] + inst + idx);
 }
 
 /* Read-modify-write a register in CM1. Caller must lock */
diff --git a/arch/arm/mach-omap2/control.c b/arch/arm/mach-omap2/control.c
index 31e0dfe..5d91945 100644
--- a/arch/arm/mach-omap2/control.c
+++ b/arch/arm/mach-omap2/control.c
@@ -161,32 +161,32 @@ void __iomem *omap_ctrl_base_get(void)
 
 u8 omap_ctrl_readb(u16 offset)
 {
-	return __raw_readb(OMAP_CTRL_REGADDR(offset));
+	return readb_relaxed(OMAP_CTRL_REGADDR(offset));
 }
 
 u16 omap_ctrl_readw(u16 offset)
 {
-	return __raw_readw(OMAP_CTRL_REGADDR(offset));
+	return readw_relaxed(OMAP_CTRL_REGADDR(offset));
 }
 
 u32 omap_ctrl_readl(u16 offset)
 {
-	return __raw_readl(OMAP_CTRL_REGADDR(offset));
+	return readl_relaxed(OMAP_CTRL_REGADDR(offset));
 }
 
 void omap_ctrl_writeb(u8 val, u16 offset)
 {
-	__raw_writeb(val, OMAP_CTRL_REGADDR(offset));
+	writeb_relaxed(val, OMAP_CTRL_REGADDR(offset));
 }
 
 void omap_ctrl_writew(u16 val, u16 offset)
 {
-	__raw_writew(val, OMAP_CTRL_REGADDR(offset));
+	writew_relaxed(val, OMAP_CTRL_REGADDR(offset));
 }
 
 void omap_ctrl_writel(u32 val, u16 offset)
 {
-	__raw_writel(val, OMAP_CTRL_REGADDR(offset));
+	writel_relaxed(val, OMAP_CTRL_REGADDR(offset));
 }
 
 /*
@@ -198,12 +198,12 @@ void omap_ctrl_writel(u32 val, u16 offset)
 
 u32 omap4_ctrl_pad_readl(u16 offset)
 {
-	return __raw_readl(OMAP4_CTRL_PAD_REGADDR(offset));
+	return readl_relaxed(OMAP4_CTRL_PAD_REGADDR(offset));
 }
 
 void omap4_ctrl_pad_writel(u32 val, u16 offset)
 {
-	__raw_writel(val, OMAP4_CTRL_PAD_REGADDR(offset));
+	writel_relaxed(val, OMAP4_CTRL_PAD_REGADDR(offset));
 }
 
 #ifdef CONFIG_ARCH_OMAP3
@@ -232,7 +232,7 @@ void omap3_ctrl_write_boot_mode(u8 bootmode)
 	 *
 	 * XXX This should use some omap_ctrl_writel()-type function
 	 */
-	__raw_writel(l, OMAP2_L4_IO_ADDRESS(OMAP343X_SCRATCHPAD + 4));
+	writel_relaxed(l, OMAP2_L4_IO_ADDRESS(OMAP343X_SCRATCHPAD + 4));
 }
 
 #endif
@@ -295,7 +295,7 @@ void omap3_clear_scratchpad_contents(void)
 	if (omap2_prm_read_mod_reg(OMAP3430_GR_MOD, OMAP3_PRM_RSTST_OFFSET) &
 	    OMAP3430_GLOBAL_COLD_RST_MASK) {
 		for ( ; offset <= max_offset; offset += 0x4)
-			__raw_writel(0x0, (v_addr + offset));
+			writel_relaxed(0x0, (v_addr + offset));
 		omap2_prm_set_mod_reg_bits(OMAP3430_GLOBAL_COLD_RST_MASK,
 					   OMAP3430_GR_MOD,
 					   OMAP3_PRM_RSTST_OFFSET);
diff --git a/arch/arm/mach-omap2/dma.c b/arch/arm/mach-omap2/dma.c
index 49fd0d5..2582ed2 100644
--- a/arch/arm/mach-omap2/dma.c
+++ b/arch/arm/mach-omap2/dma.c
@@ -98,7 +98,7 @@ static inline void dma_write(u32 val, int reg, int lch)
 
 	stride = (reg >= dma_common_ch_start) ? dma_stride : 0;
 	offset = reg_map[reg] + (stride * lch);
-	__raw_writel(val, dma_base + offset);
+	writel_relaxed(val, dma_base + offset);
 }
 
 static inline u32 dma_read(int reg, int lch)
@@ -108,7 +108,7 @@ static inline u32 dma_read(int reg, int lch)
 
 	stride = (reg >= dma_common_ch_start) ? dma_stride : 0;
 	offset = reg_map[reg] + (stride * lch);
-	val = __raw_readl(dma_base + offset);
+	val = readl_relaxed(dma_base + offset);
 	return val;
 }
 
diff --git a/arch/arm/mach-omap2/dpll3xxx.c b/arch/arm/mach-omap2/dpll3xxx.c
index 3a0296c..d3fe570 100644
--- a/arch/arm/mach-omap2/dpll3xxx.c
+++ b/arch/arm/mach-omap2/dpll3xxx.c
@@ -50,10 +50,10 @@ static void _omap3_dpll_write_clken(struct clk_hw_omap *clk, u8 clken_bits)
 
 	dd = clk->dpll_data;
 
-	v = __raw_readl(dd->control_reg);
+	v = readl_relaxed(dd->control_reg);
 	v &= ~dd->enable_mask;
 	v |= clken_bits << __ffs(dd->enable_mask);
-	__raw_writel(v, dd->control_reg);
+	writel_relaxed(v, dd->control_reg);
 }
 
 /* _omap3_wait_dpll_status: wait for a DPLL to enter a specific state */
@@ -69,7 +69,7 @@ static int _omap3_wait_dpll_status(struct clk_hw_omap *clk, u8 state)
 
 	state <<= __ffs(dd->idlest_mask);
 
-	while (((__raw_readl(dd->idlest_reg) & dd->idlest_mask) != state) &&
+	while (((readl_relaxed(dd->idlest_reg) & dd->idlest_mask) != state) &&
 	       i < MAX_DPLL_WAIT_TRIES) {
 		i++;
 		udelay(1);
@@ -147,7 +147,7 @@ static int _omap3_noncore_dpll_lock(struct clk_hw_omap *clk)
 	state <<= __ffs(dd->idlest_mask);
 
 	/* Check if already locked */
-	if ((__raw_readl(dd->idlest_reg) & dd->idlest_mask) == state)
+	if ((readl_relaxed(dd->idlest_reg) & dd->idlest_mask) == state)
 		goto done;
 
 	ai = omap3_dpll_autoidle_read(clk);
@@ -311,14 +311,14 @@ static int omap3_noncore_dpll_program(struct clk_hw_omap *clk, u16 freqsel)
 	 * only since freqsel field is no longer present on other devices.
 	 */
 	if (cpu_is_omap343x()) {
-		v = __raw_readl(dd->control_reg);
+		v = readl_relaxed(dd->control_reg);
 		v &= ~dd->freqsel_mask;
 		v |= freqsel << __ffs(dd->freqsel_mask);
-		__raw_writel(v, dd->control_reg);
+		writel_relaxed(v, dd->control_reg);
 	}
 
 	/* Set DPLL multiplier, divider */
-	v = __raw_readl(dd->mult_div1_reg);
+	v = readl_relaxed(dd->mult_div1_reg);
 	v &= ~(dd->mult_mask | dd->div1_mask);
 	v |= dd->last_rounded_m << __ffs(dd->mult_mask);
 	v |= (dd->last_rounded_n - 1) << __ffs(dd->div1_mask);
@@ -336,11 +336,11 @@ static int omap3_noncore_dpll_program(struct clk_hw_omap *clk, u16 freqsel)
 		v |= sd_div << __ffs(dd->sddiv_mask);
 	}
 
-	__raw_writel(v, dd->mult_div1_reg);
+	writel_relaxed(v, dd->mult_div1_reg);
 
 	/* Set 4X multiplier and low-power mode */
 	if (dd->m4xen_mask || dd->lpmode_mask) {
-		v = __raw_readl(dd->control_reg);
+		v = readl_relaxed(dd->control_reg);
 
 		if (dd->m4xen_mask) {
 			if (dd->last_rounded_m4xen)
@@ -356,7 +356,7 @@ static int omap3_noncore_dpll_program(struct clk_hw_omap *clk, u16 freqsel)
 				v &= ~dd->lpmode_mask;
 		}
 
-		__raw_writel(v, dd->control_reg);
+		writel_relaxed(v, dd->control_reg);
 	}
 
 	/* We let the clock framework set the other output dividers later */
@@ -554,7 +554,7 @@ u32 omap3_dpll_autoidle_read(struct clk_hw_omap *clk)
 	if (!dd->autoidle_reg)
 		return -EINVAL;
 
-	v = __raw_readl(dd->autoidle_reg);
+	v = readl_relaxed(dd->autoidle_reg);
 	v &= dd->autoidle_mask;
 	v >>= __ffs(dd->autoidle_mask);
 
@@ -588,10 +588,10 @@ void omap3_dpll_allow_idle(struct clk_hw_omap *clk)
 	 * by writing 0x5 instead of 0x1.  Add some mechanism to
 	 * optionally enter this mode.
 	 */
-	v = __raw_readl(dd->autoidle_reg);
+	v = readl_relaxed(dd->autoidle_reg);
 	v &= ~dd->autoidle_mask;
 	v |= DPLL_AUTOIDLE_LOW_POWER_STOP << __ffs(dd->autoidle_mask);
-	__raw_writel(v, dd->autoidle_reg);
+	writel_relaxed(v, dd->autoidle_reg);
 
 }
 
@@ -614,10 +614,10 @@ void omap3_dpll_deny_idle(struct clk_hw_omap *clk)
 	if (!dd->autoidle_reg)
 		return;
 
-	v = __raw_readl(dd->autoidle_reg);
+	v = readl_relaxed(dd->autoidle_reg);
 	v &= ~dd->autoidle_mask;
 	v |= DPLL_AUTOIDLE_DISABLE << __ffs(dd->autoidle_mask);
-	__raw_writel(v, dd->autoidle_reg);
+	writel_relaxed(v, dd->autoidle_reg);
 
 }
 
@@ -660,7 +660,7 @@ unsigned long omap3_clkoutx2_recalc(struct clk_hw *hw,
 
 	WARN_ON(!dd->enable_mask);
 
-	v = __raw_readl(dd->control_reg) & dd->enable_mask;
+	v = readl_relaxed(dd->control_reg) & dd->enable_mask;
 	v >>= __ffs(dd->enable_mask);
 	if ((v != OMAP3XXX_EN_DPLL_LOCKED) || (dd->flags & DPLL_J_TYPE))
 		rate = parent_rate;
diff --git a/arch/arm/mach-omap2/dpll44xx.c b/arch/arm/mach-omap2/dpll44xx.c
index d28b0f7..9562383 100644
--- a/arch/arm/mach-omap2/dpll44xx.c
+++ b/arch/arm/mach-omap2/dpll44xx.c
@@ -42,7 +42,7 @@ int omap4_dpllmx_gatectrl_read(struct clk_hw_omap *clk)
 			OMAP4430_DPLL_CLKOUTX2_GATE_CTRL_MASK :
 			OMAP4430_DPLL_CLKOUT_GATE_CTRL_MASK;
 
-	v = __raw_readl(clk->clksel_reg);
+	v = readl_relaxed(clk->clksel_reg);
 	v &= mask;
 	v >>= __ffs(mask);
 
@@ -61,10 +61,10 @@ void omap4_dpllmx_allow_gatectrl(struct clk_hw_omap *clk)
 			OMAP4430_DPLL_CLKOUTX2_GATE_CTRL_MASK :
 			OMAP4430_DPLL_CLKOUT_GATE_CTRL_MASK;
 
-	v = __raw_readl(clk->clksel_reg);
+	v = readl_relaxed(clk->clksel_reg);
 	/* Clear the bit to allow gatectrl */
 	v &= ~mask;
-	__raw_writel(v, clk->clksel_reg);
+	writel_relaxed(v, clk->clksel_reg);
 }
 
 void omap4_dpllmx_deny_gatectrl(struct clk_hw_omap *clk)
@@ -79,10 +79,10 @@ void omap4_dpllmx_deny_gatectrl(struct clk_hw_omap *clk)
 			OMAP4430_DPLL_CLKOUTX2_GATE_CTRL_MASK :
 			OMAP4430_DPLL_CLKOUT_GATE_CTRL_MASK;
 
-	v = __raw_readl(clk->clksel_reg);
+	v = readl_relaxed(clk->clksel_reg);
 	/* Set the bit to deny gatectrl */
 	v |= mask;
-	__raw_writel(v, clk->clksel_reg);
+	writel_relaxed(v, clk->clksel_reg);
 }
 
 const struct clk_hw_omap_ops clkhwops_omap4_dpllmx = {
@@ -140,7 +140,7 @@ unsigned long omap4_dpll_regm4xen_recalc(struct clk_hw *hw,
 	rate = omap2_get_dpll_rate(clk);
 
 	/* regm4xen adds a multiplier of 4 to DPLL calculations */
-	v = __raw_readl(dd->control_reg);
+	v = readl_relaxed(dd->control_reg);
 	if (v & OMAP4430_DPLL_REGM4XEN_MASK)
 		rate *= OMAP4430_REGM4XEN_MULT;
 
diff --git a/arch/arm/mach-omap2/gpmc.c b/arch/arm/mach-omap2/gpmc.c
index 579697a..55e381e 100644
--- a/arch/arm/mach-omap2/gpmc.c
+++ b/arch/arm/mach-omap2/gpmc.c
@@ -170,12 +170,12 @@ static irqreturn_t gpmc_handle_irq(int irq, void *dev);
 
 static void gpmc_write_reg(int idx, u32 val)
 {
-	__raw_writel(val, gpmc_base + idx);
+	writel_relaxed(val, gpmc_base + idx);
 }
 
 static u32 gpmc_read_reg(int idx)
 {
-	return __raw_readl(gpmc_base + idx);
+	return readl_relaxed(gpmc_base + idx);
 }
 
 void gpmc_cs_write_reg(int cs, int idx, u32 val)
@@ -183,7 +183,7 @@ void gpmc_cs_write_reg(int cs, int idx, u32 val)
 	void __iomem *reg_addr;
 
 	reg_addr = gpmc_base + GPMC_CS0_OFFSET + (cs * GPMC_CS_SIZE) + idx;
-	__raw_writel(val, reg_addr);
+	writel_relaxed(val, reg_addr);
 }
 
 static u32 gpmc_cs_read_reg(int cs, int idx)
@@ -191,7 +191,7 @@ static u32 gpmc_cs_read_reg(int cs, int idx)
 	void __iomem *reg_addr;
 
 	reg_addr = gpmc_base + GPMC_CS0_OFFSET + (cs * GPMC_CS_SIZE) + idx;
-	return __raw_readl(reg_addr);
+	return readl_relaxed(reg_addr);
 }
 
 /* TODO: Add support for gpmc_fck to clock framework and use it */
diff --git a/arch/arm/mach-omap2/id.c b/arch/arm/mach-omap2/id.c
index 0289adc..5bf2dc7 100644
--- a/arch/arm/mach-omap2/id.c
+++ b/arch/arm/mach-omap2/id.c
@@ -93,7 +93,7 @@ EXPORT_SYMBOL(omap_type);
 #define OMAP_TAP_DIE_ID_44XX_2	0x020c
 #define OMAP_TAP_DIE_ID_44XX_3	0x0210
 
-#define read_tap_reg(reg)	__raw_readl(tap_base  + (reg))
+#define read_tap_reg(reg)	readl_relaxed(tap_base  + (reg))
 
 struct omap_id {
 	u16	hawkeye;	/* Silicon type (Hawkeye id) */
diff --git a/arch/arm/mach-omap2/irq.c b/arch/arm/mach-omap2/irq.c
index 3926f37..411b197 100644
--- a/arch/arm/mach-omap2/irq.c
+++ b/arch/arm/mach-omap2/irq.c
@@ -83,12 +83,12 @@ struct omap3_intc_regs {
 
 static void intc_bank_write_reg(u32 val, struct omap_irq_bank *bank, u16 reg)
 {
-	__raw_writel(val, bank->base_reg + reg);
+	writel_relaxed(val, bank->base_reg + reg);
 }
 
 static u32 intc_bank_read_reg(struct omap_irq_bank *bank, u16 reg)
 {
-	return __raw_readl(bank->base_reg + reg);
+	return readl_relaxed(bank->base_reg + reg);
 }
 
 /* XXX: FIQ and additional INTC support (only MPU at the moment) */
diff --git a/arch/arm/mach-omap2/mux.c b/arch/arm/mach-omap2/mux.c
index f82cf87..216f051 100644
--- a/arch/arm/mach-omap2/mux.c
+++ b/arch/arm/mach-omap2/mux.c
@@ -70,18 +70,18 @@ struct omap_mux_partition *omap_mux_get(const char *name)
 u16 omap_mux_read(struct omap_mux_partition *partition, u16 reg)
 {
 	if (partition->flags & OMAP_MUX_REG_8BIT)
-		return __raw_readb(partition->base + reg);
+		return readb_relaxed(partition->base + reg);
 	else
-		return __raw_readw(partition->base + reg);
+		return readw_relaxed(partition->base + reg);
 }
 
 void omap_mux_write(struct omap_mux_partition *partition, u16 val,
 			   u16 reg)
 {
 	if (partition->flags & OMAP_MUX_REG_8BIT)
-		__raw_writeb(val, partition->base + reg);
+		writeb_relaxed(val, partition->base + reg);
 	else
-		__raw_writew(val, partition->base + reg);
+		writew_relaxed(val, partition->base + reg);
 }
 
 void omap_mux_write_array(struct omap_mux_partition *partition,
diff --git a/arch/arm/mach-omap2/omap-hotplug.c b/arch/arm/mach-omap2/omap-hotplug.c
index 458f72f..971791f 100644
--- a/arch/arm/mach-omap2/omap-hotplug.c
+++ b/arch/arm/mach-omap2/omap-hotplug.c
@@ -39,7 +39,7 @@ void __ref omap4_cpu_die(unsigned int cpu)
 		if (omap_modify_auxcoreboot0(0x0, 0x200) != 0x0)
 			pr_err("Secure clear status failed\n");
 	} else {
-		__raw_writel(0, base + OMAP_AUX_CORE_BOOT_0);
+		writel_relaxed(0, base + OMAP_AUX_CORE_BOOT_0);
 	}
 
 
@@ -53,7 +53,7 @@ void __ref omap4_cpu_die(unsigned int cpu)
 			boot_cpu = omap_read_auxcoreboot0();
 		else
 			boot_cpu =
-				__raw_readl(base + OMAP_AUX_CORE_BOOT_0) >> 5;
+				readl_relaxed(base + OMAP_AUX_CORE_BOOT_0) >> 5;
 
 		if (boot_cpu == smp_processor_id()) {
 			/*
diff --git a/arch/arm/mach-omap2/omap-mpuss-lowpower.c b/arch/arm/mach-omap2/omap-mpuss-lowpower.c
index f991016..6358257 100644
--- a/arch/arm/mach-omap2/omap-mpuss-lowpower.c
+++ b/arch/arm/mach-omap2/omap-mpuss-lowpower.c
@@ -116,7 +116,7 @@ static inline void set_cpu_wakeup_addr(unsigned int cpu_id, u32 addr)
 {
 	struct omap4_cpu_pm_info *pm_info = &per_cpu(omap4_pm_info, cpu_id);
 
-	__raw_writel(addr, pm_info->wkup_sar_addr);
+	writel_relaxed(addr, pm_info->wkup_sar_addr);
 }
 
 /*
@@ -141,7 +141,7 @@ static void scu_pwrst_prepare(unsigned int cpu_id, unsigned int cpu_state)
 		break;
 	}
 
-	__raw_writel(scu_pwr_st, pm_info->scu_sar_addr);
+	writel_relaxed(scu_pwr_st, pm_info->scu_sar_addr);
 }
 
 /* Helper functions for MPUSS OSWR */
@@ -179,7 +179,7 @@ static void l2x0_pwrst_prepare(unsigned int cpu_id, unsigned int save_state)
 {
 	struct omap4_cpu_pm_info *pm_info = &per_cpu(omap4_pm_info, cpu_id);
 
-	__raw_writel(save_state, pm_info->l2x0_sar_addr);
+	writel_relaxed(save_state, pm_info->l2x0_sar_addr);
 }
 
 /*
@@ -192,10 +192,10 @@ static void save_l2x0_context(void)
 	u32 val;
 	void __iomem *l2x0_base = omap4_get_l2cache_base();
 	if (l2x0_base) {
-		val = __raw_readl(l2x0_base + L2X0_AUX_CTRL);
-		__raw_writel(val, sar_base + L2X0_AUXCTRL_OFFSET);
-		val = __raw_readl(l2x0_base + L2X0_PREFETCH_CTRL);
-		__raw_writel(val, sar_base + L2X0_PREFETCH_CTRL_OFFSET);
+		val = readl_relaxed(l2x0_base + L2X0_AUX_CTRL);
+		writel_relaxed(val, sar_base + L2X0_AUXCTRL_OFFSET);
+		val = readl_relaxed(l2x0_base + L2X0_PREFETCH_CTRL);
+		writel_relaxed(val, sar_base + L2X0_PREFETCH_CTRL_OFFSET);
 	}
 }
 #else
@@ -383,9 +383,9 @@ int __init omap4_mpuss_init(void)
 
 	/* Save device type on scratchpad for low level code to use */
 	if (omap_type() != OMAP2_DEVICE_TYPE_GP)
-		__raw_writel(1, sar_base + OMAP_TYPE_OFFSET);
+		writel_relaxed(1, sar_base + OMAP_TYPE_OFFSET);
 	else
-		__raw_writel(0, sar_base + OMAP_TYPE_OFFSET);
+		writel_relaxed(0, sar_base + OMAP_TYPE_OFFSET);
 
 	save_l2x0_context();
 
diff --git a/arch/arm/mach-omap2/omap-smp.c b/arch/arm/mach-omap2/omap-smp.c
index 8912110..0622542 100644
--- a/arch/arm/mach-omap2/omap-smp.c
+++ b/arch/arm/mach-omap2/omap-smp.c
@@ -94,7 +94,7 @@ static int omap4_boot_secondary(unsigned int cpu, struct task_struct *idle)
 	if (omap_secure_apis_support())
 		omap_modify_auxcoreboot0(0x200, 0xfffffdff);
 	else
-		__raw_writel(0x20, base + OMAP_AUX_CORE_BOOT_0);
+		writel_relaxed(0x20, base + OMAP_AUX_CORE_BOOT_0);
 
 	if (!cpu1_clkdm && !cpu1_pwrdm) {
 		cpu1_clkdm = clkdm_lookup("mpu1_clkdm");
@@ -224,7 +224,7 @@ static void __init omap4_smp_prepare_cpus(unsigned int max_cpus)
 	if (omap_secure_apis_support())
 		omap_auxcoreboot_addr(virt_to_phys(startup_addr));
 	else
-		__raw_writel(virt_to_phys(omap5_secondary_startup),
+		writel_relaxed(virt_to_phys(omap5_secondary_startup),
 						base + OMAP_AUX_CORE_BOOT_1);
 
 }
diff --git a/arch/arm/mach-omap2/omap-wakeupgen.c b/arch/arm/mach-omap2/omap-wakeupgen.c
index 813c615..6f5665a 100644
--- a/arch/arm/mach-omap2/omap-wakeupgen.c
+++ b/arch/arm/mach-omap2/omap-wakeupgen.c
@@ -56,19 +56,19 @@ static unsigned int omap_secure_apis;
  */
 static inline u32 wakeupgen_readl(u8 idx, u32 cpu)
 {
-	return __raw_readl(wakeupgen_base + OMAP_WKG_ENB_A_0 +
+	return readl_relaxed(wakeupgen_base + OMAP_WKG_ENB_A_0 +
 				(cpu * CPU_ENA_OFFSET) + (idx * 4));
 }
 
 static inline void wakeupgen_writel(u32 val, u8 idx, u32 cpu)
 {
-	__raw_writel(val, wakeupgen_base + OMAP_WKG_ENB_A_0 +
+	writel_relaxed(val, wakeupgen_base + OMAP_WKG_ENB_A_0 +
 				(cpu * CPU_ENA_OFFSET) + (idx * 4));
 }
 
 static inline void sar_writel(u32 val, u32 offset, u8 idx)
 {
-	__raw_writel(val, sar_base + offset + (idx * 4));
+	writel_relaxed(val, sar_base + offset + (idx * 4));
 }
 
 static inline int _wakeupgen_get_irq_info(u32 irq, u32 *bit_posn, u8 *reg_index)
@@ -227,21 +227,21 @@ static inline void omap4_irq_save_context(void)
 	}
 
 	/* Save AuxBoot* registers */
-	val = __raw_readl(wakeupgen_base + OMAP_AUX_CORE_BOOT_0);
-	__raw_writel(val, sar_base + AUXCOREBOOT0_OFFSET);
-	val = __raw_readl(wakeupgen_base + OMAP_AUX_CORE_BOOT_1);
-	__raw_writel(val, sar_base + AUXCOREBOOT1_OFFSET);
+	val = readl_relaxed(wakeupgen_base + OMAP_AUX_CORE_BOOT_0);
+	writel_relaxed(val, sar_base + AUXCOREBOOT0_OFFSET);
+	val = readl_relaxed(wakeupgen_base + OMAP_AUX_CORE_BOOT_1);
+	writel_relaxed(val, sar_base + AUXCOREBOOT1_OFFSET);
 
 	/* Save SyncReq generation logic */
-	val = __raw_readl(wakeupgen_base + OMAP_PTMSYNCREQ_MASK);
-	__raw_writel(val, sar_base + PTMSYNCREQ_MASK_OFFSET);
-	val = __raw_readl(wakeupgen_base + OMAP_PTMSYNCREQ_EN);
-	__raw_writel(val, sar_base + PTMSYNCREQ_EN_OFFSET);
+	val = readl_relaxed(wakeupgen_base + OMAP_PTMSYNCREQ_MASK);
+	writel_relaxed(val, sar_base + PTMSYNCREQ_MASK_OFFSET);
+	val = readl_relaxed(wakeupgen_base + OMAP_PTMSYNCREQ_EN);
+	writel_relaxed(val, sar_base + PTMSYNCREQ_EN_OFFSET);
 
 	/* Set the Backup Bit Mask status */
-	val = __raw_readl(sar_base + SAR_BACKUP_STATUS_OFFSET);
+	val = readl_relaxed(sar_base + SAR_BACKUP_STATUS_OFFSET);
 	val |= SAR_BACKUP_STATUS_WAKEUPGEN;
-	__raw_writel(val, sar_base + SAR_BACKUP_STATUS_OFFSET);
+	writel_relaxed(val, sar_base + SAR_BACKUP_STATUS_OFFSET);
 
 }
 
@@ -260,15 +260,15 @@ static inline void omap5_irq_save_context(void)
 	}
 
 	/* Save AuxBoot* registers */
-	val = __raw_readl(wakeupgen_base + OMAP_AUX_CORE_BOOT_0);
-	__raw_writel(val, sar_base + OMAP5_AUXCOREBOOT0_OFFSET);
-	val = __raw_readl(wakeupgen_base + OMAP_AUX_CORE_BOOT_0);
-	__raw_writel(val, sar_base + OMAP5_AUXCOREBOOT1_OFFSET);
+	val = readl_relaxed(wakeupgen_base + OMAP_AUX_CORE_BOOT_0);
+	writel_relaxed(val, sar_base + OMAP5_AUXCOREBOOT0_OFFSET);
+	val = readl_relaxed(wakeupgen_base + OMAP_AUX_CORE_BOOT_0);
+	writel_relaxed(val, sar_base + OMAP5_AUXCOREBOOT1_OFFSET);
 
 	/* Set the Backup Bit Mask status */
-	val = __raw_readl(sar_base + OMAP5_SAR_BACKUP_STATUS_OFFSET);
+	val = readl_relaxed(sar_base + OMAP5_SAR_BACKUP_STATUS_OFFSET);
 	val |= SAR_BACKUP_STATUS_WAKEUPGEN;
-	__raw_writel(val, sar_base + OMAP5_SAR_BACKUP_STATUS_OFFSET);
+	writel_relaxed(val, sar_base + OMAP5_SAR_BACKUP_STATUS_OFFSET);
 
 }
 
@@ -302,9 +302,9 @@ static void irq_sar_clear(void)
 	if (soc_is_omap54xx())
 		offset = OMAP5_SAR_BACKUP_STATUS_OFFSET;
 
-	val = __raw_readl(sar_base + offset);
+	val = readl_relaxed(sar_base + offset);
 	val &= ~SAR_BACKUP_STATUS_WAKEUPGEN;
-	__raw_writel(val, sar_base + offset);
+	writel_relaxed(val, sar_base + offset);
 }
 
 /*
diff --git a/arch/arm/mach-omap2/omap4-common.c b/arch/arm/mach-omap2/omap4-common.c
index 5791143..2840d1e 100644
--- a/arch/arm/mach-omap2/omap4-common.c
+++ b/arch/arm/mach-omap2/omap4-common.c
@@ -125,19 +125,19 @@ void __init gic_init_irq(void)
 void gic_dist_disable(void)
 {
 	if (gic_dist_base_addr)
-		__raw_writel(0x0, gic_dist_base_addr + GIC_DIST_CTRL);
+		writel_relaxed(0x0, gic_dist_base_addr + GIC_DIST_CTRL);
 }
 
 bool gic_dist_disabled(void)
 {
-	return !(__raw_readl(gic_dist_base_addr + GIC_DIST_CTRL) & 0x1);
+	return !(readl_relaxed(gic_dist_base_addr + GIC_DIST_CTRL) & 0x1);
 }
 
 void gic_timer_retrigger(void)
 {
-	u32 twd_int = __raw_readl(twd_base + TWD_TIMER_INTSTAT);
-	u32 gic_int = __raw_readl(gic_dist_base_addr + GIC_DIST_PENDING_SET);
-	u32 twd_ctrl = __raw_readl(twd_base + TWD_TIMER_CONTROL);
+	u32 twd_int = readl_relaxed(twd_base + TWD_TIMER_INTSTAT);
+	u32 gic_int = readl_relaxed(gic_dist_base_addr + GIC_DIST_PENDING_SET);
+	u32 twd_ctrl = readl_relaxed(twd_base + TWD_TIMER_CONTROL);
 
 	if (twd_int && !(gic_int & BIT(IRQ_LOCALTIMER))) {
 		/*
@@ -145,11 +145,11 @@ void gic_timer_retrigger(void)
 		 * disabled.  Ack the pending interrupt, and retrigger it.
 		 */
 		pr_warn("%s: lost localtimer interrupt\n", __func__);
-		__raw_writel(1, twd_base + TWD_TIMER_INTSTAT);
+		writel_relaxed(1, twd_base + TWD_TIMER_INTSTAT);
 		if (!(twd_ctrl & TWD_TIMER_CONTROL_PERIODIC)) {
-			__raw_writel(1, twd_base + TWD_TIMER_COUNTER);
+			writel_relaxed(1, twd_base + TWD_TIMER_COUNTER);
 			twd_ctrl |= TWD_TIMER_CONTROL_ENABLE;
-			__raw_writel(twd_ctrl, twd_base + TWD_TIMER_CONTROL);
+			writel_relaxed(twd_ctrl, twd_base + TWD_TIMER_CONTROL);
 		}
 	}
 }
diff --git a/arch/arm/mach-omap2/omap_hwmod.c b/arch/arm/mach-omap2/omap_hwmod.c
index d9ee0ff..645dc40 100644
--- a/arch/arm/mach-omap2/omap_hwmod.c
+++ b/arch/arm/mach-omap2/omap_hwmod.c
@@ -72,7 +72,7 @@
  *            | (../mach-omap2/omap_hwmod*)   |
  *            +-------------------------------+
  *            | OMAP clock/PRCM/register fns  |
- *            | (__raw_{read,write}l, clk*)   |
+ *            | ({read,write}l_relaxed, clk*) |
  *            +-------------------------------+
  *
  * Device drivers should not contain any OMAP-specific code or data in
@@ -3114,17 +3114,17 @@ static int _am33xx_is_hardreset_asserted(struct omap_hwmod *oh,
 u32 omap_hwmod_read(struct omap_hwmod *oh, u16 reg_offs)
 {
 	if (oh->flags & HWMOD_16BIT_REG)
-		return __raw_readw(oh->_mpu_rt_va + reg_offs);
+		return readw_relaxed(oh->_mpu_rt_va + reg_offs);
 	else
-		return __raw_readl(oh->_mpu_rt_va + reg_offs);
+		return readl_relaxed(oh->_mpu_rt_va + reg_offs);
 }
 
 void omap_hwmod_write(u32 v, struct omap_hwmod *oh, u16 reg_offs)
 {
 	if (oh->flags & HWMOD_16BIT_REG)
-		__raw_writew(v, oh->_mpu_rt_va + reg_offs);
+		writew_relaxed(v, oh->_mpu_rt_va + reg_offs);
 	else
-		__raw_writel(v, oh->_mpu_rt_va + reg_offs);
+		writel_relaxed(v, oh->_mpu_rt_va + reg_offs);
 }
 
 /**
diff --git a/arch/arm/mach-omap2/omap_phy_internal.c b/arch/arm/mach-omap2/omap_phy_internal.c
index eb8a25d..50640b3 100644
--- a/arch/arm/mach-omap2/omap_phy_internal.c
+++ b/arch/arm/mach-omap2/omap_phy_internal.c
@@ -57,7 +57,7 @@ static int __init omap4430_phy_power_down(void)
 	}
 
 	/* Power down the phy */
-	__raw_writel(PHY_PD, ctrl_base + CONTROL_DEV_CONF);
+	writel_relaxed(PHY_PD, ctrl_base + CONTROL_DEV_CONF);
 
 	iounmap(ctrl_base);
 
@@ -162,7 +162,7 @@ void ti81xx_musb_phy_power(u8 on)
 		return;
 	}
 
-	usbphycfg = __raw_readl(scm_base + USBCTRL0);
+	usbphycfg = readl_relaxed(scm_base + USBCTRL0);
 
 	if (on) {
 		if (cpu_is_ti816x()) {
@@ -181,7 +181,7 @@ void ti81xx_musb_phy_power(u8 on)
 			usbphycfg |= USBPHY_CM_PWRDN | USBPHY_OTG_PWRDN;
 
 	}
-	__raw_writel(usbphycfg, scm_base + USBCTRL0);
+	writel_relaxed(usbphycfg, scm_base + USBCTRL0);
 
 	iounmap(scm_base);
 }
diff --git a/arch/arm/mach-omap2/prcm_mpu44xx.c b/arch/arm/mach-omap2/prcm_mpu44xx.c
index c30e44a..cdbee63 100644
--- a/arch/arm/mach-omap2/prcm_mpu44xx.c
+++ b/arch/arm/mach-omap2/prcm_mpu44xx.c
@@ -30,12 +30,12 @@ void __iomem *prcm_mpu_base;
 
 u32 omap4_prcm_mpu_read_inst_reg(s16 inst, u16 reg)
 {
-	return __raw_readl(OMAP44XX_PRCM_MPU_REGADDR(inst, reg));
+	return readl_relaxed(OMAP44XX_PRCM_MPU_REGADDR(inst, reg));
 }
 
 void omap4_prcm_mpu_write_inst_reg(u32 val, s16 inst, u16 reg)
 {
-	__raw_writel(val, OMAP44XX_PRCM_MPU_REGADDR(inst, reg));
+	writel_relaxed(val, OMAP44XX_PRCM_MPU_REGADDR(inst, reg));
 }
 
 u32 omap4_prcm_mpu_rmw_inst_reg_bits(u32 mask, u32 bits, s16 inst, s16 reg)
diff --git a/arch/arm/mach-omap2/prm2xxx.h b/arch/arm/mach-omap2/prm2xxx.h
index 3194dd8..d2cb636 100644
--- a/arch/arm/mach-omap2/prm2xxx.h
+++ b/arch/arm/mach-omap2/prm2xxx.h
@@ -27,7 +27,7 @@
 
 /*
  * OMAP2-specific global PRM registers
- * Use __raw_{read,write}l() with these registers.
+ * Use {read,write}l_relaxed() with these registers.
  *
  * With a few exceptions, these are the register names beginning with
  * PRCM_* on 24xx.  (The exceptions are the IRQSTATUS and IRQENABLE
diff --git a/arch/arm/mach-omap2/prm2xxx_3xxx.h b/arch/arm/mach-omap2/prm2xxx_3xxx.h
index 9624b40..1a3a963 100644
--- a/arch/arm/mach-omap2/prm2xxx_3xxx.h
+++ b/arch/arm/mach-omap2/prm2xxx_3xxx.h
@@ -55,12 +55,12 @@
 /* Power/reset management domain register get/set */
 static inline u32 omap2_prm_read_mod_reg(s16 module, u16 idx)
 {
-	return __raw_readl(prm_base + module + idx);
+	return readl_relaxed(prm_base + module + idx);
 }
 
 static inline void omap2_prm_write_mod_reg(u32 val, s16 module, u16 idx)
 {
-	__raw_writel(val, prm_base + module + idx);
+	writel_relaxed(val, prm_base + module + idx);
 }
 
 /* Read-modify-write a register in a PRM module. Caller must lock */
diff --git a/arch/arm/mach-omap2/prm33xx.c b/arch/arm/mach-omap2/prm33xx.c
index 7204407..93ba48a 100644
--- a/arch/arm/mach-omap2/prm33xx.c
+++ b/arch/arm/mach-omap2/prm33xx.c
@@ -27,13 +27,13 @@
 /* Read a register in a PRM instance */
 u32 am33xx_prm_read_reg(s16 inst, u16 idx)
 {
-	return __raw_readl(prm_base + inst + idx);
+	return readl_relaxed(prm_base + inst + idx);
 }
 
 /* Write into a register in a PRM instance */
 void am33xx_prm_write_reg(u32 val, s16 inst, u16 idx)
 {
-	__raw_writel(val, prm_base + inst + idx);
+	writel_relaxed(val, prm_base + inst + idx);
 }
 
 /* Read-modify-write a register in PRM. Caller must lock */
diff --git a/arch/arm/mach-omap2/prm3xxx.h b/arch/arm/mach-omap2/prm3xxx.h
index 277f717..f20e5c9 100644
--- a/arch/arm/mach-omap2/prm3xxx.h
+++ b/arch/arm/mach-omap2/prm3xxx.h
@@ -26,7 +26,7 @@
 
 /*
  * OMAP3-specific global PRM registers
- * Use __raw_{read,write}l() with these registers.
+ * Use {read,write}l_relaxed() with these registers.
  *
  * With a few exceptions, these are the register names beginning with
  * PRM_* on 34xx.  (The exceptions are the IRQSTATUS and IRQENABLE
diff --git a/arch/arm/mach-omap2/prm44xx.c b/arch/arm/mach-omap2/prm44xx.c
index 03a6034..94a43b3 100644
--- a/arch/arm/mach-omap2/prm44xx.c
+++ b/arch/arm/mach-omap2/prm44xx.c
@@ -81,13 +81,13 @@ static struct prm_reset_src_map omap44xx_prm_reset_src_map[] = {
 /* Read a register in a CM/PRM instance in the PRM module */
 u32 omap4_prm_read_inst_reg(s16 inst, u16 reg)
 {
-	return __raw_readl(prm_base + inst + reg);
+	return readl_relaxed(prm_base + inst + reg);
 }
 
 /* Write into a register in a CM/PRM instance in the PRM module */
 void omap4_prm_write_inst_reg(u32 val, s16 inst, u16 reg)
 {
-	__raw_writel(val, prm_base + inst + reg);
+	writel_relaxed(val, prm_base + inst + reg);
 }
 
 /* Read-modify-write a register in a PRM module. Caller must lock */
diff --git a/arch/arm/mach-omap2/prminst44xx.c b/arch/arm/mach-omap2/prminst44xx.c
index 6334b96..0e08425 100644
--- a/arch/arm/mach-omap2/prminst44xx.c
+++ b/arch/arm/mach-omap2/prminst44xx.c
@@ -48,7 +48,7 @@ u32 omap4_prminst_read_inst_reg(u8 part, s16 inst, u16 idx)
 	BUG_ON(part >= OMAP4_MAX_PRCM_PARTITIONS ||
 	       part == OMAP4430_INVALID_PRCM_PARTITION ||
 	       !_prm_bases[part]);
-	return __raw_readl(_prm_bases[part] + inst + idx);
+	return readl_relaxed(_prm_bases[part] + inst + idx);
 }
 
 /* Write into a register in a PRM instance */
@@ -57,7 +57,7 @@ void omap4_prminst_write_inst_reg(u32 val, u8 part, s16 inst, u16 idx)
 	BUG_ON(part >= OMAP4_MAX_PRCM_PARTITIONS ||
 	       part == OMAP4430_INVALID_PRCM_PARTITION ||
 	       !_prm_bases[part]);
-	__raw_writel(val, _prm_bases[part] + inst + idx);
+	writel_relaxed(val, _prm_bases[part] + inst + idx);
 }
 
 /* Read-modify-write a register in PRM. Caller must lock */
diff --git a/arch/arm/mach-omap2/sdrc.h b/arch/arm/mach-omap2/sdrc.h
index 446aa13..645a2a4 100644
--- a/arch/arm/mach-omap2/sdrc.h
+++ b/arch/arm/mach-omap2/sdrc.h
@@ -31,24 +31,24 @@ extern void __iomem *omap2_sms_base;
 
 static inline void sdrc_write_reg(u32 val, u16 reg)
 {
-	__raw_writel(val, OMAP_SDRC_REGADDR(reg));
+	writel_relaxed(val, OMAP_SDRC_REGADDR(reg));
 }
 
 static inline u32 sdrc_read_reg(u16 reg)
 {
-	return __raw_readl(OMAP_SDRC_REGADDR(reg));
+	return readl_relaxed(OMAP_SDRC_REGADDR(reg));
 }
 
 /* SMS global register get/set */
 
 static inline void sms_write_reg(u32 val, u16 reg)
 {
-	__raw_writel(val, OMAP_SMS_REGADDR(reg));
+	writel_relaxed(val, OMAP_SMS_REGADDR(reg));
 }
 
 static inline u32 sms_read_reg(u16 reg)
 {
-	return __raw_readl(OMAP_SMS_REGADDR(reg));
+	return readl_relaxed(OMAP_SMS_REGADDR(reg));
 }
 
 extern void omap2_set_globals_sdrc(void __iomem *sdrc, void __iomem *sms);
diff --git a/arch/arm/mach-omap2/sdrc2xxx.c b/arch/arm/mach-omap2/sdrc2xxx.c
index 9072917..ae3f155 100644
--- a/arch/arm/mach-omap2/sdrc2xxx.c
+++ b/arch/arm/mach-omap2/sdrc2xxx.c
@@ -103,9 +103,9 @@ u32 omap2xxx_sdrc_reprogram(u32 level, u32 force)
 	 * prm2xxx.c function
 	 */
 	if (cpu_is_omap2420())
-		__raw_writel(0xffff, OMAP2420_PRCM_VOLTSETUP);
+		writel_relaxed(0xffff, OMAP2420_PRCM_VOLTSETUP);
 	else
-		__raw_writel(0xffff, OMAP2430_PRCM_VOLTSETUP);
+		writel_relaxed(0xffff, OMAP2430_PRCM_VOLTSETUP);
 	omap2_sram_reprogram_sdrc(level, dll_ctrl, m_type);
 	curr_perf_level = level;
 	local_irq_restore(flags);
diff --git a/arch/arm/mach-omap2/sr_device.c b/arch/arm/mach-omap2/sr_device.c
index d7bc33f..1b91ef0 100644
--- a/arch/arm/mach-omap2/sr_device.c
+++ b/arch/arm/mach-omap2/sr_device.c
@@ -57,7 +57,7 @@ static void __init sr_set_nvalues(struct omap_volt_data *volt_data,
 
 		/*
 		 * In OMAP4 the efuse registers are 24 bit aligned.
-		 * A __raw_readl will fail for non-32 bit aligned address
+		 * A readl_relaxed will fail for non-32 bit aligned address
 		 * and hence the 8-bit read and shift.
 		 */
 		if (cpu_is_omap44xx()) {
diff --git a/arch/arm/mach-omap2/sram.c b/arch/arm/mach-omap2/sram.c
index 4bd0968..ddf1818 100644
--- a/arch/arm/mach-omap2/sram.c
+++ b/arch/arm/mach-omap2/sram.c
@@ -70,16 +70,16 @@ static int is_sram_locked(void)
 	if (OMAP2_DEVICE_TYPE_GP == omap_type()) {
 		/* RAMFW: R/W access to all initiators for all qualifier sets */
 		if (cpu_is_omap242x()) {
-			__raw_writel(0xFF, OMAP24XX_VA_REQINFOPERM0); /* all q-vects */
-			__raw_writel(0xCFDE, OMAP24XX_VA_READPERM0);  /* all i-read */
-			__raw_writel(0xCFDE, OMAP24XX_VA_WRITEPERM0); /* all i-write */
+			writel_relaxed(0xFF, OMAP24XX_VA_REQINFOPERM0); /* all q-vects */
+			writel_relaxed(0xCFDE, OMAP24XX_VA_READPERM0);  /* all i-read */
+			writel_relaxed(0xCFDE, OMAP24XX_VA_WRITEPERM0); /* all i-write */
 		}
 		if (cpu_is_omap34xx()) {
-			__raw_writel(0xFFFF, OMAP34XX_VA_REQINFOPERM0); /* all q-vects */
-			__raw_writel(0xFFFF, OMAP34XX_VA_READPERM0);  /* all i-read */
-			__raw_writel(0xFFFF, OMAP34XX_VA_WRITEPERM0); /* all i-write */
-			__raw_writel(0x0, OMAP34XX_VA_ADDR_MATCH2);
-			__raw_writel(0xFFFFFFFF, OMAP34XX_VA_SMS_RG_ATT0);
+			writel_relaxed(0xFFFF, OMAP34XX_VA_REQINFOPERM0); /* all q-vects */
+			writel_relaxed(0xFFFF, OMAP34XX_VA_READPERM0);  /* all i-read */
+			writel_relaxed(0xFFFF, OMAP34XX_VA_WRITEPERM0); /* all i-write */
+			writel_relaxed(0x0, OMAP34XX_VA_ADDR_MATCH2);
+			writel_relaxed(0xFFFFFFFF, OMAP34XX_VA_SMS_RG_ATT0);
 		}
 		return 0;
 	} else
diff --git a/arch/arm/mach-omap2/timer.c b/arch/arm/mach-omap2/timer.c
index ead48fa..3a16ea0 100644
--- a/arch/arm/mach-omap2/timer.c
+++ b/arch/arm/mach-omap2/timer.c
@@ -532,15 +532,15 @@ static void __init realtime_counter_init(void)
 	}
 
 	/* Program numerator and denumerator registers */
-	reg = __raw_readl(base + INCREMENTER_NUMERATOR_OFFSET) &
+	reg = readl_relaxed(base + INCREMENTER_NUMERATOR_OFFSET) &
 			NUMERATOR_DENUMERATOR_MASK;
 	reg |= num;
-	__raw_writel(reg, base + INCREMENTER_NUMERATOR_OFFSET);
+	writel_relaxed(reg, base + INCREMENTER_NUMERATOR_OFFSET);
 
-	reg = __raw_readl(base + INCREMENTER_DENUMERATOR_RELOAD_OFFSET) &
+	reg = readl_relaxed(base + INCREMENTER_DENUMERATOR_RELOAD_OFFSET) &
 			NUMERATOR_DENUMERATOR_MASK;
 	reg |= den;
-	__raw_writel(reg, base + INCREMENTER_DENUMERATOR_RELOAD_OFFSET);
+	writel_relaxed(reg, base + INCREMENTER_DENUMERATOR_RELOAD_OFFSET);
 
 	iounmap(base);
 }
diff --git a/arch/arm/mach-omap2/vc.c b/arch/arm/mach-omap2/vc.c
index 49ac797..267f204 100644
--- a/arch/arm/mach-omap2/vc.c
+++ b/arch/arm/mach-omap2/vc.c
@@ -462,7 +462,7 @@ static void omap4_set_timings(struct voltagedomain *voltdm, bool off_mode)
 	val |= omap4_usec_to_val_scrm(tshut, OMAP4_DOWNTIME_SHIFT,
 		OMAP4_DOWNTIME_MASK);
 
-	__raw_writel(val, OMAP4_SCRM_CLKSETUPTIME);
+	writel_relaxed(val, OMAP4_SCRM_CLKSETUPTIME);
 }
 
 /* OMAP4 specific voltage init functions */
@@ -584,7 +584,7 @@ static void __init omap4_vc_i2c_timing_init(struct voltagedomain *voltdm)
 	val = i2c_data->loadbits << 25 | i2c_data->loadbits << 29;
 
 	/* Write to SYSCTRL_PADCONF_WKUP_CTRL_I2C_2 to setup I2C pull */
-	__raw_writel(val, OMAP2_L4_IO_ADDRESS(OMAP4_CTRL_MODULE_PAD_WKUP +
+	writel_relaxed(val, OMAP2_L4_IO_ADDRESS(OMAP4_CTRL_MODULE_PAD_WKUP +
 				OMAP4_CTRL_MODULE_PAD_WKUP_CONTROL_I2C_2));
 
 	/* HSSCLH can always be zero */
diff --git a/arch/arm/mach-omap2/wd_timer.c b/arch/arm/mach-omap2/wd_timer.c
index d15c7bb..97d6607 100644
--- a/arch/arm/mach-omap2/wd_timer.c
+++ b/arch/arm/mach-omap2/wd_timer.c
@@ -49,12 +49,12 @@ int omap2_wd_timer_disable(struct omap_hwmod *oh)
 	}
 
 	/* sequence required to disable watchdog */
-	__raw_writel(0xAAAA, base + OMAP_WDT_SPR);
-	while (__raw_readl(base + OMAP_WDT_WPS) & 0x10)
+	writel_relaxed(0xAAAA, base + OMAP_WDT_SPR);
+	while (readl_relaxed(base + OMAP_WDT_WPS) & 0x10)
 		cpu_relax();
 
-	__raw_writel(0x5555, base + OMAP_WDT_SPR);
-	while (__raw_readl(base + OMAP_WDT_WPS) & 0x10)
+	writel_relaxed(0x5555, base + OMAP_WDT_SPR);
+	while (readl_relaxed(base + OMAP_WDT_WPS) & 0x10)
 		cpu_relax();
 
 	return 0;
-- 
1.7.9.5

