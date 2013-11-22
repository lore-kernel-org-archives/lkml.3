Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756003Ab3KVRIG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 12:08:06 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:56850 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755893Ab3KVRIE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 12:08:04 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/osBZwG+YyoG3+B7q8tetw
Date: Fri, 22 Nov 2013 09:08:01 -0800
From: Tony Lindgren <tony@atomide.com>
To: Joel Fernandes <joelf@ti.com>
Cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, benoit.cousson@linaro.org,
        santosh.shilimkar@ti.com, jgchunter@gmail.com, rnayak@ti.com,
        balbi@ti.com
Subject: Re: [PATCH 6/8] devicetree: doc: Document ti,timer-parent property
Message-ID: <20131122170800.GG10023@atomide.com>
References: <1385085414-9034-1-git-send-email-joelf@ti.com>
 <1385085414-9034-7-git-send-email-joelf@ti.com>
 <20131122155838.GF10023@atomide.com>
 <528F8807.7050803@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <528F8807.7050803@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Joel Fernandes <joelf@ti.com> [131122 08:37]:
> Hi Tony,
> 
> Thanks for your comments, few replies inline below..
> 
> On 11/22/2013 09:58 AM, Tony Lindgren wrote:
> > * Joel Fernandes <joelf@ti.com> [131121 18:00]:
> >> +Required properties for system timers (clockevents/clocksource):
> >> +- ti,timer-parent:	System timer's parent mux clock needs to be setup.
> >> +			This is currently hardcoded in code, for DT boot we
> >> +			move this to DT.
> >> +
> > 
> > This can be replaced with just clk_set_rate, or clk_set_parent if needed.
> > Or by having a clocks = <&32k_clk> property in the dmtimer node in the
> > .dts file.
> > 
> 
> Sure, but clock-data is still not available to make this possible in mainline.
> We also discussed earlier right that we don't want dependencies as much as
> possible to get one chunk in and working at a time. I was thinking like for a
> first-pass since there's a lot of unrelated code that doesn't have dependencies,
> but needs this to work, we can introduce this property for now and drop it later
> as a "cost of migration"?

I don't think there's a dependency here to the omap clocks as the dmtimer
can implement the clocksource separately and internally still use clk_get
using the clock alias table.
 
> >>  Optional properties:
> >>  - ti,timer-alwon:	Indicates the timer is in an alway-on power domain.
> > 
> > Hmm this we may not need, this can probably be deciphered from the compatible
> > flag already?
> 
> How? Compatible contains the same string, for example for OMAP4:
> 
> timer8 has:
>                         compatible = "ti,omap4430-timer";
>                         ti,timer-pwm;
>                         ti,timer-dsp;
> 
> and timer9 has:
>                         compatible = "ti,omap4430-timer";
>                         ti,hwmods = "timer9";
>                         ti,timer-pwm;
> 

Some of these features are always hardwired certain way and could be mapped to
the right timer based on the timer offset and the compatible flag if we want
to avoid adding the ti,timer-alwon property. It seems that most omaps have
just one always on timer that's the first timer, and only on am33xx it does
not exist?

I'm fine adding ti,timer-alwon if it help to leave out static data in the
driver and avoid patching the driver for every new SoC. But sounds like in
this case we really have just the am33xx exception to the rule?

> > Then for the users of a specific dmtimer, they can select the right one using
> > the interrupt-parent property:
> > 
> > timer1: timer@0x4800abcd {
> > 	compatible = "ti,omap5430-timer";
> > 	#interrupt-cells = <1>;		/* needs irqchip implemented for dmtimer */
> > 	interrupt-controller;
> > 	#clock-cells = <1>;		/* needs clocksource implemented for dmtimer */
> > 	clock-output-names = "32k", "sys_ck";
> > 	...
> > };
> 
> In reference to my last thread reply, irqchip may not be available early in the
> boot process (.init_time) for system timer usage?

Hmm it should be, looks like we have in arch/arm/kernel/irq.c:

void __init init_IRQ(void)
{
	if (IS_ENABLED(CONFIG_OF) && !machine_desc->init_irq)
		irqchip_init();
	else    
		machine_desc->init_irq();
}               

Then in init/main.c has:
	...
	early_irq_init();
	init_IRQ();
	tick_init();
	init_timers();
	hrtimers_init();
	softirq_init();
	timekeeping_init();
	time_init();
	...

So looks like we should have irqchip available?

Regards,

Tony
