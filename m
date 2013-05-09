Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754593Ab3EIOxZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 10:53:25 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:39664 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752821Ab3EIOxW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 10:53:22 -0400
Message-ID: <518BB852.6080400@ti.com>
Date: Thu, 9 May 2013 10:53:06 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130404 Thunderbird/17.0.5
MIME-Version: 1.0
To: Amit Daniel Kachhap <amit.daniel@samsung.com>
CC: <linux-pm@vger.kernel.org>, Zhang Rui <rui.zhang@intel.com>,
        <linux-samsung-soc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <amit.kachhap@gmail.com>, Kukjin Kim <kgene.kim@samsung.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>
Subject: Re: [PATCH V3 15/21] thermal: exynos: Add support to handle many
 instances of TMU
References: <1367931671-3906-1-git-send-email-amit.daniel@samsung.com> <1367931671-3906-16-git-send-email-amit.daniel@samsung.com>
In-Reply-To: <1367931671-3906-16-git-send-email-amit.daniel@samsung.com>
X-Enigmail-Version: 1.5.1
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature";
	boundary="----enig2DJNRJWSESXTRNWBEXENF"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------enig2DJNRJWSESXTRNWBEXENF
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 07-05-2013 09:01, Amit Daniel Kachhap wrote:
> This patch adds support to handle multiple instances of the TMU control=
lers.
> This is done by removing the static structure to register with the core=
 thermal
