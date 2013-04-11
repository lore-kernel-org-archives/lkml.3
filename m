Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754637Ab3DKUJk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 16:09:40 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:52595 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753797Ab3DKUJi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 16:09:38 -0400
Message-ID: <51671868.2030102@ti.com>
Date: Thu, 11 Apr 2013 16:09:12 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Amit Daniel Kachhap <amit.daniel@samsung.com>
CC: <linux-pm@vger.kernel.org>, Thomas Abraham <thomas.abraham@linaro.org>,
        Zhang Rui <rui.zhang@intel.com>, <linux-samsung-soc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <amit.kachhap@gmail.com>,
        Kukjin Kim <kgene.kim@samsung.com>, <eduardo.valentin@ti.com>
Subject: Re: [2/9] thermal: exynos: Add support for instance based register/unregister
References: <1364297642-2746-3-git-send-email-amit.daniel@samsung.com>
In-Reply-To: <1364297642-2746-3-git-send-email-amit.daniel@samsung.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Amit,

On 26-03-2013 07:33, Amit Daniel Kachhap wrote:
> This code modifies the thermal driver to have multiple thermal zone
> support by replacing the global thermal zone varibale with device data

s/varibale/variable

> member of thermal_zone_device.
>
> Signed-off-by: Amit Daniel Kachhap <amit.daniel@samsung.com>

I understand the idea of your patch but I also see that you do at least 
to major changes. One is to set the thermal_device.devdata. The second 
is to split your internal reference private_data into driver_data and 
pzone_data. Is it possible to split this patch into two, one per 
modification? So it is easier to review your changes?

