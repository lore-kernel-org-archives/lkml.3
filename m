Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754057AbaIBOfR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 10:35:17 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:55960 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753522AbaIBOfP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 10:35:15 -0400
Date: Tue, 2 Sep 2014 09:34:38 -0500
From: Felipe Balbi <balbi@ti.com>
To: Vivek Gautam <gautam.vivek@samsung.com>
CC: <linux-usb@vger.kernel.org>, <linux-samsung-soc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <gregkh@linuxfoundation.org>, <kishon@ti.com>, <balbi@ti.com>,
        <stern@rowland.harvard.edu>, <kgene.kim@samsung.com>,
        <heikki.krogerus@linux.intel.com>, <mathias.nyman@intel.com>,
        <sergei.shtylyov@cogentembedded.com>, <jg1.han@samsung.com>
Subject: Re: [PATCH v6 4/4] phy: exynos5-usbdrd: Calibrate LOS levels for
 exynos5420/5800
Message-ID: <20140902143438.GB16872@saruman.home>
Reply-To: <balbi@ti.com>
References: <1409656338-20337-1-git-send-email-gautam.vivek@samsung.com>
 <1409656338-20337-5-git-send-email-gautam.vivek@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="f2QGlHpHGjS2mn6Y"
Content-Disposition: inline
In-Reply-To: <1409656338-20337-5-git-send-email-gautam.vivek@samsung.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--f2QGlHpHGjS2mn6Y
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Sep 02, 2014 at 04:42:18PM +0530, Vivek Gautam wrote:
> Adding phy calibrate callback, which facilitates setting certain
> PHY settings post initialization of the PHY controller.
> Exynos5420 and Exynos5800 have 28nm USB 3.0 DRD PHY for which
> the Loss-of-Signal (LOS) Detector Threshold Level as well as
> Tx-Vboost-Level should be controlled for Super-Speed operations.
>=20
> Additionally set proper time to wait for RxDetect measurement,
> for desired PHY reference clock, so as to solve issue with enumeration
> of few USB 3.0 devices, like Samsung SUM-TSB16S 3.0 USB drive
> on the controller.
> We are using CR_port for this purpose to send required data
> to override the LOS values.
>=20
> On testing with USB 3.0 devices on USB 3.0 port present on
> SMDK5420, and peach-pit boards should see following message:
> usb 2-1: new SuperSpeed USB device number 2 using xhci-hcd
>=20
> and without this patch, should see below shown message:
> usb 1-1: new high-speed USB device number 2 using xhci-hcd
>=20
> [Also removed unnecessary extra lines in the register macro definitions]
>=20
> Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
> ---
>  drivers/phy/phy-exynos5-usbdrd.c |  185 ++++++++++++++++++++++++++++++++=
++----
>  1 file changed, 170 insertions(+), 15 deletions(-)
>=20
> diff --git a/drivers/phy/phy-exynos5-usbdrd.c b/drivers/phy/phy-exynos5-u=
sbdrd.c
> index 47f47fe..85742b0 100644
> --- a/drivers/phy/phy-exynos5-usbdrd.c
> +++ b/drivers/phy/phy-exynos5-usbdrd.c
> @@ -37,13 +37,11 @@
> =20
>  /* EXYNOS5: USB 3.0 DRD PHY registers */
>  #define EXYNOS5_DRD_LINKSYSTEM			0x04
> -
>  #define LINKSYSTEM_FLADJ_MASK			(0x3f << 1)
>  #define LINKSYSTEM_FLADJ(_x)			((_x) << 1)
>  #define LINKSYSTEM_XHCI_VERSION_CONTROL		BIT(27)
> =20
>  #define EXYNOS5_DRD_PHYUTMI			0x08
> -
>  #define PHYUTMI_OTGDISABLE			BIT(6)
>  #define PHYUTMI_FORCESUSPEND			BIT(1)
>  #define PHYUTMI_FORCESLEEP			BIT(0)
> @@ -51,26 +49,20 @@
>  #define EXYNOS5_DRD_PHYPIPE			0x0c
> =20
>  #define EXYNOS5_DRD_PHYCLKRST			0x10
> -
>  #define PHYCLKRST_EN_UTMISUSPEND		BIT(31)
> -
>  #define PHYCLKRST_SSC_REFCLKSEL_MASK		(0xff << 23)
>  #define PHYCLKRST_SSC_REFCLKSEL(_x)		((_x) << 23)
> -
>  #define PHYCLKRST_SSC_RANGE_MASK		(0x03 << 21)
>  #define PHYCLKRST_SSC_RANGE(_x)			((_x) << 21)
> -
>  #define PHYCLKRST_SSC_EN			BIT(20)
>  #define PHYCLKRST_REF_SSP_EN			BIT(19)
>  #define PHYCLKRST_REF_CLKDIV2			BIT(18)
> -
>  #define PHYCLKRST_MPLL_MULTIPLIER_MASK		(0x7f << 11)
>  #define PHYCLKRST_MPLL_MULTIPLIER_100MHZ_REF	(0x19 << 11)
>  #define PHYCLKRST_MPLL_MULTIPLIER_50M_REF	(0x32 << 11)
>  #define PHYCLKRST_MPLL_MULTIPLIER_24MHZ_REF	(0x68 << 11)
>  #define PHYCLKRST_MPLL_MULTIPLIER_20MHZ_REF	(0x7d << 11)
>  #define PHYCLKRST_MPLL_MULTIPLIER_19200KHZ_REF	(0x02 << 11)
> -
>  #define PHYCLKRST_FSEL_UTMI_MASK		(0x7 << 5)
>  #define PHYCLKRST_FSEL_PIPE_MASK		(0x7 << 8)
>  #define PHYCLKRST_FSEL(_x)			((_x) << 5)
> @@ -78,46 +70,68 @@
>  #define PHYCLKRST_FSEL_PAD_24MHZ		(0x2a << 5)
>  #define PHYCLKRST_FSEL_PAD_20MHZ		(0x31 << 5)
>  #define PHYCLKRST_FSEL_PAD_19_2MHZ		(0x38 << 5)
> -
>  #define PHYCLKRST_RETENABLEN			BIT(4)
> -
>  #define PHYCLKRST_REFCLKSEL_MASK		(0x03 << 2)
>  #define PHYCLKRST_REFCLKSEL_PAD_REFCLK		(0x2 << 2)
>  #define PHYCLKRST_REFCLKSEL_EXT_REFCLK		(0x3 << 2)
> -
>  #define PHYCLKRST_PORTRESET			BIT(1)
>  #define PHYCLKRST_COMMONONN			BIT(0)
> =20
>  #define EXYNOS5_DRD_PHYREG0			0x14
> +#define PHYREG0_SSC_REF_CLK_SEL			BIT(21)
> +#define PHYREG0_SSC_RANGE			BIT(20)
> +#define PHYREG0_CR_WRITE			BIT(19)
> +#define PHYREG0_CR_READ				BIT(18)
> +#define PHYREG0_CR_DATA_IN(_x)			((_x) << 2)
> +#define PHYREG0_CR_CAP_DATA			BIT(1)
> +#define PHYREG0_CR_CAP_ADDR			BIT(0)
> +
>  #define EXYNOS5_DRD_PHYREG1			0x18
> +#define PHYREG1_CR_DATA_OUT(_x)			((_x) << 1)
> +#define PHYREG1_CR_ACK				BIT(0)
> =20
>  #define EXYNOS5_DRD_PHYPARAM0			0x1c
> -
>  #define PHYPARAM0_REF_USE_PAD			BIT(31)
>  #define PHYPARAM0_REF_LOSLEVEL_MASK		(0x1f << 26)
>  #define PHYPARAM0_REF_LOSLEVEL			(0x9 << 26)
> =20
>  #define EXYNOS5_DRD_PHYPARAM1			0x20
> -
>  #define PHYPARAM1_PCS_TXDEEMPH_MASK		(0x1f << 0)
>  #define PHYPARAM1_PCS_TXDEEMPH			(0x1c)
> =20
>  #define EXYNOS5_DRD_PHYTERM			0x24
> =20
>  #define EXYNOS5_DRD_PHYTEST			0x28
> -
>  #define PHYTEST_POWERDOWN_SSP			BIT(3)
>  #define PHYTEST_POWERDOWN_HSP			BIT(2)
> =20
>  #define EXYNOS5_DRD_PHYADP			0x2c
> =20
>  #define EXYNOS5_DRD_PHYUTMICLKSEL		0x30
> -

