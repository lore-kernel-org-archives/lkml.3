Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754350Ab3EIOsA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 10:48:00 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:39431 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751314Ab3EIOr6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 10:47:58 -0400
Message-ID: <518BB70E.1090507@ti.com>
Date: Thu, 9 May 2013 10:47:42 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130404 Thunderbird/17.0.5
MIME-Version: 1.0
To: Amit Daniel Kachhap <amit.daniel@samsung.com>
CC: <linux-pm@vger.kernel.org>, Zhang Rui <rui.zhang@intel.com>,
        <linux-samsung-soc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <amit.kachhap@gmail.com>, Kukjin Kim <kgene.kim@samsung.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>
Subject: Re: [PATCH V3 18/21] thermal: exynos: Add support for exynos5440
 TMU sensor.
References: <1367931671-3906-1-git-send-email-amit.daniel@samsung.com> <1367931671-3906-19-git-send-email-amit.daniel@samsung.com>
In-Reply-To: <1367931671-3906-19-git-send-email-amit.daniel@samsung.com>
X-Enigmail-Version: 1.5.1
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature";
	boundary="----enig2VESTLUTDWWVRWTXSPECA"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------enig2VESTLUTDWWVRWTXSPECA
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hey Amit,

On 07-05-2013 09:01, Amit Daniel Kachhap wrote:
> This patch modifies TMU controller to add changes needed to work with
> exynos5440 platform. Also register definitions and required configurati=
on data
> are added. This sensor registers 3 instance of the tmu controller with =
the
> thermal zone and hence reports 3 temperature output. This controller su=
pports
> upto five trip points. For critical threshold the driver uses the core =
driver
> thermal framework for shutdown.
>=20

I would kindly request you to split this patch. Looks like you add
altogether in one patch both data, driver adaptation (for your new soc)
and on top, new features. I would suggest splitting this things in
smaller steps. Easier to review, track, bitsec and find bugs (if any).

> Acked-by: Kukjin Kim <kgene.kim@samsung.com>
> Signed-off-by: Amit Daniel Kachhap <amit.daniel@samsung.com>
> ---
>  .../devicetree/bindings/thermal/exynos-thermal.txt |   28 ++++-
>  drivers/thermal/samsung/Kconfig                    |    4 +-
>  drivers/thermal/samsung/exynos_thermal_common.c    |    2 +-
>  drivers/thermal/samsung/exynos_tmu.c               |  139 ++++++++++++=
+++++---
>  drivers/thermal/samsung/exynos_tmu.h               |    7 +
>  drivers/thermal/samsung/exynos_tmu_data.c          |   66 +++++++++-
>  drivers/thermal/samsung/exynos_tmu_data.h          |   40 ++++++
>  7 files changed, 261 insertions(+), 25 deletions(-)
>=20
> diff --git a/Documentation/devicetree/bindings/thermal/exynos-thermal.t=
xt b/Documentation/devicetree/bindings/thermal/exynos-thermal.txt
> index 535fd0e..970eeba 100644
> --- a/Documentation/devicetree/bindings/thermal/exynos-thermal.txt
> +++ b/Documentation/devicetree/bindings/thermal/exynos-thermal.txt
> @@ -6,13 +6,16 @@
>  	       "samsung,exynos4412-tmu"
>  	       "samsung,exynos4210-tmu"
>  	       "samsung,exynos5250-tmu"
> +	       "samsung,exynos5440-tmu"
>  - interrupt-parent : The phandle for the interrupt controller
> -- reg : Address range of the thermal registers
> +- reg : Address range of the thermal registers. For exynos5440-tmu whi=
ch has 3
> +	instances of TMU, 2 set of register has to supplied. First set belong=
s
> +	to each instance of TMU and second set belongs to common TMU register=
s.
>  - interrupts : Should contain interrupt for thermal system
>  - clocks : The main clock for TMU device
>  - clock-names : Thermal system clock name
> =20
> -Example:
> +Example 1):
> =20
>  	tmu@100C0000 {
>  		compatible =3D "samsung,exynos4412-tmu";
> @@ -23,3 +26,24 @@ Example:
>  		clock-names =3D "tmu_apbif";
>  		status =3D "disabled";
>  	};
> +
> +Example 2):
> +
> +	tmuctrl_0: tmuctrl@160118 {
> +		compatible =3D "samsung,exynos5440-tmu";
> +		reg =3D <0x160118 0x230>, <0x160368 0x10>;
> +		interrupts =3D <0 58 0>;
> +		clocks =3D <&clock 21>;
> +		clock-names =3D "tmu_apbif";
> +	};
> +
> +Note: For multi-instance tmu each instance should have an alias correc=
tly
> +numbered in "aliases" node.
> +
> +Example:
> +
> +aliases {
> +	tmuctrl0 =3D &tmuctrl_0;
> +	tmuctrl1 =3D &tmuctrl_1;
> +	tmuctrl2 =3D &tmuctrl_2;
> +};
> diff --git a/drivers/thermal/samsung/Kconfig b/drivers/thermal/samsung/=
Kconfig
> index f23f533..fce04f3 100644
> --- a/drivers/thermal/samsung/Kconfig
> +++ b/drivers/thermal/samsung/Kconfig
> @@ -19,10 +19,10 @@ config EXYNOS_THERMAL_CORE
> =20
>  config EXYNOS_THERMAL_DATA
>  	bool "Temperature sensor congiguration data for EXYNOS series SOC"
> -	depends on (CPU_EXYNOS4210 || SOC_EXYNOS4212 || SOC_EXYNOS4412 || SOC=
_EXYNOS5250)
> +	depends on (CPU_EXYNOS4210 || SOC_EXYNOS4212 || SOC_EXYNOS4412 || SOC=
_EXYNOS5250 || SOC_EXYNOS5440)
>  	depends on EXYNOS_THERMAL
>  	help
>  	  If you say yes here you can enable TMU (Thermal Management Unit) on=

