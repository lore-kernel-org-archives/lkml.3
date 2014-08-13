Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753353AbaHMU4b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 16:56:31 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:57109 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751529AbaHMU4a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 16:56:30 -0400
Date: Wed, 13 Aug 2014 13:56:23 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, tglx@linutronix.de, dhowells@redhat.com,
        edumazet@google.com, dvhart@linux.intel.com, fweisbec@gmail.com,
        oleg@redhat.com, bobby.prani@gmail.com
Subject: Re: [PATCH v5 tip/core/rcu 15/16] rcu: Make RCU-tasks wait for idle
 tasks
Message-ID: <20140813205623.GA7967@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140811224840.GA25594@linux.vnet.ibm.com>
 <1407797345-28227-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1407797345-28227-15-git-send-email-paulmck@linux.vnet.ibm.com>
 <20140813081215.GB9918@twins.programming.kicks-ass.net>
 <20140813124818.GQ4752@linux.vnet.ibm.com>
 <20140813134025.GN9918@twins.programming.kicks-ass.net>
 <20140813095132.56d288f2@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140813095132.56d288f2@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14081320-6688-0000-0000-000003FDC8E8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 13, 2014 at 09:51:32AM -0400, Steven Rostedt wrote:
> On Wed, 13 Aug 2014 15:40:25 +0200
> Peter Zijlstra <peterz@infradead.org> wrote:
> 
> > On Wed, Aug 13, 2014 at 05:48:18AM -0700, Paul E. McKenney wrote:
> > > On Wed, Aug 13, 2014 at 10:12:15AM +0200, Peter Zijlstra wrote:
> > > > On Mon, Aug 11, 2014 at 03:49:04PM -0700, Paul E. McKenney wrote:
> > > > > From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> > > > > 
> > > > > Because idle-task code may need to be patched, RCU-tasks need to wait
> > > > > for idle tasks to schedule.  This commit therefore detects this case
> > > > > via context switch.  Block CPU hotplug during this time to avoid sending
> > > > > IPIs to offline CPUs.
> > > > > 
> > > > > Note that checking for changes in the dyntick-idle counters is tempting,
> > > > > but wrong.  The reason that it is wrong is that a interrupt or NMI can
> > > > > increment these counters without necessarily allowing the idle tasks to
> > > > > make any forward progress.
> > > > 
> > > > I'm going to NAK this.. with that rcu_idle patch I send there's
> > > > typically only a single idle function thats out of bounds and if its
> > > > more it can be made that with a bit of tlc to the cpuidle driver in
> > > > question.
> > > > 
> > > > This needs _FAR_ more justification than a maybe and a want.
> > > 
> > > Peter, your patch might be a good start, but I didn't see any reaction
> > > from Steven or Masami and it did only x86.
> > 
> > That's not an excuse for doing horrible things. And inventing new infra
> > that needs to wake all CPUs is horrible.
> 
> I still need to look at the patches, but if this is just for the idle
> case, then we don't need it. The idle case can be solved with a simple
> sched_on_each_cpu(). I need a way to solve waiting for processes to
> finish from a preemption point.
> 
> That's all I want, and if we can remove the "idle" case and document it
> well that it's not covered and a sched_on_each_cpu() may be needed,
> then I'm fine with that.
> 
> 	sched_on_each_cpu(dummy_op);
> 	call_rcu_tasks(free_tramp);
> 
> Would that work?

If you are taking that approach, I can of course drop my commit dealing
with idle tasks.  Should the rcu_idle_enter() and rcu_idle_exit() calls
avoid cover any functions needing trampolines, it would be easy to pull
them back in -- especially given that the RCU dyntick-idle information
would call out the quiescent states appropriately.

So unless you tell me otherwise, Steven, I will drop the idle-detection
commit in favor of your sched_on_each_cpu() approach.

							Thanx, Paul

