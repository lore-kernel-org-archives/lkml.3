Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756126AbaICHxl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 03:53:41 -0400
Received: from smtp3.mundo-r.com ([212.51.32.191]:6683 "EHLO smtp4.mundo-r.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755659AbaICHxi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 03:53:38 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgYFAKvIBlRbdWOb/2dsb2JhbABagw2BKoJ8zREBgQ0Wd4QEAQUjBEASEAsYKgICVwYTiEYBp1KVeQEXGI81B4J5gVMFqV+IG4NjaoJPAQEB
X-IPAS-Result: AgYFAKvIBlRbdWOb/2dsb2JhbABagw2BKoJ8zREBgQ0Wd4QEAQUjBEASEAsYKgICVwYTiEYBp1KVeQEXGI81B4J5gVMFqV+IG4NjaoJPAQEB
X-IronPort-AV: E=Sophos;i="5.04,455,1406584800"; 
   d="asc'?scan'208";a="266281636"
Message-ID: <1409730785.9087.8.camel@fourier>
Subject: Re: [PATCH 3/3] ipoctal: get carrier driver to avoid rmmod
From: Samuel Iglesias =?ISO-8859-1?Q?Gons=E1lvez?= 
	<siglesias@igalia.com>
To: Federico Vaga <federico.vaga@cern.ch>
Cc: Jens Taprogge <jens.taprogge@taprogge.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        industrypack-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Date: Wed, 03 Sep 2014 09:53:05 +0200
In-Reply-To: <1409671901-4009-4-git-send-email-federico.vaga@cern.ch>
References: <1409671901-4009-1-git-send-email-federico.vaga@cern.ch>
	 <1409671901-4009-4-git-send-email-federico.vaga@cern.ch>
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-kyXbM1es95IrUNo3AAmy"
X-Mailer: Evolution 3.12.2-1+b1 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-kyXbM1es95IrUNo3AAmy
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable


On Tue, 2014-09-02 at 17:31 +0200, Federico Vaga wrote:
> Signed-off-by: Federico Vaga <federico.vaga@cern.ch>
> ---
>  drivers/ipack/devices/ipoctal.c |   30 +++++++++++++++++++++++++++---
>  1 file changed, 27 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/ipack/devices/ipoctal.c b/drivers/ipack/devices/ipoc=
tal.c
> index e531379..035d544 100644
> --- a/drivers/ipack/devices/ipoctal.c
> +++ b/drivers/ipack/devices/ipoctal.c
> @@ -55,6 +55,12 @@ struct ipoctal {
>  	u8 __iomem			*int_space;
>  };
> =20
> +static inline struct ipoctal *chan_to_ipoctal(struct ipoctal_channel *ch=
an,
> +					      unsigned int index)
> +{
> +	return container_of(chan, struct ipoctal, channel[index]);
> +}
> +
>  static void ipoctal_reset_channel(struct ipoctal_channel *channel)
>  {
>  	iowrite8(CR_DISABLE_RX | CR_DISABLE_TX, &channel->regs->w.cr);
> @@ -82,12 +88,20 @@ static int ipoctal_port_activate(struct tty_port *por=
t, struct tty_struct *tty)
> =20
>  static int ipoctal_open(struct tty_struct *tty, struct file *file)
>  {
> -	struct ipoctal_channel *channel;
> +	struct ipoctal_channel *channel =3D dev_get_drvdata(tty->dev);
> +	struct ipoctal *ipoctal =3D chan_to_ipoctal(channel, tty->index);
> +	int err;
> =20
> -	channel =3D dev_get_drvdata(tty->dev);
>  	tty->driver_data =3D channel;
> =20
> -	return tty_port_open(&channel->tty_port, tty, file);
> +	if (!ipack_get_carrier(ipoctal->dev))
> +		return -EBUSY;
> +
> +	err =3D tty_port_open(&channel->tty_port, tty, file);
> +	if (err)
> +		ipack_put_carrier(ipoctal->dev);
> +
> +	return err;
>  }
> =20
>  static void ipoctal_reset_stats(struct ipoctal_stats *stats)
> @@ -631,6 +645,15 @@ static void ipoctal_shutdown(struct tty_struct *tty)
>  	clear_bit(ASYNCB_INITIALIZED, &channel->tty_port.flags);
>  }
> =20
> +static void ipoctal_cleanup(struct tty_struct *tty)
> +{
> +	struct ipoctal_channel *channel =3D tty->driver_data;
> +	struct ipoctal *ipoctal =3D chan_to_ipoctal(channel, tty->index);
> +
> +	/* release the carrier driver */
> +	ipack_put_carrier(ipoctal->dev);
> +}
> +
>  static const struct tty_operations ipoctal_fops =3D {
>  	.ioctl =3D		NULL,
>  	.open =3D			ipoctal_open,
> @@ -642,6 +665,7 @@ static const struct tty_operations ipoctal_fops =3D {
>  	.get_icount =3D		ipoctal_get_icount,
>  	.hangup =3D		ipoctal_hangup,
>  	.shutdown =3D		ipoctal_shutdown,
> +	.cleanup =3D              ipoctal_cleanup,
>  };
> =20
>  static int ipoctal_probe(struct ipack_device *dev)

Acked-by: Samuel Iglesias Gonsalvez <siglesias@igalia.com>

Greg, Can you this series through your char-misc tree?

Sam



--=-kyXbM1es95IrUNo3AAmy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJUBsjiAAoJEH/0ujLxfcNDIZEP/AvFfNp8Pl1DPqTwXhNNvmPK
b100lZnwVVKc/UOv4s88GeNm6HZE5m9ain0U67du1aY2czhBxI0acjZCaLT+HY7d
DXPbRWqHGoATuyLzjIcyzhfI7TfY1UsqRsf47jZymuSSsmmgzxTW1/P2ahH3GR0B
RlUobdf8AbcAz0Zgute/LtUa45y8cNUQMBWgSGuU2pDQOh9KPvbwdd6fXJrUYqtE
2L1bz+iEkXfvEaOVKo4LOD0YzP1pOsJYsA+6Ir1224OVyAU13SP2AGWJ95Zk8t5r
DBa+tXQgd1CNDrJikweGS1Amkznwk7JEc4xFqM4qQTaleC/OPVioQAaDOC3sh+BM
4zxkmOKYUh+MJgQFOmFCKqRwnV6aKvhQoBz7+czSdKUH3+IpaxlEAmPvugIeLqr4
G2YN5Pl7bhTNwKYynEIV2lDKFIOil2V2E4FOfvH7M0EhyHFNPwi1FUHTGRqZlAuO
5WvdQpIheH8hKysui+QUqGu8fZUTLV78L7Mo35MD3k4t85KLwxN4qZaCNZQfzWtz
loAXexRHwFsdIMiTWAhdPCnjxV4/W1H/urRjE6PFhgmnSvmU/PCfp7Rh6z6HgCWT
/Ax3nbGTpTCF2dMkfE4Ea0Y0YXxKWD2n4rrrsOnd9oQxO89YbYNNUrO/KZNHhP4e
191KiRiOSzDYU342NYj4
=HucO
-----END PGP SIGNATURE-----

--=-kyXbM1es95IrUNo3AAmy--

