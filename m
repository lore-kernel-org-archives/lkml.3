Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967392AbaLLMHg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 07:07:36 -0500
Received: from mailapp01.imgtec.com ([195.59.15.196]:35268 "EHLO
	imgpgp01.kl.imgtec.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965873AbaLLMHe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 07:07:34 -0500
X-PGP-Universal: processed;
	by imgpgp01.kl.imgtec.org on Fri, 12 Dec 2014 12:07:32 +0000
Message-ID: <548ADA82.80603@imgtec.com>
Date: Fri, 12 Dec 2014 12:07:30 +0000
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Sifan Naeem <sifan.naeem@imgtec.com>, <mchehab@osg.samsung.com>
CC: <linux-kernel@vger.kernel.org>, <linux-media@vger.kernel.org>,
        <james.hartley@imgtec.com>, <ezequiel.garcia@imgtec.com>
Subject: Re: [PATCH v2 3/5] rc: img-ir: biphase enabled with workaround
References: <1418328386-9802-1-git-send-email-sifan.naeem@imgtec.com> <1418328386-9802-4-git-send-email-sifan.naeem@imgtec.com>
In-Reply-To: <1418328386-9802-4-git-send-email-sifan.naeem@imgtec.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="0L50J54px6gqUdQAoapmgrd2xtmfwPtJa"
X-Originating-IP: [192.168.154.101]
X-ESG-ENCRYPT-TAG: b93fcccb
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--0L50J54px6gqUdQAoapmgrd2xtmfwPtJa
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

Hi Sifan,

On 11/12/14 20:06, Sifan Naeem wrote:
> Biphase decoding in the current img-ir has got a quirk, where multiple
> Interrupts are generated when an incomplete IR code is received by the
> decoder.
>=20
> Patch adds a work around for the quirk and enables biphase decoding.
>=20
> Changes from v1:
>  * rebased due to conflict with "img-ir/hw: Fix potential deadlock stop=
ping timer"
>  * spinlock taken in img_ir_suspend_timer
>  * check for hw->stopping before handling quirks in img_ir_isr_hw
>  * new memeber added to img_ir_priv_hw to save irq status over suspend

For future reference, the list of changes between patchset versions is
usually put after a "---" so that it doesn't get included in the final
git commit message. You can also add any Acked-by/Reviewed-by tags
you've been given to new versions of patchset, assuming nothing
significant has changed in that patch (maintainers generally add
relevant tags for you, that are sent in response to the patches being
applied).

Anyway, the whole patchset looks okay to me, aside from the one question
I just asked on patch 3 of v1, which I'm not so sure about. I'll let you
decide whether that needs changing since you have the hardware to verify =
it.

So for the whole patchset feel free to add my:
Acked-by: James Hogan <james.hogan@imgtec.com>

Thanks
James

>=20
> Signed-off-by: Sifan Naeem <sifan.naeem@imgtec.com>
> ---
>  drivers/media/rc/img-ir/img-ir-hw.c |   60 +++++++++++++++++++++++++++=
++++++--
>  drivers/media/rc/img-ir/img-ir-hw.h |    4 +++
>  2 files changed, 61 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/media/rc/img-ir/img-ir-hw.c b/drivers/media/rc/img=
-ir/img-ir-hw.c
> index 9cecda7..5c32f05 100644
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
> @@ -542,6 +547,7 @@ static void img_ir_set_decoder(struct img_ir_priv *=
priv,
>  	 */
>  	spin_unlock_irq(&priv->lock);
>  	del_timer_sync(&hw->end_timer);
> +	del_timer_sync(&hw->suspend_timer);
>  	spin_lock_irq(&priv->lock);
> =20
>  	hw->stopping =3D false;
> @@ -861,6 +867,29 @@ static void img_ir_end_timer(unsigned long arg)
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
> +	spin_lock_irq(&priv->lock);
> +	/*
> +	 * Don't overwrite enabled valid/match IRQs if they have already been=

> +	 * changed by e.g. a filter change.
> +	 */
> +	if ((priv->hw.quirk_suspend_irq & IMG_IR_IRQ_EDGE) =3D=3D
> +				img_ir_read(priv, IMG_IR_IRQ_ENABLE))
> +		img_ir_write(priv, IMG_IR_IRQ_ENABLE,
> +					priv->hw.quirk_suspend_irq);
> +	/* enable */
> +	img_ir_write(priv, IMG_IR_CONTROL, priv->hw.reg_timings.ctrl);
> +	spin_unlock_irq(&priv->lock);
> +}
> +
>  #ifdef CONFIG_COMMON_CLK
>  static void img_ir_change_frequency(struct img_ir_priv *priv,
>  				    struct clk_notifier_data *change)
> @@ -926,15 +955,38 @@ void img_ir_isr_hw(struct img_ir_priv *priv, u32 =
irq_status)
>  	if (!hw->decoder)
>  		return;
> =20
> +	ct =3D hw->decoder->control.code_type;
> +
>  	ir_status =3D img_ir_read(priv, IMG_IR_STATUS);
> -	if (!(ir_status & (IMG_IR_RXDVAL | IMG_IR_RXDVALD2)))
> +	if (!(ir_status & (IMG_IR_RXDVAL | IMG_IR_RXDVALD2))) {
> +		if (!(priv->hw.ct_quirks[ct] & IMG_IR_QUIRK_CODE_IRQ) ||
> +				hw->stopping)
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
> +		hw->quirk_suspend_irq =3D img_ir_read(priv, IMG_IR_IRQ_ENABLE);
> +		img_ir_write(priv, IMG_IR_IRQ_ENABLE,
> +			     hw->quirk_suspend_irq & IMG_IR_IRQ_EDGE);
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
> @@ -976,7 +1028,7 @@ static void img_ir_probe_hw_caps(struct img_ir_pri=
v *priv)
>  	hw->ct_quirks[IMG_IR_CODETYPE_PULSELEN]
>  		|=3D IMG_IR_QUIRK_CODE_LEN_INCR;
>  	hw->ct_quirks[IMG_IR_CODETYPE_BIPHASE]
> -		|=3D IMG_IR_QUIRK_CODE_BROKEN;
> +		|=3D IMG_IR_QUIRK_CODE_IRQ;
>  	hw->ct_quirks[IMG_IR_CODETYPE_2BITPULSEPOS]
>  		|=3D IMG_IR_QUIRK_CODE_BROKEN;
>  }
> @@ -995,6 +1047,8 @@ int img_ir_probe_hw(struct img_ir_priv *priv)
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
> index beac3a6..b31ffc9 100644
> --- a/drivers/media/rc/img-ir/img-ir-hw.h
> +++ b/drivers/media/rc/img-ir/img-ir-hw.h
> @@ -218,6 +218,7 @@ enum img_ir_mode {
>   * @rdev:		Remote control device
>   * @clk_nb:		Notifier block for clock notify events.
>   * @end_timer:		Timer until repeat timeout.
> + * @suspend_timer:	Timer to re-enable protocol.
>   * @decoder:		Current decoder settings.
>   * @enabled_protocols:	Currently enabled protocols.
>   * @clk_hz:		Current core clock rate in Hz.
> @@ -228,12 +229,14 @@ enum img_ir_mode {
>   * @stopping:		Indicates that decoder is being taken down and timers
>   *			should not be restarted.
>   * @suspend_irqen:	Saved IRQ enable mask over suspend.
> + * @quirk_suspend_irq:	Saved IRQ enable mask over quirk suspend timer.=

>   */
>  struct img_ir_priv_hw {
>  	unsigned int			ct_quirks[4];
>  	struct rc_dev			*rdev;
>  	struct notifier_block		clk_nb;
>  	struct timer_list		end_timer;
> +	struct timer_list		suspend_timer;
>  	const struct img_ir_decoder	*decoder;
>  	u64				enabled_protocols;
>  	unsigned long			clk_hz;
> @@ -244,6 +247,7 @@ struct img_ir_priv_hw {
>  	enum img_ir_mode		mode;
>  	bool				stopping;
>  	u32				suspend_irqen;
> +	u32				quirk_suspend_irq;
>  };
> =20
>  static inline bool img_ir_hw_enabled(struct img_ir_priv_hw *hw)
>=20


--0L50J54px6gqUdQAoapmgrd2xtmfwPtJa
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUitqCAAoJEGwLaZPeOHZ6GkYP/1bUFQOH+LcRskGMq2nNrr0U
7NzREMVgQ1MlVtv3hinPTKHDbqUGRimP2UqlG30pMttLkRmFXULfkCHrJgxLJlJV
OGtEtu1b/Oh7qdJjpWAz5ip4dLmn6u4Hx9jVgDfDaoQziAIJvPIN1taw7SFZPq00
LNLS3qhaJWoX7uP7m2XN841cw0i4WyWvI8QxPofT6jEJFZ6QOLg+Bq7grHuha7xY
uKfdcfQ9+XxmBeTf90wrHYHf85oADkOdsnR3Yr39GQ5eTYx31QojyfhMMFwhbwLe
GhbvwCtWfxl1AgWfTBIPoTtvJItc97TnT4EUKN4qZOX4ADNWmDMz8k9xeAfPofJs
FQc62nku1PegoBOXpA7Q1dBwOpOJfIUTYbU0mvFZHdnNxqNhLNqNDLyBwwZ67sfF
jbXCuoxSxMozswqdVe/ZPgMvNzrN7cDjnBz6FNdu8RB98q1hiRPb1CO07mXViizM
FTuoIBRhMBeiv0G0jnHM1dkyndHmsVRXqozrgIMP+53aaUrcq3GJQfU2HjA7UTzC
LiciEPje699ik/hFiydHe/ahzvEinT16gIe/XmFGGfPCrQkY6sFjkH2psIiojY8f
YEEhw7dYtJcGLyVYghN09wsiRs32nqtWWZiYRad9osvph+x6JWuAysvlryV/QfKE
d8t+9gSHm3Ld3/Dwvy3U
=BTzw
-----END PGP SIGNATURE-----

--0L50J54px6gqUdQAoapmgrd2xtmfwPtJa--
