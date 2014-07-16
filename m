Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030265AbaGPQG5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 12:06:57 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:56607 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934509AbaGPQG4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 12:06:56 -0400
Date: Wed, 16 Jul 2014 11:06:14 -0500
From: Felipe Balbi <balbi@ti.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
CC: <balbi@ti.com>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Tony Lindgren <tony@atomide.com>, <linux-kernel@vger.kernel.org>,
        <linux-serial@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <mika.westerberg@linux.intel.com>
Subject: Re: [PATCH 4/5] tty: serial: 8250 core: add runtime pm
Message-ID: <20140716160614.GI1365@saruman.home>
Reply-To: <balbi@ti.com>
References: <1405521903-5877-1-git-send-email-bigeasy@linutronix.de>
 <1405521903-5877-5-git-send-email-bigeasy@linutronix.de>
 <20140716151604.GG1365@saruman.home>
 <53C6A050.2050409@linutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="svExV93C05KqedWb"
Content-Disposition: inline
In-Reply-To: <53C6A050.2050409@linutronix.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--svExV93C05KqedWb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Jul 16, 2014 at 05:54:56PM +0200, Sebastian Andrzej Siewior wrote:
> On 07/16/2014 05:16 PM, Felipe Balbi wrote:
> > Hi,
>=20
> Hi Felipe,
>=20
> > On Wed, Jul 16, 2014 at 04:45:02PM +0200, Sebastian Andrzej Siewior
> > wrote:
> >> @@ -1280,6 +1285,7 @@ static void serial8250_stop_tx(struct
> >> uart_port *port) struct uart_8250_port *up =3D container_of(port,
> >> struct uart_8250_port, port);
> >>=20
> >> +	pm_runtime_get_sync(port->dev); __stop_tx(up);
> >>=20
> >> /* @@ -1289,6 +1295,8 @@ static void serial8250_stop_tx(struct
> >> uart_port *port) up->acr |=3D UART_ACR_TXDIS; serial_icr_write(up,
> >> UART_ACR, up->acr); } +	pm_runtime_mark_last_busy(port->dev); +
> >> pm_runtime_put_autosuspend(port->dev); }
> >>=20
> >> static void serial8250_start_tx(struct uart_port *port) @@
> >> -1296,8 +1304,9 @@ static void serial8250_start_tx(struct
> >> uart_port *port) struct uart_8250_port *up =3D container_of(port,
> >> struct uart_8250_port, port);
> >>=20
> >> +	pm_runtime_get_sync(port->dev); if (up->dma &&
> >> !serial8250_tx_dma(up)) { -		return; +		goto out; } else if
> >> (!(up->ier & UART_IER_THRI)) { up->ier |=3D UART_IER_THRI;=20
> >> serial_port_out(port, UART_IER, up->ier); @@ -1318,6 +1327,9 @@
> >> static void serial8250_start_tx(struct uart_port *port) up->acr
> >> &=3D ~UART_ACR_TXDIS; serial_icr_write(up, UART_ACR, up->acr); }=20
> >> +out: +	pm_runtime_mark_last_busy(port->dev); +
> >> pm_runtime_put_autosuspend(port->dev);
> >=20
> > I wonder if you should get_sync() on start_tx() and only=20
> > put_autosuspend() at stop_tx(). I guess the outcome would be
> > largely the same, no ?
>=20
> I just opened minicom on ttyS0 and gave a try. start_tx() was invoked
> each time I pressed a key (sent a character). I haven't seen stop_tx()
> even after after I closed minicom. I guess stop_tx() is invoked if you
> switch half-duplex communication.

that's bad, I expected stop to be called also after each character.

> > well, other than in probe and other functions which need to make
> > sure clocks are on, but it seems unnecessary to enable/disable in
> > every function.
>=20
> What do you have in mind? Do you plan to let the uart on while the
> minicom is attached but is doing nothing? In that case, ->startup() and
> ->shutdown() should be enough.

no the idea was to keep it on for as long as it's transferring
characters and idle it otherwise, if that can't be done easily, then I
guess your way is the only way.

> If you want to put the uart off while the port is open but idle then
> you should cover the callbacks as they are independent of each other.
> You could receive three ->set_termios() even without a single
> ->start_tx(). And as far as I understand the whole situation, you need
> to make sure the UART is "up" while you touch a single register not
> only sending characters, right?

right, for those cases, you have to get/put around function entry/exit;
I was just assuming that we didn't have to do that for each and every
callback.

cheers

--=20
balbi

--svExV93C05KqedWb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTxqL2AAoJEIaOsuA1yqREskEP/A4DAFrmo9VWjOdvsgXns0QU
totzrZmUGi6xoY7CTH/Uf3y+PFg/OvZcOLZ47QCZsFJHyzTPtxsuxKt5Y5BNCU3K
Oy93OAkbGLGhJ9tOnnOaVpLTcf/r7DxOBk0iTeGgV2JfXc3AnRROVjgOSDg5oEo2
wpvCP4i7Ld4WD9ouktKgQ2WJyD38V5tZl0PMSWpaSuRvf1n1im36y9S9LMtQiTMU
FgwXuEgQWNhwNLGUEfNp5yIF3Yy6zidtIodM0Yrq9M0mbhWNEqPwVcQ6uCEcoQvw
G914OW6yMON1RUT9blIDiYUsmN9AabNm/EtJvPdFsdR0YOnOlWs1SHgDURUnnsCx
VWyF0yXMmNBoxURIGKN5vEhNHCdHcq2qpZsa8mOgE/SxBngRSJX9GrYxUffigjPH
eBp5/OwFkf82oNkl7zuOjncXX+opCA3eChDTdqIOdeKMfNQ/gixK+hgzkmT/bZtp
C7Qhfkl59GhG2OLGV61e+SKmqwkjThEmDkAJpoukPTiq0ydj9XAWcepk1mMyex8x
WSMZNcFNMvhNt7dkmx4mh3dvZ/FVTorIykfAFlWl7Qs5QpkK0kx4rTFjBh5YPcAS
hhAYaN+K4ssNvg48+2VEQ4S6CtCIMiiEgNpIF900Ehfzg6pGaiFXEk32iXoMFw05
ftI4VvkdBsEMLw1sajh5
=sfoI
-----END PGP SIGNATURE-----

--svExV93C05KqedWb--
