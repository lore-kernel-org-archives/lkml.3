Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752551AbaAYST3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jan 2014 13:19:29 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:59512 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752397AbaAYST1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jan 2014 13:19:27 -0500
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Mike Turquette <mturquette@linaro.org>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] clk: mvebu: armada-xp: maintain clock init order
Date: Sat, 25 Jan 2014 19:19:08 +0100
Message-Id: <1390673950-4521-3-git-send-email-sebastian.hesselbarth@gmail.com>
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
 drivers/clk/mvebu/armada-xp.c | 20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

diff --git a/drivers/clk/mvebu/armada-xp.c b/drivers/clk/mvebu/armada-xp.c
index 9922c4475aa8..b3094315a3c0 100644
--- a/drivers/clk/mvebu/armada-xp.c
+++ b/drivers/clk/mvebu/armada-xp.c
@@ -158,13 +158,6 @@ static const struct coreclk_soc_desc axp_coreclks = {
 	.num_ratios = ARRAY_SIZE(axp_coreclk_ratios),
 };
 
-static void __init axp_coreclk_init(struct device_node *np)
-{
-	mvebu_coreclk_setup(np, &axp_coreclks);
-}
-CLK_OF_DECLARE(axp_core_clk, "marvell,armada-xp-core-clock",
-	       axp_coreclk_init);
-
 /*
  * Clock Gating Control
  */
@@ -202,9 +195,14 @@ static const struct clk_gating_soc_desc axp_gating_desc[] __initconst = {
 	{ }
 };
 
-static void __init axp_clk_gating_init(struct device_node *np)
+static void __init axp_clk_init(struct device_node *np)
 {
-	mvebu_clk_gating_setup(np, axp_gating_desc);
+	struct device_node *cgnp =
+		of_find_compatible_node(NULL, NULL, "marvell,armada-xp-gating-clock");
+
+	mvebu_coreclk_setup(np, &axp_coreclks);
+
+	if (cgnp)
+		mvebu_clk_gating_setup(cgnp, axp_gating_desc);
 }
-CLK_OF_DECLARE(axp_clk_gating, "marvell,armada-xp-gating-clock",
-	       axp_clk_gating_init);
+CLK_OF_DECLARE(axp_clk, "marvell,armada-xp-core-clock", axp_clk_init);
-- 
1.8.5.2

