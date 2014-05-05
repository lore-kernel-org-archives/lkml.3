Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932666AbaEEMrt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 08:47:49 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:33651 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932245AbaEEMrr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 08:47:47 -0400
Date: Mon, 5 May 2014 14:47:45 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Jenny Tc <jenny.tc@intel.com>, linux-kernel@vger.kernel.org,
        dbaryshkov@gmail.com, cbouatmailru@gmail.com,
        anton.vorontsov@linaro.org, tony@atomide.com,
        linux-omap@vger.kernel.org
Subject: Re: [jenny.tc@intel.com: [RFC] power_supply: Introduce generic psy
 charging driver]
Message-ID: <20140505124745.GC16461@amd.pavel.ucw.cz>
References: <20140429062526.GA12879@jenny-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140429062526.GA12879@jenny-desktop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

(Only part of original cc-list preserved.)

> RFC: Fixed comments for patch v8, removed sorting and string comparisons

Ok, its better now.

> The Power Supply charging driver connects multiple subsystems
> to do charging in a generic way. The subsystems involves power_supply,
> thermal and battery communication subsystems (1wire).With this the charging is
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
> ---
>  Documentation/power/power_supply_charger.txt |  350 +++++++++
>  drivers/power/Kconfig                        |    8 +
>  drivers/power/Makefile                       |    1 +
>  drivers/power/power_supply_charger.c         | 1066 ++++++++++++++++++++++++++
>  drivers/power/power_supply_charger.h         |  226 ++++++
>  drivers/power/power_supply_core.c            |    3 +
>  include/linux/power/power_supply_charger.h   |  304 ++++++++
>  include/linux/power_supply.h                 |  161 ++++
>  8 files changed, 2119 insertions(+)
>  create mode 100644 Documentation/power/power_supply_charger.txt
>  create mode 100644 drivers/power/power_supply_charger.c
>  create mode 100644 drivers/power/power_supply_charger.h
>  create mode 100644 include/linux/power/power_supply_charger.h
> 
> diff --git a/Documentation/power/power_supply_charger.txt b/Documentation/power/power_supply_charger.txt
> new file mode 100644
> index 0000000..1bb8cb4
> --- /dev/null
> +++ b/Documentation/power/power_supply_charger.txt
> @@ -0,0 +1,350 @@
> +1. Introduction
> +===============
> +
> +The Power Supply charging driver connects multiple subsystems
> +to do charging in a generic way. The subsystems involves power_supply,
> +thermal and battery communication subsystems (1wire).With this the charging is

Space after '.'.

> +static struct charger_cable cable_list[] = {
> +	{
> +	 .psy_cable_type = PSY_CHARGER_CABLE_TYPE_USB_SDP,
> +	 },
> +	{
> +	 .psy_cable_type = PSY_CHARGER_CABLE_TYPE_USB_CDP,
> +	 },
> +	{
> +	 .psy_cable_type = PSY_CHARGER_CABLE_TYPE_USB_DCP,
> +	 },
> +	{
> +	 .psy_cable_type = PSY_CHARGER_CABLE_TYPE_USB_ACA,
> +	 },
> +	{
> +	 .psy_cable_type = PSY_CHARGER_CABLE_TYPE_ACA_DOCK,
> +	 },
> +	{
> +	 .psy_cable_type = PSY_CHARGER_CABLE_TYPE_SE1,
> +	 },
> +	{
> +	 .psy_cable_type = PSY_CHARGER_CABLE_TYPE_AC,
> +	 },
> +};

Can we get rid of this?

> +struct usb_phy *otg_xceiver;
> +static int handle_event_notification(struct notifier_block *nb,
> +				   unsigned long event, void *data);
> +struct notifier_block nb = {
> +		   .notifier_call = handle_event_notification,
> +		};

You need to add way more statics.



> +static void update_supplied_to_psy(struct power_supply *psy)
> +{
> +	WARN_ON(charger_context == NULL);

Useless.

> +	for (i = 0; i < psy->num_supplicants; i++) {
> +		charger_context->supplied_to_psy[cnt++] =
> +			power_supply_get_by_name(psy->supplied_to[i]);
> +		charger_context->supplied_to_psy[cnt] = NULL;
> +	}
> +}

