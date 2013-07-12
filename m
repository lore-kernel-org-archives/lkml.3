Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964951Ab3GLNoJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 09:44:09 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:49256 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964842Ab3GLNoD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 09:44:03 -0400
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-kernel@vger.kernel.org
Cc: linux-sh@vger.kernel.org, Magnus Damm <magnus.damm@gmail.com>,
        Simon Horman <horms@verge.net.au>, Vinod Koul <vinod.koul@intel.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Guennadi Liakhovetski <g.liakhovetski+renesas@gmail.com>
Subject: [PATCH 1/8] DMA: shdma: add support for DMAC configuration data, supplied via device ID
Date: Fri, 12 Jul 2013 15:43:51 +0200
Message-Id: <1373636638-18496-2-git-send-email-g.liakhovetski@gmx.de>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1373636638-18496-1-git-send-email-g.liakhovetski@gmx.de>
References: <1373636638-18496-1-git-send-email-g.liakhovetski@gmx.de>
X-Provags-ID: V02:K0:PpN5IpVoGEb0jRD7nEg6roHR3uP93tIt1NuFNY/6OWm
 FJpPgPdjkhq+ongJ5jiaWWQcuyxl34JqOLzKgeRUQkVsCGAlt5
 2ctsZrK1Lzd9o/4j10ttf/ti3sXexwLZuf9MFmRZDmDZ2fWUil
 d1v1wsnjQAZfb/SUQl3mBnYGRtRfz/VkzBNSvcexP+TjovzeRk
 sFaqtszgEGLXqghwp9qYgcGMAV3QB4EMJXMd6j90WP31GlCBjO
 YQCb80KJMeFAopPq3uiNwwZ8OXykeBMuHyK6hw8rpbqqzH6IDi
 zoqefUU++ZkdgNlIEP17QcYsVup/wfLvZeUxLOjPmZHSv03aIm
 9cZiiYYNwFmE0Z6BnFWhtONJOdBFYUBHGzH4ckzS8Z0fPb1quZ
 OO6ua9YlV2dDQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is going to facilitate DT support by eliminating the need in AUXDATA
and avoiding creating complex DT data. This also fits well with DMAC
devices, because SoCs with them often have multiple identical DMAC
instances and it is perfectly valid to use a single configuration data set
for all of them.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski+renesas@gmail.com>
---

A file has to be renamed to preserve the driver module name.

 drivers/dma/sh/Makefile              |    2 ++
 drivers/dma/sh/{shdma.c => shdmac.c} |   11 ++++++++++-
 2 files changed, 12 insertions(+), 1 deletions(-)
 rename drivers/dma/sh/{shdma.c => shdmac.c} (98%)

diff --git a/drivers/dma/sh/Makefile b/drivers/dma/sh/Makefile
index c962138..893ee09 100644
--- a/drivers/dma/sh/Makefile
+++ b/drivers/dma/sh/Makefile
@@ -1,3 +1,5 @@
 obj-$(CONFIG_SH_DMAE_BASE) += shdma-base.o shdma-of.o
 obj-$(CONFIG_SH_DMAE) += shdma.o
+shdma-y := shdmac.o
+shdma-objs := $(shdma-y)
 obj-$(CONFIG_SUDMAC) += sudmac.o
diff --git a/drivers/dma/sh/shdma.c b/drivers/dma/sh/shdmac.c
similarity index 98%
rename from drivers/dma/sh/shdma.c
rename to drivers/dma/sh/shdmac.c
index 0e9b719..3c5634e 100644
--- a/drivers/dma/sh/shdma.c
+++ b/drivers/dma/sh/shdmac.c
@@ -667,7 +667,7 @@ static const struct shdma_ops sh_dmae_shdma_ops = {
 
 static int sh_dmae_probe(struct platform_device *pdev)
 {
-	struct sh_dmae_pdata *pdata = pdev->dev.platform_data;
+	struct sh_dmae_pdata *pdata;
 	unsigned long irqflags = IRQF_DISABLED,
 		chan_flag[SH_DMAE_MAX_CHANNELS] = {};
 	int errirq, chan_irq[SH_DMAE_MAX_CHANNELS];
@@ -676,6 +676,8 @@ static int sh_dmae_probe(struct platform_device *pdev)
 	struct dma_device *dma_dev;
 	struct resource *chan, *dmars, *errirq_res, *chanirq_res;
 
+	pdata = (void *)pdev->id_entry->driver_data ? : pdev->dev.platform_data;
+
 	/* get platform data */
 	if (!pdata || !pdata->channel_num)
 		return -ENODEV;
@@ -919,6 +921,12 @@ static const struct of_device_id sh_dmae_of_match[] = {
 };
 MODULE_DEVICE_TABLE(of, sh_dmae_of_match);
 
+const struct platform_device_id sh_dmae_id_table[] = {
+	{.name = SH_DMAE_DRV_NAME,},
+	{}
+};
+MODULE_DEVICE_TABLE(platform, sh_dmae_id_table);
+
 static struct platform_driver sh_dmae_driver = {
 	.driver 	= {
 		.owner	= THIS_MODULE,
@@ -928,6 +936,7 @@ static struct platform_driver sh_dmae_driver = {
 	},
 	.remove		= sh_dmae_remove,
 	.shutdown	= sh_dmae_shutdown,
+	.id_table	= sh_dmae_id_table,
 };
 
 static int __init sh_dmae_init(void)
-- 
1.7.2.5

