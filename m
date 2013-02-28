Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755153Ab3B1Euf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 23:50:35 -0500
Received: from mail-pb0-f51.google.com ([209.85.160.51]:61477 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752560Ab3B1Eua (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 23:50:30 -0500
From: Mike Turquette <mturquette@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, patches@linaro.org,
        linaro-dev@lists.linaro.org, Mike Turquette <mturquette@linaro.org>
Subject: [PATCH 4/5] HACK: set_parent callback for OMAP4 non-core DPLLs
Date: Wed, 27 Feb 2013 20:49:28 -0800
Message-Id: <1362026969-11457-5-git-send-email-mturquette@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1362026969-11457-1-git-send-email-mturquette@linaro.org>
References: <1362026969-11457-1-git-send-email-mturquette@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a silly patch that demonstrates calling clk_set_parent from
within a .set_rate callback, which itself was called by clk_set_rate.
It may make your board burst into flames or otherwise void various
warrantees.

I do not suggest that the OMAP folks take this approach in unless they
really want to.  Instead it was a way for me to increase code coverage
while testing the reentrancy changes to the core clock framework.

Changes in this patch include removing __clk_prepare and __clk_unprepare
from omap3_noncore_dpll_set_rate and using the (now reentrant)
clk_prepare & clk_unprepare versions.  Most importantly this patch
introduces omap3_noncore_dpll_set_parent and adds it to the clk_ops for
all OMAP3+ DPLLs.

The net gain is that on OMAP4 platforms it is now possible to call
clk_set_parent(some_dpll_ck, ...) in order to change the PLL input from
the reference clock to the bypass clock, and vice versa.

omap3_noncore_dpll_set_rate is modified to call clk_set_parent when
appropriate as a way to test reentrancy.

Not-signed-off-by: Mike Turquette <mturquette@linaro.org>
---
 arch/arm/mach-omap2/cclock44xx_data.c |    1 +
 arch/arm/mach-omap2/clock.h           |    1 +
 arch/arm/mach-omap2/dpll3xxx.c        |  107 +++++++++++++++++++++++++--------
 3 files changed, 84 insertions(+), 25 deletions(-)

diff --git a/arch/arm/mach-omap2/cclock44xx_data.c b/arch/arm/mach-omap2/cclock44xx_data.c
index 5789a5e..df5da7f 100644
--- a/arch/arm/mach-omap2/cclock44xx_data.c
+++ b/arch/arm/mach-omap2/cclock44xx_data.c
@@ -386,6 +386,7 @@ static const struct clk_ops dpll_ck_ops = {
 	.round_rate	= &omap2_dpll_round_rate,
 	.set_rate	= &omap3_noncore_dpll_set_rate,
 	.get_parent	= &omap2_init_dpll_parent,
+	.set_parent	= &omap3_noncore_dpll_set_parent,
 };
 
 static struct clk_hw_omap dpll_iva_ck_hw = {
diff --git a/arch/arm/mach-omap2/clock.h b/arch/arm/mach-omap2/clock.h
index b402048..1cf43a5 100644
--- a/arch/arm/mach-omap2/clock.h
+++ b/arch/arm/mach-omap2/clock.h
@@ -367,6 +367,7 @@ long omap2_dpll_round_rate(struct clk_hw *hw, unsigned long target_rate,
 unsigned long omap3_dpll_recalc(struct clk_hw *hw, unsigned long parent_rate);
 int omap3_noncore_dpll_enable(struct clk_hw *hw);
 void omap3_noncore_dpll_disable(struct clk_hw *hw);
+int omap3_noncore_dpll_set_parent(struct clk_hw *hw, u8 index);
 int omap3_noncore_dpll_set_rate(struct clk_hw *hw, unsigned long rate,
 				unsigned long parent_rate);
 u32 omap3_dpll_autoidle_read(struct clk_hw_omap *clk);
diff --git a/arch/arm/mach-omap2/dpll3xxx.c b/arch/arm/mach-omap2/dpll3xxx.c
index 0a02aab5..bae123e 100644
--- a/arch/arm/mach-omap2/dpll3xxx.c
+++ b/arch/arm/mach-omap2/dpll3xxx.c
@@ -450,6 +450,76 @@ void omap3_noncore_dpll_disable(struct clk_hw *hw)
 		clkdm_clk_disable(clk->clkdm, hw->clk);
 }
 
+/* Non-CORE DPLL set parent code */
+
+/**
+ * omap3_noncore_dpll_set_parent - set non-core DPLL input
+ * @hw: hardware object for this clock/dpll
+ * @index: parent to switch to in the array of possible parents
+ *
+ * Sets the input to the DPLL to either the reference clock or bypass
+ * clock.  Returns error code upon failure or 0 upon success.
+ */
+int omap3_noncore_dpll_set_parent(struct clk_hw *hw, u8 index)
+{
+	struct clk_hw_omap *clk = to_clk_hw_omap(hw);
+	u16 freqsel = 0;
+	struct dpll_data *dd;
+	int ret;
+
+	if (!hw)
+		return -EINVAL;
+
+	dd = clk->dpll_data;
+	if (!dd)
+		return -EINVAL;
+
+	clk_prepare(dd->clk_bypass);
+	clk_enable(dd->clk_bypass);
+	clk_prepare(dd->clk_ref);
+	clk_enable(dd->clk_ref);
+
+	/* FIXME hard coded magic numbers are gross */
+	switch (index) {
+		/* dpll input is the reference clock */
+		case 0:
+			if (dd->last_rounded_rate == 0)
+				return -EINVAL;
+
+			/* No freqsel on OMAP4 and OMAP3630 */
+			if (!cpu_is_omap44xx() && !cpu_is_omap3630()) {
+				freqsel = _omap3_dpll_compute_freqsel(clk,
+						dd->last_rounded_n);
+				WARN_ON(!freqsel);
+			}
+
+			pr_debug("%s: %s: set rate: locking rate to %lu.\n",
+					__func__, __clk_get_name(hw->clk), dd->last_rounded_rate);
+
+			ret = omap3_noncore_dpll_program(clk, freqsel);
+			break;
+
+		/* dpll input is the bypass clock */
+		case 1:
+			pr_debug("%s: %s: set rate: entering bypass.\n",
+					__func__, __clk_get_name(hw->clk));
+
+			ret = _omap3_noncore_dpll_bypass(clk);
+			break;
+
+		default:
+			pr_warn("%s: %s: set parent: invalid parent\n",
+					__func__, __clk_get_name(hw->clk));
+			return -EINVAL;
+	}
+
+	clk_disable(dd->clk_ref);
+	clk_unprepare(dd->clk_ref);
+	clk_disable(dd->clk_bypass);
+	clk_unprepare(dd->clk_bypass);
+
+	return 0;
+}
 
 /* Non-CORE DPLL rate set code */
 
@@ -468,7 +538,6 @@ int omap3_noncore_dpll_set_rate(struct clk_hw *hw, unsigned long rate,
 					unsigned long parent_rate)
 {
 	struct clk_hw_omap *clk = to_clk_hw_omap(hw);
-	struct clk *new_parent = NULL;
 	u16 freqsel = 0;
 	struct dpll_data *dd;
 	int ret;
@@ -480,22 +549,18 @@ int omap3_noncore_dpll_set_rate(struct clk_hw *hw, unsigned long rate,
 	if (!dd)
 		return -EINVAL;
 
-	__clk_prepare(dd->clk_bypass);
+	clk_prepare(dd->clk_bypass);
 	clk_enable(dd->clk_bypass);
-	__clk_prepare(dd->clk_ref);
+	clk_prepare(dd->clk_ref);
 	clk_enable(dd->clk_ref);
 
-	if (__clk_get_rate(dd->clk_bypass) == rate &&
+	/* FIXME below block should call clk_set_parent */
+	if (clk_get_rate(dd->clk_bypass) == rate &&
 	    (dd->modes & (1 << DPLL_LOW_POWER_BYPASS))) {
-		pr_debug("%s: %s: set rate: entering bypass.\n",
-			 __func__, __clk_get_name(hw->clk));
-
-		ret = _omap3_noncore_dpll_bypass(clk);
-		if (!ret)
-			new_parent = dd->clk_bypass;
+		clk_set_parent(hw->clk, dd->clk_bypass);
 	} else {
 		if (dd->last_rounded_rate != rate)
-			rate = __clk_round_rate(hw->clk, rate);
+			rate = clk_round_rate(hw->clk, rate);
 
 		if (dd->last_rounded_rate == 0)
 			return -EINVAL;
@@ -510,24 +575,16 @@ int omap3_noncore_dpll_set_rate(struct clk_hw *hw, unsigned long rate,
 		pr_debug("%s: %s: set rate: locking rate to %lu.\n",
 			 __func__, __clk_get_name(hw->clk), rate);
 
-		ret = omap3_noncore_dpll_program(clk, freqsel);
-		if (!ret)
-			new_parent = dd->clk_ref;
+		if (clk_get_parent(hw->clk) == dd->clk_bypass)
+			clk_set_parent(hw->clk, dd->clk_ref);
+		else
+			ret = omap3_noncore_dpll_program(clk, freqsel);
 	}
-	/*
-	* FIXME - this is all wrong.  common code handles reparenting and
-	* migrating prepare/enable counts.  dplls should be a multiplexer
-	* clock and this should be a set_parent operation so that all of that
-	* stuff is inherited for free
-	*/
-
-	if (!ret)
-		__clk_reparent(hw->clk, new_parent);
 
 	clk_disable(dd->clk_ref);
-	__clk_unprepare(dd->clk_ref);
+	clk_unprepare(dd->clk_ref);
 	clk_disable(dd->clk_bypass);
-	__clk_unprepare(dd->clk_bypass);
+	clk_unprepare(dd->clk_bypass);
 
 	return 0;
 }
-- 
1.7.10.4

