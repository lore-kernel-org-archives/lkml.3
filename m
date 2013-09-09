Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755250Ab3IIQab (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 12:30:31 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:13736 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755097Ab3IIQa3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 12:30:29 -0400
X-Authority-Analysis: v=2.0 cv=ddwCLAre c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=JDfofD-L5ZgA:10 a=5SG0PmZfjMsA:10 a=kj9zAlcOel0A:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=5p3hctMY2UsA:10 a=VnNF1IyMAAAA:8 a=X9tyu8ftFkkhcBkNjOQA:9 a=CjuIK1q_8ugA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Date: Mon, 9 Sep 2013 12:30:26 -0400
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
Message-ID: <20130909123026.4560fa19@gandalf.local.home>
In-Reply-To: <20130909160920.GW3966@linux.vnet.ibm.com>
References: <20130909105347.GK31370@twins.programming.kicks-ass.net>
	<20130909121329.GA16280@somewhere>
	<20130909083926.3eceebef@gandalf.local.home>
	<20130909124547.GB16280@somewhere>
	<20130909085504.2ddd7e69@gandalf.local.home>
	<20130909130851.GC16280@somewhere>
	<20130909092142.05780991@gandalf.local.home>
	<20130909092917.0c99b71a@gandalf.local.home>
	<20130909144037.GH16280@somewhere>
	<20130909112057.35403440@gandalf.local.home>
	<20130909160920.GW3966@linux.vnet.ibm.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Sep 2013 09:09:20 -0700
"Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:
 
> Oddly enough, the earliest implementations of RCU that I worked with
> back in the early 1990s had implementation but no concept.  The concepts
> came later.  Something about how dragging people through 1500 lines
> of highly optimized parallel C code not being a very effective way of
> teaching RCU.  Surprisingly enough, there actually were some people who
> managed to learn it that way...

This is actually my point of my arguments :-)

Things that are shown outside of the rcu files should be an interface
that reflects the concept, not the implementation (if possible). Just
like there's nothing in "preempt_count()" that says the preempt count
is stored on a per task field.

We can't expect the rest of the community to understand the RCU
implementation, when there's still many that don't understand the
concept ;-)

You can implement RCU anyway you seem fit. My concern is where very
smart people like Peter Zijlstra stumble over code used by others that
show:

	preempt_disable();
	ret = yada_yada();
	preempt_enable();

	return ret;

Where the function name states that we want CPU state, but if that's
really true, then who ever wants CPU state must not preempt here.

The point being, here the concept actually makes more sense than the
implementation, because I think one thing we all can agree on, is that
the interface throughout the kernel should be something people can
understand quickly without too much effort. The better we all can
understand, the better the kernel will be.

I think we are starting to bike shed a bit too much. The real issue is,
what can "rcu_is_cpu_idle()" be called that makes sense with those that
need to look at this code?


"rcu_is_not_active()" or "rcu_is_ignored()" where a user can see that,
"Oh, RCU is ignored here, I shouldn't be using rcu_read_lock()" or if
their code is called within something that does "rcu_is_ignored()" and
they see that they used "rcu_read_lock()" they would understand what
the issue is.

If they see "rcu_is_cpu_idle()" they would get confused: "Hmm, the cpu
isn't idle here?"

Perhaps "rcu_watching_this_cpu()" may make sense, but again, if I see a
the above preempt_enable() in that code, I would think it's a bug,
because then the return value is not guaranteed to be on this cpu.

-- Steve

