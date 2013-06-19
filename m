Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965050Ab3FSSqV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 14:46:21 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:59128 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965035Ab3FSSqO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 14:46:14 -0400
Message-ID: <51C1FC64.8060806@ti.com>
Date: Wed, 19 Jun 2013 14:45:56 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Amit Daniel Kachhap <amit.daniel@samsung.com>
CC: <linux-pm@vger.kernel.org>, Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>,
        <linux-samsung-soc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <amit.kachhap@gmail.com>, Kukjin Kim <kgene.kim@samsung.com>,
        <jonghwa3.lee@samsung.com>
Subject: Re: [PATCH V6 04/30] thermal: exynos: Bifurcate exynos thermal common
 and tmu controller code
References: <1371451599-31035-1-git-send-email-amit.daniel@samsung.com> <1371451599-31035-5-git-send-email-amit.daniel@samsung.com>
In-Reply-To: <1371451599-31035-5-git-send-email-amit.daniel@samsung.com>
X-Enigmail-Version: 1.5.1
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature";
	boundary="----enig2ICEURVCJDFSFUHURAMBM"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------enig2ICEURVCJDFSFUHURAMBM
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Amit,

On 17-06-2013 02:46, Amit Daniel Kachhap wrote:
> This code bifurcates exynos thermal implementation into common and sens=
or
> specific parts. The common thermal code interacts with core thermal lay=
er and
> core cpufreq cooling parts and is independent of SOC specific driver. T=
his
> change is needed to cleanly add support for new TMU sensors.
>=20
> Acked-by: Kukjin Kim <kgene.kim@samsung.com>
> Acked-by: Jonghwa Lee <jonghwa3.lee@samsung.com>
> Signed-off-by: Amit Daniel Kachhap <amit.daniel@samsung.com>
> ---
>  drivers/thermal/samsung/Kconfig                 |   19 +-
>  drivers/thermal/samsung/Makefile                |    4 +-
>  drivers/thermal/samsung/exynos_thermal.c        |  419 +--------------=
--------
>  drivers/thermal/samsung/exynos_thermal_common.c |  384 +++++++++++++++=
++++++
>  drivers/thermal/samsung/exynos_thermal_common.h |   83 +++++
>  5 files changed, 490 insertions(+), 419 deletions(-)
>  create mode 100644 drivers/thermal/samsung/exynos_thermal_common.c
>  create mode 100644 drivers/thermal/samsung/exynos_thermal_common.h
>=20
> diff --git a/drivers/thermal/samsung/Kconfig b/drivers/thermal/samsung/=
Kconfig
> index 2cf31ad..f8100b1 100644
> --- a/drivers/thermal/samsung/Kconfig
> +++ b/drivers/thermal/samsung/Kconfig
> @@ -1,8 +1,17 @@
>  config EXYNOS_THERMAL
> -	tristate "Temperature sensor on Samsung EXYNOS"
> +	tristate "Exynos thermal management unit driver"
>  	depends on ARCH_HAS_BANDGAP
>  	help
> -	  If you say yes here you get support for TMU (Thermal Management
> -	  Unit) on SAMSUNG EXYNOS series of SoC. This helps in registering
> -	  the exynos thermal driver with the core thermal layer and cpu
> -	  cooling API's.
> +	  If you say yes here you get support for the TMU (Thermal Management=

> +	  Unit) driver for SAMSUNG EXYNOS series of soc. This driver initiali=
ses
> +	  the TMU, reports temperature and handles cooling action if defined.=

> +	  This driver uses the exynos core thermal API's.
> +
> +config EXYNOS_THERMAL_CORE
> +	bool "Core thermal framework support for EXYNOS SOC's"
> +	depends on EXYNOS_THERMAL
> +	help
> +	  If you say yes here you get support for EXYNOS TMU
> +	  (Thermal Management Unit) common registration/unregistration
> +	  functions to the core thermal layer and also to use the generic
> +	  cpu cooling API's.
Should this one depend on CPU_THERMAL? Is it mandatory?

