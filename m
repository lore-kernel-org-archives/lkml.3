Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754056Ab3JBJyu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 05:54:50 -0400
Received: from merlin.infradead.org ([205.233.59.134]:41071 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753041Ab3JBJvl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 05:51:41 -0400
Message-Id: <20131002092528.759956109@infradead.org>
User-Agent: quilt/0.60-1
Date: Wed, 02 Oct 2013 11:22:29 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 12/16] sched/wait: Collapse __wait_event_interruptible_lock_irq_timeout()
References: <20131002092217.784439754@infradead.org>
Content-Disposition: inline; filename=peterz-wait-deduplicate-8.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reduce macro complexity by using the new ___wait_event() helper.
No change in behaviour, identical generated code.

Reviewed-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
---
 include/linux/tty.h  |   21 +----
 include/linux/wait.h |  192 +++++++++++++++------------------------------------
 2 files changed, 63 insertions(+), 150 deletions(-)

--- a/include/linux/wait.h
+++ b/include/linux/wait.h
@@ -809,25 +748,12 @@ do {									\
 	__ret;								\
 })
 
-#define __wait_event_interruptible_lock_irq_timeout(wq, condition,	\
-						    lock, ret)		\
-do {									\
-	DEFINE_WAIT(__wait);						\
-									\
-	for (;;) {							\
-		prepare_to_wait(&wq, &__wait, TASK_INTERRUPTIBLE);	\
-		if (___wait_cond_timeout(condition, ret))		\
-			break;						\
-		if (signal_pending(current)) {				\
-			ret = -ERESTARTSYS;				\
-			break;						\
-		}							\
-		spin_unlock_irq(&lock);					\
-		ret = schedule_timeout(ret);				\
-		spin_lock_irq(&lock);					\
-	}								\
-	finish_wait(&wq, &__wait);					\
-} while (0)
+#define __wait_event_interruptible_lock_irq_timeout(wq, condition, lock, ret) \
+	___wait_event(wq, ___wait_cond_timeout(condition, ret),		      \
+		      TASK_INTERRUPTIBLE, 0, ret,	      		      \
+		      spin_unlock_irq(&lock);				      \
+		      ret = schedule_timeout(ret);			      \
+		      spin_lock_irq(&lock));
 
 /**
  * wait_event_interruptible_lock_irq_timeout - sleep until a condition gets true or a timeout elapses.


