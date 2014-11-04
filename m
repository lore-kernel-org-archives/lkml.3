Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754828AbaKDQId (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 11:08:33 -0500
Received: from mail-vc0-f169.google.com ([209.85.220.169]:49815 "EHLO
	mail-vc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752470AbaKDQI2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 11:08:28 -0500
MIME-Version: 1.0
In-Reply-To: <20141104142955.GA24816@e104818-lin.cambridge.arm.com>
References: <1414496662-25202-1-git-send-email-will.deacon@arm.com>
	<1414496662-25202-2-git-send-email-will.deacon@arm.com>
	<CA+55aFxVtxA-j7uwVCeB4asm4DB-gz4xnsygW8_s0OYfU8hXrw@mail.gmail.com>
	<CA+55aFwpOCeXdThX3zB64AU4hFwufD6UdJDi2tkD8Q7yEV2pOA@mail.gmail.com>
	<20141029194738.GA29911@arm.com>
	<20141104142955.GA24816@e104818-lin.cambridge.arm.com>
Date: Tue, 4 Nov 2014 08:08:27 -0800
X-Google-Sender-Auth: nkofHEoKR_lFWHA9F-8AgLObLrk
Message-ID: <CA+55aFzBggoXtNXQeng5d_mRoDnaMBE5Y+URs+PHR67nUpMtaw@mail.gmail.com>
Subject: Re: [RFC PATCH 1/2] zap_pte_range: update addr when forcing flush
 after TLB batching faiure
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will.deacon@arm.com>, Peter Zijlstra <peterz@infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 4, 2014 at 6:29 AM, Catalin Marinas <catalin.marinas@arm.com> wrote:
>
> This would work on arm64 but is the PAGE_SIZE range enough for all
> architectures even when we flush a huge page or a pmd/pud table entry?

It pretty much had *better* be.

For things like page tables caches (ie caching addresses "inside" the
page tables, like x86 does), for legacy reasons, flushing an
individual page had better flush the page table caches behind it. This
is definitely how x86 works, for example. And if you have an
architected non-legacy page table cache (which I'm not aware of
anybody actually doing), you're going to have some architecturally
explicit flushing for that, likely *separate* from a regular TLB entry
flush, and thus you'd need more than just some range expansion..

And the logic is very similar for things like hugepages. Either a
normal "TLB invalidate" insutrction anywhere in the hugepage will
invalidate the whole hugepage), or you would have special instructions
or rules for invalidating hugepages and you'd need more than just some
range expansion.

So in neither case does it make sense to expand the range, afaik. And
it would hurt normal architectures. So if we ever find an architecture
that would want something that odd, I think it is up to that
architecture to do its own odd thing, not cause pain for others.

                          Linus
