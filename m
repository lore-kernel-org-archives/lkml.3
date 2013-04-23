Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755392Ab3DWFnh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 01:43:37 -0400
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:50635 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754777Ab3DWFnL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 01:43:11 -0400
From: Anshuman Khandual <khandual@linux.vnet.ibm.com>
To: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Cc: michael@ellerman.id.au, mikey@neuling.org
Subject: [PATCH V4 5/5] powerpc, perf: Enable branch stack sampling framework
Date: Tue, 23 Apr 2013 11:12:44 +0530
Message-Id: <1366695764-3073-6-git-send-email-khandual@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1366695764-3073-1-git-send-email-khandual@linux.vnet.ibm.com>
References: <1366695764-3073-1-git-send-email-khandual@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13042305-2674-0000-0000-000008B31AD1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Provides basic enablement for perf branch stack sampling framework on
POWER8 processor based platforms. Adds new BHRB related elements into
cpu_hw_event structure to represent current BHRB config, BHRB filter
configuration, manage context and to hold output BHRB buffer during
PMU interrupt before passing to the user space. This also enables
processing of BHRB data and converts them into generic perf branch
stack data format.

Signed-off-by: Anshuman Khandual <khandual@linux.vnet.ibm.com>
---
 arch/powerpc/include/asm/perf_event_server.h |   1 +
 arch/powerpc/perf/core-book3s.c              | 167 ++++++++++++++++++++++++++-
 2 files changed, 165 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/include/asm/perf_event_server.h b/arch/powerpc/include/asm/perf_event_server.h
index 3f0c15c..f265049 100644
--- a/arch/powerpc/include/asm/perf_event_server.h
+++ b/arch/powerpc/include/asm/perf_event_server.h
@@ -73,6 +73,7 @@ extern int register_power_pmu(struct power_pmu *);
 struct pt_regs;
 extern unsigned long perf_misc_flags(struct pt_regs *regs);
 extern unsigned long perf_instruction_pointer(struct pt_regs *regs);
+extern unsigned long int read_bhrb(int n);
 
 /*
  * Only override the default definitions in include/linux/perf_event.h
diff --git a/arch/powerpc/perf/core-book3s.c b/arch/powerpc/perf/core-book3s.c
index 4ac6e64..c627843 100644
--- a/arch/powerpc/perf/core-book3s.c
+++ b/arch/powerpc/perf/core-book3s.c
@@ -19,6 +19,11 @@
 #include <asm/firmware.h>
 #include <asm/ptrace.h>
 
+#define BHRB_MAX_ENTRIES	32
+#define BHRB_TARGET		0x0000000000000002
+#define BHRB_PREDICTION		0x0000000000000001
+#define BHRB_EA			0xFFFFFFFFFFFFFFFC
+
 struct cpu_hw_events {
 	int n_events;
 	int n_percpu;
@@ -38,7 +43,15 @@ struct cpu_hw_events {
 
 	unsigned int group_flag;
 	int n_txn_start;
+
+	/* BHRB bits */
+	u64				bhrb_filter;	/* BHRB HW branch filter */
+	int				bhrb_users;
+	void				*bhrb_context;
+	struct	perf_branch_stack	bhrb_stack;
+	struct	perf_branch_entry	bhrb_entries[BHRB_MAX_ENTRIES];
 };
+
 DEFINE_PER_CPU(struct cpu_hw_events, cpu_hw_events);
 
 struct power_pmu *ppmu;
@@ -858,6 +871,9 @@ static void power_pmu_enable(struct pmu *pmu)
 	}
 
  out:
+	if (cpuhw->bhrb_users)
+		ppmu->config_bhrb(cpuhw->bhrb_filter);
+
 	local_irq_restore(flags);
 }
 
@@ -888,6 +904,47 @@ static int collect_events(struct perf_event *group, int max_count,
 	return n;
 }
 
