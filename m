Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755676Ab3H3EZz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 00:25:55 -0400
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:51824 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753222Ab3H3EZm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 00:25:42 -0400
From: Anshuman Khandual <khandual@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Cc: eranian@google.com, acme@redhat.com, michael.neuling@au1.ibm.com,
        ellerman@au1.ibm.com, svaidy@linux.vnet.ibm.com,
        sukadev@linux.vnet.ibm.com
Subject: [PATCH V2 6/6] powerpc, perf: Enable SW filtering in branch stack sampling framework
Date: Fri, 30 Aug 2013 09:54:50 +0530
Message-Id: <1377836690-32710-7-git-send-email-khandual@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1377836690-32710-1-git-send-email-khandual@linux.vnet.ibm.com>
References: <1377836690-32710-1-git-send-email-khandual@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13083004-8256-0000-0000-000009036540
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch enables SW based post processing of BHRB captured branches
to be able to meet more user defined branch filtration criteria in perf
branch stack sampling framework. This changes increase the number of
filters and their valid combinations on powerpc64 platform with BHRB
support. Summary of code changes described below.

(1) struct cpu_hw_events

	Introduced two new variables and modified one to track various filters.

	a) bhrb_hw_filter	Tracks PMU based HW branch filter flags.
				Computed from PMU dependent call back.
	b) bhrb_sw_filter	Tracks SW based instruction filter flags
				Computed from PPC64 generic SW filter.
	c) filter_mask		Tracks overall filter flags for PPC64

(2) Creating HW event with BHRB request

	Kernel would try to figure out supported HW filters through a PMU call
	back ppmu->bhrb_filter_map(). Here it would only invalidate unsupported
	HW filter combinations. In future we could process one element from the
	combination in HW and one in SW. Meanwhile cpuhw->filter_mask would be
	tracking the overall supported branch filter requests on the PMU.

	Kernel would also process the user request against available SW filters
	for PPC64. Then we would process filter_mask to verify whether all the
	user requested branch filters have been taken care of either in HW or in
	SW.

(3) BHRB SW filter processing

	During the BHRB data capture inside the PMU interrupt context, each
	of the captured "perf_branch_entry.from" would be checked for compliance
	with applicable SW branch filters. If the entry does not confirm to the
	filter requirements, it would be discarded from the final perf branch
	stack buffer.

(4) Instruction classification for proposed SW filters

	Here are the list of category of instructions which have been classified
	under the proposed SW filters.

	(a) PERF_SAMPLE_BRANCH_ANY_RETURN

		(i) [Un]conditional branch to LR without setting the LR
			(1) blr
			(2) bclr
			(3) btlr
			(4) bflr
			(5) bdnzlr
			(6) bdnztlr
			(7) bdnzflr
			(8) bdzlr
			(9) bdztlr
			(10) bdzflr
			(11) bltlr
			(12) blelr
			(13) beqlr
			(14) bgelr
			(15) bgtlr
			(16) bnllr
			(17) bnelr
			(18) bnglr
			(19) bsolr
			(20) bnslr
			(21) biclr
			(22) bnilr
			(23) bunlr
			(24) bnulr

	(b) PERF_SAMPLE_BRANCH_IND_CALL

		(i) [Un]conditional branch to CTR with setting the link
			(1) bctrl
			(2) bcctrl
			(3) btctrl
			(4) bfctrl
			(5) bltctrl
			(6) blectrl
			(7) beqctrl
			(8) bgectrl
			(9) bgtctrl
			(10) bnlctrl
			(11) bnectrl
			(12) bngctrl
			(13) bsoctrl
			(14) bnsctrl
			(15) bicctrl
			(16) bnictrl
			(17) bunctrl
			(18) bnuctrl

		(ii) [Un]conditional branch to LR setting the link
			(0) bclrl
			(1) blrl
			(2) btlrl
			(3) bflrl
			(4) bdnzlrl
			(5) bdnztlrl
			(6) bdnzflrl
			(7) bdzlrl
			(8) bdztlrl
			(9) bdzflrl
			(10) bltlrl
			(11) blelrl
			(12) beqlrl
			(13) bgelrl
			(14) bgtlrl
			(15) bnllrl
			(16) bnelrl
			(17) bnglrl
			(18) bsolrl
			(19) bnslrl
			(20) biclrl
			(21) bnilrl
			(22) bunlrl
			(23) bnulrl

		(iii) [Un]conditional branch to TAR setting the link
			(1) btarl
			(2) bctarl

