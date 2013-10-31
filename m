Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753380Ab3JaGuR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 02:50:17 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:60577 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753325Ab3JaGuL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 02:50:11 -0400
From: Tushar Behera <tushar.behera@linaro.org>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Cc: mturquette@linaro.org, lee.jones@linaro.org, kgene.kim@samsung.com,
        patches@linaro.org, Yadwinder Singh Brar <yadi.brar@samsung.com>
Subject: [PATCH 1/4] clk: clk-s2mps11: Refactor for including support for other MFD clocks
Date: Thu, 31 Oct 2013 12:18:41 +0530
Message-Id: <1383202124-1775-2-git-send-email-tushar.behera@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1383202124-1775-1-git-send-email-tushar.behera@linaro.org>
References: <1383202124-1775-1-git-send-email-tushar.behera@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The clocks in S2MPS11 and S5M8767 are managed in the same way, baring
a difference in the register offset. It would be better to update
existing S2MPS11 driver to support the clocks in S5M8767, rather than
creating an almost duplicate driver altogether.

Signed-off-by: Tushar Behera <tushar.behera@linaro.org>
CC: Yadwinder Singh Brar <yadi.brar@samsung.com>
CC: Mike Turquette <mturquette@linaro.org>
---
 drivers/clk/clk-s2mps11.c |   20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

diff --git a/drivers/clk/clk-s2mps11.c b/drivers/clk/clk-s2mps11.c
index 7be41e6..2262cb4 100644
--- a/drivers/clk/clk-s2mps11.c
+++ b/drivers/clk/clk-s2mps11.c
@@ -48,6 +48,7 @@ struct s2mps11_clk {
 	struct clk_lookup *lookup;
 	u32 mask;
 	bool enabled;
+	unsigned int reg;
 };
 
 static struct s2mps11_clk *to_s2mps11_clk(struct clk_hw *hw)
@@ -61,7 +62,7 @@ static int s2mps11_clk_prepare(struct clk_hw *hw)
 	int ret;
 
 	ret = regmap_update_bits(s2mps11->iodev->regmap,
-				S2MPS11_REG_RTC_CTRL,
+				 s2mps11->reg,
 				 s2mps11->mask, s2mps11->mask);
 	if (!ret)
 		s2mps11->enabled = true;
@@ -74,7 +75,7 @@ static void s2mps11_clk_unprepare(struct clk_hw *hw)
 	struct s2mps11_clk *s2mps11 = to_s2mps11_clk(hw);
 	int ret;
 
-	ret = regmap_update_bits(s2mps11->iodev->regmap, S2MPS11_REG_RTC_CTRL,
+	ret = regmap_update_bits(s2mps11->iodev->regmap, s2mps11->reg,
 			   s2mps11->mask, ~s2mps11->mask);
 
 	if (!ret)
@@ -155,6 +156,7 @@ static int s2mps11_clk_probe(struct platform_device *pdev)
 	struct sec_pmic_dev *iodev = dev_get_drvdata(pdev->dev.parent);
 	struct s2mps11_clk *s2mps11_clks, *s2mps11_clk;
 	struct device_node *clk_np = NULL;
+	unsigned int s2mps11_reg;
 	int i, ret = 0;
 	u32 val;
 
@@ -169,13 +171,23 @@ static int s2mps11_clk_probe(struct platform_device *pdev)
 	if (IS_ERR(clk_np))
 		return PTR_ERR(clk_np);
 
+	switch(platform_get_device_id(pdev)->driver_data) {
+	case S2MPS11X:
+		s2mps11_reg = S2MPS11_REG_RTC_CTRL;
+		break;
+	default:
+		dev_err(&pdev->dev, "Invalid device type\n");
+		return -EINVAL;
+	};
+
 	for (i = 0; i < S2MPS11_CLKS_NUM; i++, s2mps11_clk++) {
 		s2mps11_clk->iodev = iodev;
 		s2mps11_clk->hw.init = &s2mps11_clks_init[i];
 		s2mps11_clk->mask = 1 << i;
+		s2mps11_clk->reg = s2mps11_reg;
 
 		ret = regmap_read(s2mps11_clk->iodev->regmap,
-				  S2MPS11_REG_RTC_CTRL, &val);
+				  s2mps11_clk->reg, &val);
 		if (ret < 0)
 			goto err_reg;
 
@@ -241,7 +253,7 @@ static int s2mps11_clk_remove(struct platform_device *pdev)
 }
 
 static const struct platform_device_id s2mps11_clk_id[] = {
-	{ "s2mps11-clk", 0},
+	{ "s2mps11-clk", S2MPS11X},
 	{ },
 };
 MODULE_DEVICE_TABLE(platform, s2mps11_clk_id);
-- 
1.7.9.5

