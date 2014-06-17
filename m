Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933386AbaFQOyG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 10:54:06 -0400
Received: from mirror2.csie.ntu.edu.tw ([140.112.30.76]:41446 "EHLO
	mirror2.csie.ntu.edu.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933349AbaFQOyA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 10:54:00 -0400
From: Chen-Yu Tsai <wens@csie.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mike Turquette <mturquette@linaro.org>,
        Emilio Lopez <emilio@elopez.com.ar>,
        Linus Walleij <linus.walleij@linaro.org>
Cc: Chen-Yu Tsai <wens@csie.org>, linux-serial@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-sunxi@googlegroups.com,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Luc Verhaegen <libv@skynet.be>
Subject: [PATCH v2 10/20] clk: sunxi: Add support for table-based divider clocks
Date: Tue, 17 Jun 2014 22:52:47 +0800
Message-Id: <1403016777-15121-11-git-send-email-wens@csie.org>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1403016777-15121-1-git-send-email-wens@csie.org>
References: <1403016777-15121-1-git-send-email-wens@csie.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A few of the clock modules have odd dividers, such as
the 2 lowest dividers being the same (2), or have the
same divider when the highest bit is set.

This patch adds support for optional divider tables,
so the clock framework will know about the odd values.

Signed-off-by: Chen-Yu Tsai <wens@csie.org>
---
 drivers/clk/sunxi/clk-sunxi.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/clk/sunxi/clk-sunxi.c b/drivers/clk/sunxi/clk-sunxi.c
index a086b5b..7e2f015 100644
--- a/drivers/clk/sunxi/clk-sunxi.c
+++ b/drivers/clk/sunxi/clk-sunxi.c
@@ -703,6 +703,7 @@ struct div_data {
 	u8	shift;
 	u8	pow;
 	u8	width;
+	const struct clk_div_table *table;
 };
 
 static const struct div_data sun4i_axi_data __initconst = {
@@ -743,10 +744,10 @@ static void __init sunxi_divider_clk_setup(struct device_node *node,
 
 	of_property_read_string(node, "clock-output-names", &clk_name);
 
-	clk = clk_register_divider(NULL, clk_name, clk_parent, 0,
-				   reg, data->shift, data->width,
-				   data->pow ? CLK_DIVIDER_POWER_OF_TWO : 0,
-				   &clk_lock);
+	clk = clk_register_divider_table(NULL, clk_name, clk_parent, 0,
+					 reg, data->shift, data->width,
+					 data->pow ? CLK_DIVIDER_POWER_OF_TWO : 0,
+					 data->table, &clk_lock);
 	if (clk) {
 		of_clk_add_provider(node, of_clk_src_simple_get, clk);
 		clk_register_clkdev(clk, clk_name, NULL);
-- 
2.0.0

