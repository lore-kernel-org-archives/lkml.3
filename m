Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964958Ab3FSWkT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 18:40:19 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:43761 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964822Ab3FSWkQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 18:40:16 -0400
Message-ID: <51C23344.5050007@ti.com>
Date: Wed, 19 Jun 2013 18:40:04 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Amit Daniel Kachhap <amit.daniel@samsung.com>
CC: <linux-pm@vger.kernel.org>, Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>,
        <linux-samsung-soc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <amit.kachhap@gmail.com>, Kukjin Kim <kgene.kim@samsung.com>,
        <jonghwa3.lee@samsung.com>
Subject: Re: [PATCH V6 13/30] thermal: exynos: Add support for instance based
 register/unregister
References: <1371451599-31035-1-git-send-email-amit.daniel@samsung.com> <1371451599-31035-14-git-send-email-amit.daniel@samsung.com>
In-Reply-To: <1371451599-31035-14-git-send-email-amit.daniel@samsung.com>
X-Enigmail-Version: 1.5.1
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature";
	boundary="----enig2NPKQWPWDEELCDSULBGEO"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------enig2NPKQWPWDEELCDSULBGEO
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi,

On 17-06-2013 02:46, Amit Daniel Kachhap wrote:
> This code modifies the thermal driver to have multiple thermal zone
> support by replacing the global thermal zone variable with device data
> member of thermal_zone_device.
>=20
> Acked-by: Kukjin Kim <kgene.kim@samsung.com>
> Acked-by: Jonghwa Lee <jonghwa3.lee@samsung.com>
> Signed-off-by: Amit Daniel Kachhap <amit.daniel@samsung.com>

Acked-by: Eduardo Valentin <eduardo.valentin@ti.com>

