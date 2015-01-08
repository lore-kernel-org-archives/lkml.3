Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754982AbbAHJxZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 04:53:25 -0500
Received: from terminus.zytor.com ([198.137.202.10]:46481 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754094AbbAHJxV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 04:53:21 -0500
Date: Thu, 8 Jan 2015 01:52:51 -0800
From: tip-bot for Taesoo Kim <tipbot@zytor.com>
Message-ID: <tip-b3505208804f3b59150cd77719f01c8b0023a865@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, taesoo@gatech.edu,
        paulus@samba.org, tsgatesv@gmail.com, tglx@linutronix.de,
        hpa@zytor.com, mingo@kernel.org, mingo@redhat.com, namhyung@kernel.org,
        a.p.zijlstra@chello.nl
Reply-To: linux-kernel@vger.kernel.org, paulus@samba.org, taesoo@gatech.edu,
        acme@redhat.com, hpa@zytor.com, tglx@linutronix.de, tsgatesv@gmail.com,
        namhyung@kernel.org, a.p.zijlstra@chello.nl, mingo@redhat.com,
        mingo@kernel.org
In-Reply-To: <1419997015-11071-1-git-send-email-tsgatesv@gmail.com>
References: <1419997015-11071-1-git-send-email-tsgatesv@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf list: Fix --raw-dump option
Git-Commit-ID: b3505208804f3b59150cd77719f01c8b0023a865
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b3505208804f3b59150cd77719f01c8b0023a865
Gitweb:     http://git.kernel.org/tip/b3505208804f3b59150cd77719f01c8b0023a865
Author:     Taesoo Kim <tsgatesv@gmail.com>
AuthorDate: Tue, 30 Dec 2014 22:36:55 -0500
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 2 Jan 2015 23:26:58 -0300

perf list: Fix --raw-dump option

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
index 011195e..198f3c3 100644
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
