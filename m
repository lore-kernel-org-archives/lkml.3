Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753686AbaBQXmi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 18:42:38 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40616 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751005AbaBQXmg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 18:42:36 -0500
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
In-Reply-To: <CA+55aFx2jxE8sTZEmNnMg6ktDuU_0xPiEw3=qH0=+xat8p8cAA@mail.gmail.com>
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
	 <1392672063.18779.6940.camel@triegel.csb>
	 <CA+55aFyay_ck4eb6HEWvD4bTS=3OYY7wX1MVNKAcpUYN0ssWhA@mai! l.gmail.com>
	 <1392675939.18779.7063.camel@triegel.csb>
	 <CA+55aFx2jxE8sTZEmNnMg6ktDuU_0xPiEw3=qH0=+xat8p8cAA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 18 Feb 2014 00:41:58 +0100
Message-ID: <1392680518.18779.7213.camel@triegel.csb>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-02-17 at 14:47 -0800, Linus Torvalds wrote:
> On Mon, Feb 17, 2014 at 2:25 PM, Torvald Riegel <triegel@redhat.com> wrote:
> > On Mon, 2014-02-17 at 14:02 -0800, Linus Torvalds wrote:
> >>
> >> The argument was that an lvalue doesn't actually "access" the memory
> >> (an rvalue does), so this:
> >>
> >>    volatile int *p = ...;
> >>
> >>    *p;
> >>
> >> doesn't need to generate a load from memory, because "*p" is still an
> >> lvalue (since you could assign things to it).
> >>
> >> This isn't an issue in C, because in C, expression statements are
> >> always rvalues, but C++ changed that.
> >
> > Huhh.  I can see the problems that this creates in terms of C/C++
> > compatibility.
> 
> That's not the biggest problem.
> 
> The biggest problem is that you have compiler writers that don't care
> about sane *use* of the features they write a compiler for, they just
> care about the standard.
> 
> So they don't care about C vs C++ compatibility. Even more
> importantly, they don't care about the *user* that uses only C++ and
> the fact that their reading of the standard results in *meaningless*
> behavior. They point to the standard and say "that's what the standard
> says, suck it", and silently generate code (or in this case, avoid
> generating code) that makes no sense.

There's an underlying problem here that's independent from the actual
instance that you're worried about here: "no sense" is a ultimately a
matter of taste/objectives/priorities as long as the respective
specification is logically consistent.

If you want to be independent of your sanity being different from other
people's sanity (e.g., compiler writers), you need to make sure that the
specification is precise and says what you want.  IOW, think about the
specification being the program, and the people being computers; you
better want a well-defined program in this case.

> So it's not about C++ being incompatible with C, it's about C++ having
> insane and bad semantics unless you just admit that "oh, ok, I need to
> not just read the standard, I also need to use my brain, and admit
> that a C++ statement expression needs to act as if it is an "access"
> wrt volatile variables".

1) I agree that (IMO) a good standard strives for being easy to
understand.

2) In practice, there is a trade-off between "Easy to understand" and
actually producing a specification.  A standard is not a tutorial.  And
that's for good reason, because (a) there might be more than one way to
teach something and that should be allowed and (b) that the standard
should carry the full precision but still be compact enough to be
manageable.

3) Implementations can try to be nice to users by helping them avoiding
error-prone corner cases or such.  A warning for common problems is such
a case.  But an implementation has to draw a line somewhere, demarcating
cases where it fully exploits what the standard says (eg, to allow
optimizations) from cases where it is more conservative and does what
the standard allows but in a potentially more intuitive way.  That's
especially the case if it's being asked to produce high-performance
code.

4) There will be arguments for where the line actually is, simply
because different users will have different goals.

5) The way to reduce 4) is to either make the standard more specific, or
to provide better user documentation.  If the standard has strict
requirements, then there will be less misunderstanding.

6) To achieve 5), one way is to get involved in the standards process.


