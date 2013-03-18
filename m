Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932361Ab3CRV6E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 17:58:04 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45569 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755476Ab3CRVGt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 17:06:49 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Simon Baatz <gmbnomis@gmail.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Jason Cooper <jason@lakedaemon.net>
Subject: [ 28/75] ARM: kirkwood: fix to retain gbe MAC addresses for DT kernels
Date: Mon, 18 Mar 2013 14:06:51 -0700
Message-Id: <20130318210512.273792876@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.2.434.g9a6c84e.dirty
In-Reply-To: <20130318210510.203500214@linuxfoundation.org>
References: <20130318210510.203500214@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>

commit 7bf5b408b419fc849578e6e9fbd221bf43638eb6 upstream.

The ethernet controller used on kirkwood looses its MAC address
register contents when the corresponding clock is gated. As soon as
mv643xx_eth is built as module, the clock gets gated and when loading
the module, the MAC address is gone.

Proper DT support for the mv643xx_eth driver is expected soon, so we add
a workaround to always enable ge0/ge1 clocks on kirkwood. This workaround
is also already used on non-DT kirkwood kernels.

Reported-by: Simon Baatz <gmbnomis@gmail.com>
Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Tested-by: Simon Baatz <gmbnomis@gmail.com>
Signed-off-by: Jason Cooper <jason@lakedaemon.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/mach-kirkwood/board-dt.c |   24 +++++++++++++++---------
 1 file changed, 15 insertions(+), 9 deletions(-)

--- a/arch/arm/mach-kirkwood/board-dt.c
+++ b/arch/arm/mach-kirkwood/board-dt.c
@@ -41,16 +41,12 @@ static void __init kirkwood_legacy_clk_i
 
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
@@ -63,14 +59,24 @@ static void __init kirkwood_legacy_clk_i
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


