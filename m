Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756800Ab3E1VMK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 17:12:10 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59410 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756022Ab3E1VMH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 17:12:07 -0400
Message-ID: <51A51DA4.7010805@canonical.com>
Date: Tue, 28 May 2013 23:12:04 +0200
From: Maarten Lankhorst <maarten.lankhorst@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        peterz@infradead.org, x86@kernel.org, dri-devel@lists.freedesktop.org,
        linaro-mm-sig@lists.linaro.org, robclark@gmail.com,
        rostedt@goodmis.org, tglx@linutronix.de, mingo@elte.hu,
        linux-media@vger.kernel.org
Subject: Re: [PATCH v4 3/4] mutex: Add ww tests to lib/locking-selftest.c.
 v4
References: <20130528144420.4538.70725.stgit@patser> <20130528144845.4538.93485.stgit@patser> <20130528191847.GE15743@phenom.ffwll.local>
In-Reply-To: <20130528191847.GE15743@phenom.ffwll.local>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Op 28-05-13 21:18, Daniel Vetter schreef:
> On Tue, May 28, 2013 at 04:48:45PM +0200, Maarten Lankhorst wrote:
>> This stresses the lockdep code in some ways specifically useful to
>> ww_mutexes. It adds checks for most of the common locking errors.
>>
>> Changes since v1:
>>  - Add tests to verify reservation_id is untouched.
>>  - Use L() and U() macros where possible.
>>
>> Changes since v2:
>>  - Use the ww_mutex api directly.
>>  - Use macros for most of the code.
>> Changes since v3:
>>  - Rework tests for the api changes.
>>
>> <snip>
>>
>> +static void ww_test_normal(void)
>> +{
>> +	int ret;
>> +
>> +	WWAI(&t);
>> +
>> +	/*
>> +	 * test if ww_id is kept identical if not
>> +	 * called with any of the ww_* locking calls
>> +	 */
>> +
>> +	/* mutex_lock (and indirectly, mutex_lock_nested) */
>> +	o.ctx = (void *)~0UL;
>> +	mutex_lock(&o.base);
>> +	mutex_unlock(&o.base);
>> +	WARN_ON(o.ctx != (void *)~0UL);
>> +
>> +	/* mutex_lock_interruptible (and *_nested) */
>> +	o.ctx = (void *)~0UL;
>> +	ret = mutex_lock_interruptible(&o.base);
>> +	if (!ret)
>> +		mutex_unlock(&o.base);
>> +	else
>> +		WARN_ON(1);
>> +	WARN_ON(o.ctx != (void *)~0UL);
>> +
>> +	/* mutex_lock_killable (and *_nested) */
>> +	o.ctx = (void *)~0UL;
>> +	ret = mutex_lock_killable(&o.base);
>> +	if (!ret)
>> +		mutex_unlock(&o.base);
>> +	else
>> +		WARN_ON(1);
>> +	WARN_ON(o.ctx != (void *)~0UL);
>> +
>> +	/* trylock, succeeding */
>> +	o.ctx = (void *)~0UL;
>> +	ret = mutex_trylock(&o.base);
>> +	WARN_ON(!ret);
>> +	if (ret)
>> +		mutex_unlock(&o.base);
>> +	else
>> +		WARN_ON(1);
>> +	WARN_ON(o.ctx != (void *)~0UL);
>> +
>> +	/* trylock, failing */
>> +	o.ctx = (void *)~0UL;
>> +	mutex_lock(&o.base);
>> +	ret = mutex_trylock(&o.base);
>> +	WARN_ON(ret);
>> +	mutex_unlock(&o.base);
>> +	WARN_ON(o.ctx != (void *)~0UL);
>> +
>> +	/* nest_lock */
>> +	o.ctx = (void *)~0UL;
>> +	mutex_lock_nest_lock(&o.base, &t);
>> +	mutex_unlock(&o.base);
>> +	WARN_ON(o.ctx != (void *)~0UL);
>> +}
> Since we don't really allow this any more (instead allow ww_mutex_lock
> without context) do we need this test here really?
Yes. This test verifies all the normal locking paths are not affected by the ww_ctx changes.

>> +
>> +static void ww_test_two_contexts(void)
>> +{
>> +	WWAI(&t);
>> +	WWAI(&t2);
>> +}
>> +
>> +static void ww_test_context_unlock_twice(void)
>> +{
>> +	WWAI(&t);
>> +	WWAD(&t);
>> +	WWAF(&t);
>> +	WWAF(&t);
>> +}
>> +
>> +static void ww_test_object_unlock_twice(void)
>> +{
>> +	WWL1(&o);
>> +	WWU(&o);
>> +	WWU(&o);
>> +}
>> +
>> +static void ww_test_spin_nest_unlocked(void)
>> +{
>> +	raw_spin_lock_nest_lock(&lock_A, &o.base);
>> +	U(A);
>> +}
> I don't quite see the point of this one here ...
It's a lockdep test that was missing. o.base is not locked. So lock_A is being nested into an unlocked lock, resulting in a lockdep error.

>> +
>> +static void ww_test_unneeded_slow(void)
>> +{
>> +	int ret;
>> +
>> +	WWAI(&t);
>> +
>> +	ww_mutex_lock_slow(&o, &t);
>> +}
> I think checking the _slow debug stuff would be neat, i.e.
> - fail/success tests for properly unlocking all held locks
> - fail/success tests for lock_slow acquiring the right lock.
>
> Otherwise I didn't spot anything that seems missing in these self-tests
> here.
>
Yes it would be nice, doing so is left as an excercise for the reviewer, who failed to raise this point sooner. ;-)

~Maarten
