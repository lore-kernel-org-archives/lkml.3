Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754061Ab3IIN3j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 09:29:39 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:23529 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753104Ab3IIN3T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 09:29:19 -0400
X-Authority-Analysis: v=2.0 cv=V4T/IJbi c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=JDfofD-L5ZgA:10 a=5SG0PmZfjMsA:10 a=kj9zAlcOel0A:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=5p3hctMY2UsA:10 a=4qqQLd7zNwFsm2Afq0sA:9 a=CjuIK1q_8ugA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Date: Mon, 9 Sep 2013 09:29:17 -0400
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
Message-ID: <20130909092917.0c99b71a@gandalf.local.home>
In-Reply-To: <20130909092142.05780991@gandalf.local.home>
References: <20130906105934.GF20519@somewhere>
	<20130906151851.GQ3966@linux.vnet.ibm.com>
	<1378488088.31445.39.camel@edumazet-glaptop>
	<20130906174117.GU3966@linux.vnet.ibm.com>
	<20130906185927.GE2706@somewhere>
	<20130909105347.GK31370@twins.programming.kicks-ass.net>
	<20130909121329.GA16280@somewhere>
	<20130909083926.3eceebef@gandalf.local.home>
	<20130909124547.GB16280@somewhere>
	<20130909085504.2ddd7e69@gandalf.local.home>
	<20130909130851.GC16280@somewhere>
	<20130909092142.05780991@gandalf.local.home>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Sep 2013 09:21:42 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

 
> Especially since the function name itself is "rcu_is_cpu_idle()" which
> tells you it's a cpu state, and not a task state. Why would you care in
> RCU if CPU 1 is idle if you are on CPU 2? The name should be changed.

> Actually, preempt_count is more a CPU state than a task state. When
> preempt_count is set, that CPU can not schedule out the current task.
> It really has nothing to do with the task itself. It's the CPU that
> can't do something. Preempt count should never traverse with a task
> from one CPU to another.

I'll take this a step further. Here's a simple rule to determine if
something is a task state or a CPU state.

If the state migrates with a task from one CPU to another, it's a task
state.

If the state never leaves a CPU with a task, then it's a CPU state.

According to the above rules, rcu_is_cpu_idle() is a task state, and
really should be in task_struct, and preempt_count is a CPU state, and
should be a per_cpu variable.

I think the reason preempt_count never was a per cpu variable, is that
having it in the stack (thread info) made it easier to test in assembly
than having to grab the per cpu info. But I believe it's easier to grab
per cpu info in assembly today than it once was, which is why there is
a push to move preempt_count to per_cpu where it truly belongs.

-- Steve
