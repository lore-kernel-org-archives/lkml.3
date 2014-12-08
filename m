Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755971AbaLHRR5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 12:17:57 -0500
Received: from mailapp01.imgtec.com ([195.59.15.196]:31913 "EHLO
	imgpgp01.kl.imgtec.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751119AbaLHRRz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 12:17:55 -0500
X-PGP-Universal: processed;
	by imgpgp01.kl.imgtec.org on Mon, 08 Dec 2014 17:17:53 +0000
Message-ID: <5485DD40.60500@imgtec.com>
Date: Mon, 8 Dec 2014 17:17:52 +0000
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.8.0
MIME-Version: 1.0
To: Sifan Naeem <sifan.naeem@imgtec.com>, <mchehab@osg.samsung.com>
CC: <linux-kernel@vger.kernel.org>, <linux-media@vger.kernel.org>,
        <james.hartley@imgtec.com>, <ezequiel.garcia@imgtec.com>
Subject: Re: [PATCH 3/5] rc: img-ir: biphase enabled with workaround
References: <1417707523-7730-1-git-send-email-sifan.naeem@imgtec.com> <1417707523-7730-4-git-send-email-sifan.naeem@imgtec.com>
In-Reply-To: <1417707523-7730-4-git-send-email-sifan.naeem@imgtec.com>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="qt68giqhPrGgtOXp3UwhHfQTHkKsS4i9M"
X-Originating-IP: [192.168.154.101]
X-ESG-ENCRYPT-TAG: da4c5968
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--qt68giqhPrGgtOXp3UwhHfQTHkKsS4i9M
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 04/12/14 15:38, Sifan Naeem wrote:
> Biphase decoding in the current img-ir has got a quirk, where multiple
> Interrupts are generated when an incomplete IR code is received by the
> decoder.
>=20
> Patch adds a work around for the quirk and enables biphase decoding.
>=20
> Signed-off-by: Sifan Naeem <sifan.naeem@imgtec.com>
> ---
>  drivers/media/rc/img-ir/img-ir-hw.c |   56 +++++++++++++++++++++++++++=
++++++--
>  drivers/media/rc/img-ir/img-ir-hw.h |    2 ++
>  2 files changed, 55 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/media/rc/img-ir/img-ir-hw.c b/drivers/media/rc/img=
-ir/img-ir-hw.c
> index 4a1407b..a977467 100644
> --- a/drivers/media/rc/img-ir/img-ir-hw.c
> +++ b/drivers/media/rc/img-ir/img-ir-hw.c
> @@ -52,6 +52,11 @@ static struct img_ir_decoder *img_ir_decoders[] =3D =
{
> =20
>  #define IMG_IR_QUIRK_CODE_BROKEN	0x1	/* Decode is broken */
>  #define IMG_IR_QUIRK_CODE_LEN_INCR	0x2	/* Bit length needs increment *=
/
> +/*
> + * The decoder generates rapid interrupts without actually having
> + * received any new data after an incomplete IR code is decoded.
> + */
> +#define IMG_IR_QUIRK_CODE_IRQ		0x4
> =20
>  /* functions for preprocessing timings, ensuring max is set */
> =20
> @@ -547,6 +552,7 @@ static void img_ir_set_decoder(struct img_ir_priv *=
priv,
> =20
>  	/* stop the end timer and switch back to normal mode */
>  	del_timer_sync(&hw->end_timer);
> +	del_timer_sync(&hw->suspend_timer);

FYI, this'll need rebasing due to conflicting with "img-ir/hw: Fix
potential deadlock stopping timer". The new del_timer_sync will need to
be when spin lock isn't held, i.e. still next to the other one, and
don't forget to ensure that suspend_timer doesn't get started if
hw->stopping.

>  	hw->mode =3D IMG_IR_M_NORMAL;
> =20
>  	/* clear the wakeup scancode filter */
> @@ -843,6 +849,26 @@ static void img_ir_end_timer(unsigned long arg)
>  	spin_unlock_irq(&priv->lock);
>  }
> =20
> +/*
> + * Timer function to re-enable the current protocol after it had been
> + * cleared when invalid interrupts were generated due to a quirk in th=
e
> + * img-ir decoder.
> + */
> +static void img_ir_suspend_timer(unsigned long arg)
> +{
> +	struct img_ir_priv *priv =3D (struct img_ir_priv *)arg;
> +

You should take the spin lock for most of this function now that
"img-ir/hw: Fix potential deadlock stopping timer" is applied and it is
safe to do so.

> +	img_ir_write(priv, IMG_IR_IRQ_CLEAR,
> +			IMG_IR_IRQ_ALL & ~IMG_IR_IRQ_EDGE);
> +
> +	/* Don't set IRQ if it has changed in a different context. */

Wouldn't hurt to clarify this while you're at it (it confused me for a
moment thinking it was concerned about the enabled raw event IRQs
(IMG_IR_IRQ_EDGE) changing).

Maybe "Don't overwrite enabled valid/match IRQs if they have already
been changed by e.g. a filter change".

Should you even be clearing IRQs in that case? Maybe safer to just treat
that case as a "return immediately without touching anything" sort of
situation.

> +	if ((priv->hw.suspend_irqen & IMG_IR_IRQ_EDGE) =3D=3D
> +				img_ir_read(priv, IMG_IR_IRQ_ENABLE))
> +		img_ir_write(priv, IMG_IR_IRQ_ENABLE, priv->hw.suspend_irqen);
> +	/* enable */
> +	img_ir_write(priv, IMG_IR_CONTROL, priv->hw.reg_timings.ctrl);
> +}
> +
>  #ifdef CONFIG_COMMON_CLK
>  static void img_ir_change_frequency(struct img_ir_priv *priv,
>  				    struct clk_notifier_data *change)
> @@ -908,15 +934,37 @@ void img_ir_isr_hw(struct img_ir_priv *priv, u32 =
irq_status)
>  	if (!hw->decoder)
>  		return;
> =20
> +	ct =3D hw->decoder->control.code_type;
> +
>  	ir_status =3D img_ir_read(priv, IMG_IR_STATUS);
> -	if (!(ir_status & (IMG_IR_RXDVAL | IMG_IR_RXDVALD2)))
> +	if (!(ir_status & (IMG_IR_RXDVAL | IMG_IR_RXDVALD2))) {
> +		if (!(priv->hw.ct_quirks[ct] & IMG_IR_QUIRK_CODE_IRQ))

(I suggest adding "|| hw->stopping" to this case)

> +			return;
> +		/*
> +		 * The below functionality is added as a work around to stop
> +		 * multiple Interrupts generated when an incomplete IR code is
> +		 * received by the decoder.
> +		 * The decoder generates rapid interrupts without actually
> +		 * having received any new data. After a single interrupt it's
> +		 * expected to clear up, but instead multiple interrupts are
> +		 * rapidly generated. only way to get out of this loop is to
> +		 * reset the control register after a short delay.
> +		 */
> +		img_ir_write(priv, IMG_IR_CONTROL, 0);
> +		hw->suspend_irqen =3D img_ir_read(priv, IMG_IR_IRQ_ENABLE);

You're reusing hw->suspend_irqen. What if you get this workaround being
activated between img_ir_enable_wake() and img_ir_disable_wake()? I
suggest just using a new img_ir_priv_hw member.

The rest looks reasonable to me, even if unfortunate that it is
necessary in the first place.

Thanks for the hard work!

Cheers
James

> +		img_ir_write(priv, IMG_IR_IRQ_ENABLE,
> +			     hw->suspend_irqen & IMG_IR_IRQ_EDGE);
> +
> +		/* Timer activated to re-enable the protocol. */
> +		mod_timer(&hw->suspend_timer,
> +			  jiffies + msecs_to_jiffies(5));
>  		return;
> +	}
>  	ir_status &=3D ~(IMG_IR_RXDVAL | IMG_IR_RXDVALD2);
>  	img_ir_write(priv, IMG_IR_STATUS, ir_status);
> =20
>  	len =3D (ir_status & IMG_IR_RXDLEN) >> IMG_IR_RXDLEN_SHIFT;
>  	/* some versions report wrong length for certain code types */
> -	ct =3D hw->decoder->control.code_type;
>  	if (hw->ct_quirks[ct] & IMG_IR_QUIRK_CODE_LEN_INCR)
>  		++len;
> =20
> @@ -958,7 +1006,7 @@ static void img_ir_probe_hw_caps(struct img_ir_pri=
v *priv)
>  	hw->ct_quirks[IMG_IR_CODETYPE_PULSELEN]
>  		|=3D IMG_IR_QUIRK_CODE_LEN_INCR;
>  	hw->ct_quirks[IMG_IR_CODETYPE_BIPHASE]
> -		|=3D IMG_IR_QUIRK_CODE_BROKEN;
> +		|=3D IMG_IR_QUIRK_CODE_IRQ;
>  	hw->ct_quirks[IMG_IR_CODETYPE_2BITPULSEPOS]
>  		|=3D IMG_IR_QUIRK_CODE_BROKEN;
>  }
> @@ -977,6 +1025,8 @@ int img_ir_probe_hw(struct img_ir_priv *priv)
> =20
>  	/* Set up the end timer */
>  	setup_timer(&hw->end_timer, img_ir_end_timer, (unsigned long)priv);
> +	setup_timer(&hw->suspend_timer, img_ir_suspend_timer,
> +				(unsigned long)priv);
> =20
>  	/* Register a clock notifier */
>  	if (!IS_ERR(priv->clk)) {
> diff --git a/drivers/media/rc/img-ir/img-ir-hw.h b/drivers/media/rc/img=
-ir/img-ir-hw.h
> index 5e59e8e..8578aa7 100644
> --- a/drivers/media/rc/img-ir/img-ir-hw.h
> +++ b/drivers/media/rc/img-ir/img-ir-hw.h
> @@ -221,6 +221,7 @@ enum img_ir_mode {
>   * @rdev:		Remote control device
>   * @clk_nb:		Notifier block for clock notify events.
>   * @end_timer:		Timer until repeat timeout.
> + * @suspend_timer:	Timer to re-enable protocol.
>   * @decoder:		Current decoder settings.
>   * @enabled_protocols:	Currently enabled protocols.
>   * @clk_hz:		Current core clock rate in Hz.
> @@ -235,6 +236,7 @@ struct img_ir_priv_hw {
>  	struct rc_dev			*rdev;
>  	struct notifier_block		clk_nb;
>  	struct timer_list		end_timer;
> +	struct timer_list		suspend_timer;
>  	const struct img_ir_decoder	*decoder;
>  	u64				enabled_protocols;
>  	unsigned long			clk_hz;
>=20


--qt68giqhPrGgtOXp3UwhHfQTHkKsS4i9M
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUhd1AAAoJEGwLaZPeOHZ6n64P/1qAsNcx+UIh3MPTQtToxdt9
jzxDBVTAXzauBC5jPxoMe26ji5dZHZ6D6uRD/AkzdTgPM71OGUXqM/f+OBcNfiqX
00rFtod0s3BHK9MnId+PxiudeF71puD+2mDYFEKVTJXQnmbE5k4jbM11lRlwHsIx
po5x0P6PE9CeEICXZR+JzbiFFxnGP1tTVIZZrs+xN5CuqphNCOQl/MH24rtOYNee
dhT/IbXwN0n7VvLNaQkaXzDip92IDl0IXzu2L67NafJni+XQ/qTfBfCnKYArbdto
xe7+KiQvMBlwOR8Ba6/k2sj4fos7LecnVa81MRtsozPN914kK7ZaYaGgKfKUxI7+
gizuG9XJC/ISVNcDy5JMV7UOYxl2P/GG3S2eHK7dtwJcvIK/OJ+s29nNCBwxkcI4
j7i1U7XZQTFxoCmIYOQUpbTbZvatJBAoyd+jwa8hW0s+ly6d+ZUpindAy1//Ikku
nXbELr99dnwbJd6ta9L0E1ZsCuCntqpbgPSDRqScT4tPUn8Be9rbK0MQeUdV5h73
/hRPy3Ol4B8KTtaIMr6ZKogVcTj6mT302n4S+KAo/zreYX2jAecKog6n5Jk9aBPQ
hQMOVvac4up+APR/7OrmufNbG8S4Zqx64yBH4dvn3nhNGMUsdGOyTzaRGl0VKURo
k9AXpDW8O4C2ylP7CqYf
=/DVQ
-----END PGP SIGNATURE-----

--qt68giqhPrGgtOXp3UwhHfQTHkKsS4i9M--
