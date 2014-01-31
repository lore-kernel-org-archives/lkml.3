Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932198AbaAaKZd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 05:25:33 -0500
Received: from top.free-electrons.com ([176.31.233.9]:42883 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754178AbaAaKZY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 05:25:24 -0500
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Mark Brown <broonie@kernel.org>
Cc: linux-spi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH 3/3] spi: switch to devm_spi_alloc_master
Date: Fri, 31 Jan 2014 11:23:12 +0100
Message-Id: <1391163792-21819-4-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1391163792-21819-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1391163792-21819-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make the existing users of devm_spi_register_master use the
devm_spi_alloc_master function to avoid leaking memory.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 drivers/spi/spi-atmel.c          |  8 +++-----
 drivers/spi/spi-bcm2835.c        | 15 +++++----------
 drivers/spi/spi-bcm63xx-hsspi.c  |  8 +++-----
 drivers/spi/spi-bcm63xx.c        | 16 ++++++----------
 drivers/spi/spi-bfin-v3.c        | 13 ++++---------
 drivers/spi/spi-clps711x.c       | 37 +++++++++++++++----------------------
 drivers/spi/spi-coldfire-qspi.c  | 15 +++++----------
 drivers/spi/spi-dw.c             |  6 ++----
 drivers/spi/spi-ep93xx.c         | 15 +++++----------
 drivers/spi/spi-falcon.c         |  5 ++---
 drivers/spi/spi-mpc512x-psc.c    | 19 ++++++++-----------
 drivers/spi/spi-mxs.c            |  9 +++------
 drivers/spi/spi-octeon.c         | 12 ++++--------
 drivers/spi/spi-omap-100k.c      | 16 +++++-----------
 drivers/spi/spi-omap2-mcspi.c    | 18 ++++++------------
 drivers/spi/spi-orion.c          | 10 +++-------
 drivers/spi/spi-pl022.c          |  3 +--
 drivers/spi/spi-pxa2xx.c         |  3 +--
 drivers/spi/spi-rspi.c           | 13 ++++---------
 drivers/spi/spi-s3c64xx.c        | 23 ++++++++---------------
 drivers/spi/spi-sc18is602.c      | 12 ++----------
 drivers/spi/spi-sh-hspi.c        |  7 ++-----
 drivers/spi/spi-tegra114.c       | 15 +++++----------
 drivers/spi/spi-tegra20-sflash.c | 12 ++++--------
 drivers/spi/spi-tegra20-slink.c  | 15 +++++----------
 drivers/spi/spi-ti-qspi.c        | 32 +++++++++-----------------------
 drivers/spi/spi-txx9.c           |  3 +--
 drivers/spi/spi-xcomm.c          |  8 ++------
 28 files changed, 123 insertions(+), 245 deletions(-)

diff --git a/drivers/spi/spi-atmel.c b/drivers/spi/spi-atmel.c
index b0842f7..fdaa92f 100644
--- a/drivers/spi/spi-atmel.c
+++ b/drivers/spi/spi-atmel.c
@@ -1317,9 +1317,9 @@ static int atmel_spi_probe(struct platform_device *pdev)
 
 	/* setup spi core then atmel-specific driver state */
 	ret = -ENOMEM;
-	master = spi_alloc_master(&pdev->dev, sizeof(*as));
+	master = devm_spi_alloc_master(&pdev->dev, sizeof(*as));
 	if (!master)
-		goto out_free;
+		return ret;
 
 	/* the spi->mode bits understood by this driver: */
 	master->mode_bits = SPI_CPOL | SPI_CPHA | SPI_CS_HIGH;
@@ -1341,7 +1341,7 @@ static int atmel_spi_probe(struct platform_device *pdev)
 	as->buffer = dma_alloc_coherent(&pdev->dev, BUFFER_SIZE,
 					&as->buffer_dma, GFP_KERNEL);
 	if (!as->buffer)
-		goto out_free;
+		return ret;
 
 	spin_lock_init(&as->lock);
 
@@ -1420,8 +1420,6 @@ out_unmap_regs:
 out_free_buffer:
 	dma_free_coherent(&pdev->dev, BUFFER_SIZE, as->buffer,
 			as->buffer_dma);
-out_free:
-	spi_master_put(master);
 	return ret;
 }
 
diff --git a/drivers/spi/spi-bcm2835.c b/drivers/spi/spi-bcm2835.c
index 8a89dd1..ece406e 100644
--- a/drivers/spi/spi-bcm2835.c
+++ b/drivers/spi/spi-bcm2835.c
@@ -305,7 +305,7 @@ static int bcm2835_spi_probe(struct platform_device *pdev)
 	struct resource *res;
 	int err;
 
-	master = spi_alloc_master(&pdev->dev, sizeof(*bs));
+	master = devm_spi_alloc_master(&pdev->dev, sizeof(*bs));
 	if (!master) {
 		dev_err(&pdev->dev, "spi_alloc_master() failed\n");
 		return -ENOMEM;
@@ -326,23 +326,19 @@ static int bcm2835_spi_probe(struct platform_device *pdev)
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	bs->regs = devm_ioremap_resource(&pdev->dev, res);
-	if (IS_ERR(bs->regs)) {
-		err = PTR_ERR(bs->regs);
-		goto out_master_put;
-	}
+	if (IS_ERR(bs->regs))
+		return PTR_ERR(bs->regs);
 
 	bs->clk = devm_clk_get(&pdev->dev, NULL);
 	if (IS_ERR(bs->clk)) {
-		err = PTR_ERR(bs->clk);
 		dev_err(&pdev->dev, "could not get clk: %d\n", err);
-		goto out_master_put;
+		return PTR_ERR(bs->clk);
 	}
 
 	bs->irq = irq_of_parse_and_map(pdev->dev.of_node, 0);
 	if (bs->irq <= 0) {
 		dev_err(&pdev->dev, "could not get IRQ: %d\n", bs->irq);
-		err = bs->irq ? bs->irq : -ENODEV;
-		goto out_master_put;
+		return bs->irq ? bs->irq : -ENODEV;
 	}
 
 	clk_prepare_enable(bs->clk);
@@ -369,7 +365,6 @@ static int bcm2835_spi_probe(struct platform_device *pdev)
 out_clk_disable:
 	clk_disable_unprepare(bs->clk);
 out_master_put:
-	spi_master_put(master);
 	return err;
 }
 
diff --git a/drivers/spi/spi-bcm63xx-hsspi.c b/drivers/spi/spi-bcm63xx-hsspi.c
index b528f9f..df797cb 100644
--- a/drivers/spi/spi-bcm63xx-hsspi.c
+++ b/drivers/spi/spi-bcm63xx-hsspi.c
@@ -355,7 +355,7 @@ static int bcm63xx_hsspi_probe(struct platform_device *pdev)
 	if (ret)
 		return ret;
 
