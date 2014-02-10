Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752772AbaBJPmS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 10:42:18 -0500
Received: from mail-ee0-f54.google.com ([74.125.83.54]:60673 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752549AbaBJPmO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 10:42:14 -0500
Message-ID: <52F8F34E.3030606@monstr.eu>
Date: Mon, 10 Feb 2014 16:42:06 +0100
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Michal Simek <michal.simek@xilinx.com>
CC: linux-arm-kernel@lists.infradead.org, Arnd Bergmann <arnd@arndb.de>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 2/3] mfd: syscon: Support early initialization
References: <cover.1392045742.git.michal.simek@xilinx.com> <1785585d090175da81b561b17eeef95d991ff0de.1392045742.git.michal.simek@xilinx.com>
In-Reply-To: <1785585d090175da81b561b17eeef95d991ff0de.1392045742.git.michal.simek@xilinx.com>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="bBmlV2EG5GIXAvhUUg74kqEBRL8tBCFEO"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--bBmlV2EG5GIXAvhUUg74kqEBRL8tBCFEO
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 02/10/2014 04:22 PM, Michal Simek wrote:
> Some platforms need to get system controller
> ready as soon as possible.
> The patch provides early_syscon_initialization
> which create early mapping for all syscon compatible
> devices in early_syscon_probe.
> Regmap is get via syscon_early_regmap_lookup_by_phandle()
>=20
> Regular device probes attach device to regmap
> via regmap_attach_dev().
>=20
> For early syscon initialization is necessary to extend
> struct syscon and provide remove function
> which unmap all early init structures.
>=20
> Signed-off-by: Michal Simek <michal.simek@xilinx.com>
> ---
>=20
>  drivers/mfd/syscon.c       | 126 +++++++++++++++++++++++++++++++++++++=
++------
>  include/linux/mfd/syscon.h |  11 ++++
>  2 files changed, 120 insertions(+), 17 deletions(-)
>=20
> diff --git a/drivers/mfd/syscon.c b/drivers/mfd/syscon.c
> index 71841f9..5935f02 100644
> --- a/drivers/mfd/syscon.c
> +++ b/drivers/mfd/syscon.c
> @@ -20,12 +20,15 @@
>  #include <linux/of_platform.h>
>  #include <linux/platform_device.h>
>  #include <linux/regmap.h>
> +#include <linux/slab.h>
>  #include <linux/mfd/syscon.h>
>=20
>  static struct platform_driver syscon_driver;
>=20
>  struct syscon {
> +	void __iomem *base;
>  	struct regmap *regmap;
> +	struct resource res;
>  };
>=20
>  static int syscon_match_node(struct device *dev, void *data)
> @@ -95,6 +98,24 @@ struct regmap *syscon_regmap_lookup_by_pdevname(cons=
t char *s)
>  }
>  EXPORT_SYMBOL_GPL(syscon_regmap_lookup_by_pdevname);
>=20
> +struct regmap *syscon_early_regmap_lookup_by_phandle(struct device_nod=
e *np,
> +						     const char *property)
> +{
> +	struct device_node *syscon_np;
> +	struct syscon *syscon;
> +
> +	syscon_np =3D of_parse_phandle(np, property, 0);
> +	if (!syscon_np)
> +		return ERR_PTR(-ENODEV);
> +
> +	syscon =3D syscon_np->data;
> +
> +	of_node_put(syscon_np);
> +
> +	return syscon->regmap;
> +}
> +EXPORT_SYMBOL_GPL(syscon_early_regmap_lookup_by_phandle);
> +
>  struct regmap *syscon_regmap_lookup_by_phandle(struct device_node *np,=

>  					const char *property)
>  {
> @@ -128,40 +149,110 @@ static int syscon_probe(struct platform_device *=
pdev)
>  	struct device *dev =3D &pdev->dev;
>  	struct syscon *syscon;
>  	struct resource *res;
> -	void __iomem *base;
>=20
> -	syscon =3D devm_kzalloc(dev, sizeof(*syscon), GFP_KERNEL);
> +	/* Early syscon init */
> +	if (pdev->dev.of_node && pdev->dev.of_node->data) {
> +		syscon =3D pdev->dev.of_node->data;
> +		res =3D &syscon->res;
> +		regmap_attach_dev(dev, syscon->regmap, &syscon_regmap_config);
> +	} else {
> +
> +		syscon =3D devm_kzalloc(dev, sizeof(*syscon), GFP_KERNEL);
> +		if (!syscon)
> +			return -ENOMEM;
> +
> +		res =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +		if (!res)
> +			return -ENOENT;
> +
> +		syscon->base =3D devm_ioremap(dev, res->start,
> +					    resource_size(res));
> +		if (!syscon->base)
> +			return -ENOMEM;
> +
> +		syscon_regmap_config.max_register =3D res->end - res->start - 3;
> +		syscon->regmap =3D devm_regmap_init_mmio(dev, syscon->base,
> +						&syscon_regmap_config);
> +		if (IS_ERR(syscon->regmap)) {
> +			dev_err(dev, "regmap init failed\n");
> +			return PTR_ERR(syscon->regmap);
> +		}
> +	}
> +
> +	platform_set_drvdata(pdev, syscon);
> +
> +	dev_info(dev, "regmap %pR registered\n", res);
> +
> +	return 0;
> +}
> +
> +static const struct platform_device_id syscon_ids[] =3D {
> +	{ "syscon", },
> +	{ }
> +};
> +
> +static int syscon_remove(struct platform_device *pdev)
> +{
> +	struct syscon *syscon =3D platform_get_drvdata(pdev);
> +
> +	if (pdev->dev.of_node && pdev->dev.of_node->data) {
> +		iounmap(syscon->base);
> +		kfree(syscon);
> +	}
> +
> +	return 0;
> +}
> +
> +static int early_syscon_probe(struct device_node *np)
> +{
> +	struct syscon *syscon;
> +
> +	syscon =3D kzalloc(sizeof(*syscon), GFP_KERNEL);
>  	if (!syscon)
>  		return -ENOMEM;
>=20
> -	res =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);
> -	if (!res)
> -		return -ENOENT;
> +	if (of_address_to_resource(np, 0, &syscon->res))
> +		return -EINVAL;
>=20
> -	base =3D devm_ioremap(dev, res->start, resource_size(res));
> -	if (!base)
> -		return -ENOMEM;
> +	syscon->base =3D ioremap(syscon->res.start, resource_size(&syscon->re=
s));
> +	if (!syscon->base) {
> +		pr_err("%s: Unable to map I/O memory\n", __func__);
> +		return PTR_ERR(syscon->base);
> +	}
>=20
> -	syscon_regmap_config.max_register =3D res->end - res->start - 3;
> -	syscon->regmap =3D devm_regmap_init_mmio(dev, base,
> -					&syscon_regmap_config);
> +	syscon_regmap_config.max_register =3D syscon->res.end -
> +					    syscon->res.start - 3;
> +	syscon->regmap =3D regmap_init_mmio(NULL, syscon->base,
> +					  &syscon_regmap_config);
>  	if (IS_ERR(syscon->regmap)) {
> -		dev_err(dev, "regmap init failed\n");
> +		pr_err("regmap init failed\n");
>  		return PTR_ERR(syscon->regmap);
>  	}
>=20
> -	platform_set_drvdata(pdev, syscon);
> +	np->data =3D syscon;
>=20
> -	dev_info(dev, "regmap %pR registered\n", res);
> +	of_node_put(np);
> +
> +	pr_info("%s: regmap %pR registered\n", np->full_name, &syscon->res);
>=20
>  	return 0;
>  }
>=20
> -static const struct platform_device_id syscon_ids[] =3D {
> -	{ "syscon", },
> -	{ }
> +static struct of_device_id of_syscon_ids[] =3D {
> +	{ .compatible =3D "syscon" },
> +	{},
>  };
>=20
> +void __init early_syscon_init(void)
> +{
> +	struct device_node *np;
> +
> +	for_each_matching_node_and_match(np, of_syscon_ids, NULL) {
> +		if (!early_syscon_probe(np))

just
if (early_syscon_probe(np))
	BUG();
here.

Thanks,
Michal

--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



--bBmlV2EG5GIXAvhUUg74kqEBRL8tBCFEO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlL4804ACgkQykllyylKDCEb1ACfeOLn2F2Ue4SYoRug8BV0aHDc
bYIAn34lFYKo0GUc32/6WTwpVI4QntTW
=pFtV
-----END PGP SIGNATURE-----

--bBmlV2EG5GIXAvhUUg74kqEBRL8tBCFEO--
