Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752642Ab3HVDC5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 23:02:57 -0400
Received: from intranet.asianux.com ([58.214.24.6]:24288 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752226Ab3HVDC4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 23:02:56 -0400
X-Spam-Score: -101.0
Message-ID: <52157F21.5080200@asianux.com>
Date: Thu, 22 Aug 2013 11:01:53 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: dipankar@in.ibm.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kernel/rcutree.c: deem to be lazy if there are no callbacks.
References: <5212E76A.40903@asianux.com> <5212E7BB.4020602@asianux.com> <20130820041832.GY29406@linux.vnet.ibm.com> <5212F3E5.7080700@asianux.com> <5212F467.8090407@asianux.com> <52145741.7000008@asianux.com> <20130821142301.GX29406@linux.vnet.ibm.com>
In-Reply-To: <20130821142301.GX29406@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/21/2013 10:23 PM, Paul E. McKenney wrote:
> On Wed, Aug 21, 2013 at 01:59:29PM +0800, Chen Gang wrote:
>>
>> If we still doubt about it, but can not find a suitable way to fix it
>> (neither of us are familiar with it).
> 
> Well, you have that halfway correct, which some might well argue is an
> upward trend from your earlier postings.  I do appreciate your honesty
> in saying that you are not familiar with it.  That said, most people
> reading these emails will have figured that out by now.
> 

Hmm... do you mean you familiar with it, and know the correct fix ?

If so, please say directly, and let the discussion finish.


>> Is it suitable to use BUG_ON() for it (the diff may like below) ?
> 
> Hmmm...  Since my use of questions seems to have confused you, I will
> not use questions in this reply.  (The Google search string "quick quiz
> site:lwn.net" may help you avoid this confusion in the future.)
> 

It seems "quick quiz site:lwn.net" is valuable (at least, originally I
don't know about it), thanks.


> And no, the patch below is not appropriate.  Of course, even if it
> was appropriate to accept it, I would be unable to do so, as it has
> no Signed-of-by.  But I would expect that you already knew that,
> given that your first patch (which was also inappropriate) did have
> your Signed-off-by.
> 

So I say it is a diff below, not a patch below, it is only for
discussion, not for applying.

Hmm... if make it as a patch (include Signed-of-by and others), will be
good to efficiency (not need send patch again), I will do, next time.


> In addition, I cordially invite you to interpret my questions in the
> earlier emails in this thread as quick quizzes, and to contemplate how
> you have been doing with your answers.
> 

Do you know the answer ? If so need not let me reply.

The main goal of the discussion is not for learning, it is for
providing contributions (in our case, it is for fixing issues).

Normally, it will really can learn from the discussions, but it is not
our main goal (every members time resources are expensive).


But if you do not know the answer either, I should try.


> Don't get me wrong, I do welcome appropriate patches.  In fact, if
> you look at RCU's git history, you will see that I frequently accept
> patches from a fair number of people.  And if you were willing to
> invest some time and thought, you might eventually be able to generate
> an appropriate (albeit low priority) patch to this function.  However,
> you seem to be motivated to submit small patches with a minimum of
> thought and preparation, perhaps because you need to meet some external
> or self-imposed quota of accepted patches.  And if you are in fact driven
> by a quota that prevents you from taking the time required to carefully
> think things through, you are wasting your time with RCU.
> 

Hmm... at least, some contents you said above is correct to me.

At least, I should provide 10 patches per month, it is a necessary
basic requirement to me.

And what my focus is efficiency: let appliers and maintainers together
to provide contributes to outside with efficiency.

If you already know about it, why need I continue ?  but if you don't
know either, I should try.


> Good luck!
> 

Thanks.

> 							Thanx, Paul
> 
>> -------------------------------diff begin-------------------------------
>>
>> diff --git a/kernel/rcutree.c b/kernel/rcutree.c
>> index dbf74b5..1d02659 100644
>> --- a/kernel/rcutree.c
>> +++ b/kernel/rcutree.c
>> @@ -2728,6 +2728,7 @@ static int rcu_cpu_has_callbacks(int cpu, bool *all_lazy)
>>  		if (rdp->nxtlist)
>>  			hc = true;
>>  	}
>> +	BUG_ON(!hc && !al);
>>  	if (all_lazy)
>>  		*all_lazy = al;
>>  	return hc;
>>
>> -------------------------------diff end---------------------------------
>>
>> Thanks.
>>
>>
>> On 08/20/2013 12:45 PM, Chen Gang wrote:
>>> On 08/20/2013 12:43 PM, Chen Gang wrote:
>>>> On 08/20/2013 12:18 PM, Paul E. McKenney wrote:
>>>>> On Tue, Aug 20, 2013 at 11:51:23AM +0800, Chen Gang wrote:
>>>>>>
>>>>>>
>>>>>> If 'hc' is false, 'al' will never be false, either (only need check
>>>>>> "irdp->qlen != rdp->qlen_lazy' when 'rdp->nxtlist' existance).
>>>>>>
>>>>>> Recommend to improve the related code, like the diff below.
>>>>>
>>>>> Are you sure that this represents an improvement?  If so, why?
>>>>>
>>>>
>>>> If 'hc' and 'al' really has relationships, better to let 'C code'
>>>> express it, that will make the code clearer.
>>>>
>>>>> Or to put it another way, I see a patch that increases the size of the
>>>>> kernel by three lines.  What is the corresponding benefit given common
>>>>> kernel workloads?
>>>>>
>>>>
>>>> For 'al', need not check for each looping, and for 'hc', may save the
>>>> useless looping (so it can make performance better).
>>>>
>>>> For C code, it really increases 3 lines, but may not for assembly code
>>>> (excuse me, I am not check it, I think it is not important, although it
>>>> is easy to give a comparing for binary).
>>>>
>>>
>>> Oh, sorry, I mean: only for our case, "it is not important".
>>>
>>>
>>>>> 							Thanx, Paul
>>>>>
>>>>>> ----------------------------------diff begin------------------------------------
>>>>>>
>>>>>> diff --git a/kernel/rcutree.c b/kernel/rcutree.c
>>>>>> index 5b53a89..421caf0 100644
>>>>>> --- a/kernel/rcutree.c
>>>>>> +++ b/kernel/rcutree.c
>>>>>> @@ -2719,10 +2719,13 @@ static int rcd'_cpu_has_callbacks(int cpu, bool *all_lazy)
>>>>>>
>>>>>>  	for_each_rcu_flavor(rsp) {
>>>>>>  		rdp = per_cpu_ptr(rsp->rda, cpu);
>>>>>> -		if (rdp->qlen != rdp->qlen_lazy)
>>>>>> -			al = false;
>>>>>> -		if (rdp->nxtlist)
>>>>>> +		if (rdp->nxtlist) {
>>>>>>  			hc = true;
>>>>>> +			if (rdp->qlen != rdp->qlen_lazy) {
>>>>>> +				al = false;
>>>>>> +				break;
>>>>>> +			}
>>>>>> +		}
>>>>>>  	}
>>>>>>  	if (all_lazy)
>>>>>>  		*all_lazy = al;
>>>>>>
>>>>>> ----------------------------------diff end--------------------------------------
>>>>>>
>>>>>>
>>>>>> On 08/20/2013 11:50 AM, Chen Gang wrote:
>>>>>>> According to the comment above rcu_cpu_has_callbacks(): "If there are
>>>>>>> no callbacks, all of them are deemed to be lazy".
>>>>>>>
>>>>>>> So when both 'hc' and 'al' are false, '*all_lazy' should be true, not
>>>>>>> false.
>>>>>>>
>>>>>>>
>>>>>>> Signed-off-by: Chen Gang <gang.chen@asianux.com>
>>>>>>> ---
>>>>>>>  kernel/rcutree.c |    2 +-
>>>>>>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>>>>>>
>>>>>>> diff --git a/kernel/rcutree.c b/kernel/rcutree.c
>>>>>>> index 5b53a89..9ee9565 100644
>>>>>>> --- a/kernel/rcutree.c
>>>>>>> +++ b/kernel/rcutree.c
>>>>>>> @@ -2725,7 +2725,7 @@ static int rcu_cpu_has_callbacks(int cpu, bool *all_lazy)
>>>>>>>  			hc = true;
>>>>>>>  	}
>>>>>>>  	if (all_lazy)
>>>>>>> -		*all_lazy = al;
>>>>>>> +		*all_lazy = !hc ? true : al;
>>>>>>>  	return hc;
>>>>>>>  }
>>>>>>>  
>>>>>>>
>>>>>>
>>>>>>
>>>>>> -- 
>>>>>> Chen Gang
>>>>>>
>>>>>
>>>>>
>>>>>
>>>>
>>>>
>>>
>>>
>>
>>
>> -- 
>> Chen Gang
>>
> 
> 
> 


-- 
Chen Gang
