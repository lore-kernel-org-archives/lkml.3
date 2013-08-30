Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755723Ab3H3A34 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 20:29:56 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:44378 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753245Ab3H3A3z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 20:29:55 -0400
MIME-Version: 1.0
Date: Thu, 29 Aug 2013 17:29:54 -0700
Message-ID: <CAFkUHxd6xN3On4DTC7VnUgVuy8M57k=8eKYr47bKKnpQWS+p8A@mail.gmail.com>
Subject: Bcache sleeps forever on random writes
From: kernel neophyte <neophyte.hacker001@gmail.com>
To: Kent Overstreet <kmo@daterainc.com>
Cc: "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stefan Priebe <s.priebe@profihost.ag>, Jens Axboe <axboe@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We are evaluating to use bcache on our production systems where the
caching devices are insanely fast, in this scenario under a moderate load
of random 4k writes.. bcache fails miserably :-(

[ 3588.513638] bcache: bch_cached_dev_attach() Caching sda4 as bcache0
on set b082ce66-04c6-43d5-8207-ebf39840191d
[ 4442.163661] INFO: task kworker/0:0:4 blocked for more than 120 seconds.
[ 4442.163671] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[ 4442.163678] kworker/0:0     D ffffffff81813d40     0     4      2 0x00000000
[ 4442.163695] Workqueue: bcache bch_data_insert_keys
[ 4442.163699]  ffff882fa6ac93c8 0000000000000046 ffff882fa6ac93e8
0000000000000151
[ 4442.163705]  ffff882fa6a84cb0 ffff882fa6ac9fd8 ffff882fa6ac9fd8
ffff882fa6ac9fd8
[ 4442.163711]  ffff882fa6ad6640 ffff882fa6a84cb0 ffff882fa6a84cb0
ffff8822ca2c0d98
[ 4442.163716] Call Trace:
[ 4442.163729]  [<ffffffff816be299>] schedule+0x29/0x70
[ 4442.163735]  [<ffffffff816be57e>] schedule_preempt_disabled+0xe/0x10
[ 4442.163741]  [<ffffffff816bc862>] __mutex_lock_slowpath+0x112/0x1b0
[ 4442.163746]  [<ffffffff816bc3da>] mutex_lock+0x2a/0x50
[ 4442.163752]  [<ffffffff815112e5>] bch_mca_shrink+0x1b5/0x2f0
[ 4442.163759]  [<ffffffff8117fc32>] ? prune_super+0x162/0x1b0
[ 4442.163769]  [<ffffffff8112ebb4>] shrink_slab+0x154/0x300
[ 4442.163776]  [<ffffffff81076828>] ? resched_task+0x68/0x70
[ 4442.163782]  [<ffffffff81077165>] ? check_preempt_curr+0x75/0xa0
[ 4442.163788]  [<ffffffff8113a379>] ? fragmentation_index+0x19/0x70
[ 4442.163794]  [<ffffffff8113140f>] do_try_to_free_pages+0x20f/0x4b0
[ 4442.163800]  [<ffffffff81131864>] try_to_free_pages+0xe4/0x1a0
[ 4442.163810]  [<ffffffff81126e9c>] __alloc_pages_nodemask+0x60c/0x9b0
[ 4442.163818]  [<ffffffff8116062a>] alloc_pages_current+0xba/0x170
[ 4442.163824]  [<ffffffff8112240e>] __get_free_pages+0xe/0x40
[ 4442.163829]  [<ffffffff8150ebb3>] mca_data_alloc+0x73/0x1d0
[ 4442.163834]  [<ffffffff8150ee5a>] mca_bucket_alloc+0x14a/0x1f0
[ 4442.163838]  [<ffffffff81511020>] mca_alloc+0x360/0x470
[ 4442.163843]  [<ffffffff81511d1c>] bch_btree_node_alloc+0x8c/0x1c0
[ 4442.163849]  [<ffffffff81513020>] btree_split+0x110/0x5c0
[ 4442.163854]  [<ffffffff81515fc7>] ? bch_keylist_pop_front+0x47/0x50
[ 4442.163859]  [<ffffffff8150fed6>] ? bch_btree_insert_keys+0x56/0x250
[ 4442.163867]  [<ffffffff81325abc>] ? cpumask_next_and+0x3c/0x50
[ 4442.163872]  [<ffffffff81513582>] bch_btree_insert_node+0xb2/0x2f0
[ 4442.163877]  [<ffffffff815137e8>] btree_insert_fn+0x28/0x50
[ 4442.163881]  [<ffffffff81511b8c>] bch_btree_map_nodes_recurse+0x6c/0x170
[ 4442.163886]  [<ffffffff815137c0>] ? bch_btree_insert_node+0x2f0/0x2f0
[ 4442.163891]  [<ffffffff816bcc26>] ? down_write+0x16/0x40
[ 4442.163896]  [<ffffffff815117a1>] ? bch_btree_node_get+0x71/0x280
[ 4442.163901]  [<ffffffff81511c30>] bch_btree_map_nodes_recurse+0x110/0x170
[ 4442.163905]  [<ffffffff815137c0>] ? bch_btree_insert_node+0x2f0/0x2f0
[ 4442.163915]  [<ffffffff811b51ea>] ? dio_bio_end_io+0x5a/0x90
[ 4442.163921]  [<ffffffff8107f991>] ? update_curr+0x141/0x1f0
[ 4442.163926]  [<ffffffff81514dce>] __bch_btree_map_nodes+0x13e/0x1c0
[ 4442.163931]  [<ffffffff815137c0>] ? bch_btree_insert_node+0x2f0/0x2f0
[ 4442.163936]  [<ffffffff81514f04>] bch_btree_insert+0xb4/0x120
[ 4442.163942]  [<ffffffff8151e1be>] bch_data_insert_keys+0x3e/0x160
[ 4442.163949]  [<ffffffff810624d4>] process_one_work+0x174/0x490
[ 4442.163954]  [<ffffffff8106368b>] worker_thread+0x11b/0x370
[ 4442.163959]  [<ffffffff81063570>] ? manage_workers.isra.23+0x2d0/0x2d0
[ 4442.163965]  [<ffffffff81069f40>] kthread+0xc0/0xd0
[ 4442.163970]  [<ffffffff81069e80>] ? flush_kthread_worker+0xb0/0xb0
[ 4442.163978]  [<ffffffff816c795c>] ret_from_fork+0x7c/0xb0
[ 4442.163982]  [<ffffffff81069e80>] ? flush_kthread_worker+0xb0/0xb0
[ 4442.163994] INFO: task kswapd0:80 blocked for more than 120 seconds.
[ 4442.163998] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[ 4442.164003] kswapd0         D 0000000000000001     0    80      2 0x00000000
[ 4442.164007]  ffff882fa4b17ba8 0000000000000046 ffff882fa4b17bc8
ffff882fa60ff000
[ 4442.164013]  ffff882fa593e640 ffff882fa4b17fd8 ffff882fa4b17fd8
ffff882fa4b17fd8
[ 4442.164018]  ffff882f8a278000 ffff882fa593e640 ffff882fa6a84cb0
ffff8822ca2c0d98
[ 4442.164023] Call Trace:
[ 4442.164029]  [<ffffffff816be299>] schedule+0x29/0x70
[ 4442.164034]  [<ffffffff816be57e>] schedule_preempt_disabled+0xe/0x10
[ 4442.164039]  [<ffffffff816bc862>] __mutex_lock_slowpath+0x112/0x1b0
[ 4442.164044]  [<ffffffff816bc3da>] mutex_lock+0x2a/0x50
[ 4442.164049]  [<ffffffff815112e5>] bch_mca_shrink+0x1b5/0x2f0
[ 4442.164054]  [<ffffffff8117fc32>] ? prune_super+0x162/0x1b0
[ 4442.164059]  [<ffffffff8112ebb4>] shrink_slab+0x154/0x300
[ 4442.164065]  [<ffffffff81131f54>] kswapd+0x634/0x9b0
[ 4442.164071]  [<ffffffff8106a720>] ? add_wait_queue+0x60/0x60
[ 4442.164076]  [<ffffffff81131920>] ? try_to_free_pages+0x1a0/0x1a0
[ 4442.164080]  [<ffffffff81069f40>] kthread+0xc0/0xd0
[ 4442.164085]  [<ffffffff81069e80>] ? flush_kthread_worker+0xb0/0xb0
[ 4442.164090]  [<ffffffff816c795c>] ret_from_fork+0x7c/0xb0
[ 4442.164094]  [<ffffffff81069e80>] ? flush_kthread_worker+0xb0/0xb0
[ 4442.164101] INFO: task kworker/1:1:201 blocked for more than 120 seconds.
[ 4442.164105] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[ 4442.164110] kworker/1:1     D ffffffff81813a60     0   201      2 0x00000000
[ 4442.164117] Workqueue: bcache bch_data_insert_keys
[ 4442.164119]  ffff882f894c9be0 0000000000000046 0000000000000002
0000000000000002
[ 4442.164124]  ffff882f89974cb0 ffff882f894c9fd8 ffff882f894c9fd8
ffff882f894c9fd8
[ 4442.164129]  ffff882fa6ae8000 ffff882f89974cb0 0000000000000000
ffff882f89974cb0
[ 4442.164134] Call Trace:
[ 4442.164140]  [<ffffffff816be299>] schedule+0x29/0x70
[ 4442.164145]  [<ffffffff816bf0fd>] rwsem_down_read_failed+0x9d/0xe5
[ 4442.164152]  [<ffffffff81332c64>] call_rwsem_down_read_failed+0x14/0x30
[ 4442.164157]  [<ffffffff816bcc74>] ? down_read+0x24/0x2b
[ 4442.164162]  [<ffffffff81514d75>] __bch_btree_map_nodes+0xe5/0x1c0
[ 4442.164166]  [<ffffffff815137c0>] ? bch_btree_insert_node+0x2f0/0x2f0
[ 4442.164171]  [<ffffffff81514f04>] bch_btree_insert+0xb4/0x120
[ 4442.164177]  [<ffffffff8151e1be>] bch_data_insert_keys+0x3e/0x160
[ 4442.164182]  [<ffffffff810624d4>] process_one_work+0x174/0x490
[ 4442.164187]  [<ffffffff8106368b>] worker_thread+0x11b/0x370
[ 4442.164192]  [<ffffffff81063570>] ? manage_workers.isra.23+0x2d0/0x2d0
[ 4442.164196]  [<ffffffff81069f40>] kthread+0xc0/0xd0
[ 4442.164200]  [<ffffffff81069e80>] ? flush_kthread_worker+0xb0/0xb0
[ 4442.164206]  [<ffffffff816c795c>] ret_from_fork+0x7c/0xb0
[ 4442.164210]  [<ffffffff81069e80>] ? flush_kthread_worker+0xb0/0xb0
[ 4442.164215] INFO: task kworker/u64:2:377 blocked for more than 120 seconds.
[ 4442.164219] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[ 4442.164224] kworker/u64:2   D ffffffff81813a60     0   377      2 0x00000000
[ 4442.164231] Workqueue: bch_btree_io btree_node_write_work
[ 4442.164233]  ffff882f87cbbcc8 0000000000000046 000003e146257be1
0029002f87cbbc98
[ 4442.164238]  ffff882f88053320 ffff882f87cbbfd8 ffff882f87cbbfd8
ffff882f87cbbfd8
[ 4442.164243]  ffff882fa6ae9990 ffff882f88053320 ffff882f87cbbd18
ffff882f88053320
[ 4442.164249] Call Trace:
[ 4442.164254]  [<ffffffff816be299>] schedule+0x29/0x70
[ 4442.164259]  [<ffffffff816befb5>] rwsem_down_write_failed+0xf5/0x1a0
[ 4442.164264]  [<ffffffff8150f000>] ? __btree_node_write_done+0x100/0x100
[ 4442.164269]  [<ffffffff81332c93>] call_rwsem_down_write_failed+0x13/0x20
[ 4442.164274]  [<ffffffff816bcc41>] ? down_write+0x31/0x40
[ 4442.164279]  [<ffffffff8151144f>] btree_node_write_work+0x2f/0x80
[ 4442.164283]  [<ffffffff810624d4>] process_one_work+0x174/0x490
[ 4442.164288]  [<ffffffff8106368b>] worker_thread+0x11b/0x370
[ 4442.164293]  [<ffffffff81063570>] ? manage_workers.isra.23+0x2d0/0x2d0
[ 4442.164297]  [<ffffffff81069f40>] kthread+0xc0/0xd0
[ 4442.164302]  [<ffffffff81069e80>] ? flush_kthread_worker+0xb0/0xb0
[ 4442.164307]  [<ffffffff816c795c>] ret_from_fork+0x7c/0xb0
[ 4442.164311]  [<ffffffff81069e80>] ? flush_kthread_worker+0xb0/0xb0
[ 4442.164325] INFO: task bcache_allocato:2256 blocked for more than
120 seconds.
[ 4442.164329] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[ 4442.164334] bcache_allocato D 0000000000000001     0  2256      2 0x00000000
[ 4442.164337]  ffff881004e3dd88 0000000000000046 ffff881004e3dda8
ffffffff810808ad
[ 4442.164343]  ffff882fa3d64cb0 ffff881004e3dfd8 ffff881004e3dfd8
ffff881004e3dfd8
[ 4442.164348]  ffff882f89ea0000 ffff882fa3d64cb0 ffff882fa6a84cb0
ffff8822ca2c0d98
[ 4442.164353] Call Trace:
[ 4442.164358]  [<ffffffff810808ad>] ? dequeue_task_fair+0x2cd/0x530
[ 4442.164363]  [<ffffffff816be299>] schedule+0x29/0x70
[ 4442.164368]  [<ffffffff816be57e>] schedule_preempt_disabled+0xe/0x10
[ 4442.164373]  [<ffffffff816bc862>] __mutex_lock_slowpath+0x112/0x1b0
[ 4442.164378]  [<ffffffff816bc3da>] mutex_lock+0x2a/0x50
[ 4442.164383]  [<ffffffff8150cdbf>] bch_allocator_thread+0x10f/0xe20
[ 4442.164388]  [<ffffffff8150ccb0>] ? bch_bucket_add_unused+0xe0/0xe0
[ 4442.164392]  [<ffffffff81069f40>] kthread+0xc0/0xd0
[ 4442.164398]  [<ffffffff811ad3c0>] ? end_buffer_async_read+0x130/0x130
[ 4442.164402]  [<ffffffff81069e80>] ? flush_kthread_worker+0xb0/0xb0
[ 4442.164407]  [<ffffffff816c795c>] ret_from_fork+0x7c/0xb0
[ 4442.164411]  [<ffffffff81069e80>] ? flush_kthread_worker+0xb0/0xb0
[ 4442.164417] INFO: task iozone:2565 blocked for more than 120 seconds.
[ 4442.164421] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[ 4442.164426] iozone          D 0000000000000001     0  2565   1660 0x00000000
[ 4442.164429]  ffff882fa3ae1978 0000000000000086 ffff882fa3ae1938
ffffffff81301d7a
[ 4442.164435]  ffff882f8a420000 ffff882fa3ae1fd8 ffff882fa3ae1fd8
ffff882fa3ae1fd8
[ 4442.164440]  ffff882fa6a84cb0 ffff882f8a420000 ffff882fa3ae1978
ffff882fbf2139f8
[ 4442.164445] Call Trace:
[ 4442.164451]  [<ffffffff81301d7a>] ? generic_make_request+0xca/0x100
[ 4442.164456]  [<ffffffff816be299>] schedule+0x29/0x70
[ 4442.164461]  [<ffffffff816be36f>] io_schedule+0x8f/0xd0
[ 4442.164467]  [<ffffffff811b797c>] do_blockdev_direct_IO+0x1a7c/0x1fb0
[ 4442.164477]  [<ffffffffa020ea80>] ? ext2_get_blocks+0xa60/0xa60 [ext2]
[ 4442.164484]  [<ffffffff811b7f05>] __blockdev_direct_IO+0x55/0x60
[ 4442.164490]  [<ffffffffa020ea80>] ? ext2_get_blocks+0xa60/0xa60 [ext2]
[ 4442.164497]  [<ffffffffa020f349>] ext2_direct_IO+0x79/0xe0 [ext2]
[ 4442.164502]  [<ffffffffa020ea80>] ? ext2_get_blocks+0xa60/0xa60 [ext2]
[ 4442.164509]  [<ffffffff8104ade6>] ? current_fs_time+0x16/0x60
[ 4442.164516]  [<ffffffff8111f126>] generic_file_direct_write+0xc6/0x180
[ 4442.164521]  [<ffffffff8111f4bd>] __generic_file_aio_write+0x2dd/0x3b0
[ 4442.164526]  [<ffffffff8111f5f9>] generic_file_aio_write+0x69/0xd0
[ 4442.164532]  [<ffffffff8117b88a>] do_sync_write+0x7a/0xb0
[ 4442.164537]  [<ffffffff8117c63e>] vfs_write+0xce/0x1e0
[ 4442.164542]  [<ffffffff8117cb22>] SyS_write+0x52/0xa0
[ 4442.164548]  [<ffffffff816c7a02>] system_call_fastpath+0x16/0x1b


-Neo
