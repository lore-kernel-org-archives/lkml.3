Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753844Ab3JBJxE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 05:53:04 -0400
Received: from merlin.infradead.org ([205.233.59.134]:41085 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753464Ab3JBJvn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 05:51:43 -0400
Message-Id: <20131002092528.028892896@infradead.org>
User-Agent: quilt/0.60-1
Date: Wed, 02 Oct 2013 11:22:19 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 02/16] sched/wait: Change timeout logic
References: <20131002092217.784439754@infradead.org>
Content-Disposition: inline; filename=peterz-wait-change-sched-timo.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 4c663cf ("wait: fix false timeouts when using
wait_event_timeout()") introduced an additional condition check after
a timeout but there's a few issues;

 - it forgot one site
 - it put the check after the main loop; not at the actual timeout
   check.

Cure both; by wrapping the condition (as suggested by Oleg), this
avoids double evaluation of 'condition' which could be quite big.

Reviewed-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
---
 include/linux/wait.h |   24 +++++++++++-------------
 1 file changed, 11 insertions(+), 13 deletions(-)

--- a/include/linux/wait.h
+++ b/include/linux/wait.h
@@ -179,6 +179,14 @@ wait_queue_head_t *bit_waitqueue(void *,
 #define wake_up_interruptible_sync_poll(x, m)				\
 	__wake_up_sync_key((x), TASK_INTERRUPTIBLE, 1, (void *) (m))
 
+#define ___wait_cond_timeout(condition, ret)				\
+({									\
+ 	bool __cond = (condition);					\
+ 	if (__cond && !ret)						\
+ 		ret = 1;						\
+ 	__cond || !ret;							\
+})
+
 #define __wait_event(wq, condition) 					\
 do {									\
 	DEFINE_WAIT(__wait);						\
@@ -217,14 +225,10 @@ do {									\
 									\
 	for (;;) {							\
 		prepare_to_wait(&wq, &__wait, TASK_UNINTERRUPTIBLE);	\
-		if (condition)						\
+		if (___wait_cond_timeout(condition, ret))		\
 			break;						\
 		ret = schedule_timeout(ret);				\
-		if (!ret)						\
-			break;						\
 	}								\
-	if (!ret && (condition))					\
-		ret = 1;						\
 	finish_wait(&wq, &__wait);					\
 } while (0)
 
@@ -299,18 +303,14 @@ do {									\
 									\
 	for (;;) {							\
 		prepare_to_wait(&wq, &__wait, TASK_INTERRUPTIBLE);	\
-		if (condition)						\
+		if (___wait_cond_timeout(condition, ret))		\
 			break;						\
 		if (signal_pending(current)) {				\
 			ret = -ERESTARTSYS;				\
 			break;						\
 		}							\
 		ret = schedule_timeout(ret);				\
-		if (!ret)						\
-			break;						\
 	}								\
-	if (!ret && (condition))					\
-		ret = 1;						\
 	finish_wait(&wq, &__wait);					\
 } while (0)
 
@@ -815,7 +815,7 @@ do {									\
 									\
 	for (;;) {							\
 		prepare_to_wait(&wq, &__wait, TASK_INTERRUPTIBLE);	\
-		if (condition)						\
+		if (___wait_cond_timeout(condition, ret))		\
 			break;						\
 		if (signal_pending(current)) {				\
 			ret = -ERESTARTSYS;				\
@@ -824,8 +824,6 @@ do {									\
 		spin_unlock_irq(&lock);					\
 		ret = schedule_timeout(ret);				\
 		spin_lock_irq(&lock);					\
-		if (!ret)						\
-			break;						\
 	}								\
 	finish_wait(&wq, &__wait);					\
 } while (0)


