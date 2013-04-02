Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933841Ab3DBWhe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 18:37:34 -0400
Received: from db3ehsobe001.messaging.microsoft.com ([213.199.154.139]:3710
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933488Ab3DBWh2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 18:37:28 -0400
X-Forefront-Antispam-Report: CIP:149.199.60.83;KIP:(null);UIP:(null);IPV:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
X-SpamScore: 1
X-BigFish: VPS1(zzzz1f42h1fc6h1ee6h1de0h1202h1e76h1d1ah1d2ahzz8275bhz2fh95h668h839hd24hf0ah119dh1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h14ddh1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1b0ah906i1155h)
From: Soren Brinkmann <soren.brinkmann@xilinx.com>
To: Mike Turquette <mturquette@linaro.org>
CC: Shawn Guo <shawn.guo@linaro.org>, Rajendra Nayak <rnayak@ti.com>,
        Andrew Lunn <andrew@lunn.ch>, James Hogan <james.hogan@imgtec.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Soren Brinkmann <soren.brinkmann@xilinx.com>
Subject: [PATCH] clk: divider: Introduce CLK_DIVIDER_ALLOW_ZERO flag
Date: Tue, 2 Apr 2013 15:36:56 -0700
X-Mailer: git-send-email 1.8.2
X-RCIS-Action: ALLOW
MIME-Version: 1.0
Content-Type: text/plain
Message-ID: <397e02df-e5d1-4211-8a44-2ee15cf4188f@DB3EHSMHS005.ehs.local>
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dividers which have CLK_DIVIDER_ONE_BASED set have a redundant state,
being a divider value of zero. Some hardware implementations allow a
zero divider which simply doesn't alter the frequency. I.e. it acts like
a divide by one or bypassing the divider.
This flag is used to handle such HW in the clk-divider model.

Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
---
 drivers/clk/clk-divider.c    | 5 +++--
 include/linux/clk-provider.h | 8 +++++++-
 2 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/clk/clk-divider.c b/drivers/clk/clk-divider.c
index 68b4021..6d96741 100644
--- a/drivers/clk/clk-divider.c
+++ b/drivers/clk/clk-divider.c
@@ -109,8 +109,9 @@ static unsigned long clk_divider_recalc_rate(struct clk_hw *hw,
 
 	div = _get_div(divider, val);
 	if (!div) {
-		WARN(1, "%s: Invalid divisor for clock %s\n", __func__,
-						__clk_get_name(hw->clk));
+		WARN(!(divider->flags & CLK_DIVIDER_ALLOW_ZERO),
+			"%s: Zero divisor and CLK_DIVIDER_ALLOW_ZERO not set\n",
+			__clk_get_name(hw->clk));
 		return parent_rate;
 	}
 
diff --git a/include/linux/clk-provider.h b/include/linux/clk-provider.h
index 7f197d7..811426d 100644
--- a/include/linux/clk-provider.h
+++ b/include/linux/clk-provider.h
@@ -239,9 +239,14 @@ struct clk_div_table {
  * CLK_DIVIDER_ONE_BASED - by default the divisor is the value read from the
  * 	register plus one.  If CLK_DIVIDER_ONE_BASED is set then the divider is
  * 	the raw value read from the register, with the value of zero considered
- * 	invalid
+ *	invalid, unless CLK_DIVIDER_ALLOW_ZERO is set.
  * CLK_DIVIDER_POWER_OF_TWO - clock divisor is 2 raised to the value read from
  * 	the hardware register
+ * CLK_DIVIDER_ALLOW_ZERO - Allow zero divisors.  For dividers which have
+ *	CLK_DIVIDER_ONE_BASED set, it is possible to end up with a zero divisor.
+ *	Some hardware implementations gracefully handle this case and allow a
+ *	zero divisor by not modifying their input clock
+ *	(divide by one / bypass).
  */
 struct clk_divider {
 	struct clk_hw	hw;
@@ -255,6 +260,7 @@ struct clk_divider {
 
 #define CLK_DIVIDER_ONE_BASED		BIT(0)
 #define CLK_DIVIDER_POWER_OF_TWO	BIT(1)
+#define CLK_DIVIDER_ALLOW_ZERO		BIT(2)
 
 extern const struct clk_ops clk_divider_ops;
 struct clk *clk_register_divider(struct device *dev, const char *name,
-- 
1.8.2


