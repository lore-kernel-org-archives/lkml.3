Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755063AbbA1VVh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 16:21:37 -0500
Received: from terminus.zytor.com ([198.137.202.10]:40980 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965021AbbA1UuR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:50:17 -0500
Date: Wed, 28 Jan 2015 07:09:23 -0800
From: tip-bot for Arnaldo Carvalho de Melo <tipbot@zytor.com>
Message-ID: <tip-7k6asvfhiwiu2zs6o2oknchk@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, acme@redhat.com,
        hpa@zytor.com, fweisbec@gmail.com, bp@suse.de, dsahern@gmail.com,
        dzickus@redhat.com, namhyung@kernel.org, jolsa@redhat.com,
        mingo@kernel.org, tglx@linutronix.de, adrian.hunter@intel.com
Reply-To: tglx@linutronix.de, jolsa@redhat.com, mingo@kernel.org,
        namhyung@kernel.org, dzickus@redhat.com, adrian.hunter@intel.com,
        hpa@zytor.com, linux-kernel@vger.kernel.org, acme@redhat.com,
        eranian@google.com, dsahern@gmail.com, bp@suse.de, fweisbec@gmail.com
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf trace:
  Fix error reporting for evsel pgfault constructor
Git-Commit-ID: 5ed08dae9d2f2307c103e2dce94d801e74aefae4
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5ed08dae9d2f2307c103e2dce94d801e74aefae4
Gitweb:     http://git.kernel.org/tip/5ed08dae9d2f2307c103e2dce94d801e74aefae4
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Thu, 22 Jan 2015 11:08:04 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 22 Jan 2015 11:16:34 -0300

perf trace: Fix error reporting for evsel pgfault constructor

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
index 684609d..eaaa540 100644
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
