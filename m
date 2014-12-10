Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933161AbaLJUYw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 15:24:52 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34789 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932787AbaLJUYe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 15:24:34 -0500
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
Subject: [PATCH 1/2] perf/x86/intel/uncore: Make sure only uncore events are collected
Date: Wed, 10 Dec 2014 21:23:50 +0100
Message-Id: <1418243031-20367-2-git-send-email-jolsa@kernel.org>
In-Reply-To: <1418243031-20367-1-git-send-email-jolsa@kernel.org>
References: <1418243031-20367-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The uncore_collect_events functions assumes that event group
might contain only uncore events which is wrong, because it
might contain any type of events.

This bug leads to uncore framework touching 'not' uncore events,
which could end up all sorts of bugs.

One was triggered by Vince's perf fuzzer, when the uncore code
touched breakpoint event private event space as if it was uncore
event and caused BUG:

---
[ 4696.010643] BUG: unable to handle kernel paging request at ffffffff82822068
[ 4696.018433] IP: [<ffffffff81020338>] uncore_assign_events+0x188/0x250
[ 4696.025633] PGD 1812067 PUD 1813063 PMD 0
[ 4696.030228] Oops: 0000 [#1] SMP
[ 4696.033844] Modules linked in: igb ptp ioatdma pps_core i2c_algo_bit i2c_core x86_pkg_temp_thermal crc32c_intel dca microcode lpc_ich mfd_core megaraid_sas
[ 4696.049503] CPU: 1 PID: 9199 Comm: perf_fuzzer Not tainted 3.18.0fuzzer #117
[ 4696.057368] Hardware name: IBM System x3650 M4 : -[7915E2G]-/00Y7683, BIOS -[VVE124AUS-1.30]- 11/21/2012
[ 4696.067947] task: ffff88026be9da00 ti: ffff88026b9b0000 task.ti: ffff88026b9b0000
[ 4696.076295] RIP: 0010:[<ffffffff81020338>]  [<ffffffff81020338>] uncore_assign_events+0x188/0x250
[ 4696.086207] RSP: 0018:ffff88026b9b3d48  EFLAGS: 00010246
[ 4696.092133] RAX: 0000000000000000 RBX: ffff88007a3eda00 RCX: ffffffff81821fa0
[ 4696.100095] RDX: ffff8802719a1000 RSI: 0000000008000446 RDI: 0000000000000000
[ 4696.108057] RBP: ffff88026b9b3db8 R08: ffffffff81821fe0 R09: ffff880277803600
[ 4696.116018] R10: ffffffff81821fa0 R11: ffffffff81020429 R12: ffff88007a3eda10
[ 4696.123980] R13: 0000000000000004 R14: 0000000000000000 R15: 0000000000000004
[ 4696.131942] FS:  00007ff960a2d740(0000) GS:ffff880277c20000(0000) knlGS:0000000000000000
[ 4696.140971] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 4696.147380] CR2: ffffffff82822068 CR3: 0000000273ef0000 CR4: 00000000000407e0
[ 4696.155341] DR0: 000000003af8b4b4 DR1: 0000000000000000 DR2: 0000000000000000
[ 4696.163302] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000600
[ 4696.171264] Stack:
[ 4696.173505]  ffff88026ca5e000 0000000200000000 ffff88007a3eda10 0000000000000001
[ 4696.181797]  ffff88026b9b3d98 ffff88026ca5e000 ffff88007a3eda00 0000000000000000
[ 4696.190089]  0000000000000000 ffff88026ca5e000 ffff880473280100 ffff88007a3eda00
[ 4696.198381] Call Trace:
[ 4696.201109]  [<ffffffff81020c4c>] uncore_pmu_event_init+0x1cc/0x260
[ 4696.208104]  [<ffffffff81109053>] perf_init_event+0x93/0x130
[ 4696.214419]  [<ffffffff81109488>] perf_event_alloc+0x398/0x440
[ 4696.220928]  [<ffffffff811098f1>] SYSC_perf_event_open+0x3c1/0xbb0
[ 4696.227825]  [<ffffffff8110a539>] SyS_perf_event_open+0x9/0x10
[ 4696.234335]  [<ffffffff8154d712>] system_call_fastpath+0x12/0x17
---

The code in uncore_assign_events fucntion was looking for event->hw.idx
data while the event was initialized as a breakpoint with different members
in event->hw union.

This patch forces uncore_collect_events to collect only uncore events.

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
 arch/x86/kernel/cpu/perf_event_intel_uncore.c | 22 +++++++++++++++++++---
 1 file changed, 19 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.c b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
index 9762dbd9f3f7..e98f68cfea02 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_uncore.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
@@ -276,6 +276,17 @@ static struct intel_uncore_box *uncore_alloc_box(struct intel_uncore_type *type,
 	return box;
 }
 
+/*
+ * Using uncore_pmu_event_init pmu event_init callback
+ * as a detection point for uncore events.
+ */
+static int uncore_pmu_event_init(struct perf_event *event);
+
+static bool is_uncore_event(struct perf_event *event)
+{
+	return event->pmu->event_init == uncore_pmu_event_init;
+}
+
 static int
 uncore_collect_events(struct intel_uncore_box *box, struct perf_event *leader, bool dogrp)
 {
@@ -290,13 +301,18 @@ uncore_collect_events(struct intel_uncore_box *box, struct perf_event *leader, b
 		return -EINVAL;
 
 	n = box->n_events;
-	box->event_list[n] = leader;
-	n++;
+
+	if (is_uncore_event(leader)) {
+		box->event_list[n] = leader;
+		n++;
+	}
+
 	if (!dogrp)
 		return n;
 
 	list_for_each_entry(event, &leader->sibling_list, group_entry) {
-		if (event->state <= PERF_EVENT_STATE_OFF)
+		if (!is_uncore_event(event) ||
+		    event->state <= PERF_EVENT_STATE_OFF)
 			continue;
 
 		if (n >= max_count)
-- 
1.9.3

