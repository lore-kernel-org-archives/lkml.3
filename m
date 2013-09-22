Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752841Ab3IVV6S (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Sep 2013 17:58:18 -0400
Received: from gate.crashing.org ([63.228.1.57]:48047 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752268Ab3IVV6Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Sep 2013 17:58:16 -0400
Message-ID: <1379887000.24090.19.camel@pasglop>
Subject: Re: [RFC GIT PULL] softirq: Consolidation and stack overrun fix
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Frederic Weisbecker <fweisbec@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
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
Date: Mon, 23 Sep 2013 07:56:40 +1000
In-Reply-To: <20130922162410.GA10649@laptop.programming.kicks-ass.net>
References: <1379620267-25191-1-git-send-email-fweisbec@gmail.com>
	 <CA+55aFyXf370Ds6FH5wPPycZLSPD5qiP7rjWqxwDetfHfKjg1w@mail.gmail.com>
	 <alpine.DEB.2.02.1309201244080.4089@ionos.tec.linutronix.de>
	 <20130920162603.GA30381@localhost.localdomain>
	 <CA+55aFyBcjP2U6ipzZay=FdhzA4oFNwE4tU0OcJJhwFvgoeALw@mail.gmail.com>
	 <CAFTL4hzucS5nJbCrArPv9zfY=QpyUESMK2Th0tKFHVCjDP7-eA@mail.gmail.com>
	 <1379799901.24090.6.camel@pasglop> <523E4F8A.7020708@zytor.com>
	 <1379824754.24090.11.camel@pasglop> <1379824861.24090.12.camel@pasglop>
	 <20130922162410.GA10649@laptop.programming.kicks-ass.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2013-09-22 at 18:24 +0200, Peter Zijlstra wrote:
> On Sun, Sep 22, 2013 at 02:41:01PM +1000, Benjamin Herrenschmidt wrote:
> > On Sun, 2013-09-22 at 14:39 +1000, Benjamin Herrenschmidt wrote:
> > > How do you do your per-cpu on x86 ? 
> 
> We use a segment offset. Something like:
> 
>   inc %gs:var;
> 
> would be a per-cpu increment. The actual memory location used for the
> memop is the variable address + GS offset.
> 
> And our GS offset is per cpu and points to the base of the per cpu
> segment for that cpu.
> 
> > Also, do you have a half-decent way of getting to per-cpu from asm ?
> 
> Yes, see above :-)

And gcc makes no stupid assumptions that this gs doesn't change ? That's
the main problem we have with using r13 for PACA.

> Assuming we repurpose r13 as per-cpu base, you could do the whole
> this_cpu_* stuff which is locally atomic -- ie. safe against IRQs and
> preemption as:
> 
> loop:
> 	lwarx	rt, var, r13
> 	inc	rt
> 	stwcx	rt, var, r13
> 	bne-	loop
> 
> Except, I think your ll/sc pair is actually slower than doing:
> 
>   local_irq_save(flags)
>   var++;
>   local_irq_restore(flags)
> 
> Esp. with the lazy irq disable you have.

Right, for local atomics we really don't want to use reservations, they
have to go to the L2 (and flush the corresponding L1 line along the
way).

> And I'm fairly sure using them as generic per cpu accessors isn't sane,
> but I'm not sure PPC64 has other memops with implicit addition like
> that.

We have no memop with implicit addition today, so for generic counters
we do need reservation. For other per-cpus such as thread info etc...
the problem is more how quick it is to get to the per-cpu.

> As to the problem of GCC moving r13 about, some archs have some
> exceptions in the register allocator and leave some registers alone.
> IIRC MIPS has this and uses one of those (istr there's 2) for the
> per cpu base address.

Right, not sure if there's anything we can do short of getting gcc
modified and relying on that new change (which would be problematic).
I've been trying to get straight answers from gcc folks about what we
can or cannot rely upon and never got any.

r13 is actually the TLS, but we can't use it as such in the kernel as
gcc *will* assume it doesn't change (though we could use it for current
and have our per-cpu offset hanging off that, one level of indirection
is better than nothing as suppose).

The problem boils down to gcc not having a concept that a global
register variable can be volatile.

Cheers,
Ben.

> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


