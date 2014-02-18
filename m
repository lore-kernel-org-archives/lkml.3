Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756154AbaBRP5W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 10:57:22 -0500
Received: from mx1.redhat.com ([209.132.183.28]:37622 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751005AbaBRP5U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 10:57:20 -0500
Subject: Re: [RFC][PATCH 0/5] arch: atomic rework
From: Torvald Riegel <triegel@redhat.com>
To: paulmck@linux.vnet.ibm.com
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Will Deacon <will.deacon@arm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ramana Radhakrishnan <Ramana.Radhakrishnan@arm.com>,
        David Howells <dhowells@redhat.com>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "gcc@gcc.gnu.org" <gcc@gcc.gnu.org>
In-Reply-To: <20140218030002.GA15857@linux.vnet.ibm.com>
References: <1392321837.18779.3249.camel@triegel.csb>
	 <20140214020144.GO4250@linux.vnet.ibm.com>
	 <1392352981.18779.3800.camel@triegel.csb>
	 <20140214172920.GQ4250@linux.vnet.ibm.com>
	 <CA+55aFx9CbgrfK4rBVYD75y2KoWiO90dSYsAW83O-tYVLK-gkg@mail.gmail.com>
	 <CA+55aFypfiTFwundih8QEA6ZwVGk=g5L4sabsN0932eih5knOQ@mail.gmail.com>
	 <1392486310.18779.6447.camel@triegel.csb>
	 <CA+55aFwTrt_6m1inNHQkk74i7uPkHNnacwHiBgioZSXieAs5Sw@mail.gmail.com>
	 <1392666947.18779.6838.camel@triegel.csb>
	 <CA+55aFwUnRVk6q3VZeYjWfduoHcExW=Pht6jgp=4bBSaLHNPMA@mail.gmail.com>
	 <20140218030002.GA15857@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 18 Feb 2014 16:56:40 +0100
Message-ID: <1392739000.18779.7692.camel@triegel.csb>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-02-17 at 19:00 -0800, Paul E. McKenney wrote:
> On Mon, Feb 17, 2014 at 12:18:21PM -0800, Linus Torvalds wrote:
> > On Mon, Feb 17, 2014 at 11:55 AM, Torvald Riegel <triegel@redhat.com> wrote:
> > >
> > > Which example do you have in mind here?  Haven't we resolved all the
> > > debated examples, or did I miss any?
> > 
> > Well, Paul seems to still think that the standard possibly allows
> > speculative writes or possibly value speculation in ways that break
> > the hardware-guaranteed orderings.
> 
> It is not that I know of any specific problems, but rather that I
> know I haven't looked under all the rocks.  Plus my impression from
> my few years on the committee is that the standard will be pushed to
> the limit when it comes time to add optimizations.
> 
> One example that I learned about last week uses the branch-prediction
> hardware to validate value speculation.  And no, I am not at all a fan
> of value speculation, in case you were curious.  However, it is still
> an educational example.
> 
> This is where you start:
> 
> 	p = gp.load_explicit(memory_order_consume); /* AKA rcu_dereference() */
> 	do_something(p->a, p->b, p->c);
> 	p->d = 1;

I assume that's the source code.

> Then you leverage branch-prediction hardware as follows:
> 
> 	p = gp.load_explicit(memory_order_consume); /* AKA rcu_dereference() */
> 	if (p == GUESS) {
> 		do_something(GUESS->a, GUESS->b, GUESS->c);
> 		GUESS->d = 1;
> 	} else {
> 		do_something(p->a, p->b, p->c);
> 		p->d = 1;
> 	}

I assume that this is a potential transformation by a compiler.

> The CPU's branch-prediction hardware squashes speculation in the case where
> the guess was wrong, and this prevents the speculative store to ->d from
> ever being visible.  However, the then-clause breaks dependencies, which
> means that the loads -could- be speculated, so that do_something() gets
> passed pre-initialization values.
> 
> Now, I hope and expect that the wording in the standard about dependency
> ordering prohibits this sort of thing.  But I do not yet know for certain.

The transformation would be incorrect.  p->a in the source code carries
a dependency, and as you say, the transformed code wouldn't have that
dependency any more.  So the transformed code would loose ordering
constraints that it has in the virtual machine, so in the absence of
other proofs of correctness based on properties not shown in the
example, the transformed code would not result in the same behavior as
allowed by the abstract machine.

If the transformation would actually be by a programmer, then this
wouldn't do the same as the first example because mo_consume doesn't
work through the if statement.

Are there other specified concerns that you have regarding this example?

