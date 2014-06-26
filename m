Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757861AbaFZP5p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 11:57:45 -0400
Received: from mirror2.csie.ntu.edu.tw ([140.112.30.76]:42108 "EHLO
	mirror2.csie.ntu.edu.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756110AbaFZP4H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 11:56:07 -0400
From: Chen-Yu Tsai <wens@csie.org>
To: Maxime Ripard <maxime.ripard@free-electrons.com>,
        Mike Turquette <mturquette@linaro.org>,
        Emilio Lopez <emilio@elopez.com.ar>
Cc: Chen-Yu Tsai <wens@csie.org>, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com
Subject: [PATCH v4 2/6] clk: sunxi: move "ahb_sdram" to protected clock list
Date: Thu, 26 Jun 2014 23:55:40 +0800
Message-Id: <1403798144-32188-3-git-send-email-wens@csie.org>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1403798144-32188-1-git-send-email-wens@csie.org>
References: <1403798144-32188-1-git-send-email-wens@csie.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With sunxi_gates clocks registered with clkdev, we can use the
protected clocks list to enable the "ahb_sdram" clock, instead
of looking for it and adding CLK_IGNORE_UNUSED inline in the
clock setup code.

Signed-off-by: Chen-Yu Tsai <wens@csie.org>
Acked-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 drivers/clk/sunxi/clk-sunxi.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/clk/sunxi/clk-sunxi.c b/drivers/clk/sunxi/clk-sunxi.c
index e43ed6a..a38c799 100644
--- a/drivers/clk/sunxi/clk-sunxi.c
+++ b/drivers/clk/sunxi/clk-sunxi.c
@@ -870,7 +870,6 @@ static void __init sunxi_gates_clk_setup(struct device_node *node,
 	int qty;
 	int i = 0;
 	int j = 0;
-	int ignore;
 
 	reg = of_iomap(node, 0);
 
@@ -891,11 +890,8 @@ static void __init sunxi_gates_clk_setup(struct device_node *node,
 		of_property_read_string_index(node, "clock-output-names",
 					      j, &clk_name);
 
-		/* No driver claims this clock, but it should remain gated */
-		ignore = !strcmp("ahb_sdram", clk_name) ? CLK_IGNORE_UNUSED : 0;
-
 		clk_data->clks[i] = clk_register_gate(NULL, clk_name,
-						      clk_parent, ignore,
+						      clk_parent, 0,
 						      reg + 4 * (i/32), i % 32,
 						      0, &clk_lock);
 		WARN_ON(IS_ERR(clk_data->clks[i]));
@@ -1203,6 +1199,7 @@ static void __init sunxi_init_clocks(const char *clocks[], int nclocks)
 
 static const char *sun4i_a10_critical_clocks[] __initdata = {
 	"pll5_ddr",
+	"ahb_sdram",
 };
 
 static void __init sun4i_a10_init_clocks(struct device_node *node)
@@ -1215,6 +1212,7 @@ CLK_OF_DECLARE(sun4i_a10_clk_init, "allwinner,sun4i-a10", sun4i_a10_init_clocks)
 static const char *sun5i_critical_clocks[] __initdata = {
 	"mbus",
 	"pll5_ddr",
+	"ahb_sdram",
 };
 
 static void __init sun5i_init_clocks(struct device_node *node)
-- 
2.0.0

