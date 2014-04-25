Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752464AbaDYPOz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 11:14:55 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:58319 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751824AbaDYPOy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 11:14:54 -0400
Date: Fri, 25 Apr 2014 10:14:34 -0500
From: Felipe Balbi <balbi@ti.com>
To: Chanwoo Choi <cw00.choi@samsung.com>
CC: <linux-kernel@vger.kernel.org>, <myungjoo.ham@samsung.com>, <balbi@ti.com>,
        <gg@slimlogic.co.uk>, <kishon@ti.com>,
        <ckeepax@opensource.wolfsonmicro.com>, <broonie@kernel.org>,
        <k.kozlowski@samsung.com>, <kyungmin.park@samsung.com>
Subject: Re: [PATCHv4 2/9] extcon: Add devm_extcon_dev_allocate/free to
 manage the resource of extcon device
Message-ID: <20140425151434.GF29632@saruman.home>
Reply-To: <balbi@ti.com>
References: <1398386544-16295-1-git-send-email-cw00.choi@samsung.com>
 <1398386544-16295-3-git-send-email-cw00.choi@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="b8GWCKCLzrXbuNet"
Content-Disposition: inline
In-Reply-To: <1398386544-16295-3-git-send-email-cw00.choi@samsung.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--b8GWCKCLzrXbuNet
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 25, 2014 at 09:42:17AM +0900, Chanwoo Choi wrote:
> This patch add device managed devm_extcon_dev_{allocate,free} to automati=
cally
> free the memory of extcon_dev structure without handling free operation.
>=20
> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>

apart for a couple comments below:

Reviewed-by: Felipe Balbi <balbi@ti.com>

