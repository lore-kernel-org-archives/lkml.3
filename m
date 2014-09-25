Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752955AbaIYOKo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 10:10:44 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:54566 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751595AbaIYOKm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 10:10:42 -0400
Date: Thu, 25 Sep 2014 09:09:55 -0500
From: Felipe Balbi <balbi@ti.com>
To: Arnd Bergmann <arnd@arndb.de>
CC: Peter Chen <peter.chen@freescale.com>, <balbi@ti.com>,
        Antoine Tenart <antoine.tenart@free-electrons.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <sebastian.hesselbarth@gmail.com>, <p.zabel@pengutronix.de>,
        <thomas.petazzoni@free-electrons.com>, <zmxu@marvell.com>,
        <devicetree@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <alexandre.belloni@free-electrons.com>,
        <jszhang@marvell.com>
Subject: Re: [PATCH v6 07/12] usb: chipidea: add a usb2 driver for ci13xxx
Message-ID: <20140925140955.GB28045@saruman>
Reply-To: <balbi@ti.com>
References: <1411468088-5702-1-git-send-email-antoine.tenart@free-electrons.com>
 <62705234.gKJDtUQLyT@wuerfel>
 <20140924022736.GA5307@peterchendt>
 <2990737.4KzKXPZhaB@wuerfel>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="R3G7APHDIzY6R/pk"
Content-Disposition: inline
In-Reply-To: <2990737.4KzKXPZhaB@wuerfel>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--R3G7APHDIzY6R/pk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Sep 24, 2014 at 09:44:19AM +0200, Arnd Bergmann wrote:
> > It is a good suggestion for adding DT support for core driver, Since we=
 did
> > not do it at the first, it is a little embarrass at current situation.
> >=20
> > - For the new chipidea glue drivers, it is ok we can have a child node
> > for core device at glue device node, and some common entries can be the=
re
> > like: phy, vbus, dr_mode, etc. We need to add support for getting
> > these common things for both through device tree and platform data
> > (parent is DT support and parent is non-DT support) at core driver.
>=20
> I don't really want to see the child devices show up in DT, as this is
> really an implementation detail of the way that the driver currently work=
s,
> and IMHO we should change that.
>=20
> I know that Felipe disagrees with me on this, but almost every other
> driver that has soc-specific specializations does not use parent/child
> nodes, neither in DT nor in Linux. Instead you have a single device
> node that gets distinguished by "compatible" string.

I have two answers for this:

1) We need to let different buses use the same device. The same IP can
be used on PCI, platform, OMAP (yes, OMAP is pretty much a bus, even
though we're using platform-bus with a bunch of code to match things),
AMBA, etc.

2) I like to mode the HW in code and if you look into RTL you'll see
that PCIe, OMAP, QCOM, Exynos, etc, take a semi-bus-agnostic core IP and
write a wrapper IP to make it fit into the SoC. That Wrapper is also an
IP of its own and has its own clocks, sometimes its own IRQs. Not to
mention that PM requirements for different architectures might be (and
actually are) different, while PM requirements for the core IP is
"generic" because it comes from IP provider.

By using a parent device, we can hide all platform-/bus-specific details
on the parent driver and keep core driver "pristine". I see many, many
benefits of doing things this way and many of the benefits are already
cooked into the driver model itself, so why not use it ?

> > - For the existing glue drivers, since we can't change existed dts, we =
can
> > only do it from future SoC support. Then, in this kinds of glue drivers,
> > we need to support for both create core driver by node and by current
> > calling platform_device_add way.
>=20
> We should be able to easily change the ci_hdrc_add_device call into
> a different exported function that calls a version of the probe()
> code directly, as we do in all sorts of other drivers (ehci, ohci,
> dwc2, ..., but not dwc3 and musb as they are maintained by Felipe).

Go back a few commits and you'll see EHCI couldn't even be built with
different glues (say ehci-omap and ehci-pci).

> We can also gradually move in some of the other glue drivers into
> the main driver if the differences are small enough.

you'll end up with a bunch of conflicting requirements very soon. In
fact that's one reason for MUSB being a mess. It was, originally, a
single driver with platform-specific glue chosen in build-time. To this
day, we still can't have different DMA glues on the kernel and
TUSB6010-glue doesn't work with anybody else.

When you have a single driver like that, you end up accepting
platform-specific details into the core IP just because the changes are
small enough.

> Moving the PCI driver over to this model requires a little more
> work but is absolutely doable (again, see ehci, ahci, sdhci examples)
> by moving the platform_device handling out of core.c and changing
> it just operate on the plain 'struct device', with an exported
> probe function that gets called on either the platform device
> or the pci device.

sounds like a disaster waiting to happen for me.

--=20
balbi

--R3G7APHDIzY6R/pk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUJCIzAAoJEIaOsuA1yqREbeQQAJZTwa44eNwo5RJvl6YLWZD0
aCLZj9jiVM4WxDM4bJKNSAfyoNiWzPrSkJgax6nPE/G/7CYZruyfMZzpbn0sc0Zo
/djO/TGuQiOIYsZVvgLoCUGUtnaFZuDlt7xUslt5QjWRDfO5+QwRzrlhxx1AowMQ
GHYoLUMt5VUFIe4w22P9Pbcc9SXVEHxLe9+kPh7BwjL8XZioRg/4mgFeua6v20Wa
/2N8YS8Doe8vAcxe99LUY00w+RZW2T0WjhoISQhd5oaSvcAIfKyJ5HDASgX6ecJy
45fH25bF/0t19sFo8CD4h95qyvKW+nK+6CN5zYf3DC0IVMmlDLKntJWYwU9io0To
bmJOAM2kaeQnBCGetDVdNEl+1OJvzuc6dHX+ZZp0gytCRGzB1CQz+9ahgmF/oBuI
/wNXo004HayeIjilHzq5t3mforl5Anxu9uGMiPKId1iBGS6RG/2PK4yOXJullJLh
xzuh7bJjEVbL4bmndg7gm6TnLtyESAneYOrQB43+LOiPzjixkwQ2AmdbfSzXVe3Y
C7/da3swc9zMz7mM59HjwXnxzbF0TnrcwLMYfw98t0jY7yR0VMkhViBW+Dxv5Y15
1sD1nzpdjD7b+iH/U8VirwTAYvhvJNj2lkyq9jc0qpsZPjWXEka9wNCLCmNV0NHu
mtWemsYFno+K25Lb0vFg
=Or18
-----END PGP SIGNATURE-----

--R3G7APHDIzY6R/pk--
