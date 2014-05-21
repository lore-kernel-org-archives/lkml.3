Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752738AbaEULXZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 07:23:25 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:12115 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751561AbaEULXW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 07:23:22 -0400
X-AuditID: cbfec7f5-b7f626d000004b39-d2-537c8ca0b33c
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Mike Turquette <mturquette@linaro.org>, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org
Cc: Lee Jones <lee.jones@linaro.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH v4 2/3] clk: s2mps11: Remove useless check for clk_table
Date: Wed, 21 May 2014 13:23:00 +0200
Message-id: <1400671381-14792-3-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1400671381-14792-1-git-send-email-k.kozlowski@samsung.com>
References: <1400671381-14792-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrGJMWRmVeSWpSXmKPExsVy+t/xa7oLemqCDe7fULLYOGM9q8XrF4YW
	Z5vesFvc/3qU0eLyrjlsFjPO72OyWHvkLrvF0wkX2SzWz3jN4sDpcefaHjaPvi2rGD0+b5IL
	YI7isklJzcksSy3St0vgyni1cw9LwWOBioX3mhkbGH/wdjFyckgImEj8aehkhLDFJC7cW8/W
	xcjFISSwlFHi85cZ7BBOH5PE3c8rWECq2ASMJTYvX8IGYosI5ErMb1wF1sEs0M0kcbljFxNI
	QljAQ2Lak2dgY1kEVCUm/vwJFucVcJfY19XPDrFOTuLkscmsIDYnUP2v5nVgthBQTcOB+YwT
	GHkXMDKsYhRNLU0uKE5KzzXSK07MLS7NS9dLzs/dxAgJq687GJceszrEKMDBqMTDm3G9OliI
	NbGsuDL3EKMEB7OSCO+xippgId6UxMqq1KL8+KLSnNTiQ4xMHJxSDYxSQg0isQrha/L7JvUx
	X3S9cNx5feqmQgMz76mmk3yWXRc4xjafY/3sh9IHznWY5N3bmmJW1F1udbj03Y7OyZLBK8It
	9LYeUQ6enWGpaia6qNxIPu9U0EH9mZsP3GmbuS6gOPFjX6jw08Li0vd2zhGbp3bO22W3XVJj
	EaOAy9fVDx2F6jfNdFdiKc5INNRiLipOBAC7EISRCQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no need for checking if 'clk_table' is not NULL twice (first
after allocation and second at the end of probe()). Also move allocation
of this 'clk_table' to probe from s2mps11_clk_parse_dt as this is
logical place for it.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 drivers/clk/clk-s2mps11.c | 24 +++++++++++-------------
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
1.9.1

