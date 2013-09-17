Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753563Ab3IQT2s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 15:28:48 -0400
Received: from mail-ea0-f175.google.com ([209.85.215.175]:43932 "EHLO
	mail-ea0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753216Ab3IQT2r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 15:28:47 -0400
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: balbi@ti.com
Subject: Re: [PATCH 1/4] usb: musb: Call atomic_notifier_call_chain when status is changed
Date: Tue, 17 Sep 2013 21:28:42 +0200
User-Agent: KMail/1.13.7 (Linux/3.11.0-1+synaptics-generic; KDE/4.11.1; x86_64; ; )
Cc: Tony Lindgren <tony@atomide.com>, Anton Vorontsov <anton@enomsg.org>,
        Russell King <linux@arm.linux.org.uk>,
        David Woodhouse <dwmw2@infradead.org>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        freemangordon@abv.bg, aaro.koskinen@iki.fi, pavel@ucw.cz
References: <1378630239-10006-1-git-send-email-pali.rohar@gmail.com> <201309171805.15460@pali> <20130917160835.GS15645@radagast>
In-Reply-To: <20130917160835.GS15645@radagast>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart29369870.9tosrPilFO";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201309172128.42514@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart29369870.9tosrPilFO
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Tuesday 17 September 2013 18:08:35 Felipe Balbi wrote:
> On Tue, Sep 17, 2013 at 06:05:15PM +0200, Pali Roh=C3=A1r wrote:
> > On Tuesday 17 September 2013 17:48:59 you wrote:
> > > On Sun, Sep 08, 2013 at 10:50:36AM +0200, Pali Roh=C3=A1r wrote:
> > > > More power supply drivers depends on vbus events and
> > > > without it they not working. Power supply drivers using
> > > > usb_register_notifier, so to deliver events it is
> > > > needed to call atomic_notifier_call_chain.
> > > >=20
> > > > So without atomic notifier power supply driver isp1704
> > > > not retrieving vbus status and reporting bogus values
> > > > to userspace and also to board platform data functions.
> > > > Without proper data charger drivers trying to charge
> > > > battery also when charger is disconnected or do not
> > > > start charging when wallcharger connects.
> > > >=20
> > > > Atomic notifier in musb driver was used before v3.5 and
> > > > was replaced with omap mailbox. This patch adding
> > > > atomic_notifier_call_chain call from function
> > > > omap_musb_set_mailbox.
> > > >=20
> > > > Signed-off-by: Pali Roh=C3=A1r <pali.rohar@gmail.com>
> > > > ---
> > > >=20
> > > >  drivers/usb/musb/omap2430.c       |    3 +++
> > > >  drivers/usb/phy/phy-twl4030-usb.c |    2 ++
> > > >  2 files changed, 5 insertions(+)
> > > >=20
> > > > diff --git a/drivers/usb/musb/omap2430.c
> > > > b/drivers/usb/musb/omap2430.c index f44e8b5..5c40252
> > > > 100644 --- a/drivers/usb/musb/omap2430.c
> > > > +++ b/drivers/usb/musb/omap2430.c
> > > > @@ -305,6 +305,9 @@ static void
> > > > omap_musb_set_mailbox(struct omap2430_glue *glue)
> > > >=20
> > > >  	default:
> > > >  		dev_dbg(dev, "ID float\n");
> > > >  =09
> > > >  	}
> > > >=20
> > > > +
> > > > +	atomic_notifier_call_chain(&musb->xceiv->notifier,
> > > > +			musb->xceiv->last_event, NULL);
> > >=20
> > > let's add a wrapper for this:
> > >=20
> > > static inline int usb_phy_notify(struct usb phy *x,
> > > unsigned val, void *v) {
> > >=20
> > > 	return atomic_notifier_call_chain(&x->notifier, val, v);
> > >=20
> > > }
> >=20
> > Where to add this wrapper? To omap2430.c? or some include
> > file?
>=20
> <linux/usb/phy.h>
>=20
> > On Tuesday 17 September 2013 17:49:17 Felipe Balbi wrote:
> > > On Sun, Sep 08, 2013 at 10:50:36AM +0200, Pali Roh=C3=A1r wrote:
> > > > diff --git a/drivers/usb/phy/phy-twl4030-usb.c
> > > > b/drivers/usb/phy/phy-twl4030-usb.c index
> > > > 8f78d2d..efe6155 100644
> > > > --- a/drivers/usb/phy/phy-twl4030-usb.c
> > > > +++ b/drivers/usb/phy/phy-twl4030-usb.c
> > > > @@ -705,6 +705,8 @@ static int twl4030_usb_probe(struct
> > > > platform_device *pdev)
> > > >=20
> > > >  	if (device_create_file(&pdev->dev, &dev_attr_vbus))
> > > >  =09
> > > >  		dev_warn(&pdev->dev, "could not create sysfs
> > > >  		file\n");
> > > >=20
> > > > +	ATOMIC_INIT_NOTIFIER_HEAD(&twl->phy.notifier);
> > >=20
> > > BTW, this is a bugfix, send separately.
> >=20
> > What to send separately?
> >=20
> > This full patch 1/4 is bugfix. And I did not understand what
> > you want. Maybe it could be easier for you to apply this
> > small 3+2 lines patch how you need.
>=20
> This hunk here (initializaing notifier head) is a separate bug
> fix and needs its own patch.

So will you do that? Or it is needed to resend this one line hunk=20
again in new email again?

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart29369870.9tosrPilFO
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlI4rWoACgkQi/DJPQPkQ1I5fgCeN1kWIlv+U/0hdCKQy/DMLfuh
O7AAn1t85eT0FAiC33gBkfkUZsfdNSU9
=m3W/
-----END PGP SIGNATURE-----

--nextPart29369870.9tosrPilFO--
