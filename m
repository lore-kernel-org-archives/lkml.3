Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752588AbaBJBRP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 20:17:15 -0500
Received: from mx1.redhat.com ([209.132.183.28]:59453 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752171AbaBJBRK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 20:17:10 -0500
Subject: Re: [RFC][PATCH 0/5] arch: atomic rework
From: Torvald Riegel <triegel@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Will Deacon <will.deacon@arm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ramana Radhakrishnan <Ramana.Radhakrishnan@arm.com>,
        David Howells <dhowells@redhat.com>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "gcc@gcc.gnu.org" <gcc@gcc.gnu.org>
In-Reply-To: <CA+55aFwFVr2KiXX2MObMBGypQk9eabe-93Nhmro=HL1RtC-1jw@mail.gmail.com>
References: <52F3DA85.1060209@arm.com>
	 <20140206185910.GE27276@mudshark.cambridge.arm.com>
	 <20140206192743.GH4250@linux.vnet.ibm.com>
	 <1391721423.23421.3898.camel@triegel.csb>
	 <20140206221117.GJ4250@linux.vnet.ibm.com>
	 <1391730288.23421.4102.camel@triegel.csb>
	 <20140207042051.GL4250@linux.vnet.ibm.com>
	 <20140207074405.GM5002@laptop.programming.kicks-ass.net>
	 <20140207165028.GO4250@linux.vnet.ibm.com>
	 <20140207165548.GR5976@mudshark.cambridge.arm.com>
	 <20140207180216.GP4250@linux.vnet.ibm.com>
	 <1391992071.18779.99.camel@triegel.csb>
	 <CA+55aFwFVr2KiXX2MObMBGypQk9eabe-93Nhmro=HL1RtC-1jw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 09 Feb 2014 17:16:26 -0800
Message-ID: <1391994986.18779.169.camel@triegel.csb>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-02-09 at 16:56 -0800, Linus Torvalds wrote:
> On Sun, Feb 9, 2014 at 4:27 PM, Torvald Riegel <triegel@redhat.com> wrote:
> >
> > I wouldn't characterize the situation like this (although I can't speak
> > for others, obviously).  IMHO, it's perfectly fine on sequential /
> > non-synchronizing code, because we know the difference isn't observable
> > by a correct program.
> 
> What BS is that? If you use an "atomic_store_explicit()", by
> definition you're either
> 
>  (a) f*cking insane
>  (b) not doing sequential non-synchronizing code
> 
> and a compiler that assumes that the programmer is insane may actually
> be correct more often than not, but it's still a shit compiler.
> Agreed?

Due to all the expletives, I can't really understand what you are
saying.  Nor does what I guess it might mean seem to relate to what I
said.

(a) seems to say that you don't like requiring programmers to mark
atomic accesses specially.  Is that the case?

If so, I have to disagree.  If you're writing concurrent code, marking
the atomic accesses is the least of your problem.  Instead, for the
concurrent code I've written, it rather improved readability; it made
code more verbose, but in turn it made the synchronization easier to
see.

Beside this question of taste (and I don't care what the Kernel style
guides are), there is a real technical argument here, though:  Requiring
all synchronizing memory accesses to be annotated makes the compiler
aware what is sequential code, and what is not.  Without it, one can't
exploit data-race-freedom.  So unless we want to slow down optimization
of sequential code, we need to tell the compiler what is what.  If every
access is potentially synchronizing, then this doesn't just prevent
speculative stores.

(b) seems as if you are saying that if there is a specially annotated
atomic access in the code, that this isn't sequential/non-synchronizing
code anymore.  I don't agree with that, obviously.

> So I don't see how any sane person can say that speculative writes are
> ok. They are clearly not ok.

We are discussing programs written against the C11/C++11 memory model
here.  At least that's the part that got forwarded to gcc@gcc.gnu.org,
and was subject of the nearest emails in the thread.

This memory model requires programs to be data-race-free.  Thus, we can
optimize accordingly.  If you don't like that, then this isn't C11/C++11
anymore.  Which would be fine, but then complain about that
specifically.

> Speculative stores are a bad idea in general.

I disagree in the context of C11/C++11 programs.  At least from a
correctness point of view.

> They are completely
> invalid for anything that says "atomic".

I agree, as you will see when you read the other emails I posted as part
of this thread.  But those two things are separate.

