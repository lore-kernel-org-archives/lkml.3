Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756280Ab3GWKuR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 06:50:17 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:60847 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752128Ab3GWKuO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 06:50:14 -0400
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-kernel@vger.kernel.org
Cc: Magnus Damm <magnus.damm@gmail.com>, Simon Horman <horms@verge.net.au>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Vinod Koul <vinod.koul@intel.com>, linux-sh@vger.kernel.org,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Guennadi Liakhovetski <g.liakhovetski+renesas@gmail.com>
Subject: [PATCH v4 01/15] DMA: shdma: add support for DMAC configuration data, supplied via device ID
Date: Tue, 23 Jul 2013 12:49:55 +0200
Message-Id: <1374576609-27748-2-git-send-email-g.liakhovetski@gmx.de>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1374576609-27748-1-git-send-email-g.liakhovetski@gmx.de>
References: <1374576609-27748-1-git-send-email-g.liakhovetski@gmx.de>
X-Provags-ID: V02:K0:vyXCcya+9KsM+PtUiZ50eq5uBR7edtJsC6vypDZuTkM
 Cw0R7JS/03APG+tFS5+3MnSmA0VtgRX+2EK8/TjyCQ/4KYBeFP
 IRryzoQv1JIkwKHo440NdQxOTtqcpwud7oKLP5riPqgyJ67+OG
 W4O6DxmgSGi1tMbZTERXeuy08qgD//by9sw+5qgdbYr43M7BCB
 ILh1o1Ann7cu59+O1USzXtyfSp6yu72zttkpNW05t7jXpcl+gT
 vURm8lRN7NdDQ7spPQyRKqYZbBk2vbi+onEtlxIdFrKN0hoDe6
 T8u24QdGE1wKb82KIS0zx28kjacjiF/BEWHHGxk121nmgAVA42
 ixxrTUwoKWb6F/g5E+rpSW8+yYpvE0pkxuTrj13rwNdmzadEz3
 V2n8HijAv6SMg==
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
index 5153af1..751a4e3 100644
--- a/drivers/dma/sh/shdma.c
+++ b/drivers/dma/sh/shdmac.c
@@ -665,7 +665,7 @@ static const struct shdma_ops sh_dmae_shdma_ops = {
 
 static int sh_dmae_probe(struct platform_device *pdev)
 {
-	struct sh_dmae_pdata *pdata = pdev->dev.platform_data;
+	struct sh_dmae_pdata *pdata;
 	unsigned long irqflags = IRQF_DISABLED,
 		chan_flag[SH_DMAE_MAX_CHANNELS] = {};
 	int errirq, chan_irq[SH_DMAE_MAX_CHANNELS];
@@ -674,6 +674,8 @@ static int sh_dmae_probe(struct platform_device *pdev)
 	struct dma_device *dma_dev;
 	struct resource *chan, *dmars, *errirq_res, *chanirq_res;
 
+	pdata = (void *)pdev->id_entry->driver_data ? : pdev->dev.platform_data;
+
 	/* get platform data */
 	if (!pdata || !pdata->channel_num)
 		return -ENODEV;
@@ -903,6 +905,12 @@ static const struct of_device_id sh_dmae_of_match[] = {
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
@@ -912,6 +920,7 @@ static struct platform_driver sh_dmae_driver = {
 	},
 	.remove		= sh_dmae_remove,
 	.shutdown	= sh_dmae_shutdown,
+	.id_table	= sh_dmae_id_table,
 };
 
 static int __init sh_dmae_init(void)
-- 
1.7.2.5

