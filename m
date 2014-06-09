Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932422AbaFIU2Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 16:28:24 -0400
Received: from www.linutronix.de ([62.245.132.108]:46576 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754140AbaFIU2L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 16:28:11 -0400
Message-Id: <20140609202336.248536613@linutronix.de>
User-Agent: quilt/0.63-1
Date: Mon, 09 Jun 2014 20:28:08 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, Jason Low <jason.low2@hp.com>,
        Brad Mouring <bmouring@ni.com>
Subject: [patch V3 4/7] rtmutex: Siplify remove_waiter()
References: <20140609201118.387571774@linutronix.de>
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
 kernel/locking/rtmutex.c |   26 ++++++++++----------------
 1 file changed, 10 insertions(+), 16 deletions(-)

Index: tip/kernel/locking/rtmutex.c
===================================================================
--- tip.orig/kernel/locking/rtmutex.c
+++ tip/kernel/locking/rtmutex.c
@@ -780,7 +780,7 @@ static void remove_waiter(struct rt_mute
 {
 	int first = (waiter == rt_mutex_top_waiter(lock));
 	struct task_struct *owner = rt_mutex_owner(lock);
-	struct rt_mutex *next_lock = NULL;
+	struct rt_mutex *next_lock;
 	unsigned long flags;
 
 	raw_spin_lock_irqsave(&current->pi_lock, flags);
@@ -788,28 +788,22 @@ static void remove_waiter(struct rt_mute
 	current->pi_blocked_on = NULL;
 	raw_spin_unlock_irqrestore(&current->pi_lock, flags);
 
-	if (!owner)
+	if (!owner || !first)
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
 
 	if (!next_lock)
 		return;


