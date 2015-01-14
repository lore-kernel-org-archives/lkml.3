Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754405AbbANRiz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 12:38:55 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:55109 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754230AbbANRiv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 12:38:51 -0500
Date: Wed, 14 Jan 2015 11:37:36 -0600
From: Felipe Balbi <balbi@ti.com>
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
CC: Felipe Balbi <balbi@ti.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Arnd Bergmann <arnd@arndb.de>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Jean-Jacques Hiblot <jjhiblot@traphandler.com>
Subject: Re: [PATCH 06/12] usb: gadget: at91_udc: Drop uclk clock
Message-ID: <20150114173736.GH16533@saruman>
Reply-To: <balbi@ti.com>
References: <1421252524-24452-1-git-send-email-alexandre.belloni@free-electrons.com>
 <1421252524-24452-7-git-send-email-alexandre.belloni@free-electrons.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="McTFpSeH7KqpdXA3"
Content-Disposition: inline
In-Reply-To: <1421252524-24452-7-git-send-email-alexandre.belloni@free-electrons.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--McTFpSeH7KqpdXA3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 14, 2015 at 05:21:58PM +0100, Alexandre Belloni wrote:
> From: Boris Brezillon <boris.brezillon@free-electrons.com>
>=20
> Now that at91 system clocks forward set_rate request to their parent we
> can remove the uclk clock and directly call clk_set_rate on fclk.
>=20
> Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>

Acked-by: Felipe Balbi <balbi@ti.com>

