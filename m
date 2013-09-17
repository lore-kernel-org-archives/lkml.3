Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753105Ab3IQQKl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 12:10:41 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:45201 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752689Ab3IQQKj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 12:10:39 -0400
Date: Tue, 17 Sep 2013 11:08:35 -0500
From: Felipe Balbi <balbi@ti.com>
To: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
CC: <balbi@ti.com>, Tony Lindgren <tony@atomide.com>,
        Anton Vorontsov <anton@enomsg.org>,
        Russell King <linux@arm.linux.org.uk>,
        David Woodhouse <dwmw2@infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        <freemangordon@abv.bg>, <aaro.koskinen@iki.fi>, <pavel@ucw.cz>
Subject: Re: [PATCH 1/4] usb: musb: Call atomic_notifier_call_chain when
 status is changed
Message-ID: <20130917160835.GS15645@radagast>
Reply-To: <balbi@ti.com>
References: <1378630239-10006-1-git-send-email-pali.rohar@gmail.com>
 <1378630239-10006-2-git-send-email-pali.rohar@gmail.com>
 <20130917154917.GL15645@radagast>
 <201309171805.15460@pali>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LtN0I0gXzHUftVCi"
Content-Disposition: inline
In-Reply-To: <201309171805.15460@pali>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--LtN0I0gXzHUftVCi
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 17, 2013 at 06:05:15PM +0200, Pali Roh=E1r wrote:
> On Tuesday 17 September 2013 17:48:59 you wrote:
> > On Sun, Sep 08, 2013 at 10:50:36AM +0200, Pali Roh=E1r wrote:
> > > More power supply drivers depends on vbus events and without
> > > it they not working. Power supply drivers using
> > > usb_register_notifier, so to deliver events it is needed to
> > > call atomic_notifier_call_chain.
> > >=20
> > > So without atomic notifier power supply driver isp1704 not
> > > retrieving vbus status and reporting bogus values to
> > > userspace and also to board platform data functions.
> > > Without proper data charger drivers trying to charge
> > > battery also when charger is disconnected or do not start
> > > charging when wallcharger connects.
> > >=20
> > > Atomic notifier in musb driver was used before v3.5 and was
> > > replaced with omap mailbox. This patch adding
> > > atomic_notifier_call_chain call from function
> > > omap_musb_set_mailbox.
> > >=20
> > > Signed-off-by: Pali Roh=E1r <pali.rohar@gmail.com>
> > > ---
> > >=20
> > >  drivers/usb/musb/omap2430.c       |    3 +++
> > >  drivers/usb/phy/phy-twl4030-usb.c |    2 ++
> > >  2 files changed, 5 insertions(+)
> > >=20
> > > diff --git a/drivers/usb/musb/omap2430.c
> > > b/drivers/usb/musb/omap2430.c index f44e8b5..5c40252 100644
> > > --- a/drivers/usb/musb/omap2430.c
> > > +++ b/drivers/usb/musb/omap2430.c
> > > @@ -305,6 +305,9 @@ static void omap_musb_set_mailbox(struct
> > > omap2430_glue *glue)
> > >=20
> > >  	default:
> > >  		dev_dbg(dev, "ID float\n");
> > >  =09
> > >  	}
> > >=20
> > > +
> > > +	atomic_notifier_call_chain(&musb->xceiv->notifier,
> > > +			musb->xceiv->last_event, NULL);
> >=20
> > let's add a wrapper for this:
> >=20
> > static inline int usb_phy_notify(struct usb phy *x, unsigned
> > val, void *v) {
> > 	return atomic_notifier_call_chain(&x->notifier, val, v);
> > }
>=20
> Where to add this wrapper? To omap2430.c? or some include file?

<linux/usb/phy.h>

> On Tuesday 17 September 2013 17:49:17 Felipe Balbi wrote:
> > On Sun, Sep 08, 2013 at 10:50:36AM +0200, Pali Roh=E1r wrote:
> > > diff --git a/drivers/usb/phy/phy-twl4030-usb.c
> > > b/drivers/usb/phy/phy-twl4030-usb.c index 8f78d2d..efe6155
> > > 100644
> > > --- a/drivers/usb/phy/phy-twl4030-usb.c
> > > +++ b/drivers/usb/phy/phy-twl4030-usb.c
> > > @@ -705,6 +705,8 @@ static int twl4030_usb_probe(struct
> > > platform_device *pdev)
> > >=20
> > >  	if (device_create_file(&pdev->dev, &dev_attr_vbus))
> > >  =09
> > >  		dev_warn(&pdev->dev, "could not create sysfs file\n");
> > >=20
> > > +	ATOMIC_INIT_NOTIFIER_HEAD(&twl->phy.notifier);
> >=20
> > BTW, this is a bugfix, send separately.
>=20
> What to send separately?
>=20
> This full patch 1/4 is bugfix. And I did not understand what you=20
> want. Maybe it could be easier for you to apply this small 3+2=20
> lines patch how you need.

This hunk here (initializaing notifier head) is a separate bug fix and
needs its own patch.

--=20
balbi

--LtN0I0gXzHUftVCi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJSOH6DAAoJEIaOsuA1yqRE6fsP/1HZxWb/VlwBvRGFR9ChrlgJ
RuMTDLnOgw5V+1GpF+CqPLt5NGTrkQCDmWodD8E0e5q9P+hnNtYAio+x8HfNHPsE
rjylpMIaBBxuKYad0+s3+SNojvzsdJYHDKrJmVrUQIcKOvwKvvcgX/DVd8t2trk+
GH3DGUJxOGoz9i/fXmQRyw9nFVqNMlqxEfyNPwX/LceTOT/MdWeszLvyyy/rJxQh
nzyeUGpXv/K0RLH9QOe5mcLVwbTC1vdetgbEwtfbk5ZarmTOMT7h83NI5PFAr6HX
rW2kO2GB01OtSsruL7G3gFCh7szpeljfXwJwO6vVxl/wC3wgUXwg27j8dXc3vjbJ
X5gLKx7wJSLQeoSmw6an9BdCN+pEaMx9fB7nEJVnYWOp0FOUe35bYYntDWO22Bd4
2hvu2xeFNnGfzqEMm+w9bfvFzb7XwQVn1kU2shc91kJw9CB79Vimuhg/7jjtcODp
XBdCz1A/QO7RKjNKwhuhsD3waBxrRQWOkNFIGHzMAtyiPtXs8kbmAk1j72jveqV5
rOull+Nh3mfD7twqR0RF4ot9kvGTjfrkzrTMtJTccLoJhfxM3opyCSdshzqsjPYT
+deRW4N3pVqFyIYdu8SW9J+5JQobOmeqFDNo0O9r8oGzygHDWMox++S7rToK9/M6
VX7qIqw11jGXivDD2VAy
=CsOG
-----END PGP SIGNATURE-----

--LtN0I0gXzHUftVCi--
