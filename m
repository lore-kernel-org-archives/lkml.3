Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758634AbaGAUEH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 16:04:07 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:50360 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754676AbaGAUEG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 16:04:06 -0400
Date: Wed, 2 Jul 2014 01:33:59 +0530
From: Himangi Saraogi <himangi774@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: julia.lawall@lip6.fr
Subject: [PATCH v2] mailbox/omap: Use devm_ functions
Message-ID: <20140701200358.GA10153@himangi-Dell>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces the use of devm_kzalloc and devm_ioremap instead
of the unmanaged interfaces. The calls to the corresponding functions to
free the allocated memory in probe and remove function are done away
with. The labels in the probe function are also removed.

Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
Acked-by: Julia Lawall <julia.lawall@lip6.fr>
---
 drivers/mailbox/mailbox-omap2.c | 62 ++++++++++++-----------------------------
 1 file changed, 18 insertions(+), 44 deletions(-)

diff --git a/drivers/mailbox/mailbox-omap2.c b/drivers/mailbox/mailbox-omap2.c
index 42d2b89..8a96de9 100644
--- a/drivers/mailbox/mailbox-omap2.c
+++ b/drivers/mailbox/mailbox-omap2.c
@@ -236,21 +236,20 @@ static int omap2_mbox_probe(struct platform_device *pdev)
 	}
 
 	/* allocate one extra for marking end of list */
-	list = kzalloc((pdata->info_cnt + 1) * sizeof(*list), GFP_KERNEL);
+	list = devm_kzalloc(&pdev->dev, (pdata->info_cnt + 1) * sizeof(*list),
+			    GFP_KERNEL);
 	if (!list)
 		return -ENOMEM;
 
-	mboxblk = mbox = kzalloc(pdata->info_cnt * sizeof(*mbox), GFP_KERNEL);
-	if (!mboxblk) {
-		ret = -ENOMEM;
-		goto free_list;
-	}
+	mboxblk = mbox = devm_kzalloc(&pdev->dev,
+				pdata->info_cnt * sizeof(*mbox), GFP_KERNEL);
+	if (!mboxblk)
+		return -ENOMEM;
 
-	privblk = priv = kzalloc(pdata->info_cnt * sizeof(*priv), GFP_KERNEL);
-	if (!privblk) {
-		ret = -ENOMEM;
-		goto free_mboxblk;
-	}
+	privblk = priv = devm_kzalloc(&pdev->dev,
+				pdata->info_cnt * sizeof(*priv), GFP_KERNEL);
+	if (!privblk)
+		return -ENOMEM;
 
 	info = pdata->info;
 	for (i = 0; i < pdata->info_cnt; i++, info++, priv++) {
@@ -276,55 +275,30 @@ static int omap2_mbox_probe(struct platform_device *pdev)
 		mbox->name = info->name;
 		mbox->ops = &omap2_mbox_ops;
 		mbox->irq = platform_get_irq(pdev, info->irq_id);
-		if (mbox->irq < 0) {
-			ret = mbox->irq;
-			goto free_privblk;
-		}
+		if (mbox->irq < 0)
+			return mbox->irq;
 		list[i] = mbox++;
 	}
 
 	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!mem) {
-		ret = -ENOENT;
-		goto free_privblk;
-	}
+	if (!mem)
+		return -ENOENT;
 
-	mbox_base = ioremap(mem->start, resource_size(mem));
-	if (!mbox_base) {
-		ret = -ENOMEM;
-		goto free_privblk;
-	}
+	mbox_base = devm_ioremap(&pdev->dev, mem->start, resource_size(mem));
+	if (!mbox_base)
+		return -ENOMEM;
 
 	ret = omap_mbox_register(&pdev->dev, list);
 	if (ret)
-		goto unmap_mbox;
+		return ret;
 	platform_set_drvdata(pdev, list);
 
 	return 0;
-
-unmap_mbox:
-	iounmap(mbox_base);
-free_privblk:
-	kfree(privblk);
-free_mboxblk:
-	kfree(mboxblk);
-free_list:
-	kfree(list);
-	return ret;
 }
 
 static int omap2_mbox_remove(struct platform_device *pdev)
 {
-	struct omap_mbox2_priv *privblk;
-	struct omap_mbox **list = platform_get_drvdata(pdev);
-	struct omap_mbox *mboxblk = list[0];
-
-	privblk = mboxblk->priv;
 	omap_mbox_unregister();
-	iounmap(mbox_base);
-	kfree(privblk);
-	kfree(mboxblk);
-	kfree(list);
 
 	return 0;
 }
-- 
1.9.1

