Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755921AbaEEJLM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 05:11:12 -0400
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:45804 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755520AbaEEJLC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 05:11:02 -0400
From: Anshuman Khandual <khandual@linux.vnet.ibm.com>
To: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Cc: michael@ellerman.id.au, mikey@neuling.org, ak@linux.intel.com,
        eranian@google.com, acme@ghostprotocols.net,
        sukadev@linux.vnet.ibm.com, mingo@kernel.org
Subject: [V6 11/11] powerpc, perf: Enable privilege mode SW branch filters
Date: Mon,  5 May 2014 14:39:13 +0530
Message-Id: <1399280953-31442-12-git-send-email-khandual@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1399280953-31442-1-git-send-email-khandual@linux.vnet.ibm.com>
References: <1399280953-31442-1-git-send-email-khandual@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14050509-5816-0000-0000-00000DD768FA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch enables privilege mode SW branch filters. Also modifies
POWER8 PMU branch filter configuration so that the privilege mode
branch filter implemented as part of base PMU event configuration
is reflected in bhrb filter mask. As a result, the SW will skip and
not try to process the privilege mode branch filters itself.

Signed-off-by: Anshuman Khandual <khandual@linux.vnet.ibm.com>
---
 arch/powerpc/perf/core-book3s.c | 53 +++++++++++++++++++++++++++++++----------
 arch/powerpc/perf/power8-pmu.c  | 13 ++++++++--
 2 files changed, 52 insertions(+), 14 deletions(-)

diff --git a/arch/powerpc/perf/core-book3s.c b/arch/powerpc/perf/core-book3s.c
index a94cc43..297cddb 100644
--- a/arch/powerpc/perf/core-book3s.c
+++ b/arch/powerpc/perf/core-book3s.c
@@ -26,6 +26,9 @@
 #define BHRB_PREDICTION		0x0000000000000001
 #define BHRB_EA			0xFFFFFFFFFFFFFFFCUL
 
