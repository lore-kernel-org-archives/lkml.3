Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758984Ab3EBNOt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 09:14:49 -0400
Received: from mail-we0-f179.google.com ([74.125.82.179]:59110 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757877Ab3EBNOs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 09:14:48 -0400
From: Laurent Navet <laurent.navet@gmail.com>
To: dwmw2@infradead.org
Cc: artem.bityutskiy@linux.intel.com, sshtylyov@ru.mvista.com,
        m-karicheri2@ti.com, mturquette@linaro.org,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        Laurent Navet <laurent.navet@gmail.com>
Subject: [PATCH] drivers: mtd: nand: davinci: use devm_ioremap_resource()
Date: Thu,  2 May 2013 15:22:14 +0200
Message-Id: <1367500934-28030-1-git-send-email-laurent.navet@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace a call to deprecated devm_request_and_ioremap by devm_ioremap_resource.

Found with coccicheck and this semantic patch:
 scripts/coccinelle/api/devm_request_and_ioremap.cocci.

Signed-off-by: Laurent Navet <laurent.navet@gmail.com>
---
 drivers/mtd/nand/davinci_nand.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/mtd/nand/davinci_nand.c b/drivers/mtd/nand/davinci_nand.c
index 94e17af..4a96e58 100644
--- a/drivers/mtd/nand/davinci_nand.c
+++ b/drivers/mtd/nand/davinci_nand.c
@@ -623,11 +623,14 @@ static int __init nand_davinci_probe(struct platform_device *pdev)
 		goto err_nomem;
 	}
 
-	vaddr = devm_request_and_ioremap(&pdev->dev, res1);
-	base = devm_request_and_ioremap(&pdev->dev, res2);
-	if (!vaddr || !base) {
-		dev_err(&pdev->dev, "ioremap failed\n");
-		ret = -EADDRNOTAVAIL;
+	vaddr = devm_ioremap_resource(&pdev->dev, res1);
+	base = devm_ioremap_resource(&pdev->dev, res2);
+	if (IS_ERR(vaddr)) {
+		ret = PTR_ERR(vaddr);
+		goto err_ioremap;
+	}
+	if (IS_ERR(base)) {
+		ret = PTR_ERR(base);
 		goto err_ioremap;
 	}
 
-- 
1.7.10.4

