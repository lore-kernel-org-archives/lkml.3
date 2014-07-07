Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752197AbaGGGaN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 02:30:13 -0400
Received: from mga09.intel.com ([134.134.136.24]:11668 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752068AbaGGG30 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 02:29:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,616,1400050800"; 
   d="scan'208";a="539565662"
From: "Yan, Zheng" <zheng.z.yan@intel.com>
To: linux-kernel@vger.kernel.org
Cc: a.p.zijlstra@chello.nl, mingo@kernel.org, acme@infradead.org,
        eranian@google.com, andi@firstfloor.org,
        "Yan, Zheng" <zheng.z.yan@intel.com>
Subject: [PATCH v5 15/16] perf, x86: disable FREEZE_LBRS_ON_PMI when LBR operates in callstack mode
Date: Mon,  7 Jul 2014 14:28:46 +0800
Message-Id: <1404714527-18603-18-git-send-email-zheng.z.yan@intel.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1404714527-18603-1-git-send-email-zheng.z.yan@intel.com>
References: <1404714527-18603-1-git-send-email-zheng.z.yan@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
index 594dde2..bbbab66 100644
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
1.9.3

