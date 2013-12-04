Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932203Ab3LDKeH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 05:34:07 -0500
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:46739 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932142Ab3LDKd6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 05:33:58 -0500
From: Anshuman Khandual <khandual@linux.vnet.ibm.com>
To: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Cc: michael@ellerman.id.au, mikey@neuling.org, sukadev@linux.vnet.ibm.com,
        eranian@google.com, acme@ghostprotocols.net, ak@linux.intel.com,
        mingo@kernel.org
Subject: [PATCH V4 08/10] powerpc, perf: Enable SW filtering in branch stack sampling framework
Date: Wed,  4 Dec 2013 16:02:40 +0530
Message-Id: <1386153162-11225-9-git-send-email-khandual@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1386153162-11225-1-git-send-email-khandual@linux.vnet.ibm.com>
References: <1386153162-11225-1-git-send-email-khandual@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13120410-5816-0000-0000-00000B30B026
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
	(b) filter_mask		Tracks both (SW and HW) branch filter flags

(2) Event creation

	Kernel will figure out supported BHRB branch filters through a PMU call
	back 'bhrb_filter_map'. This function will find out how many of the
	requested branch filters can be supported in the PMU HW. It will not
	try to invalidate any branch filter combinations. Event creation will not
	error out because of lack of HW based branch filters. Meanwhile it will
	track the overall supported branch filters in the "filter_mask" variable.

	Once the PMU call back returns kernel will process the user branch filter
	request against available SW filters while looking at the "filter_mask".
	During this phase all the branch filters which are still pending from the
	user requested list will have to be supported in SW failing which the
	event creation will error out.

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

	Please refer patch to understand the classification of instructions into
	these branch filter categories.

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
 arch/powerpc/perf/core-book3s.c              | 266 ++++++++++++++++++++++++++-
 arch/powerpc/perf/power8-pmu.c               |   2 +-
 3 files changed, 262 insertions(+), 12 deletions(-)

diff --git a/arch/powerpc/include/asm/perf_event_server.h b/arch/powerpc/include/asm/perf_event_server.h
index 3fd2f1b..846d710 100644
--- a/arch/powerpc/include/asm/perf_event_server.h
+++ b/arch/powerpc/include/asm/perf_event_server.h
@@ -18,6 +18,10 @@
 #define MAX_EVENT_ALTERNATIVES	8
 #define MAX_LIMITED_HWCOUNTERS	2
 
+#define for_each_branch_sample_type(x) \
+        for ((x) = PERF_SAMPLE_BRANCH_USER; \
+             (x) < PERF_SAMPLE_BRANCH_MAX; (x) <<= 1)
+
 /*
  * This struct provides the constants and functions needed to
  * describe the PMU on a particular POWER-family CPU.
@@ -34,7 +38,7 @@ struct power_pmu {
 				unsigned long *valp);
 	int		(*get_alternatives)(u64 event_id, unsigned int flags,
 				u64 alt[]);
-	u64             (*bhrb_filter_map)(u64 branch_sample_type);
+	u64             (*bhrb_filter_map)(u64 branch_sample_type, u64 *filter_mask);
 	void            (*config_bhrb)(u64 pmu_bhrb_filter);
 	void		(*disable_pmc)(unsigned int pmc, unsigned long mmcr[]);
 	int		(*limited_pmc_event)(u64 event_id);
diff --git a/arch/powerpc/perf/core-book3s.c b/arch/powerpc/perf/core-book3s.c
index 2de7d48..54d39a5 100644
--- a/arch/powerpc/perf/core-book3s.c
+++ b/arch/powerpc/perf/core-book3s.c
@@ -48,6 +48,8 @@ struct cpu_hw_events {
 
 	/* BHRB bits */
 	u64				bhrb_hw_filter;	/* BHRB HW branch filter */
+	u64				bhrb_sw_filter;	/* BHRB SW branch filter */
+	u64				filter_mask;	/* Branch filter mask */
 	int				bhrb_users;
 	void				*bhrb_context;
 	struct	perf_branch_stack	bhrb_stack;
