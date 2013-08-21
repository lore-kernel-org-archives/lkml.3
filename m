Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753465Ab3HUXsl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 19:48:41 -0400
Received: from mga02.intel.com ([134.134.136.20]:23678 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753095Ab3HUXra (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 19:47:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,930,1367996400"; 
   d="scan'208";a="391247275"
From: Andi Kleen <andi@firstfloor.org>
To: mingo@kernel.org
Cc: peterz@infradead.org, acme@infradead.org, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 1/4] perf, x86: Avoid checkpointed counters causing excessive TSX aborts v4
Date: Wed, 21 Aug 2013 16:47:23 -0700
Message-Id: <1377128846-977-2-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1377128846-977-1-git-send-email-andi@firstfloor.org>
References: <1377128846-977-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

With checkpointed counters there can be a situation where the counter
is overflowing, aborts the transaction, is set back to a non overflowing
checkpoint, causes interupt. The interrupt doesn't see the overflow
because it has been checkpointed.  This is then a spurious PMI, typically with
a ugly NMI message.  It can also lead to excessive aborts.

Avoid this problem by:
- Using the full counter width for counting counters (earlier patch)
- Forbid sampling for checkpointed counters. It's not too useful anyways,
checkpointing is mainly for counting. The check is approximate
(to still handle KVM), but should catch the majority of cases.
- On a PMI always set back checkpointed counters to zero.

v2: Add unlikely. Add comment
v3: Allow large sampling periods with CP for KVM
v4: Use event_is_checkpointed. Use EOPNOTSUPP. (Stephane Eranian)
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/kernel/cpu/perf_event_intel.c | 39 ++++++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index a45d8d4..9218025 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -1134,6 +1134,11 @@ static void intel_pmu_enable_event(struct perf_event *event)
 	__x86_pmu_enable_event(hwc, ARCH_PERFMON_EVENTSEL_ENABLE);
 }
 
+static inline bool event_is_checkpointed(struct perf_event *event)
+{
+	return (event->hw.config & HSW_IN_TX_CHECKPOINTED) != 0;
+}
+
 /*
  * Save and restart an expired event. Called by NMI contexts,
  * so it has to be careful about preempting normal event ops:
@@ -1141,6 +1146,17 @@ static void intel_pmu_enable_event(struct perf_event *event)
 int intel_pmu_save_and_restart(struct perf_event *event)
 {
 	x86_perf_event_update(event);
+	/*
+	 * For a checkpointed counter always reset back to 0.  This
+	 * avoids a situation where the counter overflows, aborts the
+	 * transaction and is then set back to shortly before the
+	 * overflow, and overflows and aborts again.
+	 */
+	if (unlikely(event_is_checkpointed(event))) {
+		/* No race with NMIs because the counter should not be armed */
+		wrmsrl(event->hw.event_base, 0);
+		local64_set(&event->hw.prev_count, 0);
+	}
 	return x86_perf_event_set_period(event);
 }
 
@@ -1224,6 +1240,15 @@ again:
 		x86_pmu.drain_pebs(regs);
 	}
 
+	/*
+	 * To avoid spurious interrupts with perf stat always reset checkpointed
+	 * counters.
+	 *
+	 * XXX move somewhere else.
+	 */
+	if (cpuc->events[2] && event_is_checkpointed(cpuc->events[2]))
+		status |= (1ULL << 2);
+
 	for_each_set_bit(bit, (unsigned long *)&status, X86_PMC_IDX_MAX) {
 		struct perf_event *event = cpuc->events[bit];
 
@@ -1689,6 +1714,20 @@ static int hsw_hw_config(struct perf_event *event)
 	      event->attr.precise_ip > 0))
 		return -EOPNOTSUPP;
 
+	if (event_is_checkpointed(event)) {
+		/*
+		 * Sampling of checkpointed events can cause situations where
+		 * the CPU constantly aborts because of a overflow, which is
+		 * then checkpointed back and ignored. Forbid checkpointing
+		 * for sampling.
+		 *
+		 * But still allow a long sampling period, so that perf stat
+		 * from KVM works.
+		 */
+		if (event->attr.sample_period > 0 &&
+		    event->attr.sample_period < 0x7fffffff)
+			return -EOPNOTSUPP;
+	}
 	return 0;
 }
 
-- 
1.8.3.1