> and creating it dynamically for each instance of the TMU controller. Th=
e
> interrupt is made shared type to handle interrupts for all the TMU. Als=
o
> the identifier of the TMU controller is extracted from device tree alia=
s.
>=20
> Acked-by: Kukjin Kim <kgene.kim@samsung.com>
> Signed-off-by: Amit Daniel Kachhap <amit.daniel@samsung.com>
> ---
>  drivers/thermal/samsung/exynos_tmu.c |  125 +++++++++++++++++++++++---=
--------
>  1 files changed, 84 insertions(+), 41 deletions(-)
>=20
> diff --git a/drivers/thermal/samsung/exynos_tmu.c b/drivers/thermal/sam=
sung/exynos_tmu.c
> index bdf40ef..94d6e8e 100644
> --- a/drivers/thermal/samsung/exynos_tmu.c
> +++ b/drivers/thermal/samsung/exynos_tmu.c
> @@ -29,6 +29,8 @@
>  #include <linux/module.h>
>  #include <linux/mutex.h>
>  #include <linux/of.h>
> +#include <linux/of_address.h>
> +#include <linux/of_irq.h>
>  #include <linux/platform_device.h>
>  #include <linux/slab.h>
>  #include <linux/workqueue.h>
> @@ -36,9 +38,24 @@
>  #include "exynos_tmu.h"
>  #include "exynos_tmu_data.h"
> =20
> +/**
> + * struct exynos_tmu_data : A structure to hold the private data of th=
e TMU
> +	driver
> + * @id: identifier of the one instance of the TMU controller.
> + * @pdata: pointer to the tmu platform/configuration data
> + * @base: base address of the single instance of the TMU controller.
> + * @irq: irq number of the TMU controller.
> + * @soc: id of the SOC type.
> + * @irq_work: pointer to the irq work structure.
> + * @lock: lock to implement synchronization.
> + * @clk: pointer to the clock structure.
> + * @temp_error1: fused value of the first point trim.
> + * @temp_error2: fused value of the second point trim.
> + * @reg_conf: pointer to structure to register with core thermal.
> + */
>  struct exynos_tmu_data {
> +	int id;
>  	struct exynos_tmu_platform_data *pdata;
> -	struct resource *mem;
>  	void __iomem *base;
>  	int irq;
>  	enum soc_type soc;
> @@ -46,6 +63,7 @@ struct exynos_tmu_data {
>  	struct mutex lock;
>  	struct clk *clk;
>  	u8 temp_error1, temp_error2;
> +	struct thermal_sensor_conf *reg_conf;
>  };
> =20
>  /*
> @@ -319,12 +337,6 @@ static int exynos_tmu_set_emulation(void *drv_data=
,	unsigned long temp)
>  	{ return -EINVAL; }
>  #endif/*CONFIG_THERMAL_EMULATION*/
> =20
> -static struct thermal_sensor_conf exynos_sensor_conf =3D {
> -	.name			=3D "exynos-therm",
> -	.read_temperature	=3D (int (*)(void *))exynos_tmu_read,
> -	.write_emul_temp	=3D exynos_tmu_set_emulation,
> -};
> -
>  static void exynos_tmu_work(struct work_struct *work)
>  {
>  	struct exynos_tmu_data *data =3D container_of(work,
> @@ -333,7 +345,7 @@ static void exynos_tmu_work(struct work_struct *wor=
k)
>  	struct exynos_tmu_registers *reg =3D pdata->registers;
>  	unsigned int val_irq;
> =20
> -	exynos_report_trigger(&exynos_sensor_conf);
> +	exynos_report_trigger(data->reg_conf);
>  	mutex_lock(&data->lock);
>  	clk_enable(data->clk);
> =20
> @@ -405,10 +417,42 @@ static inline struct  exynos_tmu_platform_data *e=
xynos_get_driver_data(
>  			platform_get_device_id(pdev)->driver_data;
>  }
> =20
> +static int exynos_map_dt_data(struct platform_device *pdev)
> +{
> +	struct exynos_tmu_data *data =3D platform_get_drvdata(pdev);
> +	struct resource res;
> +
> +	if (!data)
> +		return -ENODEV;
> +
> +	data->id =3D of_alias_get_id(pdev->dev.of_node, "tmuctrl");
> +	if (data->id < 0)
> +		data->id =3D 0;
> +
> +	data->irq =3D irq_of_parse_and_map(pdev->dev.of_node, 0);
> +	if (data->irq <=3D 0) {
> +		dev_err(&pdev->dev, "failed to get IRQ\n");
> +		return -ENODEV;
> +	}
> +
> +	if (of_address_to_resource(pdev->dev.of_node, 0, &res)) {
> +		dev_err(&pdev->dev, "failed to get Resource\n");
> +		return -ENODEV;
> +	}
> +
> +	data->base =3D devm_ioremap(&pdev->dev, res.start, resource_size(&res=
));
> +	if (!data->base) {
> +		dev_err(&pdev->dev, "Failed to ioremap memory\n");
> +		return -ENOMEM;

looks like the statement below fits better here:
		return ERR_PTR(-EADDRNOTAVAIL);

> +	}

blank line?

> +	return 0;
> +}
> +
>  static int exynos_tmu_probe(struct platform_device *pdev)
>  {
>  	struct exynos_tmu_data *data;
>  	struct exynos_tmu_platform_data *pdata =3D pdev->dev.platform_data;
> +	struct thermal_sensor_conf *sensor_conf;
>  	int ret, i;
> =20
>  	if (!pdata)
> @@ -425,26 +469,17 @@ static int exynos_tmu_probe(struct platform_devic=
e *pdev)
>  		return -ENOMEM;
>  	}
> =20
> -	data->irq =3D platform_get_irq(pdev, 0);
> -	if (data->irq < 0) {
> -		dev_err(&pdev->dev, "Failed to get platform irq\n");
> -		return data->irq;
> -	}
> -
> -	INIT_WORK(&data->irq_work, exynos_tmu_work);
> -
> -	data->mem =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);
> -	if (!data->mem) {
> -		dev_err(&pdev->dev, "Failed to get platform resource\n");
> -		return -ENOENT;
> -	}
> +	data->pdata =3D pdata;
> +	platform_set_drvdata(pdev, data);
> +	mutex_init(&data->lock);
> =20
> -	data->base =3D devm_ioremap_resource(&pdev->dev, data->mem);
> -	if (IS_ERR(data->base))
> -		return PTR_ERR(data->base);
> +	ret =3D exynos_map_dt_data(pdev);
> +	if (ret)
> +		return ret;
> =20
> +	INIT_WORK(&data->irq_work, exynos_tmu_work);
>  	ret =3D devm_request_irq(&pdev->dev, data->irq, exynos_tmu_irq,
> -		IRQF_TRIGGER_RISING, "exynos-tmu", data);
> +		IRQF_TRIGGER_RISING | IRQF_SHARED, dev_name(&pdev->dev), data);
>  	if (ret) {
>  		dev_err(&pdev->dev, "Failed to request irq: %d\n", data->irq);
>  		return ret;
> @@ -469,10 +504,6 @@ static int exynos_tmu_probe(struct platform_device=
 *pdev)
>  		goto err_clk;
>  	}
> =20
> -	data->pdata =3D pdata;
> -	platform_set_drvdata(pdev, data);
> -	mutex_init(&data->lock);
> -
>  	ret =3D exynos_tmu_initialize(pdev);
>  	if (ret) {
>  		dev_err(&pdev->dev, "Failed to initialize TMU\n");
> @@ -481,28 +512,40 @@ static int exynos_tmu_probe(struct platform_devic=
e *pdev)
> =20
>  	exynos_tmu_control(pdev, true);
> =20
> -	/* Register the sensor with thermal management interface */
> -	(&exynos_sensor_conf)->driver_data =3D data;
> -	exynos_sensor_conf.trip_data.trip_count =3D pdata->trigger_enable[0] =
+
> +	/* Allocate a structure to register with the exynos core thermal */
> +	sensor_conf =3D devm_kzalloc(&pdev->dev,
> +				sizeof(struct thermal_sensor_conf), GFP_KERNEL);
> +	if (!sensor_conf) {
> +		dev_err(&pdev->dev, "Failed to allocate registration struct\n");
> +		ret =3D -ENOMEM;
> +		goto err_clk;
> +	}
> +	data->reg_conf =3D sensor_conf;
> +	sprintf(sensor_conf->name, "therm_zone%d", data->id);
> +	sensor_conf->read_temperature =3D (int (*)(void *))exynos_tmu_read;
> +	sensor_conf->write_emul_temp =3D
> +		(int (*)(void *, unsigned long))exynos_tmu_set_emulation;
> +	sensor_conf->driver_data =3D data;
> +	sensor_conf->trip_data.trip_count =3D pdata->trigger_enable[0] +
>  			pdata->trigger_enable[1] + pdata->trigger_enable[2]+
>  			pdata->trigger_enable[3];
> =20
> -	for (i =3D 0; i < exynos_sensor_conf.trip_data.trip_count; i++)
> -		exynos_sensor_conf.trip_data.trip_val[i] =3D
> +	for (i =3D 0; i < sensor_conf->trip_data.trip_count; i++)
> +		sensor_conf->trip_data.trip_val[i] =3D
>  			pdata->threshold + pdata->trigger_levels[i];
> =20
> -	exynos_sensor_conf.trip_data.trigger_falling =3D pdata->threshold_fal=
ling;
> +	sensor_conf->trip_data.trigger_falling =3D pdata->threshold_falling;
> =20
> -	exynos_sensor_conf.cooling_data.freq_clip_count =3D
> -						pdata->freq_tab_count;
> +	sensor_conf->cooling_data.freq_clip_count =3D pdata->freq_tab_count;
>  	for (i =3D 0; i < pdata->freq_tab_count; i++) {
> -		exynos_sensor_conf.cooling_data.freq_data[i].freq_clip_max =3D
> +		sensor_conf->cooling_data.freq_data[i].freq_clip_max =3D
>  					pdata->freq_tab[i].freq_clip_max;
> -		exynos_sensor_conf.cooling_data.freq_data[i].temp_level =3D
> +		sensor_conf->cooling_data.freq_data[i].temp_level =3D
>  					pdata->freq_tab[i].temp_level;
>  	}
> =20
> -	ret =3D exynos_register_thermal(&exynos_sensor_conf);
> +	/* Register the sensor with thermal management interface */
> +	ret =3D exynos_register_thermal(sensor_conf);
>  	if (ret) {
>  		dev_err(&pdev->dev, "Failed to register thermal interface\n");
>  		goto err_clk;
> @@ -521,7 +564,7 @@ static int exynos_tmu_remove(struct platform_device=
 *pdev)
> =20
>  	exynos_tmu_control(pdev, false);
> =20
> -	exynos_unregister_thermal(&exynos_sensor_conf);
> +	exynos_unregister_thermal(data->reg_conf);
> =20
>  	clk_unprepare(data->clk);
> =20
>=20



------enig2DJNRJWSESXTRNWBEXENF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iF4EAREIAAYFAlGLuFIACgkQCXcVR3XQvP3LfgEAxuFWVrC5yuC9bN2XVBdAPlWT
D+r/i+/EY2xTNaCAZWgBAOyAppn3y74Vi35we1x97ITxf1Nt8m0MspSvyDBMckFN
=rCDY
-----END PGP SIGNATURE-----

------enig2DJNRJWSESXTRNWBEXENF--
