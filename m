Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755734AbaDPUK2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 16:10:28 -0400
Received: from mail-bn1blp0181.outbound.protection.outlook.com ([207.46.163.181]:40812
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753049AbaDPUK0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 16:10:26 -0400
From: Jane Wan <Jane.Wan@gainspeed.com>
To: <broonie@kernel.org>, <grant.likely@linaro.org>, <robh+dt@kernel.org>,
        <Emilian.Medve@Freescale.com>, <b48286@Freescale.com>,
        <jg1.han@samsung.com>, <sr@denx.de>, <insop.song@gainspeed.com>
CC: <linux-spi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, Jane Wan <Jane.Wan@gainspeed.com>
Subject: [PATCH] Configure FSL eSPI CSBEF and CSAFT
Date: Wed, 16 Apr 2014 13:09:39 -0700
Message-ID: <1397678979-7655-1-git-send-email-Jane.Wan@gainspeed.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [157.56.245.69]
X-ClientProxiedBy: BLUPR07CA048.namprd07.prod.outlook.com (10.141.240.33) To
 BLUPR07MB050.namprd07.prod.outlook.com (10.255.208.150)
X-Forefront-PRVS: 01834E39B7
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009001)(6009001)(428001)(199002)(189002)(87286001)(4396001)(77156001)(50226001)(92566001)(87976001)(50466002)(80976001)(81542001)(2201001)(92726001)(19580395003)(81342001)(89996001)(83322001)(19580405001)(48376002)(83072002)(62966002)(88136002)(85852003)(99396002)(77982001)(42186004)(79102001)(47776003)(20776003)(80022001)(46102001)(66066001)(31966008)(93916002)(86362001)(74662001)(36756003)(50986999)(74502001);DIR:OUT;SFP:1101;SCL:1;SRVR:BLUPR07MB050;H:CH1PRD0210HT003.namprd02.prod.outlook.com;FPR:BEE7FA70.AF264F98.53D29B7F.42EE5221.20333;MLV:sfv;PTR:InfoNoRecords;A:3;MX:1;LANG:en;
X-OriginatorOrg: gainspeed.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make FSL eSPI CSnBEF and CSnAFT fields in ESPI_SPMODEn registers
(n=0,1,2,3) configurable through device tree.

CSnBEF is the chip select setup time.  It's the delay in bits from the
activation of chip select pin to the first clock for data frame.

CSnAFT is the chip select hold time.  It's the delay in bits from the
last clock for data frame to the deactivation of chip select pin.

The FSL eSPI driver hardcodes CSnBEF and CSnAFT to 0.  Need to set
them to a different value for some device.

Signed-off-by: Jane Wan <Jane.Wan@gainspeed.com>
---
 Documentation/devicetree/bindings/spi/fsl-spi.txt |    6 ++++
 drivers/spi/spi-fsl-espi.c                        |   34 ++++++++++++++++++---
 2 files changed, 36 insertions(+), 4 deletions(-)

diff --git a/Documentation/devicetree/bindings/spi/fsl-spi.txt b/Documentation/devicetree/bindings/spi/fsl-spi.txt
index b032dd7..2c7fd41 100644
--- a/Documentation/devicetree/bindings/spi/fsl-spi.txt
+++ b/Documentation/devicetree/bindings/spi/fsl-spi.txt
@@ -42,6 +42,10 @@ Required properties:
 - interrupts : should contain eSPI interrupt, the device has one interrupt.
 - fsl,espi-num-chipselects : the number of the chipselect signals.
 
+Optional properties:
+- fsl,csbef: chip select assertion time in bits before frame starts
+- fsl,csaft: chip select negation time in bits after frame ends
+
 Example:
 	spi@110000 {
 		#address-cells = <1>;
@@ -51,4 +55,6 @@ Example:
 		interrupts = <53 0x2>;
 		interrupt-parent = <&mpic>;
 		fsl,espi-num-chipselects = <4>;
+		fsl,csbef = <1>;
+		fsl,csaft = <1>;
 	};
diff --git a/drivers/spi/spi-fsl-espi.c b/drivers/spi/spi-fsl-espi.c
index 428dc7a..7ff9463 100644
--- a/drivers/spi/spi-fsl-espi.c
+++ b/drivers/spi/spi-fsl-espi.c
@@ -590,8 +590,10 @@ static struct spi_master * fsl_espi_probe(struct device *dev,
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
@@ -638,8 +640,32 @@ static struct spi_master * fsl_espi_probe(struct device *dev,
 	mpc8xxx_spi_write_reg(&reg_base->event, 0xffffffff);
 
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
+		dev_info(dev, "cs=%d, init_csmode=0x%x\n", i, csmode);
+	}
 
 	/* Enable SPI interface */
 	regval = pdata->initial_spmode | SPMODE_INIT_VAL | SPMODE_ENABLE;
-- 
1.7.9.5

