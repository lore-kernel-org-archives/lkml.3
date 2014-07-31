Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753151AbaGaRa1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 13:30:27 -0400
Received: from mga02.intel.com ([134.134.136.20]:25471 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752522AbaGaRaZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 13:30:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,773,1400050800"; 
   d="scan'208";a="551942926"
From: kan.liang@intel.com
To: peterz@infradead.org
Cc: andi@firstfloor.org, alexander.shishkin@linux.intel.com,
        linux-kernel@vger.kernel.org, Kan Liang <kan.liang@intel.com>
Subject: [PATCH 3/3] x86 perf: Protect LBR and BTS enabling
Date: Thu, 31 Jul 2014 02:41:03 -0700
Message-Id: <1406799663-18192-3-git-send-email-kan.liang@intel.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1406799663-18192-1-git-send-email-kan.liang@intel.com>
References: <1406799663-18192-1-git-send-email-kan.liang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kan Liang <kan.liang@intel.com>

If packet generation is enabled (IA32_RTIT_CTL.TraceEn = 1), any attempt to
enable LBRs, LERs, BTS, or
BTM (setting IA32_DEBUG_CTL.LBR =1 or IA32_DEBUG_CTL.TR = 1) will cause a
general-protection fault (#GP).

{rd,wr}msrl_safe can handle the exception which caused by enabling LBR/BTS

Signed-off-by: Kan Liang <kan.liang@intel.com>
---
 arch/x86/kernel/cpu/perf_event_intel_ds.c  | 4 ++--
 arch/x86/kernel/cpu/perf_event_intel_lbr.c | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_ds.c b/arch/x86/kernel/cpu/perf_event_intel_ds.c
index 980970c..c2519b0 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_ds.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_ds.c
@@ -468,7 +468,7 @@ void intel_pmu_enable_bts(u64 config)
 	if (!(config & ARCH_PERFMON_EVENTSEL_USR))
 		debugctlmsr |= DEBUGCTLMSR_BTS_OFF_USR;
 
-	update_debugctlmsr(debugctlmsr);
+	wrmsrl_safe(MSR_IA32_DEBUGCTLMSR, debugctlmsr);
 }
 
 void intel_pmu_disable_bts(void)
@@ -485,7 +485,7 @@ void intel_pmu_disable_bts(void)
 		~(DEBUGCTLMSR_TR | DEBUGCTLMSR_BTS | DEBUGCTLMSR_BTINT |
 		  DEBUGCTLMSR_BTS_OFF_OS | DEBUGCTLMSR_BTS_OFF_USR);
 
-	update_debugctlmsr(debugctlmsr);
+	wrmsrl_safe(MSR_IA32_DEBUGCTLMSR, debugctlmsr);
 }
 
 int intel_pmu_drain_bts_buffer(void)
diff --git a/arch/x86/kernel/cpu/perf_event_intel_lbr.c b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
index ec82e0e..688ac83 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_lbr.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
@@ -140,7 +140,7 @@ static void __intel_pmu_lbr_enable(void)
 
 	rdmsrl(MSR_IA32_DEBUGCTLMSR, debugctl);
 	debugctl |= (DEBUGCTLMSR_LBR | DEBUGCTLMSR_FREEZE_LBRS_ON_PMI);
-	wrmsrl(MSR_IA32_DEBUGCTLMSR, debugctl);
+	wrmsrl_safe(MSR_IA32_DEBUGCTLMSR, debugctl);
 }
 
 static void __intel_pmu_lbr_disable(void)
@@ -149,7 +149,7 @@ static void __intel_pmu_lbr_disable(void)
 
 	rdmsrl(MSR_IA32_DEBUGCTLMSR, debugctl);
 	debugctl &= ~(DEBUGCTLMSR_LBR | DEBUGCTLMSR_FREEZE_LBRS_ON_PMI);
-	wrmsrl(MSR_IA32_DEBUGCTLMSR, debugctl);
+	wrmsrl_safe(MSR_IA32_DEBUGCTLMSR, debugctl);
 }
 
 static void intel_pmu_lbr_reset_32(void)
-- 
1.8.3.1

