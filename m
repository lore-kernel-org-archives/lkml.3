Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752560AbaHWAHv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 20:07:51 -0400
Received: from mail-bl2lp0212.outbound.protection.outlook.com ([207.46.163.212]:2991
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752341AbaHWAHt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 20:07:49 -0400
From: Robin Gong <b38343@freescale.com>
To: <broonie@kernel.org>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-spi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <Frank.Li@freescale.com>,
        <shawn.guo@linaro.org>, <marex@denx.de>
Subject: [PATCH v4] spi: spi-imx: add DMA support
Date: Sat, 23 Aug 2014 08:13:55 +0800
Message-ID: <1408752835-10995-1-git-send-email-b38343@freescale.com>
X-Mailer: git-send-email 1.7.9.5
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(199003)(189002)(79102001)(107046002)(85306004)(46102001)(74662001)(89996001)(102836001)(31966008)(110136001)(74502001)(81542001)(90102001)(77982001)(104166001)(76482001)(4396001)(77156001)(50226001)(44976005)(48376002)(26826002)(64706001)(19580405001)(36756003)(92566001)(84676001)(92726001)(97736001)(83322001)(47776003)(21056001)(85852003)(99396002)(229853001)(80022001)(69596002)(81156004)(33646002)(83072002)(68736004)(50466002)(20776003)(62966002)(50986999)(2351001)(87286001)(88136002)(6806004)(106466001)(95666004)(81342001)(105606002)(93916002)(19580395003)(87936001)(104016003)(42262002);DIR:OUT;SFP:;SCL:1;SRVR:DM2PR03MB496;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 031257FE13
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=yibin.gong@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After enable DMA

spi-nor read speed is
dd if=/dev/mtd0 of=/dev/null bs=1M count=1
1+0 records in
1+0 records out
1048576 bytes (1.0 MB) copied, 0.720402 s, 1.5 MB/s

spi-nor write speed is
dd if=/dev/zero of=/dev/mtd0 bs=1M count=1
1+0 records in
1+0 records out
1048576 bytes (1.0 MB) copied, 3.56044 s, 295 kB/s

Before enable DMA

spi-nor read speed is
dd if=/dev/mtd0 of=/dev/null bs=1M count=1
1+0 records in
1+0 records out
1048576 bytes (1.0 MB) copied, 2.37717 s, 441 kB/s

spi-nor write speed is

dd if=/dev/zero of=/dev/mtd0 bs=1M count=1
1+0 records in
1+0 records out
1048576 bytes (1.0 MB) copied, 4.83181 s, 217 kB/s

Signed-off-by: Frank Li <Frank.Li@freescale.com>
Signed-off-by: Robin Gong <b38343@freescale.com>
---
 drivers/spi/spi-imx.c |  303 ++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 297 insertions(+), 6 deletions(-)

diff --git a/drivers/spi/spi-imx.c b/drivers/spi/spi-imx.c
index 5daff20..d8e5817 100644
--- a/drivers/spi/spi-imx.c
+++ b/drivers/spi/spi-imx.c
@@ -21,6 +21,8 @@
 #include <linux/clk.h>
 #include <linux/completion.h>
 #include <linux/delay.h>
+#include <linux/dmaengine.h>
+#include <linux/dma-mapping.h>
 #include <linux/err.h>
 #include <linux/gpio.h>
 #include <linux/interrupt.h>
@@ -37,6 +39,7 @@
 #include <linux/of_device.h>
 #include <linux/of_gpio.h>
 
+#include <linux/platform_data/dma-imx.h>
 #include <linux/platform_data/spi-imx.h>
 
 #define DRIVER_NAME "spi_imx"
@@ -51,6 +54,9 @@
 #define MXC_INT_RR	(1 << 0) /* Receive data ready interrupt */
 #define MXC_INT_TE	(1 << 1) /* Transmit FIFO empty interrupt */
 
+/* The maximum  bytes that a sdma BD can transfer.*/
+#define MAX_SDMA_BD_BYTES  (1 << 15)
+#define IMX_DMA_TIMEOUT (msecs_to_jiffies(3000))
 struct spi_imx_config {
 	unsigned int speed_hz;
 	unsigned int bpw;
@@ -97,6 +103,15 @@ struct spi_imx_data {
 
 	const struct spi_imx_devtype_data *devtype_data;
 	int chipselect[0];
+	/* DMA */
+	unsigned int dma_is_inited;
+	unsigned int dma_finished;
+	bool usedma;
+	u32 rx_wml;
+	u32 tx_wml;
+	u32 rxt_wml;
+	struct completion dma_rx_completion;
+	struct completion dma_tx_completion;
 };
 
 static inline int is_imx27_cspi(struct spi_imx_data *d)
@@ -181,9 +196,24 @@ static unsigned int spi_imx_clkdiv_2(unsigned int fin,
 	return 7;
 }
 
+static bool spi_imx_can_dma(struct spi_master *master, struct spi_device *spi,
+			 struct spi_transfer *transfer)
+{
+	struct spi_imx_data *spi_imx = spi_master_get_devdata(master);
+
+	if (spi_imx->dma_is_inited && (transfer->len > spi_imx->rx_wml)
+	    && (transfer->len > spi_imx->tx_wml))
+		spi_imx->usedma = true;
+	else
+		spi_imx->usedma = false;
+
+	return spi_imx->usedma;
+}
+
 #define MX51_ECSPI_CTRL		0x08
 #define MX51_ECSPI_CTRL_ENABLE		(1 <<  0)
 #define MX51_ECSPI_CTRL_XCH		(1 <<  2)
+#define MX51_ECSPI_CTRL_SMC		(1 << 3)
 #define MX51_ECSPI_CTRL_MODE_MASK	(0xf << 4)
 #define MX51_ECSPI_CTRL_POSTDIV_OFFSET	8
 #define MX51_ECSPI_CTRL_PREDIV_OFFSET	12
@@ -201,6 +231,18 @@ static unsigned int spi_imx_clkdiv_2(unsigned int fin,
 #define MX51_ECSPI_INT_TEEN		(1 <<  0)
 #define MX51_ECSPI_INT_RREN		(1 <<  3)
 
+#define MX51_ECSPI_DMA      0x14
+#define MX51_ECSPI_DMA_TX_WML_OFFSET	0
+#define MX51_ECSPI_DMA_TX_WML_MASK	0x3F
+#define MX51_ECSPI_DMA_RX_WML_OFFSET	16
+#define MX51_ECSPI_DMA_RX_WML_MASK	(0x3F << 16)
+#define MX51_ECSPI_DMA_RXT_WML_OFFSET	24
+#define MX51_ECSPI_DMA_RXT_WML_MASK	(0x3F << 24)
+
+#define MX51_ECSPI_DMA_TEDEN_OFFSET	7
+#define MX51_ECSPI_DMA_RXDEN_OFFSET	23
+#define MX51_ECSPI_DMA_RXTDEN_OFFSET	31
+
 #define MX51_ECSPI_STAT		0x18
 #define MX51_ECSPI_STAT_RR		(1 <<  3)
 
@@ -257,17 +299,22 @@ static void __maybe_unused mx51_ecspi_intctrl(struct spi_imx_data *spi_imx, int
 
 static void __maybe_unused mx51_ecspi_trigger(struct spi_imx_data *spi_imx)
 {
-	u32 reg;
-
-	reg = readl(spi_imx->base + MX51_ECSPI_CTRL);
-	reg |= MX51_ECSPI_CTRL_XCH;
+	u32 reg = readl(spi_imx->base + MX51_ECSPI_CTRL);
+
+	if (!spi_imx->usedma)
+		reg |= MX51_ECSPI_CTRL_XCH;
+	else if (!spi_imx->dma_finished)
+		reg |= MX51_ECSPI_CTRL_SMC;
+	else
+		reg &= ~MX51_ECSPI_CTRL_SMC;
 	writel(reg, spi_imx->base + MX51_ECSPI_CTRL);
 }
 
 static int __maybe_unused mx51_ecspi_config(struct spi_imx_data *spi_imx,
 		struct spi_imx_config *config)
 {
-	u32 ctrl = MX51_ECSPI_CTRL_ENABLE, cfg = 0;
+	u32 ctrl = MX51_ECSPI_CTRL_ENABLE, cfg = 0, dma = 0;
+	u32 tx_wml_cfg, rx_wml_cfg, rxt_wml_cfg;
 	u32 clk = config->speed_hz, delay;
 
 	/*
@@ -319,6 +366,30 @@ static int __maybe_unused mx51_ecspi_config(struct spi_imx_data *spi_imx,
 	else			/* SCLK is _very_ slow */
 		usleep_range(delay, delay + 10);
 
+	/*
+	 * Configure the DMA register: setup the watermark
+	 * and enable DMA request.
+	 */
+	if (spi_imx->dma_is_inited) {
+		dma = readl(spi_imx->base + MX51_ECSPI_DMA);
+
+		spi_imx->tx_wml = spi_imx_get_fifosize(spi_imx) / 2;
+		spi_imx->rx_wml = spi_imx_get_fifosize(spi_imx) / 2;
+		spi_imx->rxt_wml = spi_imx_get_fifosize(spi_imx) / 2;
+		rx_wml_cfg = spi_imx->rx_wml << MX51_ECSPI_DMA_RX_WML_OFFSET;
+		tx_wml_cfg = spi_imx->tx_wml << MX51_ECSPI_DMA_TX_WML_OFFSET;
+		rxt_wml_cfg = spi_imx->rxt_wml << MX51_ECSPI_DMA_RXT_WML_OFFSET;
+		dma = (dma & ~MX51_ECSPI_DMA_TX_WML_MASK
+				& ~MX51_ECSPI_DMA_RX_WML_MASK
+				& ~MX51_ECSPI_DMA_RXT_WML_MASK)
+				| rx_wml_cfg | tx_wml_cfg | rxt_wml_cfg
+				|(1 << MX51_ECSPI_DMA_TEDEN_OFFSET)
+				|(1 << MX51_ECSPI_DMA_RXDEN_OFFSET)
+				|(1 << MX51_ECSPI_DMA_RXTDEN_OFFSET);
+
+		writel(dma, spi_imx->base + MX51_ECSPI_DMA);
+	}
+
 	return 0;
 }
 
@@ -730,7 +801,203 @@ static int spi_imx_setupxfer(struct spi_device *spi,
 	return 0;
 }
 
-static int spi_imx_transfer(struct spi_device *spi,
+static void spi_imx_sdma_exit(struct spi_imx_data *spi_imx)
+{
+	struct spi_master *master = spi_imx->bitbang.master;
+
+	if (master->dma_rx) {
+		dma_release_channel(master->dma_rx);
+		master->dma_rx = NULL;
+	}
+
+	if (master->dma_tx) {
+		dma_release_channel(master->dma_tx);
+		master->dma_tx = NULL;
+	}
+
+	spi_imx->dma_is_inited = 0;
+}
+
+static int spi_imx_sdma_init(struct device *dev, struct spi_imx_data *spi_imx,
+			     struct spi_master *master,
+			     const struct resource *res)
+{
+	struct dma_slave_config slave_config = {};
+	int ret;
+
+	/* Prepare for TX DMA: */
+	master->dma_tx = dma_request_slave_channel(dev, "tx");
+	if (!master->dma_tx) {
+		dev_err(dev, "cannot get the TX DMA channel!\n");
+		ret = -EINVAL;
+		goto err;
+	}
+
+	slave_config.direction = DMA_MEM_TO_DEV;
+	slave_config.dst_addr = res->start + MXC_CSPITXDATA;
+	slave_config.dst_addr_width = DMA_SLAVE_BUSWIDTH_1_BYTE;
+	slave_config.dst_maxburst = spi_imx_get_fifosize(spi_imx) / 2;
+	ret = dmaengine_slave_config(master->dma_tx, &slave_config);
+	if (ret) {
+		dev_err(dev, "error in TX dma configuration.");
+		goto err;
+	}
+
+	/* Prepare for RX : */
+	master->dma_rx = dma_request_slave_channel(dev, "rx");
+	if (!master->dma_rx) {
+		dev_dbg(dev, "cannot get the DMA channel.\n");
+		ret = -EINVAL;
+		goto err;
+	}
+
+	slave_config.direction = DMA_DEV_TO_MEM;
+	slave_config.src_addr = res->start + MXC_CSPIRXDATA;
+	slave_config.src_addr_width = DMA_SLAVE_BUSWIDTH_1_BYTE;
+	slave_config.src_maxburst = spi_imx_get_fifosize(spi_imx) / 2;
+	ret = dmaengine_slave_config(master->dma_rx, &slave_config);
+	if (ret) {
+		dev_err(dev, "error in RX dma configuration.\n");
+		goto err;
+	}
+
+	init_completion(&spi_imx->dma_rx_completion);
+	init_completion(&spi_imx->dma_tx_completion);
+	master->can_dma = spi_imx_can_dma;
+	master->max_dma_len = MAX_SDMA_BD_BYTES;
+	spi_imx->bitbang.master->flags = SPI_MASTER_MUST_RX |
+					 SPI_MASTER_MUST_TX;
+	spi_imx->dma_is_inited = 1;
+
+	return 0;
+err:
+	spi_imx_sdma_exit(spi_imx);
+	return ret;
+}
+
+static void spi_imx_dma_rx_callback(void *cookie)
+{
+	struct spi_imx_data *spi_imx = (struct spi_imx_data *)cookie;
+
+	complete(&spi_imx->dma_rx_completion);
+}
+
+static void spi_imx_dma_tx_callback(void *cookie)
+{
+	struct spi_imx_data *spi_imx = (struct spi_imx_data *)cookie;
+
+	complete(&spi_imx->dma_tx_completion);
+}
+
+static int spi_imx_dma_transfer(struct spi_imx_data *spi_imx,
+				struct spi_transfer *transfer)
+{
+	struct dma_async_tx_descriptor *desc_tx = NULL, *desc_rx = NULL;
+	int ret;
+	u32 dma;
+	int left;
+	struct spi_master *master = spi_imx->bitbang.master;
+	struct sg_table *tx = &transfer->tx_sg, *rx = &transfer->rx_sg;
+
+	if (tx) {
+		desc_tx = dmaengine_prep_slave_sg(master->dma_tx,
+					tx->sgl, tx->nents, DMA_TO_DEVICE,
+					DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
+		if (!desc_tx)
+			goto no_dma;
+
+		desc_tx->callback = spi_imx_dma_tx_callback;
+		desc_tx->callback_param = (void *)spi_imx;
+		dmaengine_submit(desc_tx);
+	}
+
+	if (rx) {
+		desc_rx = dmaengine_prep_slave_sg(master->dma_rx,
+					rx->sgl, rx->nents, DMA_FROM_DEVICE,
+					DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
+		if (!desc_rx)
+			goto no_dma;
+
+		desc_rx->callback = spi_imx_dma_rx_callback;
+		desc_rx->callback_param = (void *)spi_imx;
+		dmaengine_submit(desc_rx);
+	}
+
+	reinit_completion(&spi_imx->dma_rx_completion);
+	reinit_completion(&spi_imx->dma_tx_completion);
+
+	/* Trigger the cspi module. */
+	spi_imx->dma_finished = 0;
+
+	spi_imx->devtype_data->trigger(spi_imx);
+
+	dma_async_issue_pending(master->dma_tx);
+	dma_async_issue_pending(master->dma_rx);
+	/* Wait SDMA to finish the data transfer.*/
+	ret = wait_for_completion_timeout(&spi_imx->dma_tx_completion,
+						IMX_DMA_TIMEOUT);
+	if (!ret) {
+		pr_warn("%s %s: I/O Error in DMA TX\n",
+			dev_driver_string(&master->dev),
+			dev_name(&master->dev));
+		dmaengine_terminate_all(master->dma_tx);
+	} else {
+		dma = readl(spi_imx->base + MX51_ECSPI_DMA);
+		dma = dma & (~MX51_ECSPI_DMA_RXT_WML_MASK);
+		/* Change RX_DMA_LENGTH trigger dma fetch tail data */
+		left = transfer->len % spi_imx->rxt_wml;
+		if (left)
+			writel(dma | (left << MX51_ECSPI_DMA_RXT_WML_OFFSET),
+					spi_imx->base + MX51_ECSPI_DMA);
+
+		ret = wait_for_completion_timeout(&spi_imx->dma_rx_completion,
+				IMX_DMA_TIMEOUT);
+
+		writel(dma |
+		       spi_imx->rxt_wml << MX51_ECSPI_DMA_RXT_WML_OFFSET,
+		       spi_imx->base + MX51_ECSPI_DMA);
+
+		if (!ret) {
+			pr_warn("%s %s: I/O Error in DMA RX\n",
+				dev_driver_string(&master->dev),
+				dev_name(&master->dev));
+			spi_imx->devtype_data->reset(spi_imx);
+			dmaengine_terminate_all(master->dma_rx);
+		}
+		writel(dma |
+		       spi_imx->rxt_wml << MX51_ECSPI_DMA_RXT_WML_OFFSET,
+		       spi_imx->base + MX51_ECSPI_DMA);
+	}
+
+	spi_imx->dma_finished = 1;
+	spi_imx->devtype_data->trigger(spi_imx);
+
+	if (!ret)
+		ret = -ETIMEDOUT;
+	else if (ret > 0) {
+		/*
+		 * There are weird data in rxfifo randomly after DMA/PIO switch
+		 * dozens of time. But code run to here means both rx and tx
+		 * succesfully done, both rxfifo and txfifo should be empty.
+		 * otherwise, the unhappy data in rxfifo make the flowing PIO
+		 * transfer failed. The workaround is clearing rxfifo, meanwhile
+		 * no data miss after over night test.
+		 */
+		while (spi_imx->devtype_data->rx_available(spi_imx))
+			spi_imx->rx(spi_imx);
+
+		ret = transfer->len;
+	}
+	return ret;
+
+no_dma:
+	pr_warn_once("%s %s: DMA not available, falling back to PIO\n",
+		     dev_driver_string(&master->dev),
+		     dev_name(&master->dev));
+	return -EAGAIN;
+}
+
+static int spi_imx_pio_transfer(struct spi_device *spi,
 				struct spi_transfer *transfer)
 {
 	struct spi_imx_data *spi_imx = spi_master_get_devdata(spi->master);
@@ -751,6 +1018,22 @@ static int spi_imx_transfer(struct spi_device *spi,
 	return transfer->len;
 }
 
+static int spi_imx_transfer(struct spi_device *spi,
+				struct spi_transfer *transfer)
+{
+	int ret;
+	struct spi_imx_data *spi_imx = spi_master_get_devdata(spi->master);
+
+	if (spi_imx->bitbang.master->can_dma &&
+	    spi_imx_can_dma(spi_imx->bitbang.master, spi, transfer)) {
+		ret = spi_imx_dma_transfer(spi_imx, transfer);
+		if (ret != -EAGAIN)
+			return ret;
+	}
+
+	return spi_imx_pio_transfer(spi, transfer);
+}
+
 static int spi_imx_setup(struct spi_device *spi)
 {
 	struct spi_imx_data *spi_imx = spi_master_get_devdata(spi->master);
@@ -911,6 +1194,13 @@ static int spi_imx_probe(struct platform_device *pdev)
 		goto out_put_per;
 
 	spi_imx->spi_clk = clk_get_rate(spi_imx->clk_per);
+	/*
+	 * Only validated on i.mx6 now, can remove the constrain if validated on
+	 * other chips.
+	 */
+	if (spi_imx->devtype_data == &imx51_ecspi_devtype_data
+	    && spi_imx_sdma_init(&pdev->dev, spi_imx, master, res))
+		dev_err(&pdev->dev, "dma setup error,use pio instead\n");
 
 	spi_imx->devtype_data->reset(spi_imx);
 
@@ -949,6 +1239,7 @@ static int spi_imx_remove(struct platform_device *pdev)
 	writel(0, spi_imx->base + MXC_CSPICTRL);
 	clk_unprepare(spi_imx->clk_ipg);
 	clk_unprepare(spi_imx->clk_per);
+	spi_imx_sdma_exit(spi_imx);
 	spi_master_put(master);
 
 	return 0;
-- 
1.7.9.5

