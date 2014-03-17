Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756741AbaCQOr4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 10:47:56 -0400
Received: from mail-ee0-f50.google.com ([74.125.83.50]:55689 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753770AbaCQOry (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 10:47:54 -0400
Date: Mon, 17 Mar 2014 17:43:58 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Minchan Kim <minchan@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Nitin Gupta <ngupta@vflare.org>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Jerome Marchand <jmarchan@redhat.com>, linux-kernel@vger.kernel.org
Subject: zram: zsmalloc calls sleeping function from atomic context
Message-ID: <20140317144358.GA374@swordfish.minsk.epam.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello gents,

I just noticed that starting from commit

commit 3d693a5127e79e79da7c34dc0c776bc620697ce5
Author: Andrew Morton <akpm@linux-foundation.org>
Date:   Mon Mar 17 11:23:56 2014 +1100

    mm-vmalloc-avoid-soft-lockup-warnings-when-vunmaping-large-ranges-fix
    
    add a might_sleep() to catch atomic callers more promptly


and


commit 032dda8b6c4021d4be63bcc483b47fd26c6f48a2
Author: David Vrabel <david.vrabel@citrix.com>
Date:   Mon Mar 17 11:23:56 2014 +1100

    mm/vmalloc: avoid soft lockup warnings when vunmap()'ing large ranges
    
    If vunmap() is used to unmap a large (e.g., 50 GB) region, it may take
    sufficiently long that it triggers soft lockup warnings.
    
    Add a cond_resched() into vunmap_pmd_range() so the calling task may be
    resheduled after unmapping each PMD entry.  This is how zap_pmd_range()
    fixes the same problem for userspace mappings.
    
    All callers may sleep except for the APEI GHES driver (apei/ghes.c) which
    calls unmap_kernel_range_no_flush() from NMI and IRQ contexts.  This
    driver only unmaps a single pages so don't call cond_resched() if the
    unmap doesn't cross a PMD boundary.


w/ CONFIG_PGTABLE_MAPPING=y zs_unmap_object() calls unmap_kernel_range() under rwlock,
producing the following warning (basically we perform every read()/write() under
rwlock, so I can see lots of these warnings):

[  631.541177] BUG: sleeping function called from invalid context at mm/vmalloc.c:74
[  631.541181] in_atomic(): 1, irqs_disabled(): 0, pid: 94, name: kworker/u8:2
[  631.541183] Preemption disabled at:[<ffffffffa00ca0ad>] zram_bvec_rw.isra.14+0x2be/0x4fc [zram]

[  631.541193] CPU: 2 PID: 94 Comm: kworker/u8:2 Tainted: G           O  3.14.0-rc6-next-20140317-dbg-dirty #182
[  631.541195] Hardware name: Acer             Aspire 5741G    /Aspire 5741G    , BIOS V1.20 02/08/2011
[  631.541202] Workqueue: writeback bdi_writeback_workfn (flush-254:0)
[  631.541205]  0000000000000000 ffff88015211b748 ffffffff813ba01d 0000000000000000
[  631.541208]  ffff88015211b768 ffffffff81057ecb ffffc9000003e000 ffffc9000003e000
[  631.541212]  ffff88015211b7d8 ffffffff810cc491 ffffc9000003dfff ffff88015211b800
[  631.541216] Call Trace:
[  631.541223]  [<ffffffff813ba01d>] dump_stack+0x4e/0x7a
[  631.541229]  [<ffffffff81057ecb>] __might_sleep+0x14e/0x153
[  631.541234]  [<ffffffff810cc491>] vunmap_page_range+0x133/0x25d
[  631.541237]  [<ffffffff810cd81b>] unmap_kernel_range+0x16/0x26
[  631.541241]  [<ffffffff810de6f6>] zs_unmap_object+0xd8/0xff
[  631.541245]  [<ffffffffa00ca120>] zram_bvec_rw.isra.14+0x331/0x4fc [zram]
[  631.541248]  [<ffffffffa00ca439>] zram_make_request+0x14e/0x228 [zram]
[  631.541252]  [<ffffffff810a8088>] ? mempool_alloc+0x6d/0x130
[  631.541257]  [<ffffffff811e9395>] generic_make_request+0x97/0xd6
[  631.541259]  [<ffffffff811e94c6>] submit_bio+0xf2/0x131
[  631.541263]  [<ffffffff81106306>] _submit_bh+0x1c1/0x1eb
[  631.541266]  [<ffffffff8110633b>] submit_bh+0xb/0xd
[  631.541269]  [<ffffffff811078d9>] __block_write_full_page+0x1ad/0x2c8
[  631.541273]  [<ffffffff8110a118>] ? I_BDEV+0xd/0xd
[  631.541276]  [<ffffffff81105041>] ? end_buffer_write_sync+0x61/0x61
[  631.541278]  [<ffffffff8110a118>] ? I_BDEV+0xd/0xd
[  631.541282]  [<ffffffff81107bb4>] block_write_full_page_endio+0xdc/0xe8
[  631.541284]  [<ffffffff81107bd0>] block_write_full_page+0x10/0x12
[  631.541287]  [<ffffffff8110a6e5>] blkdev_writepage+0x13/0x15
[  631.541292]  [<ffffffff810acfb8>] __writepage+0xe/0x2c
[  631.541295]  [<ffffffff810ad35f>] write_cache_pages+0x25c/0x367
[  631.541297]  [<ffffffff810acfaa>] ? mapping_tagged+0xf/0xf
[  631.541301]  [<ffffffff810ad4a3>] generic_writepages+0x39/0x51
[  631.541304]  [<ffffffff810ae6d4>] do_writepages+0x19/0x27
[  631.541307]  [<ffffffff810ff6d4>] __writeback_single_inode+0x3c/0xee
[  631.541310]  [<ffffffff811000d7>] writeback_sb_inodes+0x1bf/0x2f9
[  631.541313]  [<ffffffff8110028b>] __writeback_inodes_wb+0x7a/0xb0
[  631.541316]  [<ffffffff811003c0>] wb_writeback+0xff/0x190
[  631.541319]  [<ffffffff810595f3>] ? get_parent_ip+0xd/0x3c
[  631.541322]  [<ffffffff811008f5>] bdi_writeback_workfn+0xcd/0x28d
[  631.541325]  [<ffffffff8105b32b>] ? try_to_wake_up+0x1f4/0x203
[  631.541330]  [<ffffffff8104d213>] process_one_work+0x1c9/0x2e9
[  631.541332]  [<ffffffff8104d7ad>] worker_thread+0x1d3/0x2bd
[  631.541335]  [<ffffffff8104d5da>] ? rescuer_thread+0x27d/0x27d
[  631.541338]  [<ffffffff81051e75>] kthread+0xd6/0xde
[  631.541341]  [<ffffffff81051d9f>] ? kthread_create_on_node+0x162/0x162
[  631.541345]  [<ffffffff813bf8bc>] ret_from_fork+0x7c/0xb0
[  631.541348]  [<ffffffff81051d9f>] ? kthread_create_on_node+0x162/0x162

	-ss
