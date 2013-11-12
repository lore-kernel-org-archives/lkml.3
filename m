Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932368Ab3KLV4z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 16:56:55 -0500
Received: from terminus.zytor.com ([198.137.202.10]:40195 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757280Ab3KLV4j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 16:56:39 -0500
Date: Tue, 12 Nov 2013 13:56:22 -0800
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-003824e8c27eeb8d3eec54cfab5845ec01ab532e@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        penberg@kernel.org, namhyung.kim@lge.com, namhyung@kernel.org,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        penberg@kernel.org, namhyung.kim@lge.com, namhyung@kernel.org,
        dsahern@gmail.com, tglx@linutronix.de
In-Reply-To: <1384237500-22991-2-git-send-email-namhyung@kernel.org>
References: <1384237500-22991-2-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf trace:
  Fix segfault on perf trace -i perf.data
Git-Commit-ID: 003824e8c27eeb8d3eec54cfab5845ec01ab532e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Tue, 12 Nov 2013 13:56:28 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  003824e8c27eeb8d3eec54cfab5845ec01ab532e
Gitweb:     http://git.kernel.org/tip/003824e8c27eeb8d3eec54cfab5845ec01ab532e
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Tue, 12 Nov 2013 15:25:00 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 12 Nov 2013 13:00:37 -0300

perf trace: Fix segfault on perf trace -i perf.data

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
index 3fa1dce..8d6ea8f 100644
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
 
