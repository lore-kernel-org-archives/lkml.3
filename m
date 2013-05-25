Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757295Ab3EYQib (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 May 2013 12:38:31 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:33557 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757142Ab3EYQi2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 May 2013 12:38:28 -0400
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
To: Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        LMML <linux-media@vger.kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH v2 2/5] media: davinci: vpif: Convert to devm_* api
Date: Sat, 25 May 2013 22:06:33 +0530
Message-Id: <1369499796-18762-3-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1369499796-18762-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1369499796-18762-1-git-send-email-prabhakar.csengg@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lad, Prabhakar <prabhakar.csengg@gmail.com>

Use devm_ioremap_resource instead of reques_mem_region()/ioremap().
This ensures more consistent error values and simplifies error paths.

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 drivers/media/platform/davinci/vpif.c |   27 ++++-----------------------
 1 files changed, 4 insertions(+), 23 deletions(-)

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
1.7.0.4

