Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937695Ab3DKAJZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 20:09:25 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:64943 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937610Ab3DKAHD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 20:07:03 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Kukjin Kim <kgene.kim@samsung.com>,
        linux-samsung-soc@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        spi-devel-general@lists.sourceforge.net,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Padma Venkat <padma.kvr@gmail.com>
Subject: [PATCH 29/30] spi: s3c64xx: move to generic dmaengine API
Date: Thu, 11 Apr 2013 02:05:11 +0200
Message-Id: <1365638712-1028578-30-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1365638712-1028578-1-git-send-email-arnd@arndb.de>
References: <1365638712-1028578-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:tsbRODUCjvhj438tP49waMdurWQVKE1PZoETQERPMrf
 ERUMkUl51ydgdQKhiTMjbDTHaU5qsjPycDEQMY4FJsPvJx5yuC
 VFozL8olMGt621dpbBTn78SOejIttjtKh9jJKuT39zrg/jjfte
 7at/LQoymOHIzLjKIIBUbtrlZ21WZW7EF8IMAjXbyRrlYqnX5o
 E3zzFEH212eDbs1k0/i0mezRYwbzFTWYpj67uH7wx3hGVVgLXK
 P6zxU965Cc98031HMXP6YW9FJkcAkfyQDqT7ztLrKg8E7RycaG
 25n9uaen5LdVDdj/TcSlfL+1kllqHg+zhIW/l7WCucm3MuqYED
 ZLWfVUInlmE7fSTIR5sfJv163EkCh3VDOCJE87DVkUlJ1Xto66
 406MCUzhvFPrw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The spi-s3c64xx uses a Samsung proprietary interface for
talking to the DMA engine, which does not work with
multiplatform kernels.

This version of the patch leaves the old code in place,
behind an #ifdef. This can be removed in the future,
after the s3c64xx platform start supporting the regular
dmaengine interface. An earlier version of this patch was
tested successfully on exynos5250 by Padma Venkat.

The conversion was rather mechanical, since the samsung
interface is just a shallow wrapper around the dmaengine
interface.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: spi-devel-general@lists.sourceforge.net
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Padma Venkat <padma.kvr@gmail.com>
---
 arch/arm/plat-samsung/devs.c              |  10 ++
 drivers/spi/spi-s3c64xx.c                 | 185 +++++++++++++++++++++++-------
 include/linux/platform_data/spi-s3c64xx.h |   3 +
 3 files changed, 154 insertions(+), 44 deletions(-)

diff --git a/arch/arm/plat-samsung/devs.c b/arch/arm/plat-samsung/devs.c
index b441908..30c2fe2 100644
--- a/arch/arm/plat-samsung/devs.c
+++ b/arch/arm/plat-samsung/devs.c
@@ -10,6 +10,7 @@
  * published by the Free Software Foundation.
 */
 
+#include <linux/amba/pl330.h>
 #include <linux/kernel.h>
 #include <linux/types.h>
 #include <linux/interrupt.h>
@@ -1512,6 +1513,9 @@ void __init s3c64xx_spi0_set_platdata(int (*cfg_gpio)(void), int src_clk_nr,
 	pd.num_cs = num_cs;
 	pd.src_clk_nr = src_clk_nr;
 	pd.cfg_gpio = (cfg_gpio) ? cfg_gpio : s3c64xx_spi0_cfg_gpio;
+#ifdef CONFIG_PL330_DMA
+	pd.filter = pl330_filter;
+#endif
 
 	s3c_set_platdata(&pd, sizeof(pd), &s3c64xx_device_spi0);
 }
@@ -1550,6 +1554,9 @@ void __init s3c64xx_spi1_set_platdata(int (*cfg_gpio)(void), int src_clk_nr,
 	pd.num_cs = num_cs;
 	pd.src_clk_nr = src_clk_nr;
 	pd.cfg_gpio = (cfg_gpio) ? cfg_gpio : s3c64xx_spi1_cfg_gpio;
+#ifdef CONFIG_PL330_DMA
+	pd.filter = pl330_filter;
+#endif
 
 	s3c_set_platdata(&pd, sizeof(pd), &s3c64xx_device_spi1);
 }
@@ -1588,6 +1595,9 @@ void __init s3c64xx_spi2_set_platdata(int (*cfg_gpio)(void), int src_clk_nr,
 	pd.num_cs = num_cs;
 	pd.src_clk_nr = src_clk_nr;
 	pd.cfg_gpio = (cfg_gpio) ? cfg_gpio : s3c64xx_spi2_cfg_gpio;
+#ifdef CONFIG_PL330_DMA
+	pd.filter = pl330_filter;
+#endif
 
 	s3c_set_platdata(&pd, sizeof(pd), &s3c64xx_device_spi2);
 }
