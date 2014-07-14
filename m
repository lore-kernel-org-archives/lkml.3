Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755268AbaGNNek (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 09:34:40 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:35341 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755068AbaGNNec (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 09:34:32 -0400
Date: Mon, 14 Jul 2014 15:34:29 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Jenny TC <jenny.tc@intel.com>
Cc: linux-kernel@vger.kernel.org, Sebastian Reichel <sre@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        David Woodhouse <dwmw2@infradead.org>,
        David Cohen <david.a.cohen@linux.intel.com>,
        Pallala Ramakrishna <ramakrishna.pallala@intel.com>
Subject: Re: [PATCH 2/4] power_supply: Introduce generic psy charging driver
Message-ID: <20140714133429.GC18934@amd.pavel.ucw.cz>
References: <1404799461-26345-1-git-send-email-jenny.tc@intel.com>
 <1404799461-26345-3-git-send-email-jenny.tc@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1404799461-26345-3-git-send-email-jenny.tc@intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> The Power Supply charging driver connects multiple subsystems
> to do charging in a generic way. The subsystems involves power_supply,
> thermal and battery communication subsystems (1wire). With this the charging is
> handled in a generic way.
> 
> The driver makes use of different new features - Battery Identification
> interfaces, pluggable charging algorithms, charger cable arbitrations etc.
> The patch also introduces generic interface for charger cable notifications.
> Charger cable events and capabilities can be notified using the generic
> power_supply_notifier chain.
> 
> Overall this driver removes the charging logic out of the charger chip driver
> and the charger chip driver can just listen to the request from the power
> supply charging driver to set the charger properties. This can be implemented
> by exposing get_property and set property callbacks.
> 
> Signed-off-by: Jenny TC <jenny.tc@intel.com>

No, sorry, this still does not look like kernel code.

> +3. Use Charging Driver to setup charging
> +===========================================

I think intention here is to match the lengths?

> +static inline bool psy_is_battery_prop_changed(struct psy_batt_props *bat_prop,
> +		struct psy_batt_props *bat_cache)
> +{
> +	if (!bat_cache)
> +		return true;

Are all these !null checks neccessary? I find them excessive
... especially for debug functions below.

> +static inline bool psy_is_charger_prop_changed(struct psy_charger_props *prop,
> +		struct psy_charger_props *cache_prop)
> +{
> +	/* if online/prsent/health/is_charging is changed, then return true */

typo "present".

> +static int  __update_supplied_psy(struct device *dev, void *data)

Too many spaces before __.

> +	for (i = 0; i < psy->num_supplicants; i++) {
> +		psb = power_supply_get_by_name(psy->supplied_to[i]);
> +		if (!psb)
> +			continue;
> +
> +		if (!psb->data)
> +			psb->data = devm_kzalloc(psb->dev,
> +				sizeof(struct psy_batt_context), GFP_KERNEL);
> +
> +		batt_context = psb->data;
> +		batt_context->supplied_by_psy
> +				[batt_context->num_supplied_by_psy++] = psy;
> +		charger_context->supplied_to_psy
> +				[charger_context->num_supplied_to_psy++] = psb;

Really strange indent.

What ensures you don't write beyond end of array.

And why have arrays at all? Could you simply link the structures
together?

> +static void cache_successive_samples(long *sample_array, long new_sample)
> +{
> +	int i;
> +
> +	for (i = 0; i < MAX_CUR_VOLT_SAMPLES - 1; ++i)
> +		*(sample_array + i) = *(sample_array + i + 1);
> +
> +	*(sample_array + i) = new_sample;
> +}

But this is why I write. Would a ring buffer be faster and more
elegant?

Also we do sample_array[i], not *(sample_array + i).

Oh and we also do i++, not ++i.

> +static int process_cable_props(struct psy_cable_props *cap)
> +{
> +	struct charger_cable *cable = NULL;
> +	unsigned off;

unsigned int.

> +	memcpy((void *)&cable->cable_props, (void *)cap,
> +			sizeof(cable->cable_props));

Are the casts actually neccessary?

Would cable->cable_props = caps work as well?

> +	spin_lock(&psy_chrgr.event_queue_lock);
> +	list_for_each_entry_safe(evt, tmp, &psy_chrgr.event_queue, node) {
> +		list_del(&evt->node);
> +		spin_unlock(&psy_chrgr.event_queue_lock);
> +
> +		mutex_lock(&psy_chrgr.event_lock);
> +
> +		switch (evt->event) {
...
> +		}
> +
> +		mutex_unlock(&psy_chrgr.event_lock);
> +
> +		spin_lock(&psy_chrgr.event_queue_lock);
> +		kfree(evt);
> +	}
> +
> +	spin_unlock(&psy_chrgr.event_queue_lock);
> +}

Are you sure about locking here? Care to drop some comments to help us
understand it?

> +static int register_usb_notifier(void)
> +{
> +	int retval = 0;
> +
> +	otg_xceiver = usb_get_phy(USB_PHY_TYPE_USB2);
> +	if (!otg_xceiver) {
> +		pr_err("failure to get otg transceiver\n");
> +		retval = -EIO;
> +		goto notifier_reg_failed;
> +	}

just do return -EIO here.

> +	retval = usb_register_notifier(otg_xceiver, &nb);
> +	if (retval) {
> +		pr_err("failure to register otg notifier\n");
> +		goto notifier_reg_failed;
> +	}
> +
> +notifier_reg_failed:
> +	return retval;
> +}

Delete goto and label.

> +static inline bool is_trigger_charging_algo(struct power_supply *psy)
> +{
> +	/*
> +	* trigger charging algorithm if battery or
> +	* charger properties are changed. Also no need to
> +	* invoke algorithm for power_supply_changed from
> +	* charger, if all supplied_to has the ext_port_changed defined.
> +	* On invoking the ext_port_changed the supplied to can send
> +	* power_supplied_changed event.
> +	*/
> +
> +	if ((psy_is_charger(psy) && !is_supplied_to_has_ext_pwr_changed(psy)) &&
> +			is_chrgr_prop_changed(psy))
> +		return true;
> +
> +	if ((psy_is_battery(psy)) && (is_batt_prop_changed(psy) ||
> +				is_supplied_by_changed(psy)))
> +		return true;
> +

Begin function with if (!psy_is_charger...) to simplify the rest?

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
> +	batt_context = psy->data;
> +	status = POWER_SUPPLY_STATUS_DISCHARGING;
> +	cnt = batt_context->num_supplied_by_psy;
> +
> +	while (cnt--) {
> +		psc = batt_context->supplied_by_psy[cnt];
> +
> +		if (psy_is_present(psc))
> +			status = POWER_SUPPLY_STATUS_NOT_CHARGING;
> +
> +		if (!(psy_is_charging_can_be_enabled(psc)) ||
> +			(!psy_is_health_good(psy)) ||
> +				(!psy_is_health_good(psc)))
> +			continue;

> +		if ((batt_context->algo_stat == PSY_ALGO_STAT_FULL) ||
> +			(batt_context->algo_stat == PSY_ALGO_STAT_MAINT))
> +				status = POWER_SUPPLY_STATUS_FULL;
> +		else if (psy_is_charging_enabled(psc))
> +				status = POWER_SUPPLY_STATUS_CHARGING;
> +	}
> +
> +	pr_debug("%s: Set status=%d for %s\n", __func__, status, psy->name);
> +
> +	return status;

So if you have two batteries, return value is basically random?


> +static void update_charger_online(struct power_supply *psy)
> +{
> +	int online;
> +	struct psy_charger_context *charger_context;
> +
> +	online = psy_is_charger_enabled(psy) ? 1 : 0;

!!(..)

> +	psy_set_charger_online(psy, online);
> +	charger_context = psy->data;
> +	charger_context->charger_props.online = online;
> +}

Or perhaps online should work with bools, as you use them elsewhere?

> +static inline void wait_for_charging_enabled(struct power_supply *psy)
> +{
> +	wait_event_timeout(psy_chrgr.wait_chrg_enable,
> +			(psy_is_charging_enabled(psy)), HZ);
> +}

Is one second timeout enough?

> +static inline void enable_supplied_by_charging(struct power_supply *psy,
> +					bool is_enable)
> +{
> +	struct power_supply *psc;
> +	struct psy_batt_context *batt_context;
> +	int cnt;
> +
> +	if (!psy_is_battery(psy))
> +		return;
> +	/*
> +	* Get list of chargers supplying power to this battery and
> +	* disable charging for all chargers
> +	*/
> +	batt_context  = psy->data;

two spaces.

> +	cnt = batt_context->num_supplied_by_psy;
> +
> +	while (cnt--) {
> +		psc = batt_context->supplied_by_psy[cnt];
> +		if (!psy_is_present(psc))
> +			continue;
> +		if (is_enable && psy_is_charging_can_be_enabled(psc)) {
> +			psy_enable_charging(psc);
> +			wait_for_charging_enabled(psc);
> +

extra empty line

> +		} else {
> +			psy_disable_charging(psc);
> +		}

Do continue and get rid of else?


> +	if (!is_trigger_charging_algo(psy))
> +		return;
> +
> +	if (psy_is_battery(psy)) {
> +
> +		enable_supplied_by_charging(psy, !trigger_algo(psy));
> +		goto update_sysfs;
> +
> +	}

More extra lines.

Best regards,
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
