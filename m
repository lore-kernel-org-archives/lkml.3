Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754976Ab3LDIay (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 03:30:54 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58231 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754916Ab3LDIaw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 03:30:52 -0500
Date: Wed, 4 Dec 2013 00:31:47 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        Brian Norris <computersforpeace@gmail.com>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: Re: BUG: sleeping function called from invalid context at
 kernel/locking/mutex.c:616
Message-Id: <20131204003147.454534da.akpm@linux-foundation.org>
In-Reply-To: <1386144811.16763.2.camel@phoenix>
References: <1385895217.3994.2.camel@phoenix>
	<1386144811.16763.2.camel@phoenix>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 04 Dec 2013 16:13:31 +0800 Axel Lin <axel.lin@ingics.com> wrote:

> I can constantly hit this issue:
> 
> I trace it to mm/filemap.c: add_to_page_cache_locked
> I print the in_atomic status at BEGIN and END of add_to_page_cache_locked call.
> Then I got in_atomic is true at the end of add_to_page_cache_locked call.
> 
> int add_to_page_cache_locked(struct page *page, struct address_space *mapping,
>                 pgoff_t offset, gfp_t gfp_mask)
> {
>         int error;
> 
>         VM_BUG_ON(!PageLocked(page));
>         VM_BUG_ON(PageSwapBacked(page));
> 
> pr_info(" ##add_to_page_cache_locked BEGIN in_atomic=%d\n", in_atomic());
>         error = mem_cgroup_cache_charge(page, current->mm,
>                                         gfp_mask & GFP_RECLAIM_MASK);
>         if (error)
>                 return error;
> 
>         error = radix_tree_maybe_preload(gfp_mask & ~__GFP_HIGHMEM);
>         if (error) {
>                 mem_cgroup_uncharge_cache_page(page);
>                 return error;
>         }
> 
>         page_cache_get(page);
>         page->mapping = mapping;
>         page->index = offset;
> 
>         spin_lock_irq(&mapping->tree_lock);
>         error = radix_tree_insert(&mapping->page_tree, offset, page);
>         radix_tree_preload_end();
>         if (unlikely(error))
>                 goto err_insert;
>         mapping->nrpages++;
>         __inc_zone_page_state(page, NR_FILE_PAGES);
>         spin_unlock_irq(&mapping->tree_lock);
>         trace_mm_filemap_add_to_page_cache(page);
> pr_info(" ##add_to_page_cache_locked END in_atomic=%d\n", in_atomic());
>         return 0;
> err_insert:
>         page->mapping = NULL;
>         /* Leave page->index set: truncation relies upon it */
>         spin_unlock_irq(&mapping->tree_lock);
>         mem_cgroup_uncharge_cache_page(page);
>         page_cache_release(page);
> pr_info(" ##add_to_page_cache_locked ERR in_atomic=%d\n", in_atomic());
>         return error;
> }
> 
> Then I got below messages:
>  ##add_to_page_cache_locked BEGIN in_atomic=0
>  ##add_to_page_cache_locked END in_atomic=0
>  ##add_to_page_cache_locked BEGIN in_atomic=0
>  ##add_to_page_cache_locked END in_atomic=0
>  ##add_to_page_cache_locked BEGIN in_atomic=0
>  ##add_to_page_cache_locked END in_atomic=1

huh.  I can't spot it.  mem_cgroup_cache_charge() is by far the most
complex callee.

Is tracing enabled?

Is memcg in use?

Please add a lot more printk's so we can narrow it down further?  I'd
use something like 

	printk(%d: %d\n", __LINE__, preempt_count());

(note: preempt_count(), not in_atomic())

Paste that all over the place so we can see which statement is doing
the wrong thing.  

Thanks.
