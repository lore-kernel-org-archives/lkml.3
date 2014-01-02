Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751398AbaABK61 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 05:58:27 -0500
Received: from mail-pb0-f48.google.com ([209.85.160.48]:46037 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750748AbaABK6Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 05:58:25 -0500
From: Ramkumar Ramachandra <artagnon@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: David Ahern <dsahern@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 1/5] perf kvm: introduce --list-cmds for use by scripts
Date: Thu,  2 Jan 2014 16:28:46 +0530
Message-Id: <1388660330-16781-2-git-send-email-artagnon@gmail.com>
X-Mailer: git-send-email 1.8.5.2.227.g53f3478
In-Reply-To: <1388660330-16781-1-git-send-email-artagnon@gmail.com>
References: <1388660330-16781-1-git-send-email-artagnon@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce

  $ perf kvm --list-cmds

to dump a raw list of commands for use by the completion script. While
at it, refactor kvm_usage so that there's only one copy of the command
listing.

Cc: David Ahern <dsahern@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Ramkumar Ramachandra <artagnon@gmail.com>
---
 tools/perf/builtin-kvm.c      | 39 ++++++++++++++++++++++++++++++++++-----
 tools/perf/perf-completion.sh |  2 +-
 2 files changed, 35 insertions(+), 6 deletions(-)

diff --git a/tools/perf/builtin-kvm.c b/tools/perf/builtin-kvm.c
index 154b397..313b217 100644
--- a/tools/perf/builtin-kvm.c
+++ b/tools/perf/builtin-kvm.c
@@ -1669,9 +1669,33 @@ __cmd_buildid_list(const char *file_name, int argc, const char **argv)
 	return cmd_buildid_list(i, rec_argv, NULL);
 }
 
+static void build_usage_string(const char **usage_str, const char *command,
+			const char *const *subcommands)
+{
+	struct strbuf buf = STRBUF_INIT;
+
+	strbuf_addf(&buf, "perf %s [<options>] {", command);
+	for (int i = 0; subcommands[i]; i++) {
+		if (i)
+			strbuf_addstr(&buf, "|");
+		strbuf_addstr(&buf, subcommands[i]);
+	}
+	strbuf_addstr(&buf, "}");
+
+	usage_str[0] = strdup(buf.buf);
+	strbuf_release(&buf);
+}
+
+static void list_cmds_raw(const char *const *subcommands)
+{
+	for (int i = 0; subcommands[i]; i++)
+		printf("%s ", subcommands[i]);
+}
+
 int cmd_kvm(int argc, const char **argv, const char *prefix __maybe_unused)
 {
 	const char *file_name = NULL;
+	bool list_cmds = false;
 	const struct option kvm_options[] = {
 		OPT_STRING('i', "input", &file_name, "file",
 			   "Input file name"),
@@ -1692,20 +1716,25 @@ int cmd_kvm(int argc, const char **argv, const char *prefix __maybe_unused)
 			   "file", "file saving guest os /proc/modules"),
 		OPT_INCR('v', "verbose", &verbose,
 			    "be more verbose (show counter open errors, etc)"),
+		OPT_BOOLEAN(0, "list-cmds", &list_cmds,
+			"list commands raw for use by scripts"),
 		OPT_END()
 	};
 
-
-	const char * const kvm_usage[] = {
-		"perf kvm [<options>] {top|record|report|diff|buildid-list|stat}",
-		NULL
-	};
+	const char *const subcommands[] = { "top", "record", "report", "diff",
+					    "buildid-list", "stat", NULL };
+	const char *kvm_usage[] = { NULL, NULL };
+	build_usage_string(kvm_usage, "kvm", subcommands);
 
 	perf_host  = 0;
 	perf_guest = 1;
 
 	argc = parse_options(argc, argv, kvm_options, kvm_usage,
 			PARSE_OPT_STOP_AT_NON_OPTION);
+	if (list_cmds) {
+		list_cmds_raw(subcommands);
+		return 0;
+	}
 	if (!argc)
 		usage_with_options(kvm_usage, kvm_options);
 
diff --git a/tools/perf/perf-completion.sh b/tools/perf/perf-completion.sh
index 496e2ab..d8bfa43 100644
--- a/tools/perf/perf-completion.sh
+++ b/tools/perf/perf-completion.sh
@@ -123,7 +123,7 @@ __perf_main ()
 		__perfcomp_colon "$evts" "$cur"
 	# List subcommands for 'perf kvm'
 	elif [[ $prev == "kvm" ]]; then
-		subcmds="top record report diff buildid-list stat"
+		subcmds=$($cmd kvm --list-cmds)
 		__perfcomp_colon "$subcmds" "$cur"
 	# List long option names
 	elif [[ $cur == --* ]];  then
-- 
1.8.5.2.227.g53f3478

