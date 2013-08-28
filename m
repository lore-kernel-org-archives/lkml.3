Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752869Ab3H1Dh5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 23:37:57 -0400
Received: from mail-pb0-f52.google.com ([209.85.160.52]:63886 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751807Ab3H1Dhz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 23:37:55 -0400
MIME-Version: 1.0
In-Reply-To: <521BAACB.4070003@profihost.ag>
References: <520C788A.1060208@profihost.ag>
	<520DFAB4.1050402@profihost.ag>
	<52114614.4070509@profihost.ag>
	<20130819222718.GA32104@kmo-pixel>
	<52132243.8050803@profihost.ag>
	<521323D1.1070503@profihost.ag>
	<20130821234715.GA4630@moria.home.lan>
	<5215A130.9080508@profihost.ag>
	<20130822054336.GA14935@kmo-pixel>
	<5215A8A8.90900@profihost.ag>
	<20130822060215.GB14935@kmo-pixel>
	<5215BEA4.6040101@profihost.ag>
	<521BAACB.4070003@profihost.ag>
Date: Tue, 27 Aug 2013 20:37:54 -0700
Message-ID: <CAFkUHxeAUvv-nhSZSDRVwdm8SoNhHD8oSBKqDYnEO3bNAKLG6w@mail.gmail.com>
Subject: Re: bcache: Fix a writeback performance regression
From: kernel neophyte <neophyte.hacker001@gmail.com>
To: Stefan Priebe <s.priebe@profihost.ag>
Cc: Kent Overstreet <kmo@daterainc.com>, Jens Axboe <axboe@kernel.dk>,
        linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kent,

I am still seeing deadlock:

[  930.169234] bcache: bch_cached_dev_attach() Caching sda3 as bcache0
on set 06496904-10ca-489a-ae75-68c6a07d3db1
[ 2522.956188] INFO: task bcache_writebac:2058 blocked for more than
120 seconds.
[ 2522.956199] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[ 2522.956205] bcache_writebac D ffffffff81813a60     0  2058      2 0x00000000
[ 2522.956212]  ffff881c39c1fcd8 0000000000000046 0000000000000001
0000000000000001
[ 2522.956218]  ffff882f8b56b320 ffff881c39c1ffd8 ffff881c39c1ffd8
ffff881c39c1ffd8
[ 2522.956222]  ffff882fa6aeb320 ffff882f8b56b320 ffff882f8b56b320
ffff882f8b56b320
[ 2522.956227] Call Trace:
[ 2522.956241]  [<ffffffff816be299>] schedule+0x29/0x70
[ 2522.956247]  [<ffffffff816befb5>] rwsem_down_write_failed+0xf5/0x1a0
[ 2522.956255]  [<ffffffff81332c93>] call_rwsem_down_write_failed+0x13/0x20
[ 2522.956261]  [<ffffffff816bcc41>] ? down_write+0x31/0x40
[ 2522.956269]  [<ffffffff8151b782>] bch_writeback_thread+0x62/0x7f0
[ 2522.956278]  [<ffffffff8108458b>] ? idle_balance+0xeb/0x150
[ 2522.956284]  [<ffffffff8151b720>] ? write_dirty+0xc0/0xc0
[ 2522.956290]  [<ffffffff81069f40>] kthread+0xc0/0xd0
[ 2522.956294]  [<ffffffff81069e80>] ? flush_kthread_worker+0xb0/0xb0
[ 2522.956302]  [<ffffffff816c795c>] ret_from_fork+0x7c/0xb0
[ 2522.956306]  [<ffffffff81069e80>] ? flush_kthread_worker+0xb0/0xb0
[ 2522.956313] INFO: task kworker/u64:1:2433 blocked for more than 120 seconds.
[ 2522.956317] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[ 2522.956322] kworker/u64:1   D ffffffff81813a60     0  2433      2 0x00000000
[ 2522.956332] Workqueue: writeback bdi_writeback_workfn (flush-252:0)
[ 2522.956336]  ffff882f899d1560 0000000000000046 ffffffff81120635
0000000000000100
[ 2522.956340]  ffff88219b488000 ffff882f899d1fd8 ffff882f899d1fd8
ffff882f899d1fd8
[ 2522.956345]  ffff882fa6aeb320 ffff88219b488000 ffffffff8131ad55
ffff88219b488000
[ 2522.956349] Call Trace:
[ 2522.956359]  [<ffffffff81120635>] ? mempool_alloc_slab+0x15/0x20
[ 2522.956367]  [<ffffffff8131ad55>] ? blk_throtl_bio+0x3b5/0x540
[ 2522.956372]  [<ffffffff816be299>] schedule+0x29/0x70
[ 2522.956378]  [<ffffffff816bf0fd>] rwsem_down_read_failed+0x9d/0xe5
[ 2522.956383]  [<ffffffff81332c64>] call_rwsem_down_read_failed+0x14/0x30
[ 2522.956388]  [<ffffffff816bcc74>] ? down_read+0x24/0x2b
[ 2522.956394]  [<ffffffff8151fe32>] cached_dev_make_request+0x752/0xf00
[ 2522.956400]  [<ffffffff81301af8>] ? generic_make_request_checks+0x1e8/0x3a0
[ 2522.956405]  [<ffffffff81301d7a>] generic_make_request+0xca/0x100
[ 2522.956409]  [<ffffffff81301e29>] submit_bio+0x79/0x160
[ 2522.956417]  [<ffffffff811b1710>] ? bio_alloc_bioset+0xa0/0x1d0
[ 2522.956421]  [<ffffffff811abd3f>] _submit_bh+0x13f/0x200
[ 2522.956425]  [<ffffffff811abe10>] submit_bh+0x10/0x20
[ 2522.956430]  [<ffffffff811af6b8>] __block_write_full_page+0x1d8/0x360
[ 2522.956439]  [<ffffffff8145fc0b>] ? scsi_request_fn+0xbb/0x530
[ 2522.956444]  [<ffffffff811ad3c0>] ? end_buffer_async_read+0x130/0x130
[ 2522.956449]  [<ffffffff811b2c40>] ? I_BDEV+0x10/0x10
[ 2522.956454]  [<ffffffff811b2c40>] ? I_BDEV+0x10/0x10
[ 2522.956459]  [<ffffffff811af90a>] block_write_full_page_endio+0xca/0x100
[ 2522.956464]  [<ffffffff811af955>] block_write_full_page+0x15/0x20
[ 2522.956469]  [<ffffffff811b3608>] blkdev_writepage+0x18/0x20
[ 2522.956473]  [<ffffffff81127d37>] __writepage+0x17/0x40
[ 2522.956477]  [<ffffffff8112820e>] write_cache_pages+0x20e/0x460
[ 2522.956481]  [<ffffffff81127d20>] ? set_page_dirty_lock+0x60/0x60
[ 2522.956486]  [<ffffffff811ac251>] ? __set_page_dirty+0x71/0xc0
[ 2522.956490]  [<ffffffff811284aa>] generic_writepages+0x4a/0x70
[ 2522.956495]  [<ffffffff81129cd0>] do_writepages+0x20/0x40
[ 2522.956501]  [<ffffffff811a36f5>] __writeback_single_inode+0x45/0x280
[ 2522.956507]  [<ffffffff811269e2>] ? __alloc_pages_nodemask+0x152/0x9b0
[ 2522.956513]  [<ffffffff811a495d>] writeback_sb_inodes+0x19d/0x3c0
[ 2522.956518]  [<ffffffff811a4c1e>] __writeback_inodes_wb+0x9e/0xd0
[ 2522.956523]  [<ffffffff811a4ecb>] wb_writeback+0x27b/0x320
[ 2522.956529]  [<ffffffff81196228>] ? get_nr_dirty_inodes+0x58/0x80
[ 2522.956534]  [<ffffffff811a500f>] wb_check_old_data_flush+0x9f/0xb0
[ 2522.956539]  [<ffffffff811a67e1>] wb_do_writeback+0x151/0x1d0
[ 2522.956547]  [<ffffffff8106539f>] ? set_worker_desc+0x6f/0x80
[ 2522.956552]  [<ffffffff811a68da>] bdi_writeback_workfn+0x7a/0x200
[ 2522.956557]  [<ffffffff810624d4>] process_one_work+0x174/0x490
[ 2522.956562]  [<ffffffff8106368b>] worker_thread+0x11b/0x370
[ 2522.956567]  [<ffffffff81063570>] ? manage_workers.isra.23+0x2d0/0x2d0
[ 2522.956571]  [<ffffffff81069f40>] kthread+0xc0/0xd0
[ 2522.956575]  [<ffffffff81069e80>] ? flush_kthread_worker+0xb0/0xb0
[ 2522.956581]  [<ffffffff816c795c>] ret_from_fork+0x7c/0xb0
[ 2522.956585]  [<ffffffff81069e80>] ? flush_kthread_worker+0xb0/0xb0
[ 2522.956588] INFO: task iozone:2435 blocked for more than 120 seconds.
[ 2522.956593] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[ 2522.956597] iozone          D 0000000000000001     0  2435   1545 0x00000000
[ 2522.956602]  ffff882a75671978 0000000000000082 ffff882a75671938
ffffffff81301d7a
[ 2522.956606]  ffff882f88dc1990 ffff882a75671fd8 ffff882a75671fd8
ffff882a75671fd8
[ 2522.956611]  ffff882f8ec91990 ffff882f88dc1990 ffff882a75671978
ffff882fbf2539f8
[ 2522.956615] Call Trace:
[ 2522.956619]  [<ffffffff81301d7a>] ? generic_make_request+0xca/0x100
[ 2522.956625]  [<ffffffff816be299>] schedule+0x29/0x70
[ 2522.956630]  [<ffffffff816be36f>] io_schedule+0x8f/0xd0
[ 2522.956636]  [<ffffffff811b797c>] do_blockdev_direct_IO+0x1a7c/0x1fb0
[ 2522.956645]  [<ffffffffa0262a80>] ? ext2_get_blocks+0xa60/0xa60 [ext2]
[ 2522.956652]  [<ffffffff811b7f05>] __blockdev_direct_IO+0x55/0x60
[ 2522.956658]  [<ffffffffa0262a80>] ? ext2_get_blocks+0xa60/0xa60 [ext2]
[ 2522.956662]  [<ffffffff8107f991>] ? update_curr+0x141/0x1f0
[ 2522.956669]  [<ffffffffa0263349>] ext2_direct_IO+0x79/0xe0 [ext2]
[ 2522.956674]  [<ffffffffa0262a80>] ? ext2_get_blocks+0xa60/0xa60 [ext2]
[ 2522.956680]  [<ffffffff8104ade6>] ? current_fs_time+0x16/0x60
[ 2522.956685]  [<ffffffff8111f126>] generic_file_direct_write+0xc6/0x180
[ 2522.956690]  [<ffffffff8111f4bd>] __generic_file_aio_write+0x2dd/0x3b0
[ 2522.956696]  [<ffffffff8111f5f9>] generic_file_aio_write+0x69/0xd0
[ 2522.956702]  [<ffffffff8117b88a>] do_sync_write+0x7a/0xb0
[ 2522.956706]  [<ffffffff811bb108>] ? fsnotify+0x1f8/0x2b0
[ 2522.956712]  [<ffffffff8117c63e>] vfs_write+0xce/0x1e0
[ 2522.956716]  [<ffffffff8117cb22>] SyS_write+0x52/0xa0
[ 2522.956722]  [<ffffffff816c7a02>] system_call_fastpath+0x16/0x1b
[ 2522.956726] INFO: task kworker/2:1:2470 blocked for more than 120 seconds.
[ 2522.956730] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[ 2522.956735] kworker/2:1     D ffffffff81813d40     0  2470      2 0x00000000
[ 2522.956743] Workqueue: bcache bch_data_insert_keys
[ 2522.956745]  ffff882a5b0c9628 0000000000000046 ffff882a5b0c9648
0000004000000000
[ 2522.956749]  ffff882f8ec91990 ffff882a5b0c9fd8 ffff882a5b0c9fd8
ffff882a5b0c9fd8
[ 2522.956754]  ffff882fa6489990 ffff882f8ec91990 ffff882f8ec91990
ffff8828dba00d98
[ 2522.956758] Call Trace:
[ 2522.956763]  [<ffffffff816be299>] schedule+0x29/0x70
[ 2522.956769]  [<ffffffff816be57e>] schedule_preempt_disabled+0xe/0x10
[ 2522.956774]  [<ffffffff816bc862>] __mutex_lock_slowpath+0x112/0x1b0
[ 2522.956779]  [<ffffffff816bc3da>] mutex_lock+0x2a/0x50
[ 2522.956783]  [<ffffffff815112e5>] bch_mca_shrink+0x1b5/0x2f0
[ 2522.956791]  [<ffffffff8117fc32>] ? prune_super+0x162/0x1b0
[ 2522.956799]  [<ffffffff8112ebb4>] shrink_slab+0x154/0x300
[ 2522.956805]  [<ffffffff81076828>] ? resched_task+0x68/0x70
[ 2522.956810]  [<ffffffff81077165>] ? check_preempt_curr+0x75/0xa0
[ 2522.956816]  [<ffffffff8113a379>] ? fragmentation_index+0x19/0x70
[ 2522.956822]  [<ffffffff8113140f>] do_try_to_free_pages+0x20f/0x4b0
[ 2522.956827]  [<ffffffff81131864>] try_to_free_pages+0xe4/0x1a0
[ 2522.956833]  [<ffffffff81126e9c>] __alloc_pages_nodemask+0x60c/0x9b0
[ 2522.956843]  [<ffffffff8116062a>] alloc_pages_current+0xba/0x170
[ 2522.956848]  [<ffffffff8112240e>] __get_free_pages+0xe/0x40
[ 2522.956852]  [<ffffffff8150ebb3>] mca_data_alloc+0x73/0x1d0
[ 2522.956857]  [<ffffffff8150ee5a>] mca_bucket_alloc+0x14a/0x1f0
[ 2522.956861]  [<ffffffff81511020>] mca_alloc+0x360/0x470
[ 2522.956866]  [<ffffffff81517031>] ? __bch_bset_search+0x1d1/0x480
[ 2522.956871]  [<ffffffff8151183e>] bch_btree_node_get+0x10e/0x280
[ 2522.956875]  [<ffffffff81511c02>] bch_btree_map_nodes_recurse+0xe2/0x170
[ 2522.956880]  [<ffffffff815137c0>] ? bch_btree_insert_node+0x2f0/0x2f0
[ 2522.956886]  [<ffffffff811b51ea>] ? dio_bio_end_io+0x5a/0x90
[ 2522.956890]  [<ffffffff8107f991>] ? update_curr+0x141/0x1f0
[ 2522.956895]  [<ffffffff81514dce>] __bch_btree_map_nodes+0x13e/0x1c0
[ 2522.956899]  [<ffffffff815137c0>] ? bch_btree_insert_node+0x2f0/0x2f0
[ 2522.956905]  [<ffffffff8151ac6f>] ? bch_journal+0x42f/0x4b0
[ 2522.956909]  [<ffffffff81514f04>] bch_btree_insert+0xb4/0x120
[ 2522.956915]  [<ffffffff8151e1be>] bch_data_insert_keys+0x3e/0x160
[ 2522.956920]  [<ffffffff810624d4>] process_one_work+0x174/0x490
[ 2522.956925]  [<ffffffff8106368b>] worker_thread+0x11b/0x370
[ 2522.956930]  [<ffffffff81063570>] ? manage_workers.isra.23+0x2d0/0x2d0
[ 2522.956933]  [<ffffffff81069f40>] kthread+0xc0/0xd0
[ 2522.956938]  [<ffffffff81069e80>] ? flush_kthread_worker+0xb0/0xb0
[ 2522.956943]  [<ffffffff816c795c>] ret_from_fork+0x7c/0xb0
[ 2522.956947]  [<ffffffff81069e80>] ? flush_kthread_worker+0xb0/0xb0
[ 2522.956951] INFO: task kworker/3:2:2471 blocked for more than 120 seconds.
[ 2522.956955] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[ 2522.956959] kworker/3:2     D ffffffff81813a60     0  2471      2 0x00000000
[ 2522.956966] Workqueue: events update_writeback_rate
[ 2522.956968]  ffff882a5d125cd0 0000000000000046 0000000000000003
ffff882a5d125d68
[ 2522.956972]  ffff882f8ec94cb0 ffff882a5d125fd8 ffff882a5d125fd8
ffff882a5d125fd8
[ 2522.956977]  ffff882fa6aeb320 ffff882f8ec94cb0 0000000200000003
ffff882f8ec94cb0
[ 2522.956981] Call Trace:
[ 2522.956987]  [<ffffffff816be299>] schedule+0x29/0x70
[ 2522.956992]  [<ffffffff816bf0fd>] rwsem_down_read_failed+0x9d/0xe5
[ 2522.956997]  [<ffffffff81332c64>] call_rwsem_down_read_failed+0x14/0x30
[ 2522.957002]  [<ffffffff816bcc74>] ? down_read+0x24/0x2b
[ 2522.957007]  [<ffffffff8151b010>] update_writeback_rate+0x30/0x230
[ 2522.957011]  [<ffffffff810624d4>] process_one_work+0x174/0x490
[ 2522.957017]  [<ffffffff8106368b>] worker_thread+0x11b/0x370
[ 2522.957021]  [<ffffffff81063570>] ? manage_workers.isra.23+0x2d0/0x2d0
[ 2522.957025]  [<ffffffff81069f40>] kthread+0xc0/0xd0
[ 2522.957030]  [<ffffffff81069e80>] ? flush_kthread_worker+0xb0/0xb0
[ 2522.957035]  [<ffffffff816c795c>] ret_from_fork+0x7c/0xb0
[ 2522.957039]  [<ffffffff81069e80>] ? flush_kthread_worker+0xb0/0xb0
[ 2522.957048] INFO: task kworker/u64:2:2540 blocked for more than 120 seconds.
[ 2522.957052] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[ 2522.957056] kworker/u64:2   D ffffffff81813a60     0  2540      2 0x00000000
[ 2522.957062] Workqueue: bch_btree_io btree_node_write_work
[ 2522.957064]  ffff882a4fdc9778 0000000000000046 ffff882a4fdc9738
ffff882f86e3be58
[ 2522.957069]  ffff882fa4bc1990 ffff882a4fdc9fd8 ffff882a4fdc9fd8
ffff882a4fdc9fd8
[ 2522.957073]  ffff882fa6aeb320 ffff882fa4bc1990 ffff882f86e3be00
ffff8828dba00d98
[ 2522.957078] Call Trace:
[ 2522.957083]  [<ffffffff816be299>] schedule+0x29/0x70
[ 2522.957088]  [<ffffffff816be57e>] schedule_preempt_disabled+0xe/0x10
[ 2522.957092]  [<ffffffff816bc862>] __mutex_lock_slowpath+0x112/0x1b0
[ 2522.957102]  [<ffffffff81484090>] ? ata_scsiop_mode_sense+0x380/0x380
[ 2522.957107]  [<ffffffff816bc3da>] mutex_lock+0x2a/0x50
[ 2522.957111]  [<ffffffff815112e5>] bch_mca_shrink+0x1b5/0x2f0
[ 2522.957116]  [<ffffffff8117fc32>] ? prune_super+0x162/0x1b0
[ 2522.957121]  [<ffffffff8112ebb4>] shrink_slab+0x154/0x300
[ 2522.957126]  [<ffffffff81076828>] ? resched_task+0x68/0x70
[ 2522.957130]  [<ffffffff81077165>] ? check_preempt_curr+0x75/0xa0
[ 2522.957135]  [<ffffffff8113a379>] ? fragmentation_index+0x19/0x70
[ 2522.957140]  [<ffffffff8113140f>] do_try_to_free_pages+0x20f/0x4b0
[ 2522.957146]  [<ffffffff81131864>] try_to_free_pages+0xe4/0x1a0
[ 2522.957152]  [<ffffffff81126e9c>] __alloc_pages_nodemask+0x60c/0x9b0
[ 2522.957158]  [<ffffffff8116062a>] alloc_pages_current+0xba/0x170
[ 2522.957163]  [<ffffffff8112240e>] __get_free_pages+0xe/0x40
[ 2522.957168]  [<ffffffff81517fc8>] __btree_sort+0x48/0x230
[ 2522.957173]  [<ffffffff8151765c>] ? __bch_btree_iter_init+0x7c/0xc0
[ 2522.957178]  [<ffffffff81518301>] bch_btree_sort_partial+0x101/0x120
[ 2522.957182]  [<ffffffff8150f000>] ? __btree_node_write_done+0x100/0x100
[ 2522.957187]  [<ffffffff81518468>] bch_btree_sort_lazy+0x68/0x90
[ 2522.957191]  [<ffffffff815109ba>] bch_btree_node_write+0x36a/0x4a0
[ 2522.957196]  [<ffffffff8108458b>] ? idle_balance+0xeb/0x150
[ 2522.957201]  [<ffffffff8106212c>] ? pwq_activate_delayed_work+0x4c/0xb0
[ 2522.957205]  [<ffffffff81511477>] btree_node_write_work+0x57/0x80
[ 2522.957210]  [<ffffffff810624d4>] process_one_work+0x174/0x490
[ 2522.957215]  [<ffffffff8106368b>] worker_thread+0x11b/0x370
[ 2522.957219]  [<ffffffff81063570>] ? manage_workers.isra.23+0x2d0/0x2d0
[ 2522.957223]  [<ffffffff81069f40>] kthread+0xc0/0xd0
[ 2522.957228]  [<ffffffff81069e80>] ? flush_kthread_worker+0xb0/0xb0
[ 2522.957233]  [<ffffffff816c795c>] ret_from_fork+0x7c/0xb0
[ 2522.957237]  [<ffffffff81069e80>] ? flush_kthread_worker+0xb0/0xb0


I can easily reproduce this, please let me know if you require any
info/test any patch.

Thanks,
Neo

On Mon, Aug 26, 2013 at 12:21 PM, Stefan Priebe <s.priebe@profihost.ag> wrote:
> Hi Kent,
>
> a new one under 3.10:
>
> 2013-08-26 21:05:30     INFO: task ceph-osd:8939 blocked for more than 120
> seconds.
> 2013-08-26 21:05:30     "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> disables this message.
> 2013-08-26 21:05:30     ceph-osd D ffffffff8160f760 0 8939 1 0x00000000
> 2013-08-26 21:05:30     ffff880bd9a61820 0000000000000086 ffff880bd9a61fd8
> 0000000000012c80
> 2013-08-26 21:05:30     ffff880bd9a60010 0000000000012c80 0000000000012c80
> 0000000000012c80
> 2013-08-26 21:05:30     ffff880bd9a61fd8 0000000000012c80 ffff880bd7abb1c0
> ffff880c48dee380
> 2013-08-26 21:05:29     [<ffffffff811e8128>] xfs_vm_readpages+0x18/0x20
> 2013-08-26 21:05:29     [<ffffffff810f1da3>] read_pages+0x43/0x100
> 2013-08-26 21:05:29     [<ffffffff810e64df>] ? __page_cache_alloc+0x9f/0xc0
> 2013-08-26 21:05:29     [<ffffffff810f1fab>]
> __do_page_cache_readahead+0x14b/0x160
> 2013-08-26 21:05:29     [<ffffffff810f1fdc>] ra_submit+0x1c/0x20
> 2013-08-26 21:05:29     [<ffffffff810f22a5>] ondemand_readahead+0x115/0x240
> 2013-08-26 21:05:29     [<ffffffff810f249e>]
> page_cache_sync_readahead+0x2e/0x40
> 2013-08-26 21:05:29     [<ffffffff810e7a5e>] T.1003+0x33e/0x430
> 2013-08-26 21:05:29     [<ffffffff810e7c30>]
> generic_file_aio_read+0xe0/0x220
> 2013-08-26 21:05:29     [<ffffffff811efd0a>] xfs_file_aio_read+0x15a/0x2a0
> 2013-08-26 21:05:29     [<ffffffff8114095a>] do_sync_read+0x7a/0xb0
> 2013-08-26 21:05:29     [<ffffffff81140df1>] vfs_read+0xb1/0x130
> 2013-08-26 21:05:29     [<ffffffff81141757>] SyS_pread64+0x97/0xa0
> 2013-08-26 21:05:29     [<ffffffff81526b12>] system_call_fastpath+0x16/0x1b
> 2013-08-26 21:05:29     INFO: task ceph-osd:8896 blocked for more than 120
> seconds.
> 2013-08-26 21:05:29     "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> disables this message.
> 2013-08-26 21:05:29     ceph-osd D ffffffff8160f760 0 8896 1 0x00000000
> 2013-08-26 21:05:29     ffff880bd9a9dc28 0000000000000086 ffff880bd9a9dfd8
> 0000000000012c80
> 2013-08-26 21:05:29     ffff880bd9a9c010 0000000000012c80 0000000000012c80
> 0000000000012c80
> 2013-08-26 21:05:29     ffff880bd9a9dfd8 0000000000012c80 ffff880bd79298e0
> ffff880c48dd6380
> 2013-08-26 21:05:29     Call Trace:
> 2013-08-26 21:05:29     [<ffffffff810e60f0>] ? __lock_page+0x70/0x70
> 2013-08-26 21:05:28     "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> disables this message.
> 2013-08-26 21:05:28     ceph-osd D ffffffff8160f760 0 8798 1 0x00000000
> 2013-08-26 21:05:28     ffff880bd998b740 0000000000000086 ffff880bd998bfd8
> 0000000000012c80
> 2013-08-26 21:05:28     ffff880bd998a010 0000000000012c80 0000000000012c80
> 0000000000012c80
> 2013-08-26 21:05:28     ffff880bd998bfd8 0000000000012c80 ffff880bd99c0000
> ffff880c48dd6380
> 2013-08-26 21:05:28     Call Trace:
> 2013-08-26 21:05:28     [<ffffffff81524874>] schedule+0x24/0x70
> 2013-08-26 21:05:28     [<ffffffff81525d7d>]
> rwsem_down_read_failed+0x9d/0xe5
> 2013-08-26 21:05:28     [<ffffffff812aa0a4>]
> call_rwsem_down_read_failed+0x14/0x30
> 2013-08-26 21:05:28     [<ffffffff81523a42>] ? down_read+0x12/0x20
> 2013-08-26 21:05:28     [<ffffffffa01ead62>] btree_read_async+0xa2/0x1a0
> [bcache]
> 2013-08-26 21:05:28     [<ffffffffa01f7b73>] closure_queue+0x43/0x60
> [bcache]
> 2013-08-26 21:05:28     [<ffffffffa01eb903>] T.1050+0x63/0x70 [bcache]
> 2013-08-26 21:05:28     [<ffffffffa01ed6ea>]
> cached_dev_make_request+0x20a/0x350 [bcache]
> 2013-08-26 21:05:28     [<ffffffff81281952>] generic_make_request+0xc2/0x100
> 2013-08-26 21:05:28     [<ffffffff812819f7>] submit_bio+0x67/0x130
> 2013-08-26 21:05:28     [<ffffffff8117b240>] do_mpage_readpage+0x2a0/0x660
> 2013-08-26 21:05:28     [<ffffffff81101cee>] ?
> __inc_zone_page_state+0x2e/0x30
> 2013-08-26 21:05:28     [<ffffffff810e6581>] ?
> add_to_page_cache_locked+0x81/0x110
> 2013-08-26 21:05:28     [<ffffffff8117b76a>] mpage_readpages+0xfa/0x150
> 2013-08-26 21:05:28     [<ffffffff811e90c0>] ?
> xfs_get_blocks_direct+0x20/0x20
> 2013-08-26 21:05:28     [<ffffffff811e90c0>] ?
> xfs_get_blocks_direct+0x20/0x20
> 2013-08-26 21:05:28     [<ffffffff810eeda3>] ?
> __alloc_pages_nodemask+0x123/0x240
> 2013-08-26 21:05:27     [<ffffffff8115bf93>] ? __close_fd+0x43/0x80
> 2013-08-26 21:05:27     [<ffffffff8116dabe>] SyS_fdatasync+0xe/0x20
> 2013-08-26 21:05:27     [<ffffffff81526b12>] system_call_fastpath+0x16/0x1b
> 2013-08-26 21:05:27     INFO: task ceph-osd:8746 blocked for more than 120
> seconds.
> 2013-08-26 21:05:27     "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> disables this message.
> 2013-08-26 21:05:27     ceph-osd D ffffffff8160f760 0 8746 1 0x00000000
> 2013-08-26 21:05:27     ffff880c2dde1d38 0000000000000086 ffff880c2dde1fd8
> 0000000000012c80
> 2013-08-26 21:05:27     ffff880c2dde0010 0000000000012c80 0000000000012c80
> 0000000000012c80
> 2013-08-26 21:05:27     ffff880c2dde1fd8 0000000000012c80 ffff880c239eb1c0
> ffff880c48dd6380
> 2013-08-26 21:05:27     Call Trace:
> 2013-08-26 21:05:27     [<ffffffff81524874>] schedule+0x24/0x70
> 2013-08-26 21:05:27     [<ffffffff81522bbd>] schedule_timeout+0x16d/0x200
> 2013-08-26 21:05:27     [<ffffffff81068eba>] ?
> __queue_delayed_work+0xaa/0x1a0
> 2013-08-26 21:05:27     [<ffffffff81068d19>] ?
> try_to_grab_pending+0x109/0x190
> 2013-08-26 21:05:27     [<ffffffff815251e5>] wait_for_completion+0x95/0x110
> 2013-08-26 21:05:27     [<ffffffff8107fd00>] ? try_to_wake_up+0x2a0/0x2a0
> 2013-08-26 21:05:27     [<ffffffff81167797>] ? bdi_queue_work+0x77/0xc0
> 2013-08-26 21:05:27     [<ffffffff81167863>]
> writeback_inodes_sb_nr+0x83/0xb0
> 2013-08-26 21:05:27     [<ffffffff811678ea>] writeback_inodes_sb+0x5a/0x70
> 2013-08-26 21:05:27     [<ffffffff8116dd0a>] __sync_filesystem+0x4a/0x50
> 2013-08-26 21:05:27     [<ffffffff8116dd42>] sync_filesystem+0x32/0x60
> 2013-08-26 21:05:27     [<ffffffff8116ddc0>] SyS_syncfs+0x50/0x90
> 2013-08-26 21:05:27     [<ffffffff81526b12>] system_call_fastpath+0x16/0x1b
> 2013-08-26 21:05:27     INFO: task ceph-osd:8798 blocked for more than 120
> seconds.
>
> Stefan
>
> Am 22.08.2013 09:32, schrieb Stefan Priebe - Profihost AG:
>
>> great!
>>
>> Everything seems to work fine now! Except read_dirty always going to
>> negative values after a reboot.
>>
>> Stefan
>>
>> Am 22.08.2013 08:02, schrieb Kent Overstreet:
>>>
>>> On Thu, Aug 22, 2013 at 07:59:04AM +0200, Stefan Priebe wrote:
>>>>
>>>>
>>>>> schedule_timeout() is not the same as
>>>>> schedule_timeout_interruptible().
>>>>
>>>>
>>>> just search and replace? So i can try on my own.
>>>
>>>
>>> The one in read_dirty(), line ~330
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-bcache"
>>> in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
