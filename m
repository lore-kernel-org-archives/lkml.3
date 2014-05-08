Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754567AbaEHPcH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 11:32:07 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:17219 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753127AbaEHPcF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 11:32:05 -0400
Message-ID: <536BA35D.50807@oracle.com>
Date: Thu, 08 May 2014 11:31:41 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>
Subject: Re: tracing: NULL ptr deref in ring_buffer_wait
References: <5366DFBF.6090204@oracle.com> <20140505104712.11c63a5d@gandalf.local.home> <5367B248.2010804@oracle.com>
In-Reply-To: <5367B248.2010804@oracle.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/05/2014 11:46 AM, Sasha Levin wrote:
>>> >> [ 3589.407670] vfs_read (fs/read_write.c:430)
>>> >> [ 3589.407670] SyS_read (fs/read_write.c:568 fs/read_write.c:560)
>>> >> [ 3589.407670] tracesys (arch/x86/kernel/entry_64.S:746)
>>> >> [ 3589.407670] Code: 85 cd 0c 00 00 48 c7 c1 5c e1 6d ac 48 c7 c2 af 89 6d ac 31 c0 be fa 0b 00 00 48 c7 c7 16 e1 6d ac e8 3c 68 f9 ff e9 a7 0c 00 00 <49> 81 7d 00 80 81 76 ae b8 00 00 00 00 44 0f 44 c0 eb 07 0f 1f
>>> >> [ 3589.407670] RIP __lock_acquire (kernel/locking/lockdep.c:3070 (discriminator 1))
>>> >> [ 3589.407670]  RSP <ffff88005c9d1c18>
>>> >> [ 3589.407670] CR2: 00000000000001f0
>> > 
>> > Is this easily reproducible?
> Nope, only saw it once.

And a second time today, I guess I could put a debug patch and see if that
helps, if you had something in mind...

