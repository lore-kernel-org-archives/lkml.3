Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755238AbaHHApa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 20:45:30 -0400
Received: from g6t1524.atlanta.hp.com ([15.193.200.67]:49847 "EHLO
	g6t1524.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752088AbaHHAp3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 20:45:29 -0400
Message-ID: <1407458726.2513.12.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [PATCH v2 1/7] locking/rwsem: check for active writer/spinner
 before wakeup
From: Davidlohr Bueso <davidlohr@hp.com>
To: Waiman Long <Waiman.Long@hp.com>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org, Jason Low <jason.low2@hp.com>,
        Scott J Norton <scott.norton@hp.com>, aswin@hp.com
Date: Thu, 07 Aug 2014 17:45:26 -0700
In-Reply-To: <1407450408-11679-2-git-send-email-Waiman.Long@hp.com>
References: <1407450408-11679-1-git-send-email-Waiman.Long@hp.com>
	 <1407450408-11679-2-git-send-email-Waiman.Long@hp.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-08-07 at 18:26 -0400, Waiman Long wrote:
> On a highly contended rwsem, spinlock contention due to the slow
> rwsem_wake() call can be a significant portion of the total CPU cycles
> used. With writer lock stealing and writer optimistic spinning, there
> is also a pretty good chance that the lock may have been stolen
> before the waker wakes up the waiters. The woken tasks, if any,
> will have to go back to sleep again.

Good catch! And this applies to mutexes as well. How about something
like this:

diff --git a/kernel/locking/mutex.c b/kernel/locking/mutex.c
index dadbf88..e037588 100644
--- a/kernel/locking/mutex.c
+++ b/kernel/locking/mutex.c
@@ -707,6 +707,20 @@ EXPORT_SYMBOL_GPL(__ww_mutex_lock_interruptible);
 
 #endif
 
+#if defined(CONFIG_DEBUG_MUTEXES) || defined(CONFIG_MUTEX_SPIN_ON_OWNER)
+static inline bool mutex_has_owner(struct mutex *lock)
+{
+	struct task_struct *owner = ACCESS_ONCE(lock->owner);
+
+	return owner != NULL;
+}
+#else
+static inline bool mutex_has_owner(struct mutex *lock)
+{
+	return false;
+}
+#endif
+
 /*
  * Release the lock, slowpath:
  */
@@ -734,6 +748,15 @@ __mutex_unlock_common_slowpath(struct mutex *lock, int nested)
 	mutex_release(&lock->dep_map, nested, _RET_IP_);
 	debug_mutex_unlock(lock);
 
+	/*
+	 * Abort the wakeup operation if there is an active writer as the
+	 * lock was stolen. mutex_unlock() should have cleared the owner field
+	 * before calling this function. If that field is now set, there must
+	 * be an active writer present.
+	 */
+	if (mutex_has_owner(lock))
+		goto done;
+
 	if (!list_empty(&lock->wait_list)) {
 		/* get the first entry from the wait-list: */
 		struct mutex_waiter *waiter =
@@ -744,7 +767,7 @@ __mutex_unlock_common_slowpath(struct mutex *lock, int nested)
 
 		wake_up_process(waiter->task);
 	}
-
+done:
 	spin_unlock_mutex(&lock->wait_lock, flags);
 }
 






