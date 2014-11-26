Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753288AbaKZOpV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 09:45:21 -0500
Received: from mail-qa0-f42.google.com ([209.85.216.42]:46540 "EHLO
	mail-qa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751981AbaKZOpR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 09:45:17 -0500
Date: Wed, 26 Nov 2014 10:45:06 -0400
From: Eduardo Valentin <edubezval@gmail.com>
To: Abhilash Kesavan <a.kesavan@samsung.com>
Cc: rui.zhang@intel.com, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, b.zolnierkie@samsung.com,
        amit.daniel@samsung.com, kesavan.abhilash@gmail.com,
        l.majewski@samsung.com, cw00.choi@samsung.com
Subject: Re: [PATCH v2] thermal: exynos: add special clock support
Message-ID: <20141126144504.GA3808@developer>
References: <1416963070-5806-1-git-send-email-a.kesavan@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="EVF5PPMfhYS0aIcm"
Content-Disposition: inline
In-Reply-To: <1416963070-5806-1-git-send-email-a.kesavan@samsung.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--EVF5PPMfhYS0aIcm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


Abhilash,

On Wed, Nov 26, 2014 at 06:21:10AM +0530, Abhilash Kesavan wrote:
> Exynos7 has a special clock required for the functional operation
> of the TMU that is not present in earlier SoCs. Add support for
> this clock and update the binding documentation.
>=20
> Signed-off-by: Abhilash Kesavan <a.kesavan@samsung.com>
> ---
> Changes since v1:
> 	- Added a per-soc flag to indicate the presence of special clock
> 	- Changed the name of special clock from "tmu_sclk" to "sclk"
> 	- Fixed the error handling for sclk
>=20
> Tested on 5420 and 5800 based chromebooks, no change in existing behavior.
>=20
>  .../devicetree/bindings/thermal/exynos-thermal.txt |    3 ++
>  drivers/thermal/samsung/exynos_tmu.c               |   31 ++++++++++++++=
++----
>  2 files changed, 29 insertions(+), 5 deletions(-)
>=20
> diff --git a/Documentation/devicetree/bindings/thermal/exynos-thermal.txt=
 b/Documentation/devicetree/bindings/thermal/exynos-thermal.txt
> index ae738f5..acf4705 100644
> --- a/Documentation/devicetree/bindings/thermal/exynos-thermal.txt
> +++ b/Documentation/devicetree/bindings/thermal/exynos-thermal.txt
> @@ -32,10 +32,13 @@
>  - clocks : The main clocks for TMU device
>  	-- 1. operational clock for TMU channel
>  	-- 2. optional clock to access the shared registers of TMU channel
> +	-- 3. optional special clock for functional operation
>  - clock-names : Thermal system clock name
>  	-- "tmu_apbif" operational clock for current TMU channel
>  	-- "tmu_triminfo_apbif" clock to access the shared triminfo register
>  		for current TMU channel
> +	-- "sclk" clock for functional operation of the current TMU
> +		channel
>  - vtmu-supply: This entry is optional and provides the regulator node su=
pplying
>  		voltage to TMU. If needed this entry can be placed inside
>  		board/platform specific dts file.
> diff --git a/drivers/thermal/samsung/exynos_tmu.c b/drivers/thermal/samsu=
ng/exynos_tmu.c
> index d44d91d..8ed8409 100644
> --- a/drivers/thermal/samsung/exynos_tmu.c
> +++ b/drivers/thermal/samsung/exynos_tmu.c
> @@ -123,11 +123,14 @@
>   * @base: base address of the single instance of the TMU controller.
>   * @base_second: base address of the common registers of the TMU control=
ler.
>   * @irq: irq number of the TMU controller.
> + * @needs_sclk: SoC specific flag indicating that sclk is required for
> +	functional operation of the TMU controller.
>   * @soc: id of the SOC type.
>   * @irq_work: pointer to the irq work structure.
>   * @lock: lock to implement synchronization.
>   * @clk: pointer to the clock structure.
>   * @clk_sec: pointer to the clock structure for accessing the base_secon=
d.
> + * @sclk: pointer to the clock structure for accessing the tmu special c=
lock.
>   * @temp_error1: fused value of the first point trim.
>   * @temp_error2: fused value of the second point trim.
>   * @regulator: pointer to the TMU regulator structure.
> @@ -144,10 +147,11 @@ struct exynos_tmu_data {
>  	void __iomem *base;
>  	void __iomem *base_second;
>  	int irq;
> +	bool needs_sclk;
>  	enum soc_type soc;
>  	struct work_struct irq_work;
>  	struct mutex lock;
> -	struct clk *clk, *clk_sec;
> +	struct clk *clk, *clk_sec, *sclk;
>  	u8 temp_error1, temp_error2;
>  	struct regulator *regulator;
>  	struct thermal_sensor_conf *reg_conf;
> @@ -883,10 +887,24 @@ static int exynos_tmu_probe(struct platform_device =
*pdev)
>  		goto err_clk_sec;
>  	}
> =20
> +	if (data->needs_sclk) {

Based on the trend we see from Bartlomiej's and Lukasz' works, you
should be asking for SoC version, not adding a flag. Can you please
crosscheck with them?

Cheers,

Eduardo Valentin

> +		data->sclk =3D devm_clk_get(&pdev->dev, "sclk");
> +		if (IS_ERR(data->sclk)) {
> +			dev_err(&pdev->dev, "Failed to get sclk\n");
> +			goto err_clk;
> +		} else {
> +			ret =3D clk_prepare_enable(data->sclk);
> +			if (ret) {
> +				dev_err(&pdev->dev, "Failed to enable sclk\n");
> +				goto err_clk;
> +			}
> +		}
> +	}
> +
>  	ret =3D exynos_tmu_initialize(pdev);
>  	if (ret) {
>  		dev_err(&pdev->dev, "Failed to initialize TMU\n");
> -		goto err_clk;
> +		goto err_sclk;
>  	}
> =20
>  	exynos_tmu_control(pdev, true);
> @@ -896,7 +914,7 @@ static int exynos_tmu_probe(struct platform_device *p=
dev)
>  				sizeof(struct thermal_sensor_conf), GFP_KERNEL);
>  	if (!sensor_conf) {
>  		ret =3D -ENOMEM;
> -		goto err_clk;
> +		goto err_sclk;
>  	}
>  	sprintf(sensor_conf->name, "therm_zone%d", data->id);
>  	sensor_conf->read_temperature =3D (int (*)(void *))exynos_tmu_read;
> @@ -928,7 +946,7 @@ static int exynos_tmu_probe(struct platform_device *p=
dev)
>  	ret =3D exynos_register_thermal(sensor_conf);
>  	if (ret) {
>  		dev_err(&pdev->dev, "Failed to register thermal interface\n");
> -		goto err_clk;
> +		goto err_sclk;
>  	}
>  	data->reg_conf =3D sensor_conf;
> =20
> @@ -936,10 +954,12 @@ static int exynos_tmu_probe(struct platform_device =
*pdev)
>  		IRQF_TRIGGER_RISING | IRQF_SHARED, dev_name(&pdev->dev), data);
>  	if (ret) {
>  		dev_err(&pdev->dev, "Failed to request irq: %d\n", data->irq);
> -		goto err_clk;
> +		goto err_sclk;
>  	}
> =20
>  	return 0;
> +err_sclk:
> +	clk_disable_unprepare(data->sclk);
>  err_clk:
>  	clk_unprepare(data->clk);
>  err_clk_sec:
> @@ -956,6 +976,7 @@ static int exynos_tmu_remove(struct platform_device *=
pdev)
> =20
>  	exynos_tmu_control(pdev, false);
> =20
> +	clk_disable_unprepare(data->sclk);
>  	clk_unprepare(data->clk);
>  	if (!IS_ERR(data->clk_sec))
>  		clk_unprepare(data->clk_sec);
> --=20
> 1.7.9.5
>=20

--EVF5PPMfhYS0aIcm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUdedmAAoJEMLUO4d9pOJW+44H/jNnu1Q76o+v1bZUOKDN08xW
X8R0LiO9q0Pj/PgqLMClYRi0f4hVs3gQ2J0YR82oolpXYekn2wGiWG/ELVhhDEtd
TETvKwmMqaN19GPNM5k710zNlavFrFxx3+i+ZgWauJkiEivCaDWjXxDXcMrJYI8N
j9nWHDZtgnyU5aW0kbad9iqGEDg+4ge88VYUZfLB7CuCb7xfhFP3RWYbAvchAr2i
B/gZIl+iveqhZterKKa+9tRLwAzsBPCl3hHR9EiQAW5mripXCHWDszdrCvg/VVgR
FstWuq9mkTyt/a3Pj+n2rgNfX+blw1zvUXVZyF83hrqYDGklL8977dQ/iCdmEFk=
=9p2F
-----END PGP SIGNATURE-----

--EVF5PPMfhYS0aIcm--
