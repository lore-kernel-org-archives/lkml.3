Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933156AbaLJUsT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 15:48:19 -0500
Received: from mx1.redhat.com ([209.132.183.28]:36222 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932462AbaLJUsS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 15:48:18 -0500
From: Jiri Olsa <jolsa@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@kernel.org>, Andi Kleen <ak@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>, Vince Weaver <vince@deater.net>,
        "Yan, Zheng" <zheng.z.yan@intel.com>, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 2/2] perf: Fix events installation during moving group
Date: Wed, 10 Dec 2014 21:23:51 +0100
Message-Id: <1418243031-20367-3-git-send-email-jolsa@kernel.org>
In-Reply-To: <1418243031-20367-1-git-send-email-jolsa@kernel.org>
References: <1418243031-20367-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We allow PMU driver to change the cpu on which the event
should be installed to. This happened in patch:
  e2d37cd213dc perf: Allow the PMU driver to choose the CPU on which to install events

This patch also forces all the group members to follow
the currently opened events cpu if the group happened
to be moved.

This and the change of event->cpu in perf_install_in_context
function introduced in:
  0cda4c023132 perf: Introduce perf_pmu_migrate_context()

forces group members to change their event->cpu,
if the currently-opened-event's PMU changed the cpu
and there is a group move.

Above behaviour causes problem for breakpoint events,
which uses event->cpu to touch cpu specific data for
breakpoints accounting. By changing event->cpu, some
breakpoints slots were wrongly accounted for given
cpu.

Vinces's perf fuzzer hit this issue and caused following
WARN on my setup:

[ 7113.758779] WARNING: CPU: 0 PID: 20214 at arch/x86/kernel/hw_breakpoint.c:119 arch_install_hw_breakpoint+0x142/0x150()
[ 7113.759262] Can't find any breakpoint slot
[ 7113.759433] Modules linked in:
[ 7113.759433] CPU: 0 PID: 20214 Comm: perf_fuzzer Not tainted 3.18.0 #31
[ 7113.759433] Hardware name: Intel Corporation Montevina platform/To be filled by O.E.M., BIOS AMVACRB1.86C.0066.B00.0805070703 05/07/2008
[ 7113.759433]  0000000000000009 ffff880050783ab8 ffffffff8157b70b 0000000000000004
[ 7113.759433]  ffff880050783b08 ffff880050783af8 ffffffff8104b771 0000000000000021
[ 7113.759433]  0000000000000004 ffff88007a60a958 000000000000a960 ffff88002ef42000
[ 7113.759433] Call Trace:
[ 7113.759433]  [<ffffffff8157b70b>] dump_stack+0x4f/0x7c
[ 7113.759433]  [<ffffffff8104b771>] warn_slowpath_common+0x81/0xa0
[ 7113.759433]  [<ffffffff8104b7d6>] warn_slowpath_fmt+0x46/0x50
[ 7113.759433]  [<ffffffff8100b262>] arch_install_hw_breakpoint+0x142/0x150
[ 7113.759433]  [<ffffffff81117e48>] hw_breakpoint_add+0x48/0x50
[ 7113.759433]  [<ffffffff81111611>] event_sched_in.isra.81+0xa1/0x270
[ 7113.759433]  [<ffffffff81111892>] group_sched_in+0xb2/0x1d0
[ 7113.759433]  [<ffffffff81111b90>] ctx_sched_in+0x1e0/0x390
[ 7113.759433]  [<ffffffff81111da4>] perf_event_sched_in+0x64/0x90
[ 7113.759433]  [<ffffffff811126a1>] __perf_install_in_context+0x121/0x1c0
[ 7113.759433]  [<ffffffff8108b975>] ? mark_held_locks+0x75/0xa0
[ 7113.759433]  [<ffffffff8110e930>] ? task_clock_event_add+0x40/0x40
[ 7113.759433]  [<ffffffff8110e983>] remote_function+0x53/0x70
[ 7113.759433]  [<ffffffff810c0d43>] generic_exec_single+0x123/0x180
[ 7113.759433]  [<ffffffff8110e930>] ? task_clock_event_add+0x40/0x40
[ 7113.759433]  [<ffffffff810c0dfa>] smp_call_function_single+0x5a/0xc0
[ 7113.759433]  [<ffffffff8108ba9d>] ? trace_hardirqs_on_caller+0xfd/0x1c0
[ 7113.759433]  [<ffffffff8110bc44>] task_function_call+0x44/0x50
[ 7113.759433]  [<ffffffff81112580>] ? perf_cpu_hrtimer_handler+0x210/0x210
[ 7113.759433]  [<ffffffff8110e77b>] perf_install_in_context+0x8b/0x110
[ 7113.759433]  [<ffffffff811161eb>] SyS_perf_event_open+0x59b/0xcc0
[ 7113.759433]  [<ffffffff811361d5>] ? vm_mmap_pgoff+0x75/0xa0
[ 7113.759433]  [<ffffffff81584162>] tracesys_phase2+0xd4/0xd9
[ 7113.759433] ---[ end trace 1a0d82aa412e33cf ]---

This patch changes the group moving code to keep events
original cpus.

Reported-by: Vince Weaver <vince@deater.net>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Vince Weaver <vince@deater.net>
Cc: Yan, Zheng <zheng.z.yan@intel.com>
Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 kernel/events/core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 3e19d3ebc29c..af0a5ba4e21d 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -7477,11 +7477,11 @@ SYSCALL_DEFINE5(perf_event_open,
 
 	if (move_group) {
 		synchronize_rcu();
-		perf_install_in_context(ctx, group_leader, event->cpu);
+		perf_install_in_context(ctx, group_leader, group_leader->cpu);
 		get_ctx(ctx);
 		list_for_each_entry(sibling, &group_leader->sibling_list,
 				    group_entry) {
-			perf_install_in_context(ctx, sibling, event->cpu);
+			perf_install_in_context(ctx, sibling, sibling->cpu);
 			get_ctx(ctx);
 		}
 	}
-- 
1.9.3

