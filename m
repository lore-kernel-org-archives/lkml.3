Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754287Ab3H3EZt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 00:25:49 -0400
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:47328 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753201Ab3H3EZl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 00:25:41 -0400
From: Anshuman Khandual <khandual@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Cc: eranian@google.com, acme@redhat.com, michael.neuling@au1.ibm.com,
        ellerman@au1.ibm.com, svaidy@linux.vnet.ibm.com,
        sukadev@linux.vnet.ibm.com
Subject: [PATCH V2 2/6] powerpc, perf: Enable conditional branch filter for POWER8
Date: Fri, 30 Aug 2013 09:54:46 +0530
Message-Id: <1377836690-32710-3-git-send-email-khandual@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1377836690-32710-1-git-send-email-khandual@linux.vnet.ibm.com>
References: <1377836690-32710-1-git-send-email-khandual@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13083004-2674-0000-0000-00000A7177C8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enables conditional branch filter support for POWER8
utilizing MMCRA register based filter and also invalidates
a BHRB branch filter combination involving conditional
branches.

Signed-off-by: Anshuman Khandual <khandual@linux.vnet.ibm.com>
---
 arch/powerpc/perf/power8-pmu.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/powerpc/perf/power8-pmu.c b/arch/powerpc/perf/power8-pmu.c
index 2ee4a70..6e28587 100644
--- a/arch/powerpc/perf/power8-pmu.c
+++ b/arch/powerpc/perf/power8-pmu.c
@@ -580,11 +580,21 @@ static u64 power8_bhrb_filter_map(u64 branch_sample_type)
 	if (branch_sample_type & PERF_SAMPLE_BRANCH_IND_CALL)
 		return -1;
 
+	/* Invalid branch filter combination - HW does not support */
+	if ((branch_sample_type & PERF_SAMPLE_BRANCH_ANY_CALL) &&
+			(branch_sample_type & PERF_SAMPLE_BRANCH_COND))
+		return -1;
+
 	if (branch_sample_type & PERF_SAMPLE_BRANCH_ANY_CALL) {
 		pmu_bhrb_filter |= POWER8_MMCRA_IFM1;
 		return pmu_bhrb_filter;
 	}
 
+	if (branch_sample_type & PERF_SAMPLE_BRANCH_COND) {
+		pmu_bhrb_filter |= POWER8_MMCRA_IFM3;
+		return pmu_bhrb_filter;
+	}
+
 	/* Every thing else is unsupported */
 	return -1;
 }
-- 
1.7.11.7

