Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752758AbaEULX2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 07:23:28 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:12115 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751423AbaEULXV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 07:23:21 -0400
X-AuditID: cbfec7f5-b7f626d000004b39-cf-537c8ca0b63e
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Mike Turquette <mturquette@linaro.org>, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org
Cc: Lee Jones <lee.jones@linaro.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH v4 1/3] clk: s2mps11: Add missing of_node_put and
 of_clk_del_provider
Date: Wed, 21 May 2014 13:22:59 +0200
Message-id: <1400671381-14792-2-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1400671381-14792-1-git-send-email-k.kozlowski@samsung.com>
References: <1400671381-14792-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrKJMWRmVeSWpSXmKPExsVy+t/xa7oLemqCDZ6+Z7fYOGM9q8XrF4YW
	Z5vesFvc/3qU0eLyrjlsFjPO72OyWHvkLrvF0wkX2SzWz3jN4sDpcefaHjaPvi2rGD0+b5IL
	YI7isklJzcksSy3St0vgymj+9oi5YKtgxeeTN5gaGM/wdTFyckgImEh8WrqRGcIWk7hwbz1b
	FyMXh5DAUkaJ45ufMEM4fUwSdz+vYAGpYhMwlti8fAkbiC0ikCsxv3EVWAezQDeTxOWOXUwg
	CWGBcIlVeyawgtgsAqoSex8uByri4OAVcJdYObsAYpucxMljk8FKOAU8JH41rwOzhYBKGg7M
	Z5zAyLuAkWEVo2hqaXJBcVJ6rpFecWJucWleul5yfu4mRkhQfd3BuPSY1SFGAQ5GJR7ejOvV
	wUKsiWXFlbmHGCU4mJVEeI9V1AQL8aYkVlalFuXHF5XmpBYfYmTi4JRqYLSQUyi4H3zk795A
	ee2y7YZzrzySnMmxkuOvwPmLkQbKL1y3P0l7kmjc+b9mmc6/tjO+k8ruTA2fWTnxraKo+5W/
	mf/Fp5twFTb/PPnr0HS5MGnuOzMbhT7N27tm9cJ/86X1+2T3WyxkP3xbTvbqZIMZk5/1fDoV
	FryRPcGzkjNX2dFsZ9i/iaeVWIozEg21mIuKEwHHEv7GCAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add of_clk_del_provider to remove previously registered clock provider.
Add of_node_put to decrement the ref count of clock nodes.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 drivers/clk/clk-s2mps11.c | 16 +++++++++++-----
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
1.9.1

