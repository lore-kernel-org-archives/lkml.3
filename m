Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752960Ab3KAG2f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 02:28:35 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:32191 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751682Ab3KAG2e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 02:28:34 -0400
From: <chenxg@marvell.com>
To: <mturquette@linaro.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
CC: <chenxg@marvell.com>, <chenxg.marvell@gmail.com>
Subject: [PATCH] clk: align clock rate unit to unsigned long
Date: Fri, 1 Nov 2013 14:27:15 +0800
Message-ID: <1383287235-19583-1-git-send-email-chenxg@marvell.com>
X-Mailer: git-send-email 1.8.0
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.10.8794,1.0.431,0.0.0000
 definitions=2013-11-01_02:2013-11-01,2013-11-01,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1305240000 definitions=main-1310310328
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Xiaoguang Chen <chenxg@marvell.com>

Clock rate unit should use unsigned long instead of long.
Otherwise clock rate that is higher than 2Ghz will become negative.
Align the unit to unsigned long to make sure no long to unsigned
long conversion happens.

Signed-off-by: Xiaoguang Chen <chenxg@marvell.com>
---
 drivers/clk/clk-composite.c    | 4 ++--
 drivers/clk/clk-divider.c      | 4 ++--
 drivers/clk/clk-fixed-factor.c | 4 ++--
 drivers/clk/clk.c              | 4 ++--
 4 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/clk/clk-composite.c b/drivers/clk/clk-composite.c
index a33f46f..e091b83 100644
--- a/drivers/clk/clk-composite.c
+++ b/drivers/clk/clk-composite.c
@@ -55,8 +55,8 @@ static unsigned long clk_composite_recalc_rate(struct clk_hw *hw,
 	return rate_ops->recalc_rate(rate_hw, parent_rate);
 }
 
-static long clk_composite_round_rate(struct clk_hw *hw, unsigned long rate,
-				  unsigned long *prate)
+static unsigned long clk_composite_round_rate(struct clk_hw *hw,
+			unsigned long rate, unsigned long *prate)
 {
 	struct clk_composite *composite = to_clk_composite(hw);
 	const struct clk_ops *rate_ops = composite->rate_ops;
diff --git a/drivers/clk/clk-divider.c b/drivers/clk/clk-divider.c
index 8d3009e..280fd41 100644
--- a/drivers/clk/clk-divider.c
+++ b/drivers/clk/clk-divider.c
@@ -201,8 +201,8 @@ static int clk_divider_bestdiv(struct clk_hw *hw, unsigned long rate,
 	return bestdiv;
 }
 
-static long clk_divider_round_rate(struct clk_hw *hw, unsigned long rate,
-				unsigned long *prate)
+static unsigned long clk_divider_round_rate(struct clk_hw *hw,
+			unsigned long rate, unsigned long *prate)
 {
 	int div;
 	div = clk_divider_bestdiv(hw, rate, prate);
diff --git a/drivers/clk/clk-fixed-factor.c b/drivers/clk/clk-fixed-factor.c
index 0e1d89b..73b99c3 100644
--- a/drivers/clk/clk-fixed-factor.c
+++ b/drivers/clk/clk-fixed-factor.c
@@ -36,8 +36,8 @@ static unsigned long clk_factor_recalc_rate(struct clk_hw *hw,
 	return (unsigned long)rate;
 }
 
-static long clk_factor_round_rate(struct clk_hw *hw, unsigned long rate,
-				unsigned long *prate)
+static unsigned long clk_factor_round_rate(struct clk_hw *hw,
+			unsigned long rate, unsigned long *prate)
 {
 	struct clk_fixed_factor *fix = to_clk_fixed_factor(hw);
 
diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index a004769..4f7f6fc 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -697,7 +697,7 @@ struct clk *__clk_lookup(const char *name)
  * directly as a determine_rate callback (e.g. for a mux), or from a more
  * complex clock that may combine a mux with other operations.
  */
-long __clk_mux_determine_rate(struct clk_hw *hw, unsigned long rate,
+unsigned long __clk_mux_determine_rate(struct clk_hw *hw, unsigned long rate,
 			      unsigned long *best_parent_rate,
 			      struct clk **best_parent_p)
 {
@@ -967,7 +967,7 @@ unsigned long __clk_round_rate(struct clk *clk, unsigned long rate)
  * use which is then returned.  If clk doesn't support round_rate operation
  * then the parent rate is returned.
  */
-long clk_round_rate(struct clk *clk, unsigned long rate)
+unsigned long clk_round_rate(struct clk *clk, unsigned long rate)
 {
 	unsigned long ret;
 
-- 
1.8.0

