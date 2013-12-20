Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755838Ab3LTTJ7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 14:09:59 -0500
Received: from merlin.infradead.org ([205.233.59.134]:38494 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752147Ab3LTTJ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 14:09:29 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 35/35] perf stat: Do not show stats if workload fails
Date: Fri, 20 Dec 2013 16:09:10 -0300
Message-Id: <1387566550-3524-36-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1387566550-3524-1-git-send-email-acme@infradead.org>
References: <1387566550-3524-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

Currently perf-stat attempts to show counter stats even if the workload
is bogus:

  $ perf stat -- foo
  foo: No such file or directory

   Performance counter stats for 'foo':

       <not counted>      task-clock
       <not counted>      context-switches
       <not counted>      cpu-migrations
       <not counted>      page-faults
       <not counted>      cycles
       <not counted>      stalled-cycles-frontend
       <not counted>      stalled-cycles-backend
       <not counted>      instructions
       <not counted>      branches
       <not counted>      branch-misses

         0.009769943 seconds time elapsed

It is impossible to differentiate all the failure modes, but it seems
reasonable that if the workload handling fails, perf-stat should not try
to print stats.

With this change:

  $ perf stat  -v -- foo
  Failed to start workload

Signed-off-by: David Ahern <dsahern@gmail.com>
Acked-by: Ingo Molnar <mingo@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1387518748-25340-1-git-send-email-dsahern@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-stat.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index dab98b50c9fe..d6e6a0b031d9 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -586,7 +586,11 @@ static int __run_perf_stat(int argc, const char **argv)
 	clock_gettime(CLOCK_MONOTONIC, &ref_time);
 
 	if (forks) {
-		perf_evlist__start_workload(evsel_list);
+		if (perf_evlist__start_workload(evsel_list) != 0) {
+			pr_err("Failed to start workload\n");
+			return -1;
+		}
+
 		handle_initial_delay();
 
 		if (interval) {
@@ -1793,7 +1797,10 @@ int cmd_stat(int argc, const char **argv, const char *prefix __maybe_unused)
 				run_idx + 1);
 
 		status = run_perf_stat(argc, argv);
-		if (forever && status != -1) {
+		if (status < 0)
+			break;
+
+		if (forever) {
 			print_stat(argc, argv);
 			perf_stat__reset_stats(evsel_list);
 		}
-- 
1.8.1.4

