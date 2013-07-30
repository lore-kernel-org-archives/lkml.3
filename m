Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755916Ab3G3NJi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 09:09:38 -0400
Received: from mail-vb0-f41.google.com ([209.85.212.41]:40291 "EHLO
	mail-vb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755678Ab3G3NJe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 09:09:34 -0400
MIME-Version: 1.0
In-Reply-To: <51F775B5.201@canonical.com>
References: <20130701082221.GA14112@gmail.com>
	<CA+55aFwfsz6e5oQAdZw-YyYzwJXCPjKJKiLEXxn7ujU7KWX97Q@mail.gmail.com>
	<51D3C4C8.8060701@canonical.com>
	<20130705062345.GA29487@gmail.com>
	<51F775B5.201@canonical.com>
Date: Tue, 30 Jul 2013 09:09:33 -0400
Message-ID: <CADnq5_PLu7w=Aqq2N1Mpy+tQtugGSvxm1wckEOtqDGc8u4wFpw@mail.gmail.com>
Subject: Re: [PATCH] mutex: fix deadlock injection
From: Alex Deucher <alexdeucher@gmail.com>
To: Maarten Lankhorst <maarten.lankhorst@canonical.com>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        Alex Deucher <alexander.deucher@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 30, 2013 at 4:13 AM, Maarten Lankhorst
<maarten.lankhorst@canonical.com> wrote:
> The check needs to be for > 1, because ctx->acquired is already incremented.
> This will prevent ww_mutex_lock_slow from returning -EDEADLK and not locking
> the mutex. It caused a lot of false gpu lockups on radeon with
> CONFIG_DEBUG_WW_MUTEX_SLOWPATH=y because a function that shouldn't be able
> to return -EDEADLK did.
>

I haven't followed the new reservation stuff too closely, but seems plausible.

Acked-by: Alex Deucher <alexander.deucher@amd.com>

> Cc: Alex Deucher <alexander.deucher@amd.com>
> Signed-off-by: Maarten Lankhorst <maarten.lankhorst@canonical.com>
> ---
> diff --git a/kernel/mutex.c b/kernel/mutex.c
> index ff05f4b..a52ee7bb 100644
> --- a/kernel/mutex.c
> +++ b/kernel/mutex.c
> @@ -686,7 +686,7 @@ __ww_mutex_lock(struct ww_mutex *lock, struct ww_acquire_ctx *ctx)
>         might_sleep();
>         ret =  __mutex_lock_common(&lock->base, TASK_UNINTERRUPTIBLE,
>                                    0, &ctx->dep_map, _RET_IP_, ctx);
> -       if (!ret && ctx->acquired > 0)
> +       if (!ret && ctx->acquired > 1)
>                 return ww_mutex_deadlock_injection(lock, ctx);
>
>         return ret;
> @@ -702,7 +702,7 @@ __ww_mutex_lock_interruptible(struct ww_mutex *lock, struct ww_acquire_ctx *ctx)
>         ret = __mutex_lock_common(&lock->base, TASK_INTERRUPTIBLE,
>                                   0, &ctx->dep_map, _RET_IP_, ctx);
>
> -       if (!ret && ctx->acquired > 0)
> +       if (!ret && ctx->acquired > 1)
>                 return ww_mutex_deadlock_injection(lock, ctx);
>
>         return ret;
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel
