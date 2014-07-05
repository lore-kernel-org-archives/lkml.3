Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756351AbaGEFBt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2014 01:01:49 -0400
Received: from seketeli.net ([94.23.218.202]:45777 "EHLO ms.seketeli.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751430AbaGEFBc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2014 01:01:32 -0400
From: Apelete Seketeli <apelete@seketeli.net>
To: Chris Ball <chris@printf.net>, Ulf Hansson <ulf.hansson@linaro.org>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
        Alex Smith <alex.smith@imgtec.com>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        linux-mmc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] mmc: jz4740: add dma infrastructure for data transfers
Date: Sat,  5 Jul 2014 06:56:29 +0200
Message-Id: <1404536189-7829-2-git-send-email-apelete@seketeli.net>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1404536189-7829-1-git-send-email-apelete@seketeli.net>
References: <1404536189-7829-1-git-send-email-apelete@seketeli.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Until now the MMC driver for JZ4740 SoC was relying on PIO mode only
for data transfers.
This patch allows the use of DMA for data trasnfers in addition to PIO
mode by relying on DMA Engine.

DMA tranfers performance might be further improved by taking advantage
of the asynchronous request capability of the MMC framework.

Signed-off-by: Apelete Seketeli <apelete@seketeli.net>
---
 drivers/mmc/host/jz4740_mmc.c |  173 +++++++++++++++++++++++++++++++++++++++--
 1 file changed, 165 insertions(+), 8 deletions(-)

diff --git a/drivers/mmc/host/jz4740_mmc.c b/drivers/mmc/host/jz4740_mmc.c
index 537d6c7..28393dc 100644
--- a/drivers/mmc/host/jz4740_mmc.c
+++ b/drivers/mmc/host/jz4740_mmc.c
@@ -30,7 +30,9 @@
 #include <asm/mach-jz4740/gpio.h>
 #include <asm/cacheflush.h>
 #include <linux/dma-mapping.h>
+#include <linux/dmaengine.h>
 
+#include <asm/mach-jz4740/dma.h>
 #include <asm/mach-jz4740/jz4740_mmc.h>
 
 #define JZ_REG_MMC_STRPCL	0x00