[ 1157.707702] BUG: unable to handle kernel NULL pointer dereference at 00000000000001f0
[ 1157.710068] IP: __lock_acquire (kernel/locking/lockdep.c:3070 (discriminator 1))
[ 1157.710068] PGD 243db1067 PUD 25b047067 PMD 0
[ 1157.710068] Oops: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
[ 1157.710068] Dumping ftrace buffer:
[ 1157.710068]    (ftrace buffer empty)
[ 1157.710068] Modules linked in:
[ 1157.710068] CPU: 14 PID: 30503 Comm: trinity-c247 Tainted: G        W     3.15.0-rc4-next-20140507-sasha-00004-g14be78b-dirty #450
[ 1157.710068] task: ffff880002ec0000 ti: ffff880240ec8000 task.ti: ffff880240ec8000
[ 1157.710068] RIP: __lock_acquire (kernel/locking/lockdep.c:3070 (discriminator 1))
[ 1157.710068] RSP: 0000:ffff880240ec9ab8  EFLAGS: 00010002
[ 1157.710068] RAX: 0000000000000086 RBX: ffff880002ec0000 RCX: 0000000000000000
[ 1157.710068] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 00000000000001f0
[ 1157.710068] RBP: ffff880240ec9ba8 R08: 0000000000000001 R09: 0000000000000001
[ 1157.710068] R10: ffff880002ec0000 R11: 0000000000000001 R12: 0000000000000000
[ 1157.710068] R13: 00000000000001f0 R14: 0000000000000000 R15: 0000000000000000
[ 1157.710068] FS:  00007f33d790b700(0000) GS:ffff88036ac00000(0000) knlGS:0000000000000000
[ 1157.710068] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 1157.710068] CR2: 00000000000001f0 CR3: 0000000243fb6000 CR4: 00000000000006a0
[ 1157.710068] DR0: 00000000006df000 DR1: 0000000000000000 DR2: 0000000000000000
[ 1157.710068] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000600
[ 1157.710068] Stack:
[ 1157.710068]  ffff880240ec9ac8 ffffffffa30be274 ffff880240ec9ad8 ffffffffa307c7e5
[ 1157.710068]  ffff880240ec9b08 ffffffffa31a7a05 000000000000000e ffff88036add8380
[ 1157.710068]  00000000001d8380 000000000000000e ffff880240ec9b38 ffffffffa31a7ce8
[ 1157.710068] Call Trace:
[ 1157.710068] ? kvm_clock_read (arch/x86/include/asm/preempt.h:90 arch/x86/kernel/kvmclock.c:86)
[ 1157.710068] ? sched_clock (arch/x86/include/asm/paravirt.h:192 arch/x86/kernel/tsc.c:305)
[ 1157.710068] ? sched_clock_local (kernel/sched/clock.c:214)
[ 1157.710068] ? sched_clock_cpu (kernel/sched/clock.c:311)
[ 1157.710068] ? __lock_acquire (kernel/locking/lockdep.c:3189)
[ 1157.710068] lock_acquire (arch/x86/include/asm/current.h:14 kernel/locking/lockdep.c:3602)
[ 1157.710068] ? prepare_to_wait (kernel/sched/wait.c:177)
[ 1157.710068] ? _raw_spin_lock_irqsave (include/linux/spinlock_api_smp.h:109 kernel/locking/spinlock.c:159)
[ 1157.710068] _raw_spin_lock_irqsave (include/linux/spinlock_api_smp.h:117 kernel/locking/spinlock.c:159)
[ 1157.710068] ? prepare_to_wait (kernel/sched/wait.c:177)
[ 1157.710068] ? get_parent_ip (kernel/sched/core.c:2485)
[ 1157.710068] ? mutex_unlock (kernel/locking/mutex.c:220)
[ 1157.710068] prepare_to_wait (kernel/sched/wait.c:177)
[ 1157.710068] ? __mutex_unlock_slowpath (arch/x86/include/asm/paravirt.h:809 kernel/locking/mutex.c:713 kernel/locking/mutex.c:722)
[ 1157.710068] ring_buffer_wait (kernel/trace/ring_buffer.c:587)
[ 1157.710068] ? bit_waitqueue (kernel/sched/wait.c:291)
[ 1157.710068] wait_on_pipe (kernel/trace/trace.c:1095)
[ 1157.710068] tracing_wait_pipe.isra.19 (kernel/trace/trace.c:4235)
[ 1157.710068] tracing_read_pipe (kernel/trace/trace.c:4281)
[ 1157.710068] ? tracing_splice_read_pipe (kernel/trace/trace.c:4250)
[ 1157.710068] do_loop_readv_writev (fs/read_write.c:708)
[ 1157.710068] ? tracing_splice_read_pipe (kernel/trace/trace.c:4250)
[ 1157.710068] compat_do_readv_writev (fs/read_write.c:1020)
[ 1157.710068] ? get_parent_ip (kernel/sched/core.c:2485)
[ 1157.710068] ? mutex_lock_nested (arch/x86/include/asm/preempt.h:98 kernel/locking/mutex.c:570 kernel/locking/mutex.c:587)
[ 1157.710068] ? __fdget_pos (fs/file.c:714)
[ 1157.710068] ? __fdget_pos (fs/file.c:714)
[ 1157.710068] ? __fget_light (include/linux/rcupdate.h:428 include/linux/fdtable.h:80 fs/file.c:684)
[ 1157.710068] compat_readv (fs/read_write.c:1053)
[ 1157.710068] compat_SyS_readv (fs/read_write.c:1071 fs/read_write.c:1061)
[ 1157.710068] ia32_do_call (arch/x86/ia32/ia32entry.S:430)
[ 1157.710068] Code: 85 cd 0c 00 00 48 c7 c1 d4 12 6e a7 48 c7 c2 2f bb 6d a7 31 c0 be fa 0b 00 00 48 c7 c7 8e 12 6e a7 e8 6c 66 f9 ff e9 a7 0c 00 00 <49> 81 7d 00 40 f8 96 a9 b8 00 00 00 00 44 0f 44 c0 eb 07 0f 1f
[ 1157.710068] RIP __lock_acquire (kernel/locking/lockdep.c:3070 (discriminator 1))
[ 1157.710068]  RSP <ffff880240ec9ab8>
[ 1157.710068] CR2: 00000000000001f0


Thanks,
Sasha