Signed-off-by: Anshuman Khandual <khandual@linux.vnet.ibm.com>
---
 arch/powerpc/include/asm/perf_event_server.h |   2 +-
 arch/powerpc/perf/core-book3s.c              | 200 +++++++++++++++++++++++++--
 arch/powerpc/perf/power8-pmu.c               |  19 ++-
 3 files changed, 198 insertions(+), 23 deletions(-)

diff --git a/arch/powerpc/include/asm/perf_event_server.h b/arch/powerpc/include/asm/perf_event_server.h
index 8b24926..5fc798b 100644
--- a/arch/powerpc/include/asm/perf_event_server.h
+++ b/arch/powerpc/include/asm/perf_event_server.h
@@ -34,7 +34,7 @@ struct power_pmu {
 				unsigned long *valp);
 	int		(*get_alternatives)(u64 event_id, unsigned int flags,
 				u64 alt[]);
-	u64             (*bhrb_filter_map)(u64 branch_sample_type);
+	u64             (*bhrb_filter_map)(u64 branch_sample_type, u64 *filter_mask);
 	void            (*config_bhrb)(u64 pmu_bhrb_filter);
 	void		(*disable_pmc)(unsigned int pmc, unsigned long mmcr[]);
 	int		(*limited_pmc_event)(u64 event_id);
diff --git a/arch/powerpc/perf/core-book3s.c b/arch/powerpc/perf/core-book3s.c
index eeae308..81c4a1d 100644
--- a/arch/powerpc/perf/core-book3s.c
+++ b/arch/powerpc/perf/core-book3s.c
@@ -26,6 +26,10 @@
 #define BHRB_PREDICTION		0x0000000000000001
 #define BHRB_EA			0xFFFFFFFFFFFFFFFC
 
+#define for_each_branch_sample_type(x) \
+        for ((x) = PERF_SAMPLE_BRANCH_USER; \
+             (x) < PERF_SAMPLE_BRANCH_MAX; (x) <<= 1)
+
 struct cpu_hw_events {
 	int n_events;
 	int n_percpu;
@@ -47,7 +51,9 @@ struct cpu_hw_events {
 	int n_txn_start;
 
 	/* BHRB bits */
-	u64				bhrb_filter;	/* BHRB HW branch filter */
+	u64				bhrb_hw_filter;	/* BHRB HW branch filter */
+	u64				bhrb_sw_filter; /* BHRB SW branch filter */
+	u64				filter_mask;	/* Branch filter mask */
 	int				bhrb_users;
 	void				*bhrb_context;
 	struct	perf_branch_stack	bhrb_stack;
@@ -400,6 +406,101 @@ static __u64 power_pmu_bhrb_to(u64 addr)
 	return target - (unsigned long)&instr + addr;
 }
 
+#define BRANCH_LINK   0x00000001
+#define BRANCH_LR     0x4C000020
+#define BRANCH_CTR    0x4C000420
+#define BRANCH_TAR    0x4C000460
+
+/* Check the instruction opcodes */
+static bool validate_instruction(unsigned int *addr, u64 bhrb_sw_filter)
+{
+	if (bhrb_sw_filter & PERF_SAMPLE_BRANCH_ANY_RETURN) {
+		/* Link is not set */
+		if (!(*addr & BRANCH_LINK)) {
+			/*
+			 * Conditional and unconditional
+			 * branch to LR.
+			 */
+			if ((*addr & BRANCH_LR) == BRANCH_LR)
+				return true;
+
+			/* Everything else */
+			return false;
+		}
+
+		/* Link is set */
+		return false;
+	}
+
+	if (bhrb_sw_filter & PERF_SAMPLE_BRANCH_IND_CALL) {
+		/* Link is set */
+		if (*addr & BRANCH_LINK) {
+			/*
+			 * Conditional and unconditional
+			 * branch to CTR.
+			 */
+			if ((*addr & BRANCH_CTR) == BRANCH_CTR)
+				return true;
+			/*
+			 * Conditional and unconditional
+			 * branch to LR.
+			 */
+			if ((*addr & BRANCH_LR) == BRANCH_LR)
+				return true;
+			/*
+			 * Conditional and unconditional
+			 * branch to TAR.
+			 */
+			if ((*addr & BRANCH_TAR) == BRANCH_TAR)
+				return true;
+
+			/* Everything else */
+			return false;
+		}
+
+		/* Link is not set */
+		return false;
+	}
+
+	/* No software branch filter, control
+	 * should not have come here.
+	 */
+	return true;
+}
+
+/* Extract the instruction from the address */
+static bool check_instruction(u64 addr, u64 bhrb_sw_filter)
+{
+	unsigned int instr;
+	bool ret;
+
+	if (bhrb_sw_filter == 0)
+		return true;
+
+	if (is_kernel_addr(addr)) {
+		ret = validate_instruction((unsigned int *) addr, bhrb_sw_filter);
+	} else {
+		/*
+		 * Userspace address need to copied first
+		 * before analysis.
+		 */
+		pagefault_disable();
+		ret =  __get_user_inatomic(instr, (unsigned int __user *)addr);
+
+		/*
+		 * If the instruction could not be accessible
+		 * from user space, we still OKAY the entry.
+		 */
+		if (ret) {
+			pagefault_enable();
+			return true;
+		}
+		pagefault_enable();
+		ret = validate_instruction(&instr, bhrb_sw_filter);
+	}
+	return ret;
+}
+
 /* Processing BHRB entries */
 void power_pmu_bhrb_read(struct cpu_hw_events *cpuhw)
 {
@@ -459,14 +560,28 @@ void power_pmu_bhrb_read(struct cpu_hw_events *cpuhw)
 					addr = 0;
 				}
 				cpuhw->bhrb_entries[u_index].from = addr;
+
+				/* Apply SW filter */
+				if (!check_instruction(cpuhw->
+						bhrb_entries[u_index].from,
+							cpuhw->bhrb_sw_filter))
+					u_index--;
 			} else {
 				/* Branches to immediate field 
 				   (ie I or B form) */
 				cpuhw->bhrb_entries[u_index].from = addr;
-				cpuhw->bhrb_entries[u_index].to =
-					power_pmu_bhrb_to(addr);
-				cpuhw->bhrb_entries[u_index].mispred = pred;
-				cpuhw->bhrb_entries[u_index].predicted = ~pred;
+				if (check_instruction(cpuhw->
+						bhrb_entries[u_index].from,
+						cpuhw->bhrb_sw_filter)) {
+					cpuhw->bhrb_entries[u_index].
+						to = power_pmu_bhrb_to(addr);
+					cpuhw->bhrb_entries[u_index].
+						mispred = pred;
+					cpuhw->bhrb_entries[u_index].
+						predicted = ~pred;
+				} else {
+					u_index--;
+				}
 			}
 			u_index++;
 
