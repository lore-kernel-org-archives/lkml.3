Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753713AbaBRFWk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 00:22:40 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:51370 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751020AbaBRFWh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 00:22:37 -0500
Date: Mon, 17 Feb 2014 21:22:32 -0800
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
Message-ID: <20140218052232.GG4250@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140214172920.GQ4250@linux.vnet.ibm.com>
 <CA+55aFx9CbgrfK4rBVYD75y2KoWiO90dSYsAW83O-tYVLK-gkg@mail.gmail.com>
 <CA+55aFypfiTFwundih8QEA6ZwVGk=g5L4sabsN0932eih5knOQ@mail.gmail.com>
 <1392486310.18779.6447.camel@triegel.csb>
 <CA+55aFwTrt_6m1inNHQkk74i7uPkHNnacwHiBgioZSXieAs5Sw@mail.gmail.com>
 <1392666947.18779.6838.camel@triegel.csb>
 <CA+55aFwUnRVk6q3VZeYjWfduoHcExW=Pht6jgp=4bBSaLHNPMA@mail.gmail.com>
 <20140218030002.GA15857@linux.vnet.ibm.com>
 <CA+55aFyqLrj4d2TA+2aazRqXnbVsUvs0yaBL2D5rXF1G=Kiu_g@mail.gmail.com>
 <CA+55aFwsq5E8kMoEeHJJ1f2=+QAUCu_HndfPxHNz8fUBprS-jQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFwsq5E8kMoEeHJJ1f2=+QAUCu_HndfPxHNz8fUBprS-jQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14021805-1542-0000-0000-000006553B40
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 17, 2014 at 07:42:42PM -0800, Linus Torvalds wrote:
> On Mon, Feb 17, 2014 at 7:24 PM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >
> > As far as I can tell, the intent is that you can't do value
> > speculation (except perhaps for the "relaxed", which quite frankly
> > sounds largely useless).
> 
> Hmm. The language I see for "consume" is not obvious:
> 
>   "Consume operation: no reads in the current thread dependent on the
> value currently loaded can be reordered before this load"
> 
> and it could make a compiler writer say that value speculation is
> still valid, if you do it like this (with "ptr" being the atomic
> variable):
> 
>   value = ptr->val;
> 
> into
> 
>   tmp = ptr;
>   value = speculated.value;
>   if (unlikely(tmp != &speculated))
>     value = tmp->value;
> 
> which is still bogus. The load of "ptr" does happen before the load of
> "value = speculated->value" in the instruction stream, but it would
> still result in the CPU possibly moving the value read before the
> pointer read at least on ARM and power.
> 
> So if you're a compiler person, you think you followed the letter of
> the spec - as far as *you* were concerned, no load dependent on the
> value of the atomic load moved to before the atomic load. You go home,
> happy, knowing you've done your job. Never mind that you generated
> code that doesn't actually work.

Agreed, that would be bad.  But please see below.

> I dread having to explain to the compiler person that he may be right
> in some theoretical virtual machine, but the code is subtly broken and
> nobody will ever understand why (and likely not be able to create a
> test-case showing the breakage).

If things go as they usually do, such explanations will be required
a time or two.

> But maybe the full standard makes it clear that "reordered before this
> load" actually means on the real hardware, not just in the generated
> instruction stream. Reading it with understanding of the *intent* and
> understanding all the different memory models that requirement should
> be obvious (on alpha, you need an "rmb" instruction after the load),
> but ...

The key point with memory_order_consume is that it must be paired with
some sort of store-release, a category that includes stores tagged
with memory_order_release (surprise!), memory_order_acq_rel, and
memory_order_seq_cst.  This pairing is analogous to the memory-barrier
pairing in the Linux kernel.

So you have something like this for the rcu_assign_pointer() side:

	p = kmalloc(...);
	if (unlikely(!p))
		return -ENOMEM;
	p->a = 1;
	p->b = 2;
	p->c = 3;
	/* The following would be buried within rcu_assign_pointer(). */
	atomic_store_explicit(&gp, p, memory_order_release);

And something like this for the rcu_dereference() side:

	/* The following would be buried within rcu_dereference(). */
	q = atomic_load_explicit(&gp, memory_order_consume);
	do_something_with(q->a);

So, let's look at the C11 draft, section 5.1.2.4 "Multi-threaded
executions and data races".

5.1.2.4p14 says that the atomic_load_explicit() carries a dependency to
the argument of do_something_with().

5.1.2.4p15 says that the atomic_store_explicit() is dependency-ordered
before the atomic_load_explicit().

5.1.2.4p15 also says that the atomic_store_explicit() is
dependency-ordered before the argument of do_something_with().  This is
because if A is dependency-ordered before X and X carries a dependency
to B, then A is dependency-ordered before B.

5.1.2.4p16 says that the atomic_store_explicit() inter-thread happens
before the argument of do_something_with().

The assignment to p->a is sequenced before the atomic_store_explicit().

Therefore, combining these last two, the assignment to p->a happens
before the argument of do_something_with(), and that means that
do_something_with() had better see the "1" assigned to p->a or some
later value.

But as far as I know, compiler writers currently take the approach of
treating memory_order_consume as if it was memory_order_acquire.
Which certainly works, as long as ARM and PowerPC people don't mind
an extra memory barrier out of each rcu_dereference().

Which is one thing that compiler writers are permitted to do according
to the standard -- substitute a memory-barrier instruction for any
given dependency...

							Thanx, Paul

