Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933740AbaHZEhp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 00:37:45 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:52573 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932246AbaHZEhl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 00:37:41 -0400
From: Chao Xie <chao.xie@marvell.com>
To: <haojian.zhuang@gmail.com>, <haojian.zhuang@linaro.org>,
        <mturquette@linaro.org>, <chao.xie@marvell.com>,
        <xiechao_mail@163.com>, <linux-arm-kernel@lists.infradead.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 02/12] clk: mmp: add spin lock for clk-frac
Date: Tue, 26 Aug 2014 12:38:14 +0800
Message-ID: <1409027904-21859-3-git-send-email-chao.xie@marvell.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1409027904-21859-1-git-send-email-chao.xie@marvell.com>
References: <1409027904-21859-1-git-send-email-chao.xie@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.27,0.0.0000
 definitions=2014-08-26_02:2014-08-25,2014-08-26,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1402240000 definitions=main-1408260059
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chao Xie <chao.xie@marvell.com>

The register used by clk-frac may be shared with
other clocks.
So it needs to use spin lock to protect the register
access.

Signed-off-by: Chao Xie <chao.xie@marvell.com>
---
 drivers/clk/mmp/clk-frac.c   | 11 ++++++++++-
 drivers/clk/mmp/clk-mmp2.c   |  2 +-
 drivers/clk/mmp/clk-pxa168.c |  2 +-
 drivers/clk/mmp/clk-pxa910.c |  2 +-
 drivers/clk/mmp/clk.h        |  3 ++-
 5 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/drivers/clk/mmp/clk-frac.c b/drivers/clk/mmp/clk-frac.c
index 3fbc9ca..e29d006 100644
--- a/drivers/clk/mmp/clk-frac.c
+++ b/drivers/clk/mmp/clk-frac.c
@@ -29,6 +29,7 @@ struct mmp_clk_factor {
 	struct mmp_clk_factor_masks	*masks;
 	struct mmp_clk_factor_tbl	*ftbl;
 	unsigned int		ftbl_cnt;
+	spinlock_t *lock;
 };
 
 static long clk_factor_round_rate(struct clk_hw *hw, unsigned long drate,
@@ -86,6 +87,7 @@ static int clk_factor_set_rate(struct clk_hw *hw, unsigned long drate,
 	int i;
 	unsigned long val;
 	unsigned long prev_rate, rate = 0;
+	unsigned long flags = 0;
 
 	for (i = 0; i < factor->ftbl_cnt; i++) {
 		prev_rate = rate;
@@ -97,6 +99,9 @@ static int clk_factor_set_rate(struct clk_hw *hw, unsigned long drate,
 	if (i > 0)
 		i--;
 
+	if (factor->lock)
+		spin_lock_irqsave(factor->lock, flags);
+
 	val = readl_relaxed(factor->base);
 
 	val &= ~(masks->num_mask << masks->num_shift);
@@ -107,6 +112,9 @@ static int clk_factor_set_rate(struct clk_hw *hw, unsigned long drate,
 
 	writel_relaxed(val, factor->base);
 
+	if (factor->lock)
+		spin_unlock_irqrestore(factor->lock, flags);
+
 	return 0;
 }
 
@@ -120,7 +128,7 @@ struct clk *mmp_clk_register_factor(const char *name, const char *parent_name,
 		unsigned long flags, void __iomem *base,
 		struct mmp_clk_factor_masks *masks,
 		struct mmp_clk_factor_tbl *ftbl,
-		unsigned int ftbl_cnt)
+		unsigned int ftbl_cnt, spinlock_t *lock)
 {
 	struct mmp_clk_factor *factor;
 	struct clk_init_data init;
@@ -143,6 +151,7 @@ struct clk *mmp_clk_register_factor(const char *name, const char *parent_name,
 	factor->ftbl = ftbl;
 	factor->ftbl_cnt = ftbl_cnt;
 	factor->hw.init = &init;
+	factor->lock = lock;
 
 	init.name = name;
 	init.ops = &clk_factor_ops;
diff --git a/drivers/clk/mmp/clk-mmp2.c b/drivers/clk/mmp/clk-mmp2.c
index 7083f12..5c90a42 100644
--- a/drivers/clk/mmp/clk-mmp2.c
+++ b/drivers/clk/mmp/clk-mmp2.c
@@ -191,7 +191,7 @@ void __init mmp2_clk_init(void)
 	clk = mmp_clk_register_factor("uart_pll", "pll1_4", 0,
 				mpmu_base + MPMU_UART_PLL,
 				&uart_factor_masks, uart_factor_tbl,
-				ARRAY_SIZE(uart_factor_tbl));
+				ARRAY_SIZE(uart_factor_tbl), &clk_lock);
 	clk_set_rate(clk, 14745600);
 	clk_register_clkdev(clk, "uart_pll", NULL);
 
diff --git a/drivers/clk/mmp/clk-pxa168.c b/drivers/clk/mmp/clk-pxa168.c
index 75266ac..93e967c 100644
--- a/drivers/clk/mmp/clk-pxa168.c
+++ b/drivers/clk/mmp/clk-pxa168.c
@@ -158,7 +158,7 @@ void __init pxa168_clk_init(void)
 	uart_pll = mmp_clk_register_factor("uart_pll", "pll1_4", 0,
 				mpmu_base + MPMU_UART_PLL,
 				&uart_factor_masks, uart_factor_tbl,
-				ARRAY_SIZE(uart_factor_tbl));
+				ARRAY_SIZE(uart_factor_tbl), &clk_lock);
 	clk_set_rate(uart_pll, 14745600);
 	clk_register_clkdev(uart_pll, "uart_pll", NULL);
 
diff --git a/drivers/clk/mmp/clk-pxa910.c b/drivers/clk/mmp/clk-pxa910.c
index f817999..993abcd 100644
--- a/drivers/clk/mmp/clk-pxa910.c
+++ b/drivers/clk/mmp/clk-pxa910.c
@@ -163,7 +163,7 @@ void __init pxa910_clk_init(void)
 	uart_pll =  mmp_clk_register_factor("uart_pll", "pll1_4", 0,
 				mpmu_base + MPMU_UART_PLL,
 				&uart_factor_masks, uart_factor_tbl,
-				ARRAY_SIZE(uart_factor_tbl));
+				ARRAY_SIZE(uart_factor_tbl), &clk_lock);
 	clk_set_rate(uart_pll, 14745600);
 	clk_register_clkdev(uart_pll, "uart_pll", NULL);
 
diff --git a/drivers/clk/mmp/clk.h b/drivers/clk/mmp/clk.h
index 3fe92be..b71b717 100644
--- a/drivers/clk/mmp/clk.h
+++ b/drivers/clk/mmp/clk.h
@@ -31,5 +31,6 @@ extern struct clk *mmp_clk_register_apmu(const char *name,
 extern struct clk *mmp_clk_register_factor(const char *name,
 		const char *parent_name, unsigned long flags,
 		void __iomem *base, struct mmp_clk_factor_masks *masks,
-		struct mmp_clk_factor_tbl *ftbl, unsigned int ftbl_cnt);
+		struct mmp_clk_factor_tbl *ftbl, unsigned int ftbl_cnt,
+		spinlock_t *lock);
 #endif
-- 
1.8.3.2

