Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932366AbaJNOQr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 10:16:47 -0400
Received: from top.free-electrons.com ([176.31.233.9]:55220 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932165AbaJNOQq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 10:16:46 -0400
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
To: dwmw2@infradead.org, computersforpeace@gmail.com
Cc: jg1.han@samsung.com, andrew@lunn.ch, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: [PATCH] mtd: orion_nand: fix error code path in probe
Date: Tue, 14 Oct 2014 16:16:38 +0200
Message-Id: <1413296198-29486-1-git-send-email-michael.opdenacker@free-electrons.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This replaces kzalloc() and ioremap() calls by
the corresponding devm_ functions in the probe() routine,
which automatically release the corresponding resources
when probe() fails or when the device is removed.

This simplifies the error management code and
fixes a bug reported by "make coccicheck":

if "board = devm_kzalloc()" fails, the probe()
function jumps incorrectly to label "no_res" and
therefore returns without running "iounmap()"

Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
---
 drivers/mtd/nand/orion_nand.c | 28 +++++++++-------------------
 1 file changed, 9 insertions(+), 19 deletions(-)

diff --git a/drivers/mtd/nand/orion_nand.c b/drivers/mtd/nand/orion_nand.c
index 471b4df3a5ac..a9c2bde16c25 100644
--- a/drivers/mtd/nand/orion_nand.c
+++ b/drivers/mtd/nand/orion_nand.c
@@ -19,7 +19,7 @@
 #include <linux/mtd/partitions.h>
 #include <linux/clk.h>
 #include <linux/err.h>
-#include <asm/io.h>
+#include <linux/io.h>
 #include <asm/sizes.h>
 #include <linux/platform_data/mtd-orion_nand.h>
 
@@ -85,32 +85,30 @@ static int __init orion_nand_probe(struct platform_device *pdev)
 	int ret = 0;
 	u32 val = 0;
 
-	nc = kzalloc(sizeof(struct nand_chip) + sizeof(struct mtd_info), GFP_KERNEL);
+	nc = devm_kzalloc(&pdev->dev,
+			sizeof(struct nand_chip) + sizeof(struct mtd_info),
+			GFP_KERNEL);
 	if (!nc) {
-		ret = -ENOMEM;
-		goto no_res;
+		return -ENOMEM;
 	}
 	mtd = (struct mtd_info *)(nc + 1);
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (!res) {
-		ret = -ENODEV;
-		goto no_res;
+		return -ENODEV;
 	}
 
-	io_base = ioremap(res->start, resource_size(res));
+	io_base = devm_ioremap(&pdev->dev, res->start, resource_size(res));
 	if (!io_base) {
 		dev_err(&pdev->dev, "ioremap failed\n");
-		ret = -EIO;
-		goto no_res;
+		return -EIO;
 	}
 
 	if (pdev->dev.of_node) {
 		board = devm_kzalloc(&pdev->dev, sizeof(struct orion_nand_data),
 					GFP_KERNEL);
 		if (!board) {
-			ret = -ENOMEM;
-			goto no_res;
+			return -ENOMEM;
 		}
 		if (!of_property_read_u32(pdev->dev.of_node, "cle", &val))
 			board->cle = (u8)val;
@@ -185,9 +183,6 @@ no_dev:
 		clk_disable_unprepare(clk);
 		clk_put(clk);
 	}
-	iounmap(io_base);
-no_res:
-	kfree(nc);
 
 	return ret;
 }
@@ -195,15 +190,10 @@ no_res:
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
1.9.1

