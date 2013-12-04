Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932267Ab3LDKg0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 05:36:26 -0500
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:56337 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755459Ab3LDKdy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 05:33:54 -0500
From: Anshuman Khandual <khandual@linux.vnet.ibm.com>
To: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Cc: michael@ellerman.id.au, mikey@neuling.org, sukadev@linux.vnet.ibm.com,
        eranian@google.com, acme@ghostprotocols.net, ak@linux.intel.com,
        mingo@kernel.org
Subject: [PATCH V4 02/10] powerpc, perf: Enable conditional branch filter for POWER8
Date: Wed,  4 Dec 2013 16:02:34 +0530
Message-Id: <1386153162-11225-3-git-send-email-khandual@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1386153162-11225-1-git-send-email-khandual@linux.vnet.ibm.com>
References: <1386153162-11225-1-git-send-email-khandual@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13120410-5564-0000-0000-00000AF51F80
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enables conditional branch filter support for POWER8
utilizing MMCRA register based filter and also invalidates
any BHRB branch filter combination.

Signed-off-by: Anshuman Khandual <khandual@linux.vnet.ibm.com>
---
 arch/powerpc/perf/power8-pmu.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/powerpc/perf/power8-pmu.c b/arch/powerpc/perf/power8-pmu.c
index a3f7abd..e88b9cb 100644
--- a/arch/powerpc/perf/power8-pmu.c
+++ b/arch/powerpc/perf/power8-pmu.c
@@ -586,6 +586,16 @@ static u64 power8_bhrb_filter_map(u64 branch_sample_type)
 		return pmu_bhrb_filter;
 	}
 
+	if (branch_sample_type & PERF_SAMPLE_BRANCH_COND) {
+		pmu_bhrb_filter |= POWER8_MMCRA_IFM3;
+		return pmu_bhrb_filter;
+	}
+
+	/* PMU does not support ANY combination of HW BHRB filters */
+	if ((branch_sample_type & PERF_SAMPLE_BRANCH_ANY_CALL) &&
+			(branch_sample_type & PERF_SAMPLE_BRANCH_COND))
+		return -1;
+
 	/* Every thing else is unsupported */
 	return -1;
 }
-- 
1.7.11.7

