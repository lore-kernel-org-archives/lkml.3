Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755628Ab3J1Dgn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Oct 2013 23:36:43 -0400
Received: from mga11.intel.com ([192.55.52.93]:16837 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755597Ab3J1Dgl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Oct 2013 23:36:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,583,1378882800"; 
   d="scan'208";a="423727834"
From: "Tc, Jenny" <jenny.tc@intel.com>
To: Anton Vorontsov <anton@enomsg.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Kim, Milo" <Milo.Kim@ti.com>, Lee Jones <lee.jones@linaro.org>,
        Jingoo Han <jg1.han@samsung.com>, Chanwoo Choi <cw00.choi@samsung.com>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Rupesh Kumar <rupesh.kumar@stericsson.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        =?utf-8?B?UGFsaSBSb2jDoXI=?= <pali.rohar@gmail.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Rhyland Klein <rklein@nvidia.com>
Subject: RE: [PATCH 1/7] power_supply: Add charger control properties
Thread-Topic: [PATCH 1/7] power_supply: Add charger control properties
Thread-Index: AQHOuEUfJHCgpReEJkapo5P+cw6cHZoJEL0AgACWbGA=
Date: Mon, 28 Oct 2013 03:36:36 +0000
Message-ID: <20ADAB092842284E95860F279283C5640AA99A32@BGSMSX104.gar.corp.intel.com>
References: <1379959445-28207-1-git-send-email-jenny.tc@intel.com>
 <1379959445-28207-2-git-send-email-jenny.tc@intel.com>
 <20131027234535.GA23523@teo>
In-Reply-To: <20131027234535.GA23523@teo>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.223.10.10]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r9S3akH5001937

Anton,


 
> But do we really want to control the chargers through the power_supply's user-visible
> interface? It makes the whole power supply thing so complicated that I'm already losing
> track of it. Right now I think I would prefer to move all the charger logic out of the psy
> class.
>

I think exposing properties make the logic generic, otherwise it may end up in having callback
functions. Also there are some scenarios where the charging algorithm has to be in the
user space. If the driver need to remove the control interface from the user space, it can use
property_is_writeable callback. Using standard power supply properties, provide the
flexibility to interface the charging algorithms from the user space or the kernel space. 
This makes the charger driver implementation simple - it just need to register with psy class,
no extra API or callback required. 

> More specifically, this code:
> 
> > @@ -561,6 +575,11 @@ int power_supply_register(struct device *parent, struct
> power_supply *psy)
> >       if (rc)
> >               goto create_triggers_failed;
> >
> > +     if (psy_is_charger(psy))
> > +             rc = power_supply_register_charger(psy);
> > +     if (rc)
> > +             pr_debug("device: '%s': power_supply_register_charger failed\n",
> > +                             dev_name(dev));
> 
> I have a weird feeling about the fact that the power_supply_register() registers a charger.
> OK, we have thermal stuff registration there, but it is completely different. We have the
> cooling device registration there as well, and this stuff would be really nice to move out to
> some "chargers subsystem".
> 
> So, Jenny, the question is: can we separate chargers logic from the power supply? So that
> we don't have "charger enable"/"charger disable" knobs in the psy class itself. It is still fine
> if you need to have some interface to the psy class so that the chargers subsystem would
> interface with it, though. But I think that charger drivers have to register itself with two
> subsystems: chargers and power_supply (optionally).
> 

If your concern is in clubbing the charger framework related changes with psy class, 
then I have an alternate proposal. Using the patch https://lkml.org/lkml/2013/7/25/204,
the power supply change notification can be broadcasted. We can add notifier events
for power_supply_register and thermal throttling. This way power_supply_charger.c can
be a separate driver and it can listen to psy notifications to take actions.

> Thanks,
> 
> Anton
> 
> > Signed-off-by: Jenny TC <jenny.tc@intel.com>
> >
> > Change-Id: Id91dbbd8f34499afa97b7d8f11ecf5467847f6a8
> > ---
> >  Documentation/power/power_supply_class.txt |   16 ++++++++++++++++
> >  drivers/power/power_supply_sysfs.c         |    8 ++++++++
> >  include/linux/power_supply.h               |    8 ++++++++
> >  3 files changed, 32 insertions(+)
> >
> > diff --git a/Documentation/power/power_supply_class.txt
> > b/Documentation/power/power_supply_class.txt
> > index 3f10b39..5a5e7fa 100644
> > --- a/Documentation/power/power_supply_class.txt
> > +++ b/Documentation/power/power_supply_class.txt
> > @@ -118,6 +118,10 @@ relative, time-based measurements.
> >  CONSTANT_CHARGE_CURRENT - constant charge current programmed by charger.
> >  CONSTANT_CHARGE_CURRENT_MAX - maximum charge current supported by
> the
> > power supply object.
> > +INPUT_CURRENT_LIMIT - input current limit programmed by charger.
> > +Indicates the current drawn from a charging source.
> > +CHARGE_TERM_CUR - Charge termination current used to detect the end
> > +of charge condition
> >
> >  CONSTANT_CHARGE_VOLTAGE - constant charge voltage programmed by charger.
> >  CONSTANT_CHARGE_VOLTAGE_MAX - maximum charge voltage supported by
> the
> > @@ -140,12 +144,24 @@ TEMP_ALERT_MAX - maximum battery temperature alert
> value in milli centigrade.
> >  TEMP_AMBIENT - ambient temperature.
> >  TEMP_AMBIENT_ALERT_MIN - minimum ambient temperature alert value in milli
> centigrade.
> >  TEMP_AMBIENT_ALERT_MAX - maximum ambient temperature alert value in milli
> centigrade.
> > +MIN_TEMP - minimum operatable temperature MAX_TEMP - maximum
> > +operatable temperature
> 
> TEMP_MAX, TEMP_MIN. Be consistent with the rest of the properties...

Agreed. Will fix it
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
