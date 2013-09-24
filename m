Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753472Ab3IXBxc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 21:53:32 -0400
Received: from gate.crashing.org ([63.228.1.57]:44154 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752857Ab3IXBxb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 21:53:31 -0400
Message-ID: <1379987527.5443.20.camel@pasglop>
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
        Andrew Morton <akpm@linux-foundation.org>,
        Anton Blanchard <anton@au1.ibm.com>
Date: Tue, 24 Sep 2013 11:52:07 +1000
In-Reply-To: <CA+55aFwyVG4DXOEvaVTp0gE-H2Zy0Kx7Mg7RWzpxzwm_RSWEYQ@mail.gmail.com>
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
	 <1379981427.5443.8.camel@pasglop>
	 <CA+55aFwyVG4DXOEvaVTp0gE-H2Zy0Kx7Mg7RWzpxzwm_RSWEYQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-09-23 at 18:19 -0700, Linus Torvalds wrote:
> On Mon, Sep 23, 2013 at 5:10 PM, Benjamin Herrenschmidt
> <benh@kernel.crashing.org> wrote:
> >
> > BTW, that boils down to a choice between using r13 as either a TLS for
> > current or current_thread_info, or as a per-cpu pointer, which one is
> > the most performance critical ?
> 
> I think you can tune most of the architecture setup to best suit your needs.
> 
> For example, on x86, we don't have much choice: the per-cpu accessors
> are going to be faster than the alternatives, and there are patches
> afoot to tune the preempt and rcu-readside counters to use the percpu
> area (and then save/restore things at task switch time). But having
> the counters natively in the thread_info struct is fine too and is
> what we do now.

Right, as long as the generic code doesn't move toward putting
everything in per-cpu without leaving us the option :-)

> Generally, we've put the performance-critical stuff into
> "current_thread_info" as opposed to "current", so it's likely that if
> the choice is between those two, then you might want to pick %r13
> pointing to the thread-info rather than the "struct task_struct" (ie
> things like low-level thread flags). But which is better probably
> depends on load, and again, some of it you can tweak by just making
> per-architecture structure choices and making the macros point at one
> or the other.

Well, if current_thread_info is basically inside the thread struct, it
will be the same, just a different offset from r13... task struct,
thread struct, thread info, it all becomes just one big structure
pointed to by r13.

> There's a few things that really depend on per-cpu areas, but I don't
> think it's a huge performance issue if you have to indirect off memory
> to get that. Most of the performance issues with per-cpu stuff is
> about avoiding cachelines ping-ponging back and forth, not so much
> about fast direct access. Of course, if some load really uses a *lot*
> of percpu accesses, you get both.
> 
> The advantage of having %r13 point to thread data (which is "stable"
> as far as the compiler is concerned) as opposed to having it be a
> per-cpu pointer (which can change randomly due to task switching) is
> that from a correctness standpoint I really do think that either
> thread-info or current is *much* easier to handle than using it for
> the per-cpu base pointer.

Right. I had a chat with Alan Modra (gcc) and he reckons the "right" way
to make the per-cpu (or PACA) stuff work reasonably reliably is to do
something along the lines of:

register unsigned long per_cpu_offset asm("r13");

And have a barrier in preempt_enable/disable (and irq enable/disable,
though arguably we could just make barrier() do it) which marks r13 as
an *output* (not a clobber !).

>From there, gcc knows that after any such barrier, r13 can have changed
and we intend to use the new value (if it's marked as a clobber, it
assumes it was *clobbered* and thus need to be restored to it's
*previous* value).

So if that holds, we have a solid way to do per-cpu. On one side, I tend
to think that r13 being task/thread/thread_info is probably a better
overall choice, I'm worried that going in a different direction than x86
means generic code will get "tuned" to use per-cpu for performance
critical stuff rather than task/thread/thread_info in inflexible ways.

Cheers,
Ben.

>              Linus
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


