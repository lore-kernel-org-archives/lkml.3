Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754415Ab3IMSJA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 14:09:00 -0400
Received: from mga03.intel.com ([143.182.124.21]:11233 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754308Ab3IMSI6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 14:08:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,899,1371106800"; 
   d="scan'208";a="294580030"
From: Andi Kleen <andi@firstfloor.org>
To: mingo@kernel.org
Cc: peterz@infradead.org, acme@infradead.org, linux-kernel@vger.kernel.org,
        eranian@google.com, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 2/6] perf, x86: Add Haswell specific transaction flag reporting v4
Date: Fri, 13 Sep 2013 11:08:32 -0700
Message-Id: <1379095716-4705-3-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1379095716-4705-1-git-send-email-andi@firstfloor.org>
References: <1379095716-4705-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

In the PEBS handler report the transaction flags using the new
generic transaction flags facility. Most of them come from
the "tsx_tuning" field in PEBSv2, but the abort code is derived
from the RAX register reported in the PEBS record.

v2: Fix interaction with precise-loads
v3: Mask out reserved bits. More comments.
v4: Adjust white space
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/kernel/cpu/perf_event_intel_ds.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_ds.c b/arch/x86/kernel/cpu/perf_event_intel_ds.c
index 104cbba..f798be8 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_ds.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_ds.c
@@ -207,6 +207,8 @@ union hsw_tsx_tuning {
 	u64	    value;
 };
 
+#define PEBS_HSW_TSX_FLAGS	0xff00000000
+
 void init_debug_store_on_cpu(int cpu)
 {
 	struct debug_store *ds = per_cpu(cpu_hw_events, cpu).ds;
@@ -893,6 +895,16 @@ static void __intel_pmu_pebs_event(struct perf_event *event,
 	    (x86_pmu.intel_cap.pebs_format >= 2))
 		data.weight = intel_hsw_weight(pebs);
 
+	if ((event->attr.sample_type & PERF_SAMPLE_TRANSACTION) &&
+	    x86_pmu.intel_cap.pebs_format >= 2) {
+		data.transaction =
+			(pebs->tsx_tuning & PEBS_HSW_TSX_FLAGS) >> 32;
+		/* For RTM XABORTs also log the abort code from AX */
+		if ((data.transaction & PERF_SAMPLE_TXN_TRANSACTION) &&
+		    (pebs->ax & 1))
+			data.transaction |= pebs->ax & 0xff000000;
+	}
+
 	if (has_branch_stack(event))
 		data.br_stack = &cpuc->lbr_stack;
 
-- 
1.8.3.1

