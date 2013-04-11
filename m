Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935648Ab3DKVNr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 17:13:47 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:55552 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753490Ab3DKVNo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 17:13:44 -0400
Message-ID: <5167276F.2080308@ti.com>
Date: Thu, 11 Apr 2013 17:13:19 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Amit Daniel Kachhap <amit.daniel@samsung.com>
CC: <linux-pm@vger.kernel.org>, Thomas Abraham <thomas.abraham@linaro.org>,
        Zhang Rui <rui.zhang@intel.com>, <linux-samsung-soc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <amit.kachhap@gmail.com>,
        Kukjin Kim <kgene.kim@samsung.com>, <grant.likely@secretlab.ca>,
        <eduardo.valentin@ti.com>
Subject: Re: [8/9] thermal: exynos: Parse the platform data from the device
 tree.
References: <1364297642-2746-9-git-send-email-amit.daniel@samsung.com>
In-Reply-To: <1364297642-2746-9-git-send-email-amit.daniel@samsung.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Amit,

Copying Grant for the DT part discussion.

On 26-03-2013 07:34, Amit Daniel Kachhap wrote:
> This patch adds code to parse the DT based platform data like threshold temp,
> sensor configuration parameters like gain, reference voltages, calibration
> modes etc.
>
> Signed-off-by: Amit Daniel Kachhap <amit.daniel@samsung.com>
>
> ---
> .../bindings/thermal/exynos5440-thermal.txt        |   93 ++++++++++++++++++++
>   drivers/thermal/samsung/exynos5440_thermal.c       |    5 +-
>   drivers/thermal/samsung/exynos_common.c            |   92 +++++++++++++++++++
>   drivers/thermal/samsung/exynos_common.h            |    2 +
>   4 files changed, 189 insertions(+), 3 deletions(-)
>   create mode 100644 Documentation/devicetree/bindings/thermal/exynos5440-thermal.txt
>
> diff --git a/Documentation/devicetree/bindings/thermal/exynos5440-thermal.txt b/Documentation/devicetree/bindings/thermal/exynos5440-thermal.txt
> new file mode 100644
> index 0000000..1ad2dee
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/thermal/exynos5440-thermal.txt
> @@ -0,0 +1,93 @@
> +
> +Exynos5440 TMU driver
> +-------------------
> +
> +Exynos5440 SoC Thermal Sensor driver for CPU temperature measurement and
> +performing cooling actions.
> +
> +Required properties:
> +- interrupts: Interrupt to know the threshold change interrupts.
> +- clocks: phandle of the clock from common clock binding. More description can
> +	be found in Documentation/devicetree/bindings/clock/clock-bindings.txt.
> +- clock-name: clock name as used in the clock fetch.
> +- tmu-ctrl-data: phandle of the TMU controller configuration data. Its member
> +	description is shown below,
> +- gain: A factor describing the gain of amplifier. The value varies between
> +	0-15.
> +- reference-voltage: A factor describing the reference volt to amplifier. The
> +	value varies between 0-31.
> +- noise-cancel-mode: This value selects thermal tripping mode. The possible
> +	values can be,
> +		0: Use current temp.
> +		4: Use current temp and past 4 temp values.
> +		5: Use current temp and past 8 temp values.
> +		6: Use current temp and past 12 temp values.
> +		7: Use current temp and past 16 temp values.
> +-cal-type: This value selects temperature calibration mode. The possible values
> +	can be,
> +		0: No calibration.
> +		1: 1 point trimming method at 25 C.
> +		2: 1 point trimming method at 85 C.
> +		3: 2 point trimming method.
> +-cal-mode: This value selects hw/sw mode calibration. The possible values can be,
> +		0: Software calibration.
> +		1: Hardware calibration.
> +
> +Optional properties:
> +-efuse-value: This value should be used when the controller does not contain
> +	valid fused temperature data needed for calibration. This is a 16 bit
> +	value.
> +-threshold-falling: This value defines the falling threshold when it is added to
> +	trip threshold. If this value is not supplied then rising and falling
> +	threshold are same.
> +
> +-trip@: This node is added to define the trip properties. The trip members are
> +	shown below,
> +-trip: This field defines the trip ID. Exynos5440 has 5 trip ID.
> +-trigger-temp: Temperature at which threshold trigger is fired. Its unit is
> +	celsius.
> +-type: This denotes the type of trigger. The possible values are,
> +	0: active trip type
> +	1: critical
> +	2: hw system trip
> +-frequency-max: cpu frequency when this trip is reached.
> +
> +Example:
> +--------
> +	tmu_ctrl_info: tmu-ctrl-info {
Shouldnt this be named something like samsung,tmu_ctrl_info?

> +		gain = <8>;
> +		reference-voltage = <16>;
> +		noise-cancel-mode = <4>;
> +		cal-type = <0>;
> +		cal-mode = <0>;
> +		efuse-value = <0xabcd>;
> +		threshold-falling = <5>;
> +

ditto for the prefix of the above,

> +		trip@0{
> +			trip = <0>;
> +			trigger-temp = <80>;
> +			type = <0>;
> +			frequency-max = <1200000>;
> +		};
> +
> +		trip@3{
> +			trip = <3>;
> +			trigger-temp = <110>;
> +			type = <1>;
> +		};
> +
> +		trip@4{
> +			trip = <4>;
> +			trigger-temp = <120>;
> +			type = <2>;
> +		};
> +	};
> +
> +	tmuctrl_0: tmuctrl@160118 {
> +		compatible = "samsung,exynos5440-tmu";
> +		reg = <0x160118 0x300>;
> +		interrupts = <0 58 0>;
> +		clocks = <&clock 8>;
> +		clock-names = "tmu_apbif";
> +		tmu-ctrl-data = <&tmu_ctrl_info>;

ditto.

Grant,

In fact I believe we must talk about how to standardize the thermal 
description under DT.

> +	};
> diff --git a/drivers/thermal/samsung/exynos5440_thermal.c b/drivers/thermal/samsung/exynos5440_thermal.c
> index a3c75d3..c140e8c 100644
> --- a/drivers/thermal/samsung/exynos5440_thermal.c
> +++ b/drivers/thermal/samsung/exynos5440_thermal.c
> @@ -564,9 +564,8 @@ static int exynos_tmu_probe(struct platform_device *pdev)
>   		return -ENOMEM;
>   	}
>
> -	pdata = (struct exynos_tmu_platform_data *)
> -				platform_get_device_id(pdev)->driver_data;
> -	if (!pdata) {
> +	pdata = exynos_parse_tmu_dt_data(pdev);
> +	if (!pdata || IS_ERR(pdata)) {
>   		dev_err(&pdev->dev, "No platform init data supplied.\n");
>   		return -ENODEV;
>   	}
> diff --git a/drivers/thermal/samsung/exynos_common.c b/drivers/thermal/samsung/exynos_common.c
> index 0c0098d..345284c 100644
> --- a/drivers/thermal/samsung/exynos_common.c
> +++ b/drivers/thermal/samsung/exynos_common.c
> @@ -27,7 +27,9 @@
>   #include <linux/kernel.h>
>   #include <linux/kobject.h>
>   #include <linux/mutex.h>
> +#include <linux/of.h>
>   #include <linux/platform_data/exynos_thermal.h>
> +#include <linux/platform_device.h>
>   #include <linux/slab.h>
>   #include <linux/thermal.h>
>   #include "exynos_common.h"
> @@ -421,3 +423,93 @@ void exynos_unregister_thermal(struct thermal_sensor_conf *sensor_conf)
>   	kfree(th_zone);
>   	pr_info("Exynos: Kernel Thermal[%d] management unregistered\n", id);
>   }
> +
> +struct exynos_tmu_platform_data *
> +	exynos_parse_tmu_dt_data(struct platform_device *pdev)
> +{
> +	int ret;
> +	struct device_node *np, *cn;
> +	struct exynos_tmu_platform_data *pdata;
> +	unsigned int val, trip;
> +
> +	if (!pdev->dev.of_node)
> +		return ERR_PTR(-ENODEV);
> +
> +	pdata = devm_kzalloc(&pdev->dev, sizeof(*pdata), GFP_KERNEL);
> +	if (!pdata)
> +		return ERR_PTR(-ENOMEM);
> +
> +	np = of_parse_phandle(pdev->dev.of_node, "tmu-ctrl-data", 0);
> +	if (!np) {
> +		ret = -ENODEV;
> +		goto err_parse_dt;
> +	}
> +
> +	/* Parse compulsory parameters */
> +	ret = of_property_read_u32(np, "gain", &val);
> +	if (ret)
> +		goto err_parse_dt;
> +	pdata->gain = val;
> +
> +	ret = of_property_read_u32(np, "reference-voltage", &val);
> +	if (ret)
> +		goto err_parse_dt;
> +	pdata->reference_voltage = val;
> +
> +	ret = of_property_read_u32(np, "noise-cancel-mode", &val);
> +	if (ret)
> +		goto err_parse_dt;
> +	pdata->noise_cancel_mode = val;
> +
> +	ret = of_property_read_u32(np, "cal-type", &val);
> +	if (ret)
> +		goto err_parse_dt;
> +	pdata->cal_type = val;
> +
> +	ret = of_property_read_u32(np, "cal-mode", &val);
> +	if (ret)
> +		goto err_parse_dt;
> +	pdata->cal_mode = val;
> +
> +	/* Parse optional parameters */
> +	ret = of_property_read_u32(np, "efuse-value", &val);
> +	if (!ret)
> +		pdata->efuse_value = val;
> +
> +	ret = of_property_read_u32(np, "threshold-falling", &val);
> +	if (!ret)
> +		pdata->threshold_falling = val;
> +
> +	for (cn = NULL ; (cn = of_get_next_child(np, cn));) {
> +		/* Parse compulsory child parameters */
> +		ret = of_property_read_u32(cn, "trip", &trip);
> +		if (ret || trip > MAX_TRIP)
> +			goto err_parse_dt;
> +
> +		ret = of_property_read_u32(cn, "trigger-temp", &val);
> +		if (ret || !val)
> +			goto err_parse_dt;
> +		pdata->trigger_levels[trip] = val;
> +
> +		ret = of_property_read_u32(cn, "type", &val);
> +		if (ret || val > HW_TRIP)
> +			goto err_parse_dt;
> +		pdata->trigger_type[trip] = val;
> +
> +		/* Parse optional child parameters */
> +		ret = of_property_read_u32(cn, "frequency-max", &val);
> +		if (!ret && val) {
> +			pdata->freq_tab[pdata->freq_tab_count].freq_clip_max
> +				= val;
> +			pdata->freq_tab[pdata->freq_tab_count].temp_level
> +				= pdata->trigger_levels[trip];
> +			pdata->freq_tab_count++;
> +		}
> +		pdata->trigger_enable[trip] = true;
> +	}
> +	return pdata;
> +
> +err_parse_dt:
> +	dev_err(&pdev->dev, "Parsing TMU device tree data error.\n");
> +	return ERR_PTR(ret);
> +}
> diff --git a/drivers/thermal/samsung/exynos_common.h b/drivers/thermal/samsung/exynos_common.h
> index 453e09a..5ca640b 100644
> --- a/drivers/thermal/samsung/exynos_common.h
> +++ b/drivers/thermal/samsung/exynos_common.h
> @@ -69,4 +69,6 @@ void exynos_unregister_thermal(struct thermal_sensor_conf *sensor_conf);
>   int exynos_register_thermal(struct thermal_sensor_conf *sensor_conf);
>   void exynos_report_trigger(struct thermal_sensor_conf *sensor_conf);
>   int exynos_get_frequency_level(unsigned int cpu, unsigned int freq);
> +struct exynos_tmu_platform_data *
> +	exynos_parse_tmu_dt_data(struct platform_device *pdev);

This patch again generates a linking error while compiling as module
ERROR: "exynos_parse_tmu_dt_data" 
[drivers/thermal/samsung/exynos5440_thermal.ko] undefined!


>   #endif /* _LINUX_EXYNOS_COMMON_H */
>

