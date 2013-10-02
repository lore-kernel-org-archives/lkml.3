Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754174Ab3JBP5V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 11:57:21 -0400
Received: from mail-lb0-f181.google.com ([209.85.217.181]:41439 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753662Ab3JBP5S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 11:57:18 -0400
MIME-Version: 1.0
In-Reply-To: <1380709565-22153-1-git-send-email-daniel.lezcano@linaro.org>
References: <1380709565-22153-1-git-send-email-daniel.lezcano@linaro.org>
Date: Wed, 2 Oct 2013 17:57:17 +0200
Message-ID: <CAFTL4hw-yawRUO-8ePsonvh1o2P7T5yb+GFPVop5OHzH6HTobw@mail.gmail.com>
Subject: Re: [PATCH V2] tick: Make sleep length calculation more accurate
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Stephen Boyd <sboyd@codeaurora.org>,
        LKML <linux-kernel@vger.kernel.org>, patches@linaro.org,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/10/2 Daniel Lezcano <daniel.lezcano@linaro.org>:
> The sleep_length is computed in the tick_nohz_stop_sched_tick function but it
> is used later in the code with in between the local irq enabled.
>
> cpu_idle_loop
>   tick_nohz_idle_enter         [ exits with local irq enabled ]
>    __tick_nohz_idle_enter
>      tick_nohz_stop_sched_tick
>   ...
>
>   arch_cpu_idle
>      menu_select               [ uses here 'sleep_length' ]
>   ...
>
> Between the computation of the sleep length and its usage, some interrupts
> may occur, making the sleep length shorter than actually it is because of the
> interrupt processing

So, do you mean that the ts->sleep_length would return a value that is too long
given that the CPU already spent some time to service the irqs since we computed
the sleep length in tick_nohz_idle_enter()?

But then tick_nohz_irq_exit() should take care of that as it calls
again tick_nohz_stop_sched_tick().
So I'm a bit confused.

> or different if the timer itself expired.

Same here, if the timer expired, it triggers an interrupt which can do
two things:

1) reprogram a new timer and this recompute sleep_length
2) set_need_resched() and then exit the idle loop, so arch_cpu_idle() won't even
be called. Or the timer interrupts hlt, but then menu_select() was
called before.

So I probably missed something here.

Thanks.
