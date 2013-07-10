Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755197Ab3GJTXS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 15:23:18 -0400
Received: from merlin.infradead.org ([205.233.59.134]:56849 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754820Ab3GJTT4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 15:19:56 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>,
        Andi Kleen <ak@linux.intel.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 11/23] perf tools: Fix -x/--exclude-other option for report command
Date: Wed, 10 Jul 2013 16:19:11 -0300
Message-Id: <1373483963-19277-12-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1373483963-19277-1-git-send-email-acme@infradead.org>
References: <1373483963-19277-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@redhat.com>

Currently we have symbol_conf.exclude_other being set as true every time
so the -x/--exclude-other has nothing to do.

Also we have no way to see the data with symbol_conf.exclude_other being
false which is useful sometimes.

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
"[other]". This could help us estimate how much time we spent in the
sorted data.

In Example 2) the total is just the sorted data.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/n/tip-sg8fvu0fyqohf9ur9l38lhkw@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
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
index f036af9..e06c4f8 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -1130,8 +1130,6 @@ int cmd_top(int argc, const char **argv, const char *prefix __maybe_unused)
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
1.8.1.4

