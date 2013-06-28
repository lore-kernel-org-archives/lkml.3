Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753935Ab3F1FyO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 01:54:14 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:37540 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752862Ab3F1FyK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 01:54:10 -0400
Message-ID: <51CD24E1.2030608@canonical.com>
Date: Fri, 28 Jun 2013 07:53:37 +0200
From: Maarten Lankhorst <maarten.lankhorst@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Davidlohr Bueso <davidlohr.bueso@hp.com>
CC: Ingo Molnar <mingo@kernel.org>, Rik van Riel <riel@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] mutex: do not unnecessarily deal with waiters
References: <1369353543.1770.0.camel@buesod1.americas.hpqcorp.net>  <20130627090016.GA4398@gmail.com> <1372383138.2072.42.camel@buesod1.americas.hpqcorp.net>
In-Reply-To: <1372383138.2072.42.camel@buesod1.americas.hpqcorp.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Op 28-06-13 03:32, Davidlohr Bueso schreef:
> On Thu, 2013-06-27 at 11:00 +0200, Ingo Molnar wrote:
> [...]
>> So I tried this out yesterday, but it interacted with the Wait/Wound 
>> patches in tip:core/mutexes.
>>
>> Maarten Lankhorst pointed out that if this patch is applied on top of the 
>> WW patches as-is, then we get this semantic merge conflict:
>>
>>>> @@ -340,6 +339,14 @@ slowpath:
>>>>  #endif
>>>>     spin_lock_mutex(&lock->wait_lock, flags);
>>>>  
>>>> +   /* once more, can we acquire the lock? */
>>>> +   if (MUTEX_SHOW_NO_WAITER(lock) && (atomic_xchg(&lock->count, 0) == 1)) {
>>>> +           lock_acquired(&lock->dep_map, ip);
>>>> +           mutex_set_owner(lock);
>>>> +           spin_unlock_mutex(&lock->wait_lock, flags);
>>>> +           goto done;
>>>> +   }
>>>>
>>> ^^^^^^^^^^^^^^
>>>
>>> This part skips the whole if (!__builtin_constant_p(ww_ctx == NULL)) { 
>>> section with the wait_lock held.
> I see what you mean, I hadn't really looked at the W/W patches. BTW
> those __builtin_constant_p() calls are pretty ugly/annoying to read,
> plus why the negation of the NULL check? Couldn't we just do something
> like:
It's to kill overhead.. ww_ctx == NULL is a constant only when the function is called with null as explicit parameter.

So !__builtin_constant_p(ww_ctx == NULL) means that the function was called with a variable ww_ctx.
> #define is_ww_ctx(x) (__builtin_constant_p(x))
> ...
> if (is_ww_ctxt(ww_ctx)) { ... }
>
>
> Anyway, so going back to the actual patch, we need a few cleanups in
> __mutex_lock_common() before we can rebase this patch - otherwise we're
> going to end up duplicating a lot of code (and the function is already
> big enough):
>
> How about a new ww_mutex_set_context_slowpath() function that does the
> w/w lock acquiring and wakes up any sleeping processes. We'd use this
> function whenever we acquire the lock in the slowpath (with the
> ->wait_lock taken):
>
> static __always_inline void
> ww_mutex_set_context_slowpath(struct mutex *lock,
> 			      struct ww_acquire_ctx *ww_ctx, bool debug)
> {
> 	if (!__builtin_constant_p(ww_ctx == NULL)) {
> 		struct mutex_waiter *cur;
> 		struct ww_mutex *ww = container_of(lock, struct ww_mutex, base);
>
> 		/*
> 		 * This branch gets optimized out for the common case,
> 		 * and is only important for ww_mutex_lock.
> 		 */
> 		ww_mutex_lock_acquired(ww, ww_ctx);
> 		ww->ctx = ww_ctx;
>
> 		/*
> 		 * Give any possible sleeping processes the chance to wake up,
> 		 * so they can recheck if they have to back off.
> 		 */
> 		list_for_each_entry(cur, &lock->wait_list, list) {
> 			if (debug)
> 				debug_mutex_wake_waiter(lock, cur);
> 			wake_up_process(cur->task);
> 		}
> 	}
> }
>
> In ww_mutex_set_context_fastpath() I'm a little confused with the
> debug_mutex_wake_waiter() calls since we don't deal with debug in the
> fast path (->wait_lock isn't held). So are these calls
> correct/necessary?
Well spotted, but in that case the !debug case mutex_wake_waiter gets optimized out anyway,
so please don't add a conditional like that.
> For ww_mutex_set_context_slowpath(), the 'debug' parameter would be
> necessary since with this patch we avoid doing the debug_mutex on a
> quick attempt to grab the lock, otherwise we do the slowpath debug,
> waiters, etc. For instance:
>
> ...
> slowpath:
> #endif
> 	spin_lock_mutex(&lock->wait_lock, flags);
> 	/* once more, can we acquire the lock? */
> 	if (MUTEX_SHOW_NO_WAITER(lock) && (atomic_xchg(&lock->count, 0) == 1)) {
>         	lock_acquired(&lock->dep_map, ip);
> 	        mutex_set_owner(lock);
> 		ww_mutex_set_context_fastpath(lock, ww_ctx, false);
>         	spin_unlock_mutex(&lock->wait_lock, flags);
> 	        goto done;
>   	}
> ...
>
> lock_acquired(&lock->dep_map, ip);
> /* got the lock - rejoice! */
> mutex_remove_waiter(lock, &waiter, current_thread_info());
> mutex_set_owner(lock);
> ww_mutex_set_context_slowpath(lock, ww_ctx, true);
> ...

I used the power of goto's in my own fixed up version below, and reshuffled some calls a bit.

Maybe you could verify if it's correct, and if it is use it as base?
8<---------
diff --git a/kernel/mutex.c b/kernel/mutex.c
index e581ada..f93be1d 100644
--- a/kernel/mutex.c
+++ b/kernel/mutex.c
@@ -486,8 +486,7 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
 
 			mutex_set_owner(lock);
 			mspin_unlock(MLOCK(lock), &node);
-			preempt_enable();
-			return 0;
+			goto done;
 		}
 		mspin_unlock(MLOCK(lock), &node);
 
@@ -512,6 +511,10 @@ slowpath:
 #endif
 	spin_lock_mutex(&lock->wait_lock, flags);
 
+	/* once more, can we acquire the lock? */
+	if (MUTEX_SHOW_NO_WAITER(lock) && (atomic_xchg(&lock->count, 0) == 1))
+		goto skip_wait;
+
 	debug_mutex_lock_common(lock, &waiter);
 	debug_mutex_add_waiter(lock, &waiter, task_thread_info(task));
 
@@ -519,9 +522,6 @@ slowpath:
 	list_add_tail(&waiter.list, &lock->wait_list);
 	waiter.task = task;
 
-	if (MUTEX_SHOW_NO_WAITER(lock) && (atomic_xchg(&lock->count, -1) == 1))
-		goto done;
-
 	lock_contended(&lock->dep_map, ip);
 
 	for (;;) {
@@ -535,7 +535,7 @@ slowpath:
 		 * other waiters:
 		 */
 		if (MUTEX_SHOW_NO_WAITER(lock) &&
-		   (atomic_xchg(&lock->count, -1) == 1))
+		    (atomic_xchg(&lock->count, -1) == 1))
 			break;
 
 		/*
@@ -560,11 +560,15 @@ slowpath:
 		schedule_preempt_disabled();
 		spin_lock_mutex(&lock->wait_lock, flags);
 	}
+	mutex_remove_waiter(lock, &waiter, current_thread_info());
+	/* set it to 0 if there are no waiters left: */
+	if (likely(list_empty(&lock->wait_list)))
+		atomic_set(&lock->count, 0);
+	debug_mutex_free_waiter(&waiter);
 
-done:
+skip_wait:
+	/* got the lock - cleanup and rejoice! */
 	lock_acquired(&lock->dep_map, ip);
-	/* got the lock - rejoice! */
-	mutex_remove_waiter(lock, &waiter, current_thread_info());
 	mutex_set_owner(lock);
 
 	if (!__builtin_constant_p(ww_ctx == NULL)) {
@@ -591,15 +595,9 @@ done:
 		}
 	}
 
-	/* set it to 0 if there are no waiters left: */
-	if (likely(list_empty(&lock->wait_list)))
-		atomic_set(&lock->count, 0);
-
 	spin_unlock_mutex(&lock->wait_lock, flags);
-
-	debug_mutex_free_waiter(&waiter);
+done:
 	preempt_enable();
-
 	return 0;
 
 err:

