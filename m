Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932397AbaHGPAs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 11:00:48 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:47084 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932128AbaHGPAq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 11:00:46 -0400
Date: Thu, 7 Aug 2014 08:00:31 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, Oleg Nesterov <oleg@redhat.com>,
        linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org,
        tglx@linutronix.de, dhowells@redhat.com, edumazet@google.com,
        dvhart@linux.intel.com, fweisbec@gmail.com, bobby.prani@gmail.com
Subject: Re: [PATCH v3 tip/core/rcu 3/9] rcu: Add synchronous grace-period
 waiting for RCU-tasks
Message-ID: <20140807150031.GB5821@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140801194417.GA27141@linux.vnet.ibm.com>
 <20140802144719.GA18018@redhat.com>
 <20140802225857.GC8101@linux.vnet.ibm.com>
 <20140805205711.7a52076c@gandalf.local.home>
 <20140806012139.GY8101@linux.vnet.ibm.com>
 <20140806084708.GR9918@twins.programming.kicks-ass.net>
 <20140806120958.GZ8101@linux.vnet.ibm.com>
 <20140806163035.GG19379@twins.programming.kicks-ass.net>
 <20140806224518.GA8101@linux.vnet.ibm.com>
 <20140807084544.GJ19379@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140807084544.GJ19379@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14080715-0928-0000-0000-000003F37792
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 07, 2014 at 10:45:44AM +0200, Peter Zijlstra wrote:
> On Wed, Aug 06, 2014 at 03:45:18PM -0700, Paul E. McKenney wrote:
> > > > > But I still very much hate the polling stuff...
> > 
> > The nice thing about the polling approach is minimal overhead in the
> > common case where RCU-tasks is not in use.
> 
> No, quite the reverse, there is overhead when its not in use, as opposed
> to no overhead at all.

Say what???

> I'm still not convinced we need this 'generic' rcu-task stuff and create
> yet another kthread with polling semantics, we want to let the system
> idle out when there's nothing to do, not keep waking it up.

Which is exactly what happens.  The kthread is created only at first
use, so if no one uses RCU-tasks, then no kthread is created, see
https://lkml.org/lkml/2014/8/4/630.  Even if a kthread is created, if
there is no more work for it to do, it sleeps indefinitely.  See for
example https://lkml.org/lkml/2014/8/4/629.

> So do we really need the call_rcu_task() thing and why isn't something
> like synchronize_tasks() good enough?

Sounds like a question for Steven.

> So the thing is, the one proposed user is very rare (*) and for that
> you're adding overhead outside of that user (a separate kthread) and
> your adding overhead when its not used.

If that really was the case, that would be bad.  However, in the latest
versions, that is no longer the case.

> * I'm assuming that, since tracing is 'rare' and this is some tracing
> thing.

Another good point for Steven.

							Thanx, Paul

