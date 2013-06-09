Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753601Ab3FIJMF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jun 2013 05:12:05 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:62222 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751811Ab3FIJMD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jun 2013 05:12:03 -0400
From: Emil Goode <emilgoode@gmail.com>
To: dwmw2@infradead.org, artem.bityutskiy@linux.intel.com, andrew@lunn.ch,
        wfp5p@virginia.edu, jg1.han@samsung.com
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, Emil Goode <emilgoode@gmail.com>
Subject: [PATCH] mtd: orion_nand: Improve error handling in orion_nand_probe
Date: Sun,  9 Jun 2013 11:08:22 +0200
Message-Id: <1370768902-20239-1-git-send-email-emilgoode@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes some issues in the error handling and simplifies
the code by converting to devm* functions.

If the kzalloc call fails it is unnecessary to use the label no_res
and pass a NULL pointer to kfree. If the devm_kzalloc call fails on
line 110 we forgett to call iounmap for the previous ioremap call.

The following changes are introduced:
- Convert to devm_kzalloc and remove calls to kfree.
- Convert to devm_ioremap_resource that adds a missing call to
  *request_mem_region and remove calls to iounmap.
- The devm_ioremap_resource function checks the passed resource so
  we can remove the NULL check after the platform_get_resource call.

Signed-off-by: Emil Goode <emilgoode@gmail.com>
---
The patch is only build tested

 drivers/mtd/nand/orion_nand.c |   39 +++++++++++----------------------------
 1 file changed, 11 insertions(+), 28 deletions(-)

diff --git a/drivers/mtd/nand/orion_nand.c b/drivers/mtd/nand/orion_nand.c
index 8fbd002..cc22f2f 100644
--- a/drivers/mtd/nand/orion_nand.c
+++ b/drivers/mtd/nand/orion_nand.c
@@ -85,34 +85,25 @@ static int __init orion_nand_probe(struct platform_device *pdev)
 	int ret = 0;
 	u32 val = 0;
 
-	nc = kzalloc(sizeof(struct nand_chip) + sizeof(struct mtd_info), GFP_KERNEL);
+	nc = devm_kzalloc(&pdev->dev, sizeof(struct nand_chip) +
+			  sizeof(struct mtd_info), GFP_KERNEL);
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
-
-	io_base = ioremap(res->start, resource_size(res));
-	if (!io_base) {
-		printk(KERN_ERR "orion_nand: ioremap failed\n");
-		ret = -EIO;
-		goto no_res;
-	}
+	io_base = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(io_base))
+		return PTR_ERR(io_base);
 
 	if (pdev->dev.of_node) {
 		board = devm_kzalloc(&pdev->dev, sizeof(struct orion_nand_data),
-					GFP_KERNEL);
+				     GFP_KERNEL);
 		if (!board) {
 			printk(KERN_ERR "orion_nand: failed to allocate board structure.\n");
-			ret = -ENOMEM;
-			goto no_res;
+			return -ENOMEM;
 		}
 		if (!of_property_read_u32(pdev->dev.of_node, "cle", &val))
 			board->cle = (u8)val;
@@ -167,7 +158,7 @@ static int __init orion_nand_probe(struct platform_device *pdev)
 
 	if (nand_scan(mtd, 1)) {
 		ret = -ENXIO;
-		goto no_dev;
+		goto disable_clk;
 	}
 
 	mtd->name = "orion_nand";
@@ -176,20 +167,17 @@ static int __init orion_nand_probe(struct platform_device *pdev)
 			board->parts, board->nr_parts);
 	if (ret) {
 		nand_release(mtd);
-		goto no_dev;
+		goto disable_clk;
 	}
 
 	return 0;
 
-no_dev:
+disable_clk:
 	if (!IS_ERR(clk)) {
 		clk_disable_unprepare(clk);
 		clk_put(clk);
 	}
 	platform_set_drvdata(pdev, NULL);
-	iounmap(io_base);
-no_res:
-	kfree(nc);
 
 	return ret;
 }
@@ -197,15 +185,10 @@ no_res:
 static int orion_nand_remove(struct platform_device *pdev)
 {
 	struct mtd_info *mtd = platform_get_drvdata(pdev);
-	struct nand_chip *nc = mtd->priv;
 	struct clk *clk;
 
 	nand_release(mtd);
 
-	iounmap(nc->IO_ADDR_W);
-
-	kfree(nc);
-
 	clk = clk_get(&pdev->dev, NULL);
 	if (!IS_ERR(clk)) {
 		clk_disable_unprepare(clk);
-- 
1.7.10.4

