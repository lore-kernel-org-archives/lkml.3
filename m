Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756253AbaGIRHQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 13:07:16 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:49255 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753515AbaGIRHO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 13:07:14 -0400
Date: Wed, 9 Jul 2014 10:05:35 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Vlastimil Babka <vbabka@suse.cz>
cc: Sasha Levin <sasha.levin@oracle.com>, Hugh Dickins <hughd@google.com>,
        akpm@linux-foundation.org, davej@redhat.com, koct9i@gmail.com,
        lczerner@redhat.com, stable@vger.kernel.org,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: + shmem-fix-faulting-into-a-hole-while-its-punched-take-2.patch
 added to -mm tree
In-Reply-To: <53BD6F4E.6030003@suse.cz>
Message-ID: <alpine.LSU.2.11.1407091000410.11705@eggly.anvils>
References: <53b45c9b.2rlA0uGYBLzlXEeS%akpm@linux-foundation.org> <53BCBF1F.1000506@oracle.com> <alpine.LSU.2.11.1407082309040.7374@eggly.anvils> <53BD1053.5020401@suse.cz> <53BD39FC.7040205@oracle.com> <53BD67DC.9040700@oracle.com>
 <53BD6F4E.6030003@suse.cz>
User-Agent: Alpine 2.11 (LSU 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 Jul 2014, Vlastimil Babka wrote:
> On 07/09/2014 06:03 PM, Sasha Levin wrote:
> > 
> > We can see that it's not blocked since it's in the middle of a spinlock
> > unlock
> > call, and we can guess it's been in that function for a while because of
> > the hung
> > task timer, and other processes waiting on that i_mmap_mutex:
> 
> Hm, zap_pte_range has potentially an endless loop due to the 'goto again'
> path. Could it be a somewhat similar situation to the fallocate problem, but
> where parallel faulters on shared memory are preventing a process from
> exiting? Although they don't fault the pages into the same address space,
> they could maybe somehow interact through the TLB flushing code? And only
> after fixing the original problem we can observe this one?

That's a good thought.  It ought to make forward progress nonetheless,
but I believe (please check, I'm rushing) that there's an off-by-one in
that path which could leave us hanging - but only when __tlb_remove_page()
repeatedly fails, which would only happen if exceptionally low on memory??

Does this patch look good, and does it make any difference to the hang?

--- mmotm/mm/memory.c	2014-07-02 15:32:22.212311544 -0700
+++ linux/mm/memory.c	2014-07-09 09:56:33.724159443 -0700
@@ -1145,6 +1145,7 @@ again:
 			if (unlikely(page_mapcount(page) < 0))
 				print_bad_pte(vma, addr, ptent, page);
 			if (unlikely(!__tlb_remove_page(tlb, page))) {
+				addr += PAGE_SIZE;
 				force_flush = 1;
 				break;
 			}
