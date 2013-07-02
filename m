Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753743Ab3GBRIP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 13:08:15 -0400
Received: from mail1.bemta8.messagelabs.com ([216.82.243.203]:27872 "EHLO
	mail1.bemta8.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752502Ab3GBRIO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 13:08:14 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-8.tower-131.messagelabs.com!1372784882!5072381!19
X-Originating-IP: [216.166.12.180]
X-StarScan-Received: 
X-StarScan-Version: 6.9.9; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 04/11] spi: spi-ep93xx: get platform resources early in (*probe)
Date: Tue, 2 Jul 2013 10:07:53 -0700
User-Agent: KMail/1.9.9
CC: <spi-devel-general@lists.sourceforge.net>, Ryan Mallon <rmallon@gmail.com>,
        <mika.westerberg@iki.fi>, <broonie@kernel.org>,
        <grant.likely@linaro.org>, <hsweeten@visionengravers.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201307021007.53590.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Get the platform resources early in the (*probe) to minimize the number
of goto's in the error path.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ryan Mallon <rmallon@gmail.com>
Cc: Mika Westerberg <mika.westerberg@iki.fi>
Cc: Mark Brown <broonie@kernel.org>
Cc: Grant Likely <grant.likely@linaro.org>
---
 drivers/spi/spi-ep93xx.c | 26 ++++++++++++--------------
 1 file changed, 12 insertions(+), 14 deletions(-)

diff --git a/drivers/spi/spi-ep93xx.c b/drivers/spi/spi-ep93xx.c
index d5e6420..c2660c2 100644
--- a/drivers/spi/spi-ep93xx.c
+++ b/drivers/spi/spi-ep93xx.c
@@ -991,6 +991,18 @@ static int ep93xx_spi_probe(struct platform_device *pdev)
 
 	info = pdev->dev.platform_data;
 
+	irq = platform_get_irq(pdev, 0);
+	if (irq < 0) {
+		dev_err(&pdev->dev, "failed to get irq resources\n");
+		return -EBUSY;
+	}
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res) {
+		dev_err(&pdev->dev, "unable to get iomem resource\n");
+		return -ENODEV;
+	}
+
 	master = spi_alloc_master(&pdev->dev, sizeof(*espi));
 	if (!master) {
 		dev_err(&pdev->dev, "failed to allocate spi master\n");
@@ -1027,20 +1039,6 @@ static int ep93xx_spi_probe(struct platform_device *pdev)
 	espi->min_rate = clk_get_rate(espi->clk) / (254 * 256);
 	espi->pdev = pdev;
 
-	irq = platform_get_irq(pdev, 0);
-	if (irq < 0) {
-		error = -EBUSY;
-		dev_err(&pdev->dev, "failed to get irq resources\n");
-		goto fail_put_clock;
-	}
-
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!res) {
-		dev_err(&pdev->dev, "unable to get iomem resource\n");
-		error = -ENODEV;
-		goto fail_put_clock;
-	}
-
 	espi->sspdr_phys = res->start + SSPDR;
 
 	espi->regs_base = devm_ioremap_resource(&pdev->dev, res);
-- 
1.8.1.4

