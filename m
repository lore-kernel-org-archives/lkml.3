Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753872Ab3JBJxH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 05:53:07 -0400
Received: from merlin.infradead.org ([205.233.59.134]:41084 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753463Ab3JBJvn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 05:51:43 -0400
Message-Id: <20131002092528.831085521@infradead.org>
User-Agent: quilt/0.60-1
Date: Wed, 02 Oct 2013 11:22:30 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 13/16] sched/wait: Collapse __wait_event_interruptible_tty()
References: <20131002092217.784439754@infradead.org>
Content-Disposition: inline; filename=peterz-wait-deduplicate-9.patch
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

--- a/include/linux/tty.h
+++ b/include/linux/tty.h
@@ -679,23 +679,10 @@ static inline void tty_wait_until_sent_f
 })
 
 #define __wait_event_interruptible_tty(tty, wq, condition, ret)		\
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
-		tty_unlock(tty);					\
-		schedule();						\
-		tty_lock(tty);						\
-	}								\
-	finish_wait(&wq, &__wait);					\
-} while (0)
+	___wait_event(wq, condition, TASK_INTERRUPTIBLE, 0, ret,	\
+			tty_unlock(tty);				\
+			schedule();					\
+			tty_lock(tty))
 
 #ifdef CONFIG_PROC_FS
 extern void proc_tty_register_driver(struct tty_driver *);


