Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753188Ab3BEJST (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 04:18:19 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:36774 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752441Ab3BEJSM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 04:18:12 -0500
Date: Tue, 5 Feb 2013 11:17:58 +0200
From: Felipe Balbi <balbi@ti.com>
To: Roger Quadros <rogerq@ti.com>
CC: <tony@atomide.com>, <linux@arm.linux.org.uk>, <sameo@linux.intel.com>,
        <balbi@ti.com>, <stern@rowland.harvard.edu>,
        <gregkh@linuxfoundation.org>, <eballetbo@gmail.com>,
        <javier@dowhile0.org>, <sshtylyov@mvista.com>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2 03/30] usb: phy: nop: Manage PHY clock
Message-ID: <20130205091758.GL32118@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1359372631-8180-1-git-send-email-rogerq@ti.com>
 <1359372631-8180-4-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="yQDbd2FCF2Yhw41T"
Content-Disposition: inline
In-Reply-To: <1359372631-8180-4-git-send-email-rogerq@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--yQDbd2FCF2Yhw41T
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Jan 28, 2013 at 01:30:04PM +0200, Roger Quadros wrote:
> If the PHY has a clock associated to it then manage the clock.
> We just enable the clock in .init() and disable it in .shutdown().
>=20
> Add clk_rate parameter in platform data and configure the
> clock rate during probe if supplied.
>=20
> Signed-off-by: Roger Quadros <rogerq@ti.com>

Acked-by: Felipe Balbi <balbi@ti.com>

> ---
>  drivers/usb/otg/nop-usb-xceiv.c   |   54 +++++++++++++++++++++++++++++++=
+++++-
>  include/linux/usb/nop-usb-xceiv.h |    1 +
>  2 files changed, 54 insertions(+), 1 deletions(-)
>=20
> diff --git a/drivers/usb/otg/nop-usb-xceiv.c b/drivers/usb/otg/nop-usb-xc=
eiv.c
> index 7ffb0c8..849eb9d 100644
> --- a/drivers/usb/otg/nop-usb-xceiv.c
> +++ b/drivers/usb/otg/nop-usb-xceiv.c
> @@ -32,10 +32,12 @@
>  #include <linux/usb/otg.h>
>  #include <linux/usb/nop-usb-xceiv.h>
>  #include <linux/slab.h>
> +#include <linux/clk.h>
> =20
>  struct nop_usb_xceiv {
>  	struct usb_phy		phy;
>  	struct device		*dev;
> +	struct clk		*clk;
>  };
> =20
>  static struct platform_device *pd;
> @@ -64,6 +66,24 @@ static int nop_set_suspend(struct usb_phy *x, int susp=
end)
>  	return 0;
>  }
> =20
> +static int nop_init(struct usb_phy *phy)
> +{
> +	struct nop_usb_xceiv *nop =3D dev_get_drvdata(phy->dev);
> +
> +	if (!IS_ERR(nop->clk))
> +		clk_enable(nop->clk);
> +
> +	return 0;
> +}
> +
> +static void nop_shutdown(struct usb_phy *phy)
> +{
> +	struct nop_usb_xceiv *nop =3D dev_get_drvdata(phy->dev);
> +
> +	if (!IS_ERR(nop->clk))
> +		clk_disable(nop->clk);
> +}
> +
>  static int nop_set_peripheral(struct usb_otg *otg, struct usb_gadget *ga=
dget)
>  {
>  	if (!otg)
> @@ -111,10 +131,34 @@ static int nop_usb_xceiv_probe(struct platform_devi=
ce *pdev)
>  	if (pdata)
>  		type =3D pdata->type;
> =20
> +	nop->clk =3D devm_clk_get(&pdev->dev, "main_clk");
> +	if (IS_ERR(nop->clk)) {
> +		dev_dbg(&pdev->dev, "Can't get phy clock: %ld\n",
> +					PTR_ERR(nop->clk));
> +	}
> +
> +	if (!IS_ERR(nop->clk) && pdata && pdata->clk_rate) {
> +		err =3D clk_set_rate(nop->clk, pdata->clk_rate);
> +		if (err) {
> +			dev_err(&pdev->dev, "Error setting clock rate\n");
> +			return err;
> +		}
> +	}
> +
> +	if (!IS_ERR(nop->clk)) {
> +		err =3D clk_prepare(nop->clk);
> +		if (err) {
> +			dev_err(&pdev->dev, "Error preparing clock\n");
> +			return err;
> +		}
> +	}
> +
>  	nop->dev		=3D &pdev->dev;
>  	nop->phy.dev		=3D nop->dev;
>  	nop->phy.label		=3D "nop-xceiv";
>  	nop->phy.set_suspend	=3D nop_set_suspend;
> +	nop->phy.init		=3D nop_init;
> +	nop->phy.shutdown	=3D nop_shutdown;
>  	nop->phy.state		=3D OTG_STATE_UNDEFINED;
> =20
>  	nop->phy.otg->phy		=3D &nop->phy;
> @@ -125,7 +169,7 @@ static int nop_usb_xceiv_probe(struct platform_device=
 *pdev)
>  	if (err) {
>  		dev_err(&pdev->dev, "can't register transceiver, err: %d\n",
>  			err);
> -		return err;
> +		goto err_add;
>  	}
> =20
>  	platform_set_drvdata(pdev, nop);
> @@ -133,12 +177,20 @@ static int nop_usb_xceiv_probe(struct platform_devi=
ce *pdev)
>  	ATOMIC_INIT_NOTIFIER_HEAD(&nop->phy.notifier);
> =20
>  	return 0;
> +
> +err_add:
> +	if (!IS_ERR(nop->clk))
> +		clk_unprepare(nop->clk);
> +	return err;
>  }
> =20
>  static int nop_usb_xceiv_remove(struct platform_device *pdev)
>  {
>  	struct nop_usb_xceiv *nop =3D platform_get_drvdata(pdev);
> =20
> +	if (!IS_ERR(nop->clk))
> +		clk_unprepare(nop->clk);
> +
>  	usb_remove_phy(&nop->phy);
> =20
>  	platform_set_drvdata(pdev, NULL);
> diff --git a/include/linux/usb/nop-usb-xceiv.h b/include/linux/usb/nop-us=
b-xceiv.h
> index 28884c7..3265b61 100644
> --- a/include/linux/usb/nop-usb-xceiv.h
> +++ b/include/linux/usb/nop-usb-xceiv.h
> @@ -5,6 +5,7 @@
> =20
>  struct nop_usb_xceiv_platform_data {
>  	enum usb_phy_type type;
> +	unsigned long clk_rate;
>  };
> =20
>  #if defined(CONFIG_NOP_USB_XCEIV) || (defined(CONFIG_NOP_USB_XCEIV_MODUL=
E) && defined(MODULE))
> --=20
> 1.7.4.1
>=20

