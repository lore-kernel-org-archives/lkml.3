Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757796Ab3JRX3V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 19:29:21 -0400
Received: from mail-yh0-f42.google.com ([209.85.213.42]:58634 "EHLO
	mail-yh0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756240Ab3JRX3U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 19:29:20 -0400
From: "Victor N. Ramos Mello" <victornrm@gmail.com>
To: Mike Turquette <mturquette@linaro.org>,
        =?UTF-8?q?Emilio=20L=C3=B3pez?= <emilio@elopez.com.ar>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Stephen Boyd <sboyd@codeaurora.org>
Cc: linux-kernel@vger.kernel.org,
        "Victor N. Ramos Mello" <victornrm@gmail.com>
Subject: [PATCH v2] drivers: clk: sunxi: Fix memory leakage in clk-sunxi.c
Date: Fri, 18 Oct 2013 20:27:51 -0300
Message-Id: <1382138871-9366-1-git-send-email-victornrm@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Victor N. Ramos Mello" <victornrm@gmail.com>

Fix a possible memory leak in sun4i_osc_clk_setup().
Moved clock-frequency check to save superfluous allocation.

Signed-off-by: Victor N. Ramos Mello <victornrm@gmail.com>
---
 drivers/clk/sunxi/clk-sunxi.c |   28 +++++++++++++++++-----------
 1 files changed, 17 insertions(+), 11 deletions(-)

diff --git a/drivers/clk/sunxi/clk-sunxi.c b/drivers/clk/sunxi/clk-sunxi.c
index 34ee69f..9dcf43e 100644
--- a/drivers/clk/sunxi/clk-sunxi.c
+++ b/drivers/clk/sunxi/clk-sunxi.c
@@ -38,18 +38,16 @@ static void __init sun4i_osc_clk_setup(struct device_node *node)
 	const char *clk_name = node->name;
 	u32 rate;
 
+	if (of_property_read_u32(node, "clock-frequency", &rate))
+		return;
+
 	/* allocate fixed-rate and gate clock structs */
 	fixed = kzalloc(sizeof(struct clk_fixed_rate), GFP_KERNEL);
 	if (!fixed)
 		return;
 	gate = kzalloc(sizeof(struct clk_gate), GFP_KERNEL);
-	if (!gate) {
-		kfree(fixed);
-		return;
-	}
-
-	if (of_property_read_u32(node, "clock-frequency", &rate))
-		return;
+	if (!gate)
+		goto err_free_fixed;
 
 	/* set up gate and fixed rate properties */
 	gate->reg = of_iomap(node, 0);
@@ -64,10 +62,18 @@ static void __init sun4i_osc_clk_setup(struct device_node *node)
 			&gate->hw, &clk_gate_ops,
 			CLK_IS_ROOT);
 
-	if (!IS_ERR(clk)) {
-		of_clk_add_provider(node, of_clk_src_simple_get, clk);
-		clk_register_clkdev(clk, clk_name, NULL);
-	}
+	if (IS_ERR(clk))
+		goto err_free_gate;
+
+	of_clk_add_provider(node, of_clk_src_simple_get, clk);
+	clk_register_clkdev(clk, clk_name, NULL);
+
+	return;
+
+err_free_gate:
+	kfree(gate);
+err_free_fixed:
+	kfree(fixed);
 }
 CLK_OF_DECLARE(sun4i_osc, "allwinner,sun4i-osc-clk", sun4i_osc_clk_setup);
 
-- 
1.7.5.4

