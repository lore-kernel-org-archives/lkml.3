Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751528Ab3BEJXD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 04:23:03 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:41309 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750842Ab3BEJW6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 04:22:58 -0500
Date: Tue, 5 Feb 2013 11:22:47 +0200
From: Felipe Balbi <balbi@ti.com>
To: Roger Quadros <rogerq@ti.com>
CC: <tony@atomide.com>, <linux@arm.linux.org.uk>, <sameo@linux.intel.com>,
        <balbi@ti.com>, <stern@rowland.harvard.edu>,
        <gregkh@linuxfoundation.org>, <eballetbo@gmail.com>,
        <javier@dowhile0.org>, <sshtylyov@mvista.com>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2 05/30] usb: phy: nop: Handle RESET for the PHY
Message-ID: <20130205092247.GN32118@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1359372631-8180-1-git-send-email-rogerq@ti.com>
 <1359372631-8180-6-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Zbynv6TNPa9FrOf6"
Content-Disposition: inline
In-Reply-To: <1359372631-8180-6-git-send-email-rogerq@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Zbynv6TNPa9FrOf6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 28, 2013 at 01:30:06PM +0200, Roger Quadros wrote:
> We expect the RESET line to be modeled as a regulator with supply
> name "reset". The regulator should be modeled such that enabling
> the regulator brings the PHY device out of RESET and disabling the
> regulator holds the device in RESET.
>=20
> They PHY will be held in RESET in .shutdown() and brought out of
> RESET in .init().
>=20
> Signed-off-by: Roger Quadros <rogerq@ti.com>

Acked-by: Felipe Balbi <balbi@ti.com>

> ---
>  drivers/usb/otg/nop-usb-xceiv.c |   19 +++++++++++++++++++
>  1 files changed, 19 insertions(+), 0 deletions(-)
>=20
> diff --git a/drivers/usb/otg/nop-usb-xceiv.c b/drivers/usb/otg/nop-usb-xc=
eiv.c
> index 0a9628c..3060ed0 100644
> --- a/drivers/usb/otg/nop-usb-xceiv.c
> +++ b/drivers/usb/otg/nop-usb-xceiv.c
> @@ -40,6 +40,7 @@ struct nop_usb_xceiv {
>  	struct device		*dev;
>  	struct clk		*clk;
>  	struct regulator	*vcc;
> +	struct regulator	*reset;
>  };
> =20
>  static struct platform_device *pd;
> @@ -80,6 +81,12 @@ static int nop_init(struct usb_phy *phy)
>  	if (!IS_ERR(nop->clk))
>  		clk_enable(nop->clk);
> =20
> +	if (!IS_ERR(nop->reset)) {
> +		/* De-assert RESET */
> +		if (regulator_enable(nop->reset))
> +			dev_err(phy->dev, "Failed to de-assert reset\n");
> +	}
> +
>  	return 0;
>  }
> =20
> @@ -87,6 +94,12 @@ static void nop_shutdown(struct usb_phy *phy)
>  {
>  	struct nop_usb_xceiv *nop =3D dev_get_drvdata(phy->dev);
> =20
> +	if (!IS_ERR(nop->reset)) {
> +		/* Assert RESET */
> +		if (regulator_disable(nop->reset))
> +			dev_err(phy->dev, "Failed to assert reset\n");
> +	}
> +
>  	if (!IS_ERR(nop->clk))
>  		clk_disable(nop->clk);
> =20
> @@ -171,6 +184,12 @@ static int nop_usb_xceiv_probe(struct platform_devic=
e *pdev)
>  					PTR_ERR(nop->vcc));
>  	}
> =20
> +	nop->reset =3D devm_regulator_get(&pdev->dev, "reset");
> +	if (IS_ERR(nop->reset)) {
> +		dev_dbg(&pdev->dev, "Error getting reset regulator: %ld\n",
> +					PTR_ERR(nop->reset));
> +	}
> +
>  	nop->dev		=3D &pdev->dev;
>  	nop->phy.dev		=3D nop->dev;
>  	nop->phy.label		=3D "nop-xceiv";
> --=20
> 1.7.4.1
>=20

--=20
balbi

--Zbynv6TNPa9FrOf6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJREM9nAAoJEIaOsuA1yqRETIYP/0FLhACp1bJX58CrAWW0GrQe
q1cXZQDAuhHUgeGIypj+Yojpyw2X2slOvXM2FVtFd24o27o5YOOfKZMky1BRPeh9
+y1abcdXY8EgbqkN6cyFSpYFCEL/Wqh64lQBOUuhcV0pTdm5YgVVfHt8S5Y1I0pR
L6+6y85n/hAp83XtE9l71WQMYrE1ZPChjpXy+/tuuPC/zKtSbv1ehxfu3ylLzHLJ
sU0AQ2eEw2OxgW1H0NXskEj6rtdPQCNQliV8V9skQwyrGHGsbARvj6SPG/DA7eKv
t3mfVedD75WK4rTFAmx1ZNAm0+gQRGDoiQ2ZcW4AVhSNetDoutlLmYfK+qSDMGUL
lj9QNmYxMDpXTsEMo1rUXbeaRvsxso/K365uCxZciegTk5+C6MIA0iXywR6wrZ4Y
Z7clT/23eHH7lU/qG5Jsd8B4rNRffws3djhPJow1bhx79MqOlshosHLhqr8xLb8V
C9w1itrHClDw6EMd28uxWrTXI+WTqBQXKFIu/PsCia24br5D7BkYCOik/NqS4oKq
KKq4GGl491e7LZ19iRgnO/V7x40E6FM8gyijaLaeZ93v4dK+dmKcbmE/TUwsusDS
AEFPtKP4cULEtTQipeLZ6nDTsQ3dzwk2kjnr/Xqhm5zEsokGL8cf1fASwyDV99Yo
rAXzX1tPqEyuHh+zo/sE
=Uuls
-----END PGP SIGNATURE-----

--Zbynv6TNPa9FrOf6--
