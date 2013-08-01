Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755863Ab3HANqg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 09:46:36 -0400
Received: from vm1.sequanux.org ([188.165.36.56]:53835 "EHLO vm1.sequanux.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755414Ab3HANqf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 09:46:35 -0400
Date: Thu, 1 Aug 2013 15:46:32 +0200
From: Simon Guinot <simon.guinot@sequanux.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Grant Likely <grant.likely@secretlab.ca>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Guenter Roeck <linux@roeck-us.net>
Subject: Re: [PATCH v3] gpio: add GPIO support for F71882FG and F71889F
Message-ID: <20130801134632.GY9916@kw.sim.vm.gnt>
References: <1374486633-9737-1-git-send-email-simon.guinot@sequanux.org>
 <CACRpkda2bH_TkFR6c0cXvjye4SmFWN5xuzQSO=NqBq8mNDgV0g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="1RftZa7o64Huaoir"
Content-Disposition: inline
In-Reply-To: <CACRpkda2bH_TkFR6c0cXvjye4SmFWN5xuzQSO=NqBq8mNDgV0g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--1RftZa7o64Huaoir
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 29, 2013 at 05:59:08PM +0200, Linus Walleij wrote:
> On Mon, Jul 22, 2013 at 11:50 AM, Simon Guinot
> <simon.guinot@sequanux.org> wrote:
>=20
> > This patch adds support for the GPIOs found on the Fintek super-I/O
> > chips F71882FG and F71889F.
> >
> > A super-I/O is a legacy I/O controller embedded on x86 motherboards. It
> > is used to connect the low-bandwidth devices. Among others functions the
> > F71882FG/F71889F provides: a parallel port, two serial ports, a keyboard
> > controller, an hardware monitoring controller and some GPIO pins.
> >
> > Note that this super-I/Os are embedded on some Atom-based LaCie NASes.
> > The GPIOs are used to control the LEDs and the hard drive power.
> >
> > Signed-off-by: Simon Guinot <simon.guinot@sequanux.org>
> > ---
> > Changes since v2:
> > - Remove useless NULL setters for driver data.

Hi Linus,

>=20
> Given the recent discussion with Rafael I want to have an
> extended discussion of this patch.
>=20
> It is my current understanding that:
>=20
> - It is possible to define the whereabouts of the SuperIO
>   chips using ACPI

Agreed.

> - It is possible for developers to influence the source
>   AML for the DSDT tables of these systems.

I am not sure about that. Let's consider the LaCie x86-based boards.
LaCie only adds a few devices on the top of a motherboard provided by
an another manufacturer. In turns, this last gets a Super-I/O from an
another manufacturer. In my understanding, the Super-I/O manufacturer is
responsible for registering the PNP IDs (one per device functionality).

LaCie may have enough leverage to obtain some modifications on the ACPI
DSDT tables but about the PNP IDs registration, let's say it is less
that certain. The problem is that LaCie don't have any contacts with the
Super-I/O manufacturer.

I have to say that all this process is not as easy as adding a node in
a dts file.

> - It is the proper thing to do.

Yes, it may be.

> - So we should atleast support ACPI probing with the
>   port-based detection as a final fallback if all else fails.
>=20
> Why can I not get something like:
>=20
> #include <linux/acpi.h>
> (...)
> static const struct acpi_device_id gpio_acpi_match[] =3D {
>         { "FOOBAR", 0 },

After some checks on my boards, it appears that there is no PNP ID
available for the Super-I/O GPIO functionality (or any others). Moreover
I think this IDs don't have been registered to Microsoft by Fintech
(the super-I/O manufacturer).

How do you envisage the follow-up ?

>         { }
> };
> MODULE_DEVICE_TABLE(acpi, gpio_acpi_match);
>=20
> static struct platform_driver gpio_driver =3D {
>         (...)
>         .driver         =3D {
>                  (...)
>                 .acpi_match_table =3D ACPI_PTR(gpio_acpi_match),
>         },
> };

It seems to me that the ACPI probing is the easiest part. How do you see
the ioport probing fallback ?

I can only figure out broken solutions:

1. From the init function, we could check that the PNP IDs are well
   available in the ACPI DSDT tables before registering the platform
   driver. If not, we could fall back on the ioport probing method.
   I don't know if checking the DSDT tables is even possible. It is at
   least weird and it defeats completely the purpos of acpi_match_table.
2. In a late initcall, we could check that the driver is well
   registered else fall back on the ioport detection.
   As GPIOs may be needed early, I don't think this method is suitable.

And I have no more ideas...

Please, help me to find a correct way to combine this probing methods.

>=20
> ?
>=20
> If there is something wrong in my reasoning above, please
> share it!

I'd rather say that your reasoning adds some difficulties :)

Thanks,

Simon

--1RftZa7o64Huaoir
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlH6ZrgACgkQgtp0PDeOcDr25ACeIyOZsoLjb5UnrwAzJUt/kmoz
sAcAniTfAXgH8EUQknPD0cvNDobZa3k2
=Rae9
-----END PGP SIGNATURE-----

--1RftZa7o64Huaoir--
