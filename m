Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753418AbaCJMep (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 08:34:45 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:27943 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753105AbaCJMej (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 08:34:39 -0400
X-AuditID: cbfec7f4-b7f796d000005a13-fb-531db15dfd17
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Mike Turquette <mturquette@linaro.org>,
        linux-arm-kernel@lists.infradead.org,
        Sangbeom Kim <sbkim73@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: Tushar Behera <tushar.behera@linaro.org>,
        Yadwinder Singh Brar <yadi.brar@samsung.com>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH 1/3] clk: s2mps11: Add support for S2MPS14 clocks
Date: Mon, 10 Mar 2014 13:34:16 +0100
Message-id: <1394454858-3139-2-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1394454858-3139-1-git-send-email-k.kozlowski@samsung.com>
References: <1394454858-3139-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprFLMWRmVeSWpSXmKPExsVy+t/xq7qxG2WDDRb8YbXYOGM9q8XrF4YW
	Z5vesFvc/3qU0WLT42usFpd3zWGzmHF+H5PF2iN32S2eTrjIZnHyTy+jxeluVouLK74wWayf
	8ZrFov3vXjaLOdPfMTnwe9y5tofNY97JQI/NS+o9+rasYvT4vEkugDWKyyYlNSezLLVI3y6B
	K2P3/27mgiXqFXe2/WJrYDwt38XIySEhYCJx9dd1NghbTOLCvfVgtpDAUkaJozsluxi5gOw+
	Jomb394ygSTYBIwlNi9fwgaSEBFoZpLY9/UxE4jDLPCWSeLOoZvsIFXCAo4SK95tALNZBFQl
	1v/oAuvmFXCT+HvtB5DNAbROQWLOJBuQMKeAu8T1ed+gNrtJTHi6jnECI+8CRoZVjKKppckF
	xUnpuYZ6xYm5xaV56XrJ+bmbGCHh+WUH4+JjVocYBTgYlXh4D7yVCRZiTSwrrsw9xCjBwawk
	wpu5WDZYiDclsbIqtSg/vqg0J7X4ECMTB6dUA6PJ5ISmjR/v6653tXgS9bf2xJ78+ToFB5VK
	szya5C5u/3HgvOSk3ct2fszdHv7Mx1M8Y7Mw2yQfrWfcJ1paNT0fJYl0MfSv/9Fsd9Z/2noT
	I4W2PPuZNh8lvhovV7ZRjKjQ0D8fEigyIfvy/QbvMPvfYp4Tdn3ZYrHY9rG+QLns2t6a4tYb
	q5VYijMSDbWYi4oTAS2sZvktAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for S2MPS14 PMIC clocks (BT and AP) to the
s2mps11 clock driver.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 drivers/clk/clk-s2mps11.c |   61 ++++++++++++++++++++++++++++++++++-----------
 1 file changed, 46 insertions(+), 15 deletions(-)

diff --git a/drivers/clk/clk-s2mps11.c b/drivers/clk/clk-s2mps11.c
index 508875535e1e..8dafb552274f 100644
--- a/drivers/clk/clk-s2mps11.c
+++ b/drivers/clk/clk-s2mps11.c
@@ -1,7 +1,7 @@
 /*
  * clk-s2mps11.c - Clock driver for S2MPS11.
  *
- * Copyright (C) 2013 Samsung Electornics
+ * Copyright (C) 2013,2014 Samsung Electornics
  *
  * This program is free software; you can redistribute  it and/or modify it
  * under  the terms of  the GNU General  Public License as published by the
@@ -13,10 +13,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
- *
  */
 
 #include <linux/module.h>
@@ -27,6 +23,7 @@
 #include <linux/clk-provider.h>
 #include <linux/platform_device.h>
 #include <linux/mfd/samsung/s2mps11.h>
+#include <linux/mfd/samsung/s2mps14.h>
 #include <linux/mfd/samsung/s5m8767.h>
 #include <linux/mfd/samsung/core.h>
 
@@ -125,7 +122,21 @@ static struct clk_init_data s2mps11_clks_init[S2MPS11_CLKS_NUM] = {
 	},
 };
 
