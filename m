Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752738AbaIXU4h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 16:56:37 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:50663 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750767AbaIXU4f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 16:56:35 -0400
Date: Wed, 24 Sep 2014 15:56:27 -0500
From: Felipe Balbi <balbi@ti.com>
To: Michal Sojka <sojka@merica.cz>
CC: <linux-usb@vger.kernel.org>, Alan Stern <stern@rowland.harvard.edu>,
        Bryan Wu <cooloney@gmail.com>, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux LED Subsystem <linux-leds@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <michal.vokac@comap.cz>
Subject: Re: [PATCH v6 4/4] usb: Add LED triggers for USB activity
Message-ID: <20140924205627.GB17997@saruman>
Reply-To: <balbi@ti.com>
References: <Pine.LNX.4.44L0.1409241106100.1580-100000@iolanthe.rowland.org>
 <1411591401-5874-1-git-send-email-sojka@merica.cz>
 <1411591401-5874-5-git-send-email-sojka@merica.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="alCHniwhwUTljuKz"
Content-Disposition: inline
In-Reply-To: <1411591401-5874-5-git-send-email-sojka@merica.cz>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--alCHniwhwUTljuKz
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Sep 24, 2014 at 10:43:21PM +0200, Michal Sojka wrote:
> With this patch, USB activity can be signaled by blinking a LED. There
> are two triggers, one for activity on USB host and one for USB gadget.
>=20
> Both triggers should work with all host/device controllers. Tested only
> with musb.
>=20
> Performace: I measured performance overheads on ARM Cortex-A8 (TI
> AM335x) running on 600 MHz.
>=20
> Duration of usb_led_activity():
> - with no LED attached to the trigger:        2 =B1 1 =B5s
> - with one GPIO LED attached to the trigger:  2 =B1 1 =B5s or 8 =B1 2 =B5=
s (two peaks in histogram)
>=20
> Duration of functions calling usb_led_activity() (with this patch
> applied and no LED attached to the trigger):
> - __usb_hcd_giveback_urb():    10 - 25 =B5s
> - usb_gadget_giveback_request(): 2 - 6 =B5s
>
> Signed-off-by: Michal Sojka <sojka@merica.cz>
> ---
>  drivers/usb/Kconfig               | 10 +++++++
>  drivers/usb/common/Makefile       |  1 +
>  drivers/usb/common/led.c          | 57 +++++++++++++++++++++++++++++++++=
++++++
>  drivers/usb/core/hcd.c            |  2 ++
>  drivers/usb/gadget/udc/udc-core.c |  4 +++
>  include/linux/usb.h               | 12 +++++++++
>  6 files changed, 86 insertions(+)
>  create mode 100644 drivers/usb/common/led.c
>=20
> diff --git a/drivers/usb/Kconfig b/drivers/usb/Kconfig
> index cf1b19b..ae481c3 100644
> --- a/drivers/usb/Kconfig
> +++ b/drivers/usb/Kconfig
> @@ -149,4 +149,14 @@ source "drivers/usb/phy/Kconfig"
> =20
>  source "drivers/usb/gadget/Kconfig"
> =20
> +config USB_LED_TRIG
> +	bool "USB LED Triggers"
> +	depends on LEDS_CLASS && USB_COMMON && LEDS_TRIGGERS
> +	help
> +	  This option adds LED triggers for USB host and/or gadget activity.
> +
> +	  Say Y here if you are working on a system with led-class supported
> +	  LEDs and you want to use them as activity indicators for USB host or
> +	  gadget.
> +
>  endif # USB_SUPPORT
> diff --git a/drivers/usb/common/Makefile b/drivers/usb/common/Makefile
> index 052c120..ca2f8bd 100644
> --- a/drivers/usb/common/Makefile
> +++ b/drivers/usb/common/Makefile
> @@ -4,5 +4,6 @@
> =20
>  obj-$(CONFIG_USB_COMMON)	  +=3D usb-common.o
>  usb-common-y			  +=3D common.o
> +usb-common-$(CONFIG_USB_LED_TRIG) +=3D led.o
> =20
>  obj-$(CONFIG_USB_OTG_FSM) +=3D usb-otg-fsm.o
> diff --git a/drivers/usb/common/led.c b/drivers/usb/common/led.c
> new file mode 100644
> index 0000000..df23da0
> --- /dev/null
> +++ b/drivers/usb/common/led.c
> @@ -0,0 +1,57 @@
> +/*
> + * LED Triggers for USB Activity
> + *
> + * Copyright 2014 Michal Sojka <sojka@merica.cz>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + */
> +
> +#include <linux/module.h>
> +#include <linux/kernel.h>
> +#include <linux/init.h>
> +#include <linux/leds.h>
> +#include <linux/usb.h>
> +
> +#define BLINK_DELAY 30
> +
> +static unsigned long usb_blink_delay =3D BLINK_DELAY;
> +
> +DEFINE_LED_TRIGGER(ledtrig_usb_gadget);
> +DEFINE_LED_TRIGGER(ledtrig_usb_host);
> +
> +void usb_led_activity(enum usb_led_event ev)
> +{
> +	struct led_trigger *trig =3D NULL;
> +
> +	switch (ev) {
> +	case USB_LED_EVENT_GADGET:
> +		trig =3D ledtrig_usb_gadget;
> +		break;
> +	case USB_LED_EVENT_HOST:
> +		trig =3D ledtrig_usb_host;
> +		break;
> +	}
> +	/* led_trigger_blink_oneshot() handles trig =3D=3D NULL gracefully */
> +	led_trigger_blink_oneshot(trig, &usb_blink_delay, &usb_blink_delay, 0);
> +}
> +EXPORT_SYMBOL_GPL(usb_led_activity);
> +
> +

