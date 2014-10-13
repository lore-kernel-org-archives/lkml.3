Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753477AbaJMTg1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 15:36:27 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:48451 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753170AbaJMTgZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 15:36:25 -0400
Date: Mon, 13 Oct 2014 14:36:18 -0500
From: Felipe Balbi <balbi@ti.com>
To: Felipe Balbi <balbi@ti.com>
CC: David Cohen <david.a.cohen@linux.intel.com>, <linus.walleij@linaro.org>,
        <linux-kernel@vger.kernel.org>, <linux-gpio@vger.kernel.org>,
        <stable@vger.kernel.org>
Subject: Re: [PATCH] pinctrl: baytrail: show output gpio state correctly on
 Intel Baytrail
Message-ID: <20141013193618.GD29810@saruman>
Reply-To: <balbi@ti.com>
References: <1412355319-18946-1-git-send-email-david.a.cohen@linux.intel.com>
 <1413224639-21552-1-git-send-email-david.a.cohen@linux.intel.com>
 <20141013191405.GB29810@saruman>
 <20141013192404.GB4034@psi-dev26.jf.intel.com>
 <20141013192632.GC29810@saruman>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="uxuisgdDHaNETlh8"
Content-Disposition: inline
In-Reply-To: <20141013192632.GC29810@saruman>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--uxuisgdDHaNETlh8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 13, 2014 at 02:26:32PM -0500, Felipe Balbi wrote:
> Hi,
>=20
> On Mon, Oct 13, 2014 at 12:24:04PM -0700, David Cohen wrote:
> > On Mon, Oct 13, 2014 at 02:14:05PM -0500, Felipe Balbi wrote:
> > > On Mon, Oct 13, 2014 at 11:23:59AM -0700, David Cohen wrote:
> > > > Even if a gpio pin is set to output, we still need to set INPUT_EN =
bit
> > >=20
> > > here you say you're setting that bit.
> > >=20
> > > > to be able to read its value. Without this change, we'll always rea=
d low
> > > > level state.
> > > >=20
> > > > Cc: <stable@vger.kernel.org> # v3.14+
> > > > Signed-off-by: David Cohen <david.a.cohen@linux.intel.com>
> > > > ---
> > > >=20
> > > > Hi,
> > > >=20
> > > > I'm resending same v1 patch but now copying linux stable and linux =
gpio.
> > > > This patch is meant for all linux stable trees >=3D v3.14.
> > > >=20
> > > > Br, David
> > > > ---
> > > >=20
> > > >  drivers/pinctrl/pinctrl-baytrail.c | 2 +-
> > > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > >=20
> > > > diff --git a/drivers/pinctrl/pinctrl-baytrail.c b/drivers/pinctrl/p=
inctrl-baytrail.c
> > > > index e12e5b07f6d7..c23d8ded936d 100644
> > > > --- a/drivers/pinctrl/pinctrl-baytrail.c
> > > > +++ b/drivers/pinctrl/pinctrl-baytrail.c
> > > > @@ -318,7 +318,7 @@ static int byt_gpio_direction_output(struct gpi=
o_chip *chip,
> > > >  		"Potential Error: Setting GPIO with direct_irq_en to output");
> > > > =20
> > > >  	reg_val =3D readl(reg) | BYT_DIR_MASK;
> > > > -	reg_val &=3D ~BYT_OUTPUT_EN;
> > > > +	reg_val &=3D ~(BYT_OUTPUT_EN | BYT_INPUT_EN);
> > >=20
> > > but code is clearing it. Also, you're not patching byt_gpio_get(), so
> > > you can't be 'reading its value' either. Quite frankly, this looks ve=
ry
> > > fishy to me. Comments on BYT_OUTPUT_EN and BYT_INPUT_EN states that
> > > those bits are active low, meaning that clearing them enables that
> > > particular feature.
> > >=20
> > > How can you enable a pin to be both OUTPUT and INPUT ? Look like what
> > > you really want is:
> > >=20
> > > diff --git a/drivers/pinctrl/pinctrl-baytrail.c b/drivers/pinctrl/pin=
ctrl-baytrail.c
> > > index e12e5b0..69f882d 100644
> > > --- a/drivers/pinctrl/pinctrl-baytrail.c
> > > +++ b/drivers/pinctrl/pinctrl-baytrail.c
> > > @@ -290,6 +290,7 @@ static int byt_gpio_direction_input(struct gpio_c=
hip *chip, unsigned offset)
> > > =20
> > >  	value =3D readl(reg) | BYT_DIR_MASK;
> > >  	value &=3D ~BYT_INPUT_EN;		/* active low */
> > > +	value |=3D BYT_OUTPUT_EN;		/* disable output */
> > >  	writel(value, reg);
> > > =20
> > >  	spin_unlock_irqrestore(&vg->lock, flags);
> > > @@ -319,6 +320,7 @@ static int byt_gpio_direction_output(struct gpio_=
chip *chip,
> > > =20
> > >  	reg_val =3D readl(reg) | BYT_DIR_MASK;
> > >  	reg_val &=3D ~BYT_OUTPUT_EN;
> > > +	value |=3D BYT_INPUT_EN;		/* disable input */
> > > =20
> > >  	if (value)
> > >  		writel(reg_val | BYT_LEVEL, reg);
> > >=20
> > > completely untested however. Care to further explain why clearing both
> > > bits - thus enabling both INPUT and OUTPUT - is correct ?
> >=20
> > Actually I really meant what I sent, but perhaps I misspoke during
> > explanation. We need to clear the bit to enable the functionality.
> >=20
> > !BYT_INPUT_EN allows us to read the value. !BYT_OUTPUT_EN allows us to
> > set a value. If we want to set a value (acting as output) and still be
> > able to read via sysfs, we need to set both functionality (i.e. clear
> > both bits).
> >=20
> > I'll resend the patch with a better comment.
>=20
> Alright, just make sure that exposing a pin through sysfs and making it
> output high, then later switching it to input works. It looks like
> byt_gpio_direction_input() still needs to make sure OUTPUT is set.

I also noticed that this is missing:

diff --git a/drivers/pinctrl/pinctrl-baytrail.c b/drivers/pinctrl/pinctrl-b=
aytrail.c
index e12e5b0..7db5ab9 100644
--- a/drivers/pinctrl/pinctrl-baytrail.c
+++ b/drivers/pinctrl/pinctrl-baytrail.c
@@ -614,3 +614,9 @@ static int __init byt_gpio_init(void)
 }
