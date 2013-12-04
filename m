Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755729Ab3LDVcY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 16:32:24 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:35467 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752976Ab3LDVcW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 16:32:22 -0500
Date: Wed, 4 Dec 2013 13:32:20 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        Brian Norris <computersforpeace@gmail.com>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: Re: BUG: sleeping function called from invalid context at
 kernel/locking/mutex.c:616
Message-Id: <20131204133220.a7f38e748ce2c57f90483111@linux-foundation.org>
In-Reply-To: <1386147578.20621.4.camel@phoenix>
References: <1385895217.3994.2.camel@phoenix>
	<1386144811.16763.2.camel@phoenix>
	<20131204003147.454534da.akpm@linux-foundation.org>
	<1386147578.20621.4.camel@phoenix>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 04 Dec 2013 16:59:38 +0800 Axel Lin <axel.lin@ingics.com> wrote:

> > 
> > Please add a lot more printk's so we can narrow it down further?  I'd
> > use something like 
> > 
> > 	printk(%d: %d\n", __LINE__, preempt_count());
> > 
> > (note: preempt_count(), not in_atomic())
> > 
> > Paste that all over the place so we can see which statement is doing
> > the wrong thing.  
> 
> Below is the code ( to show the line number ):
> 
> 459 int add_to_page_cache_locked(struct page *page, struct address_space
> *mapping,
>  460                 pgoff_t offset, gfp_t gfp_mask)
>  461 {
>  462         int error;
>  463 
>  464         VM_BUG_ON(!PageLocked(page));
>  465         VM_BUG_ON(PageSwapBacked(page));
>  466 
>  467         printk("%d: %d\n", __LINE__, preempt_count());
>  468         error = mem_cgroup_cache_charge(page, current->mm,
>  469                                         gfp_mask &
> GFP_RECLAIM_MASK);
>  470 printk("%d: %d\n", __LINE__, preempt_count());
>  471         if (error)
>  472                 return error;
>  473 
>  474         error = radix_tree_maybe_preload(gfp_mask &
> ~__GFP_HIGHMEM);
>  475 printk("%d: %d\n", __LINE__, preempt_count());
>  476         if (error) {
>  477                 mem_cgroup_uncharge_cache_page(page);
>  478                 return error;
>  479         }
>  480 
>  481         page_cache_get(page);
>  482         page->mapping = mapping;
>  483         page->index = offset;
>  484 
>  485 printk("%d: %d\n", __LINE__, preempt_count());
>  486         spin_lock_irq(&mapping->tree_lock);
>  487 printk("%d: %d\n", __LINE__, preempt_count());
>  488         error = radix_tree_insert(&mapping->page_tree, offset,
> page);
>  489 printk("%d: %d\n", __LINE__, preempt_count());
>  490         radix_tree_preload_end();
>  491 printk("%d: %d\n", __LINE__, preempt_count());
>  492         if (unlikely(error))
>  493                 goto err_insert;
>  494 printk("%d: %d\n", __LINE__, preempt_count());
>  495         mapping->nrpages++;
>  496 printk("%d: %d\n", __LINE__, preempt_count());
>  497         __inc_zone_page_state(page, NR_FILE_PAGES);
>  498 printk("%d: %d\n", __LINE__, preempt_count());
>  499         spin_unlock_irq(&mapping->tree_lock);
>  500 printk("%d: %d\n", __LINE__, preempt_count());
>  501         trace_mm_filemap_add_to_page_cache(page);
>  502 printk("%d: %d\n", __LINE__, preempt_count());
>  503         return 0;
>  504 err_insert:
>  505         page->mapping = NULL;
>  506         /* Leave page->index set: truncation relies upon it */
>  507         spin_unlock_irq(&mapping->tree_lock);
>  508         mem_cgroup_uncharge_cache_page(page);
>  509         page_cache_release(page);
>  510 printk("%d: %d\n", __LINE__, preempt_count());
>  511         return error;
>  512 }
> 
> Below is the output log:
> 
> VFS: Mounted root (jffs2 filesystem) on device 31:1.
> devtmpfs: mounted
> Freeing unused kernel memory: 92K (003a8000 - 003bf000)
> 467: 0
> 470: 0
> 475: 1
> 485: 1
> 487: 2
> 489: 2
> 491: 1
> 494: 1
> 496: 1
> 498: 1
> 500: 0
> 502: 0
> 467: 0
> 470: 0
> 475: 1
> 485: 1
> 487: 2
> 489: 2
> 491: 1
> 494: 1
> 496: 1
> 498: 1
> 500: 0
> 502: 0
> 467: 0
> 470: 0
> 475: 1
> 485: 1
> 487: 2
> 489: 2
> 491: 1
> 494: 1
> 496: 1
> 498: 1
> 500: 1

blam.  spin_unlock_irq(&mapping->tree_lock) failed to decrement
preempt_count().  What the heck.

What architecture is this?  Please send the full .config.

And exactly which kernel version is in use?

Thanks.

> 502: 1
> BUG: sleeping function called from invalid context at kernel/locking/mutex.c:616
> in_atomic(): 1, irqs_disabled(): 128, pid: 1, name: swapper
> 1 lock held by swapper/1:

