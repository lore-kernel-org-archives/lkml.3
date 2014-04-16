Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752157AbaDPQjy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 12:39:54 -0400
Received: from mail-bn1lp0139.outbound.protection.outlook.com ([207.46.163.139]:32539
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750997AbaDPQjv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 12:39:51 -0400
From: Jane Wan <Jane.Wan@gainspeed.com>
To: Mark Brown <broonie@kernel.org>
CC: "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "Emilian.Medve@Freescale.com" <Emilian.Medve@Freescale.com>,
        "kenth.eriksson@transmode.com" <kenth.eriksson@transmode.com>,
        "thomas.de.schampheleire@gmail.com" 
	<thomas.de.schampheleire@gmail.com>,
        "b48286@freescale.com" <b48286@Freescale.com>,
        "jg1.han@samsung.com" <jg1.han@samsung.com>, "sr@denx.de" <sr@denx.de>,
        Insop Song <Insop.Song@gainspeed.com>,
        "linux-spi@vger.kernel.org" <linux-spi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: RE: [PATCH] Configure FSL eSPI CSBEF, CSAFT, and whether to send
 all received data to user
Thread-Topic: [PATCH] Configure FSL eSPI CSBEF, CSAFT, and whether to send
 all received data to user
Thread-Index: AQHPVn/ZKY5Y8oOa/ke19ln04KEqbZsOUp8AgANIMoCAAtLukA==
Date: Wed, 16 Apr 2014 16:39:47 +0000
Message-ID: <6f2c800fbba74470a6a49903b34e7796@SN2PR07MB064.namprd07.prod.outlook.com>
References: <1397328516-13260-1-git-send-email-Jane.Wan@gainspeed.com>
 <1397328516-13260-2-git-send-email-Jane.Wan@gainspeed.com>
 <20140414205547.GI25182@sirena.org.uk>
In-Reply-To: <20140414205547.GI25182@sirena.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [108.60.97.2]
x-forefront-prvs: 01834E39B7
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(428001)(24454002)(51704005)(199002)(189002)(87936001)(46102001)(50986999)(74316001)(76176999)(54356999)(99396002)(20776003)(4396001)(80022001)(99286001)(83072002)(66066001)(31966008)(80976001)(81542001)(19580405001)(19580395003)(83322001)(86362001)(79102001)(85852003)(77982001)(2656002)(81342001)(74662001)(76576001)(33646001)(92566001)(74502001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:SN2PR07MB014;H:SN2PR07MB064.namprd07.prod.outlook.com;FPR:BEF7F276.A0F65D18.73D2B8A7.56ED52E1.20545;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: gainspeed.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 14, 2014 at 09:51:56PM +0100, Mark Brown wrote:
> On Sat, Apr 12, 2014 at 11:48:36AM -0700, Jane Wan wrote:
> > Make FSL eSPI CSnBEF and CSnAFT in ESPI_SPMODEn registers (n=0,1,2,3)
> > configurable through device tree.  FSL eSPI driver hardcodes them to 0.
> > Some device requires different value.
> 
> What do these do?

CSnBEF is the chip select setup time.  It's the delay in bits from the activation 
of chip select pin to the first clock for data frame.

CSnAFT is the chip select hold time.  It's the delay in bits from the last clock 
for data frame to the deactivation of chip select pin.

> > Allow FSL eSPI driver configurable whether to send all received data
> > form slave devices to user.  When user wants to send n_tx bytes and
> > receives n_rx bytes, FSL eSPI driver sends (n_tx + n_rx) bytes on MOSI.
> > For the received (n_tx + n_rx) bytes from MISO, current FSL eSPI
> > driver drops the first n_tx bytes, only passes the last n_rx bytes to user.
> > Some device driver has problem with this.  It requires to know all
> > bytes that the slave device puts on MISO.
> 
> This sounds like a separate patch to the first one, the described behaviour is
> definitely buggy and any correctly implemented Linux driver that does
> bidirectional I/O will have trouble with it.  It should be split out from the new DT
> bindings which are a new feature.
> 
> > ---
> >  drivers/spi/spi-fsl-espi.c       |   68 ++++++++++++++++++++++++++++++++++---
> -
> >  1 files changed, 61 insertions(+), 7 deletions(-)
> 
> All DT binding changes need to be documented in the binding document.

The binding document is updated.  The new changes (for CSnBEF and CSnAFT only)  will 
look like the following.  If this is ok, I'll send it as a separate patch for further discussion.

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
diff --git a/drivers/spi/spi-fsl-espi.c b/drivers/spi/spi-fsl-espi.c index 428dc7a..7ff9463 100644
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

> > +/* whether to send all rx data to user per chip select */ static u8
> > +*spi_raw_rxdata_to_user;
> > +
> 
> No, any data needs to be part of the driver data structure not a global variable.

I will look into this.

> > +		if (spi_raw_rxdata_to_user[m->spi->chip_select])
> > +			espi_trans->len = n_tx;
> > +		else
> > +			espi_trans->len = trans_len + n_tx;
> 
> Why is there even an option for the buggy behaviour?

We have three devices attached to the FSL eSPI interface, with chip select (CS) 
0-2. The device driver for the device at CS #2 requires to know all the data that 
the slave device put on MISO.  But the device drivers for the other two devices 
(at CS #0 and #1) work with the existing FSL eSPI driver.  The device at CS #0 is 
Micron n25q512a compatible.

We make the FSL eSPI driver configurable through device tree.  If we make a fix 
without the DT option, the fix will break other device drivers working with the 
existing FSL eSPI driver.

Could this still be considered as a solution?  If this is ok, I can send it as a separate 
patch.  Otherwise, we will look if this driver can be modified without DT option.

Regards,
Jane
