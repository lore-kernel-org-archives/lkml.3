Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932077Ab3DIREL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 13:04:11 -0400
Received: from canardo.mork.no ([148.122.252.1]:35943 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759228Ab3DIREJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 13:04:09 -0400
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To: Phillip Susi <psusi@ubuntu.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
Subject: [regression] v3.8 -> v3.9-rc6, caused by commit 8761a3d ("loop: cleanup partitions when detaching loop device")
Organization: m
Date: Tue, 09 Apr 2013 19:03:02 +0200
Message-ID: <87r4ijfxh5.fsf@nemi.mork.no>
User-Agent: Gnus/5.11002 (No Gnus v0.20) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

the following simple test causes a deadlock between the loop driver,
umount and blkid i v3.9-rc6 (tested on a standard Debian wheezy
installating, i.e. with udev 175):

qmitest:~# file cd-image-cfg1.iso 
cd-image-cfg1.iso: # ISO 9660 CD-ROM filesystem data 'D-LINK MODEM'
qmitest:~# mount cd-image-cfg1.iso /mnt/ -oloop,ro -t iso9660
qmitest:~# umount /mnt 


where umount will hang forever.


[  241.456242] INFO: task umount:2579 blocked for more than 120 seconds.
[  241.467141] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  241.481152] umount          D 0000000000000000     0  2579   2526 0x00000000
[  241.494602]  ffff88000ef37c58 0000000000000046 ffff88000d8af040 ffff88000ef36010
[  241.509897]  ffff88000ef36000 ffff88000ef36000 ffff88000ef36000 ffff88000ef37fd8
[  241.525433]  0000000000013180 ffff88000ef36000 ffffffff81811400 ffff88000d8af040
[  241.540846] Call Trace:
[  241.545642]  [<ffffffff813ba434>] schedule+0x5f/0x61
[  241.554326]  [<ffffffff813ba6b5>] schedule_preempt_disabled+0x21/0x29
[  241.568270]  [<ffffffff813b8ff7>] __mutex_lock_common+0x26a/0x3b9
[  241.580711]  [<ffffffffa02bbd37>] ? loop_clr_fd+0x20d/0x279 [loop]
[  241.593127]  [<ffffffff8107f71d>] ? mark_held_locks+0x73/0x97
[  241.604733]  [<ffffffffa02bbd37>] ? loop_clr_fd+0x20d/0x279 [loop]
[  241.617167]  [<ffffffff813b9241>] mutex_lock_nested+0x3b/0x40
[  241.628775]  [<ffffffffa02bbd37>] loop_clr_fd+0x20d/0x279 [loop]
[  241.640876]  [<ffffffffa02bc4b5>] lo_release+0x40/0x6a [loop]
[  241.652573]  [<ffffffff811476a3>] __blkdev_put+0xb5/0x168
[  241.664783]  [<ffffffff8114787d>] blkdev_put+0x127/0x130
[  241.676804]  [<ffffffff8111b48d>] kill_block_super+0x5f/0x64
[  241.689433]  [<ffffffff8111b6b5>] deactivate_locked_super+0x21/0x4d
[  241.703484]  [<ffffffff8111c26c>] deactivate_super+0x40/0x48
[  241.721619]  [<ffffffff811325fd>] mntput_no_expire+0x12d/0x136
[  241.734652]  [<ffffffff811334e0>] sys_umount+0x33e/0x369
[  241.746746]  [<ffffffff81046f28>] ? __set_current_blocked+0x26/0x49
[  241.760553]  [<ffffffff813bc2e9>] system_call_fastpath+0x16/0x1b
[  241.773833] 2 locks held by umount/2579:
[  241.783138]  #0:  (&bdev->bd_mutex){+.+.+.}, at: [<ffffffff81147621>] __blkdev_put+0x33/0x168
[  241.805858]  #1:  (&bdev->bd_mutex/1){+.+...}, at: [<ffffffffa02bbd37>] loop_clr_fd+0x20d/0x279 [loop]
[  241.830869] INFO: task blkid:2580 blocked for more than 120 seconds.
[  241.844648] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  241.862451] blkid           D 0000000000000001     0  2580    442 0x00000004
[  241.879441]  ffff88000db55a48 0000000000000046 ffffffff818548e0 ffff88000db54010
[  241.900248]  ffff88000db54000 ffff88000db54000 ffff88000db54000 ffff88000db55fd8
[  241.920555]  0000000000013180 ffff88000db54000 ffff88000ecae040 ffff88000db69040
[  241.940945] Call Trace:
[  241.947643]  [<ffffffff813ba434>] schedule+0x5f/0x61
[  241.958943]  [<ffffffff813ba6b5>] schedule_preempt_disabled+0x21/0x29
[  241.973093]  [<ffffffff813b8ff7>] __mutex_lock_common+0x26a/0x3b9
[  241.986524]  [<ffffffff81147956>] ? __blkdev_get+0xaf/0x3f7
[  241.999026]  [<ffffffff81147956>] ? __blkdev_get+0xaf/0x3f7
[  242.011487]  [<ffffffff813b9241>] mutex_lock_nested+0x3b/0x40
[  242.030079]  [<ffffffff81147956>] __blkdev_get+0xaf/0x3f7
[  242.042256]  [<ffffffff81147fec>] ? blkdev_get+0x34e/0x34e
[  242.054748]  [<ffffffff81147eac>] blkdev_get+0x20e/0x34e
[  242.067038]  [<ffffffff81147fec>] ? blkdev_get+0x34e/0x34e
[  242.079440]  [<ffffffff813bb66e>] ? _raw_spin_unlock+0x26/0x3a
[  242.093235]  [<ffffffff81147fec>] ? blkdev_get+0x34e/0x34e
[  242.105630]  [<ffffffff81148055>] blkdev_open+0x69/0x6d
[  242.117541]  [<ffffffff811178f8>] do_dentry_open+0x16c/0x21e
[  242.130485]  [<ffffffff81117a8a>] finish_open+0x34/0x40
[  242.142334]  [<ffffffff81123f77>] do_last+0x898/0xa46
[  242.153893]  [<ffffffff81124180>] ? link_path_walk+0x5b/0x432
[  242.166726]  [<ffffffff8112318c>] ? path_init+0xcd/0x2b6
[  242.178852]  [<ffffffff811246a5>] path_openat+0xc6/0x374
[  242.190816]  [<ffffffff81124a58>] do_filp_open+0x38/0x84
[  242.202779]  [<ffffffff813bb66e>] ? _raw_spin_unlock+0x26/0x3a
[  242.215780]  [<ffffffff81130182>] ? __alloc_fd+0x106/0x11a
[  242.228092]  [<ffffffff81117640>] do_sys_open+0x6d/0xff
[  242.239965]  [<ffffffff811176ff>] sys_open+0x1c/0x1e
[  242.251195]  [<ffffffff813bc2e9>] system_call_fastpath+0x16/0x1b
[  242.264583] 1 lock held by blkid/2580:
[  242.273704]  #0:  (&bdev->bd_mutex){+.+.+.}, at: [<ffffffff81147956>] __blkdev_get+0xaf/0x3f7


Reverting commit 8761a3d ("loop: cleanup partitions when detaching loop
device") on top of v3.9-rc9 fixes this problem for me.



Bjørn
