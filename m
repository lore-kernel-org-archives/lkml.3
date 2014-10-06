Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752105AbaJFA2D (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2014 20:28:03 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:39904 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751895AbaJFA2B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2014 20:28:01 -0400
Message-ID: <5431E203.9070501@oracle.com>
Date: Sun, 05 Oct 2014 20:27:47 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: linux-fsdevel <linux-fsdevel@vger.kernel.org>
CC: Al Viro <viro@ZenIV.linux.org.uk>, bfields@redhat.com, mszeredi@suse.cz,
        "Eric W. Biederman" <ebiederm@xmission.com>, hch@lst.de,
        Dave Jones <davej@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Subject: dcache: NULL ptr deref in dentry_kill
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

While fuzzing with trinity inside a KVM tools guest running the latest -next
kernel, I've stumbled on the following spew:

[  434.580818] BUG: unable to handle kernel NULL pointer dereference at 0000000000000090
[  434.582208] IP: do_raw_spin_trylock (./arch/x86/include/asm/spinlock.h:108 kernel/locking/spinlock_debug.c:143)
[  434.583243] PGD 0
[  434.583602] Oops: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
[  434.584568] Dumping ftrace buffer:
[  434.585202]    (ftrace buffer empty)
[  434.585888] Modules linked in:
[  434.586416] CPU: 2 PID: 10385 Comm: trinity-c54 Not tainted 3.17.0-rc7-next-20141003-sasha-00039-g5069327 #1323
[  434.588072] task: ffff880051593000 ti: ffff88098708c000 task.ti: ffff88098708c000
[  434.589373] RIP: do_raw_spin_trylock (./arch/x86/include/asm/spinlock.h:108 kernel/locking/spinlock_debug.c:143)
[  434.590025] RSP: 0000:ffff88098708fbf0  EFLAGS: 00010292
[  434.590025] RAX: 0000000000000002 RBX: 0000000000000090 RCX: 0000000000000000
[  434.590025] RDX: 0000000000000000 RSI: ffff880170c22928 RDI: 0000000000000090
[  434.590025] RBP: ffff88098708fc18 R08: 0000000000000001 R09: 0000000000000000
[  434.590025] R10: 0000000000000000 R11: 0000000000000000 R12: ffff880170c22910
[  434.590025] R13: 0000000000000000 R14: 0000000000000000 R15: ffff880170c22880
[  434.590025] FS:  00007fa20164e700(0000) GS:ffff880177a00000(0000) knlGS:0000000000000000
[  434.590025] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  434.590025] CR2: 0000000000000090 CR3: 000000001de31000 CR4: 00000000000006a0
[  434.590025] DR0: 00000000006ef000 DR1: 00000000006ef000 DR2: 0000000000000000
[  434.590025] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000600
[  434.590025] Stack:
[  434.590025]  ffffffff9c525d23 ffff88098708fc18 ffffffff99b56b41 ffff88098708fc18
[  434.590025]  ffff880170c22880 ffff88098708fc48 ffffffff99349126 ffff880174260700
[  434.590025]  0000000000000008 ffff880a5a998ac0 ffff8805c2e60020 ffff88098708fc98
[  434.590025] Call Trace:
[  434.590025] ? _raw_spin_trylock (include/linux/spinlock_api_smp.h:89 kernel/locking/spinlock.c:135)
[  434.590025] ? lockref_put_or_lock (lib/lockref.c:131)
[  434.590025] dput (fs/dcache.c:513 fs/dcache.c:616)
[  434.590025] __fput (fs/file_table.c:235)
[  434.590025] ____fput (fs/file_table.c:253)
[  434.590025] task_work_run (kernel/task_work.c:125 (discriminator 1))
[  434.590025] do_exit (kernel/exit.c:761)
[  434.590025] ? get_signal (kernel/signal.c:2332)
[  434.590025] ? debug_smp_processor_id (lib/smp_processor_id.c:57)
[  434.590025] ? put_lock_stats.isra.12 (./arch/x86/include/asm/preempt.h:98 kernel/locking/lockdep.c:254)
[  434.590025] ? _raw_spin_unlock_irq (./arch/x86/include/asm/paravirt.h:819 include/linux/spinlock_api_smp.h:168 kernel/locking/spinlock.c:199)
[  434.590025] do_group_exit (kernel/exit.c:890)
[  434.590025] get_signal (kernel/signal.c:2350)
[  434.590025] ? kvm_clock_read (./arch/x86/include/asm/preempt.h:90 arch/x86/kernel/kvmclock.c:86)
[  434.590025] ? sched_clock_local (kernel/sched/clock.c:214)
[  434.590025] do_signal (arch/x86/kernel/signal.c:703)
[  434.590025] ? get_parent_ip (kernel/sched/core.c:2606)
[  434.590025] ? context_tracking_user_exit (include/linux/vtime.h:89 include/linux/jump_label.h:114 include/trace/events/context_tracking.h:47 kernel/context_tracking.c:180)
[  434.590025] ? context_tracking_user_exit (./arch/x86/include/asm/paravirt.h:809 (discriminator 2) kernel/context_tracking.c:184 (discriminator 2))
[  434.590025] ? __this_cpu_preempt_check (lib/smp_processor_id.c:63)
[  434.590025] ? trace_hardirqs_on_caller (kernel/locking/lockdep.c:2559 kernel/locking/lockdep.c:2601)
[  434.590025] ? trace_hardirqs_on (kernel/locking/lockdep.c:2609)
[  434.590025] do_notify_resume (arch/x86/kernel/signal.c:756)
[  434.590025] int_signal (arch/x86/kernel/entry_64.S:587)
[  434.590025] Code: 65 f0 89 43 08 4c 8b 6d f8 65 48 8b 04 25 c0 cb 00 00 48 89 43 10 48 8b 5d e8 c9 c3 66 2e 0f 1f 84 00 00 00 00 00 66 66 66 66 90 <8b> 0f 55 31 f6 48 89 e5 89 ca 0f b7 c1 c1 ea 10 83 e2 fe 39 d0
[  434.590025] RIP do_raw_spin_trylock (./arch/x86/include/asm/spinlock.h:108 kernel/locking/spinlock_debug.c:143)
[  434.590025]  RSP <ffff88098708fbf0>
[  434.590025] CR2: 0000000000000090


Thanks,
Sasha