-	master = spi_alloc_master(&pdev->dev, sizeof(*bs));
+	master = devm_spi_alloc_master(&pdev->dev, sizeof(*bs));
 	if (!master) {
 		ret = -ENOMEM;
 		goto out_disable_clk;
@@ -396,17 +396,15 @@ static int bcm63xx_hsspi_probe(struct platform_device *pdev)
 			       pdev->name, bs);
 
 	if (ret)
-		goto out_put_master;
+		goto out_disable_clk;
 
 	/* register and we are done */
 	ret = devm_spi_register_master(dev, master);
 	if (ret)
-		goto out_put_master;
+		goto out_disable_clk;
 
 	return 0;
 
-out_put_master:
-	spi_master_put(master);
 out_disable_clk:
 	clk_disable_unprepare(clk);
 	return ret;
diff --git a/drivers/spi/spi-bcm63xx.c b/drivers/spi/spi-bcm63xx.c
index 77286ae..dae739f 100644
--- a/drivers/spi/spi-bcm63xx.c
+++ b/drivers/spi/spi-bcm63xx.c
@@ -346,7 +346,7 @@ static int bcm63xx_spi_probe(struct platform_device *pdev)
 		return PTR_ERR(clk);
 	}
 
-	master = spi_alloc_master(dev, sizeof(*bs));
+	master = devm_spi_alloc_master(dev, sizeof(*bs));
 	if (!master) {
 		dev_err(dev, "out of memory\n");
 		return -ENOMEM;
@@ -359,10 +359,8 @@ static int bcm63xx_spi_probe(struct platform_device *pdev)
 
 	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	bs->regs = devm_ioremap_resource(&pdev->dev, r);
-	if (IS_ERR(bs->regs)) {
-		ret = PTR_ERR(bs->regs);
-		goto out_err;
-	}
+	if (IS_ERR(bs->regs))
+		return PTR_ERR(bs->regs);
 
 	bs->irq = irq;
 	bs->clk = clk;
@@ -372,7 +370,7 @@ static int bcm63xx_spi_probe(struct platform_device *pdev)
 							pdev->name, master);
 	if (ret) {
 		dev_err(dev, "unable to request irq\n");
-		goto out_err;
+		return ret;
 	}
 
 	master->bus_num = pdata->bus_num;
@@ -393,13 +391,13 @@ static int bcm63xx_spi_probe(struct platform_device *pdev)
 	default:
 		dev_err(dev, "unsupported MSG_CTL width: %d\n",
 			 bs->msg_ctl_width);
-		goto out_err;
+		return ret;
 	}
 
 	/* Initialize hardware */
 	ret = clk_prepare_enable(bs->clk);
 	if (ret)
-		goto out_err;
+		return ret;;
 
 	bcm_spi_writeb(bs, SPI_INTR_CLEAR_ALL, SPI_INT_STATUS);
 
@@ -417,8 +415,6 @@ static int bcm63xx_spi_probe(struct platform_device *pdev)
 
 out_clk_disable:
 	clk_disable_unprepare(clk);
-out_err:
-	spi_master_put(master);
 	return ret;
 }
 
diff --git a/drivers/spi/spi-bfin-v3.c b/drivers/spi/spi-bfin-v3.c
index 8f85988..140b066 100644
--- a/drivers/spi/spi-bfin-v3.c
+++ b/drivers/spi/spi-bfin-v3.c
@@ -807,7 +807,7 @@ static int bfin_spi_probe(struct platform_device *pdev)
 	rx_dma = res->start;
 
 	/* allocate master with space for drv_data */
-	master = spi_alloc_master(dev, sizeof(*drv_data));
+	master = devm_spi_alloc_master(dev, sizeof(*drv_data));
 	if (!master) {
 		dev_err(dev, "can not alloc spi_master\n");
 		return -ENOMEM;
@@ -833,16 +833,14 @@ static int bfin_spi_probe(struct platform_device *pdev)
 
 	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	drv_data->regs = devm_ioremap_resource(dev, mem);
-	if (IS_ERR(drv_data->regs)) {
-		ret = PTR_ERR(drv_data->regs);
-		goto err_put_master;
-	}
+	if (IS_ERR(drv_data->regs))
+		return PTR_ERR(drv_data->regs);
 
 	/* request tx and rx dma */
 	ret = request_dma(tx_dma, "SPI_TX_DMA");
 	if (ret) {
 		dev_err(dev, "can not request SPI TX DMA channel\n");
-		goto err_put_master;
+		return ret;
 	}
 	set_dma_callback(tx_dma, bfin_spi_tx_dma_isr, drv_data);
 
@@ -881,9 +879,6 @@ err_free_rx_dma:
 	free_dma(rx_dma);
 err_free_tx_dma:
 	free_dma(tx_dma);
-err_put_master:
-	spi_master_put(master);
-
 	return ret;
 }
 
diff --git a/drivers/spi/spi-clps711x.c b/drivers/spi/spi-clps711x.c
index 374ba4a..908c056 100644
--- a/drivers/spi/spi-clps711x.c
+++ b/drivers/spi/spi-clps711x.c
@@ -174,9 +174,9 @@ static int spi_clps711x_probe(struct platform_device *pdev)
 		return -EINVAL;
 	}
 
-	master = spi_alloc_master(&pdev->dev,
-				  sizeof(struct spi_clps711x_data) +
-				  sizeof(int) * pdata->num_chipselect);
+	master = devm_spi_alloc_master(&pdev->dev,
+				       sizeof(struct spi_clps711x_data) +
+				       sizeof(int) * pdata->num_chipselect);
 	if (!master) {
 		dev_err(&pdev->dev, "SPI allocating memory error\n");
 		return -ENOMEM;
@@ -195,21 +195,18 @@ static int spi_clps711x_probe(struct platform_device *pdev)
 		hw->chipselect[i] = pdata->chipselect[i];
 		if (!gpio_is_valid(hw->chipselect[i])) {
 			dev_err(&pdev->dev, "Invalid CS GPIO %i\n", i);
-			ret = -EINVAL;
-			goto err_out;
+			return -EINVAL;
 		}
 		if (devm_gpio_request(&pdev->dev, hw->chipselect[i], NULL)) {
 			dev_err(&pdev->dev, "Can't get CS GPIO %i\n", i);
-			ret = -EINVAL;
-			goto err_out;
+			return -EINVAL;
 		}
 	}
 
 	hw->spi_clk = devm_clk_get(&pdev->dev, "spi");
 	if (IS_ERR(hw->spi_clk)) {
 		dev_err(&pdev->dev, "Can't get clocks\n");
-		ret = PTR_ERR(hw->spi_clk);
-		goto err_out;
+		return PTR_ERR(hw->spi_clk);
 	}
 	hw->max_speed_hz = clk_get_rate(hw->spi_clk);
 