this and all above are unrelated to $subject.

>  #define PHYUTMICLKSEL_UTMI_CLKSEL		BIT(2)
> =20
>  #define EXYNOS5_DRD_PHYRESUME			0x34
>  #define EXYNOS5_DRD_LINKPORT			0x44
> =20
> +/* USB 3.0 DRD PHY SS Function Control Reg; accessed by CR_PORT */
> +#define EXYNOS5_DRD_PHYSS_LOSLEVEL_OVRD_IN		(0x15)
> +#define LOSLEVEL_OVRD_IN_LOS_BIAS_5420			(0x5 << 13)
> +#define LOSLEVEL_OVRD_IN_LOS_BIAS_DEFAULT		(0x0 << 13)
> +#define LOSLEVEL_OVRD_IN_EN				(0x1 << 10)
> +#define LOSLEVEL_OVRD_IN_LOS_LEVEL_DEFAULT		(0x9 << 0)
> +
> +#define EXYNOS5_DRD_PHYSS_TX_VBOOSTLEVEL_OVRD_IN	(0x12)
> +#define TX_VBOOSTLEVEL_OVRD_IN_VBOOST_5420		(0x5 << 13)
> +#define TX_VBOOSTLEVEL_OVRD_IN_VBOOST_DEFAULT		(0x4 << 13)
> +
> +#define EXYNOS5_DRD_PHYSS_LANE0_TX_DEBUG		(0x1010)
> +#define LANE0_TX_DEBUG_RXDET_MEAS_TIME_19M2_20M		(0x4 << 4)
> +#define LANE0_TX_DEBUG_RXDET_MEAS_TIME_24M		(0x8 << 4)
> +#define LANE0_TX_DEBUG_RXDET_MEAS_TIME_25M_26M		(0x8 << 4)
> +#define LANE0_TX_DEBUG_RXDET_MEAS_TIME_48M_50M_52M	(0x20 << 4)
> +#define LANE0_TX_DEBUG_RXDET_MEAS_TIME_62M5		(0x20 << 4)
> +#define LANE0_TX_DEBUG_RXDET_MEAS_TIME_96M_100M		(0x40 << 4)
> +
>  #define KHZ	1000
>  #define MHZ	(KHZ * KHZ)
> =20
> @@ -135,12 +149,14 @@ struct exynos5_usbdrd_phy_config {
>  	void (*phy_isol)(struct phy_usb_instance *inst, u32 on);
>  	void (*phy_init)(struct exynos5_usbdrd_phy *phy_drd);
>  	unsigned int (*set_refclk)(struct phy_usb_instance *inst);
> +	int (*phy_calibrate)(struct phy_usb_instance *inst);
>  };
> =20
>  struct exynos5_usbdrd_phy_drvdata {
>  	const struct exynos5_usbdrd_phy_config *phy_cfg;
>  	u32 pmu_offset_usbdrd0_phy;
>  	u32 pmu_offset_usbdrd1_phy;
> +	void (*phy_exynos_calibrate)(struct exynos5_usbdrd_phy *phy_drd);
>  };
> =20
>  /**
> @@ -487,6 +503,142 @@ static int exynos5_usbdrd_phy_power_off(struct phy =
*phy)
>  	return 0;
>  }
> =20
> +static void crport_handshake(struct exynos5_usbdrd_phy *phy_drd,
> +						u32 val, u32 cmd)
> +{
> +	u32 usec =3D 100;
> +	u32 result;
> +
> +	writel(val | cmd, phy_drd->reg_phy + EXYNOS5_DRD_PHYREG0);
> +
> +	do {
> +		result =3D readl(phy_drd->reg_phy + EXYNOS5_DRD_PHYREG1);
> +		if (result & PHYREG1_CR_ACK)
> +			break;
> +
> +		udelay(1);
> +	} while (usec-- > 0);
> +
> +	if (!usec)
> +		dev_err(phy_drd->dev,
> +			"CRPORT handshake timeout1 (0x%08x)\n", val);

if handshake timed out, shouldn't you error out here ? IOW, make this
function return an int and return an error code from this point ? Why
would you even continue to the next step ?

> +
> +	usec =3D 100;
> +
> +	writel(val, phy_drd->reg_phy + EXYNOS5_DRD_PHYREG0);
> +
> +	do {
> +		result =3D readl(phy_drd->reg_phy + EXYNOS5_DRD_PHYREG1);
> +		if (!(result & PHYREG1_CR_ACK))
> +			break;
> +
> +		udelay(1);
> +	} while (usec-- > 0);
> +
> +	if (!usec)
> +		dev_err(phy_drd->dev,
> +			"CRPORT handshake timeout2 (0x%08x)\n", val);

return an error ?

> +}
> +
> +static void crport_ctrl_write(struct exynos5_usbdrd_phy *phy_drd,
> +						u32 addr, u32 data)
> +{
> +	/* Write Address */
> +	writel(PHYREG0_CR_DATA_IN(addr),
> +			phy_drd->reg_phy + EXYNOS5_DRD_PHYREG0);
> +	crport_handshake(phy_drd, PHYREG0_CR_DATA_IN(addr),
> +			 PHYREG0_CR_CAP_ADDR);
> +
> +	/* Write Data */
> +	writel(PHYREG0_CR_DATA_IN(data),
> +			phy_drd->reg_phy + EXYNOS5_DRD_PHYREG0);
> +	crport_handshake(phy_drd, PHYREG0_CR_DATA_IN(data),
> +			 PHYREG0_CR_CAP_DATA);
> +	crport_handshake(phy_drd, PHYREG0_CR_DATA_IN(data),
> +			 PHYREG0_CR_WRITE);
> +}
> +
> +/*
> + * Override PHY paramaeters using CR_PORT register to calibrate settings
> + * to meet meet SuperSpeed requirements, on Exynos5420 and Exynos5800 sy=
stems,
> + * which have 28nm USB 3.0 DRD PHY.
> + */
> +static void exynos5420_usbdrd_phy_calibrate(struct exynos5_usbdrd_phy *p=
hy_drd)
> +{
> +	u32 temp;
> +
> +	/*
> +	 * Change los_bias to (0x5) for 28nm PHY from a
> +	 * default value (0x0); los_level is set as default
> +	 * (0x9) as also reflected in los_level[30:26] bits
> +	 * of PHYPARAM0 register.
> +	 */
> +	temp =3D LOSLEVEL_OVRD_IN_LOS_BIAS_5420 |
> +		LOSLEVEL_OVRD_IN_EN |
> +		LOSLEVEL_OVRD_IN_LOS_LEVEL_DEFAULT;
> +	crport_ctrl_write(phy_drd,
> +			  EXYNOS5_DRD_PHYSS_LOSLEVEL_OVRD_IN,
> +			  temp);
> +
> +	/*
> +	 * Set tx_vboost_lvl to (0x5) for 28nm PHY Tuning,
> +	 * to raise Tx signal level from its default value of (0x4)
> +	 */
> +	temp =3D TX_VBOOSTLEVEL_OVRD_IN_VBOOST_5420;
> +	crport_ctrl_write(phy_drd,
> +			  EXYNOS5_DRD_PHYSS_TX_VBOOSTLEVEL_OVRD_IN,
> +			  temp);
> +
> +	/*
> +	 * Set proper time to wait for RxDetect measurement, for
> +	 * desired reference clock of PHY, by tuning the CRPORT
> +	 * register LANE0.TX_DEBUG which is internal to PHY.
> +	 * This fixes issue with few USB 3.0 devices, which are
> +	 * not detected (not even generate interrupts on the bus
> +	 * on insertion) without this change.
> +	 * e.g. Samsung SUM-TSB16S 3.0 USB drive.
> +	 */
> +	switch (phy_drd->extrefclk) {
> +	case EXYNOS5_FSEL_50MHZ:
> +		temp =3D LANE0_TX_DEBUG_RXDET_MEAS_TIME_48M_50M_52M;
> +		break;
> +	case EXYNOS5_FSEL_20MHZ:
> +	case EXYNOS5_FSEL_19MHZ2:
> +		temp =3D LANE0_TX_DEBUG_RXDET_MEAS_TIME_19M2_20M;
> +		break;
> +	case EXYNOS5_FSEL_24MHZ:

why can't this be done during probe() ? Are you going to change external
reference clock frequency during runtime ? And even if you do,
wouldn't it be easier to subscribe to clock rate change notifiers
instead of adding this ->calibrate() ?

It still looks, to me, that this ->calibrate() thing is unnecessary. We
have a single user for it and this user could very well get this sorted
out during probe() or by subscribing to clock rate notifiers.

--=20
balbi

--f2QGlHpHGjS2mn6Y
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUBdV9AAoJEIaOsuA1yqRE4eMP/0M/Ll4iton1UguVAe/lixqL
F4Ki8ROCcakFCaK39Lp44K7cV9mtl3QVkBaHEiChIyzwg+V//Juc/P7o1pfnLxuG
wwjpG1YD1tmGRXUE/cKCeD02AOyLTZGc6ZI0N/z9yly4w6hGhAMjcG36+Jc5FUZP
Sz1oN5tojW57LQnMGJyvU9EiZLYgBShBqRQwM9gaqnXkc80opsgBe3UVJoCi54ST
8O8cV6ol4CdZ1j7uO5D9a5S3IKdAJnmYrUTHrRhmwbc9IHFCVtRE4MExjUnl+sNy
yit+sVt7WRchZDR+qxyD7pIiVi4hNxkkKdlA3QfB60Jc/F+dhTqAD9Mnez1CZs+D
C//LrJtUeyjpAJaIJ46Ry+1ONzNo1g7evlTisNrpQtVtA4WG6mohwKe9zU9PyO/+
iE2FhbptbYq4QFHQD3RgItrv8IeKrfMOKMr0O014mnscjlXzo4mQV372WKhzIiNp
Bj4zDrAUGJSTpe9Wug1zfFGj4+U/Pau5QnPXRNWLPH/rLDoeAJO5wXR6GTJS/st7
PBadiaQU4A/poiy7HrD5UyPGPZta0KDR70ljeKla0D/RonVoig88Nz3uPs31pUOs
wLOE1IJswCiwKHyFiHszoFFAxNISmG+DNlFOXavDEooGPCQnslXvvw3A1qJgnwGQ
ad8pNiIEDYETaGQmVG8v
=wyRp
-----END PGP SIGNATURE-----

--f2QGlHpHGjS2mn6Y--
