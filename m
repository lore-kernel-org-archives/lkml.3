Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752883Ab3JDFYi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 01:24:38 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:35048 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751234Ab3JDFYg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 01:24:36 -0400
From: Ramkumar Ramachandra <artagnon@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, David Ahern <dsahern@gmail.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: [PATCH v2] perf tool: report user-friendly errors from trace
Date: Fri,  4 Oct 2013 10:47:31 +0530
Message-Id: <1380863851-14460-1-git-send-email-artagnon@gmail.com>
X-Mailer: git-send-email 1.8.4.477.g5d89aa9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, execution of 'perf trace' reports the following cryptic
message to the user:

$ perf trace
Couldn't read the raw_syscalls tracepoints information!

Typically this happens because the user does not have permissions to
read the debugfs filesystem. Also handle the case when the kernel was
not compiled with debugfs support or when it isn't mounted.

Now, the tool prints detailed error messages:

$ perf trace
Error:  Unable to find debugfs
Hint:   Was your kernel was compiled with debugfs support?
Hint:   Is the debugfs filesystem mounted?

$ perf trace
Error:  No permissions to read $debugfs/tracing/events/raw_syscalls
Hint:   Change the permissions of the debugfs filesystem

Cc: Ingo Molnar <mingo@kernel.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Signed-off-by: Ramkumar Ramachandra <artagnon@gmail.com>
---
 We don't want to spoonfeed the user with an exact command-line to
 execute. She is competent enough to Google and find out what debugfs
 is, and how to use it.

 tools/perf/builtin-trace.c | 30 +++++++++++++++++++++---------
 1 file changed, 21 insertions(+), 9 deletions(-)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 71aa3e3..ee32453 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -915,17 +915,13 @@ static int trace__run(struct trace *trace, int argc, const char **argv)
 	}
 
 	if (perf_evlist__add_newtp(evlist, "raw_syscalls", "sys_enter", trace__sys_enter) ||
-	    perf_evlist__add_newtp(evlist, "raw_syscalls", "sys_exit", trace__sys_exit)) {
-		fprintf(trace->output, "Couldn't read the raw_syscalls tracepoints information!\n");
-		goto out_delete_evlist;
-	}
+		perf_evlist__add_newtp(evlist, "raw_syscalls", "sys_exit", trace__sys_exit))
+		goto out_error_tp;
 
 	if (trace->sched &&
-	    perf_evlist__add_newtp(evlist, "sched", "sched_stat_runtime",
-				   trace__sched_stat_runtime)) {
-		fprintf(trace->output, "Couldn't read the sched_stat_runtime tracepoint information!\n");
-		goto out_delete_evlist;
-	}
+		perf_evlist__add_newtp(evlist, "sched", "sched_stat_runtime",
+				trace__sched_stat_runtime))
+		goto out_error_tp;
 
 	err = perf_evlist__create_maps(evlist, &trace->opts.target);
 	if (err < 0) {
@@ -1041,6 +1037,22 @@ out_delete_evlist:
 	perf_evlist__delete(evlist);
 out:
 	return err;
+out_error_tp:
+	switch(errno) {
+	case ENOENT:
+		fprintf(trace->output, "Error:\tUnable to find debugfs\n");
+		fprintf(trace->output, "Hint:\tWas your kernel was compiled with debugfs support?\n");
+		fprintf(trace->output, "Hint:\tIs the debugfs filesystem mounted?\n");
+		break;
+	case EACCES:
+		fprintf(trace->output, "Error:\tNo permissions to read $debugfs/tracing/events/raw_syscalls\n");
+		fprintf(trace->output, "Hint:\tChange the permissions of the debugfs filesystem\n");
+		break;
+	default:
+		fprintf(trace->output, "Can't trace: %s\n", sys_errlist[errno]);
+		break;
+	}
+	goto out_delete_evlist;
 }
 
 static int trace__replay(struct trace *trace)
-- 
1.8.4.477.g5d89aa9