@@ -226,23 +223,19 @@ static int spi_clps711x_probe(struct platform_device *pdev)
 			       dev_name(&pdev->dev), hw);
 	if (ret) {
 		dev_err(&pdev->dev, "Can't request IRQ\n");
-		goto err_out;
+		return ret;
 	}
 
 	ret = devm_spi_register_master(&pdev->dev, master);
-	if (!ret) {
-		dev_info(&pdev->dev,
-			 "SPI bus driver initialized. Master clock %u Hz\n",
-			 hw->max_speed_hz);
-		return 0;
+	if (ret) {
+		dev_err(&pdev->dev, "Failed to register master\n");
+		return ret;
 	}
-
-	dev_err(&pdev->dev, "Failed to register master\n");
-
-err_out:
-	spi_master_put(master);
-
-	return ret;
+	
+	dev_info(&pdev->dev,
+		 "SPI bus driver initialized. Master clock %u Hz\n",
+		 hw->max_speed_hz);
+	return 0;
 }
 
 static struct platform_driver clps711x_spi_driver = {
diff --git a/drivers/spi/spi-coldfire-qspi.c b/drivers/spi/spi-coldfire-qspi.c
index cabed8f..41f6c9c 100644
--- a/drivers/spi/spi-coldfire-qspi.c
+++ b/drivers/spi/spi-coldfire-qspi.c
@@ -388,7 +388,7 @@ static int mcfqspi_probe(struct platform_device *pdev)
 		return -ENOENT;
 	}
 
-	master = spi_alloc_master(&pdev->dev, sizeof(*mcfqspi));
+	master = devm_spi_alloc_master(&pdev->dev, sizeof(*mcfqspi));
 	if (master == NULL) {
 		dev_dbg(&pdev->dev, "spi_alloc_master failed\n");
 		return -ENOMEM;
@@ -399,29 +399,26 @@ static int mcfqspi_probe(struct platform_device *pdev)
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	mcfqspi->iobase = devm_ioremap_resource(&pdev->dev, res);
 	if (IS_ERR(mcfqspi->iobase)) {
-		status = PTR_ERR(mcfqspi->iobase);
-		goto fail0;
+		return PTR_ERR(mcfqspi->iobase);
 	}
 
 	mcfqspi->irq = platform_get_irq(pdev, 0);
 	if (mcfqspi->irq < 0) {
 		dev_dbg(&pdev->dev, "platform_get_irq failed\n");
-		status = -ENXIO;
-		goto fail0;
+		return -ENXIO;
 	}
 
 	status = devm_request_irq(&pdev->dev, mcfqspi->irq, mcfqspi_irq_handler,
 				0, pdev->name, mcfqspi);
 	if (status) {
 		dev_dbg(&pdev->dev, "request_irq failed\n");
-		goto fail0;
+		return status;
 	}
 
 	mcfqspi->clk = devm_clk_get(&pdev->dev, "qspi_clk");
 	if (IS_ERR(mcfqspi->clk)) {
 		dev_dbg(&pdev->dev, "clk_get failed\n");
-		status = PTR_ERR(mcfqspi->clk);
-		goto fail0;
+		return PTR_ERR(mcfqspi->clk);
 	}
 	clk_enable(mcfqspi->clk);
 
@@ -461,8 +458,6 @@ fail2:
 	mcfqspi_cs_teardown(mcfqspi);
 fail1:
 	clk_disable(mcfqspi->clk);
-fail0:
-	spi_master_put(master);
 
 	dev_dbg(&pdev->dev, "Coldfire QSPI probe failed\n");
 
diff --git a/drivers/spi/spi-dw.c b/drivers/spi/spi-dw.c
index bf98d63..bcb172c 100644
--- a/drivers/spi/spi-dw.c
+++ b/drivers/spi/spi-dw.c
@@ -783,7 +783,7 @@ int dw_spi_add_host(struct device *dev, struct dw_spi *dws)
 
 	BUG_ON(dws == NULL);
 
-	master = spi_alloc_master(dev, 0);
+	master = devm_spi_alloc_master(dev, 0);
 	if (!master)
 		return -ENOMEM;
 
@@ -799,7 +799,7 @@ int dw_spi_add_host(struct device *dev, struct dw_spi *dws)
 			dws->name, dws);
 	if (ret < 0) {
 		dev_err(&master->dev, "can not get IRQ\n");
-		goto err_free_master;
+		return ret;
 	}
 
 	master->mode_bits = SPI_CPOL | SPI_CPHA;
@@ -849,8 +849,6 @@ err_queue_alloc:
 		dws->dma_ops->dma_exit(dws);
 err_diable_hw:
 	spi_enable_chip(dws, 0);
-err_free_master:
-	spi_master_put(master);
 	return ret;
 }
 EXPORT_SYMBOL_GPL(dw_spi_add_host);
diff --git a/drivers/spi/spi-ep93xx.c b/drivers/spi/spi-ep93xx.c
index 1bfaed6..7177435 100644
--- a/drivers/spi/spi-ep93xx.c
+++ b/drivers/spi/spi-ep93xx.c
@@ -888,7 +888,7 @@ static int ep93xx_spi_probe(struct platform_device *pdev)
 		return -ENODEV;
 	}
 
-	master = spi_alloc_master(&pdev->dev, sizeof(*espi));
+	master = devm_spi_alloc_master(&pdev->dev, sizeof(*espi));
 	if (!master)
 		return -ENOMEM;
 
@@ -907,8 +907,7 @@ static int ep93xx_spi_probe(struct platform_device *pdev)
 	espi->clk = devm_clk_get(&pdev->dev, NULL);
 	if (IS_ERR(espi->clk)) {
 		dev_err(&pdev->dev, "unable to get spi clock\n");
-		error = PTR_ERR(espi->clk);
-		goto fail_release_master;
+		return PTR_ERR(espi->clk);
 	}
 
 	init_completion(&espi->wait);
@@ -924,16 +923,14 @@ static int ep93xx_spi_probe(struct platform_device *pdev)
 	espi->sspdr_phys = res->start + SSPDR;
 
 	espi->regs_base = devm_ioremap_resource(&pdev->dev, res);
