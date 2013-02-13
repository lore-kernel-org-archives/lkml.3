Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934306Ab3BMPsK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 10:48:10 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:37575 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934211Ab3BMPq4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 10:46:56 -0500
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Shawn Guo <shawn.guo@linaro.org>,
        Richard Zhao <richard.zhao@freescale.com>,
        Huang Shijie <shijie8@gmail.com>,
        Dong Aisheng <dong.aisheng@linaro.org>, Matt Porter <mporter@ti.com>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Javier Martin <javier.martin@vista-silicon.com>, kernel@pengutronix.de,
        devicetree-discuss@lists.ozlabs.org,
        Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH v9 3/4] media: coda: use genalloc API
Date: Wed, 13 Feb 2013 16:46:41 +0100
Message-Id: <1360770402-23091-4-git-send-email-p.zabel@pengutronix.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1360770402-23091-1-git-send-email-p.zabel@pengutronix.de>
References: <1360770402-23091-1-git-send-email-p.zabel@pengutronix.de>
X-SA-Exim-Connect-IP: 10.1.0.7
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch depends on "genalloc: add devres support, allow to find
a managed pool by device", which provides the of_get_named_gen_pool
and dev_get_gen_pool functions.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
Acked-By: Javier Martin <javier.martin@vista-silicon.com>
Acked-by: Grant Likely <grant.likely@secretlab.ca>
---
 Documentation/devicetree/bindings/media/coda.txt |   30 +++++++++++++++
 drivers/media/platform/Kconfig                   |    1 -
 drivers/media/platform/coda.c                    |   45 +++++++++++++++-------
 include/linux/platform_data/coda.h               |   18 +++++++++
 4 files changed, 79 insertions(+), 15 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/media/coda.txt
 create mode 100644 include/linux/platform_data/coda.h

diff --git a/Documentation/devicetree/bindings/media/coda.txt b/Documentation/devicetree/bindings/media/coda.txt
new file mode 100644
index 0000000..2865d04
--- /dev/null
+++ b/Documentation/devicetree/bindings/media/coda.txt
@@ -0,0 +1,30 @@
+Chips&Media Coda multi-standard codec IP
+========================================
+
+Coda codec IPs are present in i.MX SoCs in various versions,
+called VPU (Video Processing Unit).
+
+Required properties:
+- compatible : should be "fsl,<chip>-src" for i.MX SoCs:
+  (a) "fsl,imx27-vpu" for CodaDx6 present in i.MX27
+  (b) "fsl,imx53-vpu" for CODA7541 present in i.MX53
+  (c) "fsl,imx6q-vpu" for CODA960 present in i.MX6q
+- reg: should be register base and length as documented in the
+  SoC reference manual
+- interrupts : Should contain the VPU interrupt. For CODA960,
+  a second interrupt is needed for the MJPEG unit.
+- clocks : Should contain the ahb and per clocks, in the order
+  determined by the clock-names property.
+- clock-names : Should be "ahb", "per"
+- iram : phandle pointing to the SRAM device node
+
+Example:
+
+vpu: vpu@63ff4000 {
+	compatible = "fsl,imx53-vpu";
+	reg = <0x63ff4000 0x1000>;
+	interrupts = <9>;
+	clocks = <&clks 63>, <&clks 63>;
+	clock-names = "ahb", "per";
+	iram = <&ocram>;
+};
diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
index 05d7b63..bbf83c1 100644
--- a/drivers/media/platform/Kconfig
+++ b/drivers/media/platform/Kconfig
@@ -145,7 +145,6 @@ config VIDEO_CODA
 	depends on VIDEO_DEV && VIDEO_V4L2 && ARCH_MXC
 	select VIDEOBUF2_DMA_CONTIG
 	select V4L2_MEM2MEM_DEV
-	select IRAM_ALLOC if SOC_IMX53
 	---help---
 	   Coda is a range of video codec IPs that supports
 	   H.264, MPEG-4, and other video formats.
diff --git a/drivers/media/platform/coda.c b/drivers/media/platform/coda.c
index 20827ba..b931c2a 100644
--- a/drivers/media/platform/coda.c
+++ b/drivers/media/platform/coda.c
@@ -14,6 +14,7 @@
 #include <linux/clk.h>
 #include <linux/delay.h>
 #include <linux/firmware.h>
+#include <linux/genalloc.h>
 #include <linux/interrupt.h>
 #include <linux/io.h>
 #include <linux/irq.h>
@@ -23,7 +24,7 @@
 #include <linux/slab.h>
 #include <linux/videodev2.h>
 #include <linux/of.h>
-#include <linux/platform_data/imx-iram.h>
+#include <linux/platform_data/coda.h>
 
 #include <media/v4l2-ctrls.h>
 #include <media/v4l2-device.h>