-static struct device_node *s2mps11_clk_parse_dt(struct platform_device *pdev)
+static struct clk_init_data s2mps14_clks_init[S2MPS11_CLKS_NUM] = {
+	[S2MPS11_CLK_AP] = {
+		.name = "s2mps14_ap",
+		.ops = &s2mps11_clk_ops,
+		.flags = CLK_IS_ROOT,
+	},
+	[S2MPS11_CLK_BT] = {
+		.name = "s2mps14_bt",
+		.ops = &s2mps11_clk_ops,
+		.flags = CLK_IS_ROOT,
+	},
+};
+
+static struct device_node *s2mps11_clk_parse_dt(struct platform_device *pdev,
+		struct clk_init_data *clks_init)
 {
 	struct sec_pmic_dev *iodev = dev_get_drvdata(pdev->dev.parent);
 	struct device_node *clk_np;
@@ -145,9 +156,12 @@ static struct device_node *s2mps11_clk_parse_dt(struct platform_device *pdev)
 	if (!clk_table)
 		return ERR_PTR(-ENOMEM);
 
-	for (i = 0; i < S2MPS11_CLKS_NUM; i++)
+	for (i = 0; i < S2MPS11_CLKS_NUM; i++) {
+		if (!clks_init[i].name)
+			continue; /* Skip clocks not present in some devices */
 		of_property_read_string_index(clk_np, "clock-output-names", i,
-				&s2mps11_clks_init[i].name);
+				&clks_init[i].name);
+	}
 
 	return clk_np;
 }
@@ -158,6 +172,7 @@ static int s2mps11_clk_probe(struct platform_device *pdev)
 	struct s2mps11_clk *s2mps11_clks, *s2mps11_clk;
 	struct device_node *clk_np = NULL;
 	unsigned int s2mps11_reg;
+	struct clk_init_data *clks_init;
 	int i, ret = 0;
 	u32 val;
 
@@ -168,25 +183,33 @@ static int s2mps11_clk_probe(struct platform_device *pdev)
 
 	s2mps11_clk = s2mps11_clks;
 
-	clk_np = s2mps11_clk_parse_dt(pdev);
-	if (IS_ERR(clk_np))
-		return PTR_ERR(clk_np);
-
 	switch (platform_get_device_id(pdev)->driver_data) {
 	case S2MPS11X:
 		s2mps11_reg = S2MPS11_REG_RTC_CTRL;
+		clks_init = s2mps11_clks_init;
+		break;
+	case S2MPS14X:
+		s2mps11_reg = S2MPS14_REG_RTCCTRL;
+		clks_init = s2mps14_clks_init;
 		break;
 	case S5M8767X:
 		s2mps11_reg = S5M8767_REG_CTRL1;
+		clks_init = s2mps11_clks_init;
 		break;
 	default:
 		dev_err(&pdev->dev, "Invalid device type\n");
 		return -EINVAL;
 	};
 
+	clk_np = s2mps11_clk_parse_dt(pdev, clks_init);
+	if (IS_ERR(clk_np))
+		return PTR_ERR(clk_np);
+
 	for (i = 0; i < S2MPS11_CLKS_NUM; i++, s2mps11_clk++) {
+		if (!clks_init[i].name)
+			continue; /* Skip clocks not present in some devices */
 		s2mps11_clk->iodev = iodev;
-		s2mps11_clk->hw.init = &s2mps11_clks_init[i];
+		s2mps11_clk->hw.init = &clks_init[i];
 		s2mps11_clk->mask = 1 << i;
 		s2mps11_clk->reg = s2mps11_reg;
 
@@ -220,8 +243,12 @@ static int s2mps11_clk_probe(struct platform_device *pdev)
 	}
 
 	if (clk_table) {
-		for (i = 0; i < S2MPS11_CLKS_NUM; i++)
+		for (i = 0; i < S2MPS11_CLKS_NUM; i++) {
+			/* Skip clocks not present on S2MPS14 */
+			if (!clks_init[i].name)
+				continue;
 			clk_table[i] = s2mps11_clks[i].clk;
+		}
 
 		clk_data.clks = clk_table;
 		clk_data.clk_num = S2MPS11_CLKS_NUM;
@@ -250,14 +277,18 @@ static int s2mps11_clk_remove(struct platform_device *pdev)
 	struct s2mps11_clk *s2mps11_clks = platform_get_drvdata(pdev);
 	int i;
 
-	for (i = 0; i < S2MPS11_CLKS_NUM; i++)
+	for (i = 0; i < S2MPS11_CLKS_NUM; i++) {
+		if (!s2mps11_clks[i].lookup)
+			continue; /* Skip clocks not present in some devices */
 		clkdev_drop(s2mps11_clks[i].lookup);
+	}
 
 	return 0;
 }
 
 static const struct platform_device_id s2mps11_clk_id[] = {
 	{ "s2mps11-clk", S2MPS11X},
+	{ "s2mps14-clk", S2MPS14X},
 	{ "s5m8767-clk", S5M8767X},
 	{ },
 };
-- 
1.7.9.5

