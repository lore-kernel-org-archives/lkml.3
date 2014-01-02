Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751704AbaABK7N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 05:59:13 -0500
Received: from mail-pa0-f43.google.com ([209.85.220.43]:45011 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751487AbaABK6c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 05:58:32 -0500
From: Ramkumar Ramachandra <artagnon@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: David Ahern <dsahern@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 4/5] perf mem: introduce --list-cmds
Date: Thu,  2 Jan 2014 16:28:49 +0530
Message-Id: <1388660330-16781-5-git-send-email-artagnon@gmail.com>
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
 tools/perf/builtin-mem.c      | 15 ++++++++++-----
 tools/perf/perf-completion.sh |  4 ++--
 2 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/tools/perf/builtin-mem.c b/tools/perf/builtin-mem.c
index 31c00f1..a1db6e7 100644
--- a/tools/perf/builtin-mem.c
+++ b/tools/perf/builtin-mem.c
@@ -21,11 +21,6 @@ struct perf_mem {
 	DECLARE_BITMAP(cpu_bitmap, MAX_NR_CPUS);
 };
 
-static const char * const mem_usage[] = {
-	"perf mem [<options>] {record <command> |report}",
-	NULL
-};
-
 static int __cmd_record(int argc, const char **argv)
 {
 	int rec_argc, i = 0, j;
@@ -191,6 +186,7 @@ static int report_events(int argc, const char **argv, struct perf_mem *mem)
 int cmd_mem(int argc, const char **argv, const char *prefix __maybe_unused)
 {
 	struct stat st;
+	bool list_cmds = false;
 	struct perf_mem mem = {
 		.tool = {
 			.sample		= process_sample_event,
@@ -219,12 +215,21 @@ int cmd_mem(int argc, const char **argv, const char *prefix __maybe_unused)
 		   "separator",
 		   "separator for columns, no spaces will be added"
 		   " between columns '.' is reserved."),
+	OPT_BOOLEAN(0, "list-cmds", &list_cmds,
+		"list commands raw for use by scripts"),
 	OPT_END()
 	};
+	const char *const subcommands[] = { "record", "report", NULL };
+	const char *mem_usage[] = { NULL, NULL };
+	build_usage_string(mem_usage, "mem", subcommands);
 
 	argc = parse_options(argc, argv, mem_options, mem_usage,
 			     PARSE_OPT_STOP_AT_NON_OPTION);
 
+	if (list_cmds) {
+		list_cmds_raw(subcommands);
+		return 0;
+	}
 	if (!argc || !(strncmp(argv[0], "rec", 3) || mem_operation))
 		usage_with_options(mem_usage, mem_options);
 
diff --git a/tools/perf/perf-completion.sh b/tools/perf/perf-completion.sh
index 302de6a..4ecef69 100644
--- a/tools/perf/perf-completion.sh
+++ b/tools/perf/perf-completion.sh
@@ -121,8 +121,8 @@ __perf_main ()
 	elif [[ $prev == "-e" && "${words[1]}" == @(record|stat|top) ]]; then
 		evts=$($cmd list --raw-dump)
 		__perfcomp_colon "$evts" "$cur"
-	# List subcommands for kmem, kvm, lock
-	elif [[ $prev == @(kmem|kvm|lock) ]]; then
+	# List subcommands for kmem, kvm, lock, mem
+	elif [[ $prev == @(kmem|kvm|lock|mem) ]]; then
 		subcmds=$($cmd $prev --list-cmds)
 		__perfcomp_colon "$subcmds" "$cur"
 	# List long option names
-- 
1.8.5.2.227.g53f3478

