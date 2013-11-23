Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756049Ab3KWAwI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 19:52:08 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:20786 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755634Ab3KWAwE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 19:52:04 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19bNqGG0l1cvnfOk5AzpFK5
Date: Fri, 22 Nov 2013 16:52:01 -0800
From: Tony Lindgren <tony@atomide.com>
To: Joel Fernandes <joelf@ti.com>
Cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, benoit.cousson@linaro.org,
        santosh.shilimkar@ti.com, jgchunter@gmail.com, rnayak@ti.com,
        balbi@ti.com
Subject: Re: [PATCH 6/8] devicetree: doc: Document ti,timer-parent property
Message-ID: <20131123005201.GK10023@atomide.com>
References: <1385085414-9034-1-git-send-email-joelf@ti.com>
 <1385085414-9034-7-git-send-email-joelf@ti.com>
 <20131122155838.GF10023@atomide.com>
 <528F8807.7050803@ti.com>
 <20131122170800.GG10023@atomide.com>
 <528FF774.4010109@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <528FF774.4010109@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Joel Fernandes <joelf@ti.com> [131122 16:32]:
> On 11/22/2013 11:08 AM, Tony Lindgren wrote:
> > 
> > I don't think there's a dependency here to the omap clocks as the dmtimer
> > can implement the clocksource separately and internally still use clk_get
> > using the clock alias table.
> 
> You mean implement clock-tree separately? Sorry I'm confused can you clarify
> what you mean?

You could implement the needed clocks for client drivers to use in dmtimer.c
directly if dmtimer.c is the gating those clocks.
 
> In clock tree data (not upstream), here is the system clock for am335x for example:
> sys_clkin_ck: sys_clkin_ck@44e10040 {
>         #clock-cells = <0>;
>         compatible = "mux-clock";
> 
> It uses the mux-clock driver. Are you saying we duplicate clock-tree stuff? I
> don't think that's a good idea specially since once clock dt data is available,
> we will switch to using it.

Oh OK, then that naturally could be used directly too.
 
> >>>>  Optional properties:
> >>>>  - ti,timer-alwon:	Indicates the timer is in an alway-on power domain.
> >>>
> >>> Hmm this we may not need, this can probably be deciphered from the compatible
> >>> flag already?
> >>
> >> How? Compatible contains the same string, for example for OMAP4:
> >>
> >> timer8 has:
> >>                         compatible = "ti,omap4430-timer";
> >>                         ti,timer-pwm;
> >>                         ti,timer-dsp;
> >>
> >> and timer9 has:
> >>                         compatible = "ti,omap4430-timer";
> >>                         ti,hwmods = "timer9";
> >>                         ti,timer-pwm;
> >>
> > 
> > Some of these features are always hardwired certain way and could be mapped to
> > the right timer based on the timer offset and the compatible flag if we want
> > to avoid adding the ti,timer-alwon property. It seems that most omaps have
> > just one always on timer that's the first timer, and only on am33xx it does
> > not exist?
> > 
> > I'm fine adding ti,timer-alwon if it help to leave out static data in the
> > driver and avoid patching the driver for every new SoC. But sounds like in
> > this case we really have just the am33xx exception to the rule?
> 
> ti,timer-alwon may not be needed yes, since on all platforms I've observed first
> timer has this property. However from OMAP3 dt, timer12 has it too. Not sure
> what that implies.

I guess you could mark timer1 and 12 as always on if the compatible flag 
matches ti,omap3430-timer.
 
> I think what Jon was trying to do is to find a DT node by property, he had no
> other way of getting a device_node * otherwise.
> 
> But notice this macro used for HS (secure devices):
> OMAP_SYS_32K_TIMER_INIT(3_secure, 12, "secure_32k_fck", "ti,timer-secure",
>                         2, "timer_sys_ck", NULL);
> 
> How would you specify in DT that you want a node with the timer-secure property
> as the clocksource if we drop these kind of properties?

timer {
	interrupt-parent = <&timer12>;
	...
}

Should do the trick I think :)
 
> >>> Then for the users of a specific dmtimer, they can select the right one using
> >>> the interrupt-parent property:
> >>>
> >>> timer1: timer@0x4800abcd {
> >>> 	compatible = "ti,omap5430-timer";
> >>> 	#interrupt-cells = <1>;		/* needs irqchip implemented for dmtimer */
> >>> 	interrupt-controller;
> >>> 	#clock-cells = <1>;		/* needs clocksource implemented for dmtimer */
> >>> 	clock-output-names = "32k", "sys_ck";
> >>> 	...
> >>> };
> >>
> >> In reference to my last thread reply, irqchip may not be available early in the
> >> boot process (.init_time) for system timer usage?
> > 
> > Hmm it should be, looks like we have in arch/arm/kernel/irq.c:
> > 
> > void __init init_IRQ(void)
> > {
> > 	if (IS_ENABLED(CONFIG_OF) && !machine_desc->init_irq)
> > 		irqchip_init();
> > 	else    
> > 		machine_desc->init_irq();
> > }               
> > 
> > Then in init/main.c has:
> > 	...
> > 	early_irq_init();
> > 	init_IRQ();
> > 	tick_init();
> > 	init_timers();
> > 	hrtimers_init();
> > 	softirq_init();
> > 	timekeeping_init();
> > 	time_init();
> > 	...
> > 
> > So looks like we should have irqchip available?
> 
> Right. I think your idea of using irqchip is certainly a clean way. Let me go
> back to the drawing board and try to see if we have all the pieces we need and
> there are no surprises in doing it this way.

OK cool.
 
> Then we can have a general purpose clocksource driver that uses the irqchip
> driver. I still worry about things like hwmod that may be need to be called on
> specific timer, and runtime PM is not available that early in the boot process.

Yeah we may still need a piece of code in mach-omap2 for now if runtime PM is
not available at that point yet.

Regards,

Tony
