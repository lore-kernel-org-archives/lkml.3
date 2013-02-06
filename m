Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751909Ab3BFF5x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 00:57:53 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:51050 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751961Ab3BFF5c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 00:57:32 -0500
X-AuditID: 9c930197-b7ca4ae000006ba8-fe-5111f0c83cde
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        Stephane Eranian <eranian@google.com>, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 2/3] perf sort: Make setup_sorting returns an error code
Date: Wed,  6 Feb 2013 14:57:16 +0900
Message-Id: <1360130237-9963-2-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1360130237-9963-1-git-send-email-namhyung@kernel.org>
References: <1360130237-9963-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Currently the setup_sorting() is called for parsing sort keys and
exits if it failed to add the sort key.  As it's included in libperf
it'd be better returning an error code rather than exiting application
inside of the library.

Suggested-by: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Stephane Eranian <eranian@google.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/builtin-annotate.c |  3 ++-
 tools/perf/builtin-diff.c     |  4 +++-
 tools/perf/builtin-report.c   |  3 ++-
 tools/perf/builtin-top.c      |  3 ++-
 tools/perf/tests/hists_link.c |  3 ++-
 tools/perf/util/sort.c        | 10 ++++++----
 tools/perf/util/sort.h        |  2 +-
 7 files changed, 18 insertions(+), 10 deletions(-)

diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index dc870cf31b79..95a2ad3f043e 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -309,7 +309,8 @@ int cmd_annotate(int argc, const char **argv, const char *prefix __maybe_unused)
 	if (symbol__init() < 0)
 		return -1;
 
-	setup_sorting(annotate_usage, options);
+	if (setup_sorting() < 0)
+		usage_with_options(annotate_usage, options);
 
 	if (argc) {
 		/*
diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
index 4af0b580b046..d207a97a2db1 100644
--- a/tools/perf/builtin-diff.c
+++ b/tools/perf/builtin-diff.c
@@ -605,7 +605,9 @@ int cmd_diff(int argc, const char **argv, const char *prefix __maybe_unused)
 
 	ui_init();
 
-	setup_sorting(diff_usage, options);
+	if (setup_sorting() < 0)
+		usage_with_options(diff_usage, options);
+
 	setup_pager();
 
 	sort_entry__setup_elide(&sort_dso, symbol_conf.dso_list, "dso", NULL);
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 0d221870561a..71d0b0e334be 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -741,7 +741,8 @@ int cmd_report(int argc, const char **argv, const char *prefix __maybe_unused)
 		perf_hpp__init();
 	}
 
-	setup_sorting(report_usage, options);
+	if (setup_sorting() < 0)
+		usage_with_options(report_usage, options);
 
 	/*
 	 * Only in the newt browser we are doing integrated annotation,
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index f561757b1bfa..72f6eb7b4173 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -1129,7 +1129,8 @@ int cmd_top(int argc, const char **argv, const char *prefix __maybe_unused)
 	if (sort_order == default_sort_order)
 		sort_order = "dso,symbol";
 
-	setup_sorting(top_usage, options);
+	if (setup_sorting() < 0)
+		usage_with_options(top_usage, options);
 
 	if (top.use_stdio)
 		use_browser = 0;
diff --git a/tools/perf/tests/hists_link.c b/tools/perf/tests/hists_link.c
index 0afd9223bde7..1be64a6c5daf 100644
--- a/tools/perf/tests/hists_link.c
+++ b/tools/perf/tests/hists_link.c
@@ -449,7 +449,8 @@ int test__hists_link(void)
 		goto out;
 
 	/* default sort order (comm,dso,sym) will be used */
-	setup_sorting(NULL, NULL);
+	if (setup_sorting() < 0)
+		goto out;
 
 	machines__init(&machines);
 
diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index 03cabe5678d0..d8b48827a17e 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -565,23 +565,25 @@ int sort_dimension__add(const char *tok)
 	return -ESRCH;
 }
 
-void setup_sorting(const char * const usagestr[], const struct option *opts)
+int setup_sorting(void)
 {
 	char *tmp, *tok, *str = strdup(sort_order);
+	int ret = 0;
 
 	for (tok = strtok_r(str, ", ", &tmp);
 			tok; tok = strtok_r(NULL, ", ", &tmp)) {
-		int ret = sort_dimension__add(tok);
+		ret = sort_dimension__add(tok);
 		if (ret == -EINVAL) {
 			error("Invalid --sort key: `%s'", tok);
-			usage_with_options(usagestr, opts);
+			break;
 		} else if (ret == -ESRCH) {
 			error("Unknown --sort key: `%s'", tok);
-			usage_with_options(usagestr, opts);
+			break;
 		}
 	}
 
 	free(str);
+	return ret;
 }
 
 void sort_entry__setup_elide(struct sort_entry *self, struct strlist *list,
diff --git a/tools/perf/util/sort.h b/tools/perf/util/sort.h
index e994ad3e9897..b13e56f6ccbe 100644
--- a/tools/perf/util/sort.h
+++ b/tools/perf/util/sort.h
@@ -160,7 +160,7 @@ struct sort_entry {
 extern struct sort_entry sort_thread;
 extern struct list_head hist_entry__sort_list;
 
-void setup_sorting(const char * const usagestr[], const struct option *opts);
+int setup_sorting(void);
 extern int sort_dimension__add(const char *);
 void sort_entry__setup_elide(struct sort_entry *self, struct strlist *list,
 			     const char *list_name, FILE *fp);
-- 
1.7.11.7

