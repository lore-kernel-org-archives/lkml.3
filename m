Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756270AbaBRQS0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 11:18:26 -0500
Received: from mx1.redhat.com ([209.132.183.28]:61207 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751527AbaBRQSX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 11:18:23 -0500
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
In-Reply-To: <CA+55aFwsq5E8kMoEeHJJ1f2=+QAUCu_HndfPxHNz8fUBprS-jQ@mail.gmail.com>
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
	 <CA+55aFyqLrj4d2TA+2aazRqXnbVsUvs0yaBL2D5rXF1G=Kiu_g@mail.gmail.com>
	 <CA+55aFwsq5E8kMoEeHJJ1f2=+QAUCu_HndfPxHNz8fUBprS-jQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 18 Feb 2014 17:17:38 +0100
Message-ID: <1392740258.18779.7732.camel@triegel.csb>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-02-17 at 19:42 -0800, Linus Torvalds wrote:
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

I can't remember seeing that language in the standard (ie, C or C++).
Where is this from?

> and it could make a compiler writer say that value speculation is
> still valid, if you do it like this (with "ptr" being the atomic
> variable):
> 
>   value = ptr->val;

I assume the load from ptr has mo_consume ordering?

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

And surprise, in the C/C++ model the load from ptr is sequenced-before
the load from speculated, but there's no ordering constraint on the
reads-from relation for the value load if you use mo_consume on the ptr
load.  Thus, the transformed code has less ordering constraints than the
original code, and we arrive at the same outcome.

> So if you're a compiler person, you think you followed the letter of
> the spec - as far as *you* were concerned, no load dependent on the
> value of the atomic load moved to before the atomic load.

No.  Because the wobbly sentence you cited(?) above is not what the
standard says.

Would you please stop making claims about what compiler writers would do
or not if you seemingly aren't even familiar with the model that
compiler writers would use to reason about transformations?  Seriously?

> You go home,
> happy, knowing you've done your job. Never mind that you generated
> code that doesn't actually work.
> 
> I dread having to explain to the compiler person that he may be right
> in some theoretical virtual machine, but the code is subtly broken and
> nobody will ever understand why (and likely not be able to create a
> test-case showing the breakage).
> 
> But maybe the full standard makes it clear that "reordered before this
> load" actually means on the real hardware, not just in the generated
> instruction stream.

Do you think everyone else is stupid?  If there's an ordering constraint
in the virtual machine, it better be present when executing in the real
machine unless it provably cannot result in different output as
specified by the language's semantics.

> Reading it with understanding of the *intent* and
> understanding all the different memory models that requirement should
> be obvious (on alpha, you need an "rmb" instruction after the load),
> but ...

The standard is clear on what's required.  I strongly suggest reading
the formalization of the memory model by Batty et al.

