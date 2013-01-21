Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753708Ab3AUKKs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 05:10:48 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:49967 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753053Ab3AUKKj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 05:10:39 -0500
From: Thierry Reding <thierry.reding@avionic-design.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, Wolfram Sang <w.sang@pengutronix.de>,
        David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org
Subject: [PATCH 19/33] mtd: Convert to devm_ioremap_resource()
Date: Mon, 21 Jan 2013 11:09:12 +0100
Message-Id: <1358762966-20791-20-git-send-email-thierry.reding@avionic-design.de>
X-Mailer: git-send-email 1.8.1.1
In-Reply-To: <1358762966-20791-1-git-send-email-thierry.reding@avionic-design.de>
References: <1358762966-20791-1-git-send-email-thierry.reding@avionic-design.de>
X-Provags-ID: V02:K0:ApU6LogR3I4rQ55N4IIaafUtiOHfdYf5miz9nh6dboh
 xqAfkjPcSNLYSBCJrgbjN1j5C33XUOlcHyk1ww/Nk18EVB2Ka4
 EbAw4M4UmrAXjiHeJVI1yBh1MIav5PFa+YZIgI92DgJUriUy39
 lJv/x3LSzpGwyvkaI9su2f8vvFzVsCoP7UhAZ2Tzz4PbOfwvfP
 lKv7E9FvYcbkazBZ2dJc4GMwOrzo1VgYOzYOHyKqrqvaJiKzJn
 tQjUDk5gKLbjcJlWJO4CKonz5Fe+AafrdlEq2DxJsDI1xkDWUB
 kBxCuXSSpYhB6bGWfJxaNRlWNZdNY1KvSvXVgH64zs59pw9jzj
 WxdOkNLwPkE85mSQuvzqJLW2QyhgN+euTqtehT2GmNm+iOzuap
 9xnqJvW00/iyonUoVKd5P8d9lmDi+u9NLBwvkSkTY6PXIk2pLN
 nKB70
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert all uses of devm_request_and_ioremap() to the newly introduced
devm_ioremap_resource() which provides more consistent error handling.

devm_ioremap_resource() provides its own error messages so all explicit
error messages can be removed from the failure code paths.

Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: linux-mtd@lists.infradead.org
---
 drivers/mtd/devices/spear_smi.c   |  7 +++----
 drivers/mtd/maps/autcpu12-nvram.c |  9 ++++-----
 drivers/mtd/maps/lantiq-flash.c   |  8 ++++----
 drivers/mtd/nand/fsmc_nand.c      | 33 +++++++++++++--------------------
 drivers/mtd/nand/lpc32xx_mlc.c    |  9 ++++-----
 drivers/mtd/nand/lpc32xx_slc.c    |  8 +++-----
 drivers/mtd/nand/mxc_nand.c       | 12 ++++++------
 drivers/mtd/nand/s3c2410.c        |  7 +++----
 drivers/mtd/nand/txx9ndfmc.c      |  7 ++++---
 9 files changed, 44 insertions(+), 56 deletions(-)

diff --git a/drivers/mtd/devices/spear_smi.c b/drivers/mtd/devices/spear_smi.c
index 2aabd96..8a82b8b 100644
--- a/drivers/mtd/devices/spear_smi.c
+++ b/drivers/mtd/devices/spear_smi.c
@@ -949,10 +949,9 @@ static int spear_smi_probe(struct platform_device *pdev)
 
 	smi_base = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 
