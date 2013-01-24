Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755816Ab3AXURm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 15:17:42 -0500
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:54092
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755931Ab3AXUIs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 15:08:48 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 48/74] perf sort: Separate out branch stack specific sort keys
Date: Thu, 24 Jan 2013 17:07:57 -0300
Message-Id: <1359058103-31645-49-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.1.361.gec3ae6e
In-Reply-To: <1359058103-31645-1-git-send-email-acme@infradead.org>
References: <1359058103-31645-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Current perf report gets segmentation fault when a branch stack specific
sort key is provided by --sort option to a perf.data file which contains
no branch infomation.  It's because those sort keys reference branch
info of a hist entry unconditionally.  Maybe we can change it checks
whether such branch info is valid or not.  But if the branch stacks are
not recorded, it'd be nop.  Thus it'd be better to make those keys are
unselectable.

This patch separates those keys to a different dimension array, so that
if user passes such a key to a file which has no branch stack will get
following message rather than a segfault.

  Error: Invalid --sort key: `symbol_from'

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Reported-by: Stefan Beller <stefanbeller@googlemail.com>
Acked-by: Jiri Olsa <jolsa@redhat.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1356599507-14226-10-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/sort.c | 64 ++++++++++++++++++++++++++++++++++++++++----------
 tools/perf/util/sort.h |  8 +++++--
 2 files changed, 58 insertions(+), 14 deletions(-)

diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index 39b1ab0..7ad6239 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -480,30 +480,40 @@ struct sort_dimension {
 
 #define DIM(d, n, func) [d] = { .name = n, .entry = &(func) }
 
-static struct sort_dimension sort_dimensions[] = {
+static struct sort_dimension common_sort_dimensions[] = {
 	DIM(SORT_PID, "pid", sort_thread),
 	DIM(SORT_COMM, "comm", sort_comm),
 	DIM(SORT_DSO, "dso", sort_dso),
-	DIM(SORT_DSO_FROM, "dso_from", sort_dso_from),
-	DIM(SORT_DSO_TO, "dso_to", sort_dso_to),
 	DIM(SORT_SYM, "symbol", sort_sym),
-	DIM(SORT_SYM_TO, "symbol_from", sort_sym_from),
-	DIM(SORT_SYM_FROM, "symbol_to", sort_sym_to),
 	DIM(SORT_PARENT, "parent", sort_parent),
 	DIM(SORT_CPU, "cpu", sort_cpu),
-	DIM(SORT_MISPREDICT, "mispredict", sort_mispredict),
 	DIM(SORT_SRCLINE, "srcline", sort_srcline),
 };
 
+#undef DIM
+
+#define DIM(d, n, func) [d - __SORT_BRANCH_STACK] = { .name = n, .entry = &(func) }
+
+static struct sort_dimension bstack_sort_dimensions[] = {
+	DIM(SORT_DSO_FROM, "dso_from", sort_dso_from),
+	DIM(SORT_DSO_TO, "dso_to", sort_dso_to),
+	DIM(SORT_SYM_FROM, "symbol_from", sort_sym_from),
+	DIM(SORT_SYM_TO, "symbol_to", sort_sym_to),
+	DIM(SORT_MISPREDICT, "mispredict", sort_mispredict),
+};
+
+#undef DIM
+
 int sort_dimension__add(const char *tok)
 {
 	unsigned int i;
 
-	for (i = 0; i < ARRAY_SIZE(sort_dimensions); i++) {
-		struct sort_dimension *sd = &sort_dimensions[i];
+	for (i = 0; i < ARRAY_SIZE(common_sort_dimensions); i++) {
+		struct sort_dimension *sd = &common_sort_dimensions[i];
 
 		if (strncasecmp(tok, sd->name, strlen(tok)))
 			continue;
+
 		if (sd->entry == &sort_parent) {
 			int ret = regcomp(&parent_regex, parent_pattern, REG_EXTENDED);
 			if (ret) {
@@ -514,9 +524,7 @@ int sort_dimension__add(const char *tok)
 				return -EINVAL;
 			}
 			sort__has_parent = 1;
-		} else if (sd->entry == &sort_sym ||
-			   sd->entry == &sort_sym_from ||
-			   sd->entry == &sort_sym_to) {
+		} else if (sd->entry == &sort_sym) {
 			sort__has_sym = 1;
 		}
 
@@ -534,6 +542,34 @@ int sort_dimension__add(const char *tok)
 
 		return 0;
 	}
+
+	for (i = 0; i < ARRAY_SIZE(bstack_sort_dimensions); i++) {
+		struct sort_dimension *sd = &bstack_sort_dimensions[i];
+
+		if (strncasecmp(tok, sd->name, strlen(tok)))
+			continue;
+
+		if (sort__branch_mode != 1)
+			return -EINVAL;
+
+		if (sd->entry == &sort_sym_from || sd->entry == &sort_sym_to)
+			sort__has_sym = 1;
+
+		if (sd->taken)
+			return 0;
+
+		if (sd->entry->se_collapse)
+			sort__need_collapse = 1;
+
+		if (list_empty(&hist_entry__sort_list))
+			sort__first_dimension = i + __SORT_BRANCH_STACK;
+
+		list_add_tail(&sd->entry->list, &hist_entry__sort_list);
+		sd->taken = 1;
+
+		return 0;
+	}
+
 	return -ESRCH;
 }
 
@@ -543,7 +579,11 @@ void setup_sorting(const char * const usagestr[], const struct option *opts)
 
 	for (tok = strtok_r(str, ", ", &tmp);
 			tok; tok = strtok_r(NULL, ", ", &tmp)) {
-		if (sort_dimension__add(tok) < 0) {
+		int ret = sort_dimension__add(tok);
+		if (ret == -EINVAL) {
+			error("Invalid --sort key: `%s'", tok);
+			usage_with_options(usagestr, opts);
+		} else if (ret == -ESRCH) {
 			error("Unknown --sort key: `%s'", tok);
 			usage_with_options(usagestr, opts);
 		}
diff --git a/tools/perf/util/sort.h b/tools/perf/util/sort.h
index a1c0d56..e994ad3e 100644
--- a/tools/perf/util/sort.h
+++ b/tools/perf/util/sort.h
@@ -122,18 +122,22 @@ static inline void hist_entry__add_pair(struct hist_entry *he,
 }
 
 enum sort_type {
+	/* common sort keys */
 	SORT_PID,
 	SORT_COMM,
 	SORT_DSO,
 	SORT_SYM,
 	SORT_PARENT,
 	SORT_CPU,
-	SORT_DSO_FROM,
+	SORT_SRCLINE,
+
+	/* branch stack specific sort keys */
+	__SORT_BRANCH_STACK,
+	SORT_DSO_FROM = __SORT_BRANCH_STACK,
 	SORT_DSO_TO,
 	SORT_SYM_FROM,
 	SORT_SYM_TO,
 	SORT_MISPREDICT,
-	SORT_SRCLINE,
 };
 
 /*
-- 
1.8.1.1.361.gec3ae6e

