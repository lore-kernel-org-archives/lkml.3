Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967083Ab3DRM1d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 08:27:33 -0400
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:41381 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967362Ab3DRM0i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 08:26:38 -0400
From: Anshuman Khandual <khandual@linux.vnet.ibm.com>
To: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Cc: michael@ellerman.id.au, mikey@neuling.org
Subject: [PATCH V3 4/5] powerpc, perf: Define BHRB generic functions, data and flags for POWER8
Date: Thu, 18 Apr 2013 17:56:15 +0530
Message-Id: <1366287976-3900-5-git-send-email-khandual@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1366287976-3900-1-git-send-email-khandual@linux.vnet.ibm.com>
References: <1366287976-3900-1-git-send-email-khandual@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13041812-8878-0000-0000-000006C17654
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch populates BHRB specific data for power_pmu structure. It
also implements POWER8 specific BHRB filter and configuration functions.

Signed-off-by: Anshuman Khandual <khandual@linux.vnet.ibm.com>
---
 arch/powerpc/perf/power8-pmu.c | 57 +++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 56 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/perf/power8-pmu.c b/arch/powerpc/perf/power8-pmu.c
index 106ae0b..153408c 100644
--- a/arch/powerpc/perf/power8-pmu.c
+++ b/arch/powerpc/perf/power8-pmu.c
@@ -109,6 +109,16 @@
 #define EVENT_IS_MARKED		(EVENT_MARKED_MASK << EVENT_MARKED_SHIFT)
 #define EVENT_PSEL_MASK		0xff	/* PMCxSEL value */
 
+/* MMCRA IFM bits - POWER8 */
+#define	POWER8_MMCRA_IFM1		0x0000000040000000UL
+#define	POWER8_MMCRA_IFM2		0x0000000080000000UL
+#define	POWER8_MMCRA_IFM3		0x00000000C0000000UL
+
+#define ONLY_PLM \
+	(PERF_SAMPLE_BRANCH_USER        |\
+	 PERF_SAMPLE_BRANCH_KERNEL      |\
+	 PERF_SAMPLE_BRANCH_HV)
+
 /*
  * Layout of constraint bits:
  *
@@ -428,6 +438,48 @@ static int power8_generic_events[] = {
 	[PERF_COUNT_HW_BRANCH_MISSES] =			PM_BR_MPRED_CMPL,
 };
 
+static u64 power8_bhrb_filter_map(u64 branch_sample_type)
+{
+	u64 pmu_bhrb_filter = 0;
+	u64 br_privilege = branch_sample_type & ONLY_PLM;
+
+	/* BHRB and regular PMU events share the same prvillege state
+	 * filter configuration. BHRB is always recorded along with a
+	 * regular PMU event. So privilege state filter criteria for BHRB
+	 * and the companion PMU events has to be the same. As a default
+	 * "perf record" tool sets all privillege bits ON when no filter
+	 * criteria is provided in the command line. So as along as all
+	 * privillege bits are ON or they are OFF, we are good to go.
+	 */
+	if ((br_privilege != 7) && (br_privilege != 0))
+		return -1;
+
+	/* No branch filter requested */
+	if (branch_sample_type & PERF_SAMPLE_BRANCH_ANY)
+		return pmu_bhrb_filter;
+
+	/* Invalid branch filter options - HW does not support */
+	if (branch_sample_type & PERF_SAMPLE_BRANCH_ANY_RETURN)
+		return -1;
+
+	if (branch_sample_type & PERF_SAMPLE_BRANCH_IND_CALL)
+		return -1;
+
+	if (branch_sample_type & PERF_SAMPLE_BRANCH_ANY_CALL) {
+		pmu_bhrb_filter |= POWER8_MMCRA_IFM1;
+		return pmu_bhrb_filter;
+	}
+
+	/* Every thing else is unsupported */
+	return -1;
+}
+
+static void power8_config_bhrb(u64 pmu_bhrb_filter)
+{
+	/* Enable BHRB filter in PMU */
+	mtspr(SPRN_MMCRA, (mfspr(SPRN_MMCRA) | pmu_bhrb_filter));
+}
+
 static struct power_pmu power8_pmu = {
 	.name			= "POWER8",
 	.n_counter		= 6,
@@ -435,12 +487,15 @@ static struct power_pmu power8_pmu = {
 	.add_fields		= POWER8_ADD_FIELDS,
 	.test_adder		= POWER8_TEST_ADDER,
 	.compute_mmcr		= power8_compute_mmcr,
+	.config_bhrb		= power8_config_bhrb,
+	.bhrb_filter_map	= power8_bhrb_filter_map,
 	.get_constraint		= power8_get_constraint,
 	.disable_pmc		= power8_disable_pmc,
-	.flags			= PPMU_HAS_SSLOT | PPMU_HAS_SIER,
+	.flags			= PPMU_HAS_SSLOT | PPMU_HAS_SIER | PPMU_BHRB,
 	.n_generic		= ARRAY_SIZE(power8_generic_events),
 	.generic_events		= power8_generic_events,
 	.attr_groups		= power8_pmu_attr_groups,
+	.bhrb_nr		= 32,
 };
 
 static int __init init_power8_pmu(void)
-- 
1.7.11.7

