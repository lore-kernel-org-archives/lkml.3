Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752462AbaHSAIa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 20:08:30 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:33192 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752335AbaHSAI2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 20:08:28 -0400
Date: Mon, 18 Aug 2014 17:08:22 -0700
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: Jiri Olsa <jolsa@redhat.com>, Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH v3] powerpc/perf: Implement get_cpu_str()
Message-ID: <20140819000822.GA9391@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14081900-7182-0000-0000-0000003AC3B6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

powerpc/perf: Implement get_cpu_str()

With a file ~/.cache/pmu-events/004d0100-core.json describing Power8
PMU events we would need to run:

	perf stat \
		--events-file ~/.cache/pmu-events/004d0100-core.json \
		-e PM_CYC sleep 1

With this get_cpu_str(), On Powerpc, we can skip the --events-file option
and run:

	perf stat -e PM_CYC sleep 1

Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
---
Changelog[v3]:
        [Tobias Klauser]: Fix some changelog damage to patch.

Changelog[v2]:
	[Michael Ellerman]: Use PVR instead of AUXV variables

 tools/perf/arch/powerpc/util/header.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/tools/perf/arch/powerpc/util/header.c b/tools/perf/arch/powerpc/util/header.c
index 6c1b8a7..306bf35 100644
--- a/tools/perf/arch/powerpc/util/header.c
+++ b/tools/perf/arch/powerpc/util/header.c
@@ -6,6 +6,7 @@
 
 #include "../../util/header.h"
 #include "../../util/util.h"
+#include "../../util/jevents.h"
 
 #define mfspr(rn)       ({unsigned long rval; \
 			 asm volatile("mfspr %0," __stringify(rn) \
@@ -32,3 +33,14 @@ get_cpuid(char *buffer, size_t sz)
 	}
 	return -1;
 }
+
+char *
+get_cpu_str(void)
+{
+	char *bufp;
+
+	if (asprintf(&bufp, "%.8lx-core", mfspr(SPRN_PVR)) < 0)
+		bufp = NULL;
+
+	return bufp;
+}
-- 
1.8.3.1

