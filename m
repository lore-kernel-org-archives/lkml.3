Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756012Ab3KVQCJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 11:02:09 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:54674 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755721Ab3KVQCH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 11:02:07 -0500
Message-ID: <528F7FE5.3020908@ti.com>
Date: Fri, 22 Nov 2013 10:01:41 -0600
From: Joel Fernandes <joelf@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Tony Lindgren <tony@atomide.com>
CC: <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <benoit.cousson@linaro.org>,
        <santosh.shilimkar@ti.com>, <jgchunter@gmail.com>, <rnayak@ti.com>,
        <balbi@ti.com>
Subject: Re: [PATCH 1/8] ARM: OMAP: Move public portion of dmtimer.h to include/linux/omap-timer.h
References: <1385085414-9034-1-git-send-email-joelf@ti.com> <1385085414-9034-2-git-send-email-joelf@ti.com> <20131122153334.GE10023@atomide.com>
In-Reply-To: <20131122153334.GE10023@atomide.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
> omap_dm_timer_stop			disable_irq
> omap_dm_timer_start			enable_irq
> omap_dm_timer_disable			disable_irq
> omap_dm_timer_free			free_irq
> omap_dm_timer_set_int_enable		enable_irq

Hi Tony,

The thing I feel we're trying to fit a square peg into round hole type of thing
here.

Some reasons I feel this is overkill (point 2 makes it even not possible):

1. Ideally IR_RX51 should be using clockevents/hrtimer framework instead of
irqchip. Other than that, dsp bridge is the only other user.

2. These functions will be also be required to be public once mach-omap2/timer.c
moves to drivers/clocksource/ . At such an early point of code, we can't use
irqchip anyway so we'd need these functions public.

3. This is a minor point, but its also not immediately intuitive or clear to
someone who needs a dedicated hardware timer that they need to use an IRQ chip
driver for the same. But we can avoid any discussion about this till we can
discuss/agree on the above 2.

thanks,

-Joel
