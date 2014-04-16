Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754021AbaDPFTT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 01:19:19 -0400
Received: from merlin.infradead.org ([205.233.59.134]:56448 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751417AbaDPFTS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 01:19:18 -0400
Date: Wed, 16 Apr 2014 07:19:09 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: cl@linux.com, linux-kernel@vger.kernel.org, mingo@kernel.org,
        tj@kernel.org, grygorii.strashko@ti.com
Subject: Re: How do I increment a per-CPU variable without warning?
Message-ID: <20140416051909.GJ26782@laptop.programming.kicks-ass.net>
References: <20140415221755.GA27188@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140415221755.GA27188@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 15, 2014 at 03:17:55PM -0700, Paul E. McKenney wrote:
> Hello, Christoph,
> 
> I have a patch that currently uses __this_cpu_inc_return() to increment a
> per-CPU variable, but without preemption disabled.  Of course, given that
> preemption is enabled, it might well end up picking up one CPU's counter,
> adding one to it, then storing the result into some other CPU's counter.
> But this is OK, the test can be probabilistic.  And when I run this
> against v3.14 and earlier, it works fine.
> 
> But now there is 188a81409ff7 (percpu: add preemption checks to
> __this_cpu ops), which gives me lots of splats.
> 
> My current admittedly crude workaround is as follows:
> 
> 	static inline bool rcu_should_resched(void)
> 	{
> 		int t;
> 
> 	#ifdef CONFIG_DEBUG_PREEMPT
> 		preempt_disable();
> 	#endif /* #ifdef CONFIG_DEBUG_PREEMPT */
> 		t = __this_cpu_read(rcu_cond_resched_count) + 1;
> 		if (t < RCU_COND_RESCHED_LIM) {
> 			__this_cpu_write(rcu_cond_resched_count, t);
> 	#ifdef CONFIG_DEBUG_PREEMPT
> 			preempt_enable();
> 	#endif /* #ifdef CONFIG_DEBUG_PREEMPT */
> 			return false;
> 		}
> 	#ifdef CONFIG_DEBUG_PREEMPT
> 		preempt_enable();
> 	#endif /* #ifdef CONFIG_DEBUG_PREEMPT */
> 		return true;
> 	}
> 
> This is arguably better than the original __this_cpu_read() because it
> avoids overflow, but I thought I should check to see if there was some
> better way to do this.

you could use raw_cpu_{read,write}(). But note that without the
unconditional preempt_disable() in there your code can read a different
rcu_cond_resched_count than it writes.

So I think you very much want that preempt_disable().
