Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932644AbaFPSPP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 14:15:15 -0400
Received: from g5t1627.atlanta.hp.com ([15.192.137.10]:24062 "EHLO
	g5t1627.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932257AbaFPSPM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 14:15:12 -0400
From: Davidlohr Bueso <davidlohr@hp.com>
To: acme@kernel.org, jolsa@kernel.org
Cc: mitake@dcl.info.waseda.ac.jp, davidlohr@hp.com, aswin@hp.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/9] perf bench: Add --repeat option
Date: Mon, 16 Jun 2014 11:14:19 -0700
Message-Id: <1402942467-10671-2-git-send-email-davidlohr@hp.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1402942467-10671-1-git-send-email-davidlohr@hp.com>
References: <1402942467-10671-1-git-send-email-davidlohr@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are a number of benchmarks that do single runs and
as a result does not really help users gain a general idea
of how the workload performs. So the user must either manually
do multiple runs or just use single bogus results.

This option will enable users to specify the amount of runs
(arbitrarily defaulted to 5) through the '--repeat' option.
Add it to perf-bench instead of implementing it always in
each specific benchmark.

Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
---
 tools/perf/Documentation/perf-bench.txt | 4 ++++
 tools/perf/bench/bench.h                | 1 +
 tools/perf/builtin-bench.c              | 7 +++++++
 3 files changed, 12 insertions(+)

diff --git a/tools/perf/Documentation/perf-bench.txt b/tools/perf/Documentation/perf-bench.txt
index 4464ad7..fd70928 100644
--- a/tools/perf/Documentation/perf-bench.txt
+++ b/tools/perf/Documentation/perf-bench.txt
@@ -16,6 +16,10 @@ This 'perf bench' command is a general framework for benchmark suites.
 
 COMMON OPTIONS
 --------------
+-r::
+--repeat=::
+Specify amount of times to repeat the run (default 5).
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
index 1e6e777..820da6e 100644
--- a/tools/perf/builtin-bench.c
+++ b/tools/perf/builtin-bench.c
@@ -104,9 +104,11 @@ static const char *bench_format_str;
 
 /* Output/formatting style, exported to benchmark modules: */
 int bench_format = BENCH_FORMAT_DEFAULT;
+unsigned int bench_repeat = 5; /* default number of times to repeat the run */
 
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
-- 
1.8.1.4

