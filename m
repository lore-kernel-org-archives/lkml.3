Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758968AbaGOR0B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 13:26:01 -0400
Received: from mail-we0-f171.google.com ([74.125.82.171]:62631 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755220AbaGORCI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 13:02:08 -0400
From: Sam Asadi <asadi.samuel@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Himangi Saraogi <himangi774@gmail.com>,
        Mike Turquette <mturquette@linaro.org>,
        sam-the-6 <asadi.samuel@gmail.com>
Subject: [PATCH 15/94] clk: sunxi: fix devm_ioremap_resource error detection code
Date: Tue, 15 Jul 2014 20:00:30 +0300
Message-Id: <1405443709-15288-15-git-send-email-asadi.samuel@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1405443709-15288-1-git-send-email-asadi.samuel@gmail.com>
References: <1405443709-15288-1-git-send-email-asadi.samuel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Himangi Saraogi <himangi774@gmail.com>

devm_ioremap_resource returns an ERR_PTR value, not NULL, on failure.

A simplified version of the semantic match that finds this problem is as
follows:

// <smpl>
@@
expression e,e1;
statement S;
@@

*e = devm_ioremap_resource(...);
if (!e1) S

// </smpl>

Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
Acked-by: Julia Lawall <julia.lawall@lip6.fr>
Acked-by Boris BREZILLON <boris.brezillon@free-electrons.com>
Signed-off-by: Mike Turquette <mturquette@linaro.org>
Signed-off-by: sam-the-6 <asadi.samuel@gmail.com>
---
 drivers/clk/sunxi/clk-sun6i-apb0-gates.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/sunxi/clk-sun6i-apb0-gates.c b/drivers/clk/sunxi/clk-sun6i-apb0-gates.c
index 44cd27c..670f90d 100644
--- a/drivers/clk/sunxi/clk-sun6i-apb0-gates.c
+++ b/drivers/clk/sunxi/clk-sun6i-apb0-gates.c
@@ -29,7 +29,7 @@ static int sun6i_a31_apb0_gates_clk_probe(struct platform_device *pdev)
 
 	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	reg = devm_ioremap_resource(&pdev->dev, r);
-	if (!reg)
+	if (IS_ERR(reg))
 		return PTR_ERR(reg);
 
 	clk_parent = of_clk_get_parent_name(np, 0);
-- 
1.7.10.4

