Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756446AbaE2VEq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 17:04:46 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:48387 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754147AbaE2VEo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 17:04:44 -0400
Date: Thu, 29 May 2014 14:03:33 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Michael Ellerman <mpe@ellerman.id.au>
cc: Hugh Dickins <hughd@google.com>, Andrew Morton <akpm@linux-foundation.org>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Tony Luck <tony.luck@intel.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, trinity@vger.kernel.org
Subject: Re: BUG at mm/memory.c:1489!
In-Reply-To: <1401353983.4930.15.camel@concordia>
Message-ID: <alpine.LSU.2.11.1405291350260.10186@eggly.anvils>
References: <1401265922.3355.4.camel@concordia> <alpine.LSU.2.11.1405281712310.7156@eggly.anvils> <1401353983.4930.15.camel@concordia>
User-Agent: Alpine 2.11 (LSU 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 May 2014, Michael Ellerman wrote:
> 
> Unfortunately I don't know our mm/hugetlb code well enough to give you a good
> answer. Ben had a quick look at our follow_huge_addr() and thought it looked
> "fishy". He suggested something like what we do in gup_pte_range() with
> page_cache_get_speculative() might be in order.

Fishy indeed, ancient code that was only ever intended for stats-like
usage, not designed for actually getting a hold on the page.  But I
don't think there's a big problem to getting the locking right: just
hope it doesn't require a different strategy on each architecture -
often an irritation with hugetlb.  Naoya-san will sort it out in
due course (not 3.15) I expect, but will probably need testing help.

> 
> Applying your patch and running trinity pretty immediately results in the
> following, which looks related (sys_move_pages() again) ?
> 
> Unable to handle kernel paging request for data at address 0xf2000f80000000
> Faulting instruction address: 0xc0000000001e29bc
> cpu 0x1b: Vector: 300 (Data Access) at [c0000003c70f76f0]
>     pc: c0000000001e29bc: .remove_migration_pte+0x9c/0x320
>     lr: c0000000001e29b8: .remove_migration_pte+0x98/0x320
>     sp: c0000003c70f7970
>    msr: 8000000000009032
>    dar: f2000f80000000
>  dsisr: 40000000
>   current = 0xc0000003f9045800
>   paca    = 0xc000000001dc6c00   softe: 0        irq_happened: 0x01
>     pid   = 3585, comm = trinity-c27
> enter ? for help
> [c0000003c70f7a20] c0000000001bce88 .rmap_walk+0x328/0x470
> [c0000003c70f7ae0] c0000000001e2904 .remove_migration_ptes+0x44/0x60
> [c0000003c70f7b80] c0000000001e4ce8 .migrate_pages+0x6d8/0xa00
> [c0000003c70f7cc0] c0000000001e55ec .SyS_move_pages+0x5dc/0x7d0
> [c0000003c70f7e30] c00000000000a1d8 syscall_exit+0x0/0x98
> --- Exception: c01 (System Call) at 00003fff7b2b30a8
> SP (3fffe09728a0) is in userspace
> 1b:mon> 
> 
> I've hit it twice in two runs:
> 
> If I tell trinity to skip sys_move_pages() it runs for hours.

That's sad.  Sorry for wasting your time with my patch, thank you
for trying it.  What you see might be a consequence of the locking
deficiency I mentioned, given trinity's deviousness; though if it's
being clever like that, I would expect it to have already found the
equivalent issue on x86-64.  So probably not, probably another issue.

As I've said elsewhere, I think we need to go with disablement for now.

Hugh
