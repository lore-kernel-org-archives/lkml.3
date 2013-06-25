Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751426Ab3FYLyv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 07:54:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38483 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750830Ab3FYLyt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 07:54:49 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Andi Kleen <ak@linux.intel.com>, David Ahern <dsahern@gmail.com>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 2/5] perf tools: Fix -x/--exclude-other option for report command
Date: Tue, 25 Jun 2013 13:54:10 +0200
Message-Id: <1372161253-22081-3-git-send-email-jolsa@redhat.com>
In-Reply-To: <1372161253-22081-1-git-send-email-jolsa@redhat.com>
References: <1372161253-22081-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently we have symbol_conf.exclude_other being set as true
every time so the -x/--exclude-other has nothing to do. Also
we have no way to see the data with symbol_conf.exclude_other
being false which is useful sometimes.

Fixing it by making symbol_conf.exclude_other false by default.

1) Example without -x option:

  $ perf report -i perf.data.delete -p perf_session__delete -s parent

  +  99.91%  [other]
  +   0.08%  perf_session__delete
  +   0.00%  perf_session__delete_dead_threads
  +   0.00%  perf_session__delete_threads

2) Example with -x option:

  $ ./perf report -i perf.data.delete -p perf_session__delete -s parent -x

  +  96.22%  perf_session__delete
  +   1.89%  perf_session__delete_dead_threads
  +   1.89%  perf_session__delete_threads

In Example 1) we get the sorted out data together with the rest
"[other]". This could help us estimate how much time we spent
in the sorted data.

In Example 2) the total is just the sorted data.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Stephane Eranian <eranian@google.com>
---
 tools/perf/builtin-diff.c   | 1 -
 tools/perf/builtin-report.c | 3 +--
 tools/perf/builtin-top.c    | 2 --
 tools/perf/util/symbol.c    | 1 -
 4 files changed, 1 insertion(+), 6 deletions(-)

diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
index da8f8eb..0aac5f3 100644
--- a/tools/perf/builtin-diff.c
+++ b/tools/perf/builtin-diff.c
@@ -607,7 +607,6 @@ int cmd_diff(int argc, const char **argv, const char *prefix __maybe_unused)
 		input_new = "perf.data.guest";
 	}
 
-	symbol_conf.exclude_other = false;
 	if (symbol__init() < 0)
 		return -1;
 
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index ca98d34..3662047 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -939,8 +939,7 @@ repeat:
 		 */
 		if (!strstr(sort_order, "parent"))
 			sort_parent.elide = 1;
-	} else
-		symbol_conf.exclude_other = false;
+	}
 
 	if (argc) {
 		/*
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index b03bb9a..a237059 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -1139,8 +1139,6 @@ int cmd_top(int argc, const char **argv, const char *prefix __maybe_unused)
 	if (top.evlist == NULL)
 		return -ENOMEM;
 
-	symbol_conf.exclude_other = false;
-
 	argc = parse_options(argc, argv, options, top_usage, 0);
 	if (argc)
 		usage_with_options(top_usage, options);
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 8cf3b54..d5528e1 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -32,7 +32,6 @@ int vmlinux_path__nr_entries;
 char **vmlinux_path;
 
 struct symbol_conf symbol_conf = {
-	.exclude_other	  = true,
 	.use_modules	  = true,
 	.try_vmlinux_path = true,
 	.annotate_src	  = true,
-- 
1.7.11.7

