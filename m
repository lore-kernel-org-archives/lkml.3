Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757187Ab3GWKvB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 06:51:01 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:59641 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756655Ab3GWKuV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 06:50:21 -0400
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-kernel@vger.kernel.org
Cc: Magnus Damm <magnus.damm@gmail.com>, Simon Horman <horms@verge.net.au>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Vinod Koul <vinod.koul@intel.com>, linux-sh@vger.kernel.org,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Guennadi Liakhovetski <g.liakhovetski+renesas@gmail.com>
Subject: [PATCH v4 05/15] DMA: shdma: pass SoC-specific configuration to the driver via OF matching
Date: Tue, 23 Jul 2013 12:49:59 +0200
Message-Id: <1374576609-27748-6-git-send-email-g.liakhovetski@gmx.de>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1374576609-27748-1-git-send-email-g.liakhovetski@gmx.de>
References: <1374576609-27748-1-git-send-email-g.liakhovetski@gmx.de>
X-Provags-ID: V02:K0:F2ztjV0KOdgYxDnoDguUtRowE6pbbkuiHuTG6IlktEl
 54QXOpvh15M7JjnyUamLYA1Ky4dLlePedvX2vlmUTEx8+xzBYm
 jBnCvjwkKPWl4vmr5VprC1spJahLIq+7V0m08tuzpcdgoOctBa
 RRohmDTTYV4pYlegH2zJCGEz/EX52NtSA4EKCbYMWOtaJDkjTJ
 2d8+51dxM9f2KR7z4vFaoK5uVW5D0b5gs4O8S7zd/w0boM47tA
 9szqe+StYl6hvGWcZWUHmCK/mIzMUH4CgFNf/xLDZY+RHQaMR0
 2PFi6XxZOKDaWb27fDtv2YV03G7YoF7Nj6cbdp9ZB6vmaWyyqk
 61G0U6C58yCt6K3EziPNKfrw7Tv7xlAy+tdXhYfics5uVNnSBw
 wHx5Svhy8G2gg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Similar to the non-DT case, this patch passes SoC-specific configuration
to the driver via device ID matching, instead of platform data. Since the
controller configuration shall now always be passed via a device ID
table, we can remove the generic "renesas,shdma" entry, we always need a
specific SoC match.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski+renesas@gmail.com>
---

v4: remove generic "renesas,shdma" compatibility option

 Documentation/devicetree/bindings/dma/shdma.txt |    6 ++++--
 drivers/dma/sh/shdmac.c                         |   21 ++++++++++++++-------
 2 files changed, 18 insertions(+), 9 deletions(-)

diff --git a/Documentation/devicetree/bindings/dma/shdma.txt b/Documentation/devicetree/bindings/dma/shdma.txt
index c15994a..be0f82b 100644
--- a/Documentation/devicetree/bindings/dma/shdma.txt
+++ b/Documentation/devicetree/bindings/dma/shdma.txt
@@ -22,7 +22,9 @@ Optional properties (currently unused):
 * DMA controller
 
 Required properties:
-- compatible:	should be "renesas,shdma"
+- compatible:	should be one of
+		"renesas,shdma-r8a73a4" for the system DMAC on r8a73a4 SoC
+		"renesas,shdma-r8a7740" for the DMACs (not RTDMAC) on r8a7740
 
 Example:
 	dmac: dma-mux0 {
@@ -36,7 +38,7 @@ Example:
 		ranges;
 
 		dma0: shdma@fe008020 {
-			compatible = "renesas,shdma";
+			compatible = "renesas,shdma-r8a7740";
 			reg = <0xfe008020 0x270>,
 				<0xfe009000 0xc>;
 			interrupt-parent = <&gic>;
diff --git a/drivers/dma/sh/shdmac.c b/drivers/dma/sh/shdmac.c
index 859ddbe..aa90ea2 100644
--- a/drivers/dma/sh/shdmac.c
+++ b/drivers/dma/sh/shdmac.c
@@ -20,6 +20,8 @@
 
 #include <linux/init.h>
 #include <linux/module.h>
+#include <linux/of.h>
+#include <linux/of_device.h>
 #include <linux/slab.h>
 #include <linux/interrupt.h>
 #include <linux/dmaengine.h>
@@ -663,6 +665,13 @@ static const struct shdma_ops sh_dmae_shdma_ops = {
 	.get_partial = sh_dmae_get_partial,
 };
 
+static const struct of_device_id sh_dmae_of_match[] = {
+	{.compatible = "renesas,shdma-r8a73a4", .data = r8a73a4_shdma_devid,},
+	{.compatible = "renesas,shdma-r8a7740", .data = r8a7740_shdma_devid,},
+	{}
+};
+MODULE_DEVICE_TABLE(of, sh_dmae_of_match);
+
 static int sh_dmae_probe(struct platform_device *pdev)
 {
 	const struct sh_dmae_pdata *pdata;
@@ -674,7 +683,11 @@ static int sh_dmae_probe(struct platform_device *pdev)
 	struct dma_device *dma_dev;
 	struct resource *chan, *dmars, *errirq_res, *chanirq_res;
 
-	pdata = (void *)pdev->id_entry->driver_data ? : pdev->dev.platform_data;
+	if (pdev->dev.of_node)
+		pdata = of_match_device(sh_dmae_of_match, &pdev->dev)->data;
+	else
+		pdata = (void *)pdev->id_entry->driver_data ? :
+			pdev->dev.platform_data;
 
 	/* get platform data */
 	if (!pdata || !pdata->channel_num)
@@ -899,12 +912,6 @@ static int sh_dmae_remove(struct platform_device *pdev)
 	return 0;
 }
 
-static const struct of_device_id sh_dmae_of_match[] = {
-	{ .compatible = "renesas,shdma", },
-	{ }
-};
-MODULE_DEVICE_TABLE(of, sh_dmae_of_match);
-
 const struct platform_device_id sh_dmae_id_table[] = {
 	{.name = SH_DMAE_DRV_NAME,},
 	{.name = "shdma-r8a73a4", .driver_data = (kernel_ulong_t)r8a73a4_shdma_devid,},
-- 
1.7.2.5

