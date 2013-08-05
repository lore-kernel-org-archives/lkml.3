Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754370Ab3HERzc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 13:55:32 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:26690 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753239Ab3HERzb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 13:55:31 -0400
X-Authority-Analysis: v=2.0 cv=aqMw+FlV c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=pFOAptgLnqcA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=pvQ05lsfB1wA:10 a=gDZ86hxRkP9q1vQzMwQA:9 a=QEXdDO2ut3YA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-ID: <1375725328.22073.101.camel@gandalf.local.home>
Subject: Re: [RFC] gcc feature request: Moving blocks into sections
From: Steven Rostedt <rostedt@goodmis.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, gcc <gcc@gcc.gnu.org>,
        Ingo Molnar <mingo@kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        David Daney <ddaney.cavm@gmail.com>,
        Behan Webster <behanw@converseincode.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Herbert Xu <herbert@gondor.hengli.com.au>
Date: Mon, 05 Aug 2013 13:55:28 -0400
In-Reply-To: <CA+55aFw_o=D-j_SRn=Y4LhHm-tEyuP1Je5ZHVTYxbVyLyDcLEg@mail.gmail.com>
References: <1375721715.22073.80.camel@gandalf.local.home>
	 <CA+55aFw_o=D-j_SRn=Y4LhHm-tEyuP1Je5ZHVTYxbVyLyDcLEg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-08-05 at 10:12 -0700, Linus Torvalds wrote:
> On Mon, Aug 5, 2013 at 9:55 AM, Steven Rostedt <rostedt@goodmis.org> wrote:

> First off, we have very few things that are *so* unlikely that they
> never get executed. Putting things in a separate section would
> actually be really bad.

My main concern is with tracepoints. Which on 90% (or more) of systems
running Linux, is completely off, and basically just dead code, until
someone wants to see what's happening and enables them.

> 
> Secondly, you don't want a separate section anyway for any normal
> kernel code, since you want short jumps if possible (pretty much every
> single architecture out there has a concept of shorter jumps that are
> noticeably cheaper than long ones). You want the unlikely code to be
> out-of-line, but still *close*. Which is largely what gcc already does
> (except if you use "-Os", which disables all the basic block movement
> and thus makes "likely/unlikely" pointless to begin with).
> 
> There are some situations where you'd want extremely unlikely code to
> really be elsewhere, but they are rare as hell, and mostly in user
> code where you might try to avoid demand-loading such code entirely.

Well, as tracepoints are being added quite a bit in Linux, my concern is
with the inlined functions that they bring. With jump labels they are
disabled in a very unlikely way (the static_key_false() is a nop to skip
the code, and is dynamically enabled to a jump).

I did a make kernel/sched/core.i to get what we have in the current
sched_switch code:

static inline __attribute__((no_instrument_function)) void
trace_sched_switch (struct task_struct *prev, struct task_struct *next) {
	if (static_key_false(& __tracepoint_sched_switch .key)) do {
		struct tracepoint_func *it_func_ptr;
		void *it_func;
		void *__data;
		rcu_read_lock_sched_notrace();
		it_func_ptr = ({
			typeof(*((&__tracepoint_sched_switch)->funcs)) *_________p1 =
				(typeof(*((&__tracepoint_sched_switch)->funcs))* )
				(*(volatile typeof(((&__tracepoint_sched_switch)->funcs)) *)
				&(((&__tracepoint_sched_switch)->funcs)));
			do {
				static bool __attribute__ ((__section__(".data.unlikely"))) __warned;
				if (debug_lockdep_rcu_enabled() && !__warned && !(rcu_read_lock_sched_held() || (0))) {
					__warned = true;
					lockdep_rcu_suspicious( , 153 , "suspicious rcu_dereference_check()" " usage");
				}
			} while (0);
			((typeof(*((&__tracepoint_sched_switch)->funcs)) *)(_________p1));
		});
		if (it_func_ptr) {
			do {
				it_func = (it_func_ptr)->func;
				__data = (it_func_ptr)->data;
				((void(*)(void *__data, struct task_struct *prev, struct task_struct *next))(it_func))(__data, prev, next);
			} while ((++it_func_ptr)->func);
		}
		rcu_read_unlock_sched_notrace();
	} while (0);
} 

I massaged it to look more readable. This is inlined right at the
beginning of the prepare_task_switch(). Now, most of this code should be
moved to the end of the function by gcc (well, as you stated -Os may not
play nice here). And perhaps its not that bad of an issue. That is, how
much of the icache does this actually take up? Maybe we are lucky and it
sits outside the icache of the hot path.

I still need to start running a bunch of benchmarks to see how much
overhead these tracepoints cause. Herbert Xu brought up the concern
about various latencies in the kernel, including tracing, in his ATTEND
request on the kernel-discuss mailing list.



> 
> So give up on sections. They are a bad idea for anything except the
> things we already use them for. Sure, you can try to fix the problems
> with sections with link-time optimization work and a *lot* of small
> individual sections (the way per-function sections work already), but
> that's basically just undoing the stupidity of using sections to begin
> with.

OK, this was just a suggestion. Perhaps my original patch that just
moves this code into a real function where the trace_sched_switch() only
contains the jump_label and a call to another function that does all the
work when enabled, is still a better idea. That is, if benchmarks prove
that it's worth it.

Instead of the above, my patches would make the code into:

static inline __attribute__((no_instrument_function)) void
trace_sched_switch (struct task_struct *prev, struct task_struct *next)
{
	if (static_key_false(& __tracepoint_sched_switch .key))
		__trace_sched_switch(prev, next);
}

That is, when this tracepoint is enabled, it will call another function
that does the tracepoint work. The difference between this and the
"section" hack I suggested, is that this would use a "call"/"ret" when
enabled instead of a "jmp"/"jmp".

-- Steve



