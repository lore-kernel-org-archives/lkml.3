Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754307AbaDONda (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 09:33:30 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:1774 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753190AbaDONcz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 09:32:55 -0400
X-IronPort-AV: E=Sophos;i="4.97,863,1389715200"; 
   d="scan'208";a="29292491"
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
To: <rostedt@goodmis.org>, <fweisbec@gmail.com>, <mingo@redhat.com>,
        <peterz@infradead.org>, <acme@ghostprotocols.net>
CC: <linux-kernel@vger.kernel.org>, Dongsheng <yangds.fnst@cn.fujitsu.com>
Subject: [PATCH 8/8] perf tools: Clarify the output of perf sched map.
Date: Tue, 15 Apr 2014 21:32:57 +0900
Message-ID: <34fc331d6bf5f6dbc8d622b142db92f0c163c9db.1397562542.git.yangds.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <cover.1397562542.git.yangds.fnst@cn.fujitsu.com>
References: <cover.1397562542.git.yangds.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.167.226.49]
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
as the explaination for swapper:0.

Example:
              *A0       228836.978985 secs A0 => perf:23032
          * .  A0       228836.979016 secs . => swapper:0
            . *B0       228836.979099 secs B0 => migration/3:22
  *A0       .  B0       228836.979115 secs
   A0       . * .       228836.979115 secs
   A0     *C0   .       228836.979225 secs C0 => ksoftirqd/2:18
   A0     *D0   .       228836.979236 secs D0 => rcu_sched:7

Signed-off-by: Dongsheng <yangds.fnst@cn.fujitsu.com>
---
 tools/perf/builtin-sched.c | 35 +++++++++++++++++++----------------
 1 file changed, 19 insertions(+), 16 deletions(-)

diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index 030b7d0..727b8a0 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -1359,17 +1359,23 @@ static int map_switch_event(struct perf_sched *sched, struct perf_evsel *evsel,
 
 	new_shortname = 0;
 	if (!sched_in->shortname[0]) {
-		sched_in->shortname[0] = sched->next_shortname1;
-		sched_in->shortname[1] = sched->next_shortname2;
-
-		if (sched->next_shortname1 < 'Z') {
-			sched->next_shortname1++;
-		} else {
-			sched->next_shortname1='A';
-			if (sched->next_shortname2 < '9') {
-				sched->next_shortname2++;
+		if (!strcmp(thread__comm_str(sched_in), "swapper")) {
+			sched_in->shortname[0] = '.';
+			sched_in->shortname[1] = '\0';
+		}
+		else {
+			sched_in->shortname[0] = sched->next_shortname1;
+			sched_in->shortname[1] = sched->next_shortname2;
+
+			if (sched->next_shortname1 < 'Z') {
+				sched->next_shortname1++;
 			} else {
-				sched->next_shortname2='0';
+				sched->next_shortname1='A';
+				if (sched->next_shortname2 < '9') {
+					sched->next_shortname2++;
+				} else {
+					sched->next_shortname2='0';
+				}
 			}
 		}
 		new_shortname = 1;
@@ -1381,12 +1387,9 @@ static int map_switch_event(struct perf_sched *sched, struct perf_evsel *evsel,
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
1.8.2.1

