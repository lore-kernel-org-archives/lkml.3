Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759161AbaGRCSo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 22:18:44 -0400
Received: from mail.kernel.org ([198.145.19.201]:42522 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753536AbaGRCSn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 22:18:43 -0400
Date: Fri, 18 Jul 2014 04:18:36 +0200
From: Sebastian Reichel <sre@kernel.org>
To: Jenny TC <jenny.tc@intel.com>
Cc: linux-kernel@vger.kernel.org,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        Pavel Machek <pavel@ucw.cz>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        David Woodhouse <dwmw2@infradead.org>,
        David Cohen <david.a.cohen@linux.intel.com>,
        Pallala Ramakrishna <ramakrishna.pallala@intel.com>,
        myungjoo.ham@samsung.com
Subject: Re: [PATCH 2/4] power_supply: Introduce generic psy charging driver
Message-ID: <20140718021836.GD21934@earth.universe>
References: <1404799461-26345-1-git-send-email-jenny.tc@intel.com>
 <1404799461-26345-3-git-send-email-jenny.tc@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="FFoLq8A0u+X9iRU8"
Content-Disposition: inline
In-Reply-To: <1404799461-26345-3-git-send-email-jenny.tc@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--FFoLq8A0u+X9iRU8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jenny,

On Tue, Jul 08, 2014 at 11:34:19AM +0530, Jenny TC wrote:
> The Power Supply charging driver connects multiple subsystems
> to do charging in a generic way. The subsystems involves power_supply,
> thermal and battery communication subsystems (1wire). With this the charg=
ing is
> handled in a generic way.
>=20
> The driver makes use of different new features - Battery Identification
> interfaces, pluggable charging algorithms, charger cable arbitrations etc.
> The patch also introduces generic interface for charger cable notificatio=
ns.
> Charger cable events and capabilities can be notified using the generic
> power_supply_notifier chain.
>=20
> Overall this driver removes the charging logic out of the charger chip dr=
iver
> and the charger chip driver can just listen to the request from the power
> supply charging driver to set the charger properties. This can be impleme=
nted
> by exposing get_property and set property callbacks.

this seems to be a superset of charger-manager, which is already in
the kernel. I would prefer not to have two different charger
mangement frameworks in the kernel.

I suggest to add features supported by charger-manager to power
supply charging driver and convert users of charger-manager to
the improved driver.

I CC'd MyungJoo Ham, who wrote the charger-manager, so that he
can also give feedback.

> Signed-off-by: Jenny TC <jenny.tc@intel.com>
> ---
>  Documentation/power/power_supply_charger.txt |  350 +++++++++
>  drivers/power/Kconfig                        |    8 +
>  drivers/power/Makefile                       |    1 +
>  drivers/power/power_supply_charger.c         | 1016 ++++++++++++++++++++=
++++++
>  drivers/power/power_supply_charger.h         |  226 ++++++
>  drivers/power/power_supply_core.c            |    3 +
>  include/linux/power/power_supply_charger.h   |  307 ++++++++
>  include/linux/power_supply.h                 |  161 ++++
>  8 files changed, 2072 insertions(+)
>  create mode 100644 Documentation/power/power_supply_charger.txt
>  create mode 100644 drivers/power/power_supply_charger.c
>  create mode 100644 drivers/power/power_supply_charger.h
>  create mode 100644 include/linux/power/power_supply_charger.h
>=20
> diff --git a/Documentation/power/power_supply_charger.txt b/Documentation=
/power/power_supply_charger.txt
> new file mode 100644
> index 0000000..e81754b
> --- /dev/null
> +++ b/Documentation/power/power_supply_charger.txt
> @@ -0,0 +1,350 @@
> +1. Introduction
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +
> +The Power Supply charging driver connects multiple subsystems
> +to do charging in a generic way. The subsystems involves power_supply,
> +thermal and battery communication subsystems (1wire). With this the char=
ging is

(e.g. 1wire)?

> +handled in a generic way by plugging the driver to power supply subsyste=
m.
> +
> +The driver introduces different new features - Battery Identification
> +interfaces, pluggable charging algorithms, charger cable arbitrations et=
c.
> +
> +In existing driver implementations the charging is done based on the sta=
tic
> +battery characteristics. This is done at the boot time by passing the ba=
ttery
> +properties (max_voltage, capacity) etc. as a platform data to the
> +charger/battery driver. But new generation high volt batteries needs to =
be
> +identified dynamically to do charging in a safe manner. The batteries are
> +coming with different communication protocols. It become necessary to
> +communicate with battery and identify it's charging profiles before setup
> +charging.
> +
> +Also the charging algorithms can vary based on the battery characteristi=
cs
> +and the platform characteristics. To handle charging in a generic way it=
's
> +necessary to support pluggable charging algorithms. Power Supply Charging
> +driver selects algorithms based on the type of battery charging profile.
> +This is a simple binding and can be improved later. This may be improved=
 to
> +select the algorithms based on the platform requirements. Also we can ex=
tend
> +this driver to plug algorithms from the user space.
> +
> +The driver also introduces the charger cable arbitration. A charger may
> +supports multiple cables, but it may not be able to charge with multiple
> +cables at a time (USB/AC/Wireless etc.). The arbitration logic inside the
> +driver selects the cable based on it's capabilities and the maximum
> +charge current the platform can support.
> +
> +Also the driver exposes features to control charging on different platfo=
rm
> +states. One such feature is thermal. The driver handles the thermal
> +throttling requests for charging and control charging based on the therm=
al
> +subsystem requirements.
> +
> +Overall this driver removes the charging logic out of the charger chip d=
river
> +and the charger chip driver can just listen to the request from the power
> +supply charging driver to set the charger properties. This can be implem=
ented
> +by exposing get_property and set property callbacks.

It can be, or it is supposed to be?

> +2. Reading Battery charging profile
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +
> +Power Supply charging driver expose APIs to retrieve battery profile of a
> +battery. The battery profile can be read by battery identification drive=
r which
> +may be 1wire/I2C/SFI driver. Battery identification driver can register =
the
> +battery profile with the power supply charging driver using the API
> +psy_battery_prop_changed(). The driver also exposes API
> +psy_get_battery_prop() to retrieve the battery profile which can be
> +used by power supply drivers to setup the charging. Also drivers
> +can register for battery removal/insertion notifications using
> +power_supply_reg_notifier()

I think _prop() should be either _profile() or _props().

> +3. Use Charging Driver to setup charging
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
                                           ^^^
wrong length?

> [...]
> +3.1  Registering charger chip driver with power supply charging driver
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
                                                                   ^^^^^^
wrong length?

> [...]
> +3.2 Properties exposed to power supply class driver
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
                                                     ^
wrong length?

> [...]
> +3.3 Properties exposed to power supply charging driver
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
                                                        ^
wrong length?

> [...]
> +3.4 Throttling data configuration
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
                                ^^^^
wrong length?

> [...]
> +5. Registering new charging algorithm
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
                                      ^^
wrong length?

> [...]
> +6. TODO
> +=3D=3D=3D=3D=3D=3D=3D
> +* Replace static cable array with dynamic list
> +* Implement safety timer and watch dog timer features with more monitori=
ng
> +* Move charge full detection logic to psy charging driver from algorithm=
 driver

Just curious: What are your plans regarding the TODO list?

> [...]
> diff --git a/drivers/power/power_supply_charger.c b/drivers/power/power_s=
upply_charger.c
> new file mode 100644
> index 0000000..1993c8c
> --- /dev/null
> +++ b/drivers/power/power_supply_charger.c
> @@ -0,0 +1,1016 @@
> +/*
> + * Copyright (C) 2012 Intel Corporation

should be updated probably :)

> [...]
> +#include <linux/device.h>
> +#include <linux/err.h>
> +#include <linux/init.h>
> +#include <linux/module.h>
> +#include <linux/notifier.h>
> +#include <linux/power_supply.h>
> +#include <linux/power/power_supply_charger.h>
> +#include <linux/slab.h>
> +#include <linux/thermal.h>
> +#include <linux/types.h>
> +#include <linux/usb/otg.h>
> +#include "power_supply_charger.h"
> +
> +
> +#define MAX_CHARGER_COUNT 5
           ^^^^^^^^^^^^^^^^^
unused?

> +#define MAX_CABLE_COUNT 15
> +static LIST_HEAD(algo_list);
> +
> +struct psy_event_node {
> +	struct list_head node;
> +	unsigned long event;
> +	struct psy_cable_props cap;
> +	struct power_supply *psy;
> +	struct psy_batt_chrg_prof batt_property;
> +};
> +
> +struct charger_cable {
> +	struct psy_cable_props cable_props;
> +	unsigned long psy_cable_type;
> +};
> +
> +struct psy_charger_drv_context {
> +	bool is_usb_cable_evt_reg;
> +	int psyc_cnt;
> +	int batt_status;
> +	/* cache battery and charger properties */
> +	struct mutex event_lock;
> +	struct list_head event_queue;
> +	struct psy_batt_chrg_prof batt_property;
> +	struct work_struct event_work;
> +	struct charger_cable cable_list[MAX_CABLE_COUNT];
> +	wait_queue_head_t wait_chrg_enable;
> +	spinlock_t event_queue_lock;
> +};
> +
> +DEFINE_MUTEX(battid_lock);
> +
> +static struct psy_charger_drv_context psy_chrgr;
> +static struct usb_phy *otg_xceiver;
> +static int handle_event_notification(struct notifier_block *nb,
> +				   unsigned long event, void *data);
> +static struct notifier_block nb =3D {
> +		   .notifier_call =3D handle_event_notification,
> +		};
> +static void configure_chrgr_source(struct charger_cable *cable_lst);
> +static struct psy_charging_algo *power_supply_get_charging_algo
> +		(struct power_supply *, struct psy_batt_chrg_prof *);
> +static void __power_supply_trigger_charging_handler(struct power_supply =
*psy);
> +static void power_supply_trigger_charging_handler(struct power_supply *p=
sy);
> +static void trigger_algo_psy_class(void);
> +static int psy_charger_throttle_charger(struct power_supply *psy,
> +					unsigned long state);
> +
> +static inline bool psy_is_battery_prop_changed(struct psy_batt_props *ba=
t_prop,
> +		struct psy_batt_props *bat_cache)
> +{
> +	if (!bat_cache)
> +		return true;
> +
> +	/* return true if temperature, health or throttling state changed */
> +	if ((bat_cache->temperature !=3D bat_prop->temperature) ||
> +		(bat_cache->health !=3D bat_prop->health) ||
> +		(bat_cache->throttle_state !=3D bat_prop->throttle_state))
> +		return true;
> +
> +	/* return true if voltage or current changed not within TTL limit */
> +	if (time_after64(bat_prop->tstamp, bat_cache->tstamp + PROP_TTL) &&
> +		(bat_cache->current_now !=3D bat_prop->current_now ||
> +		bat_cache->voltage_now !=3D bat_prop->voltage_now))
> +		return true;
> +
> +	return false;
> +}
> +
> +static inline bool psy_is_charger_prop_changed(struct psy_charger_props =
*prop,
> +		struct psy_charger_props *cache_prop)
> +{
> +	/* if online/prsent/health/is_charging is changed, then return true */
> +	if (!cache_prop)
> +		return true;
> +
> +	if (cache_prop->online !=3D prop->online ||
> +		cache_prop->present !=3D prop->present ||
> +		cache_prop->is_charging !=3D prop->is_charging ||
> +		cache_prop->health !=3D prop->health)
> +		return true;
> +	else
> +		return false;
> +
> +}
> +
> +static inline void get_cur_chrgr_prop(struct power_supply *psy,
> +				      struct psy_charger_props *chrgr_prop)
> +{
> +	chrgr_prop->is_charging =3D psy_is_charging_enabled(psy);
> +	chrgr_prop->online =3D psy_is_online(psy);
> +	chrgr_prop->present =3D psy_is_present(psy);
> +	chrgr_prop->cable =3D psy_cable_type(psy);
> +	chrgr_prop->health =3D PSY_HEALTH(psy);
> +	chrgr_prop->tstamp =3D get_jiffies_64();
> +}
> +
> +static void dump_charger_props(struct psy_charger_props *props)
> +{
> +	if (props)

You can drop the NULL pointer check. This should be checked already
by the parent function.

> +		pr_debug("%s: present=3D%d is_charging=3D%d health=3D%d online=3D%d ca=
ble=3D%ld tstamp=3D%ld\n",
> +			__func__, props->present, props->is_charging,
> +			props->health, props->online, props->cable,
> +			props->tstamp);
> +}
> +
> +static void dump_battery_props(struct psy_batt_props *props)
> +{
> +	if (props)

You can drop the NULL pointer check. This should be checked already
by the parent function.

> +		pr_debug("%s voltage_now=3D%ld current_now=3D%ld temperature=3D%d stat=
us=3D%ld health=3D%d tstamp=3D%lld",
> +			__func__, props->voltage_now, props->current_now,
> +			props->temperature, props->status, props->health,
> +			props->tstamp);
> +}
> +
> +static int  __update_supplied_psy(struct device *dev, void *data)
> +{
> +	struct psy_charger_context *charger_context;
> +	struct psy_batt_context *batt_context;
> +	struct power_supply *psb, *psy;
> +	int i;
> +
> +	psy =3D dev_get_drvdata(dev);
> +
> +	if (!psy || !psy_is_charger(psy) || !psy->data)
> +		return 0;
> +
> +	charger_context =3D psy->data;
> +	charger_context->num_supplied_to_psy =3D 0;
> +
> +	for (i =3D 0; i < psy->num_supplicants; i++) {
> +		psb =3D power_supply_get_by_name(psy->supplied_to[i]);
> +		if (!psb)
> +			continue;

no warning?

> +		if (!psb->data)
> +			psb->data =3D devm_kzalloc(psb->dev,
> +				sizeof(struct psy_batt_context), GFP_KERNEL);

devm_kzalloc can fail (recheck psb->data =3D=3D NULL).

> +		batt_context =3D psb->data;
> +		batt_context->supplied_by_psy
> +				[batt_context->num_supplied_by_psy++] =3D psy;

this can go out of bound!

> +		charger_context->supplied_to_psy
> +				[charger_context->num_supplied_to_psy++] =3D psb;

this can go out of bound!

> +	}
> +
> +	return 0;
> +}
> +
> [...]
> +
> +static void cache_successive_samples(long *sample_array, long new_sample)
> +{
> +	int i;
> +
> +	for (i =3D 0; i < MAX_CUR_VOLT_SAMPLES - 1; ++i)
> +		*(sample_array + i) =3D *(sample_array + i + 1);
> +
> +	*(sample_array + i) =3D new_sample;
> +}

