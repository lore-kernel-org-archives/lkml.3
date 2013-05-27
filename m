Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757272Ab3E0J6r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 05:58:47 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:49778 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756527Ab3E0J6p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 05:58:45 -0400
Message-ID: <51A32E4F.6010500@canonical.com>
Date: Mon, 27 May 2013 11:58:39 +0200
From: Maarten Lankhorst <maarten.lankhorst@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, x86@kernel.org,
        dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
        robclark@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
        mingo@elte.hu, linux-media@vger.kernel.org,
        Dave Airlie <airlied@redhat.com>
Subject: Re: [PATCH v3 2/3] mutex: add support for wound/wait style locks,
 v3
References: <20130428165914.17075.57751.stgit@patser> <20130428170407.17075.80082.stgit@patser> <20130430191422.GA5763@phenom.ffwll.local> <519CA976.9000109@canonical.com> <20130522161831.GQ18810@twins.programming.kicks-ass.net> <519CFF56.90600@canonical.com> <20130527080019.GD2781@laptop> <51A318BF.7010109@canonical.com> <20130527091333.GH2781@laptop>
In-Reply-To: <20130527091333.GH2781@laptop>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Op 27-05-13 11:13, Peter Zijlstra schreef:
> On Mon, May 27, 2013 at 10:26:39AM +0200, Maarten Lankhorst wrote:
>> Op 27-05-13 10:00, Peter Zijlstra schreef:
>>> On Wed, May 22, 2013 at 07:24:38PM +0200, Maarten Lankhorst wrote:
>>>>>> +- Functions to only acquire a single w/w mutex, which results in the exact same
>>>>>> +  semantics as a normal mutex. These functions have the _single postfix.
>>>>> This is missing rationale.
>>>> trylock_single is useful when iterating over a list, and you want to evict a bo, but only the first one that can be acquired.
>>>> lock_single is useful when only a single bo needs to be acquired, for example to lock a buffer during mmap.
>>> OK, so given that its still early, monday and I haven't actually spend
>>> much time thinking on this; would it be possible to make:
>>> ww_mutex_lock(.ctx=NULL) act like ww_mutex_lock_single()?
>>>
>>> The idea is that if we don't provide a ctx, we'll get a different
>>> lockdep annotation; mutex_lock() vs mutex_lock_nest_lock(). So if we
>>> then go and make a mistake, lockdep should warn us.
>>>
>>> Would that work or should I stock up on morning juice?
>>>
>> It's easy to merge unlock_single and unlock, which I did in the next version I'll post.
>> Lockdep will already warn if ww_mutex_lock and ww_mutex_lock_single are both
>> used. ww_test_block_context and ww_test_context_block in lib/locking-selftest.c
>> are the testcases for this.
>>
>> The locking paths are too different, it will end up with doing "if (ctx == NULL) mutex_lock(); else ww_mutex_lock();"
> I was more thinking like:
>
> int __sched ww_mutex_lock(struct ww_mutex *lock, struct ww_acquire_ctx *ctx)
> {
> 	might_sleep();
> 	return __mutex_lock_common(&lock->base, TASK_UNINTERRUPTIBLE, 0,
> 				   ctx ? ctx->dep_map : NULL, _RET_IP_,
> 				   ctx, 0);
> }
>
> That should make ww_mutex_lock(.ctx=NULL) equivalent to
> mutex_lock(&lock->base), no?
>
> Anyway, implementation aside, it would again reduce the interface some.
>
It doesn't work like that. __builtin_constant_p(ctx == NULL) will evaluate to false in __mutex_lock_common, even if you call ww_mutex_lock(lock, NULL);
gcc cannot prove at compile time whether ctx == NULL is true or false for the __mutex_lock_common inlining here, so __builtin_constant_p() will return false.

And again, that's just saying

ww_mutex_lock() {
if (ctx)
original ww_mutex_lock's slowpath(lock, ctx);
else
mutex_lock's slowpath(lock->base);
}

And the next version will already remove unlock_single, and this is the implementation for lock_single currently:
static inline void ww_mutex_lock_single(struct ww_mutex *lock)
{
    mutex_lock(&lock->base);
}

So why do you want to merge it?

~Maarten

