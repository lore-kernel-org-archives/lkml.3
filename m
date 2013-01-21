Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752964Ab3AUKJk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 05:09:40 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:57143 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752918Ab3AUKJi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 05:09:38 -0500
From: Thierry Reding <thierry.reding@avionic-design.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, Wolfram Sang <w.sang@pengutronix.de>,
        Vinod Koul <vinod.koul@intel.com>
Subject: [PATCH 07/33] dma: Convert to devm_ioremap_resource()
Date: Mon, 21 Jan 2013 11:09:00 +0100
Message-Id: <1358762966-20791-8-git-send-email-thierry.reding@avionic-design.de>
X-Mailer: git-send-email 1.8.1.1
In-Reply-To: <1358762966-20791-1-git-send-email-thierry.reding@avionic-design.de>
References: <1358762966-20791-1-git-send-email-thierry.reding@avionic-design.de>
X-Provags-ID: V02:K0:JlD+OCL5UkL0VBFpmTsyjJ3Go2XNiZqgEuafsVqL4p4
 jHzgYTkU9tQSGrjZSoQxxlx1a/GrgQUd3AbwVjCTWGxq5l2ssw
 8Pft5xZEchfWVfXskeJfqQ+GtGwW2P01Its/PT18xUC7hetEdF
 dhXuAnEUzzlL3NZTQ41lnL7WyPHEHLgdgP5Y6DeBYdzKZO3679
 /sbqkBv/d6inYCcyi5tr3s83MTe+5P8IuPJWf6gPM9r6rA00Q2
 83iuSLT6hOD9u0lyXLH85E3pOJwGt0K0FNunM9R0NlyAAB5wkh
 9/JwStaz6Z2Y0yOJ4tDbW/QyHaXokraDFtRbwT1h5uo+apJjG0
 6qqhxYdOHRfPb0UI6xE6rKoqxuDCD4X0O3d8CQsUcuRUWFeS6+
 9tj0hZU3XLigy8hR5+vMP0GdmM6m/Z7kFq4L2SY0bnmvlIBcaC
 11vFz
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert all uses of devm_request_and_ioremap() to the newly introduced
devm_ioremap_resource() which provides more consistent error handling.

devm_ioremap_resource() provides its own error messages so all explicit
error messages can be removed from the failure code paths.

Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
Cc: Vinod Koul <vinod.koul@intel.com>
---
 drivers/dma/dw_dmac.c         |  7 ++++---
 drivers/dma/imx-dma.c         |  7 ++++---
 drivers/dma/mmp_pdma.c        |  7 ++++---
 drivers/dma/mmp_tdma.c        |  7 ++++---
 drivers/dma/tegra20-apb-dma.c | 10 ++++------
 5 files changed, 20 insertions(+), 18 deletions(-)

diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
index 3e8ba02..b33d1f6 100644
--- a/drivers/dma/dw_dmac.c
+++ b/drivers/dma/dw_dmac.c
@@ -14,6 +14,7 @@
 #include <linux/delay.h>
 #include <linux/dmaengine.h>
 #include <linux/dma-mapping.h>
+#include <linux/err.h>
 #include <linux/init.h>
 #include <linux/interrupt.h>
 #include <linux/io.h>
@@ -1489,9 +1490,9 @@ static int dw_probe(struct platform_device *pdev)
 	if (irq < 0)
 		return irq;
 
-	regs = devm_request_and_ioremap(&pdev->dev, io);
-	if (!regs)
-		return -EBUSY;
+	regs = devm_ioremap_resource(&pdev->dev, io);
+	if (IS_ERR(regs))
+		return PTR_ERR(regs);
 
 	dw_params = dma_read_byaddr(regs, DW_PARAMS);
 	autocfg = dw_params >> DW_PARAMS_EN & 0x1;
diff --git a/drivers/dma/imx-dma.c b/drivers/dma/imx-dma.c
index dbf0e6f..84ae491 100644
--- a/drivers/dma/imx-dma.c
+++ b/drivers/dma/imx-dma.c
@@ -14,6 +14,7 @@
  * http://www.opensource.org/licenses/gpl-license.html
  * http://www.gnu.org/copyleft/gpl.html
  */
