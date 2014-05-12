Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755697AbaELQBW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 12:01:22 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53576 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754512AbaELQBU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 12:01:20 -0400
Date: Mon, 12 May 2014 09:01:06 -0700
From: tip-bot for Dongsheng <tipbot@zytor.com>
Message-ID: <tip-6bcab4e1eaa1f669d003051ef3b87a963d8763bb@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        jolsa@kernel.org, tglx@linutronix.de, yangds.fnst@cn.fujitsu.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        jolsa@kernel.org, tglx@linutronix.de, yangds.fnst@cn.fujitsu.com
In-Reply-To: <1399354741-19522-1-git-send-email-yangds.fnst@cn.fujitsu.com>
References: <1399354741-19522-1-git-send-email-yangds.fnst@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Clarify the output of perf sched map.
Git-Commit-ID: 6bcab4e1eaa1f669d003051ef3b87a963d8763bb
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6bcab4e1eaa1f669d003051ef3b87a963d8763bb
Gitweb:     http://git.kernel.org/tip/6bcab4e1eaa1f669d003051ef3b87a963d8763bb
Author:     Dongsheng <yangds.fnst@cn.fujitsu.com>
AuthorDate: Tue, 6 May 2014 14:39:01 +0900
Committer:  Jiri Olsa <jolsa@kernel.org>
CommitDate: Mon, 12 May 2014 11:09:05 +0200

perf tools: Clarify the output of perf sched map.

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
 
