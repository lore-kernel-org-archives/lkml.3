Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756530Ab3LECmB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 21:42:01 -0500
Received: from mail-pd0-f170.google.com ([209.85.192.170]:48302 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756469Ab3LEClx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 21:41:53 -0500
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: David Ahern <dsahern@gmail.com>
Subject: [PATCH 1/4] perf trace: Add support for syscalls vs raw_syscalls
Date: Wed,  4 Dec 2013 19:41:39 -0700
Message-Id: <1386211302-31303-2-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.8.3.4 (Apple Git-47)
In-Reply-To: <1386211302-31303-1-git-send-email-dsahern@gmail.com>
References: <1386211302-31303-1-git-send-email-dsahern@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Older kernels (e.g., RHEL6) do system call tracing via
syscalls:sys_{enter,exit} rather than raw_syscalls. Update perf-trace to
detect lack of raw_syscalls support and try syscalls.

Signed-off-by: David Ahern <dsahern@gmail.com>
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
1.8.3.4 (Apple Git-47)