+/* Reset all possible BHRB entries */
+static void power_pmu_bhrb_reset(void)
+{
+	asm volatile(PPC_CLRBHRB);
+}
+
+void power_pmu_bhrb_enable(struct perf_event *event)
+{
+	struct cpu_hw_events *cpuhw = &__get_cpu_var(cpu_hw_events);
+
+	if (!ppmu->bhrb_nr)
+		return;
+
+	/* Clear BHRB if we changed task context to avoid data leaks */
+	if (event->ctx->task && cpuhw->bhrb_context != event->ctx) {
+		power_pmu_bhrb_reset();
+		cpuhw->bhrb_context = event->ctx;
+	}
+	cpuhw->bhrb_users++;
+}
+
+void power_pmu_bhrb_disable(struct perf_event *event)
+{
+	struct cpu_hw_events *cpuhw = &__get_cpu_var(cpu_hw_events);
+
+	if (!ppmu->bhrb_nr)
+		return;
+
+	cpuhw->bhrb_users--;
+	WARN_ON_ONCE(cpuhw->bhrb_users < 0);
+
+	if (!cpuhw->disabled && !cpuhw->bhrb_users) {
+		/* BHRB cannot be turned off when other
+		 * events are active on the PMU.
+		 */
+
+		/* avoid stale pointer */
+		cpuhw->bhrb_context = NULL;
+	}
+}
+
 /*
  * Add a event to the PMU.
  * If all events are not already frozen, then we disable and
@@ -947,6 +1004,9 @@ nocheck:
 
 	ret = 0;
  out:
+	if (has_branch_stack(event))
+		power_pmu_bhrb_enable(event);
+
 	perf_pmu_enable(event->pmu);
 	local_irq_restore(flags);
 	return ret;
@@ -999,6 +1059,9 @@ static void power_pmu_del(struct perf_event *event, int ef_flags)
 		cpuhw->mmcr[0] &= ~(MMCR0_PMXE | MMCR0_FCECE);
 	}
 
+	if (has_branch_stack(event))
+		power_pmu_bhrb_disable(event);
+
 	perf_pmu_enable(event->pmu);
 	local_irq_restore(flags);
 }
@@ -1117,6 +1180,15 @@ int power_pmu_commit_txn(struct pmu *pmu)
 	return 0;
 }
 
+/* Called from ctxsw to prevent one process's branch entries to
+ * mingle with the other process's entries during context switch.
+ */
+void power_pmu_flush_branch_stack(void)
+{
+	if (ppmu->bhrb_nr)
+		power_pmu_bhrb_reset();
+}
+
 /*
  * Return 1 if we might be able to put event on a limited PMC,
  * or 0 if not.
@@ -1231,9 +1303,11 @@ static int power_pmu_event_init(struct perf_event *event)
 	if (!ppmu)
 		return -ENOENT;
 
-	/* does not support taken branch sampling */
-	if (has_branch_stack(event))
-		return -EOPNOTSUPP;
+	if (has_branch_stack(event)) {
+	        /* PMU has BHRB enabled */
+		if (!(ppmu->flags & PPMU_BHRB))
+			return -EOPNOTSUPP;
+	}
 
 	switch (event->attr.type) {
 	case PERF_TYPE_HARDWARE:
@@ -1314,6 +1388,15 @@ static int power_pmu_event_init(struct perf_event *event)
 
 	cpuhw = &get_cpu_var(cpu_hw_events);
 	err = power_check_constraints(cpuhw, events, cflags, n + 1);
+
+	if (has_branch_stack(event)) {
+		cpuhw->bhrb_filter = ppmu->bhrb_filter_map(
+					event->attr.branch_sample_type);
+
+		if(cpuhw->bhrb_filter == -1)
+			return -EOPNOTSUPP;
+	}
+
 	put_cpu_var(cpu_hw_events);
 	if (err)
 		return -EINVAL;
@@ -1372,8 +1455,79 @@ struct pmu power_pmu = {
 	.cancel_txn	= power_pmu_cancel_txn,
 	.commit_txn	= power_pmu_commit_txn,
 	.event_idx	= power_pmu_event_idx,
+	.flush_branch_stack = power_pmu_flush_branch_stack,
 };
 
+/* Processing BHRB entries */
+void power_pmu_bhrb_read(struct cpu_hw_events *cpuhw)
+{
+	u64 val;
+	u64 addr;
+	int r_index, u_index, target, pred;
+
+	r_index = 0;
+	u_index = 0;
+	while (r_index < ppmu->bhrb_nr) {
+		/* Assembly read function */
+		val = read_bhrb(r_index);
+
+		/* Terminal marker: End of valid BHRB entries */
+		if (val == 0) {
+			break;
+		} else {
+			/* BHRB field break up */
+			addr = val & BHRB_EA;
+			pred = val & BHRB_PREDICTION;
+			target = val & BHRB_TARGET;
+
+			/* Probable Missed entry: Not applicable for POWER8 */
+			if ((addr == 0) && (target == 0) && (pred == 1)) {
+				r_index++;
+				continue;
+			}
+
+			/* Real Missed entry: Power8 based missed entry */
+			if ((addr == 0) && (target == 1) && (pred == 1)) {
+				r_index++;
+				continue;
+			}
+
+			/* Reserved condition: Not a valid entry  */
+			if ((addr == 0) && (target == 1) && (pred == 0)) {
+				r_index++;
+				continue;
+			}
+
+			/* Is a target address */
+			if (val & BHRB_TARGET) {
+				/* First address cannot be a target address */
+				if (r_index == 0) {
+					r_index++;
+					continue;
+				}
+
+				/* Update target address for the previous entry */
+				cpuhw->bhrb_entries[u_index - 1].to = addr;
+				cpuhw->bhrb_entries[u_index - 1].mispred = pred;
+				cpuhw->bhrb_entries[u_index - 1].predicted = ~pred;
+
+				/* Dont increment u_index */
+				r_index++;
+			} else {
+				/* Update address, flags for current entry */
+				cpuhw->bhrb_entries[u_index].from = addr;
+				cpuhw->bhrb_entries[u_index].mispred = pred;
+				cpuhw->bhrb_entries[u_index].predicted = ~pred;
+
+				/* Successfully popullated one entry */
+				u_index++;
+				r_index++;
+			}
+		}
+	}
+	cpuhw->bhrb_stack.nr = u_index;
+	return;
+}
 
 /*
  * A counter has overflowed; update its count and record
@@ -1433,6 +1587,13 @@ static void record_and_restart(struct perf_event *event, unsigned long val,
 		if (event->attr.sample_type & PERF_SAMPLE_ADDR)
 			perf_get_data_addr(regs, &data.addr);
 
+		if (event->attr.sample_type & PERF_SAMPLE_BRANCH_STACK) {
+			struct cpu_hw_events *cpuhw;
+			cpuhw = &__get_cpu_var(cpu_hw_events);
+			power_pmu_bhrb_read(cpuhw);
+			data.br_stack = &cpuhw->bhrb_stack;
+		}
+
 		if (perf_event_overflow(event, &data, regs))
 			power_pmu_stop(event, 0);
 	}
-- 
1.7.11.7

