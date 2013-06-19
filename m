Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935187Ab3FSUDo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 16:03:44 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:51945 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757385Ab3FSUDk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 16:03:40 -0400
Message-ID: <51C20E8D.8040005@ti.com>
Date: Wed, 19 Jun 2013 16:03:25 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Amit Daniel Kachhap <amit.daniel@samsung.com>
CC: <linux-pm@vger.kernel.org>, Zhang Rui <rui.zhang@intel.com>,
        <linux-samsung-soc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <amit.kachhap@gmail.com>, Kukjin Kim <kgene.kim@samsung.com>,
        Lukasz Majewski <l.majewski@samsung.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [PATCH V2] thermal: exynos: Support for TMU regulator defined
 at device tree
References: <1367489937-30725-1-git-send-email-amit.daniel@samsung.com>
In-Reply-To: <1367489937-30725-1-git-send-email-amit.daniel@samsung.com>
X-Enigmail-Version: 1.5.1
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature";
	boundary="----enig2MQJAEJSTDLJTCJEPNSCF"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------enig2MQJAEJSTDLJTCJEPNSCF
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 02-05-2013 06:18, Amit Daniel Kachhap wrote:
> TMU probe function now checks for a device tree defined regulator.
> For compatibility reasons it is allowed to probe driver even without
> this regulator defined.
>=20
> Signed-off-by: Luk asz Majewski <l.majewski@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> Signed-off-by: Amit Daniel Kachhap <amit.daniel@samsung.com>

I assume this one got superseeded by the same patch on your 30 patch
series, right?
https://patchwork.kernel.org/patch/2731031/


> ---
>=20
> Changes in V2:
> * Added log message in regulator_get failure as suggested by Sylwester.=

> * Used IS_ERR for checking regulator pointer as suggested by Sylwester.=

>=20
> This patch is repost of the patch posted by Lukasz Majewski
> (https://patchwork.kernel.org/patch/2488211/). I have rebased this
> patch on top of my TMU re-structured patch series
> (http://lwn.net/Articles/548634/). Although I thought of handling
> regulator as one type of feature (newly added) but could not do
> so as regulator is a board/platform property and not SOC property so
> leaving the device tree to define and handle it.
>=20
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


--=20
You have got to be excited about what you are doing. (L. Lamport)

Eduardo Valentin


------enig2MQJAEJSTDLJTCJEPNSCF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iF4EAREIAAYFAlHCDo0ACgkQCXcVR3XQvP0JUwD/YgT7qm+SFj4ex6e26InHLO7b
xX8o3wzMGBrpWHThzLABALcq5m9+LwyQ3DQoTxJ7U6CD6Js+OYA1HK+AtcEauPg3
=BQaq
-----END PGP SIGNATURE-----

------enig2MQJAEJSTDLJTCJEPNSCF--
