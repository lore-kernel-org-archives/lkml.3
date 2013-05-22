Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753273Ab3EVFsU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 01:48:20 -0400
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:60411 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751073Ab3EVFsT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 01:48:19 -0400
From: Anshuman Khandual <khandual@linux.vnet.ibm.com>
To: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Cc: michael@ellerman.id.au, mikey@neuling.org
Subject: [PATCH 1/2] powerpc, perf: Ignore separate BHRB privilege state filter request
Date: Wed, 22 May 2013 11:17:46 +0530
Message-Id: <1369201667-9048-2-git-send-email-khandual@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1369201667-9048-1-git-send-email-khandual@linux.vnet.ibm.com>
References: <1369201667-9048-1-git-send-email-khandual@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13052205-3864-0000-0000-000008405CA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Completely ignore BHRB privilege state filter request as we are
already configuring MMCRA register with privilege state filtering
attribute for the accompanying PMU event. This would help achieve
cleaner user space interaction for BHRB.

Signed-off-by: Anshuman Khandual <khandual@linux.vnet.ibm.com>
---
 arch/powerpc/perf/power8-pmu.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/arch/powerpc/perf/power8-pmu.c b/arch/powerpc/perf/power8-pmu.c
index f7d1c4f..8ed323d 100644
--- a/arch/powerpc/perf/power8-pmu.c
+++ b/arch/powerpc/perf/power8-pmu.c
@@ -525,16 +525,17 @@ static u64 power8_bhrb_filter_map(u64 branch_sample_type)
 	u64 pmu_bhrb_filter = 0;
 	u64 br_privilege = branch_sample_type & ONLY_PLM;
 
-	/* BHRB and regular PMU events share the same prvillege state
+	/* BHRB and regular PMU events share the same prvilege state
 	 * filter configuration. BHRB is always recorded along with a
-	 * regular PMU event. So privilege state filter criteria for BHRB
-	 * and the companion PMU events has to be the same. As a default
-	 * "perf record" tool sets all privillege bits ON when no filter
-	 * criteria is provided in the command line. So as along as all
-	 * privillege bits are ON or they are OFF, we are good to go.
+	 * regular PMU event. So privilege state filter criteria for
+	 * the BHRB and the companion PMU events has to be the same.
+	 * Separate BHRB privillege state filter requests would be
+	 * ignored.
 	 */
-	if ((br_privilege != 7) && (br_privilege != 0))
-		return -1;
+
+	if (br_privilege)
+		pr_info("BHRB privilege state filter request %llx ignored\n",
+								br_privilege);
 
 	/* No branch filter requested */
 	if (branch_sample_type & PERF_SAMPLE_BRANCH_ANY)
-- 
1.7.11.7

