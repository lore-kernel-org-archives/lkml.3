Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934787Ab3E3QLh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 12:11:37 -0400
Received: from merlin.infradead.org ([205.233.59.134]:50995 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934608Ab3E3QCS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 12:02:18 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>, Andi Kleen <andi@firstfloor.org>,
        David Ahern <dsahern@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 07/66] perf sort: Separate out memory-specific sort keys
Date: Thu, 30 May 2013 19:00:40 +0300
Message-Id: <1369929699-8724-8-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1369929699-8724-1-git-send-email-acme@infradead.org>
References: <1369929699-8724-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Since they're used only for perf mem, separate out them to a different
dimension so that normal user cannot access them by any chance.

For global/local weights, I'm not entirely sure to place them into the
memory dimension.  But it's the only user at this time.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1364991979-3008-3-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-report.c |  2 ++
 tools/perf/util/sort.c      | 39 +++++++++++++++++++++++++++++++--------
 tools/perf/util/sort.h      | 19 +++++++++++--------
 3 files changed, 44 insertions(+), 16 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index c877982..669405c 100644
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
index a997955..1dbf169 100644
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
index 39ff4b8..0232d47 100644
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
1.8.1.4

