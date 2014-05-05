Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755884AbaEEJLH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 05:11:07 -0400
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:43359 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755341AbaEEJLC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 05:11:02 -0400
From: Anshuman Khandual <khandual@linux.vnet.ibm.com>
To: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Cc: michael@ellerman.id.au, mikey@neuling.org, ak@linux.intel.com,
        eranian@google.com, acme@ghostprotocols.net,
        sukadev@linux.vnet.ibm.com, mingo@kernel.org
Subject: [V6 09/11] powerpc, perf: Enable SW filtering in branch stack sampling framework
Date: Mon,  5 May 2014 14:39:11 +0530
Message-Id: <1399280953-31442-10-git-send-email-khandual@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1399280953-31442-1-git-send-email-khandual@linux.vnet.ibm.com>
References: <1399280953-31442-1-git-send-email-khandual@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14050509-8878-0000-0000-00000C427D31
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch enables SW based post processing of BHRB captured branches
to be able to meet more user defined branch filtration criteria in perf
branch stack sampling framework. These changes increase the number of
branch filters and their valid combinations on any powerpc64 server
platform with BHRB support. Find the summary of code changes here.

(1) struct cpu_hw_events

	Introduced two new variables track various filter values and mask

	(a) bhrb_sw_filter	Tracks SW implemented branch filter flags
	(b) bhrb_filter		Tracks both (SW and HW) branch filter flags

(2) Event creation

	Kernel will figure out supported BHRB branch filters through a PMU call
	back 'bhrb_filter_map'. This function will find out how many of the
	requested branch filters can be supported in the PMU HW. It will not
	try to invalidate any branch filter combinations. Event creation will not
	error out because of lack of HW based branch filters. Meanwhile it will
	track the overall supported branch filters in the 'bhrb_filter' variable.

	Once the PMU call back returns kernel will process the user branch filter
	request against available SW filters (bhrb_sw_filter_map) while looking
	at the 'bhrb_filter'. During this phase all the branch filters which are
	still pending from the user requested list will have to be supported in
	SW failing which the event creation will error out.

(3) SW branch filter

	During the BHRB data capture inside the PMU interrupt context, each
	of the captured 'perf_branch_entry.from' will be checked for compliance
	with applicable SW branch filters. If the entry does not conform to the
	filter requirements, it will be discarded from the final perf branch
	stack buffer.

(4) Supported SW based branch filters

	(a) PERF_SAMPLE_BRANCH_ANY_RETURN
	(b) PERF_SAMPLE_BRANCH_IND_CALL
	(c) PERF_SAMPLE_BRANCH_ANY_CALL
	(d) PERF_SAMPLE_BRANCH_COND

	Please refer the patch to understand the classification of instructions
	into these branch filter categories.

(5) Multiple branch filter semantics

	Book3 sever implementation follows the same OR semantics (as implemented in
	x86) while dealing with multiple branch filters at any point of time. SW
	branch filter analysis is carried on the data set captured in the PMU HW.
	So the resulting set of data (after applying the SW filters) will inherently
	be an AND with the HW captured set. Hence any combination of HW and SW branch
	filters will be invalid. HW based branch filters are more efficient and faster
	compared to SW implemented branch filters. So at first the PMU should decide
	whether it can support all the requested branch filters itself or not. In case
	it can support all the branch filters in an OR manner, we dont apply any SW
	branch filter on top of the HW captured set (which is the final set). This
	preserves the OR semantic of multiple branch filters as required. But in case
	where the PMU cannot support all the requested branch filters in an OR manner,
	it should not apply any it's filters and leave it upto the SW to handle them
	all. Its the PMU code's responsibility to uphold this protocol to be able to
	conform to the overall OR semantic of perf branch stack sampling framework.

Signed-off-by: Anshuman Khandual <khandual@linux.vnet.ibm.com>
---
 arch/powerpc/include/asm/perf_event_server.h |   6 +-
 arch/powerpc/perf/core-book3s.c              | 188 ++++++++++++++++++++++++++-
 arch/powerpc/perf/power8-pmu.c               |   2 +-
 3 files changed, 187 insertions(+), 9 deletions(-)

diff --git a/arch/powerpc/include/asm/perf_event_server.h b/arch/powerpc/include/asm/perf_event_server.h
index 9ed73714..93a9a8a 100644
--- a/arch/powerpc/include/asm/perf_event_server.h
+++ b/arch/powerpc/include/asm/perf_event_server.h
@@ -19,6 +19,10 @@
 #define MAX_EVENT_ALTERNATIVES	8
 #define MAX_LIMITED_HWCOUNTERS	2
 
