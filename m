Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752663AbaCGDDF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 22:03:05 -0500
Received: from mail-oa0-f41.google.com ([209.85.219.41]:39036 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751683AbaCGDDD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 22:03:03 -0500
MIME-Version: 1.0
In-Reply-To: <20140228042753.GC27921@jenny-desktop>
References: <1392875640-29230-1-git-send-email-jenny.tc@intel.com>
	<1392875640-29230-3-git-send-email-jenny.tc@intel.com>
	<CACRpkdaU44iinj2iDNdYm62J+4jQbg+XJ=Zq4GmJryPeu7GfTQ@mail.gmail.com>
	<20140228042753.GC27921@jenny-desktop>
Date: Fri, 7 Mar 2014 11:03:02 +0800
Message-ID: <CACRpkdbuCC=-aYmyeaGW0GfkhRU8SEc=1+2f6k3tA7TygiZRJA@mail.gmail.com>
Subject: Re: [PATCH 2/4] power_supply: Introduce generic psy charging driver
From: Linus Walleij <linus.walleij@linaro.org>
To: Jenny Tc <jenny.tc@intel.com>
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

On Fri, Feb 28, 2014 at 12:27 PM, Jenny Tc <jenny.tc@intel.com> wrote:
> On Thu, Feb 27, 2014 at 09:08:01PM +0100, Linus Walleij wrote:
>> On Thu, Feb 20, 2014 at 6:53 AM, Jenny TC <jenny.tc@intel.com> wrote:
>>
>> > +++ b/include/linux/power/power_supply_charger.h
>>
>> > +#define MAX_CUR_VOLT_SAMPLES 3
>> > +#define DEF_CUR_VOLT_SAMPLE_JIFF (30*HZ)
>>
>> Why are things defined in Jiffies like this insead of seconds, milliseconds
>> etc? This will vary with the current operating frequency of the system,
>> why should physical measurements do that?
>
> Is it fine if I use msecs_to_jiffies(30000)?

Keep the
#define DEF_CUR_VOLT_SAMPLE_PERIOD 30000

Then use msecs_to_jiffies(DEF_CUR_VOLT_SAMPLE_PERIOD)
in the call site.

>> > +enum psy_charger_cable_event {
>> > +       PSY_CHARGER_CABLE_EVENT_DISCONNECT = 0,
>> > +       PSY_CHARGER_CABLE_EVENT_CONNECT,
>> > +       PSY_CHARGER_CABLE_EVENT_UPDATE,
>> > +       PSY_CHARGER_CABLE_EVENT_RESUME,
>> > +       PSY_CHARGER_CABLE_EVENT_SUSPEND,
>> > +};
>> > +
>> > +enum psy_charger_cable_type {
>> > +       PSY_CHARGER_CABLE_TYPE_NONE = 0,
>> > +       PSY_CHARGER_CABLE_TYPE_USB_SDP = 1 << 0,
>> > +       PSY_CHARGER_CABLE_TYPE_USB_DCP = 1 << 1,
>> > +       PSY_CHARGER_CABLE_TYPE_USB_CDP = 1 << 2,
>> > +       PSY_CHARGER_CABLE_TYPE_USB_ACA = 1 << 3,
>> > +       PSY_CHARGER_CABLE_TYPE_AC = 1 << 4,
>> > +       PSY_CHARGER_CABLE_TYPE_ACA_DOCK = 1 << 5,
>> > +       PSY_CHARGER_CABLE_TYPE_ACA_A = 1 << 6,
>> > +       PSY_CHARGER_CABLE_TYPE_ACA_B = 1 << 7,
>> > +       PSY_CHARGER_CABLE_TYPE_ACA_C = 1 << 8,
>> > +       PSY_CHARGER_CABLE_TYPE_SE1 = 1 << 9,
>> > +       PSY_CHARGER_CABLE_TYPE_MHL = 1 << 10,
>> > +       PSY_CHARGER_CABLE_TYPE_B_DEVICE = 1 << 11,
>> > +};
>>
>> Why is this even an enum? It is clearly bitfields. I would just:
>>
>> #include <linux/bitops.h>
>>
>> #define PSY_CHARGER_CABLE_TYPE_NONE 0x0
>> #define PSY_CHARGER_CABLE_TYPE_USB_SDP BIT(0)
>> #define PSY_CHARGER_CABLE_TYPE_USB_DCP BIT(1)
>> (etc)
>
> This is to ensure type checks when the cable types are handled, #defines will
> not help in type checks.

Type checks with static code check tools? But misrepresenting
a bitfield as an enum just to satisfy a static code checker is not
OK IMO.

Yours,
Linus Walleij
