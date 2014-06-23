Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754730AbaFWOy7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 10:54:59 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:60647 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753715AbaFWOy5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 10:54:57 -0400
Date: Mon, 23 Jun 2014 06:33:41 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org,
        tglx@linutronix.de, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, dvhart@linux.intel.com, fweisbec@gmail.com,
        oleg@redhat.com, dave.hansen@intel.com, ak@linux.intel.com,
        cl@gentwo.org, umgwanakikbuti@gmail.com
Subject: Re: [PATCH tip/core/rcu] Reduce overhead of cond_resched() checks
 for RCU
Message-ID: <20140623133341.GA4603@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140621025958.GA7185@linux.vnet.ibm.com>
 <20140623062615.GB19860@laptop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140623062615.GB19860@laptop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14062314-1542-0000-0000-000002C4824A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 23, 2014 at 08:26:15AM +0200, Peter Zijlstra wrote:
> On Fri, Jun 20, 2014 at 07:59:58PM -0700, Paul E. McKenney wrote:
> > Commit ac1bea85781e (Make cond_resched() report RCU quiescent states)
> > fixed a problem where a CPU looping in the kernel with but one runnable
> > task would give RCU CPU stall warnings, even if the in-kernel loop
> > contained cond_resched() calls.  Unfortunately, in so doing, it introduced
> > performance regressions in Anton Blanchard's will-it-scale "open1" test.
> > The problem appears to be not so much the increased cond_resched() path
> > length as an increase in the rate at which grace periods complete, which
> > increased per-update grace-period overhead.
> > 
> > This commit takes a different approach to fixing this bug, mainly by
> > moving the RCU-visible quiescent state from cond_resched() to
> > rcu_note_context_switch(), and by further reducing the check to a
> > simple non-zero test of a single per-CPU variable.  However, this
> > approach requires that the force-quiescent-state processing send
> > resched IPIs to the offending CPUs.  These will be sent only once
> > the grace period has reached an age specified by the boot/sysfs
> > parameter rcutree.jiffies_till_sched_qs, or once the grace period
> > reaches an age halfway to the point at which RCU CPU stall warnings
> > will be emitted, whichever comes first.
> 
> Right, and I suppose the force quiescent stuff is triggered from the
> tick, which in turn wakes some of these rcu kthreads, which on UP would
> cause scheduling themselves.

Yep, which is another reason why this commit only affects TREE_RCU and
TREE_PREEMPT_RCU, not TINY_RCU.

> On the topic of these threads; I recently noticed RCU grew a metric ton
> of them, I found some 75 rcu kthreads on my box, wth up with that?

The most likely cause of a recent increase would be if you now have
CONFIG_RCU_NOCB_CPU_ALL=y, which would give you a pair of kthreads per
CPU for callback offloading.  Plus an additional kthread per CPU (for
a total of three new kthreads per CPU) for CONFIG_PREEMPT=y.  These would
be the rcuo kthreads.

Are they causing you trouble?

							Thanx, Paul

