Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753552AbaLNP3j (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2014 10:29:39 -0500
Received: from mout.kundenserver.de ([212.227.126.130]:54897 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751853AbaLNP3h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2014 10:29:37 -0500
From: Stefan Wahren <stefan.wahren@i2se.com>
To: mturquette@linaro.org
Cc: festevam@gmail.com, shawn.guo@linaro.org, marex@denx.de,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Stefan Wahren <stefan.wahren@i2se.com>
Subject: [PATCH RFC] clk: mxs: Fix invalid 32-bit access to frac registers
Date: Sun, 14 Dec 2014 15:28:53 +0000
Message-Id: <1418570933-21585-1-git-send-email-stefan.wahren@i2se.com>
X-Mailer: git-send-email 1.7.9.5
X-Provags-ID: V03:K0:TJHfX8CSP+8O+1NydKw+Wa21Hm7mUb5nrcWcklOPayQwGRoGe4W
 Mk8i9kzt7R25ylpP18nB5Iw1NswyNShx+QkkBKlLkM1tLLK5K5LkFnZU6tfRytlbgv7LDmM
 Ytt0Ucb5MeCE13AIZdL6y6zCYxxXs7330FVl/E/4HgFfzbNfxhc2ojgCQvTn91tXFNuIjLJ
 f9Y9Y1IPmSrQ19j09/Rxg==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

According to i.MX23 and i.MX28 reference manual the fractional
clock control registers must be addressed by byte instructions.

This patch fixes the erroneous 32-bit access to these registers.

The changes has been tested only with a i.MX28 board, because i don't
have access to an i.MX23 board.

Signed-off-by: Stefan Wahren <stefan.wahren@i2se.com>
---
 drivers/clk/mxs/clk-imx23.c |    8 +++++---
 drivers/clk/mxs/clk-imx28.c |   14 ++++++++------
 drivers/clk/mxs/clk-ref.c   |   19 ++++++++++---------
 3 files changed, 23 insertions(+), 18 deletions(-)

diff --git a/drivers/clk/mxs/clk-imx23.c b/drivers/clk/mxs/clk-imx23.c
index 9fc9359..371ba03 100644
--- a/drivers/clk/mxs/clk-imx23.c
+++ b/drivers/clk/mxs/clk-imx23.c
@@ -46,7 +46,8 @@ static void __iomem *digctrl;
 #define BP_CLKSEQ_BYPASS_SAIF	0
 #define BP_CLKSEQ_BYPASS_SSP	5
 #define BP_SAIF_DIV_FRAC_EN	16
-#define BP_FRAC_IOFRAC		24
+
+#define FRAC_IO	3
 
 static void __init clk_misc_init(void)
 {
@@ -72,9 +73,10 @@ static void __init clk_misc_init(void)
 	/*
 	 * 480 MHz seems too high to be ssp clock source directly,
 	 * so set frac to get a 288 MHz ref_io.
+	 * According to reference manual we must access frac bytewise.
 	 */
-	writel_relaxed(0x3f << BP_FRAC_IOFRAC, FRAC + CLR);
-	writel_relaxed(30 << BP_FRAC_IOFRAC, FRAC + SET);
+	writeb_relaxed(0x3f, FRAC + FRAC_IO + CLR);
+	writeb_relaxed(30, FRAC + FRAC_IO + SET);
 }
 
 static const char *sel_pll[]  __initconst = { "pll", "ref_xtal", };
diff --git a/drivers/clk/mxs/clk-imx28.c b/drivers/clk/mxs/clk-imx28.c
index a6c3501..3eae119 100644
--- a/drivers/clk/mxs/clk-imx28.c
+++ b/drivers/clk/mxs/clk-imx28.c
@@ -53,8 +53,9 @@ static void __iomem *clkctrl;
 #define BP_ENET_SLEEP		31
 #define BP_CLKSEQ_BYPASS_SAIF0	0
 #define BP_CLKSEQ_BYPASS_SSP0	3
-#define BP_FRAC0_IO1FRAC	16
-#define BP_FRAC0_IO0FRAC	24
+
+#define FRAC0_IO1	2
+#define FRAC0_IO0	3
 
 static void __iomem *digctrl;
 #define DIGCTRL digctrl
@@ -118,11 +119,12 @@ static void __init clk_misc_init(void)
 	/*
 	 * 480 MHz seems too high to be ssp clock source directly,
 	 * so set frac0 to get a 288 MHz ref_io0 and ref_io1.
+	 * According to reference manual we must access frac0 bytewise.
 	 */
-	val = readl_relaxed(FRAC0);
-	val &= ~((0x3f << BP_FRAC0_IO0FRAC) | (0x3f << BP_FRAC0_IO1FRAC));
-	val |= (30 << BP_FRAC0_IO0FRAC) | (30 << BP_FRAC0_IO1FRAC);
-	writel_relaxed(val, FRAC0);
+	writeb_relaxed(0x3f, FRAC0 + FRAC0_IO0 + CLR);
+	writeb_relaxed(30, FRAC0 + FRAC0_IO0 + SET);
+	writeb_relaxed(0x3f, FRAC0 + FRAC0_IO1 + CLR);
+	writeb_relaxed(30, FRAC0 + FRAC0_IO1 + SET);
 }
 
 static const char *sel_cpu[]  __initconst = { "ref_cpu", "ref_xtal", };
diff --git a/drivers/clk/mxs/clk-ref.c b/drivers/clk/mxs/clk-ref.c
index 4adeed6..ad3851c 100644
--- a/drivers/clk/mxs/clk-ref.c
+++ b/drivers/clk/mxs/clk-ref.c
@@ -16,6 +16,8 @@
 #include <linux/slab.h>
 #include "clk.h"
 
+#define BF_CLKGATE	BIT(7)
+
 /**
  * struct clk_ref - mxs reference clock
  * @hw: clk_hw for the reference clock
@@ -39,7 +41,7 @@ static int clk_ref_enable(struct clk_hw *hw)
 {
 	struct clk_ref *ref = to_clk_ref(hw);
 
-	writel_relaxed(1 << ((ref->idx + 1) * 8 - 1), ref->reg + CLR);
+	writeb_relaxed(BF_CLKGATE, ref->reg + ref->idx + CLR);
 
 	return 0;
 }
@@ -48,7 +50,7 @@ static void clk_ref_disable(struct clk_hw *hw)
 {
 	struct clk_ref *ref = to_clk_ref(hw);
 
-	writel_relaxed(1 << ((ref->idx + 1) * 8 - 1), ref->reg + SET);
+	writeb_relaxed(BF_CLKGATE, ref->reg + ref->idx + SET);
 }
 
 static unsigned long clk_ref_recalc_rate(struct clk_hw *hw,
@@ -56,7 +58,7 @@ static unsigned long clk_ref_recalc_rate(struct clk_hw *hw,
 {
 	struct clk_ref *ref = to_clk_ref(hw);
 	u64 tmp = parent_rate;
-	u8 frac = (readl_relaxed(ref->reg) >> (ref->idx * 8)) & 0x3f;
+	u8 frac = readb_relaxed(ref->reg + ref->idx) & 0x3f;
 
 	tmp *= 18;
 	do_div(tmp, frac);
@@ -93,8 +95,7 @@ static int clk_ref_set_rate(struct clk_hw *hw, unsigned long rate,
 	struct clk_ref *ref = to_clk_ref(hw);
 	unsigned long flags;
 	u64 tmp = parent_rate;
-	u32 val;
-	u8 frac, shift = ref->idx * 8;
+	u8 frac, val;
 
 	tmp = tmp * 18 + rate / 2;
 	do_div(tmp, rate);
@@ -107,10 +108,10 @@ static int clk_ref_set_rate(struct clk_hw *hw, unsigned long rate,
 
 	spin_lock_irqsave(&mxs_lock, flags);
 
-	val = readl_relaxed(ref->reg);
-	val &= ~(0x3f << shift);
-	val |= frac << shift;
-	writel_relaxed(val, ref->reg);
+	val = readb_relaxed(ref->reg + ref->idx);
+	val &= ~0x3f;
+	val |= frac;
+	writeb_relaxed(val, ref->reg + ref->idx);
 
 	spin_unlock_irqrestore(&mxs_lock, flags);
 
-- 
1.7.9.5