> -	  SAMSUNG EXYNOS 4210, 4412, 4414 and 5250 series of SoC. This option=

> +	  SAMSUNG EXYNOS 4210, 4412, 4414, 5250 and 5440 series of SoC. This =
option
>  	  enables/prepares the configuration, trip and cooling data for the T=
MU
>  	  driver.
> diff --git a/drivers/thermal/samsung/exynos_thermal_common.c b/drivers/=
thermal/samsung/exynos_thermal_common.c
> index b0dc63e..de43e18 100644
> --- a/drivers/thermal/samsung/exynos_thermal_common.c
> +++ b/drivers/thermal/samsung/exynos_thermal_common.c
> @@ -370,7 +370,7 @@ int exynos_register_thermal(struct thermal_sensor_c=
onf *sensor_conf)
>  	th_zone->mode =3D THERMAL_DEVICE_ENABLED;
>  	sensor_conf->pzone_data =3D th_zone;
> =20
> -	pr_info("Exynos: Kernel Thermal management registered\n");
> +	pr_info("Exynos: Thermal zone(%s) registered\n", sensor_conf->name);
> =20
>  	return 0;
> =20
> diff --git a/drivers/thermal/samsung/exynos_tmu.c b/drivers/thermal/sam=
sung/exynos_tmu.c
> index c1a8c5f..72446c9 100644
> --- a/drivers/thermal/samsung/exynos_tmu.c
> +++ b/drivers/thermal/samsung/exynos_tmu.c
> @@ -44,6 +44,7 @@
>   * @id: identifier of the one instance of the TMU controller.
>   * @pdata: pointer to the tmu platform/configuration data
>   * @base: base address of the single instance of the TMU controller.
> + * @base_common: base address of the common registers of the TMU contr=
oller.
>   * @irq: irq number of the TMU controller.
>   * @soc: id of the SOC type.
>   * @irq_work: pointer to the irq work structure.
> @@ -57,6 +58,7 @@ struct exynos_tmu_data {
>  	int id;
>  	struct exynos_tmu_platform_data *pdata;
>  	void __iomem *base;
> +	void __iomem *base_common;
>  	int irq;
>  	enum soc_type soc;
>  	struct work_struct irq_work;
> @@ -75,6 +77,9 @@ static int temp_to_code(struct exynos_tmu_data *data,=
 u8 temp)
>  	struct exynos_tmu_platform_data *pdata =3D data->pdata;
>  	int temp_code;
> =20
> +	if (pdata->cal_mode =3D=3D HW_MODE)
> +		return temp;
> +
>  	if (data->soc =3D=3D SOC_ARCH_EXYNOS4210)
>  		/* temp should range between 25 and 125 */
>  		if (temp < 25 || temp > 125) {
> @@ -109,6 +114,9 @@ static int code_to_temp(struct exynos_tmu_data *dat=
a, u8 temp_code)
>  	struct exynos_tmu_platform_data *pdata =3D data->pdata;
>  	int temp;
> =20
> +	if (pdata->cal_mode =3D=3D HW_MODE)
> +		return temp_code;
> +
>  	if (data->soc =3D=3D SOC_ARCH_EXYNOS4210)
>  		/* temp_code should range between 75 and 175 */
>  		if (temp_code < 75 || temp_code > 175) {
> @@ -139,33 +147,63 @@ static int exynos_tmu_initialize(struct platform_=
device *pdev)
>  	struct exynos_tmu_data *data =3D platform_get_drvdata(pdev);
>  	struct exynos_tmu_platform_data *pdata =3D data->pdata;
>  	struct exynos_tmu_registers *reg =3D pdata->registers;
> -	unsigned int status, trim_info, con;
> +	unsigned int status, trim_info =3D 0, con;
>  	unsigned int rising_threshold =3D 0, falling_threshold =3D 0;
>  	int ret =3D 0, threshold_code, i, trigger_levs =3D 0;
> =20
>  	mutex_lock(&data->lock);
>  	clk_enable(data->clk);
> =20
> -	status =3D readb(data->base + reg->tmu_status);
> -	if (!status) {
> -		ret =3D -EBUSY;
> -		goto out;
> +	if (TMU_SUPPORTS(pdata, READY_STATUS)) {
> +		status =3D readb(data->base + reg->tmu_status);
> +		if (!status) {
> +			ret =3D -EBUSY;
> +			goto out;
> +		}
>  	}
> =20
>  	if (TMU_SUPPORTS(pdata, TRIM_RELOAD))
>  		__raw_writel(1, data->base + reg->triminfo_ctrl);
> =20
> +	if (pdata->cal_mode =3D=3D HW_MODE)
> +		goto skip_calib_data;
> +
>  	/* Save trimming info in order to perform calibration */
> -	trim_info =3D readl(data->base + reg->triminfo_data);
> +	if (data->soc =3D=3D SOC_ARCH_EXYNOS5440) {
> +		/*
> +		 * For exynos5440 soc triminfo value is swapped between TMU0 and
> +		 * TMU2, so the below logic is needed.
> +		 */
> +		switch (data->id) {
> +		case 0:
> +			trim_info =3D readl(data->base +
> +			EXYNOS5440_EFUSE_SWAP_OFFSET + reg->triminfo_data);
> +			break;
> +		case 1:
> +			trim_info =3D readl(data->base + reg->triminfo_data);
> +			break;
> +		case 2:
> +			trim_info =3D readl(data->base -
> +			EXYNOS5440_EFUSE_SWAP_OFFSET + reg->triminfo_data);
> +		}
> +	} else {
> +		trim_info =3D readl(data->base + reg->triminfo_data);
> +	}
>  	data->temp_error1 =3D trim_info & EXYNOS_TMU_TEMP_MASK;
>  	data->temp_error2 =3D ((trim_info >> reg->triminfo_85_shift) &
>  				EXYNOS_TMU_TEMP_MASK);
> =20
> -	if ((pdata->min_efuse_value > data->temp_error1) ||
> -			(data->temp_error1 > pdata->max_efuse_value) ||
> -			(data->temp_error2 !=3D 0))
> -		data->temp_error1 =3D pdata->efuse_value;
> +	if (!data->temp_error1 ||
> +		(pdata->min_efuse_value > data->temp_error1) ||
> +		(data->temp_error1 > pdata->max_efuse_value))
> +		data->temp_error1 =3D pdata->efuse_value & EXYNOS_TMU_TEMP_MASK;
> +
> +	if (!data->temp_error2)
> +		data->temp_error2 =3D
> +			(pdata->efuse_value >> reg->triminfo_85_shift) &
> +			EXYNOS_TMU_TEMP_MASK;
> =20
> +skip_calib_data:
>  	/* Count trigger levels to be enabled */
>  	for (i =3D 0; i < MAX_THRESHOLD_LEVS; i++)
>  		if (pdata->trigger_levels[i])
> @@ -185,9 +223,10 @@ static int exynos_tmu_initialize(struct platform_d=
evice *pdev)
>  			data->base + reg->threshold_th0 + i * 4);
> =20
>  		writel(reg->inten_rise_mask, data->base + reg->tmu_intclear);
> -	} else if (data->soc =3D=3D SOC_ARCH_EXYNOS) {
> +	} else if (data->soc =3D=3D SOC_ARCH_EXYNOS ||
> +			data->soc =3D=3D SOC_ARCH_EXYNOS5440) {
>  		/* Write temperature code for rising and falling threshold */
> -		for (i =3D 0; i < trigger_levs; i++) {
> +		for (i =3D 0; i < trigger_levs && i < 4 ; i++) {
>  			threshold_code =3D temp_to_code(data,
>  						pdata->trigger_levels[i]);
>  			if (threshold_code < 0) {
> @@ -218,7 +257,29 @@ static int exynos_tmu_initialize(struct platform_d=
evice *pdev)
>  		writel((reg->inten_rise_mask << reg->inten_rise_shift) |
>  			(reg->inten_fall_mask << reg->inten_fall_shift),
>  				data->base + reg->tmu_intclear);
> +
> +		/* if 5th threshold limit is also present, use TH2 register */
> +		i =3D 4;
> +		if (pdata->trigger_levels[i]) {
> +			threshold_code =3D temp_to_code(data,
> +						pdata->trigger_levels[i]);
> +			if (threshold_code < 0) {
> +				ret =3D threshold_code;
> +				goto out;
> +			}
> +			rising_threshold =3D threshold_code << 24;
> +			writel(rising_threshold,
> +				data->base + reg->threshold_th2);
> +			if (pdata->trigger_type[i] =3D=3D HW_TRIP) {
> +				con =3D readl(data->base + reg->tmu_ctrl);
> +				con |=3D (1 << reg->therm_trip_en_shift);
> +				writel(con, data->base + reg->tmu_ctrl);
> +			}
> +		}
>  	}
> +	/*Clear the PMIN in the common TMU register*/
> +	if (reg->tmu_pmin && !data->id)
> +		writel(0, data->base_common + reg->tmu_pmin);
>  out:
>  	clk_disable(data->clk);
>  	mutex_unlock(&data->lock);
> @@ -254,6 +315,11 @@ static void exynos_tmu_control(struct platform_dev=
ice *pdev, bool on)
>  		con |=3D (pdata->noise_cancel_mode << reg->therm_trip_mode_shift);
>  	}
> =20
> +	if (pdata->cal_mode =3D=3D HW_MODE) {
> +		con &=3D ~(reg->calib_mode_mask << reg->calib_mode_shift);
> +		con |=3D pdata->cal_type << reg->calib_mode_shift;
> +	}
> +
>  	if (on) {
>  		con |=3D (1 << reg->core_en_shift);
>  		interrupt_en =3D
> @@ -317,9 +383,11 @@ static int exynos_tmu_set_emulation(void *drv_data=
, unsigned long temp)
>  	if (temp) {
>  		temp /=3D MCELSIUS;
> =20
> -		val =3D (EXYNOS_EMUL_TIME << reg->emul_time_shift) |
> -			(temp_to_code(data, temp)
> -			 << reg->emul_temp_shift) | EXYNOS_EMUL_ENABLE;
> +		if (data->soc =3D=3D SOC_ARCH_EXYNOS && reg->emul_time_shift)
> +			val |=3D (EXYNOS_EMUL_TIME << reg->emul_time_shift);
> +
> +		val |=3D (temp_to_code(data, temp) << reg->emul_temp_shift) |
> +			EXYNOS_EMUL_ENABLE;
>  	} else {
>  		val &=3D ~EXYNOS_EMUL_ENABLE;
>  	}
> @@ -343,7 +411,14 @@ static void exynos_tmu_work(struct work_struct *wo=
rk)
>  			struct exynos_tmu_data, irq_work);
>  	struct exynos_tmu_platform_data *pdata =3D data->pdata;
>  	struct exynos_tmu_registers *reg =3D pdata->registers;
> -	unsigned int val_irq;
> +	unsigned int val_irq, val_type;
> +
> +	/* Find which sensor generated this interrupt */
> +	if (reg->tmu_irqstatus) {
> +		val_type =3D readl(data->base_common + reg->tmu_irqstatus);
> +		if (!((val_type >> data->id) & 0x1))
> +			goto out;
> +	}
> =20
>  	exynos_report_trigger(data->reg_conf);
>  	mutex_lock(&data->lock);
> @@ -355,7 +430,7 @@ static void exynos_tmu_work(struct work_struct *wor=
k)
> =20
>  	clk_disable(data->clk);
>  	mutex_unlock(&data->lock);
> -
> +out:
>  	enable_irq(data->irq);
>  }
> =20
> @@ -383,6 +458,10 @@ static const struct of_device_id exynos_tmu_match[=
] =3D {
>  		.compatible =3D "samsung,exynos5250-tmu",
>  		.data =3D (void *)EXYNOS5250_TMU_DRV_DATA,
>  	},
> +	{
> +		.compatible =3D "samsung,exynos5440-tmu",
> +		.data =3D (void *)EXYNOS5440_TMU_DRV_DATA,
> +	},
>  	{},
>  };
>  MODULE_DEVICE_TABLE(of, exynos_tmu_match);
> @@ -420,6 +499,7 @@ static inline struct  exynos_tmu_platform_data *exy=
nos_get_driver_data(
>  static int exynos_map_dt_data(struct platform_device *pdev)
>  {
>  	struct exynos_tmu_data *data =3D platform_get_drvdata(pdev);
> +	struct exynos_tmu_platform_data *pdata =3D data->pdata;
>  	struct resource res;
> =20
>  	if (!data)
> @@ -436,7 +516,7 @@ static int exynos_map_dt_data(struct platform_devic=
e *pdev)
>  	}
> =20
>  	if (of_address_to_resource(pdev->dev.of_node, 0, &res)) {
> -		dev_err(&pdev->dev, "failed to get Resource\n");
> +		dev_err(&pdev->dev, "failed to get Resource 0\n");
>  		return -ENODEV;
>  	}
> =20
> @@ -445,6 +525,26 @@ static int exynos_map_dt_data(struct platform_devi=
ce *pdev)
>  		dev_err(&pdev->dev, "Failed to ioremap memory\n");
>  		return -ENOMEM;
>  	}
> +
> +	/*
> +	 * Check if the TMU is multi instance type and then try to map the
> +	 * memory of common registers.
> +	 */
> +	if (!TMU_SUPPORTS(pdata, MULTI_INST))
> +		return 0;
> +
> +	if (of_address_to_resource(pdev->dev.of_node, 1, &res)) {
> +		dev_err(&pdev->dev, "failed to get Resource 1\n");
> +		return -ENODEV;
> +	}
> +
> +	data->base_common =3D devm_ioremap(&pdev->dev, res.start,
> +					resource_size(&res));
> +	if (!data->base) {
> +		dev_err(&pdev->dev, "Failed to ioremap memory\n");
> +		return -ENOMEM;
> +	}
> +
>  	return 0;
>  }
> =20
> @@ -496,7 +596,8 @@ static int exynos_tmu_probe(struct platform_device =
*pdev)
>  		return ret;
> =20
>  	if (pdata->type =3D=3D SOC_ARCH_EXYNOS ||
> -				pdata->type =3D=3D SOC_ARCH_EXYNOS4210)
> +		pdata->type =3D=3D SOC_ARCH_EXYNOS4210 ||
> +		pdata->type =3D=3D SOC_ARCH_EXYNOS5440)
>  		data->soc =3D pdata->type;
>  	else {
>  		ret =3D -EINVAL;
> diff --git a/drivers/thermal/samsung/exynos_tmu.h b/drivers/thermal/sam=
sung/exynos_tmu.h
> index de1c342..cc6b10e 100644
> --- a/drivers/thermal/samsung/exynos_tmu.h
> +++ b/drivers/thermal/samsung/exynos_tmu.h
> @@ -43,6 +43,7 @@ enum trigger_type {
>  enum soc_type {
>  	SOC_ARCH_EXYNOS4210 =3D 1,
>  	SOC_ARCH_EXYNOS,
> +	SOC_ARCH_EXYNOS5440,
>  };
> =20
>  /**
> @@ -61,6 +62,7 @@ enum soc_type {
>  #define TMU_SUPPORT_MULTI_INST			BIT(1)
>  #define TMU_SUPPORT_TRIM_RELOAD			BIT(2)
>  #define TMU_SUPPORT_FALLING_TRIP		BIT(3)
> +#define TMU_SUPPORT_READY_STATUS		BIT(4)
> =20
>  #define TMU_SUPPORTS(a, b)	(a->features & TMU_SUPPORT_ ## b)
> =20
> @@ -85,6 +87,8 @@ struct exynos_tmu_registers {
>  	u32	therm_trip_en_shift;
>  	u32	buf_slope_sel_shift;
>  	u32	buf_slope_sel_mask;
> +	u32	calib_mode_shift;
> +	u32	calib_mode_mask;
>  	u32	therm_trip_tq_en_shift;
>  	u32	core_en_shift;
> =20
> @@ -137,6 +141,9 @@ struct exynos_tmu_registers {
>  	u32	emul_temp_shift;
>  	u32	emul_time_shift;
>  	u32	emul_time_mask;
> +
> +	u32	tmu_irqstatus;
> +	u32	tmu_pmin;
>  };
> =20
>  /**
> diff --git a/drivers/thermal/samsung/exynos_tmu_data.c b/drivers/therma=
l/samsung/exynos_tmu_data.c
> index 8a587d4..25629e6 100644
> --- a/drivers/thermal/samsung/exynos_tmu_data.c
> +++ b/drivers/thermal/samsung/exynos_tmu_data.c
> @@ -79,6 +79,7 @@ struct exynos_tmu_platform_data const exynos4210_defa=
ult_tmu_data =3D {
>  	.freq_tab_count =3D 2,
>  	.type =3D SOC_ARCH_EXYNOS4210,
>  	.registers =3D &exynos4210_tmu_registers,
> +	.features =3D (TMU_SUPPORT_READY_STATUS),
>  };
>  #endif
> =20
> @@ -155,6 +156,69 @@ struct exynos_tmu_platform_data const exynos5250_d=
efault_tmu_data =3D {
>  	.type =3D SOC_ARCH_EXYNOS,
>  	.registers =3D &exynos5250_tmu_registers,
>  	.features =3D (TMU_SUPPORT_EMULATION | TMU_SUPPORT_TRIM_RELOAD |
> -			TMU_SUPPORT_FALLING_TRIP),
> +			TMU_SUPPORT_FALLING_TRIP | TMU_SUPPORT_READY_STATUS),
> +};
> +#endif
> +
> +#if defined(CONFIG_SOC_EXYNOS5440)
> +static struct exynos_tmu_registers exynos5440_tmu_registers =3D {
> +	.triminfo_data =3D EXYNOS5440_TMU_S0_7_TRIM,
> +	.triminfo_25_shift =3D EXYNOS_TRIMINFO_25_SHIFT,
> +	.triminfo_85_shift =3D EXYNOS_TRIMINFO_85_SHIFT,
> +	.tmu_ctrl =3D EXYNOS5440_TMU_S0_7_CTRL,
> +	.buf_vref_sel_shift =3D EXYNOS_TMU_REF_VOLTAGE_SHIFT,
> +	.buf_vref_sel_mask =3D EXYNOS_TMU_REF_VOLTAGE_MASK,
> +	.therm_trip_mode_shift =3D EXYNOS_TMU_TRIP_MODE_SHIFT,
> +	.therm_trip_mode_mask =3D EXYNOS_TMU_TRIP_MODE_MASK,
> +	.therm_trip_en_shift =3D EXYNOS_TMU_THERM_TRIP_EN_SHIFT,
> +	.buf_slope_sel_shift =3D EXYNOS_TMU_BUF_SLOPE_SEL_SHIFT,
> +	.buf_slope_sel_mask =3D EXYNOS_TMU_BUF_SLOPE_SEL_MASK,
> +	.calib_mode_shift =3D EXYNOS_TMU_CALIB_MODE_SHIFT,
> +	.calib_mode_mask =3D EXYNOS_TMU_CALIB_MODE_MASK,
> +	.core_en_shift =3D EXYNOS_TMU_CORE_EN_SHIFT,
> +	.tmu_status =3D EXYNOS5440_TMU_S0_7_STATUS,
> +	.tmu_cur_temp =3D EXYNOS5440_TMU_S0_7_TEMP,
> +	.threshold_th0 =3D EXYNOS5440_TMU_S0_7_TH0,
> +	.threshold_th1 =3D EXYNOS5440_TMU_S0_7_TH1,
> +	.threshold_th2 =3D EXYNOS5440_TMU_S0_7_TH2,
> +	.tmu_inten =3D EXYNOS5440_TMU_S0_7_IRQEN,
> +	.inten_rise_mask =3D EXYNOS5440_TMU_RISE_INT_MASK,
> +	.inten_rise_shift =3D EXYNOS5440_TMU_RISE_INT_SHIFT,
> +	.inten_fall_mask =3D EXYNOS5440_TMU_FALL_INT_MASK,
> +	.inten_fall_shift =3D EXYNOS5440_TMU_FALL_INT_SHIFT,
> +	.inten_rise0_shift =3D EXYNOS5440_TMU_INTEN_RISE0_SHIFT,
> +	.inten_rise1_shift =3D EXYNOS5440_TMU_INTEN_RISE1_SHIFT,
> +	.inten_rise2_shift =3D EXYNOS5440_TMU_INTEN_RISE2_SHIFT,
> +	.inten_rise3_shift =3D EXYNOS5440_TMU_INTEN_RISE3_SHIFT,
> +	.inten_fall0_shift =3D EXYNOS5440_TMU_INTEN_FALL0_SHIFT,
> +	.tmu_evten =3D EXYNOS5440_TMU_S0_7_EVTEN,
> +	.tmu_intstat =3D EXYNOS5440_TMU_S0_7_IRQ,
> +	.tmu_intclear =3D EXYNOS5440_TMU_S0_7_IRQ,
> +	.tmu_irqstatus =3D EXYNOS5440_TMU_IRQ_STATUS,
> +	.emul_con =3D EXYNOS5440_TMU_S0_7_DEBUG,
> +	.emul_temp_shift =3D EXYNOS_EMUL_DATA_SHIFT,
> +	.tmu_pmin =3D EXYNOS5440_TMU_PMIN,
> +};
> +struct exynos_tmu_platform_data const exynos5440_default_tmu_data =3D =
{
> +	.trigger_levels[0] =3D 100,
> +	.trigger_levels[4] =3D 105,
> +	.trigger_enable[0] =3D 1,
> +	.trigger_type[0] =3D 1,
> +	.trigger_type[4] =3D 2,
> +	.gain =3D 5,
> +	.reference_voltage =3D 16,
> +	.noise_cancel_mode =3D 4,
> +	.cal_type =3D TYPE_TWO_POINT_TRIMMING,
> +	.cal_mode =3D 0,
> +	.efuse_value =3D 0x5b2d,
> +	.min_efuse_value =3D 16,
> +	.max_efuse_value =3D 76,
> +	.first_point_trim =3D 25,
> +	.second_point_trim =3D 70,
> +	.default_temp_offset =3D 25,
> +	.type =3D SOC_ARCH_EXYNOS5440,
> +	.registers =3D &exynos5440_tmu_registers,
> +	.features =3D (TMU_SUPPORT_EMULATION | TMU_SUPPORT_FALLING_TRIP |
> +			TMU_SUPPORT_MULTI_INST),
>  };
>  #endif
> diff --git a/drivers/thermal/samsung/exynos_tmu_data.h b/drivers/therma=
l/samsung/exynos_tmu_data.h
> index 0560413..c409f3a 100644
> --- a/drivers/thermal/samsung/exynos_tmu_data.h
> +++ b/drivers/thermal/samsung/exynos_tmu_data.h
> @@ -75,6 +75,8 @@
>  #define EXYNOS_TMU_TRIP_MODE_SHIFT	13
>  #define EXYNOS_TMU_TRIP_MODE_MASK	0x7
>  #define EXYNOS_TMU_THERM_TRIP_EN_SHIFT	12
> +#define EXYNOS_TMU_CALIB_MODE_SHIFT	4
> +#define EXYNOS_TMU_CALIB_MODE_MASK	0x3
> =20
>  #define EXYNOS_TMU_INTEN_RISE0_SHIFT	0
>  #define EXYNOS_TMU_INTEN_RISE1_SHIFT	4
> @@ -91,6 +93,37 @@
>  #define EXYNOS_EMUL_DATA_MASK	0xFF
>  #define EXYNOS_EMUL_ENABLE	0x1
> =20
> +/*exynos5440 specific registers*/
> +#define EXYNOS5440_TMU_S0_7_TRIM		0x000
> +#define EXYNOS5440_TMU_S0_7_CTRL		0x020
> +#define EXYNOS5440_TMU_S0_7_DEBUG		0x040
> +#define EXYNOS5440_TMU_S0_7_STATUS		0x060
> +#define EXYNOS5440_TMU_S0_7_TEMP		0x0f0
> +#define EXYNOS5440_TMU_S0_7_TH0			0x110
> +#define EXYNOS5440_TMU_S0_7_TH1			0x130
> +#define EXYNOS5440_TMU_S0_7_TH2			0x150
> +#define EXYNOS5440_TMU_S0_7_EVTEN		0x1F0
> +#define EXYNOS5440_TMU_S0_7_IRQEN		0x210
> +#define EXYNOS5440_TMU_S0_7_IRQ			0x230
> +/* exynos5440 common registers */
> +#define EXYNOS5440_TMU_IRQ_STATUS		0x000
> +#define EXYNOS5440_TMU_PMIN			0x004
> +#define EXYNOS5440_TMU_TEMP			0x008
> +
> +#define EXYNOS5440_EFUSE_SWAP_OFFSET		8
> +#define EXYNOS5440_TMU_RISE_INT_MASK		0xf
> +#define EXYNOS5440_TMU_RISE_INT_SHIFT		0
> +#define EXYNOS5440_TMU_FALL_INT_MASK		0xf
> +#define EXYNOS5440_TMU_FALL_INT_SHIFT		4
> +#define EXYNOS5440_TMU_INTEN_RISE0_SHIFT	0
> +#define EXYNOS5440_TMU_INTEN_RISE1_SHIFT	1
> +#define EXYNOS5440_TMU_INTEN_RISE2_SHIFT	2
> +#define EXYNOS5440_TMU_INTEN_RISE3_SHIFT	3
> +#define EXYNOS5440_TMU_INTEN_FALL0_SHIFT	4
> +#define EXYNOS5440_TMU_INTEN_FALL1_SHIFT	5
> +#define EXYNOS5440_TMU_INTEN_FALL2_SHIFT	6
> +#define EXYNOS5440_TMU_INTEN_FALL3_SHIFT	7
> +
>  #if defined(CONFIG_CPU_EXYNOS4210) && defined(CONFIG_EXYNOS_THERMAL_DA=
TA)
>  extern struct exynos_tmu_platform_data const exynos4210_default_tmu_da=
ta;
>  #define EXYNOS4210_TMU_DRV_DATA (&exynos4210_default_tmu_data)
> @@ -106,4 +139,11 @@ extern struct exynos_tmu_platform_data const exyno=
s5250_default_tmu_data;
>  #define EXYNOS5250_TMU_DRV_DATA (NULL)
>  #endif
> =20
> +#if defined(CONFIG_SOC_EXYNOS5440) && defined(CONFIG_EXYNOS_THERMAL_DA=
TA)
> +extern struct exynos_tmu_platform_data const exynos5440_default_tmu_da=
ta;
> +#define EXYNOS5440_TMU_DRV_DATA (&exynos5440_default_tmu_data)
> +#else
> +#define EXYNOS5440_TMU_DRV_DATA (NULL)
> +#endif
> +
>  #endif /*_LINUX_EXYNOS_TMU_DATA_H*/
>=20



------enig2VESTLUTDWWVRWTXSPECA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iF4EAREIAAYFAlGLtw4ACgkQCXcVR3XQvP3+WQEA3qeyoySH6JXrCzAsIh3W1yDY
X0gGjzbBb1OcOdpOZcgBAK0oOyywWvsVyz08Vj89l2fMt3NpNqCnA6oA3oI/BEE7
=5RK/
-----END PGP SIGNATURE-----

------enig2VESTLUTDWWVRWTXSPECA--
