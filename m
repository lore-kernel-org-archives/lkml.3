Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752767AbaHKFcf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 01:32:35 -0400
Received: from mga02.intel.com ([134.134.136.20]:49413 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752712AbaHKFcc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 01:32:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,839,1400050800"; 
   d="scan'208";a="556698817"
From: Alexander Shishkin <alexander.shishkin@linux.intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Robert Richter <rric@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>,
        kan.liang@intel.com,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>
Subject: [PATCH v3 14/23] x86: perf: Intel PT and LBR/BTS are mutually exclusive
Date: Mon, 11 Aug 2014 08:19:43 +0300
Message-Id: <1407734392-31097-15-git-send-email-alexander.shishkin@linux.intel.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1407734392-31097-1-git-send-email-alexander.shishkin@linux.intel.com>
References: <1407734392-31097-1-git-send-email-alexander.shishkin@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Intel PT cannot be used at the same time as LBR or BTS and will cause a
general protection fault if they are used together. In order to avoid
fixing up GPs in the fast path, instead we use flags to indicate that
that one of these is in use so that the other avoids MSR access altogether.

Signed-off-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
---
 arch/x86/kernel/cpu/perf_event.h           | 6 ++++++
 arch/x86/kernel/cpu/perf_event_intel_ds.c  | 8 +++++++-
 arch/x86/kernel/cpu/perf_event_intel_lbr.c | 9 +++++----
 3 files changed, 18 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.h b/arch/x86/kernel/cpu/perf_event.h
index 8ade93111e..da07b41496 100644
--- a/arch/x86/kernel/cpu/perf_event.h
+++ b/arch/x86/kernel/cpu/perf_event.h
@@ -146,6 +146,7 @@ struct cpu_hw_events {
 	 * Intel DebugStore bits
 	 */
 	struct debug_store	*ds;
+	unsigned int		bts_enabled;
 	u64			pebs_enabled;
 
 	/*
@@ -159,6 +160,11 @@ struct cpu_hw_events {
 	u64				br_sel;
 
 	/*
+	 * Intel Processor Trace
+	 */
+	unsigned int			pt_enabled;
+
+	/*
 	 * Intel host/guest exclude bits
 	 */
 	u64				intel_ctrl_guest_mask;
diff --git a/arch/x86/kernel/cpu/perf_event_intel_ds.c b/arch/x86/kernel/cpu/perf_event_intel_ds.c
index 696ade311d..b8a7f9315f 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_ds.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_ds.c
@@ -456,8 +456,13 @@ struct event_constraint bts_constraint =
 
 void intel_pmu_enable_bts(u64 config)
 {
+	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
 	unsigned long debugctlmsr;
 
+	if (cpuc->pt_enabled)
+		return;
+
+	cpuc->bts_enabled = 1;
 	debugctlmsr = get_debugctlmsr();
 
 	debugctlmsr |= DEBUGCTLMSR_TR;
@@ -478,9 +483,10 @@ void intel_pmu_disable_bts(void)
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
 	unsigned long debugctlmsr;
 
-	if (!cpuc->ds)
+	if (!cpuc->ds || cpuc->pt_enabled)
 		return;
 
+	cpuc->bts_enabled = 0;
 	debugctlmsr = get_debugctlmsr();
 
 	debugctlmsr &=
diff --git a/arch/x86/kernel/cpu/perf_event_intel_lbr.c b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
index 9dd2459a4c..516e52d0ac 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_lbr.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
@@ -172,7 +172,9 @@ static void intel_pmu_lbr_reset_64(void)
 
 void intel_pmu_lbr_reset(void)
 {
-	if (!x86_pmu.lbr_nr)
+	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+
+	if (!x86_pmu.lbr_nr || cpuc->pt_enabled)
 		return;
 
 	if (x86_pmu.intel_cap.lbr_format == LBR_FORMAT_32)
@@ -185,7 +187,7 @@ void intel_pmu_lbr_enable(struct perf_event *event)
 {
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
 
-	if (!x86_pmu.lbr_nr)
+	if (!x86_pmu.lbr_nr || cpuc->pt_enabled)
 		return;
 
 	/*
@@ -205,11 +207,10 @@ void intel_pmu_lbr_disable(struct perf_event *event)
 {
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
 
-	if (!x86_pmu.lbr_nr)
+	if (!x86_pmu.lbr_nr || !cpuc->lbr_users || cpuc->pt_enabled)
 		return;
 
 	cpuc->lbr_users--;
-	WARN_ON_ONCE(cpuc->lbr_users < 0);
 
 	if (cpuc->enabled && !cpuc->lbr_users) {
 		__intel_pmu_lbr_disable();
-- 
2.1.0.rc1

