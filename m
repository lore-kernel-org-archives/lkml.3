Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752219AbaB1DHs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 22:07:48 -0500
Received: from mga14.intel.com ([143.182.124.37]:47541 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751007AbaB1DHq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 22:07:46 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,559,1389772800"; 
   d="scan'208";a="414440016"
Date: Fri, 28 Feb 2014 08:37:27 +0530
From: Jenny Tc <jenny.tc@intel.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        Anton Vorontsov <cbouatmailru@gmail.com>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Kim Milo <Milo.Kim@ti.com>, Lee Jones <lee.jones@linaro.org>,
        Jingoo Han <jg1.han@samsung.com>, Chanwoo Choi <cw00.choi@samsung.com>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
        Rhyland Klein <rklein@nvidia.com>, Pavel Machek <pavel@ucw.cz>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        David Woodhouse <dwmw2@infradead.org>,
        Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>,
        Sebastian Reichel <sre@ring0.de>, Aaro Koskinen <aaro.koskinen@iki.fi>,
        Pallala Ramakrishna <ramakrishna.pallala@intel.com>,
        =?utf-8?B?0JjQstCw0LnQu9C+INCU0LjQvNC40YLRgNC+0LI=?= 
	<freemangordon@abv.bg>,
        Linux-OMAP <linux-omap@vger.kernel.org>
Subject: Re: [PATCH 3/4] power_supply: Introduce PSE compliant algorithm
Message-ID: <20140228030727.GB27921@jenny-desktop>
References: <1391490780-6141-1-git-send-email-jenny.tc@intel.com>
 <1391490780-6141-4-git-send-email-jenny.tc@intel.com>
 <CACRpkdbppewuSSJu=Y=1T7oOCxz_ynhNspyPT=S894KoUB6H6g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdbppewuSSJu=Y=1T7oOCxz_ynhNspyPT=S894KoUB6H6g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 27, 2014 at 09:18:57PM +0100, Linus Walleij wrote:
> On Tue, Feb 4, 2014 at 6:12 AM, Jenny TC <jenny.tc@intel.com> wrote:
> 
> > +static inline bool __is_battery_full
> > +       (long volt, long cur, long iterm, unsigned long cv)
> 
> Overall I wonder if you've run checkpatch on these patches, but why
> are you naming this one function with a double __underscore?
> Just is_battery_full_check() or something would work fine I guess?

Just to convey that is_battery_full is a local function and not generic. You
can find similar usage in power_supply_core.c (__power_supply_changed_work)
and in other drivers. Isn't it advised to have __ prefixes?
> (...)
> > +/* Parameters defining the charging range */
> > +struct psy_ps_temp_chg_table {
> > +       /* upper temperature limit for each zone */
> > +       short int temp_up_lim; /* Degree Celsius */
> > +
> > +       /* charge current and voltage */
> > +       short int full_chrg_vol; /* mV */
> > +       short int full_chrg_cur; /* mA */
> > +
> > +       /*
> > +       *  Maintenance charging thresholds.
> > +       *  Maintenance charging voltage lower limit - Once battery hits full,
> > +       *  charging will be resumed when battery voltage <= this voltage
> > +       */
> > +       short int maint_chrg_vol_ll; /* mV */
> > +
> > +       /* Charge current and voltage in maintenance charging mode */
> > +       short int maint_chrg_vol_ul; /* mV */
> > +       short int maint_chrg_cur;   /* mA */
> > +} __packed;
> 
> Why are you packing these structs? If no real reason, remove it.
> The compiler will pack what it thinks is appropriate anyway.

The structure is part of the  battery charging profile which can be read directly
from an EEPROM or from secondary storage (emmc). So it should be packed to keep
it align with the stored format.

> > +#define BATTID_STR_LEN         8
> > +#define BATT_TEMP_NR_RNG       6
> > +
> > +struct psy_pse_chrg_prof {
> > +       /* battery id */
> > +       char batt_id[BATTID_STR_LEN];
> > +       u16 battery_type; /* Defined as POWER_SUPPLY_TECHNOLOGY_* */
> 
> Use a named enum by patching that in <linux/power_supply.h>?

This is to convey that battery_type takes value as defined by
POWER_SUPPLY_TECHNOLOGY_*
> 
> > +       u16 capacity;   /* mAh */
> > +       u16 voltage_max; /* mV */
> > +       /* charge termination current */
> > +       u16 chrg_term_mA;
> > +       /* Low battery level voltage */
> > +       u16 low_batt_mV;
> > +       /* upper and lower temperature limits on discharging */
> > +       s8 disch_temp_ul; /* Degree Celsius */
> > +       s8 disch_temp_ll; /* Degree Celsius */
> > +       /* number of temperature monitoring ranges */
> > +       u16 temp_mon_ranges;
> > +       struct psy_ps_temp_chg_table temp_mon_range[BATT_TEMP_NR_RNG];
> > +       /* lowest temperature supported */
> > +       s8 temp_low_lim;
> > +} __packed;
> 
> Why packed, and convert to kerneldoc for this struct.

Battery charging profile, may come from EEPROM/emmc which would be packed.
