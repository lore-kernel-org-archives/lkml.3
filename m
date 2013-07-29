Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755612Ab3G2PHP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 11:07:15 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:41522 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755187Ab3G2PHM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 11:07:12 -0400
Date: Mon, 29 Jul 2013 18:06:38 +0300
From: Felipe Balbi <balbi@ti.com>
To: Kishon Vijay Abraham I <kishon@ti.com>
CC: <balbi@ti.com>, <tony@atomide.com>, <linux@arm.linux.org.uk>,
        <eballetbo@gmail.com>, <javier@dowhile0.org>,
        <gregkh@linuxfoundation.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>
Subject: Re: [PATCH 2/2] arm: omap: remove *.auto* from device names given in
 usb_bind_phy
Message-ID: <20130729150638.GD3063@radagast>
Reply-To: <balbi@ti.com>
References: <1374829418-27503-1-git-send-email-kishon@ti.com>
 <1374829418-27503-3-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="TybLhxa8M7aNoW+V"
Content-Disposition: inline
In-Reply-To: <1374829418-27503-3-git-send-email-kishon@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--TybLhxa8M7aNoW+V
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Jul 26, 2013 at 02:33:38PM +0530, Kishon Vijay Abraham I wrote:
> Previously MUSB wrapper (OMAP) device used PLATFORM_DEVID_AUTO while crea=
ting
> MUSB core device. So in usb_bind_phy (binds the controller with the PHY),=
 the
> device name of the controller had *.auto* in it. Since with using
> PLATFORM_DEVID_AUTO, there is no way to know the exact device name in adv=
ance,
> the data given in usb_bind_phy became obsolete and usb_get_phy was failin=
g.
> So MUSB wrapper was modified not to use PLATFORM_DEVID_AUTO. Corresponding
> change is done in board file here.
>=20
> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
> ---
>  arch/arm/mach-omap2/board-2430sdp.c          |    2 +-
>  arch/arm/mach-omap2/board-3430sdp.c          |    2 +-
>  arch/arm/mach-omap2/board-cm-t35.c           |    2 +-
>  arch/arm/mach-omap2/board-devkit8000.c       |    2 +-
>  arch/arm/mach-omap2/board-igep0020.c         |    2 +-
>  arch/arm/mach-omap2/board-ldp.c              |    2 +-
>  arch/arm/mach-omap2/board-omap3beagle.c      |    2 +-
>  arch/arm/mach-omap2/board-omap3evm.c         |    2 +-
>  arch/arm/mach-omap2/board-omap3logic.c       |    2 +-
>  arch/arm/mach-omap2/board-omap3pandora.c     |    2 +-
>  arch/arm/mach-omap2/board-omap3stalker.c     |    2 +-
>  arch/arm/mach-omap2/board-omap3touchbook.c   |    2 +-
>  arch/arm/mach-omap2/board-overo.c            |    2 +-
>  arch/arm/mach-omap2/board-rm680.c            |    2 +-
>  arch/arm/mach-omap2/board-rx51.c             |    2 +-
>  arch/arm/mach-omap2/board-zoom-peripherals.c |    2 +-
>  16 files changed, 16 insertions(+), 16 deletions(-)
>=20
> diff --git a/arch/arm/mach-omap2/board-2430sdp.c b/arch/arm/mach-omap2/bo=
ard-2430sdp.c
> index 244d8a5..17bb076 100644
> --- a/arch/arm/mach-omap2/board-2430sdp.c
> +++ b/arch/arm/mach-omap2/board-2430sdp.c
> @@ -233,7 +233,7 @@ static void __init omap_2430sdp_init(void)
>  	omap_hsmmc_init(mmc);
> =20
>  	omap_mux_init_signal("usb0hs_stp", OMAP_PULL_ENA | OMAP_PULL_UP);
> -	usb_bind_phy("musb-hdrc.0.auto", 0, "twl4030_usb");
> +	usb_bind_phy("musb-hdrc.0", 0, "twl4030_usb");

how about moving usb_bind_phy() calls to omap2430.c ?

diff --git a/drivers/usb/musb/omap2430.c b/drivers/usb/musb/omap2430.c
index f44e8b5..b6abc1a 100644
--- a/drivers/usb/musb/omap2430.c
+++ b/drivers/usb/musb/omap2430.c
@@ -544,6 +544,9 @@ static int omap2430_probe(struct platform_device *pdev)
=20
 		pdata->board_data	=3D data;
 		pdata->config		=3D config;
+	} else {
+		/* bind the PHY */
+		usb_bind_phy(dev_name(&musb->dev), 0, "twl4030_usb");
 	}
=20
 	if (pdata->has_mailbox) {

The only problem is if some board comes with a PHY other than
twl4030_usb, but in that case we can add a separate compatible flag and
treat it properly. We only need to bind the phy in non-DT case anyway,
so that's temporary. It might be better than to reintroduce the IDR in
musb_core.c.

--=20
balbi

--TybLhxa8M7aNoW+V
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJR9oT+AAoJEIaOsuA1yqRErrAQAI5WGvGhARD2HcOc+4iJ3IKy
qUIxGfmesWRXi2OiT0xoN4NXI23Res067TFii082mUqpx7Eq8YJbZF8sqHOxg6Sx
5GDY6YF4CaDj5EDnNuogvzHvFx4xfVrxmq4oOqXQWEQvPJKbPJc4n1cV1LngCgmg
2EgGagJ+DGfIz6mOTqyHY6J0IhnTVJMKG7OXUUhcO3aPQ8oUKB8WW5YDTDsTK1UO
mFb2VSgbdz1A6yuc0cQUyS+fS8VfKeVUL9WnTGsHXHezfmIKgE78fUU2fKthuOgC
uep/Rxq7gIKZCDUYVL57kWZI0ZR3KQCvGgYnZLuxVn8PkqNkGv+qCOoMyq3CX4Ew
ZTjHwwupiOEFZiIstKh1wNA0svYjEPRyeGjT5cwMB2h7gIoBN52/R8zFrdLbkak1
QoStzdzkAx46yLnlwN7rCjjOTNoR+c0DVT0GPDkTt7v76mkV4UwY7gYv+n/geEyD
/uW0pnxmX0aFv2+//ZhfrQeuWHptBaBj4zaW9kgbuhfiYn7ZrmR7E1xlNJIHp/2C
av0RPWDR2ONi2/LQQv4VKc6Yb/dwTc/XdxNbqgiqVpq/BV4rdDyZHj+udsz3NRAf
fgnXTNz1VT5jyHsFGwLLFy4+O6dqd1qMBwqNMn3biajBs/kJqlpF7GQXb7q7J4cw
nBBvWtz9pEWNhZTL6sj5
=CKdj
-----END PGP SIGNATURE-----

--TybLhxa8M7aNoW+V--
