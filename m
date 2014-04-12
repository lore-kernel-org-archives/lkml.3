Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755408AbaDLTDz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2014 15:03:55 -0400
Received: from mail-bn1blp0181.outbound.protection.outlook.com ([207.46.163.181]:21507
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753715AbaDLTDy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2014 15:03:54 -0400
X-Greylist: delayed 866 seconds by postgrey-1.27 at vger.kernel.org; Sat, 12 Apr 2014 15:03:54 EDT
From: Jane Wan <Jane.Wan@gainspeed.com>
To: <grant.likely@secretlab.ca>, <rob.herring@calxeda.com>,
        <broonie@kernel.org>, <Emilian.Medve@Freescale.com>,
        <kenth.eriksson@transmode.com>, <thomas.de.schampheleire@gmail.com>,
        <b48286@Freescale.com>, <jg1.han@samsung.com>, <sr@denx.de>,
        <insop.song@gainspeed.com>
CC: <spi-devel-general@lists.sourceforge.net>, <linux-kernel@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>,
        Jane Wan <Jane.Wan@gainspeed.com>
Subject: [PATCH] Configure FSL eSPI CSBEF, CSAFT, and whether to send all received data to user
Date: Sat, 12 Apr 2014 11:48:36 -0700
Message-ID: <1397328516-13260-2-git-send-email-Jane.Wan@gainspeed.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1397328516-13260-1-git-send-email-Jane.Wan@gainspeed.com>
References: <1397328516-13260-1-git-send-email-Jane.Wan@gainspeed.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [108.60.97.2]
X-Forefront-PRVS: 01792087B6
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009001)(6009001)(428001)(199002)(189002)(50226001)(4396001)(81342001)(74502001)(66066001)(19580395003)(62966002)(76176999)(83322001)(19580405001)(79102001)(77156001)(74662001)(31966008)(77982001)(50986999)(80022001)(46102001)(36756003)(81542001)(50466002)(80976001)(99396002)(15202345003)(20776003)(47776003)(2201001)(92566001)(89996001)(48376002)(87936001)(87286001)(88136002)(83072002)(93916002)(15975445006)(86362001)(85852003)(92726001)(921003)(1121002);DIR:OUT;SFP:1101;SCL:1;SRVR:BLUPR07MB465;H:BY2PRD0711HT002.namprd07.prod.outlook.com;FPR:B8FD7507.A7F29F08.73D2B0AB.423FAAE1.2041B;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
X-OriginatorOrg: gainspeed.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make FSL eSPI CSnBEF and CSnAFT in ESPI_SPMODEn registers (n=0,1,2,3)
configurable through device tree.  FSL eSPI driver hardcodes them to 0.
Some device requires different value.

Allow FSL eSPI driver configurable whether to send all received data
form slave devices to user.  When user wants to send n_tx bytes and
receives n_rx bytes, FSL eSPI driver sends (n_tx + n_rx) bytes on MOSI.
For the received (n_tx + n_rx) bytes from MISO, current FSL eSPI driver
drops the first n_tx bytes, only passes the last n_rx bytes to user.
Some device driver has problem with this.  It requires to know all bytes
that the slave device puts on MISO.

Part of this fix is based on a previous patch:
http://www.mail-archive.com/spi-devel-general@lists.sourceforge.net/msg08658.html

Signed-off-by: Jane Wan <Jane.Wan@gainspeed.com>
---
 drivers/spi/spi-fsl-espi.c       |   68 ++++++++++++++++++++++++++++++++++----
 1 files changed, 61 insertions(+), 7 deletions(-)

diff --git a/drivers/spi/spi-fsl-espi.c b/drivers/spi/spi-fsl-espi.c
index 0622165..660039c 100644
--- a/drivers/spi/spi-fsl-espi.c
+++ b/drivers/spi/spi-fsl-espi.c
@@ -45,6 +45,9 @@ struct fsl_espi_transfer {
 	int status;
 };
 
+/* whether to send all rx data to user per chip select */
+static u8 *spi_raw_rxdata_to_user;
+
 /* eSPI Controller mode register definitions */
 #define SPMODE_ENABLE		(1 << 31)
 #define SPMODE_LOOP		(1 << 30)
