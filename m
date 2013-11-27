Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754529Ab3K0RxG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 12:53:06 -0500
Received: from mga09.intel.com ([134.134.136.24]:14028 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752003Ab3K0RxB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 12:53:01 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,783,1378882800"; 
   d="scan'208";a="435200486"
From: "Tc, Jenny" <jenny.tc@intel.com>
To: "'NeilBrown'" <neilb@suse.de>, "'Anton Vorontsov'" <anton@enomsg.org>
CC: "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "'Kim, Milo'" <Milo.Kim@ti.com>, "'Lee Jones'" <lee.jones@linaro.org>,
        "'Jingoo Han'" <jg1.han@samsung.com>,
        "'Chanwoo Choi'" <cw00.choi@samsung.com>,
        "'Sachin Kamat'" <sachin.kamat@linaro.org>,
        "'Rupesh Kumar'" <rupesh.kumar@stericsson.com>,
        "'Lars-Peter Clausen'" <lars@metafoo.de>,
        =?iso-8859-1?Q?=27Pali_Roh=E1r=27?= <pali.rohar@gmail.com>,
        "'Mark Brown'" <broonie@opensource.wolfsonmicro.com>,
        "'Rhyland Klein'" <rklein@nvidia.com>
Subject: RE: [PATCH 1/7] power_supply: Add charger control properties
Thread-Topic: [PATCH 1/7] power_supply: Add charger control properties
Thread-Index: Ac7Wwc/TFHnLdfwRSr+wF45UZVRIrwU12JHA
Date: Wed, 27 Nov 2013 17:52:55 +0000
Message-ID: <20ADAB092842284E95860F279283C5640AAF4428@BGSMSX104.gar.corp.intel.com>
References: <20ADAB092842284E95860F279283C5640AAA4D36@BGSMSX104.gar.corp.intel.com>
In-Reply-To: <20ADAB092842284E95860F279283C5640AAA4D36@BGSMSX104.gar.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.223.10.10]
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Anton,

Does this address your concerns? 

-Jenny



