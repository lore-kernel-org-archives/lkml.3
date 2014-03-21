Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760864AbaCUMkS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 08:40:18 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:53681 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760234AbaCUMkM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 08:40:12 -0400
X-AuditID: cbfec7f5-b7fc96d000004885-14-532c332b7297
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
Subject: [PATCH-next 2/2] clk: s2mps11: Remove useless check for clk_table
Date: Fri, 21 Mar 2014 13:40:03 +0100
Message-id: <1395405603-11772-2-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1395405603-11772-1-git-send-email-k.kozlowski@samsung.com>
References: <1395405603-11772-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrHJMWRmVeSWpSXmKPExsVy+t/xa7raxjrBBr8bVS02zljPavH6haHF
	2aY37BabHl9jtbi8aw6bxYzz+5gs1h65y27xdMJFNov1M16zWLT/3cvmwOVx59oeNo/NS+o9
	+rasYvT4vEkugCWKyyYlNSezLLVI3y6BK2PzoamMBc8FKs493MTSwPiLt4uRk0NCwERi2/uz
	jBC2mMSFe+vZuhi5OIQEljJKbP3/gw0kISTQxySxf1saiM0mYCyxefkSsCIRgamMEhvXL2IC
	cZgFJjNJLFt2EGyUsICXROuU5SwgNouAqsSynuvsIDavgLvEl4tPmbsYOYDWKUjMmWQDEuYU
	8JB4M3c/O8Qyd4m5B44xTWDkXcDIsIpRNLU0uaA4KT3XSK84Mbe4NC9dLzk/dxMjJMy+7mBc
	eszqEKMAB6MSD28Fp3awEGtiWXFl7iFGCQ5mJRHenQY6wUK8KYmVValF+fFFpTmpxYcYmTg4
	pRoYOdkX21zz52A07piQfvHBnAW+Fqnisn0v1xxUXyGxLmHbikenHDuSVtq/vBg+76vz5uJm
	0xlJ0fz6c1X1L6bIhfvnznS+JBRraDl50rxrs5af6v9anb3jWRKjut+3Zytf7zdvq5288I65
	x5QFD6X107YJXCsor5557PlGxf7Mk6tWxC2LmeDPrcRSnJFoqMVcVJwIAFsff7sRAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no need for checking if 'clk_table' is not NULL twice (first
after allocation and second at the end of probe()). Also move allocation
of this 'clk_table' to probe from s2mps11_clk_parse_dt as this is
logical place for it.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 drivers/clk/clk-s2mps11.c |   24 +++++++++++-------------
 1 file changed, 11 insertions(+), 13 deletions(-)

diff --git a/drivers/clk/clk-s2mps11.c b/drivers/clk/clk-s2mps11.c
index 843ec3646501..23ffd89c4023 100644
--- a/drivers/clk/clk-s2mps11.c
+++ b/drivers/clk/clk-s2mps11.c
@@ -141,11 +141,6 @@ static struct device_node *s2mps11_clk_parse_dt(struct platform_device *pdev)
 		return ERR_PTR(-EINVAL);
 	}
 
-	clk_table = devm_kzalloc(&pdev->dev, sizeof(struct clk *) *
-				 S2MPS11_CLKS_NUM, GFP_KERNEL);
-	if (!clk_table)
-		return ERR_PTR(-ENOMEM);
-
 	for (i = 0; i < S2MPS11_CLKS_NUM; i++)
 		of_property_read_string_index(clk_np, "clock-output-names", i,
 				&s2mps11_clks_init[i].name);
@@ -168,6 +163,11 @@ static int s2mps11_clk_probe(struct platform_device *pdev)
 
 	s2mps11_clk = s2mps11_clks;
 
+	clk_table = devm_kzalloc(&pdev->dev, sizeof(struct clk *) *
+				 S2MPS11_CLKS_NUM, GFP_KERNEL);
+	if (!clk_table)
+		return -ENOMEM;
+
 	/* Store clocks of_node in first element of s2mps11_clks array */
 	s2mps11_clks->clk_np = s2mps11_clk_parse_dt(pdev);
 	if (IS_ERR(s2mps11_clks->clk_np))
@@ -220,15 +220,13 @@ static int s2mps11_clk_probe(struct platform_device *pdev)
 		clkdev_add(s2mps11_clk->lookup);
 	}
 
-	if (clk_table) {
-		for (i = 0; i < S2MPS11_CLKS_NUM; i++)
-			clk_table[i] = s2mps11_clks[i].clk;
+	for (i = 0; i < S2MPS11_CLKS_NUM; i++)
+		clk_table[i] = s2mps11_clks[i].clk;
 
-		clk_data.clks = clk_table;
-		clk_data.clk_num = S2MPS11_CLKS_NUM;
-		of_clk_add_provider(s2mps11_clks->clk_np,
-				of_clk_src_onecell_get, &clk_data);
-	}
+	clk_data.clks = clk_table;
+	clk_data.clk_num = S2MPS11_CLKS_NUM;
+	of_clk_add_provider(s2mps11_clks->clk_np, of_clk_src_onecell_get,
+			&clk_data);
 
 	platform_set_drvdata(pdev, s2mps11_clks);
 
-- 
1.7.9.5

