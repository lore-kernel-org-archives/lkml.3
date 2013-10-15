Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758578Ab3JOFkY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 01:40:24 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33503 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752428Ab3JOFaX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 01:30:23 -0400
Date: Mon, 14 Oct 2013 22:29:59 -0700
From: tip-bot for David Ahern <tipbot@zytor.com>
Message-ID: <tip-62d3b617c02785a4f1fbde8d93ca77a0b33d8454@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, jolsa@redhat.com, fweisbec@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, jolsa@redhat.com, fweisbec@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de
In-Reply-To: <1380400080-9211-2-git-send-email-dsahern@gmail.com>
References: <1380400080-9211-2-git-send-email-dsahern@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf stat:
  Fix misleading message when specifying cpu list or system wide
Git-Commit-ID: 62d3b617c02785a4f1fbde8d93ca77a0b33d8454
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 14 Oct 2013 22:30:05 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  62d3b617c02785a4f1fbde8d93ca77a0b33d8454
Gitweb:     http://git.kernel.org/tip/62d3b617c02785a4f1fbde8d93ca77a0b33d8454
Author:     David Ahern <dsahern@gmail.com>
AuthorDate: Sat, 28 Sep 2013 14:27:58 -0600
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 11 Oct 2013 12:17:42 -0300

perf stat: Fix misleading message when specifying cpu list or system wide

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
index fb02b53..c8a2662 100644
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
