Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933063Ab3LITor (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 14:44:47 -0500
Received: from merlin.infradead.org ([205.233.59.134]:54908 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755779Ab3LIThR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 14:37:17 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 01/21] perf trace: Add support for syscalls vs raw_syscalls
Date: Mon,  9 Dec 2013 16:36:50 -0300
Message-Id: <1386617830-18926-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1386617830-18926-1-git-send-email-acme@infradead.org>
References: <1386617830-18926-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

Older kernels (e.g., RHEL6) do system call tracing via
syscalls:sys_{enter,exit} rather than raw_syscalls. Update perf-trace to
detect lack of raw_syscalls support and try syscalls.

Signed-off-by: David Ahern <dsahern@gmail.com>
Link: http://lkml.kernel.org/r/1386211302-31303-2-git-send-email-dsahern@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-trace.c | 28 ++++++++++++++++++++++++++--
 1 file changed, 26 insertions(+), 2 deletions(-)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 56afe339661a..a7aa771a98e6 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -12,6 +12,7 @@
 #include "util/thread_map.h"
 #include "util/stat.h"
 #include "trace-event.h"
+#include "util/parse-events.h"
 
 #include <libaudit.h>
 #include <stdlib.h>
@@ -173,6 +174,10 @@ static struct perf_evsel *perf_evsel__syscall_newtp(const char *direction, void
 {
 	struct perf_evsel *evsel = perf_evsel__newtp("raw_syscalls", direction);
 
+	/* older kernel (e.g., RHEL6) use syscalls:{enter,exit} */
+	if (evsel == NULL)
+		evsel = perf_evsel__newtp("syscalls", direction);
+
 	if (evsel) {
 		if (perf_evsel__init_syscall_tp(evsel, handler))
 			goto out_delete;
@@ -1801,10 +1806,11 @@ static int trace__record(int argc, const char **argv)
 		"-R",
 		"-m", "1024",
 		"-c", "1",
-		"-e", "raw_syscalls:sys_enter,raw_syscalls:sys_exit",
+		"-e",
 	};
 
-	rec_argc = ARRAY_SIZE(record_args) + argc;
+	/* +1 is for the event string below */
+	rec_argc = ARRAY_SIZE(record_args) + 1 + argc;
 	rec_argv = calloc(rec_argc + 1, sizeof(char *));
 
 	if (rec_argv == NULL)
@@ -1813,6 +1819,17 @@ static int trace__record(int argc, const char **argv)
 	for (i = 0; i < ARRAY_SIZE(record_args); i++)
 		rec_argv[i] = record_args[i];
 
+	/* event string may be different for older kernels - e.g., RHEL6 */
+	if (is_valid_tracepoint("raw_syscalls:sys_enter"))
+		rec_argv[i] = "raw_syscalls:sys_enter,raw_syscalls:sys_exit";
+	else if (is_valid_tracepoint("syscalls:sys_enter"))
+		rec_argv[i] = "syscalls:sys_enter,syscalls:sys_exit";
+	else {
+		pr_err("Neither raw_syscalls nor syscalls events exist.\n");
+		return -1;
+	}
+	i++;
+
 	for (j = 0; j < (unsigned int)argc; j++, i++)
 		rec_argv[i] = argv[j];
 
@@ -2048,6 +2065,10 @@ static int trace__replay(struct trace *trace)
 
 	evsel = perf_evlist__find_tracepoint_by_name(session->evlist,
 						     "raw_syscalls:sys_enter");
+	/* older kernels have syscalls tp versus raw_syscalls */
+	if (evsel == NULL)
+		evsel = perf_evlist__find_tracepoint_by_name(session->evlist,
+							     "syscalls:sys_enter");
 	if (evsel == NULL) {
 		pr_err("Data file does not have raw_syscalls:sys_enter event\n");
 		goto out;
@@ -2061,6 +2082,9 @@ static int trace__replay(struct trace *trace)
 
 	evsel = perf_evlist__find_tracepoint_by_name(session->evlist,
 						     "raw_syscalls:sys_exit");
+	if (evsel == NULL)
+		evsel = perf_evlist__find_tracepoint_by_name(session->evlist,
+							     "syscalls:sys_exit");
 	if (evsel == NULL) {
 		pr_err("Data file does not have raw_syscalls:sys_exit event\n");
 		goto out;
-- 
1.8.1.4

