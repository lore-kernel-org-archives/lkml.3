Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754018Ab3EPM7X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 08:59:23 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:38892 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753880Ab3EPM7U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 08:59:20 -0400
From: Lad Prabhakar <prabhakar.csengg@gmail.com>
To: DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LMML <linux-media@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH 2/7] media: davinci: vpif: Convert to devm_* api
Date: Thu, 16 May 2013 18:28:17 +0530
Message-Id: <1368709102-2854-3-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1368709102-2854-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1368709102-2854-1-git-send-email-prabhakar.csengg@gmail.com>
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
index d354d50..7d028ca 100644
--- a/drivers/media/platform/davinci/vpif.c
+++ b/drivers/media/platform/davinci/vpif.c
@@ -32,8 +32,6 @@ MODULE_LICENSE("GPL");
 #define VPIF_CH2_MAX_MODES	(15)
 #define VPIF_CH3_MAX_MODES	(02)
 
-static resource_size_t	res_len;
-static struct resource	*res;
 spinlock_t vpif_lock;
 
 void __iomem *vpif_base;
@@ -416,23 +414,12 @@ EXPORT_SYMBOL(vpif_channel_getfid);
 
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
@@ -440,17 +427,11 @@ static int vpif_probe(struct platform_device *pdev)
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
1.7.4.1

