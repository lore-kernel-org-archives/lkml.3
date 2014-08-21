Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753644AbaHUDrI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 23:47:08 -0400
Received: from mail-bl2lp0203.outbound.protection.outlook.com ([207.46.163.203]:12990
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750894AbaHUDrG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 23:47:06 -0400
From: Robin Gong <b38343@freescale.com>
To: <broonie@kernel.org>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-spi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <Frank.Li@freescale.com>,
        <shawn.guo@linaro.org>, <marex@denx.de>
Subject: [PATCH v3] spi: spi-imx: add DMA support
Date: Thu, 21 Aug 2014 11:53:10 +0800
Message-ID: <1408593190-1031-1-git-send-email-b38343@freescale.com>
X-Mailer: git-send-email 1.7.9.5
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(199003)(189002)(77156001)(62966002)(64706001)(87936001)(21056001)(102836001)(99396002)(47776003)(4396001)(81542001)(85306004)(89996001)(80022001)(20776003)(83072002)(50226001)(93916002)(88136002)(81342001)(97736001)(15202345003)(107046002)(87286001)(92726001)(84676001)(74502001)(68736004)(50986999)(31966008)(110136001)(6806004)(44976005)(83322001)(74662001)(229853001)(36756003)(19580405001)(19580395003)(77982001)(15975445006)(104016003)(76482001)(46102001)(79102001)(2351001)(50466002)(85852003)(92566001)(26826002)(105606002)(106466001)(48376002)(104166001)(33646002)(95666004)(42262002);DIR:OUT;SFP:;SCL:1;SRVR:DM2PR03MB495;H:tx30smr01.am.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;UriScan:;
X-Forefront-PRVS: 0310C78181
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=yibin.gong@freescale.com; 
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;
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
Change from v2:
http://thread.gmane.org/gmane.linux.ports.arm.kernel/291722/focus=294363
1. dma setup only for imx51-ecspi
2. use one small dummy buffer(1 bd size) to templiy store data
   for meanless rx/tx, instead of malloc the actual transfer size.
3. split spi_mx_sdma_transfer to smaller and easily to read.
4. fix some code indent.
---
 drivers/spi/spi-imx.c |  398 ++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 392 insertions(+), 6 deletions(-)

diff --git a/drivers/spi/spi-imx.c b/drivers/spi/spi-imx.c
index a5474ef..0c81a66 100644
--- a/drivers/spi/spi-imx.c
+++ b/drivers/spi/spi-imx.c
@@ -39,6 +39,9 @@
 #include <linux/of_gpio.h>
 
 #include <linux/platform_data/spi-imx.h>
+#include <linux/dma-mapping.h>
+#include <linux/platform_data/dma-imx.h>
+#include <linux/dmaengine.h>
 
 #define DRIVER_NAME "spi_imx"
 
@@ -52,6 +55,10 @@
 #define MXC_INT_RR	(1 << 0) /* Receive data ready interrupt */
 #define MXC_INT_TE	(1 << 1) /* Transmit FIFO empty interrupt */
 
+/* The maximum  bytes that a sdma BD can transfer.*/
+#define MAX_SDMA_BD_BYTES  (1 << 15)
+#define IMX_DMA_TIMEOUT (msecs_to_jiffies(3000))
+
 struct spi_imx_config {
 	unsigned int speed_hz;
 	unsigned int bpw;
@@ -84,6 +91,7 @@ struct spi_imx_data {
 
 	struct completion xfer_done;
 	void __iomem *base;
+	phys_addr_t pbase;
 	int irq;
 	struct clk *clk_per;
 	struct clk *clk_ipg;
@@ -92,6 +100,27 @@ struct spi_imx_data {
 	unsigned int count;
 	void (*tx)(struct spi_imx_data *);
 	void (*rx)(struct spi_imx_data *);
+	int (*txrx_bufs)(struct spi_device *spi, struct spi_transfer *t);
+	struct dma_chan *dma_chan_rx;
+	struct dma_chan *dma_chan_tx;
+	unsigned int dma_is_inited;
+	struct device *dev;
+
+	struct completion dma_rx_completion;
+	struct completion dma_tx_completion;
+
+	void *dummy_buf;
+	dma_addr_t dummy_dma;
+	dma_addr_t dma_rx_phy_addr;
+	dma_addr_t dma_tx_phy_addr;
+
+	unsigned int usedma;
+	unsigned int dma_finished;
+	/* SDMA wartermark */
+	u32 rx_wml;
+	u32 tx_wml;
+	u32 rxt_wml;
+
 	void *rx_buf;
 	const void *tx_buf;
 	unsigned int txfifo; /* number of words pushed in tx FIFO */
@@ -185,6 +214,7 @@ static unsigned int spi_imx_clkdiv_2(unsigned int fin,
 #define MX51_ECSPI_CTRL		0x08
 #define MX51_ECSPI_CTRL_ENABLE		(1 <<  0)
 #define MX51_ECSPI_CTRL_XCH		(1 <<  2)
+#define MX51_ECSPI_CTRL_SMC		(1 << 3)
 #define MX51_ECSPI_CTRL_MODE_MASK	(0xf << 4)
 #define MX51_ECSPI_CTRL_POSTDIV_OFFSET	8
 #define MX51_ECSPI_CTRL_PREDIV_OFFSET	12
@@ -202,6 +232,18 @@ static unsigned int spi_imx_clkdiv_2(unsigned int fin,
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
 
@@ -258,17 +300,22 @@ static void __maybe_unused mx51_ecspi_intctrl(struct spi_imx_data *spi_imx, int
 
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
@@ -320,6 +367,30 @@ static int __maybe_unused mx51_ecspi_config(struct spi_imx_data *spi_imx,
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
+				   & ~MX51_ECSPI_DMA_RX_WML_MASK
+				   & ~MX51_ECSPI_DMA_RXT_WML_MASK)
+				   | rx_wml_cfg | tx_wml_cfg | rxt_wml_cfg
+				   |(1 << MX51_ECSPI_DMA_TEDEN_OFFSET)
+				   |(1 << MX51_ECSPI_DMA_RXDEN_OFFSET)
+				   |(1 << MX51_ECSPI_DMA_RXTDEN_OFFSET);
+
+		writel(dma, spi_imx->base + MX51_ECSPI_DMA);
+	}
+
 	return 0;
 }
 
@@ -731,7 +802,225 @@ static int spi_imx_setupxfer(struct spi_device *spi,
 	return 0;
 }
 
-static int spi_imx_transfer(struct spi_device *spi,
+static void spi_imx_sdma_exit(struct spi_imx_data *spi_imx)
+{
+	if (spi_imx->dma_chan_rx) {
+		dma_release_channel(spi_imx->dma_chan_rx);
+		spi_imx->dma_chan_rx = NULL;
+	}
+
+	if (spi_imx->dma_chan_tx) {
+		dma_release_channel(spi_imx->dma_chan_tx);
+		spi_imx->dma_chan_tx = NULL;
+	}
+
+	spi_imx->dma_is_inited = 0;
+}
+
+static void spi_imx_dma_rx_callback(void *cookie)
+{
+	struct spi_imx_data *spi_imx = (struct spi_imx_data *)cookie;
+
+	complete(&spi_imx->dma_rx_completion);
+
+}
+
+static void spi_imx_dma_tx_callback(void *cookie)
+{
+	struct spi_imx_data *spi_imx = (struct spi_imx_data *)cookie;
+
+	complete(&spi_imx->dma_tx_completion);
+}
+
+static struct scatterlist *spi_imx_sdma_submit(struct spi_imx_data *spi_imx,
+					  struct spi_transfer *transfer,
+					  bool is_tx, bool is_tx_dummy,
+					  bool is_rx_dummy)
+{
+	int sg_num;
+	int loop;
+	struct scatterlist *sg_rxtx;
+	unsigned len = transfer->len;
+	const void *rxtxbuf;
+	dma_addr_t rxtx_dma = (is_tx ? transfer->tx_dma : transfer->rx_dma);
+	struct dma_async_tx_descriptor *rxtxdesc;
+	enum dma_data_direction direction = is_tx ? DMA_TO_DEVICE :
+					    DMA_FROM_DEVICE;
+	bool dummy = false;
+	struct dma_chan *dma_chan = (is_tx ? spi_imx->dma_chan_tx :
+				     spi_imx->dma_chan_rx);
+
+	if ((is_tx && is_tx_dummy) || (!is_tx && is_rx_dummy)) {
+		rxtxbuf = spi_imx->dummy_buf;
+		rxtx_dma = spi_imx->dummy_dma;
+		len = MAX_SDMA_BD_BYTES;
+		dummy = true;
+	} else if (is_tx) {
+		rxtxbuf = transfer->tx_buf;
+	} else {
+		rxtxbuf = transfer->rx_buf;
+	}
+
+	if (!dummy) {
+		rxtx_dma = dma_map_single(spi_imx->dev,
+					(void *)rxtxbuf, len,
+					direction);
+		if (dma_mapping_error(spi_imx->dev, rxtx_dma)) {
+			dev_err(spi_imx->dev,
+			"Memory dma map fail, line = %d\n", __LINE__);
+			goto err_rxtx;
+		}
+		if (is_tx)
+			transfer->tx_dma = rxtx_dma;
+		else
+			transfer->rx_dma = rxtx_dma;
+	}
+	/* Prepare sg for txrx sdma. */
+	sg_num = ((transfer->len - 1) / MAX_SDMA_BD_BYTES) + 1;
+	sg_rxtx = kzalloc(sg_num * sizeof(struct scatterlist), GFP_KERNEL);
+	if (NULL == sg_rxtx) {
+		dev_err(spi_imx->dev,
+			"Memory allocate fail, line = %d\n",
+			__LINE__);
+		goto err_rxtx_sg;
+	}
+	sg_init_table(sg_rxtx, sg_num);
+	for (loop = 0; loop < (sg_num - 1); loop++) {
+		if (dummy)
+			sg_dma_address(&sg_rxtx[loop]) = rxtx_dma;
+		else
+			sg_dma_address(&sg_rxtx[loop]) =
+				rxtx_dma + loop * MAX_SDMA_BD_BYTES;
+		sg_dma_len(&sg_rxtx[loop]) = MAX_SDMA_BD_BYTES;
+	}
+
+	if (dummy)
+		sg_dma_address(&sg_rxtx[loop]) = rxtx_dma;
+	else
+		sg_dma_address(&sg_rxtx[loop]) =
+			rxtx_dma + loop * MAX_SDMA_BD_BYTES;
+	sg_dma_len(&sg_rxtx[loop]) = transfer->len - loop * MAX_SDMA_BD_BYTES;
+
+	rxtxdesc = dmaengine_prep_slave_sg(dma_chan,
+			sg_rxtx, sg_num , direction, DMA_PREP_INTERRUPT);
+	if (!rxtxdesc)
+		goto err_desc;
+
+	rxtxdesc->callback = (is_tx ? spi_imx_dma_tx_callback :
+			   spi_imx_dma_rx_callback);
+	rxtxdesc->callback_param = (void *)spi_imx;
+
+	dmaengine_submit(rxtxdesc);
+
+	return sg_rxtx;
+err_desc:
+	kfree(sg_rxtx);
+err_rxtx_sg:
+	if (!dummy) {
+		dma_unmap_single(spi_imx->dev, rxtx_dma,
+			len, direction);
+		if (is_tx)
+			transfer->tx_dma = NULL;
+		else
+			transfer->rx_dma = NULL;
+
+	}
+err_rxtx:
+	return NULL;
+}
+
+static int spi_imx_sdma_transfer(struct spi_device *spi,
+				struct spi_transfer *transfer)
+{
+	struct spi_imx_data *spi_imx = spi_master_get_devdata(spi->master);
+	int ret = 0;
+	int left;
+	u32 dma;
+	bool is_tx_dummy = false;
+	bool is_rx_dummy = false;
+
+	struct scatterlist *sg_rx, *sg_tx;
+
+	if (transfer->tx_buf && transfer->rx_buf) {
+		dev_warn(spi_imx->dev, "null data need transfer\n");
+		return 0;
+	} else if (!transfer->tx_buf) {
+		is_tx_dummy = true;
+	} else if (!transfer->rx_buf) {
+		is_rx_dummy = true;
+	}
+
+	reinit_completion(&spi_imx->dma_rx_completion);
+	reinit_completion(&spi_imx->dma_tx_completion);
+
+	sg_tx = spi_imx_sdma_submit(spi_imx, transfer, true, is_tx_dummy,
+				    is_rx_dummy);
+	if (!sg_tx)
+		goto err_tx;
+
+	sg_rx = spi_imx_sdma_submit(spi_imx, transfer, false, is_tx_dummy,
+				    is_rx_dummy);
+	if (!sg_rx)
+		goto err_rx;
+	/* Trigger the cspi module. */
+	spi_imx->dma_finished = 0;
+
+	spi_imx->devtype_data->trigger(spi_imx);
+
+	dma_async_issue_pending(spi_imx->dma_chan_tx);
+	dma_async_issue_pending(spi_imx->dma_chan_rx);
+	/* Wait SDMA to finish the data transfer.*/
+	ret = wait_for_completion_timeout(&spi_imx->dma_tx_completion,
+						IMX_DMA_TIMEOUT);
+	if (!ret) {
+		dev_err(spi_imx->dev,
+			"I/O Error in DMA TX, line = %d ####\n", __LINE__);
+		dmaengine_terminate_all(spi_imx->dma_chan_tx);
+		goto err_desc;
+	} else {
+		dma = readl(spi_imx->base + MX51_ECSPI_DMA);
+		dma = dma & (~MX51_ECSPI_DMA_RXT_WML_MASK);
+		/* Change RX_DMA_LENGTH trigger dma fetch tail data */
+		left = transfer->len & (~spi_imx->rxt_wml);
+		if (left)
+			writel(dma | (left << MX51_ECSPI_DMA_RXT_WML_OFFSET),
+					spi_imx->base + MX51_ECSPI_DMA);
+
+		ret = wait_for_completion_timeout(&spi_imx->dma_rx_completion,
+				IMX_DMA_TIMEOUT);
+		writel(dma |
+		       spi_imx->rxt_wml << MX51_ECSPI_DMA_RXT_WML_OFFSET,
+		       spi_imx->base + MX51_ECSPI_DMA);
+		if (!ret) {
+			dev_err(spi_imx->dev,
+				"I/O Error in DMA RX. len %d, line = %d\n",
+					transfer->len,
+					__LINE__);
+			spi_imx->devtype_data->reset(spi_imx);
+			dmaengine_terminate_all(spi_imx->dma_chan_rx);
+		}
+	}
+
+err_desc:
+	kfree(sg_rx);
+	if (!is_rx_dummy && transfer->rx_dma)
+		dma_unmap_single(spi_imx->dev, transfer->rx_dma,
+			transfer->len, DMA_TO_DEVICE);
+err_rx:
+	kfree(sg_tx);
+	if (!is_tx_dummy && transfer->tx_dma)
+		dma_unmap_single(spi_imx->dev, transfer->tx_dma,
+			transfer->len, DMA_FROM_DEVICE);
+err_tx:
+	spi_imx->dma_finished = 1;
+	spi_imx->devtype_data->trigger(spi_imx);
+	if (!ret)
+		return -EIO;
+	else
+		return transfer->len;
+}
+
+static int spi_imx_pio_transfer(struct spi_device *spi,
 				struct spi_transfer *transfer)
 {
 	struct spi_imx_data *spi_imx = spi_master_get_devdata(spi->master);
@@ -752,6 +1041,25 @@ static int spi_imx_transfer(struct spi_device *spi,
 	return transfer->len;
 }
 
+static int spi_imx_transfer(struct spi_device *spi,
+				struct spi_transfer *transfer)
+{
+	struct spi_imx_data *spi_imx = spi_master_get_devdata(spi->master);
+
+	/*
+	 * Don't use sdma when the size of data to be transfered is
+	 * lower then SDMA wartermark.
+	 */
+	if (spi_imx->dma_is_inited && (transfer->len > spi_imx->rx_wml)
+	    && (transfer->len > spi_imx->tx_wml)) {
+		spi_imx->usedma = 1;
+		return spi_imx_sdma_transfer(spi, transfer);
+	} else {
+		spi_imx->usedma = 0;
+		return spi_imx_pio_transfer(spi, transfer);
+	}
+}
+
 static int spi_imx_setup(struct spi_device *spi)
 {
 	struct spi_imx_data *spi_imx = spi_master_get_devdata(spi->master);
@@ -801,6 +1109,66 @@ spi_imx_unprepare_message(struct spi_master *master, struct spi_message *msg)
 	return 0;
 }
 
+static int spi_imx_sdma_init(struct spi_imx_data *spi_imx)
+{
+	struct dma_slave_config slave_config = {};
+	struct device *dev = spi_imx->dev;
+	int ret;
+
+	/* Prepare for TX DMA: */
+	spi_imx->dma_chan_tx = dma_request_slave_channel(dev, "tx");
+	if (!spi_imx->dma_chan_tx) {
+		dev_err(dev, "cannot get the TX DMA channel!\n");
+		ret = -EINVAL;
+		goto err;
+	}
+
+	slave_config.direction = DMA_MEM_TO_DEV;
+	slave_config.dst_addr = spi_imx->pbase + MXC_CSPITXDATA;
+	slave_config.dst_addr_width = DMA_SLAVE_BUSWIDTH_1_BYTE;
+	slave_config.dst_maxburst = spi_imx_get_fifosize(spi_imx) / 2;
+	ret = dmaengine_slave_config(spi_imx->dma_chan_tx, &slave_config);
+	if (ret) {
+		dev_err(dev, "error in TX dma configuration.");
+		goto err;
+	}
+
+	/* Prepare for RX : */
+	spi_imx->dma_chan_rx = dma_request_slave_channel(dev, "rx");
+	if (!spi_imx->dma_chan_rx) {
+		dev_dbg(dev, "cannot get the DMA channel.\n");
+		ret = -EINVAL;
+		goto err;
+	}
+
+	slave_config.direction = DMA_DEV_TO_MEM;
+	slave_config.src_addr = spi_imx->pbase + MXC_CSPIRXDATA;
+	slave_config.src_addr_width = DMA_SLAVE_BUSWIDTH_1_BYTE;
+	slave_config.src_maxburst = spi_imx_get_fifosize(spi_imx) / 2;
+	ret = dmaengine_slave_config(spi_imx->dma_chan_rx, &slave_config);
+	if (ret) {
+		dev_err(dev, "error in RX dma configuration.\n");
+		goto err;
+	}
+
+	spi_imx->dummy_buf = dma_alloc_coherent(dev, MAX_SDMA_BD_BYTES,
+						&spi_imx->dummy_dma,
+						GFP_KERNEL);
+	if (!spi_imx->dummy_buf) {
+		dev_err(dev, "error in dummy buf alloc.\n");
+		goto err;
+	}
+
+	init_completion(&spi_imx->dma_rx_completion);
+	init_completion(&spi_imx->dma_tx_completion);
+	spi_imx->dma_is_inited = 1;
+
+	return 0;
+err:
+	spi_imx_sdma_exit(spi_imx);
+	return ret;
+}
+
 static int spi_imx_probe(struct platform_device *pdev)
 {
 	struct device_node *np = pdev->dev.of_node;
@@ -872,6 +1240,8 @@ static int spi_imx_probe(struct platform_device *pdev)
 		(struct spi_imx_devtype_data *) pdev->id_entry->driver_data;
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (res)
+		spi_imx->pbase = res->start;
 	spi_imx->base = devm_ioremap_resource(&pdev->dev, res);
 	if (IS_ERR(spi_imx->base)) {
 		ret = PTR_ERR(spi_imx->base);
@@ -913,6 +1283,15 @@ static int spi_imx_probe(struct platform_device *pdev)
 
 	spi_imx->spi_clk = clk_get_rate(spi_imx->clk_per);
 
+	spi_imx->dev = &pdev->dev;
+	/*
+	 * Only validated on i.mx6 now, can remove the constrain if validated on
+	 * other chips.
+	 */
+	if (spi_imx->devtype_data == &imx51_ecspi_devtype_data
+	    && spi_imx_sdma_init(spi_imx))
+		dev_err(&pdev->dev, "dma setup error,use pio instead\n");
+
 	spi_imx->devtype_data->reset(spi_imx);
 
 	spi_imx->devtype_data->intctrl(spi_imx, 0);
@@ -931,6 +1310,9 @@ static int spi_imx_probe(struct platform_device *pdev)
 	return ret;
 
 out_clk_put:
+	if (spi_imx->dma_is_inited)
+		dma_free_coherent(&pdev->dev, MAX_SDMA_BD_BYTES,
+				  spi_imx->dummy_buf, spi_imx->dummy_dma);
 	clk_disable_unprepare(spi_imx->clk_ipg);
 out_put_per:
 	clk_disable_unprepare(spi_imx->clk_per);
@@ -947,6 +1329,10 @@ static int spi_imx_remove(struct platform_device *pdev)
 
 	spi_bitbang_stop(&spi_imx->bitbang);
 
+	if (spi_imx->dma_is_inited)
+		dma_free_coherent(&pdev->dev, MAX_SDMA_BD_BYTES,
+				  spi_imx->dummy_buf, spi_imx->dummy_dma);
+
 	writel(0, spi_imx->base + MXC_CSPICTRL);
 	clk_disable_unprepare(spi_imx->clk_ipg);
 	clk_disable_unprepare(spi_imx->clk_per);
-- 
1.7.9.5

