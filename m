Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755193Ab3I1U2M (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Sep 2013 16:28:12 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:39643 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755022Ab3I1U2H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Sep 2013 16:28:07 -0400
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: David Ahern <dsahern@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung.kim@lge.com>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 1/3] perf stat: Fix misleading message when specifying cpu list or system wide
Date: Sat, 28 Sep 2013 14:27:58 -0600
Message-Id: <1380400080-9211-2-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1380400080-9211-1-git-send-email-dsahern@gmail.com>
References: <1380400080-9211-1-git-send-email-dsahern@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

perf-stat displays the command run in its summary output which is misleading
when using a cpu list or system wide collection.

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
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Stephane Eranian <eranian@google.com>
---
 tools/perf/builtin-stat.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index f686d5f..6cc0aa2 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -1115,7 +1115,11 @@ static void print_stat(int argc, const char **argv)
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
1.7.10.1

