Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752547AbaIJOMP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 10:12:15 -0400
Received: from mga01.intel.com ([192.55.52.88]:28748 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752453AbaIJOLa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 10:11:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,499,1406617200"; 
   d="scan'208";a="589215317"
From: kan.liang@intel.com
To: a.p.zijlstra@chello.nl, eranian@google.com
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, paulus@samba.org,
        acme@kernel.org, ak@linux.intel.com, kan.liang@intel.com,
        "Yan, Zheng" <zheng.z.yan@intel.com>
Subject: [PATCH V5 15/16] perf, x86: disable FREEZE_LBRS_ON_PMI when LBR operates in callstack mode
Date: Wed, 10 Sep 2014 10:09:12 -0400
Message-Id: <1410358153-421-16-git-send-email-kan.liang@intel.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1410358153-421-1-git-send-email-kan.liang@intel.com>
References: <1410358153-421-1-git-send-email-kan.liang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kan Liang <kan.liang@intel.com>

LBR callstack is designed for PEBS, It does not work well with
FREEZE_LBRS_ON_PMI for non PEBS event. If FREEZE_LBRS_ON_PMI is set for
non PEBS event, PMIs near call/return instructions may cause superfluous
increase/decrease of LBR_TOS.

This patch modifies __intel_pmu_lbr_enable() to not enable
FREEZE_LBRS_ON_PMI when LBR operates in callstack mode. We currently
don't use LBR callstack to capture kernel space callchain, so disabling
FREEZE_LBRS_ON_PMI should not be a problem.

Signed-off-by: Yan, Zheng <zheng.z.yan@intel.com>
---
 arch/x86/kernel/cpu/perf_event_intel_lbr.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_lbr.c b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
index 5afb21b..fd8fdfa 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_lbr.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
@@ -131,14 +131,23 @@ static void intel_pmu_lbr_filter(struct cpu_hw_events *cpuc);
 
 static void __intel_pmu_lbr_enable(void)
 {
-	u64 debugctl;
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+	u64 debugctl, lbr_select = 0;
 
-	if (cpuc->lbr_sel)
-		wrmsrl(MSR_LBR_SELECT, cpuc->lbr_sel->config);
+	if (cpuc->lbr_sel) {
+		lbr_select = cpuc->lbr_sel->config;
+		wrmsrl(MSR_LBR_SELECT, lbr_select);
+	}
 
 	rdmsrl(MSR_IA32_DEBUGCTLMSR, debugctl);
-	debugctl |= (DEBUGCTLMSR_LBR | DEBUGCTLMSR_FREEZE_LBRS_ON_PMI);
+	debugctl |= DEBUGCTLMSR_LBR;
+	/*
+	 * LBR callstack does not work well with FREEZE_LBRS_ON_PMI.
+	 * If FREEZE_LBRS_ON_PMI is set, PMI near call/return instructions
+	 * may cause superfluous increase/decrease of LBR_TOS.
+	 */
+	if (!(lbr_select & LBR_CALL_STACK))
+		debugctl |= DEBUGCTLMSR_FREEZE_LBRS_ON_PMI;
 	wrmsrl(MSR_IA32_DEBUGCTLMSR, debugctl);
 }
 
-- 
1.8.3.2

