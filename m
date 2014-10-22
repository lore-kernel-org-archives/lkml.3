Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932841AbaJVKAe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 06:00:34 -0400
Received: from service87.mimecast.com ([91.220.42.44]:49985 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932374AbaJVKAb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 06:00:31 -0400
Message-ID: <5447803B.5080608@arm.com>
Date: Wed, 22 Oct 2014 11:00:27 +0100
From: Juri Lelli <juri.lelli@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Kirill Tkhai <ktkhai@parallels.com>
CC: Peter Zijlstra <peterz@infradead.org>, Kirill Tkhai <tkhai@yandex.ru>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Juri Lelli <juri.lelli@gmail.com>
Subject: Re: [PATCH v2 1/3] sched/dl: Implement cancel_dl_timer() to use in
 switched_from_dl()
References: <20140930210412.5258.35299.stgit@localhost>			 <20141002093408.GB2849@worktop.programming.kicks-ass.net>		 <1412244310.20287.34.camel@tkhai> <544635CA.7040200@arm.com>	 <1413888481.19914.45.camel@tkhai> <54464657.1060000@arm.com> <1413901305.19914.113.camel@tkhai>
In-Reply-To: <1413901305.19914.113.camel@tkhai>
X-OriginalArrivalTime: 22 Oct 2014 10:00:26.0876 (UTC) FILETIME=[011643C0:01CFEDDF]
X-MC-Unique: 114102211002902101
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21/10/14 15:21, Kirill Tkhai wrote:
> В Вт, 21/10/2014 в 12:41 +0100, Juri Lelli пишет:
>> On 21/10/14 11:48, Kirill Tkhai wrote:
>>> В Вт, 21/10/2014 в 11:30 +0100, Juri Lelli пишет:
>>>> Hi Kirill,
>>>>
>>>> sorry for the late reply, but I was busy doing other stuff and then
>>>> travelling.
>>>>
>>>> On 02/10/14 11:05, Kirill Tkhai wrote:
>>>>> В Чт, 02/10/2014 в 11:34 +0200, Peter Zijlstra пишет:
>>>>>> On Wed, Oct 01, 2014 at 01:04:22AM +0400, Kirill Tkhai wrote:
>>>>>>> From: Kirill Tkhai <ktkhai@parallels.com>
>>>>>>>
>>>>>>> hrtimer_try_to_cancel() may bring a suprise, its call may fail.
>>>>>>
>>>>>> Well, not really a surprise that, its a _try_ operation after all.
>>>>>>
>>>>>>> raw_spin_lock(&rq->lock)
>>>>>>> ...                            dl_task_timer                 raw_spin_lock(&rq->lock)
>>>>>>> ...                               raw_spin_lock(&rq->lock)   ...
>>>>>>>    switched_from_dl()             ...                        ...
>>>>>>>       hrtimer_try_to_cancel()     ...                        ...
>>>>>>>    switched_to_fair()             ...                        ...
>>>>>>> ...                               ...                        ...
>>>>>>> ...                               ...                        ...
>>>>>>> raw_spin_unlock(&rq->lock)        ...                        (asquired)
>>>>>>> ...                               ...                        ...
>>>>>>> ...                               ...                        ...
>>>>>>> do_exit()                         ...                        ...
>>>>>>>    schedule()                     ...                        ...
>>>>>>>       raw_spin_lock(&rq->lock)    ...                        raw_spin_unlock(&rq->lock)
>>>>>>>       ...                         ...                        ...
>>>>>>>       raw_spin_unlock(&rq->lock)  ...                        raw_spin_lock(&rq->lock)
>>>>>>>       ...                         ...                        (asquired)
>>>>>>>       put_task_struct()           ...                        ...
>>>>>>>           free_task_struct()      ...                        ...
>>>>>>>       ...                         ...                        raw_spin_unlock(&rq->lock)
>>>>>>> ...                               (asquired)                 ...
>>>>>>> ...                               ...                        ...
>>>>>>> ...                               Surprise!!!                ...
>>>>>>>
>>>>>>> So, let's implement 100% guaranteed way to cancel the timer and let's
>>>>>>> be sure we are safe even in very unlikely situations.
>>>>>>>
>>>>>>> We do not create any problem with rq unlocking, because it already
>>>>>>> may happed below in pull_dl_task(). No problem with deadline tasks
>>>>>>> balancing too.
>>>>>>
>>>>>> That doesn't sound right. pull_dl_task() is an entirely different
>>>>>> callchain than switched_from(). Now it might still be fine, but you
>>>>>> cannot compare it with pull_dl_task.
>>>>>
>>>>> I mean that caller of switched_from_dl() already knows about this situation,
>>>>> and we do not limit the area of its use.
>>>>>
>>>>
>>>> Not sure what you mean with "the caller already knows...". Also, can you
>>>> detail more about the different callchains?
>>>
>>> We have only caller of switched_from_dl(). It's check_class_changed().
>>> This function doesn't suppose that lock is always locked during its call.
>>>
>>> What other details you want?
>>>
>>
>> Ok, now is more clear, thanks. I was just wondering about what Peter
>> asked. If you can detail more about why we are still fine with it,
>> instead that just "it already was possible in pull_dl_task() below",
>> that would be nice to have.
>>
>> Also, check_class_changed() is called from several places
>> (rt_mutex_setprio() for example), are we fine with all this callplaces
>> as well?
> 
> Yeah. New code in the patch is working when hrtimer_try_to_cancel() fails.
> This means the callback is running. In this case hrtimer_cancel() is just
> waiting till the callback is finished.
> 
> Since we are in switched_from_dl(), new class is not dl_sched_class and
> new prio is not less MAX_DL_PRIO. So, the callback returns early just
> after !dl_task() check. After that hrtimer_cancel() returns back too.
> 
> The above is:
> 
> raw_spin_lock(rq->lock);                  ...
> ...                                       dl_task_timer()
> ...                                          raw_spin_lock(rq->lock);
>    switched_from_dl()                        ...
>        hrtimer_try_to_cancel()               ...
>           raw_spin_unlock(rq->lock);         ...  
>           hrtimer_cancel()                   ...
>           ...                                raw_spin_unlock(rq->lock);
>           ...                                return HRTIMER_NORESTART;
>           ...                             ...
>           raw_spin_lock(rq->lock);        ...   
> 
> 
> But the below is also possible:
>                                    dl_task_timer()
>                                       raw_spin_lock(rq->lock);
>                                       ...
>                                       raw_spin_unlock(rq->lock);
> raw_spin_lock(rq->lock);              ...
>    switched_from_dl()                 ...
>        hrtimer_try_to_cancel()        ...
>        ...                            return HRTIMER_NORESTART;
>        raw_spin_unlock(rq->lock);  ...
>        hrtimer_cancel();           ...
>        raw_spin_lock(rq->lock);    ...
> 
> In this case hrtimer_cancel() returns immediately. Very unlikely case,
> just to mention.
> 
> 
> Nobody can manipulate the task, because check_class_changed() is
> always called with pi_lock locked. Nobody can force the task to
> participate in (concurrent) priority inheritance schemes (the same reason).
> 
> All concurrent task operations require pi_lock, which is held by us.
> No deadlocks with dl_task_timer() are possible, because it returns
> right after !dl_task() check (it does nothing).
>

Ok, it looks right to me. It would be nice to have what above and the
original explanation of the bug in the changelog.

>>>>
>>>> Do you have any test for this situation? Do you experienced any crash?
>>>> As you know, the replenishment timer is of key importance for us, and
>>>> I'd like to be 100% sure we don't introduce any problems with this
>>>> change :).
>>>
>>> No, I haven't written any tests to reproduce namely this situation.
>>> I found it by code analyzing. The same way we fixed the problem
>>> with rq change in dl_task_timer():
>>>
>>>     http://www.spinics.net/lists/stable/msg49080.html
>>>
>>
>> Yeah, but I did write a test for that race:
>>
>>  "Juri Lelli reports he got this race when dl_bandwidth_enabled()
>>   was not set."
>>
>> And after that I felt more confident about the change :).
> 
> Ok, good. I forgot.
> 
>>> Are you agree the race is here? It's my fix, and if brings a problem
>>> please clarify it.
>>>
>>
>> Yeah, it seems that the race may happen. I'm just saying that it would
>> be nice to see it happening before we fix the thing. I wish I have some
>> time to try to setup a test. Even if I can't spot any problems with your
>> patch, apart from small comments below, not being completely confident
>> that this doesn't introduce regression elsewhere brought me to ask from
>> more details.
> 
> Sadly, I have no time to write a test for this bug. I can change the comment
> and add the description I posted above. Or I can add more description
> if you say what should be added else.
> 

