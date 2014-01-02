Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751548AbaABK6c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 05:58:32 -0500
Received: from mail-pd0-f179.google.com ([209.85.192.179]:60415 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750748AbaABK63 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 05:58:29 -0500
From: Ramkumar Ramachandra <artagnon@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: David Ahern <dsahern@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 3/5] perf lock: introduce --list-cmds
Date: Thu,  2 Jan 2014 16:28:48 +0530
Message-Id: <1388660330-16781-4-git-send-email-artagnon@gmail.com>
X-Mailer: git-send-email 1.8.5.2.227.g53f3478
In-Reply-To: <1388660330-16781-1-git-send-email-artagnon@gmail.com>
References: <1388660330-16781-1-git-send-email-artagnon@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: David Ahern <dsahern@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Ramkumar Ramachandra <artagnon@gmail.com>
---
 tools/perf/builtin-lock.c     | 14 ++++++++++----
 tools/perf/perf-completion.sh |  4 ++--
 2 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/tools/perf/builtin-lock.c b/tools/perf/builtin-lock.c
index c852c7a..bc7b853 100644
--- a/tools/perf/builtin-lock.c
+++ b/tools/perf/builtin-lock.c
@@ -938,6 +938,7 @@ static int __cmd_record(int argc, const char **argv)
 
 int cmd_lock(int argc, const char **argv, const char *prefix __maybe_unused)
 {
+	bool list_cmds = false;
 	const struct option info_options[] = {
 	OPT_BOOLEAN('t', "threads", &info_threads,
 		    "dump thread list in perf.data"),
@@ -949,6 +950,7 @@ int cmd_lock(int argc, const char **argv, const char *prefix __maybe_unused)
 	OPT_STRING('i', "input", &input_name, "file", "input file name"),
 	OPT_INCR('v', "verbose", &verbose, "be more verbose (show symbol address, etc)"),
 	OPT_BOOLEAN('D', "dump-raw-trace", &dump_trace, "dump raw trace in ASCII"),
+	OPT_BOOLEAN(0, "list-cmds", &list_cmds, "list commands raw for use by scripts"),
 	OPT_END()
 	};
 	const struct option report_options[] = {
@@ -961,10 +963,6 @@ int cmd_lock(int argc, const char **argv, const char *prefix __maybe_unused)
 		"perf lock info [<options>]",
 		NULL
 	};
-	const char * const lock_usage[] = {
-		"perf lock [<options>] {record|report|script|info}",
-		NULL
-	};
 	const char * const report_usage[] = {
 		"perf lock report [<options>]",
 		NULL
@@ -972,12 +970,20 @@ int cmd_lock(int argc, const char **argv, const char *prefix __maybe_unused)
 	unsigned int i;
 	int rc = 0;
 
+	const char *const subcommands[] = { "record", "report", "script", "info", NULL };
+	const char *lock_usage[] = { NULL, NULL };
+	build_usage_string(lock_usage, "lock", subcommands);
+
 	symbol__init();
 	for (i = 0; i < LOCKHASH_SIZE; i++)
 		INIT_LIST_HEAD(lockhash_table + i);
 
 	argc = parse_options(argc, argv, lock_options, lock_usage,
 			     PARSE_OPT_STOP_AT_NON_OPTION);
+	if (list_cmds) {
+		list_cmds_raw(subcommands);
+		return 0;
+	}
 	if (!argc)
 		usage_with_options(lock_usage, lock_options);
 
diff --git a/tools/perf/perf-completion.sh b/tools/perf/perf-completion.sh
index 81a932a..302de6a 100644
--- a/tools/perf/perf-completion.sh
+++ b/tools/perf/perf-completion.sh
@@ -121,8 +121,8 @@ __perf_main ()
 	elif [[ $prev == "-e" && "${words[1]}" == @(record|stat|top) ]]; then
 		evts=$($cmd list --raw-dump)
 		__perfcomp_colon "$evts" "$cur"
-	# List subcommands for kmem, kvm
-	elif [[ $prev == @(kmem|kvm) ]]; then
+	# List subcommands for kmem, kvm, lock
+	elif [[ $prev == @(kmem|kvm|lock) ]]; then
 		subcmds=$($cmd $prev --list-cmds)
 		__perfcomp_colon "$subcmds" "$cur"
 	# List long option names
-- 
1.8.5.2.227.g53f3478