diff --git a/drivers/spi/spi-s3c64xx.c b/drivers/spi/spi-s3c64xx.c
index 4188b2f..74809af 100644
--- a/drivers/spi/spi-s3c64xx.c
+++ b/drivers/spi/spi-s3c64xx.c
@@ -24,6 +24,7 @@
 #include <linux/delay.h>
 #include <linux/clk.h>
 #include <linux/dma-mapping.h>
+#include <linux/dmaengine.h>
 #include <linux/platform_device.h>
 #include <linux/pm_runtime.h>
 #include <linux/spi/spi.h>
@@ -31,9 +32,12 @@
 #include <linux/of.h>
 #include <linux/of_gpio.h>
 
-#include <mach/dma.h>
 #include <linux/platform_data/spi-s3c64xx.h>
 
+#ifdef CONFIG_SAMSUNG_DMADEV
+#include <mach/dma.h>
+#endif
+
 #define MAX_SPI_PORTS		3
 
 /* Registers and bit-fields */
@@ -131,9 +135,9 @@
 #define TXBUSY    (1<<3)
 
 struct s3c64xx_spi_dma_data {
-	unsigned		ch;
+	struct dma_chan *ch;
 	enum dma_transfer_direction direction;
-	enum dma_ch	dmach;
+	unsigned int dmach;
 };
 
 /**
@@ -195,16 +199,14 @@ struct s3c64xx_spi_driver_data {
 	unsigned                        cur_speed;
 	struct s3c64xx_spi_dma_data	rx_dma;
 	struct s3c64xx_spi_dma_data	tx_dma;
+#ifdef CONFIG_SAMSUNG_DMADEV
 	struct samsung_dma_ops		*ops;
+#endif
 	struct s3c64xx_spi_port_config	*port_conf;
 	unsigned int			port_id;
 	unsigned long			gpios[4];
 };
 
-static struct s3c2410_dma_client s3c64xx_spi_dma_client = {
-	.name = "samsung-spi-dma",
-};
-
 static void flush_fifo(struct s3c64xx_spi_driver_data *sdd)
 {
 	void __iomem *regs = sdd->regs;
@@ -281,6 +283,13 @@ static void s3c64xx_spi_dmacb(void *data)
 	spin_unlock_irqrestore(&sdd->lock, flags);
 }
 
+#ifdef CONFIG_SAMSUNG_DMADEV
+/* FIXME: remove this section once arch/arm/mach-s3c64xx uses dmaengine */
+
+static struct s3c2410_dma_client s3c64xx_spi_dma_client = {
+	.name = "samsung-spi-dma",
+};
+
 static void prepare_dma(struct s3c64xx_spi_dma_data *dma,
 					unsigned len, dma_addr_t buf)
 {
@@ -294,14 +303,14 @@ static void prepare_dma(struct s3c64xx_spi_dma_data *dma,
 		config.direction = sdd->rx_dma.direction;
 		config.fifo = sdd->sfr_start + S3C64XX_SPI_RX_DATA;
 		config.width = sdd->cur_bpw / 8;
-		sdd->ops->config(sdd->rx_dma.ch, &config);
+		sdd->ops->config((enum dma_ch)sdd->rx_dma.ch, &config);
 	} else {
 		sdd = container_of((void *)dma,
 			struct s3c64xx_spi_driver_data, tx_dma);
 		config.direction =  sdd->tx_dma.direction;
 		config.fifo = sdd->sfr_start + S3C64XX_SPI_TX_DATA;
 		config.width = sdd->cur_bpw / 8;
-		sdd->ops->config(sdd->tx_dma.ch, &config);
+		sdd->ops->config((enum dma_ch)sdd->tx_dma.ch, &config);
 	}
 
 	info.cap = DMA_SLAVE;
@@ -311,8 +320,8 @@ static void prepare_dma(struct s3c64xx_spi_dma_data *dma,
 	info.direction = dma->direction;
 	info.buf = buf;
 
-	sdd->ops->prepare(dma->ch, &info);
-	sdd->ops->trigger(dma->ch);
+	sdd->ops->prepare((enum dma_ch)dma->ch, &info);
+	sdd->ops->trigger((enum dma_ch)dma->ch);
 }
 
 static int acquire_dma(struct s3c64xx_spi_driver_data *sdd)
@@ -325,12 +334,126 @@ static int acquire_dma(struct s3c64xx_spi_driver_data *sdd)
 	req.cap = DMA_SLAVE;
 	req.client = &s3c64xx_spi_dma_client;
 
-	sdd->rx_dma.ch = sdd->ops->request(sdd->rx_dma.dmach, &req, dev, "rx");
-	sdd->tx_dma.ch = sdd->ops->request(sdd->tx_dma.dmach, &req, dev, "tx");
+	sdd->rx_dma.ch = (void *)sdd->ops->request(sdd->rx_dma.dmach, &req, dev, "rx");
+	sdd->tx_dma.ch = (void *)sdd->ops->request(sdd->tx_dma.dmach, &req, dev, "tx");
 
 	return 1;
 }
 