-	if (IS_ERR(espi->regs_base)) {
-		error = PTR_ERR(espi->regs_base);
-		goto fail_release_master;
-	}
+	if (IS_ERR(espi->regs_base))
+		return PTR_ERR(espi->regs_base);
 
 	error = devm_request_irq(&pdev->dev, irq, ep93xx_spi_interrupt,
 				0, "ep93xx-spi", espi);
 	if (error) {
 		dev_err(&pdev->dev, "failed to request irq\n");
-		goto fail_release_master;
+		return error;
 	}
 
 	if (info->use_dma && ep93xx_spi_setup_dma(espi))
@@ -955,8 +952,6 @@ static int ep93xx_spi_probe(struct platform_device *pdev)
 
 fail_free_dma:
 	ep93xx_spi_release_dma(espi);
-fail_release_master:
-	spi_master_put(master);
 
 	return error;
 }
diff --git a/drivers/spi/spi-falcon.c b/drivers/spi/spi-falcon.c
index dd5bd46..a6aa66f 100644
--- a/drivers/spi/spi-falcon.c
+++ b/drivers/spi/spi-falcon.c
@@ -414,7 +414,7 @@ static int falcon_sflash_probe(struct platform_device *pdev)
 		return -ENODEV;
 	}
 
-	master = spi_alloc_master(&pdev->dev, sizeof(*priv));
+	master = devm_spi_alloc_master(&pdev->dev, sizeof(*priv));
 	if (!master)
 		return -ENOMEM;
 
@@ -434,8 +434,7 @@ static int falcon_sflash_probe(struct platform_device *pdev)
 	platform_set_drvdata(pdev, priv);
 
 	ret = devm_spi_register_master(&pdev->dev, master);
-	if (ret)
-		spi_master_put(master);
+
 	return ret;
 }
 
