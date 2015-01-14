Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753003AbbANNh7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 08:37:59 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:45804 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752974AbbANNh5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 08:37:57 -0500
Message-ID: <1421242658.19708.84.camel@decadent.org.uk>
Subject: Re: [PATCH 3.16.y-ckt 040/216] usb: gadget: at91_udc: move prepare
 clk into process context
From: Ben Hutchings <ben@decadent.org.uk>
To: Luis Henriques <luis.henriques@canonical.com>,
        Ronald Wahl <ronald.wahl@raritan.com>, Felipe Balbi <balbi@ti.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Date: Wed, 14 Jan 2015 13:37:38 +0000
In-Reply-To: <1421085933-32536-41-git-send-email-luis.henriques@canonical.com>
References: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
	 <1421085933-32536-41-git-send-email-luis.henriques@canonical.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-Hb/Vlj+eYLiuiXHE1yp6"
X-Mailer: Evolution 3.12.9-1+b1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:d586:d5c6:98ee:42f8
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Hb/Vlj+eYLiuiXHE1yp6
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2015-01-12 at 18:02 +0000, Luis Henriques wrote:
> 3.16.7-ckt4 -stable review patch.  If anyone has any objections, please l=
et me know.
>=20
> ------------------
>=20
> From: Ronald Wahl <ronald.wahl@raritan.com>
>=20
> commit b2ba27a5c56ff7204d8a8684893d64d4afe2cee5 upstream.
>=20
> Commit 7628083227b6bc4a7e33d7c381d7a4e558424b6b (usb: gadget: at91_udc:
> prepare clk before calling enable) added clock preparation in interrupt
> context. This is not allowed as it might sleep. Also setting the clock
> rate is unsafe to call from there for the same reason. Move clock
> preparation and setting clock rate into process context (at91udc_probe).
>=20
> Signed-off-by: Ronald Wahl <ronald.wahl@raritan.com>
> Acked-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
> Acked-by: Boris Brezillon <boris.brezillon@free-electrons.com>
> Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> Cc: Felipe Balbi <balbi@ti.com>
> Signed-off-by: Felipe Balbi <balbi@ti.com>
> Signed-off-by: Luis Henriques <luis.henriques@canonical.com>

This was requested for 3.17+, although commit 7628083227b6 went into
3.11.  Does it need backporting for 3.11-3.16 or will it work without
changes?

Ben.

