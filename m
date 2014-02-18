Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754090AbaBRDAN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 22:00:13 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:37899 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752371AbaBRDAI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 22:00:08 -0500
Date: Mon, 17 Feb 2014 19:00:02 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Torvald Riegel <triegel@redhat.com>, Will Deacon <will.deacon@arm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ramana Radhakrishnan <Ramana.Radhakrishnan@arm.com>,
        David Howells <dhowells@redhat.com>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "gcc@gcc.gnu.org" <gcc@gcc.gnu.org>
Subject: Re: [RFC][PATCH 0/5] arch: atomic rework
Message-ID: <20140218030002.GA15857@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
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
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFwUnRVk6q3VZeYjWfduoHcExW=Pht6jgp=4bBSaLHNPMA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14021803-3532-0000-0000-000005C08DF2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 17, 2014 at 12:18:21PM -0800, Linus Torvalds wrote:
> On Mon, Feb 17, 2014 at 11:55 AM, Torvald Riegel <triegel@redhat.com> wrote:
> >
> > Which example do you have in mind here?  Haven't we resolved all the
> > debated examples, or did I miss any?
> 
> Well, Paul seems to still think that the standard possibly allows
> speculative writes or possibly value speculation in ways that break
> the hardware-guaranteed orderings.

It is not that I know of any specific problems, but rather that I
know I haven't looked under all the rocks.  Plus my impression from
my few years on the committee is that the standard will be pushed to
the limit when it comes time to add optimizations.

One example that I learned about last week uses the branch-prediction
hardware to validate value speculation.  And no, I am not at all a fan
of value speculation, in case you were curious.  However, it is still
an educational example.

This is where you start:

	p = gp.load_explicit(memory_order_consume); /* AKA rcu_dereference() */
	do_something(p->a, p->b, p->c);
	p->d = 1;

Then you leverage branch-prediction hardware as follows:

	p = gp.load_explicit(memory_order_consume); /* AKA rcu_dereference() */
	if (p == GUESS) {
		do_something(GUESS->a, GUESS->b, GUESS->c);
		GUESS->d = 1;
	} else {
		do_something(p->a, p->b, p->c);
		p->d = 1;
	}

The CPU's branch-prediction hardware squashes speculation in the case where
the guess was wrong, and this prevents the speculative store to ->d from
ever being visible.  However, the then-clause breaks dependencies, which
means that the loads -could- be speculated, so that do_something() gets
passed pre-initialization values.

Now, I hope and expect that the wording in the standard about dependency
ordering prohibits this sort of thing.  But I do not yet know for certain.

And yes, I am being paranoid.  But not unnecessarily paranoid.  ;-)

							Thanx, Paul

> And personally, I can't read standards paperwork. It is invariably
> written in some basically impossible-to-understand lawyeristic mode,
> and then it is read by people (compiler writers) that intentionally
> try to mis-use the words and do language-lawyering ("that depends on
> what the meaning of 'is' is"). The whole "lvalue vs rvalue expression
> vs 'what is a volatile access'" thing for C++ was/is a great example
> of that.
> 
> So quite frankly, as a result I refuse to have anything to do with the
> process directly.
> 
>                  Linus
> 

