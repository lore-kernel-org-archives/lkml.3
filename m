Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752612AbbA0Gt3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 01:49:29 -0500
Received: from mail-wi0-f169.google.com ([209.85.212.169]:47641 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751427AbbA0Gt2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 01:49:28 -0500
Message-ID: <1422341364.5145.11.camel@marge.simpson.net>
Subject: Re: [PATCH -rt] rtmutex: enable deadlock detection in the
 ww_mutex_lock functions
From: Mike Galbraith <umgwanakikbuti@gmail.com>
To: Gustavo Bittencourt <gbitten@gmail.com>
Cc: linux-kernel@vger.kernel.org
Date: Tue, 27 Jan 2015 07:49:24 +0100
In-Reply-To: <54C727DA.4040601@gmail.com>
References: <54C727DA.4040601@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

You should probably CC -rt maintainers when submitting a -rt patch.

On Tue, 2015-01-27 at 03:53 -0200, Gustavo Bittencourt wrote: 
> According the ww-mutex-design.txt documentation,  the ww_mutex_lock_interruptible and ww_mutex_lock functions should return -EDEADLK when faced with a deadlock. To do so, the flag detect_deadlock in the rt_mutex_slowlock calls should be enabled. This patch corrects potential deadlocks when running PREEMPT_RT with nouveau driver.
> 
> Kernel v3.14-rt
> 
> Signed-off-by: Gustavo Bittencourt<gbitten@gmail.com>
> ---
>   kernel/locking/rtmutex.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/locking/rtmutex.c b/kernel/locking/rtmutex.c
> index 6c40660..3f6ef91 100644
> --- a/kernel/locking/rtmutex.c
> +++ b/kernel/locking/rtmutex.c
> @@ -1965,7 +1965,7 @@ __ww_mutex_lock_interruptible(struct ww_mutex *lock, struct ww_acquire_ctx *ww_c
>   	might_sleep();
>   
>   	mutex_acquire(&lock->base.dep_map, 0, 0,_RET_IP_);
> -	ret = rt_mutex_slowlock(&lock->base.lock, TASK_INTERRUPTIBLE, NULL, 0, ww_ctx);
> +	ret = rt_mutex_slowlock(&lock->base.lock, TASK_INTERRUPTIBLE, NULL, 1, ww_ctx);
>   	if (ret)
>   		mutex_release(&lock->base.dep_map, 1,_RET_IP_);
>   	else if (!ret && ww_ctx->acquired > 1)
> @@ -1984,7 +1984,7 @@ __ww_mutex_lock(struct ww_mutex *lock, struct ww_acquire_ctx *ww_ctx)
>   
>   	mutex_acquire_nest(&lock->base.dep_map, 0, 0, &ww_ctx->dep_map,
>   			_RET_IP_);
> -	ret = rt_mutex_slowlock(&lock->base.lock, TASK_UNINTERRUPTIBLE, NULL, 0, ww_ctx);
> +	ret = rt_mutex_slowlock(&lock->base.lock, TASK_UNINTERRUPTIBLE, NULL, 1, ww_ctx);
>   	if (ret)
>   		mutex_release(&lock->base.dep_map, 1,_RET_IP_);
>   	else if (!ret && ww_ctx->acquired > 1)
> -- 1.9.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


