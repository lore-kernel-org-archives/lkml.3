Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932152AbaE3BMk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 21:12:40 -0400
Received: from mga02.intel.com ([134.134.136.20]:5208 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932120AbaE3BMi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 21:12:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,937,1392192000"; 
   d="scan'208";a="519983922"
From: Andi Kleen <andi@firstfloor.org>
To: peterz@infradead.org
Cc: gleb@kernel.org, pbonzini@redhat.com, eranian@google.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 1/4] perf: Add PEBS virtualization enable for Silvermont
Date: Thu, 29 May 2014 18:12:04 -0700
Message-Id: <1401412327-14810-2-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1401412327-14810-1-git-send-email-andi@firstfloor.org>
References: <1401412327-14810-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

To avoid various problems (like leaking counters) the PEBS
virtualization needs white listing per CPU model. Add state to the
x86_pmu for this and enable it for Silvermont.

Silvermont is currently the only CPU where it is safe
to virtualize PEBS, as it doesn't leak PEBS event
through exits (as long as the exit MSR list disables
the counter with PEBS_ENABLE)

Also Silvermont is relatively simple to handle,
as it only has one PEBS counter.

Also export the information to (modular) KVM.

Used in followon patches.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/include/asm/perf_event.h         |  6 ++++++
 arch/x86/kernel/cpu/perf_event.h          |  1 +
 arch/x86/kernel/cpu/perf_event_intel.c    |  1 +
 arch/x86/kernel/cpu/perf_event_intel_ds.c | 20 ++++++++++++++++++++
 4 files changed, 28 insertions(+)

diff --git a/arch/x86/include/asm/perf_event.h b/arch/x86/include/asm/perf_event.h
index 8249df4..c49c7d3 100644
--- a/arch/x86/include/asm/perf_event.h
+++ b/arch/x86/include/asm/perf_event.h
@@ -250,6 +250,9 @@ struct perf_guest_switch_msr {
 extern struct perf_guest_switch_msr *perf_guest_get_msrs(int *nr);
 extern void perf_get_x86_pmu_capability(struct x86_pmu_capability *cap);
 extern void perf_check_microcode(void);
+extern unsigned long long perf_get_ds_area(void);
+extern unsigned long long perf_get_pebs_enable(void);
+extern bool perf_pebs_virtualization(void);
 #else
 static inline struct perf_guest_switch_msr *perf_guest_get_msrs(int *nr)
 {
@@ -264,6 +267,9 @@ static inline void perf_get_x86_pmu_capability(struct x86_pmu_capability *cap)
 
 static inline void perf_events_lapic_init(void)	{ }
 static inline void perf_check_microcode(void) { }
+static inline unsigned long long perf_get_ds_area(void) { return 0; }
+static inline unsigned long long perf_get_pebs_enable(void) { return 0; }
+static inline bool perf_pebs_virtualization(void) { return false; }
 #endif
 
 #if defined(CONFIG_PERF_EVENTS) && defined(CONFIG_CPU_SUP_AMD)
diff --git a/arch/x86/kernel/cpu/perf_event.h b/arch/x86/kernel/cpu/perf_event.h
index 3b2f9bd..6ab8fdd 100644
--- a/arch/x86/kernel/cpu/perf_event.h
+++ b/arch/x86/kernel/cpu/perf_event.h
@@ -449,6 +449,7 @@ struct x86_pmu {
 	struct event_constraint *pebs_constraints;
 	void		(*pebs_aliases)(struct perf_event *event);
 	int 		max_pebs_events;
+	bool		pebs_virtualization;
 
 	/*
 	 * Intel LBR
diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index aa333d9..86ccb81 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -2399,6 +2399,7 @@ __init int intel_pmu_init(void)
 		x86_pmu.pebs_constraints = intel_slm_pebs_event_constraints;
 		x86_pmu.extra_regs = intel_slm_extra_regs;
 		x86_pmu.er_flags |= ERF_HAS_RSP_1;
+		x86_pmu.pebs_virtualization = true;
 		pr_cont("Silvermont events, ");
 		break;
 
diff --git a/arch/x86/kernel/cpu/perf_event_intel_ds.c b/arch/x86/kernel/cpu/perf_event_intel_ds.c
index ae96cfa..29622a7 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_ds.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_ds.c
@@ -429,6 +429,26 @@ void reserve_ds_buffers(void)
 	put_online_cpus();
 }
 
+unsigned long long perf_get_ds_area(void)
+{
+	return (u64)__get_cpu_var(cpu_hw_events).ds;
+}
+EXPORT_SYMBOL_GPL(perf_get_ds_area);
+
+unsigned long long perf_get_pebs_enable(void)
+{
+	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+
+	return cpuc->pebs_enabled;
+}
+EXPORT_SYMBOL_GPL(perf_get_pebs_enable);
+
+bool perf_pebs_virtualization(void)
+{
+	return x86_pmu.pebs_virtualization;
+}
+EXPORT_SYMBOL_GPL(perf_pebs_virtualization);
+
 /*
  * BTS
  */
-- 
1.9.0

