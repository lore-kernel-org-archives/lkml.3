Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760820AbaCUMkO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 08:40:14 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:53681 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755343AbaCUMkL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 08:40:11 -0400
X-AuditID: cbfec7f4-b7f796d000005a13-30-532c3329531b
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Mike Turquette <mturquette@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org
Cc: Tushar Behera <tushar.behera@linaro.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH-next 1/2] clk: s2mps11: Add missing of_node_put and
 of_clk_del_provider
Date: Fri, 21 Mar 2014 13:40:02 +0100
Message-id: <1395405603-11772-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrOJMWRmVeSWpSXmKPExsVy+t/xa7qaxjrBBo0bFC02zljPavH6haHF
	2aY37BabHl9jtbi8aw6bxYzz+5gs1h65y27xdMJFNov1M16zWLT/3cvmwOVx59oeNo/NS+o9
	+rasYvT4vEkugCWKyyYlNSezLLVI3y6BK+Pq34lsBTsFKyb8m8LSwHiOr4uRk0NCwETies82
	JghbTOLCvfVsXYxcHEICSxkl7i8+yA7h9DFJLPr9ghmkik3AWGLz8iVgVSICUxklNq5fxATi
	MAtMZpJYtuwgI0iVsECkxL/1e1lBbBYBVYlNa36CxXkF3CUWNB0GmsQBtE9BYs4kmwmM3AsY
	GVYxiqaWJhcUJ6XnGuoVJ+YWl+al6yXn525ihATOlx2Mi49ZHWIU4GBU4uGt4NQOFmJNLCuu
	zD3EKMHBrCTCu9NAJ1iINyWxsiq1KD++qDQntfgQIxMHp1QD4yK/iYovD618E+JhulYjrUOx
	7OyhmisCgWJ/vhrtYzsWrhh6VMU70HXlIoMnR77JmAodSv6tzrvFn/OIYu3di39PbvTRsOdk
	jZmXOOH10nPx3xpfaNTEXn20P8Lg+OGPcfnXbmoVfW79WPaYJ9ZlhdDMsil5jw6WzVe2eTtZ
	p2L+y1CtwpRGNiWW4oxEQy3mouJEABcBH7H6AQAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add of_clk_del_provider to remove previously registered clock provider.
Add of_node_put to decrement the ref count of clock nodes.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 drivers/clk/clk-s2mps11.c |   16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/clk/clk-s2mps11.c b/drivers/clk/clk-s2mps11.c
index f2f62a1bf61a..843ec3646501 100644
--- a/drivers/clk/clk-s2mps11.c
+++ b/drivers/clk/clk-s2mps11.c
@@ -44,6 +44,7 @@ enum {
 
 struct s2mps11_clk {
 	struct sec_pmic_dev *iodev;
+	struct device_node *clk_np;
 	struct clk_hw hw;
 	struct clk *clk;
 	struct clk_lookup *lookup;
@@ -156,7 +157,6 @@ static int s2mps11_clk_probe(struct platform_device *pdev)
 {
 	struct sec_pmic_dev *iodev = dev_get_drvdata(pdev->dev.parent);
 	struct s2mps11_clk *s2mps11_clks, *s2mps11_clk;
-	struct device_node *clk_np = NULL;
 	unsigned int s2mps11_reg;
 	int i, ret = 0;
 	u32 val;
@@ -168,9 +168,10 @@ static int s2mps11_clk_probe(struct platform_device *pdev)
 
 	s2mps11_clk = s2mps11_clks;
 
-	clk_np = s2mps11_clk_parse_dt(pdev);
-	if (IS_ERR(clk_np))
-		return PTR_ERR(clk_np);
+	/* Store clocks of_node in first element of s2mps11_clks array */
+	s2mps11_clks->clk_np = s2mps11_clk_parse_dt(pdev);
+	if (IS_ERR(s2mps11_clks->clk_np))
+		return PTR_ERR(s2mps11_clks->clk_np);
 
 	switch(platform_get_device_id(pdev)->driver_data) {
 	case S2MPS11X:
@@ -225,7 +226,8 @@ static int s2mps11_clk_probe(struct platform_device *pdev)
 
 		clk_data.clks = clk_table;
 		clk_data.clk_num = S2MPS11_CLKS_NUM;
-		of_clk_add_provider(clk_np, of_clk_src_onecell_get, &clk_data);
+		of_clk_add_provider(s2mps11_clks->clk_np,
+				of_clk_src_onecell_get, &clk_data);
 	}
 
 	platform_set_drvdata(pdev, s2mps11_clks);
@@ -250,6 +252,10 @@ static int s2mps11_clk_remove(struct platform_device *pdev)
 	struct s2mps11_clk *s2mps11_clks = platform_get_drvdata(pdev);
 	int i;
 
+	of_clk_del_provider(s2mps11_clks[0].clk_np);
+	/* Drop the reference obtained in s2mps11_clk_parse_dt */
+	of_node_put(s2mps11_clks[0].clk_np);
+
 	for (i = 0; i < S2MPS11_CLKS_NUM; i++)
 		clkdev_drop(s2mps11_clks[i].lookup);
 
-- 
1.7.9.5

