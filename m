Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757011AbbAZRvI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 12:51:08 -0500
Received: from mail.kernel.org ([198.145.29.136]:53172 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756183AbbAZRs6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 12:48:58 -0500
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>, Borislav Petkov <bp@suse.de>,
        David Ahern <dsahern@gmail.com>, Don Zickus <dzickus@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 21/26] perf trace: Fix error reporting for evsel pgfault constructor
Date: Mon, 26 Jan 2015 14:47:24 -0300
Message-Id: <1422294449-12735-22-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1422294449-12735-1-git-send-email-acme@kernel.org>
References: <1422294449-12735-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

In that case the only failure possible is not to have enough memory, as
we are just creating the evsels, not trying to access any system
facility such as debugfs files or syscalls.

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Borislav Petkov <bp@suse.de>
Cc: David Ahern <dsahern@gmail.com>
Cc: Don Zickus <dzickus@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-7k6asvfhiwiu2zs6o2oknchk@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-trace.c | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 684609d7a83d..eaaa540bf1f3 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -2063,18 +2063,12 @@ static int trace__run(struct trace *trace, int argc, const char **argv)
 
 	if ((trace->trace_pgfaults & TRACE_PFMAJ) &&
 	    perf_evlist__add_pgfault(evlist, PERF_COUNT_SW_PAGE_FAULTS_MAJ)) {
-		/*
-		 * FIXME: This one needs better error handling, as by now we
-		 * already checked that debugfs is mounted and that we have access to it,
-		 * so probably the case is that something is busted wrt this specific
-		 * software event, ditto for the next gotos to out_error_tp...
-		 */
-		goto out_error_tp;
+		goto out_error_mem;
 	}
 
 	if ((trace->trace_pgfaults & TRACE_PFMIN) &&
 	    perf_evlist__add_pgfault(evlist, PERF_COUNT_SW_PAGE_FAULTS_MIN))
-		goto out_error_tp;
+		goto out_error_mem;
 
 	if (trace->sched &&
 		perf_evlist__add_newtp(evlist, "sched", "sched_stat_runtime",
@@ -2225,6 +2219,9 @@ out_error:
 	fprintf(trace->output, "%s\n", errbuf);
 	goto out_delete_evlist;
 }
+out_error_mem:
+	fprintf(trace->output, "Not enough memory to run!\n");
+	goto out_delete_evlist;
 }
 
 static int trace__replay(struct trace *trace)
-- 
1.9.3

