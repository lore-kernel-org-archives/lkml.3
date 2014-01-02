Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751658AbaABK6g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 05:58:36 -0500
Received: from mail-pd0-f171.google.com ([209.85.192.171]:65059 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751585AbaABK6e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 05:58:34 -0500
From: Ramkumar Ramachandra <artagnon@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: David Ahern <dsahern@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 5/5] perf sched: introduce --list-cmds
Date: Thu,  2 Jan 2014 16:28:50 +0530
Message-Id: <1388660330-16781-6-git-send-email-artagnon@gmail.com>
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
 tools/perf/builtin-sched.c    | 15 +++++++++++----
 tools/perf/perf-completion.sh |  4 ++--
 2 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index 0f3c6551..ccd9b19 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -1658,6 +1658,7 @@ static int __cmd_record(int argc, const char **argv)
 int cmd_sched(int argc, const char **argv, const char *prefix __maybe_unused)
 {
 	const char default_sort_order[] = "avg, max, switch, runtime";
+	bool list_cmds = false;
 	struct perf_sched sched = {
 		.tool = {
 			.sample		 = perf_sched__process_tracepoint_sample,
@@ -1703,6 +1704,8 @@ int cmd_sched(int argc, const char **argv, const char *prefix __maybe_unused)
 		    "be more verbose (show symbol address, etc)"),
 	OPT_BOOLEAN('D', "dump-raw-trace", &dump_trace,
 		    "dump raw trace in ASCII"),
+	OPT_BOOLEAN(0, "list-cmds", &list_cmds,
+		"list commands raw for use by scripts"),
 	OPT_END()
 	};
 	const char * const latency_usage[] = {
@@ -1713,10 +1716,6 @@ int cmd_sched(int argc, const char **argv, const char *prefix __maybe_unused)
 		"perf sched replay [<options>]",
 		NULL
 	};
-	const char * const sched_usage[] = {
-		"perf sched [<options>] {record|latency|map|replay|script}",
-		NULL
-	};
 	struct trace_sched_handler lat_ops  = {
 		.wakeup_event	    = latency_wakeup_event,
 		.switch_event	    = latency_switch_event,
@@ -1732,12 +1731,20 @@ int cmd_sched(int argc, const char **argv, const char *prefix __maybe_unused)
 		.fork_event	    = replay_fork_event,
 	};
 	unsigned int i;
+	const char *const subcommands [] = { "record", "latency", "map",
+					     "replay", "script" };
+	const char *sched_usage[] = { NULL, NULL };
+	build_usage_string(sched_usage, "sched", subcommands);
 
 	for (i = 0; i < ARRAY_SIZE(sched.curr_pid); i++)
 		sched.curr_pid[i] = -1;
 
 	argc = parse_options(argc, argv, sched_options, sched_usage,
 			     PARSE_OPT_STOP_AT_NON_OPTION);
+	if (list_cmds) {
+		list_cmds_raw(subcommands);
+		return 0;
+	}
 	if (!argc)
 		usage_with_options(sched_usage, sched_options);
 
diff --git a/tools/perf/perf-completion.sh b/tools/perf/perf-completion.sh
index 4ecef69..3682921 100644
--- a/tools/perf/perf-completion.sh
+++ b/tools/perf/perf-completion.sh
@@ -121,8 +121,8 @@ __perf_main ()
 	elif [[ $prev == "-e" && "${words[1]}" == @(record|stat|top) ]]; then
 		evts=$($cmd list --raw-dump)
 		__perfcomp_colon "$evts" "$cur"
-	# List subcommands for kmem, kvm, lock, mem
-	elif [[ $prev == @(kmem|kvm|lock|mem) ]]; then
+	# List subcommands for kmem, kvm, lock, mem, sched
+	elif [[ $prev == @(kmem|kvm|lock|mem|sched) ]]; then
 		subcmds=$($cmd $prev --list-cmds)
 		__perfcomp_colon "$subcmds" "$cur"
 	# List long option names
-- 
1.8.5.2.227.g53f3478

