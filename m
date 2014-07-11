Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753714AbaGKMJv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 08:09:51 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:39545 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753678AbaGKMJt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 08:09:49 -0400
Message-ID: <53BFD401.8030101@pengutronix.de>
Date: Fri, 11 Jul 2014 14:09:37 +0200
From: Marc Kleine-Budde <mkl@pengutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Stefan Agner <stefan@agner.ch>
CC: wg@grandegger.com, shawn.guo@freescale.com, kernel@pengutronix.de,
        linux-arm-kernel@lists.infradead.org, linux-can@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] can: flexcan: add vf61x support for flexcan
References: <1405075933-22317-1-git-send-email-stefan@agner.ch>
In-Reply-To: <1405075933-22317-1-git-send-email-stefan@agner.ch>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="rdOQtA8BOWOBfDRpKeKtEompUMKehOL57"
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--rdOQtA8BOWOBfDRpKeKtEompUMKehOL57
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 07/11/2014 12:52 PM, Stefan Agner wrote:
> Extend FlexCAN driver to support Vybrid. Vybrids variant of the IP
> has ECC support which is controlled through the memory error
> control register (MECR). There is also an errata which leads to
> false positive error detections (ID e5295). This patch disables
> the memory error detection completely.
>=20
> Also extend the clock control for FlexCAN to enable the clocks
> in the Clock Divider (CCM_CSCDR2) register too.
>=20
> Signed-off-by: Stefan Agner <stefan@agner.ch>
> ---
> Marc, this patch requires your patch regarding clock enable
> for reading the ECR register:
> http://marc.info/?l=3Dlinux-can&m=3D136861025221160&w=3D2
> So I also tested that patch and it proved solving that issue
> hence

