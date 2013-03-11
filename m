Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754713Ab3CKVOE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 17:14:04 -0400
Received: from mail-db8lp0189.outbound.messaging.microsoft.com ([213.199.154.189]:25197
	"EHLO db8outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754011Ab3CKVOC convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 17:14:02 -0400
X-Forefront-Antispam-Report: CIP:149.199.60.83;KIP:(null);UIP:(null);IPV:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzc89bh4015Izz1f42h1ee6h1de0h1202h1e76h1d1ah1d2ahzz8275bhz2fh95h668h839h93fhd24hf0ah119dh1288h12a5h12a9h12bdh137ah139eh13b6h1441h14ddh1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1b0ah906i1155h)
From: Soren Brinkmann <soren.brinkmann@xilinx.com>
To: Mike Turquette <mturquette@linaro.org>, Shawn Guo <shawn.guo@linaro.org>,
        Rajendra Nayak <rnayak@ti.com>, Andrew Lunn <andrew@lunn.ch>,
        James Hogan <james.hogan@imgtec.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Soren Brinkmann <soren.brinkmann@xilinx.com>
Subject: [PATCH RFC] clk: divider: Tolerate 0 divider for one based dividers
Date: Mon, 11 Mar 2013 14:13:37 -0700
X-Mailer: git-send-email 1.8.1.5
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
X-OriginalArrivalTime: 11 Mar 2013 21:13:54.0075 (UTC) FILETIME=[55EF06B0:01CE1E9D]
X-RCIS-Action: ALLOW
Message-ID: <dbceb80f-0303-4ba0-acd8-336dd85444ae@DB8EHSMHS017.ehs.local>
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Handle a zero divider value as one/bypass for dividers which have the
CLK_DIVIDER_ONE_BASED flag set.

Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
---
In Zynq we have a lot of dividers which are one based, but at the same time
zero is a valid value which is handled as one/bypass. Also, the reset value of
some of these registers is zero, resulting in warnings when the clock framework
encounters this.

So, my question here is: Are our dividers odd? Does it make sense to allow zero
for all one based dividers, as shown in this patch? Or does this behavior
qualify for another flag for the divider clocks (e.g. CLK_DIVIDER_ZERO_OKAY)?

	Thanks,
	Sören

 drivers/clk/clk-divider.c    | 5 +++--
 include/linux/clk-provider.h | 4 ++--
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/clk/clk-divider.c b/drivers/clk/clk-divider.c
index 68b4021..6c2a431 100644
--- a/drivers/clk/clk-divider.c
+++ b/drivers/clk/clk-divider.c
@@ -109,8 +109,9 @@ static unsigned long clk_divider_recalc_rate(struct clk_hw *hw,
 
 	div = _get_div(divider, val);
 	if (!div) {
-		WARN(1, "%s: Invalid divisor for clock %s\n", __func__,
-						__clk_get_name(hw->clk));
+		WARN(!(divider->flags & CLK_DIVIDER_ONE_BASED),
+				"%s: Invalid divisor for clock %s\n", __func__,
+				__clk_get_name(hw->clk));
 		return parent_rate;
 	}
 
diff --git a/include/linux/clk-provider.h b/include/linux/clk-provider.h
index 7f197d7..5b19b13 100644
--- a/include/linux/clk-provider.h
+++ b/include/linux/clk-provider.h
@@ -238,8 +238,8 @@ struct clk_div_table {
  * Flags:
  * CLK_DIVIDER_ONE_BASED - by default the divisor is the value read from the
  * 	register plus one.  If CLK_DIVIDER_ONE_BASED is set then the divider is
- * 	the raw value read from the register, with the value of zero considered
- * 	invalid
+ *	the raw value read from the register. A zero divider is considered to be
+ *	the same as the a value of one.
  * CLK_DIVIDER_POWER_OF_TWO - clock divisor is 2 raised to the value read from
  * 	the hardware register
  */
-- 
1.8.1.5


