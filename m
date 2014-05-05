Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756080AbaEEJNF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 05:13:05 -0400
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:33574 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755637AbaEEJLE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 05:11:04 -0400
From: Anshuman Khandual <khandual@linux.vnet.ibm.com>
To: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Cc: michael@ellerman.id.au, mikey@neuling.org, ak@linux.intel.com,
        eranian@google.com, acme@ghostprotocols.net,
        sukadev@linux.vnet.ibm.com, mingo@kernel.org
Subject: [V6 10/11] power8, perf: Adapt BHRB PMU configuration to work with SW filters
Date: Mon,  5 May 2014 14:39:12 +0530
Message-Id: <1399280953-31442-11-git-send-email-khandual@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1399280953-31442-1-git-send-email-khandual@linux.vnet.ibm.com>
References: <1399280953-31442-1-git-send-email-khandual@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14050509-2674-0000-0000-00000E1E2AEC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Powerpc kernel now supports SW based branch filters for book3s systems with some
specifc requirements while dealing with HW supported branch filters in order to
achieve overall OR semantics prevailing in perf branch stack sampling framework.
This patch adapts the BHRB branch filter configuration to meet those protocols.
POWER8 PMU can only handle one HW based branch filter request at any point of time.
For all other combinations PMU will pass it on to the SW.

Signed-off-by: Anshuman Khandual <khandual@linux.vnet.ibm.com>
---
 arch/powerpc/perf/power8-pmu.c | 50 ++++++++++++++++++++++++++++++++++++------
 1 file changed, 43 insertions(+), 7 deletions(-)

diff --git a/arch/powerpc/perf/power8-pmu.c b/arch/powerpc/perf/power8-pmu.c
index 699b1dd..4743bde 100644
--- a/arch/powerpc/perf/power8-pmu.c
+++ b/arch/powerpc/perf/power8-pmu.c
@@ -635,6 +635,16 @@ static int power8_generic_events[] = {
 
 static u64 power8_bhrb_filter_map(u64 branch_sample_type, u64 *bhrb_filter)
 {
+	u64 x, pmu_bhrb_filter;
+	pmu_bhrb_filter = 0;
+	*bhrb_filter = 0;
+
+	/* No branch filter requested */
+	if (branch_sample_type & PERF_SAMPLE_BRANCH_ANY) {
+		*bhrb_filter = PERF_SAMPLE_BRANCH_ANY;
+		return pmu_bhrb_filter;
+	}
+
 	/* BHRB and regular PMU events share the same privilege state
 	 * filter configuration. BHRB is always recorded along with a
 	 * regular PMU event. As the privilege state filter is handled
@@ -645,16 +655,42 @@ static u64 power8_bhrb_filter_map(u64 branch_sample_type, u64 *bhrb_filter)
 	/* Ignore user, kernel, hv bits */
 	branch_sample_type &= ~PERF_SAMPLE_BRANCH_PLM_ALL;
 
-	/* No branch filter requested */
-	if (branch_sample_type == PERF_SAMPLE_BRANCH_ANY)
-		return 0;
+	/*
+	 * P8 does not support oring of PMU HW branch filters. Hence
+	 * if multiple branch filters are requested which includes filters
+	 * supported in PMU, still go ahead and clear the PMU based HW branch
+	 * filter component as in this case all the filters will be processed
+	 * in SW.
+	 */
 
-	if (branch_sample_type == PERF_SAMPLE_BRANCH_ANY_CALL) {
-		return POWER8_MMCRA_IFM1;
+	for_each_branch_sample_type(x) {
+		/* Ignore privilege branch filters */
+		if ((x == PERF_SAMPLE_BRANCH_USER)
+			|| (x == PERF_SAMPLE_BRANCH_KERNEL)
+				|| (x == PERF_SAMPLE_BRANCH_HV))
+			continue;
+
+		if (!(branch_sample_type & x))
+			continue;
+
+		/* Supported individual PMU branch filters */
+		if (branch_sample_type & PERF_SAMPLE_BRANCH_ANY_CALL) {
+			branch_sample_type &= ~PERF_SAMPLE_BRANCH_ANY_CALL;
+			if (branch_sample_type) {
+				/* Multiple branch filters will be processed in SW */
+				pmu_bhrb_filter = 0;
+				*bhrb_filter = 0;
+				return pmu_bhrb_filter;
+			} else {
+				/* Individual branch filter will be processed in PMU */
+				pmu_bhrb_filter |= POWER8_MMCRA_IFM1;
+				*bhrb_filter    |= PERF_SAMPLE_BRANCH_ANY_CALL;
+				return pmu_bhrb_filter;
+			}
+		}
 	}
 
-	/* Every thing else is unsupported */
-	return -1;
+	return pmu_bhrb_filter;
 }
 
 static void power8_config_bhrb(u64 pmu_bhrb_filter)
-- 
1.7.11.7