diff --git a/drivers/spi/spi-mpc512x-psc.c b/drivers/spi/spi-mpc512x-psc.c
index 46d2313..f376595 100644
--- a/drivers/spi/spi-mpc512x-psc.c
+++ b/drivers/spi/spi-mpc512x-psc.c
@@ -479,7 +479,7 @@ static int mpc512x_psc_spi_do_probe(struct device *dev, u32 regaddr,
 	char clk_name[16];
 	struct clk *clk;
 
-	master = spi_alloc_master(dev, sizeof *mps);
+	master = devm_spi_alloc_master(dev, sizeof *mps);
 	if (master == NULL)
 		return -ENOMEM;
 
@@ -507,8 +507,7 @@ static int mpc512x_psc_spi_do_probe(struct device *dev, u32 regaddr,
 	tempp = devm_ioremap(dev, regaddr, size);
 	if (!tempp) {
 		dev_err(dev, "could not ioremap I/O port range\n");
-		ret = -EFAULT;
-		goto free_master;
+		return -EFAULT;
 	}
 	mps->psc = tempp;
 	mps->fifo =
@@ -516,19 +515,19 @@ static int mpc512x_psc_spi_do_probe(struct device *dev, u32 regaddr,
 	ret = devm_request_irq(dev, mps->irq, mpc512x_psc_spi_isr, IRQF_SHARED,
 				"mpc512x-psc-spi", mps);
 	if (ret)
-		goto free_master;
+		return ret;
 	init_completion(&mps->txisrdone);
 
 	psc_num = master->bus_num;
 	snprintf(clk_name, sizeof(clk_name), "psc%d_mclk", psc_num);
 	clk = devm_clk_get(dev, clk_name);
-	if (IS_ERR(clk)) {
-		ret = PTR_ERR(clk);
-		goto free_master;
-	}
+	if (IS_ERR(clk))
+		return PTR_ERR(clk);
+
 	ret = clk_prepare_enable(clk);
 	if (ret)
-		goto free_master;
+		return ret;
+
 	mps->clk_mclk = clk;
 	mps->mclk_rate = clk_get_rate(clk);
 
@@ -544,8 +543,6 @@ static int mpc512x_psc_spi_do_probe(struct device *dev, u32 regaddr,
 
 free_clock:
 	clk_disable_unprepare(mps->clk_mclk);
-free_master:
-	spi_master_put(master);
 
 	return ret;
 }
diff --git a/drivers/spi/spi-mxs.c b/drivers/spi/spi-mxs.c
index 79e5aa2..2c63bed 100644
--- a/drivers/spi/spi-mxs.c
+++ b/drivers/spi/spi-mxs.c
@@ -489,7 +489,7 @@ static int mxs_spi_probe(struct platform_device *pdev)
 	if (ret)
 		clk_freq = clk_freq_default;
 
-	master = spi_alloc_master(&pdev->dev, sizeof(*spi));
+	master = devm_spi_alloc_master(&pdev->dev, sizeof(*spi));
 	if (!master)
 		return -ENOMEM;
 
@@ -512,13 +512,12 @@ static int mxs_spi_probe(struct platform_device *pdev)
 	ret = devm_request_irq(&pdev->dev, irq_err, mxs_ssp_irq_handler, 0,
 			       DRIVER_NAME, ssp);
 	if (ret)
-		goto out_master_free;
+		return ret;
 
 	ssp->dmach = dma_request_slave_channel(&pdev->dev, "rx-tx");
 	if (!ssp->dmach) {
 		dev_err(ssp->dev, "Failed to request DMA\n");
-		ret = -ENODEV;
-		goto out_master_free;
+		return -ENODEV;
 	}
 
 	ret = clk_prepare_enable(ssp->clk);
@@ -545,8 +544,6 @@ out_disable_clk:
 	clk_disable_unprepare(ssp->clk);
 out_dma_release:
 	dma_release_channel(ssp->dmach);
-out_master_free:
-	spi_master_put(master);
 	return ret;
 }
 
diff --git a/drivers/spi/spi-octeon.c b/drivers/spi/spi-octeon.c
index 67249a4..192ca3d 100644
--- a/drivers/spi/spi-octeon.c
+++ b/drivers/spi/spi-octeon.c
@@ -236,7 +236,7 @@ static int octeon_spi_probe(struct platform_device *pdev)
 	struct octeon_spi *p;
 	int err = -ENOENT;
 
-	master = spi_alloc_master(&pdev->dev, sizeof(struct octeon_spi));
+	master = devm_spi_alloc_master(&pdev->dev, sizeof(struct octeon_spi));
 	if (!master)
 		return -ENOMEM;
 	p = spi_master_get_devdata(master);
@@ -246,13 +246,12 @@ static int octeon_spi_probe(struct platform_device *pdev)
 
 	if (res_mem == NULL) {
 		dev_err(&pdev->dev, "found no memory resource\n");
-		err = -ENXIO;
-		goto fail;
+		return -ENXIO;
 	}
 	if (!devm_request_mem_region(&pdev->dev, res_mem->start,
 				     resource_size(res_mem), res_mem->name)) {
 		dev_err(&pdev->dev, "request_mem_region failed\n");
-		goto fail;
+		return err;
 	}
 	p->register_base = (u64)devm_ioremap(&pdev->dev, res_mem->start,
 					     resource_size(res_mem));
@@ -275,15 +274,12 @@ static int octeon_spi_probe(struct platform_device *pdev)
 	err = devm_spi_register_master(&pdev->dev, master);
 	if (err) {
 		dev_err(&pdev->dev, "register master failed: %d\n", err);
-		goto fail;
+		return err;
 	}
 
 	dev_info(&pdev->dev, "OCTEON SPI bus driver\n");
 
 	return 0;
-fail:
-	spi_master_put(master);
-	return err;
 }
 
 static int octeon_spi_remove(struct platform_device *pdev)
diff --git a/drivers/spi/spi-omap-100k.c b/drivers/spi/spi-omap-100k.c
index 0d32054..4ceae27 100644
--- a/drivers/spi/spi-omap-100k.c
+++ b/drivers/spi/spi-omap-100k.c
@@ -411,7 +411,7 @@ static int omap1_spi100k_probe(struct platform_device *pdev)
 	if (!pdev->id)
 		return -EINVAL;
 
-	master = spi_alloc_master(&pdev->dev, sizeof *spi100k);
+	master = devm_spi_alloc_master(&pdev->dev, sizeof *spi100k);
 	if (master == NULL) {
 		dev_dbg(&pdev->dev, "master allocation failed\n");
 		return -ENOMEM;
@@ -446,28 +446,22 @@ static int omap1_spi100k_probe(struct platform_device *pdev)
 	spi100k->ick = devm_clk_get(&pdev->dev, "ick");
 	if (IS_ERR(spi100k->ick)) {
 		dev_dbg(&pdev->dev, "can't get spi100k_ick\n");
-		status = PTR_ERR(spi100k->ick);
-		goto err;
+		return PTR_ERR(spi100k->ick);
 	}
 
 	spi100k->fck = devm_clk_get(&pdev->dev, "fck");
 	if (IS_ERR(spi100k->fck)) {
 		dev_dbg(&pdev->dev, "can't get spi100k_fck\n");
-		status = PTR_ERR(spi100k->fck);
-		goto err;
+		return PTR_ERR(spi100k->fck);
 	}
 
 	status = devm_spi_register_master(&pdev->dev, master);
 	if (status < 0)
-		goto err;
+		return status;
 
 	spi100k->state = SPI_RUNNING;
 
-	return status;
-
-err:
-	spi_master_put(master);
-	return status;
+	return 0;
 }
 
 static struct platform_driver omap1_spi100k_driver = {
diff --git a/drivers/spi/spi-omap2-mcspi.c b/drivers/spi/spi-omap2-mcspi.c
index a72127f..a4b105e 100644
--- a/drivers/spi/spi-omap2-mcspi.c
+++ b/drivers/spi/spi-omap2-mcspi.c
@@ -1297,7 +1297,7 @@ static int omap2_mcspi_probe(struct platform_device *pdev)
 	struct device_node	*node = pdev->dev.of_node;
 	const struct of_device_id *match;
 
-	master = spi_alloc_master(&pdev->dev, sizeof *mcspi);
+	master = devm_spi_alloc_master(&pdev->dev, sizeof *mcspi);
 	if (master == NULL) {
 		dev_dbg(&pdev->dev, "master allocation failed\n");
 		return -ENOMEM;
@@ -1337,20 +1337,16 @@ static int omap2_mcspi_probe(struct platform_device *pdev)
 	regs_offset = pdata->regs_offset;
 
 	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (r == NULL) {
-		status = -ENODEV;
-		goto free_master;
-	}
+	if (r == NULL)
+		return -ENODEV;
 
 	r->start += regs_offset;
 	r->end += regs_offset;
 	mcspi->phys = r->start;
 
 	mcspi->base = devm_ioremap_resource(&pdev->dev, r);
-	if (IS_ERR(mcspi->base)) {
-		status = PTR_ERR(mcspi->base);
-		goto free_master;
-	}
+	if (IS_ERR(mcspi->base))
+		return PTR_ERR(mcspi->base);
 
 	mcspi->dev = &pdev->dev;
 
@@ -1361,7 +1357,7 @@ static int omap2_mcspi_probe(struct platform_device *pdev)
 			GFP_KERNEL);
 
 	if (mcspi->dma_channels == NULL)
-		goto free_master;
+		return status;
 
 	for (i = 0; i < master->num_chipselect; i++) {
 		char *dma_rx_ch_name = mcspi->dma_channels[i].dma_rx_ch_name;
@@ -1423,8 +1419,6 @@ disable_pm:
 	pm_runtime_disable(&pdev->dev);
 dma_chnl_free:
 	kfree(mcspi->dma_channels);
-free_master:
-	spi_master_put(master);
 	return status;
 }
 
diff --git a/drivers/spi/spi-orion.c b/drivers/spi/spi-orion.c
index 7f2121f..1ca04af 100644
--- a/drivers/spi/spi-orion.c
+++ b/drivers/spi/spi-orion.c
@@ -407,7 +407,7 @@ static int orion_spi_probe(struct platform_device *pdev)
 	const u32 *iprop;
 	int size;
 
-	master = spi_alloc_master(&pdev->dev, sizeof(*spi));
+	master = devm_spi_alloc_master(&pdev->dev, sizeof(*spi));
 	if (master == NULL) {
 		dev_dbg(&pdev->dev, "master allocation failed\n");
 		return -ENOMEM;
@@ -435,10 +435,8 @@ static int orion_spi_probe(struct platform_device *pdev)
 	spi->master = master;
 
 	spi->clk = devm_clk_get(&pdev->dev, NULL);
-	if (IS_ERR(spi->clk)) {
-		status = PTR_ERR(spi->clk);
-		goto out;
-	}
+	if (IS_ERR(spi->clk))
+		return PTR_ERR(spi->clk);
 
 	clk_prepare(spi->clk);
 	clk_enable(spi->clk);
@@ -465,8 +463,6 @@ static int orion_spi_probe(struct platform_device *pdev)
 
 out_rel_clk:
 	clk_disable_unprepare(spi->clk);
-out:
-	spi_master_put(master);
 	return status;
 }
 
diff --git a/drivers/spi/spi-pl022.c b/drivers/spi/spi-pl022.c
index 2789b45..69e4d75 100644
--- a/drivers/spi/spi-pl022.c
+++ b/drivers/spi/spi-pl022.c
@@ -2095,7 +2095,7 @@ static int pl022_probe(struct amba_device *adev, const struct amba_id *id)
 	}
 
 	/* Allocate master with space for data */
-	master = spi_alloc_master(dev, sizeof(struct pl022));
+	master = devm_spi_alloc_master(dev, sizeof(struct pl022));
 	if (master == NULL) {
 		dev_err(&adev->dev, "probe - cannot alloc SPI master\n");
 		return -ENOMEM;
@@ -2259,7 +2259,6 @@ static int pl022_probe(struct amba_device *adev, const struct amba_id *id)
 	amba_release_regions(adev);
  err_no_ioregion:
  err_no_gpio:
-	spi_master_put(master);
 	return status;
 }
 
diff --git a/drivers/spi/spi-pxa2xx.c b/drivers/spi/spi-pxa2xx.c
index c702fc5..51017e8 100644
--- a/drivers/spi/spi-pxa2xx.c
+++ b/drivers/spi/spi-pxa2xx.c
@@ -1117,7 +1117,7 @@ static int pxa2xx_spi_probe(struct platform_device *pdev)
 	}
 
 	/* Allocate master with space for drv_data and null dma buffer */
