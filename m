Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752474AbaBCM4c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 07:56:32 -0500
Received: from mail-wg0-f47.google.com ([74.125.82.47]:54562 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752375AbaBCM42 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 07:56:28 -0500
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, acme@redhat.com, ak@linux.intel.com,
        zheng.z.yan@intel.com
Subject: [PATCH v1 07/10] perf/x86/uncore: allow more than one fixed counter per box
Date: Mon,  3 Feb 2014 13:55:39 +0100
Message-Id: <1391432142-18723-8-git-send-email-eranian@google.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1391432142-18723-1-git-send-email-eranian@google.com>
References: <1391432142-18723-1-git-send-email-eranian@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch modifies some of the helper functions to support
more than one fixed counter per uncore PCI PMU box.

Signed-off-by: Stephane Eranian <eranian@google.com>
---
 arch/x86/kernel/cpu/perf_event_intel_uncore.c |    4 ++--
 arch/x86/kernel/cpu/perf_event_intel_uncore.h |   22 +++++++++++++---------
 2 files changed, 15 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.c b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
index 2980994c..69a4ad0 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_uncore.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
@@ -2777,8 +2777,8 @@ static void uncore_assign_hw_event(struct intel_uncore_box *box, struct perf_eve
 	hwc->idx = idx;
 	hwc->last_tag = ++box->tags[idx];
 
-	if (hwc->idx == UNCORE_PMC_IDX_FIXED) {
-		hwc->event_base = uncore_fixed_ctr(box);
+	if (hwc->idx >= UNCORE_PMC_IDX_FIXED) {
+		hwc->event_base = uncore_fixed_ctr(box, idx);
 		hwc->config_base = uncore_fixed_ctl(box);
 		return;
 	}
diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.h b/arch/x86/kernel/cpu/perf_event_intel_uncore.h
index 433c180..c63a3ff 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_uncore.h
+++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.h
@@ -538,9 +538,18 @@ static inline unsigned uncore_pci_fixed_ctl(struct intel_uncore_box *box)
 	return box->pmu->type->fixed_ctl;
 }
 
-static inline unsigned uncore_pci_fixed_ctr(struct intel_uncore_box *box)
+static inline int uncore_fixed_ctr_bits(struct intel_uncore_box *box)
+{
+	return box->pmu->type->fixed_ctr_bits;
+}
+
+static inline unsigned uncore_pci_fixed_ctr(struct intel_uncore_box *box,
+					    int idx)
 {
-	return box->pmu->type->fixed_ctr;
+	int bits = uncore_fixed_ctr_bits(box);
+	int bytes = round_up(bits, 8);
+
+	return idx * bytes + box->pmu->type->fixed_ctr;
 }
 
 static inline
@@ -554,11 +563,6 @@ static inline int uncore_perf_ctr_bits(struct intel_uncore_box *box)
 	return box->pmu->type->perf_ctr_bits;
 }
 
-static inline int uncore_fixed_ctr_bits(struct intel_uncore_box *box)
-{
-	return box->pmu->type->fixed_ctr_bits;
-}
-
 static inline
 unsigned uncore_pci_perf_ctr(struct intel_uncore_box *box, int idx)
 {
@@ -627,10 +631,10 @@ unsigned uncore_fixed_ctl(struct intel_uncore_box *box)
 }
 
 static inline
-unsigned uncore_fixed_ctr(struct intel_uncore_box *box)
+unsigned uncore_fixed_ctr(struct intel_uncore_box *box, int idx)
 {
 	if (box->pci_dev)
-		return uncore_pci_fixed_ctr(box);
+		return uncore_pci_fixed_ctr(box, idx);
 	else
 		return uncore_msr_fixed_ctr(box);
 }
-- 
1.7.9.5

