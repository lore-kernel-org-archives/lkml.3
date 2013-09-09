Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753267Ab3IIM6y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 08:58:54 -0400
Received: from merlin.infradead.org ([205.233.59.134]:50095 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751181Ab3IIM6v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 08:58:51 -0400
Date: Mon, 9 Sep 2013 14:58:41 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: maarten.lankhorst@canonical.com, imirkin@alum.mit.edu,
        linux-kernel@vger.kernel.org, daniel.vetter@ffwll.ch,
        robdclark@gmail.com, mingo@kernel.org
Subject: Re: [3.11-rc1] CONFIG_DEBUG_MUTEXES=y using gcc 3.x makes
 unbootablekernel.
Message-ID: <20130909125841.GZ31370@twins.programming.kicks-ass.net>
References: <CAKb7UvjH1XZ3f-c=149s5=rqxkxVUhG_7-cfUYH3zrwJwr2_MQ@mail.gmail.com>
 <201309081624.EBJ90176.OJStQOFLHVFFOM@I-love.SAKURA.ne.jp>
 <522C312A.7050705@canonical.com>
 <201309082053.FDB24195.FVOOJMStFQFLHO@I-love.SAKURA.ne.jp>
 <522CDFC8.9020903@canonical.com>
 <201309092056.GDH56750.OOMJtOHQVFFLSF@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201309092056.GDH56750.OOMJtOHQVFFLSF@I-love.SAKURA.ne.jp>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 09, 2013 at 08:56:53PM +0900, Tetsuo Handa wrote:
> From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> Date: Mon, 9 Sep 2013 20:48:13 +0900
> Subject: [PATCH] mutex: Avoid gcc version dependent __builtin_constant_p() usage.
> 
> Commit 040a0a37 "mutex: Add support for wound/wait style locks" used
> "!__builtin_constant_p(p == NULL)" but gcc 3.x cannot handle such expression
> correctly, leading to boot failure when built with CONFIG_DEBUG_MUTEXES=y.
> 
> Fix it by explicitly passing a bool which tells whether p != NULL or not.
> 
> Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> Cc: <stable@kernel.org> [3.11+]
> ---
>  kernel/mutex.c |   32 ++++++++++++++++----------------
>  1 files changed, 16 insertions(+), 16 deletions(-)
> 
> diff --git a/kernel/mutex.c b/kernel/mutex.c
> index a52ee7bb..a2b80f1 100644
> --- a/kernel/mutex.c
> +++ b/kernel/mutex.c
> @@ -408,7 +408,7 @@ ww_mutex_set_context_fastpath(struct ww_mutex *lock,
>  static __always_inline int __sched
>  __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
>  		    struct lockdep_map *nest_lock, unsigned long ip,
> -		    struct ww_acquire_ctx *ww_ctx)
> +		    struct ww_acquire_ctx *ww_ctx, const bool use_ww_ctx)
>  {
>  	struct task_struct *task = current;
>  	struct mutex_waiter waiter;
> @@ -448,7 +448,7 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
>  		struct task_struct *owner;
>  		struct mspin_node  node;
>  
> -		if (!__builtin_constant_p(ww_ctx == NULL) && ww_ctx->acquired > 0) {
> +		if (use_ww_ctx && ww_ctx->acquired > 0) {
>  			struct ww_mutex *ww;
>  
>  			ww = container_of(lock, struct ww_mutex, base);
> @@ -478,7 +478,7 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
>  		if ((atomic_read(&lock->count) == 1) &&
>  		    (atomic_cmpxchg(&lock->count, 1, 0) == 1)) {
>  			lock_acquired(&lock->dep_map, ip);
> -			if (!__builtin_constant_p(ww_ctx == NULL)) {
> +			if (use_ww_ctx) {
>  				struct ww_mutex *ww;
>  				ww = container_of(lock, struct ww_mutex, base);
>  
> @@ -548,7 +548,7 @@ slowpath:
>  			goto err;
>  		}
>  
> -		if (!__builtin_constant_p(ww_ctx == NULL) && ww_ctx->acquired > 0) {
> +		if (use_ww_ctx && ww_ctx->acquired > 0) {
>  			ret = __mutex_lock_check_stamp(lock, ww_ctx);
>  			if (ret)
>  				goto err;
> @@ -568,7 +568,7 @@ done:
>  	mutex_remove_waiter(lock, &waiter, current_thread_info());
>  	mutex_set_owner(lock);
>  
> -	if (!__builtin_constant_p(ww_ctx == NULL)) {
> +	if (use_ww_ctx) {
>  		struct ww_mutex *ww = container_of(lock,
>  						      struct ww_mutex,
>  						      base);
> @@ -618,7 +618,7 @@ mutex_lock_nested(struct mutex *lock, unsigned int subclass)
>  {
>  	might_sleep();
>  	__mutex_lock_common(lock, TASK_UNINTERRUPTIBLE,
> -			    subclass, NULL, _RET_IP_, NULL);
> +			    subclass, NULL, _RET_IP_, NULL, 0);
>  }
>  
>  EXPORT_SYMBOL_GPL(mutex_lock_nested);

This is a sad patch, but provided it actually generates similar code I
suppose its the best we can do bar whole sale deprecating gcc-3.