> ---
>  drivers/thermal/samsung/exynos_thermal_common.c |   36 ++++++++++++++-=
-------
>  drivers/thermal/samsung/exynos_thermal_common.h |    9 +++--
>  drivers/thermal/samsung/exynos_tmu.c            |   15 +++++----
>  3 files changed, 36 insertions(+), 24 deletions(-)
>=20
> diff --git a/drivers/thermal/samsung/exynos_thermal_common.c b/drivers/=
thermal/samsung/exynos_thermal_common.c
> index dd49c9f..2af1e3b 100644
> --- a/drivers/thermal/samsung/exynos_thermal_common.c
> +++ b/drivers/thermal/samsung/exynos_thermal_common.c
> @@ -36,12 +36,11 @@ struct exynos_thermal_zone {
>  	bool bind;
>  };
> =20
> -static struct exynos_thermal_zone *th_zone;
> -
>  /* Get mode callback functions for thermal zone */
>  static int exynos_get_mode(struct thermal_zone_device *thermal,
>  			enum thermal_device_mode *mode)
>  {
> +	struct exynos_thermal_zone *th_zone =3D thermal->devdata;
>  	if (th_zone)
>  		*mode =3D th_zone->mode;
>  	return 0;
> @@ -51,25 +50,26 @@ static int exynos_get_mode(struct thermal_zone_devi=
ce *thermal,
>  static int exynos_set_mode(struct thermal_zone_device *thermal,
>  			enum thermal_device_mode mode)
>  {
> -	if (!th_zone->therm_dev) {
> +	struct exynos_thermal_zone *th_zone =3D thermal->devdata;
> +	if (!th_zone) {
>  		pr_notice("thermal zone not registered\n");
>  		return 0;
>  	}
> =20
> -	mutex_lock(&th_zone->therm_dev->lock);
> +	mutex_lock(&thermal->lock);
> =20
>  	if (mode =3D=3D THERMAL_DEVICE_ENABLED &&
>  		!th_zone->sensor_conf->trip_data.trigger_falling)
> -		th_zone->therm_dev->polling_delay =3D IDLE_INTERVAL;
> +		thermal->polling_delay =3D IDLE_INTERVAL;
>  	else
> -		th_zone->therm_dev->polling_delay =3D 0;
> +		thermal->polling_delay =3D 0;
> =20
> -	mutex_unlock(&th_zone->therm_dev->lock);
> +	mutex_unlock(&thermal->lock);
> =20
>  	th_zone->mode =3D mode;
> -	thermal_zone_device_update(th_zone->therm_dev);
> +	thermal_zone_device_update(thermal);
>  	pr_info("thermal polling set for duration=3D%d msec\n",
> -				th_zone->therm_dev->polling_delay);
> +				thermal->polling_delay);
>  	return 0;
>  }
> =20
> @@ -96,6 +96,8 @@ static int exynos_get_trip_type(struct thermal_zone_d=
evice *thermal, int trip,
>  static int exynos_get_trip_temp(struct thermal_zone_device *thermal, i=
nt trip,
>  				unsigned long *temp)
>  {
> +	struct exynos_thermal_zone *th_zone =3D thermal->devdata;
> +
>  	if (trip < GET_TRIP(MONITOR_ZONE) || trip > GET_TRIP(PANIC_ZONE))
>  		return -EINVAL;
> =20
> @@ -122,6 +124,7 @@ static int exynos_bind(struct thermal_zone_device *=
thermal,
>  {
>  	int ret =3D 0, i, tab_size, level;
>  	struct freq_clip_table *tab_ptr, *clip_data;
> +	struct exynos_thermal_zone *th_zone =3D thermal->devdata;
>  	struct thermal_sensor_conf *data =3D th_zone->sensor_conf;
> =20
>  	tab_ptr =3D (struct freq_clip_table *)data->cooling_data.freq_data;
> @@ -168,6 +171,7 @@ static int exynos_unbind(struct thermal_zone_device=
 *thermal,
>  			struct thermal_cooling_device *cdev)
>  {
>  	int ret =3D 0, i, tab_size;
> +	struct exynos_thermal_zone *th_zone =3D thermal->devdata;
>  	struct thermal_sensor_conf *data =3D th_zone->sensor_conf;
> =20
>  	if (th_zone->bind =3D=3D false)
> @@ -210,6 +214,7 @@ static int exynos_unbind(struct thermal_zone_device=
 *thermal,
>  static int exynos_get_temp(struct thermal_zone_device *thermal,
>  			unsigned long *temp)
>  {
> +	struct exynos_thermal_zone *th_zone =3D thermal->devdata;
>  	void *data;
> =20
>  	if (!th_zone->sensor_conf) {
> @@ -229,6 +234,7 @@ static int exynos_set_emul_temp(struct thermal_zone=
_device *thermal,
>  {
>  	void *data;
>  	int ret =3D -EINVAL;
> +	struct exynos_thermal_zone *th_zone =3D thermal->devdata;
> =20
>  	if (!th_zone->sensor_conf) {
>  		pr_info("Temperature sensor not initialised\n");
> @@ -276,11 +282,12 @@ static struct thermal_zone_device_ops const exyno=
s_dev_ops =3D {
>   * This function may be called from interrupt based temperature sensor=

>   * when threshold is changed.
>   */
> -void exynos_report_trigger(void)
> +void exynos_report_trigger(struct thermal_sensor_conf *conf)
>  {
>  	unsigned int i;
>  	char data[10];
>  	char *envp[] =3D { data, NULL };
> +	struct exynos_thermal_zone *th_zone =3D conf->pzone_data;
> =20
>  	if (!th_zone || !th_zone->therm_dev)
>  		return;
> @@ -321,6 +328,7 @@ int exynos_register_thermal(struct thermal_sensor_c=
onf *sensor_conf)
>  {
>  	int ret;
>  	struct cpumask mask_val;
> +	struct exynos_thermal_zone *th_zone;
> =20
>  	if (!sensor_conf || !sensor_conf->read_temperature) {
>  		pr_err("Temperature sensor not initialised\n");
> @@ -342,7 +350,7 @@ int exynos_register_thermal(struct thermal_sensor_c=
onf *sensor_conf)
>  	th_zone->cool_dev_size++;
> =20
>  	th_zone->therm_dev =3D thermal_zone_device_register(sensor_conf->name=
,
> -			EXYNOS_ZONE_COUNT, 0, NULL, &exynos_dev_ops, NULL, 0,
> +			EXYNOS_ZONE_COUNT, 0, th_zone, &exynos_dev_ops, NULL, 0,
>  			sensor_conf->trip_data.trigger_falling ?
>  			0 : IDLE_INTERVAL);
> =20
> @@ -352,20 +360,22 @@ int exynos_register_thermal(struct thermal_sensor=
_conf *sensor_conf)
>  		goto err_unregister;
>  	}
>  	th_zone->mode =3D THERMAL_DEVICE_ENABLED;
> +	sensor_conf->pzone_data =3D th_zone;
> =20
>  	pr_info("Exynos: Kernel Thermal management registered\n");
> =20
>  	return 0;
> =20
>  err_unregister:
> -	exynos_unregister_thermal();
> +	exynos_unregister_thermal(sensor_conf);
>  	return ret;
>  }
> =20
>  /* Un-Register with the in-kernel thermal management */
> -void exynos_unregister_thermal(void)
> +void exynos_unregister_thermal(struct thermal_sensor_conf *sensor_conf=
)
>  {
>  	int i;
> +	struct exynos_thermal_zone *th_zone =3D sensor_conf->pzone_data;
> =20
>  	if (!th_zone)
>  		return;
> diff --git a/drivers/thermal/samsung/exynos_thermal_common.h b/drivers/=
thermal/samsung/exynos_thermal_common.h
> index fd789a5..a845c2d 100644
> --- a/drivers/thermal/samsung/exynos_thermal_common.h
> +++ b/drivers/thermal/samsung/exynos_thermal_common.h
> @@ -84,22 +84,23 @@ struct thermal_sensor_conf {
>  	struct thermal_trip_point_conf trip_data;
>  	struct thermal_cooling_conf cooling_data;
>  	void *private_data;
> +	void *pzone_data;
>  };
> =20
>  /*Functions used exynos based thermal sensor driver*/
>  #ifdef CONFIG_EXYNOS_THERMAL_CORE
> -void exynos_unregister_thermal(void);
> +void exynos_unregister_thermal(struct thermal_sensor_conf *sensor_conf=
);
>  int exynos_register_thermal(struct thermal_sensor_conf *sensor_conf);
> -void exynos_report_trigger(void);
> +void exynos_report_trigger(struct thermal_sensor_conf *sensor_conf);
>  #else
>  static inline void
> -exynos_unregister_thermal(void) { return; }
> +exynos_unregister_thermal(struct thermal_sensor_conf *sensor_conf) { r=
eturn; }
> =20
>  static inline int
>  exynos_register_thermal(struct thermal_sensor_conf *sensor_conf) { ret=
urn 0; }
> =20
>  static inline void
> -exynos_report_trigger(void) { return; }
> +exynos_report_trigger(struct thermal_sensor_conf *sensor_conf) { retur=
n; }
> =20
>  #endif /* CONFIG_EXYNOS_THERMAL_CORE */
>  #endif /* _EXYNOS_THERMAL_COMMON_H */
> diff --git a/drivers/thermal/samsung/exynos_tmu.c b/drivers/thermal/sam=
sung/exynos_tmu.c
> index f6f63ca..a7bba69 100644
> --- a/drivers/thermal/samsung/exynos_tmu.c
> +++ b/drivers/thermal/samsung/exynos_tmu.c
> @@ -345,6 +345,12 @@ static int exynos_tmu_set_emulation(void *drv_data=
,	unsigned long temp)
>  	{ return -EINVAL; }
>  #endif/*CONFIG_THERMAL_EMULATION*/
> =20
> +static struct thermal_sensor_conf exynos_sensor_conf =3D {
> +	.name			=3D "exynos-therm",
> +	.read_temperature	=3D (int (*)(void *))exynos_tmu_read,
> +	.write_emul_temp	=3D exynos_tmu_set_emulation,
> +};
> +
>  static void exynos_tmu_work(struct work_struct *work)
>  {
>  	struct exynos_tmu_data *data =3D container_of(work,
> @@ -353,7 +359,7 @@ static void exynos_tmu_work(struct work_struct *wor=
k)
>  	const struct exynos_tmu_registers *reg =3D pdata->registers;
>  	unsigned int val_irq;
> =20
> -	exynos_report_trigger();
> +	exynos_report_trigger(&exynos_sensor_conf);
>  	mutex_lock(&data->lock);
>  	clk_enable(data->clk);
> =20
> @@ -377,11 +383,6 @@ static irqreturn_t exynos_tmu_irq(int irq, void *i=
d)
> =20
>  	return IRQ_HANDLED;
>  }
> -static struct thermal_sensor_conf exynos_sensor_conf =3D {
> -	.name			=3D "exynos-therm",
> -	.read_temperature	=3D (int (*)(void *))exynos_tmu_read,
> -	.write_emul_temp	=3D exynos_tmu_set_emulation,
> -};
> =20
>  #ifdef CONFIG_OF
>  static const struct of_device_id exynos_tmu_match[] =3D {
> @@ -541,7 +542,7 @@ static int exynos_tmu_remove(struct platform_device=
 *pdev)
> =20
>  	exynos_tmu_control(pdev, false);
> =20
> -	exynos_unregister_thermal();
> +	exynos_unregister_thermal(&exynos_sensor_conf);
> =20
>  	clk_unprepare(data->clk);
> =20
>=20


--=20
You have got to be excited about what you are doing. (L. Lamport)

Eduardo Valentin


------enig2NPKQWPWDEELCDSULBGEO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iF4EAREIAAYFAlHCM0QACgkQCXcVR3XQvP1ucAEAjSArupiMptyfqlGUT3xGadMa
5/cFV1P6YDxwbiq39RkA/RFtgJEDj88+NVHebOgFmhIJ4jNvNHJk4oTBB7HR00/p
=Y92L
-----END PGP SIGNATURE-----

------enig2NPKQWPWDEELCDSULBGEO--
