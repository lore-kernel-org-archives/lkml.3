Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754367Ab3IIPjJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 11:39:09 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:28878 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751731Ab3IIPjH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 11:39:07 -0400
X-Authority-Analysis: v=2.0 cv=V4T/IJbi c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=JDfofD-L5ZgA:10 a=5SG0PmZfjMsA:10 a=kj9zAlcOel0A:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=5p3hctMY2UsA:10 a=uwYOJEjIlVa52CM69hYA:9 a=CjuIK1q_8ugA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Date: Mon, 9 Sep 2013 11:39:05 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Eric Dumazet <eric.dumazet@gmail.com>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        sbw@mit.edu
Subject: Re: [PATCH] rcu: Is it safe to enter an RCU read-side critical
 section?
Message-ID: <20130909113905.0c7d65d7@gandalf.local.home>
In-Reply-To: <20130909112057.35403440@gandalf.local.home>
References: <20130906174117.GU3966@linux.vnet.ibm.com>
	<20130906185927.GE2706@somewhere>
	<20130909105347.GK31370@twins.programming.kicks-ass.net>
	<20130909121329.GA16280@somewhere>
	<20130909083926.3eceebef@gandalf.local.home>
	<20130909124547.GB16280@somewhere>
	<20130909085504.2ddd7e69@gandalf.local.home>
	<20130909130851.GC16280@somewhere>
	<20130909092142.05780991@gandalf.local.home>
	<20130909092917.0c99b71a@gandalf.local.home>
	<20130909144037.GH16280@somewhere>
	<20130909112057.35403440@gandalf.local.home>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Sep 2013 11:20:57 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> > It's a bit the same with spinlocks. spinlocks aren't a task synchronization
> > but a CPU synchronization. It's low level. Of course a task can't sleep
> > with a spinlock held (not talking about -rt) so it could be defined as a per
> > task property. But it's just not relevant.
> 
> Again, this is where we get into trouble. No it is not a CPU
> synchronization. We only disable preemption because of implementation
> details. Not the concept. A spin lock is only used to protect critical
> data, and not to disable preemption. Those that use it to disable
> preemption has caused us issues in -rt.
> 
> This is again the problem with confusing implementation with concepts.
> -rt proved that a spin lock has nothing to do with cpu state, nor
> preemption.
> 

Let me expand on this. Note, using a implementation detail from a item
is known as a side effect, and is frowned on when doing so.

In fact, when spin_locks() were created, it was just to point out where
critical sections are that prevent more than one task from accessing
some data at the same time. This was needed for multiple CPUs. This was
done before CONFIG_PREEMPT was even created.

Then Robert Love built on that concept where these same locations
had a characteristic that showed where two tasks can not access the
same data, and used that as preemption points. Points where we can not
be preempted, and let the kernel become preemptible.

Then -rt built further on the concept, and made these locations able to
sleep by removing the areas that could not sleep before (by threading
IRQs).

Again, the concept of a spin lock is not about the CPU or even the
task. It is about accessing some data in a safe way. When we stick to
concepts, we can expand on them as we did with CONFIG_PREEMPT and
CONFIG_PREEMPT_RT. It's when people use side effects (disabled
preemption) that breaks this expansion (like those that use spin_locks
and access per_cpu data).

-- Steve
