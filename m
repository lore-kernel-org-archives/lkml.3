Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752251AbbACC4H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2015 21:56:07 -0500
Received: from mail.kernel.org ([198.145.29.136]:42911 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751998AbbACCz7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2015 21:55:59 -0500
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Taesoo Kim <tsgatesv@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Taesoo kim <taesoo@gatech.edu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 3/4] perf list: Fix --raw-dump option
Date: Fri,  2 Jan 2015 23:55:36 -0300
Message-Id: <1420253737-2488-4-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1420253737-2488-1-git-send-email-acme@kernel.org>
References: <1420253737-2488-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Taesoo Kim <tsgatesv@gmail.com>

Currently, 'perf list --raw-dump' requires extra arguments
(e.g., hw) to invoke, which breaks bash/zsh completion
(perf-completion.sh).

  $ perf list --raw-dump
    Error: unknown option `raw-dump'

     usage: perf list [hw|sw|cache|tracepoint|pmu|event_glob]

After,

  $ perf list --raw-dump
  cpu-cycles instructions cache-references cache-misses ...

Signed-off-by: Taesoo Kim <tsgatesv@gmail.com>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Taesoo kim <taesoo@gatech.edu>
Link: http://lkml.kernel.org/r/1419997015-11071-1-git-send-email-tsgatesv@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-list.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/tools/perf/builtin-list.c b/tools/perf/builtin-list.c
index 011195e38f21..198f3c3aff95 100644
--- a/tools/perf/builtin-list.c
+++ b/tools/perf/builtin-list.c
@@ -19,7 +19,9 @@
 int cmd_list(int argc, const char **argv, const char *prefix __maybe_unused)
 {
 	int i;
-	const struct option list_options[] = {
+	bool raw_dump = false;
+	struct option list_options[] = {
+		OPT_BOOLEAN(0, "raw-dump", &raw_dump, "Dump raw events"),
 		OPT_END()
 	};
 	const char * const list_usage[] = {
@@ -27,11 +29,18 @@ int cmd_list(int argc, const char **argv, const char *prefix __maybe_unused)
 		NULL
 	};
 
+	set_option_flag(list_options, 0, "raw-dump", PARSE_OPT_HIDDEN);
+
 	argc = parse_options(argc, argv, list_options, list_usage,
 			     PARSE_OPT_STOP_AT_NON_OPTION);
 
 	setup_pager();
 
+	if (raw_dump) {
+		print_events(NULL, true);
+		return 0;
+	}
+
 	if (argc == 0) {
 		print_events(NULL, false);
 		return 0;
@@ -53,8 +62,6 @@ int cmd_list(int argc, const char **argv, const char *prefix __maybe_unused)
 			print_hwcache_events(NULL, false);
 		else if (strcmp(argv[i], "pmu") == 0)
 			print_pmu_events(NULL, false);
-		else if (strcmp(argv[i], "--raw-dump") == 0)
-			print_events(NULL, true);
 		else {
 			char *sep = strchr(argv[i], ':'), *s;
 			int sep_idx;
-- 
1.9.3

