Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754702AbaDONet (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 09:34:49 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:1774 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752347AbaDONcv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 09:32:51 -0400
X-IronPort-AV: E=Sophos;i="4.97,863,1389715200"; 
   d="scan'208";a="29292484"
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
To: <rostedt@goodmis.org>, <fweisbec@gmail.com>, <mingo@redhat.com>,
        <peterz@infradead.org>, <acme@ghostprotocols.net>
CC: <linux-kernel@vger.kernel.org>, Dongsheng <yangds.fnst@cn.fujitsu.com>
Subject: [PATCH 2/8] sched/wait: Add trace point before add task into wait queue.
Date: Tue, 15 Apr 2014 21:32:51 +0900
Message-ID: <2670d9eec717b8aab1328ea3c70efbfb052ff976.1397562542.git.yangds.fnst@cn.fujitsu.com>
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

As there are lots of functions in sched/wait.c to call __add_wait_queue{_tail}(),
we need to add trace point before any time we add task into wait queue, then this
patch add trace point in any possible route to adding task into wait queue.

Signed-off-by: Dongsheng <yangds.fnst@cn.fujitsu.com>
---
 kernel/sched/wait.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/kernel/sched/wait.c b/kernel/sched/wait.c
index 7d50f79..283750e 100644
--- a/kernel/sched/wait.c
+++ b/kernel/sched/wait.c
@@ -10,6 +10,8 @@
 #include <linux/wait.h>
 #include <linux/hash.h>
 
+#include <trace/events/sched.h>
+
 void __init_waitqueue_head(wait_queue_head_t *q, const char *name, struct lock_class_key *key)
 {
 	spin_lock_init(&q->lock);
@@ -23,6 +25,7 @@ void add_wait_queue(wait_queue_head_t *q, wait_queue_t *wait)
 {
 	unsigned long flags;
 
+	trace_sched_wait(current);
 	wait->flags &= ~WQ_FLAG_EXCLUSIVE;
 	spin_lock_irqsave(&q->lock, flags);
 	__add_wait_queue(q, wait);
@@ -34,6 +37,7 @@ void add_wait_queue_exclusive(wait_queue_head_t *q, wait_queue_t *wait)
 {
 	unsigned long flags;
 
+	trace_sched_wait(current);
 	wait->flags |= WQ_FLAG_EXCLUSIVE;
 	spin_lock_irqsave(&q->lock, flags);
 	__add_wait_queue_tail(q, wait);
@@ -172,6 +176,7 @@ prepare_to_wait(wait_queue_head_t *q, wait_queue_t *wait, int state)
 {
 	unsigned long flags;
 
+	trace_sched_wait(current);
 	wait->flags &= ~WQ_FLAG_EXCLUSIVE;
 	spin_lock_irqsave(&q->lock, flags);
 	if (list_empty(&wait->task_list))
@@ -186,6 +191,7 @@ prepare_to_wait_exclusive(wait_queue_head_t *q, wait_queue_t *wait, int state)
 {
 	unsigned long flags;
 
+	trace_sched_wait(current);
 	wait->flags |= WQ_FLAG_EXCLUSIVE;
 	spin_lock_irqsave(&q->lock, flags);
 	if (list_empty(&wait->task_list))
@@ -205,6 +211,7 @@ long prepare_to_wait_event(wait_queue_head_t *q, wait_queue_t *wait, int state)
 	wait->private = current;
 	wait->func = autoremove_wake_function;
 
+	trace_sched_wait(current);
 	spin_lock_irqsave(&q->lock, flags);
 	if (list_empty(&wait->task_list)) {
 		if (wait->flags & WQ_FLAG_EXCLUSIVE)
-- 
1.8.2.1

