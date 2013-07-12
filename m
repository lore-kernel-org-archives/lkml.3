Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757559Ab3GLIvZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 04:51:25 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54801 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757462Ab3GLIvW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 04:51:22 -0400
Date: Fri, 12 Jul 2013 01:50:56 -0700
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-sg8fvu0fyqohf9ur9l38lhkw@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        ak@linux.intel.com, dsahern@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        dsahern@gmail.com, ak@linux.intel.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com, mingo@elte.hu
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf tools: Fix -x/
 --exclude-other option for report command
Git-Commit-ID: 0276c22a3f22b7f6696fa07b0a77635726b2c0fd
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 12 Jul 2013 01:51:03 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0276c22a3f22b7f6696fa07b0a77635726b2c0fd
Gitweb:     http://git.kernel.org/tip/0276c22a3f22b7f6696fa07b0a77635726b2c0fd
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Mon, 10 Jun 2013 08:21:21 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 8 Jul 2013 17:38:53 -0300

perf tools: Fix -x/--exclude-other option for report command

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
