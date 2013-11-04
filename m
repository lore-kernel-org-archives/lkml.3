Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754512Ab3KDUWg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 15:22:36 -0500
Received: from terminus.zytor.com ([198.137.202.10]:50090 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753267Ab3KDUWb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 15:22:31 -0500
Date: Mon, 4 Nov 2013 12:22:15 -0800
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-cc03c54296ccbeca5363dfe8f49af42d14960f28@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, namhyung@kernel.org, jolsa@redhat.com,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, namhyung@kernel.org, jolsa@redhat.com,
        dsahern@gmail.com, tglx@linutronix.de
In-Reply-To: <1383291195-24386-6-git-send-email-namhyung@kernel.org>
References: <1383291195-24386-6-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf stat: Enhance option parse error message
Git-Commit-ID: cc03c54296ccbeca5363dfe8f49af42d14960f28
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 04 Nov 2013 12:22:20 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  cc03c54296ccbeca5363dfe8f49af42d14960f28
Gitweb:     http://git.kernel.org/tip/cc03c54296ccbeca5363dfe8f49af42d14960f28
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Fri, 1 Nov 2013 16:33:15 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 4 Nov 2013 12:57:36 -0300

perf stat: Enhance option parse error message

Print related option help messages only when it failed to process
options.  While at it, modify parse_options_usage() to skip usage part
so that it can be used for showing multiple option help messages
naturally like below:

  $ perf stat -Bx, ls
  -B option not supported with -x

   usage: perf stat [<options>] [<command>]

      -B, --big-num         print large numbers with thousands' separators
      -x, --field-separator <separator>
                            print counts with custom separator

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Acked-by: Ingo Molnar <mingo@kernel.org>
Reviewed-by: Ingo Molnar <mingo@kernel.org>
Enthusiastically-Supported-by: Ingo Molnar <mingo@kernel.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1383291195-24386-6-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-stat.c       | 42 ++++++++++++++++++++++++++---------------
 tools/perf/util/parse-options.c |  3 ++-
 2 files changed, 29 insertions(+), 16 deletions(-)

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 1a9c95d..0fc1c94 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -1596,7 +1596,7 @@ int cmd_stat(int argc, const char **argv, const char *prefix __maybe_unused)
 		"perf stat [<options>] [<command>]",
 		NULL
 	};
-	int status = -ENOMEM, run_idx;
+	int status = -EINVAL, run_idx;
 	const char *mode;
 
 	setlocale(LC_ALL, "");
@@ -1614,12 +1614,15 @@ int cmd_stat(int argc, const char **argv, const char *prefix __maybe_unused)
 
 	if (output_name && output_fd) {
 		fprintf(stderr, "cannot use both --output and --log-fd\n");
-		usage_with_options(stat_usage, options);
+		parse_options_usage(stat_usage, options, "o", 1);
+		parse_options_usage(NULL, options, "log-fd", 0);
+		goto out;
 	}
 
 	if (output_fd < 0) {
 		fprintf(stderr, "argument to --log-fd must be a > 0\n");
-		usage_with_options(stat_usage, options);
+		parse_options_usage(stat_usage, options, "log-fd", 0);
+		goto out;
 	}
 
 	if (!output) {
@@ -1656,7 +1659,9 @@ int cmd_stat(int argc, const char **argv, const char *prefix __maybe_unused)
 		/* User explicitly passed -B? */
 		if (big_num_opt == 1) {
 			fprintf(stderr, "-B option not supported with -x\n");
-			usage_with_options(stat_usage, options);
+			parse_options_usage(stat_usage, options, "B", 1);
+			parse_options_usage(NULL, options, "x", 1);
+			goto out;
 		} else /* Nope, so disable big number formatting */
 			big_num = false;
 	} else if (big_num_opt == 0) /* User passed --no-big-num */
@@ -1666,7 +1671,9 @@ int cmd_stat(int argc, const char **argv, const char *prefix __maybe_unused)
 		usage_with_options(stat_usage, options);
 
 	if (run_count < 0) {
-		usage_with_options(stat_usage, options);
+		pr_err("Run count must be a positive number\n");
+		parse_options_usage(stat_usage, options, "r", 1);
+		goto out;
 	} else if (run_count == 0) {
 		forever = true;
 		run_count = 1;
@@ -1678,8 +1685,10 @@ int cmd_stat(int argc, const char **argv, const char *prefix __maybe_unused)
 		fprintf(stderr, "both cgroup and no-aggregation "
 			"modes only available in system-wide mode\n");
 
-		usage_with_options(stat_usage, options);
-		return -1;
+		parse_options_usage(stat_usage, options, "G", 1);
+		parse_options_usage(NULL, options, "A", 1);
+		parse_options_usage(NULL, options, "a", 1);
+		goto out;
 	}
 
 	if (add_default_attributes())
@@ -1688,25 +1697,28 @@ int cmd_stat(int argc, const char **argv, const char *prefix __maybe_unused)
 	perf_target__validate(&target);
 
 	if (perf_evlist__create_maps(evsel_list, &target) < 0) {
-		if (perf_target__has_task(&target))
+		if (perf_target__has_task(&target)) {
 			pr_err("Problems finding threads of monitor\n");
-		if (perf_target__has_cpu(&target))
+			parse_options_usage(stat_usage, options, "p", 1);
+			parse_options_usage(NULL, options, "t", 1);
+		} else if (perf_target__has_cpu(&target)) {
 			perror("failed to parse CPUs map");
-
-		usage_with_options(stat_usage, options);
-		return -1;
+			parse_options_usage(stat_usage, options, "C", 1);
+			parse_options_usage(NULL, options, "a", 1);
+		}
+		goto out;
 	}
 	if (interval && interval < 100) {
 		pr_err("print interval must be >= 100ms\n");
-		usage_with_options(stat_usage, options);
-		return -1;
+		parse_options_usage(stat_usage, options, "I", 1);
+		goto out_free_maps;
 	}
 
 	if (perf_evlist__alloc_stats(evsel_list, interval))
 		goto out_free_maps;
 
 	if (perf_stat_init_aggr_mode())
-		goto out;
+		goto out_free_maps;
 
 	/*
 	 * We dont want to block the signals - that would cause
diff --git a/tools/perf/util/parse-options.c b/tools/perf/util/parse-options.c
index 1caf7b9..31f404a 100644
--- a/tools/perf/util/parse-options.c
+++ b/tools/perf/util/parse-options.c
@@ -569,7 +569,7 @@ int parse_options_usage(const char * const *usagestr,
 			const char *optstr, bool short_opt)
 {
 	if (!usagestr)
-		return PARSE_OPT_HELP;
+		goto opt;
 
 	fprintf(stderr, "\n usage: %s\n", *usagestr++);
 	while (*usagestr && **usagestr)
@@ -582,6 +582,7 @@ int parse_options_usage(const char * const *usagestr,
 	}
 	fputc('\n', stderr);
 
+opt:
 	for (  ; opts->type != OPTION_END; opts++) {
 		if (short_opt) {
 			if (opts->short_name == *optstr)
