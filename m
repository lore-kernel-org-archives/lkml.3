Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934785AbaGPGhA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 02:37:00 -0400
Received: from mga03.intel.com ([143.182.124.21]:15204 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932821AbaGPGg7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 02:36:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,670,1400050800"; 
   d="scan'208";a="457538755"
From: Chen LinX <linx.z.chen@intel.com>
To: a.p.zijlstra@chello.nl, paulus@samba.org, mingo@redhat.com,
        acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: yanmin_zhang@linux.intel.com, yanmin.zhang@intel.com,
        "Chen LinX" <linx.z.chen@intel.com>
Subject: [PATCH V2] perf: Don't enable the perf_event without in PERF_ATTACH_CONTEXT status
Date: Wed, 16 Jul 2014 14:38:40 +0800
Message-Id: <1405492720-7112-1-git-send-email-linx.z.chen@intel.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Chen LinX" <linx.z.chen@intel.com>

	ChangeLog V2:	1) Add more description about the race;
			2) Format the email to use short lines.

When we run cpu hotplug test and below perf test at the same time,
kernel panic. pmu may access freed perf_event.

while true;
do
perf record -a -g -f sleep 10
rm perf.*
done

Basically, application(perf) starts perf by many syscalls.
1) perf_event_open => perf_install_in_context;
2) perf_ioctl
     => perf_event_enable
         => cpu_function_call(event->cpu, __perf_event_enable, event)
             =>__perf_event_enable.

After step 1), the cpu might be hot unplugged, and the event is unlinked
from the cpu context. Then, the cpu is hot plugged back. The app runs at
step 2) to enable the event on that cpu. Then, the cpu is hot unplugged
again. As the event is not linked to the cpu's context
(context->pinned_groups or context->flexible_groups list), perf_cpu_notify
can't disable the events. However, the event is linked in
cpuc->event_list[XXX]. At that time, application might free the event.
The free procedure tries to delete the event on the
pmu(in cpuc->event_list[XXX]). As the cpu is offline,
__perf_remove_from_context doesn't unlink the event from
cpuc->event_list[XXX].

When a new perf_event is scheduled in on the cpu, old freed perf_event would
be also activated. That causes kernel panic.

The patch fixes it by adding PERF_ATTACH_CONTEXT flag check before enabling
event to avoid this scenario.

[  157.666035 ] BUG: unable to handle kernel paging request at ffffffe89af56004
[  157.666166 ] IP: [<ffffffff8234218c>] do_raw_spin_lock+0xc/0x130
[  157.668086 ] Call Trace:
[  157.668122 ]  <IRQ>
[  157.668156 ]  [<ffffffff828a69aa>] _raw_spin_lock_irqsave+0x2a/0x40
[  157.668268 ]  [<ffffffff820168f0>] __intel_shared_reg_get_constraints.isra.9+0x70/0x150
[  157.668350 ]  [<ffffffff8201762e>] intel_get_event_constraints+0x8e/0x150
[  157.668424 ]  [<ffffffff82011191>] x86_schedule_events+0x81/0x200
[  157.668495 ]  [<ffffffff8201767a>] ? intel_get_event_constraints+0xda/0x150
[  157.668568 ]  [<ffffffff82011191>] ? x86_schedule_events+0x81/0x200
[  157.668640 ]  [<ffffffff82028848>] ? flat_send_IPI_mask+0x88/0xa0
[  157.668710 ]  [<ffffffff820e5628>] ? __enqueue_entity+0x78/0x80
[  157.668777 ]  [<ffffffff820e818a>] ? enqueue_task_fair+0x90a/0xdd0
[  157.668848 ]  [<ffffffff82145585>] ? tracer_tracing_is_on+0x15/0x30
[  157.668918 ]  [<ffffffff820f3b91>] ? cpuacct_charge+0x61/0x70
[  157.668984 ]  [<ffffffff82028848>] ? flat_send_IPI_mask+0x88/0xa0
[  157.669052 ]  [<ffffffff820233c5>] ? native_smp_send_reschedule+0x45/0x60
[  157.669126 ]  [<ffffffff820df199>] ? resched_task+0x69/0x70
[  157.669192 ]  [<ffffffff82145585>] ? tracer_tracing_is_on+0x15/0x30
[  157.669262 ]  [<ffffffff82161c13>] ? perf_pmu_enable+0x13/0x30
[  157.669328 ]  [<ffffffff820102ef>] ? x86_pmu_add+0xaf/0x150
[  157.669393 ]  [<ffffffff8200ffc0>] x86_pmu_commit_txn+0x50/0xa0
[  157.669462 ]  [<ffffffff82008cf4>] ? native_sched_clock+0x24/0x80
[  157.669531 ]  [<ffffffff82008cf4>] ? native_sched_clock+0x24/0x80
[  157.669598 ]  [<ffffffff820e441d>] ? sched_clock_cpu+0xbd/0x110
[  157.669664 ]  [<ffffffff820e44af>] ? local_clock+0x3f/0x50
[  157.669729 ]  [<ffffffff82161fe4>] ? perf_event_update_userpage+0xe4/0x150
[  157.669802 ]  [<ffffffff82162721>] ? event_sched_in.isra.72+0x81/0x190
[  157.669871 ]  [<ffffffff821629ca>] group_sched_in+0x19a/0x1e0
[  157.669937 ]  [<ffffffff82008cf4>] ? native_sched_clock+0x24/0x80
[  157.670006 ]  [<ffffffff82162bc8>] ctx_sched_in+0x1b8/0x1e0
[  157.670071 ]  [<ffffffff821630c2>] perf_event_sched_in+0x22/0x80
[  157.670138 ]  [<ffffffff8216321f>] __perf_install_in_context+0xff/0x170
[  157.670212 ]  [<ffffffff8215e8ab>] remote_function+0x4b/0x60
[  157.670282 ]  [<ffffffff821086bd>] generic_smp_call_function_single_interrupt+0x9d/0x120
[  157.670363 ]  [<ffffffff82339e79>] ? __const_udelay+0x29/0x30
[  157.670429 ]  [<ffffffff820236b7>] smp_call_function_single_interrupt+0x27/0x40
[  157.670504 ]  [<ffffffff828ad96f>] call_function_single_interrupt+0x6f/0x80

Change-Id: I7265d83159b9180e9be3a370ba50e067385547bd
Reviewed-by: Yanmin Zhang <yanmin.zhang@intel.com>
Signed-off-by: Chen LinX <linx.z.chen@intel.com>
---
 kernel/events/core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index e76e495..30f0095 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -1783,7 +1783,7 @@ static int __perf_event_enable(void *info)
 	 * where the task could be killed and 'ctx' deactivated
 	 * by perf_event_exit_task.
 	 */
-	if (!ctx->is_active)
+	if (!ctx->is_active || !(event->attach_state & PERF_ATTACH_CONTEXT))
 		return -EINVAL;
 
 	raw_spin_lock(&ctx->lock);
-- 
1.7.9.5

