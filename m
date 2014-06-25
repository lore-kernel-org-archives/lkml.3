Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755421AbaFYFv6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 01:51:58 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36321 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752564AbaFYFvz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 01:51:55 -0400
Date: Tue, 24 Jun 2014 22:51:40 -0700
From: tip-bot for Davidlohr Bueso <tipbot@zytor.com>
Message-ID: <tip-b6f0629a94f7ed6089560be7f0561be19f934fc4@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, jolsa@kernel.org, mitake@dcl.info.waseda.ac.jp,
        tglx@linutronix.de, davidlohr@hp.com, aswin@hp.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, jolsa@kernel.org, mitake@dcl.info.waseda.ac.jp,
        tglx@linutronix.de, davidlohr@hp.com, aswin@hp.com
In-Reply-To: <1402942467-10671-2-git-send-email-davidlohr@hp.com>
References: <1402942467-10671-2-git-send-email-davidlohr@hp.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf bench: Add --repeat option
Git-Commit-ID: b6f0629a94f7ed6089560be7f0561be19f934fc4
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

Commit-ID:  b6f0629a94f7ed6089560be7f0561be19f934fc4
Gitweb:     http://git.kernel.org/tip/b6f0629a94f7ed6089560be7f0561be19f934fc4
Author:     Davidlohr Bueso <davidlohr@hp.com>
AuthorDate: Mon, 16 Jun 2014 11:14:19 -0700
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 19 Jun 2014 16:13:15 -0300

perf bench: Add --repeat option

There are a number of benchmarks that do single runs and as a result
does not really help users gain a general idea of how the workload
performs. So the user must either manually do multiple runs or just use
single bogus results.

This option will enable users to specify the amount of runs (arbitrarily
defaulted to 10, to use the existing benchmarks default) through the
'--repeat' option.  Add it to perf-bench instead of implementing it
always in each specific benchmark.

Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
Cc: Aswin Chandramouleeswaran <aswin@hp.com>
Cc: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: Jiri Olsa <jolsa@kernel.org>
Link: http://lkml.kernel.org/r/1402942467-10671-2-git-send-email-davidlohr@hp.com
[ Kept the existing default of 10, changing it to something else should
  be done on separate patch ]
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Documentation/perf-bench.txt | 4 ++++
 tools/perf/bench/bench.h                | 1 +
 tools/perf/builtin-bench.c              | 7 +++++++
 3 files changed, 12 insertions(+)

diff --git a/tools/perf/Documentation/perf-bench.txt b/tools/perf/Documentation/perf-bench.txt
index 4464ad7..f6480cb 100644
--- a/tools/perf/Documentation/perf-bench.txt
+++ b/tools/perf/Documentation/perf-bench.txt
@@ -16,6 +16,10 @@ This 'perf bench' command is a general framework for benchmark suites.
 
 COMMON OPTIONS
 --------------
+-r::
+--repeat=::
+Specify amount of times to repeat the run (default 10).
+
 -f::
 --format=::
 Specify format style.
diff --git a/tools/perf/bench/bench.h b/tools/perf/bench/bench.h
index eba4670..3c4dd44 100644
--- a/tools/perf/bench/bench.h
+++ b/tools/perf/bench/bench.h
@@ -43,5 +43,6 @@ extern int bench_futex_requeue(int argc, const char **argv, const char *prefix);
 #define BENCH_FORMAT_UNKNOWN		-1
 
 extern int bench_format;
+extern unsigned int bench_repeat;
 
 #endif
diff --git a/tools/perf/builtin-bench.c b/tools/perf/builtin-bench.c
index 1e6e777..b9a56fa 100644
--- a/tools/perf/builtin-bench.c
+++ b/tools/perf/builtin-bench.c
@@ -104,9 +104,11 @@ static const char *bench_format_str;
 
 /* Output/formatting style, exported to benchmark modules: */
 int bench_format = BENCH_FORMAT_DEFAULT;
+unsigned int bench_repeat = 10; /* default number of times to repeat the run */
 
 static const struct option bench_options[] = {
 	OPT_STRING('f', "format", &bench_format_str, "default", "Specify format style"),
+	OPT_UINTEGER('r', "repeat",  &bench_repeat,   "Specify amount of times to repeat the run"),
 	OPT_END()
 };
 
@@ -226,6 +228,11 @@ int cmd_bench(int argc, const char **argv, const char *prefix __maybe_unused)
 		goto end;
 	}
 
+	if (bench_repeat == 0) {
+		printf("Invalid repeat option: Must specify a positive value\n");
+		goto end;
+	}
+
 	if (argc < 1) {
 		print_usage();
 		goto end;
