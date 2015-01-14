Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754522AbbANRkS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 12:40:18 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:38629 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754399AbbANRkL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 12:40:11 -0500
Date: Wed, 14 Jan 2015 11:38:22 -0600
From: Felipe Balbi <balbi@ti.com>
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
CC: Felipe Balbi <balbi@ti.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Arnd Bergmann <arnd@arndb.de>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Jean-Jacques Hiblot <jjhiblot@traphandler.com>
Subject: Re: [PATCH 09/12] usb: gadget: at91_udc: Simplify probe and remove
 functions
Message-ID: <20150114173822.GJ16533@saruman>
Reply-To: <balbi@ti.com>
References: <1421252524-24452-1-git-send-email-alexandre.belloni@free-electrons.com>
 <1421252524-24452-10-git-send-email-alexandre.belloni@free-electrons.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="NrP+m7YXMSGlHqXH"
Content-Disposition: inline
In-Reply-To: <1421252524-24452-10-git-send-email-alexandre.belloni@free-electrons.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--NrP+m7YXMSGlHqXH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 14, 2015 at 05:22:01PM +0100, Alexandre Belloni wrote:
> From: Boris Brezillon <boris.brezillon@free-electrons.com>
>=20
> Make use of devm_ functions to simplify probe and remove code.
>=20
> Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>

Acked-by: Felipe Balbi <balbi@ti.com>

