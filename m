Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752936Ab3IVWjV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Sep 2013 18:39:21 -0400
Received: from gate.crashing.org ([63.228.1.57]:43210 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752319Ab3IVWjU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Sep 2013 18:39:20 -0400
Message-ID: <1379889489.24090.34.camel@pasglop>
Subject: Re: [RFC GIT PULL] softirq: Consolidation and stack overrun fix
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Paul Mackerras <paulus@au1.ibm.com>, Ingo Molnar <mingo@kernel.org>,
        James Hogan <james.hogan@imgtec.com>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Helge Deller <deller@gmx.de>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Mon, 23 Sep 2013 08:38:09 +1000
In-Reply-To: <CA+55aFwaf_Wst=AS75ydBJVQ6aJxPfAzXdt-UXj3qC9WeUt7kw@mail.gmail.com>
References: <1379620267-25191-1-git-send-email-fweisbec@gmail.com>
	 <CA+55aFyXf370Ds6FH5wPPycZLSPD5qiP7rjWqxwDetfHfKjg1w@mail.gmail.com>
	 <alpine.DEB.2.02.1309201244080.4089@ionos.tec.linutronix.de>
	 <20130920162603.GA30381@localhost.localdomain>
	 <CA+55aFyBcjP2U6ipzZay=FdhzA4oFNwE4tU0OcJJhwFvgoeALw@mail.gmail.com>
	 <CAFTL4hzucS5nJbCrArPv9zfY=QpyUESMK2Th0tKFHVCjDP7-eA@mail.gmail.com>
	 <1379799901.24090.6.camel@pasglop> <523E4F8A.7020708@zytor.com>
	 <1379824754.24090.11.camel@pasglop> <1379824861.24090.12.camel@pasglop>
	 <20130922162410.GA10649@laptop.programming.kicks-ass.net>
	 <1379887000.24090.19.camel@pasglop>
	 <CA+55aFwaf_Wst=AS75ydBJVQ6aJxPfAzXdt-UXj3qC9WeUt7kw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2013-09-22 at 15:22 -0700, Linus Torvalds wrote:
> On Sun, Sep 22, 2013 at 2:56 PM, Benjamin Herrenschmidt
> <benh@kernel.crashing.org> wrote:
> > On Sun, 2013-09-22 at 18:24 +0200, Peter Zijlstra wrote:
> >>
> >> We use a segment offset. Something like:
> >>
> >>   inc %gs:var;
> >>
> >
> > And gcc makes no stupid assumptions that this gs doesn't change ? That's
> > the main problem we have with using r13 for PACA.
> 
> Since gcc doesn't really know about segment registers at all (modulo
> %fs as TLS on x86), we do everything like that using inline asm.
> 
> It's not *too* painful if you have a number of macro helpers to build
> up all the different versions.
> 
> And r13 isn't volatile if you are preempt-safe, so I'm wondering if
> you could just make the preempt disable code mark %r13 as modified
> ("+r"). Then gcc won't ever cache r13 across one of those. And if you
> don't have preemption disabled, then you cannot do multiple ops using
> %r13 anyway, since on a load-store architecture it might change even
> between the load and store, so a per-cpu "add" operation *has* to
> cache the %r13 value in *another* register anyway, because using
> memory ops with just an offset off %r13 would be buggy.

The only other one is our soft-disable of irqs which is a byte off r13,
so technically a simple:

	li	r0,0
	stb	r0,PACASOFTIRQEN(r13)

Is a perfectly valid implementation of local_irq_disable() ;-) But that
sort of special case I think we can handle with special cases.

Right, using an r13 clobber in a dummy asm in things like
preempt_disable and local_irq_disable is so far the most interesting
option left on our table.

> So I don't think this is a gcc issue. gcc can't fix those kinds of problems.

Well, it would help if we had a way to tell gcc that a global register
variable is volatile. But it doesn't understand that concept.

> Personally, I'd suggest something like:
> 
>  - the paca stuff is just insane. Try to get rid of it.

I wish I could... it dig deep. The problem is fundamentally because with
MMU off (aka "real" mode), under a hypervisor, we have only access to a
portion of the partition memory (it's a fake real mode if you want, and
on older systems it's implemented as a physically contiguous chunk of
memory reserved by the hypervisor for the partition, and as such cannot
be arbitrarily large, newer CPUs support something smarter but with
still with some limitations).

That combined with the fact that all interrupts are delivered in real
mode, and you get the picture. KVM "userspace" (the variant that
emulates the guest as a user process) makes it worse as it needs to
maintain much more state in a place that is "real mode accessible".

We *might* be bale to repurpose r13 as our per-cpu offset and move a
chunk of stuff from the paca to per-cpu variables, but we will still
need "something" akin to the PACA for the guts of the exception
entry/exit and KVM.

>  - use %r13 for the per-thread thread-info pointer instead. A
> per-thread pointer is *not* volatile like the per-cpu base is.

Yes, use it as a TLS, that would be an option I've been considering. It
could also be the task struct but thread_info might be slightly hotter.

That's what I had in mind when I mentioned using it as a TLS for
"current".

>  - Now you can make the per-cpu offset be loaded off the per-thread
> pointer (update it at context switch). gcc knows to not cache it
> across function calls, since it's a memory access. Use ACCESS_ONCE()
> or something to make sure it's only loaded once for the cpu offset
> ops.

I have seen gcc completely disregard ACCESS_ONCE in the past though, at
least in the context of PACA relative accesses...

> Alternatively, make %r13 point to the percpu side, but make sure that
> you always use an asm accessor to fetch the value. In particular, I
> think you need to make __my_cpu_offset be an inline asm that fetches
> %r13 into some other register. Otherwise you can never get it right.

Yes, that's my plan B, at least for PACA but it would work for per-cpu
as well. Use a get_paca/put_paca style construct which fetches is in
another register (and does the preempt enable/disable while at it) and
for the handful of cases where we do want direct and faster access such
as manipulating the soft-irq flag, an inline asm load or store which is
what we do today.

Also with LE, we still have a bit of potential for tweaking the ABI and
the compiler, so that's something I want to put on the table.

Cheers,
Ben.


