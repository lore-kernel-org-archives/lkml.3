Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754546Ab3JBQm1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 12:42:27 -0400
Received: from mail-wg0-f52.google.com ([74.125.82.52]:53262 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753962Ab3JBQm0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 12:42:26 -0400
Date: Wed, 2 Oct 2013 18:42:23 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Stephen Boyd <sboyd@codeaurora.org>,
        LKML <linux-kernel@vger.kernel.org>, patches@linaro.org,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>
Subject: Re: [PATCH V2] tick: Make sleep length calculation more accurate
Message-ID: <20131002164221.GI7941@localhost.localdomain>
References: <1380709565-22153-1-git-send-email-daniel.lezcano@linaro.org>
 <CAFTL4hw-yawRUO-8ePsonvh1o2P7T5yb+GFPVop5OHzH6HTobw@mail.gmail.com>
 <524C4845.5060800@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <524C4845.5060800@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 02, 2013 at 06:22:29PM +0200, Daniel Lezcano wrote:
> On 10/02/2013 05:57 PM, Frederic Weisbecker wrote:
> >2013/10/2 Daniel Lezcano <daniel.lezcano@linaro.org>:
> >>The sleep_length is computed in the tick_nohz_stop_sched_tick function but it
> >>is used later in the code with in between the local irq enabled.
> >>
> >>cpu_idle_loop
> >>   tick_nohz_idle_enter         [ exits with local irq enabled ]
> >>    __tick_nohz_idle_enter
> >>      tick_nohz_stop_sched_tick
> >>   ...
> >>
> >>   arch_cpu_idle
> >>      menu_select               [ uses here 'sleep_length' ]
> >>   ...
> >>
> >>Between the computation of the sleep length and its usage, some interrupts
> >>may occur, making the sleep length shorter than actually it is because of the
> >>interrupt processing
> >
> >So, do you mean that the ts->sleep_length would return a value that is too long
> >given that the CPU already spent some time to service the irqs since we computed
> >the sleep length in tick_nohz_idle_enter()?
> >
> >But then tick_nohz_irq_exit() should take care of that as it calls
> >again tick_nohz_stop_sched_tick().
> >So I'm a bit confused.
> >
> >>or different if the timer itself expired.
> >
> >Same here, if the timer expired, it triggers an interrupt which can do
> >two things:
> >
> >1) reprogram a new timer and this recompute sleep_length
> >2) set_need_resched() and then exit the idle loop, so arch_cpu_idle() won't even
> >be called. Or the timer interrupts hlt, but then menu_select() was
> >called before.
> >
> >So I probably missed something here.
> 
> No you did not :)
> 
> Indeed... At the first glance, this issue sounded so obvious I
> suspected there must be a trick somewhere but I did not think to
> look at the irq_exit, the code is very complex. Thanks for
> clarifying this.
> 
> For my personal information, is there any particular reason to set
> an intermediate 'sleep_length' in tick_nohz_stop_sched_tick instead
> of doing what does this patch ?

May be we could do it that way yeah. Is menu_select() called only there?
I don't know how much difference that would make.

> 
> Thanks
>   -- Daniel
> 
> -- 
>  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs
> 
> Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
> <http://twitter.com/#!/linaroorg> Twitter |
> <http://www.linaro.org/linaro-blog/> Blog
> 
