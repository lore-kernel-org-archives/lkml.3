Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753397Ab3JCIfT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 04:35:19 -0400
Received: from mail-pb0-f42.google.com ([209.85.160.42]:51078 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751587Ab3JCIfQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 04:35:16 -0400
From: Ramkumar Ramachandra <artagnon@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: [PATCH] perf tool: more user-friendly errors from trace
Date: Thu,  3 Oct 2013 13:58:11 +0530
Message-Id: <1380788891-31908-1-git-send-email-artagnon@gmail.com>
X-Mailer: git-send-email 1.8.4.477.g5d89aa9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, execution of 'perf trace' reports the following cryptic
message to the user:

$ perf trace
Couldn't read the raw_syscalls tracepoints information!

Now, it prints a detailed message:

$ perf trace
Error:  No permissions to read $debugfs/tracing/events/raw_syscalls
Hint:   Change the permissions of debugfs: /sys/kernel/debug
        The directory will be present if your kernel was compiled with debugfs support.

Cc: Ingo Molnar <mingo@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Signed-off-by: Ramkumar Ramachandra <artagnon@gmail.com>
---
 tools/perf/builtin-trace.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 71aa3e3..544707a 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -916,14 +916,18 @@ static int trace__run(struct trace *trace, int argc, const char **argv)
 
 	if (perf_evlist__add_newtp(evlist, "raw_syscalls", "sys_enter", trace__sys_enter) ||
 	    perf_evlist__add_newtp(evlist, "raw_syscalls", "sys_exit", trace__sys_exit)) {
-		fprintf(trace->output, "Couldn't read the raw_syscalls tracepoints information!\n");
+		fprintf(trace->output, "Error:\tNo permissions to read $debugfs/tracing/events/raw_syscalls\n");
+		fprintf(trace->output, "Hint:\tChange the permissions of debugfs: /sys/kernel/debug\n");
+		fprintf(trace->output, "\tThe directory will be present if your kernel was compiled with debugfs support.\n");
 		goto out_delete_evlist;
 	}
 
 	if (trace->sched &&
 	    perf_evlist__add_newtp(evlist, "sched", "sched_stat_runtime",
 				   trace__sched_stat_runtime)) {
-		fprintf(trace->output, "Couldn't read the sched_stat_runtime tracepoint information!\n");
+		fprintf(trace->output, "Error:\tNo permissions to read $debugfs/tracing/events/sched/sched_stat_runtime\n");
+		fprintf(trace->output, "Hint:\tChange the permissions of debugfs: /sys/kernel/debug\n");
+		fprintf(trace->output, "\tThe directory will be present if your kernel was compiled with debugfs support.\n");
 		goto out_delete_evlist;
 	}
 
-- 
1.8.4.477.g5d89aa9

