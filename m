Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933660Ab3GSQ3p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 12:29:45 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:54588 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760584Ab3GSQ3j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 12:29:39 -0400
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-kernel@vger.kernel.org
Cc: linux-sh@vger.kernel.org, Magnus Damm <magnus.damm@gmail.com>,
        Simon Horman <horms@verge.net.au>, Vinod Koul <vinod.koul@intel.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Guennadi Liakhovetski <g.liakhovetski+renesas@gmail.com>
Subject: [PATCH v2 05/15] DMA: shdma: pass SoC-specific configuration to the driver via OF matching
Date: Fri, 19 Jul 2013 18:29:30 +0200
Message-Id: <1374251374-30186-6-git-send-email-g.liakhovetski@gmx.de>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1374251374-30186-1-git-send-email-g.liakhovetski@gmx.de>
References: <1374251374-30186-1-git-send-email-g.liakhovetski@gmx.de>
X-Provags-ID: V02:K0:bG4rzXhRMLhl7SQjyTXOjhj9bOe+y3CdfqrpQ1YR/hp
 C0x5oIoVNVuufN2T5kzfbbmPToOS5nY4VmgyMlfO7p6gLC4h59
 7ANYgDGtFyxzyrLZs9et7Gq5kBvPZKC9b/Qun181ZPj3gWFqlc
 vuZqDT+JSLBA4G3h0Xg6tceLiVJrwxTkwXA1MlNaOlTW8xx0ze
 M/sKMQ0f0WJt2saLyfIoQPepDbjAjy5R79F8erNlAUT1hStPHv
 +DvWWcBoFf+4RoWIUlz+Bf1QKzgvT3G57LjCwUKjX9r79EYTDL
 eh7TuzZ/ZR4X2CPO6OTqhq2q8ck81DdMlycwFRjk7oBEl2ksuY
 TWSrSOemw5bkcPg039Si5WlHVWos0EAICcLyTanOlRkObCAZ4i
 H9zRodANZfczA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Similar to the non-DT case, this patch passes SoC-specific configuration
to the driver via device ID matching, instead of platform data.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski+renesas@gmail.com>
---

v2: adjust spacing within array definitions to keep a uniform style.

 Documentation/devicetree/bindings/dma/shdma.txt |    7 +++++--
 drivers/dma/sh/shdmac.c                         |   22 +++++++++++++++-------
 2 files changed, 20 insertions(+), 9 deletions(-)

diff --git a/Documentation/devicetree/bindings/dma/shdma.txt b/Documentation/devicetree/bindings/dma/shdma.txt
index c15994a..7702e35 100644
--- a/Documentation/devicetree/bindings/dma/shdma.txt
+++ b/Documentation/devicetree/bindings/dma/shdma.txt
@@ -22,7 +22,10 @@ Optional properties (currently unused):
 * DMA controller
 
 Required properties:
-- compatible:	should be "renesas,shdma"
+- compatible:	should be one of
+		"renesas,shdma-r8a73a4" for the system DMAC on r8a73a4 SoC
+		"renesas,shdma-r8a7740" for the DMACs (not RTDMAC) on r8a7740
+		"renesas,shdma" for a generic DMAC
 
 Example:
 	dmac: dma-mux0 {
@@ -36,7 +39,7 @@ Example:
 		ranges;
 
 		dma0: shdma@fe008020 {
-			compatible = "renesas,shdma";
+			compatible = "renesas,shdma-r8a7740";
 			reg = <0xfe008020 0x270>,
 				<0xfe009000 0xc>;
 			interrupt-parent = <&gic>;
diff --git a/drivers/dma/sh/shdmac.c b/drivers/dma/sh/shdmac.c
index 859ddbe..f80543c 100644
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
@@ -663,6 +665,14 @@ static const struct shdma_ops sh_dmae_shdma_ops = {
 	.get_partial = sh_dmae_get_partial,
 };
 
+static const struct of_device_id sh_dmae_of_match[] = {
+	{.compatible = "renesas,shdma",},
+	{.compatible = "renesas,shdma-r8a73a4", .data = r8a73a4_shdma_devid,},
+	{.compatible = "renesas,shdma-r8a7740", .data = r8a7740_shdma_devid,},
+	{}
+};
+MODULE_DEVICE_TABLE(of, sh_dmae_of_match);
+
 static int sh_dmae_probe(struct platform_device *pdev)
 {
 	const struct sh_dmae_pdata *pdata;
@@ -674,7 +684,11 @@ static int sh_dmae_probe(struct platform_device *pdev)
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
@@ -899,12 +913,6 @@ static int sh_dmae_remove(struct platform_device *pdev)
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

