Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754084AbaEEAsN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2014 20:48:13 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:49434 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754024AbaEEAsL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2014 20:48:11 -0400
Message-ID: <5366DFBF.6090204@oracle.com>
Date: Sun, 04 May 2014 20:47:59 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>
Subject: tracing: NULL ptr deref in ring_buffer_wait
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

While fuzzing with trinity inside a KVM tools guest running latest -next
kernel I've stumbled on the following:


[ 3589.386869] BUG: unable to handle kernel NULL pointer dereference at 00000000000001f0
[ 3589.389326] IP: __lock_acquire (kernel/locking/lockdep.c:3070 (discriminator 1))
[ 3589.390099] PGD 44bf8067 PUD 392d1067 PMD ac4c2067 PTE 0
[ 3589.390099] Oops: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
[ 3589.390099] Dumping ftrace buffer:
[ 3589.390099]    (ftrace buffer empty)
[ 3589.390099] Modules linked in:
[ 3589.395496] CPU: 37 PID: 28180 Comm: trinity-c168 Not tainted 3.15.0-rc3-next-20140502-sasha-00020-g3183c20 #432
[ 3589.396585] task: ffff8802c77d3000 ti: ffff88005c9d0000 task.ti: ffff88005c9d0000
[ 3589.396585] RIP: __lock_acquire (kernel/locking/lockdep.c:3070 (discriminator 1))
[ 3589.396585] RSP: 0018:ffff88005c9d1c18  EFLAGS: 00010002
[ 3589.396585] RAX: 0000000000000086 RBX: ffff8802c77d3000 RCX: 0000000000000000
[ 3589.396585] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 00000000000001f0
[ 3589.396585] RBP: ffff88005c9d1d08 R08: 0000000000000001 R09: 0000000000000001
[ 3589.396585] R10: ffff8802c77d3000 R11: 0000000000000001 R12: 0000000000000000
[ 3589.396585] R13: 00000000000001f0 R14: 0000000000000000 R15: 0000000000000000
[ 3589.396585] FS:  00007f1cfe809700(0000) GS:ffff88017ce00000(0000) knlGS:0000000000000000
[ 3589.407670] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 3589.407670] CR2: 00000000000001f0 CR3: 000000005cba3000 CR4: 00000000000006a0
[ 3589.407670] DR0: 00000000006de000 DR1: 0000000000000000 DR2: 0000000000000000
[ 3589.407670] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000600
[ 3589.407670] Stack:
[ 3589.407670]  0000000000000025 ffff88017cfd8380 00000000001d8380 0000000000000025
[ 3589.407670]  ffff88005c9d1c68 ffffffffa81a5df8 0002fa098d2fe980 0000000000000000
[ 3589.407670]  0002fa098d2fe980 0000000000000001 ffffffffaf415f20 0000000000015ee0
[ 3589.407670] Call Trace:
[ 3589.407670] ? sched_clock_cpu (kernel/sched/clock.c:311)
[ 3589.407670] ? __lock_acquire (kernel/locking/lockdep.c:3189)
[ 3589.407670] lock_acquire (arch/x86/include/asm/current.h:14 kernel/locking/lockdep.c:3602)
[ 3589.407670] ? prepare_to_wait (kernel/sched/wait.c:177)
[ 3589.407670] ? _raw_spin_lock_irqsave (include/linux/spinlock_api_smp.h:109 kernel/locking/spinlock.c:159)
[ 3589.407670] _raw_spin_lock_irqsave (include/linux/spinlock_api_smp.h:117 kernel/locking/spinlock.c:159)
[ 3589.407670] ? prepare_to_wait (kernel/sched/wait.c:177)
[ 3589.407670] ? get_parent_ip (kernel/sched/core.c:2485)
[ 3589.407670] ? mutex_unlock (kernel/locking/mutex.c:220)
[ 3589.407670] prepare_to_wait (kernel/sched/wait.c:177)
[ 3589.407670] ? __mutex_unlock_slowpath (arch/x86/include/asm/paravirt.h:809 kernel/locking/mutex.c:713 kernel/locking/mutex.c:722)
[ 3589.407670] ring_buffer_wait (kernel/trace/ring_buffer.c:587)
[ 3589.407670] ? bit_waitqueue (kernel/sched/wait.c:291)
[ 3589.407670] wait_on_pipe (kernel/trace/trace.c:1095)
[ 3589.407670] tracing_buffers_read (kernel/trace/trace.c:5162)
[ 3589.407670] vfs_read (fs/read_write.c:430)
[ 3589.407670] SyS_read (fs/read_write.c:568 fs/read_write.c:560)
[ 3589.407670] tracesys (arch/x86/kernel/entry_64.S:746)
[ 3589.407670] Code: 85 cd 0c 00 00 48 c7 c1 5c e1 6d ac 48 c7 c2 af 89 6d ac 31 c0 be fa 0b 00 00 48 c7 c7 16 e1 6d ac e8 3c 68 f9 ff e9 a7 0c 00 00 <49> 81 7d 00 80 81 76 ae b8 00 00 00 00 44 0f 44 c0 eb 07 0f 1f
[ 3589.407670] RIP __lock_acquire (kernel/locking/lockdep.c:3070 (discriminator 1))
[ 3589.407670]  RSP <ffff88005c9d1c18>
[ 3589.407670] CR2: 00000000000001f0


Thanks,
Sasha
