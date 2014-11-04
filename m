Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754292AbaKDOn4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 09:43:56 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:41102 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752822AbaKDOny (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 09:43:54 -0500
Date: Tue, 4 Nov 2014 08:44:21 -0600
From: Felipe Balbi <balbi@ti.com>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
CC: Felipe Balbi <balbi@ti.com>, David Cohen <david.a.cohen@linux.intel.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        stable <stable@vger.kernel.org>, <mathias.nyman@linux.intel.com>
Subject: Re: [PATCH] pinctrl: baytrail: show output gpio state correctly on
 Intel Baytrail
Message-ID: <20141104144421.GC24983@saruman>
Reply-To: <balbi@ti.com>
References: <20141031162339.GA7136@psi-dev26.jf.intel.com>
 <20141031184509.GA2224@psi-dev26.jf.intel.com>
 <20141103092402.GA1304@lahna.fi.intel.com>
 <20141103150048.GB27425@saruman>
 <20141103152743.GB1618@lahna.fi.intel.com>
 <20141103154207.GC1618@lahna.fi.intel.com>
 <20141103155011.GH27425@saruman>
 <20141103184247.GD1618@lahna.fi.intel.com>
 <20141103204038.GB17356@saruman>
 <20141104075135.GE1618@lahna.fi.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2/5bycvrmDh4d1IB"
Content-Disposition: inline
In-Reply-To: <20141104075135.GE1618@lahna.fi.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--2/5bycvrmDh4d1IB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Nov 04, 2014 at 09:51:35AM +0200, Mika Westerberg wrote:
> > > > > > > > > > I think adding the module exit + allowing this driver t=
o be a module
> > > > > > > > > > would be a good approach. Then we don't need to force g=
eneric x86 kernel
> > > > > > > > > > binaries to always have this driver. Unless Mathias or =
Mika knows a
> > > > > > > > > > constraint to force this driver to be builtin only.
> > > > > > > > >=20
> > > > > > > > > It helps if I CC them when asking for feedback :)
> > > > > > > > >=20
> > > > > > > > > Mathias, Mika, do you know any constraint that forces pin=
ctrl-baytrail
> > > > > > > > > to be bool?
> > > > > > > >=20
> > > > > > > > The only constraint that has been keeping this driver as bo=
ol is that
> > > > > > > > some machines like, Asus T100, uses ACPI GPIO operation reg=
ions for
> > > > > > > > toggling GPIOs to get things like sensor hub powered on. Th=
e GPIO
> > > > > > > > operation region code does not yet handle -EPROBE_DEFER so =
only way to
> > > > > > > > ensure that the operation region is there is to have the dr=
iver compiled
> > > > > > > > in to the kernel.
> > > > > > >=20
> > > > > > > But that's not enough excuse to have every single x86 in the =
market
> > > > > > > shipping with this driver. Think about a distro kernel, most =
likely this
> > > > > > > gets enabled and it's wrong in 80% of the cases.
> > > > > >=20
> > > > > > True, but see below.
> > > > > >=20
> > > > > > > It would be nicer to add EPROBE_DEFER support, convert this i=
nto
> > > > > > > tristate and have default =3D M if BAYTRAIL, or something.
> > > > > >=20
> > > > > > If it were simple as that we would have done that already. Plea=
se check
> > > > > > drivers/gpio/gpiolib-acpi.c:acpi_gpio_adr_space_handler() and t=
ell me
> > > > > > how we can do that.
> > > > >=20
> > > > > Actually the above is not the problem because we already have reg=
istered
> > > > > the GPIO chip and hence we have the GPIO available to the firmwar=
e code.
> > > >=20
> > > > what happens before you registered the gpio chip ? It takes some ti=
me
> > > > from head.S to gpiochip_irqchip_add(). Anywhere between that time,
> > > > firmware could try to access gpios and the same problem would occur.
> > >=20
> > > The operation region is not ready and the firmware does not try to use
> > > it. However, the subsys_initcall() is there just to be sure that the
> > > GPIO driver gets loaded before anything that is going to use GPIOs fr=
om
> > > firmware.
> >=20
> > alright, so how does the firmware know that the operation region is
> > ready and why can't that be deferred until pinctrl-baytrail (module or
> > built-in) has finished probing ? That would sort both issues, would it
> > not ?
>=20
> The firmware checks the dependent object for AVBL or similar variable.
> If it is !=3D 0 it assumes that the operation region is there. The problem
> is how can you tell the firmware that it should somehow try again?
>=20
> Here _DEP is the right solution as it forces the dependencies to be
> loaded first.

alright.

> > > > > The real problem is that if the ACPI GPIO operation handler is no=
t there
> > > > > at the time firmware decides to do something it will just skip th=
ings
> > > > > that depend on the operation region. So if it has a GPIO that is =
used to
> > > > > turn on sensor hub or touch panel or whatever, this will not be d=
one and
> > > > > it results that the device in question might not work properly.
> > > >=20
> > > > that's an issue that needs solving, but forcing every x86 kernel to=
 ship
> > > > with this driver, is not a proper solution.
> > >=20
> > > I would rather have the driver build in to the kernel now (and btw it
> > > has been already in mainline quite some time so I suspect many distros
> > > have already enabled it), than turning it module and render some devi=
ces
> > > that have been working previously, fail suddenly.
> >=20
> > that's why I said you should default to Y if BAYTRAIL or make it
> > tristate and always default to M.
>=20
> So you are saying it is better to add config option BAYTRAIL and then
> make the driver Y? Well, now generic distros need to select that as Y
> which doesn't solve anything.

ok, so there's no differentiation for when you're building a baytrail
kernel, that's fine. Then it gets really difficult to do anything. I
guess you really need to to wait for _DEP.

--=20
balbi

--2/5bycvrmDh4d1IB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUWOZFAAoJEIaOsuA1yqREFo8QAID4IDLlwivxvr3dh30NwoQV
Vf5TpLmMRBJCs3lsNRKkwnQ0bvaTjx8X3Pe/UQwskvZNRkI+3COOHNHcJ2UsZOeS
IEwsBKCDKMAsMievQpTP3NFiWtpeTB4ZhoXVDV9q+ScobG7369HrbWJ4TnItEKuL
tgswVTqFs6ZZcKCs3zCzDU3Rv7BIUNrhstFbXBSFTb2G4rxzl+Khlt8pEsbpBAba
bARyM4ycLTKqP3DJj3OKqDz5RYllpVboTwCIfx//s6FJew0OwyV1+W/MwaQ5ePNE
U1i7Hg0LMOZdelAestF+PRDjt3GifYxRhwdFyqmf5laobPbP9mvM+znF1y6siul4
0uULvqZJnqsfeloXzVHNhri/M3eHrkPVrwqFqD9+CPRJbf9hJ7S6Itz+h5P0poF8
45KNllySygqrtXvomrle1xq5A4AL2OJ5RyEeZh3OywdpCXGlea3vWyKxNrSjS11h
tbl/5cqgPqUfUfTMa/2VJuV/ILfw+1uvF0jf7oRCN++Yzz9gkf+eEBPabKPilCrE
Q3MDq8TEwrpg6DdzQsgTsZdFuq90WkIspxuEyFTv8O4cJSb3EpJpx9MMWKwklHs/
/pFgfEOhQFg8rFUPGj8ZmBjLUz0r9mf7Xwfe9JHJiv7KKNVEfGwAszvj3fJBRRs7
xeUsHAhj85TYQfJ0bKzs
=Y2HU
-----END PGP SIGNATURE-----

--2/5bycvrmDh4d1IB--
