Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754829AbaBSR4f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 12:56:35 -0500
Received: from mx1.redhat.com ([209.132.183.28]:61548 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754123AbaBSR4b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 12:56:31 -0500
Subject: Re: [RFC][PATCH 0/5] arch: atomic rework
From: Torvald Riegel <triegel@redhat.com>
To: paulmck@linux.vnet.ibm.com
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Alec Teal <a.teal@warwick.ac.uk>, Will Deacon <will.deacon@arm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ramana Radhakrishnan <Ramana.Radhakrishnan@arm.com>,
        David Howells <dhowells@redhat.com>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "gcc@gcc.gnu.org" <gcc@gcc.gnu.org>
In-Reply-To: <20140219151422.GE4250@linux.vnet.ibm.com>
References: <1392666947.18779.6838.camel@triegel.csb>
	 <CA+55aFwUnRVk6q3VZeYjWfduoHcExW=Pht6jgp=4bBSaLHNPMA@mail.gmail.com>
	 <530296CD.5050503@warwick.ac.uk>
	 <CA+55aFyi8QWge7QR0M+ABH-kEiwvoEyMhK6GWRvN1YNKJAFuSQ@mail.gmail.com>
	 <1392737465.18779.7644.camel@triegel.csb>
	 <CA+55aFxn2KRXDQ91xRs=bO_6d_nA_PSQvoY1_=OxyJ86+KOO9Q@mail.gmail.com>
	 <20140218171609.GP4250@linux.vnet.ibm.com>
	 <1392759615.18779.8429.camel@triegel.csb>
	 <20140218225845.GB4250@linux.vnet.ibm.com>
	 <1392807548.18779.8659.camel@triegel.csb>
	 <20140219151422.GE4250@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 19 Feb 2014 18:55:51 +0100
Message-ID: <1392832551.18779.9315.camel@triegel.csb>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-02-19 at 07:14 -0800, Paul E. McKenney wrote:
> On Wed, Feb 19, 2014 at 11:59:08AM +0100, Torvald Riegel wrote:
> > On Tue, 2014-02-18 at 14:58 -0800, Paul E. McKenney wrote:
> > > On Tue, Feb 18, 2014 at 10:40:15PM +0100, Torvald Riegel wrote:
> > > > xagsmtp4.20140218214207.8481@vmsdvm9.vnet.ibm.com
> > > > X-Xagent-Gateway: vmsdvm9.vnet.ibm.com (XAGSMTP4 at VMSDVM9)
> > > > 
> > > > On Tue, 2014-02-18 at 09:16 -0800, Paul E. McKenney wrote:
> > > > > On Tue, Feb 18, 2014 at 08:49:13AM -0800, Linus Torvalds wrote:
> > > > > > On Tue, Feb 18, 2014 at 7:31 AM, Torvald Riegel <triegel@redhat.com> wrote:
> > > > > > > On Mon, 2014-02-17 at 16:05 -0800, Linus Torvalds wrote:
> > > > > > >> And exactly because I know enough, I would *really* like atomics to be
> > > > > > >> well-defined, and have very clear - and *local* - rules about how they
> > > > > > >> can be combined and optimized.
> > > > > > >
> > > > > > > "Local"?
> > > > > > 
> > > > > > Yes.
> > > > > > 
> > > > > > So I think that one of the big advantages of atomics over volatile is
> > > > > > that they *can* be optimized, and as such I'm not at all against
> > > > > > trying to generate much better code than for volatile accesses.
> > > > > > 
> > > > > > But at the same time, that can go too far. For example, one of the
> > > > > > things we'd want to use atomics for is page table accesses, where it
> > > > > > is very important that we don't generate multiple accesses to the
> > > > > > values, because parts of the values can be change *by*hardware* (ie
> > > > > > accessed and dirty bits).
> > > > > > 
> > > > > > So imagine that you have some clever global optimizer that sees that
> > > > > > the program never ever actually sets the dirty bit at all in any
> > > > > > thread, and then uses that kind of non-local knowledge to make
> > > > > > optimization decisions. THAT WOULD BE BAD.
> > > > > 
> > > > > Might as well list other reasons why value proofs via whole-program
> > > > > analysis are unreliable for the Linux kernel:
> > > > > 
> > > > > 1.	As Linus said, changes from hardware.
> > > > 
> > > > This is what's volatile is for, right?  (Or the weak-volatile idea I
> > > > mentioned).
> > > > 
> > > > Compilers won't be able to prove something about the values of such
> > > > variables, if marked (weak-)volatile.
> > > 
> > > Yep.
> > > 
> > > > > 2.	Assembly code that is not visible to the compiler.
> > > > > 	Inline asms will -normally- let the compiler know what
> > > > > 	memory they change, but some just use the "memory" tag.
> > > > > 	Worse yet, I suspect that most compilers don't look all
> > > > > 	that carefully at .S files.
> > > > > 
> > > > > 	Any number of other programs contain assembly files.
> > > > 
> > > > Are the annotations of changed memory really a problem?  If the "memory"
> > > > tag exists, isn't that supposed to mean all memory?
> > > > 
> > > > To make a proof about a program for location X, the compiler has to
> > > > analyze all uses of X.  Thus, as soon as X escapes into an .S file, then
> > > > the compiler will simply not be able to prove a thing (except maybe due
> > > > to the data-race-free requirement for non-atomics).  The attempt to
> > > > prove something isn't unreliable, simply because a correct compiler
> > > > won't claim to be able to "prove" something.
> > > 
> > > I am indeed less worried about inline assembler than I am about files
> > > full of assembly.  Or files full of other languages.
> > > 
> > > > One reason that could corrupt this is that if program addresses objects
> > > > other than through the mechanisms defined in the language.  For example,
> > > > if one thread lays out a data structure at a constant fixed memory
> > > > address, and another one then uses the fixed memory address to get
> > > > access to the object with a cast (e.g., (void*)0x123).
> > > 
> > > Or if the program uses gcc linker scripts to get the same effect.
> > > 
> > > > > 3.	Kernel modules that have not yet been written.  Now, the
> > > > > 	compiler could refrain from trying to prove anything about
> > > > > 	an EXPORT_SYMBOL() or EXPORT_SYMBOL_GPL() variable, but there
> > > > > 	is currently no way to communicate this information to the
> > > > > 	compiler other than marking the variable "volatile".
> > > > 
> > > > Even if the variable is just externally accessible, then the compiler
> > > > knows that it can't do whole-program analysis about it.
> > > > 
> > > > It is true that whole-program analysis will not be applicable in this
> > > > case, but it will not be unreliable.  I think that's an important
> > > > difference.
> > > 
> > > Let me make sure that I understand what you are saying.  If my program has
> > > "extern int foo;", the compiler will refrain from doing whole-program
> > > analysis involving "foo"?
> > 
> > Yes.  If it can't be sure to actually have the whole program available,
> > it can't do whole-program analysis, right?  Things like the linker
> > scripts you mention or other stuff outside of the language semantics
> > complicates this somewhat, and maybe some compilers assume too much.
> > There's also the point that data-race-freedom is required for
> > non-atomics even if those are shared with non-C-code.
> > 
> > But except those corner cases, a compiler sees whether something escapes
> > and becomes visible/accessible to other entities.
> 
> The traditional response to "except those corner cases" is of course
> "Murphy was an optimist".  ;-)
> 
> That said, point taken -- you expect that the compiler will always be
> told of anything that would limit its ability to reason about the
> whole program.
> 
> > > Or to ask it another way, when you say
> > > "whole-program analysis", are you restricting that analysis to the
> > > current translation unit?
> > 
> > No.  I mean, you can do analysis of the current translation unit, but
> > that will do just that; if the variable, for example, is accessible
> > outside of this translation unit, the compiler can't make a
> > whole-program proof about it, and thus can't do certain optimizations.
> 
> I had to read this several times to find an interpretation that might
> make sense.  That interpretation is "The compiler will do whole-program
> analysis only on those variables that it believes are accessed only by
> the current translation unit."  Is that what you meant?

