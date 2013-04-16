Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964926Ab3DPO0h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 10:26:37 -0400
Received: from g4t0017.houston.hp.com ([15.201.24.20]:30979 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933715Ab3DPO0f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 10:26:35 -0400
Message-ID: <516D5F97.9050203@hp.com>
Date: Tue, 16 Apr 2013 10:26:31 -0400
From: Waiman Long <Waiman.Long@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.5) Gecko/20120601 Thunderbird/10.0.5
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>, Dave Jones <davej@redhat.com>,
        Clark Williams <williams@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        x86@kernel.org, linux-arch@vger.kernel.org,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>,
        Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH v2 2/3] mutex: Queue mutex spinners with MCS lock to reduce
 cacheline contention
References: <1366036679-9702-1-git-send-email-Waiman.Long@hp.com> <1366036679-9702-3-git-send-email-Waiman.Long@hp.com> <20130416091026.GB9569@gmail.com>
In-Reply-To: <20130416091026.GB9569@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/16/2013 05:10 AM, Ingo Molnar wrote:
> * Waiman Long<Waiman.Long@hp.com>  wrote:
>
>> --- a/kernel/sched/core.c
>> +++ b/kernel/sched/core.c
>> @@ -3021,9 +3021,6 @@ static inline bool owner_running(struct mutex *lock, struct task_struct *owner)
>>    */
>>   int mutex_spin_on_owner(struct mutex *lock, struct task_struct *owner)
>>   {
>> -	if (!sched_feat(OWNER_SPIN))
>> -		return 0;
>> -
>>   	rcu_read_lock();
>>   	while (owner_running(lock, owner)) {
>>   		if (need_resched())
>> @@ -3040,6 +3037,27 @@ int mutex_spin_on_owner(struct mutex *lock, struct task_struct *owner)
>>   	 */
>>   	return lock->owner == NULL;
>>   }
>> +
>> +/*
>> + * Initial check for entering the mutex spinning loop
>> + */
>> +int mutex_can_spin_on_owner(struct mutex *lock)
>> +{
>> +	int retval = 1;
>> +
>> +	if (!sched_feat(OWNER_SPIN))
>> +		return 0;
>> +
>> +	rcu_read_lock();
>> +	if (lock->owner)
>> +		retval = lock->owner->on_cpu;
>> +	rcu_read_unlock();
>> +	/*
>> +	 * if lock->owner is not set, the mutex owner may have just acquired
>> +	 * it and not set the owner yet or the mutex has been released.
>> +	 */
>> +	return retval;
>> +}
> The SCHED_FEAT_OWNER_SPIN was really just an early hack we did to make
> with/without mutex-spinning testable.
I see.

> I'd suggest a preparatory patch that gets rid of that flag and moves these two
> functions from sched/core.c to mutex.c where they belong.
>
> This will also allow the removal of the mutex prototypes from sched.h.

Yes, I can certainly prepare a patch to remove SCHED_FEAT_OWNER_SPIN & 
move those functions back to mutex.c after my patch set goes in. As for 
the timing, do you want me to do it now or it can wait as I will start 
my vacation later this week and will be back by the end of the month.

Regards,
Longman
