Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752576Ab3KZDCi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 22:02:38 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:49257 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751119Ab3KZDCh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 22:02:37 -0500
Message-ID: <52940F32.3000006@ti.com>
Date: Mon, 25 Nov 2013 21:02:10 -0600
From: Joel Fernandes <joelf@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Tony Lindgren <tony@atomide.com>
CC: <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <benoit.cousson@linaro.org>,
        <santosh.shilimkar@ti.com>, <jgchunter@gmail.com>, <rnayak@ti.com>,
        <balbi@ti.com>, Suman Anna <s-anna@ti.com>
Subject: Re: [PATCH 1/8] ARM: OMAP: Move public portion of dmtimer.h to include/linux/omap-timer.h
References: <1385085414-9034-1-git-send-email-joelf@ti.com> <1385085414-9034-2-git-send-email-joelf@ti.com> <20131122153334.GE10023@atomide.com>
In-Reply-To: <20131122153334.GE10023@atomide.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tony,

Few replies inline below. Adding Suman as well who is planning to use dmtimer
directly for his work with DSP.

On 11/22/2013 09:33 AM, Tony Lindgren wrote:
> Hi,
> 
> * Joel Fernandes <joelf@ti.com> [131121 18:00]:
>> Multiplatform support has made arch/arm/plat-omap/include/plat/ inaccessible to
>> drivers outside the plat-omap directory [1]. Due to this the following drivers
>> are disabled with !CONFIG_ARCH_MULTIPLATFORM:
>> CONFIG_IR_RX51 (drivers/media/rc/ir-rx51.c)
>> CONFIG_TIDSPBRIDGE (drivers/staging/tidspbridge/core/dsp-clock.c)
>>
>> We move the portion of the dmtimer "API" that should be accessible to the
>> drivers, into include/linux/omap-timer.h
> 
> As we chatted earlier, we don't have to expose all these hardware specific
> functions and use existing Linux generic frameworks instead.

I thought over this, and strongly feel that in this case moving to a generic
framework is not the right approach. I mentioned reasons in last post, but
summarizing all of them below:

1. It is not immediately intuitive or obvious unlike GPIO that a timer can be an
irqchip.

2. There are only 1-2 users of the dmtimer directly so moving to linux generic
framework is bit overkill I feel. Further there is already a framework-
clockevents/hrtimer which everyone should be using. For the 1-2 direct dmtimer
users, they should just use the dmtimer public API.

More reasons below...

> 
> We can implement an irqchip and a clocksource in the dmtimer code for the
> client drivers to use, and after that we only have a couple of dmtimer
> specific functions left to export.
> 
> I'm thinkging some thing like this for the public API:
> 
> omap_dm_timer_request			request_irq
> omap_dm_timer_request_specific		request_irq
> omap_dm_timer_get_irq			request_irq
> omap_dm_timer_set_source		clk_set_rate

For clk_set_rate, how would one directly access the timer node if we've hidden
it behind an irq chip abstraction?

per your suggestion, one would have something like:

dsp {
    interrupt-parent = <&timer1>;
}

so how do you clk_set_rate rate something like this given the dsp node?

If the suggestion is to get the timer1 node from the interrupt-parent property,
if I may say- that's a bit ugly because now you're breaking the irq chip
abstraction just to access the timer node..

> omap_dm_timer_stop			disable_irq
> omap_dm_timer_start			enable_irq
> omap_dm_timer_disable			disable_irq
> omap_dm_timer_free			free_irq
> omap_dm_timer_set_int_enable		enable_irq
> 
> After that, what's left to export are some functions to configure
> the hardware timer:
> 
> omap_dm_timer_write_counter
> omap_dm_timer_set_match
> omap_dm_timer_read_counter
> omap_dm_timer_read_status
> omap_dm_timer_write_status

Same comment for clk_set_rate applies here, we've to access interrupt-parent
property to get timer node and call dmtimer API which breaks the abstraction.

Usually I've seen frameworks come up because there is code duplication etc. In
this case there is no duplication as such, and the number of users of the API is
also few. What is the problem with exposing a small set of API to timer users in
drivers/ specially when they are prefixed by a unique name (omap_dm_timer)?

thanks,

-Joel



