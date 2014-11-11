Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752745AbaKKL21 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 06:28:27 -0500
Received: from mga11.intel.com ([192.55.52.93]:2304 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752638AbaKKL2X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 06:28:23 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="414765998"
From: Alexander Shishkin <alexander.shishkin@linux.intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Robert Richter <rric@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>,
        kan.liang@intel.com, adrian.hunter@intel.com,
        markus.t.metzger@intel.com, mathieu.poirier@linaro.org,
        acme@infradead.org,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>
Subject: [PATCH v6 11/14] x86: perf: Intel PT and LBR/BTS are mutually exclusive
Date: Tue, 11 Nov 2014 13:26:57 +0200
Message-Id: <1415705221-182873-12-git-send-email-alexander.shishkin@linux.intel.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1415705221-182873-1-git-send-email-alexander.shishkin@linux.intel.com>
References: <1415705221-182873-1-git-send-email-alexander.shishkin@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Intel PT cannot be used at the same time as LBR or BTS and will cause a
general protection fault if they are used together. In order to avoid
fixing up GPs in the fast path, instead we disallow creating LBR/BTS
events when PT events are present and vice versa.

Signed-off-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
---
 arch/x86/kernel/cpu/perf_event.c       | 43 ++++++++++++++++++++++++++++++++++
 arch/x86/kernel/cpu/perf_event.h       | 40 +++++++++++++++++++++++++++++++
 arch/x86/kernel/cpu/perf_event_intel.c | 26 ++++++++++----------
 3 files changed, 95 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 143e5f5dc8..1cca1ac9b6 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -259,6 +259,14 @@ static void hw_perf_event_destroy(struct perf_event *event)
 	}
 }
 
+void hw_perf_lbr_event_destroy(struct perf_event *event)
+{
+	hw_perf_event_destroy(event);
+
+	/* undo the lbr/bts event accounting */
+	x86_del_exclusive(x86_lbr_exclusive_lbr);
+}
+
 static inline int x86_pmu_initialized(void)
 {
 	return x86_pmu.handle_irq != NULL;
@@ -298,6 +306,35 @@ set_ext_hw_attr(struct hw_perf_event *hwc, struct perf_event *event)
 	return x86_pmu_extra_regs(val, event);
 }
 
+/*
+ * Check if we can create event of a certain type (that no conflicting events
+ * are present).
+ */
+int x86_add_exclusive(unsigned int what)
+{
+	int ret = -EBUSY, i;
+
+	if (atomic_inc_not_zero(&x86_pmu.lbr_exclusive[what]))
+		return 0;
+
+	mutex_lock(&pmc_reserve_mutex);
+	for (i = 0; i < ARRAY_SIZE(x86_pmu.lbr_exclusive); i++)
+		if (i != what && atomic_read(&x86_pmu.lbr_exclusive[i]))
+			goto out;
+
+	atomic_inc(&x86_pmu.lbr_exclusive[what]);
+	ret = 0;
+
+out:
+	mutex_unlock(&pmc_reserve_mutex);
+	return ret;
+}
+
+void x86_del_exclusive(unsigned int what)
+{
+	atomic_dec(&x86_pmu.lbr_exclusive[what]);
+}
+
 int x86_setup_perfctr(struct perf_event *event)
 {
 	struct perf_event_attr *attr = &event->attr;
@@ -342,6 +379,12 @@ int x86_setup_perfctr(struct perf_event *event)
 		/* BTS is currently only allowed for user-mode. */
 		if (!attr->exclude_kernel)
 			return -EOPNOTSUPP;
+
+		/* disallow bts if conflicting events are present */
+		if (x86_add_exclusive(x86_lbr_exclusive_lbr))
+			return -EBUSY;
+
+		event->destroy = hw_perf_lbr_event_destroy;
 	}
 
 	hwc->config |= config;
