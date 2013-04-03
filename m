Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762136Ab3DCM02 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 08:26:28 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:48225 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761355Ab3DCM00 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 08:26:26 -0400
X-AuditID: 9c93016f-b7c18ae000002f5f-97-515c1ff0906e
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>,
        Andi Kleen <andi@firstfloor.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH 02/10] perf sort: Separate out memory-specific sort keys
Date: Wed,  3 Apr 2013 21:26:11 +0900
Message-Id: <1364991979-3008-3-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1364991979-3008-1-git-send-email-namhyung@kernel.org>
References: <1364991979-3008-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Since they're used only for perf mem, separate out them to a different
dimension so that normal user cannot access them by any chance.

For global/local weights, I'm not entirely sure to place them into the
memory dimension.  But it's the only user at this time.

Cc: Andi Kleen <andi@firstfloor.org>
Cc: Stephane Eranian <eranian@google.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/builtin-report.c |  2 ++
 tools/perf/util/sort.c      | 39 +++++++++++++++++++++++++++++++--------
 tools/perf/util/sort.h      | 19 +++++++++++--------
 3 files changed, 44 insertions(+), 16 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index c877982a64d3..669405c9b8a2 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -871,6 +871,8 @@ repeat:
 			fprintf(stderr, "branch and mem mode incompatible\n");
 			goto error;
 		}
+		sort__mode = SORT_MODE__MEMORY;
+
 		/*
 		 * if no sort_order is provided, then specify
 		 * branch-mode specific order
diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index a997955085eb..1dbf16949250 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -871,14 +871,6 @@ static struct sort_dimension common_sort_dimensions[] = {
 	DIM(SORT_PARENT, "parent", sort_parent),
 	DIM(SORT_CPU, "cpu", sort_cpu),
 	DIM(SORT_SRCLINE, "srcline", sort_srcline),
-	DIM(SORT_LOCAL_WEIGHT, "local_weight", sort_local_weight),
-	DIM(SORT_GLOBAL_WEIGHT, "weight", sort_global_weight),
-	DIM(SORT_MEM_DADDR_SYMBOL, "symbol_daddr", sort_mem_daddr_sym),
-	DIM(SORT_MEM_DADDR_DSO, "dso_daddr", sort_mem_daddr_dso),
-	DIM(SORT_MEM_LOCKED, "locked", sort_mem_locked),
-	DIM(SORT_MEM_TLB, "tlb", sort_mem_tlb),
-	DIM(SORT_MEM_LVL, "mem", sort_mem_lvl),
-	DIM(SORT_MEM_SNOOP, "snoop", sort_mem_snoop),
 };
 
 #undef DIM
@@ -895,6 +887,21 @@ static struct sort_dimension bstack_sort_dimensions[] = {
 
 #undef DIM
 
+#define DIM(d, n, func) [d - __SORT_MEMORY_MODE] = { .name = n, .entry = &(func) }
+
+static struct sort_dimension memory_sort_dimensions[] = {
+	DIM(SORT_LOCAL_WEIGHT, "local_weight", sort_local_weight),
+	DIM(SORT_GLOBAL_WEIGHT, "weight", sort_global_weight),
+	DIM(SORT_MEM_DADDR_SYMBOL, "symbol_daddr", sort_mem_daddr_sym),
+	DIM(SORT_MEM_DADDR_DSO, "dso_daddr", sort_mem_daddr_dso),
+	DIM(SORT_MEM_LOCKED, "locked", sort_mem_locked),
+	DIM(SORT_MEM_TLB, "tlb", sort_mem_tlb),
+	DIM(SORT_MEM_LVL, "mem", sort_mem_lvl),
+	DIM(SORT_MEM_SNOOP, "snoop", sort_mem_snoop),
+};
+
+#undef DIM
+
 static void __sort_dimension__add(struct sort_dimension *sd, enum sort_type idx)
 {
 	if (sd->taken)
@@ -957,6 +964,22 @@ int sort_dimension__add(const char *tok)
 		return 0;
 	}
 
+	for (i = 0; i < ARRAY_SIZE(memory_sort_dimensions); i++) {
+		struct sort_dimension *sd = &memory_sort_dimensions[i];
+
+		if (strncasecmp(tok, sd->name, strlen(tok)))
+			continue;
+
+		if (sort__mode != SORT_MODE__MEMORY)
+			return -EINVAL;
+
+		if (sd->entry == &sort_mem_daddr_sym)
+			sort__has_sym = 1;
+
+		__sort_dimension__add(sd, i + __SORT_MEMORY_MODE);
+		return 0;
+	}
+
 	return -ESRCH;
 }
 
diff --git a/tools/perf/util/sort.h b/tools/perf/util/sort.h
index 39ff4b86ae84..0232d476da87 100644
--- a/tools/perf/util/sort.h
+++ b/tools/perf/util/sort.h
@@ -138,14 +138,6 @@ enum sort_type {
 	SORT_PARENT,
 	SORT_CPU,
 	SORT_SRCLINE,
-	SORT_LOCAL_WEIGHT,
-	SORT_GLOBAL_WEIGHT,
-	SORT_MEM_DADDR_SYMBOL,
-	SORT_MEM_DADDR_DSO,
-	SORT_MEM_LOCKED,
-	SORT_MEM_TLB,
-	SORT_MEM_LVL,
-	SORT_MEM_SNOOP,
 
 	/* branch stack specific sort keys */
 	__SORT_BRANCH_STACK,
@@ -154,6 +146,17 @@ enum sort_type {
 	SORT_SYM_FROM,
 	SORT_SYM_TO,
 	SORT_MISPREDICT,
+
+	/* memory mode specific sort keys */
+	__SORT_MEMORY_MODE,
+	SORT_LOCAL_WEIGHT = __SORT_MEMORY_MODE,
+	SORT_GLOBAL_WEIGHT,
+	SORT_MEM_DADDR_SYMBOL,
+	SORT_MEM_DADDR_DSO,
+	SORT_MEM_LOCKED,
+	SORT_MEM_TLB,
+	SORT_MEM_LVL,
+	SORT_MEM_SNOOP,
 };
 
 /*
-- 
1.7.11.7

