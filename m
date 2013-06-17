Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752551Ab3FQPVa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 11:21:30 -0400
Received: from mail-pb0-f48.google.com ([209.85.160.48]:63135 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752901Ab3FQPV1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 11:21:27 -0400
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>,
        LMML <linux-media@vger.kernel.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH v4 02/11] media: davinci: vpif: Convert to devm_* api
Date: Mon, 17 Jun 2013 20:50:42 +0530
Message-Id: <1371482451-18314-3-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1371482451-18314-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1371482451-18314-1-git-send-email-prabhakar.csengg@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>

Use devm_ioremap_resource instead of reques_mem_region()/ioremap().
This ensures more consistent error values and simplifies error paths.

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/platform/davinci/vpif.c |   27 ++++-----------------------
 1 file changed, 4 insertions(+), 23 deletions(-)

diff --git a/drivers/media/platform/davinci/vpif.c b/drivers/media/platform/davinci/vpif.c
index 761c825..164c1b7 100644
--- a/drivers/media/platform/davinci/vpif.c
+++ b/drivers/media/platform/davinci/vpif.c
@@ -37,8 +37,6 @@ MODULE_LICENSE("GPL");
 #define VPIF_CH2_MAX_MODES	(15)
 #define VPIF_CH3_MAX_MODES	(02)
 
-static resource_size_t	res_len;
-static struct resource	*res;
 spinlock_t vpif_lock;
 
 void __iomem *vpif_base;
@@ -421,23 +419,12 @@ EXPORT_SYMBOL(vpif_channel_getfid);
 
 static int vpif_probe(struct platform_device *pdev)
 {
-	int status = 0;
+	static struct resource	*res;
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!res)
-		return -ENOENT;
-
-	res_len = resource_size(res);
-
-	res = request_mem_region(res->start, res_len, res->name);
-	if (!res)
-		return -EBUSY;
-
-	vpif_base = ioremap(res->start, res_len);
-	if (!vpif_base) {
-		status = -EBUSY;
-		goto fail;
-	}
+	vpif_base = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(vpif_base))
+		return PTR_ERR(vpif_base);
 
 	pm_runtime_enable(&pdev->dev);
 	pm_runtime_get(&pdev->dev);
@@ -445,17 +432,11 @@ static int vpif_probe(struct platform_device *pdev)
 	spin_lock_init(&vpif_lock);
 	dev_info(&pdev->dev, "vpif probe success\n");
 	return 0;
-
-fail:
-	release_mem_region(res->start, res_len);
-	return status;
 }
 
 static int vpif_remove(struct platform_device *pdev)
 {
 	pm_runtime_disable(&pdev->dev);
-	iounmap(vpif_base);
-	release_mem_region(res->start, res_len);
 	return 0;
 }
 
-- 
1.7.9.5

