Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753446Ab3EJIRS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 04:17:18 -0400
Received: from sauhun.de ([89.238.76.85]:60504 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753287Ab3EJIRM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 04:17:12 -0400
From: Wolfram Sang <wsa@the-dreams.de>
To: linux-kernel@vger.kernel.org
Cc: Wolfram Sang <wsa@the-dreams.de>, Mark Brown <broonie@kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Barry Song <baohua.song@csr.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        spi-devel-general@lists.sourceforge.net,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-tegra@vger.kernel.org
Subject: [RFC 23/42] drivers/spi: don't check resource with devm_ioremap_resource
Date: Fri, 10 May 2013 10:17:08 +0200
Message-Id: <1368173847-5661-24-git-send-email-wsa@the-dreams.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1368173847-5661-1-git-send-email-wsa@the-dreams.de>
References: <1368173847-5661-1-git-send-email-wsa@the-dreams.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

devm_ioremap_resource does sanity checks on the given resource. No need to
duplicate this in the driver.

Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
---
 drivers/spi/spi-bcm63xx.c        |    8 +-------
 drivers/spi/spi-ep93xx.c         |    8 +-------
 drivers/spi/spi-omap2-mcspi.c    |    7 +------
 drivers/spi/spi-s3c64xx.c        |    7 +------
 drivers/spi/spi-sirf.c           |    7 +------
 drivers/spi/spi-tegra114.c       |    7 +------
 drivers/spi/spi-tegra20-sflash.c |    5 -----
 drivers/spi/spi-tegra20-slink.c  |    7 +------
 8 files changed, 7 insertions(+), 49 deletions(-)

diff --git a/drivers/spi/spi-bcm63xx.c b/drivers/spi/spi-bcm63xx.c
index a4ec5f4..9804ee0 100644
--- a/drivers/spi/spi-bcm63xx.c
+++ b/drivers/spi/spi-bcm63xx.c
@@ -378,13 +378,6 @@ static int bcm63xx_spi_probe(struct platform_device *pdev)
 	struct bcm63xx_spi *bs;
 	int ret;
 
-	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!r) {
-		dev_err(dev, "no iomem\n");
-		ret = -ENXIO;
-		goto out;
-	}
-
 	irq = platform_get_irq(pdev, 0);
 	if (irq < 0) {
 		dev_err(dev, "no irq\n");
@@ -411,6 +404,7 @@ static int bcm63xx_spi_probe(struct platform_device *pdev)
 	platform_set_drvdata(pdev, master);
 	bs->pdev = pdev;
 
+	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	bs->regs = devm_ioremap_resource(&pdev->dev, r);
 	if (IS_ERR(bs->regs)) {
 		ret = PTR_ERR(bs->regs);
diff --git a/drivers/spi/spi-ep93xx.c b/drivers/spi/spi-ep93xx.c
index d7bac60..213cb7a3 100644
--- a/drivers/spi/spi-ep93xx.c
+++ b/drivers/spi/spi-ep93xx.c
@@ -1076,15 +1076,9 @@ static int ep93xx_spi_probe(struct platform_device *pdev)
 		goto fail_put_clock;
 	}
 
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!res) {
-		dev_err(&pdev->dev, "unable to get iomem resource\n");
-		error = -ENODEV;
-		goto fail_put_clock;
-	}
-
 	espi->sspdr_phys = res->start + SSPDR;
 
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	espi->regs_base = devm_ioremap_resource(&pdev->dev, res);
 	if (IS_ERR(espi->regs_base)) {
 		error = PTR_ERR(espi->regs_base);
diff --git a/drivers/spi/spi-omap2-mcspi.c b/drivers/spi/spi-omap2-mcspi.c
index 86d2158..31c054e 100644
--- a/drivers/spi/spi-omap2-mcspi.c
+++ b/drivers/spi/spi-omap2-mcspi.c
@@ -1228,16 +1228,11 @@ static int omap2_mcspi_probe(struct platform_device *pdev)
 	}
 	regs_offset = pdata->regs_offset;
 
-	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (r == NULL) {
-		status = -ENODEV;
-		goto free_master;
-	}
-
 	r->start += regs_offset;
 	r->end += regs_offset;
 	mcspi->phys = r->start;
 
+	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	mcspi->base = devm_ioremap_resource(&pdev->dev, r);
 	if (IS_ERR(mcspi->base)) {
 		status = PTR_ERR(mcspi->base);
diff --git a/drivers/spi/spi-s3c64xx.c b/drivers/spi/spi-s3c64xx.c
index 5000586..fd763cc 100644
--- a/drivers/spi/spi-s3c64xx.c
+++ b/drivers/spi/spi-s3c64xx.c
@@ -1243,12 +1243,6 @@ static int s3c64xx_spi_probe(struct platform_device *pdev)
 		return -ENODEV;
 	}
 