> diff --git a/drivers/thermal/samsung/Makefile b/drivers/thermal/samsung=
/Makefile
> index 1fe6d93..6227d4f 100644
> --- a/drivers/thermal/samsung/Makefile
> +++ b/drivers/thermal/samsung/Makefile
> @@ -1,4 +1,6 @@
>  #
>  # Samsung thermal specific Makefile
>  #
> -obj-$(CONFIG_EXYNOS_THERMAL)	+=3D exynos_thermal.o
> +obj-$(CONFIG_EXYNOS_THERMAL)			+=3D exynos_soc_thermal.o
> +exynos_soc_thermal-y				:=3D exynos_thermal.o
> +exynos_soc_thermal-$(CONFIG_EXYNOS_THERMAL_CORE) +=3D exynos_thermal_c=
ommon.o
> diff --git a/drivers/thermal/samsung/exynos_thermal.c b/drivers/thermal=
/samsung/exynos_thermal.c
> index 03e4bbc..5293849 100644
> --- a/drivers/thermal/samsung/exynos_thermal.c
> +++ b/drivers/thermal/samsung/exynos_thermal.c
> @@ -21,23 +21,15 @@
>   *
>   */
> =20
> -#include <linux/module.h>
> -#include <linux/err.h>
> -#include <linux/kernel.h>
> -#include <linux/slab.h>
> -#include <linux/platform_device.h>
> -#include <linux/interrupt.h>
>  #include <linux/clk.h>
> -#include <linux/workqueue.h>
> -#include <linux/sysfs.h>
> -#include <linux/kobject.h>
>  #include <linux/io.h>
> -#include <linux/mutex.h>
> -#include <linux/platform_data/exynos_thermal.h>
> -#include <linux/thermal.h>
> -#include <linux/cpufreq.h>
> -#include <linux/cpu_cooling.h>
> +#include <linux/interrupt.h>
> +#include <linux/module.h>
>  #include <linux/of.h>
> +#include <linux/platform_device.h>
> +#include <linux/platform_data/exynos_thermal.h>
> +
> +#include "exynos_thermal_common.h"
> =20
>  /* Exynos generic registers */
>  #define EXYNOS_TMU_REG_TRIMINFO		0x0
> @@ -88,16 +80,6 @@
>  #define EFUSE_MIN_VALUE 40
>  #define EFUSE_MAX_VALUE 100
> =20
> -/* In-kernel thermal framework related macros & definations */
> -#define SENSOR_NAME_LEN	16
> -#define MAX_TRIP_COUNT	8
> -#define MAX_COOLING_DEVICE 4
> -#define MAX_THRESHOLD_LEVS 4
> -
> -#define ACTIVE_INTERVAL 500
> -#define IDLE_INTERVAL 10000
> -#define MCELSIUS	1000
> -
>  #ifdef CONFIG_THERMAL_EMULATION
>  #define EXYNOS_EMUL_TIME	0x57F0
>  #define EXYNOS_EMUL_TIME_SHIFT	16
> @@ -106,17 +88,6 @@
>  #define EXYNOS_EMUL_ENABLE	0x1
>  #endif /* CONFIG_THERMAL_EMULATION */
> =20
> -/* CPU Zone information */
> -#define PANIC_ZONE      4
> -#define WARN_ZONE       3
> -#define MONITOR_ZONE    2
> -#define SAFE_ZONE       1
> -
> -#define GET_ZONE(trip) (trip + 2)
> -#define GET_TRIP(zone) (zone - 2)
> -
> -#define EXYNOS_ZONE_COUNT	3
> -
>  struct exynos_tmu_data {
>  	struct exynos_tmu_platform_data *pdata;
>  	struct resource *mem;
> @@ -129,384 +100,6 @@ struct exynos_tmu_data {
>  	u8 temp_error1, temp_error2;
>  };
> =20
> -struct	thermal_trip_point_conf {
> -	int trip_val[MAX_TRIP_COUNT];
> -	int trip_count;
> -	u8 trigger_falling;
> -};
> -
> -struct	thermal_cooling_conf {
> -	struct freq_clip_table freq_data[MAX_TRIP_COUNT];
> -	int freq_clip_count;
> -};
> -
> -struct thermal_sensor_conf {
> -	char name[SENSOR_NAME_LEN];
> -	int (*read_temperature)(void *data);
> -	int (*write_emul_temp)(void *drv_data, unsigned long temp);
> -	struct thermal_trip_point_conf trip_data;
> -	struct thermal_cooling_conf cooling_data;
> -	void *private_data;
> -};
> -
> -struct exynos_thermal_zone {
> -	enum thermal_device_mode mode;
> -	struct thermal_zone_device *therm_dev;
> -	struct thermal_cooling_device *cool_dev[MAX_COOLING_DEVICE];
> -	unsigned int cool_dev_size;
> -	struct platform_device *exynos4_dev;
> -	struct thermal_sensor_conf *sensor_conf;
> -	bool bind;
> -};
> -
> -static struct exynos_thermal_zone *th_zone;
> -static void exynos_unregister_thermal(void);
> -static int exynos_register_thermal(struct thermal_sensor_conf *sensor_=
conf);
> -
> -/* Get mode callback functions for thermal zone */
> -static int exynos_get_mode(struct thermal_zone_device *thermal,
> -			enum thermal_device_mode *mode)
> -{
> -	if (th_zone)
> -		*mode =3D th_zone->mode;
> -	return 0;
> -}
> -
> -/* Set mode callback functions for thermal zone */
> -static int exynos_set_mode(struct thermal_zone_device *thermal,
> -			enum thermal_device_mode mode)
> -{
> -	if (!th_zone->therm_dev) {
> -		pr_notice("thermal zone not registered\n");
> -		return 0;
> -	}
> -
> -	mutex_lock(&th_zone->therm_dev->lock);
> -
> -	if (mode =3D=3D THERMAL_DEVICE_ENABLED &&
> -		!th_zone->sensor_conf->trip_data.trigger_falling)
> -		th_zone->therm_dev->polling_delay =3D IDLE_INTERVAL;
> -	else
> -		th_zone->therm_dev->polling_delay =3D 0;
> -
> -	mutex_unlock(&th_zone->therm_dev->lock);
> -
> -	th_zone->mode =3D mode;
> -	thermal_zone_device_update(th_zone->therm_dev);
> -	pr_info("thermal polling set for duration=3D%d msec\n",
> -				th_zone->therm_dev->polling_delay);
> -	return 0;
> -}
> -
> -
> -/* Get trip type callback functions for thermal zone */
> -static int exynos_get_trip_type(struct thermal_zone_device *thermal, i=
nt trip,
> -				 enum thermal_trip_type *type)
> -{
> -	switch (GET_ZONE(trip)) {
> -	case MONITOR_ZONE:
> -	case WARN_ZONE:
> -		*type =3D THERMAL_TRIP_ACTIVE;
> -		break;
> -	case PANIC_ZONE:
> -		*type =3D THERMAL_TRIP_CRITICAL;
> -		break;
> -	default:
> -		return -EINVAL;
> -	}
> -	return 0;
> -}
> -
> -/* Get trip temperature callback functions for thermal zone */
> -static int exynos_get_trip_temp(struct thermal_zone_device *thermal, i=
nt trip,
> -				unsigned long *temp)
> -{
> -	if (trip < GET_TRIP(MONITOR_ZONE) || trip > GET_TRIP(PANIC_ZONE))
> -		return -EINVAL;
> -
> -	*temp =3D th_zone->sensor_conf->trip_data.trip_val[trip];
> -	/* convert the temperature into millicelsius */
> -	*temp =3D *temp * MCELSIUS;
> -
> -	return 0;
> -}
> -
> -/* Get critical temperature callback functions for thermal zone */
> -static int exynos_get_crit_temp(struct thermal_zone_device *thermal,
> -				unsigned long *temp)
> -{
> -	int ret;
> -	/* Panic zone */
> -	ret =3D exynos_get_trip_temp(thermal, GET_TRIP(PANIC_ZONE), temp);
> -	return ret;
> -}
> -
> -/* Bind callback functions for thermal zone */
> -static int exynos_bind(struct thermal_zone_device *thermal,
> -			struct thermal_cooling_device *cdev)
> -{
> -	int ret =3D 0, i, tab_size, level;
> -	struct freq_clip_table *tab_ptr, *clip_data;
> -	struct thermal_sensor_conf *data =3D th_zone->sensor_conf;
> -
> -	tab_ptr =3D (struct freq_clip_table *)data->cooling_data.freq_data;
> -	tab_size =3D data->cooling_data.freq_clip_count;
> -
> -	if (tab_ptr =3D=3D NULL || tab_size =3D=3D 0)
> -		return -EINVAL;
> -
> -	/* find the cooling device registered*/
> -	for (i =3D 0; i < th_zone->cool_dev_size; i++)
> -		if (cdev =3D=3D th_zone->cool_dev[i])
> -			break;
> -
> -	/* No matching cooling device */
> -	if (i =3D=3D th_zone->cool_dev_size)
> -		return 0;
> -
> -	/* Bind the thermal zone to the cpufreq cooling device */
> -	for (i =3D 0; i < tab_size; i++) {
> -		clip_data =3D (struct freq_clip_table *)&(tab_ptr[i]);
> -		level =3D cpufreq_cooling_get_level(0, clip_data->freq_clip_max);
> -		if (level =3D=3D THERMAL_CSTATE_INVALID)
> -			return 0;
> -		switch (GET_ZONE(i)) {
> -		case MONITOR_ZONE:
> -		case WARN_ZONE:
> -			if (thermal_zone_bind_cooling_device(thermal, i, cdev,
> -								level, 0)) {
> -				pr_err("error binding cdev inst %d\n", i);
> -				ret =3D -EINVAL;
> -			}
> -			th_zone->bind =3D true;
> -			break;
> -		default:
> -			ret =3D -EINVAL;
> -		}
> -	}
> -
> -	return ret;
> -}
> -
> -/* Unbind callback functions for thermal zone */
> -static int exynos_unbind(struct thermal_zone_device *thermal,
> -			struct thermal_cooling_device *cdev)
> -{
> -	int ret =3D 0, i, tab_size;
> -	struct thermal_sensor_conf *data =3D th_zone->sensor_conf;
> -
> -	if (th_zone->bind =3D=3D false)
> -		return 0;
> -
> -	tab_size =3D data->cooling_data.freq_clip_count;
> -
> -	if (tab_size =3D=3D 0)
> -		return -EINVAL;
> -
> -	/* find the cooling device registered*/
> -	for (i =3D 0; i < th_zone->cool_dev_size; i++)
> -		if (cdev =3D=3D th_zone->cool_dev[i])
> -			break;
> -
> -	/* No matching cooling device */
> -	if (i =3D=3D th_zone->cool_dev_size)
> -		return 0;
> -
> -	/* Bind the thermal zone to the cpufreq cooling device */
> -	for (i =3D 0; i < tab_size; i++) {
> -		switch (GET_ZONE(i)) {
> -		case MONITOR_ZONE:
> -		case WARN_ZONE:
> -			if (thermal_zone_unbind_cooling_device(thermal, i,
> -								cdev)) {
> -				pr_err("error unbinding cdev inst=3D%d\n", i);
> -				ret =3D -EINVAL;
> -			}
> -			th_zone->bind =3D false;
> -			break;
> -		default:
> -			ret =3D -EINVAL;
> -		}
> -	}
> -	return ret;
> -}
> -
> -/* Get temperature callback functions for thermal zone */
> -static int exynos_get_temp(struct thermal_zone_device *thermal,
> -			unsigned long *temp)
> -{
> -	void *data;
> -
> -	if (!th_zone->sensor_conf) {
> -		pr_info("Temperature sensor not initialised\n");
> -		return -EINVAL;
> -	}
> -	data =3D th_zone->sensor_conf->private_data;
> -	*temp =3D th_zone->sensor_conf->read_temperature(data);
> -	/* convert the temperature into millicelsius */
> -	*temp =3D *temp * MCELSIUS;
> -	return 0;
> -}
> -
> -/* Get temperature callback functions for thermal zone */
> -static int exynos_set_emul_temp(struct thermal_zone_device *thermal,
> -						unsigned long temp)
> -{
> -	void *data;
> -	int ret =3D -EINVAL;
> -
> -	if (!th_zone->sensor_conf) {
> -		pr_info("Temperature sensor not initialised\n");
> -		return -EINVAL;
> -	}
> -	data =3D th_zone->sensor_conf->private_data;
> -	if (th_zone->sensor_conf->write_emul_temp)
> -		ret =3D th_zone->sensor_conf->write_emul_temp(data, temp);
> -	return ret;
> -}
> -
> -/* Get the temperature trend */
> -static int exynos_get_trend(struct thermal_zone_device *thermal,
> -			int trip, enum thermal_trend *trend)
> -{
> -	int ret;
> -	unsigned long trip_temp;
> -
> -	ret =3D exynos_get_trip_temp(thermal, trip, &trip_temp);
> -	if (ret < 0)
> -		return ret;
> -
> -	if (thermal->temperature >=3D trip_temp)
> -		*trend =3D THERMAL_TREND_RAISE_FULL;
> -	else
> -		*trend =3D THERMAL_TREND_DROP_FULL;
> -
> -	return 0;
> -}
> -/* Operation callback functions for thermal zone */
> -static struct thermal_zone_device_ops const exynos_dev_ops =3D {
> -	.bind =3D exynos_bind,
> -	.unbind =3D exynos_unbind,
> -	.get_temp =3D exynos_get_temp,
> -	.set_emul_temp =3D exynos_set_emul_temp,
> -	.get_trend =3D exynos_get_trend,
> -	.get_mode =3D exynos_get_mode,
> -	.set_mode =3D exynos_set_mode,
> -	.get_trip_type =3D exynos_get_trip_type,
> -	.get_trip_temp =3D exynos_get_trip_temp,
> -	.get_crit_temp =3D exynos_get_crit_temp,
> -};
> -
> -/*
> - * This function may be called from interrupt based temperature sensor=

> - * when threshold is changed.
> - */
> -static void exynos_report_trigger(void)
> -{
> -	unsigned int i;
> -	char data[10];
> -	char *envp[] =3D { data, NULL };
> -
> -	if (!th_zone || !th_zone->therm_dev)
> -		return;
> -	if (th_zone->bind =3D=3D false) {
> -		for (i =3D 0; i < th_zone->cool_dev_size; i++) {
> -			if (!th_zone->cool_dev[i])
> -				continue;
> -			exynos_bind(th_zone->therm_dev,
> -					th_zone->cool_dev[i]);
> -		}
> -	}
> -
> -	thermal_zone_device_update(th_zone->therm_dev);
> -
> -	mutex_lock(&th_zone->therm_dev->lock);
> -	/* Find the level for which trip happened */
> -	for (i =3D 0; i < th_zone->sensor_conf->trip_data.trip_count; i++) {
> -		if (th_zone->therm_dev->last_temperature <
> -			th_zone->sensor_conf->trip_data.trip_val[i] * MCELSIUS)
> -			break;
> -	}
> -
> -	if (th_zone->mode =3D=3D THERMAL_DEVICE_ENABLED &&
> -		!th_zone->sensor_conf->trip_data.trigger_falling) {
> -		if (i > 0)
> -			th_zone->therm_dev->polling_delay =3D ACTIVE_INTERVAL;
> -		else
> -			th_zone->therm_dev->polling_delay =3D IDLE_INTERVAL;
> -	}
> -
> -	snprintf(data, sizeof(data), "%u", i);
> -	kobject_uevent_env(&th_zone->therm_dev->device.kobj, KOBJ_CHANGE, env=
p);
> -	mutex_unlock(&th_zone->therm_dev->lock);
> -}
> -
> -/* Register with the in-kernel thermal management */
> -static int exynos_register_thermal(struct thermal_sensor_conf *sensor_=
conf)
> -{
> -	int ret;
> -	struct cpumask mask_val;
> -
> -	if (!sensor_conf || !sensor_conf->read_temperature) {
> -		pr_err("Temperature sensor not initialised\n");
> -		return -EINVAL;
> -	}
> -
> -	th_zone =3D kzalloc(sizeof(struct exynos_thermal_zone), GFP_KERNEL);
> -	if (!th_zone)
> -		return -ENOMEM;
> -
> -	th_zone->sensor_conf =3D sensor_conf;
> -	cpumask_set_cpu(0, &mask_val);
> -	th_zone->cool_dev[0] =3D cpufreq_cooling_register(&mask_val);
> -	if (IS_ERR(th_zone->cool_dev[0])) {
> -		pr_err("Failed to register cpufreq cooling device\n");
> -		ret =3D -EINVAL;
> -		goto err_unregister;
> -	}
> -	th_zone->cool_dev_size++;
> -
> -	th_zone->therm_dev =3D thermal_zone_device_register(sensor_conf->name=
,
> -			EXYNOS_ZONE_COUNT, 0, NULL, &exynos_dev_ops, NULL, 0,
> -			sensor_conf->trip_data.trigger_falling ?
> -			0 : IDLE_INTERVAL);
> -
> -	if (IS_ERR(th_zone->therm_dev)) {
> -		pr_err("Failed to register thermal zone device\n");
> -		ret =3D PTR_ERR(th_zone->therm_dev);
> -		goto err_unregister;
> -	}
> -	th_zone->mode =3D THERMAL_DEVICE_ENABLED;
> -
> -	pr_info("Exynos: Kernel Thermal management registered\n");
> -
> -	return 0;
> -
> -err_unregister:
> -	exynos_unregister_thermal();
> -	return ret;
> -}
> -
> -/* Un-Register with the in-kernel thermal management */
> -static void exynos_unregister_thermal(void)
> -{
> -	int i;
> -
> -	if (!th_zone)
> -		return;
> -
> -	if (th_zone->therm_dev)
> -		thermal_zone_device_unregister(th_zone->therm_dev);
> -
> -	for (i =3D 0; i < th_zone->cool_dev_size; i++) {
> -		if (th_zone->cool_dev[i])
> -			cpufreq_cooling_unregister(th_zone->cool_dev[i]);
> -	}
> -
> -	kfree(th_zone);
> -	pr_info("Exynos: Kernel Thermal management unregistered\n");
> -}
> -
>  /*
>   * TMU treats temperature as a mapped temperature code.
>   * The temperature is converted differently depending on the calibrati=
on type.
> diff --git a/drivers/thermal/samsung/exynos_thermal_common.c b/drivers/=
thermal/samsung/exynos_thermal_common.c
> new file mode 100644
> index 0000000..92e50bc
> --- /dev/null
> +++ b/drivers/thermal/samsung/exynos_thermal_common.c
> @@ -0,0 +1,384 @@
> +/*
> + * exynos_thermal_common.c - Samsung EXYNOS common thermal file
> + *
> + *  Copyright (C) 2013 Samsung Electronics
> + *  Amit Daniel Kachhap <amit.daniel@samsung.com>
> + *
> + * This program is free software; you can redistribute it and/or modif=
y
> + * it under the terms of the GNU General Public License as published b=
y
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-130=
7  USA
> + *
> + */
> +
> +#include <linux/cpu_cooling.h>
> +#include <linux/platform_data/exynos_thermal.h>
> +#include <linux/slab.h>
> +#include <linux/thermal.h>
> +
> +#include "exynos_thermal_common.h"
> +
> +struct exynos_thermal_zone {
> +	enum thermal_device_mode mode;
> +	struct thermal_zone_device *therm_dev;
> +	struct thermal_cooling_device *cool_dev[MAX_COOLING_DEVICE];
> +	unsigned int cool_dev_size;
> +	struct platform_device *exynos4_dev;
> +	struct thermal_sensor_conf *sensor_conf;
> +	bool bind;
> +};
> +
> +static struct exynos_thermal_zone *th_zone;
> +
> +/* Get mode callback functions for thermal zone */
> +static int exynos_get_mode(struct thermal_zone_device *thermal,
> +			enum thermal_device_mode *mode)
> +{
> +	if (th_zone)
> +		*mode =3D th_zone->mode;
> +	return 0;
> +}
> +
> +/* Set mode callback functions for thermal zone */
> +static int exynos_set_mode(struct thermal_zone_device *thermal,
> +			enum thermal_device_mode mode)
> +{
> +	if (!th_zone->therm_dev) {
> +		pr_notice("thermal zone not registered\n");
> +		return 0;
> +	}
> +
> +	mutex_lock(&th_zone->therm_dev->lock);
> +
> +	if (mode =3D=3D THERMAL_DEVICE_ENABLED &&
> +		!th_zone->sensor_conf->trip_data.trigger_falling)
> +		th_zone->therm_dev->polling_delay =3D IDLE_INTERVAL;
> +	else
> +		th_zone->therm_dev->polling_delay =3D 0;
> +
> +	mutex_unlock(&th_zone->therm_dev->lock);
> +
> +	th_zone->mode =3D mode;
> +	thermal_zone_device_update(th_zone->therm_dev);
> +	pr_info("thermal polling set for duration=3D%d msec\n",
> +				th_zone->therm_dev->polling_delay);
> +	return 0;
> +}
> +
> +
> +/* Get trip type callback functions for thermal zone */
> +static int exynos_get_trip_type(struct thermal_zone_device *thermal, i=
nt trip,
> +				 enum thermal_trip_type *type)
> +{
> +	switch (GET_ZONE(trip)) {
> +	case MONITOR_ZONE:
> +	case WARN_ZONE:
> +		*type =3D THERMAL_TRIP_ACTIVE;
> +		break;
> +	case PANIC_ZONE:
> +		*type =3D THERMAL_TRIP_CRITICAL;
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
> +	return 0;
> +}
> +
> +/* Get trip temperature callback functions for thermal zone */
> +static int exynos_get_trip_temp(struct thermal_zone_device *thermal, i=
nt trip,
> +				unsigned long *temp)
> +{
> +	if (trip < GET_TRIP(MONITOR_ZONE) || trip > GET_TRIP(PANIC_ZONE))
> +		return -EINVAL;
> +
> +	*temp =3D th_zone->sensor_conf->trip_data.trip_val[trip];
> +	/* convert the temperature into millicelsius */
> +	*temp =3D *temp * MCELSIUS;
> +
> +	return 0;
> +}
> +
> +/* Get critical temperature callback functions for thermal zone */
> +static int exynos_get_crit_temp(struct thermal_zone_device *thermal,
> +				unsigned long *temp)
> +{
> +	int ret;
> +	/* Panic zone */
> +	ret =3D exynos_get_trip_temp(thermal, GET_TRIP(PANIC_ZONE), temp);
> +	return ret;
> +}
> +
> +/* Bind callback functions for thermal zone */
> +static int exynos_bind(struct thermal_zone_device *thermal,
> +			struct thermal_cooling_device *cdev)
> +{
> +	int ret =3D 0, i, tab_size, level;
> +	struct freq_clip_table *tab_ptr, *clip_data;
> +	struct thermal_sensor_conf *data =3D th_zone->sensor_conf;
> +
> +	tab_ptr =3D (struct freq_clip_table *)data->cooling_data.freq_data;
> +	tab_size =3D data->cooling_data.freq_clip_count;
> +
> +	if (tab_ptr =3D=3D NULL || tab_size =3D=3D 0)
> +		return -EINVAL;
> +
> +	/* find the cooling device registered*/
> +	for (i =3D 0; i < th_zone->cool_dev_size; i++)
> +		if (cdev =3D=3D th_zone->cool_dev[i])
> +			break;
> +
> +	/* No matching cooling device */
> +	if (i =3D=3D th_zone->cool_dev_size)
> +		return 0;
> +
> +	/* Bind the thermal zone to the cpufreq cooling device */
> +	for (i =3D 0; i < tab_size; i++) {
> +		clip_data =3D (struct freq_clip_table *)&(tab_ptr[i]);
> +		level =3D cpufreq_cooling_get_level(0, clip_data->freq_clip_max);
> +		if (level =3D=3D THERMAL_CSTATE_INVALID)
> +			return 0;
> +		switch (GET_ZONE(i)) {
> +		case MONITOR_ZONE:
> +		case WARN_ZONE:
> +			if (thermal_zone_bind_cooling_device(thermal, i, cdev,
> +								level, 0)) {
> +				pr_err("error binding cdev inst %d\n", i);
> +				ret =3D -EINVAL;
> +			}
> +			th_zone->bind =3D true;
> +			break;
> +		default:
> +			ret =3D -EINVAL;
> +		}
> +	}
> +
> +	return ret;
> +}
> +
> +/* Unbind callback functions for thermal zone */
> +static int exynos_unbind(struct thermal_zone_device *thermal,
> +			struct thermal_cooling_device *cdev)
> +{
> +	int ret =3D 0, i, tab_size;
> +	struct thermal_sensor_conf *data =3D th_zone->sensor_conf;
> +
> +	if (th_zone->bind =3D=3D false)
> +		return 0;
> +
> +	tab_size =3D data->cooling_data.freq_clip_count;
> +
> +	if (tab_size =3D=3D 0)
> +		return -EINVAL;
> +
> +	/* find the cooling device registered*/
> +	for (i =3D 0; i < th_zone->cool_dev_size; i++)
> +		if (cdev =3D=3D th_zone->cool_dev[i])
> +			break;
> +
> +	/* No matching cooling device */
> +	if (i =3D=3D th_zone->cool_dev_size)
> +		return 0;
> +
> +	/* Bind the thermal zone to the cpufreq cooling device */
> +	for (i =3D 0; i < tab_size; i++) {
> +		switch (GET_ZONE(i)) {
> +		case MONITOR_ZONE:
> +		case WARN_ZONE:
> +			if (thermal_zone_unbind_cooling_device(thermal, i,
> +								cdev)) {
> +				pr_err("error unbinding cdev inst=3D%d\n", i);
> +				ret =3D -EINVAL;
> +			}
> +			th_zone->bind =3D false;
> +			break;
> +		default:
> +			ret =3D -EINVAL;
> +		}
> +	}
> +	return ret;
> +}
> +
> +/* Get temperature callback functions for thermal zone */
> +static int exynos_get_temp(struct thermal_zone_device *thermal,
> +			unsigned long *temp)
> +{
> +	void *data;
> +
> +	if (!th_zone->sensor_conf) {
> +		pr_info("Temperature sensor not initialised\n");
> +		return -EINVAL;
> +	}
> +	data =3D th_zone->sensor_conf->private_data;
> +	*temp =3D th_zone->sensor_conf->read_temperature(data);
> +	/* convert the temperature into millicelsius */
> +	*temp =3D *temp * MCELSIUS;
> +	return 0;
> +}
> +
> +/* Get temperature callback functions for thermal zone */
> +static int exynos_set_emul_temp(struct thermal_zone_device *thermal,
> +						unsigned long temp)
> +{
> +	void *data;
> +	int ret =3D -EINVAL;
> +
> +	if (!th_zone->sensor_conf) {
> +		pr_info("Temperature sensor not initialised\n");
> +		return -EINVAL;
> +	}
> +	data =3D th_zone->sensor_conf->private_data;
> +	if (th_zone->sensor_conf->write_emul_temp)
> +		ret =3D th_zone->sensor_conf->write_emul_temp(data, temp);
> +	return ret;
> +}
> +
> +/* Get the temperature trend */
> +static int exynos_get_trend(struct thermal_zone_device *thermal,
> +			int trip, enum thermal_trend *trend)
> +{
> +	int ret;
> +	unsigned long trip_temp;
> +
> +	ret =3D exynos_get_trip_temp(thermal, trip, &trip_temp);
> +	if (ret < 0)
> +		return ret;
> +
> +	if (thermal->temperature >=3D trip_temp)
> +		*trend =3D THERMAL_TREND_RAISE_FULL;
> +	else
> +		*trend =3D THERMAL_TREND_DROP_FULL;
> +
> +	return 0;
> +}
> +/* Operation callback functions for thermal zone */
> +static struct thermal_zone_device_ops const exynos_dev_ops =3D {
> +	.bind =3D exynos_bind,
> +	.unbind =3D exynos_unbind,
> +	.get_temp =3D exynos_get_temp,
> +	.set_emul_temp =3D exynos_set_emul_temp,
> +	.get_trend =3D exynos_get_trend,
> +	.get_mode =3D exynos_get_mode,
> +	.set_mode =3D exynos_set_mode,
> +	.get_trip_type =3D exynos_get_trip_type,
> +	.get_trip_temp =3D exynos_get_trip_temp,
> +	.get_crit_temp =3D exynos_get_crit_temp,
> +};
> +
> +/*
> + * This function may be called from interrupt based temperature sensor=

> + * when threshold is changed.
> + */
> +void exynos_report_trigger(void)
> +{
> +	unsigned int i;
> +	char data[10];
> +	char *envp[] =3D { data, NULL };
> +
> +	if (!th_zone || !th_zone->therm_dev)
> +		return;
> +	if (th_zone->bind =3D=3D false) {
> +		for (i =3D 0; i < th_zone->cool_dev_size; i++) {
> +			if (!th_zone->cool_dev[i])
> +				continue;
> +			exynos_bind(th_zone->therm_dev,
> +					th_zone->cool_dev[i]);
> +		}
> +	}
> +
> +	thermal_zone_device_update(th_zone->therm_dev);
> +
> +	mutex_lock(&th_zone->therm_dev->lock);
> +	/* Find the level for which trip happened */
> +	for (i =3D 0; i < th_zone->sensor_conf->trip_data.trip_count; i++) {
> +		if (th_zone->therm_dev->last_temperature <
> +			th_zone->sensor_conf->trip_data.trip_val[i] * MCELSIUS)
> +			break;
> +	}
> +
> +	if (th_zone->mode =3D=3D THERMAL_DEVICE_ENABLED &&
> +		!th_zone->sensor_conf->trip_data.trigger_falling) {
> +		if (i > 0)
> +			th_zone->therm_dev->polling_delay =3D ACTIVE_INTERVAL;
> +		else
> +			th_zone->therm_dev->polling_delay =3D IDLE_INTERVAL;
> +	}
> +
> +	snprintf(data, sizeof(data), "%u", i);
> +	kobject_uevent_env(&th_zone->therm_dev->device.kobj, KOBJ_CHANGE, env=
p);
> +	mutex_unlock(&th_zone->therm_dev->lock);
> +}
> +
> +/* Register with the in-kernel thermal management */
> +int exynos_register_thermal(struct thermal_sensor_conf *sensor_conf)
> +{
> +	int ret;
> +	struct cpumask mask_val;
> +
> +	if (!sensor_conf || !sensor_conf->read_temperature) {
> +		pr_err("Temperature sensor not initialised\n");
> +		return -EINVAL;
> +	}
> +
> +	th_zone =3D kzalloc(sizeof(struct exynos_thermal_zone), GFP_KERNEL);
> +	if (!th_zone)
> +		return -ENOMEM;
> +
> +	th_zone->sensor_conf =3D sensor_conf;
> +	cpumask_set_cpu(0, &mask_val);
> +	th_zone->cool_dev[0] =3D cpufreq_cooling_register(&mask_val);
> +	if (IS_ERR(th_zone->cool_dev[0])) {
> +		pr_err("Failed to register cpufreq cooling device\n");
> +		ret =3D -EINVAL;
> +		goto err_unregister;
> +	}
> +	th_zone->cool_dev_size++;
> +
> +	th_zone->therm_dev =3D thermal_zone_device_register(sensor_conf->name=
,
> +			EXYNOS_ZONE_COUNT, 0, NULL, &exynos_dev_ops, NULL, 0,
> +			sensor_conf->trip_data.trigger_falling ?
> +			0 : IDLE_INTERVAL);
> +
> +	if (IS_ERR(th_zone->therm_dev)) {
> +		pr_err("Failed to register thermal zone device\n");
> +		ret =3D PTR_ERR(th_zone->therm_dev);
> +		goto err_unregister;
> +	}
> +	th_zone->mode =3D THERMAL_DEVICE_ENABLED;
> +
> +	pr_info("Exynos: Kernel Thermal management registered\n");
> +
> +	return 0;
> +
> +err_unregister:
> +	exynos_unregister_thermal();
> +	return ret;
> +}
> +
> +/* Un-Register with the in-kernel thermal management */
> +void exynos_unregister_thermal(void)
> +{
> +	int i;
> +
> +	if (!th_zone)
> +		return;
> +
> +	if (th_zone->therm_dev)
> +		thermal_zone_device_unregister(th_zone->therm_dev);
> +
> +	for (i =3D 0; i < th_zone->cool_dev_size; i++) {
> +		if (th_zone->cool_dev[i])
> +			cpufreq_cooling_unregister(th_zone->cool_dev[i]);
> +	}
> +
> +	kfree(th_zone);
> +	pr_info("Exynos: Kernel Thermal management unregistered\n");
> +}
> diff --git a/drivers/thermal/samsung/exynos_thermal_common.h b/drivers/=
thermal/samsung/exynos_thermal_common.h
> new file mode 100644
> index 0000000..8df1848
> --- /dev/null
> +++ b/drivers/thermal/samsung/exynos_thermal_common.h
> @@ -0,0 +1,83 @@
> +/*
> + * exynos_thermal_common.h - Samsung EXYNOS common header file
> + *
> + *  Copyright (C) 2013 Samsung Electronics
> + *  Amit Daniel Kachhap <amit.daniel@samsung.com>
> + *
> + * This program is free software; you can redistribute it and/or modif=
y
> + * it under the terms of the GNU General Public License as published b=
y
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-130=
7  USA
> + *
> + */
> +
> +#ifndef _EXYNOS_THERMAL_COMMON_H
> +#define _EXYNOS_THERMAL_COMMON_H
> +
> +/* In-kernel thermal framework related macros & definations */
> +#define SENSOR_NAME_LEN	16
> +#define MAX_TRIP_COUNT	8
> +#define MAX_COOLING_DEVICE 4
> +#define MAX_THRESHOLD_LEVS 4
> +
> +#define ACTIVE_INTERVAL 500
> +#define IDLE_INTERVAL 10000
> +#define MCELSIUS	1000
> +
> +/* CPU Zone information */
> +#define PANIC_ZONE      4
> +#define WARN_ZONE       3
> +#define MONITOR_ZONE    2
> +#define SAFE_ZONE       1
> +
> +#define GET_ZONE(trip) (trip + 2)
> +#define GET_TRIP(zone) (zone - 2)
> +
> +#define EXYNOS_ZONE_COUNT	3
> +
> +struct	thermal_trip_point_conf {
> +	int trip_val[MAX_TRIP_COUNT];
> +	int trip_count;
> +	unsigned char trigger_falling;
> +};
> +
> +struct	thermal_cooling_conf {
> +	struct freq_clip_table freq_data[MAX_TRIP_COUNT];
> +	int freq_clip_count;
> +};
> +
> +struct thermal_sensor_conf {
> +	char name[SENSOR_NAME_LEN];
> +	int (*read_temperature)(void *data);
> +	int (*write_emul_temp)(void *drv_data, unsigned long temp);
> +	struct thermal_trip_point_conf trip_data;
> +	struct thermal_cooling_conf cooling_data;
> +	void *private_data;
> +};
> +
> +/*Functions used exynos based thermal sensor driver*/
> +#ifdef CONFIG_EXYNOS_THERMAL_CORE
> +void exynos_unregister_thermal(void);
> +int exynos_register_thermal(struct thermal_sensor_conf *sensor_conf);
> +void exynos_report_trigger(void);
> +#else
> +static inline void
> +exynos_unregister_thermal(void) { return; }
> +
> +static inline int
> +exynos_register_thermal(struct thermal_sensor_conf *sensor_conf) { ret=
urn 0; }
> +
> +static inline void
> +exynos_report_trigger(void) { return; }
> +
> +#endif /* CONFIG_EXYNOS_THERMAL_CORE */
> +#endif /* _EXYNOS_THERMAL_COMMON_H */
>=20


--=20
You have got to be excited about what you are doing. (L. Lamport)

Eduardo Valentin


------enig2ICEURVCJDFSFUHURAMBM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iF4EAREIAAYFAlHB/GQACgkQCXcVR3XQvP3s3AD/Rv4Ccsui/VCkylPxxmVkUyYA
++O9+L68tX5KFRIbylwBAJp/qD0jmJMQgsg++LpqpEciSUaZ8mQ4g0RrC9Py1Gos
=Uo6i
-----END PGP SIGNATURE-----

------enig2ICEURVCJDFSFUHURAMBM--
