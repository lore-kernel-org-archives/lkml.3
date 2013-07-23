Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934306Ab3GWWZa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 18:25:30 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:51655 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934023Ab3GWWZ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 18:25:26 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Thomas Gleixner <tglx@linutronix.de>,
        Mike Turquette <mturquette@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>
Cc: Olof Johansson <olof@lixom.net>, albert.u.boot@aribaud.net,
        Emilio Lopez <emilio@elopez.com.ar>, kevin.z.m.zh@gmail.com,
        sunny@allwinnertech.com, shuge@allwinnertech.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH 02/10] clk: sunxi: fix initialization of basic clocks
Date: Wed, 24 Jul 2013 00:25:04 +0200
Message-Id: <1374618312-19001-3-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1374618312-19001-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1374618312-19001-1-git-send-email-maxime.ripard@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Emilio López <emilio@elopez.com.ar>

With the recent move towards CLK_OF_DECLARE(...), the driver stopped
initializing osc32k, which is compatible "fixed-clock". This is because
we never called of_clk_init(NULL). Fix this by moving the only other
simple clock (osc24M) to use CLK_OF_DECLARE(...) and call of_clk_init(NULL)
to initialize both of them.

Signed-off-by: Emilio López <emilio@elopez.com.ar>
Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 drivers/clk/sunxi/clk-sunxi.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/clk/sunxi/clk-sunxi.c b/drivers/clk/sunxi/clk-sunxi.c
index 412912b..fe1528e 100644
--- a/drivers/clk/sunxi/clk-sunxi.c
+++ b/drivers/clk/sunxi/clk-sunxi.c
@@ -409,12 +409,7 @@ static void __init sunxi_gates_clk_setup(struct device_node *node,
 
 	of_clk_add_provider(node, of_clk_src_onecell_get, clk_data);
 }
-
-/* Matches for of_clk_init */
-static const __initconst struct of_device_id clk_match[] = {
-	{.compatible = "allwinner,sun4i-osc-clk", .data = sunxi_osc_clk_setup,},
-	{}
-};
+CLK_OF_DECLARE(sunxi_osc, "allwinner,sun4i-osc-clk", sunxi_osc_clk_setup);
 
 /* Matches for factors clocks */
 static const __initconst struct of_device_id clk_factors_match[] = {
@@ -467,8 +462,8 @@ static void __init of_sunxi_table_clock_setup(const struct of_device_id *clk_mat
 
 void __init sunxi_init_clocks(void)
 {
-	/* Register all the simple sunxi clocks on DT */
-	of_clk_init(clk_match);
+	/* Register all the simple and basic clocks on DT */
+	of_clk_init(NULL);
 
 	/* Register factor clocks */
 	of_sunxi_table_clock_setup(clk_factors_match, sunxi_factors_clk_setup);
-- 
1.8.3.2

