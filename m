Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754767AbaGCCFF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 22:05:05 -0400
Received: from mga09.intel.com ([134.134.136.24]:51127 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750828AbaGCCER (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 22:04:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,592,1400050800"; 
   d="scan'208";a="567593303"
From: kan.liang@intel.com
To: peterz@infradead.org
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, andi@firstfloor.org,
        Kan Liang <kan.liang@intel.com>
Subject: [PATCH V2 2/3] perf protect LBR when Intel PT is enabled.
Date: Wed,  2 Jul 2014 11:14:14 -0700
Message-Id: <1404324855-15166-2-git-send-email-kan.liang@intel.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1404324855-15166-1-git-send-email-kan.liang@intel.com>
References: <1404324855-15166-1-git-send-email-kan.liang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kan Liang <kan.liang@intel.com>

If RTIT_CTL.TraceEn=1, any attempt to read or write the LBR or LER MSRs, including LBR_TOS, will result in a #GP.
Since Intel PT can be enabled/disabled at runtime, LBR MSRs have to be protected by _safe() at runtime.

Signed-off-by: Kan Liang <kan.liang@intel.com>
---
 arch/x86/kernel/cpu/perf_event.h           |  1 -
 arch/x86/kernel/cpu/perf_event_intel.c     |  3 ---
 arch/x86/kernel/cpu/perf_event_intel_lbr.c | 38 +++++++++++++++++-------------
 3 files changed, 21 insertions(+), 21 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.h b/arch/x86/kernel/cpu/perf_event.h
index 5d977b2..fafb809 100644
--- a/arch/x86/kernel/cpu/perf_event.h
+++ b/arch/x86/kernel/cpu/perf_event.h
@@ -458,7 +458,6 @@ struct x86_pmu {
 	u64		lbr_sel_mask;		   /* LBR_SELECT valid bits */
 	const int	*lbr_sel_map;		   /* lbr_select mappings */
 	bool		lbr_double_abort;	   /* duplicated lbr aborts */
-	bool		lbr_msr_access;		   /* LBR MSR can be accessed */
 	/*
 	 * Extra registers for events
 	 */
diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index 8011d42..ddd3590 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -2565,9 +2565,6 @@ __init int intel_pmu_init(void)
 		}
 	}
 
-	/* Access LBR MSR may cause #GP under certain circumstances. E.g. KVM doesn't support LBR MSR */
-	if (x86_pmu.lbr_nr)
-		x86_pmu.lbr_msr_access = test_msr_access(x86_pmu.lbr_tos) & test_msr_access(x86_pmu.lbr_from);
 	/* Access extra MSR may cause #GP under certain circumstances. E.g. KVM doesn't support offcore event */
 	if (x86_pmu.extra_regs)
 		x86_pmu.extra_msr_access = test_msr_access(x86_pmu.extra_regs->msr);
diff --git a/arch/x86/kernel/cpu/perf_event_intel_lbr.c b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
index 9508d1e..980b8dc 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_lbr.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
@@ -157,7 +157,7 @@ static void intel_pmu_lbr_reset_32(void)
 	int i;
 
 	for (i = 0; i < x86_pmu.lbr_nr; i++)
-		wrmsrl(x86_pmu.lbr_from + i, 0);
+		wrmsrl_safe(x86_pmu.lbr_from + i, 0ULL);
 }
 
 static void intel_pmu_lbr_reset_64(void)
@@ -165,14 +165,14 @@ static void intel_pmu_lbr_reset_64(void)
 	int i;
 
 	for (i = 0; i < x86_pmu.lbr_nr; i++) {
-		wrmsrl(x86_pmu.lbr_from + i, 0);
-		wrmsrl(x86_pmu.lbr_to   + i, 0);
+		wrmsrl_safe(x86_pmu.lbr_from + i, 0ULL);
+		wrmsrl_safe(x86_pmu.lbr_to   + i, 0ULL);
 	}
 }
 
 void intel_pmu_lbr_reset(void)
 {
-	if (!x86_pmu.lbr_nr  || !x86_pmu.lbr_msr_access)
+	if (!x86_pmu.lbr_nr)
 		return;
 
 	if (x86_pmu.intel_cap.lbr_format == LBR_FORMAT_32)
@@ -237,19 +237,14 @@ void intel_pmu_lbr_disable_all(void)
 /*
  * TOS = most recently recorded branch
  */
-static inline u64 intel_pmu_lbr_tos(void)
+static inline int intel_pmu_lbr_tos(u64 *tos)
 {
-	u64 tos;
-
-	rdmsrl(x86_pmu.lbr_tos, tos);
-
-	return tos;
+	return rdmsrl_safe(x86_pmu.lbr_tos, tos);
 }
 
-static void intel_pmu_lbr_read_32(struct cpu_hw_events *cpuc)
+static void intel_pmu_lbr_read_32(struct cpu_hw_events *cpuc, u64 tos)
 {
 	unsigned long mask = x86_pmu.lbr_nr - 1;
-	u64 tos = intel_pmu_lbr_tos();
 	int i;
 
 	for (i = 0; i < x86_pmu.lbr_nr; i++) {
@@ -278,11 +273,10 @@ static void intel_pmu_lbr_read_32(struct cpu_hw_events *cpuc)
  * is the same as the linear address, allowing us to merge the LIP and EIP
  * LBR formats.
  */
-static void intel_pmu_lbr_read_64(struct cpu_hw_events *cpuc)
+static void intel_pmu_lbr_read_64(struct cpu_hw_events *cpuc, u64 tos)
 {
 	unsigned long mask = x86_pmu.lbr_nr - 1;
 	int lbr_format = x86_pmu.intel_cap.lbr_format;
-	u64 tos = intel_pmu_lbr_tos();
 	int i;
 	int out = 0;
 
@@ -333,14 +327,24 @@ static void intel_pmu_lbr_read_64(struct cpu_hw_events *cpuc)
 void intel_pmu_lbr_read(void)
 {
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+	u64 tos;
 
-	if (!cpuc->lbr_users || !x86_pmu.lbr_msr_access)
+	if (!cpuc->lbr_users)
+		return;
+
+	/*
+	 * If KVM doesn't support LBR MSRs or Intel PT is enabled,
+	 * accessing LBR MSRs cause GP#.
+	 * Since Intel PT can be enabled/disabled at runtime,
+	 * checking the LBR MSRs access right here.
+	 */
+	if (intel_pmu_lbr_tos(&tos) < 0)
 		return;
 
 	if (x86_pmu.intel_cap.lbr_format == LBR_FORMAT_32)
-		intel_pmu_lbr_read_32(cpuc);
+		intel_pmu_lbr_read_32(cpuc, tos);
 	else
-		intel_pmu_lbr_read_64(cpuc);
+		intel_pmu_lbr_read_64(cpuc, tos);
 
 	intel_pmu_lbr_filter(cpuc);
 }
-- 
1.8.3.1

