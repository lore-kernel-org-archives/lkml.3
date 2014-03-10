Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752632AbaCJEdj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 00:33:39 -0400
Received: from mga14.intel.com ([143.182.124.37]:36193 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751560AbaCJEdh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 00:33:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,622,1389772800"; 
   d="scan'208";a="416771512"
Date: Mon, 10 Mar 2014 10:03:29 +0530
From: Jenny Tc <jenny.tc@intel.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: linux-kernel@vger.kernel.org,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        Anton Vorontsov <cbouatmailru@gmail.com>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Kim Milo <Milo.Kim@ti.com>, Lee Jones <lee.jones@linaro.org>,
        Jingoo Han <jg1.han@samsung.com>, Chanwoo Choi <cw00.choi@samsung.com>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
        Rhyland Klein <rklein@nvidia.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        David Woodhouse <dwmw2@infradead.org>,
        Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>,
        Sebastian Reichel <sre@ring0.de>, aaro.koskinen@iki.fi,
        Pallala Ramakrishna <ramakrishna.pallala@intel.com>,
        freemangordon@abv.bg, linux-omap@vger.kernel.org
Subject: Re: [PATCHv8 2/4] power_supply: Introduce generic psy charging driver
Message-ID: <20140310043328.GB27798@jenny-desktop>
References: <1394170174-21959-1-git-send-email-jenny.tc@intel.com>
 <1394170174-21959-3-git-send-email-jenny.tc@intel.com>
 <20140307202520.GD27645@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140307202520.GD27645@amd.pavel.ucw.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 07, 2014 at 09:25:20PM +0100, Pavel Machek wrote:

Hi,

> > The Power Supply charging driver connects multiple subsystems
> > to do charging in a generic way. The subsystems involves power_supply,
> > thermal and battery communication subsystems (1wire).With this the charging is
> > handled in a generic way.
> 
> " " after ".", please.

Will fix in next patch set

> > +
> > +The Power Supply charging driver connects multiple subsystems
> > +to do charging in a generic way. The subsystems involves power_supply,
> > +thermal and battery communication subsystems (1wire).With this the charging is
> 
> Here too.

Same here
> 
> 
> 
> > +
> > +The driver introduces different new features - Battery Identification
> > +interfaces, pluggable charging algorithms, charger cable arbitrations etc.
> > +
> > +In existing driver implementations the charging is done based on the static
> > +battery characteristics. This is done at the boot time by passing the battery
> > +properties (max_voltage, capacity) etc. as a platform data to the
> 
> -> (max_voltage, capacity, etc.)

Same here
> 
> > --- a/drivers/power/Kconfig
> > +++ b/drivers/power/Kconfig
> > @@ -14,6 +14,14 @@ config POWER_SUPPLY_DEBUG
> >  	  Say Y here to enable debugging messages for power supply class
> >  	  and drivers.
> >  
> > +config POWER_SUPPLY_CHARGER
> > +	bool "Power Supply Charger"
> > +	help
> > +	  Say Y here to enable the power supply charging control driver. Charging
> > +	  control supports charging in a generic way. This allows the charger
> > +	  drivers to keep the charging logic outside and the charger driver
> > +	  just need to abstract the charger hardware.
> > +
> 
> Umm. This is not too helpful for our users.

Will add more text to help users.
> 
> > +struct psy_charger_context {
> > +	bool is_usb_cable_evt_reg;
> > +	int psyc_cnt;
> > +	int batt_status;
> > +	/* cache battery and charger properties */
> > +	struct list_head chrgr_cache_lst;
> > +	struct list_head batt_cache_lst;
> > +	struct mutex event_lock;
> > +	struct list_head event_queue;
> > +	struct psy_batt_chrg_prof batt_property;
> > +	wait_queue_head_t wait_chrg_enable;
> > +	spinlock_t battid_spinlock;
> > +	spinlock_t event_queue_lock;
> > +	struct work_struct event_work;
> > +};
> > +
> > +struct charger_cable {
> > +	struct psy_cable_props cable_props;
> > +	enum psy_charger_cable_type psy_cable_type;
> > +};
> > +
> > +static struct psy_charger_context psy_chrgr;
> 
> You still miss some wovels here. Sometimes it imakes it unlear: 
> chrg is charge? charger?

chrgr means charger, chrg means charge. Isn't it used consistently?. Can fix it if
it's really annoying. Please suggest.
> 
> 
> > +static inline bool psy_is_charger_prop_changed(struct psy_charger_props prop,
> > +		struct psy_charger_props cache_prop)
> > +{
> > +	/* if online/prsent/health/is_charging is changed, then return true */
> 
> Typo - present.

Will fix in next patch set
> 
> > +static inline void cache_chrgr_prop(struct psy_charger_props *chrgr_prop_new)
> > +{
> > +	struct psy_charger_props *chrgr_cache;
> > +
> > +	list_for_each_entry(chrgr_cache, &psy_chrgr.chrgr_cache_lst, node) {
> > +		if (!strcmp(chrgr_cache->name, chrgr_prop_new->name))
> > +			goto update_props;
> > +	}
> 
> Interesting use of goto. Maybe update_properties should be separate function?

I feel, having a function just for few assignments may not be a good idea.
What about having memcpy?
> 
> > +update_props:
> > +	chrgr_cache->is_charging = chrgr_prop_new->is_charging;
> > +	chrgr_cache->online = chrgr_prop_new->online;
> > +	chrgr_cache->health = chrgr_prop_new->health;
> > +	chrgr_cache->present = chrgr_prop_new->present;
> > +	chrgr_cache->cable = chrgr_prop_new->cable;
> > +	chrgr_cache->tstamp = chrgr_prop_new->tstamp;
> > +	chrgr_cache->psyc = chrgr_prop_new->psyc;
> > +}
> > +
> > +	chrgr_prop.psyc = chrgr_prop_cache.psyc;
> > +	cache_chrgr_prop(&chrgr_prop);
> > +	return true;
> > +}
> > +static void cache_successive_samples(long *sample_array, long new_sample)
> > +{
> 
> Add empty line between the functions.

Ok..Will fix in next patch set
> 
> > +static inline void cache_bat_prop(struct psy_batt_props *bat_prop_new)
> > +{
> > +	struct psy_batt_props *bat_cache;
> > +
> > +	/*
> > +	*  Find entry in cache list. If an entry is located update
> > +	*  the existing entry else create new entry in the list
> > +	*/
> > +	list_for_each_entry(bat_cache, &psy_chrgr.batt_cache_lst, node) {
> > +		if (!strcmp(bat_cache->name, bat_prop_new->name))
> > +			goto update_props;
> > +	}
> > +
> > +	bat_cache = kzalloc(sizeof(*bat_cache), GFP_KERNEL);
> 
> What is it with all the caching? Is it good idea to have caches
> indexed by strings? Can't you go without caching, or attach caches to
> some structure? Interesting goto again.

Cache is to store previous battery properties. On receiving a new event
compare the properties with cached value to decide charging state
(charging/not charging/full etc.) and to control charging. There is added
saving with caching. If the previous and current battery properties  doesn't
differ much, ignore the event instead of continuing (as implemented in
is_trigger_charging_algo) with invoking charging algorithms. Also caching helps
to take few critical charging decisions - like charge termination which need
charge current and voltage over a period of time.

Since a power_supply object (driver) is identified by name, it's the only index
available.

goto can be fixed by a memcpy, but just wanted to keep the assignments to make
it more meaningful than having a dumb copy.

> 
> > +static inline void get_cur_bat_prop(struct power_supply *psy,
> > +				    struct psy_batt_props *bat_prop)
> > +{
> > +	struct psy_batt_props bat_prop_cache;
> > +	int ret;
> > +
> > +	bat_prop->name = psy->name;
> > +	bat_prop->voltage_now = PSY_VOLTAGE_OCV(psy) / 1000;
> 
> Not sure what OCV means...

Open Circuit voltage which is a standard battery property and is defined in
power_supply.h
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
> 
> You can do it on one line, right?

Agreed. Will fix it in next patch set

> 
> > +		if (psb && !psb->external_power_changed)
> > +			is_pwr_changed_defined &= false;
> 
> WTF?

The is_supplied_to_has_ext_pwr_changed() return true if any of the power_supply
objects in supplied_to list has the external_power_changed() call back defined.
This to  optimize the notifications and to reduce charging algo invocations.
This is used in is_trigger_charging_algo() to decide charging algorithms should
be invoked or not.
> 
> > +static int get_supplied_by_list(struct power_supply *psy,
> > +				struct power_supply *psy_lst[])
> > +{
> > +	struct class_dev_iter iter;
> > +	struct device *dev;
> > +	struct power_supply *pst;
> > +	int cnt = 0, i, j;
> > +
> > +	if (!psy_is_battery(psy))
> > +		return 0;
> > +
> > +	/* Identify chargers which are supplying power to the battery */
> > +	class_dev_iter_init(&iter, power_supply_class, NULL, NULL);
> > +	while ((dev = class_dev_iter_next(&iter))) {
> > +		pst = (struct power_supply *)dev_get_drvdata(dev);
> > +		if (!psy_is_charger(pst))
> > +			continue;
> > +		for (i = 0; i < pst->num_supplicants; i++) {
> > +			if (!strcmp(pst->supplied_to[i], psy->name))
> > +				psy_lst[cnt++] = pst;
> > +		}
> 
> Awful lot of string compares around.

In reality this would be one/two, just because the number of chargers supplying
power to a battery would be limited.

> 
> 
> > +	/* sort based on priority. 0 has the highest priority  */
> > +	for (i = 0; i < cnt; ++i)
> > +		for (j = 0; j < cnt; ++j)
> > +			if (psy_prioirty(psy_lst[j]) > psy_prioirty(psy_lst[i]))
> > +				swap(psy_lst[j], psy_lst[i]);
> > +
> 
> WTF? Bubble sort in kernel?

Yes, it's bubble sort. Since the number of power supply objects in real systems
(max 4) are limited, I feel the complexity would be as same as any other
sorting algorithms. Any suggestions?
> 
> priority is misspelled...

Will fix it in next patch set.
> 
> Does it really be so complex? Dynamically allocated caches, name
> compares everywhere?

It's really not so complex. The caches are allocated dynamically only when
a new charger/battery power supply object gets registered - basically when a
charger/battery driver gets loaded. At runtime no dynamic allocation is needed.
There is not too many string comparisons just because the number of power
supply objects are limited. Power supply subsystem has only name as unique
identifier (psy->name). I couldn't find a better way without string comparisons
to identify a power supply object.

Thanks
Jenny

