Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757145Ab3BNOUB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 09:20:01 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:59789 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753604Ab3BNOT5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 09:19:57 -0500
Message-ID: <511CF288.4040809@canonical.com>
Date: Thu, 14 Feb 2013 15:19:52 +0100
From: Maarten Lankhorst <maarten.lankhorst@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: linaro-mm-sig@lists.linaro.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, a.p.zijlstra@chello.nl, x86@kernel.org,
        dri-devel@lists.freedesktop.org, robclark@gmail.com,
        tglx@linutronix.de, mingo@elte.hu, linux-media@vger.kernel.org
Subject: Re: [Linaro-mm-sig] [PATCH 2/3] mutex: add support for reservation
 style locks
References: <20130207151831.2868.5146.stgit@patser.local> <20130207151838.2868.69610.stgit@patser.local> <201302141022.00297.arnd@arndb.de>
In-Reply-To: <201302141022.00297.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

Op 14-02-13 11:22, Arnd Bergmann schreef:
> On Thursday 07 February 2013, Maarten Lankhorst wrote:
>
> Hi Maarten,
>
> I cannot help a lot on this patch set, but there are a few things that
> I noticed when reading it.
>
>> Functions:
>> ----------
>>
>> mutex_reserve_lock, and mutex_reserve_lock_interruptible:
>>   Lock a buffer with a reservation_id set. reservation_id must not be
>>   set to 0, since this is a special value that means no reservation_id.
> I think the entire description should go into a file in the Documentation
> directory, to make it easier to find without looking up the git history.
>
> For the purpose of documenting this, it feels a little strange to
> talk about "buffers" here. Obviously this is what you are using the
> locks for, but it sounds like that is not the only possible use
> case.
It is the idea it will end up in Documentation, however I had a hard time even getting people to
review the code, so I found it easier to keep code and documentation in sync by keeping it into
the commit log when I was amending things.

But yes it's the use case I use it for. The generic use case would be if you had a number of equal
locks you want to take in an arbitrary order without deadlocking or a lock protecting all those locks*.

*) In the eyes of lockdep you still take one of those locks, and nest all those locks you take into that lock.

>>   These functions will return -EDEADLK instead of -EAGAIN if
>>   reservation_id is the same as the reservation_id that's attempted to
>>   lock the mutex with, since in that case you presumably attempted to
>>   lock the same lock twice.
> Since the user always has to check the return value, would it be
> possible to provide only the interruptible kind of this function
> but not the non-interruptible one? In general, interruptible locks
> are obviously harder to use, but they are much user friendlier when
> something goes wrong.
I agree that in general you want to use the interruptible versions as much as possible,
but there are some cases in ttm where it is desirable to lock non-interruptibly.

>> mutex_reserve_lock_slow and mutex_reserve_lock_intr_slow:
>>   Similar to mutex_reserve_lock, except it won't backoff with -EAGAIN.
>>   This is useful when mutex_reserve_lock failed with -EAGAIN, and you
>>   unreserved all buffers so no deadlock can occur.
> Are these meant to be used a lot? If not, maybe prefix them with __mutex_
> instead of mutex_.
It is a common path in case of contestion. The example lock_execbuf from the commit log used
 it. When you use the mutex_reserve_lock calls, you'll have to add calls to the *_slow variants
too when those return -EAGAIN.

>> diff --git a/include/linux/mutex.h b/include/linux/mutex.h
>> index 9121595..602c247 100644
>> --- a/include/linux/mutex.h
>> +++ b/include/linux/mutex.h
>> @@ -62,6 +62,11 @@ struct mutex {
>>  #endif
>>  };
>>  
>> +struct ticket_mutex {
>> +	struct mutex base;
>> +	atomic_long_t reservation_id;
>> +};
> Have you considered changing the meaning of the "count" member
> of the mutex in the case where a ticket mutex is used? That would
> let you use an unmodified structure.
I have considered it, but I never found a good way to make that happen.
mutex_lock and mutex_unlock are currently still used when only a single
buffer needs to be locked.

Thanks for the review!

~Maarten
