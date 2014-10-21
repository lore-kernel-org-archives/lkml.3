Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754258AbaJUCOG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 22:14:06 -0400
Received: from mail-bl2on0108.outbound.protection.outlook.com ([65.55.169.108]:1888
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754104AbaJUCOE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 22:14:04 -0400
From: Yibin Gong <yibin.gong@freescale.com>
To: Yibin Gong <yibin.gong@freescale.com>,
        "vinod.koul@intel.com" <vinod.koul@intel.com>,
        "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
        "andriy.shevchenko@linux.intel.com" 
	<andriy.shevchenko@linux.intel.com>
CC: "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v6] spi: spi-imx: add DMA support
Thread-Topic: [PATCH v6] spi: spi-imx: add DMA support
Thread-Index: AQHP7NRnTEetK/jJ/UGrxuZKvnUI7Zw5z3mA
Date: Tue, 21 Oct 2014 02:14:00 +0000
Message-ID: <2bcb6daf766645abb62286fb6144b88e@BLUPR03MB036.namprd03.prod.outlook.com>
References: <1413853584-18325-1-git-send-email-b38343@freescale.com>
 <1413853584-18325-3-git-send-email-b38343@freescale.com>
In-Reply-To: <1413853584-18325-3-git-send-email-b38343@freescale.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [192.88.158.211]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;SRVR:BLUPR03MB034;
x-forefront-prvs: 0371762FE7
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(6009001)(377454003)(13464003)(189002)(199003)(54356999)(76176999)(108616004)(31966008)(50986999)(15975445006)(2201001)(86362001)(40100003)(15202345003)(2501002)(101416001)(80022003)(21056001)(46102003)(92566001)(19580405001)(74316001)(85306004)(575784001)(2656002)(19580395003)(87936001)(33646002)(85852003)(122556002)(99396003)(95666004)(99286002)(76576001)(106116001)(120916001)(106356001)(4396001)(77096002)(20776003)(105586002)(107046002)(76482002)(66066001)(24736002);DIR:OUT;SFP:1102;SCL:1;SRVR:BLUPR03MB034;H:BLUPR03MB036.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for sending the wrong patch set, please ignore...

-----Original Message-----
From: Robin Gong [mailto:b38343@freescale.com] 
Sent: Tuesday, October 21, 2014 9:06 AM
To: vinod.koul@intel.com; dan.j.williams@intel.com; andriy.shevchenko@linux.intel.com
Cc: dmaengine@vger.kernel.org; linux-kernel@vger.kernel.org; Gong Yibin-B38343
Subject: [PATCH v6] spi: spi-imx: add DMA support

Enable DMA support on i.mx6. The read speed can increase from 600KB/s to 1.2MB/s on i.mx6q. You can disable or enable dma function in dts.
If not set "dma-names" in dts, spi will use PIO mode. This patch only validate on i.mx6, not i.mx5, but encourage ones to apply this patch on i.mx5 since they share the same IP.

Note:
  Sometime, there is a weid data in rxfifo after one full tx/rx transfer finish by DMA on i.mx6dl, so we disable dma functhion on i.mx6dl.

Signed-off-by: Frank Li <Frank.Li@freescale.com>
Signed-off-by: Robin Gong <b38343@freescale.com>

---
Change from v5:
1. Update binding doc fsl-imx-cspi.txt.
2. remove usedma flag set from can_dma interface.

Change from v4:
1. Enrich comments.
2. Remove the rxfifo workaround. The issue only exist on i.mx6dl, so disable
   dma function in dts.

Change from v3:
1. Use spi core framwork to handle dump tx/rx buf 2. Add one workaround for weird data in rxfifo when one full transfer done.

Change from v2:
http://thread.gmane.org/gmane.linux.ports.arm.kernel/291722/focus=294363
1. Dma setup only for imx51-ecspi
2. Use one small dummy buffer(1 bd size) to templiy store data
   for meanless rx/tx, instead of malloc the actual transfer size.
3. Split spi_mx_sdma_transfer to smaller and easily to read.
4. Fix some code indent.
---
 .../devicetree/bindings/spi/fsl-imx-cspi.txt       |   5 +
 drivers/spi/spi-imx.c                              | 286 ++++++++++++++++++++-
 2 files changed, 285 insertions(+), 6 deletions(-)

diff --git a/Documentation/devicetree/bindings/spi/fsl-imx-cspi.txt b/Documentation/devicetree/bindings/spi/fsl-imx-cspi.txt
index 4256a6d..aad527b 100644
--- a/Documentation/devicetree/bindings/spi/fsl-imx-cspi.txt
+++ b/Documentation/devicetree/bindings/spi/fsl-imx-cspi.txt
@@ -7,6 +7,9 @@ Required properties:
 - interrupts : Should contain CSPI/eCSPI interrupt
 - fsl,spi-num-chipselects : Contains the number of the chipselect
 - cs-gpios : Specifies the gpio pins to be used for chipselects.
+- dmas: DMA specifiers for tx and rx dma. See the DMA client binding,
+		Documentation/devicetree/bindings/dma/dma.txt
+- dma-names: DMA request names should include "tx" and "rx" if present.
 
 Example:
 
@@ -19,4 +22,6 @@ ecspi@70010000 {
 	fsl,spi-num-chipselects = <2>;
 	cs-gpios = <&gpio3 24 0>, /* GPIO3_24 */
 		   <&gpio3 25 0>; /* GPIO3_25 */
+	dmas = <&sdma 3 7 1>, <&sdma 4 7 2>;
+	dma-names = "rx", "tx";
 };
diff --git a/drivers/spi/spi-imx.c b/drivers/spi/spi-imx.c index 5daff20..3637847 100644
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
 
+/* The maximum  bytes that a sdma BD can transfer.*/ #define 
+MAX_SDMA_BD_BYTES  (1 << 15) #define IMX_DMA_TIMEOUT 
+(msecs_to_jiffies(3000))
 struct spi_imx_config {
 	unsigned int speed_hz;
 	unsigned int bpw;
@@ -95,6 +101,16 @@ struct spi_imx_data {
 	const void *tx_buf;
 	unsigned int txfifo; /* number of words pushed in tx FIFO */
 
+	/* DMA */
+	unsigned int dma_is_inited;
+	unsigned int dma_finished;
+	bool usedma;
+	u32 rx_wml;
+	u32 tx_wml;
+	u32 rxt_wml;
+	struct completion dma_rx_completion;
+	struct completion dma_tx_completion;
+
 	const struct spi_imx_devtype_data *devtype_data;
 	int chipselect[0];
 };
@@ -181,9 +197,21 @@ static unsigned int spi_imx_clkdiv_2(unsigned int fin,
 	return 7;
 }
 
+static bool spi_imx_can_dma(struct spi_master *master, struct spi_device *spi,
+			 struct spi_transfer *transfer)
+{
+	struct spi_imx_data *spi_imx = spi_master_get_devdata(master);
+
+	if (spi_imx->dma_is_inited && (transfer->len > spi_imx->rx_wml)
+	    && (transfer->len > spi_imx->tx_wml))
+		return true;
+	return false;
+}
+
 #define MX51_ECSPI_CTRL		0x08
 #define MX51_ECSPI_CTRL_ENABLE		(1 <<  0)
 #define MX51_ECSPI_CTRL_XCH		(1 <<  2)
+#define MX51_ECSPI_CTRL_SMC		(1 << 3)
 #define MX51_ECSPI_CTRL_MODE_MASK	(0xf << 4)
 #define MX51_ECSPI_CTRL_POSTDIV_OFFSET	8
 #define MX51_ECSPI_CTRL_PREDIV_OFFSET	12
@@ -201,6 +229,18 @@ static unsigned int spi_imx_clkdiv_2(unsigned int fin,
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
 
@@ -257,17 +297,22 @@ static void __maybe_unused mx51_ecspi_intctrl(struct spi_imx_data *spi_imx, int
 
 static void __maybe_unused mx51_ecspi_trigger(struct spi_imx_data *spi_imx)  {
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
 	writel(reg, spi_imx->base + MX51_ECSPI_CTRL);  }
 
 static int __maybe_unused mx51_ecspi_config(struct spi_imx_data *spi_imx,
 		struct spi_imx_config *config)
 {
-	u32 ctrl = MX51_ECSPI_CTRL_ENABLE, cfg = 0;
+	u32 ctrl = MX51_ECSPI_CTRL_ENABLE, cfg = 0, dma = 0;
+	u32 tx_wml_cfg, rx_wml_cfg, rxt_wml_cfg;
 	u32 clk = config->speed_hz, delay;
 
 	/*
@@ -319,6 +364,30 @@ static int __maybe_unused mx51_ecspi_config(struct spi_imx_data *spi_imx,
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
+			   & ~MX51_ECSPI_DMA_RX_WML_MASK
+			   & ~MX51_ECSPI_DMA_RXT_WML_MASK)
+			   | rx_wml_cfg | tx_wml_cfg | rxt_wml_cfg
+			   |(1 << MX51_ECSPI_DMA_TEDEN_OFFSET)
+			   |(1 << MX51_ECSPI_DMA_RXDEN_OFFSET)
+			   |(1 << MX51_ECSPI_DMA_RXTDEN_OFFSET);
+
+		writel(dma, spi_imx->base + MX51_ECSPI_DMA);
+	}
+
 	return 0;
 }
 
@@ -730,7 +799,186 @@ static int spi_imx_setupxfer(struct spi_device *spi,
 	return 0;
 }
 
-static int spi_imx_transfer(struct spi_device *spi,
+static void spi_imx_sdma_exit(struct spi_imx_data *spi_imx) {
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
+		dev_err(dev, "error in TX dma configuration.\n");
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
+static void spi_imx_dma_rx_callback(void *cookie) {
+	struct spi_imx_data *spi_imx = (struct spi_imx_data *)cookie;
+
+	complete(&spi_imx->dma_rx_completion);
+}
+
+static void spi_imx_dma_tx_callback(void *cookie) {
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
+	dma = readl(spi_imx->base + MX51_ECSPI_DMA);
+	dma = dma & (~MX51_ECSPI_DMA_RXT_WML_MASK);
+	/* Change RX_DMA_LENGTH trigger dma fetch tail data */
+	left = transfer->len % spi_imx->rxt_wml;
+	if (left)
+		writel(dma | (left << MX51_ECSPI_DMA_RXT_WML_OFFSET),
+				spi_imx->base + MX51_ECSPI_DMA);
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
+		ret = wait_for_completion_timeout(&spi_imx->dma_rx_completion,
+				IMX_DMA_TIMEOUT);
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
+	else if (ret > 0)
+		ret = transfer->len;
+
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
@@ -751,6 +999,24 @@ static int spi_imx_transfer(struct spi_device *spi,
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
+		spi_imx->usedma = true;
+		ret = spi_imx_dma_transfer(spi_imx, transfer);
+		if (ret != -EAGAIN)
+			return ret;
+	}
+	spi_imx->usedma = false;
+
+	return spi_imx_pio_transfer(spi, transfer); }
+
 static int spi_imx_setup(struct spi_device *spi)  {
 	struct spi_imx_data *spi_imx = spi_master_get_devdata(spi->master);
@@ -911,6 +1177,13 @@ static int spi_imx_probe(struct platform_device *pdev)
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
 
@@ -949,6 +1222,7 @@ static int spi_imx_remove(struct platform_device *pdev)
 	writel(0, spi_imx->base + MXC_CSPICTRL);
 	clk_unprepare(spi_imx->clk_ipg);
 	clk_unprepare(spi_imx->clk_per);
+	spi_imx_sdma_exit(spi_imx);
 	spi_master_put(master);
 
 	return 0;
--
1.9.1

