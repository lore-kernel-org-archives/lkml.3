Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752008AbaDYPC6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 11:02:58 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:37744 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751306AbaDYPC4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 11:02:56 -0400
Date: Fri, 25 Apr 2014 10:02:19 -0500
From: Felipe Balbi <balbi@ti.com>
To: Gregory CLEMENT <gregory.clement@free-electrons.com>
CC: Mathias Nyman <mathias.nyman@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Felipe Balbi <balbi@ti.com>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        <linux-arm-kernel@lists.infradead.org>,
        Lior Amsalem <alior@marvell.com>, Tawfik Bayouk <tawfik@marvell.com>,
        Nadav Haklai <nadavh@marvell.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, <devicetree@vger.kernel.org>
Subject: Re: [PATCH v2 02/18] usb: host: xhci-plat: Add clocks support
Message-ID: <20140425150218.GC29632@saruman.home>
Reply-To: <balbi@ti.com>
References: <1398434836-18908-1-git-send-email-gregory.clement@free-electrons.com>
 <1398434836-18908-3-git-send-email-gregory.clement@free-electrons.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="JWEK1jqKZ6MHAcjA"
Content-Disposition: inline
In-Reply-To: <1398434836-18908-3-git-send-email-gregory.clement@free-electrons.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--JWEK1jqKZ6MHAcjA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Apr 25, 2014 at 04:07:00PM +0200, Gregory CLEMENT wrote:
> Some platform (such as the Armada 38x ones) can gate the clock of
> their USB controller. This patch add the support for the clock, by
> enabling them during probe and disabling them on remove.
>=20
> As not all platforms have clock support then enabling and disabling
> the clocks have been placed in separate functions. Then if the clocks
> are not supported we still can use the same calls, and there is no
>=20
> Signed-off-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
> ---
>  drivers/usb/host/xhci-plat.c | 52 ++++++++++++++++++++++++++++++++++++++=
++++--
>  1 file changed, 50 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/usb/host/xhci-plat.c b/drivers/usb/host/xhci-plat.c
> index f5351af4b2c5..bb5d563f729c 100644
> --- a/drivers/usb/host/xhci-plat.c
> +++ b/drivers/usb/host/xhci-plat.c
> @@ -11,6 +11,7 @@
>   * version 2 as published by the Free Software Foundation.
>   */
> =20
> +#include <linux/clk.h>
>  #include <linux/dma-mapping.h>
>  #include <linux/module.h>
>  #include <linux/of.h>
> @@ -85,6 +86,42 @@ static const struct hc_driver xhci_plat_xhci_driver =
=3D {
>  	.bus_resume =3D		xhci_bus_resume,
>  };
> =20
> +#if defined(CONFIG_HAVE_CLK)

I don't think this ifdef is necessary, clk api provides stubs.

> +static int try_enable_clk(struct platform_device *pdev)

prepend this with xhci_plat_ as all other definitions here.

> +{
> +	struct clk *clk =3D devm_clk_get(&pdev->dev, NULL);

you need to create a private xhci_plat structure and save a clock
pointer there.

> +
> +	/* Not all platforms have a clk so it is not an error if the clock
> +	   does not exists. */

comment style is wrong.

> +	if (!IS_ERR(clk))

even though some don't like it, the clk API is safe against NULL
pointers, one trick you could use is to set the clk pointer to NULL when
you fail to get it, then you'll have a single place where you check for
IS_ERR().

> +		if (clk_prepare_enable(clk))
> +			return  -ENODEV;
> +	return 0;

these three lines could be rewritten as:

	return clk_prepare_enable(clk);

> +}
> +
> +static int try_disable_clk(struct platform_device *pdev)
> +{
> +	struct clk *clk =3D devm_clk_get(&pdev->dev, NULL);
> +
> +	/* Not all platforms have a clk so it is not an error if the clock
> +	   does not exists. */
> +	if (!IS_ERR(clk))
> +		clk_disable_unprepare(clk);

similar comments to previous function.

>  static int xhci_plat_probe(struct platform_device *pdev)
>  {
>  	const struct hc_driver	*driver;
> @@ -107,6 +144,10 @@ static int xhci_plat_probe(struct platform_device *p=
dev)
>  	if (!res)
>  		return -ENODEV;
> =20
> +	ret =3D try_enable_clk(pdev);
> +	if (ret)
> +		return ret;
> +
>  	/* Initialize dma_mask and coherent_dma_mask to 32-bits */
>  	ret =3D dma_set_coherent_mask(&pdev->dev, DMA_BIT_MASK(32));
>  	if (ret)
> @@ -117,8 +158,10 @@ static int xhci_plat_probe(struct platform_device *p=
dev)
>  		dma_set_mask(&pdev->dev, DMA_BIT_MASK(32));
> =20
>  	hcd =3D usb_create_hcd(driver, &pdev->dev, dev_name(&pdev->dev));
> -	if (!hcd)
> -		return -ENOMEM;
> +	if (!hcd) {
> +		ret =3D -ENOMEM;
> +		goto disable_clk;
> +	}
> =20
>  	hcd->rsrc_start =3D res->start;
>  	hcd->rsrc_len =3D resource_size(res);
> @@ -182,6 +225,9 @@ release_mem_region:
>  put_hcd:
>  	usb_put_hcd(hcd);
> =20
> +disable_clk:
> +	try_disable_clk(pdev);
> +
>  	return ret;
>  }
> =20
> @@ -199,6 +245,8 @@ static int xhci_plat_remove(struct platform_device *d=
ev)
>  	usb_put_hcd(hcd);
>  	kfree(xhci);
> =20
> +	try_disable_clk(dev);

you never call clk_put(). what gives ?

--=20
balbi

--JWEK1jqKZ6MHAcjA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTWnj6AAoJEIaOsuA1yqRE4x0QAJN26xw3ki4U8m8lZPvdfuaj
DzReoLh3XbAOo3iXg8t5hJtI1ZidsG1XMGgEtVAw72XZdOhwbvfAucSKtSCD1Zyl
rLYA5G4UKzsSxENpkl/mlJxKNAtYJNPNKU+dFeUkjk3GMZM+ZUQzlyKRGzDbI69q
I2+7CqvDOwAAZ9nPPczoA9e8qkSmF6Jz42Xay7CS2EzD0pc73PusT7mBiyVAJfS8
rxDLtHUVqqIk1SYDq8Sov/9XowntPKck4Cz+ZL98F/mVZMOBamfUegAz9MgQqcKM
hvFGhbuVNXNEBL5mYEB0QWa6S4s9IOXxJ2KO1SfS5G8IPzHdLRE57ezBZLJakt5A
0DSNMxEtY3hgRtNGJVDcTBHbsyEevlf1QxmAyCDX9mJlY7wfBXvanmYTwlXpwYoe
8iHky/tsRJLajsQK4BiZ4dD91QkDiZOml4EBMlwELpOb3DoN3Upnagjad4HCqrFR
fEkVAFic3PDtPMR3IN41xT8L98aXa3wFYNcHS8QQ9Zwyvj/5BREZdo0tzoCzAzAj
CgfjFf5K1PA18dH/cl8hQf++v5eJiVLnGhOCqdVdHF2fj2/BI7v9ny+IZY+N7lcG
Wjo/XqwwJzI7P+J/LGQIwSTACMWbvm0V5mvjGIKvW0GObE45vtvbd1tp7WVG6Z3n
sZA6y5NlWY0G7pcY0X52
=+Gig
-----END PGP SIGNATURE-----

--JWEK1jqKZ6MHAcjA--
