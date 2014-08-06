Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755068AbaHFATA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 20:19:00 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:47925 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751527AbaHFAS7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 20:18:59 -0400
Date: Tue, 5 Aug 2014 17:17:55 -0700
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: jolsa@redhat.com
Cc: andi@firstfloor.org, Michael Ellerman <mpe@ellerman.id.au>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] powerpc/perf: Implement get_cpu_str()
Message-ID: <20140806001754.GA28735@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14080600-9332-0000-0000-0000019A8346
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

powerpc/perf: Implement get_cpu_str()

With a file like ~/.cache/pmu-events/004d0100-core.json describing
Power8 PMU events, we would need to run:

	perf stat \
		--events-file ~/.cache/pmu-events/004d0100-core.json \
		-e PM_CYC sleep 1

With this get_cpu_str(), on Powerpc, we can skip the --events-file option
and run:

	perf stat -e PM_CYC sleep 1

Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
---
Note: This patch is based on Andi Kleen's recent patchset

	https://lkml.org/lkml/2014/7/30/693

Changelog[v2]:
	[Michael Ellerman]: Use PVR instead of AUXV variables

 tools/perf/arch/powerpc/util/header.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/tools/perf/arch/powerpc/util/header.c b/tools/perf/arch/powerpc/util/header.c
index 6c1b8a7..1bb400e8 100644
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
Changelog[v2]:
	[Michael Ellerman]: Use PVR instead of AUXV variables

+        char *bufp;
+
+        if (asprintf(&bufp, "%.8lx-core", mfspr(SPRN_PVR)) < 0)
+		bufp = NULL;
+
+        return bufp;
+}
-- 
1.8.3.1

