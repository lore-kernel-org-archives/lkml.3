Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753163Ab3AUKPV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 05:15:21 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:57816 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752935Ab3AUKJ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 05:09:58 -0500
From: Thierry Reding <thierry.reding@avionic-design.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, Wolfram Sang <w.sang@pengutronix.de>,
        Wim Van Sebroeck <wim@iguana.be>, linux-watchdog@vger.kernel.org
Subject: [PATCH 32/33] watchdog: Convert to devm_ioremap_resource()
Date: Mon, 21 Jan 2013 11:09:25 +0100
Message-Id: <1358762966-20791-33-git-send-email-thierry.reding@avionic-design.de>
X-Mailer: git-send-email 1.8.1.1
In-Reply-To: <1358762966-20791-1-git-send-email-thierry.reding@avionic-design.de>
References: <1358762966-20791-1-git-send-email-thierry.reding@avionic-design.de>
X-Provags-ID: V02:K0:y4PWJMChG8qP7TG5RstQl7DsBm4cR6JeVVRKrrftVwF
 bxx0fPYjYZLq83hZFeq3eyoSXRX77G0IT10VARxMmSHQEXPtbV
 1NTQt1tsUNZWpnZBzD5D9CsxInqDIRc01XSvdQ+TqhKnT2j+cA
 F1rullXVWZ55lu6xz50m714XIThxcNWKw+DQFR3gshlslCydyY
 gJWF43PnZIx2PUw7kcwhSTEgbVj+ezdbYXWAysr0tYemYGCMZe
 AMg8QRkFwU0JtwELOs6YiC6Pqo0UL+ZzcF+m9c2h/R7FO7eq4Y
 EuDrFjtxqokSm94fAXg4QdsPZEzJJUbC8L4etGutXBeSB2vBkZ
 Qc480jo0xTP3UI6QrPkbH56KvxbwFomyr/clk2iWuzLA/i7EvH
 1RRSd0iFDBZHo8N+J6wjRlxR8rOYy3s3bB1aUr1cxOZJqNkBuK
 DGG0l
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert all uses of devm_request_and_ioremap() to the newly introduced
devm_ioremap_resource() which provides more consistent error handling.

devm_ioremap_resource() provides its own error messages so all explicit
error messages can be removed from the failure code paths.

Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
Cc: Wim Van Sebroeck <wim@iguana.be>
Cc: linux-watchdog@vger.kernel.org
---
 drivers/watchdog/ar7_wdt.c     | 8 +++-----
 drivers/watchdog/dw_wdt.c      | 6 +++---
 drivers/watchdog/imx2_wdt.c    | 8 +++-----
 drivers/watchdog/jz4740_wdt.c  | 6 +++---
 drivers/watchdog/lantiq_wdt.c  | 8 +++-----
 drivers/watchdog/max63xx_wdt.c | 7 ++++---
 drivers/watchdog/pnx4008_wdt.c | 6 +++---
 drivers/watchdog/txx9wdt.c     | 6 +++---
 8 files changed, 25 insertions(+), 30 deletions(-)

diff --git a/drivers/watchdog/ar7_wdt.c b/drivers/watchdog/ar7_wdt.c
index 3003e2a..2f3cc8f 100644
--- a/drivers/watchdog/ar7_wdt.c
+++ b/drivers/watchdog/ar7_wdt.c
@@ -285,11 +285,9 @@ static int ar7_wdt_probe(struct platform_device *pdev)
 		return -ENODEV;
 	}
 
-	ar7_wdt = devm_request_and_ioremap(&pdev->dev, ar7_regs_wdt);
-	if (!ar7_wdt) {
-		pr_err("could not ioremap registers\n");
-		return -ENXIO;
-	}
+	ar7_wdt = devm_ioremap_resource(&pdev->dev, ar7_regs_wdt);
+	if (IS_ERR(ar7_wdt))
+		return PTR_ERR(ar7_wdt);
 
 	vbus_clk = clk_get(NULL, "vbus");
 	if (IS_ERR(vbus_clk)) {
diff --git a/drivers/watchdog/dw_wdt.c b/drivers/watchdog/dw_wdt.c
index a0eba3c..2037669 100644
--- a/drivers/watchdog/dw_wdt.c
+++ b/drivers/watchdog/dw_wdt.c
@@ -301,9 +301,9 @@ static int dw_wdt_drv_probe(struct platform_device *pdev)
 	if (!mem)
 		return -EINVAL;
 
-	dw_wdt.regs = devm_request_and_ioremap(&pdev->dev, mem);
-	if (!dw_wdt.regs)
-		return -ENOMEM;
+	dw_wdt.regs = devm_ioremap_resource(&pdev->dev, mem);
+	if (IS_ERR(dw_wdt.regs))
+		return PTR_ERR(dw_wdt.regs);
 
 	dw_wdt.clk = clk_get(&pdev->dev, NULL);
 	if (IS_ERR(dw_wdt.clk))
diff --git a/drivers/watchdog/imx2_wdt.c b/drivers/watchdog/imx2_wdt.c
index 9a45d029..7f023e2 100644
--- a/drivers/watchdog/imx2_wdt.c
+++ b/drivers/watchdog/imx2_wdt.c
@@ -262,11 +262,9 @@ static int __init imx2_wdt_probe(struct platform_device *pdev)
 		return -ENODEV;
 	}
 
