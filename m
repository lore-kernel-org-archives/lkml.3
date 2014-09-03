Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756098AbaICHwy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 03:52:54 -0400
Received: from smtp3.mundo-r.com ([212.51.32.191]:61036 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751755AbaICHww (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 03:52:52 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgYFAIjHBlRbdWOb/2dsb2JhbABagw2BKoJ8zREBgQ0Wd4QEAQUjBFIQCxgqAgJXBhOIRgGnT5V6ARcYjzUHgnmBUwWGFKNLiBuDY2qCTwEBAQ
X-IPAS-Result: AgYFAIjHBlRbdWOb/2dsb2JhbABagw2BKoJ8zREBgQ0Wd4QEAQUjBFIQCxgqAgJXBhOIRgGnT5V6ARcYjzUHgnmBUwWGFKNLiBuDY2qCTwEBAQ
X-IronPort-AV: E=Sophos;i="5.04,455,1406584800"; 
   d="asc'?scan'208";a="266281458"
Message-ID: <1409730756.9087.6.camel@fourier>
Subject: Re: [PATCH 1/3] ipoctal: reset function istead of duplicate code
From: Samuel Iglesias =?ISO-8859-1?Q?Gons=E1lvez?= 
	<siglesias@igalia.com>
To: Federico Vaga <federico.vaga@cern.ch>
Cc: Jens Taprogge <jens.taprogge@taprogge.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        industrypack-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Date: Wed, 03 Sep 2014 09:52:36 +0200
In-Reply-To: <1409671901-4009-2-git-send-email-federico.vaga@cern.ch>
References: <1409671901-4009-1-git-send-email-federico.vaga@cern.ch>
	 <1409671901-4009-2-git-send-email-federico.vaga@cern.ch>
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-tbZB7qK7b58VP088uRW3"
X-Mailer: Evolution 3.12.2-1+b1 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-tbZB7qK7b58VP088uRW3
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2014-09-02 at 17:31 +0200, Federico Vaga wrote:
> Signed-off-by: Federico Vaga <federico.vaga@cern.ch>
> ---
>  drivers/ipack/devices/ipoctal.c |   35 ++++++++++++++-------------------=
--
>  1 file changed, 14 insertions(+), 21 deletions(-)
>=20
> diff --git a/drivers/ipack/devices/ipoctal.c b/drivers/ipack/devices/ipoc=
tal.c
> index 90b96a1b..e531379 100644
> --- a/drivers/ipack/devices/ipoctal.c
> +++ b/drivers/ipack/devices/ipoctal.c
> @@ -55,6 +55,16 @@ struct ipoctal {
>  	u8 __iomem			*int_space;
>  };
> =20
> +static void ipoctal_reset_channel(struct ipoctal_channel *channel)
> +{
> +	iowrite8(CR_DISABLE_RX | CR_DISABLE_TX, &channel->regs->w.cr);
> +	channel->rx_enable =3D 0;
> +	iowrite8(CR_CMD_RESET_RX, &channel->regs->w.cr);
> +	iowrite8(CR_CMD_RESET_TX, &channel->regs->w.cr);
> +	iowrite8(CR_CMD_RESET_ERR_STATUS, &channel->regs->w.cr);
> +	iowrite8(CR_CMD_RESET_MR, &channel->regs->w.cr);
> +}
> +
>  static int ipoctal_port_activate(struct tty_port *port, struct tty_struc=
t *tty)
>  {
>  	struct ipoctal_channel *channel;
> @@ -306,10 +316,7 @@ static int ipoctal_inst_slot(struct ipoctal *ipoctal=
, unsigned int bus_nr,
>  			channel->isr_rx_rdy_mask =3D ISR_RxRDY_FFULL_A;
>  		}
> =20
> -		iowrite8(CR_DISABLE_RX | CR_DISABLE_TX, &channel->regs->w.cr);
> -		channel->rx_enable =3D 0;
> -		iowrite8(CR_CMD_RESET_RX, &channel->regs->w.cr);
> -		iowrite8(CR_CMD_RESET_TX, &channel->regs->w.cr);
> +		ipoctal_reset_channel(channel);
>  		iowrite8(MR1_CHRL_8_BITS | MR1_ERROR_CHAR | MR1_RxINT_RxRDY,
>  			 &channel->regs->w.mr); /* mr1 */
>  		iowrite8(0, &channel->regs->w.mr); /* mr2 */
> @@ -469,11 +476,7 @@ static void ipoctal_set_termios(struct tty_struct *t=
ty,
>  	cflag =3D tty->termios.c_cflag;
> =20
>  	/* Disable and reset everything before change the setup */
> -	iowrite8(CR_DISABLE_RX | CR_DISABLE_TX, &channel->regs->w.cr);
> -	iowrite8(CR_CMD_RESET_RX, &channel->regs->w.cr);
> -	iowrite8(CR_CMD_RESET_TX, &channel->regs->w.cr);
> -	iowrite8(CR_CMD_RESET_ERR_STATUS, &channel->regs->w.cr);
> -	iowrite8(CR_CMD_RESET_MR, &channel->regs->w.cr);
> +	ipoctal_reset_channel(channel);
> =20
>  	/* Set Bits per chars */
>  	switch (cflag & CSIZE) {
> @@ -611,12 +614,7 @@ static void ipoctal_hangup(struct tty_struct *tty)
> =20
>  	tty_port_hangup(&channel->tty_port);
> =20
> -	iowrite8(CR_DISABLE_RX | CR_DISABLE_TX, &channel->regs->w.cr);
> -	channel->rx_enable =3D 0;
> -	iowrite8(CR_CMD_RESET_RX, &channel->regs->w.cr);
> -	iowrite8(CR_CMD_RESET_TX, &channel->regs->w.cr);
> -	iowrite8(CR_CMD_RESET_ERR_STATUS, &channel->regs->w.cr);
> -	iowrite8(CR_CMD_RESET_MR, &channel->regs->w.cr);
> +	ipoctal_reset_channel(channel);
> =20
>  	clear_bit(ASYNCB_INITIALIZED, &channel->tty_port.flags);
>  	wake_up_interruptible(&channel->tty_port.open_wait);
> @@ -629,12 +627,7 @@ static void ipoctal_shutdown(struct tty_struct *tty)
>  	if (channel =3D=3D NULL)
>  		return;
> =20
> -	iowrite8(CR_DISABLE_RX | CR_DISABLE_TX, &channel->regs->w.cr);
> -	channel->rx_enable =3D 0;
> -	iowrite8(CR_CMD_RESET_RX, &channel->regs->w.cr);
> -	iowrite8(CR_CMD_RESET_TX, &channel->regs->w.cr);
> -	iowrite8(CR_CMD_RESET_ERR_STATUS, &channel->regs->w.cr);
> -	iowrite8(CR_CMD_RESET_MR, &channel->regs->w.cr);
> +	ipoctal_reset_channel(channel);
>  	clear_bit(ASYNCB_INITIALIZED, &channel->tty_port.flags);
>  }
> =20

Acked-by: Samuel Iglesias Gonsalvez <siglesias@igalia.com>

Sam



--=-tbZB7qK7b58VP088uRW3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJUBsjFAAoJEH/0ujLxfcNDpNwQAKFkDMOMaj8tYV5RNxPsF+B9
FTXQBLyQ1q9bDXi0/oBZm3pLOVCIQRQpriAHwaeXwcjr8ZAYCOrVNIoZjw6mruvx
MzSaSzqInRAd9bfEpk5Z5CXpoGyIhfO20YCHsAo3qJ5D4umPPjvL7SDCP2VWpG0+
LnLzd+Ovwh+HSa4MNEi9uxp+45FYo2pB+RrZ/M0i49gAqQoVdMUVvW71kcqxU5uY
/CcrTN8ISHqqQb3rUU7e+QsXt+Ct+g84Tc7RL0Q5x/bezAbX4l9BhW/4VlCC73AI
s5aFkISOux4p4hUR1I8+pFi9MDns7OzLjKs11M5PJ/7sp+HPuZsz68rZ+5TgJfNh
khpvZbnz5aW047gRwrB5Vey42wqSGBhsLwZJovnhst2ElBSeQPYo7eYQ1M0TWeJX
a+bzkaqgXStpWex5ECM/+uciE4M6foErFuODWLFlNyMtbY4oQ5d3CwbfaGvge7rK
8P/vUmpMmD+PqSAY3atj3JqqXASoxLteTNNdqx587xxb1KVGq7xwwc1PreN12Kfl
3KYurilg3eHNEI+3Novrftqj/vMq8pIjodzy9VQlnUXJna0odWduwI6YIVOkhCJZ
dO0ufzp5UDAOMEQWvr3vBIIGMXyBFd4O0bqs90YSbVr8/My/AXxrhsYHC6TGiq1h
q9rF1AfF70WJTCyeKXGd
=7i/E
-----END PGP SIGNATURE-----

--=-tbZB7qK7b58VP088uRW3--

