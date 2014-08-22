Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752211AbaHVV7x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 17:59:53 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:34212 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752000AbaHVV7v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 17:59:51 -0400
Date: Fri, 22 Aug 2014 16:59:24 -0500
From: Felipe Balbi <balbi@ti.com>
To: Michal Sojka <sojka@merica.cz>
CC: <linux-leds@vger.kernel.org>, <michal.vokac@comap.cz>,
        Bryan Wu <cooloney@gmail.com>, Richard Purdie <rpurdie@rpsys.net>,
        Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>
Subject: Re: [PATCH 1/2] leds: usb: Add LED trigger for USB gadget activity
Message-ID: <20140822215924.GB19838@saruman.home>
Reply-To: <balbi@ti.com>
References: <1408708399-20423-1-git-send-email-sojka@merica.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="1LKvkjL3sHcu1TtY"
Content-Disposition: inline
In-Reply-To: <1408708399-20423-1-git-send-email-sojka@merica.cz>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--1LKvkjL3sHcu1TtY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Aug 22, 2014 at 01:53:12PM +0200, Michal Sojka wrote:
> With this patch, USB gadget activity can be signaled by blinking a LED.
>=20
> Since there is no generic code where to put the trigger for all USB
> controllers, each USB controller needs to call the trigger individually.
> This patch adds the call only for the musb controller where I can test
> it.
>=20
> Signed-off-by: Michal Sojka <sojka@merica.cz>
> ---
>  drivers/leds/trigger/Kconfig             |  8 ++++++
>  drivers/leds/trigger/Makefile            |  1 +
>  drivers/leds/trigger/ledtrig-usbgadget.c | 45 ++++++++++++++++++++++++++=
++++++
>  drivers/usb/musb/musb_gadget.c           |  6 +++--
>  include/linux/leds.h                     |  6 +++++
>  5 files changed, 64 insertions(+), 2 deletions(-)
>  create mode 100644 drivers/leds/trigger/ledtrig-usbgadget.c
>=20
> diff --git a/drivers/leds/trigger/Kconfig b/drivers/leds/trigger/Kconfig
> index 49794b4..9562963 100644
> --- a/drivers/leds/trigger/Kconfig
> +++ b/drivers/leds/trigger/Kconfig
> @@ -41,6 +41,14 @@ config LEDS_TRIGGER_IDE_DISK
>  	  This allows LEDs to be controlled by IDE disk activity.
>  	  If unsure, say Y.
> =20
> +config LEDS_TRIGGER_USBGADGET
> +	bool "LED USB Gadget Trigger"
> +	depends on (USB_MUSB_GADGET || USB_MUSB_DUAL_ROLE)
> +	depends on LEDS_TRIGGERS
> +	help
> +	  This allows LEDs to be controlled by USB gadget activity.
> +	  If unsure, say Y.
> +
>  config LEDS_TRIGGER_HEARTBEAT
>  	tristate "LED Heartbeat Trigger"
>  	depends on LEDS_TRIGGERS
> diff --git a/drivers/leds/trigger/Makefile b/drivers/leds/trigger/Makefile
> index 1abf48d..45917c0 100644
> --- a/drivers/leds/trigger/Makefile
> +++ b/drivers/leds/trigger/Makefile
> @@ -8,3 +8,4 @@ obj-$(CONFIG_LEDS_TRIGGER_CPU)		+=3D ledtrig-cpu.o
>  obj-$(CONFIG_LEDS_TRIGGER_DEFAULT_ON)	+=3D ledtrig-default-on.o
>  obj-$(CONFIG_LEDS_TRIGGER_TRANSIENT)	+=3D ledtrig-transient.o
>  obj-$(CONFIG_LEDS_TRIGGER_CAMERA)	+=3D ledtrig-camera.o
> +obj-$(CONFIG_LEDS_TRIGGER_USBGADGET)	+=3D ledtrig-usbgadget.o
> diff --git a/drivers/leds/trigger/ledtrig-usbgadget.c b/drivers/leds/trig=
ger/ledtrig-usbgadget.c
> new file mode 100644
> index 0000000..1eb90da
> --- /dev/null
> +++ b/drivers/leds/trigger/ledtrig-usbgadget.c
> @@ -0,0 +1,45 @@
> +/*
> + * LED Trigger for USB Gadget Activity
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
> +
> +#define BLINK_DELAY 30
> +
> +DEFINE_LED_TRIGGER(ledtrig_usbgadget);
> +static unsigned long usbgadget_blink_delay =3D BLINK_DELAY;
> +
> +void ledtrig_usbgadget_activity(void)
> +{
> +	led_trigger_blink_oneshot(ledtrig_usbgadget,
> +				  &usbgadget_blink_delay, &usbgadget_blink_delay, 0);
> +}
> +EXPORT_SYMBOL(ledtrig_usbgadget_activity);
> +
> +static int __init ledtrig_usbgadget_init(void)
> +{
> +	led_trigger_register_simple("usb-gadget", &ledtrig_usbgadget);
> +	return 0;
> +}
> +
> +static void __exit ledtrig_usbgadget_exit(void)
> +{
> +	led_trigger_unregister_simple(ledtrig_usbgadget);
> +}
> +
> +module_init(ledtrig_usbgadget_init);
> +module_exit(ledtrig_usbgadget_exit);
> +
> +MODULE_AUTHOR("Michal Sojka <sojka@merica.cz>");
> +MODULE_DESCRIPTION("LED Trigger for USB Gadget Activity");
> +MODULE_LICENSE("GPL");
> diff --git a/drivers/usb/musb/musb_gadget.c b/drivers/usb/musb/musb_gadge=
t.c
> index d4aa779..98f8b24 100644
> --- a/drivers/usb/musb/musb_gadget.c
> +++ b/drivers/usb/musb/musb_gadget.c
> @@ -42,6 +42,7 @@
>  #include <linux/delay.h>
>  #include <linux/dma-mapping.h>
>  #include <linux/slab.h>
> +#include <linux/leds.h>
> =20
>  #include "musb_core.h"
> =20
> @@ -167,11 +168,12 @@ __acquires(ep->musb->lock)
>  	if (!dma_mapping_error(&musb->g.dev, request->dma))
>  		unmap_dma_buffer(req, musb);
> =20
> -	if (request->status =3D=3D 0)
> +	if (request->status =3D=3D 0) {
>  		dev_dbg(musb->controller, "%s done request %p,  %d/%d\n",
>  				ep->end_point.name, request,
>  				req->request.actual, req->request.length);
> -	else
> +		ledtrig_usbgadget_activity();

looks like this should, somehow, be done at udc-core.c although you'd
need some refactoring to make that happen. It shouldn't be too difficult
to have a generic usb_gadget_giveback_request()

cheers

--=20
balbi

--1LKvkjL3sHcu1TtY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJT9708AAoJEIaOsuA1yqREPd0P/3OkR5ysdQMva73RvxrvSrzv
3YLSUK9JN+EXGUmIU6CdXYZPWstZYOLgWiX7QZ32eh+ODi3cChJhhBZqKJOUgzx6
XuF4SnU6BJi7aRtLsSYuEKBTyqShP2nIYf5qKdujCawZGmV0RBXzrTQTqKdHyfPO
94InuXtLrWBJBa9oNxd7mmWvsEPxaQplb20EOeT0a81tae6BgT2BlZWRn30e5LW8
M9J88LDE/7MKgWF09Xye+cJ+bMBccURNHN3Gel6ExMEga8vcb1arl4ol3t9V/el/
ULQw/cbDRb1npi08ON5hI1LtOL3t6s5QyY/bfbAfBebNzh/zHn+RkPTbJkbZXaDH
wbdto9tHd7NVwrdokEdZOaiRGsvBOCIGlDMDpLDD8usqkAV2PRbaBGN1EoV2ECQR
LkKMik9wU2qBnlyr9Y9XUNKiMfnzX4k+UpWxnSsnQccHpxkkVQt8mJ7ykdQAPWFz
xx5UDixlgDbb3I/GDKmQhjqTbS06qTvcSViiTEL0sS02WOkodg5Ba9hB5qarKHSF
udWuAFr6BbtpRSTP3gL2QXcUwUC0ecbbz2AhvKKbvUJThyAHPo9C5AMlxRYHy1Yx
HXbsMRmTuPDuIneAS7Rw/ruGPeMLRNmoaST1Seoos2/mMXT5iC85ViExyYkL7ovc
FyuzKKmKTWtF3QfDlYud
=d+kJ
-----END PGP SIGNATURE-----

--1LKvkjL3sHcu1TtY--
