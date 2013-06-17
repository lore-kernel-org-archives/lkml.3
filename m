Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752054Ab3FQWEE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 18:04:04 -0400
Received: from mail-pb0-f53.google.com ([209.85.160.53]:54365 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751821Ab3FQWEC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 18:04:02 -0400
From: Soren Brinkmann <soren.brinkmann@xilinx.com>
To: Michal Simek <michal.simek@xilinx.com>,
        Mike Turquette <mturquette@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Soren Brinkmann <soren.brinkmann@xilinx.com>
Subject: [PATCH] clk/zynq/clkc: Add dedicated spinlock for the SWDT
Date: Mon, 17 Jun 2013 15:03:46 -0700
Message-Id: <1371506626-3892-1-git-send-email-soren.brinkmann@xilinx.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The clk_mux for the system watchdog timer reused the register lock
dedicated to the Ethernet module - for no apparent reason.
Add a lock dedicated to the SWDT's clock register to remove this
wrong dependency.

Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
---
I don't know how this slipped in...
Anyway, the fix depends on armsoc/zynq/clk.

	Sören

 drivers/clk/zynq/clkc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/clk/zynq/clkc.c b/drivers/clk/zynq/clkc.c
index 5c205b6..515a573 100644
--- a/drivers/clk/zynq/clkc.c
+++ b/drivers/clk/zynq/clkc.c
@@ -71,6 +71,7 @@ static DEFINE_SPINLOCK(armpll_lock);
 static DEFINE_SPINLOCK(ddrpll_lock);
 static DEFINE_SPINLOCK(iopll_lock);
 static DEFINE_SPINLOCK(armclk_lock);
+static DEFINE_SPINLOCK(swdtclk_lock);
 static DEFINE_SPINLOCK(ddrclk_lock);
 static DEFINE_SPINLOCK(dciclk_lock);
 static DEFINE_SPINLOCK(gem0clk_lock);
@@ -293,7 +294,7 @@ static void __init zynq_clk_setup(struct device_node *np)
 	}
 	clks[swdt] = clk_register_mux(NULL, clk_output_name[swdt],
 			swdt_ext_clk_mux_parents, 2, CLK_SET_RATE_PARENT,
-			SLCR_SWDT_CLK_SEL, 0, 1, 0, &gem0clk_lock);
+			SLCR_SWDT_CLK_SEL, 0, 1, 0, &swdtclk_lock);
 
 	/* DDR clocks */
 	clk = clk_register_divider(NULL, "ddr2x_div", "ddrpll", 0,
-- 
1.8.3.1

