Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752634Ab3JCJMv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 05:12:51 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:56982 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751357Ab3JCJMu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 05:12:50 -0400
From: Ramkumar Ramachandra <artagnon@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: [PATCH] perf tool: report user-friendly error from timechart
Date: Thu,  3 Oct 2013 14:35:46 +0530
Message-Id: <1380791146-7465-1-git-send-email-artagnon@gmail.com>
X-Mailer: git-send-email 1.8.4.477.g5d89aa9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Earlier, when 'timechart record' was invoked by a user without
permissions to debugfs:

$ perf timechart record
invalid or unsupported event: 'power:cpu_frequency'
Run 'perf list' for a list of valid events

 usage: perf record [<options>] [<command>]
    or: perf record [<options>] -- <command> [<options>]
[... detailed usage information ...]

This is highly user unfriendly, as the real problem is not reported to
the user correctly. Now, the user gets a much more friendly:

$ perf timechart record
Error:  No permissions to read $debugfs/tracing/events/power/cpu_frequency
Hint:   Change the permissions of debugfs: /sys/kernel/debug
        The directory will be present if your kernel was compiled with debugfs support.

Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Signed-off-by: Ramkumar Ramachandra <artagnon@gmail.com>
---
 tools/perf/builtin-timechart.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/tools/perf/builtin-timechart.c b/tools/perf/builtin-timechart.c
index c2e0231..ceaf9b8 100644
--- a/tools/perf/builtin-timechart.c
+++ b/tools/perf/builtin-timechart.c
@@ -1056,6 +1056,14 @@ static int __cmd_record(int argc, const char **argv)
 	}
 #endif
 
+	/* Perform a quick sanity check */
+	if (!is_valid_tracepoint("power:cpu_frequency")) {
+		fprintf(stderr, "Error:\tNo permissions to read $debugfs/tracing/events/power/cpu_frequency\n");
+		fprintf(stderr, "Hint:\tChange the permissions of debugfs: /sys/kernel/debug\n");
+		fprintf(stderr, "\tThe directory will be present if your kernel was compiled with debugfs support.\n");
+		return 1;
+	}
+
 	rec_argc = record_elems + argc - 1;
 	rec_argv = calloc(rec_argc + 1, sizeof(char *));
 
-- 
1.8.4.477.g5d89aa9

