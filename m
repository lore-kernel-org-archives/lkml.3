Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754074AbaGHJYS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 05:24:18 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:65171 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753127AbaGHJYR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 05:24:17 -0400
From: "xiaofeng.yan" <xiaofeng.yan@huawei.com>
To: <mingo@redhat.com>, <peterz@infradead.org>, <juri.lelli@gmail.com>,
        <linux-kernel@vger.kernel.org>
CC: <xiaofeng.yan2012@gmail.com>, "xiaofeng.yan" <xiaofeng.yan@huawei.com>
Subject: [PATCH] sched/deadline: overrun could happen in start_hrtick_dl
Date: Tue, 8 Jul 2014 09:06:51 +0000
Message-ID: <1404810411-27496-1-git-send-email-xiaofeng.yan@huawei.com>
X-Mailer: git-send-email 1.8.3.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.107.197.241]
X-CFilter-Loop: Reflected
X-Mirapoint-Virus-RAPID-Raw: score=unknown(0),
	refid=str=0001.0A020208.53BBB8BF.0097,ss=1,re=0.000,fgs=0,
	ip=0.0.0.0,
	so=2013-05-26 15:14:31,
	dmn=2011-05-27 18:58:46
X-Mirapoint-Loop-Id: ac0e6bbaa8fd4d09002b39c4e5506a48
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It could be wrong for the precision of runtime and deadline
when the precision is within microsecond level. For example:
Task runtime deadline period
 P1   200us   500us   500us

This case need enbale HRTICK feature by the next command
PC#echo "HRTICK" > /sys/kernel/debug/sched_features
PC#trace-cmd record -e sched_switch &
PC#./schedtool -E -t 200000:500000 -e ./test

Some of runtime and deadline run with millisecond level by
reading kernershark. Some pieces of trace.dat are as follows:
(remove some irrelevant information)
<idle>-0   157.603157: sched_switch: :R ==> 2481:4294967295: test
test-2481  157.603203: sched_switch:  2481:R ==> 0:120: swapper/2
<idle>-0   157.605657: sched_switch:  :R ==> 2481:4294967295: test
test-2481  157.608183: sched_switch:  2481:R ==> 2483:120: trace-cmd
trace-cmd-2483 157.609656: sched_switch:2483:R==>2481:4294967295: test

We can get the runtime from the information at some point.
runtime = 157.605657 - 157.608183
runtime = 0.002526(2.526ms)
The correct runtime should be less than or equal to 200us at some point.

The problem is caused by a conditional judgment "delta > 10000".
Because no hrtimer start up to control the runtime when runtime is less than 10us.
So the process will continue to run until tick-period coming.
For fixing this problem, Let delta is equal to 10us when it is less than 10us.
So the hrtimer will start up to control the end of process.

Signed-off-by: Xiaofeng Yan <xiaofeng.yan@huawei.com>
---
 kernel/sched/deadline.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index fc4f98b1..51e6b0e 100644
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
+	s64 delta = max_t(s64, 10000LL, p->dl.runtime);
+	hrtick_start(rq, delta);
 }
 #endif
 
-- 
1.7.9.5