please use array syntax, e.g.

sample_array[i] =3D new_sample[i+1];

not using a ring buffer is ok with MAX_CUR_VOLT_SAMPLES being 3. If
this is ever increased a ring buffer should be used, though.

> [...]
> +static inline bool is_batt_prop_changed(struct power_supply *psy)
> +{
> +	struct psy_batt_context *batt_context;
> +	struct psy_batt_props new_batt_props;
> +
> +	if (!psy->data)
> +		update_supplied_psy();
> +
> +	batt_context =3D  psy->data;
                  ^^
remove one space

> [...]
> +static int process_cable_props(struct psy_cable_props *cap)
> +{
> +	struct charger_cable *cable =3D NULL;
> +	unsigned off;
> +
> +	pr_info("%s: event:%d, type:%lu, current_mA:%d\n",
> +		__func__, cap->chrg_evt, cap->chrg_type, cap->current_mA);
> +
> +	off =3D ffs(cap->chrg_type);
> +
> +	if (!off || off >=3D ARRAY_SIZE(psy_chrgr.cable_list)) {
> +		pr_err("%s:%d Invalid cable type\n", __FILE__, __LINE__);
> +		return -EINVAL;
> +	}
> +
> +	cable =3D &psy_chrgr.cable_list[off - 1];
> +
> +	if (cable->psy_cable_type =3D=3D PSY_CHARGER_CABLE_TYPE_NONE)
> +		cable->psy_cable_type =3D cap->chrg_type;
> +
> +	memcpy((void *)&cable->cable_props, (void *)cap,
> +			sizeof(cable->cable_props));

Use struct assignment instead of memcpy:

*cable->cable_props =3D *cap;

> +
> +	configure_chrgr_source(psy_chrgr.cable_list);
> +
> +	return 0;
> +}
> +
> [...]
> +
> +static int register_usb_notifier(void)
> +{
> +	int retval =3D 0;
> +
> +	otg_xceiver =3D usb_get_phy(USB_PHY_TYPE_USB2);
> +	if (!otg_xceiver) {
> +		pr_err("failure to get otg transceiver\n");
> +		retval =3D -EIO;
> +		goto notifier_reg_failed;
> +	}
> +	retval =3D usb_register_notifier(otg_xceiver, &nb);
> +	if (retval) {
> +		pr_err("failure to register otg notifier\n");
> +		goto notifier_reg_failed;
> +	}
> +
> +notifier_reg_failed:
> +	return retval;
> +}

remove useless goto by returning directly.

> [...]
> +static int get_battery_status(struct power_supply *psy)
> +{
> +	int status;
> +	struct power_supply *psc;
> +	struct psy_batt_context *batt_context;
> +	int cnt;
> +
> +	if (!psy_is_battery(psy) || (!psy->data))
> +		return POWER_SUPPLY_STATUS_UNKNOWN;
> +
> +	batt_context =3D psy->data;
> +	status =3D POWER_SUPPLY_STATUS_DISCHARGING;
> +	cnt =3D batt_context->num_supplied_by_psy;
> +
> +	while (cnt--) {
> +		psc =3D batt_context->supplied_by_psy[cnt];
> +
> +		if (psy_is_present(psc))
> +			status =3D POWER_SUPPLY_STATUS_NOT_CHARGING;
> +
> +		if (!(psy_is_charging_can_be_enabled(psc)) ||
> +			(!psy_is_health_good(psy)) ||
> +				(!psy_is_health_good(psc)))
> +			continue;
> +
> +		if ((batt_context->algo_stat =3D=3D PSY_ALGO_STAT_FULL) ||
> +			(batt_context->algo_stat =3D=3D PSY_ALGO_STAT_MAINT))
> +				status =3D POWER_SUPPLY_STATUS_FULL;
> +		else if (psy_is_charging_enabled(psc))
> +				status =3D POWER_SUPPLY_STATUS_CHARGING;
> +	}
> +
> +	pr_debug("%s: Set status=3D%d for %s\n", __func__, status, psy->name);
> +
> +	return status;
> +}

mh. So basically if there's more than one charger for a battery
we will return the status of the one, which was initialized at
last? IMHO the status from the other chargers should be used to
validate the other ones.

> [...]
> +static void update_charger_online(struct power_supply *psy)
> +{
> +	int online;
> +	struct psy_charger_context *charger_context;
> +
> +	online =3D psy_is_charger_enabled(psy) ? 1 : 0;

online =3D !!psy_is_charger_enabled(psy)

> +	psy_set_charger_online(psy, online);
> +	charger_context =3D psy->data;
> +	charger_context->charger_props.online =3D online;
> +}
> [...]


TODO TODO TODO

> diff --git a/drivers/power/power_supply_charger.h b/drivers/power/power_s=
upply_charger.h
> new file mode 100644
> index 0000000..665ab7b
> --- /dev/null
> +++ b/drivers/power/power_supply_charger.h
> @@ -0,0 +1,226 @@
> +/*
> + * Copyright (C) 2012 Intel Corporation
                    ^^^^
update?

> [...]
> +static inline int psy_throttle_action
> +		(struct power_supply *psy, unsigned int state)
> +{
> +	struct power_supply_charger *psyc;
> +
> +	psyc =3D psy_to_psyc(psy);
> +
> +	if (psyc)
> +		return ((psyc->throttle_states)+state)->throttle_action;

please use array syntax!

> +
> +	/* If undetermined state, better disable charger for safety reasons */
> +
> +	return PSY_THROTTLE_DISABLE_CHARGER;
> +}
> +
> [...]
> +
> +static inline int psy_throttle_cc_value(struct power_supply *psy,
> +			unsigned int state)
> +{
> +	struct power_supply_charger *psyc;
> +
> +	psyc =3D psy_to_psyc(psy);
> +
> +	if (psyc)
> +		return ((psyc->throttle_states)+state)->throttle_val;

please use array syntax!

> +
> +	/* If undetermined state, better set CC as 0 */
> +	return 0;
> +}
> +
> [...]

