Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751430AbaLPWtT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 17:49:19 -0500
Received: from casper.infradead.org ([85.118.1.10]:50492 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750960AbaLPWtS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 17:49:18 -0500
Date: Tue, 16 Dec 2014 23:49:03 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Fengguang Wu <fengguang.wu@intel.com>,
        Frederic Weisbecker <frederic@kernel.org>,
        "Pan, Jacob jun" <jacob.jun.pan@intel.com>,
        LKML <linux-kernel@vger.kernel.org>, LKP <lkp@01.org>
Subject: Re: [nohz] 2a16fc93d2c: kernel lockup on idle injection
Message-ID: <20141216224903.GS3219@twins.programming.kicks-ass.net>
References: <CAKohpokEw6f5+u8J_AoV76sOAQO=J8dGhX1eZb=QZOuE+Jhq_A@mail.gmail.com>
 <548E8D01.9050707@linux.vnet.ibm.com>
 <CAKohpo=C8Jv-+CtmDO+QJ-_=3dNwsk6_W0gtRRHmtSQ8_LgObQ@mail.gmail.com>
 <20141215234443.GA23297@lerouge>
 <CAKohpokOuOqvpNt4_y2tHPTM8nKLyEg=-gN4NDe1_mqpy=Vrow@mail.gmail.com>
 <548FFD20.1040102@linux.vnet.ibm.com>
 <alpine.DEB.2.11.1412161105470.17382@nanos>
 <20141216142029.GA27375@lerouge>
 <alpine.DEB.2.11.1412161533210.17382@nanos>
 <alpine.DEB.2.11.1412161802570.17382@nanos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.11.1412161802570.17382@nanos>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 16, 2014 at 10:21:27PM +0100, Thomas Gleixner wrote:
> DEFINE_PER_CPU(nohz_full_must_tick, unsigned long);
> 
> enum {
>      NOHZ_SCHED_NEEDS_TICK,
>      NOHZ_POSIXTIMER_NEEDS_TICK,
>      NOHZ_PERF_NEEEDS_TICK,
> };
> 
> /* rq->lock is held for evaluating rq->nr_running */
> static void sched_ttwu_nohz(struct rq *rq)
> {
> 	if (nohz_full_disabled())
> 		return;
> 
> 	if (rq->nr_running != 2)
> 		return;
> 	set_bit(NOHZ_SCHED_NEEDS_TICK, this_cpu_ptr(nohz_full_must_tick);
> }
> 
> /* rq->lock is held for evaluating rq->nr_running */
> static void sched_ttwu_remote_nohz(struct rq *rq)
> {
> 	if (nohz_full_disabled())
> 		return;
> 
> 	if (rq->nr_running != 2)
> 	   	return;
> 	/*
> 	 * Force smp_send_reschedule(). irq_exit() on the
> 	 * remote cpu will handle the rest.
> 	 */

smp_send_reschedule() is magic and does not guarantee irq_{enter,exit}()
being called, although we could audit and fix that.

> 	set_bit(NOHZ_SCHED_NEEDS_TICK, per_cpu_ptr(nohz_full_must_tick, rq->cpu);
> 	rq->force_send_resched = true;
> }

I'd make that force_send_resched the return value or so..

> /* rq->lock is held for evaluating rq->nr_running */
> static void sched_out_nohz(struct rq *rq)
> {
> 	if (nohz_full_disabled())
> 		return;
> 
> 	if (rq->nr_running >= 2)
> 	   	return;
> 	clear_bit(NOHZ_SCHED_NEEDS_TICK, this_cpu_ptr(nohz_full_must_tick);
> }
> 
> /* preeemption is disabled */
> static void sched_in_nohz(struct task_struct *task)
> {
> 	if (nohz_full_disabled())
> 		return;
> 
> 	if (!task_uses_posix_timers(task))
> 		clear_bit(NOHZ_POSIXTIMER_NEEDS_TICK,
> 			  this_cpu_ptr(nohz_full_must_tick));
> 	else
> 		set_bit(NOHZ_POSIXTIMER_NEEDS_TICK,
> 			this_cpu_ptr(nohz_full_must_tick));
> 

/me hands you a few spare {} :-)

Arguably test state before doing a possibly pointless update?

> 	local_irq_disable();
> 	tick_full_nohz_update_state();
> 	local_irq_enable();
> }

But yes, that should work just fine..
