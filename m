Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753823AbaKXPgS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 10:36:18 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:39542 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752589AbaKXPgP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 10:36:15 -0500
Date: Mon, 24 Nov 2014 09:36:21 -0600
From: Felipe Balbi <balbi@ti.com>
To: Thierry Reding <thierry.reding@gmail.com>
CC: Felipe Balbi <balbi@ti.com>, Arjun Sreedharan <arjun024@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-next@vger.kernel.org>, <kernel-build-reports@lists.linaro.org>
Subject: Re: [PATCH] usb:phy: propagate __of_usb_find_phy()'s error on failure
Message-ID: <20141124153621.GF20705@saruman>
Reply-To: <balbi@ti.com>
References: <1416498816-3292-1-git-send-email-arjun024@gmail.com>
 <20141124131034.GB4061@ulmo.nvidia.com>
 <20141124143646.GA20705@saruman>
 <20141124151644.GC4061@ulmo.nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="L1c6L/cjZjI9d0Eq"
Content-Disposition: inline
In-Reply-To: <20141124151644.GC4061@ulmo.nvidia.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--L1c6L/cjZjI9d0Eq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Nov 24, 2014 at 04:16:46PM +0100, Thierry Reding wrote:
> On Mon, Nov 24, 2014 at 08:36:46AM -0600, Felipe Balbi wrote:
> > Hi,
> >=20
> > On Mon, Nov 24, 2014 at 02:10:41PM +0100, Thierry Reding wrote:
> > > On Thu, Nov 20, 2014 at 09:23:36PM +0530, Arjun Sreedharan wrote:
> > > > When __of_usb_find_phy() fails, it returns -ENODEV - its
> > > > error code has to be returned by devm_usb_get_phy_by_phandle().
> > > > Only when the former function succeeds and try_module_get()
> > > > fails should -EPROBE_DEFER be returned.
> > > >=20
> > > > Signed-off-by: Arjun Sreedharan <arjun024@gmail.com>
> > > > ---
> > > >  drivers/usb/phy/phy.c | 4 +++-
> > > >  1 file changed, 3 insertions(+), 1 deletion(-)
> > >=20
> > > This causes a boot regression on at least NVIDIA Dalmore (I boot over
> > > NFS using a USB network adapter).
> > >=20
> > > The commit message is somewhat insufficient because while it explains
> > > what the code does and asserts that it is the right thing to do, it
> > > fails to explain why.
> >=20
> > you also fail to explain it causes a regressions with Dalmore.
>=20
> I thought my explanation below was sufficient, but maybe I should say it
> in other words: __of_usb_find_phy() returns -ENODEV if no PHY was found
> to be registered for a given phandle. That causes the driver to abort
> probing with a -ENODEV error and does not trigger the probe deferral
> that'd be necessary to get the host controller to find the PHY the next
> time it was triggered.

right, and before $subject dev_usb_get_phy_by_phandle() was overwriting
whatever error code passed by __of_usb_find_phy() to -EPROBE_DEFER.

> > This is really the correct patch, we shouldn't be overwritting the
> > error passed in by upper layers.
>=20
> No, it's very obviously not the correct patch if it causes a regression.

or it exposes a bug elsewhere :-)

> > > > diff --git a/drivers/usb/phy/phy.c b/drivers/usb/phy/phy.c
> > > > index 045cd30..0310112 100644
> > > > --- a/drivers/usb/phy/phy.c
> > > > +++ b/drivers/usb/phy/phy.c
> > > > @@ -191,7 +191,9 @@ struct usb_phy *devm_usb_get_phy_by_phandle(str=
uct device *dev,
> > > > =20
> > > >  	phy =3D __of_usb_find_phy(node);
> > > >  	if (IS_ERR(phy) || !try_module_get(phy->dev->driver->owner)) {
> > > > -		phy =3D ERR_PTR(-EPROBE_DEFER);
> > > > +		if (!IS_ERR(phy))
> > > > +			phy =3D ERR_PTR(-EPROBE_DEFER);
> > >=20
> > > If we look at this closer, __of_usb_find_phy() return a valid pointer=
 if
> > > a PHY was found or ERR_PTR(-ENODEV) otherwise. But since the phandle =
has
> > > already been validated, the only reason why __of_usb_find_phy() fails=
 is
> > > because the PHY that the phandle refers to hasn't been registered yet.
> > >=20
> > > Returning -EPROBE_DEFER is the correct thing to do in this situation
> > > because it gives the PHY driver an opportunity to register and the USB
> > > host controller to try probing again. I suppose one could argue that
> > > __of_usb_find_phy() should return ERR_PTR(-EPROBE_DEFER) on failure
> > > instead of ERR_PTR(-ENODEV), since evidently the device does exist, it
> > > just hasn't been registered yet. On the other hand it could happen th=
at
> > > the phandle refers to a device tree node that's status =3D "disabled"=
, in
> > > which case ERR_PTR(-ENODEV) might be appropriate.
> > >=20
> > > Also, -EPROBE_DEFER isn't really the proper error for try_module_get()
> > > failure. Other functions (usb_get_phy() and usb_get_phy_dev()) return
> > > -ENODEV instead, so it'd be more consistent to stick with that. Hence=
 I
> > > propose something like the below instead.
> >=20
> > I don't mind patch below, but I want to know why Dalmore regressed with
> > $subject.
>=20
> Note that this isn't only an issue specific to Dalmore. This affects
> every device that uses a USB PHY and where the PHY is registered after
> the first probe of the USB host controller.

although, I have been running this for the last few days with
BeagleBoneBlack and AM437x SK and haven't noticed any issues.

--=20
balbi

--L1c6L/cjZjI9d0Eq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIbBAEBAgAGBQJUc1B1AAoJEIaOsuA1yqREyGUP+Ks4brrW23+H1W6F9Pu/FOty
nEai4XkSIbApqWp7G0Vi3TsOSm6+z1kBCQU5EHYX62r43lBRbXzNwfAdCm3IwzUQ
AXn0y4chwNeVJG5hXvPU18Y+1rC060jU4E4M9gYZbLO9l1N11oxJzctevR7k+xkc
TXdmfNh2lAuzp7V9Gpqa6Cgi/GjzU7/S3ez7hQEu9JUdA49O1WrC+yCfxHOIFf3Y
6rZmb/zrYFXNKT3UipnfQERwA6rc/9YMdHqbcRAagaIfJid3wLNxAD25DA8t6kKm
FL+jM6IaF5AfTBusHvWtNR0Arp/aTKn13OjjjdYNMcKPcvgE0JsLEZzCbD7qvpJ0
3UrDQafX2y6GG0il5pnwfqYJ8k3KH3ZLrNcJX2mnjkAvd21p/qo/CpzAVY5K0QTT
1I2ruKrTpIRaGyzrz0suv4p4lLk9VHP7V/nCluWr7mxAt53lb5gRy32jHYs9E+/G
ZepEWWL0MyEV0jleBSAG1qudaZ/0k3juWZ11VB8HuPA5cs7cQUopIeNRJeI3PdyL
9JuZIHXHkLQkWK3HljmUYBdAanv0tj8uvwF7yI5c/gVznpiGb4UrLEPGrcjSgWiq
GmKb+1fnBInUSgUTcd3k5ccANj4GsjyN6W1uMVxp4Jcjo02hdwwpTenEzsclKQVS
F4zRIflpervtXbfVLvw=
=zVXg
-----END PGP SIGNATURE-----

--L1c6L/cjZjI9d0Eq--