+#define POWER_ADDR_USER		0
+#define POWER_ADDR_KERNEL	1
+
 struct cpu_hw_events {
 	int n_events;
 	int n_percpu;
@@ -450,10 +453,10 @@ static bool check_instruction(unsigned int *addr, u64 sw_filter)
  * Access the instruction contained in the address and check
  * whether it complies with the applicable SW branch filters.
  */
-static bool keep_branch(u64 from, u64 sw_filter)
+static bool keep_branch(u64 from, u64 to, u64 sw_filter)
 {
 	unsigned int instr;
-	bool ret;
+	bool to_plm, ret, flag;
 
 	/*
 	 * The "from" branch for every branch record has to go
@@ -463,6 +466,37 @@ static bool keep_branch(u64 from, u64 sw_filter)
 	if (sw_filter == 0)
 		return true;
 
+	to_plm = is_kernel_addr(to) ? POWER_ADDR_KERNEL : POWER_ADDR_USER;
+
+	/*
+	 * Applying privilege mode SW branch filters first on the
+	 * 'to' address makes an AND semantic with the SW generic
+	 * branch filters (OR with each other) being applied on the
+	 * from address there after.
+	 */
+
+	/* Ignore PERF_SAMPLE_BRANCH_HV */
+	sw_filter &= ~PERF_SAMPLE_BRANCH_HV;
+
+	/* Privilege mode branch filters for "TO" address */
+	if (sw_filter & PERF_SAMPLE_BRANCH_PLM_ALL) {
+		flag = false;
+
+		if (sw_filter & PERF_SAMPLE_BRANCH_USER) {
+			if(to_plm == POWER_ADDR_USER)
+				flag = true;
+		}
+
+		if (sw_filter & PERF_SAMPLE_BRANCH_KERNEL) {
+			if(to_plm == POWER_ADDR_KERNEL)
+				flag = true;
+		}
+
+		if (!flag)
+			return false;
+	}
+
+	/* Generic branch filters for "FROM" address */
 	if (is_kernel_addr(from)) {
 		return check_instruction((unsigned int *) from, sw_filter);
 	} else {
@@ -501,15 +535,6 @@ static int all_filters_covered(u64 branch_sample_type, u64 bhrb_filter)
 		if (!(branch_sample_type & x))
 			continue;
 		/*
-		 * Privilege filter requests have been already
-		 * taken care during the base PMU configuration.
-		 */
-		if ((x == PERF_SAMPLE_BRANCH_USER)
-			|| (x == PERF_SAMPLE_BRANCH_KERNEL)
-				|| (x == PERF_SAMPLE_BRANCH_HV))
-			continue;
-
-		/*
 		 * Requested filter not available either
 		 * in PMU or in SW.
 		 */
@@ -520,7 +545,10 @@ static int all_filters_covered(u64 branch_sample_type, u64 bhrb_filter)
 }
 
 /* SW implemented branch filters */
-static unsigned int power_sw_filter[] = { PERF_SAMPLE_BRANCH_ANY_CALL,
+static unsigned int power_sw_filter[] = { PERF_SAMPLE_BRANCH_USER,
+					  PERF_SAMPLE_BRANCH_KERNEL,
+					  PERF_SAMPLE_BRANCH_HV,
+					  PERF_SAMPLE_BRANCH_ANY_CALL,
 					  PERF_SAMPLE_BRANCH_COND,
 					  PERF_SAMPLE_BRANCH_ANY_RETURN,
 					  PERF_SAMPLE_BRANCH_IND_CALL };
@@ -624,6 +652,7 @@ void power_pmu_bhrb_read(struct cpu_hw_events *cpuhw)
 
 		/* Apply SW branch filters and drop the entry if required */
 		if (!keep_branch(cpuhw->bhrb_entries[u_index].from,
+					cpuhw->bhrb_entries[u_index].to,
 						cpuhw->bhrb_sw_filter))
 			u_index--;
 		u_index++;
diff --git a/arch/powerpc/perf/power8-pmu.c b/arch/powerpc/perf/power8-pmu.c
index 4743bde..b6e21da 100644
--- a/arch/powerpc/perf/power8-pmu.c
+++ b/arch/powerpc/perf/power8-pmu.c
@@ -649,9 +649,19 @@ static u64 power8_bhrb_filter_map(u64 branch_sample_type, u64 *bhrb_filter)
 	 * filter configuration. BHRB is always recorded along with a
 	 * regular PMU event. As the privilege state filter is handled
 	 * in the basic PMC configuration of the accompanying regular
-	 * PMU event, we ignore any separate BHRB specific request.
+	 * PMU event, we ignore any separate BHRB specific request. But
+	 * this needs to be communicated with the branch filter mask.
 	 */
 
+	if (branch_sample_type & PERF_SAMPLE_BRANCH_USER)
+		*bhrb_filter |= PERF_SAMPLE_BRANCH_USER;
+
+	if (branch_sample_type & PERF_SAMPLE_BRANCH_KERNEL)
+		*bhrb_filter |= PERF_SAMPLE_BRANCH_KERNEL;
+
+	if (branch_sample_type & PERF_SAMPLE_BRANCH_HV)
+		*bhrb_filter |= PERF_SAMPLE_BRANCH_HV;
+
 	/* Ignore user, kernel, hv bits */
 	branch_sample_type &= ~PERF_SAMPLE_BRANCH_PLM_ALL;
 
@@ -679,7 +689,6 @@ static u64 power8_bhrb_filter_map(u64 branch_sample_type, u64 *bhrb_filter)
 			if (branch_sample_type) {
 				/* Multiple branch filters will be processed in SW */
 				pmu_bhrb_filter = 0;
-				*bhrb_filter = 0;
 				return pmu_bhrb_filter;
 			} else {
 				/* Individual branch filter will be processed in PMU */
-- 
1.7.11.7

