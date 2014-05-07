Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932225AbaEGIrD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 04:47:03 -0400
Received: from mga02.intel.com ([134.134.136.20]:25096 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755104AbaEGIrA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 04:47:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,1001,1389772800"; 
   d="scan'208";a="507511507"
Date: Wed, 7 May 2014 14:16:55 +0530
From: Jenny Tc <jenny.tc@intel.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: linux-kernel@vger.kernel.org, dbaryshkov@gmail.com, cbouatmailru@gmail.com,
        anton.vorontsov@linaro.org, tony@atomide.com,
        linux-omap@vger.kernel.org
Subject: Re: [jenny.tc@intel.com: [RFC] power_supply: Introduce generic psy
 charging driver]
Message-ID: <20140507084655.GA25243@jenny-desktop>
References: <20140429062526.GA12879@jenny-desktop>
 <20140505124745.GC16461@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140505124745.GC16461@amd.pavel.ucw.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > +static struct charger_cable cable_list[] = {
> > +	{
> > +	 .psy_cable_type = PSY_CHARGER_CABLE_TYPE_USB_SDP,
> > +	 },
> > +	{
> > +	 .psy_cable_type = PSY_CHARGER_CABLE_TYPE_USB_CDP,
> > +	 },
> > +	{
> > +	 .psy_cable_type = PSY_CHARGER_CABLE_TYPE_USB_DCP,
> > +	 },
> > +	{
> > +	 .psy_cable_type = PSY_CHARGER_CABLE_TYPE_USB_ACA,
> > +	 },
> > +	{
> > +	 .psy_cable_type = PSY_CHARGER_CABLE_TYPE_ACA_DOCK,
> > +	 },
> > +	{
> > +	 .psy_cable_type = PSY_CHARGER_CABLE_TYPE_SE1,
> > +	 },
> > +	{
> > +	 .psy_cable_type = PSY_CHARGER_CABLE_TYPE_AC,
> > +	 },
> > +};
> 
> Can we get rid of this?

Agreed, can initialize it runtime.

> > +	for (i = 0; i < psy->num_supplicants; i++) {
> > +		charger_context->supplied_to_psy[cnt++] =
> > +			power_supply_get_by_name(psy->supplied_to[i]);
> > +		charger_context->supplied_to_psy[cnt] = NULL;
> > +	}
> > +}
> 
> Still some name lookups to be killed.

The look up is only once, when the charger/battery driver is registered.
The supplied_to is defined as character pointer in struct power_supply.

char **supplied_to;
size_t num_supplicants;

This allows the drivers to define the supplied_to argument even if the
supplied_to driver is loaded at later stage. So the name lookup cannot be
avoided. But it is optimized to do lookup only once
> 
> > +		for (i = 0; i < pst->num_supplicants; i++) {
> > +			psb = power_supply_get_by_name(pst->supplied_to[i]);
> > +			if (psb == psy) {
> > +				batt_context->supplied_by_psy[cnt++] = pst;
> > +				batt_context->supplied_by_psy[cnt] = NULL;
> > +				break;
> > +			}
> > +		}
> > +	}
> 
> And here.

Same here
> > +	charger_context = (struct psy_charger_context *)psy->data;
> 
> > +static inline bool is_supplied_to_has_ext_pwr_changed(struct power_supply *psy)
> > +{
> > +	int i;
> > +	struct power_supply *psb;
> > +	bool is_pwr_changed_defined = true;
> > +
> > +	for (i = 0; i < psy->num_supplicants; i++) {
> > +		psb =
> > +		    power_supply_get_by_name(psy->
> > +					     supplied_to[i]);
> > +		if (psb && !psb->external_power_changed)
> > +			is_pwr_changed_defined &= false;
> > +	}
> 
> You did not really get rid of the name lookups..

This lookup can be removed
> > +#define PSY_MAX_CV(psy) \
> > +		psy_get_ps_int_property(psy,\
> > +			POWER_SUPPLY_PROP_CONSTANT_CHARGE_VOLTAGE_MAX)
> > +#define PSY_VOLTAGE_NOW(psy) \
> > +		psy_get_ps_int_property(psy, POWER_SUPPLY_PROP_VOLTAGE_NOW)
> > +#define PSY_VOLTAGE_OCV(psy) \
> > +		psy_get_ps_int_property(psy, POWER_SUPPLY_PROP_VOLTAGE_OCV)
> > +#define PSY_CURRENT_NOW(psy) \
> > +		psy_get_ps_int_property(psy, POWER_SUPPLY_PROP_CURRENT_NOW)
> > +#define PSY_STATUS(psy) \
> > +		psy_get_ps_int_property(psy, POWER_SUPPLY_PROP_STATUS)
> > +#define PSY_TEMPERATURE(psy) \
> > +		psy_get_ps_int_property(psy, POWER_SUPPLY_PROP_TEMP)
> > +#define PSY_BATTERY_TYPE(psy) \
> > +		psy_get_ps_int_property(psy, POWER_SUPPLY_PROP_TECHNOLOGY)
> > +#define PSY_ONLINE(psy) \
> > +		psy_get_ps_int_property(psy, POWER_SUPPLY_PROP_ONLINE)
> 
> This looks like bad idea. Just opencode it.

This was to make it more readable, and avoids open codes in multiple places.
Initially Anton had positive thoughts about this. Isn't it more readable with
the macros?


