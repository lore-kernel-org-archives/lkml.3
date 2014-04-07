Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754792AbaDGPdT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 11:33:19 -0400
Received: from moutng.kundenserver.de ([212.227.126.130]:51552 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754637AbaDGPdQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 11:33:16 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>, Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH] sched: remove sleep_on() and friends
Date: Mon, 07 Apr 2014 17:33:06 +0200
Message-ID: <5994834.HB1sNmNMvL@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:5XQpDk+SINDmK9qPnTNp2TS8EYFuO3M0lFqh9yM9Stn
 XSt+qtU6FJ+Q74gyr7fuLufm+oYZ8Y2l8n1FVf2tyeiYMLaaNG
 jRUKqdL1Td6UTwcNXPMHaY4OiDm4hOV8gn4/5/662HIti7EL/T
 q1nnZ73GoaTfg26DprKrDDmh62fEmLrSxmW9V9IQ6ECs3QMMsq
 rYWJVG8Hq5I4meFTI2yZ3xWaCexlc2S8+/rTrhLWNTk1h6pUXg
 ze9z5xp7Z2VpCGacHHHgW3T4UNbCdan1l8M5zLVBA09Dom0gbY
 y1WLMDvjVFH5T4pvCQcRaDDjz/FYYPknjM6kNqbXFc/aZm9DJp
 ANl9FsyGfI7p7Mmh4XcM=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the final piece in the puzzle, as all patches to remove the
last users of \(interruptible_\|\)sleep_on\(_timeout\|\) have made it
into the 3.15 merge window. The work was long overdue, and this
interface in particular should not have survived the BKL removal
that was done a couple of years ago.

Citing Jon Corbet from http://lwn.net/2001/0201/kernel.php3":
 "[...] it was suggested that the janitors look for and fix all code
  that calls sleep_on() [...] since (1) almost all such code is
  incorrect, and (2) Linus has agreed that those functions should
  be removed in the 2.5 development series".

We haven't quite made it for 2.5, but maybe we can merge this for 3.15.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>
---
 Documentation/DocBook/kernel-hacking.tmpl | 10 ----------
 include/linux/wait.h                      | 11 -----------
 kernel/sched/core.c                       | 46 ----------------------------------------------
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
index 1d1b87b..0ff3f34 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2845,52 +2845,6 @@ int default_wake_function(wait_queue_t *curr, unsigned mode, int wake_flags,
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

