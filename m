Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759253Ab3GZPnf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 11:43:35 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:57079 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757958Ab3GZPnc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 11:43:32 -0400
Message-ID: <51F2991B.3060704@ti.com>
Date: Fri, 26 Jul 2013 11:43:23 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Wolfram Sang <wsa@the-dreams.de>
CC: <linux-kernel@vger.kernel.org>, Eduardo Valentin <eduardo.valentin@ti.com>,
        Zhang Rui <rui.zhang@intel.com>, <linux-pm@vger.kernel.org>
Subject: Re: [PATCH 27/27] thermal: ti-bandgap: cleanup resource allocation
References: <1374602524-3398-1-git-send-email-wsa@the-dreams.de> <1374602524-3398-28-git-send-email-wsa@the-dreams.de>
In-Reply-To: <1374602524-3398-28-git-send-email-wsa@the-dreams.de>
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature";
	boundary="RrWdVxQg0XPUDmftcJlbS2saSU0pF6n5R"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--RrWdVxQg0XPUDmftcJlbS2saSU0pF6n5R
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 23-07-2013 14:02, Wolfram Sang wrote:
> When cleaning up usage of devm_ioremap_resource, I found that resource
> allocation in this driver is ugly and buggy. If resource[0] is not
> found, bgp->base will end up NULL, so OOPS. All other resources get
> ioremapped, but their pointers are discarded, so why bother. So, let's
> keep things simple. Just remap resource[0] and pass the error, if any.
> Compile tested only, due to no hardware.


Nack, this will actually break the driver. This device has several
sections of registers, and not a single io region. Check
Documentation/devicetree/bindings/thermal/ti_soc_thermal.txt for examples=
=2E

>=20
> Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
> ---
> Please apply via the subsystem-tree.
>=20
>  drivers/thermal/ti-soc-thermal/ti-bandgap.c |   20 ++++---------------=
-
>  1 file changed, 4 insertions(+), 16 deletions(-)
>=20
> diff --git a/drivers/thermal/ti-soc-thermal/ti-bandgap.c b/drivers/ther=
mal/ti-soc-thermal/ti-bandgap.c
> index 9dfd471..416be5d 100644
> --- a/drivers/thermal/ti-soc-thermal/ti-bandgap.c
> +++ b/drivers/thermal/ti-soc-thermal/ti-bandgap.c
> @@ -1130,7 +1130,6 @@ static struct ti_bandgap *ti_bandgap_build(struct=
 platform_device *pdev)
>  	const struct of_device_id *of_id;
>  	struct ti_bandgap *bgp;
>  	struct resource *res;
> -	int i;
> =20
>  	/* just for the sake */
>  	if (!node) {
> @@ -1156,21 +1155,10 @@ static struct ti_bandgap *ti_bandgap_build(stru=
ct platform_device *pdev)
>  		return ERR_PTR(-ENOMEM);
>  	}
> =20
> -	i =3D 0;
> -	do {
> -		void __iomem *chunk;
> -
> -		res =3D platform_get_resource(pdev, IORESOURCE_MEM, i);
> -		if (!res)
> -			break;
> -		chunk =3D devm_ioremap_resource(&pdev->dev, res);
> -		if (i =3D=3D 0)
> -			bgp->base =3D chunk;
> -		if (IS_ERR(chunk))
> -			return ERR_CAST(chunk);

In case resource 0 is not found, the error will be repassed.

> -
> -		i++;
> -	} while (res);

And yes, other IORESOURCE_MEM resources are required, depending on chip
version.

> +	res =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	bgp->base =3D devm_ioremap_resource(&pdev->dev, res);
> +	if (IS_ERR(bgp->base))
> +		return bgp->base;
> =20
>  	if (TI_BANDGAP_HAS(bgp, TSHUT)) {
>  		bgp->tshut_gpio =3D of_get_gpio(node, 0);
>=20


--=20
You have got to be excited about what you are doing. (L. Lamport)

Eduardo Valentin


--RrWdVxQg0XPUDmftcJlbS2saSU0pF6n5R
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iF4EAREIAAYFAlHymRsACgkQCXcVR3XQvP08bAD/WXdE1xeKFwlIvkKhT0IauKxb
7x1mE/697WxMBSqbF9QBAIyocfKaM18iaZwmBxqNq7tGacxuArm1XTqnBHZr1C5r
=Ur7J
-----END PGP SIGNATURE-----

--RrWdVxQg0XPUDmftcJlbS2saSU0pF6n5R--
