Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935385Ab3FSX2I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 19:28:08 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:45911 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934170Ab3FSX2G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 19:28:06 -0400
Message-ID: <51C23E78.1010202@ti.com>
Date: Wed, 19 Jun 2013 19:27:52 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Amit Daniel Kachhap <amit.daniel@samsung.com>
CC: <linux-pm@vger.kernel.org>, Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>,
        <linux-samsung-soc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <amit.kachhap@gmail.com>, Kukjin Kim <kgene.kim@samsung.com>,
        <jonghwa3.lee@samsung.com>
Subject: Re: [PATCH V6 18/30] thermal: exynos: Add support to handle many
 instances of TMU
References: <1371451599-31035-1-git-send-email-amit.daniel@samsung.com> <1371451599-31035-19-git-send-email-amit.daniel@samsung.com>
In-Reply-To: <1371451599-31035-19-git-send-email-amit.daniel@samsung.com>
X-Enigmail-Version: 1.5.1
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature";
	boundary="----enig2GUQPLIUGXKMFKOOVQEMR"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------enig2GUQPLIUGXKMFKOOVQEMR
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 17-06-2013 02:46, Amit Daniel Kachhap wrote:
> This patch adds support to handle multiple instances of the TMU control=
lers.
> This is done by removing the static structure to register with the core=
 thermal