Feel free to pick up that patch (and add the mising return value check
for clock_prepare_enable().

> Tested-By <stefan@agner.ch>
>=20
> I'm not sure whether its ok to include the device tree and
> clock changes in one patch, let me know if you prefer that
> splitted patches.

IMHO it should be 4 seperate patches:
- dt
- clocks
- flexcan_get_berr_counter fixes
- your flexcan enhancements

The first two patches go probably via Shawn's tree, while the latter two
go via linux-can-next.

> --
> Stefan
>=20
>  arch/arm/boot/dts/vf610.dtsi  | 25 ++++++++++++++-
>  arch/arm/mach-imx/clk-vf610.c |  6 ++--
>  drivers/net/can/flexcan.c     | 73 +++++++++++++++++++++++++++++++++++=
++------
>  3 files changed, 92 insertions(+), 12 deletions(-)
>=20
> diff --git a/arch/arm/boot/dts/vf610.dtsi b/arch/arm/boot/dts/vf610.dts=
i
> index 3fb127a..f38d8d8 100644
> --- a/arch/arm/boot/dts/vf610.dtsi
> +++ b/arch/arm/boot/dts/vf610.dtsi
> @@ -14,6 +14,8 @@
> =20
>  / {
>  	aliases {
> +		can0 =3D &can0;
> +		can1 =3D &can1;
>  		serial0 =3D &uart0;
>  		serial1 =3D &uart1;
>  		serial2 =3D &uart2;
> @@ -103,6 +105,16 @@
>  					<&clks VF610_CLK_DMAMUX1>;
>  			};
> =20
> +			can0: flexcan@40020000 {
> +				compatible =3D "fsl,vf610-flexcan";
> +				reg =3D <0x40020000 0x4000>;
> +				interrupts =3D <0 58 IRQ_TYPE_LEVEL_HIGH>;
> +				clocks =3D <&clks VF610_CLK_FLEXCAN0>,
> +					 <&clks VF610_CLK_FLEXCAN0>;
> +				clock-names =3D "ipg", "per";
> +				status =3D "disabled";
> +			};
> +
>  			uart0: serial@40027000 {
>  				compatible =3D "fsl,vf610-lpuart";
>  				reg =3D <0x40027000 0x1000>;
> @@ -362,7 +374,7 @@
> =20
>  			esdhc1: esdhc@400b2000 {
>  				compatible =3D "fsl,imx53-esdhc";
> -				reg =3D <0x400b2000 0x4000>;
> +				reg =3D <0x400b2000 0x1000>;

What's that doing here? :)

>  				interrupts =3D <0 28 0x04>;
>  				clocks =3D <&clks VF610_CLK_IPG_BUS>,
>  					<&clks VF610_CLK_PLATFORM_BUS>,
> @@ -414,6 +426,17 @@
>  				clock-names =3D "nfc";
>  				status =3D "disabled";
>  			};
> +
> +			can1: flexcan@400d4000 {
> +				compatible =3D "fsl,vf610-flexcan";
> +				reg =3D <0x400d4000 0x4000>;
> +				interrupts =3D <0 59 IRQ_TYPE_LEVEL_HIGH>;
> +				clocks =3D <&clks VF610_CLK_FLEXCAN1>,
> +					 <&clks VF610_CLK_FLEXCAN1>;
> +				clock-names =3D "ipg", "per";
> +				status =3D "disabled";
> +			};
> +
>  		};
>  	};
>  };
> diff --git a/arch/arm/mach-imx/clk-vf610.c b/arch/arm/mach-imx/clk-vf61=
0.c
> index 22dc3ee..b12b888 100644
> --- a/arch/arm/mach-imx/clk-vf610.c
> +++ b/arch/arm/mach-imx/clk-vf610.c
> @@ -295,8 +295,10 @@ static void __init vf610_clocks_init(struct device=
_node *ccm_node)
> =20
>  	clk[VF610_CLK_ASRC] =3D imx_clk_gate2("asrc", "ipg_bus", CCM_CCGR4, C=
CM_CCGRx_CGn(1));
> =20
> -	clk[VF610_CLK_FLEXCAN0] =3D imx_clk_gate2("flexcan0", "ipg_bus", CCM_=
CCGR0, CCM_CCGRx_CGn(0));
> -	clk[VF610_CLK_FLEXCAN1] =3D imx_clk_gate2("flexcan1", "ipg_bus", CCM_=
CCGR9, CCM_CCGRx_CGn(4));
> +	clk[VF610_CLK_FLEXCAN0] =3D imx_clk_gate("flexcan0_en", "ipg_bus", CC=
M_CSCDR2, 11);
> +	clk[VF610_CLK_FLEXCAN0] =3D imx_clk_gate2("flexcan0", "flexcan0_en", =
CCM_CCGR0, CCM_CCGRx_CGn(0));
> +	clk[VF610_CLK_FLEXCAN1] =3D imx_clk_gate("flexcan1_en", "ipg_bus", CC=
M_CSCDR2, 12);
> +	clk[VF610_CLK_FLEXCAN1] =3D imx_clk_gate2("flexcan1", "flexcan1_en", =
CCM_CCGR9, CCM_CCGRx_CGn(4));
> =20
>  	clk[VF610_CLK_DMAMUX0] =3D imx_clk_gate2("dmamux0", "platform_bus", C=
CM_CCGR0, CCM_CCGRx_CGn(4));
>  	clk[VF610_CLK_DMAMUX1] =3D imx_clk_gate2("dmamux1", "platform_bus", C=
CM_CCGR0, CCM_CCGRx_CGn(5));
> diff --git a/drivers/net/can/flexcan.c b/drivers/net/can/flexcan.c
> index f425ec2..1601247 100644
> --- a/drivers/net/can/flexcan.c
> +++ b/drivers/net/can/flexcan.c
> @@ -92,6 +92,27 @@
>  #define FLEXCAN_CTRL_ERR_ALL \
>  	(FLEXCAN_CTRL_ERR_BUS | FLEXCAN_CTRL_ERR_STATE)
> =20
> +/* FLEXCAN control register 2 (CTRL2) bits */
> +#define FLEXCAN_CRL2_ECRWRE		BIT(29)
> +#define FLEXCAN_CRL2_WRMFRZ		BIT(28)
> +#define FLEXCAN_CRL2_RFFN(x)		(((x) & 0x0f) << 24)
> +#define FLEXCAN_CRL2_TASD(x)		(((x) & 0x1f) << 19)
> +#define FLEXCAN_CRL2_MRP		BIT(18)
> +#define FLEXCAN_CRL2_RRS		BIT(17)
> +#define FLEXCAN_CRL2_EACEN		BIT(16)
> +
> +/* FLEXCAN memory error control register (MECR) bits */
> +#define FLEXCAN_MECR_ECRWRDIS		BIT(31)
> +#define FLEXCAN_MECR_HANCEI_MSK		BIT(19)
> +#define FLEXCAN_MECR_FANCEI_MSK		BIT(18)
> +#define FLEXCAN_MECR_CEI_MSK		BIT(16)
> +#define FLEXCAN_MECR_HAERRIE		BIT(15)
> +#define FLEXCAN_MECR_FAERRIE		BIT(14)
> +#define FLEXCAN_MECR_EXTERRIE		BIT(13)
> +#define FLEXCAN_MECR_RERRDIS		BIT(9)
> +#define FLEXCAN_MECR_ECCDIS		BIT(8)
> +#define FLEXCAN_MECR_NCEFAFRZ		BIT(7)
> +
>  /* FLEXCAN error and status register (ESR) bits */
>  #define FLEXCAN_ESR_TWRN_INT		BIT(17)
>  #define FLEXCAN_ESR_RWRN_INT		BIT(16)
> @@ -150,18 +171,20 @@
>   * FLEXCAN hardware feature flags
>   *
>   * Below is some version info we got:
> - *    SOC   Version   IP-Version  Glitch-  [TR]WRN_INT
> - *                                Filter?   connected?
> - *   MX25  FlexCAN2  03.00.00.00     no         no
> - *   MX28  FlexCAN2  03.00.04.00    yes        yes
> - *   MX35  FlexCAN2  03.00.00.00     no         no
> - *   MX53  FlexCAN2  03.00.00.00    yes         no
> - *   MX6s  FlexCAN3  10.00.12.00    yes        yes
> + *    SOC   Version   IP-Version  Glitch-  [TR]WRN_INT  Memory err
> + *                                Filter?   connected?  detection
> + *   MX25  FlexCAN2  03.00.00.00     no         no	   no
> + *   MX28  FlexCAN2  03.00.04.00    yes        yes	   no
> + *   MX35  FlexCAN2  03.00.00.00     no         no	   no
> + *   MX53  FlexCAN2  03.00.00.00    yes         no	   no
> + *   MX6s  FlexCAN3  10.00.12.00    yes        yes	   no
> + *   VFxx  FlexCAN3  ?		     no		no	  yes

