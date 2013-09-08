Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751908Ab3IHILg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Sep 2013 04:11:36 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:48581 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751550Ab3IHIL3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Sep 2013 04:11:29 -0400
Message-ID: <522C312A.7050705@canonical.com>
Date: Sun, 08 Sep 2013 10:11:22 +0200
From: Maarten Lankhorst <maarten.lankhorst@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130804 Thunderbird/17.0.8
MIME-Version: 1.0
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
CC: imirkin@alum.mit.edu, linux-kernel@vger.kernel.org, daniel.vetter@ffwll.ch,
        robdclark@gmail.com, a.p.zijlstra@chello.nl, mingo@kernel.org
Subject: Re: [3.11-rc1] CONFIG_DEBUG_MUTEXES=y using gcc 3.x makes unbootable
 kernel.
References: <201309080100.FFE90102.FFOVOtJQOFHSLM@I-love.SAKURA.ne.jp> <201309081332.FEJ52163.FHJOMQVOFOLStF@I-love.SAKURA.ne.jp> <CAKb7UvjH1XZ3f-c=149s5=rqxkxVUhG_7-cfUYH3zrwJwr2_MQ@mail.gmail.com> <201309081624.EBJ90176.OJStQOFLHVFFOM@I-love.SAKURA.ne.jp>
In-Reply-To: <201309081624.EBJ90176.OJStQOFLHVFFOM@I-love.SAKURA.ne.jp>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Op 08-09-13 09:24, Tetsuo Handa schreef:
> Hello.
>
> Ilia Mirkin wrote:
>>> Commit 040a0a37 "mutex: Add support for wound/wait style locks" used
>>> "!__builtin_constant_p(p == NULL)" which I guess the author meant that
>>> "__builtin_constant_p(p) && p", but gcc 3.x cannot handle such expression
>>> correctly, leading to boot failure when built with CONFIG_DEBUG_MUTEXES=y.
>> I think that !__builtin_constant_p(p == NULL) is basically saying "I
>> am unable to conclude that p == NULL at build time", which would
>> translate to something along the lines of
>>
>> (__builtin_constant_p(p) && p) || !__builtin_constant_p(p)
>>
> I think
>
>   (__builtin_constant_p(p) && p) && p->acquired > 0
>
> is safe but
>
>   (!__builtin_constant_p(p)) && p->acquired > 0
>
> is not safe, for "p != NULL" check is required for avoiding NULL pointer
> dereference.
>
> It seems to me that
>
>   (!__builtin_constant_p(p == NULL))
>
> need to be translated to something along the lines of
>
>   (__builtin_constant_p(p) && p) || (!__builtin_constant_p(p) && p)
>
> which can be simplified as
>
>   (p)
>
> .
>
>> Or perhaps it's just equivalent to !__builtin_constant_p(p), since the
>> compiler's ability to conclude whether it is NULL at build-time should
>> be unaffected by whether it actually is NULL or not.
> Likewise, it seems to me that
>
>   (!__builtin_constant_p(p == NULL))
>
> need to be translated to something along the lines of
>
>   (!__builtin_constant_p(p) && p)
>
> . Well this change as well can fix "boot failure on gcc 3.x" and avoid "locking
> selftests failure on gcc 3.x / 4.x". OK, let's wait for answer from the author.
>
> Can I add "Signed-off-by: Ilia Mirkin <imirkin@alum.mit.edu>" to below patch?
>
> ---------- good patch start ----------
> >From a8bbf6b3c2d44cb90d63820f146aaff119d871c9 Mon Sep 17 00:00:00 2001
> From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> Date: Sun, 8 Sep 2013 16:09:27 +0900
> Subject: [PATCH] mutex: Avoid gcc version dependent __builtin_constant_p() usage.
>
> Commit 040a0a37 "mutex: Add support for wound/wait style locks" used
> "!__builtin_constant_p(p == NULL)" but gcc 3.x cannot handle such expression
> correctly, leading to boot failure when built with CONFIG_DEBUG_MUTEXES=y.
>
> Fix it by changing from "!__builtin_constant_p(p == NULL)" to
> "!__builtin_constant_p(p) && p".
>
> Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> Cc: <stable@kernel.org> [3.11+]
> ---
>  kernel/mutex.c |    8 ++++----
>  1 files changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/kernel/mutex.c b/kernel/mutex.c
> index a52ee7bb..ef02003 100644
> --- a/kernel/mutex.c
> +++ b/kernel/mutex.c
> @@ -448,7 +448,7 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
>  		struct task_struct *owner;
>  		struct mspin_node  node;
>  
> -		if (!__builtin_constant_p(ww_ctx == NULL) && ww_ctx->acquired > 0) {
> +		if (!__builtin_constant_p(ww_ctx) && ww_ctx && ww_ctx->acquired > 0) {
>  			struct ww_mutex *ww;
>  
>  			ww = container_of(lock, struct ww_mutex, base);
> @@ -478,7 +478,7 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
>  		if ((atomic_read(&lock->count) == 1) &&
>  		    (atomic_cmpxchg(&lock->count, 1, 0) == 1)) {
>  			lock_acquired(&lock->dep_map, ip);
> -			if (!__builtin_constant_p(ww_ctx == NULL)) {
> +			if (!__builtin_constant_p(ww_ctx) && ww_ctx) {
>  				struct ww_mutex *ww;
>  				ww = container_of(lock, struct ww_mutex, base);
>  
> @@ -548,7 +548,7 @@ slowpath:
>  			goto err;
>  		}
>  
> -		if (!__builtin_constant_p(ww_ctx == NULL) && ww_ctx->acquired > 0) {
> +		if (!__builtin_constant_p(ww_ctx) && ww_ctx && ww_ctx->acquired > 0) {
>  			ret = __mutex_lock_check_stamp(lock, ww_ctx);
>  			if (ret)
>  				goto err;
> @@ -568,7 +568,7 @@ done:
>  	mutex_remove_waiter(lock, &waiter, current_thread_info());
>  	mutex_set_owner(lock);
>  
> -	if (!__builtin_constant_p(ww_ctx == NULL)) {
> +	if (!__builtin_constant_p(ww_ctx) && ww_ctx) {
>  		struct ww_mutex *ww = container_of(lock,
>  						      struct ww_mutex,
>  						      base);
Wrong. Wrong. Wrong.
The builtin_constant_p was explicitly added to NOT do a null pointer check in the ww_ctx case, and now you re-introduce it for ALL
compilers. Gcc will still think ww_ctx may be NULL in the ww_mutex_lock case.

__builtin_constant_p(ww_ctx) always evaluates to false, and is not equivalent to __builtin_constant_p(ww_ctx != NULL) in gcc 4.6 at least,
I have no idea why gcc treats pointers differently like that. Explicitly testing against NULL fixes it.
__builtin_constant_p(ww_ctx == NULL) should return the same value as __builtin_constant_p(ww_ctx != NULL), but I did the == NULL check for clarity,

if it's broken for your compiler, please add a bool use_ww_ctx or something to __mutex_lock_common that's set directly instead, the __builtin_constant_p trick
might be too gcc version specific.

~Maarten
