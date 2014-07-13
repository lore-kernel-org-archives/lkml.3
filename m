Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751464AbaGMXqt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2014 19:46:49 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:22703 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750791AbaGMXqm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2014 19:46:42 -0400
Message-ID: <53C31A34.8030500@oracle.com>
Date: Sun, 13 Jul 2014 19:45:56 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>,
        Andrey Ryabinin <a.ryabinin@samsung.com>
Subject: Re: sched, timers: use after free in __lock_task_sighand when exiting
 a process
References: <53C2FF4D.3020606@oracle.com>
In-Reply-To: <53C2FF4D.3020606@oracle.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/13/2014 05:51 PM, Sasha Levin wrote:
> Hi all,
> 
> While fuzzing with trinity inside a KVM tools guest running the latest -next
> kernel with the KASAN patchset, I've stumbled on the following spew:

Alrighty, I don't think it has anything to do with timers:

[  876.319044] ==================================================================
[  876.319044] AddressSanitizer: use after free in do_raw_spin_unlock+0x4b/0x1a0 at addr ffff8803e48cec18
[  876.319044] page:ffffea000f923380 count:0 mapcount:0 mapping:          (null) index:0x0
[  876.319044] page flags: 0x2fffff80008000(tail)
[  876.319044] page dumped because: kasan error
[  876.319044] CPU: 26 PID: 8749 Comm: trinity-watchdo Tainted: G        W      3.16.0-rc4-next-20140711-sasha-00046-g07d3099-dirty #817
[  876.319044]  00000000000000fb 0000000000000000 ffffea000f923380 ffff8805c417fc70
[  876.319044]  ffffffff9de47068 ffff8805c417fd40 ffff8805c417fd30 ffffffff99426f5c
[  876.319044]  0000000000000010 0000000000000000 ffff8805c417fc9d 66666620000000a8
[  876.319044] Call Trace:
[  876.319044] dump_stack (lib/dump_stack.c:52)
[  876.319044] kasan_report_error (mm/kasan/report.c:98 mm/kasan/report.c:166)
[  876.319044] ? debug_smp_processor_id (lib/smp_processor_id.c:57)
[  876.319044] ? check_chain_key (kernel/locking/lockdep.c:2188)
[  876.319044] __asan_load8 (mm/kasan/kasan.c:364)
[  876.319044] ? do_raw_spin_unlock (./arch/x86/include/asm/current.h:14 kernel/locking/spinlock_debug.c:99 kernel/locking/spinlock_debug.c:158)
[  876.319044] do_raw_spin_unlock (./arch/x86/include/asm/current.h:14 kernel/locking/spinlock_debug.c:99 kernel/locking/spinlock_debug.c:158)
[  876.319044] _raw_spin_unlock (include/linux/spinlock_api_smp.h:152 kernel/locking/spinlock.c:183)
[  876.319044] __lock_task_sighand (include/linux/rcupdate.h:858 kernel/signal.c:1285)
[  876.319044] ? __lock_task_sighand (./arch/x86/include/asm/paravirt.h:814 ./arch/x86/include/asm/paravirt.h:827 kernel/signal.c:1270)
[  876.319044] do_send_sig_info (kernel/signal.c:1191)
[  876.319044] group_send_sig_info (kernel/signal.c:1304)
[  876.319044] ? group_send_sig_info (kernel/signal.c:1296)
[  876.319044] kill_pid_info (kernel/signal.c:1339)
[  876.319044] ? kill_pid_info (kernel/signal.c:1330)
[  876.319044] SYSC_kill (kernel/signal.c:1423 kernel/signal.c:2900)
[  876.319044] ? SYSC_kill (include/linux/rcupdate.h:806 kernel/signal.c:1422 kernel/signal.c:2900)
[  876.319044] ? trace_hardirqs_on_caller (kernel/locking/lockdep.c:2600)
[  876.319044] ? syscall_trace_enter (arch/x86/kernel/ptrace.c:1500 (discriminator 2))
[  876.319044] ? trace_hardirqs_on_caller (kernel/locking/lockdep.c:2600)
[  876.319044] SyS_kill (kernel/signal.c:2890)
[  876.319044] tracesys (arch/x86/kernel/entry_64.S:542)
[  876.319044] Read of size 8 by thread T8749:
[  876.319044] Memory state around the buggy address:
[  876.319044]  ffff8803e48ce980: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
[  876.319044]  ffff8803e48cea00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
[  876.319044]  ffff8803e48cea80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
[  876.319044]  ffff8803e48ceb00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
[  876.319044]  ffff8803e48ceb80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
[  876.319044] >ffff8803e48cec00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
[  876.319044]                             ^
[  876.319044]  ffff8803e48cec80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
[  876.319044]  ffff8803e48ced00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
[  876.319044]  ffff8803e48ced80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
[  876.319044]  ffff8803e48cee00: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[  876.319044]  ffff8803e48cee80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[  876.319044] ==================================================================


Thanks,
Sasha
> Sasha
> 

