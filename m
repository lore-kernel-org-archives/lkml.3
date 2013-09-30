Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756252Ab3I3Pci (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 11:32:38 -0400
Received: from merlin.infradead.org ([205.233.59.134]:44566 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756224Ab3I3Pcg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 11:32:36 -0400
Message-Id: <20130930152625.049127088@infradead.org>
User-Agent: quilt/0.60-1
Date: Mon, 30 Sep 2013 17:22:47 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 5/6] sched, wait: Also use ___wait_event() for __wait_event_hrtimeout
References: <20130930152242.207382649@infradead.org>
Content-Disposition: inline; filename=peterz-wait-dedup-hrtimer.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The actual core of __wait_event_hrtimeout() is identical to what
___wait_event() generates.

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
---
 include/linux/wait.h |   15 ++-------------
 1 file changed, 2 insertions(+), 13 deletions(-)

--- a/include/linux/wait.h
+++ b/include/linux/wait.h
@@ -338,7 +338,6 @@ do {									\
 #define __wait_event_hrtimeout(wq, condition, timeout, state)		\
 ({									\
 	int __ret = 0;							\
-	DEFINE_WAIT(__wait);						\
 	struct hrtimer_sleeper __t;					\
 									\
 	hrtimer_init_on_stack(&__t.timer, CLOCK_MONOTONIC,		\
@@ -349,25 +348,15 @@ do {									\
 				       current->timer_slack_ns,		\
 				       HRTIMER_MODE_REL);		\
 									\
-	for (;;) {							\
-		prepare_to_wait(&wq, &__wait, state);			\
-		if (condition)						\
-			break;						\
-		if (state == TASK_INTERRUPTIBLE &&			\
-		    signal_pending(current)) {				\
-			__ret = -ERESTARTSYS;				\
-			break;						\
-		}							\
+	___wait_event(wq, condition, state, 0, __ret,			\
 		if (!__t.task) {					\
 			__ret = -ETIME;					\
 			break;						\
 		}							\
-		schedule();						\
-	}								\
+		schedule());						\
 									\
 	hrtimer_cancel(&__t.timer);					\
 	destroy_hrtimer_on_stack(&__t.timer);				\
-	finish_wait(&wq, &__wait);					\
 	__ret;								\
 })
 