--=20
balbi

--yQDbd2FCF2Yhw41T
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJREM5GAAoJEIaOsuA1yqRE860P/0xSWVyJ9PBd601/4xVcJQ/B
GYtIZ6ujq9wTQE29BIs5L7ZI2dPi15t679x4mMK0IP/XHMsBRThzjhld6iE7QnOf
iS90oodVVdeBSdmgd+l2LrH2pvBKNCIOheGXadHtut8UH4HMl6I3Ae5RUCJCJjsY
foDp8w4txm4i9mdCyntv/hxI6R1hbgR6fxcgkOQfchqWfSKKcRwJrMhbvKRu6lAW
98kwQqikgppPcfM5IORYiQgeaZdiabBKN7Q6gtPVn3tLZAldGTi42P0KCDSqbDvw
pDG9Sggh5euTDsV639S7k/VrkW3OlyVb/5hT43oTTsBBQ19cm0ZV2XoptLQYsdNC
0V1P2X1W8vRRThPaUn+RhZscSxdw20qzj/9rzjbjBsyVqdF9Qt0C88tCmam0CfZ1
QhPFHT9Y5h5jWT3tGWmz4IZkMA+bAyBKgSC1ieblOksX7ilYyBfzhLXglY8ZQ1z+
MmTcAL5y2sVC1iw5OZx3gEVR/YYK9ZDDC38zjbcSIQfvuflhGVRyackwnQVnCtGJ
JYywhW4evDbCDI7wGx/EO1CMlQN7ug2HFWrKAW29irQqAu0irYOY3GPEUxyAYx99
sel9YTQPE4/IMz4xBT+Pw69yo6XJ8zmczOVrN1fOw2GTb6GUuwBHcT218Flc4QE+
Fv5LKsDelwaZrmLlw5g3
=xBzG
-----END PGP SIGNATURE-----

--yQDbd2FCF2Yhw41T--
