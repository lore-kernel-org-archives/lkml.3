Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932806Ab3GMIvt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jul 2013 04:51:49 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:63521 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758155Ab3GMIvr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jul 2013 04:51:47 -0400
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>
Cc: DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH 4/5] media: davinci: vpss: convert to devm* api
Date: Sat, 13 Jul 2013 14:20:30 +0530
Message-Id: <1373705431-11500-5-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1373705431-11500-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1373705431-11500-1-git-send-email-prabhakar.csengg@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>

Replace existing resource handling in the driver with managed
device resource, this ensures more consistent error values and
simplifies error paths.

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 drivers/media/platform/davinci/vpss.c |   62 +++++++--------------------------
 1 file changed, 13 insertions(+), 49 deletions(-)

diff --git a/drivers/media/platform/davinci/vpss.c b/drivers/media/platform/davinci/vpss.c
index 8a2f01e..31120b4 100644
--- a/drivers/media/platform/davinci/vpss.c
+++ b/drivers/media/platform/davinci/vpss.c
@@ -21,6 +21,7 @@
 #include <linux/platform_device.h>
 #include <linux/io.h>
 #include <linux/pm_runtime.h>
+#include <linux/err.h>
 
 #include <media/davinci/vpss.h>
 
@@ -404,9 +405,8 @@ EXPORT_SYMBOL(dm365_vpss_set_pg_frame_size);
 
 static int vpss_probe(struct platform_device *pdev)
 {
-	struct resource		*r1, *r2;
+	struct resource *res;
 	char *platform_name;
-	int status;
 
 	if (!pdev->dev.platform_data) {
 		dev_err(&pdev->dev, "no platform data\n");
@@ -427,38 +427,19 @@ static int vpss_probe(struct platform_device *pdev)
 	}
 
 	dev_info(&pdev->dev, "%s vpss probed\n", platform_name);
-	r1 = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!r1)
-		return -ENOENT;
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 
-	r1 = request_mem_region(r1->start, resource_size(r1), r1->name);
-	if (!r1)
-		return -EBUSY;
-
-	oper_cfg.vpss_regs_base0 = ioremap(r1->start, resource_size(r1));
-	if (!oper_cfg.vpss_regs_base0) {
-		status = -EBUSY;
-		goto fail1;
-	}
+	oper_cfg.vpss_regs_base0 = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(oper_cfg.vpss_regs_base0))
+		return PTR_ERR(oper_cfg.vpss_regs_base0);
 
 	if (oper_cfg.platform == DM355 || oper_cfg.platform == DM365) {
-		r2 = platform_get_resource(pdev, IORESOURCE_MEM, 1);
-		if (!r2) {
-			status = -ENOENT;
-			goto fail2;
-		}
-		r2 = request_mem_region(r2->start, resource_size(r2), r2->name);
-		if (!r2) {
-			status = -EBUSY;
-			goto fail2;
-		}
-
-		oper_cfg.vpss_regs_base1 = ioremap(r2->start,
-						   resource_size(r2));
-		if (!oper_cfg.vpss_regs_base1) {
-			status = -EBUSY;
-			goto fail3;
-		}
+		res = platform_get_resource(pdev, IORESOURCE_MEM, 1);
+
+		oper_cfg.vpss_regs_base1 = devm_ioremap_resource(&pdev->dev,
+								 res);
+		if (IS_ERR(oper_cfg.vpss_regs_base1))
+			return PTR_ERR(oper_cfg.vpss_regs_base1);
 	}
 
 	if (oper_cfg.platform == DM355) {
@@ -493,30 +474,13 @@ static int vpss_probe(struct platform_device *pdev)
 
 	spin_lock_init(&oper_cfg.vpss_lock);
 	dev_info(&pdev->dev, "%s vpss probe success\n", platform_name);
-	return 0;
 
-fail3:
-	release_mem_region(r2->start, resource_size(r2));
-fail2:
-	iounmap(oper_cfg.vpss_regs_base0);
-fail1:
-	release_mem_region(r1->start, resource_size(r1));
-	return status;
+	return 0;
 }
 
 static int vpss_remove(struct platform_device *pdev)
 {
-	struct resource		*res;
-
 	pm_runtime_disable(&pdev->dev);
-	iounmap(oper_cfg.vpss_regs_base0);
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	release_mem_region(res->start, resource_size(res));
-	if (oper_cfg.platform == DM355 || oper_cfg.platform == DM365) {
-		iounmap(oper_cfg.vpss_regs_base1);
-		res = platform_get_resource(pdev, IORESOURCE_MEM, 1);
-		release_mem_region(res->start, resource_size(res));
-	}
 	return 0;
 }
 
-- 
1.7.9.5