@@ -400,6 +402,228 @@ static __u64 power_pmu_bhrb_to(u64 addr)
 	return target - (unsigned long)&instr + addr;
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
+static bool validate_instruction(unsigned int *addr, u64 bhrb_sw_filter)
+{
+	bool result = false;
+
+	if (bhrb_sw_filter & PERF_SAMPLE_BRANCH_ANY_RETURN) {
+
+		/* XL-form instruction */
+		if (instr_is_branch_xlform(*addr)) {
+
+			/* LR should not be set */
+			if (!is_branch_link_set(*addr)) {
+				/*
+			 	 * Conditional and unconditional
+			 	 * branch to LR register.
+			 	 */
+				if (is_xlform_lr(*addr))
+					result = true;
+			}
+		}
+	}
+
+	if (bhrb_sw_filter & PERF_SAMPLE_BRANCH_IND_CALL) {
+		/* XL-form instruction */
+		if (instr_is_branch_xlform(*addr)) {
+
+			/* LR should be set */
+			if (is_branch_link_set(*addr)) {
+				/*
+			 	 * Conditional and unconditional
+			 	 * branch to CTR.
+			 	 */
+				if (is_xlform_ctr(*addr))
+					result = true;
+
+				/*
+			 	 * Conditional and unconditional
+			 	 * branch to LR.
+			 	 */
+				if (is_xlform_lr(*addr))
+					result = true;
+
+				/*
+			 	 * Conditional and unconditional
+			 	 * branch to TAR.
+			 	 */
+				if (is_xlform_tar(*addr))
+					result = true;
+			}
+		}
+	}
+
+	/* Any-form branch */
+	if (bhrb_sw_filter & PERF_SAMPLE_BRANCH_ANY_CALL) {
+		/* LR should be set */
+		if (is_branch_link_set(*addr))
+			result = true;
+	}
+
+	if (bhrb_sw_filter & PERF_SAMPLE_BRANCH_COND) {
+
+		/* I-form instruction - excluded */
+		if (instr_is_branch_iform(*addr))
+			goto out;
+
+		/* B-form or XL-form instruction */
+		if (instr_is_branch_bform(*addr) || instr_is_branch_xlform(*addr))  {
+
+			/* Not branch always  */
+			if (!is_bo_always(*addr)) {
+
+				/* Conditional branch to CTR register */
+				if (is_bo_ctr(*addr))
+					goto out;
+
+				/* CR[BI] conditional branch with static hint */
+				if (is_bo_crbi_off(*addr) || is_bo_crbi_on(*addr)) {
+					if (is_bo_crbi_hint(*addr))
+						goto out;
+				}
+
+				result = true;
+			}
+		}
+	}
+out:
+	return result;
+}
+
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
+		 * Userspace address needs to be
+		 * copied first before analysis.
+		 */
+		pagefault_disable();
+		ret =  __get_user_inatomic(instr, (unsigned int __user *)addr);
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
+		ret = validate_instruction(&instr, bhrb_sw_filter);
+	}
+	return ret;
+}
+
+/*
+ * Validate whether all requested branch filters
+ * are getting processed either in the PMU or in SW.
+ */
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
+		 * taken care during the base PMU configuration.
+		 */
+		if (x == PERF_SAMPLE_BRANCH_USER)
+			continue;
+		if (x == PERF_SAMPLE_BRANCH_KERNEL)
+			continue;
+		if (x == PERF_SAMPLE_BRANCH_HV)
+			continue;
+
+		/*
+		 * Requested filter not available either
+		 * in PMU or in SW.
+		 */
+		if (!(filter_mask & x))
+			return false;
+	}
+	return true;
+}
+
+/*
+ * Required SW based branch filters
+ *
+ * This is called after figuring out what all branch filters the
+ * PMU HW supports for the requested branch filter set. Here we
+ * will go through all the SW implemented branch filters one by
+ * one and pick them up if its not already supported in the PMU.
+ */
+static u64 branch_filter_map(u64 branch_sample_type, u64 pmu_bhrb_filter,
+			     					u64 *filter_mask)
+{
+	u64 branch_sw_filter = 0;
+
+	/* No branch filter requested */
+	if (branch_sample_type & PERF_SAMPLE_BRANCH_ANY) {
+		WARN_ON(pmu_bhrb_filter != 0);
+		WARN_ON(*filter_mask != PERF_SAMPLE_BRANCH_ANY);
+		return branch_sw_filter;
+	}
+
+	/*
+	 * PMU supported branch filters must also be implemented in SW
+	 * in the event when the PMU is unable to process them for some
+	 * reason. This all those branch filters can be satisfied with
+	 * SW implemented filters. But right now, there is now way to
+	 * initimate the user about this decision.
+	 */
+	if (branch_sample_type & PERF_SAMPLE_BRANCH_ANY_CALL) {
+		if (!(pmu_bhrb_filter & PERF_SAMPLE_BRANCH_ANY_CALL)) {
+			branch_sw_filter |= PERF_SAMPLE_BRANCH_ANY_CALL;
+			*filter_mask |= PERF_SAMPLE_BRANCH_ANY_CALL;
+		}
+	}
+
+	if (branch_sample_type & PERF_SAMPLE_BRANCH_COND) {
+		if (!(pmu_bhrb_filter & PERF_SAMPLE_BRANCH_COND)) {
+			branch_sw_filter |= PERF_SAMPLE_BRANCH_COND;
+			*filter_mask |= PERF_SAMPLE_BRANCH_COND;
+		}
+	}
+
+	if (branch_sample_type & PERF_SAMPLE_BRANCH_ANY_RETURN) {
+		if (!(pmu_bhrb_filter & PERF_SAMPLE_BRANCH_ANY_RETURN)) {
+			branch_sw_filter |= PERF_SAMPLE_BRANCH_ANY_RETURN;
+			*filter_mask |= PERF_SAMPLE_BRANCH_ANY_RETURN;
+		}
+	}
+
+	if (branch_sample_type & PERF_SAMPLE_BRANCH_IND_CALL) {
+		if (!(pmu_bhrb_filter & PERF_SAMPLE_BRANCH_IND_CALL)) {
+			branch_sw_filter |= PERF_SAMPLE_BRANCH_IND_CALL;
+			*filter_mask |= PERF_SAMPLE_BRANCH_IND_CALL;
+		}
+	}
+
+	return branch_sw_filter;
+}
+
 /* Processing BHRB entries */
 void power_pmu_bhrb_read(struct cpu_hw_events *cpuhw)
 {
@@ -459,17 +683,29 @@ void power_pmu_bhrb_read(struct cpu_hw_events *cpuhw)
 					addr = 0;
 				}
 				cpuhw->bhrb_entries[u_index].from = addr;