@@ -43,6 +44,7 @@
 #define CODA7_WORK_BUF_SIZE	(512 * 1024 + CODA_FMO_BUF_SIZE * 8 * 1024)
 #define CODA_PARA_BUF_SIZE	(10 * 1024)
 #define CODA_ISRAM_SIZE	(2048 * 2)
+#define CODADX6_IRAM_SIZE	0xb000
 #define CODA7_IRAM_SIZE		0x14000 /* 81920 bytes */
 
 #define CODA_MAX_FRAMEBUFFERS	2
@@ -128,7 +130,10 @@ struct coda_dev {
 
 	struct coda_aux_buf	codebuf;
 	struct coda_aux_buf	workbuf;
+	struct gen_pool		*iram_pool;
+	long unsigned int	iram_vaddr;
 	long unsigned int	iram_paddr;
+	unsigned long		iram_size;
 
 	spinlock_t		irqlock;
 	struct mutex		dev_mutex;
@@ -1926,6 +1931,9 @@ static int coda_probe(struct platform_device *pdev)
 	const struct of_device_id *of_id =
 			of_match_device(of_match_ptr(coda_dt_ids), &pdev->dev);
 	const struct platform_device_id *pdev_id;
+	struct coda_platform_data *pdata = pdev->dev.platform_data;
+	struct device_node *np = pdev->dev.of_node;
+	struct gen_pool *pool;
 	struct coda_dev *dev;
 	struct resource *res;
 	int ret, irq;
@@ -1988,6 +1996,16 @@ static int coda_probe(struct platform_device *pdev)
 		return -ENOENT;
 	}
 
+	/* Get IRAM pool from device tree or platform data */
+	pool = of_get_named_gen_pool(np, "iram", 0);
+	if (!pool && pdata)
+		pool = dev_get_gen_pool(pdata->iram_dev);
+	if (!pool) {
+		dev_err(&pdev->dev, "iram pool not available\n");
+		return -ENOMEM;
+	}
+	dev->iram_pool = pool;
+
 	ret = v4l2_device_register(&pdev->dev, &dev->v4l2_dev);
 	if (ret)
 		return ret;
@@ -2022,18 +2040,17 @@ static int coda_probe(struct platform_device *pdev)
 		return -ENOMEM;
 	}
 
-	if (dev->devtype->product == CODA_DX6) {
-		dev->iram_paddr = 0xffff4c00;
-	} else {
-		void __iomem *iram_vaddr;
-
-		iram_vaddr = iram_alloc(CODA7_IRAM_SIZE,
-					&dev->iram_paddr);
-		if (!iram_vaddr) {
-			dev_err(&pdev->dev, "unable to alloc iram\n");
-			return -ENOMEM;
-		}
+	if (dev->devtype->product == CODA_DX6)
+		dev->iram_size = CODADX6_IRAM_SIZE;
+	else
+		dev->iram_size = CODA7_IRAM_SIZE;
+	dev->iram_vaddr = gen_pool_alloc(dev->iram_pool, dev->iram_size);
+	if (!dev->iram_vaddr) {
+		dev_err(&pdev->dev, "unable to alloc iram\n");
+		return -ENOMEM;
 	}
+	dev->iram_paddr = gen_pool_virt_to_phys(dev->iram_pool,
+						dev->iram_vaddr);
 
 	platform_set_drvdata(pdev, dev);
 
@@ -2050,8 +2067,8 @@ static int coda_remove(struct platform_device *pdev)
 	if (dev->alloc_ctx)
 		vb2_dma_contig_cleanup_ctx(dev->alloc_ctx);
 	v4l2_device_unregister(&dev->v4l2_dev);
-	if (dev->iram_paddr)
-		iram_free(dev->iram_paddr, CODA7_IRAM_SIZE);
+	if (dev->iram_vaddr)
+		gen_pool_free(dev->iram_pool, dev->iram_vaddr, dev->iram_size);
 	if (dev->codebuf.vaddr)
 		dma_free_coherent(&pdev->dev, dev->codebuf.size,
 				  &dev->codebuf.vaddr, dev->codebuf.paddr);
diff --git a/include/linux/platform_data/coda.h b/include/linux/platform_data/coda.h
new file mode 100644
index 0000000..6ad4410
--- /dev/null
+++ b/include/linux/platform_data/coda.h
@@ -0,0 +1,18 @@
+/*
+ * Copyright (C) 2013 Philipp Zabel, Pengutronix
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+#ifndef PLATFORM_CODA_H
+#define PLATFORM_CODA_H
+
+struct device;
+
+struct coda_platform_data {
+	struct device *iram_dev;
+};
+
+#endif
-- 
1.7.10.4