>
> ---
> drivers/thermal/exynos_thermal.c |   65 ++++++++++++++++++++++---------------
>   1 files changed, 39 insertions(+), 26 deletions(-)
>
> diff --git a/drivers/thermal/exynos_thermal.c b/drivers/thermal/exynos_thermal.c
> index 1cd7837..dc9b91b 100644
> --- a/drivers/thermal/exynos_thermal.c
> +++ b/drivers/thermal/exynos_thermal.c
> @@ -148,7 +148,8 @@ struct thermal_sensor_conf {
>   	int (*write_emul_temp)(void *drv_data, unsigned long temp);
>   	struct thermal_trip_point_conf trip_data;
>   	struct thermal_cooling_conf cooling_data;
> -	void *private_data;
> +	void *driver_data;
> +	void *pzone_data;
>   };
>
>   struct exynos_thermal_zone {
> @@ -161,14 +162,14 @@ struct exynos_thermal_zone {
>   	bool bind;
>   };
>
> -static struct exynos_thermal_zone *th_zone;
> -static void exynos_unregister_thermal(void);
> +static void exynos_unregister_thermal(struct thermal_sensor_conf *sensor_conf);
>   static int exynos_register_thermal(struct thermal_sensor_conf *sensor_conf);
>
>   /* Get mode callback functions for thermal zone */
>   static int exynos_get_mode(struct thermal_zone_device *thermal,
>   			enum thermal_device_mode *mode)
>   {
> +	struct exynos_thermal_zone *th_zone = thermal->devdata;
>   	if (th_zone)
>   		*mode = th_zone->mode;
>   	return 0;
> @@ -178,25 +179,26 @@ static int exynos_get_mode(struct thermal_zone_device *thermal,
>   static int exynos_set_mode(struct thermal_zone_device *thermal,
>   			enum thermal_device_mode mode)
>   {
> -	if (!th_zone->therm_dev) {
> +	struct exynos_thermal_zone *th_zone = thermal->devdata;
> +	if (!th_zone) {
>   		pr_notice("thermal zone not registered\n");
>   		return 0;
>   	}
>
> -	mutex_lock(&th_zone->therm_dev->lock);
> +	mutex_lock(&thermal->lock);
>
>   	if (mode == THERMAL_DEVICE_ENABLED &&
>   		!th_zone->sensor_conf->trip_data.trigger_falling)
> -		th_zone->therm_dev->polling_delay = IDLE_INTERVAL;
> +		thermal->polling_delay = IDLE_INTERVAL;
>   	else
> -		th_zone->therm_dev->polling_delay = 0;
> +		thermal->polling_delay = 0;
>
> -	mutex_unlock(&th_zone->therm_dev->lock);
> +	mutex_unlock(&thermal->lock);
>
>   	th_zone->mode = mode;
> -	thermal_zone_device_update(th_zone->therm_dev);
> +	thermal_zone_device_update(thermal);
>   	pr_info("thermal polling set for duration=%d msec\n",
> -				th_zone->therm_dev->polling_delay);
> +				thermal->polling_delay);
>   	return 0;
>   }
>
> @@ -223,6 +225,8 @@ static int exynos_get_trip_type(struct thermal_zone_device *thermal, int trip,
>   static int exynos_get_trip_temp(struct thermal_zone_device *thermal, int trip,
>   				unsigned long *temp)
>   {
> +	struct exynos_thermal_zone *th_zone = thermal->devdata;
> +
>   	if (trip < GET_TRIP(MONITOR_ZONE) || trip > GET_TRIP(PANIC_ZONE))
>   		return -EINVAL;
>
> @@ -269,6 +273,7 @@ static int exynos_bind(struct thermal_zone_device *thermal,
>   {
>   	int ret = 0, i, tab_size, level;
>   	struct freq_clip_table *tab_ptr, *clip_data;
> +	struct exynos_thermal_zone *th_zone = thermal->devdata;
>   	struct thermal_sensor_conf *data = th_zone->sensor_conf;
>
>   	tab_ptr = (struct freq_clip_table *)data->cooling_data.freq_data;
> @@ -315,6 +320,7 @@ static int exynos_unbind(struct thermal_zone_device *thermal,
>   			struct thermal_cooling_device *cdev)
>   {
>   	int ret = 0, i, tab_size;
> +	struct exynos_thermal_zone *th_zone = thermal->devdata;
>   	struct thermal_sensor_conf *data = th_zone->sensor_conf;
>
>   	if (th_zone->bind == false)
> @@ -357,13 +363,14 @@ static int exynos_unbind(struct thermal_zone_device *thermal,
>   static int exynos_get_temp(struct thermal_zone_device *thermal,
>   			unsigned long *temp)
>   {
> +	struct exynos_thermal_zone *th_zone = thermal->devdata;
>   	void *data;
>
>   	if (!th_zone->sensor_conf) {
>   		pr_info("Temperature sensor not initialised\n");
>   		return -EINVAL;
>   	}
> -	data = th_zone->sensor_conf->private_data;
> +	data = th_zone->sensor_conf->driver_data;
>   	*temp = th_zone->sensor_conf->read_temperature(data);
>   	/* convert the temperature into millicelsius */
>   	*temp = *temp * MCELSIUS;
> @@ -376,12 +383,13 @@ static int exynos_set_emul_temp(struct thermal_zone_device *thermal,
>   {
>   	void *data;
>   	int ret = -EINVAL;
> +	struct exynos_thermal_zone *th_zone = thermal->devdata;
>
>   	if (!th_zone->sensor_conf) {
>   		pr_info("Temperature sensor not initialised\n");
>   		return -EINVAL;
>   	}
> -	data = th_zone->sensor_conf->private_data;
> +	data = th_zone->sensor_conf->driver_data;
>   	if (th_zone->sensor_conf->write_emul_temp)
>   		ret = th_zone->sensor_conf->write_emul_temp(data, temp);
>   	return ret;
> @@ -391,7 +399,7 @@ static int exynos_set_emul_temp(struct thermal_zone_device *thermal,
>   static int exynos_get_trend(struct thermal_zone_device *thermal,
>   			int trip, enum thermal_trend *trend)
>   {
> -	int ret;
> +	int ret = 0;
>   	unsigned long trip_temp;
>
>   	ret = exynos_get_trip_temp(thermal, trip, &trip_temp);
> @@ -403,7 +411,7 @@ static int exynos_get_trend(struct thermal_zone_device *thermal,
>   	else
>   		*trend = THERMAL_TREND_DROP_FULL;
>
> -	return 0;
> +	return ret;
>   }
>   /* Operation callback functions for thermal zone */
>   static struct thermal_zone_device_ops const exynos_dev_ops = {
> @@ -423,11 +431,12 @@ static struct thermal_zone_device_ops const exynos_dev_ops = {
>    * This function may be called from interrupt based temperature sensor
>    * when threshold is changed.
>    */
> -static void exynos_report_trigger(void)
> +static void exynos_report_trigger(struct thermal_sensor_conf *conf)
>   {
>   	unsigned int i;
>   	char data[10];
>   	char *envp[] = { data, NULL };
> +	struct exynos_thermal_zone *th_zone = conf->pzone_data;
>
>   	if (!th_zone || !th_zone->therm_dev)
>   		return;
> @@ -468,6 +477,7 @@ static int exynos_register_thermal(struct thermal_sensor_conf *sensor_conf)
>   {
>   	int ret;
>   	struct cpumask mask_val;
> +	struct exynos_thermal_zone *th_zone;
>
>   	if (!sensor_conf || !sensor_conf->read_temperature) {
>   		pr_err("Temperature sensor not initialised\n");
> @@ -489,7 +499,7 @@ static int exynos_register_thermal(struct thermal_sensor_conf *sensor_conf)
>   	th_zone->cool_dev_size++;
>
>   	th_zone->therm_dev = thermal_zone_device_register(sensor_conf->name,
> -			EXYNOS_ZONE_COUNT, 0, NULL, &exynos_dev_ops, NULL, 0,
> +			EXYNOS_ZONE_COUNT, 0, th_zone, &exynos_dev_ops, NULL, 0,
>   			sensor_conf->trip_data.trigger_falling ?
>   			0 : IDLE_INTERVAL);
>
> @@ -499,20 +509,22 @@ static int exynos_register_thermal(struct thermal_sensor_conf *sensor_conf)
>   		goto err_unregister;
>   	}
>   	th_zone->mode = THERMAL_DEVICE_ENABLED;
> +	sensor_conf->pzone_data = th_zone;
>
>   	pr_info("Exynos: Kernel Thermal management registered\n");
>
>   	return 0;
>
>   err_unregister:
> -	exynos_unregister_thermal();
> +	exynos_unregister_thermal(sensor_conf);
>   	return ret;
>   }
>
>   /* Un-Register with the in-kernel thermal management */
> -static void exynos_unregister_thermal(void)
> +static void exynos_unregister_thermal(struct thermal_sensor_conf *sensor_conf)
>   {
>   	int i;
> +	struct exynos_thermal_zone *th_zone = sensor_conf->pzone_data;
>
>   	if (!th_zone)
>   		return;
> @@ -774,12 +786,18 @@ static int exynos_tmu_set_emulation(void *drv_data,	unsigned long temp)
>   	{ return -EINVAL; }
>   #endif/*CONFIG_THERMAL_EMULATION*/
>
> +static struct thermal_sensor_conf exynos_sensor_conf = {
> +	.name			= "exynos-therm",
> +	.read_temperature	= (int (*)(void *))exynos_tmu_read,
> +	.write_emul_temp	= exynos_tmu_set_emulation,
> +};
> +

Assuming you have only one exynos_sensor_conf and this is the parameter 
for each call to exynos_register_thermal, if you plan to add support to 
different pzone_data, then the above needs to be allocated. Or there is 
no point in having this.

>   static void exynos_tmu_work(struct work_struct *work)
>   {
>   	struct exynos_tmu_data *data = container_of(work,
>   			struct exynos_tmu_data, irq_work);
>
> -	exynos_report_trigger();
> +	exynos_report_trigger(&exynos_sensor_conf);
>   	mutex_lock(&data->lock);
>   	clk_enable(data->clk);
>   	if (data->soc == SOC_ARCH_EXYNOS)
> @@ -804,11 +822,6 @@ static irqreturn_t exynos_tmu_irq(int irq, void *id)
>
>   	return IRQ_HANDLED;
>   }
> -static struct thermal_sensor_conf exynos_sensor_conf = {
> -	.name			= "exynos-therm",
> -	.read_temperature	= (int (*)(void *))exynos_tmu_read,
> -	.write_emul_temp	= exynos_tmu_set_emulation,
> -};
>
>   #if defined(CONFIG_CPU_EXYNOS4210)
>   static struct exynos_tmu_platform_data const exynos4210_default_tmu_data = {
> @@ -987,7 +1000,7 @@ static int exynos_tmu_probe(struct platform_device *pdev)
>   	exynos_tmu_control(pdev, true);
>
>   	/* Register the sensor with thermal management interface */
> -	(&exynos_sensor_conf)->private_data = data;
> +	(&exynos_sensor_conf)->driver_data = data;
>   	exynos_sensor_conf.trip_data.trip_count = pdata->trigger_level0_en +
>   			pdata->trigger_level1_en + pdata->trigger_level2_en +
>   			pdata->trigger_level3_en;
> @@ -1026,7 +1039,7 @@ static int exynos_tmu_remove(struct platform_device *pdev)
>
>   	exynos_tmu_control(pdev, false);
>
> -	exynos_unregister_thermal();
> +	exynos_unregister_thermal(&exynos_sensor_conf);
>
>   	clk_put(data->clk);
>
>

