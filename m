Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932748Ab3EGB3p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 21:29:45 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:19043 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932461Ab3EGB3n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 21:29:43 -0400
Message-ID: <518858EF.2030503@oracle.com>
Date: Mon, 06 May 2013 21:29:19 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130429 Thunderbird/17.0.5
MIME-Version: 1.0
To: mchehab@redhat.com
CC: linux-media@vger.kernel.org, Dave Jones <davej@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: v4l2: lockdep spew mmap_sem/dev_mutex
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi guys,

While fuzzing with trinity running inside a KVM tools guest, using latest -next kernel,
I've stumbled on the following spew:

[  160.267181] ======================================================
[  160.267896] [ INFO: possible circular locking dependency detected ]
[  160.268631] 3.9.0-next-20130506-sasha-00012-g01de88a #356 Tainted: G        W
[  160.269486] -------------------------------------------------------
[  160.271108] trinity-child3/10132 is trying to acquire lock:
[  160.271108]  (&dev->dev_mutex){+.+.+.}, at: [<ffffffff831c39f1>] m2mtest_mmap+0x51/0x90
[  160.271108]
[  160.271108] but task is already holding lock:
[  160.271108]  (&mm->mmap_sem){++++++}, at: [<ffffffff8124ff02>] vm_mmap_pgoff+0x62/0xd0
[  160.271108]
[  160.271108] which lock already depends on the new lock.
[  160.271108]
[  160.271108]
[  160.271108] the existing dependency chain (in reverse order) is:
[  160.271108]
-> #1 (&mm->mmap_sem){++++++}:
[  160.271108]        [<ffffffff811a1f5a>] lock_acquire+0x1aa/0x240
[  160.271108]        [<ffffffff81259f8b>] might_fault+0x7b/0xa0
[  160.271108]        [<ffffffff8315d82e>] video_usercopy+0x41e/0x490
[  160.271108]        [<ffffffff8315d8b0>] video_ioctl2+0x10/0x20
[  160.271108]        [<ffffffff83157c33>] v4l2_ioctl+0xa3/0x170
[  160.271108]        [<ffffffff812bff52>] do_vfs_ioctl+0x522/0x570
[  160.271108]        [<ffffffff812bfffd>] SyS_ioctl+0x5d/0xa0
[  160.271108]        [<ffffffff84028558>] tracesys+0xe1/0xe6
[  160.271108]
-> #0 (&dev->dev_mutex){+.+.+.}:
[  160.271108]        [<ffffffff811a0e4f>] __lock_acquire+0x15af/0x1e40
[  160.271108]        [<ffffffff811a1f5a>] lock_acquire+0x1aa/0x240
[  160.271108]        [<ffffffff8401bf89>] __mutex_lock_common+0x59/0x600
[  160.271108]        [<ffffffff8401c56f>] mutex_lock_interruptible_nested+0x3f/0x50
[  160.271108]        [<ffffffff831c39f1>] m2mtest_mmap+0x51/0x90
[  160.271108]        [<ffffffff831576b8>] v4l2_mmap+0x48/0xa0
[  160.271108]        [<ffffffff81265fbb>] mmap_region+0x33b/0x630
[  160.271108]        [<ffffffff812665c6>] do_mmap_pgoff+0x316/0x3d0
[  160.271108]        [<ffffffff8124ff23>] vm_mmap_pgoff+0x83/0xd0
[  160.271108]        [<ffffffff81264b2e>] SyS_mmap_pgoff+0x16e/0x1b0
[  160.271108]        [<ffffffff8106ea2d>] SyS_mmap+0x1d/0x20
[  160.271108]        [<ffffffff84028558>] tracesys+0xe1/0xe6
[  160.271108]
[  160.271108] other info that might help us debug this:
[  160.271108]
[  160.271108]  Possible unsafe locking scenario:
[  160.271108]
[  160.271108]        CPU0                    CPU1
[  160.271108]        ----                    ----
[  160.271108]   lock(&mm->mmap_sem);
[  160.271108]                                lock(&dev->dev_mutex);
[  160.271108]                                lock(&mm->mmap_sem);
[  160.271108]   lock(&dev->dev_mutex);
[  160.271108]
[  160.271108]  *** DEADLOCK ***
[  160.271108]
[  160.271108] 1 lock held by trinity-child3/10132:
[  160.271108]  #0:  (&mm->mmap_sem){++++++}, at: [<ffffffff8124ff02>] vm_mmap_pgoff+0x62/0xd0
[  160.271108]
[  160.271108] stack backtrace:
[  160.271108] CPU: 3 PID: 10132 Comm: trinity-child3 Tainted: G        W    3.9.0-next-20130506-sasha-00012-g01de88a #356
[  160.271108]  ffffffff86ba8bf0 ffff8800ab3aba78 ffffffff83fde6a3 ffff8800ab3abac8
[  160.271108]  ffffffff83fd33cf 0000000000abc6d5 ffff8800ab3abb58 ffff8800ab3abac8
[  160.271108]  ffff88009314b9b0 ffff88009314b978 ffff88009314b000 0000000000abc6d5
[  160.271108] Call Trace:
[  160.271108]  [<ffffffff83fde6a3>] dump_stack+0x19/0x1b
[  160.271108]  [<ffffffff83fd33cf>] print_circular_bug+0x1fb/0x20c
[  160.271108]  [<ffffffff811a0e4f>] __lock_acquire+0x15af/0x1e40
[  160.271108]  [<ffffffff8401fb60>] ? _raw_spin_unlock+0x30/0x60
[  160.271108]  [<ffffffff811a1f5a>] lock_acquire+0x1aa/0x240
[  160.271108]  [<ffffffff831c39f1>] ? m2mtest_mmap+0x51/0x90
[  160.271108]  [<ffffffff8401bf89>] __mutex_lock_common+0x59/0x600
[  160.271108]  [<ffffffff831c39f1>] ? m2mtest_mmap+0x51/0x90
[  160.271108]  [<ffffffff8119e9aa>] ? __lock_is_held+0x5a/0x80
[  160.271108]  [<ffffffff81265ee4>] ? mmap_region+0x264/0x630
[  160.271108]  [<ffffffff831c39f1>] ? m2mtest_mmap+0x51/0x90
[  160.271108]  [<ffffffff8401c56f>] mutex_lock_interruptible_nested+0x3f/0x50
[  160.271108]  [<ffffffff831c39f1>] m2mtest_mmap+0x51/0x90
[  160.271108]  [<ffffffff81265ee4>] ? mmap_region+0x264/0x630
[  160.271108]  [<ffffffff831576b8>] v4l2_mmap+0x48/0xa0
[  160.271108]  [<ffffffff81265fbb>] mmap_region+0x33b/0x630
[  160.271108]  [<ffffffff812665c6>] do_mmap_pgoff+0x316/0x3d0
[  160.271108]  [<ffffffff8124ff02>] ? vm_mmap_pgoff+0x62/0xd0
[  160.271108]  [<ffffffff8124ff23>] vm_mmap_pgoff+0x83/0xd0
[  160.271108]  [<ffffffff81a4a889>] ? __const_udelay+0x29/0x30
[  160.271108]  [<ffffffff81151824>] ? __rcu_read_unlock+0x44/0xb0
[  160.271108]  [<ffffffff812cace0>] ? fget_raw+0x280/0x280
[  160.271108]  [<ffffffff81264b2e>] SyS_mmap_pgoff+0x16e/0x1b0
[  160.271108]  [<ffffffff8106ea2d>] SyS_mmap+0x1d/0x20
[  160.271108]  [<ffffffff84028558>] tracesys+0xe1/0xe6

Thanks,
Sasha
