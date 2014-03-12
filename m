Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753615AbaCLMYx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 08:24:53 -0400
Received: from merlin.infradead.org ([205.233.59.134]:57232 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752487AbaCLMYv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 08:24:51 -0400
Date: Wed, 12 Mar 2014 13:24:42 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, jason.low2@hp.com
Cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:core/locking] locking/mutexes: Unlock the mutex without the
 wait_lock
Message-ID: <20140312122442.GB27965@twins.programming.kicks-ass.net>
References: <1390936396-3962-4-git-send-email-jason.low2@hp.com>
 <tip-1d8fe7dc8078b23e060ec62ccb4cdc1ac3c41bf8@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tip-1d8fe7dc8078b23e060ec62ccb4cdc1ac3c41bf8@git.kernel.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 11, 2014 at 05:41:23AM -0700, tip-bot for Jason Low wrote:
>  kernel/locking/mutex.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/kernel/locking/mutex.c b/kernel/locking/mutex.c
> index 82dad2c..dc3d6f2 100644
> --- a/kernel/locking/mutex.c
> +++ b/kernel/locking/mutex.c
> @@ -671,10 +671,6 @@ __mutex_unlock_common_slowpath(atomic_t *lock_count, int nested)
>  	struct mutex *lock = container_of(lock_count, struct mutex, count);
>  	unsigned long flags;
>  
> -	spin_lock_mutex(&lock->wait_lock, flags);
> -	mutex_release(&lock->dep_map, nested, _RET_IP_);
> -	debug_mutex_unlock(lock);
> -
>  	/*
>  	 * some architectures leave the lock unlocked in the fastpath failure
>  	 * case, others need to leave it locked. In the later case we have to
> @@ -683,6 +679,10 @@ __mutex_unlock_common_slowpath(atomic_t *lock_count, int nested)
>  	if (__mutex_slowpath_needs_to_unlock())
>  		atomic_set(&lock->count, 1);
>  
> +	spin_lock_mutex(&lock->wait_lock, flags);
> +	mutex_release(&lock->dep_map, nested, _RET_IP_);
> +	debug_mutex_unlock(lock);
> +
>  	if (!list_empty(&lock->wait_list)) {
>  		/* get the first entry from the wait-list: */
>  		struct mutex_waiter *waiter =

OK, so this patch generates:

WARNING: CPU: 0 PID: 139 at /usr/src/linux-2.6/kernel/locking/mutex-debug.c:82 debug_mutex_unlock+0x155/0x180()
DEBUG_LOCKS_WARN_ON(lock->owner != current)

for kernels with CONFIG_DEBUG_MUTEXES=y

And that makes sense, because as soon as we release the lock a new owner
can come in.

One would think that !__mutex_slowpath_needs_to_unlock() implementations
suffer the same, but for DEBUG we fall back to mutex-null.h which has an
unconditional 1 for that.

How about something like the below; will test after lunch.

---
Subject: locking/mutex: Fix debug checks

The mutex debug code requires the mutex to be unlocked after doing the
debug checks, otherwise it can find inconsistent state.

Fixes: 1d8fe7dc8078 ("locking/mutexes: Unlock the mutex without the wait_lock")
Almost-Signed-off-by: Peter Zijlstra <peterz@infradead.org>
---
 kernel/locking/mutex-debug.c | 6 ++++++
 kernel/locking/mutex.c       | 7 +++++++
 2 files changed, 13 insertions(+)

diff --git a/kernel/locking/mutex-debug.c b/kernel/locking/mutex-debug.c
index faf6f5b53e77..e1191c996c59 100644
--- a/kernel/locking/mutex-debug.c
+++ b/kernel/locking/mutex-debug.c
@@ -83,6 +83,12 @@ void debug_mutex_unlock(struct mutex *lock)
 
 	DEBUG_LOCKS_WARN_ON(!lock->wait_list.prev && !lock->wait_list.next);
 	mutex_clear_owner(lock);
+
+	/*
+	 * __mutex_slowpath_needs_to_unlock() is explicitly 0 for debug
+	 * mutexes so that we can do it here after we've verified state.
+	 */
+	atomic_set(&lock->count, 1);
 }
 
 void debug_mutex_init(struct mutex *lock, const char *name,
diff --git a/kernel/locking/mutex.c b/kernel/locking/mutex.c
index 26c96142caac..e6fa88b64b17 100644
--- a/kernel/locking/mutex.c
+++ b/kernel/locking/mutex.c
@@ -34,6 +34,13 @@
 #ifdef CONFIG_DEBUG_MUTEXES
 # include "mutex-debug.h"
 # include <asm-generic/mutex-null.h>
+/*
+ * Must be 0 for the debug case so we do not do the unlock outside of the
+ * wait_lock region. debug_mutex_unlock() will do the actual unlock in this
+ * case.
+ */
+# undef __mutex_slowpath_needs_to_unlock
+# define  __mutex_slowpath_needs_to_unlock()	0
 #else
 # include "mutex.h"
 # include <asm/mutex.h>
