Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751487Ab3HSLWj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 07:22:39 -0400
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:50170
	"EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751345Ab3HSLVD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 07:21:03 -0400
X-IronPort-AV: E=Sophos;i="4.89,913,1367964000"; 
   d="scan'208";a="24233030"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Vinod Koul <vinod.koul@intel.com>
Cc: kernel-janitors@vger.kernel.org, Dan Williams <djbw@fb.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 4/7] dma: replace devm_request_and_ioremap by devm_ioremap_resource
Date: Mon, 19 Aug 2013 13:20:38 +0200
Message-Id: <1376911241-27720-5-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1376911241-27720-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1376911241-27720-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Use devm_ioremap_resource instead of devm_request_and_ioremap.

This was done using the semantic patch
scripts/coccinelle/api/devm_ioremap_resource.cocci

The relevant call to platform_get_resource was manually moved down to the
call to devm_ioremap_resource.

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 drivers/dma/sh/sudmac.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/dma/sh/sudmac.c b/drivers/dma/sh/sudmac.c
index c494417..8369c6f 100644
--- a/drivers/dma/sh/sudmac.c
+++ b/drivers/dma/sh/sudmac.c
@@ -345,9 +345,8 @@ static int sudmac_probe(struct platform_device *pdev)
 	if (!pdata)
 		return -ENODEV;
 
-	chan = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	irq_res = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
-	if (!chan || !irq_res)
+	if (!irq_res)
 		return -ENODEV;
 
 	err = -ENOMEM;
@@ -360,9 +359,10 @@ static int sudmac_probe(struct platform_device *pdev)
 
 	dma_dev = &su_dev->shdma_dev.dma_dev;
 
-	su_dev->chan_reg = devm_request_and_ioremap(&pdev->dev, chan);
-	if (!su_dev->chan_reg)
-		return err;
+	chan = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	su_dev->chan_reg = devm_ioremap_resource(&pdev->dev, chan);
+	if (IS_ERR(su_dev->chan_reg))
+		return PTR_ERR(su_dev->chan_reg);
 
 	dma_cap_set(DMA_SLAVE, dma_dev->cap_mask);
 

