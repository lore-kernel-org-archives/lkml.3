Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751776Ab3IRBvh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 21:51:37 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:45721 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751136Ab3IRBvf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 21:51:35 -0400
Date: Tue, 17 Sep 2013 20:49:42 -0500
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
Message-ID: <20130918014942.GD19817@radagast>
Reply-To: <balbi@ti.com>
References: <1378630239-10006-1-git-send-email-pali.rohar@gmail.com>
 <201309171805.15460@pali>
 <20130917160835.GS15645@radagast>
 <201309172128.42514@pali>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="J5MfuwkIyy7RmF4Q"
Content-Disposition: inline
In-Reply-To: <201309172128.42514@pali>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--J5MfuwkIyy7RmF4Q
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 17, 2013 at 09:28:42PM +0200, Pali Roh=E1r wrote:
> On Tuesday 17 September 2013 18:08:35 Felipe Balbi wrote:
> > On Tue, Sep 17, 2013 at 06:05:15PM +0200, Pali Roh=E1r wrote:
> > > On Tuesday 17 September 2013 17:48:59 you wrote:
> > > > On Sun, Sep 08, 2013 at 10:50:36AM +0200, Pali Roh=E1r wrote:
> > > > > More power supply drivers depends on vbus events and
> > > > > without it they not working. Power supply drivers using
> > > > > usb_register_notifier, so to deliver events it is
> > > > > needed to call atomic_notifier_call_chain.
> > > > >=20
> > > > > So without atomic notifier power supply driver isp1704
> > > > > not retrieving vbus status and reporting bogus values
> > > > > to userspace and also to board platform data functions.
> > > > > Without proper data charger drivers trying to charge
> > > > > battery also when charger is disconnected or do not
> > > > > start charging when wallcharger connects.
> > > > >=20
> > > > > Atomic notifier in musb driver was used before v3.5 and
> > > > > was replaced with omap mailbox. This patch adding
> > > > > atomic_notifier_call_chain call from function
> > > > > omap_musb_set_mailbox.
> > > > >=20
> > > > > Signed-off-by: Pali Roh=E1r <pali.rohar@gmail.com>
> > > > > ---
> > > > >=20
> > > > >  drivers/usb/musb/omap2430.c       |    3 +++
> > > > >  drivers/usb/phy/phy-twl4030-usb.c |    2 ++
> > > > >  2 files changed, 5 insertions(+)
> > > > >=20
> > > > > diff --git a/drivers/usb/musb/omap2430.c
> > > > > b/drivers/usb/musb/omap2430.c index f44e8b5..5c40252
> > > > > 100644 --- a/drivers/usb/musb/omap2430.c
> > > > > +++ b/drivers/usb/musb/omap2430.c
> > > > > @@ -305,6 +305,9 @@ static void
> > > > > omap_musb_set_mailbox(struct omap2430_glue *glue)
> > > > >=20
> > > > >  	default:
> > > > >  		dev_dbg(dev, "ID float\n");
> > > > >  =09
> > > > >  	}
> > > > >=20
> > > > > +
> > > > > +	atomic_notifier_call_chain(&musb->xceiv->notifier,
> > > > > +			musb->xceiv->last_event, NULL);
> > > >=20
> > > > let's add a wrapper for this:
> > > >=20
> > > > static inline int usb_phy_notify(struct usb phy *x,
> > > > unsigned val, void *v) {
> > > >=20
> > > > 	return atomic_notifier_call_chain(&x->notifier, val, v);
> > > >=20
> > > > }
> > >=20
> > > Where to add this wrapper? To omap2430.c? or some include
> > > file?
> >=20
> > <linux/usb/phy.h>
> >=20
> > > On Tuesday 17 September 2013 17:49:17 Felipe Balbi wrote:
> > > > On Sun, Sep 08, 2013 at 10:50:36AM +0200, Pali Roh=E1r wrote:
> > > > > diff --git a/drivers/usb/phy/phy-twl4030-usb.c
> > > > > b/drivers/usb/phy/phy-twl4030-usb.c index
> > > > > 8f78d2d..efe6155 100644
> > > > > --- a/drivers/usb/phy/phy-twl4030-usb.c
> > > > > +++ b/drivers/usb/phy/phy-twl4030-usb.c
> > > > > @@ -705,6 +705,8 @@ static int twl4030_usb_probe(struct
> > > > > platform_device *pdev)
> > > > >=20
> > > > >  	if (device_create_file(&pdev->dev, &dev_attr_vbus))
> > > > >  =09
> > > > >  		dev_warn(&pdev->dev, "could not create sysfs
> > > > >  		file\n");
> > > > >=20
> > > > > +	ATOMIC_INIT_NOTIFIER_HEAD(&twl->phy.notifier);
> > > >=20
> > > > BTW, this is a bugfix, send separately.
> > >=20
> > > What to send separately?
> > >=20
> > > This full patch 1/4 is bugfix. And I did not understand what
> > > you want. Maybe it could be easier for you to apply this
> > > small 3+2 lines patch how you need.
> >=20
> > This hunk here (initializaing notifier head) is a separate bug
> > fix and needs its own patch.
>=20
> So will you do that? Or it is needed to resend this one line hunk=20
> again in new email again?

new patch, new email

--=20
balbi

--J5MfuwkIyy7RmF4Q
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJSOQa2AAoJEIaOsuA1yqREcEQP/21PKDD7CZDQTgKXyye0r6RG
Vi+uEetkbxj5O+GzTY2Uq+hZ9OdDrssd3xhsMT8m9pUdq1uCH4rBkO8VdhghxVxm
B9qzzOBQv7RmSm5Xmwjlml/NvW5ybMUiuQKCLDhoJfa47AZ7EEcJR2lyLObLk0EE
hbS9em5hCYu6tRm6oMGwS+/bHjorr11UeOzilSIRiXh+RhkMJ0uQQqhxs2jVK5H1
RpL5Pc8KNVF0tLPv+JfPdHRcKaM6X8aVS6V6tIr3TjY6UopbRhowo1N1ZmJJsQcE
L+8FZ2PSpHd6Y/j+So7A45aqSrXgtM67MVTvlwhpd0oJJ/fqt92/0T3XCFbJfM1B
MI0qfJq1gcsi8XWfgSysrjlIcjEnu0kjz8bDbNOErpfeqrE5w+mVnDG/T/Oy1mfe
W9S5eIA1nDg/v1L0OaumDSoaqaAjb0eQxoxWmBDfyitVRgmQ42UFOdwXFmY5ZNpG
pV3B2wHZzGv24QPyYJJxqRSo5djfaxjDxg8Yz18LKzpx3e7Jv6qWTO+ptpt6FcVh
D35IX0Ir9S55sygSTH1OwX59xMBGswIzXdtVwZafyxrq3tB+DfiZX+/qMUDuB6wH
FjLFWSbowRM5ZFEyED5Mz6lRgLTaiOj6KTEUrtXYnEu2CdKHQLsxxWUtF01hyzYo
IIV8ZSOnLGjanYaf27oK
=yjwr
-----END PGP SIGNATURE-----

--J5MfuwkIyy7RmF4Q--
