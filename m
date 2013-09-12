Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756777Ab3ILSJm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 14:09:42 -0400
Received: from terminus.zytor.com ([198.137.202.10]:37883 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756734Ab3ILSFY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 14:05:24 -0400
Date: Thu, 12 Sep 2013 11:04:34 -0700
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-dvb4q0rydkfp00kqat4p5bah@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        andi@firstfloor.org, peterz@infradead.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        andi@firstfloor.org, peterz@infradead.org, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf/x86/intel:
  Clean up checkpoint-interrupt bits
Git-Commit-ID: 2b9e344df384e595db24ac61ae5f780e9b024878
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 12 Sep 2013 11:04:41 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2b9e344df384e595db24ac61ae5f780e9b024878
Gitweb:     http://git.kernel.org/tip/2b9e344df384e595db24ac61ae5f780e9b024878
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Thu, 12 Sep 2013 12:53:44 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 12 Sep 2013 19:13:37 +0200

perf/x86/intel: Clean up checkpoint-interrupt bits

Clean up the weird CP interrupt exception code by keeping a CP mask.

Andi suggested this implementation but weirdly didn't actually
implement it himself, do so now because it removes the conditional in
the interrupt handler and avoids the assumption its only on cnt2.

Suggested-by: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/n/tip-dvb4q0rydkfp00kqat4p5bah@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/cpu/perf_event.h       |  5 +++++
 arch/x86/kernel/cpu/perf_event_intel.c | 22 +++++++++++++---------
 2 files changed, 18 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.h b/arch/x86/kernel/cpu/perf_event.h
index cc16faa..ce84ede 100644
--- a/arch/x86/kernel/cpu/perf_event.h
+++ b/arch/x86/kernel/cpu/perf_event.h
@@ -164,6 +164,11 @@ struct cpu_hw_events {
 	struct perf_guest_switch_msr	guest_switch_msrs[X86_PMC_IDX_MAX];
 
 	/*
+	 * Intel checkpoint mask
+	 */
+	u64				intel_cp_status;
+
+	/*
 	 * manage shared (per-core, per-cpu) registers
 	 * used on Intel NHM/WSM/SNB
 	 */
diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index dd1d4f3..ec70d0c 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -1184,6 +1184,11 @@ static void intel_pmu_disable_fixed(struct hw_perf_event *hwc)
 	wrmsrl(hwc->config_base, ctrl_val);
 }
 
+static inline bool event_is_checkpointed(struct perf_event *event)
+{
+	return (event->hw.config & HSW_IN_TX_CHECKPOINTED) != 0;
+}
+
 static void intel_pmu_disable_event(struct perf_event *event)
 {
 	struct hw_perf_event *hwc = &event->hw;
@@ -1197,6 +1202,7 @@ static void intel_pmu_disable_event(struct perf_event *event)
 
 	cpuc->intel_ctrl_guest_mask &= ~(1ull << hwc->idx);
 	cpuc->intel_ctrl_host_mask &= ~(1ull << hwc->idx);
+	cpuc->intel_cp_status &= ~(1ull << hwc->idx);
 
 	/*
 	 * must disable before any actual event
@@ -1271,6 +1277,9 @@ static void intel_pmu_enable_event(struct perf_event *event)
 	if (event->attr.exclude_guest)
 		cpuc->intel_ctrl_host_mask |= (1ull << hwc->idx);
 
+	if (unlikely(event_is_checkpointed(event)))
+		cpuc->intel_cp_status |= (1ull << hwc->idx);
+
 	if (unlikely(hwc->config_base == MSR_ARCH_PERFMON_FIXED_CTR_CTRL)) {
 		intel_pmu_enable_fixed(hwc);
 		return;
@@ -1282,11 +1291,6 @@ static void intel_pmu_enable_event(struct perf_event *event)
 	__x86_pmu_enable_event(hwc, ARCH_PERFMON_EVENTSEL_ENABLE);
 }
 
-static inline bool event_is_checkpointed(struct perf_event *event)
-{
-	return (event->hw.config & HSW_IN_TX_CHECKPOINTED) != 0;
-}
-
 /*
  * Save and restart an expired event. Called by NMI contexts,
  * so it has to be careful about preempting normal event ops:
@@ -1389,11 +1393,11 @@ again:
 	}
 
 	/*
-	 * To avoid spurious interrupts with perf stat always reset checkpointed
-	 * counters.
+	 * Checkpointed counters can lead to 'spurious' PMIs because the
+	 * rollback caused by the PMI will have cleared the overflow status
+	 * bit. Therefore always force probe these counters.
 	 */
-	if (cpuc->events[2] && event_is_checkpointed(cpuc->events[2]))
-		status |= (1ULL << 2);
+	status |= cpuc->intel_cp_status;
 
 	for_each_set_bit(bit, (unsigned long *)&status, X86_PMC_IDX_MAX) {
 		struct perf_event *event = cpuc->events[bit];
