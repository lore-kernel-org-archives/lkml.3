Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758846Ab3BFWFT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 17:05:19 -0500
Received: from terminus.zytor.com ([198.137.202.10]:37286 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758648Ab3BFWFP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 17:05:15 -0500
Date: Wed, 6 Feb 2013 14:04:43 -0800
From: tip-bot for Namhyung Kim <namhyung.kim@lge.com>
Message-ID: <tip-553099857702bb77e541c47bde47f6863834d2e2@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        paulus@samba.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, acme@ghostprotocols.net, namhyung.kim@lge.com,
        namhyung@kernel.org, jolsa@redhat.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, acme@redhat.com,
        a.p.zijlstra@chello.nl, acme@ghostprotocols.net, namhyung.kim@lge.com,
        tglx@linutronix.de, namhyung@kernel.org, jolsa@redhat.com
In-Reply-To: <1360130237-9963-2-git-send-email-namhyung@kernel.org>
References: <1360130237-9963-2-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf sort:
  Make setup_sorting returns an error code
Git-Commit-ID: 553099857702bb77e541c47bde47f6863834d2e2
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 06 Feb 2013 14:04:52 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  553099857702bb77e541c47bde47f6863834d2e2
Gitweb:     http://git.kernel.org/tip/553099857702bb77e541c47bde47f6863834d2e2
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Wed, 6 Feb 2013 14:57:16 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 6 Feb 2013 18:09:26 -0300

perf sort: Make setup_sorting returns an error code

Currently the setup_sorting() is called for parsing sort keys and exits
if it failed to add the sort key.  As it's included in libperf it'd be
better returning an error code rather than exiting application inside of
the library.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Suggested-by: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1360130237-9963-2-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
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
index dc870cf..95a2ad3 100644
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
index 4af0b58..d207a97 100644
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
index 91555d4..96b5a7f 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -751,7 +751,8 @@ repeat:
 
 	}
 
-	setup_sorting(report_usage, options);
+	if (setup_sorting() < 0)
+		usage_with_options(report_usage, options);
 
 	/*
 	 * Only in the newt browser we are doing integrated annotation,
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index f561757..72f6eb7 100644
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
index 0afd922..1be64a6 100644
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
index 03cabe5..d8b4882 100644
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
index e994ad3e..b13e56f6 100644
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
