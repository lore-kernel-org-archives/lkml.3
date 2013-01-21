Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753042Ab3AUKJs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 05:09:48 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:60647 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752971Ab3AUKJm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 05:09:42 -0500
From: Thierry Reding <thierry.reding@avionic-design.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, Wolfram Sang <w.sang@pengutronix.de>
Subject: [PATCH 06/33] char: Convert to devm_ioremap_resource()
Date: Mon, 21 Jan 2013 11:08:59 +0100
Message-Id: <1358762966-20791-7-git-send-email-thierry.reding@avionic-design.de>
X-Mailer: git-send-email 1.8.1.1
In-Reply-To: <1358762966-20791-1-git-send-email-thierry.reding@avionic-design.de>
References: <1358762966-20791-1-git-send-email-thierry.reding@avionic-design.de>
X-Provags-ID: V02:K0:WAfHjCNjFJF/7zkD1Kam2UvymvxeeDNjB3kejYGA6nJ
 tCwFdYEYx8rWXORCgDaZ+M+9/JBCcKsKsdEgwRLAmJDR4rHOWD
 xEIYGR8TtasmvpJjTd21zRcChL+fvfvTYARvA3TtfrMx9oE6Yc
 JxwwLZoN+N0hBC4fYi0acPo+JsrsbK+X371FLvH6wjDW2D1F9W
 hOddvPnbmN8K22Huo5yX/1vwT/XdQ5o4n2lwe5/R/zERFYG93T
 MrwSfYOqzeNkuAZ/t2yonFz5ob9/T+fDCtO3I7vu+ZM4Gmpv1r
 Fg3jz8M98cD81LhlDNZTmzTIC6+CJVc1ciTdCCyu4/ENrN/7py
 zjh0+5oEQOyxR5dFUlpKVgI+qKgs/VWknISv89kzIgu4twLKeg
 igw5qoYo+oq+/NgfEBNl2XoWi3YyZqywSB3Wyk/ZN8jaG+jxGx
 v2YvU
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert all uses of devm_request_and_ioremap() to the newly introduced
devm_ioremap_resource() which provides more consistent error handling.

Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>
---
 drivers/char/hw_random/exynos-rng.c | 9 +++++----
 drivers/char/hw_random/omap-rng.c   | 6 +++---
 drivers/char/hw_random/tx4939-rng.c | 7 ++++---
 3 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/drivers/char/hw_random/exynos-rng.c b/drivers/char/hw_random/exynos-rng.c
index 48bbfec..4673fc4 100644
--- a/drivers/char/hw_random/exynos-rng.c
+++ b/drivers/char/hw_random/exynos-rng.c
@@ -104,6 +104,7 @@ static int exynos_read(struct hwrng *rng, void *buf,
 static int exynos_rng_probe(struct platform_device *pdev)
 {
 	struct exynos_rng *exynos_rng;
+	struct resource *res;
 
 	exynos_rng = devm_kzalloc(&pdev->dev, sizeof(struct exynos_rng),
 					GFP_KERNEL);
@@ -120,10 +121,10 @@ static int exynos_rng_probe(struct platform_device *pdev)
 		return -ENOENT;
 	}
 
-	exynos_rng->mem = devm_request_and_ioremap(&pdev->dev,
-			platform_get_resource(pdev, IORESOURCE_MEM, 0));
-	if (!exynos_rng->mem)
-		return -EBUSY;
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	exynos_rng->mem = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(exynos_rng->mem))
+		return PTR_ERR(exynos_rng->mem);
 
 	platform_set_drvdata(pdev, exynos_rng);
 
diff --git a/drivers/char/hw_random/omap-rng.c b/drivers/char/hw_random/omap-rng.c
index d8c54e2..749dc16 100644
--- a/drivers/char/hw_random/omap-rng.c
+++ b/drivers/char/hw_random/omap-rng.c
@@ -124,9 +124,9 @@ static int omap_rng_probe(struct platform_device *pdev)
 		goto err_ioremap;
 	}
 
-	priv->base = devm_request_and_ioremap(&pdev->dev, priv->mem_res);
-	if (!priv->base) {
-		ret = -ENOMEM;
+	priv->base = devm_ioremap_resource(&pdev->dev, priv->mem_res);
+	if (IS_ERR(priv->base)) {
+		ret = PTR_ERR(priv->base);
 		goto err_ioremap;
 	}
 	dev_set_drvdata(&pdev->dev, priv);
diff --git a/drivers/char/hw_random/tx4939-rng.c b/drivers/char/hw_random/tx4939-rng.c
index de473ef..3099198 100644
--- a/drivers/char/hw_random/tx4939-rng.c
+++ b/drivers/char/hw_random/tx4939-rng.c
@@ -7,6 +7,7 @@
  * License.  See the file "COPYING" in the main directory of this archive
  * for more details.
  */
+#include <linux/err.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/init.h>
@@ -115,9 +116,9 @@ static int __init tx4939_rng_probe(struct platform_device *dev)
 	rngdev = devm_kzalloc(&dev->dev, sizeof(*rngdev), GFP_KERNEL);
 	if (!rngdev)
 		return -ENOMEM;
-	rngdev->base = devm_request_and_ioremap(&dev->dev, r);
-	if (!rngdev->base)
-		return -EBUSY;
+	rngdev->base = devm_ioremap_resource(&dev->dev, r);
+	if (IS_ERR(rngdev->base))
+		return PTR_ERR(rngdev->base);
 
 	rngdev->rng.name = dev_name(&dev->dev);
 	rngdev->rng.data_present = tx4939_rng_data_present;
-- 
1.8.1.1

