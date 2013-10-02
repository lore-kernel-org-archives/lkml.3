Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753632Ab3JBJv7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 05:51:59 -0400
Received: from merlin.infradead.org ([205.233.59.134]:41073 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753089Ab3JBJvl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 05:51:41 -0400
Message-Id: <20131002092528.541716442@infradead.org>
User-Agent: quilt/0.60-1
Date: Wed, 02 Oct 2013 11:22:26 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 09/16] sched/wait: Collapse __wait_event_interruptible_exclusive()
References: <20131002092217.784439754@infradead.org>
Content-Disposition: inline; filename=peterz-wait-deduplicate-5.patch
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
@@ -427,26 +421,8 @@ do {									\
 })
 
 #define __wait_event_interruptible_exclusive(wq, condition, ret)	\
-do {									\
-	__label__ __out;						\
-	DEFINE_WAIT(__wait);						\
-									\
-	for (;;) {							\
-		prepare_to_wait_exclusive(&wq, &__wait,			\
-					TASK_INTERRUPTIBLE);		\
-		if (condition)						\
-			break;						\
-		if (signal_pending(current)) {				\
-			ret = -ERESTARTSYS;				\
-			abort_exclusive_wait(&wq, &__wait, 		\
-				TASK_INTERRUPTIBLE, NULL);		\
-			goto __out;					\
-		}							\
-		schedule();						\
-	}								\
-	finish_wait(&wq, &__wait);					\
-__out:	;								\
-} while (0)
+	___wait_event(wq, condition, TASK_INTERRUPTIBLE, 1, ret,	\
+		      schedule())
 
 #define wait_event_interruptible_exclusive(wq, condition)		\
 ({									\


