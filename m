Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754122Ab3KLOmY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 09:42:24 -0500
Received: from mail-la0-f50.google.com ([209.85.215.50]:45886 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751534Ab3KLOmW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 09:42:22 -0500
From: Pekka Enberg <penberg@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Pekka Enberg <penberg@kernel.org>, David Ahern <dsahern@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: [PATCH] perf trace: Simplify '--summary' output
Date: Tue, 12 Nov 2013 16:42:14 +0200
Message-Id: <1384267334-18953-1-git-send-email-penberg@kernel.org>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The output of 'perf trace --summary' tries to be too cute with
formatting and makes it very hard to read.  Simplify it in the spirit of
"strace -c":

[penberg@localhost libtrading]$ perf trace -a --duration 10000 --summary -- sleep 1
^C
 Summary of events:

 dbus-daemon (555), 10 events, 0.0%, 0.000 msec

                                                    msec/call
   syscall            calls      min      avg      max stddev
   --------------- -------- -------- -------- -------- ------
   sendmsg                2    0.002    0.005    0.008  55.00
   recvmsg                2    0.002    0.003    0.005  44.00
   epoll_wait             1    0.000    0.000    0.000   0.00

 NetworkManager (667), 56 events, 0.0%, 0.000 msec

                                                    msec/call
   syscall            calls      min      avg      max stddev
   --------------- -------- -------- -------- -------- ------
   poll                   2    0.000    0.002    0.003 100.00
   sendmsg               10    0.004    0.007    0.016  15.41
   recvmsg               16    0.002    0.003    0.005   8.24

 zfs-fuse (669), 4 events, 0.0%, 0.000 msec

                                                    msec/call
   syscall            calls      min      avg      max stddev
   --------------- -------- -------- -------- -------- ------
   futex                  2    0.000    0.001    0.002 100.00

Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Signed-off-by: Pekka Enberg <penberg@kernel.org>
---
 tools/perf/builtin-trace.c | 25 ++++++++++++-------------
 1 file changed, 12 insertions(+), 13 deletions(-)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index f841d2a..22354c8 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -2082,12 +2082,7 @@ static size_t trace__fprintf_threads_header(FILE *fp)
 {
 	size_t printed;
 
-	printed  = fprintf(fp, "\n _____________________________________________________________________________\n");
-	printed += fprintf(fp, " __)    Summary of events    (__\n\n");
-	printed += fprintf(fp, "              [ task - pid ]     [ events ] [ ratio ]  [ runtime ]\n");
-	printed += fprintf(fp, "                                  syscall  count    min     avg    max  stddev\n");
-	printed += fprintf(fp, "                                                   msec    msec   msec     %%\n");
-	printed += fprintf(fp, " _____________________________________________________________________________\n\n");
+	printed  = fprintf(fp, "\n Summary of events:\n\n");
 
 	return printed;
 }
@@ -2105,6 +2100,10 @@ static size_t thread__dump_stats(struct thread_trace *ttrace,
 
 	printed += fprintf(fp, "\n");
 
+	printed += fprintf(fp, "                                                    msec/call\n");
+	printed += fprintf(fp, "   syscall            calls      min      avg      max stddev\n");
+	printed += fprintf(fp, "   --------------- -------- -------- -------- -------- ------\n");
+
 	/* each int_node is a syscall */
 	while (inode) {
 		stats = inode->priv;
@@ -2119,10 +2118,10 @@ static size_t thread__dump_stats(struct thread_trace *ttrace,
 			avg /= NSEC_PER_MSEC;
 
 			sc = &trace->syscalls.table[inode->i];
-			printed += fprintf(fp, "%24s  %14s : ", "", sc->name);
-			printed += fprintf(fp, "%5" PRIu64 "  %8.3f  %8.3f",
+			printed += fprintf(fp, "   %-15s", sc->name);
+			printed += fprintf(fp, " %8" PRIu64 " %8.3f %8.3f",
 					   n, min, avg);
-			printed += fprintf(fp, "  %8.3f  %6.2f\n", max, pct);
+			printed += fprintf(fp, " %8.3f %6.2f\n", max, pct);
 		}
 
 		inode = intlist__next(inode);
@@ -2163,10 +2162,10 @@ static int trace__fprintf_one_thread(struct thread *thread, void *priv)
 	else if (ratio > 5.0)
 		color = PERF_COLOR_YELLOW;
 
-	printed += color_fprintf(fp, color, "%20s", thread__comm_str(thread));
-	printed += fprintf(fp, " - %-5d :%11lu   [", thread->tid, ttrace->nr_events);
-	printed += color_fprintf(fp, color, "%5.1f%%", ratio);
-	printed += fprintf(fp, " ] %10.3f ms\n", ttrace->runtime_ms);
+	printed += color_fprintf(fp, color, " %s (%d), ", thread__comm_str(thread), thread->tid);
+	printed += fprintf(fp, "%lu events, ", ttrace->nr_events);
+	printed += color_fprintf(fp, color, "%.1f%%", ratio);
+	printed += fprintf(fp, ", %.3f msec\n", ttrace->runtime_ms);
 	printed += thread__dump_stats(ttrace, trace, fp);
 
 	data->printed += printed;
-- 
1.8.3.1

