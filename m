Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761646Ab3JPUUw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 16:20:52 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:52976 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761244Ab3JPUUv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 16:20:51 -0400
X-Nat-Received: from [202.181.97.72]:60288 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1381954845.2803
To: mingo@kernel.org
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Subject: Re: [PATCH for 3.12-rcX] mutex: Avoid gcc version dependent __builtin_constant_p() usage.
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <201309082053.FDB24195.FVOOJMStFQFLHO@I-love.SAKURA.ne.jp>
	<522CDFC8.9020903@canonical.com>
	<201309092056.GDH56750.OOMJtOHQVFFLSF@I-love.SAKURA.ne.jp>
	<20130909125841.GZ31370@twins.programming.kicks-ass.net>
	<201310032302.EHJ58858.FOVHJOFLtSOMQF@I-love.SAKURA.ne.jp>
In-Reply-To: <201310032302.EHJ58858.FOVHJOFLtSOMQF@I-love.SAKURA.ne.jp>
Message-Id: <201310170520.JGF87075.OOVLQMFtFFHOJS@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Thu, 17 Oct 2013 05:20:44 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.45.2/RELEASE, bases: 16102013 #11266284, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm worrying that this patch becomes too late for backporting to 3.11-stable.
Since there is no objection, can this patch go?

Peter Zijlstra wrote:
> This is a sad patch, but provided it actually generates similar code I
> suppose its the best we can do bar whole sale deprecating gcc-3.

