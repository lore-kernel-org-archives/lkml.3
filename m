Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751686AbaDQSlh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 14:41:37 -0400
Received: from mail-qg0-f45.google.com ([209.85.192.45]:47998 "EHLO
	mail-qg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751104AbaDQSl2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 14:41:28 -0400
From: Soren Brinkmann <soren.brinkmann@xilinx.com>
To: Mike Turquette <mturquette@linaro.org>,
        Michal Simek <michal.simek@xilinx.com>
Cc: =?UTF-8?q?S=C3=B6ren=20Brinkmann?= <soren.brinkmann@xilinx.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        git@xilinx.com, Stephen Boyd <sboyd@codeaurora.org>,
        Stephen Warren <swarren@nvidia.com>,
        James Hogan <james.hogan@imgtec.com>,
        Felipe Pena <felipensp@gmail.com>
Subject: [PATCH] clk: zynq: Leave debug clocks in bootup state
Date: Thu, 17 Apr 2014 11:40:52 -0700
Message-Id: <1397760052-3310-1-git-send-email-soren.brinkmann@xilinx.com>
X-Mailer: git-send-email 1.9.2.1.g06c4abd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make sure debug clocks stay enabled if the bootloader enabled them.
Otherwise debug HW may crash due to bus-hangs caused by stopped clocks.

Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
---
 drivers/clk/zynq/clkc.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/clk/zynq/clkc.c b/drivers/clk/zynq/clkc.c
index 52c09afdcfb7..246cf1226eaa 100644
--- a/drivers/clk/zynq/clkc.c
+++ b/drivers/clk/zynq/clkc.c
@@ -53,6 +53,9 @@ static void __iomem *zynq_clkc_base;
 
 #define NUM_MIO_PINS	54
 
+#define DBG_CLK_CTRL_CLKACT_TRC		BIT(0)
+#define DBG_CLK_CTRL_CPU_1XCLKACT	BIT(1)
+
 enum zynq_clk {
 	armpll, ddrpll, iopll,
 	cpu_6or4x, cpu_3or2x, cpu_2x, cpu_1x,
@@ -499,6 +502,15 @@ static void __init zynq_clk_setup(struct device_node *np)
 			clk_output_name[cpu_1x], 0, SLCR_DBG_CLK_CTRL, 1, 0,
 			&dbgclk_lock);
 
+	/* leave debug clocks in the state the bootloader set them up to */
+	tmp = clk_readl(SLCR_DBG_CLK_CTRL);
+	if (tmp & DBG_CLK_CTRL_CLKACT_TRC)
+		if (clk_prepare_enable(clks[dbg_trc]))
+			pr_warn("%s: trace clk enable failed\n", __func__);
+	if (tmp & DBG_CLK_CTRL_CPU_1XCLKACT)
+		if (clk_prepare_enable(clks[dbg_apb]))
+			pr_warn("%s: debug APB clk enable failed\n", __func__);
+
 	/* One gated clock for all APER clocks. */
 	clks[dma] = clk_register_gate(NULL, clk_output_name[dma],
 			clk_output_name[cpu_2x], 0, SLCR_APER_CLK_CTRL, 0, 0,
-- 
1.9.2.1.g06c4abd

