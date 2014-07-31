Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932233AbaGaGqa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 02:46:30 -0400
Received: from mga11.intel.com ([192.55.52.93]:8726 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754612AbaGaGpR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 02:45:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,770,1400050800"; 
   d="scan'208";a="578059859"
From: "Yan, Zheng" <zheng.z.yan@intel.com>
To: linux-kernel@vger.kernel.org
Cc: a.p.zijlstra@chello.nl, mingo@kernel.org, acme@infradead.org,
        eranian@google.com, andi@firstfloor.org,
        "Yan, Zheng" <zheng.z.yan@intel.com>
Subject: [PATCH v4 6/9] perf, x86: handle multiple records in PEBS buffer
Date: Thu, 31 Jul 2014 14:45:01 +0800
Message-Id: <1406789104-25863-7-git-send-email-zheng.z.yan@intel.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1406789104-25863-1-git-send-email-zheng.z.yan@intel.com>
References: <1406789104-25863-1-git-send-email-zheng.z.yan@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When PEBS interrupt threshold is larger than one, the PEBS buffer
may include mutiple records for each PEBS event. This patch makes
the code first count how many records each PEBS event has, then
output the samples in batch.

One corner case needs to mention is that the PEBS hardware doesn't
deal well with collisions, when PEBS events happen near to each
other. The records for the events can be collapsed into a single
one, and it's not possible to reconstruct all events that caused
the PEBS record, However in practice collisions are extremely rare,
as long as different events are used. The periods are typically very
large, so any collision is unlikely. When collision happens, we drop
the PEBS record.

Signed-off-by: Yan, Zheng <zheng.z.yan@intel.com>
---
 arch/x86/kernel/cpu/perf_event_intel_ds.c | 114 ++++++++++++++++++++----------
 1 file changed, 76 insertions(+), 38 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_ds.c b/arch/x86/kernel/cpu/perf_event_intel_ds.c
index 7df9092..ec7b725 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_ds.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_ds.c
@@ -991,18 +991,51 @@ static void setup_pebs_sample_data(struct perf_event *event,
 }
 
 static void __intel_pmu_pebs_event(struct perf_event *event,
-				   struct pt_regs *iregs, void *__pebs)
+				   struct pt_regs *iregs,
+				   void *at, void *top, int count)
 {
+	struct perf_output_handle handle;
+	struct perf_event_header header;
 	struct perf_sample_data data;
 	struct pt_regs regs;
 
-	if (!intel_pmu_save_and_restart(event))
+	if (!intel_pmu_save_and_restart(event) &&
+	    !(event->hw.flags & PERF_X86_EVENT_AUTO_RELOAD))
 		return;
 
-	setup_pebs_sample_data(event, iregs, __pebs, &data, &regs);
+	setup_pebs_sample_data(event, iregs, at, &data, &regs);
 
-	if (perf_event_overflow(event, &data, &regs))
+	if (perf_event_overflow(event, &data, &regs)) {
 		x86_pmu_stop(event, 0);
+		return;
+	}
+
+	if (count <= 1)
+		return;
+
+	at += x86_pmu.pebs_record_size;
+	count--;
+
+	perf_sample_data_init(&data, 0, event->hw.last_period);
+	perf_prepare_sample(&header, &data, event, &regs);
+
+	if (perf_output_begin(&handle, event, header.size * count))
+		return;
+
+	for (; at < top; at += x86_pmu.pebs_record_size) {
+		struct pebs_record_nhm *p = at;
+		if (p->status != (1 << event->hw.idx))
+			continue;
+
+		setup_pebs_sample_data(event, iregs, at, &data, &regs);
+		perf_output_sample(&handle, &header, &data, event);
+
+		count--;
+		if (count == 0)
+			break;
+	}
+
+	perf_output_end(&handle);
 }
 
 static void intel_pmu_drain_pebs_core(struct pt_regs *iregs)
@@ -1043,61 +1076,66 @@ static void intel_pmu_drain_pebs_core(struct pt_regs *iregs)
 	WARN_ONCE(n > 1, "bad leftover pebs %d\n", n);
 	at += n - 1;
 
-	__intel_pmu_pebs_event(event, iregs, at);
+	__intel_pmu_pebs_event(event, iregs, at, top, 1);
 }
 
 static void intel_pmu_drain_pebs_nhm(struct pt_regs *iregs)
 {
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
 	struct debug_store *ds = cpuc->ds;
-	struct perf_event *event = NULL;
-	void *at, *top;
-	u64 status = 0;
+	struct perf_event *event;
+	void *base, *at, *top;
 	int bit;
+	int counts[MAX_PEBS_EVENTS] = {};
 
 	if (!x86_pmu.pebs_active)
 		return;
 
-	at  = (struct pebs_record_nhm *)(unsigned long)ds->pebs_buffer_base;
+	base = (struct pebs_record_nhm *)(unsigned long)ds->pebs_buffer_base;
 	top = (struct pebs_record_nhm *)(unsigned long)ds->pebs_index;
 
 	ds->pebs_index = ds->pebs_buffer_base;
 
-	if (unlikely(at > top))
+	if (unlikely(base >= top))
 		return;
 
-	/*
-	 * Should not happen, we program the threshold at 1 and do not
-	 * set a reset value.
-	 */
-	WARN_ONCE(top - at > x86_pmu.max_pebs_events * x86_pmu.pebs_record_size,
-		  "Unexpected number of pebs records %ld\n",
-		  (long)(top - at) / x86_pmu.pebs_record_size);
-
-	for (; at < top; at += x86_pmu.pebs_record_size) {
+	for (at = base; at < top; at += x86_pmu.pebs_record_size) {
 		struct pebs_record_nhm *p = at;
 
-		for_each_set_bit(bit, (unsigned long *)&p->status,
-				 x86_pmu.max_pebs_events) {
-			event = cpuc->events[bit];
-			if (!test_bit(bit, cpuc->active_mask))
-				continue;
-
-			WARN_ON_ONCE(!event);
-
-			if (!event->attr.precise_ip)
-				continue;
-
-			if (__test_and_set_bit(bit, (unsigned long *)&status))
-				continue;
-
-			break;
-		}
-
-		if (!event || bit >= x86_pmu.max_pebs_events)
+		bit = find_first_bit((unsigned long *)&p->status,
+					 x86_pmu.max_pebs_events);
+		if (bit >= x86_pmu.max_pebs_events)
+			continue;
+		/*
+		 * The PEBS hardware does not deal well with collisions,
+		 * when the same event happens near to each other. The
+		 * records for the events can be collapsed into a single
+		 * one, and it's not possible to reconstruct all events
+		 * that caused the PEBS record. However in practice, the
+		 * collisions are extremely rara. If collision happened,
+		 * we drop the record. its the safest choice.
+		 */
+		if (p->status != (1 << bit))
 			continue;
+		if (!test_bit(bit, cpuc->active_mask))
+			continue;
+		event = cpuc->events[bit];
+		WARN_ON_ONCE(!event);
+		if (!event->attr.precise_ip)
+			continue;
+		counts[bit]++;
+	}
 
-		__intel_pmu_pebs_event(event, iregs, at);
+	for (bit = 0; bit < x86_pmu.max_pebs_events; bit++) {
+		if (counts[bit] == 0)
+			continue;
+		event = cpuc->events[bit];
+		for (at = base; at < top; at += x86_pmu.pebs_record_size) {
+			struct pebs_record_nhm *p = at;
+			if (p->status == (1 << bit))
+				break;
+		}
+		__intel_pmu_pebs_event(event, iregs, at, top, counts[bit]);
 	}
 }
 
-- 
1.9.3

