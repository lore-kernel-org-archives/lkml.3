Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932300AbaFKSoN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 14:44:13 -0400
Received: from www.linutronix.de ([62.245.132.108]:34299 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752436AbaFKSoJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 14:44:09 -0400
Message-Id: <20140611183853.480271982@linutronix.de>
User-Agent: quilt/0.63-1
Date: Wed, 11 Jun 2014 18:44:07 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>
Subject: [patch V4 07/10] rtmutex: Simplify remove_waiter()
References: <20140611182944.108526809@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=rtmutex-simplify-deboost.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Exit right away, when the removed waiter was not the top prioriy
waiter on the lock. Get rid of the extra indent level.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/locking/rtmutex.c |   36 +++++++++++++++++++-----------------
 1 file changed, 19 insertions(+), 17 deletions(-)

Index: tip/kernel/locking/rtmutex.c
===================================================================
--- tip.orig/kernel/locking/rtmutex.c
+++ tip/kernel/locking/rtmutex.c
@@ -920,9 +920,9 @@ static void wakeup_next_waiter(struct rt
 static void remove_waiter(struct rt_mutex *lock,
 			  struct rt_mutex_waiter *waiter)
 {
-	int first = (waiter == rt_mutex_top_waiter(lock));
+	bool is_top_waiter = (waiter == rt_mutex_top_waiter(lock));
 	struct task_struct *owner = rt_mutex_owner(lock);
-	struct rt_mutex *next_lock = NULL;
+	struct rt_mutex *next_lock;
 	unsigned long flags;
 
 	raw_spin_lock_irqsave(&current->pi_lock, flags);
@@ -930,29 +930,31 @@ static void remove_waiter(struct rt_mute
 	current->pi_blocked_on = NULL;
 	raw_spin_unlock_irqrestore(&current->pi_lock, flags);
 
-	if (!owner)
+	/*
+	 * Only update priority if the waiter was the highest priority
+	 * waiter of the lock and there is an owner to update.
+	 */
+	if (!owner || !is_top_waiter)
 		return;
 
-	if (first) {
+	raw_spin_lock_irqsave(&owner->pi_lock, flags);
 
-		raw_spin_lock_irqsave(&owner->pi_lock, flags);
+	rt_mutex_dequeue_pi(owner, waiter);
 
-		rt_mutex_dequeue_pi(owner, waiter);
+	if (rt_mutex_has_waiters(lock))
+		rt_mutex_enqueue_pi(owner, rt_mutex_top_waiter(lock));
 
-		if (rt_mutex_has_waiters(lock)) {
-			struct rt_mutex_waiter *next;
+	__rt_mutex_adjust_prio(owner);
 
-			next = rt_mutex_top_waiter(lock);
-			rt_mutex_enqueue_pi(owner, next);
-		}
-		__rt_mutex_adjust_prio(owner);
+	/* Store the lock on which owner is blocked or NULL */
+	next_lock = task_blocked_on_lock(owner);
 
-		/* Store the lock on which owner is blocked or NULL */
-		next_lock = task_blocked_on_lock(owner);
-
-		raw_spin_unlock_irqrestore(&owner->pi_lock, flags);
-	}
+	raw_spin_unlock_irqrestore(&owner->pi_lock, flags);
 
+	/*
+	 * Don't walk the chain, if the owner task is not blocked
+	 * itself.
+	 */
 	if (!next_lock)
 		return;
 


