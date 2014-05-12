Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754914AbaELJ1g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 05:27:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18285 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754647AbaELJ1e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 05:27:34 -0400
From: Jiri Olsa <jolsa@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Dongsheng <yangds.fnst@cn.fujitsu.com>,
        Jiri Olsa <jolsa@kernel.org>
Subject: [PATCH 3/6] perf tools: Clarify the output of perf sched map.
Date: Mon, 12 May 2014 11:27:10 +0200
Message-Id: <1399886833-15472-4-git-send-email-jolsa@kernel.org>
In-Reply-To: <1399886833-15472-1-git-send-email-jolsa@kernel.org>
References: <1399886833-15472-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dongsheng <yangds.fnst@cn.fujitsu.com>

In output of perf sched map, any shortname of thread will be explained
at the first time when it appear.

Example:
              *A0       228836.978985 secs A0 => perf:23032
          *.   A0       228836.979016 secs B0 => swapper:0
           .  *C0       228836.979099 secs C0 => migration/3:22
  *A0      .   C0       228836.979115 secs
   A0      .  *.        228836.979115 secs

But B0, which is explained as swapper:0 did not appear in the
left part of output. Instead, we use '.' as the shortname of
swapper:0. So the comment of "B0 => swapper:0" is not easy to
understand.

This patch clarify the output of perf sched map with not allocating
one letter-number shortname for swapper:0 and print ". => swapper:0"
as the explanation for swapper:0.

Example:
              *A0       228836.978985 secs A0 => perf:23032
          * .  A0       228836.979016 secs .  => swapper:0
            . *B0       228836.979099 secs B0 => migration/3:22
  *A0       .  B0       228836.979115 secs
   A0       . * .       228836.979115 secs
   A0     *C0   .       228836.979225 secs C0 => ksoftirqd/2:18
   A0     *D0   .       228836.979236 secs D0 => rcu_sched:7

Signed-off-by: Dongsheng <yangds.fnst@cn.fujitsu.com>
Acked-by: Ingo Molnar <mingo@kernel.org>
Link: http://lkml.kernel.org/r/1399354741-19522-1-git-send-email-yangds.fnst@cn.fujitsu.com
[ small style fixes to make checkpatch happy ]
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/perf/builtin-sched.c | 35 ++++++++++++++++++++---------------
 1 file changed, 20 insertions(+), 15 deletions(-)

diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index 4f0dd21..2579215 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -1300,17 +1300,25 @@ static int map_switch_event(struct perf_sched *sched, struct perf_evsel *evsel,
 
 	new_shortname = 0;
 	if (!sched_in->shortname[0]) {
-		sched_in->shortname[0] = sched->next_shortname1;
-		sched_in->shortname[1] = sched->next_shortname2;
-
-		if (sched->next_shortname1 < 'Z') {
-			sched->next_shortname1++;
+		if (!strcmp(thread__comm_str(sched_in), "swapper")) {
+			/*
+			 * Don't allocate a letter-number for swapper:0
+			 * as a shortname. Instead, we use '.' for it.
+			 */
+			sched_in->shortname[0] = '.';
+			sched_in->shortname[1] = ' ';
 		} else {
-			sched->next_shortname1='A';
-			if (sched->next_shortname2 < '9') {
-				sched->next_shortname2++;
+			sched_in->shortname[0] = sched->next_shortname1;
+			sched_in->shortname[1] = sched->next_shortname2;
+
+			if (sched->next_shortname1 < 'Z') {
+				sched->next_shortname1++;
 			} else {
-				sched->next_shortname2='0';
+				sched->next_shortname1 = 'A';
+				if (sched->next_shortname2 < '9')
+					sched->next_shortname2++;
+				else
+					sched->next_shortname2 = '0';
 			}
 		}
 		new_shortname = 1;
@@ -1322,12 +1330,9 @@ static int map_switch_event(struct perf_sched *sched, struct perf_evsel *evsel,
 		else
 			printf("*");
 
-		if (sched->curr_thread[cpu]) {
-			if (sched->curr_thread[cpu]->tid)
-				printf("%2s ", sched->curr_thread[cpu]->shortname);
-			else
-				printf(".  ");
-		} else
+		if (sched->curr_thread[cpu])
+			printf("%2s ", sched->curr_thread[cpu]->shortname);
+		else
 			printf("   ");
 	}
 
-- 
1.8.3.1