minor nit: one blank line only. other than that, this looks pretty good
to me:

Acked-by: Felipe Balbi <balbi@ti.com>

--=20
balbi

--alCHniwhwUTljuKz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUIy/7AAoJEIaOsuA1yqRE3loP/2n1Hh4OxgIPaa8oijQl90Nc
cKoM15pv4TCEPcYYY7qJYGveQXQ33kNUgG3LaQBeHKsQykOJdlIrGk/BzgpPS8pV
DWyU5k4no617Du0Q5cYvO54LO+xWjKIAiqbuWwh8npbLrwSqbjjcX7BnjOpY3TW8
89nL+VSYRSS5pJQGA3b1+MDFzTO/piwH5kJTdV6Xaufbz0K6BTbJgScMuDinku5r
LUAi7sAzbQ+9op1nldclqLRl27hU5rsYBloan5UXcV4eGhWYQ21iV3GHJpLoN8BL
b5NaCLY7g6ZT3eislRc6WmalkLJKjKcZvbVV2Q4gCaCbagFTpBXNDBndNOEaiPbn
2+LSIKOK1UQkZqJI4LcnkO+K0k7pn17OOWUPRAsfHewYBkusS6OHlih1hj/jRwTd
9q9PZtsEdqJlB2+D948K6tNFgwcxQJzLZPg6aaz88/gfyzuqyOunJ3XVga3rcUYC
Av4mbN3MvEZ7dTwbCPPbN0aO+8yFDK7OzfuBK6Jo9FUz33aU4009OvpmSq4A04I2
UtPZ/sp6tWhR1LeybxDjwgKwZPx46PxHyI3olK7w+WI0cPkSD917JmwKRPSmZYJO
uXv0pFPIxgYhBeZklpGH//aVNu9Yfdc8Y1xReMmEKBiyCOj0eC5smsARPRD1/N+o
8Gfxpt0Cq6zYZP6Hit3q
=/NN5
-----END PGP SIGNATURE-----

--alCHniwhwUTljuKz--