@@ -1159,7 +1274,7 @@ static void power_pmu_enable(struct pmu *pmu)
 
  out:
 	if (cpuhw->bhrb_users)
-		ppmu->config_bhrb(cpuhw->bhrb_filter);
+		ppmu->config_bhrb(cpuhw->bhrb_hw_filter);
 
 	local_irq_restore(flags);
 }
@@ -1191,6 +1306,26 @@ static int collect_events(struct perf_event *group, int max_count,
 	return n;
 }
 
+/* SW based branch filters */
+static u64 branch_filter_map(u64 branch_sample_type, u64 *filter_mask)
+{
+	u64 branch_sw_filter = 0;
+
+	if (branch_sample_type & PERF_SAMPLE_BRANCH_ANY) {
+		WARN_ON(*filter_mask != PERF_SAMPLE_BRANCH_ANY);
+		return branch_sw_filter;
+	}
+	if (branch_sample_type & PERF_SAMPLE_BRANCH_ANY_RETURN) {
+		branch_sw_filter |= PERF_SAMPLE_BRANCH_ANY_RETURN;
+		*filter_mask |= PERF_SAMPLE_BRANCH_ANY_RETURN;
+	}
+	if (branch_sample_type & PERF_SAMPLE_BRANCH_IND_CALL) {
+		branch_sw_filter |= PERF_SAMPLE_BRANCH_IND_CALL;
+		*filter_mask |= PERF_SAMPLE_BRANCH_IND_CALL;
+	}
+	return branch_sw_filter;
+}
+
 /*
  * Add a event to the PMU.
  * If all events are not already frozen, then we disable and
@@ -1254,8 +1389,11 @@ nocheck:
  out:
 	if (has_branch_stack(event)) {
 		power_pmu_bhrb_enable(event);
-		cpuhw->bhrb_filter = ppmu->bhrb_filter_map(
-					event->attr.branch_sample_type);
+
+		cpuhw->bhrb_hw_filter = ppmu->bhrb_filter_map
+			(event->attr.branch_sample_type, &cpuhw->filter_mask);
+	        cpuhw->bhrb_sw_filter = branch_filter_map
+			(event->attr.branch_sample_type, &cpuhw->filter_mask);
 	}
 
 	perf_pmu_enable(event->pmu);
@@ -1531,6 +1669,35 @@ static int hw_perf_cache_event(u64 config, u64 *eventp)
 	return 0;
 }
 
+/* Validate requested filters either in PMU or in SW */
+static int match_filters(u64 branch_sample_type, u64 filter_mask)
+{
+	u64 x;
+
+	if (filter_mask == PERF_SAMPLE_BRANCH_ANY)
+		return true;
+
+	for_each_branch_sample_type(x) {
+		if (!(branch_sample_type & x))
+			continue;
+		/*
+		 * Privilege filter requests have been already
+		 * taken care during base PMU configuration.
+		 */
+		if (x == PERF_SAMPLE_BRANCH_USER)
+			continue;
+		if (x == PERF_SAMPLE_BRANCH_KERNEL)
+			continue;
+		if (x == PERF_SAMPLE_BRANCH_HV)
+			continue;
+
+		/* Requested filter not available */
+		if (!(filter_mask & x))
+			return false;
+	}
+	return true;
+}
+
 static int power_pmu_event_init(struct perf_event *event)
 {
 	u64 ev;
@@ -1637,10 +1804,21 @@ static int power_pmu_event_init(struct perf_event *event)
 	err = power_check_constraints(cpuhw, events, cflags, n + 1);
 
 	if (has_branch_stack(event)) {
-		cpuhw->bhrb_filter = ppmu->bhrb_filter_map(
-					event->attr.branch_sample_type);
+		/* PMU supported branch filters */
+		cpuhw->bhrb_hw_filter = ppmu->bhrb_filter_map
+			(event->attr.branch_sample_type, &cpuhw->filter_mask);
+
+		/* ABI - PMU does not support filter combination */
+		if (cpuhw->bhrb_hw_filter == -1)
+			return -EOPNOTSUPP;
+
+		/* SW supported branch filters */
+		cpuhw->bhrb_sw_filter = branch_filter_map
+			(event->attr.branch_sample_type, &cpuhw->filter_mask);
 
-		if(cpuhw->bhrb_filter == -1)
+		/* ABI - Requested filters are not present */
+		if(!match_filters(event->attr.branch_sample_type,
+							cpuhw->filter_mask))
 			return -EOPNOTSUPP;
 	}
 
diff --git a/arch/powerpc/perf/power8-pmu.c b/arch/powerpc/perf/power8-pmu.c
index 6e28587..e02027b 100644
--- a/arch/powerpc/perf/power8-pmu.c
+++ b/arch/powerpc/perf/power8-pmu.c
@@ -558,9 +558,10 @@ static int power8_generic_events[] = {
 	[PERF_COUNT_HW_BRANCH_MISSES] =			PM_BR_MPRED_CMPL,
 };
 
-static u64 power8_bhrb_filter_map(u64 branch_sample_type)
+static u64 power8_bhrb_filter_map(u64 branch_sample_type, u64 *filter_mask)
 {
 	u64 pmu_bhrb_filter = 0;
+	*filter_mask = 0;
 
 	/* BHRB and regular PMU events share the same privilege state
 	 * filter configuration. BHRB is always recorded along with a
@@ -570,15 +571,10 @@ static u64 power8_bhrb_filter_map(u64 branch_sample_type)
 	 */
 
 	/* No branch filter requested */
-	if (branch_sample_type & PERF_SAMPLE_BRANCH_ANY)
+	if (branch_sample_type & PERF_SAMPLE_BRANCH_ANY) {
+		*filter_mask = PERF_SAMPLE_BRANCH_ANY;
 		return pmu_bhrb_filter;
-
-	/* Invalid branch filter options - HW does not support */
-	if (branch_sample_type & PERF_SAMPLE_BRANCH_ANY_RETURN)
-		return -1;
-
-	if (branch_sample_type & PERF_SAMPLE_BRANCH_IND_CALL)
-		return -1;
+	}
 
 	/* Invalid branch filter combination - HW does not support */
 	if ((branch_sample_type & PERF_SAMPLE_BRANCH_ANY_CALL) &&
@@ -587,16 +583,17 @@ static u64 power8_bhrb_filter_map(u64 branch_sample_type)
 
 	if (branch_sample_type & PERF_SAMPLE_BRANCH_ANY_CALL) {
 		pmu_bhrb_filter |= POWER8_MMCRA_IFM1;
+		*filter_mask    |= PERF_SAMPLE_BRANCH_ANY_CALL;
 		return pmu_bhrb_filter;
 	}
 
 	if (branch_sample_type & PERF_SAMPLE_BRANCH_COND) {
 		pmu_bhrb_filter |= POWER8_MMCRA_IFM3;
+		*filter_mask    |= PERF_SAMPLE_BRANCH_COND;
 		return pmu_bhrb_filter;
 	}
 
-	/* Every thing else is unsupported */
-	return -1;
+	return pmu_bhrb_filter;
 }
 
 static void power8_config_bhrb(u64 pmu_bhrb_filter)
-- 
1.7.11.7

