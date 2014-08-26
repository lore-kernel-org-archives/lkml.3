Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932340AbaHZEhl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 00:37:41 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:43664 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750895AbaHZEhh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 00:37:37 -0400
From: Chao Xie <chao.xie@marvell.com>
To: <haojian.zhuang@gmail.com>, <haojian.zhuang@linaro.org>,
        <mturquette@linaro.org>, <chao.xie@marvell.com>,
        <xiechao_mail@163.com>, <linux-arm-kernel@lists.infradead.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 03/12] clk: mmp: add init callback for clk-frac
Date: Tue, 26 Aug 2014 12:38:15 +0800
Message-ID: <1409027904-21859-4-git-send-email-chao.xie@marvell.com>
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

For the clk-frac, we need to make sure that the initial
clock rate is one item of the table.
If it is not, we use the first item in the table by default.

Signed-off-by: Chao Xie <chao.xie@marvell.com>
---
 drivers/clk/mmp/clk-frac.c | 40 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 40 insertions(+)

diff --git a/drivers/clk/mmp/clk-frac.c b/drivers/clk/mmp/clk-frac.c
index e29d006..1876d2c 100644
--- a/drivers/clk/mmp/clk-frac.c
+++ b/drivers/clk/mmp/clk-frac.c
@@ -118,10 +118,50 @@ static int clk_factor_set_rate(struct clk_hw *hw, unsigned long drate,
 	return 0;
 }
 
+void clk_factor_init(struct clk_hw *hw)
+{
+	struct mmp_clk_factor *factor = to_clk_factor(hw);
+	struct mmp_clk_factor_masks *masks = factor->masks;
+	u32 val, num, den;
+	int i;
+	unsigned long flags = 0;
+
+	if (factor->lock)
+		spin_lock_irqsave(factor->lock, flags);
+
+	val = readl(factor->base);
+
+	/* calculate numerator */
+	num = (val >> masks->num_shift) & masks->num_mask;
+
+	/* calculate denominator */
+	den = (val >> masks->den_shift) & masks->den_mask;
+
+	for (i = 0; i < factor->ftbl_cnt; i++)
+		if (den == factor->ftbl[i].den && num == factor->ftbl[i].num)
+			break;
+
+	if (i >= factor->ftbl_cnt) {
+		val &= ~(masks->num_mask << masks->num_shift);
+		val |= (factor->ftbl[0].num & masks->num_mask) <<
+			masks->num_shift;
+
+		val &= ~(masks->den_mask << masks->den_shift);
+		val |= (factor->ftbl[0].den & masks->den_mask) <<
+			masks->den_shift;
+
+		writel(val, factor->base);
+	}
+
+	if (factor->lock)
+		spin_unlock_irqrestore(factor->lock, flags);
+}
+
 static struct clk_ops clk_factor_ops = {
 	.recalc_rate = clk_factor_recalc_rate,
 	.round_rate = clk_factor_round_rate,
 	.set_rate = clk_factor_set_rate,
+	.init = clk_factor_init,
 };
 
 struct clk *mmp_clk_register_factor(const char *name, const char *parent_name,
-- 
1.8.3.2

