Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753551Ab3JBJvv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 05:51:51 -0400
Received: from merlin.infradead.org ([205.233.59.134]:41067 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753007Ab3JBJvl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 05:51:41 -0400
Message-Id: <20131002092527.956416254@infradead.org>
User-Agent: quilt/0.60-1
Date: Wed, 02 Oct 2013 11:22:18 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 01/16] sched/wait: Make the signal_pending() checks consistent
References: <20131002092217.784439754@infradead.org>
Content-Disposition: inline; filename=peterz-wait-change-signal.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's two patterns to check signals in the __wait_event*() macros:

  if (!signal_pending(current)) {
	schedule();
	continue;
  }
  ret = -ERESTARTSYS;
  break;

And the more natural:

  if (signal_pending(current)) {
	ret = -ERESTARTSYS;
	break;
  }
  schedule();

Change them all into the latter form.

Reviewed-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
---
 include/linux/tty.h  |   13 ++++++-------
 include/linux/wait.h |   35 ++++++++++++++++-------------------
 2 files changed, 22 insertions(+), 26 deletions(-)

--- a/include/linux/tty.h
+++ b/include/linux/tty.h
@@ -686,14 +686,13 @@ do {									\
 		prepare_to_wait(&wq, &__wait, TASK_INTERRUPTIBLE);	\
 		if (condition)						\
 			break;						\
-		if (!signal_pending(current)) {				\
-			tty_unlock(tty);					\
-			schedule();					\
-			tty_lock(tty);					\
-			continue;					\
+		if (signal_pending(current)) {				\
+			ret = -ERESTARTSYS;				\
+			break;						\
 		}							\
-		ret = -ERESTARTSYS;					\
-		break;							\
+		tty_unlock(tty);					\
+		schedule();						\
+		tty_lock(tty);						\
 	}								\
 	finish_wait(&wq, &__wait);					\
 } while (0)
--- a/include/linux/wait.h
+++ b/include/linux/wait.h
@@ -261,12 +261,11 @@ do {									\
 		prepare_to_wait(&wq, &__wait, TASK_INTERRUPTIBLE);	\
 		if (condition)						\
 			break;						\
-		if (!signal_pending(current)) {				\
-			schedule();					\
-			continue;					\
+		if (signal_pending(current)) {				\
+			ret = -ERESTARTSYS;				\
+			break;						\
 		}							\
-		ret = -ERESTARTSYS;					\
-		break;							\
+		schedule();						\
 	}								\
 	finish_wait(&wq, &__wait);					\
 } while (0)
@@ -302,14 +301,13 @@ do {									\
 		prepare_to_wait(&wq, &__wait, TASK_INTERRUPTIBLE);	\
 		if (condition)						\
 			break;						\
-		if (!signal_pending(current)) {				\
-			ret = schedule_timeout(ret);			\
-			if (!ret)					\
-				break;					\
-			continue;					\
+		if (signal_pending(current)) {				\
+			ret = -ERESTARTSYS;				\
+			break;						\
 		}							\
-		ret = -ERESTARTSYS;					\
-		break;							\
+		ret = schedule_timeout(ret);				\
+		if (!ret)						\
+			break;						\
 	}								\
 	if (!ret && (condition))					\
 		ret = 1;						\
@@ -439,14 +437,13 @@ do {									\
 			finish_wait(&wq, &__wait);			\
 			break;						\
 		}							\
-		if (!signal_pending(current)) {				\
-			schedule();					\
-			continue;					\
-		}							\
-		ret = -ERESTARTSYS;					\
-		abort_exclusive_wait(&wq, &__wait, 			\
+		if (signal_pending(current)) {				\
+			ret = -ERESTARTSYS;				\
+			abort_exclusive_wait(&wq, &__wait, 		\
 				TASK_INTERRUPTIBLE, NULL);		\
-		break;							\
+			break;						\
+		}							\
+		schedule();						\
 	}								\
 } while (0)
 


