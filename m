Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759299AbaDKAUP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 20:20:15 -0400
Received: from mail-qg0-f47.google.com ([209.85.192.47]:54051 "EHLO
	mail-qg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753811AbaDKAUO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 20:20:14 -0400
From: Ramkumar Ramachandra <artagnon@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>, David Ahern <dsahern@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH v2] perf stat: Don't print bogus data for stalled-cycles
Date: Thu, 10 Apr 2014 20:20:31 -0400
Message-Id: <1397175631-30888-1-git-send-email-artagnon@gmail.com>
X-Mailer: git-send-email 1.9.2.667.ge5b74e1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the stalled-cycles-frontend event is requested without the cycles
event:

  $ perf stat -e stalled-cycles-frontend -- git s
  ## acme...ram/acme

   Performance counter stats for 'git s':

         326,947,423      stalled-cycles-frontend   #    0.00% frontend cycles idle

         0.363599976 seconds time elapsed

The 0.00% frontend cycles idle comment in the output is totally bogus
and misleading. Omit printing it here, as well as in the
stalled-cycles-backend case.

Cc: Jiri Olsa <jolsa@redhat.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Ramkumar Ramachandra <artagnon@gmail.com>
---
 tools/perf/builtin-stat.c | 26 ++++++++++++--------------
 1 file changed, 12 insertions(+), 14 deletions(-)

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 8b0e1c9..0bd98fa 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -797,14 +797,13 @@ static void print_stalled_cycles_frontend(int cpu,
 
 	total = avg_stats(&runtime_cycles_stats[cpu]);
 
-	if (total)
+	if (total) {
 		ratio = avg / total * 100.0;
-
-	color = get_ratio_color(GRC_STALLED_CYCLES_FE, ratio);
-
-	fprintf(output, " #  ");
-	color_fprintf(output, color, "%6.2f%%", ratio);
-	fprintf(output, " frontend cycles idle   ");
+		color = get_ratio_color(GRC_STALLED_CYCLES_FE, ratio);
+		fprintf(output, " #  ");
+		color_fprintf(output, color, "%6.2f%%", ratio);
+		fprintf(output, " frontend cycles idle   ");
+	}
 }
 
 static void print_stalled_cycles_backend(int cpu,
@@ -816,14 +815,13 @@ static void print_stalled_cycles_backend(int cpu,
 
 	total = avg_stats(&runtime_cycles_stats[cpu]);
 
-	if (total)
+	if (total) {
 		ratio = avg / total * 100.0;
-
-	color = get_ratio_color(GRC_STALLED_CYCLES_BE, ratio);
-
-	fprintf(output, " #  ");
-	color_fprintf(output, color, "%6.2f%%", ratio);
-	fprintf(output, " backend  cycles idle   ");
+		color = get_ratio_color(GRC_STALLED_CYCLES_BE, ratio);
+		fprintf(output, " #  ");
+		color_fprintf(output, color, "%6.2f%%", ratio);
+		fprintf(output, " backend  cycles idle   ");
+	}
 }
 
 static void print_branch_misses(int cpu,
-- 
1.9.2.667.ge5b74e1

