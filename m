Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755248Ab3LDI7q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 03:59:46 -0500
Received: from mail-pd0-f173.google.com ([209.85.192.173]:50252 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754544Ab3LDI7n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 03:59:43 -0500
Message-ID: <1386147578.20621.4.camel@phoenix>
Subject: Re: BUG: sleeping function called from invalid context at
 kernel/locking/mutex.c:616
From: Axel Lin <axel.lin@ingics.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        Brian Norris <computersforpeace@gmail.com>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Date: Wed, 04 Dec 2013 16:59:38 +0800
In-Reply-To: <20131204003147.454534da.akpm@linux-foundation.org>
References: <1385895217.3994.2.camel@phoenix>
	 <1386144811.16763.2.camel@phoenix>
	 <20131204003147.454534da.akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

於 三，2013-12-04 於 00:31 -0800，Andrew Morton 提到：
> On Wed, 04 Dec 2013 16:13:31 +0800 Axel Lin <axel.lin@ingics.com> wrote:
> 
> > I can constantly hit this issue:
> > 
> > I trace it to mm/filemap.c: add_to_page_cache_locked
> > I print the in_atomic status at BEGIN and END of add_to_page_cache_locked call.
> > Then I got in_atomic is true at the end of add_to_page_cache_locked call.
> > 
> > int add_to_page_cache_locked(struct page *page, struct address_space *mapping,
> >                 pgoff_t offset, gfp_t gfp_mask)
> > {
> >         int error;
> > 
> >         VM_BUG_ON(!PageLocked(page));
> >         VM_BUG_ON(PageSwapBacked(page));
> > 
> > pr_info(" ##add_to_page_cache_locked BEGIN in_atomic=%d\n", in_atomic());
> >         error = mem_cgroup_cache_charge(page, current->mm,
> >                                         gfp_mask & GFP_RECLAIM_MASK);
> >         if (error)
> >                 return error;
> > 
> >         error = radix_tree_maybe_preload(gfp_mask & ~__GFP_HIGHMEM);
> >         if (error) {
> >                 mem_cgroup_uncharge_cache_page(page);
> >                 return error;
> >         }
> > 
> >         page_cache_get(page);
> >         page->mapping = mapping;
> >         page->index = offset;
> > 
> >         spin_lock_irq(&mapping->tree_lock);
> >         error = radix_tree_insert(&mapping->page_tree, offset, page);
> >         radix_tree_preload_end();
> >         if (unlikely(error))
> >                 goto err_insert;
> >         mapping->nrpages++;
> >         __inc_zone_page_state(page, NR_FILE_PAGES);
> >         spin_unlock_irq(&mapping->tree_lock);
> >         trace_mm_filemap_add_to_page_cache(page);
> > pr_info(" ##add_to_page_cache_locked END in_atomic=%d\n", in_atomic());
> >         return 0;
> > err_insert:
> >         page->mapping = NULL;
> >         /* Leave page->index set: truncation relies upon it */
> >         spin_unlock_irq(&mapping->tree_lock);
> >         mem_cgroup_uncharge_cache_page(page);
> >         page_cache_release(page);
> > pr_info(" ##add_to_page_cache_locked ERR in_atomic=%d\n", in_atomic());
> >         return error;
> > }
> > 
> > Then I got below messages:
> >  ##add_to_page_cache_locked BEGIN in_atomic=0
> >  ##add_to_page_cache_locked END in_atomic=0
> >  ##add_to_page_cache_locked BEGIN in_atomic=0
> >  ##add_to_page_cache_locked END in_atomic=0
> >  ##add_to_page_cache_locked BEGIN in_atomic=0
> >  ##add_to_page_cache_locked END in_atomic=1
> 
> huh.  I can't spot it.  mem_cgroup_cache_charge() is by far the most
> complex callee.
> 
> Is tracing enabled?

CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
CONFIG_HAVE_SYSCALL_TRACEPOINTS=y
CONFIG_HAVE_C_RECORDMCOUNT=y
CONFIG_TRACING_SUPPORT=y

But I don't us tracing, system hang while mounting root(jffs2).

> 
> Is memcg in use?
No.

> 
> Please add a lot more printk's so we can narrow it down further?  I'd
> use something like 
> 
> 	printk(%d: %d\n", __LINE__, preempt_count());
> 
> (note: preempt_count(), not in_atomic())
> 
> Paste that all over the place so we can see which statement is doing
> the wrong thing.  

Below is the code ( to show the line number ):

459 int add_to_page_cache_locked(struct page *page, struct address_space
*mapping,
 460                 pgoff_t offset, gfp_t gfp_mask)
 461 {
 462         int error;
 463 
 464         VM_BUG_ON(!PageLocked(page));
 465         VM_BUG_ON(PageSwapBacked(page));
 466 
 467         printk("%d: %d\n", __LINE__, preempt_count());
 468         error = mem_cgroup_cache_charge(page, current->mm,
 469                                         gfp_mask &
GFP_RECLAIM_MASK);
 470 printk("%d: %d\n", __LINE__, preempt_count());
 471         if (error)
 472                 return error;
 473 
 474         error = radix_tree_maybe_preload(gfp_mask &
~__GFP_HIGHMEM);
 475 printk("%d: %d\n", __LINE__, preempt_count());
 476         if (error) {
 477                 mem_cgroup_uncharge_cache_page(page);
 478                 return error;
 479         }
 480 
 481         page_cache_get(page);
 482         page->mapping = mapping;
 483         page->index = offset;
 484 
 485 printk("%d: %d\n", __LINE__, preempt_count());
 486         spin_lock_irq(&mapping->tree_lock);
 487 printk("%d: %d\n", __LINE__, preempt_count());
 488         error = radix_tree_insert(&mapping->page_tree, offset,
page);
 489 printk("%d: %d\n", __LINE__, preempt_count());
 490         radix_tree_preload_end();
 491 printk("%d: %d\n", __LINE__, preempt_count());
 492         if (unlikely(error))
 493                 goto err_insert;
 494 printk("%d: %d\n", __LINE__, preempt_count());
 495         mapping->nrpages++;
 496 printk("%d: %d\n", __LINE__, preempt_count());
 497         __inc_zone_page_state(page, NR_FILE_PAGES);
 498 printk("%d: %d\n", __LINE__, preempt_count());
 499         spin_unlock_irq(&mapping->tree_lock);
 500 printk("%d: %d\n", __LINE__, preempt_count());
 501         trace_mm_filemap_add_to_page_cache(page);
 502 printk("%d: %d\n", __LINE__, preempt_count());
 503         return 0;
 504 err_insert:
 505         page->mapping = NULL;
 506         /* Leave page->index set: truncation relies upon it */
 507         spin_unlock_irq(&mapping->tree_lock);
 508         mem_cgroup_uncharge_cache_page(page);
 509         page_cache_release(page);
 510 printk("%d: %d\n", __LINE__, preempt_count());
 511         return error;
 512 }

Below is the output log:

VFS: Mounted root (jffs2 filesystem) on device 31:1.
devtmpfs: mounted
Freeing unused kernel memory: 92K (003a8000 - 003bf000)
467: 0
470: 0
475: 1
485: 1
487: 2
489: 2
491: 1
494: 1
496: 1
498: 1
500: 0
502: 0
467: 0
470: 0
475: 1
485: 1
487: 2
489: 2
491: 1
494: 1
496: 1
498: 1
500: 0
502: 0
467: 0
470: 0
475: 1
485: 1
487: 2
489: 2
491: 1
494: 1
496: 1
498: 1
500: 1
502: 1
BUG: sleeping function called from invalid context at kernel/locking/mutex.c:616
in_atomic(): 1, irqs_disabled(): 128, pid: 1, name: swapper
1 lock held by swapper/1:
 #0:  (&sig->cred_guard_mutex){......}, at: [<00073ef8>] prepare_bprm_creds+0x30/0x6c
CPU: 0 PID: 1 Comm: swapper Not tainted 3.13.0-rc2-00203-g34074bc-dirty #2023
Backtrace: 
[<0000b204>] (dump_backtrace+0x0/0x108) from [<0000b398>] (show_stack+0x18/0x1c)
 r6:00000000 r5:0147abb8 r4:01c34000 r3:00200140
[<0000b380>] (show_stack+0x0/0x1c) from [<002ca888>] (dump_stack+0x20/0x28)
[<002ca868>] (dump_stack+0x0/0x28) from [<0002e3b8>] (__might_sleep+0xfc/0x11c)
[<0002e2bc>] (__might_sleep+0x0/0x11c) from [<002cdfe8>] (mutex_lock_nested+0x2c/0x30c)
 r4:0147abb8
[<002cdfbc>] (mutex_lock_nested+0x0/0x30c) from [<000c4de8>] (jffs2_readpage+0x50/0x78)
 r8:00100100 r7:00000002 r6:0081a640 r5:0147abb8 r4:0081a640
[<000c4d98>] (jffs2_readpage+0x0/0x78) from [<0005d874>] (__do_page_cache_readahead+0x1f8/0x25c)
 r5:00000004 r4:0147ad2c
[<0005d67c>] (__do_page_cache_readahead+0x0/0x25c) from [<0005db50>] (ra_submit+0x2c/0x34)
[<0005db24>] (ra_submit+0x0/0x34) from [<0005de1c>] (ondemand_readahead+0x2c4/0x2e8)
[<0005db58>] (ondemand_readahead+0x0/0x2e8) from [<0005df48>] (page_cache_sync_readahead+0x60/0x68)
[<0005dee8>] (page_cache_sync_readahead+0x0/0x68) from [<000562b4>] (generic_file_aio_read+0x314/0x7b0)
 r5:00000000 r4:00000001
[<00055fa0>] (generic_file_aio_read+0x0/0x7b0) from [<0006e738>] (do_sync_read+0x88/0xd0)
[<0006e6b0>] (do_sync_read+0x0/0xd0) from [<0006f02c>] (vfs_read+0xac/0xf4)
 r7:00000080 r6:01e5a400 r5:01c35ef8 r4:01c0fc40
[<0006ef80>] (vfs_read+0x0/0xf4) from [<00073a18>] (kernel_read+0x24/0x2c)
 r7:000089ed r6:0147ac20 r5:01c34000 r4:01e5a400
[<000739f4>] (kernel_read+0x0/0x2c) from [<00073b44>] (prepare_binprm+0x124/0x134)
[<00073a20>] (prepare_binprm+0x0/0x134) from [<00074210>] (do_execve+0x250/0x528)
 r7:003599eb r6:01c34000 r5:00000000 r4:01e5a400
[<00073fc0>] (do_execve+0x0/0x528) from [<000083e4>] (try_to_run_init_process+0x20/0x4c)
[<000083c4>] (try_to_run_init_process+0x0/0x4c) from [<002c7430>] (kernel_init+0x98/0x104)
 r5:002c7398 r4:003e8300
[<002c7398>] (kernel_init+0x0/0x104) from [<00009070>] (ret_from_fork+0x14/0x24)
 r4:00000000 r3:ffffffff
BUG: scheduling while atomic: swapper/1/0x00000003
4 locks held by swapper/1:
 #0:  (&sig->cred_guard_mutex){......}, at: [<00073ef8>] prepare_bprm_creds+0x30/0x6c
 #1:  (&f->sem){......}, at: [<000c4de8>] jffs2_readpage+0x50/0x78
 #2:  (&flash->lock){......}, at: [<0015cf30>] m25p80_read+0xb4/0x134
 #3:  (lock){......}, at: [<0015d8e8>] spi_write_then_read+0x38/0x158
Modules linked in:
CPU: 0 PID: 1 Comm: swapper Not tainted 3.13.0-rc2-00203-g34074bc-dirty #2023
Backtrace: 
[<0000b204>] (dump_backtrace+0x0/0x108) from [<0000b398>] (show_stack+0x18/0x1c)
 r6:01c34000 r5:00000000 r4:01c30000 r3:00200140
[<0000b380>] (show_stack+0x0/0x1c) from [<002ca888>] (dump_stack+0x20/0x28)
[<002ca868>] (dump_stack+0x0/0x28) from [<002c92bc>] (__schedule_bug+0x58/0x70)
[<002c9264>] (__schedule_bug+0x0/0x70) from [<002cc584>] (__schedule+0x58/0x398)
 r5:003cdef0 r4:01c30000
[<002cc52c>] (__schedule+0x0/0x398) from [<002cca30>] (schedule+0x88/0x8c)
[<002cc9a8>] (schedule+0x0/0x8c) from [<002cbf88>] (schedule_timeout+0x20/0x160)
[<002cbf68>] (schedule_timeout+0x0/0x160) from [<002cd130>] (wait_for_common+0xe0/0x178)
 r8:01c34000 r7:00000002 r6:01c358e4 r5:01c358e0 r4:7fffffff
[<002cd050>] (wait_for_common+0x0/0x178) from [<002cd1e0>] (wait_for_completion+0x18/0x1c)
[<002cd1c8>] (wait_for_completion+0x0/0x1c) from [<0015d85c>] (__spi_sync+0xbc/0xe0)
[<0015d7a0>] (__spi_sync+0x0/0xe0) from [<0015d8ac>] (spi_sync+0x14/0x18)
[<0015d898>] (spi_sync+0x0/0x18) from [<0015d9b0>] (spi_write_then_read+0x100/0x158)
[<0015d8b0>] (spi_write_then_read+0x0/0x158) from [<0015be60>] (read_sr+0x34/0x5c)
[<0015be2c>] (read_sr+0x0/0x5c) from [<0015c500>] (wait_till_ready+0x24/0x70)
 r5:ffffaf08 r4:003ccbd8
[<0015c4dc>] (wait_till_ready+0x0/0x70) from [<0015cf38>] (m25p80_read+0xbc/0x134)
 r6:01ce7814 r5:01c35ab8 r4:01ce7860 r3:80000001
[<0015ce7c>] (m25p80_read+0x0/0x134) from [<0015742c>] (part_read+0x64/0xac)
[<001573c8>] (part_read+0x0/0xac) from [<001545f0>] (mtd_read+0x90/0xc8)
 r7:01c35c04 r6:01e28400 r4:001fe33c
[<00154560>] (mtd_read+0x0/0xc8) from [<000d4448>] (jffs2_flash_read+0x48/0x220)
 r9:019b2000 r8:01e59c10 r7:00000044 r6:01c35c04 r5:00001cc4
r4:01e52800
[<000d4400>] (jffs2_flash_read+0x0/0x220) from [<000c61e4>] (jffs2_read_dnode+0x90/0x4ec)
[<000c6154>] (jffs2_read_dnode+0x0/0x4ec) from [<000c6764>] (jffs2_read_inode_range+0x124/0x1b4)
[<000c6640>] (jffs2_read_inode_range+0x0/0x1b4) from [<000c49dc>] (jffs2_do_readpage_nolock+0x70/0x100)
[<000c496c>] (jffs2_do_readpage_nolock+0x0/0x100) from [<000c4d84>] (jffs2_do_readpage_unlock+0x14/0x28)
 r6:0081a640 r5:0147abb8 r4:0081a640
[<000c4d70>] (jffs2_do_readpage_unlock+0x0/0x28) from [<000c4df8>] (jffs2_readpage+0x60/0x78)
 r5:0147abb8 r4:0081a640
[<000c4d98>] (jffs2_readpage+0x0/0x78) from [<0005d874>] (__do_page_cache_readahead+0x1f8/0x25c)
 r5:00000004 r4:0147ad2c
[<0005d67c>] (__do_page_cache_readahead+0x0/0x25c) from [<0005db50>] (ra_submit+0x2c/0x34)
[<0005db24>] (ra_submit+0x0/0x34) from [<0005de1c>] (ondemand_readahead+0x2c4/0x2e8)
[<0005db58>] (ondemand_readahead+0x0/0x2e8) from [<0005df48>] (page_cache_sync_readahead+0x60/0x68)
[<0005dee8>] (page_cache_sync_readahead+0x0/0x68) from [<000562b4>] (generic_file_aio_read+0x314/0x7b0)
 r5:00000000 r4:00000001
[<00055fa0>] (generic_file_aio_read+0x0/0x7b0) from [<0006e738>] (do_sync_read+0x88/0xd0)
[<0006e6b0>] (do_sync_read+0x0/0xd0) from [<0006f02c>] (vfs_read+0xac/0xf4)
 r7:00000080 r6:01e5a400 r5:01c35ef8 r4:01c0fc40
[<0006ef80>] (vfs_read+0x0/0xf4) from [<00073a18>] (kernel_read+0x24/0x2c)
 r7:000089ed r6:0147ac20 r5:01c34000 r4:01e5a400
[<000739f4>] (kernel_read+0x0/0x2c) from [<00073b44>] (prepare_binprm+0x124/0x134)
[<00073a20>] (prepare_binprm+0x0/0x134) from [<00074210>] (do_execve+0x250/0x528)
 r7:003599eb r6:01c34000 r5:00000000 r4:01e5a400
[<00073fc0>] (do_execve+0x0/0x528) from [<000083e4>] (try_to_run_init_process+0x20/0x4c)
[<000083c4>] (try_to_run_init_process+0x0/0x4c) from [<002c7430>] (kernel_init+0x98/0x104)
 r5:002c7398 r4:003e8300
[<002c7398>] (kernel_init+0x0/0x104) from [<00009070>] (ret_from_fork+0x14/0x24)
 r4:00000000 r3:ffffffff
BUG: scheduling while atomic: spi0/30/0x00000005
no locks held by spi0/30.
Modules linked in:
CPU: 0 PID: 30 Comm: spi0 Tainted: G        W    3.13.0-rc2-00203-g34074bc-dirty #2023
Backtrace: 
[<0000b204>] (dump_backtrace+0x0/0x108) from [<0000b398>] (show_stack+0x18/0x1c)
 r6:01e24000 r5:00000000 r4:01c8a580 r3:00208040
[<0000b380>] (show_stack+0x0/0x1c) from [<002ca888>] (dump_stack+0x20/0x28)
[<002ca868>] (dump_stack+0x0/0x28) from [<002c92bc>] (__schedule_bug+0x58/0x70)
[<002c9264>] (__schedule_bug+0x0/0x70) from [<002cc584>] (__schedule+0x58/0x398)
 r5:003cdef0 r4:01c8a580
[<002cc52c>] (__schedule+0x0/0x398) from [<002cca30>] (schedule+0x88/0x8c)
[<002cc9a8>] (schedule+0x0/0x8c) from [<00028480>] (kthread_worker_fn+0xd8/0xe4)
[<000283a8>] (kthread_worker_fn+0x0/0xe4) from [<00028648>] (kthread+0xcc/0xe0)
 r8:00000000 r7:000283a8 r6:01ce75dc r5:00000000 r4:01e1cd60
r3:01e24000
[<0002857c>] (kthread+0x0/0xe0) from [<00009070>] (ret_from_fork+0x14/0x24)
 r7:00000000 r6:00000000 r5:0002857c r4:01e1cd60
BUG: scheduling while atomic: jffs2_gcd_mtd1/38/0x00000002
3 locks held by jffs2_gcd_mtd1/38:
 #0:  (&c->alloc_sem){......}, at: [<000cdf28>] jffs2_garbage_collect_pass+0x24/0x794
 #1:  (&f->sem#2){......}, at: [<000c9eb8>] jffs2_do_crccheck_inode+0x4c/0xa0
 #2:  (&flash->lock){......}, at: [<0015cf30>] m25p80_read+0xb4/0x134
Modules linked in:
CPU: 0 PID: 38 Comm: jffs2_gcd_mtd1 Tainted: G        W    3.13.0-rc2-00203-g34074bc-dirty #2023
Backtrace: 
[<0000b204>] (dump_backtrace+0x0/0x108) from [<0000b398>] (show_stack+0x18/0x1c)
 r6:01e64000 r5:00000000 r4:01c8b480 r3:00208040
[<0000b380>] (show_stack+0x0/0x1c) from [<002ca888>] (dump_stack+0x20/0x28)
[<002ca868>] (dump_stack+0x0/0x28) from [<002c92bc>] (__schedule_bug+0x58/0x70)
[<002c9264>] (__schedule_bug+0x0/0x70) from [<002cc584>] (__schedule+0x58/0x398)
 r5:003cdef0 r4:01c8b480
[<002cc52c>] (__schedule+0x0/0x398) from [<002cca30>] (schedule+0x88/0x8c)
[<002cc9a8>] (schedule+0x0/0x8c) from [<002ccbc0>] (schedule_preempt_disabled+0x18/0x24)
[<002ccba8>] (schedule_preempt_disabled+0x0/0x24) from [<002ce170>] (mutex_lock_nested+0x1b4/0x30c)
[<002cdfbc>] (mutex_lock_nested+0x0/0x30c) from [<0015cf30>] (m25p80_read+0xb4/0x134)
 r8:00000007 r7:00000232 r6:01ce7814 r5:01e65ba0 r4:01ce7860
[<0015ce7c>] (m25p80_read+0x0/0x134) from [<0015742c>] (part_read+0x64/0xac)
[<001573c8>] (part_read+0x0/0xac) from [<001545f0>] (mtd_read+0x90/0xc8)
 r7:01e65cf4 r6:01e28400 r4:00188b54
[<00154560>] (mtd_read+0x0/0xc8) from [<000d4448>] (jffs2_flash_read+0x48/0x220)
 r9:ffffffa1 r8:01e64000 r7:00000007 r6:01e65cf4 r5:000774ac
r4:01e52800
[<000d4400>] (jffs2_flash_read+0x0/0x220) from [<000c7a24>] (check_tn_node+0x218/0x444)
[<000c780c>] (check_tn_node+0x0/0x444) from [<000c93ec>] (jffs2_do_read_inode_internal+0x169c/0x1ebc)
[<000c7d50>] (jffs2_do_read_inode_internal+0x0/0x1ebc) from [<000c9ecc>] (jffs2_do_crccheck_inode+0x60/0xa0)
[<000c9e6c>] (jffs2_do_crccheck_inode+0x0/0xa0) from [<000ce09c>] (jffs2_garbage_collect_pass+0x198/0x794)
 r6:01c5c1f8 r5:01e529d8 r4:01e52800
[<000cdf04>] (jffs2_garbage_collect_pass+0x0/0x794) from [<000cfb80>] (jffs2_garbage_collect_thread+0x138/0x170)
[<000cfa48>] (jffs2_garbage_collect_thread+0x0/0x170) from [<00028648>] (kthread+0xcc/0xe0)
[<0002857c>] (kthread+0x0/0xe0) from [<00009070>] (ret_from_fork+0x14/0x24)
 r7:00000000 r6:00000000 r5:0002857c r4:01e601e0
BUG: scheduling while atomic: swapper/1/0x00000006
3 locks held by swapper/1:
 #0:  (&sig->cred_guard_mutex){......}, at: [<00073ef8>] prepare_bprm_creds+0x30/0x6c
 #1:  (&f->sem){......}, at: [<000c4de8>] jffs2_readpage+0x50/0x78
 #2:  (&flash->lock){......}, at: [<0015cf30>] m25p80_read+0xb4/0x134
Modules linked in:
CPU: 0 PID: 1 Comm: swapper Tainted: G        W    3.13.0-rc2-00203-g34074bc-dirty #2023
Backtrace: 
[<0000b204>] (dump_backtrace+0x0/0x108) from [<0000b398>] (show_stack+0x18/0x1c)
 r6:01c34000 r5:00000000 r4:01c30000 r3:00200140
[<0000b380>] (show_stack+0x0/0x1c) from [<002ca888>] (dump_stack+0x20/0x28)
[<002ca868>] (dump_stack+0x0/0x28) from [<002c92bc>] (__schedule_bug+0x58/0x70)
[<002c9264>] (__schedule_bug+0x0/0x70) from [<002cc584>] (__schedule+0x58/0x398)
 r5:003cdef0 r4:01c30000
[<002cc52c>] (__schedule+0x0/0x398) from [<002cca30>] (schedule+0x88/0x8c)
[<002cc9a8>] (schedule+0x0/0x8c) from [<002cbf88>] (schedule_timeout+0x20/0x160)
[<002cbf68>] (schedule_timeout+0x0/0x160) from [<002cd130>] (wait_for_common+0xe0/0x178)
 r8:01c34000 r7:00000002 r6:01c359dc r5:01c359d8 r4:7fffffff
[<002cd050>] (wait_for_common+0x0/0x178) from [<002cd1e0>] (wait_for_completion+0x18/0x1c)
[<002cd1c8>] (wait_for_completion+0x0/0x1c) from [<0015d85c>] (__spi_sync+0xbc/0xe0)
[<0015d7a0>] (__spi_sync+0x0/0xe0) from [<0015d8ac>] (spi_sync+0x14/0x18)
[<0015d898>] (spi_sync+0x0/0x18) from [<0015cf78>] (m25p80_read+0xfc/0x134)
[<0015ce7c>] (m25p80_read+0x0/0x134) from [<0015742c>] (part_read+0x64/0xac)
[<001573c8>] (part_read+0x0/0xac) from [<001545f0>] (mtd_read+0x90/0xc8)
 r7:01c35c04 r6:01e28400 r4:001fe33c
[<00154560>] (mtd_read+0x0/0xc8) from [<000d4448>] (jffs2_flash_read+0x48/0x220)
 r9:019b2000 r8:01e59c10 r7:00000044 r6:01c35c04 r5:00001cc4
r4:01e52800
[<000d4400>] (jffs2_flash_read+0x0/0x220) from [<000c61e4>] (jffs2_read_dnode+0x90/0x4ec)
[<000c6154>] (jffs2_read_dnode+0x0/0x4ec) from [<000c6764>] (jffs2_read_inode_range+0x124/0x1b4)
[<000c6640>] (jffs2_read_inode_range+0x0/0x1b4) from [<000c49dc>] (jffs2_do_readpage_nolock+0x70/0x100)
[<000c496c>] (jffs2_do_readpage_nolock+0x0/0x100) from [<000c4d84>] (jffs2_do_readpage_unlock+0x14/0x28)
 r6:0081a640 r5:0147abb8 r4:0081a640
[<000c4d70>] (jffs2_do_readpage_unlock+0x0/0x28) from [<000c4df8>] (jffs2_readpage+0x60/0x78)
 r5:0147abb8 r4:0081a640
[<000c4d98>] (jffs2_readpage+0x0/0x78) from [<0005d874>] (__do_page_cache_readahead+0x1f8/0x25c)
 r5:00000004 r4:0147ad2c
[<0005d67c>] (__do_page_cache_readahead+0x0/0x25c) from [<0005db50>] (ra_submit+0x2c/0x34)
[<0005db24>] (ra_submit+0x0/0x34) from [<0005de1c>] (ondemand_readahead+0x2c4/0x2e8)
[<0005db58>] (ondemand_readahead+0x0/0x2e8) from [<0005df48>] (page_cache_sync_readahead+0x60/0x68)
[<0005dee8>] (page_cache_sync_readahead+0x0/0x68) from [<000562b4>] (generic_file_aio_read+0x314/0x7b0)
 r5:00000000 r4:00000001
[<00055fa0>] (generic_file_aio_read+0x0/0x7b0) from [<0006e738>] (do_sync_read+0x88/0xd0)
[<0006e6b0>] (do_sync_read+0x0/0xd0) from [<0006f02c>] (vfs_read+0xac/0xf4)
 r7:00000080 r6:01e5a400 r5:01c35ef8 r4:01c0fc40
[<0006ef80>] (vfs_read+0x0/0xf4) from [<00073a18>] (kernel_read+0x24/0x2c)
 r7:000089ed r6:0147ac20 r5:01c34000 r4:01e5a400
[<000739f4>] (kernel_read+0x0/0x2c) from [<00073b44>] (prepare_binprm+0x124/0x134)
[<00073a20>] (prepare_binprm+0x0/0x134) from [<00074210>] (do_execve+0x250/0x528)
 r7:003599eb r6:01c34000 r5:00000000 r4:01e5a400
[<00073fc0>] (do_execve+0x0/0x528) from [<000083e4>] (try_to_run_init_process+0x20/0x4c)
[<000083c4>] (try_to_run_init_process+0x0/0x4c) from [<002c7430>] (kernel_init+0x98/0x104)
 r5:002c7398 r4:003e8300
[<002c7398>] (kernel_init+0x0/0x104) from [<00009070>] (ret_from_fork+0x14/0x24)
 r4:00000000 r3:ffffffff
BUG: scheduling while atomic: spi0/30/0x00000009
no locks held by spi0/30.
Modules linked in:
CPU: 0 PID: 30 Comm: spi0 Tainted: G        W    3.13.0-rc2-00203-g34074bc-dirty #2023
Backtrace: 
[<0000b204>] (dump_backtrace+0x0/0x108) from [<0000b398>] (show_stack+0x18/0x1c)
 r6:01e24000 r5:00000000 r4:01c8a580 r3:00208040
[<0000b380>] (show_stack+0x0/0x1c) from [<002ca888>] (dump_stack+0x20/0x28)
[<002ca868>] (dump_stack+0x0/0x28) from [<002c92bc>] (__schedule_bug+0x58/0x70)
[<002c9264>] (__schedule_bug+0x0/0x70) from [<002cc584>] (__schedule+0x58/0x398)
 r5:003cdef0 r4:01c8a580
[<002cc52c>] (__schedule+0x0/0x398) from [<002cca30>] (schedule+0x88/0x8c)
[<002cc9a8>] (schedule+0x0/0x8c) from [<00028480>] (kthread_worker_fn+0xd8/0xe4)
[<000283a8>] (kthread_worker_fn+0x0/0xe4) from [<00028648>] (kthread+0xcc/0xe0)
 r8:00000000 r7:000283a8 r6:01ce75dc r5:00000000 r4:01e1cd60
r3:01e24000
[<0002857c>] (kthread+0x0/0xe0) from [<00009070>] (ret_from_fork+0x14/0x24)
 r7:00000000 r6:00000000 r5:0002857c r4:01e1cd60
BUG: scheduling while atomic: swapper/1/0x00000009
4 locks held by swapper/1:
 #0:  (&sig->cred_guard_mutex){......}, at: [<00073ef8>] prepare_bprm_creds+0x30/0x6c
 #1:  (&f->sem){......}, at: [<000c4de8>] jffs2_readpage+0x50/0x78
 #2:  (&flash->lock){......}, at: [<0015cf30>] m25p80_read+0xb4/0x134
 #3:  (lock){......}, at: [<0015d8e8>] spi_write_then_read+0x38/0x158
Modules linked in:
CPU: 0 PID: 1 Comm: swapper Tainted: G        W    3.13.0-rc2-00203-g34074bc-dirty #2023
Backtrace: 
[<0000b204>] (dump_backtrace+0x0/0x108) from [<0000b398>] (show_stack+0x18/0x1c)
 r6:01c34000 r5:00000000 r4:01c30000 r3:00200140
[<0000b380>] (show_stack+0x0/0x1c) from [<002ca888>] (dump_stack+0x20/0x28)
[<002ca868>] (dump_stack+0x0/0x28) from [<002c92bc>] (__schedule_bug+0x58/0x70)
[<002c9264>] (__schedule_bug+0x0/0x70) from [<002cc584>] (__schedule+0x58/0x398)
 r5:003cdef0 r4:01c30000
[<002cc52c>] (__schedule+0x0/0x398) from [<002cca30>] (schedule+0x88/0x8c)
[<002cc9a8>] (schedule+0x0/0x8c) from [<002cbf88>] (schedule_timeout+0x20/0x160)
[<002cbf68>] (schedule_timeout+0x0/0x160) from [<002cd130>] (wait_for_common+0xe0/0x178)
 r8:01c34000 r7:00000002 r6:01c358e4 r5:01c358e0 r4:7fffffff
[<002cd050>] (wait_for_common+0x0/0x178) from [<002cd1e0>] (wait_for_completion+0x18/0x1c)
[<002cd1c8>] (wait_for_completion+0x0/0x1c) from [<0015d85c>] (__spi_sync+0xbc/0xe0)
[<0015d7a0>] (__spi_sync+0x0/0xe0) from [<0015d8ac>] (spi_sync+0x14/0x18)
[<0015d898>] (spi_sync+0x0/0x18) from [<0015d9b0>] (spi_write_then_read+0x100/0x158)
[<0015d8b0>] (spi_write_then_read+0x0/0x158) from [<0015be60>] (read_sr+0x34/0x5c)
[<0015be2c>] (read_sr+0x0/0x5c) from [<0015c500>] (wait_till_ready+0x24/0x70)
 r5:ffffaf08 r4:003ccbd8
[<0015c4dc>] (wait_till_ready+0x0/0x70) from [<0015cf38>] (m25p80_read+0xbc/0x134)
 r6:01ce7814 r5:01c35ab8 r4:01ce7860 r3:80000007
[<0015ce7c>] (m25p80_read+0x0/0x134) from [<0015742c>] (part_read+0x64/0xac)
[<001573c8>] (part_read+0x0/0xac) from [<001545f0>] (mtd_read+0x90/0xc8)
 r7:01c35c04 r6:01e28400 r4:001fe2f8
[<00154560>] (mtd_read+0x0/0xc8) from [<000d4448>] (jffs2_flash_read+0x48/0x220)
 r9:019b2000 r8:01e59c10 r7:000009a0 r6:01c35c04 r5:00000000
r4:01e52800
[<000d4400>] (jffs2_flash_read+0x0/0x220) from [<000c6444>] (jffs2_read_dnode+0x2f0/0x4ec)
[<000c6154>] (jffs2_read_dnode+0x0/0x4ec) from [<000c6764>] (jffs2_read_inode_range+0x124/0x1b4)
[<000c6640>] (jffs2_read_inode_range+0x0/0x1b4) from [<000c49dc>] (jffs2_do_readpage_nolock+0x70/0x100)
[<000c496c>] (jffs2_do_readpage_nolock+0x0/0x100) from [<000c4d84>] (jffs2_do_readpage_unlock+0x14/0x28)
 r6:0081a640 r5:0147abb8 r4:0081a640
[<000c4d70>] (jffs2_do_readpage_unlock+0x0/0x28) from [<000c4df8>] (jffs2_readpage+0x60/0x78)
 r5:0147abb8 r4:0081a640
[<000c4d98>] (jffs2_readpage+0x0/0x78) from [<0005d874>] (__do_page_cache_readahead+0x1f8/0x25c)
 r5:00000004 r4:0147ad2c
[<0005d67c>] (__do_page_cache_readahead+0x0/0x25c) from [<0005db50>] (ra_submit+0x2c/0x34)
[<0005db24>] (ra_submit+0x0/0x34) from [<0005de1c>] (ondemand_readahead+0x2c4/0x2e8)
[<0005db58>] (ondemand_readahead+0x0/0x2e8) from [<0005df48>] (page_cache_sync_readahead+0x60/0x68)
[<0005dee8>] (page_cache_sync_readahead+0x0/0x68) from [<000562b4>] (generic_file_aio_read+0x314/0x7b0)
 r5:00000000 r4:00000001
[<00055fa0>] (generic_file_aio_read+0x0/0x7b0) from [<0006e738>] (do_sync_read+0x88/0xd0)
[<0006e6b0>] (do_sync_read+0x0/0xd0) from [<0006f02c>] (vfs_read+0xac/0xf4)
 r7:00000080 r6:01e5a400 r5:01c35ef8 r4:01c0fc40
[<0006ef80>] (vfs_read+0x0/0xf4) from [<00073a18>] (kernel_read+0x24/0x2c)
 r7:000089ed r6:0147ac20 r5:01c34000 r4:01e5a400
[<000739f4>] (kernel_read+0x0/0x2c) from [<00073b44>] (prepare_binprm+0x124/0x134)
[<00073a20>] (prepare_binprm+0x0/0x134) from [<00074210>] (do_execve+0x250/0x528)
 r7:003599eb r6:01c34000 r5:00000000 r4:01e5a400
[<00073fc0>] (do_execve+0x0/0x528) from [<000083e4>] (try_to_run_init_process+0x20/0x4c)
[<000083c4>] (try_to_run_init_process+0x0/0x4c) from [<002c7430>] (kernel_init+0x98/0x104)
 r5:002c7398 r4:003e8300
[<002c7398>] (kernel_init+0x0/0x104) from [<00009070>] (ret_from_fork+0x14/0x24)
 r4:00000000 r3:ffffffff
BUG: scheduling while atomic: spi0/30/0x0000000d
no locks held by spi0/30.
Modules linked in:
CPU: 0 PID: 30 Comm: spi0 Tainted: G        W    3.13.0-rc2-00203-g34074bc-dirty #2023
Backtrace: 
[<0000b204>] (dump_backtrace+0x0/0x108) from [<0000b398>] (show_stack+0x18/0x1c)
 r6:01e24000 r5:00000000 r4:01c8a580 r3:00208040
[<0000b380>] (show_stack+0x0/0x1c) from [<002ca888>] (dump_stack+0x20/0x28)
[<002ca868>] (dump_stack+0x0/0x28) from [<002c92bc>] (__schedule_bug+0x58/0x70)
[<002c9264>] (__schedule_bug+0x0/0x70) from [<002cc584>] (__schedule+0x58/0x398)
 r5:003cdef0 r4:01c8a580
[<002cc52c>] (__schedule+0x0/0x398) from [<002cca30>] (schedule+0x88/0x8c)
[<002cc9a8>] (schedule+0x0/0x8c) from [<00028480>] (kthread_worker_fn+0xd8/0xe4)
[<000283a8>] (kthread_worker_fn+0x0/0xe4) from [<00028648>] (kthread+0xcc/0xe0)
 r8:00000000 r7:000283a8 r6:01ce75dc r5:00000000 r4:01e1cd60
r3:01e24000
[<0002857c>] (kthread+0x0/0xe0) from [<00009070>] (ret_from_fork+0x14/0x24)
 r7:00000000 r6:00000000 r5:0002857c r4:01e1cd60
BUG: scheduling while atomic: swapper/1/0x0000000c
3 locks held by swapper/1:
 #0:  (&sig->cred_guard_mutex){......}, at: [<00073ef8>] prepare_bprm_creds+0x30/0x6c
 #1:  (&f->sem){......}, at: [<000c4de8>] jffs2_readpage+0x50/0x78
 #2:  (&flash->lock){......}, at: [<0015cf30>] m25p80_read+0xb4/0x134
Modules linked in:
CPU: 0 PID: 1 Comm: swapper Tainted: G        W    3.13.0-rc2-00203-g34074bc-dirty #2023
Backtrace: 
[<0000b204>] (dump_backtrace+0x0/0x108) from [<0000b398>] (show_stack+0x18/0x1c)
 r6:01c34000 r5:00000000 r4:01c30000 r3:00200140
[<0000b380>] (show_stack+0x0/0x1c) from [<002ca888>] (dump_stack+0x20/0x28)
[<002ca868>] (dump_stack+0x0/0x28) from [<002c92bc>] (__schedule_bug+0x58/0x70)
[<002c9264>] (__schedule_bug+0x0/0x70) from [<002cc584>] (__schedule+0x58/0x398)
 r5:003cdef0 r4:01c30000
[<002cc52c>] (__schedule+0x0/0x398) from [<002cca30>] (schedule+0x88/0x8c)
[<002cc9a8>] (schedule+0x0/0x8c) from [<002cbf88>] (schedule_timeout+0x20/0x160)
[<002cbf68>] (schedule_timeout+0x0/0x160) from [<002cd130>] (wait_for_common+0xe0/0x178)
 r8:01c34000 r7:00000002 r6:01c359dc r5:01c359d8 r4:7fffffff
[<002cd050>] (wait_for_common+0x0/0x178) from [<002cd1e0>] (wait_for_completion+0x18/0x1c)
[<002cd1c8>] (wait_for_completion+0x0/0x1c) from [<0015d85c>] (__spi_sync+0xbc/0xe0)
[<0015d7a0>] (__spi_sync+0x0/0xe0) from [<0015d8ac>] (spi_sync+0x14/0x18)
[<0015d898>] (spi_sync+0x0/0x18) from [<0015cf78>] (m25p80_read+0xfc/0x134)
[<0015ce7c>] (m25p80_read+0x0/0x134) from [<0015742c>] (part_read+0x64/0xac)
[<001573c8>] (part_read+0x0/0xac) from [<001545f0>] (mtd_read+0x90/0xc8)
 r7:01c35c04 r6:01e28400 r4:001fe2f8
[<00154560>] (mtd_read+0x0/0xc8) from [<000d4448>] (jffs2_flash_read+0x48/0x220)
 r9:019b2000 r8:01e59c10 r7:000009a0 r6:01c35c04 r5:00000000
r4:01e52800
[<000d4400>] (jffs2_flash_read+0x0/0x220) from [<000c6444>] (jffs2_read_dnode+0x2f0/0x4ec)
[<000c6154>] (jffs2_read_dnode+0x0/0x4ec) from [<000c6764>] (jffs2_read_inode_range+0x124/0x1b4)
[<000c6640>] (jffs2_read_inode_range+0x0/0x1b4) from [<000c49dc>] (jffs2_do_readpage_nolock+0x70/0x100)
[<000c496c>] (jffs2_do_readpage_nolock+0x0/0x100) from [<000c4d84>] (jffs2_do_readpage_unlock+0x14/0x28)
 r6:0081a640 r5:0147abb8 r4:0081a640
[<000c4d70>] (jffs2_do_readpage_unlock+0x0/0x28) from [<000c4df8>] (jffs2_readpage+0x60/0x78)
 r5:0147abb8 r4:0081a640
[<000c4d98>] (jffs2_readpage+0x0/0x78) from [<0005d874>] (__do_page_cache_readahead+0x1f8/0x25c)
 r5:00000004 r4:0147ad2c
[<0005d67c>] (__do_page_cache_readahead+0x0/0x25c) from [<0005db50>] (ra_submit+0x2c/0x34)
[<0005db24>] (ra_submit+0x0/0x34) from [<0005de1c>] (ondemand_readahead+0x2c4/0x2e8)
[<0005db58>] (ondemand_readahead+0x0/0x2e8) from [<0005df48>] (page_cache_sync_readahead+0x60/0x68)
[<0005dee8>] (page_cache_sync_readahead+0x0/0x68) from [<000562b4>] (generic_file_aio_read+0x314/0x7b0)
 r5:00000000 r4:00000001
[<00055fa0>] (generic_file_aio_read+0x0/0x7b0) from [<0006e738>] (do_sync_read+0x88/0xd0)
[<0006e6b0>] (do_sync_read+0x0/0xd0) from [<0006f02c>] (vfs_read+0xac/0xf4)
 r7:00000080 r6:01e5a400 r5:01c35ef8 r4:01c0fc40
[<0006ef80>] (vfs_read+0x0/0xf4) from [<00073a18>] (kernel_read+0x24/0x2c)
 r7:000089ed r6:0147ac20 r5:01c34000 r4:01e5a400
[<000739f4>] (kernel_read+0x0/0x2c) from [<00073b44>] (prepare_binprm+0x124/0x134)
[<00073a20>] (prepare_binprm+0x0/0x134) from [<00074210>] (do_execve+0x250/0x528)
 r7:003599eb r6:01c34000 r5:00000000 r4:01e5a400
[<00073fc0>] (do_execve+0x0/0x528) from [<000083e4>] (try_to_run_init_process+0x20/0x4c)
[<000083c4>] (try_to_run_init_process+0x0/0x4c) from [<002c7430>] (kernel_init+0x98/0x104)
 r5:002c7398 r4:003e8300
[<002c7398>] (kernel_init+0x0/0x104) from [<00009070>] (ret_from_fork+0x14/0x24)
 r4:00000000 r3:ffffffff
BUG: scheduling while atomic: jffs2_gcd_mtd1/38/0x00000003
3 locks held by jffs2_gcd_mtd1/38:
 #0:  (&c->alloc_sem){......}, at: [<000cdf28>] jffs2_garbage_collect_pass+0x24/0x794
 #1:  (&f->sem#2){......}, at: [<000c9eb8>] jffs2_do_crccheck_inode+0x4c/0xa0
 #2:  (&flash->lock){......}, at: [<0015cf30>] m25p80_read+0xb4/0x134
Modules linked in:
CPU: 0 PID: 38 Comm: jffs2_gcd_mtd1 Tainted: G        W    3.13.0-rc2-00203-g34074bc-dirty #2023
Backtrace: 
[<0000b204>] (dump_backtrace+0x0/0x108) from [<0000b398>] (show_stack+0x18/0x1c)
 r6:01e64000 r5:00000000 r4:01c8b480 r3:00208040
[<0000b380>] (show_stack+0x0/0x1c) from [<002ca888>] (dump_stack+0x20/0x28)
[<002ca868>] (dump_stack+0x0/0x28) from [<002c92bc>] (__schedule_bug+0x58/0x70)
[<002c9264>] (__schedule_bug+0x0/0x70) from [<002cc584>] (__schedule+0x58/0x398)
 r5:003cdef0 r4:01c8b480
[<002cc52c>] (__schedule+0x0/0x398) from [<002cca30>] (schedule+0x88/0x8c)
[<002cc9a8>] (schedule+0x0/0x8c) from [<002ccbc0>] (schedule_preempt_disabled+0x18/0x24)
[<002ccba8>] (schedule_preempt_disabled+0x0/0x24) from [<002ce170>] (mutex_lock_nested+0x1b4/0x30c)
[<002cdfbc>] (mutex_lock_nested+0x0/0x30c) from [<0015cf30>] (m25p80_read+0xb4/0x134)
 r8:00000007 r7:00000232 r6:01ce7814 r5:01e65ba0 r4:01ce7860
[<0015ce7c>] (m25p80_read+0x0/0x134) from [<0015742c>] (part_read+0x64/0xac)
[<001573c8>] (part_read+0x0/0xac) from [<001545f0>] (mtd_read+0x90/0xc8)
 r7:01e65cf4 r6:01e28400 r4:00188b54
[<00154560>] (mtd_read+0x0/0xc8) from [<000d4448>] (jffs2_flash_read+0x48/0x220)
 r9:ffffffa1 r8:01e64000 r7:00000007 r6:01e65cf4 r5:000774ac
r4:01e52800
[<000d4400>] (jffs2_flash_read+0x0/0x220) from [<000c7a24>] (check_tn_node+0x218/0x444)
[<000c780c>] (check_tn_node+0x0/0x444) from [<000c93ec>] (jffs2_do_read_inode_internal+0x169c/0x1ebc)
[<000c7d50>] (jffs2_do_read_inode_internal+0x0/0x1ebc) from [<000c9ecc>] (jffs2_do_crccheck_inode+0x60/0xa0)
[<000c9e6c>] (jffs2_do_crccheck_inode+0x0/0xa0) from [<000ce09c>] (jffs2_garbage_collect_pass+0x198/0x794)
 r6:01c5c1f8 r5:01e529d8 r4:01e52800
[<000cdf04>] (jffs2_garbage_collect_pass+0x0/0x794) from [<000cfb80>] (jffs2_garbage_collect_thread+0x138/0x170)
[<000cfa48>] (jffs2_garbage_collect_thread+0x0/0x170) from [<00028648>] (kthread+0xcc/0xe0)
[<0002857c>] (kthread+0x0/0xe0) from [<00009070>] (ret_from_fork+0x14/0x24)
 r7:00000000 r6:00000000 r5:0002857c r4:01e601e0
BUG: scheduling while atomic: spi0/30/0x00000011
no locks held by spi0/30.
Modules linked in:
CPU: 0 PID: 30 Comm: spi0 Tainted: G        W    3.13.0-rc2-00203-g34074bc-dirty #2023
Backtrace: 
[<0000b204>] (dump_backtrace+0x0/0x108) from [<0000b398>] (show_stack+0x18/0x1c)
 r6:01e24000 r5:00000000 r4:01c8a580 r3:00208040
[<0000b380>] (show_stack+0x0/0x1c) from [<002ca888>] (dump_stack+0x20/0x28)
[<002ca868>] (dump_stack+0x0/0x28) from [<002c92bc>] (__schedule_bug+0x58/0x70)
[<002c9264>] (__schedule_bug+0x0/0x70) from [<002cc584>] (__schedule+0x58/0x398)
 r5:003cdef0 r4:01c8a580
[<002cc52c>] (__schedule+0x0/0x398) from [<002cca30>] (schedule+0x88/0x8c)
[<002cc9a8>] (schedule+0x0/0x8c) from [<00028480>] (kthread_worker_fn+0xd8/0xe4)
[<000283a8>] (kthread_worker_fn+0x0/0xe4) from [<00028648>] (kthread+0xcc/0xe0)
 r8:00000000 r7:000283a8 r6:01ce75dc r5:00000000 r4:01e1cd60
r3:01e24000
[<0002857c>] (kthread+0x0/0xe0) from [<00009070>] (ret_from_fork+0x14/0x24)
 r7:00000000 r6:00000000 r5:0002857c r4:01e1cd60
467: 13
470: 13
475: 14
485: 14
487: 15
489: 15
491: 14
494: 14
496: 14
498: 14
500: 14
502: 14
BUG: scheduling while atomic: swapper/1/0x00000010
4 locks held by swapper/1:
 #0:  (&sig->cred_guard_mutex){......}, at: [<00073ef8>] prepare_bprm_creds+0x30/0x6c
 #1:  (&f->sem){......}, at: [<000c4de8>] jffs2_readpage+0x50/0x78
 #2:  (&flash->lock){......}, at: [<0015cf30>] m25p80_read+0xb4/0x134
 #3:  (lock){......}, at: [<0015d8e8>] spi_write_then_read+0x38/0x158
Modules linked in:
CPU: 0 PID: 1 Comm: swapper Tainted: G        W    3.13.0-rc2-00203-g34074bc-dirty #2023
Backtrace: 
[<0000b204>] (dump_backtrace+0x0/0x108) from [<0000b398>] (show_stack+0x18/0x1c)
 r6:01c34000 r5:00000000 r4:01c30000 r3:00200140
[<0000b380>] (show_stack+0x0/0x1c) from [<002ca888>] (dump_stack+0x20/0x28)
[<002ca868>] (dump_stack+0x0/0x28) from [<002c92bc>] (__schedule_bug+0x58/0x70)
[<002c9264>] (__schedule_bug+0x0/0x70) from [<002cc584>] (__schedule+0x58/0x398)
 r5:003cdef0 r4:01c30000
[<002cc52c>] (__schedule+0x0/0x398) from [<002cca30>] (schedule+0x88/0x8c)
[<002cc9a8>] (schedule+0x0/0x8c) from [<002cbf88>] (schedule_timeout+0x20/0x160)
[<002cbf68>] (schedule_timeout+0x0/0x160) from [<002cd130>] (wait_for_common+0xe0/0x178)
 r8:01c34000 r7:00000002 r6:01c358e4 r5:01c358e0 r4:7fffffff
[<002cd050>] (wait_for_common+0x0/0x178) from [<002cd1e0>] (wait_for_completion+0x18/0x1c)
[<002cd1c8>] (wait_for_completion+0x0/0x1c) from [<0015d85c>] (__spi_sync+0xbc/0xe0)
[<0015d7a0>] (__spi_sync+0x0/0xe0) from [<0015d8ac>] (spi_sync+0x14/0x18)
[<0015d898>] (spi_sync+0x0/0x18) from [<0015d9b0>] (spi_write_then_read+0x100/0x158)
[<0015d8b0>] (spi_write_then_read+0x0/0x158) from [<0015be60>] (read_sr+0x34/0x5c)
[<0015be2c>] (read_sr+0x0/0x5c) from [<0015c500>] (wait_till_ready+0x24/0x70)
 r5:ffffaf08 r4:003ccbd8
[<0015c4dc>] (wait_till_ready+0x0/0x70) from [<0015cf38>] (m25p80_read+0xbc/0x134)
 r6:01ce7814 r5:01c35ab8 r4:01ce7860 r3:8000000e
[<0015ce7c>] (m25p80_read+0x0/0x134) from [<0015742c>] (part_read+0x64/0xac)
[<001573c8>] (part_read+0x0/0xac) from [<001545f0>] (mtd_read+0x90/0xc8)
 r7:01c35c04 r6:01e28400 r4:001fd958
[<00154560>] (mtd_read+0x0/0xc8) from [<000d4448>] (jffs2_flash_read+0x48/0x220)
 r9:003be000 r8:01e59c00 r7:00000044 r6:01c35c04 r5:000026a8
r4:01e52800
[<000d4400>] (jffs2_flash_read+0x0/0x220) from [<000c61e4>] (jffs2_read_dnode+0x90/0x4ec)
[<000c6154>] (jffs2_read_dnode+0x0/0x4ec) from [<000c6764>] (jffs2_read_inode_range+0x124/0x1b4)
[<000c6640>] (jffs2_read_inode_range+0x0/0x1b4) from [<000c49dc>] (jffs2_do_readpage_nolock+0x70/0x100)
[<000c496c>] (jffs2_do_readpage_nolock+0x0/0x100) from [<000c4d84>] (jffs2_do_readpage_unlock+0x14/0x28)
 r6:007ee7c0 r5:0147abb8 r4:007ee7c0
[<000c4d70>] (jffs2_do_readpage_unlock+0x0/0x28) from [<000c4df8>] (jffs2_readpage+0x60/0x78)
 r5:0147abb8 r4:007ee7c0
[<000c4d98>] (jffs2_readpage+0x0/0x78) from [<0005d874>] (__do_page_cache_readahead+0x1f8/0x25c)
 r5:00000004 r4:0147ad2c
[<0005d67c>] (__do_page_cache_readahead+0x0/0x25c) from [<0005db50>] (ra_submit+0x2c/0x34)
[<0005db24>] (ra_submit+0x0/0x34) from [<0005de1c>] (ondemand_readahead+0x2c4/0x2e8)
[<0005db58>] (ondemand_readahead+0x0/0x2e8) from [<0005df48>] (page_cache_sync_readahead+0x60/0x68)
[<0005dee8>] (page_cache_sync_readahead+0x0/0x68) from [<000562b4>] (generic_file_aio_read+0x314/0x7b0)
 r5:00000000 r4:00000001
[<00055fa0>] (generic_file_aio_read+0x0/0x7b0) from [<0006e738>] (do_sync_read+0x88/0xd0)
[<0006e6b0>] (do_sync_read+0x0/0xd0) from [<0006f02c>] (vfs_read+0xac/0xf4)
 r7:00000080 r6:01e5a400 r5:01c35ef8 r4:01c0fc40
[<0006ef80>] (vfs_read+0x0/0xf4) from [<00073a18>] (kernel_read+0x24/0x2c)
 r7:000089ed r6:0147ac20 r5:01c34000 r4:01e5a400
[<000739f4>] (kernel_read+0x0/0x2c) from [<00073b44>] (prepare_binprm+0x124/0x134)
[<00073a20>] (prepare_binprm+0x0/0x134) from [<00074210>] (do_execve+0x250/0x528)
 r7:003599eb r6:01c34000 r5:00000000 r4:01e5a400
[<00073fc0>] (do_execve+0x0/0x528) from [<000083e4>] (try_to_run_init_process+0x20/0x4c)
[<000083c4>] (try_to_run_init_process+0x0/0x4c) from [<002c7430>] (kernel_init+0x98/0x104)
 r5:002c7398 r4:003e8300
[<002c7398>] (kernel_init+0x0/0x104) from [<00009070>] (ret_from_fork+0x14/0x24)
 r4:00000000 r3:ffffffff
BUG: scheduling while atomic: spi0/30/0x00000015
no locks held by spi0/30.
Modules linked in:
CPU: 0 PID: 30 Comm: spi0 Tainted: G        W    3.13.0-rc2-00203-g34074bc-dirty #2023
Backtrace: 
[<0000b204>] (dump_backtrace+0x0/0x108) from [<0000b398>] (show_stack+0x18/0x1c)
 r6:01e24000 r5:00000000 r4:01c8a580 r3:00208040
[<0000b380>] (show_stack+0x0/0x1c) from [<002ca888>] (dump_stack+0x20/0x28)
[<002ca868>] (dump_stack+0x0/0x28) from [<002c92bc>] (__schedule_bug+0x58/0x70)
[<002c9264>] (__schedule_bug+0x0/0x70) from [<002cc584>] (__schedule+0x58/0x398)
 r5:003cdef0 r4:01c8a580
[<002cc52c>] (__schedule+0x0/0x398) from [<002cca30>] (schedule+0x88/0x8c)
[<002cc9a8>] (schedule+0x0/0x8c) from [<00028480>] (kthread_worker_fn+0xd8/0xe4)
[<000283a8>] (kthread_worker_fn+0x0/0xe4) from [<00028648>] (kthread+0xcc/0xe0)
 r8:00000000 r7:000283a8 r6:01ce75dc r5:00000000 r4:01e1cd60
r3:01e24000
[<0002857c>] (kthread+0x0/0xe0) from [<00009070>] (ret_from_fork+0x14/0x24)
 r7:00000000 r6:00000000 r5:0002857c r4:01e1cd60
BUG: scheduling while atomic: jffs2_gcd_mtd1/38/0x00000004
3 locks held by jffs2_gcd_mtd1/38:
 #0:  (&c->alloc_sem){......}, at: [<000cdf28>] jffs2_garbage_collect_pass+0x24/0x794
 #1:  (&f->sem#2){......}, at: [<000c9eb8>] jffs2_do_crccheck_inode+0x4c/0xa0
 #2:  (&flash->lock){......}, at: [<0015cf30>] m25p80_read+0xb4/0x134
Modules linked in:
CPU: 0 PID: 38 Comm: jffs2_gcd_mtd1 Tainted: G        W    3.13.0-rc2-00203-g34074bc-dirty #2023
Backtrace: 
[<0000b204>] (dump_backtrace+0x0/0x108) from [<0000b398>] (show_stack+0x18/0x1c)
 r6:01e64000 r5:00000000 r4:01c8b480 r3:00208040
[<0000b380>] (show_stack+0x0/0x1c) from [<002ca888>] (dump_stack+0x20/0x28)
[<002ca868>] (dump_stack+0x0/0x28) from [<002c92bc>] (__schedule_bug+0x58/0x70)
[<002c9264>] (__schedule_bug+0x0/0x70) from [<002cc584>] (__schedule+0x58/0x398)
 r5:003cdef0 r4:01c8b480
[<002cc52c>] (__schedule+0x0/0x398) from [<002cca30>] (schedule+0x88/0x8c)
[<002cc9a8>] (schedule+0x0/0x8c) from [<002ccbc0>] (schedule_preempt_disabled+0x18/0x24)
[<002ccba8>] (schedule_preempt_disabled+0x0/0x24) from [<002ce170>] (mutex_lock_nested+0x1b4/0x30c)
[<002cdfbc>] (mutex_lock_nested+0x0/0x30c) from [<0015cf30>] (m25p80_read+0xb4/0x134)
 r8:00000007 r7:00000232 r6:01ce7814 r5:01e65ba0 r4:01ce7860
[<0015ce7c>] (m25p80_read+0x0/0x134) from [<0015742c>] (part_read+0x64/0xac)
[<001573c8>] (part_read+0x0/0xac) from [<001545f0>] (mtd_read+0x90/0xc8)
 r7:01e65cf4 r6:01e28400 r4:00188b54
[<00154560>] (mtd_read+0x0/0xc8) from [<000d4448>] (jffs2_flash_read+0x48/0x220)
 r9:ffffffa1 r8:01e64000 r7:00000007 r6:01e65cf4 r5:000774ac
r4:01e52800
[<000d4400>] (jffs2_flash_read+0x0/0x220) from [<000c7a24>] (check_tn_node+0x218/0x444)
[<000c780c>] (check_tn_node+0x0/0x444) from [<000c93ec>] (jffs2_do_read_inode_internal+0x169c/0x1ebc)
[<000c7d50>] (jffs2_do_read_inode_internal+0x0/0x1ebc) from [<000c9ecc>] (jffs2_do_crccheck_inode+0x60/0xa0)
[<000c9e6c>] (jffs2_do_crccheck_inode+0x0/0xa0) from [<000ce09c>] (jffs2_garbage_collect_pass+0x198/0x794)
 r6:01c5c1f8 r5:01e529d8 r4:01e52800
[<000cdf04>] (jffs2_garbage_collect_pass+0x0/0x794) from [<000cfb80>] (jffs2_garbage_collect_thread+0x138/0x170)
[<000cfa48>] (jffs2_garbage_collect_thread+0x0/0x170) from [<00028648>] (kthread+0xcc/0xe0)
[<0002857c>] (kthread+0x0/0xe0) from [<00009070>] (ret_from_fork+0x14/0x24)
 r7:00000000 r6:00000000 r5:0002857c r4:01e601e0
BUG: scheduling while atomic: swapper/1/0x00000013
3 locks held by swapper/1:
 #0:  (&sig->cred_guard_mutex){......}, at: [<00073ef8>] prepare_bprm_creds+0x30/0x6c
 #1:  (&f->sem){......}, at: [<000c4de8>] jffs2_readpage+0x50/0x78
 #2:  (&flash->lock){......}, at: [<0015cf30>] m25p80_read+0xb4/0x134
Modules linked in:
CPU: 0 PID: 1 Comm: swapper Tainted: G        W    3.13.0-rc2-00203-g34074bc-dirty #2023
Backtrace: 
[<0000b204>] (dump_backtrace+0x0/0x108) from [<0000b398>] (show_stack+0x18/0x1c)
 r6:01c34000 r5:00000000 r4:01c30000 r3:00200140
[<0000b380>] (show_stack+0x0/0x1c) from [<002ca888>] (dump_stack+0x20/0x28)
[<002ca868>] (dump_stack+0x0/0x28) from [<002c92bc>] (__schedule_bug+0x58/0x70)
[<002c9264>] (__schedule_bug+0x0/0x70) from [<002cc584>] (__schedule+0x58/0x398)
 r5:003cdef0 r4:01c30000
[<002cc52c>] (__schedule+0x0/0x398) from [<002cca30>] (schedule+0x88/0x8c)
[<002cc9a8>] (schedule+0x0/0x8c) from [<002cbf88>] (schedule_timeout+0x20/0x160)
[<002cbf68>] (schedule_timeout+0x0/0x160) from [<002cd130>] (wait_for_common+0xe0/0x178)
 r8:01c34000 r7:00000002 r6:01c359dc r5:01c359d8 r4:7fffffff
[<002cd050>] (wait_for_common+0x0/0x178) from [<002cd1e0>] (wait_for_completion+0x18/0x1c)
[<002cd1c8>] (wait_for_completion+0x0/0x1c) from [<0015d85c>] (__spi_sync+0xbc/0xe0)
[<0015d7a0>] (__spi_sync+0x0/0xe0) from [<0015d8ac>] (spi_sync+0x14/0x18)
[<0015d898>] (spi_sync+0x0/0x18) from [<0015cf78>] (m25p80_read+0xfc/0x134)
[<0015ce7c>] (m25p80_read+0x0/0x134) from [<0015742c>] (part_read+0x64/0xac)
[<001573c8>] (part_read+0x0/0xac) from [<001545f0>] (mtd_read+0x90/0xc8)
 r7:01c35c04 r6:01e28400 r4:001fd958
[<00154560>] (mtd_read+0x0/0xc8) from [<000d4448>] (jffs2_flash_read+0x48/0x220)
 r9:003be000 r8:01e59c00 r7:00000044 r6:01c35c04 r5:000026a8
r4:01e52800
[<000d4400>] (jffs2_flash_read+0x0/0x220) from [<000c61e4>] (jffs2_read_dnode+0x90/0x4ec)
[<000c6154>] (jffs2_read_dnode+0x0/0x4ec) from [<000c6764>] (jffs2_read_inode_range+0x124/0x1b4)
[<000c6640>] (jffs2_read_inode_range+0x0/0x1b4) from [<000c49dc>] (jffs2_do_readpage_nolock+0x70/0x100)
[<000c496c>] (jffs2_do_readpage_nolock+0x0/0x100) from [<000c4d84>] (jffs2_do_readpage_unlock+0x14/0x28)
 r6:007ee7c0 r5:0147abb8 r4:007ee7c0
[<000c4d70>] (jffs2_do_readpage_unlock+0x0/0x28) from [<000c4df8>] (jffs2_readpage+0x60/0x78)
 r5:0147abb8 r4:007ee7c0
[<000c4d98>] (jffs2_readpage+0x0/0x78) from [<0005d874>] (__do_page_cache_readahead+0x1f8/0x25c)
 r5:00000004 r4:0147ad2c
[<0005d67c>] (__do_page_cache_readahead+0x0/0x25c) from [<0005db50>] (ra_submit+0x2c/0x34)
[<0005db24>] (ra_submit+0x0/0x34) from [<0005de1c>] (ondemand_readahead+0x2c4/0x2e8)
[<0005db58>] (ondemand_readahead+0x0/0x2e8) from [<0005df48>] (page_cache_sync_readahead+0x60/0x68)
[<0005dee8>] (page_cache_sync_readahead+0x0/0x68) from [<000562b4>] (generic_file_aio_read+0x314/0x7b0)
 r5:00000000 r4:00000001
[<00055fa0>] (generic_file_aio_read+0x0/0x7b0) from [<0006e738>] (do_sync_read+0x88/0xd0)
[<0006e6b0>] (do_sync_read+0x0/0xd0) from [<0006f02c>] (vfs_read+0xac/0xf4)
 r7:00000080 r6:01e5a400 r5:01c35ef8 r4:01c0fc40
[<0006ef80>] (vfs_read+0x0/0xf4) from [<00073a18>] (kernel_read+0x24/0x2c)
 r7:000089ed r6:0147ac20 r5:01c34000 r4:01e5a400
[<000739f4>] (kernel_read+0x0/0x2c) from [<00073b44>] (prepare_binprm+0x124/0x134)
[<00073a20>] (prepare_binprm+0x0/0x134) from [<00074210>] (do_execve+0x250/0x528)
 r7:003599eb r6:01c34000 r5:00000000 r4:01e5a400
[<00073fc0>] (do_execve+0x0/0x528) from [<000083e4>] (try_to_run_init_process+0x20/0x4c)
[<000083c4>] (try_to_run_init_process+0x0/0x4c) from [<002c7430>] (kernel_init+0x98/0x104)
 r5:002c7398 r4:003e8300
[<002c7398>] (kernel_init+0x0/0x104) from [<00009070>] (ret_from_fork+0x14/0x24)
 r4:00000000 r3:ffffffff
BUG: scheduling while atomic: spi0/30/0x00000019
no locks held by spi0/30.
Modules linked in:
CPU: 0 PID: 30 Comm: spi0 Tainted: G        W    3.13.0-rc2-00203-g34074bc-dirty #2023
Backtrace: 
[<0000b204>] (dump_backtrace+0x0/0x108) from [<0000b398>] (show_stack+0x18/0x1c)
 r6:01e24000 r5:00000000 r4:01c8a580 r3:00208040
[<0000b380>] (show_stack+0x0/0x1c) from [<002ca888>] (dump_stack+0x20/0x28)
[<002ca868>] (dump_stack+0x0/0x28) from [<002c92bc>] (__schedule_bug+0x58/0x70)
[<002c9264>] (__schedule_bug+0x0/0x70) from [<002cc584>] (__schedule+0x58/0x398)
 r5:003cdef0 r4:01c8a580
[<002cc52c>] (__schedule+0x0/0x398) from [<002cca30>] (schedule+0x88/0x8c)
[<002cc9a8>] (schedule+0x0/0x8c) from [<00028480>] (kthread_worker_fn+0xd8/0xe4)
[<000283a8>] (kthread_worker_fn+0x0/0xe4) from [<00028648>] (kthread+0xcc/0xe0)
 r8:00000000 r7:000283a8 r6:01ce75dc r5:00000000 r4:01e1cd60
r3:01e24000
[<0002857c>] (kthread+0x0/0xe0) from [<00009070>] (ret_from_fork+0x14/0x24)
 r7:00000000 r6:00000000 r5:0002857c r4:01e1cd60
BUG: scheduling while atomic: swapper/1/0x00000016
4 locks held by swapper/1:
 #0:  (&sig->cred_guard_mutex){......}, at: [<00073ef8>] prepare_bprm_creds+0x30/0x6c
 #1:  (&f->sem){......}, at: [<000c4de8>] jffs2_readpage+0x50/0x78
 #2:  (&flash->lock){......}, at: [<0015cf30>] m25p80_read+0xb4/0x134
 #3:  (lock){......}, at: [<0015d8e8>] spi_write_then_read+0x38/0x158
Modules linked in:
CPU: 0 PID: 1 Comm: swapper Tainted: G        W    3.13.0-rc2-00203-g34074bc-dirty #2023
Backtrace: 
[<0000b204>] (dump_backtrace+0x0/0x108) from [<0000b398>] (show_stack+0x18/0x1c)
 r6:01c34000 r5:00000000 r4:01c30000 r3:00200140
[<0000b380>] (show_stack+0x0/0x1c) from [<002ca888>] (dump_stack+0x20/0x28)
[<002ca868>] (dump_stack+0x0/0x28) from [<002c92bc>] (__schedule_bug+0x58/0x70)
[<002c9264>] (__schedule_bug+0x0/0x70) from [<002cc584>] (__schedule+0x58/0x398)
 r5:003cdef0 r4:01c30000
[<002cc52c>] (__schedule+0x0/0x398) from [<002cca30>] (schedule+0x88/0x8c)
[<002cc9a8>] (schedule+0x0/0x8c) from [<002cbf88>] (schedule_timeout+0x20/0x160)
[<002cbf68>] (schedule_timeout+0x0/0x160) from [<002cd130>] (wait_for_common+0xe0/0x178)
 r8:01c34000 r7:00000002 r6:01c358e4 r5:01c358e0 r4:7fffffff
[<002cd050>] (wait_for_common+0x0/0x178) from [<002cd1e0>] (wait_for_completion+0x18/0x1c)
[<002cd1c8>] (wait_for_completion+0x0/0x1c) from [<0015d85c>] (__spi_sync+0xbc/0xe0)
[<0015d7a0>] (__spi_sync+0x0/0xe0) from [<0015d8ac>] (spi_sync+0x14/0x18)
[<0015d898>] (spi_sync+0x0/0x18) from [<0015d9b0>] (spi_write_then_read+0x100/0x158)
[<0015d8b0>] (spi_write_then_read+0x0/0x158) from [<0015be60>] (read_sr+0x34/0x5c)
[<0015be2c>] (read_sr+0x0/0x5c) from [<0015c500>] (wait_till_ready+0x24/0x70)
 r5:ffffaf08 r4:003ccbd8
[<0015c4dc>] (wait_till_ready+0x0/0x70) from [<0015cf38>] (m25p80_read+0xbc/0x134)
 r6:01ce7814 r5:01c35ab8 r4:01ce7860 r3:80000014
[<0015ce7c>] (m25p80_read+0x0/0x134) from [<0015742c>] (part_read+0x64/0xac)
[<001573c8>] (part_read+0x0/0xac) from [<001545f0>] (mtd_read+0x90/0xc8)
 r7:01c35c04 r6:01e28400 r4:001fd914
[<00154560>] (mtd_read+0x0/0xc8) from [<000d4448>] (jffs2_flash_read+0x48/0x220)
 r9:003be000 r8:01e59c00 r7:00000640 r6:01c35c04 r5:00000000
r4:01e52800
[<000d4400>] (jffs2_flash_read+0x0/0x220) from [<000c6444>] (jffs2_read_dnode+0x2f0/0x4ec)
[<000c6154>] (jffs2_read_dnode+0x0/0x4ec) from [<000c6764>] (jffs2_read_inode_range+0x124/0x1b4)
[<000c6640>] (jffs2_read_inode_range+0x0/0x1b4) from [<000c49dc>] (jffs2_do_readpage_nolock+0x70/0x100)
[<000c496c>] (jffs2_do_readpage_nolock+0x0/0x100) from [<000c4d84>] (jffs2_do_readpage_unlock+0x14/0x28)
 r6:007ee7c0 r5:0147abb8 r4:007ee7c0
[<000c4d70>] (jffs2_do_readpage_unlock+0x0/0x28) from [<000c4df8>] (jffs2_readpage+0x60/0x78)
 r5:0147abb8 r4:007ee7c0
[<000c4d98>] (jffs2_readpage+0x0/0x78) from [<0005d874>] (__do_page_cache_readahead+0x1f8/0x25c)
 r5:00000004 r4:0147ad2c
[<0005d67c>] (__do_page_cache_readahead+0x0/0x25c) from [<0005db50>] (ra_submit+0x2c/0x34)
[<0005db24>] (ra_submit+0x0/0x34) from [<0005de1c>] (ondemand_readahead+0x2c4/0x2e8)
[<0005db58>] (ondemand_readahead+0x0/0x2e8) from [<0005df48>] (page_cache_sync_readahead+0x60/0x68)
[<0005dee8>] (page_cache_sync_readahead+0x0/0x68) from [<000562b4>] (generic_file_aio_read+0x314/0x7b0)
 r5:00000000 r4:00000001
[<00055fa0>] (generic_file_aio_read+0x0/0x7b0) from [<0006e738>] (do_sync_read+0x88/0xd0)
[<0006e6b0>] (do_sync_read+0x0/0xd0) from [<0006f02c>] (vfs_read+0xac/0xf4)
 r7:00000080 r6:01e5a400 r5:01c35ef8 r4:01c0fc40
[<0006ef80>] (vfs_read+0x0/0xf4) from [<00073a18>] (kernel_read+0x24/0x2c)
 r7:000089ed r6:0147ac20 r5:01c34000 r4:01e5a400
[<000739f4>] (kernel_read+0x0/0x2c) from [<00073b44>] (prepare_binprm+0x124/0x134)
[<00073a20>] (prepare_binprm+0x0/0x134) from [<00074210>] (do_execve+0x250/0x528)
 r7:003599eb r6:01c34000 r5:00000000 r4:01e5a400
[<00073fc0>] (do_execve+0x0/0x528) from [<000083e4>] (try_to_run_init_process+0x20/0x4c)
[<000083c4>] (try_to_run_init_process+0x0/0x4c) from [<002c7430>] (kernel_init+0x98/0x104)
 r5:002c7398 r4:003e8300
[<002c7398>] (kernel_init+0x0/0x104) from [<00009070>] (ret_from_fork+0x14/0x24)
 r4:00000000 r3:ffffffff
BUG: scheduling while atomic: spi0/30/0x0000001d
no locks held by spi0/30.
Modules linked in:
CPU: 0 PID: 30 Comm: spi0 Tainted: G        W    3.13.0-rc2-00203-g34074bc-dirty #2023
Backtrace: 
[<0000b204>] (dump_backtrace+0x0/0x108) from [<0000b398>] (show_stack+0x18/0x1c)
 r6:01e24000 r5:00000000 r4:01c8a580 r3:00208040
[<0000b380>] (show_stack+0x0/0x1c) from [<002ca888>] (dump_stack+0x20/0x28)
[<002ca868>] (dump_stack+0x0/0x28) from [<002c92bc>] (__schedule_bug+0x58/0x70)
[<002c9264>] (__schedule_bug+0x0/0x70) from [<002cc584>] (__schedule+0x58/0x398)
 r5:003cdef0 r4:01c8a580
[<002cc52c>] (__schedule+0x0/0x398) from [<002cca30>] (schedule+0x88/0x8c)
[<002cc9a8>] (schedule+0x0/0x8c) from [<00028480>] (kthread_worker_fn+0xd8/0xe4)
[<000283a8>] (kthread_worker_fn+0x0/0xe4) from [<00028648>] (kthread+0xcc/0xe0)
 r8:00000000 r7:000283a8 r6:01ce75dc r5:00000000 r4:01e1cd60
r3:01e24000
[<0002857c>] (kthread+0x0/0xe0) from [<00009070>] (ret_from_fork+0x14/0x24)
 r7:00000000 r6:00000000 r5:0002857c r4:01e1cd60
BUG: scheduling while atomic: swapper/1/0x00000019
3 locks held by swapper/1:
 #0:  (&sig->cred_guard_mutex){......}, at: [<00073ef8>] prepare_bprm_creds+0x30/0x6c
 #1:  (&f->sem){......}, at: [<000c4de8>] jffs2_readpage+0x50/0x78
 #2:  (&flash->lock){......}, at: [<0015cf30>] m25p80_read+0xb4/0x134
Modules linked in:
CPU: 0 PID: 1 Comm: swapper Tainted: G        W    3.13.0-rc2-00203-g34074bc-dirty #2023
Backtrace: 
[<0000b204>] (dump_backtrace+0x0/0x108) from [<0000b398>] (show_stack+0x18/0x1c)
 r6:01c34000 r5:00000000 r4:01c30000 r3:00200140
[<0000b380>] (show_stack+0x0/0x1c) from [<002ca888>] (dump_stack+0x20/0x28)
[<002ca868>] (dump_stack+0x0/0x28) from [<002c92bc>] (__schedule_bug+0x58/0x70)
[<002c9264>] (__schedule_bug+0x0/0x70) from [<002cc584>] (__schedule+0x58/0x398)
 r5:003cdef0 r4:01c30000
[<002cc52c>] (__schedule+0x0/0x398) from [<002cca30>] (schedule+0x88/0x8c)
[<002cc9a8>] (schedule+0x0/0x8c) from [<002cbf88>] (schedule_timeout+0x20/0x160)
[<002cbf68>] (schedule_timeout+0x0/0x160) from [<002cd130>] (wait_for_common+0xe0/0x178)
 r8:01c34000 r7:00000002 r6:01c359dc r5:01c359d8 r4:7fffffff
[<002cd050>] (wait_for_common+0x0/0x178) from [<002cd1e0>] (wait_for_completion+0x18/0x1c)
[<002cd1c8>] (wait_for_completion+0x0/0x1c) from [<0015d85c>] (__spi_sync+0xbc/0xe0)
[<0015d7a0>] (__spi_sync+0x0/0xe0) from [<0015d8ac>] (spi_sync+0x14/0x18)
[<0015d898>] (spi_sync+0x0/0x18) from [<0015cf78>] (m25p80_read+0xfc/0x134)
[<0015ce7c>] (m25p80_read+0x0/0x134) from [<0015742c>] (part_read+0x64/0xac)
[<001573c8>] (part_read+0x0/0xac) from [<001545f0>] (mtd_read+0x90/0xc8)
 r7:01c35c04 r6:01e28400 r4:001fd914
[<00154560>] (mtd_read+0x0/0xc8) from [<000d4448>] (jffs2_flash_read+0x48/0x220)
 r9:003be000 r8:01e59c00 r7:00000640 r6:01c35c04 r5:00000000
r4:01e52800
[<000d4400>] (jffs2_flash_read+0x0/0x220) from [<000c6444>] (jffs2_read_dnode+0x2f0/0x4ec)
[<000c6154>] (jffs2_read_dnode+0x0/0x4ec) from [<000c6764>] (jffs2_read_inode_range+0x124/0x1b4)
[<000c6640>] (jffs2_read_inode_range+0x0/0x1b4) from [<000c49dc>] (jffs2_do_readpage_nolock+0x70/0x100)
[<000c496c>] (jffs2_do_readpage_nolock+0x0/0x100) from [<000c4d84>] (jffs2_do_readpage_unlock+0x14/0x28)
 r6:007ee7c0 r5:0147abb8 r4:007ee7c0
[<000c4d70>] (jffs2_do_readpage_unlock+0x0/0x28) from [<000c4df8>] (jffs2_readpage+0x60/0x78)
 r5:0147abb8 r4:007ee7c0
[<000c4d98>] (jffs2_readpage+0x0/0x78) from [<0005d874>] (__do_page_cache_readahead+0x1f8/0x25c)
 r5:00000004 r4:0147ad2c
[<0005d67c>] (__do_page_cache_readahead+0x0/0x25c) from [<0005db50>] (ra_submit+0x2c/0x34)
[<0005db24>] (ra_submit+0x0/0x34) from [<0005de1c>] (ondemand_readahead+0x2c4/0x2e8)
[<0005db58>] (ondemand_readahead+0x0/0x2e8) from [<0005df48>] (page_cache_sync_readahead+0x60/0x68)
[<0005dee8>] (page_cache_sync_readahead+0x0/0x68) from [<000562b4>] (generic_file_aio_read+0x314/0x7b0)
 r5:00000000 r4:00000001
[<00055fa0>] (generic_file_aio_read+0x0/0x7b0) from [<0006e738>] (do_sync_read+0x88/0xd0)
[<0006e6b0>] (do_sync_read+0x0/0xd0) from [<0006f02c>] (vfs_read+0xac/0xf4)
 r7:00000080 r6:01e5a400 r5:01c35ef8 r4:01c0fc40
[<0006ef80>] (vfs_read+0x0/0xf4) from [<00073a18>] (kernel_read+0x24/0x2c)
 r7:000089ed r6:0147ac20 r5:01c34000 r4:01e5a400
[<000739f4>] (kernel_read+0x0/0x2c) from [<00073b44>] (prepare_binprm+0x124/0x134)
[<00073a20>] (prepare_binprm+0x0/0x134) from [<00074210>] (do_execve+0x250/0x528)
 r7:003599eb r6:01c34000 r5:00000000 r4:01e5a400
[<00073fc0>] (do_execve+0x0/0x528) from [<000083e4>] (try_to_run_init_process+0x20/0x4c)
[<000083c4>] (try_to_run_init_process+0x0/0x4c) from [<002c7430>] (kernel_init+0x98/0x104)
 r5:002c7398 r4:003e8300
[<002c7398>] (kernel_init+0x0/0x104) from [<00009070>] (ret_from_fork+0x14/0x24)
 r4:00000000 r3:ffffffff
BUG: scheduling while atomic: jffs2_gcd_mtd1/38/0x00000005
3 locks held by jffs2_gcd_mtd1/38:
 #0:  (&c->alloc_sem){......}, at: [<000cdf28>] jffs2_garbage_collect_pass+0x24/0x794
 #1:  (&f->sem#2){......}, at: [<000c9eb8>] jffs2_do_crccheck_inode+0x4c/0xa0
 #2:  (&flash->lock){......}, at: [<0015cf30>] m25p80_read+0xb4/0x134
Modules linked in:
CPU: 0 PID: 38 Comm: jffs2_gcd_mtd1 Tainted: G        W    3.13.0-rc2-00203-g34074bc-dirty #2023
Backtrace: 
[<0000b204>] (dump_backtrace+0x0/0x108) from [<0000b398>] (show_stack+0x18/0x1c)
 r6:01e64000 r5:00000000 r4:01c8b480 r3:00208040
[<0000b380>] (show_stack+0x0/0x1c) from [<002ca888>] (dump_stack+0x20/0x28)
[<002ca868>] (dump_stack+0x0/0x28) from [<002c92bc>] (__schedule_bug+0x58/0x70)
[<002c9264>] (__schedule_bug+0x0/0x70) from [<002cc584>] (__schedule+0x58/0x398)
 r5:003cdef0 r4:01c8b480
[<002cc52c>] (__schedule+0x0/0x398) from [<002cca30>] (schedule+0x88/0x8c)
[<002cc9a8>] (schedule+0x0/0x8c) from [<002ccbc0>] (schedule_preempt_disabled+0x18/0x24)
[<002ccba8>] (schedule_preempt_disabled+0x0/0x24) from [<002ce170>] (mutex_lock_nested+0x1b4/0x30c)
[<002cdfbc>] (mutex_lock_nested+0x0/0x30c) from [<0015cf30>] (m25p80_read+0xb4/0x134)
 r8:00000007 r7:00000232 r6:01ce7814 r5:01e65ba0 r4:01ce7860
[<0015ce7c>] (m25p80_read+0x0/0x134) from [<0015742c>] (part_read+0x64/0xac)
[<001573c8>] (part_read+0x0/0xac) from [<001545f0>] (mtd_read+0x90/0xc8)
 r7:01e65cf4 r6:01e28400 r4:00188b54
[<00154560>] (mtd_read+0x0/0xc8) from [<000d4448>] (jffs2_flash_read+0x48/0x220)
 r9:ffffffa1 r8:01e64000 r7:00000007 r6:01e65cf4 r5:000774ac
r4:01e52800
[<000d4400>] (jffs2_flash_read+0x0/0x220) from [<000c7a24>] (check_tn_node+0x218/0x444)
[<000c780c>] (check_tn_node+0x0/0x444) from [<000c93ec>] (jffs2_do_read_inode_internal+0x169c/0x1ebc)
[<000c7d50>] (jffs2_do_read_inode_internal+0x0/0x1ebc) from [<000c9ecc>] (jffs2_do_crccheck_inode+0x60/0xa0)
[<000c9e6c>] (jffs2_do_crccheck_inode+0x0/0xa0) from [<000ce09c>] (jffs2_garbage_collect_pass+0x198/0x794)
 r6:01c5c1f8 r5:01e529d8 r4:01e52800
[<000cdf04>] (jffs2_garbage_collect_pass+0x0/0x794) from [<000cfb80>] (jffs2_garbage_collect_thread+0x138/0x170)
[<000cfa48>] (jffs2_garbage_collect_thread+0x0/0x170) from [<00028648>] (kthread+0xcc/0xe0)
[<0002857c>] (kthread+0x0/0xe0) from [<00009070>] (ret_from_fork+0x14/0x24)
 r7:00000000 r6:00000000 r5:0002857c r4:01e601e0
BUG: scheduling while atomic: spi0/30/0x00000021
no locks held by spi0/30.
Modules linked in:
CPU: 0 PID: 30 Comm: spi0 Tainted: G        W    3.13.0-rc2-00203-g34074bc-dirty #2023
Backtrace: 
[<0000b204>] (dump_backtrace+0x0/0x108) from [<0000b398>] (show_stack+0x18/0x1c)
 r6:01e24000 r5:00000000 r4:01c8a580 r3:00208040
[<0000b380>] (show_stack+0x0/0x1c) from [<002ca888>] (dump_stack+0x20/0x28)
[<002ca868>] (dump_stack+0x0/0x28) from [<002c92bc>] (__schedule_bug+0x58/0x70)
[<002c9264>] (__schedule_bug+0x0/0x70) from [<002cc584>] (__schedule+0x58/0x398)
 r5:003cdef0 r4:01c8a580
[<002cc52c>] (__schedule+0x0/0x398) from [<002cca30>] (schedule+0x88/0x8c)
[<002cc9a8>] (schedule+0x0/0x8c) from [<00028480>] (kthread_worker_fn+0xd8/0xe4)
[<000283a8>] (kthread_worker_fn+0x0/0xe4) from [<00028648>] (kthread+0xcc/0xe0)
 r8:00000000 r7:000283a8 r6:01ce75dc r5:00000000 r4:01e1cd60
r3:01e24000
[<0002857c>] (kthread+0x0/0xe0) from [<00009070>] (ret_from_fork+0x14/0x24)
 r7:00000000 r6:00000000 r5:0002857c r4:01e1cd60
467: 27
470: 27
475: 28
485: 28
487: 29
489: 29
491: 28
494: 28
496: 28
498: 28
500: 28
502: 28
BUG: scheduling while atomic: init/1/0x0000001e
4 locks held by init/1:
 #0:  (&sig->cred_guard_mutex){......}, at: [<00073ef8>] prepare_bprm_creds+0x30/0x6c
 #1:  (&f->sem){......}, at: [<000c4de8>] jffs2_readpage+0x50/0x78
 #2:  (&flash->lock){......}, at: [<0015cf30>] m25p80_read+0xb4/0x134
 #3:  (lock){......}, at: [<0015d8e8>] spi_write_then_read+0x38/0x158
Modules linked in:
CPU: 0 PID: 1 Comm: init Tainted: G        W    3.13.0-rc2-00203-g34074bc-dirty #2023
Backtrace: 
[<0000b204>] (dump_backtrace+0x0/0x108) from [<0000b398>] (show_stack+0x18/0x1c)
 r6:01c34000 r5:00000000 r4:01c30000 r3:00000100
[<0000b380>] (show_stack+0x0/0x1c) from [<002ca888>] (dump_stack+0x20/0x28)
[<002ca868>] (dump_stack+0x0/0x28) from [<002c92bc>] (__schedule_bug+0x58/0x70)
[<002c9264>] (__schedule_bug+0x0/0x70) from [<002cc584>] (__schedule+0x58/0x398)
 r5:003cdef0 r4:01c30000
[<002cc52c>] (__schedule+0x0/0x398) from [<002cca30>] (schedule+0x88/0x8c)
[<002cc9a8>] (schedule+0x0/0x8c) from [<002cbf88>] (schedule_timeout+0x20/0x160)
[<002cbf68>] (schedule_timeout+0x0/0x160) from [<002cd130>] (wait_for_common+0xe0/0x178)
 r8:01c34000 r7:00000002 r6:01c3584c r5:01c35848 r4:7fffffff
[<002cd050>] (wait_for_common+0x0/0x178) from [<002cd1e0>] (wait_for_completion+0x18/0x1c)
[<002cd1c8>] (wait_for_completion+0x0/0x1c) from [<0015d85c>] (__spi_sync+0xbc/0xe0)
[<0015d7a0>] (__spi_sync+0x0/0xe0) from [<0015d8ac>] (spi_sync+0x14/0x18)
[<0015d898>] (spi_sync+0x0/0x18) from [<0015d9b0>] (spi_write_then_read+0x100/0x158)
[<0015d8b0>] (spi_write_then_read+0x0/0x158) from [<0015be60>] (read_sr+0x34/0x5c)
[<0015be2c>] (read_sr+0x0/0x5c) from [<0015c500>] (wait_till_ready+0x24/0x70)
 r5:ffffaf08 r4:003ccbd8
[<0015c4dc>] (wait_till_ready+0x0/0x70) from [<0015cf38>] (m25p80_read+0xbc/0x134)
 r6:01ce7814 r5:01c35a20 r4:01ce7860 r3:8000001c
[<0015ce7c>] (m25p80_read+0x0/0x134) from [<0015742c>] (part_read+0x64/0xac)
[<001573c8>] (part_read+0x0/0xac) from [<001545f0>] (mtd_read+0x90/0xc8)
 r7:01c35b6c r6:01e28400 r4:001fd2d4
[<00154560>] (mtd_read+0x0/0xc8) from [<000d4448>] (jffs2_flash_read+0x48/0x220)
 r9:019b6000 r8:01e59bf0 r7:00000044 r6:01c35b6c r5:00002d2c
r4:01e52800
[<000d4400>] (jffs2_flash_read+0x0/0x220) from [<000c61e4>] (jffs2_read_dnode+0x90/0x4ec)
[<000c6154>] (jffs2_read_dnode+0x0/0x4ec) from [<000c6764>] (jffs2_read_inode_range+0x124/0x1b4)
[<000c6640>] (jffs2_read_inode_range+0x0/0x1b4) from [<000c49dc>] (jffs2_do_readpage_nolock+0x70/0x100)
[<000c496c>] (jffs2_do_readpage_nolock+0x0/0x100) from [<000c4d84>] (jffs2_do_readpage_unlock+0x14/0x28)
 r6:0081a6c0 r5:0147abb8 r4:0081a6c0
[<000c4d70>] (jffs2_do_readpage_unlock+0x0/0x28) from [<000c4df8>] (jffs2_readpage+0x60/0x78)
 r5:0147abb8 r4:0081a6c0
[<000c4d98>] (jffs2_readpage+0x0/0x78) from [<0005d874>] (__do_page_cache_readahead+0x1f8/0x25c)
 r5:00000008 r4:0147ad2c
[<0005d67c>] (__do_page_cache_readahead+0x0/0x25c) from [<0005db50>] (ra_submit+0x2c/0x34)
[<0005db24>] (ra_submit+0x0/0x34) from [<0005de1c>] (ondemand_readahead+0x2c4/0x2e8)
[<0005db58>] (ondemand_readahead+0x0/0x2e8) from [<0005dee0>] (page_cache_async_readahead+0xa0/0xa8)
[<0005de40>] (page_cache_async_readahead+0x0/0xa8) from [<000562f8>] (generic_file_aio_read+0x358/0x7b0)
 r6:0147ad2c r5:00000001 r4:007e7020
[<00055fa0>] (generic_file_aio_read+0x0/0x7b0) from [<0006e738>] (do_sync_read+0x88/0xd0)
[<0006e6b0>] (do_sync_read+0x0/0xd0) from [<000739d8>] (read_code+0x34/0x50)
 r7:000bb000 r6:00390900 r5:01f00000 r4:00093900
[<000739a4>] (read_code+0x0/0x50) from [<000a9810>] (load_flat_binary+0x40c/0xa3c)
 r6:00390900 r5:01f00000 r4:01e5a400
[<000a9404>] (load_flat_binary+0x0/0xa3c) from [<000731e4>] (search_binary_handler+0x7c/0x17c)
[<00073168>] (search_binary_handler+0x0/0x17c) from [<000742f4>] (do_execve+0x334/0x528)
[<00073fc0>] (do_execve+0x0/0x528) from [<000083e4>] (try_to_run_init_process+0x20/0x4c)
[<000083c4>] (try_to_run_init_process+0x0/0x4c) from [<002c7430>] (kernel_init+0x98/0x104)
 r5:002c7398 r4:003e8300
[<002c7398>] (kernel_init+0x0/0x104) from [<00009070>] (ret_from_fork+0x14/0x24)
 r4:00000000 r3:ffffffff
BUG: scheduling while atomic: jffs2_gcd_mtd1/38/0x00000006
3 locks held by jffs2_gcd_mtd1/38:
 #0:  (&c->alloc_sem){......}, at: [<000cdf28>] jffs2_garbage_collect_pass+0x24/0x794
 #1:  (&f->sem#2){......}, at: [<000c9eb8>] jffs2_do_crccheck_inode+0x4c/0xa0
 #2:  (&flash->lock){......}, at: [<0015cf30>] m25p80_read+0xb4/0x134
Modules linked in:
CPU: 0 PID: 38 Comm: jffs2_gcd_mtd1 Tainted: G        W    3.13.0-rc2-00203-g34074bc-dirty #2023
Backtrace: 
[<0000b204>] (dump_backtrace+0x0/0x108) from [<0000b398>] (show_stack+0x18/0x1c)
 r6:01e64000 r5:00000000 r4:01c8b480 r3:00208040
[<0000b380>] (show_stack+0x0/0x1c) from [<002ca888>] (dump_stack+0x20/0x28)
[<002ca868>] (dump_stack+0x0/0x28) from [<002c92bc>] (__schedule_bug+0x58/0x70)
[<002c9264>] (__schedule_bug+0x0/0x70) from [<002cc584>] (__schedule+0x58/0x398)
 r5:003cdef0 r4:01c8b480
[<002cc52c>] (__schedule+0x0/0x398) from [<002cca30>] (schedule+0x88/0x8c)
[<002cc9a8>] (schedule+0x0/0x8c) from [<002ccbc0>] (schedule_preempt_disabled+0x18/0x24)
[<002ccba8>] (schedule_preempt_disabled+0x0/0x24) from [<002ce170>] (mutex_lock_nested+0x1b4/0x30c)
[<002cdfbc>] (mutex_lock_nested+0x0/0x30c) from [<0015cf30>] (m25p80_read+0xb4/0x134)
 r8:00000007 r7:00000232 r6:01ce7814 r5:01e65ba0 r4:01ce7860
[<0015ce7c>] (m25p80_read+0x0/0x134) from [<0015742c>] (part_read+0x64/0xac)
[<001573c8>] (part_read+0x0/0xac) from [<001545f0>] (mtd_read+0x90/0xc8)
 r7:01e65cf4 r6:01e28400 r4:00188b54
[<00154560>] (mtd_read+0x0/0xc8) from [<000d4448>] (jffs2_flash_read+0x48/0x220)
 r9:ffffffa1 r8:01e64000 r7:00000007 r6:01e65cf4 r5:000774ac
r4:01e52800
[<000d4400>] (jffs2_flash_read+0x0/0x220) from [<000c7a24>] (check_tn_node+0x218/0x444)
[<000c780c>] (check_tn_node+0x0/0x444) from [<000c93ec>] (jffs2_do_read_inode_internal+0x169c/0x1ebc)
[<000c7d50>] (jffs2_do_read_inode_internal+0x0/0x1ebc) from [<000c9ecc>] (jffs2_do_crccheck_inode+0x60/0xa0)
[<000c9e6c>] (jffs2_do_crccheck_inode+0x0/0xa0) from [<000ce09c>] (jffs2_garbage_collect_pass+0x198/0x794)
 r6:01c5c1f8 r5:01e529d8 r4:01e52800
[<000cdf04>] (jffs2_garbage_collect_pass+0x0/0x794) from [<000cfb80>] (jffs2_garbage_collect_thread+0x138/0x170)
[<000cfa48>] (jffs2_garbage_collect_thread+0x0/0x170) from [<00028648>] (kthread+0xcc/0xe0)
[<0002857c>] (kthread+0x0/0xe0) from [<00009070>] (ret_from_fork+0x14/0x24)
 r7:00000000 r6:00000000 r5:0002857c r4:01e601e0
BUG: scheduling while atomic: spi0/30/0x00000025
no locks held by spi0/30.
Modules linked in:
CPU: 0 PID: 30 Comm: spi0 Tainted: G        W    3.13.0-rc2-00203-g34074bc-dirty #2023
Backtrace: 
[<0000b204>] (dump_backtrace+0x0/0x108) from [<0000b398>] (show_stack+0x18/0x1c)
 r6:01e24000 r5:00000000 r4:01c8a580 r3:00208040
[<0000b380>] (show_stack+0x0/0x1c) from [<002ca888>] (dump_stack+0x20/0x28)
[<002ca868>] (dump_stack+0x0/0x28) from [<002c92bc>] (__schedule_bug+0x58/0x70)
[<002c9264>] (__schedule_bug+0x0/0x70) from [<002cc584>] (__schedule+0x58/0x398)
 r5:003cdef0 r4:01c8a580
[<002cc52c>] (__schedule+0x0/0x398) from [<002cca30>] (schedule+0x88/0x8c)
[<002cc9a8>] (schedule+0x0/0x8c) from [<00028480>] (kthread_worker_fn+0xd8/0xe4)
[<000283a8>] (kthread_worker_fn+0x0/0xe4) from [<00028648>] (kthread+0xcc/0xe0)
 r8:00000000 r7:000283a8 r6:01ce75dc r5:00000000 r4:01e1cd60
r3:01e24000
[<0002857c>] (kthread+0x0/0xe0) from [<00009070>] (ret_from_fork+0x14/0x24)
 r7:00000000 r6:00000000 r5:0002857c r4:01e1cd60
BUG: scheduling while atomic: init/1/0x00000021
3 locks held by init/1:
 #0:  (&sig->cred_guard_mutex){......}, at: [<00073ef8>] prepare_bprm_creds+0x30/0x6c
 #1:  (&f->sem){......}, at: [<000c4de8>] jffs2_readpage+0x50/0x78
 #2:  (&flash->lock){......}, at: [<0015cf30>] m25p80_read+0xb4/0x134
Modules linked in:
CPU: 0 PID: 1 Comm: init Tainted: G        W    3.13.0-rc2-00203-g34074bc-dirty #2023
Backtrace: 
[<0000b204>] (dump_backtrace+0x0/0x108) from [<0000b398>] (show_stack+0x18/0x1c)
 r6:01c34000 r5:00000000 r4:01c30000 r3:00000100
[<0000b380>] (show_stack+0x0/0x1c) from [<002ca888>] (dump_stack+0x20/0x28)
[<002ca868>] (dump_stack+0x0/0x28) from [<002c92bc>] (__schedule_bug+0x58/0x70)
[<002c9264>] (__schedule_bug+0x0/0x70) from [<002cc584>] (__schedule+0x58/0x398)
 r5:003cdef0 r4:01c30000
[<002cc52c>] (__schedule+0x0/0x398) from [<002cca30>] (schedule+0x88/0x8c)
[<002cc9a8>] (schedule+0x0/0x8c) from [<002cbf88>] (schedule_timeout+0x20/0x160)
[<002cbf68>] (schedule_timeout+0x0/0x160) from [<002cd130>] (wait_for_common+0xe0/0x178)
 r8:01c34000 r7:00000002 r6:01c35944 r5:01c35940 r4:7fffffff
[<002cd050>] (wait_for_common+0x0/0x178) from [<002cd1e0>] (wait_for_completion+0x18/0x1c)
[<002cd1c8>] (wait_for_completion+0x0/0x1c) from [<0015d85c>] (__spi_sync+0xbc/0xe0)
[<0015d7a0>] (__spi_sync+0x0/0xe0) from [<0015d8ac>] (spi_sync+0x14/0x18)
[<0015d898>] (spi_sync+0x0/0x18) from [<0015cf78>] (m25p80_read+0xfc/0x134)
[<0015ce7c>] (m25p80_read+0x0/0x134) from [<0015742c>] (part_read+0x64/0xac)
[<001573c8>] (part_read+0x0/0xac) from [<001545f0>] (mtd_read+0x90/0xc8)
 r7:01c35b6c r6:01e28400 r4:001fd2d4
[<00154560>] (mtd_read+0x0/0xc8) from [<000d4448>] (jffs2_flash_read+0x48/0x220)
 r9:019b6000 r8:01e59bf0 r7:00000044 r6:01c35b6c r5:00002d2c
r4:01e52800
[<000d4400>] (jffs2_flash_read+0x0/0x220) from [<000c61e4>] (jffs2_read_dnode+0x90/0x4ec)
[<000c6154>] (jffs2_read_dnode+0x0/0x4ec) from [<000c6764>] (jffs2_read_inode_range+0x124/0x1b4)
[<000c6640>] (jffs2_read_inode_range+0x0/0x1b4) from [<000c49dc>] (jffs2_do_readpage_nolock+0x70/0x100)
[<000c496c>] (jffs2_do_readpage_nolock+0x0/0x100) from [<000c4d84>] (jffs2_do_readpage_unlock+0x14/0x28)
 r6:0081a6c0 r5:0147abb8 r4:0081a6c0
[<000c4d70>] (jffs2_do_readpage_unlock+0x0/0x28) from [<000c4df8>] (jffs2_readpage+0x60/0x78)
 r5:0147abb8 r4:0081a6c0
[<000c4d98>] (jffs2_readpage+0x0/0x78) from [<0005d874>] (__do_page_cache_readahead+0x1f8/0x25c)
 r5:00000008 r4:0147ad2c
[<0005d67c>] (__do_page_cache_readahead+0x0/0x25c) from [<0005db50>] (ra_submit+0x2c/0x34)
[<0005db24>] (ra_submit+0x0/0x34) from [<0005de1c>] (ondemand_readahead+0x2c4/0x2e8)
[<0005db58>] (ondemand_readahead+0x0/0x2e8) from [<0005dee0>] (page_cache_async_readahead+0xa0/0xa8)
[<0005de40>] (page_cache_async_readahead+0x0/0xa8) from [<000562f8>] (generic_file_aio_read+0x358/0x7b0)
 r6:0147ad2c r5:00000001 r4:007e7020
[<00055fa0>] (generic_file_aio_read+0x0/0x7b0) from [<0006e738>] (do_sync_read+0x88/0xd0)
[<0006e6b0>] (do_sync_read+0x0/0xd0) from [<000739d8>] (read_code+0x34/0x50)
 r7:000bb000 r6:00390900 r5:01f00000 r4:00093900
[<000739a4>] (read_code+0x0/0x50) from [<000a9810>] (load_flat_binary+0x40c/0xa3c)
 r6:00390900 r5:01f00000 r4:01e5a400
[<000a9404>] (load_flat_binary+0x0/0xa3c) from [<000731e4>] (search_binary_handler+0x7c/0x17c)
[<00073168>] (search_binary_handler+0x0/0x17c) from [<000742f4>] (do_execve+0x334/0x528)
[<00073fc0>] (do_execve+0x0/0x528) from [<000083e4>] (try_to_run_init_process+0x20/0x4c)
[<000083c4>] (try_to_run_init_process+0x0/0x4c) from [<002c7430>] (kernel_init+0x98/0x104)
 r5:002c7398 r4:003e8300
[<002c7398>] (kernel_init+0x0/0x104) from [<00009070>] (ret_from_fork+0x14/0x24)
 r4:00000000 r3:ffffffff
BUG: scheduling while atomic: spi0/30/0x00000029
no locks held by spi0/30.
Modules linked in:
CPU: 0 PID: 30 Comm: spi0 Tainted: G        W    3.13.0-rc2-00203-g34074bc-dirty #2023
Backtrace: 
[<0000b204>] (dump_backtrace+0x0/0x108) from [<0000b398>] (show_stack+0x18/0x1c)
 r6:01e24000 r5:00000000 r4:01c8a580 r3:00208040
[<0000b380>] (show_stack+0x0/0x1c) from [<002ca888>] (dump_stack+0x20/0x28)
[<002ca868>] (dump_stack+0x0/0x28) from [<002c92bc>] (__schedule_bug+0x58/0x70)
[<002c9264>] (__schedule_bug+0x0/0x70) from [<002cc584>] (__schedule+0x58/0x398)
 r5:003cdef0 r4:01c8a580
[<002cc52c>] (__schedule+0x0/0x398) from [<002cca30>] (schedule+0x88/0x8c)
[<002cc9a8>] (schedule+0x0/0x8c) from [<00028480>] (kthread_worker_fn+0xd8/0xe4)
[<000283a8>] (kthread_worker_fn+0x0/0xe4) from [<00028648>] (kthread+0xcc/0xe0)
 r8:00000000 r7:000283a8 r6:01ce75dc r5:00000000 r4:01e1cd60
r3:01e24000
[<0002857c>] (kthread+0x0/0xe0) from [<00009070>] (ret_from_fork+0x14/0x24)
 r7:00000000 r6:00000000 r5:0002857c r4:01e1cd60
BUG: scheduling while atomic: init/1/0x00000024
4 locks held by init/1:
 #0:  (&sig->cred_guard_mutex){......}, at: [<00073ef8>] prepare_bprm_creds+0x30/0x6c
 #1:  (&f->sem){......}, at: [<000c4de8>] jffs2_readpage+0x50/0x78
 #2:  (&flash->lock){......}, at: [<0015cf30>] m25p80_read+0xb4/0x134
 #3:  (lock){......}, at: [<0015d8e8>] spi_write_then_read+0x38/0x158
Modules linked in:
CPU: 0 PID: 1 Comm: init Tainted: G        W    3.13.0-rc2-00203-g34074bc-dirty #2023
Backtrace: 
[<0000b204>] (dump_backtrace+0x0/0x108) from [<0000b398>] (show_stack+0x18/0x1c)
 r6:01c34000 r5:00000000 r4:01c30000 r3:00000100
[<0000b380>] (show_stack+0x0/0x1c) from [<002ca888>] (dump_stack+0x20/0x28)
[<002ca868>] (dump_stack+0x0/0x28) from [<002c92bc>] (__schedule_bug+0x58/0x70)
[<002c9264>] (__schedule_bug+0x0/0x70) from [<002cc584>] (__schedule+0x58/0x398)
 r5:003cdef0 r4:01c30000
[<002cc52c>] (__schedule+0x0/0x398) from [<002cca30>] (schedule+0x88/0x8c)
[<002cc9a8>] (schedule+0x0/0x8c) from [<002cbf88>] (schedule_timeout+0x20/0x160)
[<002cbf68>] (schedule_timeout+0x0/0x160) from [<002cd130>] (wait_for_common+0xe0/0x178)
 r8:01c34000 r7:00000002 r6:01c3584c r5:01c35848 r4:7fffffff
[<002cd050>] (wait_for_common+0x0/0x178) from [<002cd1e0>] (wait_for_completion+0x18/0x1c)
[<002cd1c8>] (wait_for_completion+0x0/0x1c) from [<0015d85c>] (__spi_sync+0xbc/0xe0)
[<0015d7a0>] (__spi_sync+0x0/0xe0) from [<0015d8ac>] (spi_sync+0x14/0x18)
[<0015d898>] (spi_sync+0x0/0x18) from [<0015d9b0>] (spi_write_then_read+0x100/0x158)
[<0015d8b0>] (spi_write_then_read+0x0/0x158) from [<0015be60>] (read_sr+0x34/0x5c)
[<0015be2c>] (read_sr+0x0/0x5c) from [<0015c500>] (wait_till_ready+0x24/0x70)
 r5:ffffaf08 r4:003ccbd8
[<0015c4dc>] (wait_till_ready+0x0/0x70) from [<0015cf38>] (m25p80_read+0xbc/0x134)
 r6:01ce7814 r5:01c35a20 r4:01ce7860 r3:80000022
[<0015ce7c>] (m25p80_read+0x0/0x134) from [<0015742c>] (part_read+0x64/0xac)
[<001573c8>] (part_read+0x0/0xac) from [<001545f0>] (mtd_read+0x90/0xc8)
 r7:01c35b6c r6:01e28400 r4:001fd290
[<00154560>] (mtd_read+0x0/0xc8) from [<000d4448>] (jffs2_flash_read+0x48/0x220)
 r9:019b6000 r8:01e59bf0 r7:0000072f r6:01c35b6c r5:00000000
r4:01e52800
[<000d4400>] (jffs2_flash_read+0x0/0x220) from [<000c6444>] (jffs2_read_dnode+0x2f0/0x4ec)
[<000c6154>] (jffs2_read_dnode+0x0/0x4ec) from [<000c6764>] (jffs2_read_inode_range+0x124/0x1b4)
[<000c6640>] (jffs2_read_inode_range+0x0/0x1b4) from [<000c49dc>] (jffs2_do_readpage_nolock+0x70/0x100)
[<000c496c>] (jffs2_do_readpage_nolock+0x0/0x100) from [<000c4d84>] (jffs2_do_readpage_unlock+0x14/0x28)
 r6:0081a6c0 r5:0147abb8 r4:0081a6c0
[<000c4d70>] (jffs2_do_readpage_unlock+0x0/0x28) from [<000c4df8>] (jffs2_readpage+0x60/0x78)
 r5:0147abb8 r4:0081a6c0
[<000c4d98>] (jffs2_readpage+0x0/0x78) from [<0005d874>] (__do_page_cache_readahead+0x1f8/0x25c)
 r5:00000008 r4:0147ad2c
[<0005d67c>] (__do_page_cache_readahead+0x0/0x25c) from [<0005db50>] (ra_submit+0x2c/0x34)
[<0005db24>] (ra_submit+0x0/0x34) from [<0005de1c>] (ondemand_readahead+0x2c4/0x2e8)
[<0005db58>] (ondemand_readahead+0x0/0x2e8) from [<0005dee0>] (page_cache_async_readahead+0xa0/0xa8)
[<0005de40>] (page_cache_async_readahead+0x0/0xa8) from [<000562f8>] (generic_file_aio_read+0x358/0x7b0)
 r6:0147ad2c r5:00000001 r4:007e7020
[<00055fa0>] (generic_file_aio_read+0x0/0x7b0) from [<0006e738>] (do_sync_read+0x88/0xd0)
[<0006e6b0>] (do_sync_read+0x0/0xd0) from [<000739d8>] (read_code+0x34/0x50)
 r7:000bb000 r6:00390900 r5:01f00000 r4:00093900
[<000739a4>] (read_code+0x0/0x50) from [<000a9810>] (load_flat_binary+0x40c/0xa3c)
 r6:00390900 r5:01f00000 r4:01e5a400
[<000a9404>] (load_flat_binary+0x0/0xa3c) from [<000731e4>] (search_binary_handler+0x7c/0x17c)
[<00073168>] (search_binary_handler+0x0/0x17c) from [<000742f4>] (do_execve+0x334/0x528)
[<00073fc0>] (do_execve+0x0/0x528) from [<000083e4>] (try_to_run_init_process+0x20/0x4c)
[<000083c4>] (try_to_run_init_process+0x0/0x4c) from [<002c7430>] (kernel_init+0x98/0x104)
 r5:002c7398 r4:003e8300
[<002c7398>] (kernel_init+0x0/0x104) from [<00009070>] (ret_from_fork+0x14/0x24)
 r4:00000000 r3:ffffffff
BUG: scheduling while atomic: spi0/30/0x0000002d
no locks held by spi0/30.
Modules linked in:
CPU: 0 PID: 30 Comm: spi0 Tainted: G        W    3.13.0-rc2-00203-g34074bc-dirty #2023
Backtrace: 
[<0000b204>] (dump_backtrace+0x0/0x108) from [<0000b398>] (show_stack+0x18/0x1c)
 r6:01e24000 r5:00000000 r4:01c8a580 r3:00208040
[<0000b380>] (show_stack+0x0/0x1c) from [<002ca888>] (dump_stack+0x20/0x28)
[<002ca868>] (dump_stack+0x0/0x28) from [<002c92bc>] (__schedule_bug+0x58/0x70)
[<002c9264>] (__schedule_bug+0x0/0x70) from [<002cc584>] (__schedule+0x58/0x398)
 r5:003cdef0 r4:01c8a580
[<002cc52c>] (__schedule+0x0/0x398) from [<002cca30>] (schedule+0x88/0x8c)
[<002cc9a8>] (schedule+0x0/0x8c) from [<00028480>] (kthread_worker_fn+0xd8/0xe4)
[<000283a8>] (kthread_worker_fn+0x0/0xe4) from [<00028648>] (kthread+0xcc/0xe0)
 r8:00000000 r7:000283a8 r6:01ce75dc r5:00000000 r4:01e1cd60
r3:01e24000
[<0002857c>] (kthread+0x0/0xe0) from [<00009070>] (ret_from_fork+0x14/0x24)
 r7:00000000 r6:00000000 r5:0002857c r4:01e1cd60
BUG: scheduling while atomic: init/1/0x00000027
3 locks held by init/1:
 #0:  (&sig->cred_guard_mutex){......}, at: [<00073ef8>] prepare_bprm_creds+0x30/0x6c
 #1:  (&f->sem){......}, at: [<000c4de8>] jffs2_readpage+0x50/0x78
 #2:  (&flash->lock){......}, at: [<0015cf30>] m25p80_read+0xb4/0x134
Modules linked in:
CPU: 0 PID: 1 Comm: init Tainted: G        W    3.13.0-rc2-00203-g34074bc-dirty #2023
Backtrace: 
[<0000b204>] (dump_backtrace+0x0/0x108) from [<0000b398>] (show_stack+0x18/0x1c)
 r6:01c34000 r5:00000000 r4:01c30000 r3:00000100
[<0000b380>] (show_stack+0x0/0x1c) from [<002ca888>] (dump_stack+0x20/0x28)
[<002ca868>] (dump_stack+0x0/0x28) from [<002c92bc>] (__schedule_bug+0x58/0x70)
[<002c9264>] (__schedule_bug+0x0/0x70) from [<002cc584>] (__schedule+0x58/0x398)
 r5:003cdef0 r4:01c30000
[<002cc52c>] (__schedule+0x0/0x398) from [<002cca30>] (schedule+0x88/0x8c)
[<002cc9a8>] (schedule+0x0/0x8c) from [<002cbf88>] (schedule_timeout+0x20/0x160)
[<002cbf68>] (schedule_timeout+0x0/0x160) from [<002cd130>] (wait_for_common+0xe0/0x178)
 r8:01c34000 r7:00000002 r6:01c35944 r5:01c35940 r4:7fffffff
[<002cd050>] (wait_for_common+0x0/0x178) from [<002cd1e0>] (wait_for_completion+0x18/0x1c)
[<002cd1c8>] (wait_for_completion+0x0/0x1c) from [<0015d85c>] (__spi_sync+0xbc/0xe0)
[<0015d7a0>] (__spi_sync+0x0/0xe0) from [<0015d8ac>] (spi_sync+0x14/0x18)
[<0015d898>] (spi_sync+0x0/0x18) from [<0015cf78>] (m25p80_read+0xfc/0x134)
[<0015ce7c>] (m25p80_read+0x0/0x134) from [<0015742c>] (part_read+0x64/0xac)
[<001573c8>] (part_read+0x0/0xac) from [<001545f0>] (mtd_read+0x90/0xc8)
 r7:01c35b6c r6:01e28400 r4:001fd290
[<00154560>] (mtd_read+0x0/0xc8) from [<000d4448>] (jffs2_flash_read+0x48/0x220)
 r9:019b6000 r8:01e59bf0 r7:0000072f r6:01c35b6c r5:00000000
r4:01e52800
[<000d4400>] (jffs2_flash_read+0x0/0x220) from [<000c6444>] (jffs2_read_dnode+0x2f0/0x4ec)
[<000c6154>] (jffs2_read_dnode+0x0/0x4ec) from [<000c6764>] (jffs2_read_inode_range+0x124/0x1b4)
[<000c6640>] (jffs2_read_inode_range+0x0/0x1b4) from [<000c49dc>] (jffs2_do_readpage_nolock+0x70/0x100)
[<000c496c>] (jffs2_do_readpage_nolock+0x0/0x100) from [<000c4d84>] (jffs2_do_readpage_unlock+0x14/0x28)
 r6:0081a6c0 r5:0147abb8 r4:0081a6c0
[<000c4d70>] (jffs2_do_readpage_unlock+0x0/0x28) from [<000c4df8>] (jffs2_readpage+0x60/0x78)
 r5:0147abb8 r4:0081a6c0
[<000c4d98>] (jffs2_readpage+0x0/0x78) from [<0005d874>] (__do_page_cache_readahead+0x1f8/0x25c)
 r5:00000008 r4:0147ad2c
[<0005d67c>] (__do_page_cache_readahead+0x0/0x25c) from [<0005db50>] (ra_submit+0x2c/0x34)
[<0005db24>] (ra_submit+0x0/0x34) from [<0005de1c>] (ondemand_readahead+0x2c4/0x2e8)
[<0005db58>] (ondemand_readahead+0x0/0x2e8) from [<0005dee0>] (page_cache_async_readahead+0xa0/0xa8)
[<0005de40>] (page_cache_async_readahead+0x0/0xa8) from [<000562f8>] (generic_file_aio_read+0x358/0x7b0)
 r6:0147ad2c r5:00000001 r4:007e7020
[<00055fa0>] (generic_file_aio_read+0x0/0x7b0) from [<0006e738>] (do_sync_read+0x88/0xd0)
[<0006e6b0>] (do_sync_read+0x0/0xd0) from [<000739d8>] (read_code+0x34/0x50)
 r7:000bb000 r6:00390900 r5:01f00000 r4:00093900
[<000739a4>] (read_code+0x0/0x50) from [<000a9810>] (load_flat_binary+0x40c/0xa3c)
 r6:00390900 r5:01f00000 r4:01e5a400
[<000a9404>] (load_flat_binary+0x0/0xa3c) from [<000731e4>] (search_binary_handler+0x7c/0x17c)
[<00073168>] (search_binary_handler+0x0/0x17c) from [<000742f4>] (do_execve+0x334/0x528)
[<00073fc0>] (do_execve+0x0/0x528) from [<000083e4>] (try_to_run_init_process+0x20/0x4c)
[<000083c4>] (try_to_run_init_process+0x0/0x4c) from [<002c7430>] (kernel_init+0x98/0x104)
 r5:002c7398 r4:003e8300
[<002c7398>] (kernel_init+0x0/0x104) from [<00009070>] (ret_from_fork+0x14/0x24)
 r4:00000000 r3:ffffffff
BUG: scheduling while atomic: jffs2_gcd_mtd1/38/0x00000007
3 locks held by jffs2_gcd_mtd1/38:
 #0:  (&c->alloc_sem){......}, at: [<000cdf28>] jffs2_garbage_collect_pass+0x24/0x794
 #1:  (&f->sem#2){......}, at: [<000c9eb8>] jffs2_do_crccheck_inode+0x4c/0xa0
 #2:  (&flash->lock){......}, at: [<0015cf30>] m25p80_read+0xb4/0x134
Modules linked in:
CPU: 0 PID: 38 Comm: jffs2_gcd_mtd1 Tainted: G        W    3.13.0-rc2-00203-g34074bc-dirty #2023
Backtrace: 
[<0000b204>] (dump_backtrace+0x0/0x108) from [<0000b398>] (show_stack+0x18/0x1c)
 r6:01e64000 r5:00000000 r4:01c8b480 r3:00208040
[<0000b380>] (show_stack+0x0/0x1c) from [<002ca888>] (dump_stack+0x20/0x28)
[<002ca868>] (dump_stack+0x0/0x28) from [<002c92bc>] (__schedule_bug+0x58/0x70)
[<002c9264>] (__schedule_bug+0x0/0x70) from [<002cc584>] (__schedule+0x58/0x398)
 r5:003cdef0 r4:01c8b480
[<002cc52c>] (__schedule+0x0/0x398) from [<002cca30>] (schedule+0x88/0x8c)
[<002cc9a8>] (schedule+0x0/0x8c) from [<002ccbc0>] (schedule_preempt_disabled+0x18/0x24)
[<002ccba8>] (schedule_preempt_disabled+0x0/0x24) from [<002ce170>] (mutex_lock_nested+0x1b4/0x30c)
[<002cdfbc>] (mutex_lock_nested+0x0/0x30c) from [<0015cf30>] (m25p80_read+0xb4/0x134)
 r8:00000007 r7:00000232 r6:01ce7814 r5:01e65ba0 r4:01ce7860
[<0015ce7c>] (m25p80_read+0x0/0x134) from [<0015742c>] (part_read+0x64/0xac)
[<001573c8>] (part_read+0x0/0xac) from [<001545f0>] (mtd_read+0x90/0xc8)
 r7:01e65cf4 r6:01e28400 r4:00188b54
[<00154560>] (mtd_read+0x0/0xc8) from [<000d4448>] (jffs2_flash_read+0x48/0x220)
 r9:ffffffa1 r8:01e64000 r7:00000007 r6:01e65cf4 r5:000774ac
r4:01e52800
[<000d4400>] (jffs2_flash_read+0x0/0x220) from [<000c7a24>] (check_tn_node+0x218/0x444)
[<000c780c>] (check_tn_node+0x0/0x444) from [<000c93ec>] (jffs2_do_read_inode_internal+0x169c/0x1ebc)
[<000c7d50>] (jffs2_do_read_inode_internal+0x0/0x1ebc) from [<000c9ecc>] (jffs2_do_crccheck_inode+0x60/0xa0)
[<000c9e6c>] (jffs2_do_crccheck_inode+0x0/0xa0) from [<000ce09c>] (jffs2_garbage_collect_pass+0x198/0x794)
 r6:01c5c1f8 r5:01e529d8 r4:01e52800
[<000cdf04>] (jffs2_garbage_collect_pass+0x0/0x794) from [<000cfb80>] (jffs2_garbage_collect_thread+0x138/0x170)
[<000cfa48>] (jffs2_garbage_collect_thread+0x0/0x170) from [<00028648>] (kthread+0xcc/0xe0)
[<0002857c>] (kthread+0x0/0xe0) from [<00009070>] (ret_from_fork+0x14/0x24)
 r7:00000000 r6:00000000 r5:0002857c r4:01e601e0
BUG: scheduling while atomic: spi0/30/0x00000031
no locks held by spi0/30.
Modules linked in:
CPU: 0 PID: 30 Comm: spi0 Tainted: G        W    3.13.0-rc2-00203-g34074bc-dirty #2023
Backtrace: 
[<0000b204>] (dump_backtrace+0x0/0x108) from [<0000b398>] (show_stack+0x18/0x1c)
 r6:01e24000 r5:00000000 r4:01c8a580 r3:00208040
[<0000b380>] (show_stack+0x0/0x1c) from [<002ca888>] (dump_stack+0x20/0x28)
[<002ca868>] (dump_stack+0x0/0x28) from [<002c92bc>] (__schedule_bug+0x58/0x70)
[<002c9264>] (__schedule_bug+0x0/0x70) from [<002cc584>] (__schedule+0x58/0x398)
 r5:003cdef0 r4:01c8a580
[<002cc52c>] (__schedule+0x0/0x398) from [<002cca30>] (schedule+0x88/0x8c)
[<002cc9a8>] (schedule+0x0/0x8c) from [<00028480>] (kthread_worker_fn+0xd8/0xe4)
[<000283a8>] (kthread_worker_fn+0x0/0xe4) from [<00028648>] (kthread+0xcc/0xe0)
 r8:00000000 r7:000283a8 r6:01ce75dc r5:00000000 r4:01e1cd60
r3:01e24000
[<0002857c>] (kthread+0x0/0xe0) from [<00009070>] (ret_from_fork+0x14/0x24)
 r7:00000000 r6:00000000 r5:0002857c r4:01e1cd60
467: 40
470: 40
475: 41
485: 41
487: 42
489: 42
491: 41
494: 41
496: 41
498: 41
500: 41
502: 41
BUG: scheduling while atomic: init/1/0x0000002b
4 locks held by init/1:
 #0:  (&sig->cred_guard_mutex){......}, at: [<00073ef8>] prepare_bprm_creds+0x30/0x6c
 #1:  (&f->sem){......}, at: [<000c4de8>] jffs2_readpage+0x50/0x78
 #2:  (&flash->lock){......}, at: [<0015cf30>] m25p80_read+0xb4/0x134
 #3:  (lock){......}, at: [<0015d8e8>] spi_write_then_read+0x38/0x158
Modules linked in:
CPU: 0 PID: 1 Comm: init Tainted: G        W    3.13.0-rc2-00203-g34074bc-dirty #2023
Backtrace: 
[<0000b204>] (dump_backtrace+0x0/0x108) from [<0000b398>] (show_stack+0x18/0x1c)
 r6:01c34000 r5:00000000 r4:01c30000 r3:00000100
[<0000b380>] (show_stack+0x0/0x1c) from [<002ca888>] (dump_stack+0x20/0x28)
[<002ca868>] (dump_stack+0x0/0x28) from [<002c92bc>] (__schedule_bug+0x58/0x70)
[<002c9264>] (__schedule_bug+0x0/0x70) from [<002cc584>] (__schedule+0x58/0x398)
 r5:003cdef0 r4:01c30000
[<


