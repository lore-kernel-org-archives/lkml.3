Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755822Ab3KWAcT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 19:32:19 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:48583 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755614Ab3KWAcR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 19:32:17 -0500
Message-ID: <528FF774.4010109@ti.com>
Date: Fri, 22 Nov 2013 18:31:48 -0600
From: Joel Fernandes <joelf@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Tony Lindgren <tony@atomide.com>
CC: <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <benoit.cousson@linaro.org>,
        <santosh.shilimkar@ti.com>, <jgchunter@gmail.com>, <rnayak@ti.com>,
        <balbi@ti.com>
Subject: Re: [PATCH 6/8] devicetree: doc: Document ti,timer-parent property
References: <1385085414-9034-1-git-send-email-joelf@ti.com> <1385085414-9034-7-git-send-email-joelf@ti.com> <20131122155838.GF10023@atomide.com> <528F8807.7050803@ti.com> <20131122170800.GG10023@atomide.com>
In-Reply-To: <20131122170800.GG10023@atomide.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/22/2013 11:08 AM, Tony Lindgren wrote:
> * Joel Fernandes <joelf@ti.com> [131122 08:37]:
>> Hi Tony,
>>
>> Thanks for your comments, few replies inline below..
>>
>> On 11/22/2013 09:58 AM, Tony Lindgren wrote:
>>> * Joel Fernandes <joelf@ti.com> [131121 18:00]:
>>>> +Required properties for system timers (clockevents/clocksource):
>>>> +- ti,timer-parent:	System timer's parent mux clock needs to be setup.
>>>> +			This is currently hardcoded in code, for DT boot we
>>>> +			move this to DT.
>>>> +
>>>
>>> This can be replaced with just clk_set_rate, or clk_set_parent if needed.
>>> Or by having a clocks = <&32k_clk> property in the dmtimer node in the
>>> .dts file.
>>>
>>
>> Sure, but clock-data is still not available to make this possible in mainline.
>> We also discussed earlier right that we don't want dependencies as much as
>> possible to get one chunk in and working at a time. I was thinking like for a
>> first-pass since there's a lot of unrelated code that doesn't have dependencies,
>> but needs this to work, we can introduce this property for now and drop it later
>> as a "cost of migration"?
> 
> I don't think there's a dependency here to the omap clocks as the dmtimer
> can implement the clocksource separately and internally still use clk_get
> using the clock alias table.

You mean implement clock-tree separately? Sorry I'm confused can you clarify
what you mean?

In clock tree data (not upstream), here is the system clock for am335x for example:
sys_clkin_ck: sys_clkin_ck@44e10040 {
        #clock-cells = <0>;
        compatible = "mux-clock";

It uses the mux-clock driver. Are you saying we duplicate clock-tree stuff? I
don't think that's a good idea specially since once clock dt data is available,
we will switch to using it.

>>>>  Optional properties:
>>>>  - ti,timer-alwon:	Indicates the timer is in an alway-on power domain.
>>>
>>> Hmm this we may not need, this can probably be deciphered from the compatible
>>> flag already?
>>
>> How? Compatible contains the same string, for example for OMAP4:
>>
>> timer8 has:
>>                         compatible = "ti,omap4430-timer";
>>                         ti,timer-pwm;
>>                         ti,timer-dsp;
>>
>> and timer9 has:
>>                         compatible = "ti,omap4430-timer";
>>                         ti,hwmods = "timer9";
>>                         ti,timer-pwm;
>>
> 
> Some of these features are always hardwired certain way and could be mapped to
> the right timer based on the timer offset and the compatible flag if we want
> to avoid adding the ti,timer-alwon property. It seems that most omaps have
> just one always on timer that's the first timer, and only on am33xx it does
> not exist?
> 
> I'm fine adding ti,timer-alwon if it help to leave out static data in the
> driver and avoid patching the driver for every new SoC. But sounds like in
> this case we really have just the am33xx exception to the rule?

ti,timer-alwon may not be needed yes, since on all platforms I've observed first
timer has this property. However from OMAP3 dt, timer12 has it too. Not sure
what that implies.

I think what Jon was trying to do is to find a DT node by property, he had no
other way of getting a device_node * otherwise.

But notice this macro used for HS (secure devices):
OMAP_SYS_32K_TIMER_INIT(3_secure, 12, "secure_32k_fck", "ti,timer-secure",
                        2, "timer_sys_ck", NULL);

How would you specify in DT that you want a node with the timer-secure property
as the clocksource if we drop these kind of properties?

>>> Then for the users of a specific dmtimer, they can select the right one using
>>> the interrupt-parent property:
>>>
>>> timer1: timer@0x4800abcd {
>>> 	compatible = "ti,omap5430-timer";
>>> 	#interrupt-cells = <1>;		/* needs irqchip implemented for dmtimer */
>>> 	interrupt-controller;
>>> 	#clock-cells = <1>;		/* needs clocksource implemented for dmtimer */
>>> 	clock-output-names = "32k", "sys_ck";
>>> 	...
>>> };
>>
>> In reference to my last thread reply, irqchip may not be available early in the
>> boot process (.init_time) for system timer usage?
> 
> Hmm it should be, looks like we have in arch/arm/kernel/irq.c:
> 
> void __init init_IRQ(void)
> {
> 	if (IS_ENABLED(CONFIG_OF) && !machine_desc->init_irq)
> 		irqchip_init();
> 	else    
> 		machine_desc->init_irq();
> }               
> 
> Then in init/main.c has:
> 	...
> 	early_irq_init();
> 	init_IRQ();
> 	tick_init();
> 	init_timers();
> 	hrtimers_init();
> 	softirq_init();
> 	timekeeping_init();
> 	time_init();
> 	...
> 
> So looks like we should have irqchip available?

Right. I think your idea of using irqchip is certainly a clean way. Let me go
back to the drawing board and try to see if we have all the pieces we need and
there are no surprises in doing it this way.

Then we can have a general purpose clocksource driver that uses the irqchip
driver. I still worry about things like hwmod that may be need to be called on
specific timer, and runtime PM is not available that early in the boot process.

thanks,

-Joel