> and creating it dynamically for each instance of the TMU controller. Th=
e
> interrupt is made shared type to handle shared interrupts. Also
> the identifier of the TMU controller is extracted from device tree alia=
s.
>=20
> Acked-by: Kukjin Kim <kgene.kim@samsung.com>
> Acked-by: Jonghwa Lee <jonghwa3.lee@samsung.com>
> Signed-off-by: Amit Daniel Kachhap <amit.daniel@samsung.com>
> ---
>  drivers/thermal/samsung/exynos_thermal_common.h |    1 +
>  drivers/thermal/samsung/exynos_tmu.c            |  147 +++++++++++++++=
+-------
>  drivers/thermal/samsung/exynos_tmu.h            |   13 ++
>  drivers/thermal/samsung/exynos_tmu_data.c       |  145 ++++++++++++---=
-------
>  drivers/thermal/samsung/exynos_tmu_data.h       |    4 +-
>  5 files changed, 197 insertions(+), 113 deletions(-)
>=20
> diff --git a/drivers/thermal/samsung/exynos_thermal_common.h b/drivers/=
thermal/samsung/exynos_thermal_common.h
> index dd0077e..0c189d6 100644
> --- a/drivers/thermal/samsung/exynos_thermal_common.h
> +++ b/drivers/thermal/samsung/exynos_thermal_common.h
> @@ -84,6 +84,7 @@ struct thermal_sensor_conf {
>  	struct thermal_cooling_conf cooling_data;
>  	void *driver_data;
>  	void *pzone_data;
> +	struct device *dev;
>  };
> =20
>  /*Functions used exynos based thermal sensor driver*/
> diff --git a/drivers/thermal/samsung/exynos_tmu.c b/drivers/thermal/sam=
sung/exynos_tmu.c
> index 4356118..1880c4e 100644
> --- a/drivers/thermal/samsung/exynos_tmu.c
> +++ b/drivers/thermal/samsung/exynos_tmu.c
> @@ -26,15 +26,32 @@
>  #include <linux/interrupt.h>
>  #include <linux/module.h>
>  #include <linux/of.h>
> +#include <linux/of_address.h>
> +#include <linux/of_irq.h>
>  #include <linux/platform_device.h>
> =20
>  #include "exynos_thermal_common.h"
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
> @@ -42,6 +59,7 @@ struct exynos_tmu_data {
>  	struct mutex lock;
>  	struct clk *clk;
>  	u8 temp_error1, temp_error2;
> +	struct thermal_sensor_conf *reg_conf;
>  };
> =20
>  /*
> @@ -345,12 +363,6 @@ static int exynos_tmu_set_emulation(void *drv_data=
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
> @@ -359,7 +371,7 @@ static void exynos_tmu_work(struct work_struct *wor=
k)
>  	const struct exynos_tmu_registers *reg =3D pdata->registers;
>  	unsigned int val_irq;
> =20
> -	exynos_report_trigger(&exynos_sensor_conf);
> +	exynos_report_trigger(data->reg_conf);
>  	mutex_lock(&data->lock);
>  	clk_enable(data->clk);
> =20
> @@ -404,33 +416,73 @@ MODULE_DEVICE_TABLE(of, exynos_tmu_match);
>  #endif
> =20
>  static inline struct  exynos_tmu_platform_data *exynos_get_driver_data=
(
> -			struct platform_device *pdev)
> +			struct platform_device *pdev, int id)
>  {
> +	struct  exynos_tmu_init_data *data_table;
> +	struct exynos_tmu_platform_data *tmu_data;
>  #ifdef CONFIG_OF
>  	if (pdev->dev.of_node) {
>  		const struct of_device_id *match;
>  		match =3D of_match_node(exynos_tmu_match, pdev->dev.of_node);
>  		if (!match)
>  			return NULL;
> -		return (struct exynos_tmu_platform_data *) match->data;
> +		data_table =3D (struct exynos_tmu_init_data *) match->data;
> +		if (!data_table || id >=3D data_table->tmu_count)
> +			return NULL;
> +		tmu_data =3D data_table->tmu_data;
> +		return (struct exynos_tmu_platform_data *) (tmu_data + id);
>  	}
>  #endif
>  	return NULL;
>  }
> =20
> -static int exynos_tmu_probe(struct platform_device *pdev)
> +static int exynos_map_dt_data(struct platform_device *pdev)
>  {
> -	struct exynos_tmu_data *data;
> -	struct exynos_tmu_platform_data *pdata =3D pdev->dev.platform_data;
> -	int ret, i;
> +	struct exynos_tmu_data *data =3D platform_get_drvdata(pdev);
> +	struct exynos_tmu_platform_data *pdata;
> +	struct resource res;
> =20
> -	if (!pdata)
> -		pdata =3D exynos_get_driver_data(pdev);
> +	if (!data)
> +		return -ENODEV;
> +
> +	data->id =3D of_alias_get_id(pdev->dev.of_node, "tmuctrl");
> +	if (data->id < 0)
> +		data->id =3D 0;
> =20
> +	data->irq =3D irq_of_parse_and_map(pdev->dev.of_node, 0);
> +	if (data->irq <=3D 0) {
> +		dev_err(&pdev->dev, "failed to get IRQ\n");
> +		return -ENODEV;
> +	}
> +
> +	if (of_address_to_resource(pdev->dev.of_node, 0, &res)) {
> +		dev_err(&pdev->dev, "failed to get Resource 0\n");
> +		return -ENODEV;
> +	}
> +
> +	data->base =3D devm_ioremap(&pdev->dev, res.start, resource_size(&res=
));
> +	if (!data->base) {
> +		dev_err(&pdev->dev, "Failed to ioremap memory\n");
> +		return -EADDRNOTAVAIL;
> +	}
> +
> +	pdata =3D exynos_get_driver_data(pdev, data->id);
>  	if (!pdata) {
>  		dev_err(&pdev->dev, "No platform init data supplied.\n");
>  		return -ENODEV;
>  	}
> +	data->pdata =3D pdata;
> +
> +	return 0;
> +}
> +
> +static int exynos_tmu_probe(struct platform_device *pdev)
> +{
> +	struct exynos_tmu_data *data;
> +	struct exynos_tmu_platform_data *pdata;
> +	struct thermal_sensor_conf *sensor_conf;
> +	int ret, i;
> +
>  	data =3D devm_kzalloc(&pdev->dev, sizeof(struct exynos_tmu_data),
>  					GFP_KERNEL);
>  	if (!data) {
> @@ -438,21 +490,18 @@ static int exynos_tmu_probe(struct platform_devic=
e *pdev)
>  		return -ENOMEM;
>  	}
> =20
> -	data->irq =3D platform_get_irq(pdev, 0);
> -	if (data->irq < 0) {
> -		dev_err(&pdev->dev, "Failed to get platform irq\n");
> -		return data->irq;
> -	}
> +	platform_set_drvdata(pdev, data);
> +	mutex_init(&data->lock);
> =20
> -	INIT_WORK(&data->irq_work, exynos_tmu_work);
> +	ret =3D exynos_map_dt_data(pdev);
> +	if (ret)
> +		return ret;
> =20
> -	data->mem =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);
> -	data->base =3D devm_ioremap_resource(&pdev->dev, data->mem);
> -	if (IS_ERR(data->base))
> -		return PTR_ERR(data->base);
> +	pdata =3D data->pdata;
> =20
> +	INIT_WORK(&data->irq_work, exynos_tmu_work);
>  	ret =3D devm_request_irq(&pdev->dev, data->irq, exynos_tmu_irq,
> -		IRQF_TRIGGER_RISING, "exynos-tmu", data);
> +		IRQF_TRIGGER_RISING | IRQF_SHARED, dev_name(&pdev->dev), data);

Lets think about this poing:  You request the IRQ before data->reg_conf
is allocated (below). Does it mean, from this point you can get called
to the IRQ handler even if reg_conf is not set? What happens then? I see
your irqhandler/worker use it.

>  	if (ret) {
>  		dev_err(&pdev->dev, "Failed to request irq: %d\n", data->irq);
>  		return ret;
> @@ -477,10 +526,6 @@ static int exynos_tmu_probe(struct platform_device=
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
> @@ -489,31 +534,43 @@ static int exynos_tmu_probe(struct platform_devic=
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
> -	for (i =3D 0; i < exynos_sensor_conf.trip_data.trip_count; i++) {
> -		exynos_sensor_conf.trip_data.trip_val[i] =3D
> +	for (i =3D 0; i < sensor_conf->trip_data.trip_count; i++) {
> +		sensor_conf->trip_data.trip_val[i] =3D
>  			pdata->threshold + pdata->trigger_levels[i];
> -		exynos_sensor_conf.trip_data.trip_type[i] =3D
> +		sensor_conf->trip_data.trip_type[i] =3D
>  					pdata->trigger_type[i];
>  	}
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
> -
> -	ret =3D exynos_register_thermal(&exynos_sensor_conf);
> +	sensor_conf->dev =3D &pdev->dev;
> +	/* Register the sensor with thermal management interface */
> +	ret =3D exynos_register_thermal(sensor_conf);
>  	if (ret) {
>  		dev_err(&pdev->dev, "Failed to register thermal interface\n");
>  		goto err_clk;
> @@ -531,7 +588,7 @@ static int exynos_tmu_remove(struct platform_device=
 *pdev)
> =20
>  	exynos_tmu_control(pdev, false);
> =20
> -	exynos_unregister_thermal(&exynos_sensor_conf);
> +	exynos_unregister_thermal(data->reg_conf);
> =20
>  	clk_unprepare(data->clk);
> =20
> diff --git a/drivers/thermal/samsung/exynos_tmu.h b/drivers/thermal/sam=
sung/exynos_tmu.h
> index 619a34c..b614407 100644
> --- a/drivers/thermal/samsung/exynos_tmu.h
> +++ b/drivers/thermal/samsung/exynos_tmu.h
> @@ -248,4 +248,17 @@ struct exynos_tmu_platform_data {
>  	unsigned int freq_tab_count;
>  	const struct exynos_tmu_registers *registers;
>  };
> +
> +/**
> + * struct exynos_tmu_init_data
> + * @tmu_count: number of TMU instances.
> + * @tmu_data: platform data of all TMU instances.
> + * This structure is required to store data for multi-instance exynos =
tmu
> + * driver.
> + */
> +struct exynos_tmu_init_data {
> +	int tmu_count;
> +	struct exynos_tmu_platform_data tmu_data[];
> +};
> +
>  #endif /* _EXYNOS_TMU_H */
> diff --git a/drivers/thermal/samsung/exynos_tmu_data.c b/drivers/therma=
l/samsung/exynos_tmu_data.c
> index 7fcf183..06ecfb0 100644
> --- a/drivers/thermal/samsung/exynos_tmu_data.c
> +++ b/drivers/thermal/samsung/exynos_tmu_data.c
> @@ -48,38 +48,44 @@ static const struct exynos_tmu_registers exynos4210=
_tmu_registers =3D {
>  	.tmu_intstat =3D EXYNOS_TMU_REG_INTSTAT,
>  	.tmu_intclear =3D EXYNOS_TMU_REG_INTCLEAR,
>  };
> -struct exynos_tmu_platform_data const exynos4210_default_tmu_data =3D =
{
> -	.threshold =3D 80,
> -	.trigger_levels[0] =3D 5,
> -	.trigger_levels[1] =3D 20,
> -	.trigger_levels[2] =3D 30,
> -	.trigger_enable[0] =3D 1,
> -	.trigger_enable[1] =3D 1,
> -	.trigger_enable[2] =3D 1,
> -	.trigger_enable[3] =3D 0,
> -	.trigger_type[0] =3D THROTTLE_ACTIVE,
> -	.trigger_type[1] =3D THROTTLE_ACTIVE,
> -	.trigger_type[2] =3D SW_TRIP,
> -	.max_trigger_level =3D 4,
> -	.gain =3D 15,
> -	.reference_voltage =3D 7,
> -	.cal_type =3D TYPE_ONE_POINT_TRIMMING,
> -	.min_efuse_value =3D 40,
> -	.max_efuse_value =3D 100,
> -	.first_point_trim =3D 25,
> -	.second_point_trim =3D 85,
> -	.default_temp_offset =3D 50,
> -	.freq_tab[0] =3D {
> -		.freq_clip_max =3D 800 * 1000,
> -		.temp_level =3D 85,
> -	},
> -	.freq_tab[1] =3D {
> -		.freq_clip_max =3D 200 * 1000,
> -		.temp_level =3D 100,
> +
> +struct exynos_tmu_init_data const exynos4210_default_tmu_data =3D {
> +	.tmu_data =3D {
> +		{
> +		.threshold =3D 80,
> +		.trigger_levels[0] =3D 5,
> +		.trigger_levels[1] =3D 20,
> +		.trigger_levels[2] =3D 30,
> +		.trigger_enable[0] =3D 1,
> +		.trigger_enable[1] =3D 1,
> +		.trigger_enable[2] =3D 1,
> +		.trigger_enable[3] =3D 0,
> +		.trigger_type[0] =3D THROTTLE_ACTIVE,
> +		.trigger_type[1] =3D THROTTLE_ACTIVE,
> +		.trigger_type[2] =3D SW_TRIP,
> +		.max_trigger_level =3D 4,
> +		.gain =3D 15,
> +		.reference_voltage =3D 7,
> +		.cal_type =3D TYPE_ONE_POINT_TRIMMING,
> +		.min_efuse_value =3D 40,
> +		.max_efuse_value =3D 100,
> +		.first_point_trim =3D 25,
> +		.second_point_trim =3D 85,
> +		.default_temp_offset =3D 50,
> +		.freq_tab[0] =3D {
> +			.freq_clip_max =3D 800 * 1000,
> +			.temp_level =3D 85,
> +			},
> +		.freq_tab[1] =3D {
> +			.freq_clip_max =3D 200 * 1000,
> +			.temp_level =3D 100,
> +		},
> +		.freq_tab_count =3D 2,
> +		.type =3D SOC_ARCH_EXYNOS4210,
> +		.registers =3D &exynos4210_tmu_registers,
> +		},
>  	},
> -	.freq_tab_count =3D 2,
> -	.type =3D SOC_ARCH_EXYNOS4210,
> -	.registers =3D &exynos4210_tmu_registers,
> +	.tmu_count =3D 1,
>  };
>  #endif
> =20
> @@ -120,41 +126,48 @@ static const struct exynos_tmu_registers exynos52=
50_tmu_registers =3D {
>  	.emul_time_shift =3D EXYNOS_EMUL_TIME_SHIFT,
>  	.emul_time_mask =3D EXYNOS_EMUL_TIME_MASK,
>  };
> -struct exynos_tmu_platform_data const exynos5250_default_tmu_data =3D =
{
> -	.threshold_falling =3D 10,
> -	.trigger_levels[0] =3D 85,
> -	.trigger_levels[1] =3D 103,
> -	.trigger_levels[2] =3D 110,
> -	.trigger_levels[3] =3D 120,
> -	.trigger_enable[0] =3D 1,
> -	.trigger_enable[1] =3D 1,
> -	.trigger_enable[2] =3D 1,
> -	.trigger_enable[3] =3D 0,
> -	.trigger_type[0] =3D THROTTLE_ACTIVE,
> -	.trigger_type[1] =3D THROTTLE_ACTIVE,
> -	.trigger_type[2] =3D SW_TRIP,
> -	.trigger_type[3] =3D HW_TRIP,
> -	.max_trigger_level =3D 4,
> -	.gain =3D 8,
> -	.reference_voltage =3D 16,
> -	.noise_cancel_mode =3D 4,
> -	.cal_type =3D TYPE_ONE_POINT_TRIMMING,
> -	.efuse_value =3D 55,
> -	.min_efuse_value =3D 40,
> -	.max_efuse_value =3D 100,
> -	.first_point_trim =3D 25,
> -	.second_point_trim =3D 85,
> -	.default_temp_offset =3D 50,
> -	.freq_tab[0] =3D {
> -		.freq_clip_max =3D 800 * 1000,
> -		.temp_level =3D 85,
> -	},
> -	.freq_tab[1] =3D {
> -		.freq_clip_max =3D 200 * 1000,
> -		.temp_level =3D 103,
> -	},
> -	.freq_tab_count =3D 2,
> -	.type =3D SOC_ARCH_EXYNOS,
> +
> +#define EXYNOS5250_TMU_DATA \
> +	.threshold_falling =3D 10, \
> +	.trigger_levels[0] =3D 85, \
> +	.trigger_levels[1] =3D 103, \
> +	.trigger_levels[2] =3D 110, \
> +	.trigger_levels[3] =3D 120, \
> +	.trigger_enable[0] =3D 1, \
> +	.trigger_enable[1] =3D 1, \
> +	.trigger_enable[2] =3D 1, \
> +	.trigger_enable[3] =3D 0, \
> +	.trigger_type[0] =3D THROTTLE_ACTIVE, \
> +	.trigger_type[1] =3D THROTTLE_ACTIVE, \
> +	.trigger_type[2] =3D SW_TRIP, \
> +	.trigger_type[3] =3D HW_TRIP, \
> +	.max_trigger_level =3D 4, \
> +	.gain =3D 8, \
> +	.reference_voltage =3D 16, \
> +	.noise_cancel_mode =3D 4, \
> +	.cal_type =3D TYPE_ONE_POINT_TRIMMING, \
> +	.efuse_value =3D 55, \
> +	.min_efuse_value =3D 40, \
> +	.max_efuse_value =3D 100, \
> +	.first_point_trim =3D 25, \
> +	.second_point_trim =3D 85, \
> +	.default_temp_offset =3D 50, \
> +	.freq_tab[0] =3D { \
> +		.freq_clip_max =3D 800 * 1000, \
> +		.temp_level =3D 85, \
> +	}, \
> +	.freq_tab[1] =3D { \
> +		.freq_clip_max =3D 200 * 1000, \
> +		.temp_level =3D 103, \
> +	}, \
> +	.freq_tab_count =3D 2, \
> +	.type =3D SOC_ARCH_EXYNOS, \
>  	.registers =3D &exynos5250_tmu_registers,
> +
> +struct exynos_tmu_init_data const exynos5250_default_tmu_data =3D {
> +	.tmu_data =3D {
> +		{ EXYNOS5250_TMU_DATA },
> +	},
> +	.tmu_count =3D 1,
>  };
>  #endif
> diff --git a/drivers/thermal/samsung/exynos_tmu_data.h b/drivers/therma=
l/samsung/exynos_tmu_data.h
> index 4acf070..139dbbb 100644
> --- a/drivers/thermal/samsung/exynos_tmu_data.h
> +++ b/drivers/thermal/samsung/exynos_tmu_data.h
> @@ -94,14 +94,14 @@
>  #define EXYNOS_MAX_TRIGGER_PER_REG	4
> =20
>  #if defined(CONFIG_CPU_EXYNOS4210)
> -extern struct exynos_tmu_platform_data const exynos4210_default_tmu_da=
ta;
> +extern struct exynos_tmu_init_data const exynos4210_default_tmu_data;
>  #define EXYNOS4210_TMU_DRV_DATA (&exynos4210_default_tmu_data)
>  #else
>  #define EXYNOS4210_TMU_DRV_DATA (NULL)
>  #endif
> =20
>  #if (defined(CONFIG_SOC_EXYNOS5250) || defined(CONFIG_SOC_EXYNOS4412))=

> -extern struct exynos_tmu_platform_data const exynos5250_default_tmu_da=
ta;
> +extern struct exynos_tmu_init_data const exynos5250_default_tmu_data;
>  #define EXYNOS5250_TMU_DRV_DATA (&exynos5250_default_tmu_data)
>  #else
>  #define EXYNOS5250_TMU_DRV_DATA (NULL)
>=20


--=20
You have got to be excited about what you are doing. (L. Lamport)

Eduardo Valentin


------enig2GUQPLIUGXKMFKOOVQEMR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iF4EAREIAAYFAlHCPngACgkQCXcVR3XQvP3cOwD+Jrt/7PKnTC7MgR5dTmfm1zYg
/QX2QUtLF713gEFrQsIBAOd4QbuaBZzv1oiv59bERj0IMMwKoPpp/9akoDvafaX5
=uS1a
-----END PGP SIGNATURE-----

------enig2GUQPLIUGXKMFKOOVQEMR--
