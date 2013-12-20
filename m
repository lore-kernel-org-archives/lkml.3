Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753610Ab3LTFwf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 00:52:35 -0500
Received: from mail-pa0-f49.google.com ([209.85.220.49]:41773 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751799Ab3LTFwe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 00:52:34 -0500
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: David Ahern <dsahern@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH] perf stat: Do not show stats if workload fails
Date: Thu, 19 Dec 2013 22:52:28 -0700
Message-Id: <1387518748-25340-1-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.8.3.4 (Apple Git-47)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Stephane Eranian <eranian@google.com>
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
1.8.3.4 (Apple Git-47)

