Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756506AbaDKPOR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 11:14:17 -0400
Received: from merlin.infradead.org ([205.233.59.134]:40814 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754045AbaDKPOQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 11:14:16 -0400
Date: Fri, 11 Apr 2014 17:14:09 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        nicolas.pitre@linaro.org, daniel.lezcano@linaro.org,
        Mike Galbraith <umgwanakikbuti@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH 0/8] sched,idle: need resched polling rework
Message-ID: <20140411151409.GW11096@twins.programming.kicks-ass.net>
References: <20140411134243.160989490@infradead.org>
 <CALCETrWJZ1-T+qOY9v=KBOSJkck7YYe7khw_dYPc9Ar8WFgMKw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrWJZ1-T+qOY9v=KBOSJkck7YYe7khw_dYPc9Ar8WFgMKw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 11, 2014 at 08:00:23AM -0700, Andy Lutomirski wrote:
> That being said, I think that this addresses once one of the two major
> issues.  While the race you're fixing is more interesting, I think its
> impact is dwarfed by the fact that ttwu_queue_remote completely
> ignores polling.  (NB: I haven't actually tested this patch set, but I
> did try to instrument this stuff awhile ago.)
> 
> To fix this, presumably the wake-from-idle path needs a
> sched_ttwu_pending call, and ttwu_queue_remote could use resched_task.
>  sched_ttwu_pending could benefit from a straightforward optimization:
> it doesn't need rq->lock if llist is empty.
> 
> If you're not planning on trying to fix that, I can try to write up a
> patch in the next day or two.

Right; I forgot to write about that; I was going to look at both ttwu
and arch_send_call_function_single_ipi() after this got sorted.

While you didn't complain about the remote function call IPI, Venki
(while @google) did and this was their reason to look at this.

> Even with all of this fixed, what happens when ttwu_queue_remote is
> called with a task that has lower priority than whatever is currently
> running on the targeted cpu?  I think the result is an IPI that serves
> very little purpose other than avoiding taking a spinlock in the
> waking thread.  This may be a bad tradeoff.  I doubt that this matters
> for my particular workload, though.

Today Mike also noted that on very high freq the IPI is actually a lot
slower than doing the remote accesses for some weird reason --
previously I've seen the remote wakeups queue a lot of wakeups and have
the IPI take too long.

So there's definitely something to prod at there.
