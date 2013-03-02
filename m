Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752169Ab3CBXVw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Mar 2013 18:21:52 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:57316 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751052Ab3CBXVu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Mar 2013 18:21:50 -0500
Date: Sun, 3 Mar 2013 01:21:32 +0200
From: Felipe Balbi <balbi@ti.com>
To: Alan Stern <stern@rowland.harvard.edu>
CC: Felipe Balbi <balbi@ti.com>, Vivek Gautam <gautam.vivek@samsung.com>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-samsung-soc@vger.kernel.org>,
        <gregkh@linuxfoundation.org>, <sarah.a.sharp@linux.intel.com>,
        <kgene.kim@samsung.com>, <kishon@ti.com>,
        Doug Anderson <dianders@chromium.org>
Subject: Re: [PATCH v2 06/10] usb: xhci: Enable runtime pm in xhci-plat
Message-ID: <20130302232132.GB14558@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <20130302203908.GF12181@arwen.pp.htv.fi>
 <Pine.LNX.4.44L0.1303021647290.17418-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0ntfKIWw70PvrIHh"
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1303021647290.17418-100000@netrider.rowland.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--0ntfKIWw70PvrIHh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Sat, Mar 02, 2013 at 05:02:13PM -0500, Alan Stern wrote:
> On Sat, 2 Mar 2013, Felipe Balbi wrote:
>=20
> > > > @@ -174,6 +177,10 @@ static int xhci_plat_remove(struct platform_de=
vice *dev)
> > > >  	struct usb_hcd	*hcd =3D platform_get_drvdata(dev);
> > > >  	struct xhci_hcd	*xhci =3D hcd_to_xhci(hcd);
> > > > =20
> > > > +	if (!pm_runtime_suspended(&dev->dev))
> > > > +		pm_runtime_put(&dev->dev);
> > > > +	pm_runtime_disable(&dev->dev);
> > > > +
> > > >  	usb_remove_hcd(xhci->shared_hcd);
> > > >  	usb_put_hcd(xhci->shared_hcd);
> > >=20
> > > This is very strange.  Why have a pm_runtime_put with no balancing=20
> > > pm_runtime_get?
> >=20
> > this is good point and, in fact, a doubt I have myself. How are we
> > supposed to check if device is suspended ? In case it _is_ suspended we
> > might not be able to read device's registers due to clocks possibly
> > being gated.
>=20
> That's really a separate question.  It has a simple answer, though: If=20
> you want to access a device's registers, call pm_runtime_get_sync()=20
> beforehand and pm_runtime_put() (or _put_sync()) afterward.  Then it=20
> won't matter if the device was suspended originally.

that's alright, but how do you want me to check if my device is enabled
or not before pm_runtime_enable() ?

> If you actually do want to tell whether or not a device is suspended
> and nothing more, call pm_runtime_status_suspended().  Of course, this
> is racy -- the power state might change right after you make the call.

right.

> > Also, considering that some drivers are used in multiple platforms and
> > those might behave differently when it comes to clock handling, how do
> > we do that ? Should we require drivers to explicitly clk_get();
> > clk_prepare_enable(); pm_runtime_set_active(); pm_runtime_enable() ?
>=20
> I don't know much about clock handling.  In general, the
> pm_runtime_set_active() and pm_runtime_enable() parts should be done by
> the subsystem, not the driver, whenever possible.

good to know :-) Though I disagree with calling pm_runtime_enable() at
the subsystem level.

This means we can add pm_runtime_set_active()=20

> > While that's doable, I don't see how that'd be doable for OMAP since
> > they want to hide clock handling from drivers.
> >=20
> > Any tips ?
>=20
> Whichever piece of code is responsible for associating a clock with a
> device should also be responsible for making sure that neither is
> suspended when the driver's probe routine runs.  I'm not sure how=20
> different platforms do this; using a PM domain could be one answer.

that's alright, but it generates a different set of problems. That same
piece of code which associates a device with its clock, doesn't really
know if the driver is even available which means we could be enabling
clocks for no reason and just wasting precious battery juice ;-)

> All this is somewhat off the point of my original comment, however. =20
> Drivers must be sure to balance their pm_runtime_get() and _put() =20
> calls.  Having an unbalanced _put() in the remove routine is almost
> certainly a mistake -- especially if it is conditional on the device's
> power state, because a device can remain unsuspended even after the
> driver does a pm_runtime_put().  For example, this will happen if the
> user wrote "on"  to /sys/.../power/control.

indeed... Makes sense. I'll consider mailing linux-pm for the rest of
the discussion, cheers.

--=20
balbi

--0ntfKIWw70PvrIHh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRMol8AAoJEIaOsuA1yqREo2AP/0DZbquu0C/vmTfVEHU5Wx7N
b8F8m+RCYRPrEbGmj58E5rsVFNPHBcwLforC/am6j2ljONUeCiYmH7/EINSVSX6L
hv3aHeoS8vHUWBHUqQFq2clXG9IvuHClmA0j6M5y9p34+NXU1UBAddmhwGu2t3n/
TWIFw7dHm9h1XDWx/JtEaMjyjEUIKaCmG4xqut1RLVq8y3eag5goRZX8rfRpN0mL
8niaoeRIKIQyvf/QwrmPaUv2Kz7p+guH5DgKhXASc0PYip+89Wm2tRvtvHyiiYWP
0LrbaJzE9PTEOzd42plU38zNq4+D/Pjbv5w3iN/qhT/Rj5+uydGiWUSRupaXiHl+
9llOK87mCeoK4uGRE/ZzkIZc+x6zx6smZ/3CvJR8NGs24+b/3YsBKd4SFbbKFT9S
VMmx4lA0VaaQy9aKEc52XteNo8Y97ffPgWB6gAoDCkWkXPsjPSNaEvUbhUTc5Bff
R84fXZUqq+CbSEl3GzD/eTF8tb8dKg0Xm5K5FtSyWG3kehnCPqcCrZwlQn1OcjdC
6Vo6ZTEDdja4leWIjC39RYURIFrw9TOwbddt/iJtSzYhz2SpY4j0SBtJdL4bTwNi
PU9cK9P4MBcaf1xvcNgyfIXKleM9CGaOx8UpF2lP/m9nu9aRquzpQ0kSpMFjBErI
eBRuEcbVWPgaZvAU3gyl
=pY6L
-----END PGP SIGNATURE-----

--0ntfKIWw70PvrIHh--
