Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932135Ab3LDKd5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 05:33:57 -0500
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:47535 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755522Ab3LDKdz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 05:33:55 -0500
From: Anshuman Khandual <khandual@linux.vnet.ibm.com>
To: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Cc: michael@ellerman.id.au, mikey@neuling.org, sukadev@linux.vnet.ibm.com,
        eranian@google.com, acme@ghostprotocols.net, ak@linux.intel.com,
        mingo@kernel.org
Subject: [PATCH V4 09/10] power8, perf: Change BHRB branch filter configuration
Date: Wed,  4 Dec 2013 16:02:41 +0530
Message-Id: <1386153162-11225-10-git-send-email-khandual@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1386153162-11225-1-git-send-email-khandual@linux.vnet.ibm.com>
References: <1386153162-11225-1-git-send-email-khandual@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13120410-2000-0000-0000-00000EC96E78
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Powerpc kernel now supports SW based branch filters for book3s systems with some
specifc requirements while dealing with HW supported branch filters in order to
achieve overall OR semantics prevailing in perf branch stack sampling framework.
This patch adapts the BHRB branch filter configuration to meet those protocols.
POWER8 PMU does support 3 branch filters (out of which two are getting used in
perf branch stack) which are mutually exclussive and cannot be ORed with each
other. This implies that PMU can only handle one HW based branch filter request
at any point of time. For all other combinations PMU will pass it on to the SW.

Also the combination of PERF_SAMPLE_BRANCH_ANY_CALL and PERF_SAMPLE_BRANCH_COND
can now be handled in SW, hence we dont error them out anymore.

Signed-off-by: Anshuman Khandual <khandual@linux.vnet.ibm.com>
---
 arch/powerpc/perf/power8-pmu.c | 73 +++++++++++++++++++++++++++++++-----------
 1 file changed, 54 insertions(+), 19 deletions(-)

diff --git a/arch/powerpc/perf/power8-pmu.c b/arch/powerpc/perf/power8-pmu.c
index 03c5b8d..6021349 100644
--- a/arch/powerpc/perf/power8-pmu.c
+++ b/arch/powerpc/perf/power8-pmu.c
@@ -561,7 +561,56 @@ static int power8_generic_events[] = {
 
 static u64 power8_bhrb_filter_map(u64 branch_sample_type, u64 *filter_mask)
 {
-	u64 pmu_bhrb_filter = 0;
+	u64 x, tmp, pmu_bhrb_filter = 0;
+	*filter_mask = 0;
+
+	/* No branch filter requested */
+	if (branch_sample_type & PERF_SAMPLE_BRANCH_ANY) {
+		*filter_mask = PERF_SAMPLE_BRANCH_ANY;
+		return pmu_bhrb_filter;
+	}
+
+	/*
+	 * P8 does not support oring of PMU HW branch filters. Hence
+	 * if multiple branch filters are requested which includes filters
+	 * supported in PMU, still go ahead and clear the PMU based HW branch
+	 * filter component as in this case all the filters will be processed
+ 	 * in SW.
+	 */
+	tmp = branch_sample_type;
+
+	/* Remove privilege filters before comparison */
+	tmp &= ~PERF_SAMPLE_BRANCH_USER;
+	tmp &= ~PERF_SAMPLE_BRANCH_KERNEL;
+	tmp &= ~PERF_SAMPLE_BRANCH_HV;
+
+	for_each_branch_sample_type(x) {
+		/* Ignore privilege requests */
+		if ((x == PERF_SAMPLE_BRANCH_USER) || (x == PERF_SAMPLE_BRANCH_KERNEL) || (x == PERF_SAMPLE_BRANCH_HV))
+			continue;
+
+		if (!(tmp & x))
+			continue;
+
+               /* Supported HW PMU filters */
+		if (tmp & PERF_SAMPLE_BRANCH_ANY_CALL) {
+			tmp &= ~PERF_SAMPLE_BRANCH_ANY_CALL;
+			if (tmp) {
+				pmu_bhrb_filter = 0;
+				*filter_mask = 0;
+				return pmu_bhrb_filter;
+			}
+		}
+
+		if (tmp & PERF_SAMPLE_BRANCH_COND) {
+			tmp &= ~PERF_SAMPLE_BRANCH_COND;
+			if (tmp) {
+				pmu_bhrb_filter = 0;
+				*filter_mask = 0;
+				return pmu_bhrb_filter;
+			}
+		}
+	}
 
 	/* BHRB and regular PMU events share the same privilege state
 	 * filter configuration. BHRB is always recorded along with a
@@ -570,34 +619,20 @@ static u64 power8_bhrb_filter_map(u64 branch_sample_type, u64 *filter_mask)
 	 * PMU event, we ignore any separate BHRB specific request.
 	 */
 
-	/* No branch filter requested */
-	if (branch_sample_type & PERF_SAMPLE_BRANCH_ANY)
-		return pmu_bhrb_filter;
-
-	/* Invalid branch filter options - HW does not support */
-	if (branch_sample_type & PERF_SAMPLE_BRANCH_ANY_RETURN)
-		return -1;
-
-	if (branch_sample_type & PERF_SAMPLE_BRANCH_IND_CALL)
-		return -1;
-
+	/* Supported individual branch filters */
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
 
-	/* PMU does not support ANY combination of HW BHRB filters */
-	if ((branch_sample_type & PERF_SAMPLE_BRANCH_ANY_CALL) &&
-			(branch_sample_type & PERF_SAMPLE_BRANCH_COND))
-		return -1;
-
-	/* Every thing else is unsupported */
-	return -1;
+	return pmu_bhrb_filter;
 }
 
 static void power8_config_bhrb(u64 pmu_bhrb_filter)
-- 
1.7.11.7

