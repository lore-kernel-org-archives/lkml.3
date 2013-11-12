Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754892Ab3KLMPT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 07:15:19 -0500
Received: from mail-yh0-f50.google.com ([209.85.213.50]:35037 "EHLO
	mail-yh0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752098Ab3KLMPQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 07:15:16 -0500
Date: Tue, 12 Nov 2013 09:15:08 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Pekka Enberg <penberg@kernel.org>
Subject: Re: [PATCH 2/2] perf trace: Fix segfault on perf trace -i perf.data
Message-ID: <20131112121508.GE4053@ghostprotocols.net>
References: <1384237500-22991-1-git-send-email-namhyung@kernel.org>
 <1384237500-22991-2-git-send-email-namhyung@kernel.org>
 <20131112114609.GB4053@ghostprotocols.net>
 <20131112115700.GC4053@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131112115700.GC4053@ghostprotocols.net>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Nov 12, 2013 at 08:57:00AM -0300, Arnaldo Carvalho de Melo escreveu:
> Em Tue, Nov 12, 2013 at 08:46:09AM -0300, Arnaldo Carvalho de Melo escreveu:
> > Em Tue, Nov 12, 2013 at 03:25:00PM +0900, Namhyung Kim escreveu:
> > > From: Namhyung Kim <namhyung.kim@lge.com>
> 
> > > When replaying a previous record session, it'll get a segfault since
> > > it doesn't initialize evsel->priv for finding syscall id.  So fix it
> > > by initialize sys_enter/exit evsel manually.
> 
> > > While at it, factor out perf_evsel__init_syscall_tp() to init a
> > > syscall evsel and remove unused perf_session__has_tp().
> 
> > Try to avoid these "while at it" to combine multiple patches into one
> > :-)
> 
> > I'll try to do it for you this time as it fixes a real problem, thanks
> > for fixing it!
> 
> So this becomes the first part of this patch, split from yours and
> massaged a bit so that by looking at the patch it becomes quickly clear
> what it is doing, please let me now if I can keep this as-is (with your
> authorship, etc).
> 
> I'll test this all out after finishing the next part of the split up.

Second part, just rewrote the changelog a bit:

commit 4e8a6e566fc611b9cbec2978a52266f29cb65785
Author: Namhyung Kim <namhyung.kim@lge.com>
Date:   Tue Nov 12 15:25:00 2013 +0900

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
 