> Subject: RE: [PATCH 1/7] power_supply: Add charger control properties
> 
> > Subject: Re: [PATCH 1/7] power_supply: Add charger control properties
> >
> > On Sun, 27 Oct 2013 23:18:08 -0700 Anton Vorontsov <anton@enomsg.org> wrote:
> >
> > > On Mon, Oct 28, 2013 at 03:36:36AM +0000, Tc, Jenny wrote:
> > > > > But do we really want to control the chargers through the
> > > > > power_supply's user-visible interface? It makes the whole power
> > > > > supply thing so complicated that I'm already losing track of it.
> > > > > Right now I think I would prefer to move all the charger logic out of the psy class.
> > > > >
> > > >
> > > > I think exposing properties make the logic generic, otherwise it
> > > > may end up in having callback functions.
> > > >
> > > > Also there are some scenarios where the charging algorithm has to
> > > > be in the user space.
> > >
> > > Which scenarios?
> 
> Charger may be of two different path. 1) Single path 2) Dual path
> 
> With a single path charger, the charger will be having only one output path. This path
> supplies power to battery(IBAT) and to system (ISYS). With dual path chargers, charger
> will be having two separate output paths -to battery and to system .
> 
> With single path chargers, consider the scenario when system is idle and the maximum
> Allowed charge current is 1A. So the charger output can be set to 1A so that battery can
> charge with 1A. But with a varying load, this may not be good. If the platform consumes
> 500mA, then the charging current would be reduced to 500mA. But increasing the output
> to 1.5A may result in high charge current if the load is reduced.
> 
> Identifying different use case and their power profile helps to handle this scenario.
> This can be better handled by some algorithm in user space which can monitor the running
> applications and derive average platform load. The algorithm can proactively decide the
> charge current based on the power and thermal characteristics of different use case.
> 
> So in this scenario, there is a need to modify the charging parameters from the user space.
> 
> 
> > >
> > > Plus, I am more questioning if the power supply framework is the
> > > right thing to control the *chargers*. Chargers are not the power
> > > supply to the system or any device (well, except for the batteries themselves).
> >
> > I'm not sure this is (always) true.
> > On my device (gta04.org) the battery, the USB OTG port, and a separate
> > 5VDC input can each be the power source of the whole device.
> > The USB and 5VDC cannot both be active concurrently, but either can be
> > active together with the battery.
> >
> > The device can function without the battery, so the charger plugged
> > into the USB-OTG must be supplying power to the system (not just the battery).
> >
> > The "charger" functionality sits between the battery and the external
> > power supply monitoring the voltage on the battery and the current
> > from the external supply.  Based on these values (and some timers and
> > a state machine) it enabled or disables the external supply and possibly imposes a
> current-limit on it.
> >
> > The three power sources all have "power_supply" devices registered
> > (though the battery only does because it contains a bq27000 charger counter).
> > I've been wondering where to put sysfs attributes to control the charging.
> > I currently place them in the power_supply device for each external power source.
> > That makes some sense for the 'current limit' value, but not for the
> > 'battery volts at which to re-start charging' value.
> > There is also a setting which affects  whether the external source is
> > switched off if the voltage drops below 4.4V.  In some circumstances I
> > want to leave the charger enabled then, as it could just mean the cyclist is taking a break
> and there should be current again soon.
> >
> > I think the sensible place for these tune-ables is with the battery.
> > i.e. the power_supply that corresponds to the battery could register "min voltage" and
> "min current".
> > The charger driver needs to know about this battery and about any
> > power sources that can charge it, and uses the state of the battery to decide how to tune
> the state of the charger.
> >
> > I note that there is already something a lot like this between
> >    88pm860x_battery.c
> > and
> >    88pm860x_charger.c
> >
> > They manage to locate each other and the charger call get_property and
> > set_property on the battery.
> >
> > Maybe formalising this might be a useful way forward.
> >
> > I'm not sure that we really need a new driver-class for chargers.
> > Maybe just a way to link external power supplies to battery power
> > supplies, and maybe some agreement on what they are allowed to say to each other.
> >
> > Jenny: would something like that work for you??
> 
> The idea of charging framework is to connect different components to setup and monitor
> charging. This includes battery identification protocols, battery driver, charger driver,
> platform thermal profile for charging, different cables (USB/AC/Wireless/MHL etc),
> different charging algorithms (PSE compliant/ruler based/pulse charging etc).
> This makes the charger driver simple. It can just act as a h/w abstraction layer and doesn't
> need to be aware of the cable types/properties/thermal/battery characteristics. All logic
> resides in the framework layer.
> 
> The proposal separates the battery characteristics (different from runtime battery
> properties) from the charger/battery driver. The battery characteristics can be read based on
> the type of battery identification interface - Analog (BSI) or digital. In case of Analog
> interface, a BSI resistance is used to identify the battery. Based on the BSI resistance
> battery charging profile and characteristics can be loaded.
> 
> In case of digital battery profile, a one wire protocol is used to read the battery properties
> from an EEPROM inside the Battery pack. In some  platforms to reduce the battery pack
> cost, the EEPROM may be on the board and may be connected using I2C lines.
> 
> Separating out this logic from battery driver makes it more modular.  So the proposal uses
> a battery identification layer to read the battery profile. So the charger and battery drivers
> (fuel gauge drivers) can read the profile from the battery identification layer and configure
> the h/w register settings appropriately.
> 
> So the tunable attributes resides in the battery identification layer and the drivers reads
> them from this layer.
> 
> I uploaded a modified version of the Charging Framework ELCE presentation at
> https://drive.google.com/file/d/0B3urTgiXiZF6eGt4MkVZaXNlNlE/edit?usp=sharing
> Hope this would give more idea about the proposal.
> 
> >
> >
> >
> > >
> > > > Using the patch https://lkml.org/lkml/2013/7/25/204,
> > > > the power supply change notification can be broadcasted. We can
> > > > add notifier events for power_supply_register and thermal throttling.
> > > > This way power_supply_charger.c can be a separate driver and it
> > > > can listen to psy
> > notifications to take actions.
> > >
> > > If you ever need this particular notifier, I am OK with it (but I'll
> > > consider applying it only together with some its users).
> > >
> > > Basically, I am more against these three patches:
> > >
> > > [PATCH 3/7] power_supply: add throttle state [PATCH 2/7] power_supply:
> > > add charger cable properties [PATCH 1/7] power_supply: Add charger
> > > control properties (enable_charger part)
> 
> [PATCH 3/7] power_supply: add throttle state and [PATCH 2/7] power_supply: add
> charger cable properties can be reworked I can move them out of power_supply.h to a new
> file include/linux/power/power_supply_charger.h
> 
> But I think the control properties exposed in patch " [PATCH 1/7] power_supply: Add
> charger control properties" qualifies to be part of power_supply.h
> 
> INPUT_CURRENT_LIMIT - Controls the output from external supply.
> CHARGE_TERM_CUR - Decides when to stop supply to battery. When supply to battery
> is stopped, battery starts supplying power to platform.
> 
> MIN_TEMP - minimum temperature for a power supply MAX_TEMP - maximum
> temperature for a power supply ENABLE_CHARGING - enable/disable charging.
> Enable/disable supply to battery.
> ENABLE_CHARGER - enable/disable charger. Enable/disable supply to system and
> battery.
> CABLE_TYPE - type of a cable, helps to identify the cable type PRIORITY - priority for
> charging if multiple charger drivers are present.
> 
> All attributes control the external power supply or the battery. The term charger may get
> confused as "charger IC". Do you have better suggestions?
> 
> > >
> > > These three add too much "charger" specifics to the power_supply
> > > stuff. I think they deserve their own subsystem/class/whatever.
> > >
> > > Also, the battid framework is written without any notion of
> > > device/driver separation, uses global variables, and I suspect it
> > > should not exist at all (psy_get_batt_prop function makes me think
> > > that you should just register the i2c/spi/w1 battery with the
> > > power_supply and not use the ad-hoc stuff).
> 
> These drivers are not power supply. They just reads the static battery profile and exposes
> to the consumers. Hope previous explanation on this would be helpful
> 
> > >
> > > Anton
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe
> > > linux-kernel" in the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > > Please read the FAQ at  http://www.tux.org/lkml/

