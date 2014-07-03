Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758732AbaGCO42 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 10:56:28 -0400
Received: from mail.kernel.org ([198.145.19.201]:36598 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758661AbaGCO4Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 10:56:24 -0400
Date: Thu, 3 Jul 2014 16:56:17 +0200
From: Sebastian Reichel <sre@kernel.org>
To: Jenny TC <jenny.tc@intel.com>
Cc: linux-kernel@vger.kernel.org,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        Pavel Machek <pavel@ucw.cz>, Stephen Rothwell <sfr@canb.auug.org.au>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        David Woodhouse <dwmw2@infradead.org>,
        David Cohen <david.a.cohen@linux.intel.com>,
        Pallala Ramakrishna <ramakrishna.pallala@intel.com>
Subject: Re: [PATCH 3/4] power_supply: Introduce PSE compliant algorithm
Message-ID: <20140703145617.GA23309@earth.universe>
References: <1404122155-12369-1-git-send-email-jenny.tc@intel.com>
 <1404122155-12369-4-git-send-email-jenny.tc@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="sdtB3X0nJg68CQEu"
Content-Disposition: inline
In-Reply-To: <1404122155-12369-4-git-send-email-jenny.tc@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--sdtB3X0nJg68CQEu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jenny,

On Mon, Jun 30, 2014 at 03:25:54PM +0530, Jenny TC wrote:
> As per Product Safety Engineering (PSE) specification for battery chargin=
g, the
> battery characteristics and thereby the charging rates can vary on differ=
ent
> temperature zones. This patch introduces a PSE compliant charging algorit=
hm with
> maintenance charging support. The algorithm can be selected by the power =
supply
> charging driver based on the type of the battery charging profile.
>=20
> Signed-off-by: Jenny TC <jenny.tc@intel.com>

Code looks quite good. I have a couple of minor nits:

> ---
>  drivers/power/Kconfig                      |   15 +++
>  drivers/power/Makefile                     |    1 +
>  drivers/power/charging_algo_pse.c          |  202 ++++++++++++++++++++++=
++++++
>  include/linux/power/power_supply_charger.h |   63 +++++++++
>  4 files changed, 281 insertions(+)
>  create mode 100644 drivers/power/charging_algo_pse.c
>=20
> diff --git a/drivers/power/Kconfig b/drivers/power/Kconfig
> index f679f82..54a0321 100644
> --- a/drivers/power/Kconfig
> +++ b/drivers/power/Kconfig
> @@ -22,6 +22,21 @@ config POWER_SUPPLY_CHARGER
>  	  drivers to keep the charging logic outside and the charger driver
>  	  just need to abstract the charger hardware.
> =20
> +config POWER_SUPPLY_CHARGING_ALGO_PSE
> +	bool "PSE compliant charging algorithm"
> +	depends on POWER_SUPPLY_CHARGER
> +	help
> +	  Say Y here to select Product Safety Engineering (PSE) compliant
> +	  charging algorithm. As per PSE standard the battery characteristics
> +	  and thereby the charging rates can vary on different temperature
> +	  zones. Select this if your charging algorithm need to change the
> +	  charging parameters based on the battery temperature and the battery
> +	  charging profile follows the struct psy_pse_chrg_prof definition.
> +	  This  config will enable PSE compliant charging algorithm with
> +	  maintenance charging support. At runtime the algorithm will be
> +	  selected by the psy charger driver based on the type of the battery
> +	  charging profile.
> +
>  config PDA_POWER
>  	tristate "Generic PDA/phone power driver"
>  	depends on !S390
> diff --git a/drivers/power/Makefile b/drivers/power/Makefile
> index 405f0f4..77535fd 100644
> --- a/drivers/power/Makefile
> +++ b/drivers/power/Makefile
> @@ -8,6 +8,7 @@ obj-$(CONFIG_POWER_SUPPLY)	+=3D power_supply.o
>  obj-$(CONFIG_GENERIC_ADC_BATTERY)	+=3D generic-adc-battery.o
> =20
>  obj-$(CONFIG_POWER_SUPPLY_CHARGER) +=3D power_supply_charger.o
> +obj-$(CONFIG_POWER_SUPPLY_CHARGING_ALGO_PSE) +=3D charging_algo_pse.o
>  obj-$(CONFIG_PDA_POWER)		+=3D pda_power.o
>  obj-$(CONFIG_APM_POWER)		+=3D apm_power.o
>  obj-$(CONFIG_MAX8925_POWER)	+=3D max8925_power.o
> diff --git a/drivers/power/charging_algo_pse.c b/drivers/power/charging_a=
lgo_pse.c
> new file mode 100644
> index 0000000..6ec4873
> --- /dev/null
> +++ b/drivers/power/charging_algo_pse.c
> @@ -0,0 +1,202 @@
> +/*
> + * Copyright (C) 2012 Intel Corporation
> + *
> + * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~=
~~~~~
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; version 2 of the License.
> + *
> + * This program is distributed in the hope that it will be useful, but
> + * WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.	See the GNU
> + * General Public License for more details.
> + *
> + * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~=
~~~~~
> + * Author: Jenny TC <jenny.tc@intel.com>
> + */
> +
> +#include <linux/module.h>
> +#include <linux/types.h>
> +#include <linux/init.h>
> +#include <linux/slab.h>
> +#include <linux/device.h>
> +#include <linux/err.h>
> +#include <linux/power_supply.h>
> +#include <linux/thermal.h>
> +#include "power_supply.h"
> +#include "power_supply_charger.h"
> +
> +/* 98% of CV is considered as voltage to detect Full */
> +#define FULL_CV_MIN 98
> +
> +/*
> + * Offset to exit from maintenance charging. In maintenance charging
> + * if the volatge is less than the (maintenance_lower_threshold -
> + * MAINT_EXIT_OFFSET) then system can switch to normal charging
> + */
> +
> +#define MAINT_EXIT_OFFSET 50  /* mV */
> +
> +static int get_tempzone(struct psy_pse_chrg_prof *pse_mod_bprof,
> +		int temp)
> +{
> +	int i =3D 0;
> +	int temp_range_cnt;
> +
> +	temp_range_cnt =3D  min_t(u16, pse_mod_bprof->temp_mon_ranges,
> +					BATT_TEMP_NR_RNG);
> +	if ((temp < pse_mod_bprof->temp_low_lim) ||
> +		(temp > pse_mod_bprof->temp_mon_range[0].temp_up_lim))
> +		return -EINVAL;
> +
> +	for (i =3D 0; i < temp_range_cnt; ++i)
> +		if (temp > pse_mod_bprof->temp_mon_range[i].temp_up_lim)
> +			break;
> +	return i-1;
> +}

pse_mod_bprof->temp_mon_ranges > BATT_TEMP_NR_RNG is not allowed,
so I suggest to print an error and return some error code.

> +static inline bool is_charge_terminated(long volt, long cur,
> +				long iterm, unsigned long cv)
> +{
> +	return (cur > 0) && (cur <=3D iterm) &&
> +				((volt * 100)  >=3D (FULL_CV_MIN * cv));
> +}
> +
> +static inline bool is_battery_full(struct psy_batt_context *batt_cxt,
> +		struct psy_pse_chrg_prof *pse_mod_bprof, unsigned long cv)
> +{
> +	int i;
> +	struct psy_batt_props batt_props;
> +
> +	batt_props =3D  batt_cxt->batt_props;
> +
> +	/*
> +	* Software full detection. Check the battery charge current to detect
> +	* battery Full. The voltage also verified to avoid false charge
> +	* full detection.
> +	*/
> +	for (i =3D (MAX_CUR_VOLT_SAMPLES - 1); i >=3D 0; --i) {
> +
> +		if (!(is_charge_terminated(batt_cxt->voltage_now_cache[i],
> +				batt_cxt->current_now_cache[i],
> +				pse_mod_bprof->chrg_term_mA, cv)))
> +			return false;
> +	}
> +
> +	return true;
> +}
> +
> +static int  pse_get_bat_thresholds(struct psy_batt_chrg_prof  bprof,
> +			struct psy_batt_thresholds *bat_thresh)
> +{
> +	struct psy_pse_chrg_prof *pse_mod_bprof =3D
> +			(struct psy_pse_chrg_prof *) bprof.batt_prof;
> +
> +	if ((bprof.chrg_prof_type !=3D PSY_CHRG_PROF_PSE) || (!pse_mod_bprof))
> +		return -EINVAL;
> +
> +	bat_thresh->iterm =3D pse_mod_bprof->chrg_term_mA;
> +	bat_thresh->temp_min =3D pse_mod_bprof->temp_low_lim;
> +	bat_thresh->temp_max =3D pse_mod_bprof->temp_mon_range[0].temp_up_lim;
> +
> +	return 0;
> +}
> +
> +static enum psy_algo_stat pse_get_next_cc_cv(struct psy_batt_context *ba=
tt_cxt,
> +	struct psy_batt_chrg_prof  bprof, unsigned long *cc, unsigned long *cv)
> +{
> +	int tzone;
> +	struct psy_pse_chrg_prof *pse_mod_bprof;
> +	struct psy_batt_props batt_props;
> +	enum psy_algo_stat algo_stat;
> +	int maint_exit_volt;
> +
> +	pse_mod_bprof =3D (struct psy_pse_chrg_prof *) bprof.batt_prof;
> +	algo_stat =3D batt_cxt->algo_stat;
> +
> +	batt_props =3D batt_cxt->batt_props;
> +
> +	*cc =3D *cv =3D 0;
> +
> +	/*
> +	* If STATUS is discharging, assume that charger is not connected.
> +	* If charger is not connected, no need to take any action.
> +	* If charge profile type is not PSY_CHRG_PROF_PSE or the charge profile
> +	* is not present, no need to take any action.
> +	*/
> +
> +	if (!pse_mod_bprof)
> +		return PSY_ALGO_STAT_NOT_CHARGE;
> +
> +	tzone =3D get_tempzone(pse_mod_bprof, batt_props.temperature);
> +
> +	if (tzone < 0)
> +		return PSY_ALGO_STAT_NOT_CHARGE;
> +
> +	/*
> +	* Change the algo status to not charging, if battery is
> +	* not really charging or less than maintenance exit threshold.
> +	* This way algorithm can switch to normal charging if current
> +	* status is full/maintenance.
> +	*/
> +	maint_exit_volt =3D pse_mod_bprof->
> +				temp_mon_range[tzone].maint_chrg_vol_ll -
> +				MAINT_EXIT_OFFSET;
> +
> +	if ((batt_props.status =3D=3D POWER_SUPPLY_STATUS_DISCHARGING) ||
> +		(batt_props.status =3D=3D POWER_SUPPLY_STATUS_NOT_CHARGING) ||
> +			batt_props.voltage_now < maint_exit_volt) {
> +
> +		algo_stat =3D PSY_ALGO_STAT_NOT_CHARGE;
> +
> +	}
> +
> +	/* read cc and cv based on temperature and algorithm status */
> +	if (algo_stat =3D=3D PSY_ALGO_STAT_FULL ||
> +			algo_stat =3D=3D PSY_ALGO_STAT_MAINT) {
> +
> +		/*
> +		* if status is full and voltage is lower than maintenance lower
> +		* threshold change status to maintenance
> +		*/
> +
> +		if (algo_stat =3D=3D PSY_ALGO_STAT_FULL &&
> +			(batt_props.voltage_now <=3D
> +			pse_mod_bprof->temp_mon_range[tzone].maint_chrg_vol_ll))
> +				algo_stat =3D PSY_ALGO_STAT_MAINT;
> +
> +		/* Read maintenance CC and CV */
> +		if (algo_stat =3D=3D PSY_ALGO_STAT_MAINT) {
> +			*cv =3D pse_mod_bprof->temp_mon_range
> +					[tzone].maint_chrg_vol_ul;
> +			*cc =3D pse_mod_bprof->temp_mon_range
> +					[tzone].maint_chrg_cur;
> +		}
> +	} else {
> +		*cv =3D pse_mod_bprof->temp_mon_range[tzone].full_chrg_vol;
> +		*cc =3D pse_mod_bprof->temp_mon_range[tzone].full_chrg_cur;
> +		algo_stat =3D PSY_ALGO_STAT_CHARGE;
> +	}
> +
> +	if (is_battery_full(batt_cxt, pse_mod_bprof, *cv)) {
> +		*cc =3D *cv =3D 0;
> +		algo_stat =3D PSY_ALGO_STAT_FULL;
> +	}
> +
> +	return algo_stat;
> +}
> +
> +struct psy_charging_algo pse_algo =3D {
> +	.name =3D "pse_algo",

Most power supply drivers use "-" instead of "_" in their names, so
probably it a good idea to continue doing so. I suggest to use
"pse-algorithm" as name.

> +	.chrg_prof_type =3D PSY_CHRG_PROF_PSE,
> +	.get_next_cc_cv =3D pse_get_next_cc_cv,
> +	.get_batt_thresholds =3D pse_get_bat_thresholds,
> +};
> +static int __init pse_algo_init(void)
> +{
> +	power_supply_register_charging_algo(&pse_algo);
> +	return 0;
> +}
> +
> +module_init(pse_algo_init);
> diff --git a/include/linux/power/power_supply_charger.h b/include/linux/p=
ower/power_supply_charger.h
> index 2b59817..8f3797d 100644
> --- a/include/linux/power/power_supply_charger.h
> +++ b/include/linux/power/power_supply_charger.h
> @@ -94,8 +94,71 @@ enum battery_events {
> =20
>  enum psy_batt_chrg_prof_type {
>  	PSY_CHRG_PROF_NONE =3D 0,
> +	PSY_CHRG_PROF_PSE,
>  };
> =20
> +/* Product Safety Engineering (PSE) compliant charging profile */
> +
> +/**
> + * struct psy_ps_temp_chg_table - charging temperature zones definition
> + * @temp_up_lim: upper temperature limit for each zone in Degree Celsius

Maybe simply use temp_max?

> + * @full_chrg_vol: charge voltage till battery full in mV
> + * @full_chrg_cur: charge current till battery full in mA
> + * @maint_chrg_vol_ll: voltage at which maintenance charging should star=
t in mV
> + * @maint_chrg_vol_ul: voltage at which maintenance charging should stop=
 in mV.

min and max instead of ll and ul improves readability IMHO.

> + *	This is the charging voltage in maintenance charging mode
> + * @maint_chrg_cur: charge current in maintenance charging mode
> + *
> + * Charging temperature zone definition to decide the charging parameter=
s on
> + * each zone. An array of the structure is used to define multiple tempe=
rature
> + * zones
> + */
> +
> +struct psy_ps_temp_chg_table {
> +	short int temp_up_lim;
> +	short int full_chrg_vol;
> +	short int full_chrg_cur;
> +	short int maint_chrg_vol_ll;
> +	short int maint_chrg_vol_ul;
> +	short int maint_chrg_cur;
> +} __packed;
> +
> +#define BATTID_STR_LEN		8
> +#define BATT_TEMP_NR_RNG	6
> +
> +/**
> + * struct psy_pse_chrg_prof - PSE charging profile structure
> + * @batt_id: battery identifier
> + * @battery_type: as defined in POWER_SUPPLY_TECHNOLOGY_*
> + * @capacity: battery capacity in mAh
> + * @voltage_max: maximum battery volatge in mV
> + * @chrg_term_ma: charge termination current in mA
> + * @low_batt_mv: Low battery level voltage in mV
> + * @disch_temp_ul: maximum operating temperature when battery is dischar=
ging
> + * @disch_temp_ll: lowest operating temperature when battery is discharg=
ing

min and max instead of ll and ul improves readability IMHO.

Please add in degree Celsius for temperatures.

> + * @temp_mon_ranges: number of temperature zones
> + * @psy_ps_temp_chg_table: temperature zone table array
> + * @temp_low_lim: minimum charging temperature

Please add in degree Celsius for temperatures. Also maybe simply use
temp_min.

> + * PSE compliant charging profile which can be stored in battery EEPROM
> + * (if digital battery interface like MIPI BIF/SDQ supported) or in seco=
ndary
> + * storage to support analog battery (with BSI sensing support)
> + */
> +
> +struct psy_pse_chrg_prof {
> +	char batt_id[BATTID_STR_LEN];
> +	u16 battery_type;
> +	u16 capacity;
> +	u16 voltage_max;
> +	u16 chrg_term_mA;
> +	u16 low_batt_mV;
> +	s8 disch_temp_ul;
> +	s8 disch_temp_ll;
> +	u16 temp_mon_ranges;
> +	struct psy_ps_temp_chg_table temp_mon_range[BATT_TEMP_NR_RNG];
> +	s8 temp_low_lim;
> +} __packed;
> +
>  /**
>   * struct psy_batt_chrg_prof - power supply charging profile structure
>   * @chrg_prof_type: charging profile type
> --=20
> 1.7.9.5
>=20

--sdtB3X0nJg68CQEu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJTtW8RAAoJENju1/PIO/qacRgP/AivbDEJTMZ8tudYVXzzK5ol
c9n55cf2YihO9hFurX3rGO+R9/W+wVFPZxFWxP4LmXlRtVE/86Fnsj5MIqyE6cTC
1IIDp/3YSaj45PTTLvsTb0hGy2uBUCCjlOVFFTig1aQkCFVUFnYeBT/bM+PlngzW
k/XdORhuUPBNnAxzIKrMtZDVaZ7XgGjyy6TepBljvBQ0RqvsQplazqY8CTq6olbS
OsL7YyM5D8LvyluTQaYPI7qDQEZAUhzQpvXeXpFhpZBTK9CQiBFz6yHARbUniPRG
GOrisu2rbUc7vTIv59JvIPBdjC4tRmcuFInTTUjlKuqi9Vu2OYb1zpFFNx6PnYXU
QmQGqGzJ3r4Q6bHvvJswPpXhwWYQlr2lqQem04qCUXBcICFjnO1joiLfY5jCk2qA
bmPy2YFUnO1C8UwNU99I2JLn2YX/wEaF7/zP2J4ria2J8Jz935QY21/mgg3mm/Ew
J89Vf+0BZV3Cx3hmnHaf8qkd+GRUPOuoPXJL8G3mbzsJHlA2IQzf8e1D5TVgeFsy
Se7Ox1bD4Mu1gN5npHaHUSi2wUpNIYVp22URgLfXuVyVy2Ec5nJArG0YyFXwqFWb
miTtjtK0O3BtHn+Yd9XQQgMfUvgbRJW37IC/HiZr/1ad8qUIiXTWQf0iri5zwEdv
N5NtvF8vutq8LwmzlFGJ
=kuR2
-----END PGP SIGNATURE-----

--sdtB3X0nJg68CQEu--
