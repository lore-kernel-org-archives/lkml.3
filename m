Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752232Ab3LNHqV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Dec 2013 02:46:21 -0500
Received: from mail-pd0-f170.google.com ([209.85.192.170]:59677 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751811Ab3LNHqU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Dec 2013 02:46:20 -0500
Date: Sat, 14 Dec 2013 13:16:06 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: k.kozlowski@samsung.com, andy@groveronline.com, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, kyungmin.park@samsung.com,
        broonie@linaro.org, sbkim73@samsung.com,
        Mike Turquette <mturquette@linaro.org>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH] drivers: clk: Fix build break introduced in 3e1e4a5f
Message-ID: <20131214074606.GA20826@rashika>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the build break introduced by 3e1e4a5f. The mentioned
commit id makes the changes in file "include/linux/mfd/samsung/core.h"
by changing the members of structure sec_pmic_dev.

The patch replaces "regmap" with "regmap_pmic" because structure
sec_pmic_dev no more contains any member named regmap.

Thus, it removes the undefined reference to regmap in functions
s2mps11_clk_prepare(), s2mps11_clk_unprepare() and s2mps11_clk_probe().

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
---
 drivers/clk/clk-s2mps11.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/clk/clk-s2mps11.c b/drivers/clk/clk-s2mps11.c
index 7be41e6..94e3695 100644
--- a/drivers/clk/clk-s2mps11.c
+++ b/drivers/clk/clk-s2mps11.c
@@ -60,7 +60,7 @@ static int s2mps11_clk_prepare(struct clk_hw *hw)
 	struct s2mps11_clk *s2mps11 = to_s2mps11_clk(hw);
 	int ret;
 
-	ret = regmap_update_bits(s2mps11->iodev->regmap,
+	ret = regmap_update_bits(s2mps11->iodev->regmap_pmic,
 				S2MPS11_REG_RTC_CTRL,
 				 s2mps11->mask, s2mps11->mask);
 	if (!ret)
@@ -74,7 +74,8 @@ static void s2mps11_clk_unprepare(struct clk_hw *hw)
 	struct s2mps11_clk *s2mps11 = to_s2mps11_clk(hw);
 	int ret;
 
-	ret = regmap_update_bits(s2mps11->iodev->regmap, S2MPS11_REG_RTC_CTRL,
+	ret = regmap_update_bits(s2mps11->iodev->regmap_pmic,
+			   S2MPS11_REG_RTC_CTRL,
 			   s2mps11->mask, ~s2mps11->mask);
 
 	if (!ret)
@@ -174,7 +175,7 @@ static int s2mps11_clk_probe(struct platform_device *pdev)
 		s2mps11_clk->hw.init = &s2mps11_clks_init[i];
 		s2mps11_clk->mask = 1 << i;
 
-		ret = regmap_read(s2mps11_clk->iodev->regmap,
+		ret = regmap_read(s2mps11_clk->iodev->regmap_pmic,
 				  S2MPS11_REG_RTC_CTRL, &val);
 		if (ret < 0)
 			goto err_reg;
-- 
1.7.9.5