+static int s3c64xx_spi_prepare_transfer(struct spi_master *spi)
+{
+	struct s3c64xx_spi_driver_data *sdd = spi_master_get_devdata(spi);
+
+	/* Acquire DMA channels */
+	while (!acquire_dma(sdd))
+		usleep_range(10000, 11000);
+
+	pm_runtime_get_sync(&sdd->pdev->dev);
+
+	return 0;
+}
+
+static int s3c64xx_spi_unprepare_transfer(struct spi_master *spi)
+{
+	struct s3c64xx_spi_driver_data *sdd = spi_master_get_devdata(spi);
+
+	/* Free DMA channels */
+	sdd->ops->release((enum dma_ch)sdd->rx_dma.ch, &s3c64xx_spi_dma_client);
+	sdd->ops->release((enum dma_ch)sdd->tx_dma.ch, &s3c64xx_spi_dma_client);
+
+	pm_runtime_put(&sdd->pdev->dev);
+
+	return 0;
+}
+
+static void s3c64xx_spi_dma_stop(struct s3c64xx_spi_driver_data *sdd,
+				 struct s3c64xx_spi_dma_data *dma)
+{
+	sdd->ops->stop((enum dma_ch)dma->ch);
+}
+#else
+
+static void prepare_dma(struct s3c64xx_spi_dma_data *dma,
+					unsigned len, dma_addr_t buf)
+{
+	struct s3c64xx_spi_driver_data *sdd;
+	struct dma_slave_config config;
+	struct scatterlist sg;
+	struct dma_async_tx_descriptor *desc;
+
+	if (dma->direction == DMA_DEV_TO_MEM) {
+		sdd = container_of((void *)dma,
+			struct s3c64xx_spi_driver_data, rx_dma);
+		config.direction = dma->direction;
+		config.src_addr = sdd->sfr_start + S3C64XX_SPI_RX_DATA;
+		config.src_addr_width = sdd->cur_bpw / 8;
+		config.src_maxburst = 1;
+		dmaengine_slave_config(dma->ch, &config);
+	} else {
+		sdd = container_of((void *)dma,
+			struct s3c64xx_spi_driver_data, tx_dma);
+		config.direction = dma->direction;
+		config.dst_addr = sdd->sfr_start + S3C64XX_SPI_TX_DATA;
+		config.dst_addr_width = sdd->cur_bpw / 8;
+		config.dst_maxburst = 1;
+		dmaengine_slave_config(dma->ch, &config);
+	}
+
+	sg_init_table(&sg, 1);
+	sg_dma_len(&sg) = len;
+	sg_set_page(&sg, pfn_to_page(PFN_DOWN(buf)),
+		    len, offset_in_page(buf));
+	sg_dma_address(&sg) = buf;
+
+	desc = dmaengine_prep_slave_sg(dma->ch,
+		&sg, 1, dma->direction, DMA_PREP_INTERRUPT);
+
+	desc->callback = s3c64xx_spi_dmacb;
+	desc->callback_param = dma;
+
+	dmaengine_submit(desc);
+	dma_async_issue_pending(dma->ch);
+}
+
+static int s3c64xx_spi_prepare_transfer(struct spi_master *spi)
+{
+	struct s3c64xx_spi_driver_data *sdd = spi_master_get_devdata(spi);
+	dma_filter_fn filter = sdd->cntrlr_info->filter;
+	struct device *dev = &sdd->pdev->dev;
+	dma_cap_mask_t mask;
+
+	dma_cap_zero(mask);
+	dma_cap_set(DMA_SLAVE, mask);
+
+	/* Acquire DMA channels */
+	sdd->rx_dma.ch = dma_request_slave_channel_compat(mask, filter,
+				(void*)sdd->rx_dma.dmach, dev, "rx");
+	sdd->tx_dma.ch = dma_request_slave_channel_compat(mask, filter,
+				(void*)sdd->tx_dma.dmach, dev, "tx");
+	pm_runtime_get_sync(&sdd->pdev->dev);
+
+	return 0;
+}
+
+static int s3c64xx_spi_unprepare_transfer(struct spi_master *spi)
+{
+	struct s3c64xx_spi_driver_data *sdd = spi_master_get_devdata(spi);
+
+	/* Free DMA channels */
+	dma_release_channel(sdd->rx_dma.ch);
+	dma_release_channel(sdd->tx_dma.ch);
+
+	pm_runtime_put(&sdd->pdev->dev);
+	return 0;
+}
+
+static void s3c64xx_spi_dma_stop(struct s3c64xx_spi_driver_data *sdd,
+				 struct s3c64xx_spi_dma_data *dma)
+{
+	dmaengine_terminate_all(dma->ch);
+}
+#endif
+
 static void enable_datapath(struct s3c64xx_spi_driver_data *sdd,
 				struct spi_device *spi,
 				struct spi_transfer *xfer, int dma_mode)