-	master = spi_alloc_master(dev, sizeof(struct driver_data) + 16);
+	master = devm_spi_alloc_master(dev, sizeof(struct driver_data) + 16);
 	if (!master) {
 		dev_err(&pdev->dev, "cannot alloc spi_master\n");
 		pxa_ssp_free(ssp);
@@ -1224,7 +1224,6 @@ out_error_clock_enabled:
 	free_irq(ssp->irq, drv_data);
 
 out_error_master_alloc:
-	spi_master_put(master);
 	pxa_ssp_free(ssp);
 	return status;
 }
diff --git a/drivers/spi/spi-rspi.c b/drivers/spi/spi-rspi.c
index 28987d9..b69d06f 100644
--- a/drivers/spi/spi-rspi.c
+++ b/drivers/spi/spi-rspi.c
@@ -952,7 +952,7 @@ static int rspi_probe(struct platform_device *pdev)
 		return -ENODEV;
 	}
 
-	master = spi_alloc_master(&pdev->dev, sizeof(struct rspi_data));
+	master = devm_spi_alloc_master(&pdev->dev, sizeof(struct rspi_data));
 	if (master == NULL) {
 		dev_err(&pdev->dev, "spi_alloc_master error.\n");
 		return -ENOMEM;
@@ -965,17 +965,14 @@ static int rspi_probe(struct platform_device *pdev)
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	rspi->addr = devm_ioremap_resource(&pdev->dev, res);
-	if (IS_ERR(rspi->addr)) {
-		ret = PTR_ERR(rspi->addr);
-		goto error1;
-	}
+	if (IS_ERR(rspi->addr))
+		return PTR_ERR(rspi->addr);
 
 	snprintf(clk_name, sizeof(clk_name), "%s%d", id_entry->name, pdev->id);
 	rspi->clk = devm_clk_get(&pdev->dev, clk_name);
 	if (IS_ERR(rspi->clk)) {
 		dev_err(&pdev->dev, "cannot get clock\n");
-		ret = PTR_ERR(rspi->clk);
-		goto error1;
+		return PTR_ERR(rspi->clk);
 	}
 	clk_enable(rspi->clk);
 
@@ -1023,8 +1020,6 @@ error3:
 	rspi_release_dma(rspi);
 error2:
 	clk_disable(rspi->clk);
-error1:
-	spi_master_put(master);
 
 	return ret;
 }
diff --git a/drivers/spi/spi-s3c64xx.c b/drivers/spi/spi-s3c64xx.c
index ae907dd..1772cba 100644
--- a/drivers/spi/spi-s3c64xx.c
+++ b/drivers/spi/spi-s3c64xx.c
@@ -1279,8 +1279,8 @@ static int s3c64xx_spi_probe(struct platform_device *pdev)
 		return irq;
 	}
 
-	master = spi_alloc_master(&pdev->dev,
-				sizeof(struct s3c64xx_spi_driver_data));
+	master = devm_spi_alloc_master(&pdev->dev,
+				       sizeof(struct s3c64xx_spi_driver_data));
 	if (master == NULL) {
 		dev_err(&pdev->dev, "Unable to allocate SPI Master\n");
 		return -ENOMEM;
@@ -1303,7 +1303,7 @@ static int s3c64xx_spi_probe(struct platform_device *pdev)
 		if (ret < 0) {
 			dev_err(&pdev->dev, "failed to get alias id, errno %d\n",
 				ret);
-			goto err0;
+			return ret;
 		}
 		sdd->port_id = ret;
 	} else {
@@ -1349,29 +1349,24 @@ static int s3c64xx_spi_probe(struct platform_device *pdev)
 	master->auto_runtime_pm = true;
 
 	sdd->regs = devm_ioremap_resource(&pdev->dev, mem_res);
-	if (IS_ERR(sdd->regs)) {
-		ret = PTR_ERR(sdd->regs);
-		goto err0;
-	}
+	if (IS_ERR(sdd->regs))
+		return PTR_ERR(sdd->regs);
 
 	if (sci->cfg_gpio && sci->cfg_gpio()) {
 		dev_err(&pdev->dev, "Unable to config gpio\n");
-		ret = -EBUSY;
-		goto err0;
+		return -EBUSY;
 	}
 
 	/* Setup clocks */
 	sdd->clk = devm_clk_get(&pdev->dev, "spi");
 	if (IS_ERR(sdd->clk)) {
 		dev_err(&pdev->dev, "Unable to acquire clock 'spi'\n");
-		ret = PTR_ERR(sdd->clk);
-		goto err0;
+		return PTR_ERR(sdd->clk);
 	}
 
 	if (clk_prepare_enable(sdd->clk)) {
 		dev_err(&pdev->dev, "Couldn't enable clock 'spi'\n");
-		ret = -EBUSY;
-		goto err0;
+		return -EBUSY;
 	}
 
 	sprintf(clk_name, "spi_busclk%d", sci->src_clk_nr);
@@ -1428,8 +1423,6 @@ err3:
 	clk_disable_unprepare(sdd->src_clk);
 err2:
 	clk_disable_unprepare(sdd->clk);
-err0:
-	spi_master_put(master);
 
 	return ret;
 }
diff --git a/drivers/spi/spi-sc18is602.c b/drivers/spi/spi-sc18is602.c
index 121c2e1..64760ae 100644
--- a/drivers/spi/spi-sc18is602.c
+++ b/drivers/spi/spi-sc18is602.c
@@ -267,7 +267,7 @@ static int sc18is602_probe(struct i2c_client *client,
 				     I2C_FUNC_SMBUS_WRITE_BYTE_DATA))
 		return -EINVAL;
 
