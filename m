Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751211AbaLPWzL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 17:55:11 -0500
Received: from www.linutronix.de ([62.245.132.108]:52061 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751044AbaLPWzJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 17:55:09 -0500
Date: Tue, 16 Dec 2014 23:54:51 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Peter Zijlstra <peterz@infradead.org>
cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Fengguang Wu <fengguang.wu@intel.com>,
        Frederic Weisbecker <frederic@kernel.org>,
        "Pan, Jacob jun" <jacob.jun.pan@intel.com>,
        LKML <linux-kernel@vger.kernel.org>, LKP <lkp@01.org>
Subject: Re: [nohz] 2a16fc93d2c: kernel lockup on idle injection
In-Reply-To: <20141216224903.GS3219@twins.programming.kicks-ass.net>
Message-ID: <alpine.DEB.2.11.1412162350110.17382@nanos>
References: <CAKohpokEw6f5+u8J_AoV76sOAQO=J8dGhX1eZb=QZOuE+Jhq_A@mail.gmail.com> <548E8D01.9050707@linux.vnet.ibm.com> <CAKohpo=C8Jv-+CtmDO+QJ-_=3dNwsk6_W0gtRRHmtSQ8_LgObQ@mail.gmail.com> <20141215234443.GA23297@lerouge> <CAKohpokOuOqvpNt4_y2tHPTM8nKLyEg=-gN4NDe1_mqpy=Vrow@mail.gmail.com>
 <548FFD20.1040102@linux.vnet.ibm.com> <alpine.DEB.2.11.1412161105470.17382@nanos> <20141216142029.GA27375@lerouge> <alpine.DEB.2.11.1412161533210.17382@nanos> <alpine.DEB.2.11.1412161802570.17382@nanos>
 <20141216224903.GS3219@twins.programming.kicks-ass.net>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Dec 2014, Peter Zijlstra wrote:
> On Tue, Dec 16, 2014 at 10:21:27PM +0100, Thomas Gleixner wrote:
> > /* rq->lock is held for evaluating rq->nr_running */
> > static void sched_ttwu_remote_nohz(struct rq *rq)
> > {
> > 	if (nohz_full_disabled())
> > 		return;
> > 
> > 	if (rq->nr_running != 2)
> > 	   	return;
> > 	/*
> > 	 * Force smp_send_reschedule(). irq_exit() on the
> > 	 * remote cpu will handle the rest.
> > 	 */
> 
> smp_send_reschedule() is magic and does not guarantee irq_{enter,exit}()
> being called, although we could audit and fix that.

I know. I did not want to do all the work for the nohz
folks. Otherwise I would have simply sent a patch. :)
 
> > 	if (!task_uses_posix_timers(task))
> > 		clear_bit(NOHZ_POSIXTIMER_NEEDS_TICK,
> > 			  this_cpu_ptr(nohz_full_must_tick));
> > 	else
> > 		set_bit(NOHZ_POSIXTIMER_NEEDS_TICK,
> > 			this_cpu_ptr(nohz_full_must_tick));
> > 
> 
> /me hands you a few spare {} :-)

Without the proper instruction manual they are pretty useless.
 
> Arguably test state before doing a possibly pointless update?
> 
> > 	local_irq_disable();
> > 	tick_full_nohz_update_state();
> > 	local_irq_enable();
> > }
> 
> But yes, that should work just fine..

So I'm not the only one who thinks that this needs a proper
reimplementation :)

Thanks,

	tglx

