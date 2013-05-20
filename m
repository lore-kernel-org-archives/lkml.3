Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756673Ab3ETNdX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 09:33:23 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:64991 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755835Ab3ETNdV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 09:33:21 -0400
Date: Mon, 20 May 2013 16:31:03 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: possible circular locking dependency on CPU hot plug
Message-ID: <20130520133102.GD2238@swordfish>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

[13409.527747] smpboot: CPU 1 is now offline
[13409.532268] ======================================================
[13409.532269] [ INFO: possible circular locking dependency detected ]
[13409.532271] 3.10.0-rc1-dbg-01696-g1c1c281-dirty #1665 Tainted: G        W   
[13409.532272] -------------------------------------------------------
[13409.532274] bash/30580 is trying to acquire lock:
[13409.532287]  (console_lock){+.+.+.}, at: [<ffffffff815c35de>] console_cpu_notify+0x1f/0x31
[13409.532287] but task is already holding lock:
[13409.532294]  (cpu_hotplug.lock){+.+.+.}, at: [<ffffffff8104711b>] cpu_hotplug_begin+0x2b/0x60
[13409.532295] which lock already depends on the new lock.
[13409.532296] the existing dependency chain (in reverse order) is:
[13409.532299] -> #2 (cpu_hotplug.lock){+.+.+.}:
[13409.532304]        [<ffffffff810b1a14>] lock_acquire+0xa4/0x200
[13409.532310]        [<ffffffff815cefd7>] mutex_lock_nested+0x67/0x410
[13409.532312]        [<ffffffff8104711b>] cpu_hotplug_begin+0x2b/0x60
[13409.532315]        [<ffffffff815c361a>] _cpu_up+0x2a/0x140
[13409.532318]        [<ffffffff815c3781>] cpu_up+0x51/0x68
[13409.532324]        [<ffffffff81af204a>] smp_init+0x64/0x95
[13409.532329]        [<ffffffff81ad7f0a>] kernel_init_freeable+0x84/0x191
[13409.532331]        [<ffffffff815b8c1e>] kernel_init+0xe/0x180
[13409.532334]        [<ffffffff815d472c>] ret_from_fork+0x7c/0xb0
[13409.532337] -> #1 (cpu_add_remove_lock){+.+.+.}:
[13409.532340]        [<ffffffff810b1a14>] lock_acquire+0xa4/0x200
[13409.532343]        [<ffffffff815cefd7>] mutex_lock_nested+0x67/0x410
[13409.532345]        [<ffffffff810473e4>] disable_nonboot_cpus+0x24/0x120
[13409.532349]        [<ffffffff8109a3e3>] hibernation_snapshot+0x223/0x370
[13409.532351]        [<ffffffff8109a9bb>] hibernate+0x11b/0x1b0
[13409.532353]        [<ffffffff810986d1>] state_store+0x71/0xa0
[13409.532358]        [<ffffffff81310dff>] kobj_attr_store+0xf/0x20
[13409.532362]        [<ffffffff811ea79b>] sysfs_write_file+0xdb/0x150
[13409.532368]        [<ffffffff811708ad>] vfs_write+0xbd/0x1f0
[13409.532371]        [<ffffffff8117126c>] SyS_write+0x4c/0xa0
[13409.532373]        [<ffffffff815d4986>] tracesys+0xd4/0xd9
[13409.532376] -> #0 (console_lock){+.+.+.}:
[13409.532378]        [<ffffffff810b0b66>] __lock_acquire+0x1766/0x1d30
[13409.532381]        [<ffffffff810b1a14>] lock_acquire+0xa4/0x200
[13409.532384]        [<ffffffff81044e97>] console_lock+0x77/0x80
[13409.532387]        [<ffffffff815c35de>] console_cpu_notify+0x1f/0x31
[13409.532391]        [<ffffffff81076ccd>] notifier_call_chain+0x5d/0x110
[13409.532393]        [<ffffffff81076d8e>] __raw_notifier_call_chain+0xe/0x10
[13409.532395]        [<ffffffff81047173>] cpu_notify+0x23/0x50
[13409.532397]        [<ffffffff810471ae>] cpu_notify_nofail+0xe/0x20
[13409.532400]        [<ffffffff815b984d>] _cpu_down+0x1ad/0x330
[13409.532402]        [<ffffffff815b9a06>] cpu_down+0x36/0x50
[13409.532404]        [<ffffffff815bb408>] store_online+0x98/0xd0
[13409.532411]        [<ffffffff814692f8>] dev_attr_store+0x18/0x30
[13409.532414]        [<ffffffff811ea79b>] sysfs_write_file+0xdb/0x150
[13409.532416]        [<ffffffff811708ad>] vfs_write+0xbd/0x1f0
[13409.532419]        [<ffffffff8117126c>] SyS_write+0x4c/0xa0
[13409.532421]        [<ffffffff815d4986>] tracesys+0xd4/0xd9
[13409.532422] other info that might help us debug this:
[13409.532425] Chain exists of:  console_lock --> cpu_add_remove_lock --> cpu_hotplug.lock
[13409.532426]  Possible unsafe locking scenario:
[13409.532427]        CPU0                    CPU1
[13409.532427]        ----                    ----
[13409.532429]   lock(cpu_hotplug.lock);
[13409.532430]                                lock(cpu_add_remove_lock);
[13409.532432]                                lock(cpu_hotplug.lock);
[13409.532434]   lock(console_lock);
[13409.532434]  *** DEADLOCK ***
[13409.532436] 6 locks held by bash/30580:
[13409.532442]  #0:  (sb_writers#6){.+.+.+}, at: [<ffffffff811709b3>] vfs_write+0x1c3/0x1f0
[13409.532446]  #1:  (&buffer->mutex){+.+.+.}, at: [<ffffffff811ea6fc>] sysfs_write_file+0x3c/0x150
[13409.532452]  #2:  (s_active#185){.+.+.+}, at: [<ffffffff811ea783>] sysfs_write_file+0xc3/0x150
[13409.532458]  #3:  (x86_cpu_hotplug_driver_mutex){+.+.+.}, at: [<ffffffff81027107>] cpu_hotplug_driver_lock+0x17/0x20
[13409.532462]  #4:  (cpu_add_remove_lock){+.+.+.}, at: [<ffffffff815b99f2>] cpu_down+0x22/0x50
[13409.532466]  #5:  (cpu_hotplug.lock){+.+.+.}, at: [<ffffffff8104711b>] cpu_hotplug_begin+0x2b/0x60
[13409.532467] stack backtrace:
[13409.532470] CPU: 3 PID: 30580 Comm: bash Tainted: G        W    3.10.0-rc1-dbg-01696-g1c1c281-dirty #1665
[13409.532471] Hardware name: Acer             Aspire 5741G    /Aspire 5741G    , BIOS V1.20 02/08/2011
[13409.532476]  ffffffff82007530 ffff88014771bbd8 ffffffff815ccc04 ffff88014771bc18
[13409.532479]  ffffffff815c9757 ffff8801465a3f60 ffff8801465a4770 4c4262802c89c39d
[13409.532482]  ffff8801465a4748 ffff8801465a4770 ffff8801465a3f60 ffff88014771bce0
[13409.532483] Call Trace:
[13409.532487]  [<ffffffff815ccc04>] dump_stack+0x19/0x1b
[13409.532490]  [<ffffffff815c9757>] print_circular_bug+0x2b6/0x2c5
[13409.532494]  [<ffffffff810b0b66>] __lock_acquire+0x1766/0x1d30
[13409.532497]  [<ffffffff810aee54>] ? mark_held_locks+0x94/0x140
[13409.532500]  [<ffffffff810aee54>] ? mark_held_locks+0x94/0x140
[13409.532503]  [<ffffffff810b1a14>] lock_acquire+0xa4/0x200
[13409.532505]  [<ffffffff815c35de>] ? console_cpu_notify+0x1f/0x31
[13409.532509]  [<ffffffff81044e97>] console_lock+0x77/0x80
[13409.532511]  [<ffffffff815c35de>] ? console_cpu_notify+0x1f/0x31
[13409.532513]  [<ffffffff815c35de>] console_cpu_notify+0x1f/0x31
[13409.532516]  [<ffffffff81076ccd>] notifier_call_chain+0x5d/0x110
[13409.532518]  [<ffffffff81076d8e>] __raw_notifier_call_chain+0xe/0x10
[13409.532520]  [<ffffffff81047173>] cpu_notify+0x23/0x50
[13409.532522]  [<ffffffff810471ae>] cpu_notify_nofail+0xe/0x20
[13409.532524]  [<ffffffff815b984d>] _cpu_down+0x1ad/0x330
[13409.532527]  [<ffffffff81027107>] ? cpu_hotplug_driver_lock+0x17/0x20
[13409.532529]  [<ffffffff815b9a06>] cpu_down+0x36/0x50
[13409.532531]  [<ffffffff815bb408>] store_online+0x98/0xd0
[13409.532534]  [<ffffffff814692f8>] dev_attr_store+0x18/0x30
[13409.532537]  [<ffffffff811ea79b>] sysfs_write_file+0xdb/0x150
[13409.532540]  [<ffffffff811708ad>] vfs_write+0xbd/0x1f0
[13409.532545]  [<ffffffff8118e940>] ? fget_light+0x320/0x4b0
[13409.532547]  [<ffffffff8117126c>] SyS_write+0x4c/0xa0
[13409.532549]  [<ffffffff815d4986>] tracesys+0xd4/0xd9




	-ss
