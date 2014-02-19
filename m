Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753895AbaBSOlo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 09:41:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:39438 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752463AbaBSOll (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 09:41:41 -0500
Subject: Re: [RFC][PATCH 0/5] arch: atomic rework
From: Torvald Riegel <triegel@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alec Teal <a.teal@warwick.ac.uk>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Will Deacon <will.deacon@arm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ramana Radhakrishnan <Ramana.Radhakrishnan@arm.com>,
        David Howells <dhowells@redhat.com>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "gcc@gcc.gnu.org" <gcc@gcc.gnu.org>
In-Reply-To: <CA+55aFwOrFyDG_ZcOeh9Y-mQ1jMKA6bbBudh2hde6+jaRy4L_A@mail.gmail.com>
References: <20140207180216.GP4250@linux.vnet.ibm.com>
	 <1391992071.18779.99.camel@triegel.csb>
	 <CA+55aFwTwCPMpYTL_vCgNNP0hE8s2sgB0iw-79=xoj99V0JUNA@mail.gmail.com>
	 <1392183564.18779.2187.camel@triegel.csb>
	 <20140212180739.GB4250@linux.vnet.ibm.com>
	 <CA+55aFw3S82GYdtnV2nJCvBGcuZf6kXdF5b7Vp9yb21QKr49Jw@mail.gmail.com>
	 <20140213002355.GI4250@linux.vnet.ibm.com>
	 <1392321837.18779.3249.camel@triegel.csb>
	 <20140214020144.GO4250@linux.vnet.ibm.com>
	 <1392352981.18779.3800.camel@triegel.csb>
	 <20140214172920.GQ4250@linux.vnet.ibm.com>
	 <CA+55aFx9CbgrfK4rBVYD75y2KoWiO90dSYsAW83O-tYVLK-gkg@mail.gmail.com>
	 <CA+55aFypfiTFwundih8QEA6ZwVGk=g5L4sabsN0932eih5knOQ@mail.gmail.com>
	 <1392486310.18779.6447.camel@triegel.csb>
	 <CA+55aFwTrt_6m1inNHQkk74i7uPkHNnacwHiBgioZSXieAs5Sw@mail.gmail.com>
	 <1392666947.18779.6838.camel@triegel.csb>
	 <CA+55aFwUnRVk6q3VZeYjWfduoHcExW=Pht6jgp=4bBSaLHNPMA@mail.gmail.com>
	 <530296CD.5050503@warwick.ac.uk>	<1392737465.18779.7644.camel@triegel.csb>
	 <CA+55aFxn2KRXDQ91xRs=b! O_6d_nA_PSQvoY1_=OxyJ86+KOO9Q@mail.gmail.com>
	 <1392758516.18779.8378.camel@triegel.csb>
	 <CA+55aFwOrFyDG_ZcOeh9Y-mQ1jMKA6bbBudh2hde6+jaRy4L_A@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 19 Feb 2014 15:40:58 +0100
Message-ID: <1392820858.18779.8936.camel@triegel.csb>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-02-18 at 14:14 -0800, Linus Torvalds wrote:
> On Tue, Feb 18, 2014 at 1:21 PM, Torvald Riegel <triegel@redhat.com> wrote:
> >>
> >> So imagine that you have some clever global optimizer that sees that
> >> the program never ever actually sets the dirty bit at all in any
> >> thread, and then uses that kind of non-local knowledge to make
> >> optimization decisions. THAT WOULD BE BAD.
> >>
> >> Do you see what I'm aiming for?
> >
> > Yes, I do.  But that seems to be "volatile" territory.  It crosses the
> > boundaries of the abstract machine, and thus is input/output.  Which
> > fraction of your atomic accesses can read values produced by hardware?
> > I would still suppose that lots of synchronization is not affected by
> > this.
> 
> The "hardware can change things" case is indeed pretty rare.
> 
> But quite frankly, even when it isn't hardware, as far as the compiler
> is concerned you have the exact same issue - you have TLB faults
> happening on other CPU's that do the same thing asynchronously using
> software TLB fault handlers. So *semantically*, it really doesn't make
> any difference what-so-ever if it's a software TLB handler on another
> CPU, a microcoded TLB fault, or an actual hardware path.

I think there are a few semantic differences:

* If a SW handler uses the C11 memory model, it will synchronize like
any other thread.  HW might do something else entirely, including
synchronizing differently, not using atomic accesses, etc.  (At least
that's the constraints I had in mind).

* If we can treat any interrupt handler like Just Another Thread, then
the next question is whether the compiler will be aware that there is
another thread.  I think that in practice it will be: You'll set up the
handler in some way by calling a function the compiler can't analyze, so
the compiler will know that stuff accessible to the handler (e.g.,
global variables) will potentially be accessed by other threads. 

* Similarly, if the C code is called from some external thing, it also
has to assume the presence of other threads.  (Perhaps this is what the
compiler has to assume in a freestanding implementation anyway...)

However, accessibility will be different for, say, stack variables that
haven't been shared with other functions yet; those are arguably not
reachable by other things, at least not through mechanisms defined by
the C standard.  So optimizing these should be possible with the
assumption that there is no other thread (at least as default -- I'm not
saying that this is the only reasonable semantics).

> So if the answer for all of the above is "use volatile", then I think
> that means that the C11 atomics are badly designed.
> 
> The whole *point* of atomic accesses is that stuff like above should
> "JustWork(tm)"

I think that it should in the majority of cases.  If the other thing
potentially accessing can do as much as a valid C11 thread can do, the
synchronization itself will work just fine.  In most cases except the
(void*)0x123 example (or linker scripts etc.) the compiler is aware when
data is made visible to other threads or other non-analyzable functions
that may spawn other threads (or just by being a plain global variable
accessible to other (potentially .S) translation units.

> > Do you perhaps want a weaker form of volatile?  That is, one that, for
> > example, allows combining of two adjacent loads of the dirty bits, but
> > will make sure that this is treated as if there is some imaginary
> > external thread that it cannot analyze and that may write?
> 
> Yes, that's basically what I would want. And it is what I would expect
> an atomic to be. Right now we tend to use "ACCESS_ONCE()", which is a
> bit of a misnomer, because technically we really generally want
> "ACCESS_AT_MOST_ONCE()" (but "once" is what we get, because we use
> volatile, and is a hell of a lot simpler to write ;^).
> 
> So we obviously use "volatile" for this currently, and generally the
> semantics we really want are:
> 
>  - the load or store is done as a single access ("atomic")
> 
>  - the compiler must not try to re-materialize the value by reloading
> it from memory (this is the "at most once" part)

In the presence of other threads performing operations unknown to the
compiler, that's what you should get even if the compiler is trying to
optimize C11 atomics.  The first requirement is clear, and the "at most
once" follows from another thread potentially writing to the variable.

The only difference I can see right now is that a compiler may be able
to *prove* that it doesn't matter whether it reloaded the value or not.
But this seems very hard to prove for me, and likely to require
whole-program analysis (which won't be possible because we don't know
what other threads are doing).  I would guess that this isn't a problem
in practice.  I just wanted to note it because it theoretically does
have a different semantics than plain volatiles.

> and quite frankly, "volatile" is a big hammer for this. In practice it
> tends to work pretty well, though, because in _most_ cases, there
> really is just the single access, so there isn't anything that it
> could be combined with, and the biggest issue is often just the
> correctness of not re-materializing the value.
> 
> And I agree - memory ordering is a totally separate issue, and in fact
> we largely tend to consider it entirely separate. For cases where we
> have ordering constraints, we either handle those with special
> accessors (ie "atomic-modify-and-test" helpers tend to have some
> serialization guarantees built in), or we add explicit fencing.

Good.

> But semantically, C11 atomic accessors *should* generally have the
> correct behavior for our uses.
> 
> If we have to add "volatile", that makes atomics basically useless. We
> already *have* the volatile semantics, if atomics need it, that just
> means that atomics have zero upside for us.

I agree, but I don't think it's necessary.  atomics should have the
right semantics for you, provided the compiler is aware that there are
other unknown threads accessing the same data.

> >> But *local* optimizations are fine, as long as they follow the obvious
> >> rule of not actually making changes that are semantically visible.
> >
> > If we assume that there is this imaginary thread called hardware that
> > can write/read to/from such weak-volatile atomics, I believe this should
> > restrict optimizations sufficiently even in the model as specified in
> > the standard.
> 
> Well, what about *real* threads that do this, but that aren't
> analyzable by the C compiler because they are written in another
> language entirely (inline asm, asm, perl, INTERCA:. microcode,
> PAL-code, whatever?)
> 
> I really don't think that "hardware" is necessary for this to happen.
> What is done by hardware on x86, for example, is done by PAL-code
> (loaded at boot-time) on alpha, and done by hand-tuned assembler fault
> handlers on Sparc. The *effect* is the same: it's not visible to the
> compiler. There is no way in hell that the compiler can understand the
> hand-tuned Sparc TLB fault handler, even if it parsed it.

I agree.  Let me rephrase it.

If all those other threads written in whichever way use the same memory
model and ABI for synchronization (e.g., choice of HW barriers for a
certain memory_order), it doesn't matter whether it's a hardware thread,
microcode, whatever.  In this case, C11 atomics should be fine.
(We have this in userspace already, because correct compilers will have
to assume that the code generated by them has to properly synchronize
with other code generated by different compilers.)

If the other threads use a different model, access memory entirely
differently, etc, then we might be back to "volatile" because we don't
know anything, and the very strict rules about execution steps of the
abstract machine (ie, no as-if rule) are probably the safest thing to
do.

If you agree with this categorization, then I believe we just need to
look at whether a compiler is naturally aware of a variable being shared
with potentially other threads that follow C11 synchronization semantics
but are written in other languages and generally not accessible:
* Maybe that's the case anyway when compiling for freestanding
optimizations.
* In a lot of cases, the compiler will know, because data escapes to
non-C / non-analyzable functions, or is global and accessible to other
translation units.
* Maybe we need some additional mechanism to mark those corner cases
where it isn't known (e.g., because of (void*)0x123 fixed-address
accesses, or other non-C-semantics issues).  That should be a clearer
mechanism than weak-volatile; maybe a shared_with_other_threads
attribute.  But my current gut feeling is that we wouldn't need that
often, if ever.

Sounds better?