> ---
>  drivers/extcon/extcon-class.c | 72 +++++++++++++++++++++++++++++++++++--=
------
>  include/linux/extcon.h        | 11 +++++++
>  2 files changed, 71 insertions(+), 12 deletions(-)
>=20
> diff --git a/drivers/extcon/extcon-class.c b/drivers/extcon/extcon-class.c
> index 654ed52..24ede8b 100644
> --- a/drivers/extcon/extcon-class.c
> +++ b/drivers/extcon/extcon-class.c
> @@ -601,6 +601,66 @@ void extcon_dev_free(struct extcon_dev *edev)
>  }
>  EXPORT_SYMBOL_GPL(extcon_dev_free);
> =20
> +static int devm_extcon_dev_match(struct device *dev, void *res, void *da=
ta)
> +{
> +	struct extcon_dev **r =3D res;
> +
> +	if (!r || !*r) {
> +		WARN_ON(!r || !*r);

you can use WARN_ON() inside the if statement:

	if (WARN_ON(!r || !*r))
		return 0;

> +		return 0;
> +	}
> +
> +	return *r =3D=3D data;
> +}
> +
> +static void devm_extcon_dev_release(struct device *dev, void *res)
> +{
> +	extcon_dev_free(*(struct extcon_dev **)res);
> +}
> +
> +/**
> + * devm_extcon_dev_allocate - Allocate managed extcon device
> + * @dev:		device owning the extcon device being created
> + * @supported_cable:	Array of supported cable names ending with NULL.
> + *			If supported_cable is NULL, cable name related APIs
> + *			are disabled.
> + *
> + * This function manages automatically the memory of extcon device using=
 device
> + * resource management and simplify the control of freeing the memory of=
 extcon
> + * device.
> + *
> + * Returns the pointer memory of allocated extcon_dev if success
> + * or ERR_PTR(err) if fail
> + */
> +struct extcon_dev *devm_extcon_dev_allocate(struct device *dev,
> +					    const char **supported_cable)
> +{
> +	struct extcon_dev **ptr, *edev;
> +
> +	ptr =3D devres_alloc(devm_extcon_dev_release, sizeof(*ptr), GFP_KERNEL);
> +	if (!ptr)
> +		return ERR_PTR(-ENOMEM);
> +
> +	edev =3D extcon_dev_allocate(supported_cable);
> +	if (IS_ERR(edev)) {
> +		devres_free(ptr);
> +		return ERR_PTR(-ENOMEM);

edev already is an error pointer, you might want to propagate that error
instead of rewriting it here.

> +	}
> +
> +	*ptr =3D edev;
> +	devres_add(dev, ptr);
> +
> +	return edev;
> +}
> +EXPORT_SYMBOL_GPL(devm_extcon_dev_allocate);
> +
> +void devm_extcon_dev_free(struct device *dev, struct extcon_dev *edev)
> +{
> +	WARN_ON(devres_release(dev, devm_extcon_dev_release,
> +			       devm_extcon_dev_match, edev));
> +}
> +EXPORT_SYMBOL_GPL(devm_extcon_dev_free);
> +
>  /**
>   * extcon_dev_register() - Register a new extcon device
>   * @edev	: the new extcon device (should be allocated before calling)
> @@ -860,18 +920,6 @@ static void devm_extcon_dev_unreg(struct device *dev=
, void *res)
>  	extcon_dev_unregister(*(struct extcon_dev **)res);
>  }
> =20
> -static int devm_extcon_dev_match(struct device *dev, void *res, void *da=
ta)
> -{
> -	struct extcon_dev **r =3D res;
> -
> -	if (!r || !*r) {
> -		WARN_ON(!r || !*r);
> -		return 0;
> -	}
> -
> -	return *r =3D=3D data;
> -}
> -
>  /**
>   * devm_extcon_dev_register() - Resource-managed extcon_dev_register()
>   * @dev:	device to allocate extcon device
> diff --git a/include/linux/extcon.h b/include/linux/extcon.h
> index f4fc983..3fd831b 100644
> --- a/include/linux/extcon.h
> +++ b/include/linux/extcon.h
> @@ -196,6 +196,9 @@ extern struct extcon_dev *extcon_get_extcon_dev(const=
 char *extcon_name);
>   */
>  extern struct extcon_dev *extcon_dev_allocate(const char **cables);
>  extern void extcon_dev_free(struct extcon_dev *edev);
> +extern struct extcon_dev *devm_extcon_dev_allocate(struct device *dev,
> +						   const char **cables);
> +extern void devm_extcon_dev_free(struct device *dev, struct extcon_dev *=
edev);
> =20
>  /*
>   * get/set/update_state access the 32b encoded state value, which repres=
ents
> @@ -280,6 +283,14 @@ static inline struct extcon_dev *extcon_dev_allocate=
(const char **cables)
> =20
>  static inline void extcon_dev_free(struct extcon_dev *edev) { }
> =20
> +static inline struct extcon_dev *devm_extcon_dev_allocate(struct device =
*dev,
> +							  const char **cables)
> +{
> +	return ERR_PTR(-ENOMEM);

-ENOSYS

--=20
balbi

--b8GWCKCLzrXbuNet
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTWnvaAAoJEIaOsuA1yqREqCEP/1Sa8ORwHY3GUIAY1/IwxgZm
5OuUNJQyFOpGaJmXkElCxcjFw68ujSuslq9P3Fji65g/jj4R8Rmwc7mcuD1pdsQO
y+hHzyu+0pDj43lBE40oLwBxIsHgsgoUenmys8gnN6omBVWvzRqUpM0ka90amUff
SDG+Euv4fJCkIPR1jPqqGhA5WVjeaykighfPbVW2FzR5k2+YlgXIHxxeSGuCORK0
zgMqZEcN6W6SOahUkN0xsC4mXxmtSFdjeFDtUhnjSbPO5Q+iJf/M36l9+LsNX8qU
HGKpkQ7q6i0ZDWBFaSTQjg6ScPP7OhcrhfBdHWRvAPHnetRpHlBcQHAf2MUzIrp+
I7AsN3JqJ00XKEphofvaHXyDv73+bX8TWNi/fIv+KhlaOT95id73b8bvigmV4PP2
uAW7Vzbq4xaTKuXoqiesPLxIFeVeKeBHni+EBNkGZQaYHlJmVGWuVhMHQnnI3g6R
SjPM1YdLrL6YB4a4jniI9GJjLTH2SAXFfLACaL8ADRdUot7e1GSohUPhkXyco13V
Gzkb/Ia3qiClR0/Vn5UYcbdHFZIlHdbatFyzSIF/bQD3NAzEKBE5k07u989DH4WK
9RAfa/d+TS/KtagbkJVtkTANS0IKym8Gs7bCOreRJsGf76F5QPsMnM/vqhGzxzrk
hAwnKJ3CLI2oy+cjxa6m
=Yvui
-----END PGP SIGNATURE-----

--b8GWCKCLzrXbuNet--