So, if you are ok with it, I'd say I can take some time to do a little
testing anyway, as the bug is there, but nobody (except you) noticed
that yet :).

>>
>>> I'm waiting for your reply.
>>>
>>> Thanks,
>>> Kirill
>>>
>>>>> Does this sound better?
>>>>>
>>>>> [PATCH] sched/dl: Implement cancel_dl_timer() to use in switched_from_dl()
>>>>>     
>>>>> Currently used hrtimer_try_to_cancel() is racy:
>>>>>
>>>>> raw_spin_lock(&rq->lock)
>>>>> ...                            dl_task_timer                 raw_spin_lock(&rq->lock)
>>>>> ...                               raw_spin_lock(&rq->lock)   ...
>>>>>    switched_from_dl()             ...                        ...
>>>>>       hrtimer_try_to_cancel()     ...                        ...
>>>>>    switched_to_fair()             ...                        ...
>>>>> ...                               ...                        ...
>>>>> ...                               ...                        ...
>>>>> raw_spin_unlock(&rq->lock)        ...                        (asquired)
>>>>> ...                               ...                        ...
>>>>> ...                               ...                        ...
>>>>> do_exit()                         ...                        ...
>>>>>    schedule()                     ...                        ...
>>>>>       raw_spin_lock(&rq->lock)    ...                        raw_spin_unlock(&rq->lock)
>>>>>       ...                         ...                        ...
>>>>>       raw_spin_unlock(&rq->lock)  ...                        raw_spin_lock(&rq->lock)
>>>>>       ...                         ...                        (asquired)
>>>>>       put_task_struct()           ...                        ...
>>>>>           free_task_struct()      ...                        ...
>>>>>       ...                         ...                        raw_spin_unlock(&rq->lock)
>>>>> ...                               (asquired)                 ...
>>>>> ...                               ...                        ...
>>>>> ...                               (use after free)           ...
>>>>>
>>>>>     
>>>>> So, let's implement 100% guaranteed way to cancel the timer and let's
>>>>> be sure we are safe even in very unlikely situations.
>>>>>
>>>>> rq unlocking does not limit the area of switched_from_dl() use, because
>>>>> it already was possible in pull_dl_task() below.
>>>>>
>>>>> Signed-off-by: Kirill Tkhai <ktkhai@parallels.com>
>>>>>
>>>>> diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
>>>>> index abfaf3d..63f8b4a 100644
>>>>> --- a/kernel/sched/deadline.c
>>>>> +++ b/kernel/sched/deadline.c
>>>>> @@ -555,11 +555,6 @@ void init_dl_task_timer(struct sched_dl_entity *dl_se)
>>>>>  {
>>>>>  	struct hrtimer *timer = &dl_se->dl_timer;
>>>>>  
>>>>> -	if (hrtimer_active(timer)) {
>>>>> -		hrtimer_try_to_cancel(timer);
>>>>> -		return;
>>>>> -	}
>>>>> -
>>>>>  	hrtimer_init(timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
>>>>>  	timer->function = dl_task_timer;
>>>>>  }
>>>>> @@ -1567,10 +1562,34 @@ void init_sched_dl_class(void)
>>>>>  
>>>>>  #endif /* CONFIG_SMP */
>>>>>  
>>>>> +/*
>>>>> + *  Surely cancel task's dl_timer. May drop rq->lock.
>>>>> + */
>>
>> Maybe we can add comments explaining why we are fine releasing the lock
>> here.
>>

Does "Ensure p's dl_timer is cancelled. May drop rq->lock." sound better?

>>>>> +static void cancel_dl_timer(struct rq *rq, struct task_struct *p)
>>>>> +{
>>>>> +	struct hrtimer *dl_timer = &p->dl.dl_timer;
>>>>> +
>>>>> +	/* Nobody will change task's class if pi_lock is held */
>>>>> +	lockdep_assert_held(&p->pi_lock);
>>>>> +
>>>>> +	if (hrtimer_active(dl_timer)) {
>>>>> +		int ret = hrtimer_try_to_cancel(dl_timer);
>>>>> +
>>>>> +		if (unlikely(ret == -1)) {
>>>>> +			/*
>>>>> +			 * Note, p may migrate OR new deadline tasks
>>>>> +			 * may appear in rq when we are unlocking it.
>>>>> +			 */
>>
>> Yeah, some comments also here on why this is all good?
>>

Here you say what may happen. Can you add something saying why we are
fine with this happening? Just for future reference...

Thanks again!

Best,

- Juri

>> Thanks a lot Kirill!
>>
>> Best,
>>
>> - Juri
>>
>>>>> +			raw_spin_unlock(&rq->lock);
>>>>> +			hrtimer_cancel(dl_timer);
>>>>> +			raw_spin_lock(&rq->lock);
>>>>> +		}
>>>>> +	}
>>>>> +}
>>>>> +
>>>>>  static void switched_from_dl(struct rq *rq, struct task_struct *p)
>>>>>  {
>>>>> -	if (hrtimer_active(&p->dl.dl_timer) && !dl_policy(p->policy))
>>>>> -		hrtimer_try_to_cancel(&p->dl.dl_timer);
>>>>> +	cancel_dl_timer(rq, p);
>>>>>  
>>>>>  	__dl_clear_params(p);
>>>>>  
>>>>>
>>>>>
>>>>>
>>>>
>>>
>>>
>>>
>>
> 
> 
> 

