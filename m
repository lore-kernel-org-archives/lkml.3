Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965943AbaFSVQK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 17:16:10 -0400
Received: from mail.kernel.org ([198.145.19.201]:34213 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965756AbaFSVOi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 17:14:38 -0400
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Davidlohr Bueso <davidlohr@hp.com>,
        Aswin Chandramouleeswaran <aswin@hp.com>,
        Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>,
        Jiri Olsa <jolsa@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 08/11] perf bench: Add --repeat option
Date: Thu, 19 Jun 2014 18:13:50 -0300
Message-Id: <1403212433-2714-9-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1403212433-2714-1-git-send-email-acme@kernel.org>
References: <1403212433-2714-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Davidlohr Bueso <davidlohr@hp.com>

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

Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Documentation/perf-bench.txt | 4 ++++
 tools/perf/bench/bench.h                | 1 +
 tools/perf/builtin-bench.c              | 7 +++++++
 3 files changed, 12 insertions(+)

diff --git a/tools/perf/Documentation/perf-bench.txt b/tools/perf/Documentation/perf-bench.txt
index 4464ad770d51..f6480cbf309b 100644
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
index eba46709b279..3c4dd44d45cb 100644
--- a/tools/perf/bench/bench.h
+++ b/tools/perf/bench/bench.h
@@ -43,5 +43,6 @@ extern int bench_futex_requeue(int argc, const char **argv, const char *prefix);
 #define BENCH_FORMAT_UNKNOWN		-1
 
 extern int bench_format;
+extern unsigned int bench_repeat;
 
 #endif
diff --git a/tools/perf/builtin-bench.c b/tools/perf/builtin-bench.c
index 1e6e77710545..b9a56fa83330 100644
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
-- 
1.9.3

