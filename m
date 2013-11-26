Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932464Ab3KZTD6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 14:03:58 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:49078 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753677Ab3KZTDz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 14:03:55 -0500
Date: Tue, 26 Nov 2013 13:03:11 -0600
From: Felipe Balbi <balbi@ti.com>
To: Felipe Balbi <balbi@ti.com>
CC: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Pavel Machek <pavel@ucw.cz>, Aaro Koskinen <aaro.koskinen@iki.fi>,
        <freemangordon@abv.bg>, Sebastian Reichel <sre@ring0.de>
Subject: Re: BUG: usb: obex in g_nokia.ko causing kernel panic
Message-ID: <20131126190311.GC24310@saruman.home>
Reply-To: <balbi@ti.com>
References: <201311191151.17153@pali>
 <201311261828.05990@pali>
 <20131126173953.GQ24310@saruman.home>
 <201311261910.08537@pali>
 <20131126185913.GB24310@saruman.home>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="pd/ueeoza9+75UV5"
Content-Disposition: inline
In-Reply-To: <20131126185913.GB24310@saruman.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--pd/ueeoza9+75UV5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Nov 26, 2013 at 12:59:13PM -0600, Felipe Balbi wrote:
> > > diff --git a/drivers/usb/gadget/f_obex.c
> > > b/drivers/usb/gadget/f_obex.c index ad39f1d..4af2f06 100644
> > > --- a/drivers/usb/gadget/f_obex.c
> > > +++ b/drivers/usb/gadget/f_obex.c
> > > @@ -267,10 +267,12 @@ static void obex_connect(struct gserial
> > > *g) if (!obex->can_activate)
> > >  		return;
> > >=20
> > > +#if 0
> > >  	status =3D usb_function_activate(&g->func);
> > >  	if (status)
> > >  		DBG(cdev, "obex ttyGS%d function activate --> %d\n",
> > >  			obex->port_num, status);
> > > +#endif
> > >  }
> > >=20
> > >  static void obex_disconnect(struct gserial *g)
> > > @@ -282,10 +284,12 @@ static void obex_disconnect(struct
> > > gserial *g) if (!obex->can_activate)
> > >  		return;
> > >=20
> > > +#if 0
> > >  	status =3D usb_function_deactivate(&g->func);
> > >  	if (status)
> > >  		DBG(cdev, "obex ttyGS%d function deactivate --> %d\n",
> > >  			obex->port_num, status);
> > > +#endif
> > >  }
> > >=20
> > >  /*-----------------------------------------------------------
> > > --------------*/ @@ -372,6 +376,7 @@ static int
> > > obex_bind(struct usb_configuration *c, struct usb_function
> > > *f) if (status)
> > >  		goto fail;
> > >=20
> > > +#if 0
> > >  	/* Avoid letting this gadget enumerate until the userspace
> > >  	 * OBEX server is active.
> > >  	 */
> > > @@ -381,6 +386,7 @@ static int obex_bind(struct
> > > usb_configuration *c, struct usb_function *f) obex->port_num,
> > > status);
> > >  	else
> > >  		obex->can_activate =3D true;
> > > +#endif
> > >=20
> > >=20
> > >  	DBG(cdev, "obex ttyGS%d: %s speed IN/%s OUT/%s\n",
> >=20
> > Hi, with above patch g_nokia.ko working and not crashing.
>=20
> yeah, makes sense. We shouldn't call phy operations in atomic context.
> I'll see how easy it would be to fix that. Real patch coming soon(-ish).

I think we could send diff below for the -rc cycle and figure out a
better to handle this for the merge window. Can you check if it also
works with patch below ?

diff --git a/drivers/usb/musb/omap2430.c b/drivers/usb/musb/omap2430.c
index 2a408cd..8aa59a2 100644
--- a/drivers/usb/musb/omap2430.c
+++ b/drivers/usb/musb/omap2430.c
@@ -659,7 +659,6 @@ static int omap2430_runtime_suspend(struct device *dev)
 				OTG_INTERFSEL);
=20
 		omap2430_low_level_exit(musb);
-		phy_power_off(musb->phy);
 	}
=20
 	return 0;
@@ -674,7 +673,6 @@ static int omap2430_runtime_resume(struct device *dev)
 		omap2430_low_level_init(musb);
 		musb_writel(musb->mregs, OTG_INTERFSEL,
 				musb->context.otg_interfsel);
-		phy_power_on(musb->phy);
 	}
=20
 	return 0;

--=20
balbi

--pd/ueeoza9+75UV5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJSlPBvAAoJEIaOsuA1yqRExeoP/2CP1O8tF2xNHgoCB+KOnoW2
DuSPR0kOPD02YRvZ+mAVVZGxUzqjkoBCi4w4OIDc5BAkXT1ePcAbuRmDaN5lzPOt
9WMHavmLxE20KL0Q870Jwr+Cwv1TJTcC9aFbRgrLXd2aTSN2OGtBULiqPYXKhk76
3VoG+8Uqg5dgS+cC+vOCsEjrJCDtAcmFz7YU1XNBVKbrvvQV1pLXHp3/ZLQ/roLX
ycZ4N/9z2HNM4Mp9NkHKcHysn6gngQfTW5pSkjUmkiRLPtLBk3jM/0arzQN5Q7w6
KJ3Flx1nJIRDuoSbTSgGyQqKA06RBagyK6q3sRtWzPw3vZxMA4wi9zvmzJw3V7DQ
/FibgnddnCzd8z98+cpaEJoNqCTHZRN1HQ3XpGPCd/s99NY+Se9+PBuFMTEB9IJM
UuB7pUcDOi1nXNpoG8tMDjLi82mSqtDPcq3XnAkWfwmC+MJ4hBRjog56b+Jz8mHL
JenhtlbPDBue+ukWCbj9vMaZc2OHh8MFHhf9RWSNGbZzDqqqPWBFPbQZ9kO/9hGi
bIlPut2vBpdPMZxJ2buzMMx33/f/B54AOsZU0mNRbHS7xGHX7VHT/895XgodzER8
rYyNCdFxSMglpIQmNbut9jpw5pJ2Wf7ZnUVchVie6UOLiYp0kqBZLEN4IhsVBs9M
rO9wStqq/nM2ZMYKn9Fz
=tYP+
-----END PGP SIGNATURE-----

--pd/ueeoza9+75UV5--
