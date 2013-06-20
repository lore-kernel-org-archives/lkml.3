Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935601Ab3FTCeD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 22:34:03 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:34441 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935506Ab3FTCeB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 22:34:01 -0400
Message-ID: <51C26A0D.9060906@ti.com>
Date: Wed, 19 Jun 2013 22:33:49 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Amit Daniel Kachhap <amit.daniel@samsung.com>
CC: <linux-pm@vger.kernel.org>, Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>,
        <linux-samsung-soc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <amit.kachhap@gmail.com>, Kukjin Kim <kgene.kim@samsung.com>,
        <jonghwa3.lee@samsung.com>
Subject: Re: [PATCH V6 28/30] thermal: exynos: Support for TMU regulator defined
 at device tree
References: <1371451599-31035-1-git-send-email-amit.daniel@samsung.com> <1371451599-31035-29-git-send-email-amit.daniel@samsung.com>
In-Reply-To: <1371451599-31035-29-git-send-email-amit.daniel@samsung.com>
X-Enigmail-Version: 1.5.1
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature";
	boundary="----enig2JPEXLNUCFTMSXMXABFUM"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------enig2JPEXLNUCFTMSXMXABFUM
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 17-06-2013 02:46, Amit Daniel Kachhap wrote:
> TMU probe function now checks for a device tree defined regulator.
> For compatibility reasons it is allowed to probe driver even without
> this regulator defined.
>=20
> Acked-by: Jonghwa Lee <jonghwa3.lee@samsung.com>
> Signed-off-by: Lukasz Majewski <l.majewski@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> Signed-off-by: Amit Daniel Kachhap <amit.daniel@samsung.com>

Acked-by: Eduardo Valentin <eduardo.valentin@ti.com>

> ---
>  .../devicetree/bindings/thermal/exynos-thermal.txt |    4 +++
>  drivers/thermal/samsung/exynos_tmu.c               |   23 ++++++++++++=
++++++++
>  2 files changed, 27 insertions(+), 0 deletions(-)
>=20
> diff --git a/Documentation/devicetree/bindings/thermal/exynos-thermal.t=
xt b/Documentation/devicetree/bindings/thermal/exynos-thermal.txt
> index e6386ea..284f530 100644
> --- a/Documentation/devicetree/bindings/thermal/exynos-thermal.txt
> +++ b/Documentation/devicetree/bindings/thermal/exynos-thermal.txt
> @@ -16,6 +16,9 @@
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
> @@ -27,6 +30,7 @@ Example 1):
>  		clocks =3D <&clock 383>;
>  		clock-names =3D "tmu_apbif";
>  		status =3D "disabled";
> +		vtmu-supply =3D <&tmu_regulator_node>;
>  	};
> =20
>  Example 2):
> diff --git a/drivers/thermal/samsung/exynos_tmu.c b/drivers/thermal/sam=
sung/exynos_tmu.c
> index 7a259f4..441efd5 100644
> --- a/drivers/thermal/samsung/exynos_tmu.c
> +++ b/drivers/thermal/samsung/exynos_tmu.c
> @@ -29,6 +29,7 @@
>  #include <linux/of_address.h>
>  #include <linux/of_irq.h>
>  #include <linux/platform_device.h>
> +#include <linux/regulator/consumer.h>
> =20
>  #include "exynos_thermal_common.h"
>  #include "exynos_tmu.h"
> @@ -48,6 +49,7 @@
>   * @clk: pointer to the clock structure.
>   * @temp_error1: fused value of the first point trim.
>   * @temp_error2: fused value of the second point trim.
> + * @regulator: pointer to the TMU regulator structure.
>   * @reg_conf: pointer to structure to register with core thermal.
>   */
>  struct exynos_tmu_data {
> @@ -61,6 +63,7 @@ struct exynos_tmu_data {
>  	struct mutex lock;
>  	struct clk *clk;
>  	u8 temp_error1, temp_error2;
> +	struct regulator *regulator;
>  	struct thermal_sensor_conf *reg_conf;
>  };
> =20
> @@ -510,10 +513,27 @@ static int exynos_map_dt_data(struct platform_dev=
ice *pdev)
>  	struct exynos_tmu_data *data =3D platform_get_drvdata(pdev);
>  	struct exynos_tmu_platform_data *pdata;
>  	struct resource res;
> +	int ret;
> =20
>  	if (!data)
>  		return -ENODEV;
> =20
> +	/*
> +	 * Try enabling the regulator if found
> +	 * TODO: Add regulator as an SOC feature, so that regulator enable
> +	 * is a compulsory call.
> +	 */
> +	data->regulator =3D devm_regulator_get(&pdev->dev, "vtmu");
> +	if (!IS_ERR(data->regulator)) {
> +		ret =3D regulator_enable(data->regulator);
> +		if (ret) {
> +			dev_err(&pdev->dev, "failed to enable vtmu\n");
> +			return ret;
> +		}
> +	} else {
> +		dev_info(&pdev->dev, "Regulator node (vtmu) not found\n");
> +	}
> +
>  	data->id =3D of_alias_get_id(pdev->dev.of_node, "tmuctrl");
>  	if (data->id < 0)
>  		data->id =3D 0;
> @@ -680,6 +700,9 @@ static int exynos_tmu_remove(struct platform_device=
 *pdev)
> =20
>  	clk_unprepare(data->clk);
> =20
> +	if (!IS_ERR(data->regulator))
> +		regulator_disable(data->regulator);
> +
>  	return 0;
>  }
> =20
>=20


--=20
You have got to be excited about what you are doing. (L. Lamport)

Eduardo Valentin


------enig2JPEXLNUCFTMSXMXABFUM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iF4EAREIAAYFAlHCag0ACgkQCXcVR3XQvP0bKwD/WXJj3ZqxhmYSb64e/CYDTODC
5BToEXVoAzy84Uod2FkBAJNJ2fDxvk9BWwAqd8GgwOcFYWc8vzbpvSIef/4weZXn
=muBH
-----END PGP SIGNATURE-----

------enig2JPEXLNUCFTMSXMXABFUM--
