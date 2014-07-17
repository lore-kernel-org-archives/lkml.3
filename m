Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757405AbaGQQCu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 12:02:50 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:40593 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757290AbaGQQCr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 12:02:47 -0400
Date: Thu, 17 Jul 2014 11:02:06 -0500
From: Felipe Balbi <balbi@ti.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
CC: Peter Hurley <peter@hurleysoftware.com>, <balbi@ti.com>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Tony Lindgren <tony@atomide.com>, <linux-kernel@vger.kernel.org>,
        <linux-serial@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <mika.westerberg@linux.intel.com>
Subject: Re: [PATCH 4/5] tty: serial: 8250 core: add runtime pm
Message-ID: <20140717160206.GI10459@saruman.home>
Reply-To: <balbi@ti.com>
References: <1405521903-5877-1-git-send-email-bigeasy@linutronix.de>
 <1405521903-5877-5-git-send-email-bigeasy@linutronix.de>
 <20140716151604.GG1365@saruman.home>
 <53C6A050.2050409@linutronix.de>
 <20140716160614.GI1365@saruman.home>
 <53C7EC6F.6060902@hurleysoftware.com>
 <20140717154300.GA16623@linutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="JIpyCmsTxyPLrmrM"
Content-Disposition: inline
In-Reply-To: <20140717154300.GA16623@linutronix.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--JIpyCmsTxyPLrmrM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Jul 17, 2014 at 05:43:00PM +0200, Sebastian Andrzej Siewior wrote:
> * Peter Hurley | 2014-07-17 11:31:59 [-0400]:
>=20
> >On 07/16/2014 12:06 PM, Felipe Balbi wrote:
> >>On Wed, Jul 16, 2014 at 05:54:56PM +0200, Sebastian Andrzej Siewior wro=
te:
> >>>On 07/16/2014 05:16 PM, Felipe Balbi wrote:
> >
> >>>>I wonder if you should get_sync() on start_tx() and only
> >>>>put_autosuspend() at stop_tx(). I guess the outcome would be
> >>>>largely the same, no ?
> >>>
> >>>I just opened minicom on ttyS0 and gave a try. start_tx() was invoked
> >>>each time I pressed a key (sent a character). I haven't seen stop_tx()
> >>>even after after I closed minicom. I guess stop_tx() is invoked if you
> >>>switch half-duplex communication.
> >>
> >>that's bad, I expected stop to be called also after each character.
> >
> >The 8250 core auto-stops tx when the tx ring buffer is empty (except
> >in the case of dma, where stopping tx isn't necessary).
>=20
> This is correct. So this is what I have now for the non-dma case:
>=20
> diff --git a/drivers/tty/serial/8250/8250_core.c b/drivers/tty/serial/825=
0/8250_core.c
> index 2e4a93b..480a1c0 100644
> --- a/drivers/tty/serial/8250/8250_core.c
> +++ b/drivers/tty/serial/8250/8250_core.c
> @@ -1283,6 +1283,9 @@ static inline void __stop_tx(struct uart_8250_port =
*p)
>  	if (p->ier & UART_IER_THRI) {
>  		p->ier &=3D ~UART_IER_THRI;
>  		serial_out(p, UART_IER, p->ier);
> +
> +		pm_runtime_mark_last_busy(p->port.dev);
> +		pm_runtime_put_autosuspend(p->port.dev);
>  	}
>  }
> =20
> @@ -1310,12 +1313,12 @@ static void serial8250_start_tx(struct uart_port =
*port)
>  	struct uart_8250_port *up =3D
>  		container_of(port, struct uart_8250_port, port);
> =20
> -	pm_runtime_get_sync(port->dev);
>  	if (up->dma && !serial8250_tx_dma(up)) {
>  		goto out;
>  	} else if (!(up->ier & UART_IER_THRI)) {
>  		up->ier |=3D UART_IER_THRI;
> +		pm_runtime_get_sync(port->dev);
>  		serial_port_out(port, UART_IER, up->ier);
> =20
>  		if (up->bugs & UART_BUG_TXEN) {
>  			unsigned char lsr;

this looks better. So we get on start_tx() and put on stop_tx().

> @@ -1500,9 +1503,10 @@ void serial8250_tx_chars(struct uart_8250_port *up)
>  		uart_write_wakeup(port);
> =20
>  	DEBUG_INTR("THRE...");
> -
> +#if 0
>  	if (uart_circ_empty(xmit))
>  		__stop_tx(up);
> +#endif
>  }
>  EXPORT_SYMBOL_GPL(serial8250_tx_chars);

is it so that start_tx() gets called one and stop_tx() might be called N
times ? That looks unbalanced to me. If the calls are balanced, then you
shouldn't need to care because pm_runtime will handle reference counting
for you, right?

> and now I need to come up with something that is not if (port !=3D omap)
> for that #if 0 block. The code disables the TX FIFO empty interrupt once
> the transfer is complete. I want to call __stop_tx() once the tx fifo is
> empty.
> Felipe, Would a check for dev->power.use_autosuspend be the right thing
> to do?

probably not, as that's internal to the pm_runtime code. But I wonder if
start/stop tx calls are balanced, if they are then we're good. Unless
I'm missing something else.

--=20
balbi

--JIpyCmsTxyPLrmrM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTx/N+AAoJEIaOsuA1yqREkMYQAKPnCgOMNpTy/HStetWYOHVS
jorSnDEvaCBriLW7ifDvsn2Y1mFqQBF21khHcXAiQEqhBZGGloOPiRnpUayvuplD
w+TASW+NOoqSm00XrYtfVrJlK51tXUBFJzzWvKdNwsMv/lRCe8rBbzi5g/yWVDsZ
NU3AL/kO2YrIQj7WmvhN2720XFzKn4HcwerFxQWtHn9xf86I/8iHNNaqMbLN/PNM
+XJUXEFFpf6a7qiqmAJXKb6VL1Yuyu8pB5D9BDdhsGlt8hE6Tgobz2IOtSbK+3oc
vYugyV/BfHMVA06+gy+oJTvzMsxfrYGxVl961L6Is9wxBpkka9GZO3NhsbrU52hU
OZ5/v2lamhGs5xmLY3+IKHKze27Umww0bmAXMSKg2MzQeuCl9558O1MZCG5YI7/x
xKTS4wHgMsvprPrryJHMnGYmfTGlaNUJTPa+UPoRAdVALSGbnTM/cgrPADAX2ykg
pdk9l/9AMpxRLsnnrplnBz1syed3a495Jm3DMDdi7bG+V7uvMP3gc6Mf/CDYd7nz
FtRgdfs0geR/MFBXWD90R5woMKitkdkvihbwm1G/fsnisD5CmdfpHXEeXg15X/BN
GVDrCjNIVST60o+tmOT3dJxTL3flBqWhm8l5EELuzsTzm/EVzDpMwVKyBN7bfzoK
wSN0k3ooqJGvVvugG8yb
=myhJ
-----END PGP SIGNATURE-----

--JIpyCmsTxyPLrmrM--