Yes.  For a pure-C program (ie, one that's perfectly specified by just
the C standard), this will be the case; IOW, I'm not aware of any corner
case in such a setting.  But the kernel is doing more than what the C
standard covers, so we'll have to check those things.

> > > If so, I was probably not the only person thinking that you instead meant
> > > analysis across all translation units linked into the program.  ;-)
> > 
> > That's roughly what I meant, but not just including translation units
> > but truly all parts of the program, including non-C program parts.  IOW,
> > literally the whole program :)
> > 
> > That's why I said that if you indeed do *whole program* analysis, then
> > things should be fine (modulo corner cases such as linker scripts, later
> > binary rewriting of code produced by the compiler, etc.).  Many of the
> > things you worried about *prevent* whole-program analysis, which means
> > that they do not make it any less reliable.  Does that clarify my line
> > of thought?
> 
> If my interpretation above is correct, yes.  It appears that you are much
> more confident than many kernel folks that the compiler will be informed of
> everything that might limit its omniscience.

Maybe.  Nonetheless, if it's just a matter of letting the compiler know
that there is Other Stuff when the compiler isn't aware of that, but
once doing so all is good because the memory model handles this just
fine, then this makes me more optimistic than if the model was
insufficient.

> > > > > 	Other programs have similar issues, e.g., via dlopen().
> > > > > 
> > > > > 4.	Some drivers allow user-mode code to mmap() some of their
> > > > > 	state.  Any changes undertaken by the user-mode code would
> > > > > 	be invisible to the compiler.
> > > > 
> > > > A good point, but a compiler that doesn't try to (incorrectly) assume
> > > > something about the semantics of mmap will simply see that the mmap'ed
> > > > data will escape to stuff if can't analyze, so it will not be able to
> > > > make a proof.
> > > > 
> > > > This is different from, for example, malloc(), which is guaranteed to
> > > > return "fresh" nonaliasing memory.
> > > 
> > > As Peter noted, this is the other end of mmap().  The -user- code sees
> > > that there is an mmap(), but the kernel code invokes functions that
> > > poke values into hardware registers (or into in-memory page tables)
> > > that, as a side effect, cause some of the kernel's memory to be
> > > accessible to some user program.
> > > 
> > > Presumably the kernel code needs to do something to account for the
> > > possibility of usermode access whenever it accesses that memory.
> > > Volatile casts, volatile storage class on the declarations, barrier()
> > > calls, whatever.
> > 
> > In this case, there should be another option except volatile:  If
> > userspace code is using the C11 memory model as well and lock-free
> > atomics to synchronize, then this should have well-defined semantics
> > without using volatile.
> 
> For user-mode programs that have not yet been written, this could be
> a reasonable approach.  For existing user-mode binaries, C11 won't
> help, which leaves things like volatile and assembly (including the
> "memory" qualifier as used in barrier() macro).

