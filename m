Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755189AbaF3Ivh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 04:51:37 -0400
Received: from mga02.intel.com ([134.134.136.20]:53494 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755150AbaF3Ivf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 04:51:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,573,1400050800"; 
   d="scan'208";a="536451165"
From: "Yan, Zheng" <zheng.z.yan@intel.com>
To: linux-kernel@vger.kernel.org
Cc: a.p.zijlstra@chello.nl, mingo@kernel.org, acme@infradead.org,
        eranian@google.com, andi@firstfloor.org,
        "Yan, Zheng" <zheng.z.yan@intel.com>
Subject: [PATCH V4 15/16] perf, x86: disable FREEZE_LBRS_ON_PMI when LBR operates in callstack mode
Date: Mon, 30 Jun 2014 16:50:52 +0800
Message-Id: <1404118253-19532-16-git-send-email-zheng.z.yan@intel.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1404118253-19532-1-git-send-email-zheng.z.yan@intel.com>
References: <1404118253-19532-1-git-send-email-zheng.z.yan@intel.com>
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
 arch/x86/kernel/cpu/perf_event_intel_lbr.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_lbr.c b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
index f059b98..dd14f67 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_lbr.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
@@ -138,7 +138,14 @@ static void __intel_pmu_lbr_enable(void)
 		wrmsrl(MSR_LBR_SELECT, cpuc->lbr_sel->config);
 
 	rdmsrl(MSR_IA32_DEBUGCTLMSR, debugctl);
-	debugctl |= (DEBUGCTLMSR_LBR | DEBUGCTLMSR_FREEZE_LBRS_ON_PMI);
+	debugctl |= DEBUGCTLMSR_LBR;
+	/*
+	 * LBR callstack does not work well with FREEZE_LBRS_ON_PMI.
+	 * If FREEZE_LBRS_ON_PMI is set, PMI near call/return instructions
+	 * may cause superfluous increase/decrease of LBR_TOS.
+	 */
+	if (!cpuc->lbr_sel || !(cpuc->lbr_sel->config & LBR_CALL_STACK))
+		debugctl |= DEBUGCTLMSR_FREEZE_LBRS_ON_PMI;
 	wrmsrl(MSR_IA32_DEBUGCTLMSR, debugctl);
 }
 
-- 
1.9.0

