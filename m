Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753899Ab3GBRJL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 13:09:11 -0400
Received: from mail1.bemta8.messagelabs.com ([216.82.243.202]:19643 "EHLO
	mail1.bemta8.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753007Ab3GBRJJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 13:09:09 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-7.tower-132.messagelabs.com!1372784944!9645535!8
X-Originating-IP: [216.166.12.69]
X-StarScan-Received: 
X-StarScan-Version: 6.9.9; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 05/11] spi: spi-ep93xx: use devm_clk_get()
Date: Tue, 2 Jul 2013 10:08:21 -0700
User-Agent: KMail/1.9.9
CC: <spi-devel-general@lists.sourceforge.net>, Ryan Mallon <rmallon@gmail.com>,
        <mika.westerberg@iki.fi>, <broonie@kernel.org>,
        <grant.likely@linaro.org>, <hsweeten@visionengravers.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201307021008.22347.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_clk_get() so that the clk_put() happens automatically when
the last reference to this driver is dropped.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ryan Mallon <rmallon@gmail.com>
Cc: Mika Westerberg <mika.westerberg@iki.fi>
Cc: Mark Brown <broonie@kernel.org>
Cc: Grant Likely <grant.likely@linaro.org>
---
 drivers/spi/spi-ep93xx.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/spi/spi-ep93xx.c b/drivers/spi/spi-ep93xx.c
index c2660c2..c1a610e 100644
--- a/drivers/spi/spi-ep93xx.c
+++ b/drivers/spi/spi-ep93xx.c
@@ -1021,7 +1021,7 @@ static int ep93xx_spi_probe(struct platform_device *pdev)
 
 	espi = spi_master_get_devdata(master);
 
-	espi->clk = clk_get(&pdev->dev, NULL);
+	espi->clk = devm_clk_get(&pdev->dev, NULL);
 	if (IS_ERR(espi->clk)) {
 		dev_err(&pdev->dev, "unable to get spi clock\n");
 		error = PTR_ERR(espi->clk);
@@ -1044,14 +1044,14 @@ static int ep93xx_spi_probe(struct platform_device *pdev)
 	espi->regs_base = devm_ioremap_resource(&pdev->dev, res);
 	if (IS_ERR(espi->regs_base)) {
 		error = PTR_ERR(espi->regs_base);
-		goto fail_put_clock;
+		goto fail_release_master;
 	}
 
 	error = devm_request_irq(&pdev->dev, irq, ep93xx_spi_interrupt,
 				0, "ep93xx-spi", espi);
 	if (error) {
 		dev_err(&pdev->dev, "failed to request irq\n");
-		goto fail_put_clock;
+		goto fail_release_master;
 	}
 
 	if (info->use_dma && ep93xx_spi_setup_dma(espi))
@@ -1085,8 +1085,6 @@ fail_free_queue:
 	destroy_workqueue(espi->wq);
 fail_free_dma:
 	ep93xx_spi_release_dma(espi);
-fail_put_clock:
-	clk_put(espi->clk);
 fail_release_master:
 	spi_master_put(master);
 
@@ -1122,7 +1120,6 @@ static int ep93xx_spi_remove(struct platform_device *pdev)
 	spin_unlock_irq(&espi->lock);
 
 	ep93xx_spi_release_dma(espi);
-	clk_put(espi->clk);
 
 	spi_unregister_master(master);
 	return 0;
-- 
1.8.1.4

