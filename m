Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754055AbaGaRb7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 13:31:59 -0400
Received: from mga02.intel.com ([134.134.136.20]:25471 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751999AbaGaRaX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 13:30:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,773,1400050800"; 
   d="scan'208";a="551942875"
From: kan.liang@intel.com
To: peterz@infradead.org
Cc: andi@firstfloor.org, alexander.shishkin@linux.intel.com,
        linux-kernel@vger.kernel.org, Kan Liang <kan.liang@intel.com>
Subject: [PATCH 2/3] x86 perf: Protect LBR msrs accessing against potential #GP
Date: Thu, 31 Jul 2014 02:41:02 -0700
Message-Id: <1406799663-18192-2-git-send-email-kan.liang@intel.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1406799663-18192-1-git-send-email-kan.liang@intel.com>
References: <1406799663-18192-1-git-send-email-kan.liang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kan Liang <kan.liang@intel.com>

Intel PT will take over LBR hardware. If RTIT_CTL.TraceEn=1, any attempt to
read or write the LBR or LER MSRs, including LBR_TOS, will result in a #GP.
Intel PT can be enabled/disabled at runtime by hardware/BIOS, so it's better
LBR MSRs can be protected at runtime.

The {rd,wr}msrl_goto can protect LBR accessing against the potential #GP.
Furthermore, it will not impact the "fast" path's performance.

Signed-off-by: Kan Liang <kan.liang@intel.com>
---
 arch/x86/kernel/cpu/perf_event_intel_lbr.c | 35 ++++++++++++++++++++++++------
 1 file changed, 28 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_lbr.c b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
index 9dd2459..ec82e0e 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_lbr.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
@@ -157,7 +157,11 @@ static void intel_pmu_lbr_reset_32(void)
 	int i;
 
 	for (i = 0; i < x86_pmu.lbr_nr; i++)
-		wrmsrl(x86_pmu.lbr_from + i, 0);
+		wrmsrl_goto(x86_pmu.lbr_from + i, 0ULL, wrmsr_fail);
+	return;
+
+wrmsr_fail:
+	; /* TODO: error path, but do nothing currently. */
 }
 
 static void intel_pmu_lbr_reset_64(void)
@@ -165,9 +169,13 @@ static void intel_pmu_lbr_reset_64(void)
 	int i;
 
 	for (i = 0; i < x86_pmu.lbr_nr; i++) {
-		wrmsrl(x86_pmu.lbr_from + i, 0);
-		wrmsrl(x86_pmu.lbr_to   + i, 0);
+		wrmsrl_goto(x86_pmu.lbr_from + i, 0ULL, wrmsr_fail);
+		wrmsrl_goto(x86_pmu.lbr_to   + i, 0ULL, wrmsr_fail);
 	}
+	return;
+
+wrmsr_fail:
+	; /* TODO: error path, but do nothing currently. */
 }
 
 void intel_pmu_lbr_reset(void)
@@ -241,9 +249,13 @@ static inline u64 intel_pmu_lbr_tos(void)
 {
 	u64 tos;
 
-	rdmsrl(x86_pmu.lbr_tos, tos);
+	rdmsrl_goto(x86_pmu.lbr_tos, tos, rdmsr_fail);
 
 	return tos;
+
+rdmsr_fail:
+	/* TODO: error path, but do nothing currently. */
+	return 0;
 }
 
 static void intel_pmu_lbr_read_32(struct cpu_hw_events *cpuc)
@@ -262,7 +274,8 @@ static void intel_pmu_lbr_read_32(struct cpu_hw_events *cpuc)
 			u64     lbr;
 		} msr_lastbranch;
 
-		rdmsrl(x86_pmu.lbr_from + lbr_idx, msr_lastbranch.lbr);
+		rdmsrl_goto(x86_pmu.lbr_from + lbr_idx,
+				msr_lastbranch.lbr, rdmsr_fail);
 
 		cpuc->lbr_entries[i].from	= msr_lastbranch.from;
 		cpuc->lbr_entries[i].to		= msr_lastbranch.to;
@@ -271,6 +284,10 @@ static void intel_pmu_lbr_read_32(struct cpu_hw_events *cpuc)
 		cpuc->lbr_entries[i].reserved	= 0;
 	}
 	cpuc->lbr_stack.nr = i;
+	return;
+
+rdmsr_fail:
+	; /* TODO: error path, but do nothing currently. */
 }
 
 /*
@@ -292,8 +309,8 @@ static void intel_pmu_lbr_read_64(struct cpu_hw_events *cpuc)
 		int skip = 0;
 		int lbr_flags = lbr_desc[lbr_format];
 
-		rdmsrl(x86_pmu.lbr_from + lbr_idx, from);
-		rdmsrl(x86_pmu.lbr_to   + lbr_idx, to);
+		rdmsrl_goto(x86_pmu.lbr_from + lbr_idx, from, rdmsr_fail);
+		rdmsrl_goto(x86_pmu.lbr_to   + lbr_idx, to, rdmsr_fail);
 
 		if (lbr_flags & LBR_EIP_FLAGS) {
 			mis = !!(from & LBR_FROM_FLAG_MISPRED);
@@ -328,6 +345,10 @@ static void intel_pmu_lbr_read_64(struct cpu_hw_events *cpuc)
 		out++;
 	}
 	cpuc->lbr_stack.nr = out;
+	return;
+
+rdmsr_fail:
+	; /* TODO: error path, but do nothing currently. */
 }
 
 void intel_pmu_lbr_read(void)
-- 
1.8.3.1

