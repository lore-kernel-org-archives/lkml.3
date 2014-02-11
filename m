Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752121AbaBKPV0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 10:21:26 -0500
Received: from mail-wi0-f176.google.com ([209.85.212.176]:45969 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751403AbaBKPUx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 10:20:53 -0500
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, acme@redhat.com, ak@linux.intel.com,
        zheng.z.yan@intel.com
Subject: [PATCH v2 7/8] perf/x86/uncore: add hrtimer to SNB uncore IMC PMU
Date: Tue, 11 Feb 2014 16:20:13 +0100
Message-Id: <1392132015-14521-8-git-send-email-eranian@google.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1392132015-14521-1-git-send-email-eranian@google.com>
References: <1392132015-14521-1-git-send-email-eranian@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is needed because that PMU uses 32-bit free
running counters with no interrupt capabilities.

On SNB/IVB/HSW, we used 20GB/s theoretical peak to calculate
the hrtimer timeout necessary to avoid missing an overflow.
That delay is set to 5s to be on the cautious side.

The SNB IMC uses free running counters, which are handled
via pseudo fixed counters. The SNB IMC PMU implementation
supports an arbitrary number of events, because the counters
are read-only. Therefore it is not possible to track active
counters. Instead we put active events on a linked list which
is then used by the hrtimer handler to update the SW counts.

Signed-off-by: Stephane Eranian <eranian@google.com>
---
 arch/x86/kernel/cpu/perf_event_intel_uncore.c |   12 ++++++++++++
 arch/x86/kernel/cpu/perf_event_intel_uncore.h |    2 ++
 2 files changed, 14 insertions(+)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.c b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
index 2c7693a..20a8061 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_uncore.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
@@ -1728,6 +1728,7 @@ static void snb_uncore_imc_init_box(struct intel_uncore_box *box)
 	addr &= ~(PAGE_SIZE - 1);
 
 	box->io_addr = ioremap(addr, SNB_UNCORE_PCI_IMC_MAP_SIZE);
+	box->hrtimer_duration = UNCORE_SNB_IMC_HRTIMER_INTERVAL;
 }
 
 static void snb_uncore_imc_enable_box(struct intel_uncore_box *box)
@@ -3160,6 +3161,7 @@ static void uncore_perf_event_update(struct intel_uncore_box *box, struct perf_e
 static enum hrtimer_restart uncore_pmu_hrtimer(struct hrtimer *hrtimer)
 {
 	struct intel_uncore_box *box;
+	struct perf_event *event;
 	unsigned long flags;
 	int bit;
 
@@ -3172,6 +3174,14 @@ static enum hrtimer_restart uncore_pmu_hrtimer(struct hrtimer *hrtimer)
 	 */
 	local_irq_save(flags);
 
+	/*
+	 * handle boxes with an active event list as opposed to active
+	 * counters
+	 */
+	list_for_each_entry(event, &box->active_list, active_entry) {
+		uncore_perf_event_update(box, event);
+	}
+
 	for_each_set_bit(bit, box->active_mask, UNCORE_PMC_IDX_MAX)
 		uncore_perf_event_update(box, box->events[bit]);
 
@@ -3221,6 +3231,8 @@ static struct intel_uncore_box *uncore_alloc_box(struct intel_uncore_type *type,
 	/* set default hrtimer timeout */
 	box->hrtimer_duration = UNCORE_PMU_HRTIMER_INTERVAL;
 
+	INIT_LIST_HEAD(&box->active_list);
+
 	return box;
 }
 
diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.h b/arch/x86/kernel/cpu/perf_event_intel_uncore.h
index fbf45a0..90236f0 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_uncore.h
+++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.h
@@ -6,6 +6,7 @@
 
 #define UNCORE_PMU_NAME_LEN		32
 #define UNCORE_PMU_HRTIMER_INTERVAL	(60LL * NSEC_PER_SEC)
+#define UNCORE_SNB_IMC_HRTIMER_INTERVAL (5ULL * NSEC_PER_SEC)
 
 #define UNCORE_FIXED_EVENT		0xff
 #define UNCORE_PMC_IDX_MAX_GENERIC	8
@@ -492,6 +493,7 @@ struct intel_uncore_box {
 	u64 hrtimer_duration; /* hrtimer timeout for this box */
 	struct hrtimer hrtimer;
 	struct list_head list;
+	struct list_head active_list;
 	void *io_addr;
 	struct intel_uncore_extra_reg shared_regs[0];
 };
-- 
1.7.9.5

