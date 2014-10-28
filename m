Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754445AbaJ1VRf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 17:17:35 -0400
Received: from gate.crashing.org ([63.228.1.57]:47667 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751141AbaJ1VRe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 17:17:34 -0400
Message-ID: <1414530994.29180.19.camel@pasglop>
Subject: Re: [RFC PATCH 1/2] zap_pte_range: update addr when forcing flush
 after TLB batching faiure
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Will Deacon <will.deacon@arm.com>, Peter Zijlstra <peterz@infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Date: Wed, 29 Oct 2014 08:16:34 +1100
In-Reply-To: <CA+55aFxvz=guax4KcAszyjkqdqXGwV38O+G23xMvGFJDTrZqtg@mail.gmail.com>
References: <1414496662-25202-1-git-send-email-will.deacon@arm.com>
	 <1414496662-25202-2-git-send-email-will.deacon@arm.com>
	 <CA+55aFxVtxA-j7uwVCeB4asm4DB-gz4xnsygW8_s0OYfU8hXrw@mail.gmail.com>
	 <20141028160729.GH29706@arm.com>
	 <CA+55aFxvz=guax4KcAszyjkqdqXGwV38O+G23xMvGFJDTrZqtg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-10-28 at 09:25 -0700, Linus Torvalds wrote:

> > Since we have hardware broadcasting of TLB invalidations on ARM, it is
> > in our interest to keep the number of outstanding operations as small as
> > possible, particularly on large systems where we don't get the targetted
> > shootdown with a single message that you can perform using IPIs (i.e.
> > you can only broadcast to all or no CPUs, and that happens for each pte).
> 
> Do you seriously *have* to broadcast for each pte?

We do too, in current CPUs at least, it's sad ...

> Because that is quite frankly moronic.  We batch things up in software
> for a real good reason: doing things one entry at a time just cannot
> ever scale. At some point (and that point is usually not even very far
> away), it's much better to do a single invalidate over a range. The
> cost of having to refill the TLB's is *much* smaller than the cost of
> doing tons of cross-CPU invalidates.
> 
> That's true even for the cases where we track the CPU's involved in
> that mapping, and only invalidate a small subset. With a "all CPU's
> broadcast", the cross-over point must be even smaller. Doing thousands
> of CPU broadcasts is just crazy, even if they are hw-accelerated.
> 
> Can't you just do a full invalidate and a SW IPI for larger ranges?

For us, this would be great except ... we can potentially have other
agents with an MMU that only support snooping of the broadcasts...

> And as mentioned, true sparse mappings are actually fairly rare, so
> making extra effort (and data structures) to have individual ranges
> sounds crazy.
> 
> Is this some hw-enforced thing? You really can't turn off the
> cross-cpu-for-each-pte braindamage?

Cheers,
Ben.

>                          Linus
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


