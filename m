Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932237AbaGAO7r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 10:59:47 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:63894 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932176AbaGAO7p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 10:59:45 -0400
X-AuditID: cbfec7f5-b7f626d000004b39-42-53b2ccde7ed3
From: Karol Wrona <k.wrona@samsung.com>
To: Mike Turquette <mturquette@linaro.org>, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>, Karol Wrona <k.wrona@samsung.com>
Subject: [PATCH] clk: s2mps11: Fix clk_ops
Date: Tue, 01 Jul 2014 16:57:02 +0200
Message-id: <1404226622-25423-1-git-send-email-k.wrona@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrOJMWRmVeSWpSXmKPExsVy+t/xa7r3zmwKNvgyS8ti44z1rBanlu1n
	sjjb9Ibd4vKuOWwWM87vY7JYe+Quu8XTCRfZLNbPeM3iwOFx59oeNo++LasYPT5vkgtgjuKy
	SUnNySxLLdK3S+DKWP3PuGC6eMXbHfOYGhjvCnUxcnJICJhILFq4mxXCFpO4cG89WxcjF4eQ
	wFJGiR9ffrBAOH1MEr9+3gGrYhNQl2jesZgZxBYRyJWY37gKrINZ4DajxKxL39i7GDk4hAW0
	JC68rAKpYRFQldj/oIEdxOYVcJZ4P2cCI0iJhICCxJxJNhMYuRcwMqxiFE0tTS4oTkrPNdIr
	TswtLs1L10vOz93ECAmMrzsYlx6zOsQowMGoxMP7Qn9TsBBrYllxZe4hRgkOZiUR3j37gUK8
	KYmVValF+fFFpTmpxYcYmTg4pRoY5aU/PLXYpfqjSJhJ4p7dmr8Zk38xl60UuyTjMPVntISZ
	4abnX6aV75JZ5CPxc+lT7ROCUo+e2m0QLdjYdazgT0vkvT0PN8zdN3G9W+TNJeZJFaXeDoun
	LdKaHZo2eUalUbOlKlPdUea7TnN//jYqvqLeuFMycPOZSib5lyzvjxVfi/DpCdWcocRSnJFo
	qMVcVJwIAJF06HjqAQAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

s32mps11 clocks had registered callbacks for prepare ,unprepare and is_enable
what was wrong and caused i.e. that unused clocks were not disabled.

Regmap_read is cached so it can be called in is_prepare callback
to achieve this information. Enabled field was removed from struct s2mps11_clk.

Change-Id: I4a850aef9034ece4e45760291d0a6fdceffb3304
Signed-off-by: Karol Wrona <k.wrona@samsung.com>
---
 drivers/clk/clk-s2mps11.c |   33 +++++++++++----------------------
 1 file changed, 11 insertions(+), 22 deletions(-)

diff --git a/drivers/clk/clk-s2mps11.c b/drivers/clk/clk-s2mps11.c
index b5274a9..5df99a4 100644
--- a/drivers/clk/clk-s2mps11.c
+++ b/drivers/clk/clk-s2mps11.c
@@ -45,7 +45,6 @@ struct s2mps11_clk {
 	struct clk *clk;
 	struct clk_lookup *lookup;
 	u32 mask;
-	bool enabled;
 	unsigned int reg;
 };
 
@@ -62,8 +61,6 @@ static int s2mps11_clk_prepare(struct clk_hw *hw)
 	ret = regmap_update_bits(s2mps11->iodev->regmap_pmic,
 				 s2mps11->reg,
 				 s2mps11->mask, s2mps11->mask);
-	if (!ret)
-		s2mps11->enabled = true;
 
 	return ret;
 }
@@ -75,32 +72,32 @@ static void s2mps11_clk_unprepare(struct clk_hw *hw)
 
 	ret = regmap_update_bits(s2mps11->iodev->regmap_pmic, s2mps11->reg,
 			   s2mps11->mask, ~s2mps11->mask);
-
-	if (!ret)
-		s2mps11->enabled = false;
 }
 
-static int s2mps11_clk_is_enabled(struct clk_hw *hw)
+static int s2mps11_clk_is_prepared(struct clk_hw *hw)
 {
+	int ret;
+	u32 val;
 	struct s2mps11_clk *s2mps11 = to_s2mps11_clk(hw);
 
-	return s2mps11->enabled;
+	ret = regmap_read(s2mps11->iodev->regmap_pmic,
+				s2mps11->reg, &val);
+	if (ret < 0)
+		return -EINVAL;
+
+	return val & s2mps11->mask;
 }
 
 static unsigned long s2mps11_clk_recalc_rate(struct clk_hw *hw,
 					     unsigned long parent_rate)
 {
-	struct s2mps11_clk *s2mps11 = to_s2mps11_clk(hw);
-	if (s2mps11->enabled)
-		return 32768;
-	else
-		return 0;
+	return 32768;
 }
 
 static struct clk_ops s2mps11_clk_ops = {
 	.prepare	= s2mps11_clk_prepare,
 	.unprepare	= s2mps11_clk_unprepare,
-	.is_enabled	= s2mps11_clk_is_enabled,
+	.is_prepared	= s2mps11_clk_is_prepared,
 	.recalc_rate	= s2mps11_clk_recalc_rate,
 };
 
@@ -174,7 +171,6 @@ static int s2mps11_clk_probe(struct platform_device *pdev)
 	unsigned int s2mps11_reg;
 	struct clk_init_data *clks_init;
 	int i, ret = 0;
-	u32 val;
 
 	s2mps11_clks = devm_kzalloc(&pdev->dev, sizeof(*s2mps11_clk) *
 					S2MPS11_CLKS_NUM, GFP_KERNEL);
@@ -213,13 +209,6 @@ static int s2mps11_clk_probe(struct platform_device *pdev)
 		s2mps11_clk->mask = 1 << i;
 		s2mps11_clk->reg = s2mps11_reg;
 
-		ret = regmap_read(s2mps11_clk->iodev->regmap_pmic,
-				  s2mps11_clk->reg, &val);
-		if (ret < 0)
-			goto err_reg;
-
-		s2mps11_clk->enabled = val & s2mps11_clk->mask;
-
 		s2mps11_clk->clk = devm_clk_register(&pdev->dev,
 							&s2mps11_clk->hw);
 		if (IS_ERR(s2mps11_clk->clk)) {
-- 
1.7.9.5

