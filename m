Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755148Ab3HEH6B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 03:58:01 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:54284 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754836Ab3HEH57 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 03:57:59 -0400
Date: Mon, 5 Aug 2013 09:58:05 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Maarten Lankhorst <maarten.lankhorst@canonical.com>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        Alex Deucher <alexander.deucher@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] mutex: fix deadlock injection
Message-ID: <20130805075805.GB22035@phenom.ffwll.local>
Mail-Followup-To: Maarten Lankhorst <maarten.lankhorst@canonical.com>,
	Ingo Molnar <mingo@kernel.org>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	"dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
	Alex Deucher <alexander.deucher@amd.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Andrew Morton <akpm@linux-foundation.org>
References: <20130701082221.GA14112@gmail.com>
 <CA+55aFwfsz6e5oQAdZw-YyYzwJXCPjKJKiLEXxn7ujU7KWX97Q@mail.gmail.com>
 <51D3C4C8.8060701@canonical.com>
 <20130705062345.GA29487@gmail.com>
 <51F775B5.201@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51F775B5.201@canonical.com>
X-Operating-System: Linux phenom 3.11.0-rc2+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 30, 2013 at 10:13:41AM +0200, Maarten Lankhorst wrote:
> The check needs to be for > 1, because ctx->acquired is already incremented.
> This will prevent ww_mutex_lock_slow from returning -EDEADLK and not locking
> the mutex. It caused a lot of false gpu lockups on radeon with
> CONFIG_DEBUG_WW_MUTEX_SLOWPATH=y because a function that shouldn't be able
> to return -EDEADLK did.
> 
> Cc: Alex Deucher <alexander.deucher@amd.com>
> Signed-off-by: Maarten Lankhorst <maarten.lankhorst@canonical.com>

Oops, thanks for catching this.

Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>

> ---
> diff --git a/kernel/mutex.c b/kernel/mutex.c
> index ff05f4b..a52ee7bb 100644
> --- a/kernel/mutex.c
> +++ b/kernel/mutex.c
> @@ -686,7 +686,7 @@ __ww_mutex_lock(struct ww_mutex *lock, struct ww_acquire_ctx *ctx)
>  	might_sleep();
>  	ret =  __mutex_lock_common(&lock->base, TASK_UNINTERRUPTIBLE,
>  				   0, &ctx->dep_map, _RET_IP_, ctx);
> -	if (!ret && ctx->acquired > 0)
> +	if (!ret && ctx->acquired > 1)
>  		return ww_mutex_deadlock_injection(lock, ctx);
>  
>  	return ret;
> @@ -702,7 +702,7 @@ __ww_mutex_lock_interruptible(struct ww_mutex *lock, struct ww_acquire_ctx *ctx)
>  	ret = __mutex_lock_common(&lock->base, TASK_INTERRUPTIBLE,
>  				  0, &ctx->dep_map, _RET_IP_, ctx);
>  
> -	if (!ret && ctx->acquired > 0)
> +	if (!ret && ctx->acquired > 1)
>  		return ww_mutex_deadlock_injection(lock, ctx);
>  
>  	return ret;
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel

-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
