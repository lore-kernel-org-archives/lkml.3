Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759945AbaJCXWA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 19:22:00 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46796 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757799AbaJCWNo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 18:13:44 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Nishanth Menon <nm@ti.com>, Tero Kristo <t-kristo@ti.com>
Subject: [PATCH 3.16 349/357] clk: ti: divider: Provide error check for incoming parameters in set_rate
Date: Fri,  3 Oct 2014 14:32:15 -0700
Message-Id: <20141003212943.938244177@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141003212933.458851516@linuxfoundation.org>
References: <20141003212933.458851516@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nishanth Menon <nm@ti.com>

commit 2f1032517623b70920d99529e5c87c8c680ab8bf upstream.

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
Signed-off-by: Tero Kristo <t-kristo@ti.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/clk/ti/divider.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/clk/ti/divider.c
+++ b/drivers/clk/ti/divider.c
@@ -211,11 +211,16 @@ static long ti_clk_divider_round_rate(st
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
 


