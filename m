Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933399AbaLBWxs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 17:53:48 -0500
Received: from mail-qa0-f42.google.com ([209.85.216.42]:49253 "EHLO
	mail-qa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933086AbaLBWxr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 17:53:47 -0500
Message-ID: <547E42F7.5070105@gmail.com>
Date: Tue, 02 Dec 2014 17:53:43 -0500
From: Sasha Levin <levinsasha928@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>,
        Andrey Ryabinin <a.ryabinin@samsung.com>
Subject: sched: odd values for effective load calculations
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I was fuzzing with trinity inside a KVM tools guest, running the latest -next
kernel along with the undefined behaviour sanitizer patch, and hit the following:

[  787.894288] ================================================================================
[  787.897074] UBSan: Undefined behaviour in kernel/sched/fair.c:4541:17
[  787.898981] signed integer overflow:
[  787.900066] 361516561629678 * 101500 cannot be represented in type 'long long int'
[  787.900066] CPU: 18 PID: 12958 Comm: trinity-c103 Not tainted 3.18.0-rc6-next-20141201-sasha-00070-g028060a-dirty #1528
[  787.900066]  0000000000000000 0000000000000000 ffffffff93b0f890 ffff8806e3eff918
[  787.900066]  ffffffff91f1cf26 1ffffffff3c2de73 ffffffff93b0f8a8 ffff8806e3eff938
[  787.900066]  ffffffff91f1fb90 1ffffffff3c2de73 ffffffff93b0f8a8 ffff8806e3eff9f8
[  787.900066] Call Trace:
[  787.900066] dump_stack (lib/dump_stack.c:52)
[  787.900066] ubsan_epilogue (lib/ubsan.c:159)
[  787.900066] handle_overflow (lib/ubsan.c:191)
[  787.900066] ? __do_page_fault (arch/x86/mm/fault.c:1220)
[  787.900066] ? local_clock (kernel/sched/clock.c:392)
[  787.900066] __ubsan_handle_mul_overflow (lib/ubsan.c:218)
[  787.900066] select_task_rq_fair (kernel/sched/fair.c:4541 kernel/sched/fair.c:4755)
[  787.900066] try_to_wake_up (kernel/sched/core.c:1415 kernel/sched/core.c:1724)
[  787.900066] ? trace_hardirqs_on_thunk (arch/x86/lib/thunk_64.S:33)
[  787.900066] default_wake_function (kernel/sched/core.c:2979)
[  787.900066] ? get_parent_ip (kernel/sched/core.c:2559)
[  787.900066] autoremove_wake_function (kernel/sched/wait.c:295)
[  787.900066] ? get_parent_ip (kernel/sched/core.c:2559)
[  787.900066] __wake_up_common (kernel/sched/wait.c:73)
[  787.900066] __wake_up_sync_key (include/linux/spinlock.h:364 kernel/sched/wait.c:146)
[  787.900066] pipe_write (fs/pipe.c:466)
[  787.900066] ? kasan_poison_shadow (mm/kasan/kasan.c:48)
[  787.900066] ? new_sync_read (fs/read_write.c:480)
[  787.900066] do_iter_readv_writev (fs/read_write.c:681)
[  787.900066] compat_do_readv_writev (fs/read_write.c:1029)
[  787.900066] ? wait_for_partner (fs/pipe.c:340)
[  787.900066] ? _raw_spin_unlock (./arch/x86/include/asm/preempt.h:95 include/linux/spinlock_api_smp.h:152 kernel/locking/spinlock.c:183)
[  787.900066] ? __this_cpu_preempt_check (lib/smp_processor_id.c:63)
[  787.900066] ? syscall_trace_enter_phase1 (include/linux/context_tracking.h:27 arch/x86/kernel/ptrace.c:1486)
[  787.900066] compat_writev (fs/read_write.c:1145)
[  787.900066] compat_SyS_writev (fs/read_write.c:1163 fs/read_write.c:1151)
[  787.900066] ia32_do_call (arch/x86/ia32/ia32entry.S:446)
[  787.900066] ================================================================================

The values for effective load seem a bit off (and are overflowing!).

One change I did recently was to disable lock debugging, could it be related?


Thanks,
Sasha
