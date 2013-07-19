Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760130Ab3GSN06 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 09:26:58 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:51309 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752307Ab3GSN04 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 09:26:56 -0400
Date: Fri, 19 Jul 2013 16:26:48 +0300
From: Felipe Balbi <balbi@ti.com>
To: Illia Smyrnov <illia.smyrnov@globallogic.com>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>, <linux-input@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>
Subject: Re: [PATCH 2/2] Input: omap-keypad: Cleanup - remove unnecessary IRQ
 enabling/disabling
Message-ID: <20130719132648.GB17188@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1374239027-3927-1-git-send-email-illia.smyrnov@globallogic.com>
 <1374239027-3927-3-git-send-email-illia.smyrnov@globallogic.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="yEPQxsgoJgBvi8ip"
Content-Disposition: inline
In-Reply-To: <1374239027-3927-3-git-send-email-illia.smyrnov@globallogic.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--yEPQxsgoJgBvi8ip
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Jul 19, 2013 at 04:03:47PM +0300, Illia Smyrnov wrote:
> From: Illia Smyrnov <illia.smyrnov@ti.com>
>=20
> Remove unnecessary IRQ enabling/disabling for certain keyboard events.
>=20
> Signed-off-by: Illia Smyrnov <illia.smyrnov@ti.com>
> ---
>  drivers/input/keyboard/omap4-keypad.c |   15 ++++-----------
>  1 files changed, 4 insertions(+), 11 deletions(-)
>=20
> diff --git a/drivers/input/keyboard/omap4-keypad.c b/drivers/input/keyboa=
rd/omap4-keypad.c
> index c727548..73813b6 100644
> --- a/drivers/input/keyboard/omap4-keypad.c
> +++ b/drivers/input/keyboard/omap4-keypad.c
> @@ -121,10 +121,6 @@ static irqreturn_t omap4_keypad_interrupt(int irq, v=
oid *dev_id)
>  	unsigned int col, row, code, changed;
>  	u32 *new_state =3D (u32 *) key_state;
> =20
> -	/* Disable interrupts */
> -	kbd_write_irqreg(keypad_data, OMAP4_KBD_IRQENABLE,
> -			 OMAP4_VAL_IRQDISABLE);
> -
>  	*new_state =3D kbd_readl(keypad_data, OMAP4_KBD_FULLCODE31_0);
>  	*(new_state + 1) =3D kbd_readl(keypad_data, OMAP4_KBD_FULLCODE63_32);
> =20
> @@ -154,11 +150,6 @@ static irqreturn_t omap4_keypad_interrupt(int irq, v=
oid *dev_id)
>  	kbd_write_irqreg(keypad_data, OMAP4_KBD_IRQSTATUS,
>  			 kbd_read_irqreg(keypad_data, OMAP4_KBD_IRQSTATUS));
> =20
> -	/* enable interrupts */
> -	kbd_write_irqreg(keypad_data, OMAP4_KBD_IRQENABLE,
> -		OMAP4_DEF_IRQENABLE_EVENTEN |
> -				OMAP4_DEF_IRQENABLE_LONGKEY);
> -

please don't remove this code. It'll be good to have this around when we
move the driver to threaded IRQs without IRQF_ONESHOT. In fact, it would
be very simple to implement such a change, wanna take it up ?

It should be doable in few patches:

1) switch over to request_threaded_irq()

	just blind move to a thread, without hardirq handler, so
	IRQF_ONESHOT is mandatory.

2) add hardirq handler

	read IRQSTATUS to check if our device has generated IRQs
	returning IRQ_WAKE_THREAD if true

3) move 'IRQ masking logic' to hardirq handler, before returning
IRQ_WAKE_THREAD

	this will let you remove IRQF_ONESHOT

4) finally remove IRQF_ONESHOT

	this makes sure that IRQs aren't kept disabled until we have
	time to iterate over the entire keypad matrix. Only the keypad
	IRQ will be masked.

--=20
balbi

--yEPQxsgoJgBvi8ip
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJR6T6YAAoJEIaOsuA1yqREiu8P/13909a6NgJFVGavASP9XXGk
4XZjZfFJjA/o0kqsms9Oo3A7HaGVyNgfDwYynZruNJX/eQaPiiEFZi5nUwYLsOMZ
a1UlpXnHrfIvJis6u9njgtVbvFINt5fab28QEMAKFkqbz8tqK5qlQZ1VuZvNpkxS
hEQKC9DY1vAPLH8TMVIUYvZ9Wk1qleQNoJIlqj7hkz0FS+2C+MEPzbYI6Ele/X7N
HnUj01IqV0cwLCM1Sbzyh5UfeXAJCcXNlj4Z+TeF+gysdpVUKNRbW7nQGRFND+5u
3eHah6VGkQPr+zePF8OwObPlsa+nZhGnTqlVs7p2W1AD3OeNxV+VCZ9ZXoGlJlcB
G3C2y6wjNJDuvpowRL0PlgQVtD5ee2VS5hZoVldM4aWWgLcsJzDOC7eXL6o2sVC6
Vjj2r+msCZ7XuzDUgnwVvxNd9I0/JrEtGYBOU04oh/OSzRfzOMVIxXbA7AwBQIaX
WwDDbLCEvPDSI+4K5bxl00H6f6FoY1rECQ5L3Tx5xUM57Z257HGEj5jhn44KbMa+
SVorZdNudFia9wA0cWINi0+rw+fJlMN2H1Q7saseJQ6DautHtBRD9u3uhIUKZ8FQ
wMEqUP3INNFoVsKwbIokevh57v5JPewts8DB9pwRsElDRSryZQzjoqlEdCjqNE7z
b4y4G9daSw1acPmkpzox
=kACE
-----END PGP SIGNATURE-----

--yEPQxsgoJgBvi8ip--
