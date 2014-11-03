Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753623AbaKCUlM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 15:41:12 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:54697 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752624AbaKCUlI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 15:41:08 -0500
Date: Mon, 3 Nov 2014 14:40:38 -0600
From: Felipe Balbi <balbi@ti.com>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
CC: Felipe Balbi <balbi@ti.com>, David Cohen <david.a.cohen@linux.intel.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        stable <stable@vger.kernel.org>, <mathias.nyman@linux.intel.com>
Subject: Re: [PATCH] pinctrl: baytrail: show output gpio state correctly on
 Intel Baytrail
Message-ID: <20141103204038.GB17356@saruman>
Reply-To: <balbi@ti.com>
References: <CACRpkdaN5hNWFUOFbHLm8HgZEKVSETUgVF4Cn4UbMQxNEg46Vw@mail.gmail.com>
 <20141031132005.GB1273@saruman>
 <20141031162339.GA7136@psi-dev26.jf.intel.com>
 <20141031184509.GA2224@psi-dev26.jf.intel.com>
 <20141103092402.GA1304@lahna.fi.intel.com>
 <20141103150048.GB27425@saruman>
 <20141103152743.GB1618@lahna.fi.intel.com>
 <20141103154207.GC1618@lahna.fi.intel.com>
 <20141103155011.GH27425@saruman>
 <20141103184247.GD1618@lahna.fi.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LpQ9ahxlCli8rRTG"
Content-Disposition: inline
In-Reply-To: <20141103184247.GD1618@lahna.fi.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--LpQ9ahxlCli8rRTG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Nov 03, 2014 at 08:42:47PM +0200, Mika Westerberg wrote:
> > > > > > > > I think adding the module exit + allowing this driver to be=
 a module
> > > > > > > > would be a good approach. Then we don't need to force gener=
ic x86 kernel
> > > > > > > > binaries to always have this driver. Unless Mathias or Mika=
 knows a
> > > > > > > > constraint to force this driver to be builtin only.
> > > > > > >=20
> > > > > > > It helps if I CC them when asking for feedback :)
> > > > > > >=20
> > > > > > > Mathias, Mika, do you know any constraint that forces pinctrl=
-baytrail
> > > > > > > to be bool?
> > > > > >=20
> > > > > > The only constraint that has been keeping this driver as bool i=
s that
> > > > > > some machines like, Asus T100, uses ACPI GPIO operation regions=
 for
> > > > > > toggling GPIOs to get things like sensor hub powered on. The GP=
IO
> > > > > > operation region code does not yet handle -EPROBE_DEFER so only=
 way to
> > > > > > ensure that the operation region is there is to have the driver=
 compiled
> > > > > > in to the kernel.
> > > > >=20
> > > > > But that's not enough excuse to have every single x86 in the mark=
et
> > > > > shipping with this driver. Think about a distro kernel, most like=
ly this
> > > > > gets enabled and it's wrong in 80% of the cases.
> > > >=20
> > > > True, but see below.
> > > >=20
> > > > > It would be nicer to add EPROBE_DEFER support, convert this into
> > > > > tristate and have default =3D M if BAYTRAIL, or something.
> > > >=20
> > > > If it were simple as that we would have done that already. Please c=
heck
> > > > drivers/gpio/gpiolib-acpi.c:acpi_gpio_adr_space_handler() and tell =
me
> > > > how we can do that.
> > >=20
> > > Actually the above is not the problem because we already have registe=
red
> > > the GPIO chip and hence we have the GPIO available to the firmware co=
de.
> >=20
> > what happens before you registered the gpio chip ? It takes some time
> > from head.S to gpiochip_irqchip_add(). Anywhere between that time,
> > firmware could try to access gpios and the same problem would occur.
>=20
> The operation region is not ready and the firmware does not try to use
> it. However, the subsys_initcall() is there just to be sure that the
> GPIO driver gets loaded before anything that is going to use GPIOs from
> firmware.

alright, so how does the firmware know that the operation region is
ready and why can't that be deferred until pinctrl-baytrail (module or
built-in) has finished probing ? That would sort both issues, would it
not ?

> > > The real problem is that if the ACPI GPIO operation handler is not th=
ere
> > > at the time firmware decides to do something it will just skip things
> > > that depend on the operation region. So if it has a GPIO that is used=
 to
> > > turn on sensor hub or touch panel or whatever, this will not be done =
and
> > > it results that the device in question might not work properly.
> >=20
> > that's an issue that needs solving, but forcing every x86 kernel to ship
> > with this driver, is not a proper solution.
>=20
> I would rather have the driver build in to the kernel now (and btw it
> has been already in mainline quite some time so I suspect many distros
> have already enabled it), than turning it module and render some devices
> that have been working previously, fail suddenly.

that's why I said you should default to Y if BAYTRAIL or make it
tristate and always default to M.

> There is a mechanism in ACPI to solve these issues, called _DEP, but it
> is still very much work in progress.

alright.

--=20
balbi

--LpQ9ahxlCli8rRTG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUV+hGAAoJEIaOsuA1yqREV8YP/1WTXTKb+2BjF1cLMetU6gKp
njzrGPpU1S+0H8HMzZsP2w+ZS/y8NB86xmc8sEQ3hVLB5UUYOdY4iXnVHHNgpn6h
cbHDIyJBo30vKPiwKwt/4QszCstBhVBu6K7uKIhxlIPmx/5iJ9js55L9qBtV0R6R
tRM+VcDgdJIcvtfgsgHznBupjm+3nirQ6AxlrZEIZ7A2e7a1KBvE8XXkIdRGZ600
NUnJO1Mkey/XSBgKCwF/poieVE335Sz27uJ+H3rO+qQkPr/WWUBPpAncp3ZTnvTS
37PuuWAw4xCbYiYrI6FykN+QJef6V/t1teNgZzrSewLm3RV1aNvOZfLtgF0vwNZs
fhb24h6UGOQCSzgpJk1i7Q1MDeXqvJeTI+uGcYQykJVDocb/OZm5LHOC6V22XEUd
QAe6PBPFfP1ybtd+Rj6rDKv16v0lSNhOA2HGXGtOGD9cmxTvbPV9KmM5xQgvvcFq
7Ecq31+BJc1LId+sKMKgxcknDN3+XDJ564L+vy+cuMAJpCG+d2cVsVXHhLKRsSDF
RjwA/P0/N1xcjEWGFJ0Ft8KvIbEI3XCsrnbWSe/AaTwkHMNgmeHeJ0BVQpg44bKc
k5KxXiHgjB3smF+ZOygbj2kZz8AOTVH/eGhKRega673gVQoJVvjiFFzG5LEjiauW
fy00FN8C6vxqgFQjlVlw
=eaQ2
-----END PGP SIGNATURE-----

--LpQ9ahxlCli8rRTG--
