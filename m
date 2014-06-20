Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753833AbaFTTMo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 15:12:44 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:47718 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751817AbaFTTMn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 15:12:43 -0400
Date: Fri, 20 Jun 2014 12:12:36 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, dvhart@linux.intel.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu
Subject: Re: [PATCH tip/core/rcu 0/5] Fix for cond_resched performance
 regression
Message-ID: <20140620191236.GA10340@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140620183249.GA6325@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140620183249.GA6325@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14062019-0928-0000-0000-000002CB7B23
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 20, 2014 at 11:32:49AM -0700, Paul E. McKenney wrote:
> Hello!
> 
> This series contains changes to address the performance regressions
> introduced by commit ac1bea85781e (Make cond_resched() report RCU
> quiescent states), which was in turn fixing a problem where tasks looping
> in the kernel could delay RCU grace periods.  The changes in this series
> are as follows:
> 
> 1.	Reduce the overhead of checking added to cond_resched() and friends.
> 
> 2.	Add a new cond_resched_rcu_qs() to provide RCU quiescent states
> 	even if cond_resched() should stop doing so.
> 
> 3.	Add a new RCU_COND_RESCHED_QS to prevent cond_resched() from
> 	reporting RCU quiescent states.
> 
> 4.	Prevent rcutorture testing from reporting spurious RCU CPU stall
> 	warnings, and also to test RCU_COND_RESCHED_QS.
> 
> 5.	Provides a boot/sysfs rcutree.jiffies_till_cond_resched_qs
> 	parameter to replace the magic "7".

And alternatives considered thus far:

o	Just revert commit ac1bea85781e (Make cond_resched() report RCU
	quiescent states).  This would bring back the RCU CPU stalls
	and OOMs that this commit was designed to fix.

o	Just have cond_resched_rcu_qs() provide RCU quiescent states,
	and leave cond_resched() unchanged.  This is in fact what
	the default RCU_COND_RESCHED_QS=y does, but the advantage
	of allowing RCU_COND_RESCHED_QS=y is that it provides a good
	workaround for cases where cond_resched() calls need to change
	to cond_resched_rcu_qs().

o	Push the checks further into cond_resched(), so that the
	fastpath does the same sequence of instructions that the original
	did.  This might work well, but requires IPIs, which are not so
	good for latencies on the remote CPU.  It nevertheless might be a
	decent long-term solution given that if your CPU is spending many
	jiffies looping in the kernel, you aren't getting good latencies
	anyway.  It also has the benefit of allowing RCU to take advantage
	of the implicit quiescent states of all cond_resched() calls,
	and of eliminating the need for a separate cond_resched_rcu_qs()
	and for RCU_COND_RESCHED_QS.

o	Remove cond_resched() calls from various fastpaths.  These were
	presumably put there for a reason, and there might be situations
	where that reason still holds.

o	Make cond_resched() a no-op for PREEMPT=y.  This might well turn
	out to be a good thing, but it doesn't help give RCU the quiescent
	states that it needs.

o	Other thoughts?

							Thanx, Paul

