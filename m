Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752087AbaJ1QZi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 12:25:38 -0400
Received: from mail-vc0-f178.google.com ([209.85.220.178]:58129 "EHLO
	mail-vc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750892AbaJ1QZg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 12:25:36 -0400
MIME-Version: 1.0
In-Reply-To: <20141028160729.GH29706@arm.com>
References: <1414496662-25202-1-git-send-email-will.deacon@arm.com>
	<1414496662-25202-2-git-send-email-will.deacon@arm.com>
	<CA+55aFxVtxA-j7uwVCeB4asm4DB-gz4xnsygW8_s0OYfU8hXrw@mail.gmail.com>
	<20141028160729.GH29706@arm.com>
Date: Tue, 28 Oct 2014 09:25:35 -0700
X-Google-Sender-Auth: KpDhX43bZZlflyw8dSI57fOZKjs
Message-ID: <CA+55aFxvz=guax4KcAszyjkqdqXGwV38O+G23xMvGFJDTrZqtg@mail.gmail.com>
Subject: Re: [RFC PATCH 1/2] zap_pte_range: update addr when forcing flush
 after TLB batching faiure
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Will Deacon <will.deacon@arm.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 28, 2014 at 9:07 AM, Will Deacon <will.deacon@arm.com> wrote:
>
> Ok, that's useful, thanks. Out of curiosity, what *is* the current intention
> of __tlb_remove_tlb_entry, if start/end shouldn't be touched by
> architectures? Is it just for the PPC hash thing?

I think it's both the PPC hash, and for "legacy reasons" (ie
architectures that don't use the generic code, and were converted from
the "invalidate as you walk the tables" without ever really fixing the
"you have to flush the TLB before you free the page, and do
batching").

It would be lovely if we could just drop it entirely, although
changing it to actively do the minimal range is fine too.

> I was certainly seeing this issue trigger regularly when running firefox,
> but I'll need to dig and find out the differences in range size.

I'm wondering whether that was perhaps because of the mix-up with
initialization of the range. Afaik, that would always break your
min/max thing for the first batch (and since the batches are fairly
large, "first" may be "only")

But hey. it's possible that firefox does some big mappings but only
populates the beginning. Most architectures don't tend to have
excessive glass jaws in this area: invalidating things page-by-page is
invariably so slow that at some point you just go "just do the whole
range".

> Since we have hardware broadcasting of TLB invalidations on ARM, it is
> in our interest to keep the number of outstanding operations as small as
> possible, particularly on large systems where we don't get the targetted
> shootdown with a single message that you can perform using IPIs (i.e.
> you can only broadcast to all or no CPUs, and that happens for each pte).

Do you seriously *have* to broadcast for each pte?

Because that is quite frankly moronic.  We batch things up in software
for a real good reason: doing things one entry at a time just cannot
ever scale. At some point (and that point is usually not even very far
away), it's much better to do a single invalidate over a range. The
cost of having to refill the TLB's is *much* smaller than the cost of
doing tons of cross-CPU invalidates.

That's true even for the cases where we track the CPU's involved in
that mapping, and only invalidate a small subset. With a "all CPU's
broadcast", the cross-over point must be even smaller. Doing thousands
of CPU broadcasts is just crazy, even if they are hw-accelerated.

Can't you just do a full invalidate and a SW IPI for larger ranges?

And as mentioned, true sparse mappings are actually fairly rare, so
making extra effort (and data structures) to have individual ranges
sounds crazy.

Is this some hw-enforced thing? You really can't turn off the
cross-cpu-for-each-pte braindamage?

                         Linus
