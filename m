Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751781AbaGGXd2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 19:33:28 -0400
Received: from lgeamrelo04.lge.com ([156.147.1.127]:49827 "EHLO
	lgeamrelo04.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751077AbaGGXd0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 19:33:26 -0400
X-Original-SENDERIP: 10.177.220.169
X-Original-MAILFROM: minchan@kernel.org
Date: Tue, 8 Jul 2014 08:33:26 +0900
From: Minchan Kim <minchan@kernel.org>
To: Zheng Liu <wenqing.lz@taobao.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>, Jan kara <jack@suse.cz>,
        linux-kernel@vger.kernel.org
Subject: ext4: lockdep splash
Message-ID: <20140707233326.GA6076@bbox>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

When I tested recent mmotm with memory stress, I found this.
It seems to be related to [ext4: reclaim extents from extent status tree].
Please take a look.

<snip>
[  376.297372] SLUB: Unable to allocate memory on node -1 (gfp=0x20)
[  376.297372]   cache: ext4_extent_status, object size: 40, buffer size: 40, default order: 0, min order: 0
[  376.297372]   node 0: slabs: 115, objs: 11730, free: 0
[  376.366605] 
[  376.367022] ======================================================
[  376.369411] [ INFO: possible circular locking dependency detected ]
[  376.370494] 3.16.0-rc2-mm1+ #7 Tainted: G           O  
[  376.370580] -------------------------------------------------------
[  376.370580] kworker/u24:0/4356 is trying to acquire lock:
[  376.370580]  (&(&sbi->s_es_lru_lock)->rlock){+.+.-.}, at: [<ffffffff81285fff>] __ext4_es_shrink+0x4f/0x2e0
[  376.370580] 
[  376.370580] but task is already holding lock:
[  376.376397]  (&ei->i_es_lock){++++-.}, at: [<ffffffff81286961>] ext4_es_insert_extent+0x71/0x180
[  376.376397] 
[  376.376397] which lock already depends on the new lock.
[  376.376397] 
[  376.376397] 
[  376.376397] the existing dependency chain (in reverse order) is:
[  376.376397] 
-> #1 (&ei->i_es_lock){++++-.}:
[  376.376397]        [<ffffffff810a8707>] lock_acquire+0x87/0x120
[  376.376397]        [<ffffffff815e72f9>] _raw_write_lock+0x39/0x50
[  376.376397]        [<ffffffff812861cd>] __ext4_es_shrink+0x21d/0x2e0
[  376.376397]        [<ffffffff81286649>] ext4_es_scan+0xc9/0x150
[  376.376397]        [<ffffffff8115437e>] shrink_slab_node+0x14e/0x2f0
[  376.376397]        [<ffffffff81155f6a>] shrink_slab+0x8a/0x140
[  376.376397]        [<ffffffff812035e3>] drop_caches_sysctl_handler+0x73/0x110
[  376.376397]        [<ffffffff8121690c>] proc_sys_call_handler+0xbc/0xd0
[  376.376397]        [<ffffffff81216934>] proc_sys_write+0x14/0x20
[  376.376397]        [<ffffffff811a6ad7>] vfs_write+0xc7/0x1f0
[  376.376397]        [<ffffffff811a6fe2>] SyS_write+0x52/0xb0
[  376.376397]        [<ffffffff815e7dd2>] system_call_fastpath+0x16/0x1b
[  376.376397] 
-> #0 (&(&sbi->s_es_lru_lock)->rlock){+.+.-.}:
[  376.376397]        [<ffffffff810a7a3e>] __lock_acquire+0x163e/0x1d00
[  376.376397]        [<ffffffff810a8707>] lock_acquire+0x87/0x120
[  376.376397]        [<ffffffff815e6f09>] _raw_spin_lock+0x39/0x50
[  376.376397]        [<ffffffff81285fff>] __ext4_es_shrink+0x4f/0x2e0
[  376.376397]        [<ffffffff812869b8>] ext4_es_insert_extent+0xc8/0x180
[  376.376397]        [<ffffffff812470f4>] ext4_map_blocks+0x1c4/0x550
[  376.376397]        [<ffffffff8124c4c4>] ext4_writepages+0x6d4/0xd00
[  376.376397]        [<ffffffff8114fd33>] do_writepages+0x23/0x40
[  376.376397]        [<ffffffff811d0535>] __writeback_single_inode+0x45/0x2e0
[  376.376397]        [<ffffffff811d1cad>] writeback_sb_inodes+0x2ad/0x4f0
[  376.376397]        [<ffffffff811d1f8e>] __writeback_inodes_wb+0x9e/0xd0
[  376.376397]        [<ffffffff811d225b>] wb_writeback+0x29b/0x350
[  376.376397]        [<ffffffff811d4702>] bdi_writeback_workfn+0x122/0x490
[  376.376397]        [<ffffffff81071d62>] process_one_work+0x1e2/0x560
[  376.376397]        [<ffffffff81072b7c>] worker_thread+0x11c/0x520
[  376.376397]        [<ffffffff81079e54>] kthread+0xe4/0x100
[  376.376397]        [<ffffffff815e7d2c>] ret_from_fork+0x7c/0xb0
[  376.376397] 
[  376.376397] other info that might help us debug this:
[  376.376397] 
[  376.376397]  Possible unsafe locking scenario:
[  376.376397] 
[  376.376397]        CPU0                    CPU1
[  376.376397]        ----                    ----
[  376.376397]   lock(&ei->i_es_lock);
[  376.376397]                                lock(&(&sbi->s_es_lru_lock)->rlock);
[  376.376397]                                lock(&ei->i_es_lock);
[  376.376397]   lock(&(&sbi->s_es_lru_lock)->rlock);
[  376.376397] 
[  376.376397]  *** DEADLOCK ***
[  376.376397] 
[  376.376397] 6 locks held by kworker/u24:0/4356:
[  376.376397]  #0:  ("writeback"){.+.+.+}, at: [<ffffffff81071d00>] process_one_work+0x180/0x560
[  376.376397]  #1:  ((&(&wb->dwork)->work)){+.+.+.}, at: [<ffffffff81071d00>] process_one_work+0x180/0x560
[  376.376397]  #2:  (&type->s_umount_key#22){++++++}, at: [<ffffffff811a9c74>] grab_super_passive+0x44/0x90
[  376.376397]  #3:  (jbd2_handle){+.+...}, at: [<ffffffff812979f9>] start_this_handle+0x189/0x5f0
[  376.376397]  #4:  (&ei->i_data_sem){++++..}, at: [<ffffffff81247062>] ext4_map_blocks+0x132/0x550
[  376.376397]  #5:  (&ei->i_es_lock){++++-.}, at: [<ffffffff81286961>] ext4_es_insert_extent+0x71/0x180
[  376.376397] 
[  376.376397] stack backtrace:
[  376.376397] CPU: 0 PID: 4356 Comm: kworker/u24:0 Tainted: G           O   3.16.0-rc2-mm1+ #7
[  376.376397] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[  376.376397] Workqueue: writeback bdi_writeback_workfn (flush-253:0)
[  376.376397]  ffffffff8213dce0 ffff880014b07538 ffffffff815df0bb 0000000000000007
[  376.376397]  ffffffff8213e040 ffff880014b07588 ffffffff815db3dd ffff880014b07568
[  376.376397]  ffff880014b07610 ffff88003b868930 ffff88003b868908 ffff88003b868930
[  376.376397] Call Trace:
[  376.376397]  [<ffffffff815df0bb>] dump_stack+0x4e/0x68
[  376.376397]  [<ffffffff815db3dd>] print_circular_bug+0x1fb/0x20c
[  376.376397]  [<ffffffff810a7a3e>] __lock_acquire+0x163e/0x1d00
[  376.376397]  [<ffffffff815e89dc>] ? retint_restore_args+0xe/0xe
[  376.376397]  [<ffffffff815ddc7b>] ? __slab_alloc+0x4a8/0x4ce
[  376.376397]  [<ffffffff81285fff>] ? __ext4_es_shrink+0x4f/0x2e0
[  376.376397]  [<ffffffff810a8707>] lock_acquire+0x87/0x120
[  376.376397]  [<ffffffff81285fff>] ? __ext4_es_shrink+0x4f/0x2e0
[  376.376397]  [<ffffffff8128592d>] ? ext4_es_free_extent+0x5d/0x70
[  376.376397]  [<ffffffff815e6f09>] _raw_spin_lock+0x39/0x50
[  376.376397]  [<ffffffff81285fff>] ? __ext4_es_shrink+0x4f/0x2e0
[  376.376397]  [<ffffffff8119760b>] ? kmem_cache_alloc+0x18b/0x1a0
[  376.376397]  [<ffffffff81285fff>] __ext4_es_shrink+0x4f/0x2e0
[  376.376397]  [<ffffffff812869b8>] ext4_es_insert_extent+0xc8/0x180
[  376.376397]  [<ffffffff812470f4>] ext4_map_blocks+0x1c4/0x550
[  376.376397]  [<ffffffff8124c4c4>] ext4_writepages+0x6d4/0xd00
[  376.376397]  [<ffffffff810a8248>] ? lock_release_non_nested+0x148/0x340
[  376.376397]  [<ffffffff811d1b39>] ? writeback_sb_inodes+0x139/0x4f0
[  376.376397]  [<ffffffff8114fd33>] do_writepages+0x23/0x40
[  376.376397]  [<ffffffff811d0535>] __writeback_single_inode+0x45/0x2e0
[  376.376397]  [<ffffffff811d1cad>] writeback_sb_inodes+0x2ad/0x4f0
[  376.376397]  [<ffffffff811d2014>] ? wb_writeback+0x54/0x350
[  376.376397]  [<ffffffff811d1f8e>] __writeback_inodes_wb+0x9e/0xd0
[  376.376397]  [<ffffffff811d225b>] wb_writeback+0x29b/0x350
[  376.376397]  [<ffffffff81059b7d>] ? __local_bh_enable_ip+0x6d/0xd0
[  376.376397]  [<ffffffff810a9115>] ? trace_hardirqs_on_caller+0x105/0x1d0
[  376.376397]  [<ffffffff810a91ed>] ? trace_hardirqs_on+0xd/0x10
[  376.376397]  [<ffffffff811d4702>] bdi_writeback_workfn+0x122/0x490
[  376.376397]  [<ffffffff81071d00>] ? process_one_work+0x180/0x560
[  376.376397]  [<ffffffff815e7630>] ? _raw_spin_unlock_irq+0x30/0x40
[  376.376397]  [<ffffffff81071d62>] process_one_work+0x1e2/0x560
[  376.376397]  [<ffffffff81071d00>] ? process_one_work+0x180/0x560
[  376.376397]  [<ffffffff81072b7c>] worker_thread+0x11c/0x520
[  376.376397]  [<ffffffff815e7681>] ? _raw_spin_unlock_irqrestore+0x41/0x70
[  376.376397]  [<ffffffff81072a60>] ? create_and_start_worker+0x50/0x50
[  376.376397]  [<ffffffff81079e54>] kthread+0xe4/0x100
[  376.376397]  [<ffffffff81079d70>] ? flush_kthread_worker+0x130/0x130
[  376.376397]  [<ffffffff815e7d2c>] ret_from_fork+0x7c/0xb0
[  376.376397]  [<ffffffff81079d70>] ? flush_kthread_worker+0x130/0x130
[  376.958663] Clocksource tsc unstable (delta = 208144855 ns)
[  376.959926] Switched to clocksource refined-jiffies
[ 1051.275540] cc1: page allocation failure: order:0, mode:0x120
[ 1051.276381] CPU: 2 PID: 8177 Comm: cc1 Tainted: G           O   3.16.0-rc2-mm1+ #7
[ 1051.277427] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[ 1051.278064]  0000000000000000 ffff88003fc43a98 ffffffff815df0bb ffff88003fc4ee98
[ 1051.279576]  0000000000000120 ffff88003fc43b28 ffffffff81148cbe 0000000000000000
[ 1051.281541]  ffffffff00000000 ff00880000000000 ffff8800175a0550 ffff88003fffbe28
[ 1051.282998] Call Trace:
[ 1051.283692]  <IRQ>  [<ffffffff815df0bb>] dump_stack+0x4e/0x68
[ 1051.284732]  [<ffffffff81148cbe>] warn_alloc_failed+0xee/0x140
[ 1051.286070]  [<ffffffff8114d2ee>] __alloc_pages_nodemask+0x99e/0xbe0
[ 1051.287012]  [<ffffffff8156b2b1>] ? ip_local_deliver_finish+0x41/0x150
[ 1051.288541]  [<ffffffff8118c08b>] alloc_pages_current+0x10b/0x1f0
[ 1051.289643]  [<ffffffff8151dbd2>] ? skb_page_frag_refill+0x82/0xd0
[ 1051.290310]  [<ffffffff8151dbd2>] skb_page_frag_refill+0x82/0xd0
[ 1051.290961]  [<ffffffff8146f7bf>] try_fill_recv+0x2ff/0x5c0
[ 1051.291824]  [<ffffffff8146ebd0>] ? page_to_skb+0x240/0x280
[ 1051.292647]  [<ffffffff814716d6>] virtnet_poll+0x1e6/0x7c0
[ 1051.294075]  [<ffffffff815349a8>] net_rx_action+0xb8/0x1e0
[ 1051.294989]  [<ffffffff810597ef>] __do_softirq+0x10f/0x350
[ 1051.295831]  [<ffffffff81059cf6>] irq_exit+0x96/0xc0
[ 1051.296755]  [<ffffffff815ea747>] do_IRQ+0x67/0x110
[ 1051.298070]  [<ffffffff815e892f>] common_interrupt+0x6f/0x6f
[ 1051.300512]  <EOI>  [<ffffffff815e89dc>] ? retint_restore_args+0xe/0xe
[ 1051.302088]  [<ffffffff810cd4c2>] ? generic_exec_single+0xe2/0x180
[ 1051.303262]  [<ffffffff810cd4a6>] ? generic_exec_single+0xc6/0x180
[ 1051.304683]  [<ffffffff81049010>] ? do_flush_tlb_all+0x70/0x70
[ 1051.306071]  [<ffffffff81049010>] ? do_flush_tlb_all+0x70/0x70
[ 1051.307147]  [<ffffffff81049010>] ? do_flush_tlb_all+0x70/0x70
[ 1051.308222]  [<ffffffff810cd5f7>] smp_call_function_single+0x67/0xb0
[ 1051.309340]  [<ffffffff81304098>] ? cpumask_next_and+0x38/0x50
[ 1051.310071]  [<ffffffff810cdb6f>] smp_call_function_many+0x21f/0x260
[ 1051.310987]  [<ffffffff810490ee>] native_flush_tlb_others+0x2e/0x30
[ 1051.312041]  [<ffffffff81049369>] flush_tlb_page+0x69/0xb0
[ 1051.312823]  [<ffffffff8117f7df>] ptep_clear_flush+0x2f/0x40
[ 1051.314078]  [<ffffffff81179fdf>] try_to_unmap_one+0xaf/0x420
[ 1051.314934]  [<ffffffff8117ae05>] ? page_lock_anon_vma_read+0x5/0x1d0
[ 1051.315849]  [<ffffffff8117b481>] rmap_walk+0x261/0x3f0
[ 1051.316583]  [<ffffffff8117b6d3>] try_to_unmap+0x73/0xa0
[ 1051.317345]  [<ffffffff81179f30>] ? page_remove_rmap+0xd0/0xd0
[ 1051.318069]  [<ffffffff81179440>] ? invalid_mkclean_vma+0x20/0x20
[ 1051.318925]  [<ffffffff8117a350>] ? try_to_unmap_one+0x420/0x420
[ 1051.319757]  [<ffffffff8117ae00>] ? anon_vma_clone+0x1a0/0x1a0
[ 1051.320693]  [<ffffffff81156b01>] shrink_page_list+0x301/0xa40
[ 1051.321623]  [<ffffffff81157885>] shrink_inactive_list+0x265/0x500
[ 1051.322071]  [<ffffffff811583ed>] shrink_lruvec+0x58d/0x6d0
[ 1051.323361]  [<ffffffff8115857c>] shrink_zone+0x4c/0x110
[ 1051.324360]  [<ffffffff81158add>] do_try_to_free_pages+0x19d/0x3d0
[ 1051.326071]  [<ffffffff811547aa>] ? throttle_direct_reclaim+0x8a/0x240
[ 1051.327112]  [<ffffffff81158dd4>] try_to_free_pages+0xc4/0x190
[ 1051.328095]  [<ffffffff8114d133>] __alloc_pages_nodemask+0x7e3/0xbe0
[ 1051.329130]  [<ffffffff8116fc9a>] ? handle_mm_fault+0x9ea/0xc60
[ 1051.330072]  [<ffffffff8118dac2>] alloc_pages_vma+0xf2/0x1c0
[ 1051.331000]  [<ffffffff8116fc0b>] ? handle_mm_fault+0x95b/0xc60
[ 1051.332144]  [<ffffffff8116fc0b>] handle_mm_fault+0x95b/0xc60
[ 1051.333187]  [<ffffffff811e5f52>] ? fsnotify+0x82/0x2c0
[ 1051.334074]  [<ffffffff81042db2>] __do_page_fault+0x1c2/0x580
[ 1051.335158]  [<ffffffff811e60c2>] ? fsnotify+0x1f2/0x2c0
[ 1051.336086]  [<ffffffff811e5f52>] ? fsnotify+0x82/0x2c0
[ 1051.337098]  [<ffffffff813118dd>] ? trace_hardirqs_off_thunk+0x3a/0x3c
[ 1051.338097]  [<ffffffff810432ac>] do_page_fault+0xc/0x10
[ 1051.339087]  [<ffffffff815e99b2>] page_fault+0x22/0x30
[ 1051.340099] Mem-Info:
[ 1051.340496] Node 0 DMA per-cpu:
[ 1051.342069] CPU    0: hi:    0, btch:   1 usd:   0
[ 1051.342993] CPU    1: hi:    0, btch:   1 usd:   0
[ 1051.343766] CPU    2: hi:    0, btch:   1 usd:   0
[ 1051.344551] CPU    3: hi:    0, btch:   1 usd:   0
[ 1051.345336] CPU    4: hi:    0, btch:   1 usd:   0
[ 1051.346069] CPU    5: hi:    0, btch:   1 usd:   0
[ 1051.346869] CPU    6: hi:    0, btch:   1 usd:   0
[ 1051.347652] CPU    7: hi:    0, btch:   1 usd:   0
[ 1051.348449] CPU    8: hi:    0, btch:   1 usd:   0
[ 1051.349233] CPU    9: hi:    0, btch:   1 usd:   0
[ 1051.350069] CPU   10: hi:    0, btch:   1 usd:   0
[ 1051.350901] CPU   11: hi:    0, btch:   1 usd:   0
[ 1051.351691] Node 0 DMA32 per-cpu:
[ 1051.352256] CPU    0: hi:  186, btch:  31 usd:  43
[ 1051.353022] CPU    1: hi:  186, btch:  31 usd: 177
[ 1051.354069] CPU    2: hi:  186, btch:  31 usd:   0
[ 1051.354842] CPU    3: hi:  186, btch:  31 usd:  70
[ 1051.355760] CPU    4: hi:  186, btch:  31 usd:   0
[ 1051.356548] CPU    5: hi:  186, btch:  31 usd:  27
[ 1051.357307] CPU    6: hi:  186, btch:  31 usd:  40
[ 1051.358069] CPU    7: hi:  186, btch:  31 usd:  61
[ 1051.358857] CPU    8: hi:  186, btch:  31 usd:   0
[ 1051.359620] CPU    9: hi:  186, btch:  31 usd: 184
[ 1051.360409] CPU   10: hi:  186, btch:  31 usd: 184
[ 1051.361199] CPU   11: hi:  186, btch:  31 usd:  32
[ 1051.362073] active_anon:72458 inactive_anon:51807 isolated_anon:73
[ 1051.362073]  active_file:5881 inactive_file:1831 isolated_file:74
[ 1051.362073]  unevictable:0 dirty:0 writeback:0 unstable:0
[ 1051.362073]  free:22713 slab_reclaimable:9163 slab_unreclaimable:9568
[ 1051.362073]  mapped:3543 shmem:0 pagetables:7808 bounce:0
[ 1051.362073]  free_cma:0
[ 1051.366072] Node 0 DMA free:4736kB min:712kB low:888kB high:1068kB active_anon:2516kB inactive_anon:2732kB active_file:768kB inactive_file:212kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15992kB managed:15908kB mlocked:0kB dirty:0kB writeback:0kB mapped:520kB shmem:0kB slab_reclaimable:656kB slab_unreclaimable:904kB kernel_stack:1360kB pagetables:432kB unstable:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:32 all_unreclaimable? no
[ 1051.374072] lowmem_reserve[]: 0 964 964 964
[ 1051.374944] Node 0 DMA32 free:79216kB min:44340kB low:55424kB high:66508kB active_anon:290844kB inactive_anon:206512kB active_file:22756kB inactive_file:7112kB unevictable:0kB isolated(anon):292kB isolated(file):296kB present:1032188kB managed:989844kB mlocked:0kB dirty:0kB writeback:0kB mapped:13652kB shmem:0kB slab_reclaimable:35996kB slab_unreclaimable:37368kB kernel_stack:7600kB pagetables:30800kB unstable:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:128 all_unreclaimable? no
[ 1051.382071] lowmem_reserve[]: 0 0 0 0
[ 1051.382776] Node 0 DMA: 62*4kB (UM) 121*8kB (UM) 89*16kB (UMR) 3*32kB (MR) 1*64kB (R) 1*128kB (R) 1*256kB (R) 1*512kB (R) 1*1024kB (R) 0*2048kB 0*4096kB = 4720kB
[ 1051.386371] Node 0 DMA32: 5227*4kB (UEM) 5060*8kB (UEM) 442*16kB (UM) 30*32kB (UMR) 6*64kB (M) 2*128kB (MR) 1*256kB (R) 1*512kB (R) 1*1024kB (R) 1*2048kB (R) 0*4096kB = 73900kB
[ 1051.389406] Node 0 hugepages_total=0 hugepages_free=0 hugepages_surp=0 hugepages_size=2048kB
[ 1051.390072] 23477 total pagecache pages
[ 1051.390689] 15386 pages in swap cache
[ 1051.391313] Swap cache stats: add 20421292, delete 20405850, find 472327/5900497
[ 1051.392471] Free swap  = 1276976kB
[ 1051.393020] Total swap = 2047996kB
[ 1051.394072] 262045 pages RAM
[ 1051.394543] 0 pages HighMem/MovableOnly
[ 1051.395251] 10586 pages reserved
[ 1051.395777] 0 pages hwpoisoned
[ 1630.140673] ld invoked oom-killer: gfp_mask=0x200da, order=0, oom_score_adj=0
[ 1630.142251] ld cpuset=/ mems_allowed=0
[ 1630.142661] CPU: 3 PID: 19270 Comm: ld Tainted: G           O   3.16.0-rc2-mm1+ #7
[ 1630.143410] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[ 1630.143978]  0000000000000000 ffff88002bf775a8 ffffffff815df0bb 0000000000000006
[ 1630.144779]  ffff88003c6e2110 ffff88002bf77648 ffffffff815dc13d 0000000000000206
....



-- 
Kind regards,
Minchan Kim
