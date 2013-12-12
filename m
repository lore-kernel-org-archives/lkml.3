Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751901Ab3LLR16 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 12:27:58 -0500
Received: from mail-pb0-f42.google.com ([209.85.160.42]:58751 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751396Ab3LLR14 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 12:27:56 -0500
From: Ramkumar Ramachandra <artagnon@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: David Ahern <dsahern@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH] perf kvm: introduce --list-cmds for use by scripts
Date: Thu, 12 Dec 2013 22:56:51 +0530
Message-Id: <1386869211-1971-1-git-send-email-artagnon@gmail.com>
X-Mailer: git-send-email 1.8.5.1.113.g8cb5bef.dirty
In-Reply-To: <52A9E9F3.4090801@gmail.com>
References: <52A9E9F3.4090801@gmail.com>
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
 David Ahern wrote:
 > That would work -- perhaps a #define or string near
 >
 >    const char * const kvm_usage[] = {
 >         "perf kvm [<options>] {top|record|report|diff|buildid-list|stat}",
 >         NULL
 >     };
 >
 > Building kvm_usage from the string would better - only 1 place listing the
 > commands.

 Something like this, perhaps? It's not too pretty though: do you have
 suggestions to prettify it?

 tools/perf/builtin-kvm.c      | 25 +++++++++++++++++++++----
 tools/perf/perf-completion.sh |  2 +-
 2 files changed, 22 insertions(+), 5 deletions(-)

diff --git a/tools/perf/builtin-kvm.c b/tools/perf/builtin-kvm.c
index c6fa3cb..ce44a9b 100644
--- a/tools/perf/builtin-kvm.c
+++ b/tools/perf/builtin-kvm.c
@@ -1672,6 +1672,7 @@ __cmd_buildid_list(const char *file_name, int argc, const char **argv)
 int cmd_kvm(int argc, const char **argv, const char *prefix __maybe_unused)
 {
 	const char *file_name = NULL;
+	bool list_cmds = false;
 	const struct option kvm_options[] = {
 		OPT_STRING('i', "input", &file_name, "file",
 			   "Input file name"),
@@ -1692,20 +1693,36 @@ int cmd_kvm(int argc, const char **argv, const char *prefix __maybe_unused)
 			   "file", "file saving guest os /proc/modules"),
 		OPT_INCR('v', "verbose", &verbose,
 			    "be more verbose (show counter open errors, etc)"),
+		OPT_BOOLEAN(0, "list-cmds", &list_cmds,
+			"list commands raw for use by scripts"),
 		OPT_END()
 	};
 
+	const char *const commands[] = { "top", "record", "report", "diff",
+					 "buildid-list", "stat", NULL };
+	char kvm_usage_str[80];
+	const char *kvm_usage[] = { NULL, NULL };
 
-	const char * const kvm_usage[] = {
-		"perf kvm [<options>] {top|record|report|diff|buildid-list|stat}",
-		NULL
-	};
+	sprintf(kvm_usage_str, "%s", "perf kvm [<options>] {");
+	for (int i = 0; commands[i]; i++) {
+		if (i)
+			strcat(kvm_usage_str, "|");
+		strcat(kvm_usage_str, commands[i]);
+	}
+	strcat(kvm_usage_str, "}");
+
+	kvm_usage[0] = kvm_usage_str;
 
 	perf_host  = 0;
 	perf_guest = 1;
 
 	argc = parse_options(argc, argv, kvm_options, kvm_usage,
 			PARSE_OPT_STOP_AT_NON_OPTION);
+	if (list_cmds) {
+		for (int i = 0; commands[i]; i++)
+			printf("%s ", commands[i]);
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
1.8.5.1.113.g8cb5bef.dirty