+
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
-
 		}
 	}
 	cpuhw->bhrb_stack.nr = u_index;
@@ -1255,7 +1491,11 @@ nocheck:
 	if (has_branch_stack(event)) {
 		power_pmu_bhrb_enable(event);
 		cpuhw->bhrb_hw_filter = ppmu->bhrb_filter_map(
-					event->attr.branch_sample_type);
+					event->attr.branch_sample_type,
+					&cpuhw->filter_mask);
+		cpuhw->bhrb_sw_filter = branch_filter_map
+					(event->attr.branch_sample_type,
+					cpuhw->bhrb_hw_filter, &cpuhw->filter_mask);
 	}
 
 	perf_pmu_enable(event->pmu);
@@ -1637,10 +1877,16 @@ static int power_pmu_event_init(struct perf_event *event)
 	err = power_check_constraints(cpuhw, events, cflags, n + 1);
 
 	if (has_branch_stack(event)) {
-		cpuhw->bhrb_hw_filter = ppmu->bhrb_filter_map(
-					event->attr.branch_sample_type);
-
-		if(cpuhw->bhrb_hw_filter == -1)
+		cpuhw->bhrb_hw_filter = ppmu->bhrb_filter_map
+				(event->attr.branch_sample_type,
+				&cpuhw->filter_mask);
+		cpuhw->bhrb_sw_filter = branch_filter_map
+				(event->attr.branch_sample_type,
+				cpuhw->bhrb_hw_filter,
+				&cpuhw->filter_mask);
+
+		if(!match_filters(event->attr.branch_sample_type,
+						cpuhw->filter_mask))
 			return -EOPNOTSUPP;
 	}
 
diff --git a/arch/powerpc/perf/power8-pmu.c b/arch/powerpc/perf/power8-pmu.c
index e88b9cb..03c5b8d 100644
--- a/arch/powerpc/perf/power8-pmu.c
+++ b/arch/powerpc/perf/power8-pmu.c
@@ -559,7 +559,7 @@ static int power8_generic_events[] = {
 	[PERF_COUNT_HW_BRANCH_MISSES] =			PM_BR_MPRED_CMPL,
 };
 
-static u64 power8_bhrb_filter_map(u64 branch_sample_type)
+static u64 power8_bhrb_filter_map(u64 branch_sample_type, u64 *filter_mask)
 {
 	u64 pmu_bhrb_filter = 0;
 
-- 
1.7.11.7

