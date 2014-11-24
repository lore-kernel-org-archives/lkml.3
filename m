Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753839AbaKXPQy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 10:16:54 -0500
Received: from mail-pa0-f47.google.com ([209.85.220.47]:65092 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750733AbaKXPQw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 10:16:52 -0500
Date: Mon, 24 Nov 2014 16:16:46 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Felipe Balbi <balbi@ti.com>
Cc: Arjun Sreedharan <arjun024@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-next@vger.kernel.org, kernel-build-reports@lists.linaro.org
Subject: Re: [PATCH] usb:phy: propagate __of_usb_find_phy()'s error on failure
Message-ID: <20141124151644.GC4061@ulmo.nvidia.com>
References: <1416498816-3292-1-git-send-email-arjun024@gmail.com>
 <20141124131034.GB4061@ulmo.nvidia.com>
 <20141124143646.GA20705@saruman>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0IvGJv3f9h+YhkrH"
Content-Disposition: inline
In-Reply-To: <20141124143646.GA20705@saruman>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--0IvGJv3f9h+YhkrH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 24, 2014 at 08:36:46AM -0600, Felipe Balbi wrote:
> Hi,
>=20
> On Mon, Nov 24, 2014 at 02:10:41PM +0100, Thierry Reding wrote:
> > On Thu, Nov 20, 2014 at 09:23:36PM +0530, Arjun Sreedharan wrote:
> > > When __of_usb_find_phy() fails, it returns -ENODEV - its
> > > error code has to be returned by devm_usb_get_phy_by_phandle().
> > > Only when the former function succeeds and try_module_get()
> > > fails should -EPROBE_DEFER be returned.
> > >=20
> > > Signed-off-by: Arjun Sreedharan <arjun024@gmail.com>
> > > ---
> > >  drivers/usb/phy/phy.c | 4 +++-
> > >  1 file changed, 3 insertions(+), 1 deletion(-)
> >=20
> > This causes a boot regression on at least NVIDIA Dalmore (I boot over
> > NFS using a USB network adapter).
> >=20
> > The commit message is somewhat insufficient because while it explains
> > what the code does and asserts that it is the right thing to do, it
> > fails to explain why.
>=20
> you also fail to explain it causes a regressions with Dalmore.

I thought my explanation below was sufficient, but maybe I should say it
in other words: __of_usb_find_phy() returns -ENODEV if no PHY was found
to be registered for a given phandle. That causes the driver to abort
probing with a -ENODEV error and does not trigger the probe deferral
that'd be necessary to get the host controller to find the PHY the next
time it was triggered.

> This is really the correct patch, we shouldn't be overwritting the
> error passed in by upper layers.

No, it's very obviously not the correct patch if it causes a regression.

> > > diff --git a/drivers/usb/phy/phy.c b/drivers/usb/phy/phy.c
> > > index 045cd30..0310112 100644
> > > --- a/drivers/usb/phy/phy.c
> > > +++ b/drivers/usb/phy/phy.c
> > > @@ -191,7 +191,9 @@ struct usb_phy *devm_usb_get_phy_by_phandle(struc=
t device *dev,
> > > =20
> > >  	phy =3D __of_usb_find_phy(node);
> > >  	if (IS_ERR(phy) || !try_module_get(phy->dev->driver->owner)) {
> > > -		phy =3D ERR_PTR(-EPROBE_DEFER);
> > > +		if (!IS_ERR(phy))
> > > +			phy =3D ERR_PTR(-EPROBE_DEFER);
> >=20
> > If we look at this closer, __of_usb_find_phy() return a valid pointer if
> > a PHY was found or ERR_PTR(-ENODEV) otherwise. But since the phandle has
> > already been validated, the only reason why __of_usb_find_phy() fails is
> > because the PHY that the phandle refers to hasn't been registered yet.
> >=20
> > Returning -EPROBE_DEFER is the correct thing to do in this situation
> > because it gives the PHY driver an opportunity to register and the USB
> > host controller to try probing again. I suppose one could argue that
> > __of_usb_find_phy() should return ERR_PTR(-EPROBE_DEFER) on failure
> > instead of ERR_PTR(-ENODEV), since evidently the device does exist, it
> > just hasn't been registered yet. On the other hand it could happen that
> > the phandle refers to a device tree node that's status =3D "disabled", =
in
> > which case ERR_PTR(-ENODEV) might be appropriate.
> >=20
> > Also, -EPROBE_DEFER isn't really the proper error for try_module_get()
> > failure. Other functions (usb_get_phy() and usb_get_phy_dev()) return
> > -ENODEV instead, so it'd be more consistent to stick with that. Hence I
> > propose something like the below instead.
>=20
> I don't mind patch below, but I want to know why Dalmore regressed with
> $subject.

Note that this isn't only an issue specific to Dalmore. This affects
every device that uses a USB PHY and where the PHY is registered after
the first probe of the USB host controller.

Thierry

--0IvGJv3f9h+YhkrH
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUc0vcAAoJEN0jrNd/PrOhyJcP/RG/Lv4CJrBL2o8fySKqoBbZ
a6UYijwUmit0IvPQfjAVih5+UlMdzKB6siz0/n8cxcTsB8s/IAvHEAJ32Has+xzW
+R2Oa3AXtx3C1flWCA6hj0OggCRrAt384hEg3L4Q2LxPCQfZiABDIZ4EnMHq1Kkc
Dol5ao/C0/S9pJHh+7lr7mTk3mTyUQB2S+uMhlDAITnTVPVeKZE0qaWmmNGXQ57F
FOCy30OBTfB5fy3zWmGRyzJXUWGgSnLzw/m/MFsS+u1YdLHxHhXbEh99nPWthAhl
9ff7BTey3gqI3sJa706FvXpfK4RkceXh1qjYDlB5TLnSh7RKprHyuji/0T9i/mty
UlqgPvFO5Be0qyAG4JFHLYUI68hJKJj/27i0h19ERrEGAcfTQ1szdQ20uwegFxkS
vvrBKvbqHzITQHae3H9KaqUOYL4Mh1b+zMkIzSA0w2F3SBiMOOgsEbmaCWt3+0D7
t7XvJDh9ELew639NkJQYAxH1M9h3GKcAicUTxyZJmvfFo8otFQ6zGS1LynEt9dNu
IR0r1ArTaM262ip5TlXMs3TuhoeqpJ8N38I4hdmGeRvZb4/oUNR52T8S2am2IlgL
KpiPxqwHdk8xeg4h7k7UwBvSH7hpoqNMXgn7RHb2rgW5fO4BXwSnZijoXWDIzPJf
bo9rhih9LubFNrI5Yzcu
=rIdT
-----END PGP SIGNATURE-----

--0IvGJv3f9h+YhkrH--
