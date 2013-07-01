Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753669Ab3GAQ2y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 12:28:54 -0400
Received: from vm1.sequanux.org ([188.165.36.56]:44535 "EHLO vm1.sequanux.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751386Ab3GAQ2x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 12:28:53 -0400
Date: Mon, 1 Jul 2013 18:28:50 +0200
From: Simon Guinot <simon.guinot@sequanux.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Vincent Donnefort <vdonnefort@gmail.com>
Subject: Re: [PATCH] gpio: add GPIO support for F71882FG and F71889F
Message-ID: <20130701162849.GF10726@kw.sim.vm.gnt>
References: <1372247816-5590-1-git-send-email-simon.guinot@sequanux.org>
 <CACRpkda=BBo+yUcUorYQQasKaF68neSz8cVmq3PcwLGPY_FjtA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="sDKAb4OeUBrWWL6P"
Content-Disposition: inline
In-Reply-To: <CACRpkda=BBo+yUcUorYQQasKaF68neSz8cVmq3PcwLGPY_FjtA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--sDKAb4OeUBrWWL6P
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Jun 30, 2013 at 01:35:00AM +0200, Linus Walleij wrote:

Hi Linus,

> On Wed, Jun 26, 2013 at 1:56 PM, Simon Guinot <simon.guinot@sequanux.org>=
 wrote:
>=20
> > This patch adds support for the GPIOs found on the Fintek Super-I/O
> > chips F71882FG and F71889F.
> >
> > Signed-off-by: Simon Guinot <simon.guinot@sequanux.org>
>=20
> Please be more elaborate in the commit message. What kind of beast
> is a Super-I/O chip? Which architecture is this? Some SoC?
> ISA card? etc. References are made to ACPI so I'm just half-guessing...

OK.

>=20
> > +++ b/drivers/gpio/gpio-f7188x.c
>=20
> > +#define gpio_oe_reg(base) (base + 0)
> > +#define gpio_od_reg(base) (base + 1)
> > +#define gpio_st_reg(base) (base + 2)
> > +#define gpio_de_reg(base) (base + 3)
>=20
> What are these four things?
>=20
> Output enable, open drain, ...?

I realize I don't have picked self-explanatory macro names :)

oe: output enable
od: output data
st: pin status
de: driver enable

I will fix that for the next version.

>=20
> > +static int __init
> > +f7188x_gpio_device_add(const struct f7188x_sio *sio)
> > +{
> > +       int err;
> > +
> > +       f7188x_gpio_pdev =3D platform_device_alloc(DRVNAME, -1);
> > +       if (!f7188x_gpio_pdev)
> > +               return -ENOMEM;
> > +
> > +       err =3D platform_device_add_data(f7188x_gpio_pdev,
> > +                                      sio, sizeof(*sio));
> > +       if (err) {
> > +               pr_err(DRVNAME "Platform data allocation failed\n");
> > +               goto err;
> > +       }
> > +
> > +       err =3D platform_device_add(f7188x_gpio_pdev);
> > +       if (err) {
> > +               pr_err(DRVNAME "Device addition failed\n");
> > +               goto err;
> > +       }
> > +
> > +       return 0;
> > +
> > +err:
> > +       platform_device_put(f7188x_gpio_pdev);
> > +
> > +       return err;
> > +}
>=20
> You need to explain with some comment here what is happening
> here. You auto-probe then spawn some devices?

Yes, that's what we are doing here. I will add some comments to explain
that.

>=20
> > +static struct platform_driver f7188x_gpio_driver =3D {
> > +       .driver =3D {
> > +               .owner  =3D THIS_MODULE,
> > +               .name   =3D DRVNAME,
> > +       },
> > +       .probe          =3D f7188x_gpio_probe,
> > +       .remove         =3D f7188x_gpio_remove,
> > +};
> > +
> > +static int __init f7188x_gpio_init(void)
> > +{
> > +       int err;
> > +       struct f7188x_sio sio;
> > +
> > +       if (f7188x_find(0x2e, &sio) &&
> > +           f7188x_find(0x4e, &sio))
> > +               return -ENODEV;
>=20
> This looks like the life on the ISA-bus. Is that not dangerous?

I guess this looks like the ISA bus because this super-I/O uses the LPC
bus which is ISA-compatible. At my knowledge, reading this I/O ports
and trying to match the vendor and device IDs is the only way to
identify the super-I/O chip. For example, have a look at the drivers
f71882fg (hwmon) and f71808e_wdt (watchdog). Both are using the same
identification mechanism.

>=20
> > +
> > +       err =3D platform_driver_register(&f7188x_gpio_driver);
> > +       if (!err) {
> > +               err =3D f7188x_gpio_device_add(&sio);
> > +               if (err)
> > +                       platform_driver_unregister(&f7188x_gpio_driver);
> > +       }
> > +
> > +       return err;
> > +}
> > +subsys_initcall(f7188x_gpio_init);
>=20
> And this is called unconditionally. Don't you get hints from
> ACPI (given you include that header) as to whether this needs
> to be registered or not?

At my limited knowledge, ACPI is not helpful here. This also points out
an another problem. The ACPI header is not used by this driver... I will
remove it for the next version.

>=20
> It looks quite backwards. Isn't there *any* way to tell if the
> system actually has this thing?

This super-I/O is embedded on some LaCie x86-based NAS boards. The GPIOs
are used to control the LEDs and to power up/down the hard disks. All
this platform devices are not very common on x86 boards. They can't be
detected dynamically. One have to know they are available in order to
register their definitions. For x86, the arch/x86/platform/ directory
seems to be the right place to do that.

In a very same way, maybe we could handle the super-I/O GPIO chip as a
true platform device ? If a board needs it, then a static platform
device declaration should be added in the board setup file. This solves
the probe concern about sending inb/outb commands over a port maybe
owned by an unexpected device. As a drawback, the driver is no longer
usable standalone. Some extra platform code is required.

Let me know your advice.

Regards,

Simon

--sDKAb4OeUBrWWL6P
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlHRrkEACgkQgtp0PDeOcDowrQCfbx5wTJ6gq8xQVQilu2OEJJPN
AtQAn1PldJNUkeu8EnbR7ykhqP2/NTFp
=8B0e
-----END PGP SIGNATURE-----

--sDKAb4OeUBrWWL6P--