+#define for_each_branch_sample_type(x) \
+        for ((x) = PERF_SAMPLE_BRANCH_USER; \
+             (x) < PERF_SAMPLE_BRANCH_MAX; (x) <<= 1)
+
 /*
  * This struct provides the constants and functions needed to
  * describe the PMU on a particular POWER-family CPU.
@@ -35,7 +39,7 @@ struct power_pmu {
 				unsigned long *valp);
 	int		(*get_alternatives)(u64 event_id, unsigned int flags,
 				u64 alt[]);
-	u64             (*bhrb_filter_map)(u64 branch_sample_type);
+	u64             (*bhrb_filter_map)(u64 branch_sample_type, u64 *bhrb_filter);
 	void            (*config_bhrb)(u64 pmu_bhrb_filter);
 	void		(*disable_pmc)(unsigned int pmc, unsigned long mmcr[]);
 	int		(*limited_pmc_event)(u64 event_id);
diff --git a/arch/powerpc/perf/core-book3s.c b/arch/powerpc/perf/core-book3s.c
index 1d7e909..a94cc43 100644
--- a/arch/powerpc/perf/core-book3s.c
+++ b/arch/powerpc/perf/core-book3s.c
@@ -46,8 +46,9 @@ struct cpu_hw_events {
 	unsigned int group_flag;
 	int n_txn_start;
 
-	/* BHRB bits */
 	u64				bhrb_hw_filter;	/* BHRB HW branch filter */
+	u64				bhrb_sw_filter;	/* BHRB SW branch filter */
+	u64				bhrb_filter;	/* Branch filter mask */
 	int				bhrb_users;
 	void				*bhrb_context;
 	struct	perf_branch_stack	bhrb_stack;
@@ -412,6 +413,152 @@ void update_branch_entry(struct cpu_hw_events *cpuhw, int u_index, u64 from, u64
 	return;
 }
 
+/*
+ * Instruction opcode analysis
+ *
+ * Analyse instruction opcodes and classify them
+ * into various branch filter options available.
+ * This follows the standard semantics of OR which
+ * means that instructions which conforms to `any`
+ * of the requested branch filters get picked up.
+ */
+static bool check_instruction(unsigned int *addr, u64 sw_filter)
+{
+	if (sw_filter & PERF_SAMPLE_BRANCH_ANY_RETURN) {
+		if (instr_is_return_branch(*addr))
+			return true;
+	}
+
+	if (sw_filter & PERF_SAMPLE_BRANCH_IND_CALL) {
+		if (instr_is_indirect_func_call(*addr))
+			return true;
+	}
+
+	if (sw_filter & PERF_SAMPLE_BRANCH_ANY_CALL) {
+		if (instr_is_func_call(*addr))
+			return true;
+	}
+
+	if (sw_filter & PERF_SAMPLE_BRANCH_COND) {
+		if (instr_is_conditional_branch(*addr))
+			return true;
+	}
+	return false;
+}
+
+/* 
+ * Access the instruction contained in the address and check
+ * whether it complies with the applicable SW branch filters.
+ */
+static bool keep_branch(u64 from, u64 sw_filter)
+{
+	unsigned int instr;
+	bool ret;
+
+	/*
+	 * The "from" branch for every branch record has to go
+	 * through this filter verification. So this quick check
+	 * here for no SW filters will improve performance.
+	 */
+	if (sw_filter == 0)
+		return true;
+
+	if (is_kernel_addr(from)) {
+		return check_instruction((unsigned int *) from, sw_filter);
+	} else {
+		/*
+		 * Userspace address needs to be
+		 * copied first before analysis.
+		 */
+		pagefault_disable();
+		ret =  __get_user_inatomic(instr, (unsigned int __user *) from);
+
+		/*
+		 * If the instruction could not be accessible
+		 * from user space, we still 'okay' the entry.
+		 */
+		if (ret) {
+			pagefault_enable();
+			return true;
+		}
+		pagefault_enable();
+		return check_instruction(&instr, sw_filter);
+	}
+}
+
+/*
+ * Validate whether all the requested branch filters
+ * are getting processed either in the PMU or in SW.
+ */
+static int all_filters_covered(u64 branch_sample_type, u64 bhrb_filter)
+{
+	u64 x;
+
+	if (bhrb_filter == PERF_SAMPLE_BRANCH_ANY)
+		return true;
+
+	for_each_branch_sample_type(x) {
+		if (!(branch_sample_type & x))
+			continue;
+		/*
+		 * Privilege filter requests have been already
+		 * taken care during the base PMU configuration.
+		 */
+		if ((x == PERF_SAMPLE_BRANCH_USER)
+			|| (x == PERF_SAMPLE_BRANCH_KERNEL)
+				|| (x == PERF_SAMPLE_BRANCH_HV))
+			continue;
+
+		/*
+		 * Requested filter not available either
+		 * in PMU or in SW.
+		 */
+		if (!(bhrb_filter & x))
+			return false;
+	}
+	return true;
+}
+
+/* SW implemented branch filters */
+static unsigned int power_sw_filter[] = { PERF_SAMPLE_BRANCH_ANY_CALL,
+					  PERF_SAMPLE_BRANCH_COND,
+					  PERF_SAMPLE_BRANCH_ANY_RETURN,
+					  PERF_SAMPLE_BRANCH_IND_CALL };
+
+/*
+ * Required SW based branch filters
+ *
+ * This is called after figuring out what all branch filters the
+ * PMU HW supports for the requested branch filter set. Here we
+ * will go through all the SW implemented branch filters one by
+ * one and pick them up if its not already supported in the PMU.
+ */
+static u64 bhrb_sw_filter_map(u64 branch_sample_type, u64 *bhrb_filter)
+{
+	u64 branch_sw_filter = 0;
+	unsigned int i;
+
+	if (branch_sample_type & PERF_SAMPLE_BRANCH_ANY) {
+		WARN_ON(*bhrb_filter != PERF_SAMPLE_BRANCH_ANY);
+		return branch_sw_filter;
+	}
+
+	/*
+	 * PMU supported branch filters must be implemented in SW
+	 * when the PMU is unable to process them for some reason.
+	 */
+	for (i = 0; i < ARRAY_SIZE(power_sw_filter); i++) {
+		if (branch_sample_type & power_sw_filter[i]) {
+			if (!(*bhrb_filter & power_sw_filter[i])) {
+				branch_sw_filter |= power_sw_filter[i];
+				*bhrb_filter |= power_sw_filter[i];
+			}
+		}
+	}
+
+	return branch_sw_filter;
+}
+
 /* Processing BHRB entries */
 void power_pmu_bhrb_read(struct cpu_hw_events *cpuhw)
 {
@@ -474,6 +621,11 @@ void power_pmu_bhrb_read(struct cpu_hw_events *cpuhw)
 			tmp = power_pmu_bhrb_to(addr);
 			update_branch_entry(cpuhw, u_index, addr, tmp, pred);
 		}
