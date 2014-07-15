Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753488AbaGOOYb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 10:24:31 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:36699 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752525AbaGOOYZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 10:24:25 -0400
Message-ID: <53C5398F.2000005@pengutronix.de>
Date: Tue, 15 Jul 2014 16:24:15 +0200
From: Marc Kleine-Budde <mkl@pengutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Stefan Agner <stefan@agner.ch>, shawn.guo@freescale.com
CC: kernel@pengutronix.de, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 4/4] can: flexcan: add vf610 support for FlexCAN
References: <cover.1405428166.git.stefan@agner.ch> <ff2ea1726b13dc2ffa3519ce9244f3633cf1420d.1405428166.git.stefan@agner.ch>
In-Reply-To: <ff2ea1726b13dc2ffa3519ce9244f3633cf1420d.1405428166.git.stefan@agner.ch>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="I1gJ9e9RT6a1qIr6R1G64vew0uOUCeeUx"
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--I1gJ9e9RT6a1qIr6R1G64vew0uOUCeeUx
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 07/15/2014 02:56 PM, Stefan Agner wrote:
> Extend FlexCAN driver to support Vybrid. Vybrids variant of the IP
> has ECC support which is controlled through the memory error
> control register (MECR). There is also an errata which leads to
> false positive error detections (ID e5295). This patch disables
> the memory error detection completely.
>=20
> Signed-off-by: Stefan Agner <stefan@agner.ch>
> ---
>  drivers/net/can/flexcan.c | 73 +++++++++++++++++++++++++++++++++++++++=
++------
>  1 file changed, 64 insertions(+), 9 deletions(-)
>=20
> diff --git a/drivers/net/can/flexcan.c b/drivers/net/can/flexcan.c
> index 89745aa..1c31a5d 100644
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
> + *   MX25  FlexCAN2  03.00.00.00     no         no         no
> + *   MX28  FlexCAN2  03.00.04.00    yes        yes         no
> + *   MX35  FlexCAN2  03.00.00.00     no         no         no
> + *   MX53  FlexCAN2  03.00.00.00    yes         no         no
> + *   MX6s  FlexCAN3  10.00.12.00    yes        yes         no
> + *   VF610 FlexCAN3  ?               no         no        yes
                                        ^^         ^^

Can you check the datasheet if the flexcan core has a "Glitch Filter
Width Register (FLEXCANx_GFWR)"

Can you check if the core generates a warning interrupt with the current
setup, if you don't switch on bus error reporting? This means internally
the [TR]WRN_INT is connected and works as specified.

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

Marc

--=20
Pengutronix e.K.                  | Marc Kleine-Budde           |
Industrial Linux Solutions        | Phone: +49-231-2826-924     |
Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |


--I1gJ9e9RT6a1qIr6R1G64vew0uOUCeeUx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Using GnuPG with Icedove - http://www.enigmail.net/

iEYEARECAAYFAlPFOY8ACgkQjTAFq1RaXHNdvgCdF6+uqR5ovCTgsV4e9lFxzqY4
UNoAn3ZLEZsQEKtBddfm2PEMWbx7yncA
=FWLS
-----END PGP SIGNATURE-----

--I1gJ9e9RT6a1qIr6R1G64vew0uOUCeeUx--
