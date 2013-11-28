Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757968Ab3K1LH1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 06:07:27 -0500
Received: from mail-bk0-f45.google.com ([209.85.214.45]:42633 "EHLO
	mail-bk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751536Ab3K1LHZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 06:07:25 -0500
Date: Thu, 28 Nov 2013 12:06:37 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Marc Dietrich <marvin24@gmx.de>
Cc: Alexandre Courbot <gnurou@gmail.com>, Rhyland Klein <rklein@nvidia.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Linus Walleij <linus.walleij@linaro.org>, Chris Ball <cjb@laptop.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Alex Courbot <acourbot@nvidia.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Rob Landley <rob@landley.net>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Devicetree List <devicetree@vger.kernel.org>
Subject: Re: [PATCH v3 1/6] ARM: tegra: add gpiod_lookup table for paz00
Message-ID: <20131128110636.GA22818@ulmo.nvidia.com>
References: <1385460350-17543-1-git-send-email-mika.westerberg@linux.intel.com>
 <4501377.Eymj5teNBr@fb07-iapwap2>
 <20131128093224.GA26634@ulmo.nvidia.com>
 <1752117.77jQLaML2y@fb07-iapwap2>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="k1lZvvs/B4yU6o8G"
Content-Disposition: inline
In-Reply-To: <1752117.77jQLaML2y@fb07-iapwap2>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--k1lZvvs/B4yU6o8G
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 28, 2013 at 11:20:19AM +0100, Marc Dietrich wrote:
> Am Donnerstag, 28. November 2013, 10:32:41 schrieb Thierry Reding:
> > On Thu, Nov 28, 2013 at 10:09:14AM +0100, Marc Dietrich wrote:
> > > The real problem with the rfkill driver is that it does not support D=
T. A
> > > naive attempt to convert it was made some year ago, but got rejected
> > > because rfkill wasn't seen as isolated device which can be represente=
d in
> > > the device- tree. Also it can not be added under some existing device
> > > node (e.g. the wifi driver) because those devices sit normally on an
> > > "enumeratable" bus (e.g. usb, pci), which is not listed in the device
> > > tree at all. This is why it still requires a board file and
> > > platform_data. I wish we could find a solution for this.
> >=20
> > There is a solution at least for PCI. You can list PCI devices within
> > the device tree, which is really handy (required even) if for instance
> > one of the PCI devices is an SPI or I2C controller, each providing a bus
> > that cannot be probed. What you usually do is describe the PCI hierarchy
> > at least up to the controller and then list slaves as child nodes.
> >=20
> > I'm not aware of anything similar for USB, but it should certainly be
> > possible to come up with a standard binding for the USB bus. It has a
> > topology that's similar enough to that of PCI so that the same general
> > rules could be applied.
> >=20
> > If that's really the only thing that keeps rfkill from gaining DT
> > support then it's something worth tackling in my opinion.
>=20
> it's not so simple I fear. The wifi driver needs to learn about the rfkil=
l=20
> "device".

Why does the WiFi driver need to know about it? You say below that the
WiFi driver polls a separate set of GPIO lines (internal to the WiFi
module I assume?). In that case rfkill is merely a way to export control
of that functionality so that it can be used from some other part of the
kernel or from userspace.

That's very similar to things such as backlight control or fan control.
Still we manage to describe those in DT as well.

> As mentioned above, it's not really a device so the question is what=20
> needs to be added and where? The wifi driver just polls his own gpio line=
s to=20
> check the status of rfkill. Be we want to modify the "other side", so may=
be=20
> this isn't related to the wifi driver at all. It's more a "virtual rfkill=
=20
> device". No idea if something like this exists already in device tree.

But it's a part of some other device. Or rather, it's always associated
with another device, right? So I don't see anything particularily wrong
with something like this:

	usb-controller {
		/* USB hub */
		usb@0,0 {
			...

			/* USB device */
			usb@1,0 {
				...

				rfkill {
					shutdown-gpio =3D <&gpio ...>;
					reset-gpio =3D <&gpio ...>;
				};

				...
			};

			...
		};
	};

You said that the main objection was that it needed to be represented as
a "subdevice" of whatever device it controls. If the only reason is that
we have no means to represent those devices because they are on a bus
that can be enumerated and therefore can't be listed in DT, then my
suggestion is to fix things so that we can describe those devices in DT.

The goal is to get rid of board files, right? board-paz00.c is the only
one left for Tegra, and rfkill is an actual hardware component, so there
is no reason why it can't be described in DT.

Thierry

--k1lZvvs/B4yU6o8G
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSlyO8AAoJEN0jrNd/PrOh8F4QALqaUuMfKpecn5Z6Xw4QCWgg
/wBz/ZlGEs3zx/a1ig05L6hmhw6YZGVMQ2yNhrATTXODbbeJB8Wm+F4lk7WRMV/L
CJpy2Zc0pHVFg3/n7KLFyKeHBJRJCJwSOwOXRnLjmWb5dc0lLwyMbcW0cKWI1wzX
k/nNVQJSUz+x/NAO5jgmv11XYeu48Nxgs0h9YDjY0uqUbYdRhmEnClt8h0b7bcdk
QlY2aJsufctK/fXiFNOrXTIPOT2hC547++KN3nCL3uQ6u/pXOYm3Jp3f623+mx2A
mTAVvvlh+m0pYCZG1zR0Oq4Oeh/gLEhrOdxZZQV7n6ZDD9BLcFZt495+lMVKUpBA
uW2LRVUUOfL/y+fo5TPGT4VGhsyKuBmNNtmveo1L+jKy974UYOfgpDmy8sPWzZt0
5mMy1clGOp9iea+7KGTOKtXkpcMOAmy3QvxGEuhwlrF3Ui+/iRrVAJ/Ql55tiXgB
Ty/uI6Rl/ztbWgPs66axn2YGEHbfoLLv9PQ/k6rXXNGEjYgHEOx2BhcD0FJhNks8
NC2kchVnDW14YxQBwUJwEjHqY2UdiHrwgryv1m2+42Xd2s/+F8yrIhyWgR2HHDhd
SqZW81/Uz2M9X62UotpWqGU9wEiY4OfwbWPCyh9xnD+dC4sLJlb9YAWfGJEubzzn
UB6/qAMJb933c2UHFJ55
=jDA2
-----END PGP SIGNATURE-----

--k1lZvvs/B4yU6o8G--