> ---
>  drivers/usb/gadget/udc/at91_udc.c | 27 +++------------------------
>  drivers/usb/gadget/udc/at91_udc.h |  2 +-
>  2 files changed, 4 insertions(+), 25 deletions(-)
>=20
> diff --git a/drivers/usb/gadget/udc/at91_udc.c b/drivers/usb/gadget/udc/a=
t91_udc.c
> index 9ff2f7e5c6a7..d33f2994b7c4 100644
> --- a/drivers/usb/gadget/udc/at91_udc.c
> +++ b/drivers/usb/gadget/udc/at91_udc.c
> @@ -895,8 +895,6 @@ static void clk_on(struct at91_udc *udc)
>  		return;
>  	udc->clocked =3D 1;
> =20
> -	if (IS_ENABLED(CONFIG_COMMON_CLK))
> -		clk_enable(udc->uclk);
>  	clk_enable(udc->iclk);
>  	clk_enable(udc->fclk);
>  }
> @@ -909,8 +907,6 @@ static void clk_off(struct at91_udc *udc)
>  	udc->gadget.speed =3D USB_SPEED_UNKNOWN;
>  	clk_disable(udc->fclk);
>  	clk_disable(udc->iclk);
> -	if (IS_ENABLED(CONFIG_COMMON_CLK))
> -		clk_disable(udc->uclk);
>  }
> =20
>  /*
> @@ -1781,25 +1777,17 @@ static int at91udc_probe(struct platform_device *=
pdev)
>  	/* get interface and function clocks */
>  	udc->iclk =3D clk_get(dev, "pclk");
>  	udc->fclk =3D clk_get(dev, "hclk");
> -	if (IS_ENABLED(CONFIG_COMMON_CLK))
> -		udc->uclk =3D clk_get(dev, "usb_clk");
> -	if (IS_ERR(udc->iclk) || IS_ERR(udc->fclk) ||
> -	    (IS_ENABLED(CONFIG_COMMON_CLK) && IS_ERR(udc->uclk))) {
> +	if (IS_ERR(udc->iclk) || IS_ERR(udc->fclk)) {
>  		DBG("clocks missing\n");
>  		retval =3D -ENODEV;
>  		goto fail1;
>  	}
> =20
>  	/* don't do anything until we have both gadget driver and VBUS */
> -	if (IS_ENABLED(CONFIG_COMMON_CLK)) {
> -		clk_set_rate(udc->uclk, 48000000);
> -		retval =3D clk_prepare(udc->uclk);
> -		if (retval)
> -			goto fail1;
> -	}
> +	clk_set_rate(udc->fclk, 48000000);
>  	retval =3D clk_prepare(udc->fclk);
>  	if (retval)
> -		goto fail1a;
> +		goto fail1;
> =20
>  	retval =3D clk_prepare_enable(udc->iclk);
>  	if (retval)
> @@ -1873,12 +1861,7 @@ fail1c:
>  	clk_unprepare(udc->iclk);
>  fail1b:
>  	clk_unprepare(udc->fclk);
> -fail1a:
> -	if (IS_ENABLED(CONFIG_COMMON_CLK))
> -		clk_unprepare(udc->uclk);
>  fail1:
> -	if (IS_ENABLED(CONFIG_COMMON_CLK) && !IS_ERR(udc->uclk))
> -		clk_put(udc->uclk);
>  	if (!IS_ERR(udc->fclk))
>  		clk_put(udc->fclk);
>  	if (!IS_ERR(udc->iclk))
> @@ -1924,15 +1907,11 @@ static int __exit at91udc_remove(struct platform_=
device *pdev)
>  	res =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);
>  	release_mem_region(res->start, resource_size(res));
> =20
> -	if (IS_ENABLED(CONFIG_COMMON_CLK))
> -		clk_unprepare(udc->uclk);
>  	clk_unprepare(udc->fclk);
>  	clk_unprepare(udc->iclk);
> =20
>  	clk_put(udc->iclk);
>  	clk_put(udc->fclk);
> -	if (IS_ENABLED(CONFIG_COMMON_CLK))
> -		clk_put(udc->uclk);
> =20
>  	return 0;
>  }
> diff --git a/drivers/usb/gadget/udc/at91_udc.h b/drivers/usb/gadget/udc/a=
t91_udc.h
> index 017524663381..e647d1c2ada4 100644
> --- a/drivers/usb/gadget/udc/at91_udc.h
> +++ b/drivers/usb/gadget/udc/at91_udc.h
> @@ -126,7 +126,7 @@ struct at91_udc {
>  	unsigned			active_suspend:1;
>  	u8				addr;
>  	struct at91_udc_data		board;
> -	struct clk			*iclk, *fclk, *uclk;
> +	struct clk			*iclk, *fclk;
>  	struct platform_device		*pdev;
>  	struct proc_dir_entry		*pde;
>  	void __iomem			*udp_baseaddr;
> --=20
> 2.1.0
>=20

--=20
balbi

--McTFpSeH7KqpdXA3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUtqlgAAoJEIaOsuA1yqRE4vEP/jcVp4HWHVbOhIDjlFsJY0gO
NzKcwkAY1qmj/xdM4sfQsYVzkQ1fmTGOZc8JbN2cmeb71Xl6pNaFcZeW3Hck3vZ3
TifYV6uXtA1ldl2XI2oqSiER+w3L9XficuKAFzBo7Cir77wMqNXjuWdik9fqwGMz
+r/pk17h3asVjqCgqH3n7ruCC5cUaBgft3CLe0cre+2sxd7TSgBsPbSD1rIC/j+m
x+PB9+fjrsafKBYWldRuq8vGyuDHihfkmL85xOJkkGGfxlHGr4pX6w4VVmT0Aq3W
z5wUNOATg/oNrYjLL3VqMoym3bAreEBdke0G+bbSjk+Qdw9kaNqqFx/gRNhIjN/0
HeYKgQ2/zaoNLo3NJOLXJqwME2iJw9JbLTL/hiK/I4ZO57GLXCA1wHGxsajTz62m
ZXl+xyCyoWSzW1rf5aS9c5lWI9H5RYPZGvm10i30CKpuAZBnj1C3TRPYotvgIObN
fbOk0SuChm7pkeevXITiA2NB+rUS/vGQkd9e7pw7LB4hv9auuVZ/ZPWg9qRAKrr7
8C3loEOviSY6cQGss2DN3dwu4a6gTsiMCZ00naoeV4Q56pZXce5qs59Dy2yn8BU9
cEt2pFI+Gn+3SXnxg2wmCTgZY0eWXUwtCbc/IldsIwfypjTwVt4N++dAXwRZcyr1
t25ORDRr7AUOK+DvBLHz
=/q+l
-----END PGP SIGNATURE-----

--McTFpSeH7KqpdXA3--
