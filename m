Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752112Ab3HTEoT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 00:44:19 -0400
Received: from intranet.asianux.com ([58.214.24.6]:3472 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751875Ab3HTEoS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 00:44:18 -0400
X-Spam-Score: -101.1
Message-ID: <5212F3E5.7080700@asianux.com>
Date: Tue, 20 Aug 2013 12:43:17 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: dipankar@in.ibm.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kernel/rcutree.c: deem to be lazy if there are no callbacks.
References: <5212E76A.40903@asianux.com> <5212E7BB.4020602@asianux.com> <20130820041832.GY29406@linux.vnet.ibm.com>
In-Reply-To: <20130820041832.GY29406@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/20/2013 12:18 PM, Paul E. McKenney wrote:
> On Tue, Aug 20, 2013 at 11:51:23AM +0800, Chen Gang wrote:
>>
>>
>> If 'hc' is false, 'al' will never be false, either (only need check
>> "irdp->qlen != rdp->qlen_lazy' when 'rdp->nxtlist' existance).
>>
>> Recommend to improve the related code, like the diff below.
> 
> Are you sure that this represents an improvement?  If so, why?
> 

If 'hc' and 'al' really has relationships, better to let 'C code'
express it, that will make the code clearer.

> Or to put it another way, I see a patch that increases the size of the
> kernel by three lines.  What is the corresponding benefit given common
> kernel workloads?
> 

For 'al', need not check for each looping, and for 'hc', may save the
useless looping (so it can make performance better).

For C code, it really increases 3 lines, but may not for assembly code
(excuse me, I am not check it, I think it is not important, although it
is easy to give a comparing for binary).

> 							Thanx, Paul
> 
>> ----------------------------------diff begin------------------------------------
>>
>> diff --git a/kernel/rcutree.c b/kernel/rcutree.c
>> index 5b53a89..421caf0 100644
>> --- a/kernel/rcutree.c
>> +++ b/kernel/rcutree.c
>> @@ -2719,10 +2719,13 @@ static int rcd'_cpu_has_callbacks(int cpu, bool *all_lazy)
>>
>>  	for_each_rcu_flavor(rsp) {
>>  		rdp = per_cpu_ptr(rsp->rda, cpu);
>> -		if (rdp->qlen != rdp->qlen_lazy)
>> -			al = false;
>> -		if (rdp->nxtlist)
>> +		if (rdp->nxtlist) {
>>  			hc = true;
>> +			if (rdp->qlen != rdp->qlen_lazy) {
>> +				al = false;
>> +				break;
>> +			}
>> +		}
>>  	}
>>  	if (all_lazy)
>>  		*all_lazy = al;
>>
>> ----------------------------------diff end--------------------------------------
>>
>>
>> On 08/20/2013 11:50 AM, Chen Gang wrote:
>>> According to the comment above rcu_cpu_has_callbacks(): "If there are
>>> no callbacks, all of them are deemed to be lazy".
>>>
>>> So when both 'hc' and 'al' are false, '*all_lazy' should be true, not
>>> false.
>>>
>>>
>>> Signed-off-by: Chen Gang <gang.chen@asianux.com>
>>> ---
>>>  kernel/rcutree.c |    2 +-
>>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>>
>>> diff --git a/kernel/rcutree.c b/kernel/rcutree.c
>>> index 5b53a89..9ee9565 100644
>>> --- a/kernel/rcutree.c
>>> +++ b/kernel/rcutree.c
>>> @@ -2725,7 +2725,7 @@ static int rcu_cpu_has_callbacks(int cpu, bool *all_lazy)
>>>  			hc = true;
>>>  	}
>>>  	if (all_lazy)
>>> -		*all_lazy = al;
>>> +		*all_lazy = !hc ? true : al;
>>>  	return hc;
>>>  }
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
