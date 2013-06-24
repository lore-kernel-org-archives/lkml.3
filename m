Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752738Ab3FXRkk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 13:40:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1483 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752632Ab3FXRki (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 13:40:38 -0400
Date: Mon, 24 Jun 2013 19:35:10 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Dave Jones <davej@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrey Vagin <avagin@openvz.org>, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: frequent softlockups with 3.10rc6.
Message-ID: <20130624173510.GA1321@redhat.com>
References: <20130620161652.GA4462@linux.vnet.ibm.com> <20130621151119.GA1596@redhat.com> <20130621195949.GA15519@redhat.com> <20130622013731.GA22918@redhat.com> <20130622173129.GA29375@redhat.com> <20130622215905.GA28238@redhat.com> <20130623143634.GA2000@redhat.com> <20130623150603.GA32313@redhat.com> <20130623160452.GA11740@redhat.com> <20130624155758.GA5993@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130624155758.GA5993@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/24, Dave Jones wrote:
>
> On Sun, Jun 23, 2013 at 06:04:52PM +0200, Oleg Nesterov wrote:
>  >
>  > Could you please do the following:
>  >
>  > 	1. # cd /sys/kernel/debug/tracing
>  > 	   # echo 0 >> options/function-trace
>  > 	   # echo preemptirqsoff >> current_tracer
>  >
>  > 	2. reproduce the lockup again
>  >
>  > 	3. show the result of
>  > 	   # cat trace
>
> Not sure this is helpful, but..

This makes me think that something is seriously broken.

Or I do not understand this stuff at all. Quite possible too.
Steven, could you please help?

> # preemptirqsoff latency trace v1.1.5 on 3.10.0-rc7+
> # --------------------------------------------------------------------
> # latency: 165015310 us, #4/4, CPU#1 | (M:preempt VP:0, KP:0, SP:0 HP:0 #P:4)

OK, 165015310/1000000 = 165, nice.

> #    -----------------
> #    | task: trinity-child1-3173 (uid:1000 nice:19 policy:0 rt_prio:0)
> #    -----------------
> #  => started at: vprintk_emit
> #  => ended at:   vprintk_emit
> #
> #
> #                  _------=> CPU#
> #                 / _-----=> irqs-off
> #                | / _----=> need-resched
> #                || / _---=> hardirq/softirq
> #                ||| / _--=> preempt-depth
> #                |||| /     delay
> #  cmd     pid   ||||| time  |   caller
> #     \   /      |||||  \    |   /
> trinity--3173    1dNh1    0us!: console_unlock <-vprintk_emit
> trinity--3173    1dNh1 165015310us : console_unlock <-vprintk_emit
> trinity--3173    1dNh1 165015311us+: stop_critical_timings <-vprintk_emit
> trinity--3173    1dNh1 165015315us : <stack trace>
>  => console_unlock
>  => vprintk_emit
>  => printk
>  => watchdog_timer_fn

But this is already called in the non-preemtible context, how can
'started at' blame vprintk_emit?

>  => __run_hrtimer
>  => hrtimer_interrupt
>  => smp_apic_timer_interrupt
>  => apic_timer_interrupt
>  => _raw_spin_lock

This is where start_critical_timing() should be called?

Or by TRACE_IRQS_OFF in apic_timer_interrupt...

>  => sync_inodes_sb
>  => sync_inodes_one_sb
>  => iterate_supers
>  => sys_sync
>  => tracesys

Also. watchdog_timer_fn() calls printk() only if it detects the
lockup, so I assume you hit another one?

Oleg.