@@ -713,9 +836,9 @@ static int s3c64xx_spi_transfer_one_message(struct spi_master *master,
 		}
 
 		/* Polling method for xfers not bigger than FIFO capacity */
-		if (xfer->len <= ((FIFO_LVL_MASK(sdd) >> 1) + 1))
-			use_dma = 0;
-		else
+		use_dma = 0;
+		if (sdd->rx_dma.ch && sdd->tx_dma.ch &&
+		    (xfer->len > ((FIFO_LVL_MASK(sdd) >> 1) + 1)))
 			use_dma = 1;
 
 		spin_lock_irqsave(&sdd->lock, flags);
@@ -750,10 +873,10 @@ static int s3c64xx_spi_transfer_one_message(struct spi_master *master,
 			if (use_dma) {
 				if (xfer->tx_buf != NULL
 						&& (sdd->state & TXBUSY))
-					sdd->ops->stop(sdd->tx_dma.ch);
+					s3c64xx_spi_dma_stop(sdd, &sdd->tx_dma);
 				if (xfer->rx_buf != NULL
 						&& (sdd->state & RXBUSY))
-					sdd->ops->stop(sdd->rx_dma.ch);
+					s3c64xx_spi_dma_stop(sdd, &sdd->rx_dma);
 			}
 
 			goto out;
@@ -790,32 +913,6 @@ out:
 	return 0;
 }
 
-static int s3c64xx_spi_prepare_transfer(struct spi_master *spi)
-{
-	struct s3c64xx_spi_driver_data *sdd = spi_master_get_devdata(spi);
-
-	/* Acquire DMA channels */
-	while (!acquire_dma(sdd))
-		usleep_range(10000, 11000);
-
-	pm_runtime_get_sync(&sdd->pdev->dev);
-
-	return 0;
-}
-
-static int s3c64xx_spi_unprepare_transfer(struct spi_master *spi)
-{
-	struct s3c64xx_spi_driver_data *sdd = spi_master_get_devdata(spi);
-
-	/* Free DMA channels */
-	sdd->ops->release(sdd->rx_dma.ch, &s3c64xx_spi_dma_client);
-	sdd->ops->release(sdd->tx_dma.ch, &s3c64xx_spi_dma_client);
-
-	pm_runtime_put(&sdd->pdev->dev);
-
-	return 0;
-}
-
 static struct s3c64xx_spi_csinfo *s3c64xx_get_slave_ctrldata(
 				struct s3c64xx_spi_driver_data *sdd,
 				struct spi_device *spi)
diff --git a/include/linux/platform_data/spi-s3c64xx.h b/include/linux/platform_data/spi-s3c64xx.h
index ceba18d..8447f63 100644
--- a/include/linux/platform_data/spi-s3c64xx.h
+++ b/include/linux/platform_data/spi-s3c64xx.h
@@ -11,6 +11,8 @@
 #ifndef __S3C64XX_PLAT_SPI_H
 #define __S3C64XX_PLAT_SPI_H
 
+#include <linux/dmaengine.h>
+
 struct platform_device;
 
 /**
@@ -38,6 +40,7 @@ struct s3c64xx_spi_info {
 	int src_clk_nr;
 	int num_cs;
 	int (*cfg_gpio)(void);
+	dma_filter_fn filter;
 };
 
 /**
-- 
1.8.1.2

