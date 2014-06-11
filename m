Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932698AbaFKSrr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 14:47:47 -0400
Received: from www.linutronix.de ([62.245.132.108]:34281 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753296AbaFKSoH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 14:44:07 -0400
Message-Id: <20140611183853.208557255@linutronix.de>
User-Agent: quilt/0.63-1
Date: Wed, 11 Jun 2014 18:44:05 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>
Subject: [patch V4 04/10] rtmutex: No need to keep task ref for lock owner
 check
References: <20140611182944.108526809@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=rtmutex-deobfuscate-chain-walk.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no point to keep the task ref across the check for lock
owner. Drop the ref before that, so the protection context is clear.

Found while documenting the chain walk.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/locking/rtmutex.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

Index: tip/kernel/locking/rtmutex.c
===================================================================
--- tip.orig/kernel/locking/rtmutex.c
+++ tip/kernel/locking/rtmutex.c
@@ -463,6 +463,8 @@ static int rt_mutex_adjust_prio_chain(st
 
 	/* Release the task */
 	raw_spin_unlock_irqrestore(&task->pi_lock, flags);
+	put_task_struct(task);
+
 	if (!rt_mutex_owner(lock)) {
 		/*
 		 * If the requeue above changed the top waiter, then we need
@@ -472,9 +474,8 @@ static int rt_mutex_adjust_prio_chain(st
 		if (top_waiter != rt_mutex_top_waiter(lock))
 			wake_up_process(rt_mutex_top_waiter(lock)->task);
 		raw_spin_unlock(&lock->wait_lock);
-		goto out_put_task;
+		return 0;
 	}
-	put_task_struct(task);
 
 	/* Grab the next task */
 	task = rt_mutex_owner(lock);


