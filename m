Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754802Ab3H1Srn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 14:47:43 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:51601 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753173Ab3H1Srl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 14:47:41 -0400
MIME-Version: 1.0
In-Reply-To: <AE6E0884-C111-4545-B4E5-CB03A5AD2A5F@profihost.ag>
References: <52132243.8050803@profihost.ag>
	<521323D1.1070503@profihost.ag>
	<20130821234715.GA4630@moria.home.lan>
	<5215A130.9080508@profihost.ag>
	<20130822054336.GA14935@kmo-pixel>
	<5215A8A8.90900@profihost.ag>
	<20130822060215.GB14935@kmo-pixel>
	<5215BEA4.6040101@profihost.ag>
	<521BAACB.4070003@profihost.ag>
	<CAFkUHxeAUvv-nhSZSDRVwdm8SoNhHD8oSBKqDYnEO3bNAKLG6w@mail.gmail.com>
	<20130828060521.GC8032@kmo-pixel>
	<CAFkUHxeryKu2VdgBTBWBHTnzzZ=aapUgLd22+7cQnFOXF4r_2g@mail.gmail.com>
	<AE6E0884-C111-4545-B4E5-CB03A5AD2A5F@profihost.ag>
Date: Wed, 28 Aug 2013 11:47:40 -0700
Message-ID: <CAFkUHxcu+0Qv64_4gEGbMk5YaBkm1r7pdw4-JTamiCqy=SMUPg@mail.gmail.com>
Subject: Re: bcache: Fix a writeback performance regression
From: kernel neophyte <neophyte.hacker001@gmail.com>
To: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
Cc: Kent Overstreet <kmo@daterainc.com>, Jens Axboe <axboe@kernel.dk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 28, 2013 at 11:38 AM, Stefan Priebe - Profihost AG
<s.priebe@profihost.ag> wrote:
> I don't had one for a few days. Which kernel so you use?

3.10 kernel with all of kent's stable patches and perf patches..

and all defaults except for:

echo writeback > /sys/block/bcache0/bcache/cache_mode
echo 0 > /sys/block/bcache0/bcache/sequential_cutoff
echo 0 > /sys/fs/bcache/1e26e5ca-5cb9-4c5a-ad7e-3c787524a9dc/congested_read_threshold_us
echo 0 > /sys/fs/bcache/1e26e5ca-5cb9-4c5a-ad7e-3c787524a9dc/congested_write_threshold_us

-Neo

