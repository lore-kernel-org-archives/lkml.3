Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932174Ab3AYLpH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 06:45:07 -0500
Received: from terminus.zytor.com ([198.137.202.10]:41949 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753657Ab3AYLpE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 06:45:04 -0500
Date: Fri, 25 Jan 2013 03:44:42 -0800
From: tip-bot for Namhyung Kim <namhyung.kim@lge.com>
Message-ID: <tip-fc5871ed0dcf8c76dd1b3b36ff0f70112d2f0e74@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        paulus@samba.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, namhyung.kim@lge.com,
        stefanbeller@googlemail.com, namhyung@kernel.org, jolsa@redhat.com,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, acme@redhat.com,
        a.p.zijlstra@chello.nl, namhyung.kim@lge.com, namhyung@kernel.org,
        stefanbeller@googlemail.com, jolsa@redhat.com, dsahern@gmail.com,
        tglx@linutronix.de
In-Reply-To: <1356599507-14226-10-git-send-email-namhyung@kernel.org>
References: <1356599507-14226-10-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf sort:
  Separate out branch stack specific sort keys
Git-Commit-ID: fc5871ed0dcf8c76dd1b3b36ff0f70112d2f0e74
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 25 Jan 2013 03:44:49 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  fc5871ed0dcf8c76dd1b3b36ff0f70112d2f0e74
Gitweb:     http://git.kernel.org/tip/fc5871ed0dcf8c76dd1b3b36ff0f70112d2f0e74
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Thu, 27 Dec 2012 18:11:46 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 24 Jan 2013 16:40:26 -0300

perf sort: Separate out branch stack specific sort keys

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
