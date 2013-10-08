Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752625Ab3JHCeW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 22:34:22 -0400
Received: from mail-ye0-f171.google.com ([209.85.213.171]:37257 "EHLO
	mail-ye0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751806Ab3JHCeT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 22:34:19 -0400
From: Felipe Pena <felipensp@gmail.com>
To: Mike Turquette <mturquette@linaro.org>,
        Michal Simek <michal.simek@xilinx.com>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        =?UTF-8?q?S=C3=B6ren=20Brinkmann?= <soren.brinkmann@xilinx.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Felipe Pena <felipensp@gmail.com>
Subject: =?UTF-8?q?=5BPATCHv2=201/1=5D=20clk/zynq=3A=20Fix=20possible=20memory=20leak?=
Date: Mon,  7 Oct 2013 23:25:44 -0300
Message-Id: <1381199144-5827-1-git-send-email-felipensp@gmail.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The zynq_clk_register_fclk function can leak memory (fclk_lock) when unable
to alloc memory for fclk_gate_lock

Signed-off-by: Felipe Pena <felipensp@gmail.com>
Acked-by: Sören Brinkmann <soren.brinkmann@xilinx.com>
---
 drivers/clk/zynq/clkc.c |   16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/drivers/clk/zynq/clkc.c b/drivers/clk/zynq/clkc.c
index cc40fe6..10772aa 100644
--- a/drivers/clk/zynq/clkc.c
+++ b/drivers/clk/zynq/clkc.c
@@ -117,13 +117,19 @@ static void __init zynq_clk_register_fclk(enum zynq_clk fclk,
 		goto err;
 	fclk_gate_lock = kmalloc(sizeof(*fclk_gate_lock), GFP_KERNEL);
 	if (!fclk_gate_lock)
-		goto err;
+		goto err_fclk_gate_lock;
 	spin_lock_init(fclk_lock);
 	spin_lock_init(fclk_gate_lock);

 	mux_name = kasprintf(GFP_KERNEL, "%s_mux", clk_name);
+	if (!mux_name)
+		goto err_mux_name;
 	div0_name = kasprintf(GFP_KERNEL, "%s_div0", clk_name);
+	if (!div0_name)
+		goto err_div0_name;
 	div1_name = kasprintf(GFP_KERNEL, "%s_div1", clk_name);
+	if (!div1_name)
+		goto err_div1_name;

 	clk = clk_register_mux(NULL, mux_name, parents, 4,
 			CLK_SET_RATE_NO_REPARENT, fclk_ctrl_reg, 4, 2, 0,
@@ -147,6 +153,14 @@ static void __init zynq_clk_register_fclk(enum zynq_clk fclk,

 	return;

+err_div1_name:
+	kfree(div0_name);
+err_div0_name:
+	kfree(mux_name);
+err_mux_name:
+	kfree(fclk_gate_lock);
+err_fclk_gate_lock:
+	kfree(fclk_lock);
 err:
 	clks[fclk] = ERR_PTR(-ENOMEM);
 }
--
1.7.10.4

