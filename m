Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752650Ab3CBUj2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Mar 2013 15:39:28 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:33839 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752460Ab3CBUj0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Mar 2013 15:39:26 -0500
Date: Sat, 2 Mar 2013 22:39:08 +0200
From: Felipe Balbi <balbi@ti.com>
To: Alan Stern <stern@rowland.harvard.edu>
CC: Vivek Gautam <gautam.vivek@samsung.com>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-samsung-soc@vger.kernel.org>, <gregkh@linuxfoundation.org>,
        <balbi@ti.com>, <sarah.a.sharp@linux.intel.com>,
        <kgene.kim@samsung.com>, <kishon@ti.com>,
        Doug Anderson <dianders@chromium.org>
Subject: Re: [PATCH v2 06/10] usb: xhci: Enable runtime pm in xhci-plat
Message-ID: <20130302203908.GF12181@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1362230590-20960-7-git-send-email-gautam.vivek@samsung.com>
 <Pine.LNX.4.44L0.1303021050210.11936-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="AH+kv8CCoFf6qPuz"
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1303021050210.11936-100000@netrider.rowland.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--AH+kv8CCoFf6qPuz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Sat, Mar 02, 2013 at 10:53:16AM -0500, Alan Stern wrote:
> On Sat, 2 Mar 2013, Vivek Gautam wrote:
>=20
> > By enabling runtime pm in this driver allows users of
> > xhci-plat to enter into runtime pm. This is not full
> > runtime pm support (AKA xhci-plat doesn't actually power
> > anything off when in runtime suspend mode) but,
> > just basic enablement.
> >=20
> > Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
> > CC: Doug Anderson <dianders@chromium.org>
> > ---
> >  drivers/usb/host/xhci-plat.c |    7 +++++++
> >  1 files changed, 7 insertions(+), 0 deletions(-)
> >=20
> > diff --git a/drivers/usb/host/xhci-plat.c b/drivers/usb/host/xhci-plat.c
> > index c9c7e13..595cb52 100644
> > --- a/drivers/usb/host/xhci-plat.c
> > +++ b/drivers/usb/host/xhci-plat.c
> > @@ -12,6 +12,7 @@
> >   */
> > =20
> >  #include <linux/platform_device.h>
> > +#include <linux/pm_runtime.h>
> >  #include <linux/module.h>
> >  #include <linux/slab.h>
> > =20
> > @@ -149,6 +150,8 @@ static int xhci_plat_probe(struct platform_device *=
pdev)
> >  	if (ret)
> >  		goto put_usb3_hcd;
> > =20
> > +	pm_runtime_enable(&pdev->dev);
>=20
> This is generally not a good idea.  You shouldn't enable a device for=20
> runtime PM without first telling the PM core what state it is in.
>=20
> > @@ -174,6 +177,10 @@ static int xhci_plat_remove(struct platform_device=
 *dev)
> >  	struct usb_hcd	*hcd =3D platform_get_drvdata(dev);
> >  	struct xhci_hcd	*xhci =3D hcd_to_xhci(hcd);
> > =20
> > +	if (!pm_runtime_suspended(&dev->dev))
> > +		pm_runtime_put(&dev->dev);
> > +	pm_runtime_disable(&dev->dev);
> > +
> >  	usb_remove_hcd(xhci->shared_hcd);
> >  	usb_put_hcd(xhci->shared_hcd);
>=20
> This is very strange.  Why have a pm_runtime_put with no balancing=20
> pm_runtime_get?

this is good point and, in fact, a doubt I have myself. How are we
supposed to check if device is suspended ? In case it _is_ suspended we
might not be able to read device's registers due to clocks possibly
being gated.

Also, considering that some drivers are used in multiple platforms and
those might behave differently when it comes to clock handling, how do
we do that ? Should we require drivers to explicitly clk_get();
clk_prepare_enable(); pm_runtime_set_active(); pm_runtime_enable() ?

While that's doable, I don't see how that'd be doable for OMAP since
they want to hide clock handling from drivers.

Any tips ?

--=20
balbi

--AH+kv8CCoFf6qPuz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRMmNsAAoJEIaOsuA1yqREMBIQAJSscdOflYj1XhHQmcwa6SmJ
P63w8WJTGQynQiE/MEa568O8VAdve4Cj0euMWE/yOCG9Hna/+bkljcvXm4NPcXpP
EJy5Q/83Y/M66bg/iit/CM9AlxDcbYdY3tM2FGh7Xb/ftOB/IexgFiN3eIFvL6ff
ptykSgJxmN+FvIUujfRE6nzWYwWIUoLhBHAd9YHUMPw8PZ+flP8VbNDE3dCMknCR
aqSjnvMAK2stF0eU+VyNGwvlz4FJ8cz8vpo8E6u/ut/cJ9LeEC/i1yXqx2IZnzLM
piJ3a1oFNb9WaH8vku80RpGJUy06mYyUAyFnVZnobhKj9qV+1K7PSUtqlI0ccVHN
uYm31sZZhZXTjiS1nmmTn2SC8QK1oVBnCOs1l/LjXKA2Fqu/WITXfB6JTn/tXKEg
ljMAkMTkElQttieXsdW0Ntyo+MF03HpC+lS4RBbJRMa4Xzhn+QFCRRCdkt8yLI2T
+DlV5IkB10sxuSDZTDCVf6IL60IMAOrEO5stDMk/wKatOBnEQhKWbub7npz67vRf
ZovILLYBD/jZ2eT8/0H0dIkKLlkAeOzBFTQbDd2fg4tz0arGzIrxexiMJOy37E8p
L0qzBJjXrtwd7QkpFsfiLr4sywtFAWXlg/XaIAe/fddjeZRl9Xsw0eKb22hixhFp
tH/Kmi7UgZ6Op5nZ1rU0
=Y48L
-----END PGP SIGNATURE-----

--AH+kv8CCoFf6qPuz--
