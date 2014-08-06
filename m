Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755195AbaHFA5X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 20:57:23 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:13297 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751081AbaHFA5W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 20:57:22 -0400
Date: Tue, 5 Aug 2014 20:57:11 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org,
        mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, tglx@linutronix.de, peterz@infradead.org,
        dhowells@redhat.com, edumazet@google.com, dvhart@linux.intel.com,
        fweisbec@gmail.com, bobby.prani@gmail.com
Subject: Re: [PATCH v3 tip/core/rcu 3/9] rcu: Add synchronous grace-period
 waiting for RCU-tasks
Message-ID: <20140805205711.7a52076c@gandalf.local.home>
In-Reply-To: <20140802225857.GC8101@linux.vnet.ibm.com>
References: <20140731215445.GA21933@linux.vnet.ibm.com>
	<1406843709-23396-1-git-send-email-paulmck@linux.vnet.ibm.com>
	<1406843709-23396-3-git-send-email-paulmck@linux.vnet.ibm.com>
	<20140801150926.GA845@redhat.com>
	<20140801183251.GJ4784@linux.vnet.ibm.com>
	<20140801194417.GA27141@linux.vnet.ibm.com>
	<20140802144719.GA18018@redhat.com>
	<20140802225857.GC8101@linux.vnet.ibm.com>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2 Aug 2014 15:58:57 -0700
"Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:

> On Sat, Aug 02, 2014 at 04:47:19PM +0200, Oleg Nesterov wrote:
> > On 08/01, Paul E. McKenney wrote:
> > >
> > > On Fri, Aug 01, 2014 at 11:32:51AM -0700, Paul E. McKenney wrote:
> > > > On Fri, Aug 01, 2014 at 05:09:26PM +0200, Oleg Nesterov wrote:
> > > > > On 07/31, Paul E. McKenney wrote:
> > > > > >
> > > > > > +void synchronize_rcu_tasks(void)
> > > > > > +{
> > > > > > +	/* Complain if the scheduler has not started.  */
> > > > > > +	rcu_lockdep_assert(!rcu_scheduler_active,
> > > > > > +			   "synchronize_rcu_tasks called too soon");
> > > > > > +
> > > > > > +	/* Wait for the grace period. */
> > > > > > +	wait_rcu_gp(call_rcu_tasks);
> > > > > > +}
> > > > >
> > > > > Btw, what about CONFIG_PREEMPT=n ?
> > > > >
> > > > > I mean, can't synchronize_rcu_tasks() be synchronize_sched() in this
> > > > > case?
> > > >
> > > > Excellent point, indeed it can!
> > > >
> > > > And if I do it right, it will make CONFIG_TASKS_RCU=y safe for kernel
> > > > tinification.  ;-)
> > >
> > > Unless, that is, we need to wait for trampolines in the idle loop...
> > >
> > > Sounds like a question for Steven.  ;-)
> > 
> > Sure, but the full blown synchronize_rcu_tasks() can't handle the idle threads
> > anyway. An idle thread can not be deactivated and for_each_process() can't see
> > it anyway.
> 
> Indeed, if idle threads need to be tracked, their tracking will need to
> be at least partially special-cased.
> 

Yeah, idle threads can be affected by the trampolines. That is, we can
still hook a trampoline to some function in the idle loop.

But we should be able to make the hardware call that puts the CPU to
sleep a quiescent state too. May need to be arch dependent. :-/

-- Steve
