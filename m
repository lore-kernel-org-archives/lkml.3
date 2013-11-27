Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757016Ab3K0RkR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 12:40:17 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:46698 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751875Ab3K0RkN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 12:40:13 -0500
Date: Wed, 27 Nov 2013 11:39:04 -0600
From: Felipe Balbi <balbi@ti.com>
To: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
CC: <balbi@ti.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Pavel Machek <pavel@ucw.cz>, Aaro Koskinen <aaro.koskinen@iki.fi>,
        <freemangordon@abv.bg>, Sebastian Reichel <sre@ring0.de>
Subject: Re: BUG: usb: obex in g_nokia.ko causing kernel panic
Message-ID: <20131127173904.GD8123@saruman.home>
Reply-To: <balbi@ti.com>
References: <201311191151.17153@pali>
 <20131126185913.GB24310@saruman.home>
 <20131126190311.GC24310@saruman.home>
 <201311271740.42913@pali>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="d9ADC0YsG2v16Js0"
Content-Disposition: inline
In-Reply-To: <201311271740.42913@pali>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--d9ADC0YsG2v16Js0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Nov 27, 2013 at 05:40:42PM +0100, Pali Roh=E1r wrote:
> > > > > @@ -282,10 +284,12 @@ static void obex_disconnect(struct
> > > > > gserial *g) if (!obex->can_activate)
> > > > >=20
> > > > >  		return;
> > > > >=20
> > > > > +#if 0
> > > > >=20
> > > > >  	status =3D usb_function_deactivate(&g->func);
> > > > >  	if (status)
> > > > >  =09
> > > > >  		DBG(cdev, "obex ttyGS%d function deactivate -->
> > > > >  		%d\n",
> > > > >  	=09
> > > > >  			obex->port_num, status);
> > > > >=20
> > > > > +#endif
> > > > >=20
> > > > >  }
> > > > > =20
> > > > >  /*-----------------------------------------------------
> > > > >  ------
> > > > >=20
> > > > > --------------*/ @@ -372,6 +376,7 @@ static int
> > > > > obex_bind(struct usb_configuration *c, struct
> > > > > usb_function *f) if (status)
> > > > >=20
> > > > >  		goto fail;
> > > > >=20
> > > > > +#if 0
> > > > >=20
> > > > >  	/* Avoid letting this gadget enumerate until the
> > > > >  	userspace
> > > > >  =09
> > > > >  	 * OBEX server is active.
> > > > >  	 */
> > > > >=20
> > > > > @@ -381,6 +386,7 @@ static int obex_bind(struct
> > > > > usb_configuration *c, struct usb_function *f)
> > > > > obex->port_num, status);
> > > > >=20
> > > > >  	else
> > > > >  =09
> > > > >  		obex->can_activate =3D true;
> > > > >=20
> > > > > +#endif
> > > > >=20
> > > > >  	DBG(cdev, "obex ttyGS%d: %s speed IN/%s OUT/%s\n",
> > > >=20
> > > > Hi, with above patch g_nokia.ko working and not crashing.
> > >=20
> > > yeah, makes sense. We shouldn't call phy operations in
> > > atomic context. I'll see how easy it would be to fix that.
> > > Real patch coming soon(-ish).
> >=20
> > I think we could send diff below for the -rc cycle and figure
> > out a better to handle this for the merge window. Can you
> > check if it also works with patch below ?
> >=20
> > diff --git a/drivers/usb/musb/omap2430.c
> > b/drivers/usb/musb/omap2430.c index 2a408cd..8aa59a2 100644
> > --- a/drivers/usb/musb/omap2430.c
> > +++ b/drivers/usb/musb/omap2430.c
> > @@ -659,7 +659,6 @@ static int omap2430_runtime_suspend(struct
> > device *dev) OTG_INTERFSEL);
> >=20
> >  		omap2430_low_level_exit(musb);
> > -		phy_power_off(musb->phy);
> >  	}
> >=20
> >  	return 0;
> > @@ -674,7 +673,6 @@ static int omap2430_runtime_resume(struct
> > device *dev) omap2430_low_level_init(musb);
> >  		musb_writel(musb->mregs, OTG_INTERFSEL,
> >  				musb->context.otg_interfsel);
> > -		phy_power_on(musb->phy);
> >  	}
> >=20
> >  	return 0;
>=20
> Hi, I applied similar patch (commented usb_phy_set_suspend=20
> instead phy_power_on/off) on 3.12-rc5 and it working too, no=20
> crash. I do not have rebased n900 patches on top of 3.13 tree, so=20
> I cannot check it. But I think phy_power_on/off doing same as=20
> usb_phy_set_suspend in 3.12.

cool, I'll send this during the -rc and Cc stable, then I'll manually
backport it to stable later.

--=20
balbi

--d9ADC0YsG2v16Js0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJSli44AAoJEIaOsuA1yqRE6DkQAJ4DlGooQejCQK9tjzeZGAgu
uAOJ0jsuo0Wb8mCdnJP7BnRIUnxBbMdspwfKWysdCi92GzX1/JDs851xu4HjJq6Y
rNd+peIqWliHEh8p9ga3T5BHZBzCKN4Ta4gpuCHLxLHuuJemU2gm+5T/edCRdXcq
i/M3tGDTa9Q+boCBnI/1kwA8oxlijQbID6HfIcHcT2sIVkNxu9Cdp/0w1YFaW0R6
v1LpZ2X8K8i5sLLwt26a1zPheQhHwo+eqx+B426PEtcUNqs1rDULJSJFfXXyG1yM
RBZU0sLj/he7s9/7/XoPdDh5RG25cWdxNSs7ynmoTzZichoUFEAtrz793e3lDU5B
cm0cwJ3tUud3Ye9yzqvNCc+1PdLTrkGPt51LntC/DhlGeUVevMODq9YaV8CpfXvw
re/px1H7pTzD7k4NTNmoSzYwdrnLOLLKs4OFeeZu9vcr8eBhCEZIUqmDxYgL7rt3
sRG6aG6qRcjIK0k2esfNwGMWG1J+GIK/g9DkfJ492AXBJomUTS21iYaA+fWdtC/k
nsS0HUvwwuxjVY/dfh5rxtKp3q5K2p8QXRq8w6nDZdX7MbkxtXQAsnwWfZ/rU5ZG
5T1qYo4duRwGL3mrgH/hd8mkDbLRwTxV0/iGzni8aruK/LAoESjqRV+y4rP0K5By
OrRx6lVp9dNC/3+RhCbk
=HHmr
-----END PGP SIGNATURE-----

--d9ADC0YsG2v16Js0--
