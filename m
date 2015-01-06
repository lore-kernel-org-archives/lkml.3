Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755022AbbAFM0y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 07:26:54 -0500
Received: from mail-la0-f44.google.com ([209.85.215.44]:33561 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753340AbbAFM0v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 07:26:51 -0500
MIME-Version: 1.0
Date: Tue, 6 Jan 2015 13:26:49 +0100
Message-ID: <CADN1jKAVAp5DRw2sWLrkn1V=dE=Cd7kB1kNjD9MAUFsm+mH_Og@mail.gmail.com>
Subject: Unmounted block device is still used - can't open it using O_EXCL
From: Adam Papai <wooh@wooh.hu>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey!

Sorry for posting this question here, but I have no better idea where to ask.

We're using EC2 instances with EBS volumes attached.

Sometimes when I unmount a device and than detach it from the server
this kernel message pops up in the dmesg:

50469541.116761] vbd vbd-2193: 16 Device in use; refusing to close
[50469728.730101] INFO: task kworker/1:0:27515 blocked for more than
120 seconds.
[50469728.730116]       Not tainted 3.16.4-1-ARCH #1
[50469728.730120] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[50469728.730127] kworker/1:0     D 0000000000000000     0 27515
2 0x00000000
[50469728.730154] Workqueue: xfs-log/xvdj1 xfs_log_worker [xfs]
[50469728.730157]  ffff88015e213d00 0000000000000246 ffff88004af165e0
0000000000014580
[50469728.730166]  ffff88015e213fd8 0000000000014580 ffff88004af165e0
00000000403291ac
[50469728.730169]  ffff8801d20a4c00 ffff8801d20a4c00 ffff8801d20a4c00
ffffffffa029edeb
[50469728.730172] Call Trace:
[50469728.730187]  [<ffffffffa029edeb>] ? xlog_bdstrat+0x2b/0x60 [xfs]
[50469728.730195]  [<ffffffffa023f896>] ? xfs_buf_iorequest+0x66/0xd0 [xfs]
[50469728.730206]  [<ffffffffa029edeb>] ? xlog_bdstrat+0x2b/0x60 [xfs]
[50469728.730217]  [<ffffffffa02a0c3c>] ? xlog_sync+0x27c/0x420 [xfs]
[50469728.730224]  [<ffffffff8152e239>] schedule+0x29/0x70
[50469728.730235]  [<ffffffffa02a2234>] _xfs_log_force_lsn+0x2c4/0x300 [xfs]
[50469728.730239]  [<ffffffff810a2d10>] ? wake_up_process+0x50/0x50
[50469728.730250]  [<ffffffffa0258ac3>] xfs_trans_commit+0x213/0x250 [xfs]
[50469728.730259]  [<ffffffffa02470f7>] xfs_fs_log_dummy+0x57/0x80 [xfs]
[50469728.730270]  [<ffffffffa02a1f68>] xfs_log_worker+0x48/0x50 [xfs]
[50469728.730274]  [<ffffffff8108afd8>] process_one_work+0x168/0x450
[50469728.730277]  [<ffffffff8108b60b>] worker_thread+0x6b/0x550
[50469728.730280]  [<ffffffff8108b5a0>] ? init_pwq.part.22+0x10/0x10
[50469728.730283]  [<ffffffff81091d1a>] kthread+0xea/0x100
[50469728.730287]  [<ffffffff81530000>] ? __mutex_lock_slowpath+0xc0/0x230
[50469728.730290]  [<ffffffff81091c30>] ? kthread_create_on_node+0x1b0/0x1b0
[50469728.730293]  [<ffffffff8153203c>] ret_from_fork+0x7c/0xb0
[50469728.730295]  [<ffffffff81091c30>] ? kthread_create_on_node+0x1b0/0x1b0

fuser/lsof does not show anything, so I wrote a little script in
python, and try to open the device itself in O_EXCL mode. It fails to
open it in O_EXCL, so I'm sure it is used in a deeper level (kernel,
kernel module?)

I can however re-mount it, write/read, and unmount without any
problem, but it seems something is still referencing/using this
device. But when I detach it, the device refuses to close, it remains
in /proc/particions and will generate I/O wait: iostat -xdk 5 will
show 100% utilisation.

Is there any way to release this block device so I can detach it from
a linux box? Or at least check what is using it? I think the lxc
bind-mount is very suspicious, but I assume the unmount won't work if
it's still used by a leftover lxc process.

We have this issue with 3.15/3.16 kernel as well. Haven't tried with
the never ones, but I guess it won't make a difference.

I tried blockdev --flushbufs, but the same error.

Any advice would help!

Thanks!
