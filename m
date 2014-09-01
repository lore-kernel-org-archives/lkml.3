Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753731AbaIAMmq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 08:42:46 -0400
Received: from smtp3.mundo-r.com ([212.51.32.191]:59429 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752976AbaIAMm2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 08:42:28 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AiMFAGZpBFRbdWOb/2dsb2JhbABZgw2BKoJ8zFMBgRUWd4QEAQUjBFIQCxgqAgJXBhOIRgGlI5ReARcYiWiEaWQHgnmBUwWPHaJdg2NqgQaBSQEBAQ
X-IPAS-Result: AiMFAGZpBFRbdWOb/2dsb2JhbABZgw2BKoJ8zFMBgRUWd4QEAQUjBFIQCxgqAgJXBhOIRgGlI5ReARcYiWiEaWQHgnmBUwWPHaJdg2NqgQaBSQEBAQ
X-IronPort-AV: E=Sophos;i="5.04,442,1406584800"; 
   d="asc'?scan'208";a="254453299"
Message-ID: <1409575325.8116.0.camel@fourier>
Subject: Re: [PATCH] ipoctal: clear break interrupt as soon as it occurs
From: Samuel Iglesias =?ISO-8859-1?Q?Gons=E1lvez?= 
	<siglesias@igalia.com>
To: Federico Vaga <federico.vaga@cern.ch>
Cc: Jens Taprogge <jens.taprogge@taprogge.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        industrypack-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Date: Mon, 01 Sep 2014 14:42:05 +0200
In-Reply-To: <1409572196-15015-1-git-send-email-federico.vaga@cern.ch>
References: <1409572196-15015-1-git-send-email-federico.vaga@cern.ch>
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-ufMJEfq+4ELPxZKQRsd5"
X-Mailer: Evolution 3.12.2-1+b1 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-ufMJEfq+4ELPxZKQRsd5
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2014-09-01 at 13:49 +0200, Federico Vaga wrote:
> In some condition we receive the break interrupt but nothing is putted
> in the Rx FIFO and the correspondend bit in the status register is not
> set. Thus, no-one clear the interrupt and the handler will be called
> forever.
>=20
> This patch clear the break interrupt as soon as it occurs. Then, if the
> break character '\0' is putted in the fifo we will manage it.
>=20
> We can also unmask the Break interrupt but its bit in ISR is still set
> on break. So I think is better to keep the registers clean.
>=20
> Signed-off-by: Federico Vaga <federico.vaga@cern.ch>
> ---
>  drivers/ipack/devices/ipoctal.c |    4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/ipack/devices/ipoctal.c b/drivers/ipack/devices/ipoc=
tal.c
> index e41bef0..90b96a1b 100644
> --- a/drivers/ipack/devices/ipoctal.c
> +++ b/drivers/ipack/devices/ipoctal.c
> @@ -151,7 +151,6 @@ static void ipoctal_irq_rx(struct ipoctal_channel *ch=
annel, u8 sr)
>  				flag =3D TTY_FRAME;
>  			}
>  			if (sr & SR_RECEIVED_BREAK) {
> -				iowrite8(CR_CMD_RESET_BREAK_CHANGE, &channel->regs->w.cr);
>  				channel->stats.rcv_break++;
>  				flag =3D TTY_BREAK;
>  			}
> @@ -196,6 +195,9 @@ static void ipoctal_irq_channel(struct ipoctal_channe=
l *channel)
>  	isr =3D ioread8(&channel->block_regs->r.isr);
>  	sr =3D ioread8(&channel->regs->r.sr);
> =20
> +	if (isr & (IMR_DELTA_BREAK_A | IMR_DELTA_BREAK_B))
> +		iowrite8(CR_CMD_RESET_BREAK_CHANGE, &channel->regs->w.cr);
> +
>  	if ((sr & SR_TX_EMPTY) && (channel->nb_bytes =3D=3D 0)) {
>  		iowrite8(CR_DISABLE_TX, &channel->regs->w.cr);
>  		/* In case of RS-485, change from TX to RX when finishing TX.

Acked-by: Samuel Iglesias Gonsalvez <siglesias@igalia.com>

Thanks for the patch!

Greg, Would you mind picking this patch through your char-misc tree?

Sam

--=-ufMJEfq+4ELPxZKQRsd5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJUBGmdAAoJEH/0ujLxfcND0aAP/2DwY1ZJ+bvCZYO8Q8pFQ6Nk
QZrkKQwUMINvLqlHXzWe8IAbHeUZj/HGr6OznxCrVcpelbX0+cWFKMd4XnHnONqP
yF2Qoyxi++L60b/4qZBWNd1PBC6mDjF7wZ8PFcpsxTp73FR4GuC4N56lRvWPp2pG
pctgSV83dRSh7nJuGX1+12egzTM9zF1Xsuerl/sHOrX/l5PBWImt6D8uryoCus1o
bNzMEOTeEEDOhdW0V7vpHlSbprW7OHnGPypiScer1PuHHYZ8TsbxaQmyMso1Cr2V
zp9/n5ouWrNBMKX33TQtKms7YJyA094+Hw0XM8kFsa1r+IfEIzhIJVxBGBLtKX6D
6wlAKJW2Gxb3deU1O8iDHSagSiU3vyHQaOnyVf5gN6Y5hpPodFetGw8cPHzKD1pa
7H1st6wZXG5+duPZ/INJL2aL94y5rNPSu/f5vTfdUILnVCn6akjZSU18H/GcKQzC
K+P/SjoppOZo65b6MsdTNGYCjqkLF6Isd4aeRy/S2MZig4isWPNQAhhToD2GMdN1
IJgtPyyiW9D7x1mDTsm2nF6q/zNp4fkw/0igyEYYKNy280uFVNWlvPqDjMVCXky+
wjWSWvcHurjWkNL6aDMshbmPXhWQmUHlyUzVyAPEtX1RQnLbF5xL6+eQoS+rc1T9
40t8xPCNJFi4M2adKB9S
=UQXR
-----END PGP SIGNATURE-----

--=-ufMJEfq+4ELPxZKQRsd5--

