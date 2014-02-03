Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753050AbaBCM6q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 07:58:46 -0500
Received: from mail-we0-f176.google.com ([74.125.82.176]:34039 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752272AbaBCM4V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 07:56:21 -0500
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, acme@redhat.com, ak@linux.intel.com,
        zheng.z.yan@intel.com
Subject: [PATCH v1 05/10] perf/x86/uncore: make hrtimer timeout configurable per box
Date: Mon,  3 Feb 2014 13:55:37 +0100
Message-Id: <1391432142-18723-6-git-send-email-eranian@google.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1391432142-18723-1-git-send-email-eranian@google.com>
References: <1391432142-18723-1-git-send-email-eranian@google.com>
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
index f5549cf..433c180 100644
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

