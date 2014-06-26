Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755409AbaFZIDG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 04:03:06 -0400
Received: from smtp3.mundo-r.com ([212.51.32.191]:55551 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754658AbaFZIC4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 04:02:56 -0400
X-Greylist: delayed 594 seconds by postgrey-1.27 at vger.kernel.org; Thu, 26 Jun 2014 04:02:56 EDT
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgUFAHnQq1NbdWOb/2dsb2JhbABSCIMNhBrBFAGBCBZ1hAMBAQUjBFIQCxgqAgJXBhOIRgGlYJ1XFxeOE1YHgneBTAWuR4NE
X-IPAS-Result: AgUFAHnQq1NbdWOb/2dsb2JhbABSCIMNhBrBFAGBCBZ1hAMBAQUjBFIQCxgqAgJXBhOIRgGlYJ1XFxeOE1YHgneBTAWuR4NE
X-IronPort-AV: E=Sophos;i="5.01,551,1400018400"; 
   d="asc'?scan'208";a="224331737"
Message-ID: <1403769170.4516.5.camel@fourier>
Subject: Re: [PATCH] ipoctal: protect only the real critical section
From: Samuel Iglesias =?ISO-8859-1?Q?Gons=E1lvez?= 
	<siglesias@igalia.com>
To: Federico Vaga <federico.vaga@cern.ch>
Cc: jens.taprogge@taprogge.org, gregkh@linuxfoundation.org,
        industrypack-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Date: Thu, 26 Jun 2014 09:52:50 +0200
In-Reply-To: <1403768784-21605-1-git-send-email-federico.vaga@cern.ch>
References: <1403768784-21605-1-git-send-email-federico.vaga@cern.ch>
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-4GLoIIqKAVwThLWBRCx2"
X-Mailer: Evolution 3.12.2-1 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-4GLoIIqKAVwThLWBRCx2
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2014-06-26 at 09:46 +0200, Federico Vaga wrote:
> In some conditions (echo or particular sequence of special
> characters), on buffer push, the tty layer calls the write operation
> while we are holding the spinlock. This means deadlock within the same
> process on kernels version < 3.12. It seems not a problem on recent
> kernel, but the patch still valid as locking optimization.
>=20
> The protected variables by the spinlock are: xmit_buf, nb_bytes,
> pointer_read and pointer_write. So, this patch reduces the locked area
> in the IRQ handler only to these variables. Most of the code inside the
> locked area in the IRQ handler is not protected elsewhere; it means
> that it is not protected at all.
>=20
> Signed-off-by: Federico Vaga <federico.vaga@cern.ch>
> ---
>  drivers/ipack/devices/ipoctal.c |    5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/ipack/devices/ipoctal.c b/drivers/ipack/devices/ipoc=
tal.c
> index 141094e..69687f1 100644
> --- a/drivers/ipack/devices/ipoctal.c
> +++ b/drivers/ipack/devices/ipoctal.c
> @@ -177,19 +177,20 @@ static void ipoctal_irq_tx(struct ipoctal_channel *=
channel)
>  	if (channel->nb_bytes =3D=3D 0)
>  		return;
> =20
> +	spin_lock(&channel->lock);
>  	value =3D channel->tty_port.xmit_buf[*pointer_write];
>  	iowrite8(value, &channel->regs->w.thr);
>  	channel->stats.tx++;
>  	(*pointer_write)++;
>  	*pointer_write =3D *pointer_write % PAGE_SIZE;
>  	channel->nb_bytes--;
> +	spin_unlock(&channel->lock);
>  }
> =20
>  static void ipoctal_irq_channel(struct ipoctal_channel *channel)
>  {
>  	u8 isr, sr;
> =20
> -	spin_lock(&channel->lock);
>  	/* The HW is organized in pair of channels.  See which register we need
>  	 * to read from */
>  	isr =3D ioread8(&channel->block_regs->r.isr);
> @@ -213,8 +214,6 @@ static void ipoctal_irq_channel(struct ipoctal_channe=
l *channel)
>  	/* TX of each character */
>  	if ((isr & channel->isr_tx_rdy_mask) && (sr & SR_TX_READY))
>  		ipoctal_irq_tx(channel);
> -
> -	spin_unlock(&channel->lock);
>  }
> =20
>  static irqreturn_t ipoctal_irq_handler(void *arg)

Acked-by: Samuel Iglesias Gonsalvez <siglesias@igalia.com>

Sam

--=-4GLoIIqKAVwThLWBRCx2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAABCAAGBQJTq9FSAAoJEH/0ujLxfcNDciQP/0FABUn/499fbq/ZKi8Koaad
9Z564rGj71FbX8DLJjX9ogvlrLsdonsUG85IBDcyRje+11TK6OC+tq5opDX2zkDm
ET0SH3/pbabodnGDWVuFV1VDoQjxXzllVPp2LdQFvDjoD0+0W3MYq0jNjV9ej90E
k7MPXZZ3pwuTjwFunbZfplKTVpMCBkdVd10xI3LWe6krOygaEa2RttjVS4PZtCCk
J7PxRzw++fXYrqtmqroNMWAKjtE2UD7zDF3FmiQIIMLvXgO1/R8dfpyKYGPJNwpw
/vV6+Xq8aln2x+sERN1viJ6IA5aP8MhpUlWmw4jAkvYzJrVYqDiaQPQgp5f4/Ap1
Cf4JkJpQDy8xC9E+p8QEFWnin5ie7aFzVObeHDVsCANtRao8JV1XJnR2HrBS+2qe
4+G6fZRj8AthkYjbkxsTFulhzLj8jul5fXuhbeS4Q68sKjZFvv3CDo0gWC2t0OLN
Lde92sQopg15lB7V8s7n+s0DMdTsm1xgvCTLraK5/H7Re1WYmutS3C1U/INXEM9c
H0UCyjuw7fJj/vPFSAdeOZYTDe/b0XlXFBE6IwZ9FpgIGG0DVWETub9bzTEbtDRn
GU26yvSCmSENh4DkZDJZ+qpwbq9lFVpe/Uxk63UvcS3oNJGAeanklDpXNoJ5dx5V
Q0wPu9ltaWCdx+esowjz
=r54Q
-----END PGP SIGNATURE-----

--=-4GLoIIqKAVwThLWBRCx2--