@@ -398,12 +401,19 @@ static void fsl_espi_rw_trans(struct spi_message *m,
 
 		espi_trans->n_tx = n_tx;
 		espi_trans->n_rx = trans_len;
-		espi_trans->len = trans_len + n_tx;
+		if (spi_raw_rxdata_to_user[m->spi->chip_select])
+			espi_trans->len = n_tx;
+		else
+			espi_trans->len = trans_len + n_tx;
 		espi_trans->tx_buf = local_buf;
 		espi_trans->rx_buf = local_buf + n_tx;
 		fsl_espi_do_trans(m, espi_trans);
 
-		memcpy(rx_buf + pos, espi_trans->rx_buf + n_tx, trans_len);
+		if (spi_raw_rxdata_to_user[m->spi->chip_select])
+			memcpy(rx_buf + pos, espi_trans->rx_buf, trans_len);
+		else
+			memcpy(rx_buf + pos, espi_trans->rx_buf + n_tx,
+				trans_len);
 
 		if (loop > 0)
 			espi_trans->actual_length += espi_trans->len - n_tx;
@@ -433,7 +443,10 @@ static void fsl_espi_do_one_msg(struct spi_message *m)
 
 	espi_trans.n_tx = n_tx;
 	espi_trans.n_rx = n_rx;
-	espi_trans.len = n_tx + n_rx;
+	if (spi_raw_rxdata_to_user[m->spi->chip_select])
+		espi_trans.len = n_tx;
+	else
+		espi_trans.len = n_tx + n_rx;
 	espi_trans.actual_length = 0;
 	espi_trans.status = 0;
 
@@ -579,6 +592,7 @@ static irqreturn_t fsl_espi_irq(s32 irq, void *context_data)
 static void fsl_espi_remove(struct mpc8xxx_spi *mspi)
 {
 	iounmap(mspi->reg_base);
+	kfree(spi_raw_rxdata_to_user);
 }
 
 static struct spi_master * fsl_espi_probe(struct device *dev,
@@ -588,8 +602,10 @@ static struct spi_master * fsl_espi_probe(struct device *dev,
 	struct spi_master *master;
 	struct mpc8xxx_spi *mpc8xxx_spi;
 	struct fsl_espi_reg *reg_base;
-	u32 regval;
-	int i, ret = 0;
+	struct device_node *nc;
+	const __be32 *prop;
+	u32 regval, csmode;
+	int i, len, ret = 0;
 
 	master = spi_alloc_master(dev, sizeof(struct mpc8xxx_spi));
 	if (!master) {
@@ -635,9 +651,45 @@ static struct spi_master * fsl_espi_probe(struct device *dev,
 	mpc8xxx_spi_write_reg(&reg_base->command, 0);
 	mpc8xxx_spi_write_reg(&reg_base->event, 0xffffffff);
 
+	spi_raw_rxdata_to_user = kzalloc(pdata->max_chipselect, GFP_KERNEL);
+	if (!spi_raw_rxdata_to_user) {
+		ret = -ENOMEM;
+		goto err_spi_raw_rxdata_to_user;
+	}
+
 	/* Init eSPI CS mode register */
-	for (i = 0; i < pdata->max_chipselect; i++)
-		mpc8xxx_spi_write_reg(&reg_base->csmode[i], CSMODE_INIT_VAL);
+	for_each_available_child_of_node(master->dev.of_node, nc) {
+		/* get chip select */
+		prop = of_get_property(nc, "reg", &len);
+		if (!prop || len < sizeof(*prop))
+			continue;
+		i = be32_to_cpup(prop);
+		if (i < 0 || i >= pdata->max_chipselect)
+			continue;
+
+		csmode = CSMODE_INIT_VAL;
+		/* check if CSBEF is set in device tree */
+		prop = of_get_property(nc, "fsl,csbef", &len);
+		if (prop && len >= sizeof(*prop)) {
+			csmode &= ~(CSMODE_BEF(0xf));
+			csmode |= CSMODE_BEF(be32_to_cpup(prop));
+		}
+		/* check if CSAFT is set in device tree */
+		prop = of_get_property(nc, "fsl,csaft", &len);
+		if (prop && len >= sizeof(*prop)) {
+			csmode &= ~(CSMODE_AFT(0xf));
+			csmode |= CSMODE_AFT(be32_to_cpup(prop));
+		}
+		mpc8xxx_spi_write_reg(&reg_base->csmode[i], csmode);
+
+		/* check if set to send all received data to user */
+		prop = of_get_property(nc, "fsl,spi-raw-rxdata-to-user", &len);
+		if (prop && len >= sizeof(*prop))
+			spi_raw_rxdata_to_user[i] = be32_to_cpup(prop);
+
+		dev_info(dev, "cs=%d, init_csmode=0x%x, spi_raw_rxdata_to_user=%d\n",
+			 i, csmode, spi_raw_rxdata_to_user[i]);
+	}
 
 	/* Enable SPI interface */
 	regval = pdata->initial_spmode | SPMODE_INIT_VAL | SPMODE_ENABLE;
@@ -653,6 +705,8 @@ static struct spi_master * fsl_espi_probe(struct device *dev,
 	return master;
 
 unreg_master:
+	kfree(spi_raw_rxdata_to_user);
+err_spi_raw_rxdata_to_user:
 	free_irq(mpc8xxx_spi->irq, mpc8xxx_spi);
 free_irq:
 	iounmap(mpc8xxx_spi->reg_base);
-- 
1.7.9.5

