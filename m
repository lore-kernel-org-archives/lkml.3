Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754490AbbANRjx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 12:39:53 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:38485 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753824AbbANRjw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 12:39:52 -0500
Date: Wed, 14 Jan 2015 11:38:38 -0600
From: Felipe Balbi <balbi@ti.com>
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
CC: Felipe Balbi <balbi@ti.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Arnd Bergmann <arnd@arndb.de>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Jean-Jacques Hiblot <jjhiblot@traphandler.com>
Subject: Re: [PATCH 10/12] usb: gadget: at91_udc: Rework for multi-platform
 kernel support
Message-ID: <20150114173838.GK16533@saruman>
Reply-To: <balbi@ti.com>
References: <1421252524-24452-1-git-send-email-alexandre.belloni@free-electrons.com>
 <1421252524-24452-11-git-send-email-alexandre.belloni@free-electrons.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ibe32dcbQs37CEZO"
Content-Disposition: inline
In-Reply-To: <1421252524-24452-11-git-send-email-alexandre.belloni@free-electrons.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--ibe32dcbQs37CEZO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 14, 2015 at 05:22:02PM +0100, Alexandre Belloni wrote:
> From: Boris Brezillon <boris.brezillon@free-electrons.com>
>=20
> cpu_is_at91xxx are a set of macros defined in mach/cpu.h and are here used
> to detect the SoC we are booting on.
> Use compatible string + a caps structure to replace those cpu_is_xxx test=
s.
>=20
> Remove all mach and asm headers (which are now unused).
>=20
> Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>

Acked-by: Felipe Balbi <balbi@ti.com>

