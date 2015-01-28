Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759322AbbA1ACa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 19:02:30 -0500
Received: from mga11.intel.com ([192.55.52.93]:39645 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756530AbbA1ABx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 19:01:53 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,477,1418112000"; 
   d="scan'208";a="677052522"
From: Vikas Shivappa <vikas.shivappa@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: vikas.shivappa@intel.com, vikas.shivappa@linux.intel.com, hpa@zytor.com,
        tglx@linutronix.de, mingo@kernel.org, tj@kernel.org,
        peterz@infradead.org, matt.fleming@intel.com, will.auld@intel.com
Subject: [PATCH 5/6] x86/intel_rdt: Software Cache for IA32_PQR_MSR
Date: Tue, 27 Jan 2015 16:00:08 -0800
Message-Id: <1422403209-15533-6-git-send-email-vikas.shivappa@linux.intel.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422403209-15533-1-git-send-email-vikas.shivappa@linux.intel.com>
References: <1422403209-15533-1-git-send-email-vikas.shivappa@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch implements a common software cache for IA32_PQR_MSR(RMID 0:9,
    CLOSId 32:63) to be used by both CMT and CAT. CMT updates the RMID
where as CAT updates the CLOSid in the software cache. When the new
RMID/CLOSid value is different from the cached values, IA32_PQR_MSR is
updated. Since the measured rdmsr latency for IA32_PQR_MSR is very
high(~250 cycles) this software cache is necessary to avoid reading the
MSR to compare the current CLOSid value.

Signed-off-by: Vikas Shivappa <vikas.shivappa@linux.intel.com>
---
 arch/x86/include/asm/intel_cat.h           | 36 ++++++++++++++++--------------
 arch/x86/include/asm/rdt.h                 | 13 +++++++++++
 arch/x86/kernel/cpu/perf_event_intel_cqm.c | 20 ++++++-----------
 3 files changed, 39 insertions(+), 30 deletions(-)
 create mode 100644 arch/x86/include/asm/rdt.h

diff --git a/arch/x86/include/asm/intel_cat.h b/arch/x86/include/asm/intel_cat.h
index eda86b1..a534e94 100644
--- a/arch/x86/include/asm/intel_cat.h
+++ b/arch/x86/include/asm/intel_cat.h
@@ -4,11 +4,13 @@
 #ifdef CONFIG_CGROUP_CAT
 
 #include <linux/cgroup.h>
-#define MSR_IA32_PQR_ASSOC		0xc8f
-#define MAX_CBM_LENGTH			32
-#define IA32_L3_CBM_BASE		0xc90
+#include <asm/rdt.h>
+
+#define MAX_CBM_LENGTH		32
+#define IA32_L3_CBM_BASE	0xc90
 #define CBM_FROM_INDEX(x)		(IA32_L3_CBM_BASE + x)
-DECLARE_PER_CPU(unsigned int, x86_cpu_clos);
+
+DECLARE_PER_CPU(struct intel_pqr_state, pqr_state);
 extern struct static_key cat_enable_key;
 
 struct cat_subsys_info {
@@ -63,30 +65,30 @@ static inline struct cache_alloc *task_cat(struct task_struct *task)
 static inline void cat_sched_in(struct task_struct *task)
 {
 	struct cache_alloc *cq;
-	unsigned int clos;
+	struct intel_pqr_state *state = this_cpu_ptr(&pqr_state);
+	unsigned long flags;
 
 	if (!cat_enabled())
 		return;
 
-	/*
-	 * This needs to be fixed after CQM code stabilizes
-	 * to cache the whole PQR instead of just CLOSid.
-	 * PQR has closid in high 32 bits and CQM-RMID in low 10 bits.
-	 * Should not write a 0 to the low 10 bits of PQR
-	 * and corrupt RMID.
-	 */
-	clos = this_cpu_read(x86_cpu_clos);
-
+	raw_spin_lock_irqsave(&state->lock, flags);
 	rcu_read_lock();
 	cq = task_cat(task);
-	if (cq->clos == clos) {
+	if (cq->clos == state->clos) {
 		rcu_read_unlock();
+		raw_spin_unlock_irqrestore(&state->lock, flags);
 		return;
 	}
 
-	wrmsr(MSR_IA32_PQR_ASSOC, 0, cq->clos);
-	this_cpu_write(x86_cpu_clos, cq->clos);
+	/*
+	 * PQR has closid in high 32 bits and CQM-RMID
+	 * in low 10 bits. Rewrite the exsting rmid from
+	 * software cache.
+	 */
+	wrmsr(MSR_IA32_PQR_ASSOC, state->rmid, cq->clos);
+	state->clos = cq->clos;
 	rcu_read_unlock();
+	raw_spin_unlock_irqrestore(&state->lock, flags);
 }
 
 #else
diff --git a/arch/x86/include/asm/rdt.h b/arch/x86/include/asm/rdt.h
new file mode 100644
index 0000000..c87f908
--- /dev/null
+++ b/arch/x86/include/asm/rdt.h
@@ -0,0 +1,13 @@
+#ifndef _X86_RDT_H_
+#define _X86_RDT_H_
+
+#define MSR_IA32_PQR_ASSOC	0x0c8f
+
+struct intel_pqr_state {
+	raw_spinlock_t    lock;
+	int     rmid;
+	int     clos;
+	int       cnt;
+};
+
+#endif
diff --git a/arch/x86/kernel/cpu/perf_event_intel_cqm.c b/arch/x86/kernel/cpu/perf_event_intel_cqm.c
index 596d1ec..15564e2 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_cqm.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_cqm.c
@@ -7,22 +7,16 @@
 #include <linux/perf_event.h>
 #include <linux/slab.h>
 #include <asm/cpu_device_id.h>
+#include <asm/rdt.h>
 #include "perf_event.h"
 
-#define MSR_IA32_PQR_ASSOC	0x0c8f
 #define MSR_IA32_QM_CTR		0x0c8e
 #define MSR_IA32_QM_EVTSEL	0x0c8d
 
 static unsigned int cqm_max_rmid = -1;
 static unsigned int cqm_l3_scale; /* supposedly cacheline size */
 
-struct intel_cqm_state {
-	raw_spinlock_t		lock;
-	int			rmid;
-	int 			cnt;
-};
-
-static DEFINE_PER_CPU(struct intel_cqm_state, cqm_state);
+DEFINE_PER_CPU(struct intel_pqr_state, pqr_state);
 
 /*
  * Protects cache_cgroups and cqm_rmid_free_lru and cqm_rmid_limbo_lru.
@@ -931,7 +925,7 @@ out:
 
 static void intel_cqm_event_start(struct perf_event *event, int mode)
 {
-	struct intel_cqm_state *state = this_cpu_ptr(&cqm_state);
+	struct intel_pqr_state *state = this_cpu_ptr(&pqr_state);
 	unsigned int rmid = event->hw.cqm_rmid;
 	unsigned long flags;
 
@@ -948,14 +942,14 @@ static void intel_cqm_event_start(struct perf_event *event, int mode)
 		WARN_ON_ONCE(state->rmid);
 
 	state->rmid = rmid;
-	wrmsrl(MSR_IA32_PQR_ASSOC, state->rmid);
+	wrmsr(MSR_IA32_PQR_ASSOC, state->rmid, state->clos);
 
 	raw_spin_unlock_irqrestore(&state->lock, flags);
 }
 
 static void intel_cqm_event_stop(struct perf_event *event, int mode)
 {
-	struct intel_cqm_state *state = this_cpu_ptr(&cqm_state);
+	struct intel_pqr_state *state = this_cpu_ptr(&pqr_state);
 	unsigned long flags;
 
 	if (event->hw.cqm_state & PERF_HES_STOPPED)
@@ -968,7 +962,7 @@ static void intel_cqm_event_stop(struct perf_event *event, int mode)
 
 	if (!--state->cnt) {
 		state->rmid = 0;
-		wrmsrl(MSR_IA32_PQR_ASSOC, 0);
+		wrmsr(MSR_IA32_PQR_ASSOC, 0, state->clos);
 	} else {
 		WARN_ON_ONCE(!state->rmid);
 	}
@@ -1213,7 +1207,7 @@ static inline void cqm_pick_event_reader(int cpu)
 
 static void intel_cqm_cpu_prepare(unsigned int cpu)
 {
-	struct intel_cqm_state *state = &per_cpu(cqm_state, cpu);
+	struct intel_pqr_state *state = &per_cpu(pqr_state, cpu);
 	struct cpuinfo_x86 *c = &cpu_data(cpu);
 
 	raw_spin_lock_init(&state->lock);
-- 
1.9.1

