Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755375Ab3HXRN3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Aug 2013 13:13:29 -0400
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:15091
	"EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754982Ab3HXRN0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Aug 2013 13:13:26 -0400
X-IronPort-AV: E=Sophos;i="4.89,947,1367964000"; 
   d="scan'208";a="24669912"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Mark Brown <broonie@kernel.org>
Cc: kernel-janitors@vger.kernel.org, linux-spi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] spi: simplify devm_request_mem_region/devm_ioremap
Date: Sat, 24 Aug 2013 19:13:15 +0200
Message-Id: <1377364396-27861-2-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1377364396-27861-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1377364396-27861-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Convert the composition of devm_request_mem_region and devm_ioremap to a
single call to devm_ioremap_resource.  The associated call to
platform_get_resource is also simplified and moved next to the new call to
devm_ioremap_resource.

This was done using a combination of the semantic patches
devm_ioremap_resource.cocci and devm_request_and_ioremap.cocci, found in
the scripts/coccinelle/api directory.

This patch also removes the label exit_busy, to use the error code returned
by the failing operation, rather than always -EBUSY.

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 drivers/spi/spi-altera.c  |   17 +++++------------
 drivers/spi/spi-oc-tiny.c |   22 +++++++++-------------
 2 files changed, 14 insertions(+), 25 deletions(-)

diff --git a/drivers/spi/spi-altera.c b/drivers/spi/spi-altera.c
index 8a6bb37..63d25e6 100644
--- a/drivers/spi/spi-altera.c
+++ b/drivers/spi/spi-altera.c
@@ -234,15 +234,11 @@ static int altera_spi_probe(struct platform_device *pdev)
 
 	/* find and map our resources */
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!res)
-		goto exit_busy;
-	if (!devm_request_mem_region(&pdev->dev, res->start, resource_size(res),
-				     pdev->name))
-		goto exit_busy;
-	hw->base = devm_ioremap_nocache(&pdev->dev, res->start,
-					resource_size(res));
-	if (!hw->base)
-		goto exit_busy;
+	hw->base = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(hw->base)) {
+		err = PTR_ERR(hw->base);
+		goto exit;
+	}
 	/* program defaults into the registers */
 	hw->imr = 0;		/* disable spi interrupts */
 	writel(hw->imr, hw->base + ALTERA_SPI_CONTROL);
@@ -269,9 +265,6 @@ static int altera_spi_probe(struct platform_device *pdev)
 	dev_info(&pdev->dev, "base %p, irq %d\n", hw->base, hw->irq);
 
 	return 0;
-
-exit_busy:
-	err = -EBUSY;
 exit:
 	spi_master_put(master);
 	return err;
diff --git a/drivers/spi/spi-oc-tiny.c b/drivers/spi/spi-oc-tiny.c
index 58deb79..d36ba90 100644
--- a/drivers/spi/spi-oc-tiny.c
+++ b/drivers/spi/spi-oc-tiny.c
@@ -315,15 +315,11 @@ static int tiny_spi_probe(struct platform_device *pdev)
 
 	/* find and map our resources */
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!res)
-		goto exit_busy;
-	if (!devm_request_mem_region(&pdev->dev, res->start, resource_size(res),
-				     pdev->name))
-		goto exit_busy;
-	hw->base = devm_ioremap_nocache(&pdev->dev, res->start,
-					resource_size(res));
-	if (!hw->base)
-		goto exit_busy;
+	hw->base = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(hw->base)) {
+		err = PTR_ERR(hw->base);
+		goto exit;
+	}
 	/* irq is optional */
 	hw->irq = platform_get_irq(pdev, 0);
 	if (hw->irq >= 0) {
@@ -337,8 +333,10 @@ static int tiny_spi_probe(struct platform_device *pdev)
 	if (platp) {
 		hw->gpio_cs_count = platp->gpio_cs_count;
 		hw->gpio_cs = platp->gpio_cs;
-		if (platp->gpio_cs_count && !platp->gpio_cs)
-			goto exit_busy;
+		if (platp->gpio_cs_count && !platp->gpio_cs) {
+			err = -EBUSY;
+			goto exit;
+		}
 		hw->freq = platp->freq;
 		hw->baudwidth = platp->baudwidth;
 	} else {
@@ -365,8 +363,6 @@ static int tiny_spi_probe(struct platform_device *pdev)
 exit_gpio:
 	while (i-- > 0)
 		gpio_free(hw->gpio_cs[i]);
-exit_busy:
-	err = -EBUSY;
 exit:
 	spi_master_put(master);
 	return err;

