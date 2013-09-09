Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754931Ab3IIRpq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 13:45:46 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:56486 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751346Ab3IIRpm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 13:45:42 -0400
Date: Mon, 9 Sep 2013 10:45:10 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        sbw@mit.edu
Subject: Re: [PATCH] rcu: Is it safe to enter an RCU read-side critical
 section?
Message-ID: <20130909174510.GD3966@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130909105347.GK31370@twins.programming.kicks-ass.net>
 <20130909121329.GA16280@somewhere>
 <20130909083926.3eceebef@gandalf.local.home>
 <20130909124547.GB16280@somewhere>
 <20130909085504.2ddd7e69@gandalf.local.home>
 <20130909131452.GA31370@twins.programming.kicks-ass.net>
 <20130909134605.GP3966@linux.vnet.ibm.com>
 <20130909095511.735bcffc@gandalf.local.home>
 <20130909162215.GY3966@linux.vnet.ibm.com>
 <20130909124044.2e851d97@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130909124044.2e851d97@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13090917-1344-0000-0000-000001878DC9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 09, 2013 at 12:40:44PM -0400, Steven Rostedt wrote:
> On Mon, 9 Sep 2013 09:22:15 -0700
> "Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:
> > However, the API we are arguing about is deep within the implementation.
> > It is not at the level of rcu_read_lock().  It is something that should
> > not have that many invocations -- after all, the things using it are
> > binding themselves unusually close to RCU.
> 
> Is it? I guess the question is, is dynamic ticks an extension of RCU,
> or is it just using the RCU implementation as a convenience?

It is something that RCU didn't need to deal with at all in the "good
old days" before the current level of concern with energy efficiency.
To say nothing of back in the day where the idle loop was a simple tight
loop without all the tracing, C-state manipulation, and who knows what
all else.

Dynamic ticks is separate from RCU, but is something that RCU must pay
close attention to, because it RCU must avoid causing dynamic-ticks CPUs
to do anything -- to do otherwise would defeat the energy-efficiency
purpose of dynamic ticks.  Therefore, RCU needs to exactly track the
dynamic-ticks state of each CPU and behave accordingly.

The RCU-user-visible piece of this is that RCU read-side critical sections
are not permitted on dynamic-ticks CPUs, which normally only an issue for
code called from within the idle loop.  In most cases, code that is called
from the idle loop that need to use RCU read-side primitives can use the
RCU_NONIDLE() macro.

> Also the OP patch is for function tracing, something not coupled by RCU
> at all. Just a way to know if it is safe to call functions that use RCU
> or not.

Your tracing code is an exception because RCU_NONIDLE() is too
heavyweight for your code: surrounding each and every function trace
with RCU_NONIDLE() would make for nice stately and slow function tracing.
I don't expect too many similar exceptions because most code would
have a problem if the answer came back "you can't use RCU read-side
critical sections".  I suspect that this includes event tracing invoked
from the idle loop, as I would guess that just refusing to do the
event tracing would not make people happy.

> That can have "this_cpu()" by the way as a way to tell us that we must
> disable preemption before hand. Which is what caused this thread to
> start with, as it was suggested to combine rcu_is_cpu_idle() which
> brought up why that function disables preemption.

Yep, that is how we got here.  ;-)

							Thanx, Paul

