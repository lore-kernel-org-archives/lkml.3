Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753561AbaGLP4m (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2014 11:56:42 -0400
Received: from mail-wg0-f48.google.com ([74.125.82.48]:57551 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751435AbaGLP4l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2014 11:56:41 -0400
Message-ID: <53C15AB6.9000605@kernel.dk>
Date: Sat, 12 Jul 2014 17:56:38 +0200
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: linux-kernel@vger.kernel.org, Shirish Pargaonkar <spargaonkar@suse.com>,
        Sasha Levin <sasha.levin@oracle.com>, Jet Chen <jet.chen@intel.com>
Subject: Re: [PATCH block/for-linus] blkcg: don't call into policy draining
 if root_blkg is already gone
References: <20140705224321.GA9701@mtj.dyndns.org>
In-Reply-To: <20140705224321.GA9701@mtj.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-07-06 00:43, Tejun Heo wrote:
> While a queue is being destroyed, all the blkgs are destroyed and its
> ->root_blkg pointer is set to NULL.  If someone else starts to drain
> while the queue is in this state, the following oops happens.
>
>    NULL pointer dereference at 0000000000000028
>    IP: [<ffffffff8144e944>] blk_throtl_drain+0x84/0x230
>    PGD e4a1067 PUD b773067 PMD 0
>    Oops: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
>    Modules linked in: cfq_iosched(-) [last unloaded: cfq_iosched]
>    CPU: 1 PID: 537 Comm: bash Not tainted 3.16.0-rc3-work+ #2
>    Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
>    task: ffff88000e222250 ti: ffff88000efd4000 task.ti: ffff88000efd4000
>    RIP: 0010:[<ffffffff8144e944>]  [<ffffffff8144e944>] blk_throtl_drain+0x84/0x230
>    RSP: 0018:ffff88000efd7bf0  EFLAGS: 00010046
>    RAX: 0000000000000000 RBX: ffff880015091450 RCX: 0000000000000001
>    RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
>    RBP: ffff88000efd7c10 R08: 0000000000000000 R09: 0000000000000001
>    R10: ffff88000e222250 R11: 0000000000000000 R12: ffff880015091450
>    R13: ffff880015092e00 R14: ffff880015091d70 R15: ffff88001508fc28
>    FS:  00007f1332650740(0000) GS:ffff88001fa80000(0000) knlGS:0000000000000000
>    CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
>    CR2: 0000000000000028 CR3: 0000000009446000 CR4: 00000000000006e0
>    Stack:
>     ffffffff8144e8f6 ffff880015091450 0000000000000000 ffff880015091d80
>     ffff88000efd7c28 ffffffff8144ae2f ffff880015091450 ffff88000efd7c58
>     ffffffff81427641 ffff880015091450 ffffffff82401f00 ffff880015091450
>    Call Trace:
>     [<ffffffff8144ae2f>] blkcg_drain_queue+0x1f/0x60
>     [<ffffffff81427641>] __blk_drain_queue+0x71/0x180
>     [<ffffffff81429b3e>] blk_queue_bypass_start+0x6e/0xb0
>     [<ffffffff814498b8>] blkcg_deactivate_policy+0x38/0x120
>     [<ffffffff8144ec44>] blk_throtl_exit+0x34/0x50
>     [<ffffffff8144aea5>] blkcg_exit_queue+0x35/0x40
>     [<ffffffff8142d476>] blk_release_queue+0x26/0xd0
>     [<ffffffff81454968>] kobject_cleanup+0x38/0x70
>     [<ffffffff81454848>] kobject_put+0x28/0x60
>     [<ffffffff81427505>] blk_put_queue+0x15/0x20
>     [<ffffffff817d07bb>] scsi_device_dev_release_usercontext+0x16b/0x1c0
>     [<ffffffff810bc339>] execute_in_process_context+0x89/0xa0
>     [<ffffffff817d064c>] scsi_device_dev_release+0x1c/0x20
>     [<ffffffff817930e2>] device_release+0x32/0xa0
>     [<ffffffff81454968>] kobject_cleanup+0x38/0x70
>     [<ffffffff81454848>] kobject_put+0x28/0x60
>     [<ffffffff817934d7>] put_device+0x17/0x20
>     [<ffffffff817d11b9>] __scsi_remove_device+0xa9/0xe0
>     [<ffffffff817d121b>] scsi_remove_device+0x2b/0x40
>     [<ffffffff817d1257>] sdev_store_delete+0x27/0x30
>     [<ffffffff81792ca8>] dev_attr_store+0x18/0x30
>     [<ffffffff8126f75e>] sysfs_kf_write+0x3e/0x50
>     [<ffffffff8126ea87>] kernfs_fop_write+0xe7/0x170
>     [<ffffffff811f5e9f>] vfs_write+0xaf/0x1d0
>     [<ffffffff811f69bd>] SyS_write+0x4d/0xc0
>     [<ffffffff81d24692>] system_call_fastpath+0x16/0x1b
>
> 776687bce42b ("block, blk-mq: draining can't be skipped even if
> bypass_depth was non-zero") made it easier to trigger this bug by
> making blk_queue_bypass_start() drain even when it loses the first
> bypass test to blk_cleanup_queue(); however, the bug has always been
> there even before the commit as blk_queue_bypass_start() could race
> against queue destruction, win the initial bypass test but perform the
> actual draining after blk_cleanup_queue() already destroyed all blkgs.
>
> Fix it by skippping calling into policy draining if all the blkgs are
> already gone.

Applied, thanks Tejun.

-- 
Jens Axboe

