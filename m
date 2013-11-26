Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757643Ab3KZTAH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 14:00:07 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:52796 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757660Ab3KZTAA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 14:00:00 -0500
Date: Tue, 26 Nov 2013 12:59:13 -0600
From: Felipe Balbi <balbi@ti.com>
To: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
CC: <balbi@ti.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Pavel Machek <pavel@ucw.cz>, Aaro Koskinen <aaro.koskinen@iki.fi>,
        <freemangordon@abv.bg>, Sebastian Reichel <sre@ring0.de>
Subject: Re: BUG: usb: obex in g_nokia.ko causing kernel panic
Message-ID: <20131126185913.GB24310@saruman.home>
Reply-To: <balbi@ti.com>
References: <201311191151.17153@pali>
 <201311261828.05990@pali>
 <20131126173953.GQ24310@saruman.home>
 <201311261910.08537@pali>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ozkSYTWEkbLDijvq"
Content-Disposition: inline
In-Reply-To: <201311261910.08537@pali>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--ozkSYTWEkbLDijvq
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Nov 26, 2013 at 07:10:08PM +0100, Pali Roh=E1r wrote:
> > > > > (above dump is from 3.12-rc5 kernel)
> > > >=20
> > > > looks like it's trying to do i2c transfers from atomic.
> > > > But why only when obex is enabled ? Makes no sense. What
> > > > do you have on userland ? Is there anything trying to
> > > > access the obex interface ? Was the USB cable attached at
> > > > that time ?
> > >=20
> > > Yes, only when initliaizing obex. Other is ok. Problem is
> > > there with Maemo userland and also with clean userland
> > > (rescueOS) where is only busybox and some simple init
> > > scripts. On Maemo maybe something is trying to access obex,
> > > but on rescueOS for sure nothing. Problem happends when
> > > cable is attached and also when not =3D always.
> >=20
> > As a debug effort, can you apply hack below and see if it
> > "helps" ?
> >=20
> > diff --git a/drivers/usb/gadget/f_obex.c
> > b/drivers/usb/gadget/f_obex.c index ad39f1d..4af2f06 100644
> > --- a/drivers/usb/gadget/f_obex.c
> > +++ b/drivers/usb/gadget/f_obex.c
> > @@ -267,10 +267,12 @@ static void obex_connect(struct gserial
> > *g) if (!obex->can_activate)
> >  		return;
> >=20
> > +#if 0
> >  	status =3D usb_function_activate(&g->func);
> >  	if (status)
> >  		DBG(cdev, "obex ttyGS%d function activate --> %d\n",
> >  			obex->port_num, status);
> > +#endif
> >  }
> >=20
> >  static void obex_disconnect(struct gserial *g)
> > @@ -282,10 +284,12 @@ static void obex_disconnect(struct
> > gserial *g) if (!obex->can_activate)
> >  		return;
> >=20
> > +#if 0
> >  	status =3D usb_function_deactivate(&g->func);
> >  	if (status)
> >  		DBG(cdev, "obex ttyGS%d function deactivate --> %d\n",
> >  			obex->port_num, status);
> > +#endif
> >  }
> >=20
> >  /*-----------------------------------------------------------
> > --------------*/ @@ -372,6 +376,7 @@ static int
> > obex_bind(struct usb_configuration *c, struct usb_function
> > *f) if (status)
> >  		goto fail;
> >=20
> > +#if 0
> >  	/* Avoid letting this gadget enumerate until the userspace
> >  	 * OBEX server is active.
> >  	 */
> > @@ -381,6 +386,7 @@ static int obex_bind(struct
> > usb_configuration *c, struct usb_function *f) obex->port_num,
> > status);
> >  	else
> >  		obex->can_activate =3D true;
> > +#endif
> >=20
> >=20
> >  	DBG(cdev, "obex ttyGS%d: %s speed IN/%s OUT/%s\n",
>=20
> Hi, with above patch g_nokia.ko working and not crashing.

yeah, makes sense. We shouldn't call phy operations in atomic context.
I'll see how easy it would be to fix that. Real patch coming soon(-ish).

--=20
balbi

--ozkSYTWEkbLDijvq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJSlO+BAAoJEIaOsuA1yqREnuoP/RaK/+kZ8L8ZF34aBd0cHpFu
xQ54ZCTytSCH2jBjvcrAFXVZigBmXeiDXWL8ZT5OSEVkEgqqxqfIp15y3qLwGAV7
yihEWd/WEaeTEnsJ2Lnl6CvyeqXFaije37ibzrsRPE0QuPs/W/NWudAFES4LOdSI
ru3t4RIyJjaqeG86+bVVLbMRUZrr6n4HLXiNaTbIgcyIb4qyDlADrITRs8w8qLvt
+oqF/Fvd1a/m2DSdtyZKvOhARc5aqZhiTx+NOsypk7P8NrEZoRkhb1MnP0RgFxlf
3PB/7eWbSUsexKDd6DkjVUPndTcK2WdhsnLld02Fl+RdvjEGzWocyrmuyDLZKIs5
GuRajrkNh5VkHGMV+cke3PUHlAQUnwcXdwx3bXgIk0aP5DoKa3UV99IbpX1UdPUi
n2YT5DvgYl7sF12dc/fvHSLgcUArqXeWn3f74Nv2irSxrfu0UczZGC1zLeONH+8x
2m31IkXlSnNhQMfYHSHucF2EitiFQutV2O/z2BvgZKPV/iKAvfACQt9KJBdjkKJu
Hek9/J1z3AhxWRTQq97bFpybbOeQJEdzBlSpxRF5tAxoHC/KVuxyNgISKvW+sQA8
roYBjRgCKcJvZXuoXc0k4VOeZAPs9Ai22bwOGMrieohDzO3m7+VFAUSTTIqMgSNY
fBAlA3BALaGnJqTpRv39
=p/gD
-----END PGP SIGNATURE-----

--ozkSYTWEkbLDijvq--
