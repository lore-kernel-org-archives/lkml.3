Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756193AbaC0ADn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 20:03:43 -0400
Received: from mail-qa0-f52.google.com ([209.85.216.52]:50816 "EHLO
	mail-qa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753695AbaC0ADl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 20:03:41 -0400
From: Ramkumar Ramachandra <artagnon@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>, David Ahern <dsahern@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH] perf list: Replace --raw-dump with parse_options_subcommand()
Date: Wed, 26 Mar 2014 20:04:49 -0400
Message-Id: <1395878689-6981-1-git-send-email-artagnon@gmail.com>
X-Mailer: git-send-email 1.9.0.431.g014438b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While adding usage information, 44d742e (perf list: Add usage,
2013-10-30) broke

  $ perf list --raw-dump

Remove this option, and use parse_options_subcommand() to provide a
'--list-cmds'. The argument to 'perf list' is now treated like a
subcommand. Update the completion script to reflect this change.

Fixes: 44d742e01e6d (perf list: Add usage)
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Ramkumar Ramachandra <artagnon@gmail.com>
---
 tools/perf/builtin-list.c     | 13 +++++++------
 tools/perf/perf-completion.sh |  6 +++---
 2 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/tools/perf/builtin-list.c b/tools/perf/builtin-list.c
index 011195e..4e9e4e3 100644
--- a/tools/perf/builtin-list.c
+++ b/tools/perf/builtin-list.c
@@ -22,13 +22,16 @@ int cmd_list(int argc, const char **argv, const char *prefix __maybe_unused)
 	const struct option list_options[] = {
 		OPT_END()
 	};
-	const char * const list_usage[] = {
-		"perf list [hw|sw|cache|tracepoint|pmu|event_glob]",
+	const char *const list_subcommands[] = { "hw", "sw", "cache", "tracepoint",
+						 "pmu", NULL };
+
+	const char *list_usage[] = {
+		"perf list {hw|sw|cache|tracepoint|pmu|event_glob}",
 		NULL
 	};
 
-	argc = parse_options(argc, argv, list_options, list_usage,
-			     PARSE_OPT_STOP_AT_NON_OPTION);
+	argc = parse_options_subcommand(argc, argv, list_options, list_subcommands,
+					list_usage, PARSE_OPT_STOP_AT_NON_OPTION);
 
 	setup_pager();
 
@@ -53,8 +56,6 @@ int cmd_list(int argc, const char **argv, const char *prefix __maybe_unused)
 			print_hwcache_events(NULL, false);
 		else if (strcmp(argv[i], "pmu") == 0)
 			print_pmu_events(NULL, false);
-		else if (strcmp(argv[i], "--raw-dump") == 0)
-			print_events(NULL, true);
 		else {
 			char *sep = strchr(argv[i], ':'), *s;
 			int sep_idx;
diff --git a/tools/perf/perf-completion.sh b/tools/perf/perf-completion.sh
index ae3a576..a1f867b 100644
--- a/tools/perf/perf-completion.sh
+++ b/tools/perf/perf-completion.sh
@@ -119,10 +119,10 @@ __perf_main ()
 		fi
 	# List possible events for -e option
 	elif [[ $prev == "-e" && "${words[1]}" == @(record|stat|top) ]]; then
-		evts=$($cmd list --raw-dump)
+		evts=$($cmd list --list-cmds)
 		__perfcomp_colon "$evts" "$cur"
-	# List subcommands for 'perf kvm'
-	elif [[ $prev == "kvm" ]]; then
+	# List subcommands for perf commands
+	elif [[ $prev == @(kvm|list) ]]; then
 		subcmds=$($cmd $prev --list-cmds)
 		__perfcomp_colon "$subcmds" "$cur"
 	# List long option names
-- 
1.9.0.431.g014438b