> ---
>  drivers/usb/gadget/at91_udc.c | 44 +++++++++++++++++++++++++++++++------=
------
>  1 file changed, 32 insertions(+), 12 deletions(-)
>=20
> diff --git a/drivers/usb/gadget/at91_udc.c b/drivers/usb/gadget/at91_udc.=
c
> index cfd18bcca723..0d685d0b858e 100644
> --- a/drivers/usb/gadget/at91_udc.c
> +++ b/drivers/usb/gadget/at91_udc.c
> @@ -870,12 +870,10 @@ static void clk_on(struct at91_udc *udc)
>  		return;
>  	udc->clocked =3D 1;
> =20
> -	if (IS_ENABLED(CONFIG_COMMON_CLK)) {
> -		clk_set_rate(udc->uclk, 48000000);
> -		clk_prepare_enable(udc->uclk);
> -	}
> -	clk_prepare_enable(udc->iclk);
> -	clk_prepare_enable(udc->fclk);
> +	if (IS_ENABLED(CONFIG_COMMON_CLK))
> +		clk_enable(udc->uclk);
> +	clk_enable(udc->iclk);
> +	clk_enable(udc->fclk);
>  }
> =20
>  static void clk_off(struct at91_udc *udc)
> @@ -884,10 +882,10 @@ static void clk_off(struct at91_udc *udc)
>  		return;
>  	udc->clocked =3D 0;
>  	udc->gadget.speed =3D USB_SPEED_UNKNOWN;
> -	clk_disable_unprepare(udc->fclk);
> -	clk_disable_unprepare(udc->iclk);
> +	clk_disable(udc->fclk);
> +	clk_disable(udc->iclk);
>  	if (IS_ENABLED(CONFIG_COMMON_CLK))
> -		clk_disable_unprepare(udc->uclk);
> +		clk_disable(udc->uclk);
>  }
> =20
>  /*
> @@ -1780,14 +1778,24 @@ static int at91udc_probe(struct platform_device *=
pdev)
>  	}
> =20
>  	/* don't do anything until we have both gadget driver and VBUS */
> +	if (IS_ENABLED(CONFIG_COMMON_CLK)) {
> +		clk_set_rate(udc->uclk, 48000000);
> +		retval =3D clk_prepare(udc->uclk);
> +		if (retval)
> +			goto fail1;
> +	}
> +	retval =3D clk_prepare(udc->fclk);
> +	if (retval)
> +		goto fail1a;
> +
>  	retval =3D clk_prepare_enable(udc->iclk);
>  	if (retval)
> -		goto fail1;
> +		goto fail1b;
>  	at91_udp_write(udc, AT91_UDP_TXVC, AT91_UDP_TXVC_TXVDIS);
>  	at91_udp_write(udc, AT91_UDP_IDR, 0xffffffff);
>  	/* Clear all pending interrupts - UDP may be used by bootloader. */
>  	at91_udp_write(udc, AT91_UDP_ICR, 0xffffffff);
> -	clk_disable_unprepare(udc->iclk);
> +	clk_disable(udc->iclk);
> =20
>  	/* request UDC and maybe VBUS irqs */
>  	udc->udp_irq =3D platform_get_irq(pdev, 0);
> @@ -1795,7 +1803,7 @@ static int at91udc_probe(struct platform_device *pd=
ev)
>  			0, driver_name, udc);
>  	if (retval < 0) {
>  		DBG("request irq %d failed\n", udc->udp_irq);
> -		goto fail1;
> +		goto fail1c;
>  	}
>  	if (gpio_is_valid(udc->board.vbus_pin)) {
>  		retval =3D gpio_request(udc->board.vbus_pin, "udc_vbus");
> @@ -1848,6 +1856,13 @@ fail3:
>  		gpio_free(udc->board.vbus_pin);
>  fail2:
>  	free_irq(udc->udp_irq, udc);
> +fail1c:
> +	clk_unprepare(udc->iclk);
> +fail1b:
> +	clk_unprepare(udc->fclk);
> +fail1a:
> +	if (IS_ENABLED(CONFIG_COMMON_CLK))
> +		clk_unprepare(udc->uclk);
>  fail1:
>  	if (IS_ENABLED(CONFIG_COMMON_CLK) && !IS_ERR(udc->uclk))
>  		clk_put(udc->uclk);
> @@ -1896,6 +1911,11 @@ static int __exit at91udc_remove(struct platform_d=
evice *pdev)
>  	res =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);
>  	release_mem_region(res->start, resource_size(res));
> =20
> +	if (IS_ENABLED(CONFIG_COMMON_CLK))
> +		clk_unprepare(udc->uclk);
> +	clk_unprepare(udc->fclk);
> +	clk_unprepare(udc->iclk);
> +
>  	clk_put(udc->iclk);
>  	clk_put(udc->fclk);
>  	if (IS_ENABLED(CONFIG_COMMON_CLK))

--=20
Ben Hutchings
The world is coming to an end.	Please log off.

--=-Hb/Vlj+eYLiuiXHE1yp6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUAVLZxKee/yOyVhhEJAQql8w/+ME9Vh/OuA/rtf0VmCu8jRMjc1ZSB+DXE
Cmt1eWXITVwcJZxSAZd5uMRXKsGKgjtpmE6GS5KiMAXyj7UHQ5tqOhqATtE01vSM
vlOSTtgOSXD0YgeVS6y+sSdZ4nGl+gXSJv0WfFtTs6g5DGVWWKtY2fXpuOA6uL/L
M64LF1+6W3OcCjKuiRmix7zntB/M9eyrVFJd7TeagooUQh0ow4DSLg2fExFzrpVE
y7MJjeQ6yxpUED6PR2S1efL4vN95gklqA/kPPwTvPPQ0gzeZeSYZHDKDTrpkv1F+
T11zScl2u/DP4g87I+uZS0iWuXU6F5FXy5B2YE56dNmKtNYLpREbQ1JJ6zt5HNoz
apMRCmOWdxYJyc3kqJwI0n9ULCBOJqCC2CqfLx2MyUaT1DQATHNKOWXB4OM7D/ZM
r5QMIG7MxsJtZkgZafjY86jqgHjHW+O4aGGIAAV+0QWaRuli3AtvJCugE+CveEFv
YxUGkYDNU/uLdK3s6biKKrFWz5dRbhUJCYAhGk24YQ+5F7EweCNWCLCTVrCZOBBt
dWgBoVZomDI67u3yt8xOQzBOSkHWYRtit+HKm0soPA0ruGCRb+yklh/l4YscNYWE
BY5UOhD2/jvjibSeTBWClbk0H1bw84KyKeR/ZbWNxZmBd5eIpbphLfYFTnx8Odf+
pLyM4feWt+g=
=y9em
-----END PGP SIGNATURE-----

--=-Hb/Vlj+eYLiuiXHE1yp6--
