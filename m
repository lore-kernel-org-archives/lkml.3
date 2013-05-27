Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757349Ab3E0KBy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 06:01:54 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:49827 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756904Ab3E0KBw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 06:01:52 -0400
Message-ID: <51A32F0E.9000206@canonical.com>
Date: Mon, 27 May 2013 12:01:50 +0200
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
References: <20130428165914.17075.57751.stgit@patser> <20130428170407.17075.80082.stgit@patser> <20130430191422.GA5763@phenom.ffwll.local> <519CA976.9000109@canonical.com> <20130522161831.GQ18810@twins.programming.kicks-ass.net> <519CFF56.90600@canonical.com> <20130527082149.GE2781@laptop>
In-Reply-To: <20130527082149.GE2781@laptop>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Op 27-05-13 10:21, Peter Zijlstra schreef:
> On Wed, May 22, 2013 at 07:24:38PM +0200, Maarten Lankhorst wrote:
>>>> +static inline void ww_acquire_init(struct ww_acquire_ctx *ctx,
>>>> +				   struct ww_class *ww_class)
>>>> +{
>>>> +	ctx->task = current;
>>>> +	do {
>>>> +		ctx->stamp = atomic_long_inc_return(&ww_class->stamp);
>>>> +	} while (unlikely(!ctx->stamp));
>>> I suppose we'll figure something out when this becomes a bottleneck. Ideally
>>> we'd do something like:
>>>
>>>  ctx->stamp = local_clock();
>>>
>>> but for now we cannot guarantee that's not jiffies, and I suppose that's a tad
>>> too coarse to work for this.
>> This might mess up when 2 cores happen to return exactly the same time, how do you choose a winner in that case?
>> EDIT: Using pointer address like you suggested below is fine with me. ctx pointer would be static enough.
> Right, but for now I suppose the 'global' atomic is ok, if/when we find
> it hurts performance we can revisit. I was just spewing ideas :-)
If  accurate timers are available it wouldn't be a bad idea. I fixed up the code to at least support this case should it happen.
For now the source of the stamp is still a single atomic_long.

>>> Also, why is 0 special?
>> Oops, 0 is no longer special.
>>
>> I used to set the samp directly on the lock, so 0 used to mean no ctx set.
> Ah, ok :-)
>
>>>> +static inline int __must_check ww_mutex_trylock_single(struct ww_mutex *lock)
>>>> +{
>>>> +	return mutex_trylock(&lock->base);
>>>> +}
>>> trylocks can never deadlock they don't block per definition, I don't see the
>>> point of the _single() thing here.
>> I called it single because they weren't annotated into any ctx. I can drop the _single suffix though,
>> but you'd still need to unlock with unlock_single, or we need to remove that distinction altogether,
>> lose a few lockdep checks and only have a one unlock function.
> Again, early.. monday.. would a trylock, even if successful still need
> the ctx?
No ctx for trylock is supported. You can still do a trylock while holding a context, but the mutex won't be
a part of the context. Normal lockdep rules apply. lib/locking-selftest.c:

context + ww_mutex_lock first, then a trylock:
dotest(ww_test_context_try, SUCCESS, LOCKTYPE_WW);

trylock first, then context + ww_mutex_lock:
dotest(ww_test_try_context, FAILURE, LOCKTYPE_WW);

For now I don't want to add support for a trylock with context, I'm very glad I managed to fix ttm locking
to not require this any more, and it was needed there only because it was a workaround for the locking
being wrong.  There was no annotation for the buffer locking it was using, so the real problem wasn't easy to spot.

~Maarten
