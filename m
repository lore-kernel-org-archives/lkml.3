Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932344Ab3JNUUX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 16:20:23 -0400
Received: from merlin.infradead.org ([205.233.59.134]:39037 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757721Ab3JNUDG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 16:03:06 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Ramkumar Ramachandra <artagnon@gmail.com>,
        David Ahern <dsahern@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 138/161] perf trace: Improve the error messages
Date: Mon, 14 Oct 2013 17:02:07 -0300
Message-Id: <1381780950-25642-139-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1381780950-25642-1-git-send-email-acme@infradead.org>
References: <1381780950-25642-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ramkumar Ramachandra <artagnon@gmail.com>

Currently, execution of 'perf trace' reports the following cryptic
message to the user:

$ perf trace
Couldn't read the raw_syscalls tracepoints information!

Typically this happens because the user does not have permissions to
read the debugfs filesystem. Also handle the case when the kernel was
not compiled with debugfs support or when it isn't mounted.

Now, the tool prints detailed error messages:

$ perf trace
Error:	Unable to find debugfs
Hint:	Was your kernel was compiled with debugfs support?
Hint:	Is the debugfs filesystem mounted?
Hint:	Try 'sudo mount -t debugfs nodev /sys/kernel/debug'

$ perf trace
Error:	No permissions to read /sys/kernel/debug//tracing/events/raw_syscalls
Hint:	Try 'sudo mount -o remount,mode=755 /sys/kernel/debug/'

Signed-off-by: Ramkumar Ramachandra <artagnon@gmail.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Link: http://lkml.kernel.org/r/1380863851-14460-1-git-send-email-artagnon@gmail.com
[ Added ready to use commands to fix the issues as extra hints, use the
  current debugfs mount point when reporting permission error, use
  strerror_r instead of the deprecated sys_errlist, as reported by David Ahern ]
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-trace.c | 37 ++++++++++++++++++++++++++++---------
 1 file changed, 28 insertions(+), 9 deletions(-)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 19ddcabc73d2..5496546b7c5c 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -1590,17 +1590,13 @@ static int trace__run(struct trace *trace, int argc, const char **argv)
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
@@ -1717,6 +1713,29 @@ out_delete_evlist:
 out:
 	trace->live = false;
 	return err;
+out_error_tp:
+	switch(errno) {
+	case ENOENT:
+		fputs("Error:\tUnable to find debugfs\n"
+		      "Hint:\tWas your kernel was compiled with debugfs support?\n"
+		      "Hint:\tIs the debugfs filesystem mounted?\n"
+		      "Hint:\tTry 'sudo mount -t debugfs nodev /sys/kernel/debug'\n",
+		      trace->output);
+		break;
+	case EACCES:
+		fprintf(trace->output,
+			"Error:\tNo permissions to read %s/tracing/events/raw_syscalls\n"
+			"Hint:\tTry 'sudo mount -o remount,mode=755 %s'\n",
+			debugfs_mountpoint, debugfs_mountpoint);
+		break;
+	default: {
+		char bf[256];
+		fprintf(trace->output, "Can't trace: %s\n",
+			strerror_r(errno, bf, sizeof(bf)));
+	}
+		break;
+	}
+	goto out_delete_evlist;
 }
 
 static int trace__replay(struct trace *trace)
-- 
1.8.1.4

