Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752153AbaBKPWI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 10:22:08 -0500
Received: from mail-wi0-f180.google.com ([209.85.212.180]:58993 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751869AbaBKPUn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 10:20:43 -0500
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, acme@redhat.com, ak@linux.intel.com,
        zheng.z.yan@intel.com
Subject: [PATCH v2 4/8] perf/x86/uncore: make hrtimer timeout configurable per box
Date: Tue, 11 Feb 2014 16:20:10 +0100
Message-Id: <1392132015-14521-5-git-send-email-eranian@google.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1392132015-14521-1-git-send-email-eranian@google.com>
References: <1392132015-14521-1-git-send-email-eranian@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes the hrtimer timeout configurable per PMU
box. Not all counters have necessarily the same width and
rate, thus the default timeout of 60s may need to be adjusted.

This patch adds box->hrtimer_duration. It is set to default
when the box is allocated. It can be overriden when the box
is initialized.

Signed-off-by: Stephane Eranian <eranian@google.com>
---
 arch/x86/kernel/cpu/perf_event_intel_uncore.c |    7 +++++--
 arch/x86/kernel/cpu/perf_event_intel_uncore.h |    1 +
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.c b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
index e6f32b3..ea823b8 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_uncore.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
@@ -2798,14 +2798,14 @@ static enum hrtimer_restart uncore_pmu_hrtimer(struct hrtimer *hrtimer)
 
 	local_irq_restore(flags);
 
-	hrtimer_forward_now(hrtimer, ns_to_ktime(UNCORE_PMU_HRTIMER_INTERVAL));
+	hrtimer_forward_now(hrtimer, ns_to_ktime(box->hrtimer_duration));
 	return HRTIMER_RESTART;
 }
 
 static void uncore_pmu_start_hrtimer(struct intel_uncore_box *box)
 {
 	__hrtimer_start_range_ns(&box->hrtimer,
-			ns_to_ktime(UNCORE_PMU_HRTIMER_INTERVAL), 0,
+			ns_to_ktime(box->hrtimer_duration), 0,
 			HRTIMER_MODE_REL_PINNED, 0);
 }
 
@@ -2839,6 +2839,9 @@ static struct intel_uncore_box *uncore_alloc_box(struct intel_uncore_type *type,
 	box->cpu = -1;
 	box->phys_id = -1;
 
+	/* set default hrtimer timeout */
+	box->hrtimer_duration = UNCORE_PMU_HRTIMER_INTERVAL;
+
 	return box;
 }
 
diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.h b/arch/x86/kernel/cpu/perf_event_intel_uncore.h
index 77dc9a5..7efd298 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_uncore.h
+++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.h
@@ -489,6 +489,7 @@ struct intel_uncore_box {
 	u64 tags[UNCORE_PMC_IDX_MAX];
 	struct pci_dev *pci_dev;
 	struct intel_uncore_pmu *pmu;
+	u64 hrtimer_duration; /* hrtimer timeout for this box */
 	struct hrtimer hrtimer;
 	struct list_head list;
 	struct intel_uncore_extra_reg shared_regs[0];
-- 
1.7.9.5

