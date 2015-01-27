Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758033AbbA0K61 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 05:58:27 -0500
Received: from mail-am1on0128.outbound.protection.outlook.com ([157.56.112.128]:40384
	"EHLO emea01-am1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753174AbbA0K6Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 05:58:25 -0500
X-Greylist: delayed 348 seconds by postgrey-1.27 at vger.kernel.org; Tue, 27 Jan 2015 05:58:24 EST
From: Bhuvanchandra DV <bhuvanchandra.dv@toradex.com>
To: <mark.rutland@arm.com>
CC: <stefan@agner.ch>, <shawn.guo@linaro.org>, <robh+dt@kernel.org>,
        <pawel.moll@arm.com>, <ijc+devicetree@hellion.org.uk>,
        <galak@codeaurora.org>, <linux@arm.linux.org.uk>, <broonie@kernel.org>,
        <B44548@freescale.com>, <Li.Xiubo@freescale.com>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-spi@vger.kernel.org>,
        Bhuvanchandra DV <bhuvanchandra.dv@toradex.com>
Subject: [PATCH 6/7] spi: spi-fsl-dspi: split the resuable code
Date: Tue, 27 Jan 2015 16:33:27 +0530
Message-ID: <1422356608-15961-1-git-send-email-bhuvanchandra.dv@toradex.com>
X-Mailer: git-send-email 2.2.2
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
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(6009001)(575784001)(33646002)(77096005)(87976001)(50986999)(229853001)(42186005)(86362001)(122386002)(110136001)(92566002)(50226001)(36756003)(53416004)(230783001)(66066001)(50466002)(19580395003)(62966003)(47776003)(46102003)(19580405001)(77156002)(48376002)(40100003)(2351001)(7059030);DIR:OUT;SFP:1102;SCL:1;SRVR:DB3PR05MB267;H:dvb.toradex.ext;FPR:;SPF:None;MLV:sfv;LANG:en;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:DB3PR05MB267;
X-OriginatorOrg: toradex.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2015 10:58:15.0867 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB3PR05MB267
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chao Fu <B44548@freescale.com>

Add two functions:
- dspi_data_from_popr
- dspi_data_to_pushr

Signed-off-by: Bhuvanchandra DV <bhuvanchandra.dv@toradex.com>
---
 drivers/spi/spi-fsl-dspi.c | 118 +++++++++++++++++++++++----------------------
 1 file changed, 60 insertions(+), 58 deletions(-)

diff --git a/drivers/spi/spi-fsl-dspi.c b/drivers/spi/spi-fsl-dspi.c
index b20dbb5..e0ce906 100644
--- a/drivers/spi/spi-fsl-dspi.c
+++ b/drivers/spi/spi-fsl-dspi.c
@@ -167,12 +167,68 @@ static void hz_to_spi_baud(char *pbr, char *br, int speed_hz,
 	*br =  ARRAY_SIZE(brs) - 1;
 }
 
+static u32 dspi_data_to_pushr(struct fsl_dspi *dspi, int tx_word)
+{
+	u16 d16;
+	u8 d8;
+
+	if (tx_word) {
+		if (!(dspi->dataflags & TRAN_STATE_TX_VOID)) {
+			d16 = *(u16 *)dspi->tx;
+			dspi->tx += 2;
+		} else {
+			d16 = dspi->void_write_data;
+		}
+
+		dspi->len -= 2;
+
+		return	SPI_PUSHR_TXDATA(d16) |
+			SPI_PUSHR_PCS(dspi->cs) |
+			SPI_PUSHR_CTAS(dspi->cs) |
+			SPI_PUSHR_CONT;
+	} else {
+		if (!(dspi->dataflags & TRAN_STATE_TX_VOID)) {
+
+			d8 = *(u8 *)dspi->tx;
+			dspi->tx++;
+		} else {
+			d8 = (u8)dspi->void_write_data;
+		}
+
+		dspi->len--;
+
+		return SPI_PUSHR_TXDATA(d8) |
+			SPI_PUSHR_PCS(dspi->cs) |
+			SPI_PUSHR_CTAS(dspi->cs) |
+			SPI_PUSHR_CONT;
+	}
+}
+
+static void dspi_data_from_popr(struct fsl_dspi *dspi, int rx_word)
+{
+	u16 d;
+	unsigned int val;
+
+	if (rx_word) {
+		regmap_read(dspi->regmap, SPI_POPR, &val);
+		d = SPI_POPR_RXDATA(val);
+
+		if (!(dspi->dataflags & TRAN_STATE_RX_VOID))
+			*(u16 *)dspi->rx = d;
+		dspi->rx += 2;
+	} else {
+		regmap_read(dspi->regmap, SPI_POPR, &val);
+		d = SPI_POPR_RXDATA(val);
+		if (!(dspi->dataflags & TRAN_STATE_RX_VOID))
+			*(u8 *)dspi->rx = d;
+		dspi->rx++;
+	}
+}
+
 static int dspi_transfer_write(struct fsl_dspi *dspi)
 {
 	int tx_count = 0;
 	int tx_word;
-	u16 d16;
-	u8  d8;
 	u32 dspi_pushr = 0;
 	int first = 1;
 
@@ -190,39 +246,7 @@ static int dspi_transfer_write(struct fsl_dspi *dspi)
 	}
 
 	while (dspi->len && (tx_count < DSPI_FIFO_SIZE)) {
-		if (tx_word) {
-			if (dspi->len == 1)
-				break;
-
-			if (!(dspi->dataflags & TRAN_STATE_TX_VOID)) {
-				d16 = *(u16 *)dspi->tx;
-				dspi->tx += 2;
-			} else {
-				d16 = dspi->void_write_data;
-			}
-
-			dspi_pushr = SPI_PUSHR_TXDATA(d16) |
-				SPI_PUSHR_PCS(dspi->cs) |
-				SPI_PUSHR_CTAS(dspi->cs) |
-				SPI_PUSHR_CONT;
-
-			dspi->len -= 2;
-		} else {
-			if (!(dspi->dataflags & TRAN_STATE_TX_VOID)) {
-
-				d8 = *(u8 *)dspi->tx;
-				dspi->tx++;
-			} else {
-				d8 = (u8)dspi->void_write_data;
-			}
-
-			dspi_pushr = SPI_PUSHR_TXDATA(d8) |
-				SPI_PUSHR_PCS(dspi->cs) |
-				SPI_PUSHR_CTAS(dspi->cs) |
-				SPI_PUSHR_CONT;
-
-			dspi->len--;
-		}
+		dspi_pushr = dspi_data_to_pushr(dspi, tx_word);
 
 		if (dspi->len == 0 || tx_count == DSPI_FIFO_SIZE - 1) {
 			/* last transfer in the transfer */
@@ -249,32 +273,10 @@ static int dspi_transfer_read(struct fsl_dspi *dspi)
 {
 	int rx_count = 0;
 	int rx_word = is_double_byte_mode(dspi);
-	u16 d;
 
 	while ((dspi->rx < dspi->rx_end)
 			&& (rx_count < DSPI_FIFO_SIZE)) {
-		if (rx_word) {
-			unsigned int val;
-
-			if ((dspi->rx_end - dspi->rx) == 1)
-				break;
-
-			regmap_read(dspi->regmap, SPI_POPR, &val);
-			d = SPI_POPR_RXDATA(val);
-
-			if (!(dspi->dataflags & TRAN_STATE_RX_VOID))
-				*(u16 *)dspi->rx = d;
-			dspi->rx += 2;
-
-		} else {
-			unsigned int val;
-
-			regmap_read(dspi->regmap, SPI_POPR, &val);
-			d = SPI_POPR_RXDATA(val);
-			if (!(dspi->dataflags & TRAN_STATE_RX_VOID))
-				*(u8 *)dspi->rx = d;
-			dspi->rx++;
-		}
+		dspi_data_from_popr(dspi, rx_word);
 		rx_count++;
 	}
 
-- 
2.2.2

