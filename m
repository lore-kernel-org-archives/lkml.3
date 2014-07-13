Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752213AbaGMVwA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2014 17:52:00 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:42334 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752043AbaGMVvw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2014 17:51:52 -0400
Message-ID: <53C2FF4D.3020606@oracle.com>
Date: Sun, 13 Jul 2014 17:51:09 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>,
        Andrey Ryabinin <a.ryabinin@samsung.com>
Subject: sched, timers: use after free in __lock_task_sighand when exiting
 a process
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

While fuzzing with trinity inside a KVM tools guest running the latest -next
kernel with the KASAN patchset, I've stumbled on the following spew:

[ 4838.503887] ==================================================================
[ 4838.510906] AddressSanitizer: use after free in do_raw_spin_lock+0x157/0x240 at addr ffff8800ac3af608
[ 4838.513433] page:ffffea0002b0ebc0 count:0 mapcount:0 mapping:          (null) index:0x0
[ 4838.513433] page flags: 0x1fffff80008000(tail)
[ 4838.513433] page dumped because: kasan error
[ 4838.513433] CPU: 14 PID: 19619 Comm: trinity-c52 Tainted: G        W      3.16.0-rc4-next-20140711-sasha-00046-g07d3099-dirty #813
[ 4838.513433]  00000000000000fb 0000000000000000 ffffea0002b0ebc0 ffff8805f2e03bc8
[ 4838.513433]  ffffffff9ee47068 ffff8805f2e03c98 ffff8805f2e03c88 ffffffff9a426f5c
[ 4838.513433]  ffff8805f2fe2d80 ffff8805f2fe2d90 ffff8805f2fe2d80 ffff8805f2fe2d88
[ 4838.513433] Call Trace:
[ 4838.513433] <IRQ> dump_stack (lib/dump_stack.c:52)
[ 4838.513433] kasan_report_error (mm/kasan/report.c:98 mm/kasan/report.c:166)
[ 4838.513433] __asan_load4 (mm/kasan/kasan.c:358)
[ 4838.513433] do_raw_spin_lock (./arch/x86/include/asm/spinlock.h:108 kernel/locking/spinlock_debug.c:112 kernel/locking/spinlock_debug.c:137)
[ 4838.513433] _raw_spin_lock (include/linux/spinlock_api_smp.h:143 kernel/locking/spinlock.c:151)
[ 4838.513433] __lock_task_sighand (kernel/signal.c:1280)
[ 4838.513433] run_posix_cpu_timers (kernel/time/posix-cpu-timers.c:1162)
[ 4838.513433] update_process_times (kernel/time/timer.c:1392)
[ 4838.513433] tick_sched_timer (kernel/time/tick-sched.c:152 kernel/time/tick-sched.c:1096)
[ 4838.513433] __run_hrtimer (kernel/time/hrtimer.c:1272 (discriminator 3))
[ 4838.513433] hrtimer_interrupt (kernel/time/hrtimer.c:1361)
[ 4838.513433] local_apic_timer_interrupt (arch/x86/kernel/apic/apic.c:921)
[ 4838.513433] smp_apic_timer_interrupt (./arch/x86/include/asm/apic.h:696 arch/x86/kernel/apic/apic.c:945)
[ 4838.513433] apic_timer_interrupt (arch/x86/kernel/entry_64.S:1020)
[ 4838.513433] <EOI> ? _raw_spin_unlock_irqrestore (./arch/x86/include/asm/paravirt.h:809 include/linux/spinlock_api_smp.h:160 kernel/locking/spinlock.c:191)
[ 4838.513433] __slab_free (include/linux/spinlock.h:358 mm/slub.c:2565)
[ 4838.513433] kmem_cache_free (mm/slub.c:2704 mm/slub.c:2714)
[ 4838.513433] put_io_context (block/blk-ioc.c:154)
[ 4838.513433] put_io_context_active (block/blk-ioc.c:197)
[ 4838.513433] exit_io_context (block/blk-ioc.c:211)
[ 4838.513433] do_exit (kernel/exit.c:801)
[ 4838.513433] do_group_exit (./arch/x86/include/asm/current.h:14 kernel/exit.c:870)
[ 4838.513433] get_signal_to_deliver (kernel/signal.c:2351)
[ 4838.513433] do_signal (arch/x86/kernel/signal.c:698)
[ 4838.513433] do_notify_resume (arch/x86/kernel/signal.c:751)
[ 4838.513433] int_signal (arch/x86/kernel/entry_64.S:600)
[ 4838.513433] Read of size 4 by thread T19619:
[ 4838.513433] Memory state around the buggy address:
[ 4838.513433]  ffff8800ac3af380: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
[ 4838.513433]  ffff8800ac3af400: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
[ 4838.513433]  ffff8800ac3af480: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
[ 4838.513433]  ffff8800ac3af500: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
[ 4838.513433]  ffff8800ac3af580: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
[ 4838.513433] >ffff8800ac3af600: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
[ 4838.513433]                       ^
[ 4838.513433]  ffff8800ac3af680: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
[ 4838.513433]  ffff8800ac3af700: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
[ 4838.513433]  ffff8800ac3af780: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
[ 4838.513433]  ffff8800ac3af800: fd fd fd fd fd fd fd fd fd fd fd fd fd fd fd fd
[ 4838.513433]  ffff8800ac3af880: fd fd fd fd fd fd fd fd fd fd fd fd fd fd fd fd
[ 4838.513433] ==================================================================

It looks like a race between an exiting process and an external access to it's
'sighand'.


Thanks,
Sasha
