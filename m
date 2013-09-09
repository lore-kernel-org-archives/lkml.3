Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753565Ab3IIOQd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 10:16:33 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:20323 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752933Ab3IIOQc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 10:16:32 -0400
X-Authority-Analysis: v=2.0 cv=fJG7LOme c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=JDfofD-L5ZgA:10 a=5SG0PmZfjMsA:10 a=kj9zAlcOel0A:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=5p3hctMY2UsA:10 a=VnNF1IyMAAAA:8 a=knhLouBK5m0vlhZZwPUA:9 a=CjuIK1q_8ugA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Date: Mon, 9 Sep 2013 10:16:29 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: paulmck@linux.vnet.ibm.com
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Eric Dumazet <eric.dumazet@gmail.com>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        sbw@mit.edu
Subject: Re: [PATCH] rcu: Is it safe to enter an RCU read-side critical
 section?
Message-ID: <20130909101629.32df27a2@gandalf.local.home>
In-Reply-To: <20130909135656.GT3966@linux.vnet.ibm.com>
References: <20130906174117.GU3966@linux.vnet.ibm.com>
	<20130906185927.GE2706@somewhere>
	<20130909105347.GK31370@twins.programming.kicks-ass.net>
	<20130909121329.GA16280@somewhere>
	<20130909083926.3eceebef@gandalf.local.home>
	<20130909124547.GB16280@somewhere>
	<20130909085504.2ddd7e69@gandalf.local.home>
	<20130909130851.GC16280@somewhere>
	<20130909092142.05780991@gandalf.local.home>
	<20130909134505.GF16280@somewhere>
	<20130909135656.GT3966@linux.vnet.ibm.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Sep 2013 06:56:56 -0700
"Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:


> Indeed, there is on ongoing naming debate as well.  About the only point
> of agreement thus far is that the current names are inadequate. ;-)
> 
> My current feeling is that rcu_is_cpu_idle() should be called
> rcu_watching_this_cpu() and what is called rcu_watching_this_cpu()
> in my local tree should be called __rcu_watching_this_cpu().

I disagree. Then it would not make sense if we take a return value of
"__rcu_watching_this_cpu()" and use it on another CPU to make other
decisions for that other CPU.

I still think we are confusing concepts with implementation. Yes, the
RCU implementation tracks CPU state, but the concept is still based on
the task.

But you are right, with dynamic ticks, things get a little more
complex, as dynamic ticks is a CPU state, not a task state, as it can
be something other than the running task that changes the state
(another task gets scheduled on that CPU).

But I think we are coupling RCU a bit too much with dynamic ticks here.
Maybe we need to take a step back to visualize concepts again.

The state of being in dynamic tick mode is determined by what a task or
tasks are doing on the CPU. One of those things is if the task needs to
be tracked by RCU. And here, is where I think we are getting our
confusion from. The dynamic tick state needs to check if the running
task is requiring RCU or not, and thus we ask for "is rcu needed on
this CPU?" when the real question is "is the task running on this CPU
requiring RCU?"

Again, if we keep things in a conceptual mode, and not look too much at
the implementation details, I think more people will understand what's
going on. Especially those that don't know why something was
implemented the way it was.

-- Steve
