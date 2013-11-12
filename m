Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756906Ab3KLUrp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 15:47:45 -0500
Received: from merlin.infradead.org ([205.233.59.134]:41959 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756319Ab3KLUqj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 15:46:39 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
        Paul Mackerras <paulus@samba.org>, Pekka Enberg <penberg@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 03/13] perf trace: Fix segfault on perf trace -i perf.data
Date: Tue, 12 Nov 2013 17:46:08 -0300
Message-Id: <1384289178-31374-4-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1384289178-31374-1-git-send-email-acme@infradead.org>
References: <1384289178-31374-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

When replaying a previous record session, it'll get a segfault since it
doesn't initialize raw_syscalls enter/exit tracepoint's evsel->priv for
caching the format fields.

So fix it by properly initializing sys_enter/exit evsels that comes from
reading the perf.data file header.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1384237500-22991-2-git-send-email-namhyung@kernel.org
[ Split the syscall tp field caching part in the previous patch ]
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-trace.c | 37 +++++++++++++++++++++----------------
 1 file changed, 21 insertions(+), 16 deletions(-)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 3fa1dce6d43e..8d6ea8fbf476 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -1766,16 +1766,6 @@ static int trace__process_sample(struct perf_tool *tool,
 	return err;
 }
 
-static bool
-perf_session__has_tp(struct perf_session *session, const char *name)
-{
-	struct perf_evsel *evsel;
-
-	evsel = perf_evlist__find_tracepoint_by_name(session->evlist, name);
-
-	return evsel != NULL;
-}
-
 static int parse_target_str(struct trace *trace)
 {
 	if (trace->opts.target.pid) {
@@ -2012,8 +2002,6 @@ out_error:
 static int trace__replay(struct trace *trace)
 {
 	const struct perf_evsel_str_handler handlers[] = {
-		{ "raw_syscalls:sys_enter",  trace__sys_enter, },
-		{ "raw_syscalls:sys_exit",   trace__sys_exit, },
 		{ "probe:vfs_getname",	     trace__vfs_getname, },
 	};
 	struct perf_data_file file = {
@@ -2021,6 +2009,7 @@ static int trace__replay(struct trace *trace)
 		.mode  = PERF_DATA_MODE_READ,
 	};
 	struct perf_session *session;
+	struct perf_evsel *evsel;
 	int err = -1;
 
 	trace->tool.sample	  = trace__process_sample;
@@ -2052,13 +2041,29 @@ static int trace__replay(struct trace *trace)
 	if (err)
 		goto out;
 
-	if (!perf_session__has_tp(session, "raw_syscalls:sys_enter")) {
-		pr_err("Data file does not have raw_syscalls:sys_enter events\n");
+	evsel = perf_evlist__find_tracepoint_by_name(session->evlist,
+						     "raw_syscalls:sys_enter");
+	if (evsel == NULL) {
+		pr_err("Data file does not have raw_syscalls:sys_enter event\n");
+		goto out;
+	}
+
+	if (perf_evsel__init_syscall_tp(evsel, trace__sys_enter) < 0 ||
+	    perf_evsel__init_sc_tp_ptr_field(evsel, args)) {
+		pr_err("Error during initialize raw_syscalls:sys_enter event\n");
+		goto out;
+	}
+
+	evsel = perf_evlist__find_tracepoint_by_name(session->evlist,
+						     "raw_syscalls:sys_exit");
+	if (evsel == NULL) {
+		pr_err("Data file does not have raw_syscalls:sys_exit event\n");
 		goto out;
 	}
 
-	if (!perf_session__has_tp(session, "raw_syscalls:sys_exit")) {
-		pr_err("Data file does not have raw_syscalls:sys_exit events\n");
+	if (perf_evsel__init_syscall_tp(evsel, trace__sys_exit) < 0 ||
+	    perf_evsel__init_sc_tp_uint_field(evsel, ret)) {
+		pr_err("Error during initialize raw_syscalls:sys_exit event\n");
 		goto out;
 	}
 
-- 
1.8.1.4

