Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752647AbaBRVlK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 16:41:10 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51789 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752577AbaBRVlE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 16:41:04 -0500
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
In-Reply-To: <20140218171609.GP4250@linux.vnet.ibm.com>
References: <CA+55aFx9CbgrfK4rBVYD75y2KoWiO90dSYsAW83O-tYVLK-gkg@mail.gmail.com>
	 <CA+55aFypfiTFwundih8QEA6ZwVGk=g5L4sabsN0932eih5knOQ@mail.gmail.com>
	 <1392486310.18779.6447.camel@triegel.csb>
	 <CA+55aFwTrt_6m1inNHQkk74i7uPkHNnacwHiBgioZSXieAs5Sw@mail.gmail.com>
	 <1392666947.18779.6838.camel@triegel.csb>
	 <CA+55aFwUnRVk6q3VZeYjWfduoHcExW=Pht6jgp=4bBSaLHNPMA@mail.gmail.com>
	 <530296CD.5050503@warwick.ac.uk>
	 <CA+55aFyi8QWge7QR0M+ABH-kEiwvoEyMhK6GWRvN1YNKJAFuSQ@mail.gmail.com>
	 <1392737465.18779.7644.camel@triegel.csb>
	 <CA+55aFxn2KRXDQ91xRs=bO_6d_nA_PSQvoY1_=OxyJ86+KOO9Q@mail.gmail.com>
	 <20140218171609.GP4250@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 18 Feb 2014 22:40:15 +0100
Message-ID: <1392759615.18779.8429.camel@triegel.csb>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-02-18 at 09:16 -0800, Paul E. McKenney wrote:
> On Tue, Feb 18, 2014 at 08:49:13AM -0800, Linus Torvalds wrote:
> > On Tue, Feb 18, 2014 at 7:31 AM, Torvald Riegel <triegel@redhat.com> wrote:
> > > On Mon, 2014-02-17 at 16:05 -0800, Linus Torvalds wrote:
> > >> And exactly because I know enough, I would *really* like atomics to be
> > >> well-defined, and have very clear - and *local* - rules about how they
> > >> can be combined and optimized.
> > >
> > > "Local"?
> > 
> > Yes.
> > 
> > So I think that one of the big advantages of atomics over volatile is
> > that they *can* be optimized, and as such I'm not at all against
> > trying to generate much better code than for volatile accesses.
> > 
> > But at the same time, that can go too far. For example, one of the
> > things we'd want to use atomics for is page table accesses, where it
> > is very important that we don't generate multiple accesses to the
> > values, because parts of the values can be change *by*hardware* (ie
> > accessed and dirty bits).
> > 
> > So imagine that you have some clever global optimizer that sees that
> > the program never ever actually sets the dirty bit at all in any
> > thread, and then uses that kind of non-local knowledge to make
> > optimization decisions. THAT WOULD BE BAD.
> 
> Might as well list other reasons why value proofs via whole-program
> analysis are unreliable for the Linux kernel:
> 
> 1.	As Linus said, changes from hardware.

This is what's volatile is for, right?  (Or the weak-volatile idea I
mentioned).

Compilers won't be able to prove something about the values of such
variables, if marked (weak-)volatile.

> 2.	Assembly code that is not visible to the compiler.
> 	Inline asms will -normally- let the compiler know what
> 	memory they change, but some just use the "memory" tag.
> 	Worse yet, I suspect that most compilers don't look all
> 	that carefully at .S files.
> 
> 	Any number of other programs contain assembly files.

Are the annotations of changed memory really a problem?  If the "memory"
tag exists, isn't that supposed to mean all memory?

To make a proof about a program for location X, the compiler has to
analyze all uses of X.  Thus, as soon as X escapes into an .S file, then
the compiler will simply not be able to prove a thing (except maybe due
to the data-race-free requirement for non-atomics).  The attempt to
prove something isn't unreliable, simply because a correct compiler
won't claim to be able to "prove" something.

One reason that could corrupt this is that if program addresses objects
other than through the mechanisms defined in the language.  For example,
if one thread lays out a data structure at a constant fixed memory
address, and another one then uses the fixed memory address to get
access to the object with a cast (e.g., (void*)0x123).

> 3.	Kernel modules that have not yet been written.  Now, the
> 	compiler could refrain from trying to prove anything about
> 	an EXPORT_SYMBOL() or EXPORT_SYMBOL_GPL() variable, but there
> 	is currently no way to communicate this information to the
> 	compiler other than marking the variable "volatile".

Even if the variable is just externally accessible, then the compiler
knows that it can't do whole-program analysis about it.

It is true that whole-program analysis will not be applicable in this
case, but it will not be unreliable.  I think that's an important
difference.

> 	Other programs have similar issues, e.g., via dlopen().
> 
> 4.	Some drivers allow user-mode code to mmap() some of their
> 	state.  Any changes undertaken by the user-mode code would
> 	be invisible to the compiler.

A good point, but a compiler that doesn't try to (incorrectly) assume
something about the semantics of mmap will simply see that the mmap'ed
data will escape to stuff if can't analyze, so it will not be able to
make a proof.

This is different from, for example, malloc(), which is guaranteed to
return "fresh" nonaliasing memory.

> 5.	JITed code produced based on BPF: https://lwn.net/Articles/437981/

This might be special, or not, depending on how the JITed code gets
access to data.  If this is via fixed addresses (e.g., (void*)0x123),
then see above.  If this is through function calls that the compiler
can't analyze, then this is like 4.