Please use either tabs or space to indent in this table.

>   *
>   * Some SOCs do not have the RX_WARN & TX_WARN interrupt line connecte=
d.
>   */
>  #define FLEXCAN_HAS_V10_FEATURES	BIT(1) /* For core version >=3D 10 */=

>  #define FLEXCAN_HAS_BROKEN_ERR_STATE	BIT(2) /* [TR]WRN_INT not connect=
ed */
> +#define FLEXCAN_HAS_MECR_FEATURES	BIT(3) /* Memory error detection */
> =20
>  /* Structure of the message buffer */
>  struct flexcan_mb {
> @@ -192,8 +215,11 @@ struct flexcan_regs {
>  	u32 crcr;		/* 0x44 */
>  	u32 rxfgmask;		/* 0x48 */
>  	u32 rxfir;		/* 0x4c */
> -	u32 _reserved3[12];
> +	u32 _reserved3[12];	/* 0x50 */
>  	struct flexcan_mb cantxfg[64];
> +	u32 _reserved4[408];
> +	u32 mecr;		/* 0xae0 */
> +	u32 erriar;		/* 0xae4 */
>  };
> =20
>  struct flexcan_devtype_data {
> @@ -223,6 +249,9 @@ static struct flexcan_devtype_data fsl_imx28_devtyp=
e_data;
>  static struct flexcan_devtype_data fsl_imx6q_devtype_data =3D {
>  	.features =3D FLEXCAN_HAS_V10_FEATURES,
>  };
> +static struct flexcan_devtype_data fsl_vf610_devtype_data =3D {
> +	.features =3D FLEXCAN_HAS_V10_FEATURES | FLEXCAN_HAS_MECR_FEATURES,
> +};
> =20
>  static const struct can_bittiming_const flexcan_bittiming_const =3D {
>  	.name =3D DRV_NAME,
> @@ -793,7 +822,7 @@ static int flexcan_chip_start(struct net_device *de=
v)
>  	struct flexcan_priv *priv =3D netdev_priv(dev);
>  	struct flexcan_regs __iomem *regs =3D priv->base;
>  	int err;
> -	u32 reg_mcr, reg_ctrl;
> +	u32 reg_mcr, reg_ctrl, reg_crl2, reg_mecr;
> =20
>  	/* enable module */
>  	err =3D flexcan_chip_enable(priv);
> @@ -870,6 +899,31 @@ static int flexcan_chip_start(struct net_device *d=
ev)
>  	if (priv->devtype_data->features & FLEXCAN_HAS_V10_FEATURES)
>  		flexcan_write(0x0, &regs->rxfgmask);
> =20
> +	/*
> +	 * On Vybrid, disable memory error detection interrupts
> +	 * and freeze mode.
> +	 * This also works around errata e5295 which generates
> +	 * false positive memory errors and put the device in
> +	 * freeze mode.
> +	 */
> +	if (priv->devtype_data->features & FLEXCAN_HAS_MECR_FEATURES) {
> +		/*
> +		 * Follow the protocol as described in "Detection
> +		 * and Correction of Memory Errors" to write to
> +		 * MECR register
> +		 */
> +		reg_crl2 =3D flexcan_read(&regs->crl2);
> +		reg_crl2 |=3D FLEXCAN_CRL2_ECRWRE;
> +		flexcan_write(reg_crl2, &regs->crl2);
> +
> +		reg_mecr =3D flexcan_read(&regs->mecr);
> +		reg_mecr &=3D ~FLEXCAN_MECR_ECRWRDIS;
> +		flexcan_write(reg_mecr, &regs->mecr);
> +		reg_mecr &=3D ~(FLEXCAN_MECR_NCEFAFRZ | FLEXCAN_MECR_HANCEI_MSK |
> +				FLEXCAN_MECR_FANCEI_MSK);
> +		flexcan_write(reg_mecr, &regs->mecr);
> +	}
> +
>  	err =3D flexcan_transceiver_enable(priv);
>  	if (err)
>  		goto out_chip_disable;
> @@ -1080,6 +1134,7 @@ static const struct of_device_id flexcan_of_match=
[] =3D {
>  	{ .compatible =3D "fsl,imx6q-flexcan", .data =3D &fsl_imx6q_devtype_d=
ata, },
>  	{ .compatible =3D "fsl,imx28-flexcan", .data =3D &fsl_imx28_devtype_d=
ata, },
>  	{ .compatible =3D "fsl,p1010-flexcan", .data =3D &fsl_p1010_devtype_d=
ata, },
> +	{ .compatible =3D "fsl,vf610-flexcan", .data =3D &fsl_vf610_devtype_d=
ata, },
>  	{ /* sentinel */ },
>  };
>  MODULE_DEVICE_TABLE(of, flexcan_of_match);
>=20

Marc

--=20
Pengutronix e.K.                  | Marc Kleine-Budde           |
Industrial Linux Solutions        | Phone: +49-231-2826-924     |
Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |


--rdOQtA8BOWOBfDRpKeKtEompUMKehOL57
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Using GnuPG with Icedove - http://www.enigmail.net/

iEYEARECAAYFAlO/1AEACgkQjTAFq1RaXHNlbgCfSj+Kz5vzZyk6KGOOHw4CNzVJ
dwUAn2KbHOOaVydKSh0VwVNylJf9H/Bk
=2fwI
-----END PGP SIGNATURE-----

--rdOQtA8BOWOBfDRpKeKtEompUMKehOL57--
