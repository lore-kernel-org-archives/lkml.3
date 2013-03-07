Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753065Ab3CGHLK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 02:11:10 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:52288 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752210Ab3CGHLI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 02:11:08 -0500
Date: Thu, 7 Mar 2013 08:11:03 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Andrew Chew <achew@nvidia.com>
Cc: acourbot@nvidia.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1 v4] pwm_bl: Add support for backlight enable regulator
Message-ID: <20130307071102.GB3451@avionic-0098.mockup.avionic-design.de>
References: <1362590238-27692-1-git-send-email-achew@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ftEhullJWpWg/VHq"
Content-Disposition: inline
In-Reply-To: <1362590238-27692-1-git-send-email-achew@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:qAReVEwGA9tI13jgsUtChyV/Po94I4Qky5hSHlt/3wg
 rWSiIksdHJmTpUSNIEy6nRkf5JchiTkm2Khq3jvj8DVoqt/E8J
 YkMHptq7+o2MhKHrhc0GUVFbwhSsHMdLYVQ+wBB60YrnQxYuMx
 iM5HdAabfnTGXG50eCU7OOWDNlZGgqrWDqiYdcMJPCKFp8auRE
 u1uurqdIublaEhE3Raks3Errh8VTTbMUHZ+xMQGbrJkIpVEL1x
 p+4+5SjPZwRlPilftCVM8jh19P/ht0d3oIcZLCjVMqN34C1ahz
 P6epK7MpWxibnw+LeN4gnLci5wjIKAjd+IA5se/JaYs8tGolyi
 oBoULkWgGQh3/lF3RW9FBHDNjOWK4qpFN7PQJ5PoguUPdg0bR6
 VAfkpcLhaayF51fDUyEQnshWcZoG3Zt5IkL1lixAm7dC6Bz+EQ
 4Vszz
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ftEhullJWpWg/VHq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 06, 2013 at 09:17:18AM -0800, Andrew Chew wrote:
[...]
> diff --git a/drivers/video/backlight/pwm_bl.c b/drivers/video/backlight/p=
wm_bl.c
> index 069983c..ff98cdd 100644
> --- a/drivers/video/backlight/pwm_bl.c
> +++ b/drivers/video/backlight/pwm_bl.c
> @@ -20,10 +20,13 @@
>  #include <linux/pwm.h>
>  #include <linux/pwm_backlight.h>
>  #include <linux/slab.h>
> +#include <linux/regulator/consumer.h>
> =20
>  struct pwm_bl_data {
>  	struct pwm_device	*pwm;
>  	struct device		*dev;
> +	struct regulator	*en_supply;

Can this be renamed to enable_supply to match the DT property name?

> +	bool			en_supply_enabled;

This boolean can be dropped. As discussed in a previous thread, the
pwm-backlight driver shouldn't need to know about any other uses of the
regulator.

> +static void pwm_backlight_enable(struct backlight_device *bl)
> +{
> +	struct pwm_bl_data *pb =3D dev_get_drvdata(&bl->dev);
> +
> +	pwm_enable(pb->pwm);
> +
> +	if (pb->en_supply && !pb->en_supply_enabled) {
> +		if (regulator_enable(pb->en_supply) !=3D 0)
> +			dev_warn(&bl->dev, "Failed to enable regulator");
> +		else
> +			pb->en_supply_enabled =3D true;
> +	}
> +}
> +
> +static void pwm_backlight_disable(struct backlight_device *bl)
> +{
> +	struct pwm_bl_data *pb =3D dev_get_drvdata(&bl->dev);
> +
> +	if (pb->en_supply && pb->en_supply_enabled) {
> +		if (regulator_disable(pb->en_supply) !=3D 0)
> +			dev_warn(&bl->dev, "Failed to disable regulator");
> +		else
> +			pb->en_supply_enabled =3D false;
> +	}
> +
> +	pwm_disable(pb->pwm);
> +}

Alex already brought this up: shouldn't the sequences be reversed. That
is, when enabling the backlight, turn on the regulator first, then
enable the PWM. When disabling, disable the PWM first, then turn off the
regulator?

> @@ -213,6 +238,13 @@ static int pwm_backlight_probe(struct platform_devic=
e *pdev)
>  	pb->exit =3D data->exit;
>  	pb->dev =3D &pdev->dev;
> =20
> +	pb->en_supply =3D devm_regulator_get(&pdev->dev, "enable");
> +	if (IS_ERR(pb->en_supply)) {
> +		ret =3D PTR_ERR(pb->en_supply);
> +		pb->en_supply =3D NULL;
> +		goto err_alloc;
> +	}

This effectively makes the regulator mandatory, so the board files that
use pwm-backlight need to be updated or otherwise will break.

Thierry

--ftEhullJWpWg/VHq
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJROD2GAAoJEN0jrNd/PrOhy6YP/jw5eUSP9+MOXjgq2Vkj26ap
4sNDr6mAuFbzVkZg0mz5d5SCTxkzKedKl0AErRSB9VeRuUl0EmDsgujlsbrusG38
zGs3bMUqYGlMEICgyRtyiSK7cLC1ekkXCAkM2hB4DL8vaL0Q2yWxYGFyicQzFRnq
JlN+qqG/4Yxxnh4wtzM12N3hejQgMCIZyF9TbJqo9MMnUlBsubKxkxggw+fsZu+G
dPrsNTdUvK1dQZLvkT3D6wK4UkQkWJDuT+oQySc0vp6WzH+qQQPD1X7fAlQ3R1+X
SaA8dqhGW5K/gmXHZvjHXW7vkWDUSVYSHqirKtrintzOsVRtiHh4X6h5WBw0gllz
TN9Tqst3rUp/y6Woj4WVvEYMFj7gxnOqgk0P0wLqysh2NjgUj2fCuP5GucLCa2nh
nllBSz4NhLXocUkAMnSZrhufbQXxxCp1Gq1jtECavN7JUiLGCcrC2pUm2Pz4eA+z
87PHaRHyjnusM3/9YFT05hZ9ob3wu6jOT+rOBPJAfgf2WbyQd7oEQwLUURFjdj4w
JYZ113jgecY2o0LqTD0vSFvvXTGKPBOe3OC4J3fkNSPFYCiKxpnF+7UeZ5faMRnW
OPoqsjS3eY6GYXFSuBKpQvvHKaTayBPXO/0BNNu0R/iBduNOUkWlWm8Bdrxu6Mzo
hi8zu7eOBUUofRAFI+nC
=k/jQ
-----END PGP SIGNATURE-----

--ftEhullJWpWg/VHq--