I agree.  I also agree that there is the possibility of
malicious/incorrect userspace code, and that this shouldn't endanger the
kernel.

> > On both sides, the compiler will see that mmap() (or similar) is called,
> > so that means the data escapes to something unknown, which could create
> > threads and so on.  So first, it can't do whole-program analysis for
> > this state anymore, and has to assume that other C11 threads are
> > accessing this memory.  Next, lock-free atomics are specified to be
> > "address-free", meaning that they must work independent of where in
> > memory the atomics are mapped (see C++ (e.g., N3690) 29.4p3; that's a
> > "should" and non-normative, but essential IMO).  Thus, this then boils
> > down to just a simple case of synchronization.  (Of course, the rest of
> > the ABI has to match too for the data exchange to work.)
> 
> The compiler will see mmap() on the user side, but not on the kernel
> side.  On the kernel side, something special is required.

Maybe -- you'll certainly know better :)

But maybe it's not that hard: For example, if the memory is in current
code made available to userspace via calling some function with an asm
implementation that the compiler can't analyze, then this should be
sufficient.

> Agree that "address-free" would be nice as "shall" rather than "should".
> 
> > > I echo Peter's question about how one tags functions like mmap().
> > > 
> > > I will also remember this for the next time someone on the committee
> > > discounts "volatile".  ;-)
> > > 
> > > > > 5.	JITed code produced based on BPF: https://lwn.net/Articles/437981/
> > > > 
> > > > This might be special, or not, depending on how the JITed code gets
> > > > access to data.  If this is via fixed addresses (e.g., (void*)0x123),
> > > > then see above.  If this is through function calls that the compiler
> > > > can't analyze, then this is like 4.
> > > 
> > > It could well be via the kernel reading its own symbol table, sort of
> > > a poor-person's reflection facility.  I guess that would be for all
> > > intents and purposes equivalent to your (void*)0x123.
> > 
> > If it is replacing code generated by the compiler, then yes.  If the JIT
> > is just filling in functions that had been undefined yet declared
> > before, then the compiler will have seen the data escape through the
> > function interfaces, and should be aware that there is other stuff.
> 
> So one other concern would then be things things like ftrace, kprobes,
> ksplice, and so on.  These rewrite the kernel binary at runtime, though
> in very limited ways.

Yes.  Nonetheless, I wouldn't see a problem if they, say, rewrite with
C11-compatible code (and same ABI) on a function granularity (and when
the function itself isn't executing concurrently) -- this seems to be
similar to just having another compiler compile this particular
function.


