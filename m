Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753638Ab3JBJys (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 05:54:48 -0400
Received: from merlin.infradead.org ([205.233.59.134]:41072 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753051Ab3JBJvl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 05:51:41 -0400
Message-Id: <20131002092528.686006009@infradead.org>
User-Agent: quilt/0.60-1
Date: Wed, 02 Oct 2013 11:22:28 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 11/16] sched/wait: Collapse __wait_event_interruptible_lock_irq()
References: <20131002092217.784439754@infradead.org>
Content-Disposition: inline; filename=peterz-wait-deduplicate-7.patch
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
@@ -721,26 +674,12 @@ do {									\
 } while (0)
 
 
-#define __wait_event_interruptible_lock_irq(wq, condition,		\
-					    lock, ret, cmd)		\
-do {									\
-	DEFINE_WAIT(__wait);						\
-									\
-	for (;;) {							\
-		prepare_to_wait(&wq, &__wait, TASK_INTERRUPTIBLE);	\
-		if (condition)						\
-			break;						\
-		if (signal_pending(current)) {				\
-			ret = -ERESTARTSYS;				\
-			break;						\
-		}							\
-		spin_unlock_irq(&lock);					\
-		cmd;							\
-		schedule();						\
-		spin_lock_irq(&lock);					\
-	}								\
-	finish_wait(&wq, &__wait);					\
-} while (0)
+#define __wait_event_interruptible_lock_irq(wq, condition, lock, ret, cmd) \
+	___wait_event(wq, condition, TASK_INTERRUPTIBLE, 0, ret,	   \
+		      spin_unlock_irq(&lock);				   \
+		      cmd;						   \
+		      schedule();					   \
+		      spin_lock_irq(&lock))
 
 /**
  * wait_event_interruptible_lock_irq_cmd - sleep until a condition gets true.


