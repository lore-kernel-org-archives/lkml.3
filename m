Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755615Ab3EVLSV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 07:18:21 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:45405 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752953Ab3EVLST (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 07:18:19 -0400
Message-ID: <519CA976.9000109@canonical.com>
Date: Wed, 22 May 2013 13:18:14 +0200
From: Maarten Lankhorst <maarten.lankhorst@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        peterz@infradead.org, x86@kernel.org, dri-devel@lists.freedesktop.org,
        linaro-mm-sig@lists.linaro.org, robclark@gmail.com,
        rostedt@goodmis.org, tglx@linutronix.de, mingo@elte.hu,
        linux-media@vger.kernel.org, Dave Airlie <airlied@redhat.com>
Subject: Re: [PATCH v3 2/3] mutex: add support for wound/wait style locks,
 v3
References: <20130428165914.17075.57751.stgit@patser> <20130428170407.17075.80082.stgit@patser> <20130430191422.GA5763@phenom.ffwll.local>
In-Reply-To: <20130430191422.GA5763@phenom.ffwll.local>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

Op 30-04-13 21:14, Daniel Vetter schreef:
> On Sun, Apr 28, 2013 at 07:04:07PM +0200, Maarten Lankhorst wrote:
>> Changes since RFC patch v1:
>>  - Updated to use atomic_long instead of atomic, since the reservation_id was a long.
>>  - added mutex_reserve_lock_slow and mutex_reserve_lock_intr_slow
>>  - removed mutex_locked_set_reservation_id (or w/e it was called)
>> Changes since RFC patch v2:
>>  - remove use of __mutex_lock_retval_arg, add warnings when using wrong combination of
>>    mutex_(,reserve_)lock/unlock.
>> Changes since v1:
>>  - Add __always_inline to __mutex_lock_common, otherwise reservation paths can be
>>    triggered from normal locks, because __builtin_constant_p might evaluate to false
>>    for the constant 0 in that case. Tests for this have been added in the next patch.
>>  - Updated documentation slightly.
>> Changes since v2:
>>  - Renamed everything to ww_mutex. (mlankhorst)
>>  - Added ww_acquire_ctx and ww_class. (mlankhorst)
>>  - Added a lot of checks for wrong api usage. (mlankhorst)
>>  - Documentation updates. (danvet)
> While writing the kerneldoc I've carefully check that all restrictions are
> enforced through debug checks somehow. I think that with full mutex debug
> (including lockdep) enabled, plus the slowpath injector patch I've just
> posted, _all_ interface abuse will be catched at runtime as long as all
> the single-threaded/uncontended cases are exercises sufficiently.
>
> So I think we've fully achieved level 5 on the Rusty API safety scale
> here. Higher levels seem pretty hard given that the concepts are rather
> fancy, but I think with the new (and much more consitent) naming, plus the
> explicit introduction as (more abstruct) structures for ww_class and
> ww_acquire_context the interface is about as intuitive as it gets.
>
> So all together I'm pretty happy with what the interface looks like. And
> one quick bikeshed below on the implementation.
> -Daniel
I included your fix below. I'm hoping to get this included in 3.11 through the drm tree, so
I can convert ttm to use it, but I haven't received any further reply on the patch series.

The 3.10 mutex improvement patches don't seem to cause any conflicts when merging
linus' tree, so I'll use drm-next as a base.

Are there any issues left? I included the patch you wrote for injecting -EDEADLK too
in my tree. The overwhelming silence makes me think there are either none, or
nobody cared enough to review it. :(

>> +/*
>> + * after acquiring lock with fastpath or when we lost out in contested
>> + * slowpath, set ctx and wake up any waiters so they can recheck.
>> + *
>> + * This function is never called when CONFIG_DEBUG_LOCK_ALLOC is set,
>> + * as the fastpath and opportunistic spinning are disabled in that case.
>> + */
>> +static __always_inline void
>> +ww_mutex_set_context_fastpath(struct ww_mutex *lock,
>> +			       struct ww_acquire_ctx *ctx)
>> +{
>> +	unsigned long flags;
>> +	struct mutex_waiter *cur;
>> +
>> +	ww_mutex_lock_acquired(lock, ctx, false);
>> +
>> +	lock->ctx = ctx;
>> +	smp_mb__after_atomic_dec();
> I think this should be
>
> +	smp_mb__after_atomic_dec();
> +	lock->ctx = ctx;
> +	smp_mb();
>
> Also I wonder a bit how much this hurts the fastpath, and whether we
> should just shovel the ctx into the atomic field with a cmpxcht, like the
> rt mutex code does with the current pointer.
>
Fixed. I'm not sure if the second smp_mb is really needed. If there was a
smp_mb__before_atomic_read it would have been sufficient.

~Maarten
