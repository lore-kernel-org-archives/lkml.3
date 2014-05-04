Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753359AbaEDSbh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2014 14:31:37 -0400
Received: from mail-vc0-f169.google.com ([209.85.220.169]:42572 "EHLO
	mail-vc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751360AbaEDSbg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2014 14:31:36 -0400
MIME-Version: 1.0
In-Reply-To: <5365FB8A.8080303@nod.at>
References: <alpine.LSU.2.11.1404161239320.6778@eggly.anvils>
	<1399160247-32093-1-git-send-email-richard@nod.at>
	<CA+55aFzbSUPGWyO42KM7geAy8WrP8e=q+KoqdOBY68zay0jrZA@mail.gmail.com>
	<5365FB8A.8080303@nod.at>
Date: Sun, 4 May 2014 11:31:35 -0700
X-Google-Sender-Auth: rjE4eZ8YEoU1KgMmFH17i2p5Ig8
Message-ID: <CA+55aFw9SLeE1fv1-nKMeB7o0YAFZ85mskYy_izCb7Nh3AiicQ@mail.gmail.com>
Subject: Re: [PATCH] mm: Fix force_flush behavior in zap_pte_range()
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Richard Weinberger <richard@nod.at>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>, Dave Jones <davej@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Sasha Levin <sasha.levin@oracle.com>, Hugh Dickins <hughd@google.com>,
        =?UTF-8?Q?Toralf_F=C3=B6rster?= <toralf.foerster@gmx.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 4, 2014 at 1:34 AM, Richard Weinberger <richard@nod.at> wrote:
>
> Hmm, I got confused by:
>                         if (PageAnon(page))
>                                 rss[MM_ANONPAGES]--;
>                         else {
>                                 if (pte_dirty(ptent)) {
>                                         force_flush = 1;
>
> Here you set force_flush.

Yes. And it needs to stay set, but we don't want to break out early.

The logic is:

 - if the tlb removal page batching tables fill up, we need to stop
any further batching, and flush the TLB immediately, since we don't
have room for any more entries.

   Thus that case does "force_flush=1" _and_ a "break" out of the loop.

 - if we see dirty shared pages, we need to flush the TLB before we
release the page table lock, but we don't have to stop further
batching.

   So this case just does "force_flush=1", but will continue to loop
over the page tables, since it can happily batch more pages.

>                         if (unlikely(!__tlb_remove_page(tlb, page))) {
>                                 force_flush = 1;
>                                 break;
>                         }
>
> And here it cannot get back to 0.

Correct. It *must* not go back to zero, because that would break the
"we had dirty pages, and more room to batch things".

> With your patch applied I see lots of BUG: Bad rss-counter state messages on UML (x86_32)
> when fuzzing with trinity the mremap syscall.
> And sometimes I face BUG at mm/filemap.c:202.

I'm suspecting that it's some UML bug that is triggered by the
changes. UML has its own tlb gather logic (I'm not quite sure why), I
wonder what's up.

Also, are the messages coming from UML or from the host kernel? I'm
assuming they are UML.

> After killing a trinity child I start observing the said issues.
>
> e.g.
> fix_range_common: failed, killing current process: 841
> fix_range_common: failed, killing current process: 842
> fix_range_common: failed, killing current process: 843
> BUG: Bad rss-counter state mm:28e69600 idx:0 val:2

That "idx=0" means that it's MM_FILEPAGES. Apparently the killing
ended up resulting in not freeing all the file mapping pte's.

So I'm assuming the real issue is that fix_range_common failure that
triggers this.

Exactly why the new tlb flushing triggers this is not entirely clear,
but I'd take a look at how UML reacts to the whole fact that a forced
flush (which never happened before, because your __tlb_remove_page()
doesn't batch anything up and always returns 1) updates the tlb
start/end fields as it does the tlb_flush_mmu_tlbonly().

             Linus
