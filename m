Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751144AbbAMFLn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 00:11:43 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:26183 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750845AbbAMFLl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 00:11:41 -0500
Message-ID: <54B4A909.9060206@oracle.com>
Date: Tue, 13 Jan 2015 00:11:37 -0500
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Jeff Layton <jeff.layton@primarydata.com>
CC: LKML <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: fs: locks: WARNING: CPU: 16 PID: 4296 at fs/locks.c:236 locks_free_lock_context+0x10d/0x240()
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Jeff,

While fuzzing with trinity inside a KVM tools guest running the latest -next
kernel, I've stumbled on the following spew:

[  887.078606] WARNING: CPU: 16 PID: 4296 at fs/locks.c:236 locks_free_lock_context+0x10d/0x240()
[  887.079703] Modules linked in:
[  887.080288] CPU: 16 PID: 4296 Comm: trinity-c273 Not tainted 3.19.0-rc4-next-20150112-sasha-00053-g23c147e02e-dirty #1710
[  887.082229]  0000000000000000 0000000000000000 0000000000000000 ffff8804c9f4f8e8
[  887.083773]  ffffffff9154e0a6 0000000000000000 ffff8804cad98000 ffff8804c9f4f938
[  887.085280]  ffffffff8140a4d0 0000000000000001 ffffffff81bf0d2d ffff8804c9f4f988
[  887.086792] Call Trace:
[  887.087320] dump_stack (lib/dump_stack.c:52)
[  887.088247] warn_slowpath_common (kernel/panic.c:447)
[  887.089342] ? locks_free_lock_context (fs/locks.c:236 (discriminator 3))
[  887.090514] warn_slowpath_null (kernel/panic.c:481)
[  887.091629] locks_free_lock_context (fs/locks.c:236 (discriminator 3))
[  887.092782] __destroy_inode (fs/inode.c:243)
[  887.093817] destroy_inode (fs/inode.c:268)
[  887.094833] evict (fs/inode.c:574)
[  887.095808] iput (fs/inode.c:1503)
[  887.096687] __dentry_kill (fs/dcache.c:323 fs/dcache.c:508)
[  887.097683] ? _raw_spin_trylock (kernel/locking/spinlock.c:136)
[  887.098733] ? dput (fs/dcache.c:545 fs/dcache.c:648)
[  887.099672] dput (fs/dcache.c:649)
[  887.100552] __fput (fs/file_table.c:227)
[  887.101437] ____fput (fs/file_table.c:245)
[  887.102317] task_work_run (kernel/task_work.c:125 (discriminator 1))
[  887.103356] ? _raw_spin_unlock (./arch/x86/include/asm/preempt.h:95 include/linux/spinlock_api_smp.h:154 kernel/locking/spinlock.c:183)
[  887.104390] do_exit (kernel/exit.c:746)
[  887.105338] ? task_numa_work (kernel/sched/fair.c:2218)
[  887.106384] ? get_signal (kernel/signal.c:2207)
[  887.107492] ? _raw_spin_unlock_irq (./arch/x86/include/asm/paravirt.h:819 include/linux/spinlock_api_smp.h:170 kernel/locking/spinlock.c:199)
[  887.108610] do_group_exit (include/linux/sched.h:775 kernel/exit.c:858)
[  887.109613] get_signal (kernel/signal.c:2358)
[  887.110578] ? trace_hardirqs_off (kernel/locking/lockdep.c:2671)
[  887.111672] do_signal (arch/x86/kernel/signal.c:703)
[  887.112604] ? acct_account_cputime (kernel/tsacct.c:168)
[  887.113722] ? context_tracking_user_exit (./arch/x86/include/asm/paravirt.h:809 (discriminator 2) kernel/context_tracking.c:144 (discriminator 2))
[  887.114937] ? trace_hardirqs_on_caller (kernel/locking/lockdep.c:2578 kernel/locking/lockdep.c:2625)
[  887.116128] ? trace_hardirqs_on (kernel/locking/lockdep.c:2633)
[  887.117160] do_notify_resume (arch/x86/kernel/signal.c:750)
[  887.118167] int_signal (arch/x86/kernel/entry_64.S:587)


Thanks,
Sasha