>
> Stefan
>
> This mail was sent with my iPhone.
>
> Am 28.08.2013 um 20:12 schrieb kernel neophyte <neophyte.hacker001@gmail.com>:
>
>> On Tue, Aug 27, 2013 at 11:05 PM, Kent Overstreet <kmo@daterainc.com> wrote:
>>> On Tue, Aug 27, 2013 at 08:37:54PM -0700, kernel neophyte wrote:
>>>> Hi Kent,
>>>>
>>>> I am still seeing deadlock:
>>>
>>> Seeing blk_throtl_bio (what asshole misspells words in their function
>>> names, so when you go to grep for them you grep for the wrong thing?) in
>>> the backtrace - is that what it takes to hit it?
>>
>> I don't think so,
>> I had another deadlock:
>>
>> [ 1179.193990] bio: create slab <bio-2> at 2
>> [ 1179.194491] bcache: run_cache_set() invalidating existing data
>> [ 1179.212308] bcache: register_cache() registered cache device rxd1
>> [ 1203.846220] bcache: register_bdev() registered backing device sda3
>> [ 1227.780088] bcache: bch_cached_dev_attach() Caching sda3 as bcache0
>> on set a079dda3-27fd-4b1c-a616-d46110bfae6c
>> [ 2162.497950] INFO: task kworker/0:0:4 blocked for more than 120 seconds.
>> [ 2162.497961] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
>> disables this message.
>> [ 2162.497967] kworker/0:0     D 0000000000000000     0     4      2 0x00000000
>> [ 2162.497982] Workqueue: events write_dirty_finish
>> [ 2162.497986]  ffff882fa6ac9b30 0000000000000046 ffffffff81511b8c
>> ffffffff815137c0
>> [ 2162.497992]  ffff882fa6a84cb0 ffff882fa6ac9fd8 ffff882fa6ac9fd8
>> ffff882fa6ac9fd8
>> [ 2162.497996]  ffff882f78139990 ffff882fa6a84cb0 ffffffff815117a1
>> ffff882fa6a84cb0
>> [ 2162.498001] Call Trace:
>> [ 2162.498010]  [<ffffffff81511b8c>] ? bch_btree_map_nodes_recurse+0x6c/0x170
>> [ 2162.498015]  [<ffffffff815137c0>] ? bch_btree_insert_node+0x2f0/0x2f0
>> [ 2162.498019]  [<ffffffff815117a1>] ? bch_btree_node_get+0x71/0x280
>> [ 2162.498028]  [<ffffffff816be299>] schedule+0x29/0x70
>> [ 2162.498034]  [<ffffffff816bf0fd>] rwsem_down_read_failed+0x9d/0xe5
>> [ 2162.498043]  [<ffffffff81332c64>] call_rwsem_down_read_failed+0x14/0x30
>> [ 2162.498048]  [<ffffffff816bcc74>] ? down_read+0x24/0x2b
>> [ 2162.498052]  [<ffffffff81514d75>] __bch_btree_map_nodes+0xe5/0x1c0
>> [ 2162.498057]  [<ffffffff815137c0>] ? bch_btree_insert_node+0x2f0/0x2f0
>> [ 2162.498066]  [<ffffffff8107f991>] ? update_curr+0x141/0x1f0
>> [ 2162.498072]  [<ffffffff8151b21e>] ? dirty_io_destructor+0xe/0x10
>> [ 2162.498076]  [<ffffffff81514f04>] bch_btree_insert+0xb4/0x120
>> [ 2162.498082]  [<ffffffff8151b553>] write_dirty_finish+0x1e3/0x270
>> [ 2162.498087]  [<ffffffff8107e7fb>] ? pick_next_task_fair+0x6b/0x150
>> [ 2162.498093]  [<ffffffff810765f3>] ? dequeue_task+0x93/0xb0
>> [ 2162.498100]  [<ffffffff810624d4>] process_one_work+0x174/0x490
>> [ 2162.498105]  [<ffffffff8106368b>] worker_thread+0x11b/0x370
>> [ 2162.498110]  [<ffffffff81063570>] ? manage_workers.isra.23+0x2d0/0x2d0
>> [ 2162.498115]  [<ffffffff81069f40>] kthread+0xc0/0xd0
>> [ 2162.498120]  [<ffffffff81069e80>] ? flush_kthread_worker+0xb0/0xb0
>> [ 2162.498127]  [<ffffffff816c795c>] ret_from_fork+0x7c/0xb0
>> [ 2162.498131]  [<ffffffff81069e80>] ? flush_kthread_worker+0xb0/0xb0
>> [ 2162.498145] INFO: task bcache_allocato:1766 blocked for more than
>> 120 seconds.
>> [ 2162.498149] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
>> disables this message.
>> [ 2162.498154] bcache_allocato D 0000000000000001     0  1766      2 0x00000000
>> [ 2162.498158]  ffff8822630f3d88 0000000000000046 ffff8822630f3da8
>> ffffffff810808ad
>> [ 2162.498163]  ffff882f891de640 ffff8822630f3fd8 ffff8822630f3fd8
>> ffff8822630f3fd8
>> [ 2162.498167]  ffff882f81a91990 ffff882f891de640 ffff882f88b33320
>> ffff8801fad20d98
>> [ 2162.498172] Call Trace:
>> [ 2162.498177]  [<ffffffff810808ad>] ? dequeue_task_fair+0x2cd/0x530
>> [ 2162.498182]  [<ffffffff816be299>] schedule+0x29/0x70
>> [ 2162.498187]  [<ffffffff816be57e>] schedule_preempt_disabled+0xe/0x10
>> [ 2162.498192]  [<ffffffff816bc862>] __mutex_lock_slowpath+0x112/0x1b0
>> [ 2162.498197]  [<ffffffff816bc3da>] mutex_lock+0x2a/0x50
>> [ 2162.498202]  [<ffffffff8150cdbf>] bch_allocator_thread+0x10f/0xe20
>> [ 2162.498207]  [<ffffffff8150ccb0>] ? bch_bucket_add_unused+0xe0/0xe0
>> [ 2162.498211]  [<ffffffff81069f40>] kthread+0xc0/0xd0
>> [ 2162.498215]  [<ffffffff81069e80>] ? flush_kthread_worker+0xb0/0xb0
>> [ 2162.498220]  [<ffffffff816c795c>] ret_from_fork+0x7c/0xb0
>> [ 2162.498224]  [<ffffffff81069e80>] ? flush_kthread_worker+0xb0/0xb0
>> [ 2162.498228] INFO: task bcache_writebac:1771 blocked for more than
>> 120 seconds.
>> [ 2162.498233] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
>> disables this message.
>> [ 2162.498237] bcache_writebac D 0000000000000000     0  1771      2 0x00000000
>> [ 2162.498241]  ffff88197d2adc58 0000000000000046 ffff88197d2add48
>> ffffffff811269e2
>> [ 2162.498245]  ffff882f891d8000 ffff88197d2adfd8 ffff88197d2adfd8
>> ffff88197d2adfd8
>> [ 2162.498250]  ffff882f81a91990 ffff882f891d8000 ffff88197d2adc68
>> ffff882f89550ba0
>> [ 2162.498254] Call Trace:
>> [ 2162.498264]  [<ffffffff811269e2>] ? __alloc_pages_nodemask+0x152/0x9b0
>> [ 2162.498269]  [<ffffffff816be299>] schedule+0x29/0x70
>> [ 2162.498274]  [<ffffffff816bc015>] schedule_timeout+0x1e5/0x250
>> [ 2162.498280]  [<ffffffff810799bf>] ? try_to_wake_up+0x24f/0x2b0
>> [ 2162.498285]  [<ffffffff816bcd09>] __down_common+0x8e/0xe3
>> [ 2162.498293]  [<ffffffff81160600>] ? alloc_pages_current+0x90/0x170
>> [ 2162.498298]  [<ffffffff816bcdd1>] __down+0x1d/0x1f
>> [ 2162.498304]  [<ffffffff8106f351>] down+0x41/0x50
>> [ 2162.498310]  [<ffffffff8151ba7d>] bch_writeback_thread+0x35d/0x7f0
>> [ 2162.498315]  [<ffffffff8108458b>] ? idle_balance+0xeb/0x150
>> [ 2162.498321]  [<ffffffff8151b720>] ? write_dirty+0xc0/0xc0
>> [ 2162.498325]  [<ffffffff81069f40>] kthread+0xc0/0xd0
>> [ 2162.498329]  [<ffffffff81069e80>] ? flush_kthread_worker+0xb0/0xb0
>> [ 2162.498334]  [<ffffffff816c795c>] ret_from_fork+0x7c/0xb0
>> [ 2162.498338]  [<ffffffff81069e80>] ? flush_kthread_worker+0xb0/0xb0
>> [ 2162.498342] INFO: task kworker/0:2:1789 blocked for more than 120 seconds.
>> [ 2162.498346] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
>> disables this message.
>> [ 2162.498351] kworker/0:2     D ffffffff81813a60     0  1789      2 0x00000000
>> [ 2162.498357] Workqueue: events write_dirty_finish
>> [ 2162.498360]  ffff88277062fb30 0000000000000046 ffffffff81511b8c
>> ffffffff815137c0
>> [ 2162.498364]  ffff882fa6786640 ffff88277062ffd8 ffff88277062ffd8
>> ffff88277062ffd8
>> [ 2162.498368]  ffffffff81c10440 ffff882fa6786640 ffffffff815117a1
>> ffff882fa6786640
>> [ 2162.498373] Call Trace:
>> [ 2162.498378]  [<ffffffff81511b8c>] ? bch_btree_map_nodes_recurse+0x6c/0x170
>> [ 2162.498382]  [<ffffffff815137c0>] ? bch_btree_insert_node+0x2f0/0x2f0
>> [ 2162.498387]  [<ffffffff815117a1>] ? bch_btree_node_get+0x71/0x280
>> [ 2162.498392]  [<ffffffff816be299>] schedule+0x29/0x70
>> [ 2162.498397]  [<ffffffff816bf0fd>] rwsem_down_read_failed+0x9d/0xe5
>> [ 2162.498402]  [<ffffffff81332c64>] call_rwsem_down_read_failed+0x14/0x30
>> [ 2162.498407]  [<ffffffff816bcc74>] ? down_read+0x24/0x2b
>> [ 2162.498411]  [<ffffffff81514d75>] __bch_btree_map_nodes+0xe5/0x1c0
>> [ 2162.498416]  [<ffffffff815137c0>] ? bch_btree_insert_node+0x2f0/0x2f0
>> [ 2162.498420]  [<ffffffff8107f991>] ? update_curr+0x141/0x1f0
>> [ 2162.498425]  [<ffffffff8151b21e>] ? dirty_io_destructor+0xe/0x10
>> [ 2162.498430]  [<ffffffff81514f04>] bch_btree_insert+0xb4/0x120
>> [ 2162.498435]  [<ffffffff8151b553>] write_dirty_finish+0x1e3/0x270
>> [ 2162.498439]  [<ffffffff8107e7fb>] ? pick_next_task_fair+0x6b/0x150
>> [ 2162.498444]  [<ffffffff810765f3>] ? dequeue_task+0x93/0xb0
>> [ 2162.498449]  [<ffffffff810624d4>] process_one_work+0x174/0x490
>> [ 2162.498454]  [<ffffffff8106368b>] worker_thread+0x11b/0x370
>> [ 2162.498459]  [<ffffffff81063570>] ? manage_workers.isra.23+0x2d0/0x2d0
>> [ 2162.498463]  [<ffffffff81069f40>] kthread+0xc0/0xd0
>> [ 2162.498467]  [<ffffffff81069e80>] ? flush_kthread_worker+0xb0/0xb0
>> [ 2162.498472]  [<ffffffff816c795c>] ret_from_fork+0x7c/0xb0
>> [ 2162.498476]  [<ffffffff81069e80>] ? flush_kthread_worker+0xb0/0xb0
>> [ 2162.498480] INFO: task iozone:2052 blocked for more than 120 seconds.
>> [ 2162.498484] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
>> disables this message.
>> [ 2162.498488] iozone          D 0000000000000001     0  2052   1944 0x00000000
>> [ 2162.498492]  ffff882f7e2d3978 0000000000000082 ffff882f7e2d3938
>> ffffffff81301d7a
>> [ 2162.498497]  ffff882f8a116640 ffff882f7e2d3fd8 ffff882f7e2d3fd8
>> ffff882f7e2d3fd8
>> [ 2162.498501]  ffff882f88b33320 ffff882f8a116640 ffff882f7e2d3978
>> ffff882fbf2339f8
>> [ 2162.498505] Call Trace:
>> [ 2162.498511]  [<ffffffff81301d7a>] ? generic_make_request+0xca/0x100
>> [ 2162.498517]  [<ffffffff816be299>] schedule+0x29/0x70
>> [ 2162.498522]  [<ffffffff816be36f>] io_schedule+0x8f/0xd0
>> [ 2162.498530]  [<ffffffff811b797c>] do_blockdev_direct_IO+0x1a7c/0x1fb0
>> [ 2162.498539]  [<ffffffffa0273a80>] ? ext2_get_blocks+0xa60/0xa60 [ext2]
>> [ 2162.498546]  [<ffffffff811b7f05>] __blockdev_direct_IO+0x55/0x60
>> [ 2162.498552]  [<ffffffffa0273a80>] ? ext2_get_blocks+0xa60/0xa60 [ext2]
>> [ 2162.498556]  [<ffffffff8107f991>] ? update_curr+0x141/0x1f0
>> [ 2162.498562]  [<ffffffffa0274349>] ext2_direct_IO+0x79/0xe0 [ext2]
>> [ 2162.498567]  [<ffffffffa0273a80>] ? ext2_get_blocks+0xa60/0xa60 [ext2]
>> [ 2162.498572]  [<ffffffff8107e775>] ? set_next_entity+0xa5/0xc0
>> [ 2162.498579]  [<ffffffff8104ade6>] ? current_fs_time+0x16/0x60
>> [ 2162.498585]  [<ffffffff8111f126>] generic_file_direct_write+0xc6/0x180
>> [ 2162.498590]  [<ffffffff8111f4bd>] __generic_file_aio_write+0x2dd/0x3b0
>> [ 2162.498595]  [<ffffffff816bc364>] ? mutex_unlock+0x14/0x20
>> [ 2162.498600]  [<ffffffff8111f5f9>] generic_file_aio_write+0x69/0xd0
>> [ 2162.498607]  [<ffffffff8117b88a>] do_sync_write+0x7a/0xb0
>> [ 2162.498612]  [<ffffffff8117c63e>] vfs_write+0xce/0x1e0
>> [ 2162.498617]  [<ffffffff8117bba0>] ? generic_file_llseek_size+0x110/0x110
>> [ 2162.498621]  [<ffffffff8117cb22>] SyS_write+0x52/0xa0
>> [ 2162.498627]  [<ffffffff816c7a02>] system_call_fastpath+0x16/0x1b
>> [ 2162.498630] INFO: task kworker/0:1:2293 blocked for more than 120 seconds.
>> [ 2162.498635] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
>> disables this message.
>> [ 2162.498639] kworker/0:1     D ffffffff81813a60     0  2293      2 0x00000000
>> [ 2162.498645] Workqueue: events write_dirty_finish
>> [ 2162.498647]  ffff882f8a05bb30 0000000000000046 ffffffff81511b8c
>> ffffffff815137c0
>> [ 2162.498652]  ffff882f8a163320 ffff882f8a05bfd8 ffff882f8a05bfd8
>> ffff882f8a05bfd8
>> [ 2162.498656]  ffffffff81c10440 ffff882f8a163320 ffffffff815117a1
>> ffff882f8a163320
>> [ 2162.498661] Call Trace:
>> [ 2162.498665]  [<ffffffff81511b8c>] ? bch_btree_map_nodes_recurse+0x6c/0x170
>> [ 2162.498669]  [<ffffffff815137c0>] ? bch_btree_insert_node+0x2f0/0x2f0
>> [ 2162.498674]  [<ffffffff815117a1>] ? bch_btree_node_get+0x71/0x280
>> [ 2162.498679]  [<ffffffff816be299>] schedule+0x29/0x70
>> [ 2162.498684]  [<ffffffff816bf0fd>] rwsem_down_read_failed+0x9d/0xe5
>> [ 2162.498689]  [<ffffffff81332c64>] call_rwsem_down_read_failed+0x14/0x30
>> [ 2162.498693]  [<ffffffff816bcc74>] ? down_read+0x24/0x2b
>> [ 2162.498698]  [<ffffffff81514d75>] __bch_btree_map_nodes+0xe5/0x1c0
>> [ 2162.498702]  [<ffffffff815137c0>] ? bch_btree_insert_node+0x2f0/0x2f0
>> [ 2162.498707]  [<ffffffff8107f991>] ? update_curr+0x141/0x1f0
>> [ 2162.498712]  [<ffffffff8151b21e>] ? dirty_io_destructor+0xe/0x10
>> [ 2162.498716]  [<ffffffff81514f04>] bch_btree_insert+0xb4/0x120
>> [ 2162.498721]  [<ffffffff8151b553>] write_dirty_finish+0x1e3/0x270
>> [ 2162.498726]  [<ffffffff8107e7fb>] ? pick_next_task_fair+0x6b/0x150
>> [ 2162.498731]  [<ffffffff810765f3>] ? dequeue_task+0x93/0xb0
>> [ 2162.498735]  [<ffffffff810624d4>] process_one_work+0x174/0x490
>> [ 2162.498740]  [<ffffffff8106368b>] worker_thread+0x11b/0x370
>> [ 2162.498745]  [<ffffffff81063570>] ? manage_workers.isra.23+0x2d0/0x2d0
>> [ 2162.498749]  [<ffffffff81069f40>] kthread+0xc0/0xd0
>> [ 2162.498753]  [<ffffffff81069e80>] ? flush_kthread_worker+0xb0/0xb0
>> [ 2162.498758]  [<ffffffff816c795c>] ret_from_fork+0x7c/0xb0
>> [ 2162.498762]  [<ffffffff81069e80>] ? flush_kthread_worker+0xb0/0xb0
>> [ 2162.498766] INFO: task kworker/0:3:2534 blocked for more than 120 seconds.
>> [ 2162.498772] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
>> disables this message.
>> [ 2162.498777] kworker/0:3     D ffffffff81813a60     0  2534      2 0x00000000
>> [ 2162.498783] Workqueue: events write_dirty_finish
>> [ 2162.498785]  ffff88237d0bdb30 0000000000000046 ffffffff81511b8c
>> ffffffff815137c0
>> [ 2162.498790]  ffff882fa66fe640 ffff88237d0bdfd8 ffff88237d0bdfd8
>> ffff88237d0bdfd8
>> [ 2162.498794]  ffffffff81c10440 ffff882fa66fe640 ffffffff815117a1
>> ffff882fa66fe640
>> [ 2162.498799] Call Trace:
>> [ 2162.498803]  [<ffffffff81511b8c>] ? bch_btree_map_nodes_recurse+0x6c/0x170
>> [ 2162.498807]  [<ffffffff815137c0>] ? bch_btree_insert_node+0x2f0/0x2f0
>> [ 2162.498812]  [<ffffffff815117a1>] ? bch_btree_node_get+0x71/0x280
>> [ 2162.498817]  [<ffffffff816be299>] schedule+0x29/0x70
>> [ 2162.498822]  [<ffffffff816bf0fd>] rwsem_down_read_failed+0x9d/0xe5
>> [ 2162.498826]  [<ffffffff81332c64>] call_rwsem_down_read_failed+0x14/0x30
>> [ 2162.498831]  [<ffffffff816bcc74>] ? down_read+0x24/0x2b
>> [ 2162.498836]  [<ffffffff81514d75>] __bch_btree_map_nodes+0xe5/0x1c0
>> [ 2162.498840]  [<ffffffff815137c0>] ? bch_btree_insert_node+0x2f0/0x2f0
>> [ 2162.498845]  [<ffffffff8107f991>] ? update_curr+0x141/0x1f0
>> [ 2162.498849]  [<ffffffff8151b21e>] ? dirty_io_destructor+0xe/0x10
>> [ 2162.498854]  [<ffffffff81514f04>] bch_btree_insert+0xb4/0x120
>> [ 2162.498859]  [<ffffffff8151b553>] write_dirty_finish+0x1e3/0x270
>> [ 2162.498864]  [<ffffffff8107e7fb>] ? pick_next_task_fair+0x6b/0x150
>> [ 2162.498868]  [<ffffffff810765f3>] ? dequeue_task+0x93/0xb0
>> [ 2162.498873]  [<ffffffff810624d4>] process_one_work+0x174/0x490
>> [ 2162.498878]  [<ffffffff8106368b>] worker_thread+0x11b/0x370
>> [ 2162.498882]  [<ffffffff81063570>] ? manage_workers.isra.23+0x2d0/0x2d0
>> [ 2162.498886]  [<ffffffff81069f40>] kthread+0xc0/0xd0
>> [ 2162.498890]  [<ffffffff81069e80>] ? flush_kthread_worker+0xb0/0xb0
>> [ 2162.498896]  [<ffffffff816c795c>] ret_from_fork+0x7c/0xb0
>> [ 2162.498900]  [<ffffffff81069e80>] ? flush_kthread_worker+0xb0/0xb0
>> [ 2162.498903] INFO: task kworker/0:4:2537 blocked for more than 120 seconds.
>> [ 2162.498908] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
>> disables this message.
>> [ 2162.498914] kworker/0:4     D 0000000000000000     0  2537      2 0x00000000
>> [ 2162.498920] Workqueue: events write_dirty_finish
>> [ 2162.498922]  ffff882f76d8fb30 0000000000000046 ffffffff81511b8c
>> ffffffff815137c0
>> [ 2162.498926]  ffff882f88b30000 ffff882f76d8ffd8 ffff882f76d8ffd8
>> ffff882f76d8ffd8
>> [ 2162.498931]  ffff882f78beb320 ffff882f88b30000 ffffffff815117a1
>> ffff882f88b30000
>> [ 2162.498935] Call Trace:
>> [ 2162.498940]  [<ffffffff81511b8c>] ? bch_btree_map_nodes_recurse+0x6c/0x170
>> [ 2162.498944]  [<ffffffff815137c0>] ? bch_btree_insert_node+0x2f0/0x2f0
>> [ 2162.498948]  [<ffffffff815117a1>] ? bch_btree_node_get+0x71/0x280
>> [ 2162.498953]  [<ffffffff816be299>] schedule+0x29/0x70
>> [ 2162.498958]  [<ffffffff816bf0fd>] rwsem_down_read_failed+0x9d/0xe5
>> [ 2162.498963]  [<ffffffff81332c64>] call_rwsem_down_read_failed+0x14/0x30
>> [ 2162.498968]  [<ffffffff816bcc74>] ? down_read+0x24/0x2b
>> [ 2162.498972]  [<ffffffff81514d75>] __bch_btree_map_nodes+0xe5/0x1c0
>> [ 2162.498977]  [<ffffffff815137c0>] ? bch_btree_insert_node+0x2f0/0x2f0
>> [ 2162.498981]  [<ffffffff8107f991>] ? update_curr+0x141/0x1f0
>> [ 2162.498986]  [<ffffffff8151b21e>] ? dirty_io_destructor+0xe/0x10
>> [ 2162.498990]  [<ffffffff81514f04>] bch_btree_insert+0xb4/0x120
>> [ 2162.498995]  [<ffffffff8151b553>] write_dirty_finish+0x1e3/0x270
>> [ 2162.499000]  [<ffffffff8107e7fb>] ? pick_next_task_fair+0x6b/0x150
>> [ 2162.499004]  [<ffffffff810765f3>] ? dequeue_task+0x93/0xb0
>> [ 2162.499009]  [<ffffffff810624d4>] process_one_work+0x174/0x490
>> [ 2162.499014]  [<ffffffff8106368b>] worker_thread+0x11b/0x370
>> [ 2162.499019]  [<ffffffff81063570>] ? manage_workers.isra.23+0x2d0/0x2d0
>> [ 2162.499023]  [<ffffffff81069f40>] kthread+0xc0/0xd0
>> [ 2162.499027]  [<ffffffff81069e80>] ? flush_kthread_worker+0xb0/0xb0
>> [ 2162.499032]  [<ffffffff816c795c>] ret_from_fork+0x7c/0xb0
>> [ 2162.499036]  [<ffffffff81069e80>] ? flush_kthread_worker+0xb0/0xb0
>> [ 2162.499039] INFO: task kworker/1:1:2544 blocked for more than 120 seconds.
>> [ 2162.499044] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
>> disables this message.
>> [ 2162.499050] kworker/1:1     D ffffffff81813d40     0  2544      2 0x00000000
>> [ 2162.499057] Workqueue: bcache bch_data_insert_keys
>> [ 2162.499059]  ffff882fa677b3f8 0000000000000046 ffff882fa677b418
>> ffff882f8a709000
>> [ 2162.499063]  ffff882f88b33320 ffff882fa677bfd8 ffff882fa677bfd8
>> ffff882fa677bfd8
>> [ 2162.499068]  ffff882fa6471990 ffff882f88b33320 ffff882f88b33320
>> ffff8801fad20d98
>> [ 2162.499072] Call Trace:
>> [ 2162.499077]  [<ffffffff816be299>] schedule+0x29/0x70
>> [ 2162.499082]  [<ffffffff816be57e>] schedule_preempt_disabled+0xe/0x10
>> [ 2162.499087]  [<ffffffff816bc862>] __mutex_lock_slowpath+0x112/0x1b0
>> [ 2162.499092]  [<ffffffff816bc3da>] mutex_lock+0x2a/0x50
>> [ 2162.499096]  [<ffffffff815112e5>] bch_mca_shrink+0x1b5/0x2f0
>> [ 2162.499102]  [<ffffffff8117fc32>] ? prune_super+0x162/0x1b0
>> [ 2162.499109]  [<ffffffff8112ebb4>] shrink_slab+0x154/0x300
>> [ 2162.499113]  [<ffffffff81076828>] ? resched_task+0x68/0x70
>> [ 2162.499118]  [<ffffffff81077165>] ? check_preempt_curr+0x75/0xa0
>> [ 2162.499126]  [<ffffffff8113a379>] ? fragmentation_index+0x19/0x70
>> [ 2162.499131]  [<ffffffff8113140f>] do_try_to_free_pages+0x20f/0x4b0
>> [ 2162.499137]  [<ffffffff81131864>] try_to_free_pages+0xe4/0x1a0
>> [ 2162.499143]  [<ffffffff81126e9c>] __alloc_pages_nodemask+0x60c/0x9b0
>> [ 2162.499149]  [<ffffffff8116062a>] alloc_pages_current+0xba/0x170
>> [ 2162.499155]  [<ffffffff8112240e>] __get_free_pages+0xe/0x40
>> [ 2162.499159]  [<ffffffff8150ebb3>] mca_data_alloc+0x73/0x1d0
>> [ 2162.499163]  [<ffffffff81510f37>] mca_alloc+0x277/0x470
>> [ 2162.499168]  [<ffffffff81511d1c>] bch_btree_node_alloc+0x8c/0x1c0
>> [ 2162.499173]  [<ffffffff81513020>] btree_split+0x110/0x5c0
>> [ 2162.499179]  [<ffffffff81457d43>] ? scsi_pool_alloc_command+0x33/0x80
>> [ 2162.499184]  [<ffffffff81515fc7>] ? bch_keylist_pop_front+0x47/0x50
>> [ 2162.499188]  [<ffffffff8150fed6>] ? bch_btree_insert_keys+0x56/0x250
>> [ 2162.499193]  [<ffffffff81082def>] ? update_group_power+0x13f/0x220
>> [ 2162.499198]  [<ffffffff81513582>] bch_btree_insert_node+0xb2/0x2f0
>> [ 2162.499202]  [<ffffffff815137e8>] btree_insert_fn+0x28/0x50
>> [ 2162.499207]  [<ffffffff81511b8c>] bch_btree_map_nodes_recurse+0x6c/0x170
>> [ 2162.499211]  [<ffffffff815137c0>] ? bch_btree_insert_node+0x2f0/0x2f0
>> [ 2162.499216]  [<ffffffff816bcc26>] ? down_write+0x16/0x40
>> [ 2162.499221]  [<ffffffff815117a1>] ? bch_btree_node_get+0x71/0x280
>> [ 2162.499225]  [<ffffffff81511c30>] bch_btree_map_nodes_recurse+0x110/0x170
>> [ 2162.499230]  [<ffffffff815137c0>] ? bch_btree_insert_node+0x2f0/0x2f0
>> [ 2162.499235]  [<ffffffff811b51ea>] ? dio_bio_end_io+0x5a/0x90
>> [ 2162.499239]  [<ffffffff8107f991>] ? update_curr+0x141/0x1f0
>> [ 2162.499244]  [<ffffffff81514dce>] __bch_btree_map_nodes+0x13e/0x1c0
>> [ 2162.499248]  [<ffffffff815137c0>] ? bch_btree_insert_node+0x2f0/0x2f0
>> [ 2162.499254]  [<ffffffff8151ac6f>] ? bch_journal+0x42f/0x4b0
>> [ 2162.499258]  [<ffffffff81514f04>] bch_btree_insert+0xb4/0x120
>> [ 2162.499264]  [<ffffffff8151e1be>] bch_data_insert_keys+0x3e/0x160
>> [ 2162.499268]  [<ffffffff810624d4>] process_one_work+0x174/0x490
>> [ 2162.499273]  [<ffffffff8106368b>] worker_thread+0x11b/0x370
>> [ 2162.499278]  [<ffffffff81063570>] ? manage_workers.isra.23+0x2d0/0x2d0
>> [ 2162.499282]  [<ffffffff81069f40>] kthread+0xc0/0xd0
>> [ 2162.499286]  [<ffffffff81069e80>] ? flush_kthread_worker+0xb0/0xb0
>> [ 2162.499292]  [<ffffffff816c795c>] ret_from_fork+0x7c/0xb0
>> [ 2162.499296]  [<ffffffff81069e80>] ? flush_kthread_worker+0xb0/0xb0
>> [ 2162.499299] INFO: task kworker/0:5:2552 blocked for more than 120 seconds.
>> [ 2162.499304] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
>> disables this message.
>> [ 2162.499310] kworker/0:5     D 0000000000000000     0  2552      2 0x00000000
>> [ 2162.499411] Workqueue: events write_dirty_finish
>> [ 2162.499413]  ffff88226314db30 0000000000000046 ffffffff81511b8c
>> ffffffff815137c0
>> [ 2162.499418]  ffff882fa6781990 ffff88226314dfd8 ffff88226314dfd8
>> ffff88226314dfd8
>> [ 2162.499422]  ffff882fa6a84cb0 ffff882fa6781990 ffffffff815117a1
>> ffff882fa6781990
>> [ 2162.499427] Call Trace:
>> [ 2162.499431]  [<ffffffff81511b8c>] ? bch_btree_map_nodes_recurse+0x6c/0x170
>> [ 2162.499435]  [<ffffffff815137c0>] ? bch_btree_insert_node+0x2f0/0x2f0
>> [ 2162.499440]  [<ffffffff815117a1>] ? bch_btree_node_get+0x71/0x280
>> [ 2162.499445]  [<ffffffff816be299>] schedule+0x29/0x70
>> [ 2162.499450]  [<ffffffff816bf0fd>] rwsem_down_read_failed+0x9d/0xe5
>> [ 2162.499455]  [<ffffffff81332c64>] call_rwsem_down_read_failed+0x14/0x30
>> [ 2162.499460]  [<ffffffff816bcc74>] ? down_read+0x24/0x2b
>> [ 2162.499464]  [<ffffffff81514d75>] __bch_btree_map_nodes+0xe5/0x1c0
>> [ 2162.499468]  [<ffffffff815137c0>] ? bch_btree_insert_node+0x2f0/0x2f0
>> [ 2162.499473]  [<ffffffff8151b21e>] ? dirty_io_destructor+0xe/0x10
>> [ 2162.499478]  [<ffffffff81514f04>] bch_btree_insert+0xb4/0x120
>> [ 2162.499483]  [<ffffffff8151b553>] write_dirty_finish+0x1e3/0x270
>> [ 2162.499488]  [<ffffffff8107e7fb>] ? pick_next_task_fair+0x6b/0x150
>> [ 2162.499492]  [<ffffffff810765f3>] ? dequeue_task+0x93/0xb0
>> [ 2162.499497]  [<ffffffff810624d4>] process_one_work+0x174/0x490
>> [ 2162.499502]  [<ffffffff8106368b>] worker_thread+0x11b/0x370
>> [ 2162.499507]  [<ffffffff81063570>] ? manage_workers.isra.23+0x2d0/0x2d0
>> [ 2162.499511]  [<ffffffff81069f40>] kthread+0xc0/0xd0
>> [ 2162.499515]  [<ffffffff81069e80>] ? flush_kthread_worker+0xb0/0xb0
>> [ 2162.499520]  [<ffffffff816c795c>] ret_from_fork+0x7c/0xb0
>> [ 2162.499524]  [<ffffffff81069e80>] ? flush_kthread_worker+0xb0/0xb0
>>
>>
>>
>>>> [  930.169234] bcache: bch_cached_dev_attach() Caching sda3 as bcache0
>>>> on set 06496904-10ca-489a-ae75-68c6a07d3db1
>>>> [ 2522.956188] INFO: task bcache_writebac:2058 blocked for more than
>>>> 120 seconds.
>>>> [ 2522.956199] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
>>>> disables this message.
>>>> [ 2522.956205] bcache_writebac D ffffffff81813a60     0  2058      2 0x00000000
>>>> [ 2522.956212]  ffff881c39c1fcd8 0000000000000046 0000000000000001
>>>> 0000000000000001
>>>> [ 2522.956218]  ffff882f8b56b320 ffff881c39c1ffd8 ffff881c39c1ffd8
>>>> ffff881c39c1ffd8
>>>> [ 2522.956222]  ffff882fa6aeb320 ffff882f8b56b320 ffff882f8b56b320
>>>> ffff882f8b56b320
>>>> [ 2522.956227] Call Trace:
>>>> [ 2522.956241]  [<ffffffff816be299>] schedule+0x29/0x70
>>>> [ 2522.956247]  [<ffffffff816befb5>] rwsem_down_write_failed+0xf5/0x1a0
>>>> [ 2522.956255]  [<ffffffff81332c93>] call_rwsem_down_write_failed+0x13/0x20
>>>> [ 2522.956261]  [<ffffffff816bcc41>] ? down_write+0x31/0x40
>>>> [ 2522.956269]  [<ffffffff8151b782>] bch_writeback_thread+0x62/0x7f0
>>>> [ 2522.956278]  [<ffffffff8108458b>] ? idle_balance+0xeb/0x150
>>>> [ 2522.956284]  [<ffffffff8151b720>] ? write_dirty+0xc0/0xc0
>>>> [ 2522.956290]  [<ffffffff81069f40>] kthread+0xc0/0xd0
>>>> [ 2522.956294]  [<ffffffff81069e80>] ? flush_kthread_worker+0xb0/0xb0
>>>> [ 2522.956302]  [<ffffffff816c795c>] ret_from_fork+0x7c/0xb0
>>>> [ 2522.956306]  [<ffffffff81069e80>] ? flush_kthread_worker+0xb0/0xb0
>>>> [ 2522.956313] INFO: task kworker/u64:1:2433 blocked for more than 120 seconds.
>>>> [ 2522.956317] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
>>>> disables this message.
>>>> [ 2522.956322] kworker/u64:1   D ffffffff81813a60     0  2433      2 0x00000000
>>>> [ 2522.956332] Workqueue: writeback bdi_writeback_workfn (flush-252:0)
>>>> [ 2522.956336]  ffff882f899d1560 0000000000000046 ffffffff81120635
>>>> 0000000000000100
>>>> [ 2522.956340]  ffff88219b488000 ffff882f899d1fd8 ffff882f899d1fd8
>>>> ffff882f899d1fd8
>>>> [ 2522.956345]  ffff882fa6aeb320 ffff88219b488000 ffffffff8131ad55
>>>> ffff88219b488000
>>>> [ 2522.956349] Call Trace:
>>>> [ 2522.956359]  [<ffffffff81120635>] ? mempool_alloc_slab+0x15/0x20
>>>> [ 2522.956367]  [<ffffffff8131ad55>] ? blk_throtl_bio+0x3b5/0x540
>>>> [ 2522.956372]  [<ffffffff816be299>] schedule+0x29/0x70
>>>> [ 2522.956378]  [<ffffffff816bf0fd>] rwsem_down_read_failed+0x9d/0xe5
>>>> [ 2522.956383]  [<ffffffff81332c64>] call_rwsem_down_read_failed+0x14/0x30
>>>> [ 2522.956388]  [<ffffffff816bcc74>] ? down_read+0x24/0x2b
>>>> [ 2522.956394]  [<ffffffff8151fe32>] cached_dev_make_request+0x752/0xf00
>>>> [ 2522.956400]  [<ffffffff81301af8>] ? generic_make_request_checks+0x1e8/0x3a0
>>>> [ 2522.956405]  [<ffffffff81301d7a>] generic_make_request+0xca/0x100
>>>> [ 2522.956409]  [<ffffffff81301e29>] submit_bio+0x79/0x160
>>>> [ 2522.956417]  [<ffffffff811b1710>] ? bio_alloc_bioset+0xa0/0x1d0
>>>> [ 2522.956421]  [<ffffffff811abd3f>] _submit_bh+0x13f/0x200
>>>> [ 2522.956425]  [<ffffffff811abe10>] submit_bh+0x10/0x20
>>>> [ 2522.956430]  [<ffffffff811af6b8>] __block_write_full_page+0x1d8/0x360
>>>> [ 2522.956439]  [<ffffffff8145fc0b>] ? scsi_request_fn+0xbb/0x530
>>>> [ 2522.956444]  [<ffffffff811ad3c0>] ? end_buffer_async_read+0x130/0x130
>>>> [ 2522.956449]  [<ffffffff811b2c40>] ? I_BDEV+0x10/0x10
>>>> [ 2522.956454]  [<ffffffff811b2c40>] ? I_BDEV+0x10/0x10
>>>> [ 2522.956459]  [<ffffffff811af90a>] block_write_full_page_endio+0xca/0x100
>>>> [ 2522.956464]  [<ffffffff811af955>] block_write_full_page+0x15/0x20
>>>> [ 2522.956469]  [<ffffffff811b3608>] blkdev_writepage+0x18/0x20
>>>> [ 2522.956473]  [<ffffffff81127d37>] __writepage+0x17/0x40
>>>> [ 2522.956477]  [<ffffffff8112820e>] write_cache_pages+0x20e/0x460
>>>> [ 2522.956481]  [<ffffffff81127d20>] ? set_page_dirty_lock+0x60/0x60
>>>> [ 2522.956486]  [<ffffffff811ac251>] ? __set_page_dirty+0x71/0xc0
>>>> [ 2522.956490]  [<ffffffff811284aa>] generic_writepages+0x4a/0x70
>>>> [ 2522.956495]  [<ffffffff81129cd0>] do_writepages+0x20/0x40
>>>> [ 2522.956501]  [<ffffffff811a36f5>] __writeback_single_inode+0x45/0x280
>>>> [ 2522.956507]  [<ffffffff811269e2>] ? __alloc_pages_nodemask+0x152/0x9b0
>>>> [ 2522.956513]  [<ffffffff811a495d>] writeback_sb_inodes+0x19d/0x3c0
>>>> [ 2522.956518]  [<ffffffff811a4c1e>] __writeback_inodes_wb+0x9e/0xd0
>>>> [ 2522.956523]  [<ffffffff811a4ecb>] wb_writeback+0x27b/0x320
>>>> [ 2522.956529]  [<ffffffff81196228>] ? get_nr_dirty_inodes+0x58/0x80
>>>> [ 2522.956534]  [<ffffffff811a500f>] wb_check_old_data_flush+0x9f/0xb0
>>>> [ 2522.956539]  [<ffffffff811a67e1>] wb_do_writeback+0x151/0x1d0
>>>> [ 2522.956547]  [<ffffffff8106539f>] ? set_worker_desc+0x6f/0x80
>>>> [ 2522.956552]  [<ffffffff811a68da>] bdi_writeback_workfn+0x7a/0x200
>>>> [ 2522.956557]  [<ffffffff810624d4>] process_one_work+0x174/0x490
>>>> [ 2522.956562]  [<ffffffff8106368b>] worker_thread+0x11b/0x370
>>>> [ 2522.956567]  [<ffffffff81063570>] ? manage_workers.isra.23+0x2d0/0x2d0
>>>> [ 2522.956571]  [<ffffffff81069f40>] kthread+0xc0/0xd0
>>>> [ 2522.956575]  [<ffffffff81069e80>] ? flush_kthread_worker+0xb0/0xb0
>>>> [ 2522.956581]  [<ffffffff816c795c>] ret_from_fork+0x7c/0xb0
>>>> [ 2522.956585]  [<ffffffff81069e80>] ? flush_kthread_worker+0xb0/0xb0
>>>> [ 2522.956588] INFO: task iozone:2435 blocked for more than 120 seconds.
>>>> [ 2522.956593] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
>>>> disables this message.
>>>> [ 2522.956597] iozone          D 0000000000000001     0  2435   1545 0x00000000
>>>> [ 2522.956602]  ffff882a75671978 0000000000000082 ffff882a75671938
>>>> ffffffff81301d7a
>>>> [ 2522.956606]  ffff882f88dc1990 ffff882a75671fd8 ffff882a75671fd8
>>>> ffff882a75671fd8
>>>> [ 2522.956611]  ffff882f8ec91990 ffff882f88dc1990 ffff882a75671978
>>>> ffff882fbf2539f8
>>>> [ 2522.956615] Call Trace:
>>>> [ 2522.956619]  [<ffffffff81301d7a>] ? generic_make_request+0xca/0x100
>>>> [ 2522.956625]  [<ffffffff816be299>] schedule+0x29/0x70
>>>> [ 2522.956630]  [<ffffffff816be36f>] io_schedule+0x8f/0xd0
>>>> [ 2522.956636]  [<ffffffff811b797c>] do_blockdev_direct_IO+0x1a7c/0x1fb0
>>>> [ 2522.956645]  [<ffffffffa0262a80>] ? ext2_get_blocks+0xa60/0xa60 [ext2]
>>>> [ 2522.956652]  [<ffffffff811b7f05>] __blockdev_direct_IO+0x55/0x60
>>>> [ 2522.956658]  [<ffffffffa0262a80>] ? ext2_get_blocks+0xa60/0xa60 [ext2]
>>>> [ 2522.956662]  [<ffffffff8107f991>] ? update_curr+0x141/0x1f0
>>>> [ 2522.956669]  [<ffffffffa0263349>] ext2_direct_IO+0x79/0xe0 [ext2]
>>>> [ 2522.956674]  [<ffffffffa0262a80>] ? ext2_get_blocks+0xa60/0xa60 [ext2]
>>>> [ 2522.956680]  [<ffffffff8104ade6>] ? current_fs_time+0x16/0x60
>>>> [ 2522.956685]  [<ffffffff8111f126>] generic_file_direct_write+0xc6/0x180
>>>> [ 2522.956690]  [<ffffffff8111f4bd>] __generic_file_aio_write+0x2dd/0x3b0
>>>> [ 2522.956696]  [<ffffffff8111f5f9>] generic_file_aio_write+0x69/0xd0
>>>> [ 2522.956702]  [<ffffffff8117b88a>] do_sync_write+0x7a/0xb0
>>>> [ 2522.956706]  [<ffffffff811bb108>] ? fsnotify+0x1f8/0x2b0
>>>> [ 2522.956712]  [<ffffffff8117c63e>] vfs_write+0xce/0x1e0
>>>> [ 2522.956716]  [<ffffffff8117cb22>] SyS_write+0x52/0xa0
>>>> [ 2522.956722]  [<ffffffff816c7a02>] system_call_fastpath+0x16/0x1b
>>>> [ 2522.956726] INFO: task kworker/2:1:2470 blocked for more than 120 seconds.
>>>> [ 2522.956730] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
>>>> disables this message.
>>>> [ 2522.956735] kworker/2:1     D ffffffff81813d40     0  2470      2 0x00000000
>>>> [ 2522.956743] Workqueue: bcache bch_data_insert_keys
>>>> [ 2522.956745]  ffff882a5b0c9628 0000000000000046 ffff882a5b0c9648
>>>> 0000004000000000
>>>> [ 2522.956749]  ffff882f8ec91990 ffff882a5b0c9fd8 ffff882a5b0c9fd8
>>>> ffff882a5b0c9fd8
>>>> [ 2522.956754]  ffff882fa6489990 ffff882f8ec91990 ffff882f8ec91990
>>>> ffff8828dba00d98
>>>> [ 2522.956758] Call Trace:
>>>> [ 2522.956763]  [<ffffffff816be299>] schedule+0x29/0x70
>>>> [ 2522.956769]  [<ffffffff816be57e>] schedule_preempt_disabled+0xe/0x10
>>>> [ 2522.956774]  [<ffffffff816bc862>] __mutex_lock_slowpath+0x112/0x1b0
>>>> [ 2522.956779]  [<ffffffff816bc3da>] mutex_lock+0x2a/0x50
>>>> [ 2522.956783]  [<ffffffff815112e5>] bch_mca_shrink+0x1b5/0x2f0
>>>> [ 2522.956791]  [<ffffffff8117fc32>] ? prune_super+0x162/0x1b0
>>>> [ 2522.956799]  [<ffffffff8112ebb4>] shrink_slab+0x154/0x300
>>>> [ 2522.956805]  [<ffffffff81076828>] ? resched_task+0x68/0x70
>>>> [ 2522.956810]  [<ffffffff81077165>] ? check_preempt_curr+0x75/0xa0
>>>> [ 2522.956816]  [<ffffffff8113a379>] ? fragmentation_index+0x19/0x70
>>>> [ 2522.956822]  [<ffffffff8113140f>] do_try_to_free_pages+0x20f/0x4b0
>>>> [ 2522.956827]  [<ffffffff81131864>] try_to_free_pages+0xe4/0x1a0
>>>> [ 2522.956833]  [<ffffffff81126e9c>] __alloc_pages_nodemask+0x60c/0x9b0
>>>> [ 2522.956843]  [<ffffffff8116062a>] alloc_pages_current+0xba/0x170
>>>> [ 2522.956848]  [<ffffffff8112240e>] __get_free_pages+0xe/0x40
>>>> [ 2522.956852]  [<ffffffff8150ebb3>] mca_data_alloc+0x73/0x1d0
>>>> [ 2522.956857]  [<ffffffff8150ee5a>] mca_bucket_alloc+0x14a/0x1f0
>>>> [ 2522.956861]  [<ffffffff81511020>] mca_alloc+0x360/0x470
>>>> [ 2522.956866]  [<ffffffff81517031>] ? __bch_bset_search+0x1d1/0x480
>>>> [ 2522.956871]  [<ffffffff8151183e>] bch_btree_node_get+0x10e/0x280
>>>> [ 2522.956875]  [<ffffffff81511c02>] bch_btree_map_nodes_recurse+0xe2/0x170
>>>> [ 2522.956880]  [<ffffffff815137c0>] ? bch_btree_insert_node+0x2f0/0x2f0
>>>> [ 2522.956886]  [<ffffffff811b51ea>] ? dio_bio_end_io+0x5a/0x90
>>>> [ 2522.956890]  [<ffffffff8107f991>] ? update_curr+0x141/0x1f0
>>>> [ 2522.956895]  [<ffffffff81514dce>] __bch_btree_map_nodes+0x13e/0x1c0
>>>> [ 2522.956899]  [<ffffffff815137c0>] ? bch_btree_insert_node+0x2f0/0x2f0
>>>> [ 2522.956905]  [<ffffffff8151ac6f>] ? bch_journal+0x42f/0x4b0
>>>> [ 2522.956909]  [<ffffffff81514f04>] bch_btree_insert+0xb4/0x120
>>>> [ 2522.956915]  [<ffffffff8151e1be>] bch_data_insert_keys+0x3e/0x160
>>>> [ 2522.956920]  [<ffffffff810624d4>] process_one_work+0x174/0x490
>>>> [ 2522.956925]  [<ffffffff8106368b>] worker_thread+0x11b/0x370
>>>> [ 2522.956930]  [<ffffffff81063570>] ? manage_workers.isra.23+0x2d0/0x2d0
>>>> [ 2522.956933]  [<ffffffff81069f40>] kthread+0xc0/0xd0
>>>> [ 2522.956938]  [<ffffffff81069e80>] ? flush_kthread_worker+0xb0/0xb0
>>>> [ 2522.956943]  [<ffffffff816c795c>] ret_from_fork+0x7c/0xb0
>>>> [ 2522.956947]  [<ffffffff81069e80>] ? flush_kthread_worker+0xb0/0xb0
>>>> [ 2522.956951] INFO: task kworker/3:2:2471 blocked for more than 120 seconds.
>>>> [ 2522.956955] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
>>>> disables this message.
>>>> [ 2522.956959] kworker/3:2     D ffffffff81813a60     0  2471      2 0x00000000
>>>> [ 2522.956966] Workqueue: events update_writeback_rate
>>>> [ 2522.956968]  ffff882a5d125cd0 0000000000000046 0000000000000003
>>>> ffff882a5d125d68
>>>> [ 2522.956972]  ffff882f8ec94cb0 ffff882a5d125fd8 ffff882a5d125fd8
>>>> ffff882a5d125fd8
>>>> [ 2522.956977]  ffff882fa6aeb320 ffff882f8ec94cb0 0000000200000003
>>>> ffff882f8ec94cb0
>>>> [ 2522.956981] Call Trace:
>>>> [ 2522.956987]  [<ffffffff816be299>] schedule+0x29/0x70
>>>> [ 2522.956992]  [<ffffffff816bf0fd>] rwsem_down_read_failed+0x9d/0xe5
>>>> [ 2522.956997]  [<ffffffff81332c64>] call_rwsem_down_read_failed+0x14/0x30
>>>> [ 2522.957002]  [<ffffffff816bcc74>] ? down_read+0x24/0x2b
>>>> [ 2522.957007]  [<ffffffff8151b010>] update_writeback_rate+0x30/0x230
>>>> [ 2522.957011]  [<ffffffff810624d4>] process_one_work+0x174/0x490
>>>> [ 2522.957017]  [<ffffffff8106368b>] worker_thread+0x11b/0x370
>>>> [ 2522.957021]  [<ffffffff81063570>] ? manage_workers.isra.23+0x2d0/0x2d0
>>>> [ 2522.957025]  [<ffffffff81069f40>] kthread+0xc0/0xd0
>>>> [ 2522.957030]  [<ffffffff81069e80>] ? flush_kthread_worker+0xb0/0xb0
>>>> [ 2522.957035]  [<ffffffff816c795c>] ret_from_fork+0x7c/0xb0
>>>> [ 2522.957039]  [<ffffffff81069e80>] ? flush_kthread_worker+0xb0/0xb0
>>>> [ 2522.957048] INFO: task kworker/u64:2:2540 blocked for more than 120 seconds.
>>>> [ 2522.957052] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
>>>> disables this message.
>>>> [ 2522.957056] kworker/u64:2   D ffffffff81813a60     0  2540      2 0x00000000
>>>> [ 2522.957062] Workqueue: bch_btree_io btree_node_write_work
>>>> [ 2522.957064]  ffff882a4fdc9778 0000000000000046 ffff882a4fdc9738
>>>> ffff882f86e3be58
>>>> [ 2522.957069]  ffff882fa4bc1990 ffff882a4fdc9fd8 ffff882a4fdc9fd8
>>>> ffff882a4fdc9fd8
>>>> [ 2522.957073]  ffff882fa6aeb320 ffff882fa4bc1990 ffff882f86e3be00
>>>> ffff8828dba00d98
>>>> [ 2522.957078] Call Trace:
>>>> [ 2522.957083]  [<ffffffff816be299>] schedule+0x29/0x70
>>>> [ 2522.957088]  [<ffffffff816be57e>] schedule_preempt_disabled+0xe/0x10
>>>> [ 2522.957092]  [<ffffffff816bc862>] __mutex_lock_slowpath+0x112/0x1b0
>>>> [ 2522.957102]  [<ffffffff81484090>] ? ata_scsiop_mode_sense+0x380/0x380
>>>> [ 2522.957107]  [<ffffffff816bc3da>] mutex_lock+0x2a/0x50
>>>> [ 2522.957111]  [<ffffffff815112e5>] bch_mca_shrink+0x1b5/0x2f0
>>>> [ 2522.957116]  [<ffffffff8117fc32>] ? prune_super+0x162/0x1b0
>>>> [ 2522.957121]  [<ffffffff8112ebb4>] shrink_slab+0x154/0x300
>>>> [ 2522.957126]  [<ffffffff81076828>] ? resched_task+0x68/0x70
>>>> [ 2522.957130]  [<ffffffff81077165>] ? check_preempt_curr+0x75/0xa0
>>>> [ 2522.957135]  [<ffffffff8113a379>] ? fragmentation_index+0x19/0x70
>>>> [ 2522.957140]  [<ffffffff8113140f>] do_try_to_free_pages+0x20f/0x4b0
>>>> [ 2522.957146]  [<ffffffff81131864>] try_to_free_pages+0xe4/0x1a0
>>>> [ 2522.957152]  [<ffffffff81126e9c>] __alloc_pages_nodemask+0x60c/0x9b0
>>>> [ 2522.957158]  [<ffffffff8116062a>] alloc_pages_current+0xba/0x170
>>>> [ 2522.957163]  [<ffffffff8112240e>] __get_free_pages+0xe/0x40
>>>> [ 2522.957168]  [<ffffffff81517fc8>] __btree_sort+0x48/0x230
>>>> [ 2522.957173]  [<ffffffff8151765c>] ? __bch_btree_iter_init+0x7c/0xc0
>>>> [ 2522.957178]  [<ffffffff81518301>] bch_btree_sort_partial+0x101/0x120
>>>> [ 2522.957182]  [<ffffffff8150f000>] ? __btree_node_write_done+0x100/0x100
>>>> [ 2522.957187]  [<ffffffff81518468>] bch_btree_sort_lazy+0x68/0x90
>>>> [ 2522.957191]  [<ffffffff815109ba>] bch_btree_node_write+0x36a/0x4a0
>>>> [ 2522.957196]  [<ffffffff8108458b>] ? idle_balance+0xeb/0x150
>>>> [ 2522.957201]  [<ffffffff8106212c>] ? pwq_activate_delayed_work+0x4c/0xb0
>>>> [ 2522.957205]  [<ffffffff81511477>] btree_node_write_work+0x57/0x80
>>>> [ 2522.957210]  [<ffffffff810624d4>] process_one_work+0x174/0x490
>>>> [ 2522.957215]  [<ffffffff8106368b>] worker_thread+0x11b/0x370
>>>> [ 2522.957219]  [<ffffffff81063570>] ? manage_workers.isra.23+0x2d0/0x2d0
>>>> [ 2522.957223]  [<ffffffff81069f40>] kthread+0xc0/0xd0
>>>> [ 2522.957228]  [<ffffffff81069e80>] ? flush_kthread_worker+0xb0/0xb0
>>>> [ 2522.957233]  [<ffffffff816c795c>] ret_from_fork+0x7c/0xb0
>>>> [ 2522.957237]  [<ffffffff81069e80>] ? flush_kthread_worker+0xb0/0xb0
>>>>
>>>>
>>>> I can easily reproduce this, please let me know if you require any
>>>> info/test any patch.
>>>>
>>>> Thanks,
>>>> Neo
>>>>
>>>> On Mon, Aug 26, 2013 at 12:21 PM, Stefan Priebe <s.priebe@profihost.ag> wrote:
>>>>> Hi Kent,
>>>>>
>>>>> a new one under 3.10:
>>>>>
>>>>> 2013-08-26 21:05:30     INFO: task ceph-osd:8939 blocked for more than 120
>>>>> seconds.
>>>>> 2013-08-26 21:05:30     "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
>>>>> disables this message.
>>>>> 2013-08-26 21:05:30     ceph-osd D ffffffff8160f760 0 8939 1 0x00000000
>>>>> 2013-08-26 21:05:30     ffff880bd9a61820 0000000000000086 ffff880bd9a61fd8
>>>>> 0000000000012c80
>>>>> 2013-08-26 21:05:30     ffff880bd9a60010 0000000000012c80 0000000000012c80
>>>>> 0000000000012c80
>>>>> 2013-08-26 21:05:30     ffff880bd9a61fd8 0000000000012c80 ffff880bd7abb1c0
>>>>> ffff880c48dee380
>>>>> 2013-08-26 21:05:29     [<ffffffff811e8128>] xfs_vm_readpages+0x18/0x20
>>>>> 2013-08-26 21:05:29     [<ffffffff810f1da3>] read_pages+0x43/0x100
>>>>> 2013-08-26 21:05:29     [<ffffffff810e64df>] ? __page_cache_alloc+0x9f/0xc0
>>>>> 2013-08-26 21:05:29     [<ffffffff810f1fab>]
>>>>> __do_page_cache_readahead+0x14b/0x160
>>>>> 2013-08-26 21:05:29     [<ffffffff810f1fdc>] ra_submit+0x1c/0x20
>>>>> 2013-08-26 21:05:29     [<ffffffff810f22a5>] ondemand_readahead+0x115/0x240
>>>>> 2013-08-26 21:05:29     [<ffffffff810f249e>]
>>>>> page_cache_sync_readahead+0x2e/0x40
>>>>> 2013-08-26 21:05:29     [<ffffffff810e7a5e>] T.1003+0x33e/0x430
>>>>> 2013-08-26 21:05:29     [<ffffffff810e7c30>]
>>>>> generic_file_aio_read+0xe0/0x220
>>>>> 2013-08-26 21:05:29     [<ffffffff811efd0a>] xfs_file_aio_read+0x15a/0x2a0
>>>>> 2013-08-26 21:05:29     [<ffffffff8114095a>] do_sync_read+0x7a/0xb0
>>>>> 2013-08-26 21:05:29     [<ffffffff81140df1>] vfs_read+0xb1/0x130
>>>>> 2013-08-26 21:05:29     [<ffffffff81141757>] SyS_pread64+0x97/0xa0
>>>>> 2013-08-26 21:05:29     [<ffffffff81526b12>] system_call_fastpath+0x16/0x1b
>>>>> 2013-08-26 21:05:29     INFO: task ceph-osd:8896 blocked for more than 120
>>>>> seconds.
>>>>> 2013-08-26 21:05:29     "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
>>>>> disables this message.
>>>>> 2013-08-26 21:05:29     ceph-osd D ffffffff8160f760 0 8896 1 0x00000000
>>>>> 2013-08-26 21:05:29     ffff880bd9a9dc28 0000000000000086 ffff880bd9a9dfd8
>>>>> 0000000000012c80
>>>>> 2013-08-26 21:05:29     ffff880bd9a9c010 0000000000012c80 0000000000012c80
>>>>> 0000000000012c80
>>>>> 2013-08-26 21:05:29     ffff880bd9a9dfd8 0000000000012c80 ffff880bd79298e0
>>>>> ffff880c48dd6380
>>>>> 2013-08-26 21:05:29     Call Trace:
>>>>> 2013-08-26 21:05:29     [<ffffffff810e60f0>] ? __lock_page+0x70/0x70
>>>>> 2013-08-26 21:05:28     "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
>>>>> disables this message.
>>>>> 2013-08-26 21:05:28     ceph-osd D ffffffff8160f760 0 8798 1 0x00000000
>>>>> 2013-08-26 21:05:28     ffff880bd998b740 0000000000000086 ffff880bd998bfd8
>>>>> 0000000000012c80
>>>>> 2013-08-26 21:05:28     ffff880bd998a010 0000000000012c80 0000000000012c80
>>>>> 0000000000012c80
>>>>> 2013-08-26 21:05:28     ffff880bd998bfd8 0000000000012c80 ffff880bd99c0000
>>>>> ffff880c48dd6380
>>>>> 2013-08-26 21:05:28     Call Trace:
>>>>> 2013-08-26 21:05:28     [<ffffffff81524874>] schedule+0x24/0x70
>>>>> 2013-08-26 21:05:28     [<ffffffff81525d7d>]
>>>>> rwsem_down_read_failed+0x9d/0xe5
>>>>> 2013-08-26 21:05:28     [<ffffffff812aa0a4>]
>>>>> call_rwsem_down_read_failed+0x14/0x30
>>>>> 2013-08-26 21:05:28     [<ffffffff81523a42>] ? down_read+0x12/0x20
>>>>> 2013-08-26 21:05:28     [<ffffffffa01ead62>] btree_read_async+0xa2/0x1a0
>>>>> [bcache]
>>>>> 2013-08-26 21:05:28     [<ffffffffa01f7b73>] closure_queue+0x43/0x60
>>>>> [bcache]
>>>>> 2013-08-26 21:05:28     [<ffffffffa01eb903>] T.1050+0x63/0x70 [bcache]
>>>>> 2013-08-26 21:05:28     [<ffffffffa01ed6ea>]
>>>>> cached_dev_make_request+0x20a/0x350 [bcache]
>>>>> 2013-08-26 21:05:28     [<ffffffff81281952>] generic_make_request+0xc2/0x100
>>>>> 2013-08-26 21:05:28     [<ffffffff812819f7>] submit_bio+0x67/0x130
>>>>> 2013-08-26 21:05:28     [<ffffffff8117b240>] do_mpage_readpage+0x2a0/0x660
>>>>> 2013-08-26 21:05:28     [<ffffffff81101cee>] ?
>>>>> __inc_zone_page_state+0x2e/0x30
>>>>> 2013-08-26 21:05:28     [<ffffffff810e6581>] ?
>>>>> add_to_page_cache_locked+0x81/0x110
>>>>> 2013-08-26 21:05:28     [<ffffffff8117b76a>] mpage_readpages+0xfa/0x150
>>>>> 2013-08-26 21:05:28     [<ffffffff811e90c0>] ?
>>>>> xfs_get_blocks_direct+0x20/0x20
>>>>> 2013-08-26 21:05:28     [<ffffffff811e90c0>] ?
>>>>> xfs_get_blocks_direct+0x20/0x20
>>>>> 2013-08-26 21:05:28     [<ffffffff810eeda3>] ?
>>>>> __alloc_pages_nodemask+0x123/0x240
>>>>> 2013-08-26 21:05:27     [<ffffffff8115bf93>] ? __close_fd+0x43/0x80
>>>>> 2013-08-26 21:05:27     [<ffffffff8116dabe>] SyS_fdatasync+0xe/0x20
>>>>> 2013-08-26 21:05:27     [<ffffffff81526b12>] system_call_fastpath+0x16/0x1b
>>>>> 2013-08-26 21:05:27     INFO: task ceph-osd:8746 blocked for more than 120
>>>>> seconds.
>>>>> 2013-08-26 21:05:27     "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
>>>>> disables this message.
>>>>> 2013-08-26 21:05:27     ceph-osd D ffffffff8160f760 0 8746 1 0x00000000
>>>>> 2013-08-26 21:05:27     ffff880c2dde1d38 0000000000000086 ffff880c2dde1fd8
>>>>> 0000000000012c80
>>>>> 2013-08-26 21:05:27     ffff880c2dde0010 0000000000012c80 0000000000012c80
>>>>> 0000000000012c80
>>>>> 2013-08-26 21:05:27     ffff880c2dde1fd8 0000000000012c80 ffff880c239eb1c0
>>>>> ffff880c48dd6380
>>>>> 2013-08-26 21:05:27     Call Trace:
>>>>> 2013-08-26 21:05:27     [<ffffffff81524874>] schedule+0x24/0x70
>>>>> 2013-08-26 21:05:27     [<ffffffff81522bbd>] schedule_timeout+0x16d/0x200
>>>>> 2013-08-26 21:05:27     [<ffffffff81068eba>] ?
>>>>> __queue_delayed_work+0xaa/0x1a0
>>>>> 2013-08-26 21:05:27     [<ffffffff81068d19>] ?
>>>>> try_to_grab_pending+0x109/0x190
>>>>> 2013-08-26 21:05:27     [<ffffffff815251e5>] wait_for_completion+0x95/0x110
>>>>> 2013-08-26 21:05:27     [<ffffffff8107fd00>] ? try_to_wake_up+0x2a0/0x2a0
>>>>> 2013-08-26 21:05:27     [<ffffffff81167797>] ? bdi_queue_work+0x77/0xc0
>>>>> 2013-08-26 21:05:27     [<ffffffff81167863>]
>>>>> writeback_inodes_sb_nr+0x83/0xb0
>>>>> 2013-08-26 21:05:27     [<ffffffff811678ea>] writeback_inodes_sb+0x5a/0x70
>>>>> 2013-08-26 21:05:27     [<ffffffff8116dd0a>] __sync_filesystem+0x4a/0x50
>>>>> 2013-08-26 21:05:27     [<ffffffff8116dd42>] sync_filesystem+0x32/0x60
>>>>> 2013-08-26 21:05:27     [<ffffffff8116ddc0>] SyS_syncfs+0x50/0x90
>>>>> 2013-08-26 21:05:27     [<ffffffff81526b12>] system_call_fastpath+0x16/0x1b
>>>>> 2013-08-26 21:05:27     INFO: task ceph-osd:8798 blocked for more than 120
>>>>> seconds.
>>>>>
>>>>> Stefan
>>>>>
>>>>> Am 22.08.2013 09:32, schrieb Stefan Priebe - Profihost AG:
>>>>>
>>>>>> great!
>>>>>>
>>>>>> Everything seems to work fine now! Except read_dirty always going to
>>>>>> negative values after a reboot.
>>>>>>
>>>>>> Stefan
>>>>>>
>>>>>> Am 22.08.2013 08:02, schrieb Kent Overstreet:
>>>>>>>
>>>>>>> On Thu, Aug 22, 2013 at 07:59:04AM +0200, Stefan Priebe wrote:
>>>>>>>>
>>>>>>>>
>>>>>>>>> schedule_timeout() is not the same as
>>>>>>>>> schedule_timeout_interruptible().
>>>>>>>>
>>>>>>>>
>>>>>>>> just search and replace? So i can try on my own.
>>>>>>>
>>>>>>>
>>>>>>> The one in read_dirty(), line ~330
>>>>>>> --
>>>>>>> To unsubscribe from this list: send the line "unsubscribe linux-bcache"
>>>>>>> in
>>>>>>> the body of a message to majordomo@vger.kernel.org
>>>>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>>> --
>>>>> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
>>>>> the body of a message to majordomo@vger.kernel.org
>>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
