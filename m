Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757515AbaCFACV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 19:02:21 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:57523 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755704AbaCFACQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 19:02:16 -0500
From: Cody P Schafer <cody@linux.vnet.ibm.com>
To: Linux PPC <linuxppc-dev@lists.ozlabs.org>,
        Cody P Schafer <cody@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Michael Ellerman <michael@ellerman.id.au>, scottwood@freescale.com,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH v4 05/11] powerpc/perf: add hv_gpci interface header
Date: Wed,  5 Mar 2014 16:01:04 -0800
Message-Id: <1394064082-6242-6-git-send-email-cody@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1394064082-6242-1-git-send-email-cody@linux.vnet.ibm.com>
References: <1394064082-6242-1-git-send-email-cody@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14030600-5806-0000-0000-000024488F63
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"H_GetPerformanceCounterInfo" (refered to as hv_gpci or just gpci from
here on) is an interface to retrieve specific performance counters and
other data from the hypervisor. All outputs have a fixed format. This
header only describes the portions of the interface that we plan on
using in linux at this time.

Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
---
 arch/powerpc/perf/hv-gpci.h | 73 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 73 insertions(+)
 create mode 100644 arch/powerpc/perf/hv-gpci.h

diff --git a/arch/powerpc/perf/hv-gpci.h b/arch/powerpc/perf/hv-gpci.h
new file mode 100644
index 0000000..b25f460
--- /dev/null
+++ b/arch/powerpc/perf/hv-gpci.h
@@ -0,0 +1,73 @@
+#ifndef LINUX_POWERPC_PERF_HV_GPCI_H_
+#define LINUX_POWERPC_PERF_HV_GPCI_H_
+
+#include <linux/types.h>
+
+/* From the document "H_GetPerformanceCounterInfo Interface" v1.07 */
+
+/* H_GET_PERF_COUNTER_INFO argument */
+struct hv_get_perf_counter_info_params {
+	__be32 counter_request; /* I */
+	__be32 starting_index;  /* IO */
+	__be16 secondary_index; /* IO */
+	__be16 returned_values; /* O */
+	__be32 detail_rc; /* O, only needed when called via *_norets() */
+
+	/*
+	 * O, size each of counter_value element in bytes, only set for version
+	 * >= 0x3
+	 */
+	__be16 cv_element_size;
+
+	/* I, 0 (zero) for versions < 0x3 */
+	__u8 counter_info_version_in;
+
+	/* O, 0 (zero) if version < 0x3. Must be set to 0 when making hcall */
+	__u8 counter_info_version_out;
+	__u8 reserved[0xC];
+	__u8 counter_value[];
+} __packed;
+
+/*
+ * counter info version => fw version/reference (spec version)
+ *
+ * 8 => power8 (1.07)
+ * [7 is skipped by spec 1.07]
+ * 6 => TLBIE (1.07)
+ * 5 => v7r7m0.phyp (1.05)
+ * [4 skipped]
+ * 3 => v7r6m0.phyp (?)
+ * [1,2 skipped]
+ * 0 => v7r{2,3,4}m0.phyp (?)
+ */
+#define COUNTER_INFO_VERSION_CURRENT 0x8
+
+/*
+ * These determine the counter_value[] layout and the meaning of starting_index
+ * and secondary_index.
+ *
+ * Unless otherwise noted, @secondary_index is unused and ignored.
+ */
+enum counter_info_requests {
+
+	/* GENERAL */
+
+	/* @starting_index: must be -1 (to refer to the current partition)
+	 */
+	CIR_SYSTEM_PERFORMANCE_CAPABILITIES = 0X40,
+};
+
+struct cv_system_performance_capabilities {
+	/* If != 0, allowed to collect data from other partitions */
+	__u8 perf_collect_privileged;
+
+	/* These following are only valid if counter_info_version >= 0x3 */
+#define CV_CM_GA       (1 << 7)
+#define CV_CM_EXPANDED (1 << 6)
+#define CV_CM_LAB      (1 << 5)
+	/* remaining bits are reserved */
+	__u8 capability_mask;
+	__u8 reserved[0xE];
+} __packed;
+
+#endif
-- 
1.9.0

