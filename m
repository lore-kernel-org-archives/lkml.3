Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754217AbaBQW0U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 17:26:20 -0500
Received: from mx1.redhat.com ([209.132.183.28]:16058 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752819AbaBQW0R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 17:26:17 -0500
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
In-Reply-To: <CA+55aFyay_ck4eb6HEWvD4bTS=3OYY7wX1MVNKAcpUYN0ssWhA@mail.gmail.com>
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
	 <CA+55aFyay_ck4eb6HEWvD4bTS=3OYY7wX1MVNKAcpUYN0ssWhA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 17 Feb 2014 23:25:39 +0100
Message-ID: <1392675939.18779.7063.camel@triegel.csb>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-02-17 at 14:02 -0800, Linus Torvalds wrote:
> On Mon, Feb 17, 2014 at 1:21 PM, Torvald Riegel <triegel@redhat.com> wrote:
> > On Mon, 2014-02-17 at 12:18 -0800, Linus Torvalds wrote:
> >> and then it is read by people (compiler writers) that intentionally
> >> try to mis-use the words and do language-lawyering ("that depends on
> >> what the meaning of 'is' is").
> >
> > That assumption about people working on compilers is a little too broad,
> > don't you think?
> 
> Let's just say that *some* are that way, and those are the ones that I
> end up butting heads with.
> 
> The sane ones I never have to argue with - point them at a bug, and
> they just say "yup, bug". The insane ones say "we don't need to fix
> that, because if you read this copy of the standards that have been
> translated to chinese and back, it clearly says that this is
> acceptable".
> 
> >> The whole "lvalue vs rvalue expression
> >> vs 'what is a volatile access'" thing for C++ was/is a great example
> >> of that.
> >
> > I'm not aware of the details of this.
> 
> The argument was that an lvalue doesn't actually "access" the memory
> (an rvalue does), so this:
> 
>    volatile int *p = ...;
> 
>    *p;
> 
> doesn't need to generate a load from memory, because "*p" is still an
> lvalue (since you could assign things to it).
> 
> This isn't an issue in C, because in C, expression statements are
> always rvalues, but C++ changed that.

Huhh.  I can see the problems that this creates in terms of C/C++
compatibility.

> The people involved with the C++
> standards have generally been totally clueless about their subtle
> changes.

This isn't a fair characterization.  There are many people that do care,
and certainly not all are clueless.  But it's a limited set of people,
bugs happen, and not all of them will have the same goals.

I think one way to prevent such problems in the future could be to have
someone in the kernel community volunteer to look through standard
revisions before they are published.  The standard needs to be fixed,
because compilers need to conform to the standard (e.g., a compiler's
extension "fixing" the above wouldn't be conforming anymore because it
emits more volatile reads than specified).

Or maybe those of us working on the standard need to flag potential
changes of interest to the kernel folks.  But that may be less reliable
than someone from the kernel side looking at them; I don't know.