+
+		/* Apply SW branch filters and drop the entry if required */
+		if (!keep_branch(cpuhw->bhrb_entries[u_index].from,
+						cpuhw->bhrb_sw_filter))
+			u_index--;
 		u_index++;
 	}
 	cpuhw->bhrb_stack.nr = u_index;
@@ -1297,6 +1449,8 @@ static void power_pmu_enable(struct pmu *pmu)
 	mmcr0 = ebb_switch_in(ebb, cpuhw->mmcr[0]);
 
 	mb();
+
+	/* Enable PMU based branch filters */
 	if (cpuhw->bhrb_users)
 		ppmu->config_bhrb(cpuhw->bhrb_hw_filter);
 
@@ -1405,8 +1559,12 @@ nocheck:
  out:
 	if (has_branch_stack(event)) {
 		power_pmu_bhrb_enable(event);
-		cpuhw->bhrb_hw_filter = ppmu->bhrb_filter_map(
-					event->attr.branch_sample_type);
+		cpuhw->bhrb_hw_filter = ppmu->bhrb_filter_map
+					(event->attr.branch_sample_type,
+							&cpuhw->bhrb_filter);
+		cpuhw->bhrb_sw_filter = bhrb_sw_filter_map
+					(event->attr.branch_sample_type,
+							&cpuhw->bhrb_filter);
 	}
 
 	perf_pmu_enable(event->pmu);
@@ -1787,11 +1945,27 @@ static int power_pmu_event_init(struct perf_event *event)
 	cpuhw = &get_cpu_var(cpu_hw_events);
 	err = power_check_constraints(cpuhw, events, cflags, n + 1);
 
+	/*
+	 * BHRB branch filters implemented in PMU will take
+	 * effect when we enable the event and data set
+	 * collected thereafter will be compliant with those
+	 * branch filters. Where as the SW branch filters will
+	 * be applied during the post processing of BHRB data.
+	 */
 	if (has_branch_stack(event)) {
-		cpuhw->bhrb_hw_filter = ppmu->bhrb_filter_map(
-					event->attr.branch_sample_type);
-
-		if(cpuhw->bhrb_hw_filter == -1)
+		/* Query available PMU branch filter support */
+		cpuhw->bhrb_hw_filter = ppmu->bhrb_filter_map
+				(event->attr.branch_sample_type,
+						&cpuhw->bhrb_filter);
+
+		/* Query available SW branch filter support */
+		cpuhw->bhrb_sw_filter = bhrb_sw_filter_map
+				(event->attr.branch_sample_type,
+						&cpuhw->bhrb_filter);
+
+		/* Check overall coverage of branch filter request */
+		if(!all_filters_covered(event->attr.branch_sample_type,
+						cpuhw->bhrb_filter))
 			return -EOPNOTSUPP;
 	}
 
diff --git a/arch/powerpc/perf/power8-pmu.c b/arch/powerpc/perf/power8-pmu.c
index 13f47f5..699b1dd 100644
--- a/arch/powerpc/perf/power8-pmu.c
+++ b/arch/powerpc/perf/power8-pmu.c
@@ -633,7 +633,7 @@ static int power8_generic_events[] = {
 	[PERF_COUNT_HW_CACHE_MISSES] =			PM_LD_MISS_L1,
 };
 
-static u64 power8_bhrb_filter_map(u64 branch_sample_type)
+static u64 power8_bhrb_filter_map(u64 branch_sample_type, u64 *bhrb_filter)
 {
 	/* BHRB and regular PMU events share the same privilege state
 	 * filter configuration. BHRB is always recorded along with a
-- 
1.7.11.7