-- Sebastian

--FFoLq8A0u+X9iRU8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJTyIP8AAoJENju1/PIO/qaOXAP/1hAlr8qVMANkeEiDfA7tdpP
cyGzzQ6PkMD/gKONgAr1XMA6Z2QhLyz/vmVyfT3od/6YQGdQNvSdLwmWhJoSCNda
JfQf/kXQSiH2vjgxwScINbEQIvBnwpqc9EdrRPitqR8vd8B3rqUI2n38shBgsGF6
y0U4/NFU1x62ELOwmyACIiYF5hiKB9Rt6Fa1lg0EuuOGmQOTk3LAJUzeNV1E6dTO
3z3J10nvFSFh5Qfbq03Sp8SPsrmsiKkWGxcS22VlikAVU+Jf1ZSgn+rZdbMhvceZ
jIXaBlG51k0MNcEdAI6qARiqk4j/lsRn1w9O6M2P6MuzKEsjeXMxBImBRy63eiKA
lyrJ7I3G+IQ+U030auZvXQcIQHZG8ZzpKztqej2MdjuSdR8IfnVOOUEPHcL8Ltxz
qo9epZ7D+OzyH+dlXjxQViBYFovhtjefRM4zEi50s/rZGgpk7nq6oalnnk/lvCno
cKXvsoBm2OJvkmkZ4+CK9pTg9irGfDwtsONoH9Q9pEiRJSRIwn4nPflBGPfOXNGm
kDKptWqUriKGm6c6y774CEexk2NmloIHUoko2TqbNEsOa87D5BZkapqE1t/cKfQD
QDlugyL8u5khQopXKYCLdWuybCSRBQQcUVW+4ZWynN3yL/y8V9J2EGVErQ6v60H4
OoJu70KU0DTETZSuXpGg
=Fa2k
-----END PGP SIGNATURE-----

--FFoLq8A0u+X9iRU8--
