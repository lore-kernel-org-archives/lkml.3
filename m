Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761447Ab3EAPQs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 11:16:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40896 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756287Ab3EAPQf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 11:16:35 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andi Kleen <andi@firstfloor.org>, David Ahern <dsahern@gmail.com>,
        Ulrich Drepper <drepper@gmail.com>, Will Deacon <will.deacon@arm.com>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 8/8] perf list: List formulas counters
Date: Wed,  1 May 2013 17:15:46 +0200
Message-Id: <1367421346-18257-9-git-send-email-jolsa@redhat.com>
In-Reply-To: <1367421346-18257-1-git-send-email-jolsa@redhat.com>
References: <1367421346-18257-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make default formulas appear in 'perf list' command output
with [Formula counter].

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ulrich Drepper <drepper@gmail.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Stephane Eranian <eranian@google.com>
---
 tools/perf/builtin-list.c      |  3 +++
 tools/perf/util/formula.c      | 34 ++++++++++++++++++++++++++++++++++
 tools/perf/util/formula.h      |  2 ++
 tools/perf/util/parse-events.c |  3 +++
 4 files changed, 42 insertions(+)

diff --git a/tools/perf/builtin-list.c b/tools/perf/builtin-list.c
index 1948ece..71e6d1f 100644
--- a/tools/perf/builtin-list.c
+++ b/tools/perf/builtin-list.c
@@ -13,6 +13,7 @@
 
 #include "util/parse-events.h"
 #include "util/cache.h"
+#include "util/formula.h"
 
 int cmd_list(int argc, const char **argv, const char *prefix __maybe_unused)
 {
@@ -37,6 +38,8 @@ int cmd_list(int argc, const char **argv, const char *prefix __maybe_unused)
 			else if (strcmp(argv[i], "cache") == 0 ||
 				 strcmp(argv[i], "hwcache") == 0)
 				print_hwcache_events(NULL, false);
+			else if (strcmp(argv[i], "formulas") == 0)
+				print_formulas();
 			else if (strcmp(argv[i], "--raw-dump") == 0)
 				print_events(NULL, true);
 			else {
diff --git a/tools/perf/util/formula.c b/tools/perf/util/formula.c
index b9d95b2..71ae117 100644
--- a/tools/perf/util/formula.c
+++ b/tools/perf/util/formula.c
@@ -564,3 +564,37 @@ int perf_formula__preload(struct perf_formula *f)
 
 	return ret ? ret : perf_formula__preload_arch(f);
 }
+
+static int print_set_cb(struct perf_formula_set *set, void *data)
+{
+	bool *printed = (bool *) data;
+	char name[100];
+
+	scnprintf(name, 100, "formula-%s", set->name);
+	printf("  %-50s [Formula counter]\n", name);
+
+	if (!*printed)
+		*printed = true;
+
+	return CB_NEXT;
+}
+
+void print_formulas(void)
+{
+	struct perf_formula f;
+	bool printed = false;
+
+	perf_formula__init(&f);
+
+	if (perf_formula__preload(&f)) {
+		pr_err("formula: failed to preload formulas\n");
+		return;
+	}
+
+	printf("\n");
+
+	for_each_set(&f, print_set_cb, &printed);
+
+	if (printed)
+		printf("\n");
+}
diff --git a/tools/perf/util/formula.h b/tools/perf/util/formula.h
index b6437d8..5288bc6 100644
--- a/tools/perf/util/formula.h
+++ b/tools/perf/util/formula.h
@@ -137,4 +137,6 @@ double perf_formula_expr__resolve(struct perf_formula_expr *expr,
 
 int perf_formula__preload(struct perf_formula *f);
 int perf_formula__preload_arch(struct perf_formula *f);
+
+void print_formulas(void);
 #endif /* __PERF_FORMULA */
diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index fe0a554..405f192 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -15,6 +15,7 @@
 #define YY_EXTRA_TYPE int
 #include "parse-events-flex.h"
 #include "pmu.h"
+#include "formula.h"
 
 #define MAX_NAME_LEN 100
 
@@ -1133,6 +1134,8 @@ void print_events(const char *event_glob, bool name_only)
 
 	print_hwcache_events(event_glob, name_only);
 
+	print_formulas();
+
 	if (event_glob != NULL)
 		return;
 
-- 
1.7.11.7

