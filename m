Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933615Ab3D3TLb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 15:11:31 -0400
Received: from mail-we0-f172.google.com ([74.125.82.172]:60422 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932711Ab3D3TL2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 15:11:28 -0400
Date: Tue, 30 Apr 2013 21:14:22 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Maarten Lankhorst <maarten.lankhorst@canonical.com>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        peterz@infradead.org, x86@kernel.org, dri-devel@lists.freedesktop.org,
        linaro-mm-sig@lists.linaro.org, robclark@gmail.com,
        rostedt@goodmis.org, daniel@ffwll.ch, tglx@linutronix.de,
        mingo@elte.hu, linux-media@vger.kernel.org
Subject: Re: [PATCH v3 2/3] mutex: add support for wound/wait style locks, v3
Message-ID: <20130430191422.GA5763@phenom.ffwll.local>
Mail-Followup-To: Maarten Lankhorst <maarten.lankhorst@canonical.com>,
	linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
	peterz@infradead.org, x86@kernel.org,
	dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
	robclark@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
	mingo@elte.hu, linux-media@vger.kernel.org
References: <20130428165914.17075.57751.stgit@patser>
 <20130428170407.17075.80082.stgit@patser>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130428170407.17075.80082.stgit@patser>
X-Operating-System: Linux phenom 3.9.0-rc6+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 28, 2013 at 07:04:07PM +0200, Maarten Lankhorst wrote:
> Changes since RFC patch v1:
>  - Updated to use atomic_long instead of atomic, since the reservation_id was a long.
>  - added mutex_reserve_lock_slow and mutex_reserve_lock_intr_slow
>  - removed mutex_locked_set_reservation_id (or w/e it was called)
> Changes since RFC patch v2:
>  - remove use of __mutex_lock_retval_arg, add warnings when using wrong combination of
>    mutex_(,reserve_)lock/unlock.
> Changes since v1:
>  - Add __always_inline to __mutex_lock_common, otherwise reservation paths can be
>    triggered from normal locks, because __builtin_constant_p might evaluate to false
>    for the constant 0 in that case. Tests for this have been added in the next patch.
>  - Updated documentation slightly.
> Changes since v2:
>  - Renamed everything to ww_mutex. (mlankhorst)
>  - Added ww_acquire_ctx and ww_class. (mlankhorst)
>  - Added a lot of checks for wrong api usage. (mlankhorst)
>  - Documentation updates. (danvet)

While writing the kerneldoc I've carefully check that all restrictions are
enforced through debug checks somehow. I think that with full mutex debug
(including lockdep) enabled, plus the slowpath injector patch I've just
posted, _all_ interface abuse will be catched at runtime as long as all
the single-threaded/uncontended cases are exercises sufficiently.

So I think we've fully achieved level 5 on the Rusty API safety scale
here. Higher levels seem pretty hard given that the concepts are rather
fancy, but I think with the new (and much more consitent) naming, plus the
explicit introduction as (more abstruct) structures for ww_class and
ww_acquire_context the interface is about as intuitive as it gets.

So all together I'm pretty happy with what the interface looks like. And
one quick bikeshed below on the implementation.
-Daniel

> 
> Signed-off-by: Maarten Lankhorst <maarten.lankhorst@canonical.com>
> Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
> ---
>  Documentation/ww-mutex-design.txt |  322 +++++++++++++++++++++++++++
>  include/linux/mutex-debug.h       |    1 
>  include/linux/mutex.h             |  257 +++++++++++++++++++++
>  kernel/mutex.c                    |  445 ++++++++++++++++++++++++++++++++++++-
>  lib/debug_locks.c                 |    2 
>  5 files changed, 1010 insertions(+), 17 deletions(-)
>  create mode 100644 Documentation/ww-mutex-design.txt

[snip]

> +/*
> + * after acquiring lock with fastpath or when we lost out in contested
> + * slowpath, set ctx and wake up any waiters so they can recheck.
> + *
> + * This function is never called when CONFIG_DEBUG_LOCK_ALLOC is set,
> + * as the fastpath and opportunistic spinning are disabled in that case.
> + */
> +static __always_inline void
> +ww_mutex_set_context_fastpath(struct ww_mutex *lock,
> +			       struct ww_acquire_ctx *ctx)
> +{
> +	unsigned long flags;
> +	struct mutex_waiter *cur;
> +
> +	ww_mutex_lock_acquired(lock, ctx, false);
> +
> +	lock->ctx = ctx;
> +	smp_mb__after_atomic_dec();

I think this should be

+	smp_mb__after_atomic_dec();
+	lock->ctx = ctx;
+	smp_mb();

Also I wonder a bit how much this hurts the fastpath, and whether we
should just shovel the ctx into the atomic field with a cmpxcht, like the
rt mutex code does with the current pointer.

> +
> +	/*
> +	 * Check if lock is contended, if not there is nobody to wake up
> +	 */
> +	if (likely(atomic_read(&lock->base.count) == 0))
> +		return;
> +
> +	/*
> +	 * Uh oh, we raced in fastpath, wake up everyone in this case,
> +	 * so they can see the new ctx
> +	 */
> +	spin_lock_mutex(&lock->base.wait_lock, flags);
> +	list_for_each_entry(cur, &lock->base.wait_list, list) {
> +		debug_mutex_wake_waiter(&lock->base, cur);
> +		wake_up_process(cur->task);
> +	}
> +	spin_unlock_mutex(&lock->base.wait_lock, flags);
> +}
> +
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