-	imx2_wdt.base = devm_request_and_ioremap(&pdev->dev, res);
-	if (!imx2_wdt.base) {
-		dev_err(&pdev->dev, "ioremap failed\n");
-		return -ENOMEM;
-	}
+	imx2_wdt.base = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(imx2_wdt.base))
+		return PTR_ERR(imx2_wdt.base);
 
 	imx2_wdt.clk = clk_get(&pdev->dev, NULL);
 	if (IS_ERR(imx2_wdt.clk)) {
diff --git a/drivers/watchdog/jz4740_wdt.c b/drivers/watchdog/jz4740_wdt.c
index a61408f..1cb25f6 100644
--- a/drivers/watchdog/jz4740_wdt.c
+++ b/drivers/watchdog/jz4740_wdt.c
@@ -171,9 +171,9 @@ static int jz4740_wdt_probe(struct platform_device *pdev)
 	watchdog_set_drvdata(jz4740_wdt, drvdata);
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	drvdata->base = devm_request_and_ioremap(&pdev->dev, res);
-	if (drvdata->base == NULL) {
-		ret = -EBUSY;
+	drvdata->base = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(drvdata->base)) {
+		ret = PTR_ERR(drvdata->base);
 		goto err_out;
 	}
 
diff --git a/drivers/watchdog/lantiq_wdt.c b/drivers/watchdog/lantiq_wdt.c
index 79fe01b..088fd0c 100644
--- a/drivers/watchdog/lantiq_wdt.c
+++ b/drivers/watchdog/lantiq_wdt.c
@@ -197,11 +197,9 @@ ltq_wdt_probe(struct platform_device *pdev)
 		return -ENOENT;
 	}
 
-	ltq_wdt_membase = devm_request_and_ioremap(&pdev->dev, res);
-	if (!ltq_wdt_membase) {
-		dev_err(&pdev->dev, "cannot remap I/O memory region\n");
-		return -ENOMEM;
-	}
+	ltq_wdt_membase = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(ltq_wdt_membase))
+		return PTR_ERR(ltq_wdt_membase);
 
 	/* we do not need to enable the clock as it is always running */
 	clk = clk_get_io();
diff --git a/drivers/watchdog/max63xx_wdt.c b/drivers/watchdog/max63xx_wdt.c
index 773c661..cc9d328 100644
--- a/drivers/watchdog/max63xx_wdt.c
+++ b/drivers/watchdog/max63xx_wdt.c
@@ -14,6 +14,7 @@
  * another interface, some abstraction will have to be introduced.
  */
 
+#include <linux/err.h>
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/types.h>
@@ -198,9 +199,9 @@ static int max63xx_wdt_probe(struct platform_device *pdev)
 	heartbeat = current_timeout->twd;
 
 	wdt_mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	wdt_base = devm_request_and_ioremap(&pdev->dev, wdt_mem);
-	if (!wdt_base)
-		return -ENOMEM;
+	wdt_base = devm_ioremap_resource(&pdev->dev, wdt_mem);
+	if (IS_ERR(wdt_base))
+		return PTR_ERR(wdt_base);
 
 	max63xx_wdt_dev.timeout = heartbeat;
 	watchdog_set_nowayout(&max63xx_wdt_dev, nowayout);
diff --git a/drivers/watchdog/pnx4008_wdt.c b/drivers/watchdog/pnx4008_wdt.c
index dcba5da..de1f3fa 100644
--- a/drivers/watchdog/pnx4008_wdt.c
+++ b/drivers/watchdog/pnx4008_wdt.c
@@ -155,9 +155,9 @@ static int pnx4008_wdt_probe(struct platform_device *pdev)
 		heartbeat = DEFAULT_HEARTBEAT;
 
 	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	wdt_base = devm_request_and_ioremap(&pdev->dev, r);
-	if (!wdt_base)
-		return -EADDRINUSE;
+	wdt_base = devm_ioremap_resource(&pdev->dev, r);
+	if (IS_ERR(wdt_base))
+		return PTR_ERR(wdt_base);
 
 	wdt_clk = clk_get(&pdev->dev, NULL);
 	if (IS_ERR(wdt_clk))
diff --git a/drivers/watchdog/txx9wdt.c b/drivers/watchdog/txx9wdt.c
index 98e1637..626dc0b 100644
--- a/drivers/watchdog/txx9wdt.c
+++ b/drivers/watchdog/txx9wdt.c
@@ -121,9 +121,9 @@ static int __init txx9wdt_probe(struct platform_device *dev)
 	}
 
 	res = platform_get_resource(dev, IORESOURCE_MEM, 0);
-	txx9wdt_reg = devm_request_and_ioremap(&dev->dev, res);
-	if (!txx9wdt_reg) {
-		ret = -EBUSY;
+	txx9wdt_reg = devm_ioremap_resource(&dev->dev, res);
+	if (IS_ERR(txx9wdt_reg)) {
+		ret = PTR_ERR(txx9wdt_reg);
 		goto exit;
 	}
 
-- 
1.8.1.1

