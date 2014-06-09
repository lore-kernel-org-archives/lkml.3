Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755340AbaFIOpO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 10:45:14 -0400
Received: from www.linutronix.de ([62.245.132.108]:45119 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751587AbaFIOpM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 10:45:12 -0400
Date: Mon, 9 Jun 2014 16:44:54 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Stanislav Fomichev <stfomichev@yandex-team.ru>
cc: viresh.kumar@linaro.org, paul.gortmaker@windriver.com,
        peterz@infradead.org, stuart.w.hayes@gmail.com,
        david.vrabel@citrix.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] hrtimers: add fast path to hrtimer_get_next_event
In-Reply-To: <20140609125931.GL26511@stfomichev-desktop.yandex.net>
Message-ID: <alpine.DEB.2.10.1406091635080.3830@nanos>
References: <1402305825-3015-1-git-send-email-stfomichev@yandex-team.ru> <alpine.DEB.2.10.1406091304140.3830@nanos> <20140609111115.GK26511@stfomichev-desktop.yandex.net> <20140609125931.GL26511@stfomichev-desktop.yandex.net>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Jun 2014, Stanislav Fomichev wrote:

> In hrtimer_get_next_event we unconditionally lock/unlock spinlock, even if it's
> not required (hrtimer_hres_active() != 0). This patch adds fast path
> when highres is active so we don't execute unnecessary operations.
> 
> We can safely do lockless check because:
> - hrtimer_get_next_event is always called with interrupts disabled;
> - we may switch to hres only from softirq handler with disabled interrupts.
> 
> Because we only care about hres_active which may be changed only from
> local CPU, we can use interrupt context for synchronization.
> 
> run_timer_softirq
>   hrtimer_run_pending
>     hrtimer_switch_to_hres
>       local_irq_save <-
>       base->hres_active = 0
> 
> tick_nohz_idle_enter
>   local_irq_disable <-
>   __tick_nohz_idle_enter
>     tick_nohz_stop_sched_tick
>       get_next_timer_interrupt
>         cmp_next_hrtimer_event
>           hrtimer_get_next_event
>           check base->hres_active
> 
> irq_exit <- irq context
>   tick_irq_exit
>     tick_nohz_irq_exit
>       tick_nohz_full_stop_tick
>         tick_nohz_stop_sched_tick
>             ... <see above>
>       __tick_nohz_idle_enter
>         ... <see above>

Sigh. Is anybody actually reading and trying to understand what I
write in reviews?

> Also the lockless check wants a comment why it is correct.

Is it that hard? A comment is NOT a uberlenghty explanation in the
changelog. A comment starts with /* and ends with */ and is in the
code.

	/*
	 * Called with interrupts disabled and therefor
	 * protected against a switch to high resolution mode.
	 */
 
That's a comment, right?

Thanks,

	tglx
