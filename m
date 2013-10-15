Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758380Ab3JOFcv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 01:32:51 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33687 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932813Ab3JOFcr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 01:32:47 -0400
Date: Mon, 14 Oct 2013 22:32:35 -0700
From: tip-bot for Ramkumar Ramachandra <tipbot@zytor.com>
Message-ID: <tip-87f918685a452be514d060a09eeb4e0c91422e86@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, dsahern@gmail.com, artagnon@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, dsahern@gmail.com, tglx@linutronix.de,
        artagnon@gmail.com
In-Reply-To: <1380863851-14460-1-git-send-email-artagnon@gmail.com>
References: <1380863851-14460-1-git-send-email-artagnon@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf trace: Improve the error messages
Git-Commit-ID: 87f918685a452be514d060a09eeb4e0c91422e86
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 14 Oct 2013 22:32:41 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  87f918685a452be514d060a09eeb4e0c91422e86
Gitweb:     http://git.kernel.org/tip/87f918685a452be514d060a09eeb4e0c91422e86
Author:     Ramkumar Ramachandra <artagnon@gmail.com>
AuthorDate: Fri, 4 Oct 2013 10:47:31 +0530
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 14 Oct 2013 10:24:04 -0300

perf trace: Improve the error messages

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
index 19ddcab..5496546 100644
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