Still some name lookups to be killed.

> +		for (i = 0; i < pst->num_supplicants; i++) {
> +			psb = power_supply_get_by_name(pst->supplied_to[i]);
> +			if (psb == psy) {
> +				batt_context->supplied_by_psy[cnt++] = pst;
> +				batt_context->supplied_by_psy[cnt] = NULL;
> +				break;
> +			}
> +		}
> +	}

And here.

> +	WARN_ON(psy->data == NULL);

Useless.

> +	charger_context = (struct psy_charger_context *)psy->data;

> +static inline bool is_supplied_to_has_ext_pwr_changed(struct power_supply *psy)
> +{
> +	int i;
> +	struct power_supply *psb;
> +	bool is_pwr_changed_defined = true;
> +
> +	for (i = 0; i < psy->num_supplicants; i++) {
> +		psb =
> +		    power_supply_get_by_name(psy->
> +					     supplied_to[i]);
> +		if (psb && !psb->external_power_changed)
> +			is_pwr_changed_defined &= false;
> +	}

You did not really get rid of the name lookups..

&= false. Bad idea.


> +static int trigger_algo(struct power_supply *psy)
> +{
> +	unsigned long cc = 0, cv = 0, cc_min;
> +	struct psy_batt_context *batt_context;
> +	struct psy_charging_algo *algo;
> +	struct psy_batt_chrg_prof chrg_profile;
> +	struct power_supply *psc;
> +	int cnt = 0;
> +
> +	if (psy->type != POWER_SUPPLY_TYPE_BATTERY)
> +		return 0;
> +
> +	if (psy_get_battery_prop(&chrg_profile)) {
> +		pr_err("Error in getting charge profile:%s:%d\n", __FILE__,
> +		       __LINE__);
> +		return -EINVAL;
> +	}
> +
> +	batt_context = (struct psy_batt_context *)psy->data;

Create inline function doing the cast. You have too many opencoded
casts.

> +	batt_context->algo_stat = algo->get_next_cc_cv
> +		(&batt_context->batt_props, chrg_profile, &cc, &cv);
> +static inline void enable_supplied_by_charging
> +		(struct power_supply *psy, bool is_enable)

This is not how you indent that, is it.

> +static void __power_supply_trigger_charging_handler(struct power_supply *psy)
> +{
> +	int i;
> +	struct power_supply *psb = NULL;
> +
> +	if (!is_trigger_charging_algo(psy))
> +		return;
> +
> +	if (psy_is_battery(psy)) {
> +		if (trigger_algo(psy))
> +			enable_supplied_by_charging(psy, false);
> +		else
> +			enable_supplied_by_charging(psy, true);

enable...(psy, trigger_algo())



> +static inline int psy_throttle_cc_value
> +		(struct power_supply *psy, unsigned int state)

Indent.


> +#define PSY_MAX_CV(psy) \
> +		psy_get_ps_int_property(psy,\
> +			POWER_SUPPLY_PROP_CONSTANT_CHARGE_VOLTAGE_MAX)
> +#define PSY_VOLTAGE_NOW(psy) \
> +		psy_get_ps_int_property(psy, POWER_SUPPLY_PROP_VOLTAGE_NOW)
> +#define PSY_VOLTAGE_OCV(psy) \
> +		psy_get_ps_int_property(psy, POWER_SUPPLY_PROP_VOLTAGE_OCV)
> +#define PSY_CURRENT_NOW(psy) \
> +		psy_get_ps_int_property(psy, POWER_SUPPLY_PROP_CURRENT_NOW)
> +#define PSY_STATUS(psy) \
> +		psy_get_ps_int_property(psy, POWER_SUPPLY_PROP_STATUS)
> +#define PSY_TEMPERATURE(psy) \
> +		psy_get_ps_int_property(psy, POWER_SUPPLY_PROP_TEMP)
> +#define PSY_BATTERY_TYPE(psy) \
> +		psy_get_ps_int_property(psy, POWER_SUPPLY_PROP_TECHNOLOGY)
> +#define PSY_ONLINE(psy) \
> +		psy_get_ps_int_property(psy, POWER_SUPPLY_PROP_ONLINE)

This looks like bad idea. Just opencode it.

s/return  /return /g

Thanks,
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
