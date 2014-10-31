Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933482AbaJaNUd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 09:20:33 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:43268 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751323AbaJaNUc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 09:20:32 -0400
Date: Fri, 31 Oct 2014 08:20:05 -0500
From: Felipe Balbi <balbi@ti.com>
To: Linus Walleij <linus.walleij@linaro.org>
CC: Felipe Balbi <balbi@ti.com>, David Cohen <david.a.cohen@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH] pinctrl: baytrail: show output gpio state correctly on
 Intel Baytrail
Message-ID: <20141031132005.GB1273@saruman>
Reply-To: <balbi@ti.com>
References: <1412355319-18946-1-git-send-email-david.a.cohen@linux.intel.com>
 <1413224639-21552-1-git-send-email-david.a.cohen@linux.intel.com>
 <20141013191405.GB29810@saruman>
 <20141013192404.GB4034@psi-dev26.jf.intel.com>
 <20141013192632.GC29810@saruman>
 <20141013193618.GD29810@saruman>
 <CACRpkdYDiFvwsPwqACXS2bZU9peUyJEn-fpzVqZKYXseuEFGGA@mail.gmail.com>
 <20141028144249.GD8123@saruman>
 <CACRpkdaN5hNWFUOFbHLm8HgZEKVSETUgVF4Cn4UbMQxNEg46Vw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="kORqDWCi7qDJ0mEj"
Content-Disposition: inline
In-Reply-To: <CACRpkdaN5hNWFUOFbHLm8HgZEKVSETUgVF4Cn4UbMQxNEg46Vw@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--kORqDWCi7qDJ0mEj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Oct 31, 2014 at 09:12:16AM +0100, Linus Walleij wrote:
> On Tue, Oct 28, 2014 at 3:42 PM, Felipe Balbi <balbi@ti.com> wrote:
> > On Tue, Oct 28, 2014 at 11:15:20AM +0100, Linus Walleij wrote:
> >> On Mon, Oct 13, 2014 at 9:36 PM, Felipe Balbi <balbi@ti.com> wrote:
> >> > On Mon, Oct 13, 2014 at 02:26:32PM -0500, Felipe Balbi wrote:
> >>
> >> > I also noticed that this is missing:
> >> >
> >> > diff --git a/drivers/pinctrl/pinctrl-baytrail.c b/drivers/pinctrl/pi=
nctrl-baytrail.c
> >> > index e12e5b0..7db5ab9 100644
> >> > --- a/drivers/pinctrl/pinctrl-baytrail.c
> >> > +++ b/drivers/pinctrl/pinctrl-baytrail.c
> >> > @@ -614,3 +614,9 @@ static int __init byt_gpio_init(void)
> >> >  }
> >> >
> >> >  subsys_initcall(byt_gpio_init);
> >> > +
> >> > +static void __exit byt_gpio_exit(void)
> >> > +{
> >> > +       platform_driver_unregister(&byt_gpio_driver);
> >> > +}
> >> > +module_exit(byt_gpio_exit);
> >>
> >> But the Baytrail driver is not a loadable module, it is bool:
> >>
> >> config PINCTRL_BAYTRAIL
> >>         bool "Intel Baytrail GPIO pin control"
> >>         depends on GPIOLIB && ACPI && X86
> >>
> >> (...)
> >>
> >> So I guess it won't need handling for removal, as it can only
> >> be compiled-in.
> >
> > you can still unbind it through sysfs, right ? The thing also already
> > provides a ->remove() method anyway.
>=20
> Yes you're right of course...
>=20
> But another way to get rid of the dilemma is to set
> .suppress_bind_attrs =3D true on the .driver field of the
> device driver. The one can't unbind it through sysfs anymore.
>=20
>         .driver =3D {
>                 .name   =3D "foo",
>                 .suppress_bind_attrs =3D true,
>         },
>=20
> So one of them need to be done.
>=20
> I suspect this is a kind of common problem...

so instead of taking of taking a three-liner which just makes sure this
can be used as "intended" you prefer to:

diff --git a/drivers/pinctrl/pinctrl-baytrail.c b/drivers/pinctrl/pinctrl-b=
aytrail.c
index e12e5b0..254ba81 100644
--- a/drivers/pinctrl/pinctrl-baytrail.c
+++ b/drivers/pinctrl/pinctrl-baytrail.c
@@ -587,16 +587,6 @@ static const struct acpi_device_id byt_gpio_acpi_match=
[] =3D {
 };
 MODULE_DEVICE_TABLE(acpi, byt_gpio_acpi_match);
=20
-static int byt_gpio_remove(struct platform_device *pdev)
-{
-	struct byt_gpio *vg =3D platform_get_drvdata(pdev);
-
-	pm_runtime_disable(&pdev->dev);
-	gpiochip_remove(&vg->chip);
-
-	return 0;
-}
-
 static struct platform_driver byt_gpio_driver =3D {
 	.probe          =3D byt_gpio_probe,
 	.remove         =3D byt_gpio_remove,
@@ -605,6 +595,7 @@ static struct platform_driver byt_gpio_driver =3D {
 		.owner  =3D THIS_MODULE,
 		.pm	=3D &byt_gpio_pm_ops,
 		.acpi_match_table =3D ACPI_PTR(byt_gpio_acpi_match),
+		.suppress_bind_attrs =3D true,
 	},
 };
=20

I don't quite care since this is not an architecture I work for, but I
prefer drivers which can be unbound one way or another. Not to mention
that there's already a ->remove callback on the platform_driver anyway.

--=20
balbi

--kORqDWCi7qDJ0mEj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUU4yFAAoJEIaOsuA1yqRE3scQAJUfzS3wiRnhk1MhnEuZyky3
u+BnmP+BJ+qscfAF38HIMTQRifV+JemDu8/lqXLPQCQH8Q3IkBhk9HR96boa/53M
nV/5dTH39a+LUpl8MeQEBBIWt/MBXeBaI9DLksGGziiUP+86OpP1VNakesjqtj53
tqMB2dVDx60i03i8g19FqPkHzKjwMFbUcDEY9RPwDLKhjO1mz6SQUxBEePM6Ws7e
grDgcDcRFq2B8blbSPTIExhxyCd+3RegABqIBm9OFeTMPQEbImXp5totuzzYGfcy
kSAsU2aDNNxNlwdtokk5Xt9KzugL8CdZ1hcPes1Nt6NtPy7rwf6NsqQZzV1Q/Y8g
U8J3Umtb0f1vXz96vJBIyTpahXdZSlTt0hvd/LwV2n2oEvHTy2103rIrNCZvQsaH
1VTiwqwO9SSSVw60Rzi92ZRyMhmEcv8ZXAUzd3LIr8uHSDQDXT7H/9BYWibemVmZ
FTkxV9PHGA8sbDWn4GQaGsiW2FfhKY6PX5QtL9SSabSpVhpZs44tk2TbDeVew2sH
jj9U7QOxR0uZ3yBZpmjtLpFA3JwyUYQh4/xtzda/xLa+9kOdpwp4HIK46fVnI1JP
okVda9H0TrveT3FY3ZogDwrOcVfQqgmuGoRkmViRRKi2LlSCJhqO4fCVWHWAH8Mj
wg4JSQd/4AqqYTHpNaeF
=btQh
-----END PGP SIGNATURE-----

--kORqDWCi7qDJ0mEj--
