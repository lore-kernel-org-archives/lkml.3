Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755436AbaGDMU4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 08:20:56 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:42906 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750714AbaGDMUz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 08:20:55 -0400
From: "xiaofeng.yan" <xiaofeng.yan@huawei.com>
To: <mingo@redhat.com>, <peterz@infradead.org>, <linux-kernel@vger.kernel.org>
CC: <xiaofeng.yan2012@gmail.com>, "xiaofeng.yan" <xiaofeng.yan@huawei.com>
Subject: [PATCH] sched/rt: overrun could happen in start_hrtick_dl
Date: Fri, 4 Jul 2014 12:02:21 +0000
Message-ID: <1404475341-22536-1-git-send-email-xiaofeng.yan@huawei.com>
X-Mailer: git-send-email 1.8.3.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.107.197.241]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It could be wrong for the precision of runtime and deadline
when the precision is within microsecond level. For example:
Task runtime deadline period
 P1   200us   500us   500us

This case need enbale HRTICK feature by the next command
PC#echo "HRTICK" > /sys/kernel/debug/sched_features
PC#./schedtool -E -t 200000:500000 -e ./test&
PC#trace-cmd record -e sched_switch

Some of runtime and deadline run with millisecond level by
reading kernershark.
The problem is caused by a conditional judgment "delta > 10000".
Because no hrtimer start up to control the runtime when runtime is less than 10us.
So the process will continue to run until tick-period coming.
For fixing this problem, Let delta is equal to 10us when it is less than 10us.
So the hrtimer will start up to control the end of process.

Signed-off-by: xiaofeng.yan <xiaofeng.yan@huawei.com>
---
 kernel/sched/deadline.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index fc4f98b1..dfefa82 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -997,10 +997,8 @@ static void check_preempt_curr_dl(struct rq *rq, struct task_struct *p,
 #ifdef CONFIG_SCHED_HRTICK
 static void start_hrtick_dl(struct rq *rq, struct task_struct *p)
 {
-	s64 delta = p->dl.dl_runtime - p->dl.runtime;
-
-	if (delta > 10000)
-		hrtick_start(rq, p->dl.runtime);
+	s64 delta = p->dl.runtime > 10000 ? p->dl.runtime : 10000;
+	hrtick_start(rq, delta);
 }
 #endif
 
-- 
1.7.9.5

