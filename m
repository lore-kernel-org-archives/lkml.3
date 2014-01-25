Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752641AbaAYSTc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jan 2014 13:19:32 -0500
Received: from mail-ea0-f180.google.com ([209.85.215.180]:43071 "EHLO
	mail-ea0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752473AbaAYST3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jan 2014 13:19:29 -0500
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Mike Turquette <mturquette@linaro.org>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] clk: mvebu: kirkwood: maintain clock init order
Date: Sat, 25 Jan 2014 19:19:10 +0100
Message-Id: <1390673950-4521-5-git-send-email-sebastian.hesselbarth@gmail.com>
In-Reply-To: <1390673950-4521-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1390673950-4521-1-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Init order of CLK_OF_DECLARE'd drivers depends on compile order.
Unfortunately, clk_of_init does not allow drivers to return errors,
e.g. -EPROBE_DEFER if parent clocks have not been registered, yet.

To avoid init order woes for MVEBU clock drivers, we take care of
proper init order ourselves. This patch joins core-clk and gating-clk
init to maintain proper init order.

Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
---
Cc: Mike Turquette <mturquette@linaro.org>
Cc: Jason Cooper <jason@lakedaemon.net>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Gregory Clement <gregory.clement@free-electrons.com>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/clk/mvebu/kirkwood.c | 34 ++++++++++++++++------------------
 1 file changed, 16 insertions(+), 18 deletions(-)

diff --git a/drivers/clk/mvebu/kirkwood.c b/drivers/clk/mvebu/kirkwood.c
index 2636a55f29f9..ddb666a86500 100644
--- a/drivers/clk/mvebu/kirkwood.c
+++ b/drivers/clk/mvebu/kirkwood.c
@@ -193,13 +193,6 @@ static const struct coreclk_soc_desc kirkwood_coreclks = {
 	.num_ratios = ARRAY_SIZE(kirkwood_coreclk_ratios),
 };
 
-static void __init kirkwood_coreclk_init(struct device_node *np)
-{
-	mvebu_coreclk_setup(np, &kirkwood_coreclks);
-}
-CLK_OF_DECLARE(kirkwood_core_clk, "marvell,kirkwood-core-clock",
-	       kirkwood_coreclk_init);
-
 static const struct coreclk_soc_desc mv88f6180_coreclks = {
 	.get_tclk_freq = kirkwood_get_tclk_freq,
 	.get_cpu_freq = mv88f6180_get_cpu_freq,
@@ -208,13 +201,6 @@ static const struct coreclk_soc_desc mv88f6180_coreclks = {
 	.num_ratios = ARRAY_SIZE(kirkwood_coreclk_ratios),
 };
 
-static void __init mv88f6180_coreclk_init(struct device_node *np)
-{
-	mvebu_coreclk_setup(np, &mv88f6180_coreclks);
-}
-CLK_OF_DECLARE(mv88f6180_core_clk, "marvell,mv88f6180-core-clock",
-	       mv88f6180_coreclk_init);
-
 /*
  * Clock Gating Control
  */
@@ -239,9 +225,21 @@ static const struct clk_gating_soc_desc kirkwood_gating_desc[] __initconst = {
 	{ }
 };
 
-static void __init kirkwood_clk_gating_init(struct device_node *np)
+static void __init kirkwood_clk_init(struct device_node *np)
 {
-	mvebu_clk_gating_setup(np, kirkwood_gating_desc);
+	struct device_node *cgnp =
+		of_find_compatible_node(NULL, NULL, "marvell,kirkwood-gating-clock");
+
+
+	if (of_device_is_compatible(np, "marvell,mv88f6180-core-clock"))
+		mvebu_coreclk_setup(np, &mv88f6180_coreclks);
+	else
+		mvebu_coreclk_setup(np, &kirkwood_coreclks);
+
+	if (cgnp)
+		mvebu_clk_gating_setup(cgnp, kirkwood_gating_desc);
 }
-CLK_OF_DECLARE(kirkwood_clk_gating, "marvell,kirkwood-gating-clock",
-	       kirkwood_clk_gating_init);
+CLK_OF_DECLARE(kirkwood_clk, "marvell,kirkwood-core-clock",
+	       kirkwood_clk_init);
+CLK_OF_DECLARE(mv88f6180_clk, "marvell,mv88f6180-core-clock",
+	       kirkwood_clk_init);
-- 
1.8.5.2

