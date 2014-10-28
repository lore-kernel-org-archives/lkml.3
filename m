Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754710AbaJ1Pav (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 11:30:51 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:58363 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754625AbaJ1Pas (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 11:30:48 -0400
MIME-Version: 1.0
In-Reply-To: <1414496662-25202-2-git-send-email-will.deacon@arm.com>
References: <1414496662-25202-1-git-send-email-will.deacon@arm.com>
	<1414496662-25202-2-git-send-email-will.deacon@arm.com>
Date: Tue, 28 Oct 2014 08:30:43 -0700
X-Google-Sender-Auth: GkmAzeg4BdIq30nRLBmOZQPPOnU
Message-ID: <CA+55aFxVtxA-j7uwVCeB4asm4DB-gz4xnsygW8_s0OYfU8hXrw@mail.gmail.com>
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

On Tue, Oct 28, 2014 at 4:44 AM, Will Deacon <will.deacon@arm.com> wrote:
>
> This patch fixes the problem by incrementing addr by the PAGE_SIZE
> before breaking out of the loop on batch failure.

This patch seems harmless and right, unlike the other one.

I'd be ok with changing the *generic* code to do the "update start/end
pointers in the mmu_gather structure", but then it really has to be
done in *generic* code. Move your arm64 start/end updates to
include/asm-generic/tlb.h, and change the initialization of start/end
entirely. Right now we initialize those things to the maximal range
(see tlb_gather_mmu()), and the arm64 logic seems to be to initialize
them to TASK_SIZE/0 respectively and then update start/end as you add
pages, so that you get the minimal range.

But because of this arm64 confusion (the "minimal range" really is
*not* how this is designed to work), the current existing
tlb_gather_mmu() does the wrong initialization.

In other words: my argument is that right now the arm64 code is just
*wrong*. I'd be ok with making it the right thing to do, but if so, it
needs to be made generic.

Are there any actual advantages to teh whole "minimal range" model? It
adds overhead and complexity, and the only case where it would seem to
be worth it is for benchmarks that do mmap/munmap in a loop and then
only map a single page. Normal loads don't tend to have those kinds of
"minimal range is very different from whole range" cases. Do you have
a real case for why it does that minimal range thing.

Because if you don't have a real case, I'd really suggest you get rid
of all the arm64 games with start/end. That still leaves this one
patch the correct thing to do (because even without the start/end
games the "need_flush" flag goes with the range, but it makes the
second patch a complete non-issue.

If you *do* have a real case, I think you need to modify your second patch to:

 - move the arm start/end updates from tlb_flush/tlb_add_flush to asm-generic

 - make tlb_gather_mmu() initialize start/end to TASK_SIZE/0 the same
way your tlb_flush does (so that the subsequent min/max games work).

so that *everybody* does the start/end games. I'd be ok with that.
What I'm not ok with is arm64 using the generic TLB gather way in odd
ways that then breaks code and results in things like your 2/2 patch
that fixes ARM64 but breaks x86.

Hmm? Is there something I'm missing?

                         Linus