-	master = spi_alloc_master(dev, sizeof(struct sc18is602));
+	master = devm_spi_alloc_master(dev, sizeof(struct sc18is602));
 	if (!master)
 		return -ENOMEM;
 
@@ -310,15 +310,7 @@ static int sc18is602_probe(struct i2c_client *client,
 	master->transfer_one_message = sc18is602_transfer_one;
 	master->dev.of_node = np;
 
-	error = devm_spi_register_master(dev, master);
-	if (error)
-		goto error_reg;
-
-	return 0;
-
-error_reg:
-	spi_master_put(master);
-	return error;
+	return devm_spi_register_master(dev, master);
 }
 
 static const struct i2c_device_id sc18is602_id[] = {
diff --git a/drivers/spi/spi-sh-hspi.c b/drivers/spi/spi-sh-hspi.c
index 82d2f92..fe090a3 100644
--- a/drivers/spi/spi-sh-hspi.c
+++ b/drivers/spi/spi-sh-hspi.c
@@ -268,7 +268,7 @@ static int hspi_probe(struct platform_device *pdev)
 		return -EINVAL;
 	}
 
-	master = spi_alloc_master(&pdev->dev, sizeof(*hspi));
+	master = devm_spi_alloc_master(&pdev->dev, sizeof(*hspi));
 	if (!master) {
 		dev_err(&pdev->dev, "spi_alloc_master error.\n");
 		return -ENOMEM;
@@ -277,8 +277,7 @@ static int hspi_probe(struct platform_device *pdev)
 	clk = clk_get(NULL, "shyway_clk");
 	if (IS_ERR(clk)) {
 		dev_err(&pdev->dev, "shyway_clk is required\n");
-		ret = -EINVAL;
-		goto error0;
+		return -EINVAL;
 	}
 
 	hspi = spi_master_get_devdata(master);
@@ -316,8 +315,6 @@ static int hspi_probe(struct platform_device *pdev)
 
  error1:
 	clk_put(clk);
- error0:
-	spi_master_put(master);
 
 	return ret;
 }
diff --git a/drivers/spi/spi-tegra114.c b/drivers/spi/spi-tegra114.c
index 47b93cc..72076f6 100644
--- a/drivers/spi/spi-tegra114.c
+++ b/drivers/spi/spi-tegra114.c
@@ -1048,7 +1048,7 @@ static int tegra_spi_probe(struct platform_device *pdev)
 	struct resource		*r;
 	int ret, spi_irq;
 
-	master = spi_alloc_master(&pdev->dev, sizeof(*tspi));
+	master = devm_spi_alloc_master(&pdev->dev, sizeof(*tspi));
 	if (!master) {
 		dev_err(&pdev->dev, "master allocation failed\n");
 		return -ENOMEM;
@@ -1073,10 +1073,8 @@ static int tegra_spi_probe(struct platform_device *pdev)
 
 	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	tspi->base = devm_ioremap_resource(&pdev->dev, r);
-	if (IS_ERR(tspi->base)) {
-		ret = PTR_ERR(tspi->base);
-		goto exit_free_master;
-	}
+	if (IS_ERR(tspi->base))
+		return PTR_ERR(tspi->base);
 	tspi->phys = r->start;
 
 	spi_irq = platform_get_irq(pdev, 0);
@@ -1087,14 +1085,13 @@ static int tegra_spi_probe(struct platform_device *pdev)
 	if (ret < 0) {
 		dev_err(&pdev->dev, "Failed to register ISR for IRQ %d\n",
 					tspi->irq);
-		goto exit_free_master;
+		return ret;
 	}
 
 	tspi->clk = devm_clk_get(&pdev->dev, "spi");
 	if (IS_ERR(tspi->clk)) {
 		dev_err(&pdev->dev, "can not get clock\n");
-		ret = PTR_ERR(tspi->clk);
-		goto exit_free_irq;
+		return PTR_ERR(tspi->clk);
 	}
 
 	tspi->max_buf_size = SPI_FIFO_DEPTH << 2;
@@ -1152,8 +1149,6 @@ exit_rx_dma_free:
 	tegra_spi_deinit_dma_param(tspi, true);
 exit_free_irq:
 	free_irq(spi_irq, tspi);
-exit_free_master:
-	spi_master_put(master);
 	return ret;
 }
 
diff --git a/drivers/spi/spi-tegra20-sflash.c b/drivers/spi/spi-tegra20-sflash.c
index af78c17..1638036 100644
--- a/drivers/spi/spi-tegra20-sflash.c
+++ b/drivers/spi/spi-tegra20-sflash.c
@@ -458,7 +458,7 @@ static int tegra_sflash_probe(struct platform_device *pdev)
 		return -ENODEV;
 	}
 
-	master = spi_alloc_master(&pdev->dev, sizeof(*tsd));
+	master = devm_spi_alloc_master(&pdev->dev, sizeof(*tsd));
 	if (!master) {
 		dev_err(&pdev->dev, "master allocation failed\n");
 		return -ENOMEM;
@@ -482,10 +482,8 @@ static int tegra_sflash_probe(struct platform_device *pdev)
 
 	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	tsd->base = devm_ioremap_resource(&pdev->dev, r);
-	if (IS_ERR(tsd->base)) {
-		ret = PTR_ERR(tsd->base);
-		goto exit_free_master;
-	}
+	if (IS_ERR(tsd->base))
+		return PTR_ERR(tsd->base);
 
 	tsd->irq = platform_get_irq(pdev, 0);
 	ret = request_irq(tsd->irq, tegra_sflash_isr, 0,
@@ -493,7 +491,7 @@ static int tegra_sflash_probe(struct platform_device *pdev)
 	if (ret < 0) {
 		dev_err(&pdev->dev, "Failed to register ISR for IRQ %d\n",
 					tsd->irq);
-		goto exit_free_master;
+		return ret;
 	}
 
 	tsd->clk = devm_clk_get(&pdev->dev, NULL);
@@ -540,8 +538,6 @@ exit_pm_disable:
 		tegra_sflash_runtime_suspend(&pdev->dev);
 exit_free_irq:
 	free_irq(tsd->irq, tsd);
-exit_free_master:
-	spi_master_put(master);
 	return ret;
 }
 
diff --git a/drivers/spi/spi-tegra20-slink.c b/drivers/spi/spi-tegra20-slink.c
index 3ce1de8..65e3f0d 100644
--- a/drivers/spi/spi-tegra20-slink.c
+++ b/drivers/spi/spi-tegra20-slink.c
@@ -1045,7 +1045,7 @@ static int tegra_slink_probe(struct platform_device *pdev)
 	}
 	cdata = match->data;
 
