Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759995Ab3JPFD0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 01:03:26 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:62800 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751593Ab3JPFA1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 01:00:27 -0400
X-AuditID: 9c93016f-b7c63ae00000696f-34-525e1d684329
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Stephane Eranian <eranian@google.com>, Jeremy Eder <jeder@redhat.com>
Subject: [PATCH 10/18] perf ftrace: Add dump_printf() for low-level debugging
Date: Wed, 16 Oct 2013 14:00:13 +0900
Message-Id: <1381899621-14638-11-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1381899621-14638-1-git-send-email-namhyung@kernel.org>
References: <1381899621-14638-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

For reusability, rename trace_event() to dump_raw_event() and pass
size as an argument.  And use it in do_ftrace_report() to show raw
data of ftrace entries.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/builtin-ftrace.c | 6 ++++++
 tools/perf/util/debug.c     | 8 ++++----
 tools/perf/util/debug.h     | 2 +-
 tools/perf/util/session.c   | 2 +-
 4 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/tools/perf/builtin-ftrace.c b/tools/perf/builtin-ftrace.c
index ba04a402974c..676b2aa7590f 100644
--- a/tools/perf/builtin-ftrace.c
+++ b/tools/perf/builtin-ftrace.c
@@ -1350,6 +1350,12 @@ static int do_ftrace_report(struct perf_ftrace *ftrace)
 			goto out;
 		}
 
+		dump_printf(" .... event: %s\n", perf_evsel__name(evsel));
+		dump_raw_event(record, record->size);
+		dump_printf("%3d %llu %#llx [%#x]\n\n",
+			    record->cpu, record->ts, record->offset,
+			    record->size);
+
 		/* TODO: update sample.period using calltime */
 		if (!__hists__add_entry(&evsel->hists, &al, NULL,
 					sample.period, 0, 0)) {
diff --git a/tools/perf/util/debug.c b/tools/perf/util/debug.c
index 399e74c34c1a..2c42aaed4528 100644
--- a/tools/perf/util/debug.c
+++ b/tools/perf/util/debug.c
@@ -47,7 +47,7 @@ int dump_printf(const char *fmt, ...)
 	return ret;
 }
 
-void trace_event(union perf_event *event)
+void dump_raw_event(void *event, int size)
 {
 	unsigned char *raw_event = (void *)event;
 	const char *color = PERF_COLOR_BLUE;
@@ -58,9 +58,9 @@ void trace_event(union perf_event *event)
 
 	printf(".");
 	color_fprintf(stdout, color, "\n. ... raw event: size %d bytes\n",
-		      event->header.size);
+		      size);
 
-	for (i = 0; i < event->header.size; i++) {
+	for (i = 0; i < size; i++) {
 		if ((i & 15) == 0) {
 			printf(".");
 			color_fprintf(stdout, color, "  %04x: ", i);
@@ -68,7 +68,7 @@ void trace_event(union perf_event *event)
 
 		color_fprintf(stdout, color, " %02x", raw_event[i]);
 
-		if (((i & 15) == 15) || i == event->header.size-1) {
+		if (((i & 15) == 15) || i == size-1) {
 			color_fprintf(stdout, color, "  ");
 			for (j = 0; j < 15-(i & 15); j++)
 				color_fprintf(stdout, color, "   ");
diff --git a/tools/perf/util/debug.h b/tools/perf/util/debug.h
index efbd98805ad0..9cebb0cdb7bd 100644
--- a/tools/perf/util/debug.h
+++ b/tools/perf/util/debug.h
@@ -12,7 +12,7 @@ extern int verbose;
 extern bool quiet, dump_trace;
 
 int dump_printf(const char *fmt, ...) __attribute__((format(printf, 1, 2)));
-void trace_event(union perf_event *event);
+void dump_raw_event(void *event, int size);
 
 int ui__error(const char *format, ...) __attribute__((format(printf, 1, 2)));
 int ui__warning(const char *format, ...) __attribute__((format(printf, 1, 2)));
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index d1e449534b33..a714265ea0c3 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -832,7 +832,7 @@ static void dump_event(struct perf_session *session, union perf_event *event,
 	printf("\n%#" PRIx64 " [%#x]: event: %d\n",
 	       file_offset, event->header.size, event->header.type);
 
-	trace_event(event);
+	dump_raw_event(event, event->header.size);
 
 	if (sample)
 		perf_session__print_tstamp(session, event, sample);
-- 
1.7.11.7

