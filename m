Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751904AbaERPvm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2014 11:51:42 -0400
Received: from mail-vc0-f180.google.com ([209.85.220.180]:54512 "EHLO
	mail-vc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751527AbaERPvl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2014 11:51:41 -0400
Message-ID: <1400428295.15403.3.camel@phoenix>
Subject: [PATCH] clk: s2mps11: Simplify s2mps11_clk_probe unwind paths
From: Axel Lin <axel.lin@ingics.com>
To: Mike Turquette <mturquette@linaro.org>
Cc: Yadwinder Singh Brar <yadi.brar@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        linux-kernel@vger.kernel.org
Date: Sun, 18 May 2014 23:51:35 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The devm_clk_unregister() in probe error paths are not necessary as it will be
automatically called when probe fails.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/clk/clk-s2mps11.c | 14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

diff --git a/drivers/clk/clk-s2mps11.c b/drivers/clk/clk-s2mps11.c
index f2f62a1b..aeaa61c 100644
--- a/drivers/clk/clk-s2mps11.c
+++ b/drivers/clk/clk-s2mps11.c
@@ -210,7 +210,7 @@ static int s2mps11_clk_probe(struct platform_device *pdev)
 					sizeof(struct clk_lookup), GFP_KERNEL);
 		if (!s2mps11_clk->lookup) {
 			ret = -ENOMEM;
-			goto err_lup;
+			goto err_reg;
 		}
 
 		s2mps11_clk->lookup->con_id = s2mps11_name(s2mps11_clk);
@@ -231,16 +231,10 @@ static int s2mps11_clk_probe(struct platform_device *pdev)
 	platform_set_drvdata(pdev, s2mps11_clks);
 
 	return ret;
-err_lup:
-	devm_clk_unregister(&pdev->dev, s2mps11_clk->clk);
+
 err_reg:
-	while (s2mps11_clk > s2mps11_clks) {
-		if (s2mps11_clk->lookup) {
-			clkdev_drop(s2mps11_clk->lookup);
-			devm_clk_unregister(&pdev->dev, s2mps11_clk->clk);
-		}
-		s2mps11_clk--;
-	}
+	while (--i >= 0)
+		clkdev_drop(s2mps11_clks[i].lookup);
 
 	return ret;
 }
-- 
1.8.3.2