-	master = spi_alloc_master(&pdev->dev, sizeof(*tspi));
+	master = devm_spi_alloc_master(&pdev->dev, sizeof(*tspi));
 	if (!master) {
 		dev_err(&pdev->dev, "master allocation failed\n");
 		return -ENOMEM;
@@ -1073,15 +1073,12 @@ static int tegra_slink_probe(struct platform_device *pdev)
 	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (!r) {
 		dev_err(&pdev->dev, "No IO memory resource\n");
-		ret = -ENODEV;
-		goto exit_free_master;
+		return -ENODEV;
 	}
 	tspi->phys = r->start;
 	tspi->base = devm_ioremap_resource(&pdev->dev, r);
-	if (IS_ERR(tspi->base)) {
-		ret = PTR_ERR(tspi->base);
-		goto exit_free_master;
-	}
+	if (IS_ERR(tspi->base))
+		return PTR_ERR(tspi->base);
 
 	spi_irq = platform_get_irq(pdev, 0);
 	tspi->irq = spi_irq;
@@ -1091,7 +1088,7 @@ static int tegra_slink_probe(struct platform_device *pdev)
 	if (ret < 0) {
 		dev_err(&pdev->dev, "Failed to register ISR for IRQ %d\n",
 					tspi->irq);
-		goto exit_free_master;
+		return ret;
 	}
 
 	tspi->clk = devm_clk_get(&pdev->dev, NULL);
@@ -1158,8 +1155,6 @@ exit_rx_dma_free:
 	tegra_slink_deinit_dma_param(tspi, true);
 exit_free_irq:
 	free_irq(spi_irq, tspi);
-exit_free_master:
-	spi_master_put(master);
 	return ret;
 }
 
diff --git a/drivers/spi/spi-ti-qspi.c b/drivers/spi/spi-ti-qspi.c
index 3d09265..61807ef 100644
--- a/drivers/spi/spi-ti-qspi.c
+++ b/drivers/spi/spi-ti-qspi.c
@@ -423,7 +423,7 @@ static int ti_qspi_probe(struct platform_device *pdev)
 	u32 max_freq;
 	int ret = 0, num_cs, irq;
 
-	master = spi_alloc_master(&pdev->dev, sizeof(*qspi));
+	master = devm_spi_alloc_master(&pdev->dev, sizeof(*qspi));
 	if (!master)
 		return -ENOMEM;
 
@@ -484,26 +484,20 @@ static int ti_qspi_probe(struct platform_device *pdev)
 	mutex_init(&qspi->list_lock);
 
 	qspi->base = devm_ioremap_resource(&pdev->dev, r);
-	if (IS_ERR(qspi->base)) {
-		ret = PTR_ERR(qspi->base);
-		goto free_master;
-	}
+	if (IS_ERR(qspi->base))
+		return PTR_ERR(qspi->base);
 
 	if (res_ctrl) {
 		qspi->ctrl_mod = true;
 		qspi->ctrl_base = devm_ioremap_resource(&pdev->dev, res_ctrl);
-		if (IS_ERR(qspi->ctrl_base)) {
-			ret = PTR_ERR(qspi->ctrl_base);
-			goto free_master;
-		}
+		if (IS_ERR(qspi->ctrl_base))
+			return PTR_ERR(qspi->ctrl_base);
 	}
 
 	if (res_mmap) {
 		qspi->mmap_base = devm_ioremap_resource(&pdev->dev, res_mmap);
-		if (IS_ERR(qspi->mmap_base)) {
-			ret = PTR_ERR(qspi->mmap_base);
-			goto free_master;
-		}
+		if (IS_ERR(qspi->mmap_base))
+			return PTR_ERR(qspi->mmap_base);
 	}
 
 	ret = devm_request_irq(&pdev->dev, irq, ti_qspi_isr, 0,
@@ -511,7 +505,7 @@ static int ti_qspi_probe(struct platform_device *pdev)
 	if (ret < 0) {
 		dev_err(&pdev->dev, "Failed to register ISR for IRQ %d\n",
 				irq);
-		goto free_master;
+		return ret;
 	}
 
 	qspi->fclk = devm_clk_get(&pdev->dev, "fck");
@@ -529,15 +523,7 @@ static int ti_qspi_probe(struct platform_device *pdev)
 	if (!of_property_read_u32(np, "spi-max-frequency", &max_freq))
 		qspi->spi_max_frequency = max_freq;
 
-	ret = devm_spi_register_master(&pdev->dev, master);
-	if (ret)
-		goto free_master;
-
-	return 0;
-
-free_master:
-	spi_master_put(master);
-	return ret;
+	return devm_spi_register_master(&pdev->dev, master);
 }
 
 static int ti_qspi_remove(struct platform_device *pdev)
diff --git a/drivers/spi/spi-txx9.c b/drivers/spi/spi-txx9.c
index 6191ced..76307b7 100644
--- a/drivers/spi/spi-txx9.c
+++ b/drivers/spi/spi-txx9.c
@@ -337,7 +337,7 @@ static int txx9spi_probe(struct platform_device *dev)
 	u32 mcr;
 	int irq;
 
-	master = spi_alloc_master(&dev->dev, sizeof(*c));
+	master = devm_spi_alloc_master(&dev->dev, sizeof(*c));
 	if (!master)
 		return ret;
 	c = spi_master_get_devdata(master);
@@ -416,7 +416,6 @@ exit:
 		destroy_workqueue(c->workqueue);
 	if (c->clk)
 		clk_disable(c->clk);
-	spi_master_put(master);
 	return ret;
 }
 
diff --git a/drivers/spi/spi-xcomm.c b/drivers/spi/spi-xcomm.c
index 24c40b1..094119d 100644
--- a/drivers/spi/spi-xcomm.c
+++ b/drivers/spi/spi-xcomm.c
@@ -216,7 +216,7 @@ static int spi_xcomm_probe(struct i2c_client *i2c,
 	struct spi_master *master;
 	int ret;
 
-	master = spi_alloc_master(&i2c->dev, sizeof(*spi_xcomm));
+	master = devm_spi_alloc_master(&i2c->dev, sizeof(*spi_xcomm));
 	if (!master)
 		return -ENOMEM;
 
@@ -231,11 +231,7 @@ static int spi_xcomm_probe(struct i2c_client *i2c,
 	master->dev.of_node = i2c->dev.of_node;
 	i2c_set_clientdata(i2c, master);
 
-	ret = devm_spi_register_master(&i2c->dev, master);
-	if (ret < 0)
-		spi_master_put(master);
-
-	return ret;
+	return devm_spi_register_master(&i2c->dev, master);
 }
 
 static const struct i2c_device_id spi_xcomm_ids[] = {
-- 
1.8.4.2

