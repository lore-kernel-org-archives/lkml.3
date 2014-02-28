Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751453AbaB1E2F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 23:28:05 -0500
Received: from mga11.intel.com ([192.55.52.93]:38021 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750957AbaB1E2D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 23:28:03 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,559,1389772800"; 
   d="scan'208";a="489675902"
Date: Fri, 28 Feb 2014 09:57:53 +0530
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
Subject: Re: [PATCH 2/4] power_supply: Introduce generic psy charging driver
Message-ID: <20140228042753.GC27921@jenny-desktop>
References: <1392875640-29230-1-git-send-email-jenny.tc@intel.com>
 <1392875640-29230-3-git-send-email-jenny.tc@intel.com>
 <CACRpkdaU44iinj2iDNdYm62J+4jQbg+XJ=Zq4GmJryPeu7GfTQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdaU44iinj2iDNdYm62J+4jQbg+XJ=Zq4GmJryPeu7GfTQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 27, 2014 at 09:08:01PM +0100, Linus Walleij wrote:
> On Thu, Feb 20, 2014 at 6:53 AM, Jenny TC <jenny.tc@intel.com> wrote:
> 
> > +++ b/include/linux/power/power_supply_charger.h
> 
> > +#define MAX_CUR_VOLT_SAMPLES 3
> > +#define DEF_CUR_VOLT_SAMPLE_JIFF (30*HZ)
> 
> Why are things defined in Jiffies like this insead of seconds, milliseconds
> etc? This will vary with the current operating frequency of the system,
> why should physical measurements do that?

Is it fine if I use msecs_to_jiffies(30000)?

> > +enum psy_charger_cable_event {
> > +       PSY_CHARGER_CABLE_EVENT_DISCONNECT = 0,
> > +       PSY_CHARGER_CABLE_EVENT_CONNECT,
> > +       PSY_CHARGER_CABLE_EVENT_UPDATE,
> > +       PSY_CHARGER_CABLE_EVENT_RESUME,
> > +       PSY_CHARGER_CABLE_EVENT_SUSPEND,
> > +};
> > +
> > +enum psy_charger_cable_type {
> > +       PSY_CHARGER_CABLE_TYPE_NONE = 0,
> > +       PSY_CHARGER_CABLE_TYPE_USB_SDP = 1 << 0,
> > +       PSY_CHARGER_CABLE_TYPE_USB_DCP = 1 << 1,
> > +       PSY_CHARGER_CABLE_TYPE_USB_CDP = 1 << 2,
> > +       PSY_CHARGER_CABLE_TYPE_USB_ACA = 1 << 3,
> > +       PSY_CHARGER_CABLE_TYPE_AC = 1 << 4,
> > +       PSY_CHARGER_CABLE_TYPE_ACA_DOCK = 1 << 5,
> > +       PSY_CHARGER_CABLE_TYPE_ACA_A = 1 << 6,
> > +       PSY_CHARGER_CABLE_TYPE_ACA_B = 1 << 7,
> > +       PSY_CHARGER_CABLE_TYPE_ACA_C = 1 << 8,
> > +       PSY_CHARGER_CABLE_TYPE_SE1 = 1 << 9,
> > +       PSY_CHARGER_CABLE_TYPE_MHL = 1 << 10,
> > +       PSY_CHARGER_CABLE_TYPE_B_DEVICE = 1 << 11,
> > +};
> 
> Why is this even an enum? It is clearly bitfields. I would just:
> 
> #include <linux/bitops.h>
> 
> #define PSY_CHARGER_CABLE_TYPE_NONE 0x0
> #define PSY_CHARGER_CABLE_TYPE_USB_SDP BIT(0)
> #define PSY_CHARGER_CABLE_TYPE_USB_DCP BIT(1)
> (etc)

This is to ensure type checks when the cable types are handled, #defines will
not help in type checks. 

> 
> > +enum {
> > + POWER_SUPPLY_BATTERY_REMOVED = 0,
> > + POWER_SUPPLY_BATTERY_INSERTED,
> > +};
> 
> Why is this enum anonymous? Does that mean the code just
> casts the enum to an int?

OK.I'll name the enum.
> 
> > +
> > +struct psy_cable_props {
> > +       enum psy_charger_cable_event    chrg_evt;
> > +       enum psy_charger_cable_type     chrg_type;
> > +       unsigned int                    mA;     /* input current limit */
> 
> You are naming a struct member after a unit, can it not
> be given a better name like "current_limit" and write in the
> kerneldoc (not a comment) that it is stated in mA?

I'll change the variable name in next patch set.
> > +struct psy_batt_props {
> > +       struct list_head node;
> > +       const char *name;
> > +       long voltage_now; /* mV */
> > +       long voltage_now_cache[MAX_CUR_VOLT_SAMPLES]; /* mV */
> > +       long current_now; /* mA */
> > +       long current_now_cache[MAX_CUR_VOLT_SAMPLES]; /* mV */
> > +       int temperature; /* Degree Celsius */
> > +       long status; /* POWER_SUPPLY_STATUS_* */
> 
> I don't understand these comments... Do you mean you are
> using the enums from <linux/power_supply.h>?
>
> Would it not be better to give those enums a real name
> (as a separate patch) and then use:
> 
> enum power_supply_status status;
> 
> here? That would be helpful methinks.

My intention is to convey that status variable takes values
POWER_SUPPLY_STATUS_*. I'll submit a separate patch to name the enums in
power_supply.h. Also I'll make the appropriate changes in power_supply_charger.h
> > +struct power_supply_charger {
> > +       struct power_supply *psy;
> > +       struct psy_throttle_state *throttle_states;
> > +       size_t num_throttle_states;
> > +       unsigned long supported_cables;
> > +       int (*get_property)(struct power_supply_charger *psyc,
> > +                           enum power_supply_charger_property psp,
> > +                           union power_supply_propval *val);
> > +       int (*set_property)(struct power_supply_charger *psyc,
> > +                           enum power_supply_charger_property psp,
> > +                           const union power_supply_propval *val);
> > +       int (*property_is_writeable)(struct power_supply_charger *psyc,
> > +                                    enum power_supply_charger_property psp);
> > +};
> 
> Kerneldoc this vtable struct.

I'll make the necessary kerneldoc changes as you suggested for this structure
and other structures.
> 
> > +/* power_supply_charger functions */
> > +
> > +#ifdef CONFIG_POWER_SUPPLY_CHARGER
> > +
> > +extern int power_supply_register_charger(struct power_supply_charger *psyc);
> > +extern int power_supply_unregister_charger(struct power_supply_charger *psyc);
> > +extern int power_supply_register_charging_algo(struct psy_charging_algo *);
> > +extern int power_supply_unregister_charging_algo(struct psy_charging_algo *);
> > +extern int psy_get_battery_prop(struct psy_batt_chrg_prof *batt_prop);
> > +extern void psy_battery_prop_changed(int battery_conn_stat,
> > +                               struct psy_batt_chrg_prof *batt_prop);
> > +
> > +#else
> > +
> > +static int power_supply_register_charger(struct power_supply_charger *psyc)
> > +{ return 0; }
> > +static  int power_supply_unregister_charger(struct power_supply_charger *psyc)
> > +{ return 0; }
> > +static int power_supply_register_charging_algo(struct psy_charging_algo *algo)
> > +{ return 0; }
> > +static int power_supply_unregister_charging_algo(struct psy_charging_algo *algo)
> > +{ return 0; }
> 
> Why do these return 0? Should they not just fail if the power supply
> charger support is not compiled in, like return -EINVAL etc?
> 
> Sorry for just making some random review of the header files, but
> this caught my attention and I couldn't resist.

No issues, it make sense to return error instead of 0. Thanks for the comments.

-Jenny