> ---
>  drivers/usb/gadget/udc/at91_udc.c | 116 +++++++++++++-------------------=
------
>  1 file changed, 39 insertions(+), 77 deletions(-)
>=20
> diff --git a/drivers/usb/gadget/udc/at91_udc.c b/drivers/usb/gadget/udc/a=
t91_udc.c
> index be7e16037ac4..4dba2c65dfd4 100644
> --- a/drivers/usb/gadget/udc/at91_udc.c
> +++ b/drivers/usb/gadget/udc/at91_udc.c
> @@ -1710,15 +1710,6 @@ static int at91udc_probe(struct platform_device *p=
dev)
>  	int		retval;
>  	struct resource	*res;
> =20
> -	res =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);
> -	if (!res)
> -		return -ENXIO;
> -
> -	if (!request_mem_region(res->start, resource_size(res), driver_name)) {
> -		DBG("someone's using UDC memory\n");
> -		return -EBUSY;
> -	}
> -
>  	/* init software state */
>  	udc =3D &controller;
>  	udc->gadget.dev.parent =3D dev;
> @@ -1731,13 +1722,13 @@ static int at91udc_probe(struct platform_device *=
pdev)
>  	if (cpu_is_at91rm9200()) {
>  		if (!gpio_is_valid(udc->board.pullup_pin)) {
>  			DBG("no D+ pullup?\n");
> -			retval =3D -ENODEV;
> -			goto fail0;
> +			return -ENODEV;
>  		}
> -		retval =3D gpio_request(udc->board.pullup_pin, "udc_pullup");
> +		retval =3D devm_gpio_request(dev, udc->board.pullup_pin,
> +					   "udc_pullup");
>  		if (retval) {
>  			DBG("D+ pullup is busy\n");
> -			goto fail0;
> +			return retval;
>  		}
>  		gpio_direction_output(udc->board.pullup_pin,
>  				udc->board.pullup_active_low);
> @@ -1756,32 +1747,32 @@ static int at91udc_probe(struct platform_device *=
pdev)
>  		udc->ep[3].maxpacket =3D 64;
>  	}
> =20
> -	udc->udp_baseaddr =3D ioremap(res->start, resource_size(res));
> -	if (!udc->udp_baseaddr) {
> -		retval =3D -ENOMEM;
> -		goto fail0a;
> -	}
> +	res =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	udc->udp_baseaddr =3D devm_ioremap_resource(dev, res);
> +	if (IS_ERR(udc->udp_baseaddr))
> +		return PTR_ERR(udc->udp_baseaddr);
> =20
>  	udc_reinit(udc);
> =20
>  	/* get interface and function clocks */
> -	udc->iclk =3D clk_get(dev, "pclk");
> -	udc->fclk =3D clk_get(dev, "hclk");
> -	if (IS_ERR(udc->iclk) || IS_ERR(udc->fclk)) {
> -		DBG("clocks missing\n");
> -		retval =3D -ENODEV;
> -		goto fail1;
> -	}
> +	udc->iclk =3D devm_clk_get(dev, "pclk");
> +	if (IS_ERR(udc->iclk))
> +		return PTR_ERR(udc->iclk);
> +
> +	udc->fclk =3D devm_clk_get(dev, "hclk");
> +	if (IS_ERR(udc->fclk))
> +		return PTR_ERR(udc->fclk);
> =20
>  	/* don't do anything until we have both gadget driver and VBUS */
>  	clk_set_rate(udc->fclk, 48000000);
>  	retval =3D clk_prepare(udc->fclk);
>  	if (retval)
> -		goto fail1;
> +		return retval;
> =20
>  	retval =3D clk_prepare_enable(udc->iclk);
>  	if (retval)
> -		goto fail1b;
> +		goto err_unprepare_fclk;
> +
>  	at91_udp_write(udc, AT91_UDP_TXVC, AT91_UDP_TXVC_TXVDIS);
>  	at91_udp_write(udc, AT91_UDP_IDR, 0xffffffff);
>  	/* Clear all pending interrupts - UDP may be used by bootloader. */
> @@ -1790,18 +1781,21 @@ static int at91udc_probe(struct platform_device *=
pdev)
> =20
>  	/* request UDC and maybe VBUS irqs */
>  	udc->udp_irq =3D platform_get_irq(pdev, 0);
> -	retval =3D request_irq(udc->udp_irq, at91_udc_irq,
> -			0, driver_name, udc);
> -	if (retval < 0) {
> +	retval =3D devm_request_irq(dev, udc->udp_irq, at91_udc_irq, 0,
> +				  driver_name, udc);
> +	if (retval) {
>  		DBG("request irq %d failed\n", udc->udp_irq);
> -		goto fail1c;
> +		goto err_unprepare_iclk;
>  	}
> +
>  	if (gpio_is_valid(udc->board.vbus_pin)) {
> -		retval =3D gpio_request(udc->board.vbus_pin, "udc_vbus");
> -		if (retval < 0) {
> +		retval =3D devm_gpio_request(dev, udc->board.vbus_pin,
> +					   "udc_vbus");
> +		if (retval) {
>  			DBG("request vbus pin failed\n");
> -			goto fail2;
> +			goto err_unprepare_iclk;
>  		}
> +
>  		gpio_direction_input(udc->board.vbus_pin);
> =20
>  		/*
> @@ -1818,12 +1812,13 @@ static int at91udc_probe(struct platform_device *=
pdev)
>  			mod_timer(&udc->vbus_timer,
>  				  jiffies + VBUS_POLL_TIMEOUT);
>  		} else {
> -			if (request_irq(gpio_to_irq(udc->board.vbus_pin),
> -					at91_vbus_irq, 0, driver_name, udc)) {
> +			retval =3D devm_request_irq(dev,
> +					gpio_to_irq(udc->board.vbus_pin),
> +					at91_vbus_irq, 0, driver_name, udc);
> +			if (retval) {
>  				DBG("request vbus irq %d failed\n",
>  				    udc->board.vbus_pin);
> -				retval =3D -EBUSY;
> -				goto fail3;
> +				goto err_unprepare_iclk;
>  			}
>  		}
>  	} else {
> @@ -1832,44 +1827,27 @@ static int at91udc_probe(struct platform_device *=
pdev)
>  	}
>  	retval =3D usb_add_gadget_udc(dev, &udc->gadget);
>  	if (retval)
> -		goto fail4;
> +		goto err_unprepare_iclk;
>  	dev_set_drvdata(dev, udc);
>  	device_init_wakeup(dev, 1);
>  	create_debug_file(udc);
> =20
>  	INFO("%s version %s\n", driver_name, DRIVER_VERSION);
>  	return 0;
> -fail4:
> -	if (gpio_is_valid(udc->board.vbus_pin) && !udc->board.vbus_polled)
> -		free_irq(gpio_to_irq(udc->board.vbus_pin), udc);
> -fail3:
> -	if (gpio_is_valid(udc->board.vbus_pin))
> -		gpio_free(udc->board.vbus_pin);
> -fail2:
> -	free_irq(udc->udp_irq, udc);
> -fail1c:
> +
> +err_unprepare_iclk:
>  	clk_unprepare(udc->iclk);
> -fail1b:
> +err_unprepare_fclk:
>  	clk_unprepare(udc->fclk);
> -fail1:
> -	if (!IS_ERR(udc->fclk))
> -		clk_put(udc->fclk);
> -	if (!IS_ERR(udc->iclk))
> -		clk_put(udc->iclk);
> -	iounmap(udc->udp_baseaddr);
> -fail0a:
> -	if (cpu_is_at91rm9200())
> -		gpio_free(udc->board.pullup_pin);
> -fail0:
> -	release_mem_region(res->start, resource_size(res));
> +
>  	DBG("%s probe failed, %d\n", driver_name, retval);
> +
>  	return retval;
>  }
> =20
>  static int __exit at91udc_remove(struct platform_device *pdev)
>  {
>  	struct at91_udc *udc =3D platform_get_drvdata(pdev);
> -	struct resource *res;
>  	unsigned long	flags;
> =20
>  	DBG("remove\n");
> @@ -1884,25 +1862,9 @@ static int __exit at91udc_remove(struct platform_d=
evice *pdev)
> =20
>  	device_init_wakeup(&pdev->dev, 0);
>  	remove_debug_file(udc);
> -	if (gpio_is_valid(udc->board.vbus_pin)) {
> -		free_irq(gpio_to_irq(udc->board.vbus_pin), udc);
> -		gpio_free(udc->board.vbus_pin);
> -	}
> -	free_irq(udc->udp_irq, udc);
> -	iounmap(udc->udp_baseaddr);
> -
> -	if (cpu_is_at91rm9200())
> -		gpio_free(udc->board.pullup_pin);
> -
> -	res =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);
> -	release_mem_region(res->start, resource_size(res));
> -
>  	clk_unprepare(udc->fclk);
>  	clk_unprepare(udc->iclk);
> =20
> -	clk_put(udc->iclk);
> -	clk_put(udc->fclk);
> -
>  	return 0;
>  }
> =20
> --=20
> 2.1.0
>=20

--=20
balbi

--NrP+m7YXMSGlHqXH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUtqmOAAoJEIaOsuA1yqREWy0P/1r++WSL4uBbCnk0VxBgkCyP
49ID05XmmyXyn/WtDWwKK5W5iRIuOg2Ueg303KobzLE6nCXvq3SEhNXJdJaD3Alp
XyskfKz8TQYxuS31u0zDBNidrBGu79/Mrdgj7WUhZn7WpQkwXUMyG+VBoHMopj5i
NbIou8hmyZMMpEuY3RH0uZkXGESLYffNoJd7Ek+hWUoqL+KZUFQQ0e0g37I7SDTp
2VCuq7lWPDmefFET4tKi/pZbdFyyybhalsRCdqUML14bxTs6+W7VBrlA0Caf7veC
fC5/q42GMO3CQIxzAyxRuh9sGxvqQujhbIL7WYJo2VnTai2GLBBY/OZx9jxvBJJV
OiRWSQGdrJdcktXCUiQtBWfkF+eg4f0Rjrj/NpFxMLy9/d8AsLnYYFu0MKbn/k27
JDVAOJlUjDuXCdNrLYaeGWpl+xz4cIho5+fkk/a+0ZNe45zoTEJ+2Gqwbkf+edkr
l6QlC/w0x8F18bfUYEWICmvLHXhiE3FSY4iJ5CH5SvyaBUzyLqu0sm+aiy/w/Khr
sy9hfqGEvGbJ4cEBWwHTW0WojGQ6DY2NsufNHaxWczPLXVH/2HerE4xNwmN38X0p
IoEJaRXPFWf9D/w349rHbbO1w2tYLMyz0UsdqqzajmhO20oAd7fjgAG83ZMZ48ms
6lkAvrvUk2kj/28mSTVD
=0lqP
-----END PGP SIGNATURE-----

--NrP+m7YXMSGlHqXH--