@@ -122,6 +124,7 @@ struct jz4740_mmc_host {
 	int card_detect_irq;
 
 	void __iomem *base;
+	struct resource *mem_res;
 	struct mmc_request *req;
 	struct mmc_command *cmd;
 
@@ -136,8 +139,132 @@ struct jz4740_mmc_host {
 	struct timer_list timeout_timer;
 	struct sg_mapping_iter miter;
 	enum jz4740_mmc_state state;
+
+	/* DMA support */
+	struct dma_chan *dma_rx;
+	struct dma_chan *dma_tx;
+	unsigned int sg_len;
+	bool use_dma;
+
+/* The DMA trigger level is 8 words, that is to say, the DMA read
+ * trigger is when data words in MSC_RXFIFO is >= 8 and the DMA write
+ * trigger is when data words in MSC_TXFIFO is < 8.
+ */
+#define JZ4740_MMC_FIFO_HALF_SIZE 8
 };
 
+/*----------------------------------------------------------------------------*/
+/* DMA infrastructure */
+
+static void jz4740_release_dma_channels(struct jz4740_mmc_host *host)
+{
+	if (!host->use_dma)
+		return;
+
+	dma_release_channel(host->dma_tx);
+	dma_release_channel(host->dma_rx);
+}
+
+static int jz4740_acquire_dma_channels(struct jz4740_mmc_host *host)
+{
+	dma_cap_mask_t mask;
+
+	dma_cap_zero(mask);
+	dma_cap_set(DMA_SLAVE, mask);
+
+	host->dma_tx = dma_request_channel(mask, NULL, host);
+	if (!host->dma_tx) {
+		dev_err(mmc_dev(host->mmc), "Failed to get dma_tx channel\n");
+		return -ENODEV;
+	}
+
+	host->dma_rx = dma_request_channel(mask, NULL, host);
+	if (!host->dma_rx) {
+		dev_err(mmc_dev(host->mmc), "Failed to get dma_rx channel\n");
+		goto free_master_write;
+	}
+
+	return 0;
+
+free_master_write:
+	dma_release_channel(host->dma_tx);
+	return -ENODEV;
+}
+
+static inline int jz4740_get_dma_dir(struct mmc_data *data)
+{
+	return (data->flags & MMC_DATA_READ) ? DMA_FROM_DEVICE : DMA_TO_DEVICE;
+}
+
+static void jz4740_dma_unmap(struct jz4740_mmc_host *host,
+			     struct mmc_data *data)
+{
+	enum dma_data_direction dir = jz4740_get_dma_dir(data);
+
+	dma_unmap_sg(mmc_dev(host->mmc), data->sg, data->sg_len, dir);
+}
+
+static int jz4740_start_dma_transfer(struct jz4740_mmc_host *host,
+				     struct mmc_data *data)
+{
+	struct dma_chan *chan;
+	struct dma_async_tx_descriptor *desc;
+	struct dma_slave_config conf = {
+		.src_addr_width = DMA_SLAVE_BUSWIDTH_4_BYTES,
+		.dst_addr_width = DMA_SLAVE_BUSWIDTH_4_BYTES,
+		.src_maxburst = JZ4740_MMC_FIFO_HALF_SIZE,
+		.dst_maxburst = JZ4740_MMC_FIFO_HALF_SIZE,
+	};
+	enum dma_data_direction dir = jz4740_get_dma_dir(data);
+
+	host->sg_len = dma_map_sg(mmc_dev(host->mmc),
+				  data->sg,
+				  data->sg_len,
+				  dir);
+
+	if (host->sg_len < 0) {
+		dev_err(mmc_dev(host->mmc),
+			 "Failed to map scatterlist for DMA operation\n");
+		return -EINVAL;
+	}
+
+	if (dir == DMA_TO_DEVICE) {
+		conf.direction = DMA_MEM_TO_DEV;
+		conf.dst_addr = host->mem_res->start + JZ_REG_MMC_TXFIFO;
+		conf.slave_id = JZ4740_DMA_TYPE_MMC_TRANSMIT;
+		chan = host->dma_tx;
+	} else {
+		conf.direction = DMA_DEV_TO_MEM;
+		conf.src_addr = host->mem_res->start + JZ_REG_MMC_RXFIFO;
+		conf.slave_id = JZ4740_DMA_TYPE_MMC_RECEIVE;
+		chan = host->dma_rx;
+	}
+
+	dmaengine_slave_config(chan, &conf);
+	desc = dmaengine_prep_slave_sg(chan,
+				       data->sg,
+				       host->sg_len,
+				       conf.direction,
+				       DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
+	if (!desc) {
+		dev_err(mmc_dev(host->mmc),
+			 "Failed to allocate DMA %s descriptor",
+			 conf.direction == DMA_MEM_TO_DEV ? "TX" : "RX");
+		goto dma_unmap;
+	}
+
+	dmaengine_submit(desc);
+	dma_async_issue_pending(chan);
+
+	return 0;
+
+dma_unmap:
+	jz4740_dma_unmap(host, data);
+	return -ENOMEM;
+}
+
+/*----------------------------------------------------------------------------*/
+
 static void jz4740_mmc_set_irq_enabled(struct jz4740_mmc_host *host,
 	unsigned int irq, bool enabled)
 {
@@ -442,6 +569,8 @@ static void jz4740_mmc_send_command(struct jz4740_mmc_host *host,
 			cmdat |= JZ_MMC_CMDAT_WRITE;
 		if (cmd->data->flags & MMC_DATA_STREAM)
 			cmdat |= JZ_MMC_CMDAT_STREAM;
+		if (host->use_dma)
+			cmdat |= JZ_MMC_CMDAT_DMA_EN;
 
 		writew(cmd->data->blksz, host->base + JZ_REG_MMC_BLKLEN);
 		writew(cmd->data->blocks, host->base + JZ_REG_MMC_NOB);
@@ -465,6 +594,7 @@ static void jz_mmc_prepare_data_transfer(struct jz4740_mmc_host *host)
 	else
 		direction = SG_MITER_FROM_SG;
 
+
 	sg_miter_start(&host->miter, data->sg, data->sg_len, direction);
 }
 
@@ -474,6 +604,7 @@ static irqreturn_t jz_mmc_irq_worker(int irq, void *devid)
 	struct jz4740_mmc_host *host = (struct jz4740_mmc_host *)devid;
 	struct mmc_command *cmd = host->req->cmd;
 	struct mmc_request *req = host->req;
+	struct mmc_data *data = cmd->data;
 	bool timeout = false;
 
 	if (cmd->error)
@@ -484,23 +615,32 @@ static irqreturn_t jz_mmc_irq_worker(int irq, void *devid)
 		if (cmd->flags & MMC_RSP_PRESENT)
 			jz4740_mmc_read_response(host, cmd);
 
-		if (!cmd->data)
+		if (!data)
 			break;
 
 		jz_mmc_prepare_data_transfer(host);
 
 	case JZ4740_MMC_STATE_TRANSFER_DATA:
-		if (cmd->data->flags & MMC_DATA_READ)
-			timeout = jz4740_mmc_read_data(host, cmd->data);
+		if (host->use_dma) {
+			/* Use DMA if enabled, data transfer direction was
+			 * defined  before in jz_mmc_prepare_data_transfer().
+			 */
+			timeout = jz4740_start_dma_transfer(host, data);
+			data->bytes_xfered = data->blocks * data->blksz;
+		} else if (data->flags & MMC_DATA_READ)
+			/* If DMA is not enabled, rely on data flags
+			 * to establish data transfer direction.
+			 */
+			timeout = jz4740_mmc_read_data(host, data);
 		else
-			timeout = jz4740_mmc_write_data(host, cmd->data);
+			timeout = jz4740_mmc_write_data(host, data);
 
 		if (unlikely(timeout)) {
 			host->state = JZ4740_MMC_STATE_TRANSFER_DATA;
 			break;
 		}
 
-		jz4740_mmc_transfer_check_state(host, cmd->data);
+		jz4740_mmc_transfer_check_state(host, data);
 
 		timeout = jz4740_mmc_poll_irq(host, JZ_MMC_IRQ_DATA_TRAN_DONE);
 		if (unlikely(timeout)) {
@@ -757,7 +897,6 @@ static int jz4740_mmc_probe(struct platform_device* pdev)
 	struct mmc_host *mmc;
 	struct jz4740_mmc_host *host;
 	struct jz4740_mmc_platform_data *pdata;
-	struct resource *res;
 
 	pdata = pdev->dev.platform_data;
 
@@ -784,10 +923,17 @@ static int jz4740_mmc_probe(struct platform_device* pdev)
 		goto err_free_host;
 	}
 
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	host->base = devm_ioremap_resource(&pdev->dev, res);
+	host->mem_res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!host->mem_res) {
+		ret = -EBUSY;
+		dev_err(&pdev->dev, "Failed to request memory region\n");
+		goto err_free_host;
+	}
+
+	host->base = devm_ioremap_resource(&pdev->dev, host->mem_res);
 	if (IS_ERR(host->base)) {
 		ret = PTR_ERR(host->base);
+		dev_err(&pdev->dev, "Failed to ioremap base memory\n");
 		goto err_free_host;
 	}
 
@@ -834,6 +980,10 @@ static int jz4740_mmc_probe(struct platform_device* pdev)
 	/* It is not important when it times out, it just needs to timeout. */
 	set_timer_slack(&host->timeout_timer, HZ);
 
+	host->use_dma = true;
+	if (host->use_dma && jz4740_acquire_dma_channels(host) != 0)
+		host->use_dma = false;
+
 	platform_set_drvdata(pdev, host);
 	ret = mmc_add_host(mmc);
 
@@ -843,6 +993,10 @@ static int jz4740_mmc_probe(struct platform_device* pdev)
 	}
 	dev_info(&pdev->dev, "JZ SD/MMC card driver registered\n");
 
+	dev_info(&pdev->dev, "Using %s, %d-bit mode\n",
+		 host->use_dma ? "DMA" : "PIO",
+		 (mmc->caps & MMC_CAP_4_BIT_DATA) ? 4 : 1);
+
 	return 0;
 
 err_free_irq:
@@ -850,6 +1004,8 @@ err_free_irq:
 err_free_gpios:
 	jz4740_mmc_free_gpios(pdev);
 err_gpio_bulk_free:
+	if (host->use_dma)
+		jz4740_release_dma_channels(host);
 	jz_gpio_bulk_free(jz4740_mmc_pins, jz4740_mmc_num_pins(host));
 err_free_host:
 	mmc_free_host(mmc);
@@ -871,6 +1027,7 @@ static int jz4740_mmc_remove(struct platform_device *pdev)
 
 	jz4740_mmc_free_gpios(pdev);
 	jz_gpio_bulk_free(jz4740_mmc_pins, jz4740_mmc_num_pins(host));
+	jz4740_release_dma_channels(host);
 
 	mmc_free_host(host->mmc);
 
-- 
1.7.10.4

