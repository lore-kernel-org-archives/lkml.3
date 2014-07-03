Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757987AbaGCIzc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 04:55:32 -0400
Received: from smtp3.mundo-r.com ([212.51.32.191]:59012 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755076AbaGCIza (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 04:55:30 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AiwFAPoZtVNbdWOb/2dsb2JhbABSCIMNhBvDLgGBChZ1hAMBAQUjBFIQCxgqAgJXBhOIRgGsDpwAFxiONFYHgneBTAWud4IBgUQ7
X-IPAS-Result: AiwFAPoZtVNbdWOb/2dsb2JhbABSCIMNhBvDLgGBChZ1hAMBAQUjBFIQCxgqAgJXBhOIRgGsDpwAFxiONFYHgneBTAWud4IBgUQ7
X-IronPort-AV: E=Sophos;i="5.01,594,1400018400"; 
   d="asc'?scan'208";a="244053725"
Message-ID: <1404377716.4537.18.camel@fourier>
Subject: Re: [Industrypack-devel] [PATCH] ipoctal: protect only the real
 critical section
From: Samuel Iglesias =?ISO-8859-1?Q?Gons=E1lvez?= 
	<siglesias@igalia.com>
To: Federico Vaga <federico.vaga@cern.ch>
Cc: gregkh@linuxfoundation.org, jens.taprogge@taprogge.org,
        linux-kernel@vger.kernel.org, industrypack-devel@lists.sourceforge.net
Date: Thu, 03 Jul 2014 10:55:16 +0200
In-Reply-To: <1403769170.4516.5.camel@fourier>
References: <1403768784-21605-1-git-send-email-federico.vaga@cern.ch>
	 <1403769170.4516.5.camel@fourier>
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-oX5Y0t02YlyXWu05gaI9"
X-Mailer: Evolution 3.12.2-1 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-oX5Y0t02YlyXWu05gaI9
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2014-06-26 at 09:52 +0200, Samuel Iglesias Gons=C3=A1lvez wrote:
> On Thu, 2014-06-26 at 09:46 +0200, Federico Vaga wrote:
> > In some conditions (echo or particular sequence of special
> > characters), on buffer push, the tty layer calls the write operation
> > while we are holding the spinlock. This means deadlock within the same
> > process on kernels version < 3.12. It seems not a problem on recent
> > kernel, but the patch still valid as locking optimization.
> >=20
> > The protected variables by the spinlock are: xmit_buf, nb_bytes,
> > pointer_read and pointer_write. So, this patch reduces the locked area
> > in the IRQ handler only to these variables. Most of the code inside the
> > locked area in the IRQ handler is not protected elsewhere; it means
> > that it is not protected at all.
> >=20
> > Signed-off-by: Federico Vaga <federico.vaga@cern.ch>
> > ---
> >  drivers/ipack/devices/ipoctal.c |    5 ++---
> >  1 file changed, 2 insertions(+), 3 deletions(-)
> >=20
> > diff --git a/drivers/ipack/devices/ipoctal.c b/drivers/ipack/devices/ip=
octal.c
> > index 141094e..69687f1 100644
> > --- a/drivers/ipack/devices/ipoctal.c
> > +++ b/drivers/ipack/devices/ipoctal.c
> > @@ -177,19 +177,20 @@ static void ipoctal_irq_tx(struct ipoctal_channel=
 *channel)
> >  	if (channel->nb_bytes =3D=3D 0)
> >  		return;
> > =20
> > +	spin_lock(&channel->lock);
> >  	value =3D channel->tty_port.xmit_buf[*pointer_write];
> >  	iowrite8(value, &channel->regs->w.thr);
> >  	channel->stats.tx++;
> >  	(*pointer_write)++;
> >  	*pointer_write =3D *pointer_write % PAGE_SIZE;
> >  	channel->nb_bytes--;
> > +	spin_unlock(&channel->lock);
> >  }
> > =20
> >  static void ipoctal_irq_channel(struct ipoctal_channel *channel)
> >  {
> >  	u8 isr, sr;
> > =20
> > -	spin_lock(&channel->lock);
> >  	/* The HW is organized in pair of channels.  See which register we ne=
ed
> >  	 * to read from */
> >  	isr =3D ioread8(&channel->block_regs->r.isr);
> > @@ -213,8 +214,6 @@ static void ipoctal_irq_channel(struct ipoctal_chan=
nel *channel)
> >  	/* TX of each character */
> >  	if ((isr & channel->isr_tx_rdy_mask) && (sr & SR_TX_READY))
> >  		ipoctal_irq_tx(channel);
> > -
> > -	spin_unlock(&channel->lock);
> >  }
> > =20
> >  static irqreturn_t ipoctal_irq_handler(void *arg)
>=20
> Acked-by: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
>=20
> Sam

Greg, Would you mind picking this patch through your driver-core tree?

Thanks,

Sam

--=-oX5Y0t02YlyXWu05gaI9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJTtRp0AAoJEH/0ujLxfcNDB1kP/2cSZQu459IG/iQ5vER48T2m
vYm1V5FcjgbUt/GszCCQkzhGmuBYwW+NR46kmgeiO2zKzxCXMhfrxA7K3znJ3ylM
rr79F/v1qPrdzboPBlnGdBNbl7UqzwpVQxybEF4auRzLvsJNpIAKJIWysRPFf3QV
koZFc7ZHJShqtZ+aCgc35piP7/yWqz7gTRWSy77xN/c276xU2T8SvLxa8Ddpgfar
Gp90qOXux8Br1APiYuEVtLdfoclTdyqe90gXD7Tu+nquHohwI+A9Gb/Unn4TiPWJ
w0tgLkp9OwZ4I6LHYdre4DaQCzYtNkRd+6nYG556eKzEbhhlxJ2h2VqWUmtkN1MU
O1z/1fIYe/IJur4k3czRwyY+knF2zXr35MggtCv7ZwfPM4GdQZ5Zj0ZP720U0F10
XEI7qkpqkl3Y/0LtOOUAJSyU6YjATwIrRykevG5pZF/RlSjIezASvCZAcGJWyohM
BEWNXKatqFhv2S3CzBgEa6YprtNTOLJ/3yrJa2PHwSIuXISNAv0Ydaq2mTfUTSOw
lVIyZG+1IXsCFy7TpxpikpFiaBNLB/T1xV7RUDr5trYB7Y1Ylx+m+g0yTFQVIpJT
9FS7hQ/V6euGzF6Q+IT/Xw+BZz1MemAqjKfj+9tLbccYOe70AWL/N8g/EaWrE7ML
f8Axx5N6PKgetL2JZzvN
=CYmC
-----END PGP SIGNATURE-----

--=-oX5Y0t02YlyXWu05gaI9--