diff --git a/arch/x86/kernel/cpu/perf_event.h b/arch/x86/kernel/cpu/perf_event.h
index fc5eb390b3..620612d311 100644
--- a/arch/x86/kernel/cpu/perf_event.h
+++ b/arch/x86/kernel/cpu/perf_event.h
@@ -402,6 +402,12 @@ union x86_pmu_config {
 
 #define X86_CONFIG(args...) ((union x86_pmu_config){.bits = {args}}).value
 
+enum {
+	x86_lbr_exclusive_lbr,
+	x86_lbr_exclusive_pt,
+	x86_lbr_exclusive_max,
+};
+
 /*
  * struct x86_pmu - generic x86 pmu
  */
@@ -498,6 +504,11 @@ struct x86_pmu {
 	bool		lbr_double_abort;	   /* duplicated lbr aborts */
 
 	/*
+	 * Intel PT/LBR/BTS are exclusive
+	 */
+	atomic_t	lbr_exclusive[x86_lbr_exclusive_max];
+
+	/*
 	 * Extra registers for events
 	 */
 	struct extra_reg *extra_regs;
@@ -582,6 +593,12 @@ static inline int x86_pmu_rdpmc_index(int index)
 	return x86_pmu.rdpmc_index ? x86_pmu.rdpmc_index(index) : index;
 }
 
+int x86_add_exclusive(unsigned int what);
+
+void x86_del_exclusive(unsigned int what);
+
+void hw_perf_lbr_event_destroy(struct perf_event *event);
+
 int x86_setup_perfctr(struct perf_event *event);
 
 int x86_pmu_hw_config(struct perf_event *event);
@@ -668,6 +685,29 @@ static inline int amd_pmu_init(void)
 
 #ifdef CONFIG_CPU_SUP_INTEL
 
+static inline bool intel_pmu_needs_lbr_smpl(struct perf_event *event)
+{
+	/* user explicitly requested branch sampling */
+	if (has_branch_stack(event))
+		return true;
+
+	/* implicit branch sampling to correct PEBS skid */
+	if (x86_pmu.intel_cap.pebs_trap && event->attr.precise_ip > 1 &&
+	    x86_pmu.intel_cap.pebs_format < 2)
+		return true;
+
+	return false;
+}
+
+static inline bool intel_pmu_has_bts(struct perf_event *event)
+{
+	if (event->attr.config == PERF_COUNT_HW_BRANCH_INSTRUCTIONS &&
+	    !event->attr.freq && event->hw.sample_period == 1)
+		return true;
+
+	return false;
+}
+
 int intel_pmu_save_and_restart(struct perf_event *event);
 
 struct event_constraint *
diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index 944bf019b7..c64e97a1cb 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -1029,20 +1029,6 @@ static __initconst const u64 slm_hw_cache_event_ids
  },
 };
 
-static inline bool intel_pmu_needs_lbr_smpl(struct perf_event *event)
-{
-	/* user explicitly requested branch sampling */
-	if (has_branch_stack(event))
-		return true;
-
-	/* implicit branch sampling to correct PEBS skid */
-	if (x86_pmu.intel_cap.pebs_trap && event->attr.precise_ip > 1 &&
-	    x86_pmu.intel_cap.pebs_format < 2)
-		return true;
-
-	return false;
-}
-
 static void intel_pmu_disable_all(void)
 {
 	struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
@@ -1751,6 +1737,18 @@ static int intel_pmu_hw_config(struct perf_event *event)
 		ret = intel_pmu_setup_lbr_filter(event);
 		if (ret)
 			return ret;
+
+		/*
+		 * bts is set up earlier in this path, so don't account
+		 * twice
+		 */
+		if (!intel_pmu_has_bts(event)) {
+			/* disallow lbr if conflicting events are present */
+			if (x86_add_exclusive(x86_lbr_exclusive_lbr))
+				return -EBUSY;
+
+			event->destroy = hw_perf_lbr_event_destroy;
+		}
 	}
 
 	if (event->attr.type != PERF_TYPE_RAW)
-- 
2.1.1

