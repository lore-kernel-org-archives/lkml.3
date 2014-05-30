Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932272AbaE3BNO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 21:13:14 -0400
Received: from mga02.intel.com ([134.134.136.20]:62494 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932121AbaE3BMj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 21:12:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,937,1392192000"; 
   d="scan'208";a="519983923"
From: Andi Kleen <andi@firstfloor.org>
To: peterz@infradead.org
Cc: gleb@kernel.org, pbonzini@redhat.com, eranian@google.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 3/4] perf: Handle guest PEBS events with a fake event
Date: Thu, 29 May 2014 18:12:06 -0700
Message-Id: <1401412327-14810-4-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1401412327-14810-1-git-send-email-andi@firstfloor.org>
References: <1401412327-14810-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

With PEBS virtualization the PEBS record gets delivered to the guest,
but the host sees the PMI. This would normally result in a spurious
PEBS PMI that is ignored. But we need to inject the PMI into the guest,
so that the guest PMI handler can handle the PEBS record.

Check for this case in the perf PEBS handler.  When any guest PEBS
counters are active always check the counters explicitely for
overflow. If a guest PEBs counter overflowed trigger a fake event. The
fake event results in calling the KVM PMI callback, which injects
the PMI into the guest. The guest handler then retrieves the correct
information from its own PEBS record and the guest state.

Note: in very rare cases with exotic events this may lead to spurious PMIs
in the guest.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/kernel/cpu/perf_event_intel_ds.c | 49 +++++++++++++++++++++++++++++++
 1 file changed, 49 insertions(+)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_ds.c b/arch/x86/kernel/cpu/perf_event_intel_ds.c
index 29622a7..0267174 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_ds.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_ds.c
@@ -998,6 +998,53 @@ static void intel_pmu_drain_pebs_core(struct pt_regs *iregs)
 	__intel_pmu_pebs_event(event, iregs, at);
 }
 
+/*
+ * We may be running with virtualized PEBS, so the PEBS record
+ * was logged into the guest's DS and is invisible to us.
+ *
+ * For guest-owned counters we always have to check the counter
+ * and see if they are overflowed, because PEBS thresholds
+ * are not reported in the GLOBAL_STATUS.
+ *
+ * In this case just trigger a fake event for KVM to forward
+ * to the guest as PMI.  The guest will then see the real PEBS
+ * record and read the counter values.
+ *
+ * The contents of the event do not matter.
+ */
+static void intel_pmu_handle_guest_pebs(struct cpu_hw_events *cpuc,
+					struct pt_regs *iregs)
+{
+	int bit;
+	struct perf_event *event;
+
+	if (!cpuc->intel_ctrl_guest_owned)
+		return;
+
+	for_each_set_bit(bit, (unsigned long *)&cpuc->intel_ctrl_guest_owned,
+			 x86_pmu.max_pebs_events) {
+		struct perf_sample_data data;
+		s64 count;
+		int shift;
+
+		event = cpuc->events[bit];
+		if (!event->attr.precise_ip)
+			continue;
+		rdpmcl(event->hw.event_base_rdpmc, count);
+
+		/* sign extend */
+		shift = 64 - x86_pmu.cntval_bits;
+		count = ((s64)((u64)count << shift)) >> shift;
+
+		if (count < 0)
+			continue;
+
+		perf_sample_data_init(&data, 0, event->hw.last_period);
+		if (perf_event_overflow(event, &data, iregs))
+			x86_pmu_stop(event, 0);
+	}
+}
+
 static void intel_pmu_drain_pebs_nhm(struct pt_regs *iregs)
 {
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
@@ -1010,6 +1057,8 @@ static void intel_pmu_drain_pebs_nhm(struct pt_regs *iregs)
 	if (!x86_pmu.pebs_active)
 		return;
 
+	intel_pmu_handle_guest_pebs(cpuc, iregs);
+
 	at  = (struct pebs_record_nhm *)(unsigned long)ds->pebs_buffer_base;
 	top = (struct pebs_record_nhm *)(unsigned long)ds->pebs_index;
 
-- 
1.9.0

