Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756788Ab3A3UaU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 15:30:20 -0500
Received: from mail-bk0-f52.google.com ([209.85.214.52]:58029 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752122Ab3A3UaQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 15:30:16 -0500
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Simon Baatz <gmbnomis@gmail.com>, Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>, Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/2] ARM: kirkwood: fix to retain gbe MAC addresses for DT kernels
Date: Wed, 30 Jan 2013 21:29:58 +0100
Message-Id: <1359577799-23351-1-git-send-email-sebastian.hesselbarth@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <20130130183049.GR7717@titan.lakedaemon.net>
References: <20130130183049.GR7717@titan.lakedaemon.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ethernet controller used on kirkwood looses its MAC address
register contents when the corresponding clock is gated. As soon as
mv643xx_eth is built as module, the clock gets gated and when loading
the module, the MAC address is gone.

Proper DT support for the mv643xx_eth driver is expected soon, so we add
a workaround to always enable ge0/ge1 clocks on kirkwood. This workaround
is also already used on non-DT kirkwood kernels.

Reported-by: Simon Baatz <gmbnomis@gmail.com>
Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
---
Changelog:
[v2]
- add note in patch description that MAC address is lost only when using
  modular driver
- add note in patch description that the workaround will be removed soon

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