-	dev->io_base = devm_request_and_ioremap(&pdev->dev, smi_base);
-	if (!dev->io_base) {
-		ret = -EIO;
-		dev_err(&pdev->dev, "devm_request_and_ioremap fail\n");
+	dev->io_base = devm_ioremap_resource(&pdev->dev, smi_base);
+	if (IS_ERR(dev->io_base)) {
+		ret = PTR_ERR(dev->io_base);
 		goto err;
 	}
 
diff --git a/drivers/mtd/maps/autcpu12-nvram.c b/drivers/mtd/maps/autcpu12-nvram.c
index a2dc2ae..c3525d2 100644
--- a/drivers/mtd/maps/autcpu12-nvram.c
+++ b/drivers/mtd/maps/autcpu12-nvram.c
@@ -16,6 +16,7 @@
  * along with this program; if not, write to the Free Software
  * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  */
+#include <linux/err.h>
 #include <linux/sizes.h>
 
 #include <linux/types.h>
@@ -55,12 +56,10 @@ static int autcpu12_nvram_probe(struct platform_device *pdev)
 	priv->map.bankwidth	= 4;
 	priv->map.phys		= res->start;
 	priv->map.size		= resource_size(res);
-	priv->map.virt		= devm_request_and_ioremap(&pdev->dev, res);
+	priv->map.virt = devm_ioremap_resource(&pdev->dev, res);
 	strcpy((char *)priv->map.name, res->name);
-	if (!priv->map.virt) {
-		dev_err(&pdev->dev, "failed to remap mem resource\n");
-		return -EBUSY;
-	}
+	if (IS_ERR(priv->map.virt))
+		return PTR_ERR(priv->map.virt);
 
 	simple_map_init(&priv->map);
 
diff --git a/drivers/mtd/maps/lantiq-flash.c b/drivers/mtd/maps/lantiq-flash.c
index 3c3c791..d1da6ed 100644
--- a/drivers/mtd/maps/lantiq-flash.c
+++ b/drivers/mtd/maps/lantiq-flash.c
@@ -7,6 +7,7 @@
  *  Copyright (C) 2010 John Crispin <blogic@openwrt.org>
  */
 
+#include <linux/err.h>
 #include <linux/module.h>
 #include <linux/types.h>
 #include <linux/kernel.h>
@@ -136,10 +137,9 @@ ltq_mtd_probe(struct platform_device *pdev)
 	ltq_mtd->map = kzalloc(sizeof(struct map_info), GFP_KERNEL);
 	ltq_mtd->map->phys = ltq_mtd->res->start;
 	ltq_mtd->map->size = resource_size(ltq_mtd->res);
-	ltq_mtd->map->virt = devm_request_and_ioremap(&pdev->dev, ltq_mtd->res);
-	if (!ltq_mtd->map->virt) {
-		dev_err(&pdev->dev, "failed to remap mem resource\n");
-		err = -EBUSY;
+	ltq_mtd->map->virt = devm_ioremap_resource(&pdev->dev, ltq_mtd->res);
+	if (IS_ERR(ltq_mtd->map->virt)) {
+		err = PTR_ERR(ltq_mtd->map->virt);
 		goto err_out;
 	}
 
diff --git a/drivers/mtd/nand/fsmc_nand.c b/drivers/mtd/nand/fsmc_nand.c
index 67e62d3..c543cc0 100644
--- a/drivers/mtd/nand/fsmc_nand.c
+++ b/drivers/mtd/nand/fsmc_nand.c
@@ -937,42 +937,35 @@ static int __init fsmc_nand_probe(struct platform_device *pdev)
 	if (!res)
 		return -EINVAL;
 
-	host->data_va = devm_request_and_ioremap(&pdev->dev, res);
-	if (!host->data_va) {
-		dev_err(&pdev->dev, "data ioremap failed\n");
-		return -ENOMEM;
-	}
+	host->data_va = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(host->data_va))
+		return PTR_ERR(host->data_va);
+	
 	host->data_pa = (dma_addr_t)res->start;
 
 	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "nand_addr");
 	if (!res)
 		return -EINVAL;
 
-	host->addr_va = devm_request_and_ioremap(&pdev->dev, res);
-	if (!host->addr_va) {
-		dev_err(&pdev->dev, "ale ioremap failed\n");
-		return -ENOMEM;
-	}
+	host->addr_va = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(host->addr_va))
+		return PTR_ERR(host->addr_va);
 
 	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "nand_cmd");
 	if (!res)
 		return -EINVAL;
 
-	host->cmd_va = devm_request_and_ioremap(&pdev->dev, res);
-	if (!host->cmd_va) {
-		dev_err(&pdev->dev, "ale ioremap failed\n");
-		return -ENOMEM;
-	}
+	host->cmd_va = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(host->cmd_va))
+		return PTR_ERR(host->cmd_va);
 
 	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "fsmc_regs");
 	if (!res)
 		return -EINVAL;
 
-	host->regs_va = devm_request_and_ioremap(&pdev->dev, res);
-	if (!host->regs_va) {
-		dev_err(&pdev->dev, "regs ioremap failed\n");
-		return -ENOMEM;
-	}
+	host->regs_va = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(host->regs_va))
+		return PTR_ERR(host->regs_va);
 
 	host->clk = clk_get(&pdev->dev, NULL);
 	if (IS_ERR(host->clk)) {
diff --git a/drivers/mtd/nand/lpc32xx_mlc.c b/drivers/mtd/nand/lpc32xx_mlc.c
index f182bef..0ca22ae 100644
--- a/drivers/mtd/nand/lpc32xx_mlc.c
+++ b/drivers/mtd/nand/lpc32xx_mlc.c
@@ -677,11 +677,10 @@ static int lpc32xx_nand_probe(struct platform_device *pdev)
 		return -ENXIO;
 	}
 
