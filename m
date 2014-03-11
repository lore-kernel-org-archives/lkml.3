Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754545AbaCKIr0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 04:47:26 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:47040 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753216AbaCKIrV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 04:47:21 -0400
Date: Tue, 11 Mar 2014 09:47:18 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Jenny Tc <jenny.tc@intel.com>
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
Subject: Re: [PATCHv8 2/4] power_supply: Introduce generic psy charging
 driver
Message-ID: <20140311084718.GA10586@amd.pavel.ucw.cz>
References: <1394170174-21959-1-git-send-email-jenny.tc@intel.com>
 <1394170174-21959-3-git-send-email-jenny.tc@intel.com>
 <20140307202520.GD27645@amd.pavel.ucw.cz>
 <20140310043328.GB27798@jenny-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140310043328.GB27798@jenny-desktop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!


> > You still miss some wovels here. Sometimes it imakes it unlear: 
> > chrg is charge? charger?
> 
> chrgr means charger, chrg means charge. Isn't it used consistently?. Can fix it if
> it's really annoying. Please suggest.

Well... with all the missing letters, it is not clear if letter is
missing because you just made it short, or it is real difference.

Please just use full words. ... but read below.

> > > +	list_for_each_entry(bat_cache, &psy_chrgr.batt_cache_lst, node) {
> > > +		if (!strcmp(bat_cache->name, bat_prop_new->name))
> > > +			goto update_props;
> > > +	}
> > > +
> > > +	bat_cache = kzalloc(sizeof(*bat_cache), GFP_KERNEL);
> > 
> > What is it with all the caching? Is it good idea to have caches
> > indexed by strings? Can't you go without caching, or attach caches to
> > some structure? Interesting goto again.
> 
> Cache is to store previous battery properties. On receiving a new event
> compare the properties with cached value to decide charging state
> (charging/not charging/full etc.) and to control charging. There is added
> saving with caching. If the previous and current battery properties  doesn't
> differ much, ignore the event instead of continuing (as implemented in
> is_trigger_charging_algo) with invoking charging algorithms. Also caching helps
> to take few critical charging decisions - like charge termination which need
> charge current and voltage over a period of time.
> 
> Since a power_supply object (driver) is identified by name, it's the only index
> available.

Why can't you just use address of struct power_supply? There should be
no need to work with names.

Feel free to extend struct power_supply, wrap it in another struct,
anything.

> > > +		if (psb && !psb->external_power_changed)
> > > +			is_pwr_changed_defined &= false;
> > 
> > WTF?
> 
> The is_supplied_to_has_ext_pwr_changed() return true if any of the power_supply
> objects in supplied_to list has the external_power_changed() call back defined.
> This to  optimize the notifications and to reduce charging algo invocations.
> This is used in is_trigger_charging_algo() to decide charging algorithms should
> be invoked or not.

No, I mean... using "&=" operator in case where plain assignment
should work is evil.

> > > +	/* Identify chargers which are supplying power to the battery */
> > > +	class_dev_iter_init(&iter, power_supply_class, NULL, NULL);
> > > +	while ((dev = class_dev_iter_next(&iter))) {
> > > +		pst = (struct power_supply *)dev_get_drvdata(dev);
> > > +		if (!psy_is_charger(pst))
> > > +			continue;
> > > +		for (i = 0; i < pst->num_supplicants; i++) {
> > > +			if (!strcmp(pst->supplied_to[i], psy->name))
> > > +				psy_lst[cnt++] = pst;
> > > +		}
> > 
> > Awful lot of string compares around.
> 
> In reality this would be one/two, just because the number of chargers supplying
> power to a battery would be limited.

This whole file is nothing but string compares, bubble sorts, and
weird caches.

Please find a way to simplify a design. Rafael works for same company,
can he help?


> > Does it really be so complex? Dynamically allocated caches, name
> > compares everywhere?
> 
> It's really not so complex. The caches are allocated dynamically only when
> a new charger/battery power supply object gets registered - basically when a
> charger/battery driver gets loaded. At runtime no dynamic allocation is needed.
> There is not too many string comparisons just because the number of power
> supply objects are limited. Power supply subsystem has only name as unique
> identifier (psy->name). I couldn't find a better way without string comparisons
> to identify a power supply object.

(void *) psy is also an unique identifier. Plus, you can add new
fields to psy.

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
