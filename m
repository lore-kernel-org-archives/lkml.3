Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760042Ab3JPCIv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 22:08:51 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:45965 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759042Ab3JPCHO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 22:07:14 -0400
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: <linux-kernel@vger.kernel.org>, linuxppc-dev@ozlabs.org,
        Stephane Eranian <eranian@google.com>,
        Michael Ellerman <michaele@au1.ibm.com>,
        Paul Mackerras <paulus@samba.org>,
        Anshuman Khandual <khandual@linux.vnet.ibm.com>
Subject: [PATCH 06/10][v6] powerpc/perf: Export Power8 generic events in sysfs
Date: Tue, 15 Oct 2013 19:06:38 -0700
Message-Id: <1381889202-16826-7-git-send-email-sukadev@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1381889202-16826-1-git-send-email-sukadev@linux.vnet.ibm.com>
References: <1381889202-16826-1-git-send-email-sukadev@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13101602-1344-0000-0000-0000027AD59C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Export generic perf events for Power8 in sysfs.

Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
---
Changelog[v6]:
	[Michael Ellerman] Drop PME_ prefix in macros

 arch/powerpc/perf/power8-events-list.h |   20 +++++++++++++++
 arch/powerpc/perf/power8-pmu.c         |   44 +++++++++++++++++++++++++++-----
 2 files changed, 58 insertions(+), 6 deletions(-)
 create mode 100644 arch/powerpc/perf/power8-events-list.h

diff --git a/arch/powerpc/perf/power8-events-list.h b/arch/powerpc/perf/power8-events-list.h
new file mode 100644
index 0000000..1368547
--- /dev/null
+++ b/arch/powerpc/perf/power8-events-list.h
@@ -0,0 +1,20 @@
+/*
+ * Performance counter support for POWER8 processors.
+ *
+ * Copyright 2013 Sukadev Bhattiprolu, IBM Corporation.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+
+/*
+ * Some power8 event codes.
+ */
+EVENT(PM_CYC,				0x0001e)
+EVENT(PM_GCT_NOSLOT_CYC,		0x100f8)
+EVENT(PM_CMPLU_STALL,			0x4000a)
+EVENT(PM_INST_CMPL,			0x00002)
+EVENT(PM_BRU_FIN,			0x10068)
+EVENT(PM_BR_MPRED_CMPL,			0x400f6)
diff --git a/arch/powerpc/perf/power8-pmu.c b/arch/powerpc/perf/power8-pmu.c
index 2ee4a70..5141d97 100644
--- a/arch/powerpc/perf/power8-pmu.c
+++ b/arch/powerpc/perf/power8-pmu.c
@@ -18,13 +18,13 @@
 /*
  * Some power8 event codes.
  */
-#define PM_CYC				0x0001e
-#define PM_GCT_NOSLOT_CYC		0x100f8
-#define PM_CMPLU_STALL			0x4000a
-#define PM_INST_CMPL			0x00002
-#define PM_BRU_FIN			0x10068
-#define PM_BR_MPRED_CMPL		0x400f6
+#define EVENT(_name, _code)	_name = _code,
 
+enum {
+#include "power8-events-list.h"
+};
+
+#undef EVENT
 
 /*
  * Raw event encoding for POWER8:
@@ -510,6 +510,37 @@ static void power8_disable_pmc(unsigned int pmc, unsigned long mmcr[])
 		mmcr[1] &= ~(0xffUL << MMCR1_PMCSEL_SHIFT(pmc + 1));
 }
 
+GENERIC_EVENT_ATTR(cpu-cyles,			PM_CYC);
+GENERIC_EVENT_ATTR(stalled-cycles-frontend,	PM_GCT_NOSLOT_CYC);
+GENERIC_EVENT_ATTR(stalled-cycles-backend,	PM_CMPLU_STALL);
+GENERIC_EVENT_ATTR(instructions,		PM_INST_CMPL);
+GENERIC_EVENT_ATTR(branch-instructions,		PM_BRU_FIN);
+GENERIC_EVENT_ATTR(branch-misses,		PM_BR_MPRED_CMPL);
+
+#define EVENT(_name, _code)	POWER_EVENT_ATTR(_name, _name);
+#include "power8-events-list.h"
+#undef EVENT
+
+#define EVENT(_name, _code)	POWER_EVENT_PTR(_name),
+
+static struct attribute *power8_events_attr[] = {
+	GENERIC_EVENT_PTR(PM_CYC),
+	GENERIC_EVENT_PTR(PM_GCT_NOSLOT_CYC),
+	GENERIC_EVENT_PTR(PM_CMPLU_STALL),
+	GENERIC_EVENT_PTR(PM_INST_CMPL),
+	GENERIC_EVENT_PTR(PM_BRU_FIN),
+	GENERIC_EVENT_PTR(PM_BR_MPRED_CMPL),
+
+	#include "power8-events-list.h"
+	#undef EVENT
+	NULL
+};
+
+static struct attribute_group power8_pmu_events_group = {
+	.name = "events",
+	.attrs = power8_events_attr,
+};
+
 PMU_FORMAT_ATTR(event,		"config:0-49");
 PMU_FORMAT_ATTR(pmcxsel,	"config:0-7");
 PMU_FORMAT_ATTR(mark,		"config:8");
@@ -546,6 +577,7 @@ struct attribute_group power8_pmu_format_group = {
 
 static const struct attribute_group *power8_pmu_attr_groups[] = {
 	&power8_pmu_format_group,
+	&power8_pmu_events_group,
 	NULL,
 };
 
-- 
1.7.9.5