+#include <linux/err.h>
 #include <linux/init.h>
 #include <linux/types.h>
 #include <linux/mm.h>
@@ -1011,9 +1012,9 @@ static int __init imxdma_probe(struct platform_device *pdev)
 	imxdma->devtype = pdev->id_entry->driver_data;
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	imxdma->base = devm_request_and_ioremap(&pdev->dev, res);
-	if (!imxdma->base)
-		return -EADDRNOTAVAIL;
+	imxdma->base = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(imxdma->base))
+		return PTR_ERR(imxdma->base);
 
 	irq = platform_get_irq(pdev, 0);
 	if (irq < 0)
diff --git a/drivers/dma/mmp_pdma.c b/drivers/dma/mmp_pdma.c
index c6d98c0..dc74665 100644
--- a/drivers/dma/mmp_pdma.c
+++ b/drivers/dma/mmp_pdma.c
@@ -5,6 +5,7 @@
  * it under the terms of the GNU General Public License version 2 as
  * published by the Free Software Foundation.
  */
+#include <linux/err.h>
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/types.h>
@@ -782,9 +783,9 @@ static int mmp_pdma_probe(struct platform_device *op)
 	if (!iores)
 		return -EINVAL;
 
-	pdev->base = devm_request_and_ioremap(pdev->dev, iores);
-	if (!pdev->base)
-		return -EADDRNOTAVAIL;
+	pdev->base = devm_ioremap_resource(pdev->dev, iores);
+	if (IS_ERR(pdev->base))
+		return PTR_ERR(pdev->base);
 
 	of_id = of_match_device(mmp_pdma_dt_ids, pdev->dev);
 	if (of_id)
diff --git a/drivers/dma/mmp_tdma.c b/drivers/dma/mmp_tdma.c
index a9f1cd5..43d5a6c 100644
--- a/drivers/dma/mmp_tdma.c
+++ b/drivers/dma/mmp_tdma.c
@@ -9,6 +9,7 @@
  *
  */
 
+#include <linux/err.h>
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/types.h>
@@ -547,9 +548,9 @@ static int mmp_tdma_probe(struct platform_device *pdev)
 	if (!iores)
 		return -EINVAL;
 
-	tdev->base = devm_request_and_ioremap(&pdev->dev, iores);
-	if (!tdev->base)
-		return -EADDRNOTAVAIL;
+	tdev->base = devm_ioremap_resource(&pdev->dev, iores);
+	if (IS_ERR(tdev->base))
+		return PTR_ERR(tdev->base);
 
 	INIT_LIST_HEAD(&tdev->device.channels);
 
diff --git a/drivers/dma/tegra20-apb-dma.c b/drivers/dma/tegra20-apb-dma.c
index c39e61b..7d6d8b4 100644
--- a/drivers/dma/tegra20-apb-dma.c
+++ b/drivers/dma/tegra20-apb-dma.c
@@ -21,6 +21,7 @@
 #include <linux/delay.h>
 #include <linux/dmaengine.h>
 #include <linux/dma-mapping.h>
+#include <linux/err.h>
 #include <linux/init.h>
 #include <linux/interrupt.h>
 #include <linux/io.h>
@@ -1236,12 +1237,9 @@ static int tegra_dma_probe(struct platform_device *pdev)
 		return -EINVAL;
 	}
 
-	tdma->base_addr = devm_request_and_ioremap(&pdev->dev, res);
-	if (!tdma->base_addr) {
-		dev_err(&pdev->dev,
-			"Cannot request memregion/iomap dma address\n");
-		return -EADDRNOTAVAIL;
-	}
+	tdma->base_addr = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(tdma->base_addr))
+		return PTR_ERR(tdma->base_addr);
 
 	tdma->dma_clk = devm_clk_get(&pdev->dev, NULL);
 	if (IS_ERR(tdma->dma_clk)) {
-- 
1.8.1.1

