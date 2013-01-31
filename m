Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757214Ab3AaWx4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 17:53:56 -0500
Received: from mga09.intel.com ([134.134.136.24]:5377 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757233Ab3AaWwV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 17:52:21 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,579,1355126400"; 
   d="scan'208";a="279285612"
From: Andi Kleen <andi@firstfloor.org>
To: mingo@kernel.org
Cc: linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        akpm@linux-foundation.org, acme@redhat.com, eranian@google.com,
        jolsa@redhat.com, namhyung@kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 07/12] perf, x86: Avoid checkpointed counters causing excessive TSX aborts v4
Date: Thu, 31 Jan 2013 14:51:45 -0800
Message-Id: <1359672710-19528-8-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1359672710-19528-1-git-send-email-andi@firstfloor.org>
References: <1359672710-19528-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

With checkpointed counters there can be a situation where the counter
is overflowing, aborts the transaction, is set back to a non overflowing
checkpoint, causes interupt. The interrupt doesn't see the overflow
because it has been checkpointed.  This is then a spurious PMI, typically with a
ugly NMI message.  It can also lead to excessive aborts.

Avoid this problem by:
- Using the full counter width for counting counters (previous patch)
- Forbid sampling for checkpointed counters. It's not too useful anyways,
checkpointing is mainly for counting.
- On a PMI always set back checkpointed counters to zero.

v2: Add unlikely. Add comment
v3: Allow large sampling periods with CP for KVM
v4: Use event_is_checkpointed. Use EOPNOTSUPP. (Stephane Eranian)
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/kernel/cpu/perf_event_intel.c |   39 ++++++++++++++++++++++++++++++++
 1 files changed, 39 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index 9e11295..3d915e9 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -1072,6 +1072,11 @@ static void intel_pmu_enable_event(struct perf_event *event)
 	__x86_pmu_enable_event(hwc, ARCH_PERFMON_EVENTSEL_ENABLE);
 }
 
+static inline bool event_is_checkpointed(struct perf_event *event)
+{
+	return (event->hw.config & HSW_INTX_CHECKPOINTED) != 0;
+}
+
 /*
  * Save and restart an expired event. Called by NMI contexts,
  * so it has to be careful about preempting normal event ops:
@@ -1079,6 +1084,17 @@ static void intel_pmu_enable_event(struct perf_event *event)
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
 
@@ -1162,6 +1178,15 @@ again:
 		x86_pmu.drain_pebs(regs);
 	}
 
+	/*
+ 	 * To avoid spurious interrupts with perf stat always reset checkpointed
+ 	 * counters.
+ 	 *
+	 * XXX move somewhere else.
+	 */
+	if (cpuc->events[2] && event_is_checkpointed(cpuc->events[2]))
+		status |= (1ULL << 2);
+
 	for_each_set_bit(bit, (unsigned long *)&status, X86_PMC_IDX_MAX) {
 		struct perf_event *event = cpuc->events[bit];
 
@@ -1616,6 +1641,20 @@ static int hsw_hw_config(struct perf_event *event)
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
1.7.7.6

