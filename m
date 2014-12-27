Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751543AbaL0EXg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2014 23:23:36 -0500
Received: from mail-qc0-f182.google.com ([209.85.216.182]:64438 "EHLO
	mail-qc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751371AbaL0EXf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2014 23:23:35 -0500
From: Taesoo Kim <tsgatesv@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        linux-kernel@vger.kernel.org
Cc: taesoo@gatech.edu, Taesoo Kim <tsgatesv@gmail.com>
Subject: [PATCH 1/1] perf list: Fix --raw-dump option
Date: Fri, 26 Dec 2014 23:29:33 -0500
Message-Id: <1419654573-2340-1-git-send-email-tsgatesv@gmail.com>
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
 tools/perf/builtin-list.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/tools/perf/builtin-list.c b/tools/perf/builtin-list.c
index 011195e..ec76bee 100644
--- a/tools/perf/builtin-list.c
+++ b/tools/perf/builtin-list.c
@@ -16,14 +16,17 @@
 #include "util/pmu.h"
 #include "util/parse-options.h"
 
+static bool raw_dump = false;
+
 int cmd_list(int argc, const char **argv, const char *prefix __maybe_unused)
 {
 	int i;
 	const struct option list_options[] = {
+		OPT_BOOLEAN(0, "raw-dump", &raw_dump, "Dump raw events"),
 		OPT_END()
 	};
 	const char * const list_usage[] = {
-		"perf list [hw|sw|cache|tracepoint|pmu|event_glob]",
+		"perf list [hw|sw|cache|tracepoint|pmu|event_glob|--raw-dump]",
 		NULL
 	};
 
@@ -32,6 +35,11 @@ int cmd_list(int argc, const char **argv, const char *prefix __maybe_unused)
 
 	setup_pager();
 
+	if (raw_dump) {
+		print_events(NULL, true);
+		return 0;
+	}
+
 	if (argc == 0) {
 		print_events(NULL, false);
 		return 0;
@@ -53,8 +61,6 @@ int cmd_list(int argc, const char **argv, const char *prefix __maybe_unused)
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

