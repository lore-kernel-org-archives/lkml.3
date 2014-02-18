Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752805AbaBRTm2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 14:42:28 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:34455 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752427AbaBRTmZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 14:42:25 -0500
Date: Tue, 18 Feb 2014 11:42:18 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Sewell <Peter.Sewell@cl.cam.ac.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Torvald Riegel <triegel@redhat.com>, Alec Teal <a.teal@warwick.ac.uk>,
        Will Deacon <will.deacon@arm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ramana Radhakrishnan <Ramana.Radhakrishnan@arm.com>,
        David Howells <dhowells@redhat.com>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "gcc@gcc.gnu.org" <gcc@gcc.gnu.org>
Subject: Re: [RFC][PATCH 0/5] arch: atomic rework
Message-ID: <20140218194218.GU4250@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1392486310.18779.6447.camel@triegel.csb>
 <CA+55aFwTrt_6m1inNHQkk74i7uPkHNnacwHiBgioZSXieAs5Sw@mail.gmail.com>
 <1392666947.18779.6838.camel@triegel.csb>
 <CA+55aFwUnRVk6q3VZeYjWfduoHcExW=Pht6jgp=4bBSaLHNPMA@mail.gmail.com>
 <530296CD.5050503@warwick.ac.uk>
 <CA+55aFyi8QWge7QR0M+ABH-kEiwvoEyMhK6GWRvN1YNKJAFuSQ@mail.gmail.com>
 <1392737465.18779.7644.camel@triegel.csb>
 <CA+55aFxn2KRXDQ91xRs=bO_6d_nA_PSQvoY1_=OxyJ86+KOO9Q@mail.gmail.com>
 <20140218171609.GP4250@linux.vnet.ibm.com>
 <CAHWkzRSXxAPShfFTAQj=f5M1L4K1E5D6yLmQS72-b1jNGTPpEA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHWkzRSXxAPShfFTAQj=f5M1L4K1E5D6yLmQS72-b1jNGTPpEA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14021819-0928-0000-0000-000006CCF3CF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 18, 2014 at 06:23:47PM +0000, Peter Sewell wrote:
> On 18 February 2014 17:16, Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:
> > On Tue, Feb 18, 2014 at 08:49:13AM -0800, Linus Torvalds wrote:
> >> On Tue, Feb 18, 2014 at 7:31 AM, Torvald Riegel <triegel@redhat.com> wrote:
> >> > On Mon, 2014-02-17 at 16:05 -0800, Linus Torvalds wrote:
> >> >> And exactly because I know enough, I would *really* like atomics to be
> >> >> well-defined, and have very clear - and *local* - rules about how they
> >> >> can be combined and optimized.
> >> >
> >> > "Local"?
> >>
> >> Yes.
> >>
> >> So I think that one of the big advantages of atomics over volatile is
> >> that they *can* be optimized, and as such I'm not at all against
> >> trying to generate much better code than for volatile accesses.
> >>
> >> But at the same time, that can go too far. For example, one of the
> >> things we'd want to use atomics for is page table accesses, where it
> >> is very important that we don't generate multiple accesses to the
> >> values, because parts of the values can be change *by*hardware* (ie
> >> accessed and dirty bits).
> >>
> >> So imagine that you have some clever global optimizer that sees that
> >> the program never ever actually sets the dirty bit at all in any
> >> thread, and then uses that kind of non-local knowledge to make
> >> optimization decisions. THAT WOULD BE BAD.
> >
> > Might as well list other reasons why value proofs via whole-program
> > analysis are unreliable for the Linux kernel:
> >
> > 1.      As Linus said, changes from hardware.
> >
> > 2.      Assembly code that is not visible to the compiler.
> >         Inline asms will -normally- let the compiler know what
> >         memory they change, but some just use the "memory" tag.
> >         Worse yet, I suspect that most compilers don't look all
> >         that carefully at .S files.
> >
> >         Any number of other programs contain assembly files.
> >
> > 3.      Kernel modules that have not yet been written.  Now, the
> >         compiler could refrain from trying to prove anything about
> >         an EXPORT_SYMBOL() or EXPORT_SYMBOL_GPL() variable, but there
> >         is currently no way to communicate this information to the
> >         compiler other than marking the variable "volatile".
> >
> >         Other programs have similar issues, e.g., via dlopen().
> >
> > 4.      Some drivers allow user-mode code to mmap() some of their
> >         state.  Any changes undertaken by the user-mode code would
> >         be invisible to the compiler.
> >
> > 5.      JITed code produced based on BPF: https://lwn.net/Articles/437981/
> >
> > And probably other stuff as well.
> 
> interesting list.  So are you saying that value-range-analysis and
> such-like (I say glibly, without really knowing what "such-like"
> refers to here) are fundamentally incompatible with
> the kernel code, or can you think of some way to tell the compiler a
> bound on the footprint of the "unseen" changes in each of those cases?

Other than the "volatile" keyword, no.

Well, I suppose you could also create a function that changed the
variables in question, then arrange to never call it, but in such a way
that the compiler could not prove that it was never called.  But ouch!

							Thanx, Paul

