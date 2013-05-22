Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754945Ab3EVNTy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 09:19:54 -0400
Received: from sauhun.de ([89.238.76.85]:55343 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752705Ab3EVNTx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 09:19:53 -0400
From: Wolfram Sang <wsa@the-dreams.de>
To: linux-kernel@vger.kernel.org
Cc: Wolfram Sang <wsa@the-dreams.de>, Deepak Saxena <dsaxena@plexity.net>,
        Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>
Subject: [PATCH 1/3] drivers/char/hw_random: remove leftover release_mem_region
Date: Wed, 22 May 2013 15:21:24 +0200
Message-Id: <1369228886-3527-1-git-send-email-wsa@the-dreams.de>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When converting this driver to devm_ioremap_resource, the removal of this now
unneeded function has been forgotten.

Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
---
 drivers/char/hw_random/omap-rng.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/char/hw_random/omap-rng.c b/drivers/char/hw_random/omap-rng.c
index d2903e7..7af2b24 100644
--- a/drivers/char/hw_random/omap-rng.c
+++ b/drivers/char/hw_random/omap-rng.c
@@ -52,7 +52,6 @@
  */
 struct omap_rng_private_data {
 	void __iomem *base;
-	struct resource *mem_res;
 };
 
 static inline u32 omap_rng_read_reg(struct omap_rng_private_data *priv, int reg)
@@ -107,6 +106,7 @@ static struct hwrng omap_rng_ops = {
 static int omap_rng_probe(struct platform_device *pdev)
 {
 	struct omap_rng_private_data *priv;
+	struct resource *mem_res;
 	int ret;
 
 	priv = kzalloc(sizeof(struct omap_rng_private_data), GFP_KERNEL);
@@ -118,8 +118,8 @@ static int omap_rng_probe(struct platform_device *pdev)
 	omap_rng_ops.priv = (unsigned long)priv;
 	dev_set_drvdata(&pdev->dev, priv);
 
-	priv->mem_res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	priv->base = devm_ioremap_resource(&pdev->dev, priv->mem_res);
+	mem_res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	priv->base = devm_ioremap_resource(&pdev->dev, mem_res);
 	if (IS_ERR(priv->base)) {
 		ret = PTR_ERR(priv->base);
 		goto err_ioremap;
@@ -160,8 +160,6 @@ static int __exit omap_rng_remove(struct platform_device *pdev)
 	pm_runtime_put_sync(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
 
-	release_mem_region(priv->mem_res->start, resource_size(priv->mem_res));
-
 	kfree(priv);
 
 	return 0;
-- 
1.7.10.4

