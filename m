Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755904AbaEEJLJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 05:11:09 -0400
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:43360 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755518AbaEEJLC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 05:11:02 -0400
From: Anshuman Khandual <khandual@linux.vnet.ibm.com>
To: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Cc: michael@ellerman.id.au, mikey@neuling.org, ak@linux.intel.com,
        eranian@google.com, acme@ghostprotocols.net,
        sukadev@linux.vnet.ibm.com, mingo@kernel.org
Subject: [V6 06/11] powerpc, perf: Re-arrange PMU based branch filter processing in POWER8
Date: Mon,  5 May 2014 14:39:08 +0530
Message-Id: <1399280953-31442-7-git-send-email-khandual@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1399280953-31442-1-git-send-email-khandual@linux.vnet.ibm.com>
References: <1399280953-31442-1-git-send-email-khandual@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14050509-8878-0000-0000-00000C427D34
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch does some code re-arrangements to make it clear that
it ignores any separate privilege level branch filter request
and does not support any combinations of HW PMU branch filters.

Signed-off-by: Anshuman Khandual <khandual@linux.vnet.ibm.com>
---
 arch/powerpc/perf/power8-pmu.c | 21 +++++++--------------
 1 file changed, 7 insertions(+), 14 deletions(-)

diff --git a/arch/powerpc/perf/power8-pmu.c b/arch/powerpc/perf/power8-pmu.c
index fe2763b..13f47f5 100644
--- a/arch/powerpc/perf/power8-pmu.c
+++ b/arch/powerpc/perf/power8-pmu.c
@@ -635,8 +635,6 @@ static int power8_generic_events[] = {
 
 static u64 power8_bhrb_filter_map(u64 branch_sample_type)
 {
-	u64 pmu_bhrb_filter = 0;
-
 	/* BHRB and regular PMU events share the same privilege state
 	 * filter configuration. BHRB is always recorded along with a
 	 * regular PMU event. As the privilege state filter is handled
@@ -644,20 +642,15 @@ static u64 power8_bhrb_filter_map(u64 branch_sample_type)
 	 * PMU event, we ignore any separate BHRB specific request.
 	 */
 
-	/* No branch filter requested */
-	if (branch_sample_type & PERF_SAMPLE_BRANCH_ANY)
-		return pmu_bhrb_filter;
-
-	/* Invalid branch filter options - HW does not support */
-	if (branch_sample_type & PERF_SAMPLE_BRANCH_ANY_RETURN)
-		return -1;
+	/* Ignore user, kernel, hv bits */
+	branch_sample_type &= ~PERF_SAMPLE_BRANCH_PLM_ALL;
 
-	if (branch_sample_type & PERF_SAMPLE_BRANCH_IND_CALL)
-		return -1;
+	/* No branch filter requested */
+	if (branch_sample_type == PERF_SAMPLE_BRANCH_ANY)
+		return 0;
 
-	if (branch_sample_type & PERF_SAMPLE_BRANCH_ANY_CALL) {
-		pmu_bhrb_filter |= POWER8_MMCRA_IFM1;
-		return pmu_bhrb_filter;
+	if (branch_sample_type == PERF_SAMPLE_BRANCH_ANY_CALL) {
+		return POWER8_MMCRA_IFM1;
 	}
 
 	/* Every thing else is unsupported */
-- 
1.7.11.7