Tetsuo Handa wrote:
> Can the patch below go to 3.12-rcX (and the patch above to 3.11-stable which
> does the same thing)?
> 
> Regards.
> ----------
> >From a1b01c858143c2c2c92b17e7df096042bfe0df6b Mon Sep 17 00:00:00 2001
> From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> Date: Tue, 24 Sep 2013 23:44:17 +0900
> Subject: [PATCH] mutex: Avoid gcc version dependent __builtin_constant_p() usage.
> 
> Commit 040a0a37 "mutex: Add support for wound/wait style locks" used
> "!__builtin_constant_p(p == NULL)" but gcc 3.x cannot handle such expression
> correctly, leading to boot failure when built with CONFIG_DEBUG_MUTEXES=y.
> 
> Fix it by explicitly passing a bool which tells whether p != NULL or not.
> 
> Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> ---
>  kernel/mutex.c |   32 ++++++++++++++++----------------
>  1 files changed, 16 insertions(+), 16 deletions(-)
> 
> diff --git a/kernel/mutex.c b/kernel/mutex.c
> index 6d647ae..d24105b 100644
> --- a/kernel/mutex.c
> +++ b/kernel/mutex.c
> @@ -410,7 +410,7 @@ ww_mutex_set_context_fastpath(struct ww_mutex *lock,
>  static __always_inline int __sched
>  __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
>  		    struct lockdep_map *nest_lock, unsigned long ip,
> -		    struct ww_acquire_ctx *ww_ctx)
> +		    struct ww_acquire_ctx *ww_ctx, const bool use_ww_ctx)
>  {
>  	struct task_struct *task = current;
>  	struct mutex_waiter waiter;
> @@ -450,7 +450,7 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
>  		struct task_struct *owner;
>  		struct mspin_node  node;
>  
> -		if (!__builtin_constant_p(ww_ctx == NULL) && ww_ctx->acquired > 0) {
> +		if (use_ww_ctx && ww_ctx->acquired > 0) {
>  			struct ww_mutex *ww;
>  
>  			ww = container_of(lock, struct ww_mutex, base);
> @@ -480,7 +480,7 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
>  		if ((atomic_read(&lock->count) == 1) &&
>  		    (atomic_cmpxchg(&lock->count, 1, 0) == 1)) {
>  			lock_acquired(&lock->dep_map, ip);
> -			if (!__builtin_constant_p(ww_ctx == NULL)) {
> +			if (use_ww_ctx) {
>  				struct ww_mutex *ww;
>  				ww = container_of(lock, struct ww_mutex, base);
>  
> @@ -551,7 +551,7 @@ slowpath:
>  			goto err;
>  		}
>  
> -		if (!__builtin_constant_p(ww_ctx == NULL) && ww_ctx->acquired > 0) {
> +		if (use_ww_ctx && ww_ctx->acquired > 0) {
>  			ret = __mutex_lock_check_stamp(lock, ww_ctx);
>  			if (ret)
>  				goto err;
> @@ -575,7 +575,7 @@ skip_wait:
>  	lock_acquired(&lock->dep_map, ip);
>  	mutex_set_owner(lock);
>  
> -	if (!__builtin_constant_p(ww_ctx == NULL)) {
> +	if (use_ww_ctx) {
>  		struct ww_mutex *ww = container_of(lock, struct ww_mutex, base);
>  		struct mutex_waiter *cur;
>  
> @@ -615,7 +615,7 @@ mutex_lock_nested(struct mutex *lock, unsigned int subclass)
>  {
>  	might_sleep();
>  	__mutex_lock_common(lock, TASK_UNINTERRUPTIBLE,
> -			    subclass, NULL, _RET_IP_, NULL);
> +			    subclass, NULL, _RET_IP_, NULL, 0);
>  }
>  
>  EXPORT_SYMBOL_GPL(mutex_lock_nested);
> @@ -625,7 +625,7 @@ _mutex_lock_nest_lock(struct mutex *lock, struct lockdep_map *nest)
>  {
>  	might_sleep();
>  	__mutex_lock_common(lock, TASK_UNINTERRUPTIBLE,
> -			    0, nest, _RET_IP_, NULL);
> +			    0, nest, _RET_IP_, NULL, 0);
>  }
>  
>  EXPORT_SYMBOL_GPL(_mutex_lock_nest_lock);
> @@ -635,7 +635,7 @@ mutex_lock_killable_nested(struct mutex *lock, unsigned int subclass)
>  {
>  	might_sleep();
>  	return __mutex_lock_common(lock, TASK_KILLABLE,
> -				   subclass, NULL, _RET_IP_, NULL);
> +				   subclass, NULL, _RET_IP_, NULL, 0);
>  }
>  EXPORT_SYMBOL_GPL(mutex_lock_killable_nested);
>  
> @@ -644,7 +644,7 @@ mutex_lock_interruptible_nested(struct mutex *lock, unsigned int subclass)
>  {
>  	might_sleep();
>  	return __mutex_lock_common(lock, TASK_INTERRUPTIBLE,
> -				   subclass, NULL, _RET_IP_, NULL);
> +				   subclass, NULL, _RET_IP_, NULL, 0);
>  }
>  
>  EXPORT_SYMBOL_GPL(mutex_lock_interruptible_nested);
> @@ -682,7 +682,7 @@ __ww_mutex_lock(struct ww_mutex *lock, struct ww_acquire_ctx *ctx)
>  
>  	might_sleep();
>  	ret =  __mutex_lock_common(&lock->base, TASK_UNINTERRUPTIBLE,
> -				   0, &ctx->dep_map, _RET_IP_, ctx);
> +				   0, &ctx->dep_map, _RET_IP_, ctx, 1);
>  	if (!ret && ctx->acquired > 1)
>  		return ww_mutex_deadlock_injection(lock, ctx);
>  
> @@ -697,7 +697,7 @@ __ww_mutex_lock_interruptible(struct ww_mutex *lock, struct ww_acquire_ctx *ctx)
>  
>  	might_sleep();
>  	ret = __mutex_lock_common(&lock->base, TASK_INTERRUPTIBLE,
> -				  0, &ctx->dep_map, _RET_IP_, ctx);
> +				  0, &ctx->dep_map, _RET_IP_, ctx, 1);
>  
>  	if (!ret && ctx->acquired > 1)
>  		return ww_mutex_deadlock_injection(lock, ctx);
> @@ -809,28 +809,28 @@ __mutex_lock_slowpath(atomic_t *lock_count)
>  	struct mutex *lock = container_of(lock_count, struct mutex, count);
>  
>  	__mutex_lock_common(lock, TASK_UNINTERRUPTIBLE, 0,
> -			    NULL, _RET_IP_, NULL);
> +			    NULL, _RET_IP_, NULL, 0);
>  }
>  
>  static noinline int __sched
>  __mutex_lock_killable_slowpath(struct mutex *lock)
>  {
>  	return __mutex_lock_common(lock, TASK_KILLABLE, 0,
> -				   NULL, _RET_IP_, NULL);
> +				   NULL, _RET_IP_, NULL, 0);
>  }
>  
>  static noinline int __sched
>  __mutex_lock_interruptible_slowpath(struct mutex *lock)
>  {
>  	return __mutex_lock_common(lock, TASK_INTERRUPTIBLE, 0,
> -				   NULL, _RET_IP_, NULL);
> +				   NULL, _RET_IP_, NULL, 0);
>  }
>  
>  static noinline int __sched
>  __ww_mutex_lock_slowpath(struct ww_mutex *lock, struct ww_acquire_ctx *ctx)
>  {
>  	return __mutex_lock_common(&lock->base, TASK_UNINTERRUPTIBLE, 0,
> -				   NULL, _RET_IP_, ctx);
> +				   NULL, _RET_IP_, ctx, 1);
>  }
>  
>  static noinline int __sched
> @@ -838,7 +838,7 @@ __ww_mutex_lock_interruptible_slowpath(struct ww_mutex *lock,
>  					    struct ww_acquire_ctx *ctx)
>  {
>  	return __mutex_lock_common(&lock->base, TASK_INTERRUPTIBLE, 0,
> -				   NULL, _RET_IP_, ctx);
> +				   NULL, _RET_IP_, ctx, 1);
>  }
>  
>  #endif
> -- 
> 1.7.1
> 
