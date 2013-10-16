Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759956Ab3JPG6H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 02:58:07 -0400
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:35598 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754374Ab3JPG6C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 02:58:02 -0400
From: Anshuman Khandual <khandual@linux.vnet.ibm.com>
To: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Cc: eranian@google.com, michaele@au1.ibm.com, mikey@neuling.org,
        sukadev@linux.vnet.ibm.com
Subject: [V3 10/10] powerpc, perf: Cleanup SW branch filter list look up
Date: Wed, 16 Oct 2013 12:26:57 +0530
Message-Id: <1381906617-11392-11-git-send-email-khandual@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1381906617-11392-1-git-send-email-khandual@linux.vnet.ibm.com>
References: <1381906617-11392-1-git-send-email-khandual@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13101606-9574-0000-0000-00000A1842C1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds enumeration for all available SW branch filters
in powerpc book3s code and also streamlines the look for the
SW branch filter entries while trying to figure out which all
branch filters can be supported in SW.

Signed-off-by: Anshuman Khandual <khandual@linux.vnet.ibm.com>
---
 arch/powerpc/perf/core-book3s.c | 38 +++++++++++++-------------------------
 1 file changed, 13 insertions(+), 25 deletions(-)

diff --git a/arch/powerpc/perf/core-book3s.c b/arch/powerpc/perf/core-book3s.c
index f983334..ec2dd61 100644
--- a/arch/powerpc/perf/core-book3s.c
+++ b/arch/powerpc/perf/core-book3s.c
@@ -566,6 +566,12 @@ static int match_filters(u64 branch_sample_type, u64 filter_mask)
 	return true;
 }
 
+/* SW implemented branch filters */
+static unsigned int power_sw_filter[] =	      { PERF_SAMPLE_BRANCH_ANY_CALL,
+						PERF_SAMPLE_BRANCH_COND,
+						PERF_SAMPLE_BRANCH_ANY_RETURN,
+						PERF_SAMPLE_BRANCH_IND_CALL };
+
 /*
  * Required SW based branch filters
  *
@@ -578,6 +584,7 @@ static u64 branch_filter_map(u64 branch_sample_type, u64 pmu_bhrb_filter,
 			     					u64 *filter_mask)
 {
 	u64 branch_sw_filter = 0;
+	unsigned int i;
 
 	/* No branch filter requested */
 	if (branch_sample_type & PERF_SAMPLE_BRANCH_ANY) {
@@ -593,34 +600,15 @@ static u64 branch_filter_map(u64 branch_sample_type, u64 pmu_bhrb_filter,
 	 * SW implemented filters. But right now, there is now way to
 	 * initimate the user about this decision.
 	 */
-	if (branch_sample_type & PERF_SAMPLE_BRANCH_ANY_CALL) {
-		if (!(pmu_bhrb_filter & PERF_SAMPLE_BRANCH_ANY_CALL)) {
-			branch_sw_filter |= PERF_SAMPLE_BRANCH_ANY_CALL;
-			*filter_mask |= PERF_SAMPLE_BRANCH_ANY_CALL;
-		}
-	}
-
-	if (branch_sample_type & PERF_SAMPLE_BRANCH_COND) {
-		if (!(pmu_bhrb_filter & PERF_SAMPLE_BRANCH_COND)) {
-			branch_sw_filter |= PERF_SAMPLE_BRANCH_COND;
-			*filter_mask |= PERF_SAMPLE_BRANCH_COND;
-		}
-	}
 
-	if (branch_sample_type & PERF_SAMPLE_BRANCH_ANY_RETURN) {
-		if (!(pmu_bhrb_filter & PERF_SAMPLE_BRANCH_ANY_RETURN)) {
-			branch_sw_filter |= PERF_SAMPLE_BRANCH_ANY_RETURN;
-			*filter_mask |= PERF_SAMPLE_BRANCH_ANY_RETURN;
-		}
-	}
-
-	if (branch_sample_type & PERF_SAMPLE_BRANCH_IND_CALL) {
-		if (!(pmu_bhrb_filter & PERF_SAMPLE_BRANCH_IND_CALL)) {
-			branch_sw_filter |= PERF_SAMPLE_BRANCH_IND_CALL;
-			*filter_mask |= PERF_SAMPLE_BRANCH_IND_CALL;
+	for (i = 0; i < ARRAY_SIZE(power_sw_filter); i++) {
+		if (branch_sample_type & power_sw_filter[i]) {
+			if (!(pmu_bhrb_filter & power_sw_filter[i])) {
+				branch_sw_filter |= power_sw_filter[i];
+				*filter_mask |= power_sw_filter[i];
+			}
 		}
 	}
-
 	return branch_sw_filter;
 }
 
-- 
1.7.11.7

