Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932433Ab3JNUUf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 16:20:35 -0400
Received: from merlin.infradead.org ([205.233.59.134]:39008 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757710Ab3JNUDG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 16:03:06 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung.kim@lge.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 120/161] perf stat: Fix misleading message when specifying cpu list or system wide
Date: Mon, 14 Oct 2013 17:01:49 -0300
Message-Id: <1381780950-25642-121-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1381780950-25642-1-git-send-email-acme@infradead.org>
References: <1381780950-25642-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

The "perf stat" tool displays the command run in its summary output
which is misleading when using a cpu list or system wide collection.

Before:

perf stat -a -- sleep 1

 Performance counter stats for 'sleep 1':

16152.670249 task-clock                #   16.132 CPUs utilized
         417 context-switches          #    0.002 M/sec
           7 cpu-migrations            #    0.030 K/sec
...

After:

perf stat -a -- sleep 1

 Performance counter stats for 'system wide':

16206.931120 task-clock                #   16.144 CPUs utilized
         395 context-switches          #    0.002 M/sec
           5 cpu-migrations            #    0.030 K/sec
...

or

perf stat -C1 -- sleep 1

 Performance counter stats for 'CPU(s) 1':

   1001.669257 task-clock                #    1.000 CPUs utilized
         4,264 context-switches          #    0.004 M/sec
             3 cpu-migrations            #    0.003 K/sec
...

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1380400080-9211-2-git-send-email-dsahern@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-stat.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index fb02b53b0e3d..c8a2662eb57a 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -1229,7 +1229,11 @@ static void print_stat(int argc, const char **argv)
 	if (!csv_output) {
 		fprintf(output, "\n");
 		fprintf(output, " Performance counter stats for ");
-		if (!perf_target__has_task(&target)) {
+		if (target.system_wide)
+			fprintf(output, "\'system wide");
+		else if (target.cpu_list)
+			fprintf(output, "\'CPU(s) %s", target.cpu_list);
+		else if (!perf_target__has_task(&target)) {
 			fprintf(output, "\'%s", argv[0]);
 			for (i = 1; i < argc; i++)
 				fprintf(output, " %s", argv[i]);
-- 
1.8.1.4

