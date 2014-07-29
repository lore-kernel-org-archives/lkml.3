Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752198AbaG2TZL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 15:25:11 -0400
Received: from casper.infradead.org ([85.118.1.10]:39063 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751165AbaG2TZK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 15:25:10 -0400
Date: Tue, 29 Jul 2014 21:25:04 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org,
        tglx@linutronix.de, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, dvhart@linux.intel.com, fweisbec@gmail.com,
        oleg@redhat.com, bobby.prani@gmail.com
Subject: Re: [PATCH RFC tip/core/rcu 1/9] rcu: Add call_rcu_tasks()
Message-ID: <20140729192504.GO3935@laptop>
References: <20140728225556.GA19493@linux.vnet.ibm.com>
 <1406588180-21933-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <20140729075055.GY19379@twins.programming.kicks-ass.net>
 <20140729155747.GO11241@linux.vnet.ibm.com>
 <20140729160754.GW20603@laptop.programming.kicks-ass.net>
 <20140729163312.GR11241@linux.vnet.ibm.com>
 <20140729173121.GL3935@laptop>
 <20140729181949.GZ11241@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140729181949.GZ11241@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 29, 2014 at 11:19:49AM -0700, Paul E. McKenney wrote:
> > I feel we're doing far too much async stuff already and it keeps getting
> > worse and worse. Ideally we'd be able to account every cycle of kernel
> > 'overhead' to a specific user action.
> 
> Hmmm...
> 
> In theory, we could transfer the overhead of the kthread for a given grace
> period to the task invoking the corresponding synchronize_rcu_tasks().
> In practice, the overhead might need to be parceled out among several
> tasks that concurrently invoked synchronize_rcu_tasks().  Or I suppose
> that the overhead could be assigned to the first such task that woke
> up, on the theory that things would even out over time.
> 
> So exactly how annoyed are you about the lack of accounting?  ;-)

Its a general annoyance that people don't seem to consider this at all.

And RCU isn't the largest offender by a long shot.

> > Another reason is that I fundamentally dislike polling stuff.. but yes,
> > I'm not really seeing how to do this differently, partly because I'm not
> > entirely sure why we need this to begin with. I'm not sure what problem
> > we're solving.
> 
> As I recall it...
> 
> Steven is working on some sort of tracing infrastructure that involves
> dynamically allocated trampolines being inserted into some/all functions.
> The trampoline code can be preempted, but never does voluntary context
> switches, and presumably never calls anything that does voluntary
> context switches.
> 
> Easy to insert a trampoline, but the trick is removing them.
> 
> The thought is to restore the instructions at the begining of the
> function in question, wait for an RCU-tasks grace period, then dispose
> of the trampoline.
> 
> Of course, you could imagine disabling preemption or otherwise entering
> an RCU read-side critical section before transferring to the trampoline,
> but this was apparently a no-go due to the overhead for small functions.

So why not use the freezer to get the kernel into a known good state and
then remove them trampolines? That would mean a more noticeable
disruption of service, but it might be ok for something like disabling a
tracer or so. Dunno.

Kernel threads are the problem here, lemme ponder this for a bit.
