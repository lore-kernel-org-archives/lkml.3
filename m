Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753794Ab3EIOob (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 10:44:31 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:39233 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752821Ab3EIOo3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 10:44:29 -0400
Message-ID: <518BB63E.4050006@ti.com>
Date: Thu, 9 May 2013 10:44:14 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130404 Thunderbird/17.0.5
MIME-Version: 1.0
To: Amit Daniel Kachhap <amit.daniel@samsung.com>
CC: <linux-pm@vger.kernel.org>, Zhang Rui <rui.zhang@intel.com>,
        <linux-samsung-soc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <amit.kachhap@gmail.com>, Kukjin Kim <kgene.kim@samsung.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>
Subject: Re: [PATCH V3 20/21] thermal: exynos: Support for TMU regulator defined
 at device tree
References: <1367931671-3906-1-git-send-email-amit.daniel@samsung.com> <1367931671-3906-21-git-send-email-amit.daniel@samsung.com>
In-Reply-To: <1367931671-3906-21-git-send-email-amit.daniel@samsung.com>
X-Enigmail-Version: 1.5.1
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature";
	boundary="----enig2TEQTVBUDMNCGSLQGPGXQ"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------enig2TEQTVBUDMNCGSLQGPGXQ
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 07-05-2013 09:01, Amit Daniel Kachhap wrote:
> TMU probe function now checks for a device tree defined regulator.
> For compatibility reasons it is allowed to probe driver even without
> this regulator defined.
>=20
> Signed-off-by: Lukasz Majewski <l.majewski@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> Signed-off-by: Amit Daniel Kachhap <amit.daniel@samsung.com>
> ---
>  .../devicetree/bindings/thermal/exynos-thermal.txt |    4 ++++
>  drivers/thermal/samsung/exynos_tmu.c               |   19 ++++++++++++=
+++++++
>  2 files changed, 23 insertions(+), 0 deletions(-)
>=20
> diff --git a/Documentation/devicetree/bindings/thermal/exynos-thermal.t=
xt b/Documentation/devicetree/bindings/thermal/exynos-thermal.txt
> index 970eeba..ff62f7a 100644
> --- a/Documentation/devicetree/bindings/thermal/exynos-thermal.txt
> +++ b/Documentation/devicetree/bindings/thermal/exynos-thermal.txt
> @@ -14,6 +14,9 @@
>  - interrupts : Should contain interrupt for thermal system
>  - clocks : The main clock for TMU device
>  - clock-names : Thermal system clock name
> +- vtmu-supply: This entry is optional and provides the regulator node =
supplying
> +		voltage to TMU. If needed this entry can be placed inside
> +		board/platform specific dts file.
> =20
>  Example 1):
> =20
> @@ -25,6 +28,7 @@ Example 1):
>  		clocks =3D <&clock 383>;
>  		clock-names =3D "tmu_apbif";
>  		status =3D "disabled";
> +		vtmu-supply =3D <&tmu_regulator_node>;
>  	};
> =20
>  Example 2):
> diff --git a/drivers/thermal/samsung/exynos_tmu.c b/drivers/thermal/sam=
sung/exynos_tmu.c
> index 72446c9..b7c609a 100644
> --- a/drivers/thermal/samsung/exynos_tmu.c
> +++ b/drivers/thermal/samsung/exynos_tmu.c
> @@ -32,6 +32,7 @@
>  #include <linux/of_address.h>
>  #include <linux/of_irq.h>
>  #include <linux/platform_device.h>
> +#include <linux/regulator/consumer.h>
>  #include <linux/slab.h>
>  #include <linux/workqueue.h>
>  #include "exynos_thermal_common.h"
> @@ -52,6 +53,7 @@
>   * @clk: pointer to the clock structure.
>   * @temp_error1: fused value of the first point trim.
>   * @temp_error2: fused value of the second point trim.
> + * @regulator: pointer to the TMU regulator structure.
>   * @reg_conf: pointer to structure to register with core thermal.
>   */
>  struct exynos_tmu_data {
> @@ -65,6 +67,7 @@ struct exynos_tmu_data {
>  	struct mutex lock;
>  	struct clk *clk;
>  	u8 temp_error1, temp_error2;
> +	struct regulator *regulator;
>  	struct thermal_sensor_conf *reg_conf;
>  };
> =20
> @@ -501,10 +504,23 @@ static int exynos_map_dt_data(struct platform_dev=
ice *pdev)
>  	struct exynos_tmu_data *data =3D platform_get_drvdata(pdev);
>  	struct exynos_tmu_platform_data *pdata =3D data->pdata;
>  	struct resource res;
> +	int ret;
> =20
>  	if (!data)
>  		return -ENODEV;
> =20
> +	/* Try enabling the regulator if found */
> +	data->regulator =3D devm_regulator_get(&pdev->dev, "vtmu");
> +	if (!IS_ERR(data->regulator)) {
> +		ret =3D regulator_enable(data->regulator);
> +		if (ret) {
> +			dev_err(&pdev->dev, "failed to enable vtmu\n");
> +			return ret;
> +		}
> +	} else {
> +		dev_info(&pdev->dev, "Regulator node (vtmu) not found\n");

Now that you have a bitfield for your features, shouldnt this become a
check? If the SoC requires the regulator, then it has to return a valid
regulator (regulator_get). Meaning, if your SoC version requires this
feature and the regulator_get returns an error, you must treat as an
error an not continue gracefuly.

> +	}
> +
>  	data->id =3D of_alias_get_id(pdev->dev.of_node, "tmuctrl");
>  	if (data->id < 0)
>  		data->id =3D 0;
> @@ -669,6 +685,9 @@ static int exynos_tmu_remove(struct platform_device=
 *pdev)
> =20
>  	clk_unprepare(data->clk);
> =20
> +	if (!IS_ERR(data->regulator))
> +		regulator_disable(data->regulator);
> +
>  	platform_set_drvdata(pdev, NULL);
> =20
>  	return 0;
>=20



------enig2TEQTVBUDMNCGSLQGPGXQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iF4EAREIAAYFAlGLtj4ACgkQCXcVR3XQvP02/QD/XjlpNSOeXCJj3+EAMnlwfvOU
G2rls7XIQ1C+M6K/nK0A/3Imb/eU9VxW9g7M8R6+M0+xcaHsX0PIRQ7UVXHgSVGD
=OtVT
-----END PGP SIGNATURE-----

------enig2TEQTVBUDMNCGSLQGPGXQ--
