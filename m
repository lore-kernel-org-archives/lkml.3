Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752282AbaEWIc6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 04:32:58 -0400
Received: from mirror2.csie.ntu.edu.tw ([140.112.30.76]:39572 "EHLO
	mirror2.csie.ntu.edu.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751678AbaEWI1n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 04:27:43 -0400
From: Chen-Yu Tsai <wens@csie.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mike Turquette <mturquette@linaro.org>,
        Emilio Lopez <emilio@elopez.com.ar>,
        Linus Walleij <linus.walleij@linaro.org>
Cc: Chen-Yu Tsai <wens@csie.org>, linux-serial@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Luc Verhaegen <libv@skynet.be>
Subject: [PATCH 08/22] clk: sunxi: Specify number of child clocks for divs clocks
Date: Fri, 23 May 2014 15:51:11 +0800
Message-Id: <1400831485-28576-9-git-send-email-wens@csie.org>
X-Mailer: git-send-email 2.0.0.rc2
In-Reply-To: <1400831485-28576-1-git-send-email-wens@csie.org>
References: <1400831485-28576-1-git-send-email-wens@csie.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently sunxi_divs_clk_setup assumes the number of child clocks
to be the same as the number of clock-output-names, and a maximum
of SUNXI_DIVS_MAX_QTY child clocks.

On sun6i, PLL6 only has 1 child clock, but the parent would be used
as well, thereby also having it's own clock-output-names entry. This
results in an extra bogus clock being registered.

This patch adds an entry for the number of child clocks alongside
the data structures for them.

Signed-off-by: Chen-Yu Tsai <wens@csie.org>
---
 drivers/clk/sunxi/clk-sunxi.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/sunxi/clk-sunxi.c b/drivers/clk/sunxi/clk-sunxi.c
index 6500a1b..6857c6e 100644
--- a/drivers/clk/sunxi/clk-sunxi.c
+++ b/drivers/clk/sunxi/clk-sunxi.c
@@ -933,6 +933,7 @@ static void __init sunxi_gates_clk_setup(struct device_node *node,
 
 struct divs_data {
 	const struct factors_data *factors; /* data for the factor clock */
+	int ndivs; /* number of children */
 	struct {
 		u8 fixed; /* is it a fixed divisor? if not... */
 		struct clk_div_table *table; /* is it a table based divisor? */
@@ -952,6 +953,7 @@ static struct clk_div_table pll6_sata_tbl[] = {
 
 static const struct divs_data pll5_divs_data __initconst = {
 	.factors = &sun4i_pll5_data,
+	.ndivs = 2,
 	.div = {
 		{ .shift = 0, .pow = 0, }, /* M, DDR */
 		{ .shift = 16, .pow = 1, }, /* P, other */
@@ -960,6 +962,7 @@ static const struct divs_data pll5_divs_data __initconst = {
 
 static const struct divs_data pll6_divs_data __initconst = {
 	.factors = &sun4i_pll6_data,
+	.ndivs = 2,
 	.div = {
 		{ .shift = 0, .table = pll6_sata_tbl, .gate = 14 }, /* M, SATA */
 		{ .fixed = 2 }, /* P, other */
@@ -990,7 +993,7 @@ static void __init sunxi_divs_clk_setup(struct device_node *node,
 	struct clk_fixed_factor *fix_factor;
 	struct clk_divider *divider;
 	void *reg;
-	int i = 0;
+	int ndivs = SUNXI_DIVS_MAX_QTY, i = 0;
 	int flags, clkflags;
 
 	/* Set up factor clock that we will be dividing */
@@ -1013,7 +1016,11 @@ static void __init sunxi_divs_clk_setup(struct device_node *node,
 	 * our RAM clock! */
 	clkflags = !strcmp("pll5", parent) ? 0 : CLK_SET_RATE_PARENT;
 
-	for (i = 0; i < SUNXI_DIVS_MAX_QTY; i++) {
+	/* if number of children known, use it */
+	if (data->ndivs)
+		ndivs = data->ndivs;
+
+	for (i = 0; i < ndivs; i++) {
 		if (of_property_read_string_index(node, "clock-output-names",
 						  i, &clk_name) != 0)
 			break;
-- 
2.0.0.rc2

