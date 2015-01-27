Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758150AbbA0K6h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 05:58:37 -0500
Received: from mail-am1on0147.outbound.protection.outlook.com ([157.56.112.147]:16992
	"EHLO emea01-am1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758038AbbA0K6c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 05:58:32 -0500
From: Bhuvanchandra DV <bhuvanchandra.dv@toradex.com>
To: <mark.rutland@arm.com>
CC: <stefan@agner.ch>, <shawn.guo@linaro.org>, <robh+dt@kernel.org>,
        <pawel.moll@arm.com>, <ijc+devicetree@hellion.org.uk>,
        <galak@codeaurora.org>, <linux@arm.linux.org.uk>, <broonie@kernel.org>,
        <B44548@freescale.com>, <Li.Xiubo@freescale.com>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-spi@vger.kernel.org>,
        Bhuvanchandra DV <bhuvanchandra.dv@toradex.com>
Subject: [PATCH 7/7] spi: spi-fsl-dspi: Add support for TCFQ transfer mode
Date: Tue, 27 Jan 2015 16:33:28 +0530
Message-ID: <1422356608-15961-2-git-send-email-bhuvanchandra.dv@toradex.com>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <1422356608-15961-1-git-send-email-bhuvanchandra.dv@toradex.com>
References: <1422356608-15961-1-git-send-email-bhuvanchandra.dv@toradex.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [122.166.214.162]
X-ClientProxiedBy: HKNPR04CA002.apcprd04.prod.outlook.com (10.242.116.32) To
 DB3PR05MB267.eurprd05.prod.outlook.com (10.141.4.26)
Authentication-Results: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=toradex.com;
X-DmarcAction-Test: None
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(3005004);SRVR:DB3PR05MB267;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:DB3PR05MB267;
X-Forefront-PRVS: 046985391D
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(6009001)(575784001)(33646002)(77096005)(87976001)(50986999)(76176999)(229853001)(2950100001)(42186005)(217423001)(86362001)(122386002)(110136001)(92566002)(50226001)(36756003)(53416004)(230783001)(66066001)(50466002)(19580395003)(62966003)(47776003)(46102003)(19580405001)(77156002)(48376002)(40100003)(2351001)(7059030);DIR:OUT;SFP:1102;SCL:1;SRVR:DB3PR05MB267;H:dvb.toradex.ext;FPR:;SPF:None;MLV:sfv;LANG:en;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:DB3PR05MB267;
X-OriginatorOrg: toradex.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2015 10:58:22.9617 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB3PR05MB267
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chao Fu <B44548@freescale.com>

TCFQ is interrupt of Transfer Complete Flag in DSPI module.
EOQ is interrupt of End of Queue Flag in DSPI module.
For adopting of different platform, either of them is a way of DSPI
transfer data. This patch add TCF support for DSPI module  in other platform.

Signed-off-by: Bhuvanchandra DV <bhuvanchandra.dv@toradex.com>
---
 .../devicetree/bindings/spi/spi-fsl-dspi.txt       |  2 +
 drivers/spi/spi-fsl-dspi.c                         | 74 +++++++++++++++++++---
 2 files changed, 68 insertions(+), 8 deletions(-)

diff --git a/Documentation/devicetree/bindings/spi/spi-fsl-dspi.txt b/Documentation/devicetree/bindings/spi/spi-fsl-dspi.txt
index cbbe16e..b50439f 100644
--- a/Documentation/devicetree/bindings/spi/spi-fsl-dspi.txt
+++ b/Documentation/devicetree/bindings/spi/spi-fsl-dspi.txt
@@ -15,6 +15,8 @@ Optional property:
 - big-endian: If present the dspi device's registers are implemented
   in big endian mode, otherwise in native mode(same with CPU), for more
   detail please see: Documentation/devicetree/bindings/regmap/regmap.txt.
+- tcfq-mode: If present, the data transfer will be done at TCFQ interrupt.
+  By default, driver chooses EOQ interrupt if 'tcfq-mode' property was not set.
 
 Example:
 
diff --git a/drivers/spi/spi-fsl-dspi.c b/drivers/spi/spi-fsl-dspi.c
index e0ce906..feca2fd 100644
--- a/drivers/spi/spi-fsl-dspi.c
+++ b/drivers/spi/spi-fsl-dspi.c
@@ -63,9 +63,11 @@
 #define SPI_CTAR0_SLAVE	0x0c
 
 #define SPI_SR			0x2c
+#define SPI_SR_TCFQF		0x80000000
 #define SPI_SR_EOQF		0x10000000
 
 #define SPI_RSER		0x30
+#define SPI_RSER_TCFQE		0x80000000
 #define SPI_RSER_EOQFE		0x10000000
 
 #define SPI_PUSHR		0x34
@@ -105,6 +107,12 @@ struct chip_data {
 	u16 void_write_data;
 };
 
+enum dspi_trans_mode {
+	DSPI_EOQ_MODE = 0,
+	DSPI_TCFQ_MODE,
+	DSPI_DMA_MODE, /*TODO*/
+};
+
 struct fsl_dspi {
 	struct spi_master	*master;
 	struct platform_device	*pdev;
@@ -125,6 +133,7 @@ struct fsl_dspi {
 	u8			cs;
 	u16			void_write_data;
 	u32			cs_change;
+	enum dspi_trans_mode	trans_mode;
 
 	wait_queue_head_t	waitq;
 	u32			waitflags;
@@ -225,7 +234,7 @@ static void dspi_data_from_popr(struct fsl_dspi *dspi, int rx_word)
 	}
 }
 
-static int dspi_transfer_write(struct fsl_dspi *dspi)
+static int dspi_eoq_write(struct fsl_dspi *dspi)
 {
 	int tx_count = 0;
 	int tx_word;
@@ -269,7 +278,7 @@ static int dspi_transfer_write(struct fsl_dspi *dspi)
 	return tx_count * (tx_word + 1);
 }
 
-static int dspi_transfer_read(struct fsl_dspi *dspi)
+static int dspi_eoq_read(struct fsl_dspi *dspi)
 {
 	int rx_count = 0;
 	int rx_word = is_double_byte_mode(dspi);
@@ -283,6 +292,37 @@ static int dspi_transfer_read(struct fsl_dspi *dspi)
 	return rx_count;
 }
 
+static int dspi_tcfq_write(struct fsl_dspi *dspi)
+{
+	int tx_word;
+	u32 dspi_pushr = 0;
+
+	tx_word = is_double_byte_mode(dspi);
+
+	if (tx_word && (dspi->len == 1)) {
+		dspi->dataflags |= TRAN_STATE_WORD_ODD_NUM;
+		regmap_update_bits(dspi->regmap, SPI_CTAR(dspi->cs),
+				SPI_FRAME_BITS_MASK, SPI_FRAME_BITS(8));
+		tx_word = 0;
+	}
+
+	dspi_pushr = dspi_data_to_pushr(dspi, tx_word);
+
+	if ((dspi->cs_change) && (!dspi->len))
+		dspi_pushr &= ~SPI_PUSHR_CONT;
+
+	regmap_write(dspi->regmap, SPI_PUSHR, dspi_pushr);
+
+	return tx_word + 1;
+}
+
+static void dspi_tcfq_read(struct fsl_dspi *dspi)
+{
+	int rx_word = is_double_byte_mode(dspi);
+
+	dspi_data_from_popr(dspi, rx_word);
+}
+
 static int dspi_transfer_one_message(struct spi_master *master,
 		struct spi_message *message)
 {
@@ -326,8 +366,13 @@ static int dspi_transfer_one_message(struct spi_master *master,
 			regmap_write(dspi->regmap, SPI_CTAR(dspi->cs),
 					dspi->cur_chip->ctar_val);
 
-		regmap_write(dspi->regmap, SPI_RSER, SPI_RSER_EOQFE);
-		message->actual_length += dspi_transfer_write(dspi);
+		if (dspi->trans_mode == DSPI_EOQ_MODE) {
+			regmap_write(dspi->regmap, SPI_RSER, SPI_RSER_EOQFE);
+			message->actual_length += dspi_eoq_write(dspi);
+		} else if (dspi->trans_mode == DSPI_TCFQ_MODE) {
+			regmap_write(dspi->regmap, SPI_RSER, SPI_RSER_TCFQE);
+			message->actual_length += dspi_tcfq_write(dspi);
+		}
 
 		if (wait_event_interruptible(dspi->waitq, dspi->waitflags))
 			dev_err(&dspi->pdev->dev, "wait transfer complete fail!\n");
@@ -399,8 +444,13 @@ static irqreturn_t dspi_interrupt(int irq, void *dev_id)
 
 	struct spi_message *msg = dspi->cur_msg;
 
-	regmap_write(dspi->regmap, SPI_SR, SPI_SR_EOQF);
-	dspi_transfer_read(dspi);
+	if (dspi->trans_mode == DSPI_EOQ_MODE) {
+		regmap_write(dspi->regmap, SPI_SR, SPI_SR_EOQF);
+		dspi_eoq_read(dspi);
+	} else if (dspi->trans_mode == DSPI_TCFQ_MODE) {
+		regmap_write(dspi->regmap, SPI_SR, SPI_SR_TCFQF);
+		dspi_tcfq_read(dspi);
+	}
 
 	if (!dspi->len) {
 		if (dspi->dataflags & TRAN_STATE_WORD_ODD_NUM)
@@ -409,8 +459,12 @@ static irqreturn_t dspi_interrupt(int irq, void *dev_id)
 
 		dspi->waitflags = 1;
 		wake_up_interruptible(&dspi->waitq);
-	} else
-		msg->actual_length += dspi_transfer_write(dspi);
+	} else {
+		if (dspi->trans_mode == DSPI_EOQ_MODE)
+			msg->actual_length += dspi_eoq_write(dspi);
+		else if (dspi->trans_mode == DSPI_TCFQ_MODE)
+			msg->actual_length += dspi_tcfq_write(dspi);
+	}
 
 	return IRQ_HANDLED;
 }
@@ -470,6 +524,7 @@ static int dspi_probe(struct platform_device *pdev)
 	dspi = spi_master_get_devdata(master);
 	dspi->pdev = pdev;
 	dspi->master = master;
+	dspi->trans_mode = DSPI_EOQ_MODE;
 
 	master->transfer = NULL;
 	master->setup = dspi_setup;
@@ -481,6 +536,9 @@ static int dspi_probe(struct platform_device *pdev)
 	master->bits_per_word_mask = SPI_BPW_MASK(4) | SPI_BPW_MASK(8) |
 					SPI_BPW_MASK(16);
 
+	if (of_property_read_bool(np, "tcfq-mode"))
+		dspi->trans_mode = DSPI_TCFQ_MODE;
+
 	ret = of_property_read_u32(np, "spi-num-chipselects", &cs_num);
 	if (ret < 0) {
 		dev_err(&pdev->dev, "can't get spi-num-chipselects\n");
-- 
2.2.2

