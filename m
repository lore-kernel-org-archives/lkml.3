Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753609AbaJMT0n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 15:26:43 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:37118 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752116AbaJMT0l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 15:26:41 -0400
Date: Mon, 13 Oct 2014 14:26:32 -0500
From: Felipe Balbi <balbi@ti.com>
To: David Cohen <david.a.cohen@linux.intel.com>
CC: Felipe Balbi <balbi@ti.com>, <linus.walleij@linaro.org>,
        <linux-kernel@vger.kernel.org>, <linux-gpio@vger.kernel.org>,
        <stable@vger.kernel.org>
Subject: Re: [PATCH] pinctrl: baytrail: show output gpio state correctly on
 Intel Baytrail
Message-ID: <20141013192632.GC29810@saruman>
Reply-To: <balbi@ti.com>
References: <1412355319-18946-1-git-send-email-david.a.cohen@linux.intel.com>
 <1413224639-21552-1-git-send-email-david.a.cohen@linux.intel.com>
 <20141013191405.GB29810@saruman>
 <20141013192404.GB4034@psi-dev26.jf.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="vOmOzSkFvhd7u8Ms"
Content-Disposition: inline
In-Reply-To: <20141013192404.GB4034@psi-dev26.jf.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--vOmOzSkFvhd7u8Ms
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Oct 13, 2014 at 12:24:04PM -0700, David Cohen wrote:
> On Mon, Oct 13, 2014 at 02:14:05PM -0500, Felipe Balbi wrote:
> > On Mon, Oct 13, 2014 at 11:23:59AM -0700, David Cohen wrote:
> > > Even if a gpio pin is set to output, we still need to set INPUT_EN bit
> >=20
> > here you say you're setting that bit.
> >=20
> > > to be able to read its value. Without this change, we'll always read =
low
> > > level state.
> > >=20
> > > Cc: <stable@vger.kernel.org> # v3.14+
> > > Signed-off-by: David Cohen <david.a.cohen@linux.intel.com>
> > > ---
> > >=20
> > > Hi,
> > >=20
> > > I'm resending same v1 patch but now copying linux stable and linux gp=
io.
> > > This patch is meant for all linux stable trees >=3D v3.14.
> > >=20
> > > Br, David
> > > ---
> > >=20
> > >  drivers/pinctrl/pinctrl-baytrail.c | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > >=20
> > > diff --git a/drivers/pinctrl/pinctrl-baytrail.c b/drivers/pinctrl/pin=
ctrl-baytrail.c
> > > index e12e5b07f6d7..c23d8ded936d 100644
> > > --- a/drivers/pinctrl/pinctrl-baytrail.c
> > > +++ b/drivers/pinctrl/pinctrl-baytrail.c
> > > @@ -318,7 +318,7 @@ static int byt_gpio_direction_output(struct gpio_=
chip *chip,
> > >  		"Potential Error: Setting GPIO with direct_irq_en to output");
> > > =20
> > >  	reg_val =3D readl(reg) | BYT_DIR_MASK;
> > > -	reg_val &=3D ~BYT_OUTPUT_EN;
> > > +	reg_val &=3D ~(BYT_OUTPUT_EN | BYT_INPUT_EN);
> >=20
> > but code is clearing it. Also, you're not patching byt_gpio_get(), so
> > you can't be 'reading its value' either. Quite frankly, this looks very
> > fishy to me. Comments on BYT_OUTPUT_EN and BYT_INPUT_EN states that
> > those bits are active low, meaning that clearing them enables that
> > particular feature.
> >=20
> > How can you enable a pin to be both OUTPUT and INPUT ? Look like what
> > you really want is:
> >=20
> > diff --git a/drivers/pinctrl/pinctrl-baytrail.c b/drivers/pinctrl/pinct=
rl-baytrail.c
> > index e12e5b0..69f882d 100644
> > --- a/drivers/pinctrl/pinctrl-baytrail.c
> > +++ b/drivers/pinctrl/pinctrl-baytrail.c
> > @@ -290,6 +290,7 @@ static int byt_gpio_direction_input(struct gpio_chi=
p *chip, unsigned offset)
> > =20
> >  	value =3D readl(reg) | BYT_DIR_MASK;
> >  	value &=3D ~BYT_INPUT_EN;		/* active low */
> > +	value |=3D BYT_OUTPUT_EN;		/* disable output */
> >  	writel(value, reg);
> > =20
> >  	spin_unlock_irqrestore(&vg->lock, flags);
> > @@ -319,6 +320,7 @@ static int byt_gpio_direction_output(struct gpio_ch=
ip *chip,
> > =20
> >  	reg_val =3D readl(reg) | BYT_DIR_MASK;
> >  	reg_val &=3D ~BYT_OUTPUT_EN;
> > +	value |=3D BYT_INPUT_EN;		/* disable input */
> > =20
> >  	if (value)
> >  		writel(reg_val | BYT_LEVEL, reg);
> >=20
> > completely untested however. Care to further explain why clearing both
> > bits - thus enabling both INPUT and OUTPUT - is correct ?
>=20
> Actually I really meant what I sent, but perhaps I misspoke during
> explanation. We need to clear the bit to enable the functionality.
>=20
> !BYT_INPUT_EN allows us to read the value. !BYT_OUTPUT_EN allows us to
> set a value. If we want to set a value (acting as output) and still be
> able to read via sysfs, we need to set both functionality (i.e. clear
> both bits).
>=20
> I'll resend the patch with a better comment.

Alright, just make sure that exposing a pin through sysfs and making it
output high, then later switching it to input works. It looks like
byt_gpio_direction_input() still needs to make sure OUTPUT is set.

--=20
balbi

--vOmOzSkFvhd7u8Ms
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUPCdoAAoJEIaOsuA1yqRE6V4QAJrDdR8OCm+lsv/ZLT2gmDVF
1c9P92J5bLiwfQxwjGrFdyBklZ0mFI/4cohFJE+oSLsZ4N0myaAJbaeM8WT0PjBX
8szRZpNmypwjrbGp9qU3tCsOxFCdDU2wQz++y4Nwr6GxOxAtXDn8bIe0Z9MSJA7v
JHTWnf43r6qQ5KhKdtyPjyJrh91WnC3rnBgllJKKZb5SCrVb1WR9fNPC1GuN6gJQ
3LRkcVbEj88QhQsL0pp0jv5Ee8j9sW5/V7cUi8Y96JNnuBQ3o6KQhxze/LB3wbl3
2pzCCFz488PXbAtzLWHboT6MRKJquimjcYhTemYTaH5AqcX+YdDPgt3tkPr1E3aR
qc5QDXJyL+agzZ3iBfySBoD1CevKd9heVI3r0bLt+GvsYkxHVARUHnVZ6JYnl8Vq
LkfR8ShAFwuU6gA1JhjVIC0SBQzWvPgZFt6KOZ/HiIp1Vk5AhdGknfxK8H+Lc1C/
HYHHRVB7zT5w2M+YwIk9Br8t7HswwC0sG2IpqpHrlImps3q7/uOBUDF/h6cwkpr+
jkk3PglSRYTLYpSr2vvvxhU5fd+OQLDAom9OPhm3GMPG+ugaiSCV9CxpemgNktTQ
1XOkijEo+417dGpJ8EMvr7HtCNi3tMY7pbjRmI/uA+rxwq3560KRvQVWwDdSLauB
6umnGkhLAM0TE2i4IM86
=UJ+x
-----END PGP SIGNATURE-----

--vOmOzSkFvhd7u8Ms--
