Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757987Ab3GWRZG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 13:25:06 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:57657 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756829Ab3GWRZD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 13:25:03 -0400
Date: Tue, 23 Jul 2013 20:25:01 +0300
From: Felipe Balbi <balbi@ti.com>
To: Illia Smyrnov <illia.smyrnov@ti.com>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>, <balbi@ti.com>,
        <linux-input@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>
Subject: Re: [PATCH v2 2/3] Input: omap-keypad: Convert to threaded IRQ
Message-ID: <20130723172501.GC9166@radagast>
Reply-To: <balbi@ti.com>
References: <1374595798-15492-1-git-send-email-illia.smyrnov@ti.com>
 <1374595798-15492-3-git-send-email-illia.smyrnov@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="O3RTKUHj+75w1tg5"
Content-Disposition: inline
In-Reply-To: <1374595798-15492-3-git-send-email-illia.smyrnov@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--O3RTKUHj+75w1tg5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Jul 23, 2013 at 07:09:57PM +0300, Illia Smyrnov wrote:
> Convert to use threaded IRQ.
>=20
> Cc: Felipe Balbi <balbi@ti.com>
> Signed-off-by: Illia Smyrnov <illia.smyrnov@ti.com>
> ---
>  drivers/input/keyboard/omap4-keypad.c |   29 ++++++++++++++++++++-------=
--
>  1 files changed, 20 insertions(+), 9 deletions(-)
>=20
> diff --git a/drivers/input/keyboard/omap4-keypad.c b/drivers/input/keyboa=
rd/omap4-keypad.c
> index c727548..b876a0d 100644
> --- a/drivers/input/keyboard/omap4-keypad.c
> +++ b/drivers/input/keyboard/omap4-keypad.c
> @@ -112,8 +112,22 @@ static void kbd_write_irqreg(struct omap4_keypad *ke=
ypad_data,
>  }
> =20
> =20
> -/* Interrupt handler */
> -static irqreturn_t omap4_keypad_interrupt(int irq, void *dev_id)
> +/* Interrupt handlers */
> +static irqreturn_t omap4_keypad_irq_handler(int irq, void *dev_id)
> +{
> +	struct omap4_keypad *keypad_data =3D dev_id;
> +
> +	if (kbd_read_irqreg(keypad_data, OMAP4_KBD_IRQSTATUS)) {
> +		/* Disable interrupts */
> +		kbd_write_irqreg(keypad_data, OMAP4_KBD_IRQENABLE,
> +				 OMAP4_VAL_IRQDISABLE);
> +		return IRQ_WAKE_THREAD;
> +	}
> +
> +	return IRQ_NONE;
> +}
> +
> +static irqreturn_t omap4_keypad_irq_thread_fn(int irq, void *dev_id)
>  {
>  	struct omap4_keypad *keypad_data =3D dev_id;
>  	struct input_dev *input_dev =3D keypad_data->input;
> @@ -121,10 +135,6 @@ static irqreturn_t omap4_keypad_interrupt(int irq, v=
oid *dev_id)
>  	unsigned int col, row, code, changed;
>  	u32 *new_state =3D (u32 *) key_state;
> =20
> -	/* Disable interrupts */
> -	kbd_write_irqreg(keypad_data, OMAP4_KBD_IRQENABLE,
> -			 OMAP4_VAL_IRQDISABLE);

looking a lot better, but I wonder if you should add a mutex to this
threaded handler, but I guess there's no way this will never race since
IRQs are masked anyway and registers are only accessed from within IRQ
handlers.

Reviewed-by: Felipe Balbi <balbi@ti.com>

--=20
balbi

--O3RTKUHj+75w1tg5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJR7rxtAAoJEIaOsuA1yqRE0RkP/0AhoT9+N07m0V+zZUq4kpXh
9MTtJrxavEAZPVml/aaB5fIGKNWpF+8Toxt6pTr7B+yXlOrCp2hL6PtjGezDyo+1
vS63tlSSoUhQIcYXyaalUq+rrvElr2Uvd5u2e+GmmksvV0o0ANCIM957WQBxbUUs
/xDbIk9bxoMPxA17YksRbAQvSx0LYkFMQTkWBc2WONcCPknQerJN4n5A8zG9ryhL
d0Cy8CNHazVyLCLiccoNa3w0LkskewqU7LKAu0fBAvqlWSrDG2wFf4ac6GOVTZaq
jH8I5KrrcuEl7Wcdeq2PcGzTuSmwnKidClNU3bQ+j61Ov4lazMWE63jCZ224TP3O
tgPAf/vphKKK4Qv7Dh1g5DsJVIFTUd5NV5PkMV6WeyLyZgAEUc4xPFc/Jt5p/vz+
G40yfbtWJ3vWX2z/KYRRbj+df7bJVieSq+RU63bPpG7xL/JQVfNlUDc0klHiSEbY
UTSfRwqBjsdXkdJll0W/7EW3fVIeAbfykVFIZDweK0R6ROn0Ip0Qp8NSqhEe6kmF
UAZsXsR+ZLy3qk+DpBK1q4ZECX3ONq+TDI854pMeXqbk/iXgXj95PGtgRuJFYik5
V/J5kdYApv+B15LlqtTjS5sQOh7Rr6752UhUF40Z8u0mR4Ouy52lcwr8t5uQsPjk
MDw8TJtyIsiRv0DeHm4u
=NEoa
-----END PGP SIGNATURE-----

--O3RTKUHj+75w1tg5--