> ---
>  drivers/usb/gadget/udc/at91_udc.c | 288 ++++++++++++++++++++++++++++----=
------
>  drivers/usb/gadget/udc/at91_udc.h |   7 +
>  2 files changed, 218 insertions(+), 77 deletions(-)
>=20
> diff --git a/drivers/usb/gadget/udc/at91_udc.c b/drivers/usb/gadget/udc/a=
t91_udc.c
> index 4dba2c65dfd4..c0abb9bc76a9 100644
> --- a/drivers/usb/gadget/udc/at91_udc.c
> +++ b/drivers/usb/gadget/udc/at91_udc.c
> @@ -31,16 +31,9 @@
>  #include <linux/of.h>
>  #include <linux/of_gpio.h>
>  #include <linux/platform_data/atmel.h>
> -
> -#include <asm/byteorder.h>
> -#include <mach/hardware.h>
> -#include <asm/io.h>
> -#include <asm/irq.h>
> -#include <asm/gpio.h>
> -
> -#include <mach/cpu.h>
> -#include <mach/at91sam9261_matrix.h>
> -#include <mach/at91_matrix.h>
> +#include <linux/regmap.h>
> +#include <linux/mfd/syscon.h>
> +#include <linux/mfd/syscon/atmel-matrix.h>
> =20
>  #include "at91_udc.h"
> =20
> @@ -915,8 +908,6 @@ static void clk_off(struct at91_udc *udc)
>   */
>  static void pullup(struct at91_udc *udc, int is_on)
>  {
> -	int	active =3D !udc->board.pullup_active_low;
> -
>  	if (!udc->enabled || !udc->vbus)
>  		is_on =3D 0;
>  	DBG("%sactive\n", is_on ? "" : "in");
> @@ -925,40 +916,15 @@ static void pullup(struct at91_udc *udc, int is_on)
>  		clk_on(udc);
>  		at91_udp_write(udc, AT91_UDP_ICR, AT91_UDP_RXRSM);
>  		at91_udp_write(udc, AT91_UDP_TXVC, 0);
> -		if (cpu_is_at91rm9200())
> -			gpio_set_value(udc->board.pullup_pin, active);
> -		else if (cpu_is_at91sam9260() || cpu_is_at91sam9263() || cpu_is_at91sa=
m9g20()) {
> -			u32	txvc =3D at91_udp_read(udc, AT91_UDP_TXVC);
> -
> -			txvc |=3D AT91_UDP_TXVC_PUON;
> -			at91_udp_write(udc, AT91_UDP_TXVC, txvc);
> -		} else if (cpu_is_at91sam9261() || cpu_is_at91sam9g10()) {
> -			u32	usbpucr;
> -
> -			usbpucr =3D at91_matrix_read(AT91_MATRIX_USBPUCR);
> -			usbpucr |=3D AT91_MATRIX_USBPUCR_PUON;
> -			at91_matrix_write(AT91_MATRIX_USBPUCR, usbpucr);
> -		}
>  	} else {
>  		stop_activity(udc);
>  		at91_udp_write(udc, AT91_UDP_IDR, AT91_UDP_RXRSM);
>  		at91_udp_write(udc, AT91_UDP_TXVC, AT91_UDP_TXVC_TXVDIS);
> -		if (cpu_is_at91rm9200())
> -			gpio_set_value(udc->board.pullup_pin, !active);
> -		else if (cpu_is_at91sam9260() || cpu_is_at91sam9263() || cpu_is_at91sa=
m9g20()) {
> -			u32	txvc =3D at91_udp_read(udc, AT91_UDP_TXVC);
> -
> -			txvc &=3D ~AT91_UDP_TXVC_PUON;
> -			at91_udp_write(udc, AT91_UDP_TXVC, txvc);
> -		} else if (cpu_is_at91sam9261() || cpu_is_at91sam9g10()) {
> -			u32	usbpucr;
> -
> -			usbpucr =3D at91_matrix_read(AT91_MATRIX_USBPUCR);
> -			usbpucr &=3D ~AT91_MATRIX_USBPUCR_PUON;
> -			at91_matrix_write(AT91_MATRIX_USBPUCR, usbpucr);
> -		}
>  		clk_off(udc);
>  	}
> +
> +	if (udc->caps && udc->caps->pullup)
> +		udc->caps->pullup(udc, is_on);
>  }
> =20
>  /* vbus is here!  turn everything on that's ready */
> @@ -1683,12 +1649,202 @@ static void at91udc_shutdown(struct platform_dev=
ice *dev)
>  	spin_unlock_irqrestore(&udc->lock, flags);
>  }
> =20
> -static void at91udc_of_init(struct at91_udc *udc,
> -				     struct device_node *np)
> +static int at91rm9200_udc_init(struct at91_udc *udc)
> +{
> +	struct at91_ep *ep;
> +	int ret;
> +	int i;
> +
> +	for (i =3D 0; i < NUM_ENDPOINTS; i++) {
> +		ep =3D &udc->ep[i];
> +
> +		switch (i) {
> +		case 0:
> +		case 3:
> +			ep->maxpacket =3D 8;
> +			break;
> +		case 1 ... 2:
> +			ep->maxpacket =3D 64;
> +			break;
> +		case 4 ... 5:
> +			ep->maxpacket =3D 256;
> +			break;
> +		}
> +	}
> +
> +	if (!gpio_is_valid(udc->board.pullup_pin)) {
> +		DBG("no D+ pullup?\n");
> +		return -ENODEV;
> +	}
> +
> +	ret =3D devm_gpio_request(&udc->pdev->dev, udc->board.pullup_pin,
> +				"udc_pullup");
> +	if (ret) {
> +		DBG("D+ pullup is busy\n");
> +		return ret;
> +	}
> +
> +	gpio_direction_output(udc->board.pullup_pin,
> +			      udc->board.pullup_active_low);
> +
> +	return 0;
> +}
> +
> +static void at91rm9200_udc_pullup(struct at91_udc *udc, int is_on)
> +{
> +	int active =3D !udc->board.pullup_active_low;
> +
> +	if (is_on)
> +		gpio_set_value(udc->board.pullup_pin, active);
> +	else
> +		gpio_set_value(udc->board.pullup_pin, !active);
> +}
> +
> +static const struct at91_udc_caps at91rm9200_udc_caps =3D {
> +	.init =3D at91rm9200_udc_init,
> +	.pullup =3D at91rm9200_udc_pullup,
> +};
> +
> +static int at91sam9260_udc_init(struct at91_udc *udc)
> +{
> +	struct at91_ep *ep;
> +	int i;
> +
> +	for (i =3D 0; i < NUM_ENDPOINTS; i++) {
> +		ep =3D &udc->ep[i];
> +
> +		switch (i) {
> +		case 0 ... 3:
> +			ep->maxpacket =3D 64;
> +			break;
> +		case 4 ... 5:
> +			ep->maxpacket =3D 512;
> +			break;
> +		}
> +	}
> +
> +	return 0;
> +}
> +
> +static void at91sam9260_udc_pullup(struct at91_udc *udc, int is_on)
> +{
> +	u32 txvc =3D at91_udp_read(udc, AT91_UDP_TXVC);
> +
> +	if (is_on)
> +		txvc |=3D AT91_UDP_TXVC_PUON;
> +	else
> +		txvc &=3D ~AT91_UDP_TXVC_PUON;
> +
> +	at91_udp_write(udc, AT91_UDP_TXVC, txvc);
> +}
> +
> +static const struct at91_udc_caps at91sam9260_udc_caps =3D {
> +	.init =3D at91sam9260_udc_init,
> +	.pullup =3D at91sam9260_udc_pullup,
> +};
> +
> +static int at91sam9261_udc_init(struct at91_udc *udc)
> +{
> +	struct at91_ep *ep;
> +	int i;
> +
> +	for (i =3D 0; i < NUM_ENDPOINTS; i++) {
> +		ep =3D &udc->ep[i];
> +
> +		switch (i) {
> +		case 0:
> +			ep->maxpacket =3D 8;
> +			break;
> +		case 1 ... 3:
> +			ep->maxpacket =3D 64;
> +			break;
> +		case 4 ... 5:
> +			ep->maxpacket =3D 256;
> +			break;
> +		}
> +	}
> +
> +	udc->matrix =3D syscon_regmap_lookup_by_phandle(udc->pdev->dev.of_node,
> +						      "atmel,matrix");
> +	if (IS_ERR(udc->matrix))
> +		return PTR_ERR(udc->matrix);
> +
> +	return 0;
> +}
> +
> +static void at91sam9261_udc_pullup(struct at91_udc *udc, int is_on)
> +{
> +	u32 usbpucr =3D 0;
> +
> +	if (is_on)
> +		usbpucr =3D AT91_MATRIX_USBPUCR_PUON;
> +
> +	regmap_update_bits(udc->matrix, AT91SAM9261_MATRIX_USBPUCR,
> +			   AT91_MATRIX_USBPUCR_PUON, usbpucr);
> +}
> +
> +static const struct at91_udc_caps at91sam9261_udc_caps =3D {
> +	.init =3D at91sam9261_udc_init,
> +	.pullup =3D at91sam9261_udc_pullup,
> +};
> +
> +static int at91sam9263_udc_init(struct at91_udc *udc)
> +{
> +	struct at91_ep *ep;
> +	int i;
> +
> +	for (i =3D 0; i < NUM_ENDPOINTS; i++) {
> +		ep =3D &udc->ep[i];
> +
> +		switch (i) {
> +		case 0:
> +		case 1:
> +		case 2:
> +		case 3:
> +			ep->maxpacket =3D 64;
> +			break;
> +		case 4:
> +		case 5:
> +			ep->maxpacket =3D 256;
> +			break;
> +		}
> +	}
> +
> +	return 0;
> +}
> +
> +static const struct at91_udc_caps at91sam9263_udc_caps =3D {
> +	.init =3D at91sam9263_udc_init,
> +	.pullup =3D at91sam9260_udc_pullup,
> +};
> +
> +static const struct of_device_id at91_udc_dt_ids[] =3D {
> +	{
> +		.compatible =3D "atmel,at91rm9200-udc",
> +		.data =3D &at91rm9200_udc_caps,
> +	},
> +	{
> +		.compatible =3D "atmel,at91sam9260-udc",
> +		.data =3D &at91sam9260_udc_caps,
> +	},
> +	{
> +		.compatible =3D "atmel,at91sam9261-udc",
> +		.data =3D &at91sam9261_udc_caps,
> +	},
> +	{
> +		.compatible =3D "atmel,at91sam9263-udc",
> +		.data =3D &at91sam9263_udc_caps,
> +	},
> +	{ /* sentinel */ }
> +};
> +MODULE_DEVICE_TABLE(of, at91_udc_dt_ids);
> +
> +static void at91udc_of_init(struct at91_udc *udc, struct device_node *np)
>  {
>  	struct at91_udc_data *board =3D &udc->board;
> -	u32 val;
> +	const struct of_device_id *match;
>  	enum of_gpio_flags flags;
> +	u32 val;
> =20
>  	if (of_property_read_u32(np, "atmel,vbus-polled", &val) =3D=3D 0)
>  		board->vbus_polled =3D 1;
> @@ -1701,6 +1857,10 @@ static void at91udc_of_init(struct at91_udc *udc,
>  						  &flags);
> =20
>  	board->pullup_active_low =3D (flags & OF_GPIO_ACTIVE_LOW) ? 1 : 0;
> +
> +	match =3D of_match_node(at91_udc_dt_ids, np);
> +	if (match)
> +		udc->caps =3D match->data;
>  }
> =20
>  static int at91udc_probe(struct platform_device *pdev)
> @@ -1709,6 +1869,8 @@ static int at91udc_probe(struct platform_device *pd=
ev)
>  	struct at91_udc	*udc;
>  	int		retval;
>  	struct resource	*res;
> +	struct at91_ep	*ep;
> +	int		i;
> =20
>  	/* init software state */
>  	udc =3D &controller;
> @@ -1718,40 +1880,19 @@ static int at91udc_probe(struct platform_device *=
pdev)
>  	udc->enabled =3D 0;
>  	spin_lock_init(&udc->lock);
> =20
> -	/* rm9200 needs manual D+ pullup; off by default */
> -	if (cpu_is_at91rm9200()) {
> -		if (!gpio_is_valid(udc->board.pullup_pin)) {
> -			DBG("no D+ pullup?\n");
> -			return -ENODEV;
> -		}
> -		retval =3D devm_gpio_request(dev, udc->board.pullup_pin,
> -					   "udc_pullup");
> -		if (retval) {
> -			DBG("D+ pullup is busy\n");
> -			return retval;
> -		}
> -		gpio_direction_output(udc->board.pullup_pin,
> -				udc->board.pullup_active_low);
> -	}
> =20
> -	/* newer chips have more FIFO memory than rm9200 */
> -	if (cpu_is_at91sam9260() || cpu_is_at91sam9g20()) {
> -		udc->ep[0].maxpacket =3D 64;
> -		udc->ep[3].maxpacket =3D 64;
> -		udc->ep[4].maxpacket =3D 512;
> -		udc->ep[5].maxpacket =3D 512;
> -	} else if (cpu_is_at91sam9261() || cpu_is_at91sam9g10()) {
> -		udc->ep[3].maxpacket =3D 64;
> -	} else if (cpu_is_at91sam9263()) {
> -		udc->ep[0].maxpacket =3D 64;
> -		udc->ep[3].maxpacket =3D 64;
> -	}
> =20
>  	res =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);
>  	udc->udp_baseaddr =3D devm_ioremap_resource(dev, res);
>  	if (IS_ERR(udc->udp_baseaddr))
>  		return PTR_ERR(udc->udp_baseaddr);
> =20
> +	if (udc->caps && udc->caps->init) {
> +		retval =3D udc->caps->init(udc);
> +		if (retval)
> +			return retval;
> +	}
> +
>  	udc_reinit(udc);
> =20
>  	/* get interface and function clocks */
> @@ -1920,13 +2061,6 @@ static int at91udc_resume(struct platform_device *=
pdev)
>  #define	at91udc_resume	NULL
>  #endif
> =20
> -static const struct of_device_id at91_udc_dt_ids[] =3D {
> -	{ .compatible =3D "atmel,at91rm9200-udc" },
> -	{ /* sentinel */ }
> -};
> -
> -MODULE_DEVICE_TABLE(of, at91_udc_dt_ids);
> -
>  static struct platform_driver at91_udc_driver =3D {
>  	.remove		=3D __exit_p(at91udc_remove),
>  	.shutdown	=3D at91udc_shutdown,
> diff --git a/drivers/usb/gadget/udc/at91_udc.h b/drivers/usb/gadget/udc/a=
t91_udc.h
> index e647d1c2ada4..4fc0daa6587f 100644
> --- a/drivers/usb/gadget/udc/at91_udc.h
> +++ b/drivers/usb/gadget/udc/at91_udc.h
> @@ -107,6 +107,11 @@ struct at91_ep {
>  	unsigned			fifo_bank:1;
>  };
> =20
> +struct at91_udc_caps {
> +	int (*init)(struct at91_udc *udc);
> +	void (*pullup)(struct at91_udc *udc, int is_on);
> +};
> +
>  /*
>   * driver is non-SMP, and just blocks IRQs whenever it needs
>   * access protection for chip registers or driver state
> @@ -115,6 +120,7 @@ struct at91_udc {
>  	struct usb_gadget		gadget;
>  	struct at91_ep			ep[NUM_ENDPOINTS];
>  	struct usb_gadget_driver	*driver;
> +	const struct at91_udc_caps	*caps;
>  	unsigned			vbus:1;
>  	unsigned			enabled:1;
>  	unsigned			clocked:1;
> @@ -134,6 +140,7 @@ struct at91_udc {
>  	spinlock_t			lock;
>  	struct timer_list		vbus_timer;
>  	struct work_struct		vbus_timer_work;
> +	struct regmap			*matrix;
>  };
> =20
>  static inline struct at91_udc *to_udc(struct usb_gadget *g)
> --=20
> 2.1.0
>=20

--=20
balbi

--ibe32dcbQs37CEZO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUtqmeAAoJEIaOsuA1yqRE+3YP/3kW09Pcw8ZqwmJ9ApOkC299
3yTiD8ymTsIjAgs4C0MFL86WMI+9hfTbX5TcKqnCDNLdFxAlC261M0tQiXb2ahQR
e7UYD1icyB2uosTZpC1cnSM+2+I4L7xWm8BTznboxQs40Z6GS/+37V/Dx81gmzo4
SUqtf82WlfukqCoAazEpbbWVvfrmAbWs97ID46oEh27JxPR8OrBHaQM3MmhmwAtR
bLUxwJcwVMaC0D7oTQoKJFf2uLGnh21mAQVtL9Ty4iclIVU7l3cDypbr3rcHkwId
4gQzsl+/jQmZRocyPH1MZMrjxCAEOQo/MJYlWy64UcQuFfXqLRhFRRmtltAxDBQY
6UcftlPwejuuf8oSFY2OoTmMl2Aeud/w58vIqkZ58ONBvgWo5lxp+nrmhR3QI4Sx
47gb7SIz0TRWbCsQHrL4Zw/hnXDdrRoaY1ENryZUnUDTLbE6mrnwunDm1KprVoqe
cXJsxQuJm2wQUZo8VJwMH6sanmO/XQ3pgSuQVa01Xx+eqhNAWNtWGSMfhNJGT1mN
8otglOC9Nl79C/PvoxclfdctY56VKlO6RthdnP2e23lwOgSOod0ZmT6HuamtM48T
qW/HQ5RUAc9/a59aCdtB0sYLN1ArGhrMIoa+cWS1rJC38YmSFvAQpUeW3+I6uZ1X
G2ijijNUPbsMA0w7OdZT
=IjXO
-----END PGP SIGNATURE-----

--ibe32dcbQs37CEZO--
