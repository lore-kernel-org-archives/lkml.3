Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753301AbaIYOf4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 10:35:56 -0400
Received: from www.linutronix.de ([62.245.132.108]:33915 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752914AbaIYOfz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 10:35:55 -0400
Date: Thu, 25 Sep 2014 16:35:49 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Dave Jones <davej@redhat.com>
cc: linux-mm@kvack.org, Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: hrtimer deadlock caused by nohz_full
In-Reply-To: <20140925141425.GA21702@redhat.com>
Message-ID: <alpine.DEB.2.10.1409251630210.4604@nanos>
References: <20140925141425.GA21702@redhat.com>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Sep 2014, Dave Jones wrote:

> Got this on a box that had been fuzzing for 12 hours or so.
> There's also some timer stuff going on htere, so cc'ing the usual suspects.

And it's a hrtimer lockup
 
>  [<ffffffffa10f95f8>] ? hrtimer_try_to_cancel+0x58/0x1f0
>  [<ffffffffa10d103d>] ? lock_release+0x1d/0x300
>  [<ffffffffa10d103d>] ? lock_release+0x1d/0x300
>  [<ffffffffa10f95f8>] ? hrtimer_try_to_cancel+0x58/0x1f0
>  [<ffffffffa10d103d>] ? lock_release+0x1d/0x300
>  <<EOE>>  <IRQ>  [<ffffffffa1823ac4>] _raw_spin_unlock_irqrestore+0x24/0x70
>  [<ffffffffa10f95f8>] hrtimer_try_to_cancel+0x58/0x1f0
>  [<ffffffffa10f97aa>] hrtimer_cancel+0x1a/0x30
>  [<ffffffffa110a0e7>] tick_nohz_restart+0x17/0x90
>  [<ffffffffa110af38>] __tick_nohz_full_check+0xc8/0xe0
>  [<ffffffffa110af5e>] nohz_full_kick_work_func+0xe/0x10
>  [<ffffffffa117c9bf>] irq_work_run_list+0x4f/0x70
>  [<ffffffffa117ca0a>] irq_work_run+0x2a/0x60
>  [<ffffffffa10f82eb>] update_process_times+0x5b/0x70
>  [<ffffffffa1109dc5>] tick_sched_handle.isra.21+0x25/0x60
>  [<ffffffffa110a0b1>] tick_sched_timer+0x41/0x60
>  [<ffffffffa10f8c71>] __run_hrtimer+0x81/0x480
>  [<ffffffffa110a070>] ? tick_sched_do_timer+0x90/0x90
>  [<ffffffffa10f9b27>] hrtimer_interrupt+0x107/0x260
>  [<ffffffffa10331a4>] local_apic_timer_interrupt+0x34/0x60
>  [<ffffffffa182734f>] smp_apic_timer_interrupt+0x3f/0x60
>  [<ffffffffa182576f>] apic_timer_interrupt+0x6f/0x80

hrtimer_interrupt
  tick_sched_timer
    tick_sched_handle
      update_process_times
        irq_work_run
	  irq_work_run_list
	    nohz_full_kick_work_func
	      __tick_nohz_full_check
	        tick_nohz_restart
                  hrtimer_cancel

And that hrtimer_cancel is:

static void tick_nohz_restart(struct tick_sched *ts, ktime_t now)
{
	hrtimer_cancel(&ts->sched_timer);

Now, that's really bad because we are in the timer callback of
ts->sched_timer. So hrtimer_cancel will loop forever waiting for the
callback to complete.

Frederic !?!?

Thanks,

	tglx