-	mem_res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (mem_res == NULL) {
-		dev_err(&pdev->dev, "Unable to get SPI MEM resource\n");
-		return -ENXIO;
-	}
-
 	irq = platform_get_irq(pdev, 0);
 	if (irq < 0) {
 		dev_warn(&pdev->dev, "Failed to get IRQ: %d\n", irq);
@@ -1318,6 +1312,7 @@ static int s3c64xx_spi_probe(struct platform_device *pdev)
 	/* the spi->mode bits understood by this driver: */
 	master->mode_bits = SPI_CPOL | SPI_CPHA | SPI_CS_HIGH;
 
+	mem_res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	sdd->regs = devm_ioremap_resource(&pdev->dev, mem_res);
 	if (IS_ERR(sdd->regs)) {
 		ret = PTR_ERR(sdd->regs);
diff --git a/drivers/spi/spi-sirf.c b/drivers/spi/spi-sirf.c
index 0808cd5..318ca5b 100644
--- a/drivers/spi/spi-sirf.c
+++ b/drivers/spi/spi-sirf.c
@@ -502,12 +502,6 @@ static int spi_sirfsoc_probe(struct platform_device *pdev)
 	platform_set_drvdata(pdev, master);
 	sspi = spi_master_get_devdata(master);
 
-	mem_res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!mem_res) {
-		dev_err(&pdev->dev, "Unable to get IO resource\n");
-		ret = -ENODEV;
-		goto free_master;
-	}
 	master->num_chipselect = num_cs;
 
 	for (i = 0; i < master->num_chipselect; i++) {
@@ -534,6 +528,7 @@ static int spi_sirfsoc_probe(struct platform_device *pdev)
 		}
 	}
 
+	mem_res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	sspi->base = devm_ioremap_resource(&pdev->dev, mem_res);
 	if (IS_ERR(sspi->base)) {
 		ret = PTR_ERR(sspi->base);
diff --git a/drivers/spi/spi-tegra114.c b/drivers/spi/spi-tegra114.c
index 598eb45..fc39365 100644
--- a/drivers/spi/spi-tegra114.c
+++ b/drivers/spi/spi-tegra114.c
@@ -1058,13 +1058,8 @@ static int tegra_spi_probe(struct platform_device *pdev)
 	tspi->dev = &pdev->dev;
 	spin_lock_init(&tspi->lock);
 
-	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!r) {
-		dev_err(&pdev->dev, "No IO memory resource\n");
-		ret = -ENODEV;
-		goto exit_free_master;
-	}
 	tspi->phys = r->start;
+	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	tspi->base = devm_ioremap_resource(&pdev->dev, r);
 	if (IS_ERR(tspi->base)) {
 		ret = PTR_ERR(tspi->base);
diff --git a/drivers/spi/spi-tegra20-sflash.c b/drivers/spi/spi-tegra20-sflash.c
index d65c000..09df8e2 100644
--- a/drivers/spi/spi-tegra20-sflash.c
+++ b/drivers/spi/spi-tegra20-sflash.c
@@ -489,11 +489,6 @@ static int tegra_sflash_probe(struct platform_device *pdev)
 	tegra_sflash_parse_dt(tsd);
 
 	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!r) {
-		dev_err(&pdev->dev, "No IO memory resource\n");
-		ret = -ENODEV;
-		goto exit_free_master;
-	}
 	tsd->base = devm_ioremap_resource(&pdev->dev, r);
 	if (IS_ERR(tsd->base)) {
 		ret = PTR_ERR(tsd->base);
diff --git a/drivers/spi/spi-tegra20-slink.c b/drivers/spi/spi-tegra20-slink.c
index 3faf88d..46392f0 100644
--- a/drivers/spi/spi-tegra20-slink.c
+++ b/drivers/spi/spi-tegra20-slink.c
@@ -1098,13 +1098,8 @@ static int tegra_slink_probe(struct platform_device *pdev)
 
 	tegra_slink_parse_dt(tspi);
 
-	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!r) {
-		dev_err(&pdev->dev, "No IO memory resource\n");
-		ret = -ENODEV;
-		goto exit_free_master;
-	}
 	tspi->phys = r->start;
+	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	tspi->base = devm_ioremap_resource(&pdev->dev, r);
 	if (IS_ERR(tspi->base)) {
 		ret = PTR_ERR(tspi->base);
-- 
1.7.10.4

