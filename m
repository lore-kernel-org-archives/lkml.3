Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751528AbaF0QsW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 12:48:22 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:16650 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750971AbaF0QsV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 12:48:21 -0400
Message-ID: <53ADA04B.3010707@oracle.com>
Date: Fri, 27 Jun 2014 12:48:11 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, josh@joshtriplett.org
CC: LKML <linux-kernel@vger.kernel.org>
Subject: rcu: NULL ptr deref on boot
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

I've noticed the following on boot with the latest -next kernel:

[    0.000000] WARNING: CPU: 0 PID: 0 at arch/x86/kernel/cpu/common.c:1439 warn_pre_alternatives+0x1e/0x20()
[    0.000000] You're using static_cpu_has before alternatives have run!
[    0.000000] Modules linked in:
[    0.000000] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.16.0-rc2-next-20140627-sasha-00023-g5d10814-dirty #734
[    0.000000]  0000000000000009 ffffffff9d003c48 ffffffff9b525423 0000000000000002
[    0.000000]  ffffffff9d003c98 ffffffff9d003c88 ffffffff98168aec ffffffff9d003d58
[    0.000000]  0000000000000000 ffffffff9d003e78 0000000000000000 0000000000000002
[    0.000000] Call Trace:
[    0.000000] dump_stack (lib/dump_stack.c:52)
[    0.000000] warn_slowpath_common (kernel/panic.c:431)
[    0.000000] warn_slowpath_fmt (kernel/panic.c:446)
[    0.000000] ? irq_return (arch/x86/kernel/entry_64.S:842)
[    0.000000] warn_pre_alternatives (arch/x86/kernel/cpu/common.c:1440)
[    0.000000] __do_page_fault (./arch/x86/include/asm/cpufeature.h:423 arch/x86/mm/fault.c:1022 arch/x86/mm/fault.c:1112)
[    0.000000] ? trace_hardirqs_off_caller (kernel/locking/lockdep.c:2638 (discriminator 2))
[    0.000000] ? trace_hardirqs_off (kernel/locking/lockdep.c:2645)
[    0.000000] ? __slab_alloc (mm/slub.c:2364 (discriminator 1))
[    0.000000] ? __this_cpu_preempt_check (lib/smp_processor_id.c:63)
[    0.000000] ? trace_hardirqs_off_caller (kernel/locking/lockdep.c:2638 (discriminator 2))
[    0.000000] ? error_sti (arch/x86/kernel/entry_64.S:1419)
[    0.000000] trace_do_page_fault (arch/x86/mm/fault.c:1313 include/linux/jump_label.h:115 include/linux/context_tracking_state.h:27 include/linux/context_tracking.h:45 arch/x86/mm/fault.c:1314)
[    0.000000] do_async_page_fault (arch/x86/kernel/kvm.c:264)
[    0.000000] async_page_fault (arch/x86/kernel/entry_64.S:1322)
[    0.000000] ? tick_nohz_init (include/linux/bitmap.h:165 include/linux/cpumask.h:333 kernel/time/tick-sched.c:344 kernel/time/tick-sched.c:356)
[    0.000000] ? tick_nohz_init (include/linux/bitmap.h:164 include/linux/cpumask.h:333 kernel/time/tick-sched.c:344 kernel/time/tick-sched.c:356)
[    0.000000] start_kernel (init/main.c:581)
[    0.000000] ? set_init_arg (init/main.c:281)
[    0.000000] ? early_idt_handlers (arch/x86/kernel/head_64.S:340)
[    0.000000] x86_64_start_reservations (arch/x86/kernel/head64.c:194)
[    0.000000] x86_64_start_kernel (arch/x86/kernel/head64.c:183)
[    0.000000] ---[ end trace 4d5ff9f2f68c4233 ]---
[    0.000000] BUG: unable to handle kernel NULL pointer dereference at           (null)
[    0.000000] IP: tick_nohz_init (include/linux/bitmap.h:165 include/linux/cpumask.h:333 kernel/time/tick-sched.c:344 kernel/time/tick-sched.c:356)
[    0.000000] PGD 0
[    0.000000] Oops: 0002 [#1] PREEMPT SMP DEBUG_PAGEALLOC
[    0.000000] Modules linked in:
[    0.000000] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G        W      3.16.0-rc2-next-20140627-sasha-00023-g5d10814-dirty #734
[    0.000000] task: ffffffff9d0354c0 ti: ffffffff9d000000 task.ti: ffffffff9d000000
[    0.000000] RIP: tick_nohz_init (include/linux/bitmap.h:165 include/linux/cpumask.h:333 kernel/time/tick-sched.c:344 kernel/time/tick-sched.c:356)
[    0.000000] RSP: 0000:ffffffff9d003f28  EFLAGS: 00010002
[    0.000000] RAX: 0000000000000000 RBX: ffff88003684d480 RCX: 0000000000000008
[    0.000000] RDX: 0000000000000014 RSI: ffff88003684d480 RDI: 0000000000000000
[    0.000000] RBP: ffffffff9d003f38 R08: ffff88003684d480 R09: ffff88003684d480
[    0.000000] R10: ffff88003684d480 R11: 0000000000000001 R12: ffffffff9e5fd020
[    0.000000] R13: ffff88070282ca00 R14: ffffffff9e607ae0 R15: 00000000000146f0
[    0.000000] FS:  0000000000000000(0000) GS:ffff880036e00000(0000) knlGS:0000000000000000
[    0.000000] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[    0.000000] CR2: 0000000000000000 CR3: 000000001d02e000 CR4: 00000000000006b0
[    0.000000] Stack:
[    0.000000]  ffffffffffffffff ffffffff9e5fd020 ffffffff9d003f88 ffffffff9e4c9f09
[    0.000000]  ffffffff9e4c98fd 00000000000146f0 ffffffff9d003f78 ffffffff9e607ae0
[    0.000000]  0000000000000020 ffffffff9e4c9117 00000000ffffffff 0000ffffffff9e4c
[    0.000000] Call Trace:
[    0.000000] start_kernel (init/main.c:581)
[    0.000000] ? set_init_arg (init/main.c:281)
[    0.000000] ? early_idt_handlers (arch/x86/kernel/head_64.S:340)
[    0.000000] x86_64_start_reservations (arch/x86/kernel/head64.c:194)
[    0.000000] x86_64_start_kernel (arch/x86/kernel/head64.c:183)
[ 0.000000] Code: e8 d0 84 66 fa 89 c7 48 89 de e8 b0 46 02 fd 48 63 0d 4f 91 dd ff 31 c0 48 8b 3d 5e 1f 1c 01 48 83 c1 3f 48 c1 f9 03 48 83 e1 f8 <f3> aa 48 8b 1d 49 1f 1c 01 e8 9c 84 66 fa 89 c7 e8 25 3c d1 f9
All code
========
   0:	e8 d0 84 66 fa       	callq  0xfffffffffa6684d5
   5:	89 c7                	mov    %eax,%edi
   7:	48 89 de             	mov    %rbx,%rsi
   a:	e8 b0 46 02 fd       	callq  0xfffffffffd0246bf
   f:	48 63 0d 4f 91 dd ff 	movslq -0x226eb1(%rip),%rcx        # 0xffffffffffdd9165
  16:	31 c0                	xor    %eax,%eax
  18:	48 8b 3d 5e 1f 1c 01 	mov    0x11c1f5e(%rip),%rdi        # 0x11c1f7d
  1f:	48 83 c1 3f          	add    $0x3f,%rcx
  23:	48 c1 f9 03          	sar    $0x3,%rcx
  27:	48 83 e1 f8          	and    $0xfffffffffffffff8,%rcx
  2b:	f3 aa                	rep stos %al,%es:*(%rdi)		<-- trapping instruction
  2d:	48 8b 1d 49 1f 1c 01 	mov    0x11c1f49(%rip),%rbx        # 0x11c1f7d
  34:	e8 9c 84 66 fa       	callq  0xfffffffffa6684d5
  39:	89 c7                	mov    %eax,%edi
  3b:	e8 25 3c d1 f9       	callq  0xfffffffff9d13c65
	...

Code starting with the faulting instruction
===========================================
   0:	f3 aa                	rep stos %al,%es:(%rdi)
   2:	48 8b 1d 49 1f 1c 01 	mov    0x11c1f49(%rip),%rbx        # 0x11c1f52
   9:	e8 9c 84 66 fa       	callq  0xfffffffffa6684aa
   e:	89 c7                	mov    %eax,%edi
  10:	e8 25 3c d1 f9       	callq  0xfffffffff9d13c3a
	...
[    0.000000] RIP tick_nohz_init (include/linux/bitmap.h:165 include/linux/cpumask.h:333 kernel/time/tick-sched.c:344 kernel/time/tick-sched.c:356)
[    0.000000]  RSP <ffffffff9d003f28>
[    0.000000] CR2: 0000000000000000

Bisection pointed me to "rcu: Bind grace-period kthreads to non-NO_HZ_FULL CPUs".


Thanks,
Sasha
