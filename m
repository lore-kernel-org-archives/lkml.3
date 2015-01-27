Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758225AbbA0Kyh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 05:54:37 -0500
Received: from mail-am1on0128.outbound.protection.outlook.com ([157.56.112.128]:22720
	"EHLO emea01-am1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758210AbbA0Kyf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 05:54:35 -0500
From: Bhuvanchandra DV <bhuvanchandra.dv@toradex.com>
To: <mark.rutland@arm.com>
CC: <stefan@agner.ch>, <shawn.guo@linaro.org>, <robh+dt@kernel.org>,
        <pawel.moll@arm.com>, <ijc+devicetree@hellion.org.uk>,
        <galak@codeaurora.org>, <linux@arm.linux.org.uk>, <broonie@kernel.org>,
        <B44548@freescale.com>, <Li.Xiubo@freescale.com>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-spi@vger.kernel.org>,
        Bhuvanchandra DV <bhuvanchandra.dv@toradex.com>
Subject: [PATCH 5/7] spi: spi-fsl-dspi: Remove spi-bitbang
Date: Tue, 27 Jan 2015 16:27:22 +0530
Message-ID: <1422356244-15629-6-git-send-email-bhuvanchandra.dv@toradex.com>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <1422356244-15629-1-git-send-email-bhuvanchandra.dv@toradex.com>
References: <1422356244-15629-1-git-send-email-bhuvanchandra.dv@toradex.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [115.115.225.206]
X-ClientProxiedBy: HKXPR03CA001.apcprd03.prod.outlook.com (10.242.96.21) To
 AMSPR05MB262.eurprd05.prod.outlook.com (10.242.95.19)
Authentication-Results: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=toradex.com;
X-DmarcAction-Test: None
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(3005004);SRVR:AMSPR05MB262;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:AMSPR05MB262;
X-Forefront-PRVS: 046985391D
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(6009001)(92566002)(229853001)(48376002)(19580395003)(230783001)(122386002)(40100003)(19580405001)(50986999)(50466002)(87976001)(50226001)(53416004)(86362001)(47776003)(42186005)(36756003)(33646002)(77156002)(76176999)(62966003)(2950100001)(110136001)(46102003)(77096005)(2351001)(66066001)(7059030);DIR:OUT;SFP:1102;SCL:1;SRVR:AMSPR05MB262;H:dvb.toradex.int;FPR:;SPF:None;MLV:sfv;LANG:en;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:AMSPR05MB262;
X-OriginatorOrg: toradex.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2015 10:52:54.9162 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AMSPR05MB262
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chao Fu <B44548@freescale.com>

DSPI module need cs change information in
a spi transfer. According to cs change, DSPI
will give last data the right flag. Bitbang
provide cs change behind the last data in
a transfer. So DSPI can not deal the last
data in every transfer properly, so remove
the bitbang in the driver.

Signed-off-by: Bhuvanchandra DV <bhuvanchandra.dv@toradex.com>
---
 drivers/spi/Kconfig        |   1 -
 drivers/spi/spi-fsl-dspi.c | 144 ++++++++++++++++++++++-----------------------
 2 files changed, 71 insertions(+), 74 deletions(-)

diff --git a/drivers/spi/Kconfig b/drivers/spi/Kconfig
index 9982998..6316d6d 100644
--- a/drivers/spi/Kconfig
+++ b/drivers/spi/Kconfig
@@ -292,7 +292,6 @@ config SPI_FSL_SPI
 
 config SPI_FSL_DSPI
 	tristate "Freescale DSPI controller"
-	select SPI_BITBANG
 	select REGMAP_MMIO
 	depends on SOC_VF610 || COMPILE_TEST
 	help
diff --git a/drivers/spi/spi-fsl-dspi.c b/drivers/spi/spi-fsl-dspi.c
index 5378148..b20dbb5 100644
--- a/drivers/spi/spi-fsl-dspi.c
+++ b/drivers/spi/spi-fsl-dspi.c
@@ -106,7 +106,7 @@ struct chip_data {
 };
 
 struct fsl_dspi {
-	struct spi_bitbang	bitbang;
+	struct spi_master	*master;
 	struct platform_device	*pdev;
 
 	struct regmap		*regmap;
@@ -114,6 +114,7 @@ struct fsl_dspi {
 	struct clk		*clk;
 
 	struct spi_transfer	*cur_transfer;
+	struct spi_message	*cur_msg;
 	struct chip_data	*cur_chip;
 	size_t			len;
 	void			*tx;
@@ -123,6 +124,7 @@ struct fsl_dspi {
 	char			dataflags;
 	u8			cs;
 	u16			void_write_data;
+	u32			cs_change;
 
 	wait_queue_head_t	waitq;
 	u32			waitflags;
@@ -225,6 +227,8 @@ static int dspi_transfer_write(struct fsl_dspi *dspi)
 		if (dspi->len == 0 || tx_count == DSPI_FIFO_SIZE - 1) {
 			/* last transfer in the transfer */
 			dspi_pushr |= SPI_PUSHR_EOQ;
+			if ((dspi->cs_change) && (!dspi->len))
+				dspi_pushr &= ~SPI_PUSHR_CONT;
 		} else if (tx_word && (dspi->len == 1))
 			dspi_pushr |= SPI_PUSHR_EOQ;
 
@@ -246,6 +250,7 @@ static int dspi_transfer_read(struct fsl_dspi *dspi)
 	int rx_count = 0;
 	int rx_word = is_double_byte_mode(dspi);
 	u16 d;
+
 	while ((dspi->rx < dspi->rx_end)
 			&& (rx_count < DSPI_FIFO_SIZE)) {
 		if (rx_word) {
@@ -276,64 +281,67 @@ static int dspi_transfer_read(struct fsl_dspi *dspi)
 	return rx_count;
 }
 
-static int dspi_txrx_transfer(struct spi_device *spi, struct spi_transfer *t)
+static int dspi_transfer_one_message(struct spi_master *master,
+		struct spi_message *message)
 {
-	struct fsl_dspi *dspi = spi_master_get_devdata(spi->master);
-	dspi->cur_transfer = t;
-	dspi->cur_chip = spi_get_ctldata(spi);
-	dspi->cs = spi->chip_select;
-	dspi->void_write_data = dspi->cur_chip->void_write_data;
-
-	dspi->dataflags = 0;
-	dspi->tx = (void *)t->tx_buf;
-	dspi->tx_end = dspi->tx + t->len;
-	dspi->rx = t->rx_buf;
-	dspi->rx_end = dspi->rx + t->len;
-	dspi->len = t->len;
-
-	if (!dspi->rx)
-		dspi->dataflags |= TRAN_STATE_RX_VOID;
-
-	if (!dspi->tx)
-		dspi->dataflags |= TRAN_STATE_TX_VOID;
-
-	regmap_write(dspi->regmap, SPI_MCR, dspi->cur_chip->mcr_val);
-	regmap_write(dspi->regmap, SPI_CTAR(dspi->cs), dspi->cur_chip->ctar_val);
-	regmap_write(dspi->regmap, SPI_RSER, SPI_RSER_EOQFE);
-
-	if (t->speed_hz)
+	struct fsl_dspi *dspi = spi_master_get_devdata(master);
+	struct spi_device *spi = message->spi;
+	struct spi_transfer *transfer;
+	int status = 0;
+	message->actual_length = 0;
+
+	list_for_each_entry(transfer, &message->transfers, transfer_list) {
+		dspi->cur_transfer = transfer;
+		dspi->cur_msg = message;
+		dspi->cur_chip = spi_get_ctldata(spi);
+		dspi->cs = spi->chip_select;
+		if (dspi->cur_transfer->transfer_list.next
+				== &dspi->cur_msg->transfers)
+			transfer->cs_change = 1;
+		dspi->cs_change = transfer->cs_change;
+		dspi->void_write_data = dspi->cur_chip->void_write_data;
+
+		dspi->dataflags = 0;
+		dspi->tx = (void *)transfer->tx_buf;
+		dspi->tx_end = dspi->tx + transfer->len;
+		dspi->rx = transfer->rx_buf;
+		dspi->rx_end = dspi->rx + transfer->len;
+		dspi->len = transfer->len;
+
+		if (!dspi->rx)
+			dspi->dataflags |= TRAN_STATE_RX_VOID;
+
+		if (!dspi->tx)
+			dspi->dataflags |= TRAN_STATE_TX_VOID;
+
+		regmap_write(dspi->regmap, SPI_MCR, dspi->cur_chip->mcr_val);
+		regmap_update_bits(dspi->regmap, SPI_MCR,
+				SPI_MCR_CLR_TXF | SPI_MCR_CLR_RXF,
+				SPI_MCR_CLR_TXF | SPI_MCR_CLR_RXF);
 		regmap_write(dspi->regmap, SPI_CTAR(dspi->cs),
 				dspi->cur_chip->ctar_val);
+		if (transfer->speed_hz)
+			regmap_write(dspi->regmap, SPI_CTAR(dspi->cs),
+					dspi->cur_chip->ctar_val);
 
-	dspi_transfer_write(dspi);
-
-	if (wait_event_interruptible(dspi->waitq, dspi->waitflags))
-		dev_err(&dspi->pdev->dev, "wait transfer complete fail!\n");
-	dspi->waitflags = 0;
-
-	return t->len - dspi->len;
-}
-
-static void dspi_chipselect(struct spi_device *spi, int value)
-{
-	struct fsl_dspi *dspi = spi_master_get_devdata(spi->master);
-	unsigned int pushr;
+		regmap_write(dspi->regmap, SPI_RSER, SPI_RSER_EOQFE);
+		message->actual_length += dspi_transfer_write(dspi);
 
-	regmap_read(dspi->regmap, SPI_PUSHR, &pushr);
+		if (wait_event_interruptible(dspi->waitq, dspi->waitflags))
+			dev_err(&dspi->pdev->dev, "wait transfer complete fail!\n");
+		dspi->waitflags = 0;
 
-	switch (value) {
-	case BITBANG_CS_ACTIVE:
-		pushr |= SPI_PUSHR_CONT;
-		break;
-	case BITBANG_CS_INACTIVE:
-		pushr &= ~SPI_PUSHR_CONT;
-		break;
+		if (transfer->delay_usecs)
+			udelay(transfer->delay_usecs);
 	}
 
-	regmap_write(dspi->regmap, SPI_PUSHR, pushr);
+	message->status = status;
+	spi_finalize_current_message(master);
+
+	return status;
 }
 
-static int dspi_setup_transfer(struct spi_device *spi, struct spi_transfer *t)
+static int dspi_setup(struct spi_device *spi)
 {
 	struct chip_data *chip;
 	struct fsl_dspi *dspi = spi_master_get_devdata(spi->master);
@@ -373,14 +381,6 @@ static int dspi_setup_transfer(struct spi_device *spi, struct spi_transfer *t)
 	return 0;
 }
 
-static int dspi_setup(struct spi_device *spi)
-{
-	if (!spi->max_speed_hz)
-		return -EINVAL;
-
-	return dspi_setup_transfer(spi, NULL);
-}
-
 static void dspi_cleanup(struct spi_device *spi)
 {
 	struct chip_data *chip = spi_get_ctldata((struct spi_device *)spi);
@@ -395,22 +395,20 @@ static irqreturn_t dspi_interrupt(int irq, void *dev_id)
 {
 	struct fsl_dspi *dspi = (struct fsl_dspi *)dev_id;
 
-	regmap_write(dspi->regmap, SPI_SR, SPI_SR_EOQF);
+	struct spi_message *msg = dspi->cur_msg;
 
+	regmap_write(dspi->regmap, SPI_SR, SPI_SR_EOQF);
 	dspi_transfer_read(dspi);
 
 	if (!dspi->len) {
 		if (dspi->dataflags & TRAN_STATE_WORD_ODD_NUM)
 			regmap_update_bits(dspi->regmap, SPI_CTAR(dspi->cs),
-				SPI_FRAME_BITS_MASK, SPI_FRAME_BITS(16));
+			SPI_FRAME_BITS_MASK, SPI_FRAME_BITS(16));
 
 		dspi->waitflags = 1;
 		wake_up_interruptible(&dspi->waitq);
-	} else {
-		dspi_transfer_write(dspi);
-
-		return IRQ_HANDLED;
-	}
+	} else
+		msg->actual_length += dspi_transfer_write(dspi);
 
 	return IRQ_HANDLED;
 }
@@ -469,12 +467,12 @@ static int dspi_probe(struct platform_device *pdev)
 
 	dspi = spi_master_get_devdata(master);
 	dspi->pdev = pdev;
-	dspi->bitbang.master = master;
-	dspi->bitbang.chipselect = dspi_chipselect;
-	dspi->bitbang.setup_transfer = dspi_setup_transfer;
-	dspi->bitbang.txrx_bufs = dspi_txrx_transfer;
-	dspi->bitbang.master->setup = dspi_setup;
-	dspi->bitbang.master->dev.of_node = pdev->dev.of_node;
+	dspi->master = master;
+
+	master->transfer = NULL;
+	master->setup = dspi_setup;
+	master->transfer_one_message = dspi_transfer_one_message;
+	master->dev.of_node = pdev->dev.of_node;
 
 	master->cleanup = dspi_cleanup;
 	master->mode_bits = SPI_CPOL | SPI_CPHA;
@@ -535,7 +533,7 @@ static int dspi_probe(struct platform_device *pdev)
 	init_waitqueue_head(&dspi->waitq);
 	platform_set_drvdata(pdev, master);
 
-	ret = spi_bitbang_start(&dspi->bitbang);
+	ret = spi_register_master(master);
 	if (ret != 0) {
 		dev_err(&pdev->dev, "Problem registering DSPI master\n");
 		goto out_clk_put;
@@ -557,9 +555,9 @@ static int dspi_remove(struct platform_device *pdev)
 	struct fsl_dspi *dspi = spi_master_get_devdata(master);
 
 	/* Disconnect from the SPI framework */
-	spi_bitbang_stop(&dspi->bitbang);
 	clk_disable_unprepare(dspi->clk);
-	spi_master_put(dspi->bitbang.master);
+	spi_unregister_master(dspi->master);
+	spi_master_put(dspi->master);
 
 	return 0;
 }
-- 
2.2.2

