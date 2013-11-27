Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757500Ab3K0Qkt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 11:40:49 -0500
Received: from mail-bk0-f49.google.com ([209.85.214.49]:36140 "EHLO
	mail-bk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754103Ab3K0Qkq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 11:40:46 -0500
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: balbi@ti.com
Subject: Re: BUG: usb: obex in g_nokia.ko causing kernel panic
Date: Wed, 27 Nov 2013 17:40:42 +0100
User-Agent: KMail/1.13.7 (Linux/3.11.0-14-generic; KDE/4.11.3; x86_64; ; )
Cc: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pavel Machek <pavel@ucw.cz>, Aaro Koskinen <aaro.koskinen@iki.fi>,
        freemangordon@abv.bg, Sebastian Reichel <sre@ring0.de>
References: <201311191151.17153@pali> <20131126185913.GB24310@saruman.home> <20131126190311.GC24310@saruman.home>
In-Reply-To: <20131126190311.GC24310@saruman.home>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1965930.xO3oUrSQps";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201311271740.42913@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1965930.xO3oUrSQps
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Tuesday 26 November 2013 20:03:11 Felipe Balbi wrote:
> Hi,
>=20
> On Tue, Nov 26, 2013 at 12:59:13PM -0600, Felipe Balbi wrote:
> > > > diff --git a/drivers/usb/gadget/f_obex.c
> > > > b/drivers/usb/gadget/f_obex.c index ad39f1d..4af2f06
> > > > 100644 --- a/drivers/usb/gadget/f_obex.c
> > > > +++ b/drivers/usb/gadget/f_obex.c
> > > > @@ -267,10 +267,12 @@ static void obex_connect(struct
> > > > gserial *g) if (!obex->can_activate)
> > > >=20
> > > >  		return;
> > > >=20
> > > > +#if 0
> > > >=20
> > > >  	status =3D usb_function_activate(&g->func);
> > > >  	if (status)
> > > >  =09
> > > >  		DBG(cdev, "obex ttyGS%d function activate --> %d\n",
> > > >  	=09
> > > >  			obex->port_num, status);
> > > >=20
> > > > +#endif
> > > >=20
> > > >  }
> > > > =20
> > > >  static void obex_disconnect(struct gserial *g)
> > > >=20
> > > > @@ -282,10 +284,12 @@ static void obex_disconnect(struct
> > > > gserial *g) if (!obex->can_activate)
> > > >=20
> > > >  		return;
> > > >=20
> > > > +#if 0
> > > >=20
> > > >  	status =3D usb_function_deactivate(&g->func);
> > > >  	if (status)
> > > >  =09
> > > >  		DBG(cdev, "obex ttyGS%d function deactivate -->
> > > >  		%d\n",
> > > >  	=09
> > > >  			obex->port_num, status);
> > > >=20
> > > > +#endif
> > > >=20
> > > >  }
> > > > =20
> > > >  /*-----------------------------------------------------
> > > >  ------
> > > >=20
> > > > --------------*/ @@ -372,6 +376,7 @@ static int
> > > > obex_bind(struct usb_configuration *c, struct
> > > > usb_function *f) if (status)
> > > >=20
> > > >  		goto fail;
> > > >=20
> > > > +#if 0
> > > >=20
> > > >  	/* Avoid letting this gadget enumerate until the
> > > >  	userspace
> > > >  =09
> > > >  	 * OBEX server is active.
> > > >  	 */
> > > >=20
> > > > @@ -381,6 +386,7 @@ static int obex_bind(struct
> > > > usb_configuration *c, struct usb_function *f)
> > > > obex->port_num, status);
> > > >=20
> > > >  	else
> > > >  =09
> > > >  		obex->can_activate =3D true;
> > > >=20
> > > > +#endif
> > > >=20
> > > >  	DBG(cdev, "obex ttyGS%d: %s speed IN/%s OUT/%s\n",
> > >=20
> > > Hi, with above patch g_nokia.ko working and not crashing.
> >=20
> > yeah, makes sense. We shouldn't call phy operations in
> > atomic context. I'll see how easy it would be to fix that.
> > Real patch coming soon(-ish).
>=20
> I think we could send diff below for the -rc cycle and figure
> out a better to handle this for the merge window. Can you
> check if it also works with patch below ?
>=20
> diff --git a/drivers/usb/musb/omap2430.c
> b/drivers/usb/musb/omap2430.c index 2a408cd..8aa59a2 100644
> --- a/drivers/usb/musb/omap2430.c
> +++ b/drivers/usb/musb/omap2430.c
> @@ -659,7 +659,6 @@ static int omap2430_runtime_suspend(struct
> device *dev) OTG_INTERFSEL);
>=20
>  		omap2430_low_level_exit(musb);
> -		phy_power_off(musb->phy);
>  	}
>=20
>  	return 0;
> @@ -674,7 +673,6 @@ static int omap2430_runtime_resume(struct
> device *dev) omap2430_low_level_init(musb);
>  		musb_writel(musb->mregs, OTG_INTERFSEL,
>  				musb->context.otg_interfsel);
> -		phy_power_on(musb->phy);
>  	}
>=20
>  	return 0;

Hi, I applied similar patch (commented usb_phy_set_suspend=20
instead phy_power_on/off) on 3.12-rc5 and it working too, no=20
crash. I do not have rebased n900 patches on top of 3.13 tree, so=20
I cannot check it. But I think phy_power_on/off doing same as=20
usb_phy_set_suspend in 3.12.

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart1965930.xO3oUrSQps
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlKWIIoACgkQi/DJPQPkQ1KjmACfeHp0B7IxT7dG9fKFhriBUrgE
0q0AoJ7lIb4nrMvxAKLbuggszv92vZgW
=ai5z
-----END PGP SIGNATURE-----

--nextPart1965930.xO3oUrSQps--
