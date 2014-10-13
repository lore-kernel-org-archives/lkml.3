Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754797AbaJMTOT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 15:14:19 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:47637 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754236AbaJMTOS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 15:14:18 -0400
Date: Mon, 13 Oct 2014 14:14:05 -0500
From: Felipe Balbi <balbi@ti.com>
To: David Cohen <david.a.cohen@linux.intel.com>
CC: <linus.walleij@linaro.org>, <linux-kernel@vger.kernel.org>,
        <linux-gpio@vger.kernel.org>, <stable@vger.kernel.org>
Subject: Re: [PATCH] pinctrl: baytrail: show output gpio state correctly on
 Intel Baytrail
Message-ID: <20141013191405.GB29810@saruman>
Reply-To: <balbi@ti.com>
References: <1412355319-18946-1-git-send-email-david.a.cohen@linux.intel.com>
 <1413224639-21552-1-git-send-email-david.a.cohen@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="XOIedfhf+7KOe/yw"
Content-Disposition: inline
In-Reply-To: <1413224639-21552-1-git-send-email-david.a.cohen@linux.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--XOIedfhf+7KOe/yw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 13, 2014 at 11:23:59AM -0700, David Cohen wrote:
> Even if a gpio pin is set to output, we still need to set INPUT_EN bit

here you say you're setting that bit.

> to be able to read its value. Without this change, we'll always read low
> level state.
>=20
> Cc: <stable@vger.kernel.org> # v3.14+
> Signed-off-by: David Cohen <david.a.cohen@linux.intel.com>
> ---
>=20
> Hi,
>=20
> I'm resending same v1 patch but now copying linux stable and linux gpio.
> This patch is meant for all linux stable trees >=3D v3.14.
>=20
> Br, David
> ---
>=20
>  drivers/pinctrl/pinctrl-baytrail.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/pinctrl/pinctrl-baytrail.c b/drivers/pinctrl/pinctrl=
-baytrail.c
> index e12e5b07f6d7..c23d8ded936d 100644
> --- a/drivers/pinctrl/pinctrl-baytrail.c
> +++ b/drivers/pinctrl/pinctrl-baytrail.c
> @@ -318,7 +318,7 @@ static int byt_gpio_direction_output(struct gpio_chip=
 *chip,
>  		"Potential Error: Setting GPIO with direct_irq_en to output");
> =20
>  	reg_val =3D readl(reg) | BYT_DIR_MASK;
> -	reg_val &=3D ~BYT_OUTPUT_EN;
> +	reg_val &=3D ~(BYT_OUTPUT_EN | BYT_INPUT_EN);

but code is clearing it. Also, you're not patching byt_gpio_get(), so
you can't be 'reading its value' either. Quite frankly, this looks very
fishy to me. Comments on BYT_OUTPUT_EN and BYT_INPUT_EN states that
those bits are active low, meaning that clearing them enables that
particular feature.

How can you enable a pin to be both OUTPUT and INPUT ? Look like what
you really want is:

diff --git a/drivers/pinctrl/pinctrl-baytrail.c b/drivers/pinctrl/pinctrl-b=
aytrail.c
index e12e5b0..69f882d 100644
--- a/drivers/pinctrl/pinctrl-baytrail.c
+++ b/drivers/pinctrl/pinctrl-baytrail.c
@@ -290,6 +290,7 @@ static int byt_gpio_direction_input(struct gpio_chip *c=
hip, unsigned offset)
=20
 	value =3D readl(reg) | BYT_DIR_MASK;
 	value &=3D ~BYT_INPUT_EN;		/* active low */
+	value |=3D BYT_OUTPUT_EN;		/* disable output */
 	writel(value, reg);
=20
 	spin_unlock_irqrestore(&vg->lock, flags);
@@ -319,6 +320,7 @@ static int byt_gpio_direction_output(struct gpio_chip *=
chip,
=20
 	reg_val =3D readl(reg) | BYT_DIR_MASK;
 	reg_val &=3D ~BYT_OUTPUT_EN;
+	value |=3D BYT_INPUT_EN;		/* disable input */
=20
 	if (value)
 		writel(reg_val | BYT_LEVEL, reg);

completely untested however. Care to further explain why clearing both
bits - thus enabling both INPUT and OUTPUT - is correct ?

--=20
balbi

--XOIedfhf+7KOe/yw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUPCR9AAoJEIaOsuA1yqREhbUP/218r1tB0ToV/u23D6ex4tcS
xXP80QOhH77OibNz2ngUBN/z2zvrsIFiVvjdPA2GobtT5/28Am95yRa44c++k0Su
Fl0VZ12ApLw4XTjLBhcB22U/b+OcK4ivHIVKnsb8qfOGfuWU0MJPURGJ7mPMk+6K
AZgOI5Ga0wFO7f2OP+6ysMvtawd8DKvoir01u8d9GXJvoCMLo8PggkIoCwIs44cL
bc0ebHQMjZwuqP8LbHI8FECnpzOEOjN3NcR2oAGYK7HuRfFVZAXbngHKijURT/dy
Kge1eurm7fMEsdpQC2Ho37PQskcB/XMz8Tw529EzIi1YeyHDKqlp33WnvGyOjuYk
Cjt2G1r/rCupxtbKZYMyAFinux5A7CsNrqFlIJYeYPBJ07Vy8whSCf4s6HnJWcm0
o18ifAcjKs7KdNBcEQhY6ubTDxtBg5xNrCHpP4DpPN9y0NtDoIjgTxK85BepfdbP
/zDISI0yDgwxsZggsqhgHvFicMdL96bpCAtaFYo54XoK5RG4FrBcJf2r9RRfIw3y
r4pd1B0In0XMBJy39lENoerCT9lpWMLGwqXxZjHTqM9vXQMADh6ZKg4Ql7V6Wuuf
Pjikw8FrKBM+w9UtTq9E9XNXyNjq55PhcxLsP/I39LnxDOORvr2UFG/OTRpKdmJt
3VROP+Eow4syCXJKprdW
=u+Fe
-----END PGP SIGNATURE-----

--XOIedfhf+7KOe/yw--
