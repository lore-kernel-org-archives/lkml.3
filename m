Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751959AbaB0UIG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 15:08:06 -0500
Received: from mail-ob0-f171.google.com ([209.85.214.171]:34701 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751876AbaB0UIC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 15:08:02 -0500
MIME-Version: 1.0
In-Reply-To: <1392875640-29230-3-git-send-email-jenny.tc@intel.com>
References: <1392875640-29230-1-git-send-email-jenny.tc@intel.com>
	<1392875640-29230-3-git-send-email-jenny.tc@intel.com>
Date: Thu, 27 Feb 2014 21:08:01 +0100
Message-ID: <CACRpkdaU44iinj2iDNdYm62J+4jQbg+XJ=Zq4GmJryPeu7GfTQ@mail.gmail.com>
Subject: Re: [PATCH 2/4] power_supply: Introduce generic psy charging driver
From: Linus Walleij <linus.walleij@linaro.org>
To: Jenny TC <jenny.tc@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        Anton Vorontsov <cbouatmailru@gmail.com>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Kim Milo <Milo.Kim@ti.com>, Lee Jones <lee.jones@linaro.org>,
        Jingoo Han <jg1.han@samsung.com>, Chanwoo Choi <cw00.choi@samsung.com>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Lars-Peter Clausen <lars@metafoo.de>,
        =?ISO-8859-1?Q?Pali_Roh=E1r?= <pali.rohar@gmail.com>,
        Rhyland Klein <rklein@nvidia.com>, Pavel Machek <pavel@ucw.cz>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        David Woodhouse <dwmw2@infradead.org>,
        Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>,
        Sebastian Reichel <sre@ring0.de>, Aaro Koskinen <aaro.koskinen@iki.fi>,
        Pallala Ramakrishna <ramakrishna.pallala@intel.com>,
        =?windows-1251?B?yOLg6evuIMTo7Ojy8O7i?= <freemangordon@abv.bg>,
        Linux-OMAP <linux-omap@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 20, 2014 at 6:53 AM, Jenny TC <jenny.tc@intel.com> wrote:

> +++ b/include/linux/power/power_supply_charger.h

> +#define MAX_CUR_VOLT_SAMPLES 3
> +#define DEF_CUR_VOLT_SAMPLE_JIFF (30*HZ)

Why are things defined in Jiffies like this insead of seconds, milliseconds
etc? This will vary with the current operating frequency of the system,
why should physical measurements do that?

> +/*
> +* Define a TTL for some properties to optimize the frequency of
> +* algorithm calls. This can be used by properties which will be changed
> +* very frequently (e.g. Current, Voltage..)
> +*/
> +#define PROP_TTL (HZ*10)

Same comment.

> +enum psy_charger_cable_event {
> +       PSY_CHARGER_CABLE_EVENT_DISCONNECT = 0,
> +       PSY_CHARGER_CABLE_EVENT_CONNECT,
> +       PSY_CHARGER_CABLE_EVENT_UPDATE,
> +       PSY_CHARGER_CABLE_EVENT_RESUME,
> +       PSY_CHARGER_CABLE_EVENT_SUSPEND,
> +};
> +
> +enum psy_charger_cable_type {
> +       PSY_CHARGER_CABLE_TYPE_NONE = 0,
> +       PSY_CHARGER_CABLE_TYPE_USB_SDP = 1 << 0,
> +       PSY_CHARGER_CABLE_TYPE_USB_DCP = 1 << 1,
> +       PSY_CHARGER_CABLE_TYPE_USB_CDP = 1 << 2,
> +       PSY_CHARGER_CABLE_TYPE_USB_ACA = 1 << 3,
> +       PSY_CHARGER_CABLE_TYPE_AC = 1 << 4,
> +       PSY_CHARGER_CABLE_TYPE_ACA_DOCK = 1 << 5,
> +       PSY_CHARGER_CABLE_TYPE_ACA_A = 1 << 6,
> +       PSY_CHARGER_CABLE_TYPE_ACA_B = 1 << 7,
> +       PSY_CHARGER_CABLE_TYPE_ACA_C = 1 << 8,
> +       PSY_CHARGER_CABLE_TYPE_SE1 = 1 << 9,
> +       PSY_CHARGER_CABLE_TYPE_MHL = 1 << 10,
> +       PSY_CHARGER_CABLE_TYPE_B_DEVICE = 1 << 11,
> +};

Why is this even an enum? It is clearly bitfields. I would just:

#include <linux/bitops.h>

#define PSY_CHARGER_CABLE_TYPE_NONE 0x0
#define PSY_CHARGER_CABLE_TYPE_USB_SDP BIT(0)
#define PSY_CHARGER_CABLE_TYPE_USB_DCP BIT(1)
(etc)

> +enum {
> + POWER_SUPPLY_BATTERY_REMOVED = 0,
> + POWER_SUPPLY_BATTERY_INSERTED,
> +};

Why is this enum anonymous? Does that mean the code just
casts the enum to an int?

> +
> +struct psy_cable_props {
> +       enum psy_charger_cable_event    chrg_evt;
> +       enum psy_charger_cable_type     chrg_type;
> +       unsigned int                    mA;     /* input current limit */

You are naming a struct member after a unit, can it not
be given a better name like "current_limit" and write in the
kerneldoc (not a comment) that it is stated in mA?

(...)
> +struct psy_batt_props {
> +       struct list_head node;
> +       const char *name;
> +       long voltage_now; /* mV */
> +       long voltage_now_cache[MAX_CUR_VOLT_SAMPLES]; /* mV */
> +       long current_now; /* mA */
> +       long current_now_cache[MAX_CUR_VOLT_SAMPLES]; /* mV */
> +       int temperature; /* Degree Celsius */
> +       long status; /* POWER_SUPPLY_STATUS_* */

I don't understand these comments... Do you mean you are
using the enums from <linux/power_supply.h>?

Would it not be better to give those enums a real name
(as a separate patch) and then use:

enum power_supply_status status;

here? That would be helpful methinks.

> +       unsigned long long tstamp;
> +       enum psy_algo_stat algo_stat;
> +       int health; /* POWER_SUPPLY_HEALTH_* */

Same thing.

> +struct psy_charger_props {
> +       struct list_head node;
> +       struct power_supply_charger *psyc;
> +       const char *name;
> +       bool present;
> +       bool is_charging;
> +       int health; /* POWER_SUPPLY_HEALTH_* */

Same thing.

> +       bool online;
> +       unsigned long cable;
> +       unsigned long tstamp;
> +};

Kerneldoc this struct...

> +
> +struct psy_batt_thresholds {
> +       int temp_min; /* Degree Celsius */
> +       int temp_max; /* Degree Celsius */
> +       unsigned int iterm; /* mA */
> +};

Kerneldoc this struct.

> +struct power_supply_charger {
> +       struct power_supply *psy;
> +       struct psy_throttle_state *throttle_states;
> +       size_t num_throttle_states;
> +       unsigned long supported_cables;
> +       int (*get_property)(struct power_supply_charger *psyc,
> +                           enum power_supply_charger_property psp,
> +                           union power_supply_propval *val);
> +       int (*set_property)(struct power_supply_charger *psyc,
> +                           enum power_supply_charger_property psp,
> +                           const union power_supply_propval *val);
> +       int (*property_is_writeable)(struct power_supply_charger *psyc,
> +                                    enum power_supply_charger_property psp);
> +};

Kerneldoc this vtable struct.

> +struct psy_charging_algo {
> +       struct list_head node;
> +       unsigned int chrg_prof_type;
> +       char *name;
> +       enum psy_algo_stat (*get_next_cc_cv)(struct psy_batt_props,
> +                       struct psy_batt_chrg_prof, unsigned long *cc,
> +                       unsigned long *cv);
> +       int (*get_batt_thresholds)(struct psy_batt_chrg_prof,
> +                       struct psy_batt_thresholds *bat_thr);
> +};

And this.

> +/* power_supply_charger functions */
> +
> +#ifdef CONFIG_POWER_SUPPLY_CHARGER
> +
> +extern int power_supply_register_charger(struct power_supply_charger *psyc);
> +extern int power_supply_unregister_charger(struct power_supply_charger *psyc);
> +extern int power_supply_register_charging_algo(struct psy_charging_algo *);
> +extern int power_supply_unregister_charging_algo(struct psy_charging_algo *);
> +extern int psy_get_battery_prop(struct psy_batt_chrg_prof *batt_prop);
> +extern void psy_battery_prop_changed(int battery_conn_stat,
> +                               struct psy_batt_chrg_prof *batt_prop);
> +
> +#else
> +
> +static int power_supply_register_charger(struct power_supply_charger *psyc)
> +{ return 0; }
> +static  int power_supply_unregister_charger(struct power_supply_charger *psyc)
> +{ return 0; }
> +static int power_supply_register_charging_algo(struct psy_charging_algo *algo)
> +{ return 0; }
> +static int power_supply_unregister_charging_algo(struct psy_charging_algo *algo)
> +{ return 0; }

Why do these return 0? Should they not just fail if the power supply
charger support is not compiled in, like return -EINVAL etc?

Sorry for just making some random review of the header files, but
this caught my attention and I couldn't resist.

Yours,
Linus Walleij
