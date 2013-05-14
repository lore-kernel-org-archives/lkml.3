Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756810Ab3ENJSX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 05:18:23 -0400
Received: from mail-we0-f178.google.com ([74.125.82.178]:38170 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756433Ab3ENJSU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 05:18:20 -0400
From: Laurent Navet <laurent.navet@gmail.com>
To: FlorianSchandinat@gmx.de
Cc: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Laurent Navet <laurent.navet@gmail.com>
Subject: [PATCH] drivers: video: mxsfb: clean use of devm_ioremap_resource()
Date: Tue, 14 May 2013 11:25:08 +0200
Message-Id: <1368523508-30967-1-git-send-email-laurent.navet@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Check of 'res' and calls to dev_err are already done in devm_ioremap_resource,
so no need to do them twice.

Signed-off-by: Laurent Navet <laurent.navet@gmail.com>
---
 drivers/video/mxsfb.c |   14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

diff --git a/drivers/video/mxsfb.c b/drivers/video/mxsfb.c
index 21223d4..0f3d0fc 100644
--- a/drivers/video/mxsfb.c
+++ b/drivers/video/mxsfb.c
@@ -884,9 +884,10 @@ static int mxsfb_probe(struct platform_device *pdev)
 		pdev->id_entry = of_id->data;
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!res) {
-		dev_err(&pdev->dev, "Cannot get memory IO resource\n");
-		return -ENODEV;
+	host->base = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(host->base)) {
+		ret = PTR_ERR(host->base);
+		goto fb_release;
 	}
 
 	fb_info = framebuffer_alloc(sizeof(struct mxsfb_info), &pdev->dev);
@@ -897,13 +898,6 @@ static int mxsfb_probe(struct platform_device *pdev)
 
 	host = to_imxfb_host(fb_info);
 
-	host->base = devm_ioremap_resource(&pdev->dev, res);
-	if (IS_ERR(host->base)) {
-		dev_err(&pdev->dev, "ioremap failed\n");
-		ret = PTR_ERR(host->base);
-		goto fb_release;
-	}
-
 	host->pdev = pdev;
 	platform_set_drvdata(pdev, host);
 
-- 
1.7.10.4

