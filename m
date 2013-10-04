Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755032Ab3JDO4g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 10:56:36 -0400
Received: from merlin.infradead.org ([205.233.59.134]:48641 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754186Ab3JDO4e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 10:56:34 -0400
Date: Fri, 4 Oct 2013 16:56:25 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Thomas Gleixner <tglx@linutronix.de>, rostedt@goodmis.org
Cc: linux-kernel@vger.kernel.org
Subject: wait-simple stuff
Message-ID: <20131004145625.GN3081@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi guys,

Would something like the below break something?
>From a quick read things seems fine for both the simple-waitqueue as the
completions.

Without that lockbreak in I can't see how the kernel would still be
deterministic as you can pile as many tasks as you want on these
waitqueues.

---
 kernel/sched/core.c  |  4 ++--
 kernel/wait-simple.c | 12 +++++++++---
 2 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index d2a85b2b58f0..ae2fbef70971 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -3496,7 +3496,7 @@ void complete(struct completion *x)
 
 	raw_spin_lock_irqsave(&x->wait.lock, flags);
 	x->done++;
-	__swait_wake_locked(&x->wait, TASK_NORMAL, 1);
+	__swait_wake_locked(&x->wait, TASK_NORMAL, 1, &flags);
 	raw_spin_unlock_irqrestore(&x->wait.lock, flags);
 }
 EXPORT_SYMBOL(complete);
@@ -3516,7 +3516,7 @@ void complete_all(struct completion *x)
 
 	raw_spin_lock_irqsave(&x->wait.lock, flags);
 	x->done += UINT_MAX/2;
-	__swait_wake_locked(&x->wait, TASK_NORMAL, 0);
+	__swait_wake_locked(&x->wait, TASK_NORMAL, 0, &flags);
 	raw_spin_unlock_irqrestore(&x->wait.lock, flags);
 }
 EXPORT_SYMBOL(complete_all);
diff --git a/kernel/wait-simple.c b/kernel/wait-simple.c
index 7dfa86d1f654..3a20cbff91dd 100644
--- a/kernel/wait-simple.c
+++ b/kernel/wait-simple.c
@@ -73,12 +73,13 @@ void swait_finish(struct swait_head *head, struct swaiter *w)
 EXPORT_SYMBOL(swait_finish);
 
 unsigned int
-__swait_wake_locked(struct swait_head *head, unsigned int state, unsigned int num)
+__swait_wake_locked(struct swait_head *head, unsigned int state,
+		    unsigned int num, unsigned long *flags)
 {
-	struct swaiter *curr, *next;
+	struct swaiter *curr;
 	int woken = 0;
 
-	list_for_each_entry_safe(curr, next, &head->list, node) {
+	while ((curr = list_first_entry_or_null(&head->list, struct swaiter, node))) {
 		if (wake_up_state(curr->task, state)) {
 			__swait_dequeue(curr);
 			/*
@@ -94,6 +95,11 @@ __swait_wake_locked(struct swait_head *head, unsigned int state, unsigned int nu
 			if (++woken == num)
 				break;
 		}
+
+		if (need_resched()) {
+			raw_spin_unlock_irqrestore(&head->lock, *flags);
+			raw_spin_lock_irqsave(&head->lock, *flags);
+		}
 	}
 	return woken;
 }