=20
 subsys_initcall(byt_gpio_init);
+
+static void __exit byt_gpio_exit(void)
+{
+	platform_driver_unregister(&byt_gpio_driver);
+}
+module_exit(byt_gpio_exit);

(also untested)

ps: is BayTrail documentation available publicly ?

--=20
balbi

--uxuisgdDHaNETlh8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUPCmyAAoJEIaOsuA1yqREr6wQAJmkoO9EipDtd/iq4yDMDu99
MZ3llqigUFsqPF/2u+GJOutwPdCHxYvW4/BV8m/1SVXW2bxpb2sYzkO/LpZFZy3O
WvxZg8bM8YPP+KQlVefF2FkVd/1S/OdajwojZ4K14wh7SkmSwqsa2ivk0yG7V02w
K1OiGYiYi6jISFS/ZAYzRSPJT2htprJYylGa9vx9dYQMJZHtkuD4CUSEcEnoFubU
q9MfEdKPZgDEMPSkrbBJGlzZpOJJXc6lcd3dKCQja4HwRSMlW8nhAO6fvSK+LJc8
h0Pgdg6nZxab7qSXr50q4elaXny51t3aNnlIlSk1Qdg/m4EBIMGd3XDI/KhlPTHX
PTimoWnCQEaoqJ+ReynFuhOkSfTCsurlo3oTAhf+rUKfDVodwe/3YbibMH8QszcC
BoT8CT9bYhJESPOPFH+aLLIU405nIfRQxzKcWN6u+5wXYQQly5y9PZXL8u4Dp+M5
frIc5b/f5A+Pglp9h+jVXCtOGu7kTlAACRya2K1IBVuLqkCFucbgbPZZ4AztpKkj
BYQwqpxejwClvPuszFN2Y1bnAgtRBJsCQHcnkYAh6G3Ax7LD94DBYZdngmVnJo8M
zyQFpTtDqx90Ukpy7Hxb5CR4CZM8riI1lbOOkwi1oFQWpAGOQ0cXUUawTesV3wnz
4Uxdw+80av++0Rwz+721
=49XI
-----END PGP SIGNATURE-----

--uxuisgdDHaNETlh8--
