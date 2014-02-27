Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753034AbaB0Vcc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 16:32:32 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:42138 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752998AbaB0Vc2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 16:32:28 -0500
From: Cody P Schafer <cody@linux.vnet.ibm.com>
To: Linux PPC <linuxppc-dev@lists.ozlabs.org>,
        Cody P Schafer <cody@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Michael Ellerman <michael@ellerman.id.au>, scottwood@freescale.com,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH v3 07/11] powerpc/perf: add a shared interface to get gpci version and capabilities
Date: Thu, 27 Feb 2014 13:05:00 -0800
Message-Id: <1393535105-7528-8-git-send-email-cody@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1393535105-7528-1-git-send-email-cody@linux.vnet.ibm.com>
References: <1393535105-7528-1-git-send-email-cody@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14022721-7182-0000-0000-000009F125EA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This exposes a simple way to grab the firmware provided
collect_priveliged, ga, expanded, and lab capability bits. All of these
bits come in from the same gpci request, so we've exposed all of them.

Only the collect_priveliged bit is really used by the hv-gpci/hv-24x7
code, the other bits are simply exposed in sysfs to inform the user.

Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
---
 arch/powerpc/perf/hv-common.c | 39 +++++++++++++++++++++++++++++++++++++++
 arch/powerpc/perf/hv-common.h | 17 +++++++++++++++++
 2 files changed, 56 insertions(+)
 create mode 100644 arch/powerpc/perf/hv-common.c
 create mode 100644 arch/powerpc/perf/hv-common.h

diff --git a/arch/powerpc/perf/hv-common.c b/arch/powerpc/perf/hv-common.c
new file mode 100644
index 0000000..47e02b3
--- /dev/null
+++ b/arch/powerpc/perf/hv-common.c
@@ -0,0 +1,39 @@
+#include <asm/io.h>
+#include <asm/hvcall.h>
+
+#include "hv-gpci.h"
+#include "hv-common.h"
+
+unsigned long hv_perf_caps_get(struct hv_perf_caps *caps)
+{
+	unsigned long r;
+	struct p {
+		struct hv_get_perf_counter_info_params params;
+		struct cv_system_performance_capabilities caps;
+	} __packed __aligned(sizeof(uint64_t));
+
+	struct p arg = {
+		.params = {
+			.counter_request = cpu_to_be32(
+					CIR_SYSTEM_PERFORMANCE_CAPABILITIES),
+			.starting_index = cpu_to_be32(-1),
+			.counter_info_version_in = 0,
+		}
+	};
+
+	r = plpar_hcall_norets(H_GET_PERF_COUNTER_INFO,
+			       virt_to_phys(&arg), sizeof(arg));
+
+	if (r)
+		return r;
+
+	pr_devel("capability_mask: 0x%x\n", arg.caps.capability_mask);
+
+	caps->version = arg.params.counter_info_version_out;
+	caps->collect_privileged = !!arg.caps.perf_collect_privileged;
+	caps->ga = !!(arg.caps.capability_mask & CV_CM_GA);
+	caps->expanded = !!(arg.caps.capability_mask & CV_CM_EXPANDED);
+	caps->lab = !!(arg.caps.capability_mask & CV_CM_LAB);
+
+	return r;
+}
diff --git a/arch/powerpc/perf/hv-common.h b/arch/powerpc/perf/hv-common.h
new file mode 100644
index 0000000..7e615bd
--- /dev/null
+++ b/arch/powerpc/perf/hv-common.h
@@ -0,0 +1,17 @@
+#ifndef LINUX_POWERPC_PERF_HV_COMMON_H_
+#define LINUX_POWERPC_PERF_HV_COMMON_H_
+
+#include <linux/types.h>
+
+struct hv_perf_caps {
+	u16 version;
+	u16 collect_privileged:1,
+	    ga:1,
+	    expanded:1,
+	    lab:1,
+	    unused:12;
+};
+
+unsigned long hv_perf_caps_get(struct hv_perf_caps *caps);
+
+#endif
-- 
1.9.0

