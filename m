Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753753Ab3JDKOW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 06:14:22 -0400
Received: from mail-bk0-f53.google.com ([209.85.214.53]:35090 "EHLO
	mail-bk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752167Ab3JDKOV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 06:14:21 -0400
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@linaro.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Mike Turquette <mturquette@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3] ARM: kirkwood: remove ethernet clock gate workaround
Date: Fri,  4 Oct 2013 12:13:50 +0200
Message-Id: <1380881630-24439-1-git-send-email-sebastian.hesselbarth@gmail.com>
In-Reply-To: <1380826568-18587-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1380826568-18587-1-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With a proper fix for Kirkwood ethernet IP MAC address clock gating
issue, we can now remove the clock gating workaround that always
enabled ethernet clocks.

Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
---
Changelog:
v2->v3:
- make use of new public clk_is_enabled, adds dependency to [1]
- add warning about gated clock && missing MAC property
  (Suggested by Jason Gunthorpe)
v1->v2:
- check for gated clock before accessing eth registers
  (Suggested by Andrew Lunn)

[1] http://www.spinics.net/lists/arm-kernel/msg277392.html

Cc: Jason Cooper <jason@lakedaemon.net>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Grant Likely <grant.likely@linaro.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
Cc: Mike Turquette <mturquette@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 arch/arm/mach-kirkwood/board-dt.c |   14 --------------
 1 file changed, 14 deletions(-)

diff --git a/arch/arm/mach-kirkwood/board-dt.c b/arch/arm/mach-kirkwood/board-dt.c
index 28e952b..6925de8 100644
--- a/arch/arm/mach-kirkwood/board-dt.c
+++ b/arch/arm/mach-kirkwood/board-dt.c
@@ -41,7 +41,6 @@ static void __init kirkwood_legacy_clk_init(void)
 	struct device_node *np = of_find_compatible_node(
 		NULL, NULL, "marvell,kirkwood-gating-clock");
 	struct of_phandle_args clkspec;
-	struct clk *clk;
 
 	clkspec.np = np;
 	clkspec.args_count = 1;
@@ -53,19 +52,6 @@ static void __init kirkwood_legacy_clk_init(void)
 	clkspec.args[0] = CGC_BIT_PEX1;
 	orion_clkdev_add("1", "pcie",
 			 of_clk_get_from_provider(&clkspec));
-
-	/*
-	 * The ethernet interfaces forget the MAC address assigned by
-	 * u-boot if the clocks are turned off. Until proper DT support
-	 * is available we always enable them for now.
-	 */
-	clkspec.args[0] = CGC_BIT_GE0;
-	clk = of_clk_get_from_provider(&clkspec);
-	clk_prepare_enable(clk);
-
-	clkspec.args[0] = CGC_BIT_GE1;
-	clk = of_clk_get_from_provider(&clkspec);
-	clk_prepare_enable(clk);
 }
 
 #define MV643XX_ETH_MAC_ADDR_LOW	0x0414
-- 
1.7.10.4

