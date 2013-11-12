Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932569Ab3KLWBB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 17:01:01 -0500
Received: from terminus.zytor.com ([198.137.202.10]:40225 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932373Ab3KLV5A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 16:57:00 -0500
Date: Tue, 12 Nov 2013 13:56:48 -0800
From: tip-bot for Pekka Enberg <tipbot@zytor.com>
Message-ID: <tip-99ff7150547382ee612c40d8d6a0670ddec7c9fc@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, mingo@redhat.com,
        hpa@zytor.com, mingo@kernel.org, penberg@kernel.org, dsahern@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, mingo@redhat.com,
        linux-kernel@vger.kernel.org, acme@redhat.com, penberg@kernel.org,
        dsahern@gmail.com, tglx@linutronix.de
In-Reply-To: <1384267334-18953-1-git-send-email-penberg@kernel.org>
References: <1384267334-18953-1-git-send-email-penberg@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf trace: Simplify '--summary' output
Git-Commit-ID: 99ff7150547382ee612c40d8d6a0670ddec7c9fc
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Tue, 12 Nov 2013 13:56:54 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  99ff7150547382ee612c40d8d6a0670ddec7c9fc
Gitweb:     http://git.kernel.org/tip/99ff7150547382ee612c40d8d6a0670ddec7c9fc
Author:     Pekka Enberg <penberg@kernel.org>
AuthorDate: Tue, 12 Nov 2013 16:42:14 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 12 Nov 2013 13:00:38 -0300

perf trace: Simplify '--summary' output

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

Signed-off-by: Pekka Enberg <penberg@kernel.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Link: http://lkml.kernel.org/r/1384267334-18953-1-git-send-email-penberg@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-trace.c | 25 ++++++++++++-------------
 1 file changed, 12 insertions(+), 13 deletions(-)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 8990fbe..0964c0c 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -2090,12 +2090,7 @@ static size_t trace__fprintf_threads_header(FILE *fp)
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
@@ -2113,6 +2108,10 @@ static size_t thread__dump_stats(struct thread_trace *ttrace,
 
 	printed += fprintf(fp, "\n");
 
+	printed += fprintf(fp, "                                                    msec/call\n");
+	printed += fprintf(fp, "   syscall            calls      min      avg      max stddev\n");
+	printed += fprintf(fp, "   --------------- -------- -------- -------- -------- ------\n");
+
 	/* each int_node is a syscall */
 	while (inode) {
 		stats = inode->priv;
@@ -2127,10 +2126,10 @@ static size_t thread__dump_stats(struct thread_trace *ttrace,
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
@@ -2171,10 +2170,10 @@ static int trace__fprintf_one_thread(struct thread *thread, void *priv)
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
