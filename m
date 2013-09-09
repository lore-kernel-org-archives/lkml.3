Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751464Ab3III6Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 04:58:16 -0400
Received: from mail-la0-f52.google.com ([209.85.215.52]:53402 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751025Ab3III6O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 04:58:14 -0400
MIME-Version: 1.0
Date: Mon, 9 Sep 2013 10:58:12 +0200
Message-ID: <CAE2SPAa-2NY3OKKSbmTY1fsaSD62BXwjNTRhGnrqdRGKd4z4KQ@mail.gmail.com>
Subject: [3.10.7] Reproductible soft lockup, recover but freeze even the mouse
From: Bastien ROUCARIES <roucaries.bastien@gmail.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: Neil Brown <neilb@suse.de>, "Theodore Ts'o" <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I experiment a soft lockup. during 20 s I have no mouse, could not
switch back to console and so on.

I achieve to get a backtrace by echo 15 >
/proc/sys/kernel/hung_task_timeout_secs

Seems file system related (hdd led is on).

My filesystems are ext4 over raid0 so add some cc

How can I debug ?

It seems related to fsync but not sure why it should lockup my
box.Look like firefox is the source of fsync. Get some bugreport about
this on:
- https://bugs.launchpad.net/ubuntu/+source/firefox-3.5/+bug/510656

I see a thread "Excessive stall times on ext4 in 3.9-rc2" and question
about "Question about ext4 excessive stall time" that this bug was
worked arround for 3.10 but it seems it is not the case if it is the
same bug.

Bastien

[ 5313.553442] INFO: task jbd2/dm-0-8:349 blocked for more than 15 seconds.
[ 5313.553445] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[ 5313.553447] jbd2/dm-0-8     D ffff88042dc53f40     0   349      2 0x00000000
[ 5313.553451]  ffff8804191ba780 0000000000000046 ffff88041d0d8040
0000000000013f40
[ 5313.553455]  ffff88041909dfd8 ffff88041909dfd8 ffff8804191ba780
ffff88042dc53f40
[ 5313.553458]  ffff8804191ba780 ffff88041909dcc8 ffffffff8112c313
0000000000000002
[ 5313.553461] Call Trace:
[ 5313.553467]  [<ffffffff8112c313>] ? do_thaw_one+0x6d/0x6d
[ 5313.553472]  [<ffffffff8138518e>] ? io_schedule+0x54/0x69
[ 5313.553475]  [<ffffffff8112c318>] ? sleep_on_buffer+0x5/0x8
[ 5313.553477]  [<ffffffff81383fad>] ? __wait_on_bit+0x3b/0x6e
[ 5313.553480]  [<ffffffff8138404d>] ? out_of_line_wait_on_bit+0x6d/0x76
[ 5313.553482]  [<ffffffff8112c313>] ? do_thaw_one+0x6d/0x6d
[ 5313.553486]  [<ffffffff81057c91>] ? autoremove_wake_function+0x2a/0x2a
[ 5313.553506]  [<ffffffffa023efdd>] ?
jbd2_journal_commit_transaction+0xdaa/0x138b [jbd2]
[ 5313.553509]  [<ffffffff81385ace>] ? _raw_spin_lock_irqsave+0x14/0x35
[ 5313.553516]  [<ffffffffa024355d>] ? kjournald2+0xb7/0x239 [jbd2]
[ 5313.553519]  [<ffffffff81057c67>] ? abort_exclusive_wait+0x79/0x79
[ 5313.553524]  [<ffffffffa02434a6>] ? jbd2_superblock_csum+0x31/0x31 [jbd2]
[ 5313.553527]  [<ffffffff8105730f>] ? kthread+0x7d/0x85
[ 5313.553529]  [<ffffffff81057292>] ? __kthread_parkme+0x59/0x59
[ 5313.553532]  [<ffffffff8138ad3c>] ? ret_from_fork+0x7c/0xb0
[ 5313.553535]  [<ffffffff81057292>] ? __kthread_parkme+0x59/0x59
[ 5313.553539] INFO: task kworker/2:2:726 blocked for more than 15 seconds.
[ 5313.553540] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[ 5313.553541] kworker/2:2     D ffff88042dc53f40     0   726      2 0x00000000
[ 5313.553550] Workqueue: md submit_flushes [md_mod]
[ 5313.553552]  ffff880417ba77c0 0000000000000046 ffff88041d0d8040
0000000000013f40
[ 5313.553554]  ffff88041b21bfd8 ffff88041b21bfd8 ffff880417ba77c0
ffff88042dc53f40
[ 5313.553557]  ffff880417ba77c0 0000000000000000 ffff88041c68e3a0
ffff88021c8f5440
[ 5313.553560] Call Trace:
[ 5313.553563]  [<ffffffff8138518e>] ? io_schedule+0x54/0x69
[ 5313.553566]  [<ffffffff811a7621>] ? get_request+0x4b1/0x55e
[ 5313.553570]  [<ffffffff810f937e>] ? ____cache_alloc+0x1d3/0x290
[ 5313.553573]  [<ffffffff81057c67>] ? abort_exclusive_wait+0x79/0x79
[ 5313.553576]  [<ffffffff811a94e9>] ? blk_queue_bio+0x1c0/0x2e8
[ 5313.553578]  [<ffffffff811a7a86>] ? generic_make_request+0x96/0xd5
[ 5313.553581]  [<ffffffff811a8672>] ? submit_bio+0x10a/0x13b
[ 5313.553584]  [<ffffffff8113035c>] ? bio_alloc_bioset+0xd0/0x172
[ 5313.553590]  [<ffffffffa0159185>] ? submit_flushes+0xbe/0x116 [md_mod]
[ 5313.553594]  [<ffffffff81052a60>] ? process_one_work+0x18b/0x287
[ 5313.553597]  [<ffffffff81052f05>] ? worker_thread+0x121/0x1e7
[ 5313.553599]  [<ffffffff81052de4>] ? rescuer_thread+0x265/0x265
[ 5313.553602]  [<ffffffff8105730f>] ? kthread+0x7d/0x85
[ 5313.553604]  [<ffffffff81057292>] ? __kthread_parkme+0x59/0x59
[ 5313.553607]  [<ffffffff8138ad3c>] ? ret_from_fork+0x7c/0xb0
[ 5313.553609]  [<ffffffff81057292>] ? __kthread_parkme+0x59/0x59
[ 5313.553614] INFO: task jbd2/dm-1-8:1601 blocked for more than 15 seconds.
[ 5313.553615] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[ 5313.553617] jbd2/dm-1-8     D ffff88042dc13f40     0  1601      2 0x00000000
[ 5313.553619]  ffff880419bfc800 0000000000000046 ffffffff81613400
0000000000013f40
[ 5313.553622]  ffff88041b365fd8 ffff88041b365fd8 ffff880419bfc800
ffff88042dc13f40
[ 5313.553625]  ffff880419bfc800 ffff88041b365cc8 ffffffff8112c313
0000000000000002
[ 5313.553627] Call Trace:
[ 5313.553630]  [<ffffffff8112c313>] ? do_thaw_one+0x6d/0x6d
[ 5313.553633]  [<ffffffff8138518e>] ? io_schedule+0x54/0x69
[ 5313.553635]  [<ffffffff8112c318>] ? sleep_on_buffer+0x5/0x8
[ 5313.553638]  [<ffffffff81383fad>] ? __wait_on_bit+0x3b/0x6e
[ 5313.553640]  [<ffffffff8138404d>] ? out_of_line_wait_on_bit+0x6d/0x76
[ 5313.553642]  [<ffffffff8112c313>] ? do_thaw_one+0x6d/0x6d
[ 5313.553645]  [<ffffffff81057c91>] ? autoremove_wake_function+0x2a/0x2a
[ 5313.553651]  [<ffffffffa023efdd>] ?
jbd2_journal_commit_transaction+0xdaa/0x138b [jbd2]
[ 5313.553655]  [<ffffffff81385ace>] ? _raw_spin_lock_irqsave+0x14/0x35
[ 5313.553661]  [<ffffffffa024355d>] ? kjournald2+0xb7/0x239 [jbd2]
[ 5313.553664]  [<ffffffff81057c67>] ? abort_exclusive_wait+0x79/0x79
[ 5313.553669]  [<ffffffffa02434a6>] ? jbd2_superblock_csum+0x31/0x31 [jbd2]
[ 5313.553672]  [<ffffffff8105730f>] ? kthread+0x7d/0x85
[ 5313.553675]  [<ffffffff810408ef>] ? do_exit+0x901/0x918
[ 5313.553678]  [<ffffffff81057292>] ? __kthread_parkme+0x59/0x59
[ 5313.553680]  [<ffffffff8138ad3c>] ? ret_from_fork+0x7c/0xb0
[ 5313.553683]  [<ffffffff81057292>] ? __kthread_parkme+0x59/0x59
[ 5313.553721] INFO: task mysqld:5039 blocked for more than 15 seconds.
[ 5313.553722] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[ 5313.553724] mysqld          D ffff88042dc13f40     0  5039   5029 0x00000000
[ 5313.553726]  ffff8804190a2080 0000000000000086 ffffffff81613400
0000000000013f40
[ 5313.553729]  ffff8803f0943fd8 ffff8803f0943fd8 ffff8804190a2080
ffff88041a212000
[ 5313.553732]  ffff8803f0943eb0 ffff88041a212024 00000000008180f2
ffff8803f0943ec8
[ 5313.553734] Call Trace:
[ 5313.553742]  [<ffffffffa0242d40>] ? jbd2_log_wait_commit+0xc3/0x118 [jbd2]
[ 5313.553744]  [<ffffffff81057c67>] ? abort_exclusive_wait+0x79/0x79
[ 5313.553753]  [<ffffffffa026296b>] ? ext4_sync_file+0x269/0x2ec [ext4]
[ 5313.553757]  [<ffffffff8112af9e>] ? do_fsync+0x2b/0x4e
[ 5313.553760]  [<ffffffff8113eb8d>] ? SyS_io_getevents+0x64/0x78
[ 5313.553763]  [<ffffffff8112b185>] ? SyS_fsync+0x7/0xa
[ 5313.553766]  [<ffffffff8138ade9>] ? system_call_fastpath+0x16/0x1b
[ 5313.553785] INFO: task virtuoso-t:5274 blocked for more than 15 seconds.
[ 5313.553786] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[ 5313.553787] virtuoso-t      D ffff88042dc33f40     0  5274   5062 0x00000000
[ 5313.553790]  ffff88041a297100 0000000000000086 ffff88041d0d8780
0000000000013f40
[ 5313.553792]  ffff8803d6a99fd8 ffff8803d6a99fd8 ffff88041a297100
ffff88042dc33f40
[ 5313.553794]  ffff88041a297100 0000000000000005 ffff88041926b130
ffff88041c4026e0
[ 5313.553797] Call Trace:
[ 5313.553800]  [<ffffffff8138518e>] ? io_schedule+0x54/0x69
[ 5313.553802]  [<ffffffff811a7621>] ? get_request+0x4b1/0x55e
[ 5313.553806]  [<ffffffff811ab201>] ? ioc_lookup_icq+0x23/0x3b
[ 5313.553808]  [<ffffffff81057c67>] ? abort_exclusive_wait+0x79/0x79
[ 5313.553811]  [<ffffffff811a94e9>] ? blk_queue_bio+0x1c0/0x2e8
[ 5313.553819]  [<ffffffffa016f8b0>] ? dm_request+0x14c/0x15e [dm_mod]
[ 5313.553821]  [<ffffffff811a7a86>] ? generic_make_request+0x96/0xd5
[ 5313.553823]  [<ffffffff811a8672>] ? submit_bio+0x10a/0x13b
[ 5313.553831]  [<ffffffffa026b66d>] ? ext4_io_submit+0x21/0x4a [ext4]
[ 5313.553839]  [<ffffffffa0265611>] ? mpage_da_submit_io+0x26a/0x280 [ext4]
[ 5313.553847]  [<ffffffffa0269fc4>] ?
mpage_da_map_and_submit+0x314/0x32a [ext4]
[ 5313.553855]  [<ffffffffa026a0eb>] ? write_cache_pages_da+0x111/0x360 [ext4]
[ 5313.553863]  [<ffffffffa026a5af>] ? ext4_da_writepages+0x275/0x447 [ext4]
[ 5313.553867]  [<ffffffff810c175a>] ? __filemap_fdatawrite_range+0x4d/0x52
[ 5313.553869]  [<ffffffff810c177f>] ? filemap_write_and_wait_range+0x20/0x50
[ 5313.553876]  [<ffffffffa0262786>] ? ext4_sync_file+0x84/0x2ec [ext4]
[ 5313.553880]  [<ffffffff8112af9e>] ? do_fsync+0x2b/0x4e
[ 5313.553882]  [<ffffffff8112b185>] ? SyS_fsync+0x7/0xa
[ 5313.553885]  [<ffffffff8138ade9>] ? system_call_fastpath+0x16/0x1b
[ 5313.553901] INFO: task kworker/0:0:17733 blocked for more than 15 seconds.
[ 5313.553902] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[ 5313.553904] kworker/0:0     D ffff88042dc13f40     0 17733      2 0x00000000
[ 5313.553911] Workqueue: kdmflush dm_wq_work [dm_mod]
[ 5313.553912]  ffff8804199ba040 0000000000000046 ffffffff81613400
0000000000013f40
[ 5313.553915]  ffff880210f15fd8 ffff880210f15fd8 ffff8804199ba040
ffff88042dc13f40
[ 5313.553918]  ffff8804199ba040 0000000000000000 ffff880418bee7b0
ffff8803e14496a0
[ 5313.553921] Call Trace:
[ 5313.553924]  [<ffffffff8138518e>] ? io_schedule+0x54/0x69
[ 5313.553926]  [<ffffffff811a7621>] ? get_request+0x4b1/0x55e
[ 5313.553929]  [<ffffffff81057c67>] ? abort_exclusive_wait+0x79/0x79
[ 5313.553931]  [<ffffffff811a94e9>] ? blk_queue_bio+0x1c0/0x2e8
[ 5313.553934]  [<ffffffff811a7a86>] ? generic_make_request+0x96/0xd5
[ 5313.553940]  [<ffffffffa016f0c0>] ?
__clone_and_map_data_bio+0x1cd/0x1ee [dm_mod]
[ 5313.553946]  [<ffffffffa016f5ba>] ?
__split_and_process_bio+0x276/0x420 [dm_mod]
[ 5313.553951]  [<ffffffffa016f960>] ? dm_wq_work+0x9e/0xb7 [dm_mod]
[ 5313.553954]  [<ffffffff81052a60>] ? process_one_work+0x18b/0x287
[ 5313.553956]  [<ffffffff81052f05>] ? worker_thread+0x121/0x1e7
[ 5313.553959]  [<ffffffff81052de4>] ? rescuer_thread+0x265/0x265
[ 5313.553961]  [<ffffffff8105730f>] ? kthread+0x7d/0x85
[ 5313.553964]  [<ffffffff81057292>] ? __kthread_parkme+0x59/0x59
[ 5313.553966]  [<ffffffff8138ad3c>] ? ret_from_fork+0x7c/0xb0
[ 5313.553969]  [<ffffffff81057292>] ? __kthread_parkme+0x59/0x59
[ 6619.155867] INFO: task kworker/2:2:726 blocked for more than 15 seconds.
[ 6619.155872] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[ 6619.155874] kworker/2:2     D ffff88042dc53f40     0   726      2 0x00000000
[ 6619.155901] Workqueue: md submit_flushes [md_mod]
[ 6619.155903]  ffff880417ba77c0 0000000000000046 ffff88041d0d8040
0000000000013f40
[ 6619.155915]  ffff88041b21bfd8 ffff88041b21bfd8 ffff880417ba77c0
ffff88042dc53f40
[ 6619.155917]  ffff880417ba77c0 0000000000000000 ffff88041c68e3a0
ffff880221258300
[ 6619.155919] Call Trace:
[ 6619.155925]  [<ffffffff8138518e>] ? io_schedule+0x54/0x69
[ 6619.155928]  [<ffffffff811a7621>] ? get_request+0x4b1/0x55e
[ 6619.155931]  [<ffffffff81057c67>] ? abort_exclusive_wait+0x79/0x79
[ 6619.155933]  [<ffffffff811a94e9>] ? blk_queue_bio+0x1c0/0x2e8
[ 6619.155934]  [<ffffffff811a7a86>] ? generic_make_request+0x96/0xd5
[ 6619.155936]  [<ffffffff811a8672>] ? submit_bio+0x10a/0x13b
[ 6619.155939]  [<ffffffff8113035c>] ? bio_alloc_bioset+0xd0/0x172
[ 6619.155943]  [<ffffffffa0159185>] ? submit_flushes+0xbe/0x116 [md_mod]
[ 6619.155946]  [<ffffffff81052a60>] ? process_one_work+0x18b/0x287
[ 6619.155948]  [<ffffffff81052f05>] ? worker_thread+0x121/0x1e7
[ 6619.155950]  [<ffffffff81052de4>] ? rescuer_thread+0x265/0x265
[ 6619.155951]  [<ffffffff8105730f>] ? kthread+0x7d/0x85
[ 6619.155952]  [<ffffffff81057292>] ? __kthread_parkme+0x59/0x59
[ 6619.155955]  [<ffffffff8138ad3c>] ? ret_from_fork+0x7c/0xb0
[ 6619.155956]  [<ffffffff81057292>] ? __kthread_parkme+0x59/0x59
[ 6619.155960] INFO: task jbd2/dm-1-8:1601 blocked for more than 15 seconds.
[ 6619.155960] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[ 6619.155961] jbd2/dm-1-8     D ffff88042dc53f40     0  1601      2 0x00000000
[ 6619.155963]  ffff880419bfc800 0000000000000046 ffff88041d0d8040
0000000000013f40
[ 6619.155964]  ffff88041b365fd8 ffff88041b365fd8 ffff880419bfc800
ffff88042dc53f40
[ 6619.155966]  ffff880419bfc800 ffff88041b365cc8 ffffffff8112c313
0000000000000002
[ 6619.155968] Call Trace:
[ 6619.155969]  [<ffffffff8112c313>] ? do_thaw_one+0x6d/0x6d
[ 6619.155971]  [<ffffffff8138518e>] ? io_schedule+0x54/0x69
[ 6619.155972]  [<ffffffff8112c318>] ? sleep_on_buffer+0x5/0x8
[ 6619.155974]  [<ffffffff81383fad>] ? __wait_on_bit+0x3b/0x6e
[ 6619.155976]  [<ffffffff8138404d>] ? out_of_line_wait_on_bit+0x6d/0x76
[ 6619.155977]  [<ffffffff8112c313>] ? do_thaw_one+0x6d/0x6d
[ 6619.155978]  [<ffffffff81057c91>] ? autoremove_wake_function+0x2a/0x2a
[ 6619.155983]  [<ffffffffa023efdd>] ?
jbd2_journal_commit_transaction+0xdaa/0x138b [jbd2]
[ 6619.155985]  [<ffffffff81385ace>] ? _raw_spin_lock_irqsave+0x14/0x35
[ 6619.155989]  [<ffffffffa024355d>] ? kjournald2+0xb7/0x239 [jbd2]
[ 6619.155991]  [<ffffffff81057c67>] ? abort_exclusive_wait+0x79/0x79
[ 6619.155995]  [<ffffffffa02434a6>] ? jbd2_superblock_csum+0x31/0x31 [jbd2]
[ 6619.155996]  [<ffffffff8105730f>] ? kthread+0x7d/0x85
[ 6619.155999]  [<ffffffff810408ef>] ? do_exit+0x901/0x918
[ 6619.156000]  [<ffffffff81057292>] ? __kthread_parkme+0x59/0x59
[ 6619.156002]  [<ffffffff8138ad3c>] ? ret_from_fork+0x7c/0xb0
[ 6619.156003]  [<ffffffff81057292>] ? __kthread_parkme+0x59/0x59
[ 6619.156049] INFO: task iceweasel:5196 blocked for more than 15 seconds.
[ 6619.156050] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[ 6619.156051] iceweasel       D ffff88042dc13f40     0  5196   4814 0x00000000
[ 6619.156052]  ffff8803d73d0780 0000000000000082 ffffffff81613400
0000000000013f40
[ 6619.156054]  ffff8803f088ffd8 ffff8803f088ffd8 ffff8803d73d0780
ffff88041a212000
[ 6619.156055]  ffff8803f088feb0 ffff88041a212024 0000000000818286
ffff8803f088fec8
[ 6619.156057] Call Trace:
[ 6619.156062]  [<ffffffffa0242d40>] ? jbd2_log_wait_commit+0xc3/0x118 [jbd2]
[ 6619.156063]  [<ffffffff81057c67>] ? abort_exclusive_wait+0x79/0x79
[ 6619.156069]  [<ffffffffa026296b>] ? ext4_sync_file+0x269/0x2ec [ext4]
[ 6619.156072]  [<ffffffff8112af9e>] ? do_fsync+0x2b/0x4e
[ 6619.156073]  [<ffffffff8112b185>] ? SyS_fsync+0x7/0xa
[ 6619.156075]  [<ffffffff8138ade9>] ? system_call_fastpath+0x16/0x1b
[ 6619.156082] INFO: task virtuoso-t:5274 blocked for more than 15 seconds.
[ 6619.156083] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[ 6619.156084] virtuoso-t      D ffff88042dc33f40     0  5274   5062 0x00000000
[ 6619.156085]  ffff88041a297100 0000000000000086 ffff88041d0d8780
0000000000013f40
[ 6619.156087]  ffff8803d6a99fd8 ffff8803d6a99fd8 ffff88041a297100
ffff88042dc33f40
[ 6619.156088]  ffff88041a297100 0000000000000000 ffff88041926b130
ffff880223b00be0
[ 6619.156090] Call Trace:
[ 6619.156092]  [<ffffffff8138518e>] ? io_schedule+0x54/0x69
[ 6619.156093]  [<ffffffff811a7621>] ? get_request+0x4b1/0x55e
[ 6619.156095]  [<ffffffff811ab201>] ? ioc_lookup_icq+0x23/0x3b
[ 6619.156097]  [<ffffffff81057c67>] ? abort_exclusive_wait+0x79/0x79
[ 6619.156098]  [<ffffffff811a94e9>] ? blk_queue_bio+0x1c0/0x2e8
[ 6619.156103]  [<ffffffffa016f8b0>] ? dm_request+0x14c/0x15e [dm_mod]
[ 6619.156104]  [<ffffffff811a7a86>] ? generic_make_request+0x96/0xd5
[ 6619.156105]  [<ffffffff811a8672>] ? submit_bio+0x10a/0x13b
[ 6619.156111]  [<ffffffffa026b66d>] ? ext4_io_submit+0x21/0x4a [ext4]
[ 6619.156116]  [<ffffffffa0265611>] ? mpage_da_submit_io+0x26a/0x280 [ext4]
[ 6619.156121]  [<ffffffffa0269fc4>] ?
mpage_da_map_and_submit+0x314/0x32a [ext4]
[ 6619.156126]  [<ffffffffa026a0eb>] ? write_cache_pages_da+0x111/0x360 [ext4]
[ 6619.156130]  [<ffffffffa026a5af>] ? ext4_da_writepages+0x275/0x447 [ext4]
[ 6619.156133]  [<ffffffff810c175a>] ? __filemap_fdatawrite_range+0x4d/0x52
[ 6619.156135]  [<ffffffff810c177f>] ? filemap_write_and_wait_range+0x20/0x50
[ 6619.156139]  [<ffffffffa0262786>] ? ext4_sync_file+0x84/0x2ec [ext4]
[ 6619.156141]  [<ffffffff8112af9e>] ? do_fsync+0x2b/0x4e
[ 6619.156150]  [<ffffffff8112b185>] ? SyS_fsync+0x7/0xa
[ 6619.156151]  [<ffffffff8138ade9>] ? system_call_fastpath+0x16/0x1b
