Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755130AbaBSSMY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 13:12:24 -0500
Received: from mx1.redhat.com ([209.132.183.28]:31949 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755109AbaBSSMU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 13:12:20 -0500
Subject: Re: [RFC][PATCH 0/5] arch: atomic rework
From: Torvald Riegel <triegel@redhat.com>
To: David Lang <david@lang.hm>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Alec Teal <a.teal@warwick.ac.uk>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Will Deacon <will.deacon@arm.com>,
        Ramana Radhakrishnan <Ramana.Radhakrishnan@arm.com>,
        David Howells <dhowells@redhat.com>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "gcc@gcc.gnu.org" <gcc@gcc.gnu.org>
In-Reply-To: <alpine.DEB.2.02.1402190722040.2147@nftneq.ynat.uz>
References: <CA+55aFypfiTFwundih8QEA6ZwVGk=g5L4sabsN0932eih5knOQ@mail.gmail.com>
	 <1392486310.18779.6447.camel@triegel.csb>
	 <CA+55aFwTrt_6m1inNHQkk74i7uPkHNnacwHiBgioZSXieAs5Sw@mail.gmail.com>
	 <1392666947.18779.6838.camel@triegel.csb>
	 <CA+55aFwUnRVk6q3VZeYjWfduoHcExW=Pht6jgp=4bBSaLHNPMA@mail.gmail.com>
	 <530296CD.5050503@warwick.ac.uk>
	 <CA+55aFyi8QWge7QR0M+ABH-kEiwvoEyMhK6GWRvN1YNKJAFuSQ@mail.gmail.c!om>
	 <1392737465.18779.7644.camel@triegel.csb>
	 <CA+55aFxn2KRXDQ91xRs=bO_6d_nA_PSQvoY1_=OxyJ86+KOO9Q@mail.gmail.com>
	 <1392758516.18779.8378.camel@triegel.csb>
	 <20140218214047.GU14089@laptop.programming.kicks-ass.net>
	 <1392760035.18779.8449.camel@triegel.csb>
	 <alpine.DEB.2.02.1402190722040.2147@nftneq.ynat.uz>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 19 Feb 2014 19:11:39 +0100
Message-ID: <1392833499.18779.9347.camel@triegel.csb>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-02-19 at 07:23 -0800, David Lang wrote:
> On Tue, 18 Feb 2014, Torvald Riegel wrote:
> 
> > On Tue, 2014-02-18 at 22:40 +0100, Peter Zijlstra wrote:
> >> On Tue, Feb 18, 2014 at 10:21:56PM +0100, Torvald Riegel wrote:
> >>> Well, that's how atomics that aren't volatile are defined in the
> >>> standard.  I can see that you want something else too, but that doesn't
> >>> mean that the other thing is broken.
> >>
> >> Well that other thing depends on being able to see the entire program at
> >> compile time. PaulMck already listed various ways in which this is
> >> not feasible even for normal userspace code.
> >>
> >> In particular; DSOs and JITs were mentioned.
> >
> > No it doesn't depend on whole-program analysis being possible.  Because
> > if it isn't, then a correct compiler will just not do certain
> > optimizations simply because it can't prove properties required for the
> > optimization to hold.  With the exception of access to objects via magic
> > numbers (e.g., fixed and known addresses (see my reply to Paul), which
> > are outside of the semantics specified in the standard), I don't see a
> > correctness problem here.
> 
> Are you really sure that the compiler can figure out every possible thing that a 
> loadable module or JITed code can access? That seems like a pretty strong claim.

If the other code can be produced by a C translation unit that is valid
to be linked with the rest of the program, then I'm pretty sure the
compiler has a well-defined notion of whether it does or does not see
all other potential accesses.  IOW, if the C compiler is dealing with C
semantics and mechanisms only (including the C mechanisms for sharing
with non-C code!), then it will know what to do.

If you're playing tricks behind the C compiler's back using
implementation-defined stuff outside of the C specification, then
there's nothing the compiler really can do.  For example, if you're
trying to access a variable on a function's stack from some other
function, you better know how the register allocator of the compiler
operates.  In contrast, if you let this function simply export the
address of the variable to some external place, all will be fine.

The documentation of GCC's -fwhole-program and -flto might also be
interesting for you.  GCC wouldn't need to have -fwhole-program if it
weren't conservative by default (correctly so).

