Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751371Ab3GQCJO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 22:09:14 -0400
Received: from mail-bk0-f41.google.com ([209.85.214.41]:65203 "EHLO
	mail-bk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751186Ab3GQCJM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 22:09:12 -0400
MIME-Version: 1.0
Date: Wed, 17 Jul 2013 10:09:10 +0800
Message-ID: <CAPgLHd8upcmfnQqHAWnqP7YBVYDVyoYKQ3WCh3c5+uY-EKr1jg@mail.gmail.com>
Subject: [PATCH -next] mtd: orion_nand: convert to use devm_* APIs
From: Wei Yongjun <weiyj.lk@gmail.com>
To: dwmw2@infradead.org, grant.likely@linaro.org, rob.herring@calxeda.com,
        artem.bityutskiy@linux.intel.com, jg1.han@samsung.com, andrew@lunn.ch,
        wfp5p@virginia.edu
Cc: yongjun_wei@trendmicro.com.cn, linux-mtd@lists.infradead.org,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Convert to use devm_* APIs to avoid resources leak on error handling case.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/mtd/nand/orion_nand.c | 29 +++++++++--------------------
 1 file changed, 9 insertions(+), 20 deletions(-)

diff --git a/drivers/mtd/nand/orion_nand.c b/drivers/mtd/nand/orion_nand.c
index 46f308d..ce711b4 100644
--- a/drivers/mtd/nand/orion_nand.c
+++ b/drivers/mtd/nand/orion_nand.c
@@ -85,25 +85,23 @@ static int __init orion_nand_probe(struct platform_device *pdev)
 	int ret = 0;
 	u32 val = 0;
 
-	nc = kzalloc(sizeof(struct nand_chip) + sizeof(struct mtd_info), GFP_KERNEL);
+	nc = devm_kzalloc(&pdev->dev,
+			  sizeof(struct nand_chip) + sizeof(struct mtd_info),
+			  GFP_KERNEL);
 	if (!nc) {
 		printk(KERN_ERR "orion_nand: failed to allocate device structure.\n");
-		ret = -ENOMEM;
-		goto no_res;
+		return -ENOMEM;
 	}
 	mtd = (struct mtd_info *)(nc + 1);
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!res) {
-		ret = -ENODEV;
-		goto no_res;
-	}
+	if (!res)
+		return -ENODEV;
 
-	io_base = ioremap(res->start, resource_size(res));
+	io_base = devm_ioremap(&pdev->dev, res->start, resource_size(res));
 	if (!io_base) {
 		printk(KERN_ERR "orion_nand: ioremap failed\n");
-		ret = -EIO;
-		goto no_res;
+		return -EIO;
 	}
 
 	if (pdev->dev.of_node) {
@@ -111,8 +109,7 @@ static int __init orion_nand_probe(struct platform_device *pdev)
 					GFP_KERNEL);
 		if (!board) {
 			printk(KERN_ERR "orion_nand: failed to allocate board structure.\n");
-			ret = -ENOMEM;
-			goto no_res;
+			return -ENOMEM;
 		}
 		if (!of_property_read_u32(pdev->dev.of_node, "cle", &val))
 			board->cle = (u8)val;
@@ -186,10 +183,6 @@ no_dev:
 		clk_disable_unprepare(clk);
 		clk_put(clk);
 	}
-	iounmap(io_base);
-no_res:
-	kfree(nc);
-
 	return ret;
 }
 
@@ -201,10 +194,6 @@ static int orion_nand_remove(struct platform_device *pdev)
 
 	nand_release(mtd);
 
-	iounmap(nc->IO_ADDR_W);
-
-	kfree(nc);
-
 	clk = clk_get(&pdev->dev, NULL);
 	if (!IS_ERR(clk)) {
 		clk_disable_unprepare(clk);