-	host->io_base = devm_request_and_ioremap(&pdev->dev, rc);
-	if (host->io_base == NULL) {
-		dev_err(&pdev->dev, "ioremap failed\n");
-		return -EIO;
-	}
+	host->io_base = devm_ioremap_resource(&pdev->dev, rc);
+	if (IS_ERR(host->io_base))
+		return PTR_ERR(host->io_base);
+	
 	host->io_base_phy = rc->start;
 
 	mtd = &host->mtd;
diff --git a/drivers/mtd/nand/lpc32xx_slc.c b/drivers/mtd/nand/lpc32xx_slc.c
index 030b78c..be94ed5 100644
--- a/drivers/mtd/nand/lpc32xx_slc.c
+++ b/drivers/mtd/nand/lpc32xx_slc.c
@@ -778,11 +778,9 @@ static int lpc32xx_nand_probe(struct platform_device *pdev)
 	}
 	host->io_base_dma = rc->start;
 
-	host->io_base = devm_request_and_ioremap(&pdev->dev, rc);
-	if (host->io_base == NULL) {
-		dev_err(&pdev->dev, "ioremap failed\n");
-		return -ENOMEM;
-	}
+	host->io_base = devm_ioremap_resource(&pdev->dev, rc);
+	if (IS_ERR(host->io_base))
+		return PTR_ERR(host->io_base);
 
 	if (pdev->dev.of_node)
 		host->ncfg = lpc32xx_parse_dt(&pdev->dev);
diff --git a/drivers/mtd/nand/mxc_nand.c b/drivers/mtd/nand/mxc_nand.c
index 45204e4..60ac5b9 100644
--- a/drivers/mtd/nand/mxc_nand.c
+++ b/drivers/mtd/nand/mxc_nand.c
@@ -1437,9 +1437,9 @@ static int mxcnd_probe(struct platform_device *pdev)
 		res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 		if (!res)
 			return -ENODEV;
-		host->regs_ip = devm_request_and_ioremap(&pdev->dev, res);
-		if (!host->regs_ip)
-			return -ENOMEM;
+		host->regs_ip = devm_ioremap_resource(&pdev->dev, res);
+		if (IS_ERR(host->regs_ip))
+			return PTR_ERR(host->regs_ip);
 
 		res = platform_get_resource(pdev, IORESOURCE_MEM, 1);
 	} else {
@@ -1449,9 +1449,9 @@ static int mxcnd_probe(struct platform_device *pdev)
 	if (!res)
 		return -ENODEV;
 
-	host->base = devm_request_and_ioremap(&pdev->dev, res);
-	if (!host->base)
-		return -ENOMEM;
+	host->base = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(host->base))
+		return PTR_ERR(host->base);
 
 	host->main_area0 = host->base;
 
diff --git a/drivers/mtd/nand/s3c2410.c b/drivers/mtd/nand/s3c2410.c
index df954b4..d65afd2 100644
--- a/drivers/mtd/nand/s3c2410.c
+++ b/drivers/mtd/nand/s3c2410.c
@@ -952,10 +952,9 @@ static int s3c24xx_nand_probe(struct platform_device *pdev)
 	info->platform	= plat;
 	info->cpu_type	= cpu_type;
 
-	info->regs	= devm_request_and_ioremap(&pdev->dev, res);
-	if (info->regs == NULL) {
-		dev_err(&pdev->dev, "cannot reserve register region\n");
-		err = -EIO;
+	info->regs = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(info->regs)) {
+		err = PTR_ERR(info->regs);
 		goto exit_error;
 	}
 
diff --git a/drivers/mtd/nand/txx9ndfmc.c b/drivers/mtd/nand/txx9ndfmc.c
index e3d7266..e1e8748 100644
--- a/drivers/mtd/nand/txx9ndfmc.c
+++ b/drivers/mtd/nand/txx9ndfmc.c
@@ -9,6 +9,7 @@
  * (C) Copyright TOSHIBA CORPORATION 2004-2007
  * All Rights Reserved.
  */
+#include <linux/err.h>
 #include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/module.h>
@@ -286,9 +287,9 @@ static int __init txx9ndfmc_probe(struct platform_device *dev)
 	drvdata = devm_kzalloc(&dev->dev, sizeof(*drvdata), GFP_KERNEL);
 	if (!drvdata)
 		return -ENOMEM;
-	drvdata->base = devm_request_and_ioremap(&dev->dev, res);
-	if (!drvdata->base)
-		return -EBUSY;
+	drvdata->base = devm_ioremap_resource(&dev->dev, res);
+	if (IS_ERR(drvdata->base))
+		return PTR_ERR(drvdata->base);
 
 	hold = plat->hold ?: 20; /* tDH */
 	spw = plat->spw ?: 90; /* max(tREADID, tWP, tRP) */
-- 
1.8.1.1

