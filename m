Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752720Ab3LaKQh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Dec 2013 05:16:37 -0500
Received: from mail-bk0-f47.google.com ([209.85.214.47]:42481 "EHLO
	mail-bk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752254Ab3LaKQf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Dec 2013 05:16:35 -0500
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Takashi Iwai <tiwai@suse.de>, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Pavel Machek <pavel@ucw.cz>, Richard Purdie <rpurdie@rpsys.net>
Subject: Re: [PATCH v4] input: Add LED support to Synaptics device
Date: Tue, 31 Dec 2013 11:16:29 +0100
User-Agent: KMail/1.13.7 (Linux/3.11.0-15-generic; KDE/4.12.0; x86_64; ; )
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
References: <s5hy6ggxb91.wl%tiwai@suse.de> <201304202051.13656@pali>
In-Reply-To: <201304202051.13656@pali>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart55543173.RulyKDBUrZ";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201312311116.30062@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart55543173.RulyKDBUrZ
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Saturday 20 April 2013 20:51:13 Pali Roh=C3=A1r wrote:
> On Thursday 22 April 2010 08:16:42 Takashi Iwai wrote:
> > diff --git a/drivers/input/mouse/Kconfig
> > b/drivers/input/mouse/Kconfig index c714ca2..91d3517 100644
> > --- a/drivers/input/mouse/Kconfig
> > +++ b/drivers/input/mouse/Kconfig
> > @@ -19,6 +19,7 @@ config MOUSE_PS2
> >=20
> >  	select SERIO_LIBPS2
> >  	select SERIO_I8042 if X86
> >  	select SERIO_GSCPS2 if GSC
> >=20
> > +	select LEDS_CLASS if MOUSE_PS2_SYNAPICS_LED
> >=20
> >  	help
> >  =09
> >  	  Say Y here if you have a PS/2 mouse connected to your
> >=20
> > system. This includes the standard 2 or 3-button PS/2 mouse,
> > as well as PS/2 @@ -67,6 +68,14 @@ config
> > MOUSE_PS2_SYNAPTICS
> >=20
> >  	  If unsure, say Y.
> >=20
> > +config MOUSE_PS2_SYNAPTICS_LED
> > +	bool "Support embedded LED on Synaptics devices"
> > +	depends on MOUSE_PS2_SYNAPTICS
> > +	select NEW_LEDS
> > +	help
> > +	  Say Y here if you have a Synaptics device with an
> > embedded LED. +	  This will enable LED class driver to
> > control the LED device. +
> >=20
> >  config MOUSE_PS2_LIFEBOOK
> > =20
> >  	bool "Fujitsu Lifebook PS/2 mouse protocol extension" if
> >=20
> > EMBEDDED default y
> > diff --git a/drivers/input/mouse/synaptics.c
> > b/drivers/input/mouse/synaptics.c index c7b5285..8dc1fb5
> > 100644
> > --- a/drivers/input/mouse/synaptics.c
> > +++ b/drivers/input/mouse/synaptics.c
> > @@ -28,6 +28,7 @@
> >=20
> >  #include <linux/input.h>
> >  #include <linux/serio.h>
> >  #include <linux/libps2.h>
> >=20
> > +#include <linux/leds.h>
> >=20
> >  #include <linux/slab.h>
> >  #include "psmouse.h"
> >  #include "synaptics.h"
> >=20
> > @@ -335,6 +336,110 @@ static void synaptics_pt_create(struct
> > psmouse *psmouse) serio_register_port(serio);
> >=20
> >  }
> >=20
> > +#ifdef CONFIG_MOUSE_PS2_SYNAPTICS_LED
> > +/*
> > + * LED handling:
> > + * Some Synaptics devices have an embeded LED at the
> > top-left corner. + */
> > +
> > +struct synaptics_led {
> > +	struct psmouse *psmouse;
> > +	struct work_struct work;
> > +	struct led_classdev cdev;
> > +};
> > +
> > +static void synaptics_set_led(struct psmouse *psmouse, int
> > on) +{
> > +	int i;
> > +	unsigned char cmd =3D on ? 0x88 : 0x10;
> > +
> > +	ps2_begin_command(&psmouse->ps2dev);
> > +	if (__ps2_command(&psmouse->ps2dev, NULL,
> > PSMOUSE_CMD_SETSCALE11)) +		goto out;
> > +	for (i =3D 6; i >=3D 0; i -=3D 2) {
> > +		unsigned char d =3D (cmd >> i) & 3;
> > +		if (__ps2_command(&psmouse->ps2dev, &d,
> > PSMOUSE_CMD_SETRES)) +			goto out;
> > +	}
> > +	cmd =3D 0x0a;
> > +	__ps2_command(&psmouse->ps2dev, &cmd,
> > PSMOUSE_CMD_SETRATE); + out:
> > +	ps2_end_command(&psmouse->ps2dev);
> > +}
> > +
> > +static void synaptics_led_work(struct work_struct *work)
> > +{
> > +	struct synaptics_led *led;
> > +
> > +	led =3D container_of(work, struct synaptics_led, work);
> > +	synaptics_set_led(led->psmouse, led->cdev.brightness);
> > +}
> > +
> > +static void synaptics_led_cdev_brightness_set(struct
> > led_classdev *cdev, +					      enum led_brightness
>=20
> value)
>=20
> > +{
> > +	struct synaptics_led *led;
> > +
> > +	led =3D container_of(cdev, struct synaptics_led, cdev);
> > +	schedule_work(&led->work);
> > +}
> > +
> > +static void synaptics_sync_led(struct psmouse *psmouse)
> > +{
> > +	struct synaptics_data *priv =3D psmouse->private;
> > +
> > +	if (priv->led)
> > +		synaptics_set_led(psmouse, priv->led-
>cdev.brightness);
> > +}
> > +
> > +static int synaptics_init_led(struct psmouse *psmouse)
> > +{
> > +	struct synaptics_data *priv =3D psmouse->private;
> > +	struct synaptics_led *led;
> > +	int err;
> > +
> > +	/* FIXME: LED is supposedly detectable in cap0c[1] 0x20,
> > but it seems +	 * not working on real machines.
> > +	 * So we check the product id to be sure.
> > +	 */
> > +	if (!priv->ext_cap_0c || SYN_CAP_PRODUCT_ID(priv-
>ext_cap)
> > !=3D 0xe4) +		return 0;
> > +
> > +	printk(KERN_INFO "synaptics: support LED control\n");
> > +	led =3D kzalloc(sizeof(struct synaptics_led), GFP_KERNEL);
> > +	if (!led)
> > +		return -ENOMEM;
> > +	led->psmouse =3D psmouse;
> > +	INIT_WORK(&led->work, synaptics_led_work);
> > +	led->cdev.name =3D "psmouse::synaptics";
> > +	led->cdev.brightness_set =3D
> > synaptics_led_cdev_brightness_set; +	led->cdev.flags =3D
> > LED_CORE_SUSPENDRESUME;
> > +	err =3D led_classdev_register(NULL, &led->cdev);
> > +	if (err < 0) {
> > +		kfree(led);
> > +		return err;
> > +	}
> > +	priv->led =3D led;
> > +	return 0;
> > +}
> > +
> > +static void synaptics_free_led(struct psmouse *psmouse)
> > +{
> > +	struct synaptics_data *priv =3D psmouse->private;
> > +
> > +	if (!priv->led)
> > +		return;
> > +	cancel_work_sync(&priv->led->work);
> > +	synaptics_set_led(psmouse, 0);
> > +	led_classdev_unregister(&priv->led->cdev);
> > +	kfree(priv->led);
> > +}
> > +#else
> > +#define synaptics_init_led(ps)	0
> > +#define synaptics_free_led(ps)	do {} while (0)
> > +#define synaptics_sync_led(ps)	do {} while (0)
> > +#endif
> > +
> >=20
> >  /**********************************************************
> >  **
> >=20
> > ***************** *	Functions to interpret the absolute mode
> > packets
> >=20
> > ************************************************************
> > * ***************/ @@ -622,6 +727,7 @@ static void
> > set_input_params(struct input_dev *dev, struct
> > synaptics_data *priv)
> >=20
> >  static void synaptics_disconnect(struct psmouse *psmouse)
> >  {
> >=20
> > +	synaptics_free_led(psmouse);
> >=20
> >  	synaptics_reset(psmouse);
> >  	kfree(psmouse->private);
> >  	psmouse->private =3D NULL;
> >=20
> > @@ -653,6 +759,8 @@ static int synaptics_reconnect(struct
> > psmouse *psmouse) return -1;
> >=20
> >  	}
> >=20
> > +	synaptics_sync_led(psmouse);
> > +
> >=20
> >  	return 0;
> > =20
> >  }
> >=20
> > @@ -727,6 +835,9 @@ int synaptics_init(struct psmouse
> > *psmouse) SYN_ID_MAJOR(priv->identity),
> > SYN_ID_MINOR(priv->identity), priv->model_id,
> > priv->capabilities, priv->ext_cap, priv->ext_cap_0c);
> >=20
> > +	if (synaptics_init_led(psmouse) < 0)
> > +		goto init_fail;
> > +
> >=20
> >  	set_input_params(psmouse->dev, priv);
> >  =09
> >  	/*
> >=20
> > diff --git a/drivers/input/mouse/synaptics.h
> > b/drivers/input/mouse/synaptics.h index ae37c5d..d5bb8f4
> > 100644
> > --- a/drivers/input/mouse/synaptics.h
> > +++ b/drivers/input/mouse/synaptics.h
> > @@ -94,6 +94,8 @@ struct synaptics_hw_state {
> >=20
> >  	signed char scroll;
> > =20
> >  };
> >=20
> > +struct synaptics_led;
> > +
> >=20
> >  struct synaptics_data {
> > =20
> >  	/* Data read from the touchpad */
> >  	unsigned long int model_id;		/* Model-ID */
> >=20
> > @@ -107,6 +109,7 @@ struct synaptics_data {
> >=20
> >  	unsigned char pkt_type;			/* packet type - old, new, etc
>=20
> */
>=20
> >  	unsigned char mode;			/* current mode byte */
> >  	int scroll;
> >=20
> > +	struct synaptics_led *led;
> >=20
> >  };
> > =20
> >  void synaptics_module_init(void);
>=20
> Hello,
>=20
> what happened with this patch? There is no discussion about
> v4: https://patchwork.kernel.org/patch/94026/
> https://lkml.org/lkml/2010/4/22/35
>=20
> Are there any problems with this patch?

BUMP!

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com


--nextPart55543173.RulyKDBUrZ
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlLCmX4ACgkQi/DJPQPkQ1IL8wCgi73hqRaVn3802qKlXG/zHVvF
QKcAn0yxHA96BHHZ39I6u5txY4+lMS25
=W4ep
-----END PGP SIGNATURE-----

--nextPart55543173.RulyKDBUrZ--
