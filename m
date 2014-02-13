Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752175AbaBMWLf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 17:11:35 -0500
Received: from zene.cmpxchg.org ([85.214.230.12]:60758 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751547AbaBMWLc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 17:11:32 -0500
Date: Thu, 13 Feb 2014 17:11:26 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 00/10] mm: thrash detection-based file cache sizing v9
Message-ID: <20140213221126.GP6963@cmpxchg.org>
References: <1391475222-1169-1-git-send-email-hannes@cmpxchg.org>
 <201402130321.s1D3LH41073563@www262.sakura.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201402130321.s1D3LH41073563@www262.sakura.ne.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tetsuo,

On Thu, Feb 13, 2014 at 12:21:17PM +0900, Tetsuo Handa wrote:
> Hello.
> 
> I got a lockdep warning shown below, and the bad commit seems to be de055616
> \"mm: keep page cache radix tree nodes in check\" as of next-20140212
> on linux-next.git.

Thanks for the report.  There is already a fix for this in -mm:
http://marc.info/?l=linux-mm-commits&m=139180637114625&w=2

It was merged on the 7th, so it should show up in -next... any day
now?

> Regards.
> 
> =========================================================
> [ INFO: possible irq lock inversion dependency detected ]
> 3.14.0-rc1-00099-gde05561 #126 Tainted: GF           
> ---------------------------------------------------------
> swapper/0/0 just changed the state of lock:
>  (&(&mapping->tree_lock)->rlock){..-.-.}, at: [<ffffffff8116f3e8>] test_clear_page_writeback+0x48/0x190
> but this lock took another, SOFTIRQ-unsafe lock in the past:
>  (&(&lru->node[i].lock)->rlock){+.+.-.}
> 
> and interrupts could create inverse lock ordering between them.
> 
> 
> other info that might help us debug this:
>  Possible interrupt unsafe locking scenario:
> 
>        CPU0                    CPU1
>        ----                    ----
>   lock(&(&lru->node[i].lock)->rlock);
>                                local_irq_disable();
>                                lock(&(&mapping->tree_lock)->rlock);
>                                lock(&(&lru->node[i].lock)->rlock);
>   <Interrupt>
>     lock(&(&mapping->tree_lock)->rlock);
> 
>  *** DEADLOCK ***
> 
> no locks held by swapper/0/0.
> 
> the shortest dependencies between 2nd lock and 1st lock:
>  -> (&(&lru->node[i].lock)->rlock){+.+.-.} ops: 445715 {
>     HARDIRQ-ON-W at:
>                       [<ffffffff810b6490>] mark_irqflags+0x130/0x190
>                       [<ffffffff810b7edc>] __lock_acquire+0x3bc/0x5e0
>                       [<ffffffff810b819e>] lock_acquire+0x9e/0x170
>                       [<ffffffff816305ae>] _raw_spin_lock+0x3e/0x80
>                       [<ffffffff8118c82b>] list_lru_add+0x5b/0xf0
>                       [<ffffffff811e5c1c>] dput+0xbc/0x120
>                       [<ffffffff811cebc2>] __fput+0x1d2/0x310
>                       [<ffffffff811cedae>] ____fput+0xe/0x10
>                       [<ffffffff8107cc2d>] task_work_run+0xad/0xe0
>                       [<ffffffff81003be5>] do_notify_resume+0x75/0x80
>                       [<ffffffff8163b01a>] int_signal+0x12/0x17
>     SOFTIRQ-ON-W at:
>                       [<ffffffff810b64b4>] mark_irqflags+0x154/0x190
>                       [<ffffffff810b7edc>] __lock_acquire+0x3bc/0x5e0
>                       [<ffffffff810b819e>] lock_acquire+0x9e/0x170
>                       [<ffffffff816305ae>] _raw_spin_lock+0x3e/0x80
>                       [<ffffffff8118c82b>] list_lru_add+0x5b/0xf0
>                       [<ffffffff811e5c1c>] dput+0xbc/0x120
>                       [<ffffffff811cebc2>] __fput+0x1d2/0x310
>                       [<ffffffff811cedae>] ____fput+0xe/0x10
>                       [<ffffffff8107cc2d>] task_work_run+0xad/0xe0
>                       [<ffffffff81003be5>] do_notify_resume+0x75/0x80
>                       [<ffffffff8163b01a>] int_signal+0x12/0x17
>     IN-RECLAIM_FS-W at:
>                          [<ffffffff810b6426>] mark_irqflags+0xc6/0x190
>                          [<ffffffff810b7edc>] __lock_acquire+0x3bc/0x5e0
>                          [<ffffffff810b819e>] lock_acquire+0x9e/0x170
>                          [<ffffffff816305ae>] _raw_spin_lock+0x3e/0x80
>                          [<ffffffff8118c698>] list_lru_count_node+0x28/0x70
>                          [<ffffffff811d05b3>] super_cache_count+0x83/0x120
>                          [<ffffffff81176647>] shrink_slab_node+0x47/0x350
>                          [<ffffffff811769dd>] shrink_slab+0x8d/0x160
>                          [<ffffffff81179480>] kswapd_shrink_zone+0x130/0x1c0
>                          [<ffffffff81179fe9>] balance_pgdat+0x389/0x520
>                          [<ffffffff8117b92f>] kswapd+0x1bf/0x380
>                          [<ffffffff81080abe>] kthread+0xee/0x110
>                          [<ffffffff8163ac6c>] ret_from_fork+0x7c/0xb0
>     INITIAL USE at:
>                      [<ffffffff810b7d34>] __lock_acquire+0x214/0x5e0
>                      [<ffffffff810b819e>] lock_acquire+0x9e/0x170
>                      [<ffffffff816305ae>] _raw_spin_lock+0x3e/0x80
>                      [<ffffffff8118c82b>] list_lru_add+0x5b/0xf0
>                      [<ffffffff811e5c1c>] dput+0xbc/0x120
>                      [<ffffffff811cebc2>] __fput+0x1d2/0x310
>                      [<ffffffff811cedae>] ____fput+0xe/0x10
>                      [<ffffffff8107cc2d>] task_work_run+0xad/0xe0
>                      [<ffffffff81003be5>] do_notify_resume+0x75/0x80
>                      [<ffffffff8163b01a>] int_signal+0x12/0x17
>   }
>   ... key      at: [<ffffffff82b59f34>] __key.23573+0x0/0xc
>   ... acquired at:
>    [<ffffffff810b79c1>] validate_chain+0x6e1/0x840
>    [<ffffffff810b7e87>] __lock_acquire+0x367/0x5e0
>    [<ffffffff810b819e>] lock_acquire+0x9e/0x170
>    [<ffffffff816305ae>] _raw_spin_lock+0x3e/0x80
>    [<ffffffff8118c82b>] list_lru_add+0x5b/0xf0
>    [<ffffffff81161180>] page_cache_tree_delete+0x140/0x1a0
>    [<ffffffff81161230>] __delete_from_page_cache+0x50/0x1c0
>    [<ffffffff8117571d>] __remove_mapping+0x9d/0x170
>    [<ffffffff81177347>] shrink_page_list+0x617/0x7f0
>    [<ffffffff811783aa>] shrink_inactive_list+0x26a/0x520
>    [<ffffffff81178cc6>] shrink_lruvec+0x336/0x420
>    [<ffffffff81178e0c>] shrink_zone+0x5c/0x120
>    [<ffffffff8117944b>] kswapd_shrink_zone+0xfb/0x1c0
>    [<ffffffff81179fe9>] balance_pgdat+0x389/0x520
>    [<ffffffff8117b92f>] kswapd+0x1bf/0x380
>    [<ffffffff81080abe>] kthread+0xee/0x110
>    [<ffffffff8163ac6c>] ret_from_fork+0x7c/0xb0
> 
> -> (&(&mapping->tree_lock)->rlock){..-.-.} ops: 11597 {
>    IN-SOFTIRQ-W at:
>                     [<ffffffff810b6469>] mark_irqflags+0x109/0x190
>                     [<ffffffff810b7edc>] __lock_acquire+0x3bc/0x5e0
>                     [<ffffffff810b819e>] lock_acquire+0x9e/0x170
>                     [<ffffffff81630760>] _raw_spin_lock_irqsave+0x50/0x90
>                     [<ffffffff8116f3e8>] test_clear_page_writeback+0x48/0x190
>                     [<ffffffff811604f0>] end_page_writeback+0x20/0x60
>                     [<ffffffffa00c17b8>] ext4_finish_bio+0x168/0x220 [ext4]
>                     [<ffffffffa00c1c37>] ext4_end_bio+0x97/0xe0 [ext4]
>                     [<ffffffff8120b9e3>] bio_endio+0x53/0xa0
>                     [<ffffffff812da333>] blk_update_request+0x213/0x430
>                     [<ffffffff812da577>] blk_update_bidi_request+0x27/0xb0
>                     [<ffffffff812db18f>] blk_end_bidi_request+0x2f/0x80
>                     [<ffffffff812db230>] blk_end_request+0x10/0x20
>                     [<ffffffff8143d770>] scsi_end_request+0x40/0xb0
>                     [<ffffffff8143daff>] scsi_io_completion+0x9f/0x6c0
>                     [<ffffffff81433204>] scsi_finish_command+0xd4/0x140
>                     [<ffffffff8143e28f>] scsi_softirq_done+0x14f/0x170
>                     [<ffffffff812e3144>] blk_done_softirq+0x84/0xa0
>                     [<ffffffff8105b29d>] __do_softirq+0x12d/0x430
>                     [<ffffffff8105b6d5>] irq_exit+0xc5/0xd0
>                     [<ffffffff8163cc47>] do_IRQ+0x67/0x110
>                     [<ffffffff8163156f>] ret_from_intr+0x0/0x13
>                     [<ffffffff8100dd26>] arch_cpu_idle+0x26/0x30
>                     [<ffffffff810cac39>] cpu_idle_loop+0xa9/0x3c0
>                     [<ffffffff810caf73>] cpu_startup_entry+0x23/0x30
>                     [<ffffffff81623434>] rest_init+0xf4/0x170
>                     [<ffffffff81f491dc>] start_kernel+0x346/0x34d
>                     [<ffffffff81f483a8>] x86_64_start_reservations+0x2a/0x2c
>                     [<ffffffff81f484d8>] x86_64_start_kernel+0xf5/0xfc
>    IN-RECLAIM_FS-W at:
>                        [<ffffffff810b6426>] mark_irqflags+0xc6/0x190
>                        [<ffffffff810b7edc>] __lock_acquire+0x3bc/0x5e0
>                        [<ffffffff810b819e>] lock_acquire+0x9e/0x170
>                        [<ffffffff816306d4>] _raw_spin_lock_irq+0x44/0x80
>                        [<ffffffff811756d5>] __remove_mapping+0x55/0x170
>                        [<ffffffff81177347>] shrink_page_list+0x617/0x7f0
>                        [<ffffffff811783aa>] shrink_inactive_list+0x26a/0x520
>                        [<ffffffff81178cc6>] shrink_lruvec+0x336/0x420
>                        [<ffffffff81178e0c>] shrink_zone+0x5c/0x120
>                        [<ffffffff8117944b>] kswapd_shrink_zone+0xfb/0x1c0
>                        [<ffffffff81179fe9>] balance_pgdat+0x389/0x520
>                        [<ffffffff8117b92f>] kswapd+0x1bf/0x380
>                        [<ffffffff81080abe>] kthread+0xee/0x110
>                        [<ffffffff8163ac6c>] ret_from_fork+0x7c/0xb0
>    INITIAL USE at:
>                    [<ffffffff810b7d34>] __lock_acquire+0x214/0x5e0
>                    [<ffffffff810b819e>] lock_acquire+0x9e/0x170
>                    [<ffffffff816306d4>] _raw_spin_lock_irq+0x44/0x80
>                    [<ffffffff81161810>] __add_to_page_cache_locked+0xa0/0x1d0
>                    [<ffffffff81161968>] add_to_page_cache_lru+0x28/0x80
>                    [<ffffffff81162c28>] grab_cache_page_write_begin+0x98/0xe0
>                    [<ffffffff811f95e4>] simple_write_begin+0x34/0x100
>                    [<ffffffff8115fc9a>] generic_perform_write+0xca/0x210
>                    [<ffffffff8115fe43>] generic_file_buffered_write+0x63/0xa0
>                    [<ffffffff81163aea>] __generic_file_aio_write+0x1ca/0x3c0
>                    [<ffffffff81163d46>] generic_file_aio_write+0x66/0xb0
>                    [<ffffffff811cc20f>] do_sync_write+0x5f/0xa0
>                    [<ffffffff811ce127>] vfs_write+0xc7/0x1f0
>                    [<ffffffff811ce362>] SyS_write+0x62/0xb0
>                    [<ffffffff81f4b0c6>] do_copy+0x2b/0xb0
>                    [<ffffffff81f4ad46>] flush_buffer+0x7d/0xa3
>                    [<ffffffff81f7e9ab>] gunzip+0x287/0x330
>                    [<ffffffff81f4b967>] unpack_to_rootfs+0x167/0x293
>                    [<ffffffff81f4bb97>] populate_rootfs+0x62/0xdf
>                    [<ffffffff810002a2>] do_one_initcall+0xd2/0x180
>                    [<ffffffff81f48933>] do_basic_setup+0x9d/0xc0
>                    [<ffffffff81f48bd6>] kernel_init_freeable+0x280/0x303
>                    [<ffffffff816234be>] kernel_init+0xe/0x130
>                    [<ffffffff8163ac6c>] ret_from_fork+0x7c/0xb0
>  }
>  ... key      at: [<ffffffff82bb7f98>] __key.41448+0x0/0x8
>  ... acquired at:
>    [<ffffffff810b51f0>] check_usage_forwards+0x90/0x110
>    [<ffffffff810b5f4f>] mark_lock_irq+0x9f/0x2c0
>    [<ffffffff810b628c>] mark_lock+0x11c/0x1f0
>    [<ffffffff810b6469>] mark_irqflags+0x109/0x190
>    [<ffffffff810b7edc>] __lock_acquire+0x3bc/0x5e0
>    [<ffffffff810b819e>] lock_acquire+0x9e/0x170
>    [<ffffffff81630760>] _raw_spin_lock_irqsave+0x50/0x90
>    [<ffffffff8116f3e8>] test_clear_page_writeback+0x48/0x190
>    [<ffffffff811604f0>] end_page_writeback+0x20/0x60
>    [<ffffffffa00c17b8>] ext4_finish_bio+0x168/0x220 [ext4]
>    [<ffffffffa00c1c37>] ext4_end_bio+0x97/0xe0 [ext4]
>    [<ffffffff8120b9e3>] bio_endio+0x53/0xa0
>    [<ffffffff812da333>] blk_update_request+0x213/0x430
>    [<ffffffff812da577>] blk_update_bidi_request+0x27/0xb0
>    [<ffffffff812db18f>] blk_end_bidi_request+0x2f/0x80
>    [<ffffffff812db230>] blk_end_request+0x10/0x20
>    [<ffffffff8143d770>] scsi_end_request+0x40/0xb0
>    [<ffffffff8143daff>] scsi_io_completion+0x9f/0x6c0
>    [<ffffffff81433204>] scsi_finish_command+0xd4/0x140
>    [<ffffffff8143e28f>] scsi_softirq_done+0x14f/0x170
>    [<ffffffff812e3144>] blk_done_softirq+0x84/0xa0
>    [<ffffffff8105b29d>] __do_softirq+0x12d/0x430
>    [<ffffffff8105b6d5>] irq_exit+0xc5/0xd0
>    [<ffffffff8163cc47>] do_IRQ+0x67/0x110
>    [<ffffffff8163156f>] ret_from_intr+0x0/0x13
>    [<ffffffff8100dd26>] arch_cpu_idle+0x26/0x30
>    [<ffffffff810cac39>] cpu_idle_loop+0xa9/0x3c0
>    [<ffffffff810caf73>] cpu_startup_entry+0x23/0x30
>    [<ffffffff81623434>] rest_init+0xf4/0x170
>    [<ffffffff81f491dc>] start_kernel+0x346/0x34d
>    [<ffffffff81f483a8>] x86_64_start_reservations+0x2a/0x2c
>    [<ffffffff81f484d8>] x86_64_start_kernel+0xf5/0xfc
> 
> 
> stack backtrace:
> CPU: 0 PID: 0 Comm: swapper/0 Tainted: GF            3.14.0-rc1-00099-gde05561 #126
> Hardware name: VMware, Inc. VMware Virtual Platform/440BX Desktop Reference Platform, BIOS 6.00 09/20/2012
>  ffffffff8233b140 ffff8800792038d8 ffffffff8162aa99 0000000000000002
>  ffffffff8233b140 ffff880079203928 ffffffff810b5118 ffffffff81a08d4a
>  ffffffff81a08d4a ffff880079203928 ffffffff81c110a8 ffff880079203938
> Call Trace:
>  <IRQ>  [<ffffffff8162aa99>] dump_stack+0x51/0x70
>  [<ffffffff810b5118>] print_irq_inversion_bug+0x1c8/0x210
>  [<ffffffff810b51f0>] check_usage_forwards+0x90/0x110
>  [<ffffffff8107cec8>] ? __kernel_text_address+0x58/0x80
>  [<ffffffff810b5160>] ? print_irq_inversion_bug+0x210/0x210
>  [<ffffffff810b5f4f>] mark_lock_irq+0x9f/0x2c0
>  [<ffffffff810b628c>] mark_lock+0x11c/0x1f0
>  [<ffffffff810b6469>] mark_irqflags+0x109/0x190
>  [<ffffffff810b7edc>] __lock_acquire+0x3bc/0x5e0
>  [<ffffffff810b819e>] lock_acquire+0x9e/0x170
>  [<ffffffff8116f3e8>] ? test_clear_page_writeback+0x48/0x190
>  [<ffffffff81048aed>] ? __change_page_attr_set_clr+0x4d/0xb0
>  [<ffffffff81630760>] _raw_spin_lock_irqsave+0x50/0x90
>  [<ffffffff8116f3e8>] ? test_clear_page_writeback+0x48/0x190
>  [<ffffffff8116f3e8>] test_clear_page_writeback+0x48/0x190
>  [<ffffffffa00c1825>] ? ext4_finish_bio+0x1d5/0x220 [ext4]
>  [<ffffffff811604f0>] end_page_writeback+0x20/0x60
>  [<ffffffffa00c17b8>] ext4_finish_bio+0x168/0x220 [ext4]
>  [<ffffffffa00c18ec>] ? ext4_release_io_end+0x7c/0x100 [ext4]
>  [<ffffffff812da079>] ? blk_account_io_completion+0x119/0x1c0
>  [<ffffffffa00c1c37>] ext4_end_bio+0x97/0xe0 [ext4]
>  [<ffffffff8120b9e3>] bio_endio+0x53/0xa0
>  [<ffffffff812da333>] blk_update_request+0x213/0x430
>  [<ffffffff812da577>] blk_update_bidi_request+0x27/0xb0
>  [<ffffffff812db18f>] blk_end_bidi_request+0x2f/0x80
>  [<ffffffff812db230>] blk_end_request+0x10/0x20
>  [<ffffffff8143d770>] scsi_end_request+0x40/0xb0
>  [<ffffffff816310c0>] ? _raw_spin_unlock_irqrestore+0x40/0x70
>  [<ffffffff8143daff>] scsi_io_completion+0x9f/0x6c0
>  [<ffffffff810b6add>] ? trace_hardirqs_on+0xd/0x10
>  [<ffffffff81433204>] scsi_finish_command+0xd4/0x140
>  [<ffffffff8143e28f>] scsi_softirq_done+0x14f/0x170
>  [<ffffffff812e3144>] blk_done_softirq+0x84/0xa0
>  [<ffffffff8105b29d>] __do_softirq+0x12d/0x430
>  [<ffffffff8105b6d5>] irq_exit+0xc5/0xd0
>  [<ffffffff8163cc47>] do_IRQ+0x67/0x110
>  [<ffffffff8163156f>] common_interrupt+0x6f/0x6f
>  <EOI>  [<ffffffff8100e426>] ? default_idle+0x26/0x210
>  [<ffffffff8100e424>] ? default_idle+0x24/0x210
>  [<ffffffff8100dd26>] arch_cpu_idle+0x26/0x30
>  [<ffffffff810cac39>] cpu_idle_loop+0xa9/0x3c0
>  [<ffffffff810caf73>] cpu_startup_entry+0x23/0x30
>  [<ffffffff81623434>] rest_init+0xf4/0x170
>  [<ffffffff81623340>] ? csum_partial_copy_generic+0x170/0x170
>  [<ffffffff81f491dc>] start_kernel+0x346/0x34d
>  [<ffffffff81f48cb4>] ? repair_env_string+0x5b/0x5b
>  [<ffffffff816293ea>] ? memblock_reserve+0x49/0x4e
>  [<ffffffff81f483a8>] x86_64_start_reservations+0x2a/0x2c
>  [<ffffffff81f484d8>] x86_64_start_kernel+0xf5/0xfc
