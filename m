Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752544AbaBZLDX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 06:03:23 -0500
Received: from moutng.kundenserver.de ([212.227.126.131]:64924 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752437AbaBZLDQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 06:03:16 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: [PATCH 16/16] NOTYET: sched: remove sleep_on() and friends
Date: Wed, 26 Feb 2014 12:01:56 +0100
Message-Id: <1393412516-3762435-17-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1393412516-3762435-1-git-send-email-arnd@arndb.de>
References: <1393412516-3762435-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:ckx0WpnPjjd/MAzKWHPcA0xqmz5oxs5wXt2OhVEJZw+
 Itk1Imuo2sWpfXKNu6lxSCBYZ8p6D3bZJUhni3HvKc3Fkymsw/
 wvYxCe/+FM61TFdbQlYQHGls4jRNwUp4aaO2CFwYCiHVkfCtj+
 bftjb9tiH+/CY4jPdJg8AtKR2uhQ2i8zme3DArXjegchw9JjLO
 wPadm+B24XMB19gvF5Wlbe8SDTUDPzv9FPyXQf3bCU/DhhKYo3
 BD7QiA510Y7t8DUjip/xJpNN6A/pwOzpQfn9KpCPTihzC+6ri9
 K7N0EnNYQDvgEGthD5Wxoqi2bR7yr6qVZTEUj3gXetIQiAe0ju
 8a58RYlQN0dcR2/WjRYOTlLcx0cHe3wtrgm4zuMXt
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Do not apply yet, we first have to wait for the other patches
in the series to get merged. Comments appreciated.

8<----

We probably should have done this 15 years ago. I have created patches
for every remaining user of the four sleep_on variants that are all
broken, and this patch should get applied as soon as all of the other
patches are merged.

If you are reading this changeset because you are looking for the
functions I removed, please convert your code to use wait_event,
wait_for_completion or an open-coded prepare_to_wait loop.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>
---
 Documentation/DocBook/kernel-hacking.tmpl | 10 -------
 include/linux/wait.h                      | 11 --------
 kernel/sched/core.c                       | 46 -------------------------------
 3 files changed, 67 deletions(-)

diff --git a/Documentation/DocBook/kernel-hacking.tmpl b/Documentation/DocBook/kernel-hacking.tmpl
index d0758b24..bd9015d 100644
--- a/Documentation/DocBook/kernel-hacking.tmpl
+++ b/Documentation/DocBook/kernel-hacking.tmpl
@@ -850,16 +850,6 @@ printk(KERN_INFO "my ip: %pI4\n", &amp;ipaddress);
     <returnvalue>-ERESTARTSYS</returnvalue> if a signal is received.
     The <function>wait_event()</function> version ignores signals.
    </para>
-   <para>
-   Do not use the <function>sleep_on()</function> function family -
-   it is very easy to accidentally introduce races; almost certainly
-   one of the <function>wait_event()</function> family will do, or a
-   loop around <function>schedule_timeout()</function>. If you choose
-   to loop around <function>schedule_timeout()</function> remember
-   you must set the task state (with 
-   <function>set_current_state()</function>) on each iteration to avoid
-   busy-looping.
-   </para>
  
   </sect1>
 
diff --git a/include/linux/wait.h b/include/linux/wait.h
index 559044c..e7d9d9e 100644
--- a/include/linux/wait.h
+++ b/include/linux/wait.h
@@ -803,17 +803,6 @@ do {									\
 	__ret;								\
 })
 
-
-/*
- * These are the old interfaces to sleep waiting for an event.
- * They are racy.  DO NOT use them, use the wait_event* interfaces above.
- * We plan to remove these interfaces.
- */
-extern void sleep_on(wait_queue_head_t *q);
-extern long sleep_on_timeout(wait_queue_head_t *q, signed long timeout);
-extern void interruptible_sleep_on(wait_queue_head_t *q);
-extern long interruptible_sleep_on_timeout(wait_queue_head_t *q, signed long timeout);
-
 /*
  * Waitqueues which are removed from the waitqueue_head at wakeup time
  */
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index b46131e..25377f4 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2852,52 +2852,6 @@ int default_wake_function(wait_queue_t *curr, unsigned mode, int wake_flags,
 }
 EXPORT_SYMBOL(default_wake_function);
 
-static long __sched
-sleep_on_common(wait_queue_head_t *q, int state, long timeout)
-{
-	unsigned long flags;
-	wait_queue_t wait;
-
-	init_waitqueue_entry(&wait, current);
-
-	__set_current_state(state);
-
-	spin_lock_irqsave(&q->lock, flags);
-	__add_wait_queue(q, &wait);
-	spin_unlock(&q->lock);
-	timeout = schedule_timeout(timeout);
-	spin_lock_irq(&q->lock);
-	__remove_wait_queue(q, &wait);
-	spin_unlock_irqrestore(&q->lock, flags);
-
-	return timeout;
-}
-
-void __sched interruptible_sleep_on(wait_queue_head_t *q)
-{
-	sleep_on_common(q, TASK_INTERRUPTIBLE, MAX_SCHEDULE_TIMEOUT);
-}
-EXPORT_SYMBOL(interruptible_sleep_on);
-
-long __sched
-interruptible_sleep_on_timeout(wait_queue_head_t *q, long timeout)
-{
-	return sleep_on_common(q, TASK_INTERRUPTIBLE, timeout);
-}
-EXPORT_SYMBOL(interruptible_sleep_on_timeout);
-
-void __sched sleep_on(wait_queue_head_t *q)
-{
-	sleep_on_common(q, TASK_UNINTERRUPTIBLE, MAX_SCHEDULE_TIMEOUT);
-}
-EXPORT_SYMBOL(sleep_on);
-
-long __sched sleep_on_timeout(wait_queue_head_t *q, long timeout)
-{
-	return sleep_on_common(q, TASK_UNINTERRUPTIBLE, timeout);
-}
-EXPORT_SYMBOL(sleep_on_timeout);
-
 #ifdef CONFIG_RT_MUTEXES
 
 /*
-- 
1.8.3.2

