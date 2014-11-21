Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932413AbaKUJfn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 04:35:43 -0500
Received: from mo4.mail-out.ovh.net ([178.32.228.4]:57522 "EHLO
	mo4.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758491AbaKUJfi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 04:35:38 -0500
From: Julien CHAUVEAU <julien.chauveau@neo-technologies.fr>
To: Heiko Stuebner <heiko@sntech.de>, Mike Turquette <mturquette@linaro.org>,
        linux-arm-kernel@lists.infradead.org (moderated list:ARM/Rockchip
	SoC...),
        linux-rockchip@lists.infradead.org (open list:ARM/Rockchip SoC...),
        linux-kernel@vger.kernel.org (open list:COMMON CLK FRAMEWORK)
Cc: Julien CHAUVEAU <julien.chauveau@neo-technologies.fr>
Subject: [PATCH] clk: rockchip: fix clock gate for rk3188 spdif_pre
Date: Fri, 21 Nov 2014 10:27:41 +0100
Message-Id: <1416562062-14286-1-git-send-email-julien.chauveau@neo-technologies.fr>
X-Mailer: git-send-email 2.1.0
X-Ovh-Tracer-Id: 418834766108688412
X-Ovh-Remote: 193.248.240.88 (laubervilliers-656-1-116-88.w193-248.abo.wanadoo.fr)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejhedrkeekucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejhedrkeekucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In rk3188 clock branches, spdif_pre gate was set to RK2928_CLKGATE_CON(13) bit 13.
This appears to be a copy-paste error because such a register does not exist.
We correct it to RK2928_CLKGATE_CON(0) and find out that the rk3188 spdif clock
is the same as the rk3066 spdif clock, so we move it to the common clock branches.

Signed-off-by: Julien CHAUVEAU <julien.chauveau@neo-technologies.fr>
---
 drivers/clk/rockchip/clk-rk3188.c | 25 +++++++++----------------
 1 file changed, 9 insertions(+), 16 deletions(-)

diff --git a/drivers/clk/rockchip/clk-rk3188.c b/drivers/clk/rockchip/clk-rk3188.c
index b0293c4..725d841 100644
--- a/drivers/clk/rockchip/clk-rk3188.c
+++ b/drivers/clk/rockchip/clk-rk3188.c
@@ -330,6 +330,15 @@ static struct rockchip_clk_branch common_clk_branches[] __initdata = {
 			RK2928_CLKSEL_CON(24), 8, 8, DFLAGS,
 			RK2928_CLKGATE_CON(2), 8, GFLAGS),
 
+	COMPOSITE_NOMUX(0, "spdif_pre", "i2s_src", 0,
+			RK2928_CLKSEL_CON(5), 0, 7, DFLAGS,
+			RK2928_CLKGATE_CON(0), 13, GFLAGS),
+	COMPOSITE_FRAC(0, "spdif_frac", "spdif_pll", 0,
+			RK2928_CLKSEL_CON(9), 0,
+			RK2928_CLKGATE_CON(0), 14, GFLAGS),
+	MUX(SCLK_SPDIF, "sclk_spdif", mux_sclk_spdif_p, 0,
+			RK2928_CLKSEL_CON(5), 8, 2, MFLAGS),
+
 	/*
 	 * Clock-Architecture Diagram 4
 	 */
@@ -577,14 +586,6 @@ static struct rockchip_clk_branch rk3066a_clk_branches[] __initdata = {
 			RK2928_CLKGATE_CON(0), 12, GFLAGS),
 	MUX(SCLK_I2S2, "sclk_i2s2", mux_sclk_i2s2_p, 0,
 			RK2928_CLKSEL_CON(4), 8, 2, MFLAGS),
-	COMPOSITE_NOMUX(0, "spdif_pre", "i2s_src", 0,
-			RK2928_CLKSEL_CON(5), 0, 7, DFLAGS,
-			RK2928_CLKGATE_CON(0), 13, GFLAGS),
-	COMPOSITE_FRAC(0, "spdif_frac", "spdif_pll", 0,
-			RK2928_CLKSEL_CON(9), 0,
-			RK2928_CLKGATE_CON(0), 14, GFLAGS),
-	MUX(SCLK_SPDIF, "sclk_spdif", mux_sclk_spdif_p, 0,
-			RK2928_CLKSEL_CON(5), 8, 2, MFLAGS),
 
 	GATE(HCLK_I2S1, "hclk_i2s1", "hclk_cpu", 0, RK2928_CLKGATE_CON(7), 3, GFLAGS),
 	GATE(HCLK_I2S2, "hclk_i2s2", "hclk_cpu", 0, RK2928_CLKGATE_CON(7), 4, GFLAGS),
@@ -675,14 +676,6 @@ static struct rockchip_clk_branch rk3188_clk_branches[] __initdata = {
 			RK2928_CLKGATE_CON(0), 10, GFLAGS),
 	MUX(SCLK_I2S0, "sclk_i2s0", mux_sclk_i2s0_p, 0,
 			RK2928_CLKSEL_CON(3), 8, 2, MFLAGS),
-	COMPOSITE_NOMUX(0, "spdif_pre", "i2s_src", 0,
-			RK2928_CLKSEL_CON(5), 0, 7, DFLAGS,
-			RK2928_CLKGATE_CON(13), 13, GFLAGS),
-	COMPOSITE_FRAC(0, "spdif_frac", "spdif_pll", 0,
-			RK2928_CLKSEL_CON(9), 0,
-			RK2928_CLKGATE_CON(0), 14, GFLAGS),
-	MUX(SCLK_SPDIF, "sclk_spdif", mux_sclk_spdif_p, 0,
-			RK2928_CLKSEL_CON(5), 8, 2, MFLAGS),
 
 	GATE(0, "hclk_imem0", "hclk_cpu", 0, RK2928_CLKGATE_CON(4), 14, GFLAGS),
 	GATE(0, "hclk_imem1", "hclk_cpu", 0, RK2928_CLKGATE_CON(4), 15, GFLAGS),
-- 
2.1.0

