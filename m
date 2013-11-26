Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757620Ab3KZS3P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 13:29:15 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:56639 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754754Ab3KZS3M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 13:29:12 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+hHWH1XXns69yawho1BoME
Date: Tue, 26 Nov 2013 10:29:09 -0800
From: Tony Lindgren <tony@atomide.com>
To: Joel Fernandes <joelf@ti.com>
Cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, benoit.cousson@linaro.org,
        santosh.shilimkar@ti.com, jgchunter@gmail.com, rnayak@ti.com,
        balbi@ti.com, Suman Anna <s-anna@ti.com>
Subject: Re: [PATCH 1/8] ARM: OMAP: Move public portion of dmtimer.h to
 include/linux/omap-timer.h
Message-ID: <20131126182908.GK26766@atomide.com>
References: <1385085414-9034-1-git-send-email-joelf@ti.com>
 <1385085414-9034-2-git-send-email-joelf@ti.com>
 <20131122153334.GE10023@atomide.com>
 <52940F32.3000006@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52940F32.3000006@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Joel Fernandes <joelf@ti.com> [131125 19:03]:
> Hi Tony,
> 
> Few replies inline below. Adding Suman as well who is planning to use dmtimer
> directly for his work with DSP.
> 
> On 11/22/2013 09:33 AM, Tony Lindgren wrote:
> > Hi,
> > 
> > * Joel Fernandes <joelf@ti.com> [131121 18:00]:
> >> Multiplatform support has made arch/arm/plat-omap/include/plat/ inaccessible to
> >> drivers outside the plat-omap directory [1]. Due to this the following drivers
> >> are disabled with !CONFIG_ARCH_MULTIPLATFORM:
> >> CONFIG_IR_RX51 (drivers/media/rc/ir-rx51.c)
> >> CONFIG_TIDSPBRIDGE (drivers/staging/tidspbridge/core/dsp-clock.c)
> >>
> >> We move the portion of the dmtimer "API" that should be accessible to the
> >> drivers, into include/linux/omap-timer.h
> > 
> > As we chatted earlier, we don't have to expose all these hardware specific
> > functions and use existing Linux generic frameworks instead.
> 
> I thought over this, and strongly feel that in this case moving to a generic
> framework is not the right approach. I mentioned reasons in last post, but
> summarizing all of them below:
> 
> 1. It is not immediately intuitive or obvious unlike GPIO that a timer can be an
> irqchip.

But that's what it really is for hadware timers :)
 
> 2. There are only 1-2 users of the dmtimer directly so moving to linux generic
> framework is bit overkill I feel. Further there is already a framework-
> clockevents/hrtimer which everyone should be using. For the 1-2 direct dmtimer
> users, they should just use the dmtimer public API.

But the thing is, we don't want to expose the dmtimer public API. That will
lead to drivers tinkering directly with the hardware timers and then other
SoCs will follow.
 
> More reasons below...
> 
> > 
> > We can implement an irqchip and a clocksource in the dmtimer code for the
> > client drivers to use, and after that we only have a couple of dmtimer
> > specific functions left to export.
> > 
> > I'm thinkging some thing like this for the public API:
> > 
> > omap_dm_timer_request			request_irq
> > omap_dm_timer_request_specific		request_irq
> > omap_dm_timer_get_irq			request_irq
> > omap_dm_timer_set_source		clk_set_rate
> 
> For clk_set_rate, how would one directly access the timer node if we've hidden
> it behind an irq chip abstraction?
> 
> per your suggestion, one would have something like:
> 
> dsp {
>     interrupt-parent = <&timer1>;
> }
> 
> so how do you clk_set_rate rate something like this given the dsp node?

All you have to do is implement a clocksource driver in dmtimer.c code.
 
> If the suggestion is to get the timer1 node from the interrupt-parent property,
> if I may say- that's a bit ugly because now you're breaking the irq chip
> abstraction just to access the timer node..

Hmm sorry I don't follow you here.
 
> > omap_dm_timer_stop			disable_irq
> > omap_dm_timer_start			enable_irq
> > omap_dm_timer_disable			disable_irq
> > omap_dm_timer_free			free_irq
> > omap_dm_timer_set_int_enable		enable_irq
> > 
> > After that, what's left to export are some functions to configure
> > the hardware timer:
> > 
> > omap_dm_timer_write_counter
> > omap_dm_timer_set_match
> > omap_dm_timer_read_counter
> > omap_dm_timer_read_status
> > omap_dm_timer_write_status
> 
> Same comment for clk_set_rate applies here, we've to access interrupt-parent
> property to get timer node and call dmtimer API which breaks the abstraction.

Sorry, I don't follow you here either. I'm sure we'll have some Linux generic
standard for programming hardware timers, but still using request_irq + 
clk_set_rate is very standard behaviour no matter what happens later on.
 
> Usually I've seen frameworks come up because there is code duplication etc. In
> this case there is no duplication as such, and the number of users of the API is
> also few. What is the problem with exposing a small set of API to timer users in
> drivers/ specially when they are prefixed by a unique name (omap_dm_timer)?

Because we don't want to export 27 omap specific functions to drivers:

$ grep EXPORT_SYMBOL arch/arm/plat-omap/dmtimer.c | wc -l
27

Instead, it looks like we can get away with exporting just:

omap_dm_timer_write_counter
omap_dm_timer_set_match
omap_dm_timer_read_counter
omap_dm_timer_read_status
omap_dm_timer_write_status

And I'm sure we'll have some solution for those also later on.

Regards,

Tony
