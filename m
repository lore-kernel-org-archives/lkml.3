Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753534AbaG2OUf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 10:20:35 -0400
Received: from mail.kmu-office.ch ([178.209.48.102]:48955 "EHLO
	mail.kmu-office.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751143AbaG2OUe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 10:20:34 -0400
From: Stefan Agner <stefan@agner.ch>
To: shawn.guo@freescale.com, kernel@pengutronix.de, peter.chen@freescale.com
Cc: jingchang.lu@freescale.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, stefan@agner.ch
Subject: [PATCH] ARM: imx: clk-vf610: introduce clks_init_on
Date: Tue, 29 Jul 2014 16:20:28 +0200
Message-Id: <1406643628-4061-1-git-send-email-stefan@agner.ch>
X-Mailer: git-send-email 2.0.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At the end of the boot process, the clock framework might disable
required main PLL's. So far, this was no issue since drivers
requested clocks, which are descended of the main PLL's (e.g.
pll1_pfd1, which provides the system clock).

To archive the full 500MHz system clock, DDR clock need to be a
descendant of PLL2 rather than PLL1 (DDRC_CLK_SEL set to 0). The
bootloader sets up the clocks accordingly before making use of
DDR at all. However, in Linux, there is no driver using PLL2,
which lead to PLL2 being disabled by the clock framework.

With this patch, we make sure that the main system clock and the
DDR clock are initially enabled and are kept enabled.

Signed-off-by: Stefan Agner <stefan@agner.ch>
---
 arch/arm/mach-imx/clk-vf610.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/arm/mach-imx/clk-vf610.c b/arch/arm/mach-imx/clk-vf610.c
index f60d6d5..a41ed73 100644
--- a/arch/arm/mach-imx/clk-vf610.c
+++ b/arch/arm/mach-imx/clk-vf610.c
@@ -98,9 +98,15 @@ static struct clk_div_table pll4_main_div_table[] = {
 static struct clk *clk[VF610_CLK_END];
 static struct clk_onecell_data clk_data;
 
+static unsigned int const clks_init_on[] __initconst = {
+	VF610_CLK_SYS_BUS,
+	VF610_CLK_DDR_SEL,
+};
+
 static void __init vf610_clocks_init(struct device_node *ccm_node)
 {
 	struct device_node *np;
+	int i;
 
 	clk[VF610_CLK_DUMMY] = imx_clk_fixed("dummy", 0);
 	clk[VF610_CLK_SIRC_128K] = imx_clk_fixed("sirc_128k", 128000);
@@ -322,6 +328,9 @@ static void __init vf610_clocks_init(struct device_node *ccm_node)
 	clk_set_parent(clk[VF610_CLK_SAI2_SEL], clk[VF610_CLK_AUDIO_EXT]);
 	clk_set_parent(clk[VF610_CLK_SAI3_SEL], clk[VF610_CLK_AUDIO_EXT]);
 
+	for (i = 0; i < ARRAY_SIZE(clks_init_on); i++)
+		clk_prepare_enable(clk[clks_init_on[i]]);
+
 	/* Add the clocks to provider list */
 	clk_data.clks = clk;
 	clk_data.clk_num = ARRAY_SIZE(clk);
-- 
2.0.2

