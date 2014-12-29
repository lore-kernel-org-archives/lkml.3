Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751558AbaL2Q5S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2014 11:57:18 -0500
Received: from mail-qg0-f43.google.com ([209.85.192.43]:64360 "EHLO
	mail-qg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751026AbaL2Q5R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2014 11:57:17 -0500
From: Taesoo Kim <tsgatesv@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        linux-kernel@vger.kernel.org
Cc: taesoo@gatech.edu, namhyung@kernel.org, Taesoo Kim <tsgatesv@gmail.com>
Subject: [PATCH 1/1] perf list: Fix --raw-dump option
Date: Mon, 29 Dec 2014 12:02:50 -0500
Message-Id: <1419872570-24843-1-git-send-email-tsgatesv@gmail.com>
X-Mailer: git-send-email 2.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
---
 tools/perf/builtin-list.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/tools/perf/builtin-list.c b/tools/perf/builtin-list.c
index 011195e..3783c28 100644
--- a/tools/perf/builtin-list.c
+++ b/tools/perf/builtin-list.c
@@ -16,10 +16,13 @@
 #include "util/pmu.h"
 #include "util/parse-options.h"
 
+static bool raw_dump = false;
+
 int cmd_list(int argc, const char **argv, const char *prefix __maybe_unused)
 {
 	int i;
-	const struct option list_options[] = {
+	struct option list_options[] = {
+		OPT_BOOLEAN(0, "raw-dump", &raw_dump, "Dump raw events"),
 		OPT_END()
 	};
 	const char * const list_usage[] = {
@@ -27,11 +30,18 @@ int cmd_list(int argc, const char **argv, const char *prefix __maybe_unused)
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
@@ -53,8 +63,6 @@ int cmd_list(int argc, const char **argv, const char *prefix __maybe_unused)
 			print_hwcache_events(NULL, false);
 		else if (strcmp(argv[i], "pmu") == 0)
 			print_pmu_events(NULL, false);
-		else if (strcmp(argv[i], "--raw-dump") == 0)
-			print_events(NULL, true);
 		else {
 			char *sep = strchr(argv[i], ':'), *s;
 			int sep_idx;
-- 
2.1.3

