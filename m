Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752366AbaBCM4Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 07:56:25 -0500
Received: from mail-wg0-f50.google.com ([74.125.82.50]:58915 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752241AbaBCM4Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 07:56:16 -0500
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, acme@redhat.com, ak@linux.intel.com,
        zheng.z.yan@intel.com
Subject: [PATCH v1 03/10] perf/x86/uncore: do not assume PCI fixed ctrs have more than 32 bits
Date: Mon,  3 Feb 2014 13:55:35 +0100
Message-Id: <1391432142-18723-4-git-send-email-eranian@google.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1391432142-18723-1-git-send-email-eranian@google.com>
References: <1391432142-18723-1-git-send-email-eranian@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current code assumes all PCI fixed counters implement more than
32-bit hardware counters. The actual width is then round up to 64 to
enable base + 8 * idx calculations.

Not all PMUs necessarily implement counters with more than 32-bits.
The patch makes the uncore_pci_perf_ctr() function dynamically
determine the actual bits width of a pci perf counter.

This patch paves the way for handling more than one uncore fixed
counter per PMU box.

Signed-off-by: Stephane Eranian <eranian@google.com>
---
 arch/x86/kernel/cpu/perf_event_intel_uncore.h |   31 ++++++++++++++++---------
 1 file changed, 20 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.h b/arch/x86/kernel/cpu/perf_event_intel_uncore.h
index 77dc9a5..f5549cf 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_uncore.h
+++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.h
@@ -548,10 +548,29 @@ unsigned uncore_pci_event_ctl(struct intel_uncore_box *box, int idx)
 	return idx * 4 + box->pmu->type->event_ctl;
 }
 
+static inline int uncore_perf_ctr_bits(struct intel_uncore_box *box)
+{
+	return box->pmu->type->perf_ctr_bits;
+}
+
+static inline int uncore_fixed_ctr_bits(struct intel_uncore_box *box)
+{
+	return box->pmu->type->fixed_ctr_bits;
+}
+
 static inline
 unsigned uncore_pci_perf_ctr(struct intel_uncore_box *box, int idx)
 {
-	return idx * 8 + box->pmu->type->perf_ctr;
+	int bits, bytes;
+
+	if (idx == UNCORE_PMC_IDX_FIXED)
+		bits = uncore_fixed_ctr_bits(box);
+	else
+		bits = uncore_perf_ctr_bits(box);
+
+	bytes = round_up(bits, 8);
+
+	return idx * bytes + box->pmu->type->perf_ctr;
 }
 
 static inline unsigned uncore_msr_box_offset(struct intel_uncore_box *box)
@@ -633,16 +652,6 @@ unsigned uncore_perf_ctr(struct intel_uncore_box *box, int idx)
 		return uncore_msr_perf_ctr(box, idx);
 }
 
-static inline int uncore_perf_ctr_bits(struct intel_uncore_box *box)
-{
-	return box->pmu->type->perf_ctr_bits;
-}
-
-static inline int uncore_fixed_ctr_bits(struct intel_uncore_box *box)
-{
-	return box->pmu->type->fixed_ctr_bits;
-}
-
 static inline int uncore_num_counters(struct intel_uncore_box *box)
 {
 	return box->pmu->type->num_counters;
-- 
1.7.9.5

