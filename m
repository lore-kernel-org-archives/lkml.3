Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753817Ab3JBJxC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 05:53:02 -0400
Received: from merlin.infradead.org ([205.233.59.134]:41086 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753477Ab3JBJvn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 05:51:43 -0400
Message-Id: <20131002092528.898691966@infradead.org>
User-Agent: quilt/0.60-1
Date: Wed, 02 Oct 2013 11:22:31 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 14/16] sched/wait: Collapse __wait_event_killable()
References: <20131002092217.784439754@infradead.org>
Content-Disposition: inline; filename=peterz-wait-deduplicate-10.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reduce macro complexity by using the new ___wait_event() helper.
No change in behaviour, identical generated code.

Reviewed-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
---
--- a/include/linux/wait.h
+++ b/include/linux/wait.h
@@ -582,22 +582,7 @@ do {									\
 
 
 #define __wait_event_killable(wq, condition, ret)			\
-do {									\
-	DEFINE_WAIT(__wait);						\
-									\
-	for (;;) {							\
-		prepare_to_wait(&wq, &__wait, TASK_KILLABLE);		\
-		if (condition)						\
-			break;						\
-		if (!fatal_signal_pending(current)) {			\
-			schedule();					\
-			continue;					\
-		}							\
-		ret = -ERESTARTSYS;					\
-		break;							\
-	}								\
-	finish_wait(&wq, &__wait);					\
-} while (0)
+	___wait_event(wq, condition, TASK_KILLABLE, 0, ret, schedule())
 
 /**
  * wait_event_killable - sleep until a condition gets true


