Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752817Ab3EZErp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 May 2013 00:47:45 -0400
Received: from mail-pb0-f50.google.com ([209.85.160.50]:47024 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752592Ab3EZEra (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 May 2013 00:47:30 -0400
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: David Ahern <dsahern@gmail.com>, Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 2/2] perf script: add option to dump parent pid
Date: Sat, 25 May 2013 22:47:11 -0600
Message-Id: <1369543631-5106-2-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1369543631-5106-1-git-send-email-dsahern@gmail.com>
References: <1369543631-5106-1-git-send-email-dsahern@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
---
 tools/perf/Documentation/perf-script.txt |    2 +-
 tools/perf/builtin-script.c              |    9 +++++++--
 2 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/tools/perf/Documentation/perf-script.txt b/tools/perf/Documentation/perf-script.txt
index e9cbfcd..3cca420 100644
--- a/tools/perf/Documentation/perf-script.txt
+++ b/tools/perf/Documentation/perf-script.txt
@@ -115,7 +115,7 @@ OPTIONS
 -f::
 --fields::
         Comma separated list of fields to print. Options are:
-        comm, tid, pid, time, cpu, event, trace, ip, sym, dso, addr, symoff.
+        comm, tid, pid, ppid, time, cpu, event, trace, ip, sym, dso, addr, symoff.
         Field list can be prepended with the type, trace, sw or hw,
         to indicate to which event type the field list applies.
         e.g., -f sw:comm,tid,time,ip,sym  and -f trace:time,cpu,trace
diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index 2e07c70..9e400e6 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -41,6 +41,7 @@ enum perf_output_field {
 	PERF_OUTPUT_DSO             = 1U << 9,
 	PERF_OUTPUT_ADDR            = 1U << 10,
 	PERF_OUTPUT_SYMOFFSET       = 1U << 11,
+	PERF_OUTPUT_PPID            = 1U << 12,
 };
 
 struct output_option {
@@ -50,6 +51,7 @@ struct output_option {
 	{.str = "comm",  .field = PERF_OUTPUT_COMM},
 	{.str = "tid",   .field = PERF_OUTPUT_TID},
 	{.str = "pid",   .field = PERF_OUTPUT_PID},
+	{.str = "ppid",  .field = PERF_OUTPUT_PPID},
 	{.str = "time",  .field = PERF_OUTPUT_TIME},
 	{.str = "cpu",   .field = PERF_OUTPUT_CPU},
 	{.str = "event", .field = PERF_OUTPUT_EVNAME},
@@ -208,7 +210,7 @@ static int perf_evsel__check_attr(struct perf_evsel *evsel,
 		return -EINVAL;
 	}
 
-	if ((PRINT_FIELD(PID) || PRINT_FIELD(TID)) &&
+	if ((PRINT_FIELD(PID) || PRINT_FIELD(TID) || PRINT_FIELD(PPID)) &&
 		perf_evsel__check_stype(evsel, PERF_SAMPLE_TID, "TID",
 					PERF_OUTPUT_TID|PERF_OUTPUT_PID))
 		return -EINVAL;
@@ -283,6 +285,9 @@ static void print_sample_start(struct perf_sample *sample,
 	else if (PRINT_FIELD(TID))
 		printf("%5d ", sample->tid);
 
+	if (PRINT_FIELD(PPID))
+		printf("%5d ", thread->ppid);
+
 	if (PRINT_FIELD(CPU)) {
 		if (latency_format)
 			printf("%3d ", sample->cpu);
@@ -1274,7 +1279,7 @@ int cmd_script(int argc, const char **argv, const char *prefix __maybe_unused)
 	OPT_CALLBACK('f', "fields", NULL, "str",
 		     "comma separated output fields prepend with 'type:'. "
 		     "Valid types: hw,sw,trace,raw. "
-		     "Fields: comm,tid,pid,time,cpu,event,trace,ip,sym,dso,"
+		     "Fields: comm,tid,pid,ppid,time,cpu,event,trace,ip,sym,dso,"
 		     "addr,symoff", parse_output_fields),
 	OPT_BOOLEAN('a', "all-cpus", &system_wide,
 		    "system-wide collection from all CPUs"),
-- 
1.7.10.1

