Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751472Ab3HSLVL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 07:21:11 -0400
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:50168
	"EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751371Ab3HSLVD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 07:21:03 -0400
X-IronPort-AV: E=Sophos;i="4.89,913,1367964000"; 
   d="scan'208";a="24233031"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: netdev@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 5/7] bcm63xx_enet: replace devm_request_and_ioremap by devm_ioremap_resource
Date: Mon, 19 Aug 2013 13:20:39 +0200
Message-Id: <1376911241-27720-6-git-send-email-Julia.Lawall@lip6.fr>
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
 drivers/net/ethernet/broadcom/bcm63xx_enet.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bcm63xx_enet.c b/drivers/net/ethernet/broadcom/bcm63xx_enet.c
index b1bcd4b..89ff09e 100644
--- a/drivers/net/ethernet/broadcom/bcm63xx_enet.c
+++ b/drivers/net/ethernet/broadcom/bcm63xx_enet.c
@@ -1747,11 +1747,10 @@ static int bcm_enet_probe(struct platform_device *pdev)
 	if (!bcm_enet_shared_base[0])
 		return -ENODEV;
 
-	res_mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	res_irq = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
 	res_irq_rx = platform_get_resource(pdev, IORESOURCE_IRQ, 1);
 	res_irq_tx = platform_get_resource(pdev, IORESOURCE_IRQ, 2);
-	if (!res_mem || !res_irq || !res_irq_rx || !res_irq_tx)
+	if (!res_irq || !res_irq_rx || !res_irq_tx)
 		return -ENODEV;
 
 	ret = 0;
@@ -1767,9 +1766,10 @@ static int bcm_enet_probe(struct platform_device *pdev)
 	if (ret)
 		goto out;
 
-	priv->base = devm_request_and_ioremap(&pdev->dev, res_mem);
-	if (priv->base == NULL) {
-		ret = -ENOMEM;
+	res_mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	priv->base = devm_ioremap_resource(&pdev->dev, res_mem);
+	if (IS_ERR(priv->base)) {
+		ret = PTR_ERR(priv->base);
 		goto out;
 	}
 

