Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753444Ab3A3B1J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 20:27:09 -0500
Received: from mail-ea0-f173.google.com ([209.85.215.173]:46062 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753243Ab3A3B1F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 20:27:05 -0500
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Simon Baatz <gmbnomis@gmail.com>, Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>, Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] ARM: kirkwood: fix to retain gbe MAC addresses for DT kernels
Date: Wed, 30 Jan 2013 02:26:41 +0100
Message-Id: <1359509201-11674-2-git-send-email-sebastian.hesselbarth@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1359509201-11674-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1359509201-11674-1-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ethernet controller used on kirkwood looses its MAC address
register contents when the corresponding clock is gated. Until there
is proper DT support for the mv643xx_eth driver, we add a workaround
to always enable ge0/ge1 clocks on kirkwood. This workaround is also
already used on non-DT kirkwood kernels.

Reported-by: Simon Baatz <gmbnomis@gmail.com>
Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
---
Cc: Simon Baatz <gmbnomis@gmail.com>
Cc: Jason Cooper <jason@lakedaemon.net>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 arch/arm/mach-kirkwood/board-dt.c |   24 +++++++++++++++---------
 1 file changed, 15 insertions(+), 9 deletions(-)

diff --git a/arch/arm/mach-kirkwood/board-dt.c b/arch/arm/mach-kirkwood/board-dt.c
index de4fd2b..e714ead 100644
--- a/arch/arm/mach-kirkwood/board-dt.c
+++ b/arch/arm/mach-kirkwood/board-dt.c
@@ -41,16 +41,12 @@ static void __init kirkwood_legacy_clk_init(void)
 
 	struct device_node *np = of_find_compatible_node(
 		NULL, NULL, "marvell,kirkwood-gating-clock");
-
 	struct of_phandle_args clkspec;
+	struct clk *clk;
 
 	clkspec.np = np;
 	clkspec.args_count = 1;
 
-	clkspec.args[0] = CGC_BIT_GE0;
-	orion_clkdev_add(NULL, "mv643xx_eth_port.0",
-			 of_clk_get_from_provider(&clkspec));
-
 	clkspec.args[0] = CGC_BIT_PEX0;
 	orion_clkdev_add("0", "pcie",
 			 of_clk_get_from_provider(&clkspec));
@@ -63,14 +59,24 @@ static void __init kirkwood_legacy_clk_init(void)
 	orion_clkdev_add("1", "pcie",
 			 of_clk_get_from_provider(&clkspec));
 
-	clkspec.args[0] = CGC_BIT_GE1;
-	orion_clkdev_add(NULL, "mv643xx_eth_port.1",
-			 of_clk_get_from_provider(&clkspec));
-
 	clkspec.args[0] = CGC_BIT_SDIO;
 	orion_clkdev_add(NULL, "mvsdio",
 			 of_clk_get_from_provider(&clkspec));
 
+	/*
+	 * The ethernet interfaces forget the MAC address assigned by
+	 * u-boot if the clocks are turned off. Until proper DT support
+	 * is available we always enable them for now.
+	 */
+	clkspec.args[0] = CGC_BIT_GE0;
+	clk = of_clk_get_from_provider(&clkspec);
+	orion_clkdev_add(NULL, "mv643xx_eth_port.0", clk);
+	clk_prepare_enable(clk);
+
+	clkspec.args[0] = CGC_BIT_GE1;
+	clk = of_clk_get_from_provider(&clkspec);
+	orion_clkdev_add(NULL, "mv643xx_eth_port.1", clk);
+	clk_prepare_enable(clk);
 }
 
 static void __init kirkwood_of_clk_init(void)
-- 
1.7.10.4

