Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753456AbaIXVPr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 17:15:47 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:49926 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753314AbaIXVPp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 17:15:45 -0400
Date: Wed, 24 Sep 2014 14:15:44 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Greg Thelen <gthelen@google.com>,
        Vladimir Davydov <vdavydov@parallels.com>, Dave Hansen <dave@sr71.net>,
        Michal Hocko <mhocko@suse.cz>, linux-mm@kvack.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 1/3] mm: memcontrol: do not kill uncharge batching in
 free_pages_and_swap_cache
Message-Id: <20140924141544.72fbfd323252a18d275d063e@linux-foundation.org>
In-Reply-To: <20140924210322.GA11017@cmpxchg.org>
References: <1411571338-8178-1-git-send-email-hannes@cmpxchg.org>
	<1411571338-8178-2-git-send-email-hannes@cmpxchg.org>
	<20140924124234.3fdb59d6cdf7e9c4d6260adb@linux-foundation.org>
	<20140924210322.GA11017@cmpxchg.org>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Sep 2014 17:03:22 -0400 Johannes Weiner <hannes@cmpxchg.org> wrote:

> > Obviously it's not very important - presumably the common case is that
> > the LRU contains lengthy sequences of pages from the same zone.  Maybe.
> 
> Even then, the end result is more concise and busts the lock where
> it's actually taken, making the whole thing a bit more obvious:

Yes, that did come out better.

> From: Michal Hocko <mhocko@suse.cz>
> Date: Fri, 5 Sep 2014 11:16:17 +0200
> Subject: [patch] mm: memcontrol: do not kill uncharge batching in
>  free_pages_and_swap_cache
> 
> free_pages_and_swap_cache limits release_pages to PAGEVEC_SIZE chunks.
> This is not a big deal for the normal release path but it completely
> kills memcg uncharge batching which reduces res_counter spin_lock
> contention. Dave has noticed this with his page fault scalability test
> case on a large machine when the lock was basically dominating on all
> CPUs:
>     80.18%    80.18%  [kernel]               [k] _raw_spin_lock
>                   |
>                   --- _raw_spin_lock
>                      |
>                      |--66.59%-- res_counter_uncharge_until
>                      |          res_counter_uncharge
>                      |          uncharge_batch
>                      |          uncharge_list
>                      |          mem_cgroup_uncharge_list
>                      |          release_pages
>                      |          free_pages_and_swap_cache
>                      |          tlb_flush_mmu_free
>                      |          |
>                      |          |--90.12%-- unmap_single_vma
>                      |          |          unmap_vmas
>                      |          |          unmap_region
>                      |          |          do_munmap
>                      |          |          vm_munmap
>                      |          |          sys_munmap
>                      |          |          system_call_fastpath
>                      |          |          __GI___munmap
>                      |          |
>                      |           --9.88%-- tlb_flush_mmu
>                      |                     tlb_finish_mmu
>                      |                     unmap_region
>                      |                     do_munmap
>                      |                     vm_munmap
>                      |                     sys_munmap
>                      |                     system_call_fastpath
>                      |                     __GI___munmap
> 
> In his case the load was running in the root memcg and that part
> has been handled by reverting 05b843012335 ("mm: memcontrol: use
> root_mem_cgroup res_counter") because this is a clear regression,
> but the problem remains inside dedicated memcgs.
> 
> There is no reason to limit release_pages to PAGEVEC_SIZE batches other
> than lru_lock held times. This logic, however, can be moved inside the
> function. mem_cgroup_uncharge_list and free_hot_cold_page_list do not
> hold any lock for the whole pages_to_free list so it is safe to call
> them in a single run.
> 
> In release_pages, break the lock at least every SWAP_CLUSTER_MAX (32)
> pages, then remove the batching from free_pages_and_swap_cache.

I beefed this paragraph up a bit:

: The release_pages() code was previously breaking the lru_lock each
: PAGEVEC_SIZE pages (ie, 14 pages).  However this code has no usage of
: pagevecs so switch to breaking the lock at least every SWAP_CLUSTER_MAX
: (32) pages.  This means that the lock acquisition frequency is
: approximately halved and the max hold times are approximately doubled.
:
: The now unneeded batching is removed from free_pages_and_swap_cache().

I doubt if the increased irq-off time will hurt anyone, but who knows...


