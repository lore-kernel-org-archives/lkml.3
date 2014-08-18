Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751796AbaHRQ5W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 12:57:22 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:56615 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751652AbaHRQ5U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 12:57:20 -0400
From: Nishanth Menon <nm@ti.com>
To: Tero Kristo <t-kristo@ti.com>, Mike Turquette <mturquette@linaro.org>
CC: <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, Nishanth Menon <nm@ti.com>
Subject: [PATCH 1/2] clk: ti: divider: Provide error check for incoming parameters in set_rate
Date: Mon, 18 Aug 2014 11:56:54 -0500
Message-ID: <1408381015-16042-2-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1408381015-16042-1-git-send-email-nm@ti.com>
References: <1408381015-16042-1-git-send-email-nm@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Check for valid parameters in check rate. Else, we end up getting errors
like:
[    0.000000] Division by zero in kernel.
[    0.000000] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.17.0-rc1 #1
[    0.000000] [<c0015160>] (unwind_backtrace) from [<c0011978>] (show_stack+0x10/0x14)
[    0.000000] [<c0011978>] (show_stack) from [<c055f5f4>] (dump_stack+0x78/0x94)
[    0.000000] [<c055f5f4>] (dump_stack) from [<c02e17cc>] (Ldiv0+0x8/0x10)
[    0.000000] [<c02e17cc>] (Ldiv0) from [<c047d228>] (ti_clk_divider_set_rate+0x14/0x14c)
[    0.000000] [<c047d228>] (ti_clk_divider_set_rate) from [<c047a938>] (clk_change_rate+0x138/0x180)
[    0.000000] [<c047a938>] (clk_change_rate) from [<c047a908>] (clk_change_rate+0x108/0x180)

This occurs as part of the inital clock tree update of child clock nodes
where new_rate could be 0 for non functional clocks.

Fixes: b4761198bfaf296 ("CLK: ti: add support for ti divider-clock")
Signed-off-by: Nishanth Menon <nm@ti.com>
---
 drivers/clk/ti/divider.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/clk/ti/divider.c b/drivers/clk/ti/divider.c
index e6aa10d..a837f70 100644
--- a/drivers/clk/ti/divider.c
+++ b/drivers/clk/ti/divider.c
@@ -211,11 +211,16 @@ static long ti_clk_divider_round_rate(struct clk_hw *hw, unsigned long rate,
 static int ti_clk_divider_set_rate(struct clk_hw *hw, unsigned long rate,
 				   unsigned long parent_rate)
 {
-	struct clk_divider *divider = to_clk_divider(hw);
+	struct clk_divider *divider;
 	unsigned int div, value;
 	unsigned long flags = 0;
 	u32 val;
 
+	if (!hw || !rate)
+		return -EINVAL;
+
+	divider = to_clk_divider(hw);
+
 	div = DIV_ROUND_UP(parent_rate, rate);
 	value = _get_val(divider, div);
 
-- 
1.7.9.5

