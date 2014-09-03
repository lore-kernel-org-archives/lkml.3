Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756107AbaICHxh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 03:53:37 -0400
Received: from smtp3.mundo-r.com ([212.51.32.191]:6683 "EHLO smtp4.mundo-r.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751114AbaICHxf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 03:53:35 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgcFAKvIBlRbdWOb/2dsb2JhbABagw2BKoJ8zREBgQ0Wd4QDAQEEASMEQBIFCwsYKgICVwYTiDoMAadSlXkBFxiPNQeCeYFTBalfiBuDY2qCTwEBAQ
X-IPAS-Result: AgcFAKvIBlRbdWOb/2dsb2JhbABagw2BKoJ8zREBgQ0Wd4QDAQEEASMEQBIFCwsYKgICVwYTiDoMAadSlXkBFxiPNQeCeYFTBalfiBuDY2qCTwEBAQ
X-IronPort-AV: E=Sophos;i="5.04,455,1406584800"; 
   d="asc'?scan'208";a="266281578"
Message-ID: <1409730775.9087.7.camel@fourier>
Subject: Re: [PATCH 2/3] ipack: save carrier owner to allow device to get it
From: Samuel Iglesias =?ISO-8859-1?Q?Gons=E1lvez?= 
	<siglesias@igalia.com>
To: Federico Vaga <federico.vaga@cern.ch>
Cc: Jens Taprogge <jens.taprogge@taprogge.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        industrypack-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Date: Wed, 03 Sep 2014 09:52:55 +0200
In-Reply-To: <1409671901-4009-3-git-send-email-federico.vaga@cern.ch>
References: <1409671901-4009-1-git-send-email-federico.vaga@cern.ch>
	 <1409671901-4009-3-git-send-email-federico.vaga@cern.ch>
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-0SpTRX/RFW+uQGJWDCLW"
X-Mailer: Evolution 3.12.2-1+b1 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-0SpTRX/RFW+uQGJWDCLW
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable


On Tue, 2014-09-02 at 17:31 +0200, Federico Vaga wrote:
> There was not any kind of protection against carrier driver removal.
> In this way, device driver can 'get' the carrier driver when it is
> using it.
>=20
> Signed-off-by: Federico Vaga <federico.vaga@cern.ch>
> ---
>  drivers/ipack/carriers/tpci200.c |    3 ++-
>  drivers/ipack/ipack.c            |    4 +++-
>  include/linux/ipack.h            |   24 +++++++++++++++++++++++-
>  3 files changed, 28 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/ipack/carriers/tpci200.c b/drivers/ipack/carriers/tp=
ci200.c
> index de5e321..9b23843 100644
> --- a/drivers/ipack/carriers/tpci200.c
> +++ b/drivers/ipack/carriers/tpci200.c
> @@ -572,7 +572,8 @@ static int tpci200_pci_probe(struct pci_dev *pdev,
>  	/* Register the carrier in the industry pack bus driver */
>  	tpci200->info->ipack_bus =3D ipack_bus_register(&pdev->dev,
>  						      TPCI200_NB_SLOT,
> -						      &tpci200_bus_ops);
> +						      &tpci200_bus_ops,
> +						      THIS_MODULE);
>  	if (!tpci200->info->ipack_bus) {
>  		dev_err(&pdev->dev,
>  			"error registering the carrier on ipack driver\n");
> diff --git a/drivers/ipack/ipack.c b/drivers/ipack/ipack.c
> index d0016ba..c0e7b62 100644
> --- a/drivers/ipack/ipack.c
> +++ b/drivers/ipack/ipack.c
> @@ -206,7 +206,8 @@ static struct bus_type ipack_bus_type =3D {
>  };
> =20
>  struct ipack_bus_device *ipack_bus_register(struct device *parent, int s=
lots,
> -					    const struct ipack_bus_ops *ops)
> +					    const struct ipack_bus_ops *ops,
> +					    struct module *owner)
>  {
>  	int bus_nr;
>  	struct ipack_bus_device *bus;
> @@ -225,6 +226,7 @@ struct ipack_bus_device *ipack_bus_register(struct de=
vice *parent, int slots,
>  	bus->parent =3D parent;
>  	bus->slots =3D slots;
>  	bus->ops =3D ops;
> +	bus->owner =3D owner;
>  	return bus;
>  }
>  EXPORT_SYMBOL_GPL(ipack_bus_register);
> diff --git a/include/linux/ipack.h b/include/linux/ipack.h
> index 1888e06..8bddc3f 100644
> --- a/include/linux/ipack.h
> +++ b/include/linux/ipack.h
> @@ -172,6 +172,7 @@ struct ipack_bus_ops {
>   *	@ops: bus operations for the mezzanine drivers
>   */
>  struct ipack_bus_device {
> +	struct module *owner;
>  	struct device *parent;
>  	int slots;
>  	int bus_nr;
> @@ -189,7 +190,8 @@ struct ipack_bus_device {
>   * available bus device in ipack.
>   */
>  struct ipack_bus_device *ipack_bus_register(struct device *parent, int s=
lots,
> -					    const struct ipack_bus_ops *ops);
> +					    const struct ipack_bus_ops *ops,
> +					    struct module *owner);
> =20
>  /**
>   *	ipack_bus_unregister -- unregister an ipack bus
> @@ -265,3 +267,23 @@ void ipack_put_device(struct ipack_device *dev);
>  	 .format =3D (_format), \
>  	 .vendor =3D (vend), \
>  	 .device =3D (dev)
> +
> +/**
> + * ipack_get_carrier - it increase the carrier ref. counter of
> + *                     the carrier module
> + * @dev: mezzanine device which wants to get the carrier
> + */
> +static inline int ipack_get_carrier(struct ipack_device *dev)
> +{
> +	return try_module_get(dev->bus->owner);
> +}
> +
> +/**
> + * ipack_get_carrier - it decrease the carrier ref. counter of
> + *                     the carrier module
> + * @dev: mezzanine device which wants to get the carrier
> + */
> +static inline void ipack_put_carrier(struct ipack_device *dev)
> +{
> +	module_put(dev->bus->owner);
> +}

Acked-by: Samuel Iglesias Gonsalvez <siglesias@igalia.com>

Sam


--=-0SpTRX/RFW+uQGJWDCLW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJUBsjXAAoJEH/0ujLxfcNDTsIQAM3/+yMSpzFI//e0qLV6g86X
AjHahAskrtEgEcMDgzYS755uirW6IAcfQxul1ik4NlRy4kEUFAhdwxDYLvwDvjLE
0oX7yeuWn41i/W4wNz9GI6DdxqbeVkBpea5miUiY1wnSZnoHsBuYfsdc8p2DqYEV
LO7Bnc8ZcRR3MyO2fuXQgkW/k6EB2T/GVsgoKEPxzz2udkiejDg2a7cnBb6X+ROt
cqivwZ7U2dd5k7aEJ6i/+Jd80VXQbVKIFExZHpRfkm1Nmn2pp4CG6Xdw6hW+Jc+k
9MBoJTWKEcPaFvIMyf2AeVlZSuqR44GoRE3xPnsm8nu8V0Nzd8AUR9fl399wVaj0
gjzpEvMv+zqFTElJkUrnIxVgiPeqxKTmkIng68+aDwR6HQLaAybv1bUK445s8pMA
NBBqDQbH+0dHu3BbL9BY/vZiAmfq/PzsMunjYMDEL+oVCz6AazralCeXRKhQwmwq
uXoybOd+I4A87efN3TvYJJyECrGThipFgw+1p1CByhXiScChnHLyUViaabH30RV7
MSK/nm37AfGbpYyfoHBCViTnVkjMufh38ro++ZH8JyvMsu6gSoGZFlowWapO9w13
Li9Y0MxCs2b5WcR8m2BPCLBComKhU8caCew40DgrZ3VUoYxT85kIsG0wHDC9CbFI
6RSx9Iyz6S/KyiMrPvpn
=iFD/
-----END PGP SIGNATURE-----

--=-0SpTRX/RFW+uQGJWDCLW--

