Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756143Ab3CMD5s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 23:57:48 -0400
Received: from mail-ea0-f169.google.com ([209.85.215.169]:45796 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755873Ab3CMD5r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 23:57:47 -0400
From: Fabio Estevam <festevam@gmail.com>
To: herbert@gondor.hengli.com.au
Cc: s.hauer@pengutronix.de, linux-kernel@vger.kernel.org,
        Fabio Estevam <fabio.estevam@freescale.com>
Subject: [PATCH] hw_random: mxc-rnga: Use devm_ioremap_resource()
Date: Wed, 13 Mar 2013 00:57:27 -0300
Message-Id: <1363147047-22546-1-git-send-email-festevam@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fabio Estevam <fabio.estevam@freescale.com>

Using devm_ioremap_resource() can make the code cleaner and simpler.

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
 drivers/char/hw_random/mxc-rnga.c |   21 ++++-----------------
 1 file changed, 4 insertions(+), 17 deletions(-)

diff --git a/drivers/char/hw_random/mxc-rnga.c b/drivers/char/hw_random/mxc-rnga.c
index f05d857..93fc741 100644
--- a/drivers/char/hw_random/mxc-rnga.c
+++ b/drivers/char/hw_random/mxc-rnga.c
@@ -142,7 +142,7 @@ static void mxc_rnga_cleanup(struct hwrng *rng)
 static int __init mxc_rnga_probe(struct platform_device *pdev)
 {
 	int err = -ENODEV;
-	struct resource *res, *mem;
+	struct resource *res;
 	struct mxc_rng *mxc_rng;
 
 	mxc_rng = devm_kzalloc(&pdev->dev, sizeof(struct mxc_rng),
@@ -172,15 +172,9 @@ static int __init mxc_rnga_probe(struct platform_device *pdev)
 		goto err_region;
 	}
 
-	mem = request_mem_region(res->start, resource_size(res), pdev->name);
-	if (mem == NULL) {
-		err = -EBUSY;
-		goto err_region;
-	}
-
-	mxc_rng->mem = ioremap(res->start, resource_size(res));
-	if (!mxc_rng->mem) {
-		err = -ENOMEM;
+	mxc_rng->mem = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(mxc_rng->mem)) {
+		err = PTR_ERR(mxc_rng->mem);
 		goto err_ioremap;
 	}
 
@@ -195,8 +189,6 @@ static int __init mxc_rnga_probe(struct platform_device *pdev)
 	return 0;
 
 err_ioremap:
-	release_mem_region(res->start, resource_size(res));
-
 err_region:
 	clk_disable_unprepare(mxc_rng->clk);
 
@@ -206,15 +198,10 @@ out:
 
 static int __exit mxc_rnga_remove(struct platform_device *pdev)
 {
-	struct resource *res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	struct mxc_rng *mxc_rng = platform_get_drvdata(pdev);
 
 	hwrng_unregister(&mxc_rng->rng);
 
-	iounmap(mxc_rng->mem);
-
-	release_mem_region(res->start, resource_size(res));
-
 	clk_disable_unprepare(mxc_rng->clk);
 
 	return 0;
-- 
1.7.9.5

