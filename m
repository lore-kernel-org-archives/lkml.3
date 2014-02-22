Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752069AbaBVRwH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Feb 2014 12:52:07 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:27047 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751447AbaBVRwE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Feb 2014 12:52:04 -0500
Message-ID: <5308E3AE.3040405@oracle.com>
Date: Sat, 22 Feb 2014 12:51:42 -0500
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>, Greg KH <greg@kroah.com>, a.zummo@towertech.it
CC: rtc-linux@googlegroups.com, LKML <linux-kernel@vger.kernel.org>
Subject: kernfs/rtc: circular dependency between kernfs and ops_lock
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

While fuzzing with trinity inside a KVM tools guest running the latest -next kernel I've stumbled on 
the following (now with pretty line numbers!) spew:

[  218.132898] ======================================================
[  218.133902] [ INFO: possible circular locking dependency detected ]
[  218.134820] 3.14.0-rc3-next-20140221-sasha-00008-g0e660cf-dirty #116 Tainted: G        W
[  218.135911] -------------------------------------------------------
[  218.136842] trinity-c47/11528 is trying to acquire lock:
[  218.137613]  (&rtc->ops_lock){+.+.+.}, at: [<drivers/rtc/interface.c:42>] rtc_read_time+0x2b/0x60
[  218.138909]
[  218.138909] but task is already holding lock:
[  218.139802]  (s_active#20){++++.+}, at: [<fs/kernfs/file.c:99>] kernfs_seq_start+0x34/0xa0
[  218.140087]
[  218.140087] which lock already depends on the new lock.
[  218.140087]
[  218.140087]
[  218.140087] the existing dependency chain (in reverse order) is:
[  218.140087]
-> #1 (s_active#20){++++.+}:
[  218.140087]        [<kernel/locking/lockdep.c:1945 kernel/locking/lockdep.c:2131>] 
validate_chain+0x6ca/0x7c0
[  218.140087]        [<kernel/locking/lockdep.c:3182>] __lock_acquire+0x4ad/0x580
[  218.140087]        [<arch/x86/include/asm/current.h:14 kernel/locking/lockdep.c:3602>] 
lock_acquire+0x182/0x1d0
[  218.140087]        [<arch/x86/include/asm/atomic.h:26 fs/kernfs/dir.c:349>] kernfs_drain+0xb8/0x180
[  218.140087]        [<fs/kernfs/dir.c:1031>] __kernfs_remove+0x10b/0x1d0
[  218.140087]        [<fs/kernfs/dir.c:1226>] kernfs_remove_by_name_ns+0x79/0xb0
[  218.140087]        [<fs/sysfs/group.c:28>] remove_files+0x31/0x70
[  218.140087]        [<fs/sysfs/group.c:228>] sysfs_remove_group+0x7e/0xb0
[  218.140087]        [<fs/sysfs/group.c:250>] sysfs_remove_groups+0x32/0x50
[  218.140087]        [<drivers/base/core.c:524>] device_remove_attrs+0x6d/0x90
[  218.140087]        [<drivers/base/core.c:1206>] device_del+0x135/0x1c0
[  218.140087]        [<drivers/base/core.c:1237>] device_unregister+0x50/0x60
[  218.140087]        [<drivers/rtc/class.c:273>] rtc_device_unregister+0x4f/0x80
[  218.140087]        [<include/linux/ioport.h:166 drivers/rtc/rtc-cmos.c:805>] 
cmos_do_probe+0x3b0/0x3f0
[  218.157097]        [<drivers/rtc/rtc-cmos.c:1153>] cmos_platform_probe+0x46/0x4e
[  218.157097]        [<drivers/base/platform.c:487>] platform_drv_probe+0x36/0x90
[  218.157097]        [<drivers/base/dd.c:292>] really_probe+0x11f/0x2f0
[  218.157097]        [<include/linux/pm_runtime.h:189 drivers/base/dd.c:383>] 
driver_probe_device+0x83/0xb0
[  218.157097]        [<drivers/base/dd.c:460>] __driver_attach+0x69/0xa0
[  218.157097]        [<drivers/base/bus.c:311>] bus_for_each_dev+0x66/0xc0
[  218.157097]        [<drivers/base/dd.c:480>] driver_attach+0x19/0x20
[  218.157097]        [<drivers/base/bus.c:692>] bus_add_driver+0x116/0x240
[  218.157097]        [<drivers/base/driver.c:167>] driver_register+0xa8/0xf0
[  218.157097]        [<drivers/base/platform.c:542>] __platform_driver_register+0x45/0x50
[  218.157097]        [<drivers/base/platform.c:590>] platform_driver_probe+0x1f/0xc0
[  218.157097]        [<drivers/rtc/rtc-cmos.c:1200>] cmos_init+0x3f/0x77
[  218.157097]        [<init/main.c:696>] do_one_initcall+0xc2/0x1e0
[  218.157097]        [<init/main.c:761 init/main.c:770 init/main.c:789>] do_basic_setup+0x9c/0xbf
[  218.157097]        [<init/main.c:913>] kernel_init_freeable+0x2d1/0x354
[  218.157097]        [<init/main.c:842>] kernel_init+0x9/0xf0
[  218.157097]        [<arch/x86/kernel/entry_64.S:555>] ret_from_fork+0x7c/0xb0
[  218.157097]
-> #0 (&rtc->ops_lock){+.+.+.}:
[  218.157097]        [<kernel/locking/lockdep.c:1840>] check_prev_add+0x13f/0x560
[  218.157097]        [<kernel/locking/lockdep.c:1945 kernel/locking/lockdep.c:2131>] 
validate_chain+0x6ca/0x7c0
[  218.157097]        [<kernel/locking/lockdep.c:3182>] __lock_acquire+0x4ad/0x580
[  218.157097]        [<arch/x86/include/asm/current.h:14 kernel/locking/lockdep.c:3602>] 
lock_acquire+0x182/0x1d0
[  218.157097]        [<kernel/locking/mutex.c:470 kernel/locking/mutex.c:600>] 
mutex_lock_interruptible_nested+0x6a/0x600
[  218.157097]        [<drivers/rtc/interface.c:42>] rtc_read_time+0x2b/0x60
[  218.157097]        [<drivers/rtc/rtc-sysfs.c:56>] time_show+0x15/0x40
[  218.157097]        [<drivers/base/core.c:122>] dev_attr_show+0x22/0x50
[  218.157097]        [<fs/sysfs/file.c:62>] sysfs_kf_seq_show+0xa8/0x130
[  218.157097]        [<fs/kernfs/file.c:155>] kernfs_seq_show+0x21/0x30
[  218.157097]        [<fs/seq_file.c:109>] traverse+0xd8/0x1f0
[  218.157097]        [<fs/seq_file.c:179>] seq_read+0x5c/0x430
[  218.157097]        [<fs/kernfs/file.c:230>] kernfs_fop_read+0x24/0x40
[  218.157097]        [<fs/read_write.c:396>] vfs_read+0xb4/0x180
[  218.157097]        [<include/linux/file.h:36 fs/read_write.c:545 fs/read_write.c:532>] 
SyS_pread64+0x67/0x90
[  218.157097]        [<arch/x86/kernel/entry_64.S:749>] tracesys+0xdd/0xe2
[  218.157097]
[  218.157097] other info that might help us debug this:
[  218.157097]
[  218.157097]  Possible unsafe locking scenario:
[  218.157097]
[  218.157097]        CPU0                    CPU1
[  218.157097]        ----                    ----
[  218.157097]   lock(s_active#20);
[  218.157097]                                lock(&rtc->ops_lock);
[  218.157097]                                lock(s_active#20);
[  218.157097]   lock(&rtc->ops_lock);
[  218.157097]
[  218.157097]  *** DEADLOCK ***
[  218.157097]
[  218.157097] 3 locks held by trinity-c47/11528:
[  218.157097]  #0:  (&p->lock){+.+.+.}, at: [<fs/seq_file.c:175>] seq_read+0x3a/0x430
[  218.157097]  #1:  (&of->mutex){+.+.+.}, at: [<fs/kernfs/file.c:99>] kernfs_seq_start+0x2c/0xa0
[  218.157097]  #2:  (s_active#20){++++.+}, at: [<fs/kernfs/file.c:99>] kernfs_seq_start+0x34/0xa0
[  218.157097]
[  218.157097] stack backtrace:
[  218.157097] CPU: 8 PID: 11528 Comm: trinity-c47 Tainted: G        W 
3.14.0-rc3-next-20140221-sasha-00008-g0e660cf-dirty #116
[  218.157097]  0000000000000000 ffff8806a74dba18 ffffffff843894c8 0000000000000000
[  218.157097]  0000000000000000 ffff8806a74dba68 ffffffff811a0379 ffff8806a74dba88
[  218.157097]  ffff8806a74dba88 ffff8806a74dba68 ffff8806a96d0d38 ffff8806a96d0d70
[  218.157097] Call Trace:
[  218.157097]  [<lib/dump_stack.c:52>] dump_stack+0x52/0x7f
[  218.157097]  [<kernel/locking/lockdep.c:1213>] print_circular_bug+0x129/0x160
[  218.157097]  [<kernel/locking/lockdep.c:1840>] check_prev_add+0x13f/0x560
[  218.157097]  [<arch/x86/include/asm/paravirt.h:192 arch/x86/kernel/tsc.c:305>] ? 
sched_clock+0x1d/0x30
[  218.157097]  [<kernel/locking/lockdep.c:1945 kernel/locking/lockdep.c:2131>] 
validate_chain+0x6ca/0x7c0
[  218.157097]  [<kernel/locking/lockdep.c:3182>] __lock_acquire+0x4ad/0x580
[  218.157097]  [<arch/x86/include/asm/current.h:14 kernel/locking/lockdep.c:3602>] 
lock_acquire+0x182/0x1d0
[  218.157097]  [<drivers/rtc/interface.c:42>] ? rtc_read_time+0x2b/0x60
[  218.157097]  [<kernel/locking/mutex.c:470 kernel/locking/mutex.c:600>] 
mutex_lock_interruptible_nested+0x6a/0x600
[  218.157097]  [<drivers/rtc/interface.c:42>] ? rtc_read_time+0x2b/0x60
[  218.157097]  [<kernel/locking/lockdep.c:3189>] ? __lock_acquire+0x4cd/0x580
[  218.157097]  [<drivers/rtc/interface.c:42>] ? rtc_read_time+0x2b/0x60
[  218.157097]  [<drivers/rtc/interface.c:42>] rtc_read_time+0x2b/0x60
[  218.157097]  [<drivers/rtc/rtc-sysfs.c:56>] time_show+0x15/0x40
[  218.157097]  [<drivers/base/core.c:122>] dev_attr_show+0x22/0x50
[  218.157097]  [<fs/sysfs/file.c:33>] ? sysfs_file_ops+0x30/0x60
[  218.157097]  [<fs/sysfs/file.c:62>] sysfs_kf_seq_show+0xa8/0x130
[  218.157097]  [<fs/kernfs/file.c:155>] kernfs_seq_show+0x21/0x30
[  218.157097]  [<fs/seq_file.c:109>] traverse+0xd8/0x1f0
[  218.157097]  [<fs/seq_file.c:179>] seq_read+0x5c/0x430
[  218.157097]  [<security/security.c:677>] ? security_file_permission+0x85/0x90
[  218.157097]  [<fs/kernfs/file.c:230>] kernfs_fop_read+0x24/0x40
[  218.157097]  [<fs/read_write.c:396>] vfs_read+0xb4/0x180
[  218.157097]  [<include/linux/file.h:36 fs/read_write.c:545 fs/read_write.c:532>] 
SyS_pread64+0x67/0x90
[  218.157097]  [<arch/x86/kernel/entry_64.S:749>] tracesys+0xdd/0xe2


Thanks,
Sasha
