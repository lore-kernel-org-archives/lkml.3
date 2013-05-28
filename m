Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754487Ab3E1Ten (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 15:34:43 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:37651 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752468Ab3E1Tem (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 15:34:42 -0400
Message-ID: <51A5069F.7050607@oracle.com>
Date: Tue, 28 May 2013 15:33:51 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130527 Thunderbird/17.0.6
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: torvalds@linux-foundation.org, mingo@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 3/9] liblockdep: Add public headers for pthread_mutex_t
 implementation
References: <1368674141-10796-1-git-send-email-sasha.levin@oracle.com> <1368674141-10796-4-git-send-email-sasha.levin@oracle.com> <20130522092232.GF18810@twins.programming.kicks-ass.net>
In-Reply-To: <20130522092232.GF18810@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/22/2013 05:22 AM, Peter Zijlstra wrote:
> They will however then also want all the 'normal' lockdep annotations to
> deal with that like:
> 
> liblockdep_pthread_mutex_lock_nested()
> liblockdep_pthread_mutex_lock_nest_lock()
> 
> *phew* and here I always though pthread_mutex_* was a long prefix...
> 
> Also, the above doesn't have the full lockstat contention hooks -- not
> sure that's on purpose or not.

I was quietly hoping on leaving this out in the initial version of liblockdep
and start adding this and the rest of the toys that come with lockdep once we
figure out whether this code will go into the kernel tree or not.

Should I be adding them now?

>> +
>> +static inline int liblockdep_pthread_mutex_unlock(liblockdep_pthread_mutex_t *lock)
>> +{
>> +	lock_release(&lock->dep_map, 0, (unsigned long)_RET_IP_);
>> +	return pthread_mutex_unlock(&lock->mutex);
>> +}
>> +
>> +static inline int liblockdep_pthread_mutex_trylock(liblockdep_pthread_mutex_t *lock)
>> +{
>> +	lock_acquire(&lock->dep_map, 0, 1, 0, 2, NULL, (unsigned long)_RET_IP_);
>> +	return pthread_mutex_trylock(&lock->mutex) == 0 ? 1 : 0;
>> +}
>> +
>> +static inline int liblockdep_pthread_mutex_destroy(liblockdep_pthread_mutex_t *lock)
>> +{
>> +	return pthread_mutex_destroy(&lock->mutex);
>> +}
>> +
>> +#ifdef __USE_LIBLOCKDEP
>> +
>> +#define pthread_mutex_t         liblockdep_pthread_mutex_t
>> +#define pthread_mutex_init      liblockdep_pthread_mutex_init
>> +#define pthread_mutex_lock      liblockdep_pthread_mutex_lock
>> +#define pthread_mutex_unlock    liblockdep_pthread_mutex_unlock
>> +#define pthread_mutex_trylock   liblockdep_pthread_mutex_trylock
>> +#define pthread_mutex_destroy   liblockdep_pthread_mutex_destroy
> 
> Given the liblockdep_* things use 'proper' classes do you want this
> mapping? If you do, should we use the same alias nonsense glibc uses or
> are CPP macros good enough for us?
> 

I think that this will be good enough for our purpose, why wouldn't these
simple macros be enough?


Thanks,
Sasha
