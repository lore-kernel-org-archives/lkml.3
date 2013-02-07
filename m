Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757758Ab3BGKcK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 05:32:10 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:34249 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755776Ab3BGKcG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 05:32:06 -0500
From: Mrugesh Katepallewar <mrugesh.mk@ti.com>
To: <linux-mtd@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <davinci-linux-open-source@linux.davincidsp.com>
CC: <dwmw2@infradead.org>, <artem.bityutskiy@linux.intel.com>,
        <m-karicheri2@ti.com>, <mturquette@linaro.org>, <nsekhar@ti.com>
Subject: [PATCH] mtd: davinci_nand: Use managed resources
Date: Thu, 7 Feb 2013 16:03:15 +0530
Message-ID: <1360233195-8575-1-git-send-email-mrugesh.mk@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

davinci_nand driver currently uses normal kzalloc, ioremap and get_clk
routines. This patch replaces these routines with devm_kzalloc,
devm_request_and_ioremap and devm_clk_get resp.

Signed-off-by: Mrugesh Katepallewar <mrugesh.mk@ti.com>
---
Apply on top of v3.8-rc6 of linus tree.

:100644 100644 3502606... e7d5bd6... M	drivers/mtd/nand/davinci_nand.c
 drivers/mtd/nand/davinci_nand.c |   24 +++++-------------------
 1 file changed, 5 insertions(+), 19 deletions(-)

diff --git a/drivers/mtd/nand/davinci_nand.c b/drivers/mtd/nand/davinci_nand.c
index 3502606..e7d5bd6 100644
--- a/drivers/mtd/nand/davinci_nand.c
+++ b/drivers/mtd/nand/davinci_nand.c
@@ -606,7 +606,7 @@ static int __init nand_davinci_probe(struct platform_device *pdev)
 	if (pdev->id < 0 || pdev->id > 3)
 		return -ENODEV;
 
-	info = kzalloc(sizeof(*info), GFP_KERNEL);
+	info = devm_kzalloc(&pdev->dev, sizeof(*info), GFP_KERNEL);
 	if (!info) {
 		dev_err(&pdev->dev, "unable to allocate memory\n");
 		ret = -ENOMEM;
@@ -623,11 +623,11 @@ static int __init nand_davinci_probe(struct platform_device *pdev)
 		goto err_nomem;
 	}
 
-	vaddr = ioremap(res1->start, resource_size(res1));
-	base = ioremap(res2->start, resource_size(res2));
+	vaddr = devm_request_and_ioremap(&pdev->dev, res1);
+	base = devm_request_and_ioremap(&pdev->dev, res2);
 	if (!vaddr || !base) {
 		dev_err(&pdev->dev, "ioremap failed\n");
-		ret = -EINVAL;
+		ret = -EADDRNOTAVAIL;
 		goto err_ioremap;
 	}
 
@@ -717,7 +717,7 @@ static int __init nand_davinci_probe(struct platform_device *pdev)
 	}
 	info->chip.ecc.mode = ecc_mode;
 
-	info->clk = clk_get(&pdev->dev, "aemif");
+	info->clk = devm_clk_get(&pdev->dev, "aemif");
 	if (IS_ERR(info->clk)) {
 		ret = PTR_ERR(info->clk);
 		dev_dbg(&pdev->dev, "unable to get AEMIF clock, err %d\n", ret);
@@ -845,8 +845,6 @@ err_timing:
 	clk_disable_unprepare(info->clk);
 
 err_clk_enable:
-	clk_put(info->clk);
-
 	spin_lock_irq(&davinci_nand_lock);
 	if (ecc_mode == NAND_ECC_HW_SYNDROME)
 		ecc4_busy = false;
@@ -855,13 +853,7 @@ err_clk_enable:
 err_ecc:
 err_clk:
 err_ioremap:
-	if (base)
-		iounmap(base);
-	if (vaddr)
-		iounmap(vaddr);
-
 err_nomem:
-	kfree(info);
 	return ret;
 }
 
@@ -874,15 +866,9 @@ static int __exit nand_davinci_remove(struct platform_device *pdev)
 		ecc4_busy = false;
 	spin_unlock_irq(&davinci_nand_lock);
 
-	iounmap(info->base);
-	iounmap(info->vaddr);
-
 	nand_release(&info->mtd);
 
 	clk_disable_unprepare(info->clk);
-	clk_put(info->clk);
-
-	kfree(info);
 
 	return 0;
 }
-- 
1.7.9.5

