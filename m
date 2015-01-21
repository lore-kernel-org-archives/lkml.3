Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753942AbbAUDOV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 22:14:21 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:32738 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751533AbbAUDOU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 22:14:20 -0500
Message-ID: <54BF1957.6080606@huawei.com>
Date: Wed, 21 Jan 2015 11:13:27 +0800
From: Zhang Zhen <zhenzhang.zhang@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
To: Don Zickus <dzickus@redhat.com>
CC: <paulmck@linux.vnet.ibm.com>, <linux-kernel@vger.kernel.org>,
        <morgan.wang@huawei.com>, <josh@freedesktop.org>,
        <dipankar@in.ibm.com>
Subject: Re: RCU CPU stall console spews  leads to soft lockup disabled is
 reasonable ?
References: <54BCBB33.6060608@huawei.com> <20150119084200.GE9719@linux.vnet.ibm.com> <54BCC89D.9040702@huawei.com> <20150119140612.GI116159@redhat.com> <54BDC6DF.6000602@huawei.com> <20150120152531.GR116159@redhat.com> <54BF0E53.5040409@huawei.com>
In-Reply-To: <54BF0E53.5040409@huawei.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.111.68.57]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2015/1/21 10:26, Zhang Zhen wrote:
> On 2015/1/20 23:25, Don Zickus wrote:
>> On Tue, Jan 20, 2015 at 11:09:19AM +0800, Zhang Zhen wrote:
>>>
>>>> Of course back then, touch_nmi_watchdog touched all cpus.  So a problem
>>>> like this was masked.  I believe this upstream commit 62572e29bc53, solved
>>>> the problem.
>>>
>>> Thanks for your suggestion.
>>>
>>> Commit 62572e29bc53 changed the semantics of touch_nmi_watchdog and make it
>>> only touch local cpu not every one.
>>> But watchdog_nmi_touch = true only guarantee no hard lockup check on this cpu.
>>>
>>> Commit 62572e29bc53 didn't changed the semantics of touch_softlockup_watchdog.
>>
>> Ah, yes.  I reviewed the commit to quickly yesterday.  I thought
>> touch_softlockup_watchdog was called on every cpu and that commit changed
>> it to the local cpu.  But that was incorrect.
>>
>>>>
>>>> You can apply that commit and see if you if you get both RCU stall
>>>> messages _and_ softlockup messages.  I believe that is what you were
>>>> expecting, correct?
>>>>
>>> Correct, i expect i can get  both RCU stall messages _and_ softlockup messages.
>>> I applied that commit, and i only got RCU stall messages.
>>
>> Hmm, I believe the act of printing to the console calls touch_nmi_watchdog
>> which calls touch_softlockup_watchdog.  I think that is the problem there.
>>
> Yeah, you are right.
> 
>> This may not cause other problems but what happens if you comment out the
>> 'touch_softlockup_watchdog' from the touch_nmi_watchdog function like
>> below (based on latest upstream cb59670870)?
>>
>> The idea is that console printing for that cpu won't reset the softlockup
>> detector.  Again other bad things might happen and this patch may not be a
>> good final solution, but it can help give me a clue about what is going
>> on.
> 
> I commented out the 'touch_softlockup_watchdog' from the touch_nmi_watchdog function
> (based on latest upstream ec6f34e5b552).
> This triggered RCU stall and softlockup, but softlockup just printk only once.
> As you mentioned "other bad things" lead to softlockup just printk only once.
> What's the bad thing ?
> 
> / #
> / # echo 60 > /proc/sys/kernel/watchdog_thresh
> / # busybox insmod softlockup_test.ko &
> / # [   39.044058] INFO: rcu_preempt detected stalls on CPUs/tasks: {} (detected by 0, t=21002 jiffies, g=78, c=77, q=4)
> [   39.044058] INFO: Stall ended before state dump start
> [  102.049045] INFO: rcu_preempt detected stalls on CPUs/tasks: {} (detected by 0, t=84007 jiffies, g=78, c=77, q=4)
> [  102.049045] INFO: Stall ended before state dump start
> [  160.482123] BUG: soft lockup - CPU#0 stuck for 134s! [busybox:54]
> [  165.054075] INFO: rcu_preempt detected stalls on CPUs/tasks: {} (detected by 0, t=147012 jiffies, g=78, c=77, q=4)
> [  165.054075] INFO: Stall ended before state dump start
> [  228.059045] INFO: rcu_preempt detected stalls on CPUs/tasks: {} (detected by 0, t=210017 jiffies, g=78, c=77, q=4)
> [  228.059045] INFO: Stall ended before state dump start
> [  291.064099] INFO: rcu_preempt detected stalls on CPUs/tasks: {} (detected by 0, t=273022 jiffies, g=78, c=77, q=4)
> [  291.064099] INFO: Stall ended before state dump start
> [  354.069074] INFO: rcu_preempt detected stalls on CPUs/tasks: {} (detected by 0, t=336027 jiffies, g=78, c=77, q=4)
> [  354.069099] INFO: Stall ended before state dump start
> [  417.074045] INFO: rcu_preempt detected stalls on CPUs/tasks: {} (detected by 0, t=399032 jiffies, g=78, c=77, q=4)
> [  417.074045] INFO: Stall ended before state dump start
> [  480.079099] INFO: rcu_preempt detected stalls on CPUs/tasks: {} (detected by 0, t=462037 jiffies, g=78, c=77, q=4)
> [  480.079099] INFO: Stall ended before state dump start
> [  543.084099] INFO: rcu_preempt detected stalls on CPUs/tasks: {} (detected by 0, t=525042 jiffies, g=78, c=77, q=4)
> [  543.084099] INFO: Stall ended before state dump start
> [  606.089101] INFO: rcu_preempt detected stalls on CPUs/tasks: {} (detected by 0, t=588047 jiffies, g=78, c=77, q=4)
> [  606.089101] INFO: Stall ended before state dump start
> [  669.094099] INFO: rcu_preempt detected stalls on CPUs/tasks: {} (detected by 0, t=651052 jiffies, g=78, c=77, q=4)
> [  669.094099] INFO: Stall ended before state dump start
> [  732.099045] INFO: rcu_preempt detected stalls on CPUs/tasks: {} (detected by 0, t=714057 jiffies, g=78, c=77, q=4)
> [  732.099045] INFO: Stall ended before state dump start
> [  795.104074] INFO: rcu_preempt detected stalls on CPUs/tasks: {} (detected by 0, t=777062 jiffies, g=78, c=77, q=4)
> [  795.104098] INFO: Stall ended before state dump start
> [  858.109046] INFO: rcu_preempt detected stalls on CPUs/tasks: {} (detected by 0, t=840067 jiffies, g=78, c=77, q=4)
> [  858.109046] INFO: Stall ended before state dump start
> [  921.114100] INFO: rcu_preempt detected stalls on CPUs/tasks: {} (detected by 0, t=903072 jiffies, g=78, c=77, q=4)
> [  921.114100] INFO: Stall ended before state dump start
> [  984.119099] INFO: rcu_preempt detected stalls on CPUs/tasks: {} (detected by 0, t=966077 jiffies, g=78, c=77, q=4)
> [  984.119099] INFO: Stall ended before state dump start
> [ 1047.124075] INFO: rcu_preempt detected stalls on CPUs/tasks: {} (detected by 0, t=1029082 jiffies, g=78, c=77, q=4)
> [ 1047.124099] INFO: Stall ended before state dump start
> [ 1110.129046] INFO: rcu_preempt detected stalls on CPUs/tasks: {} (detected by 0, t=1092087 jiffies, g=78, c=77, q=4)
> [ 1110.129046] INFO: Stall ended before state dump start
> [ 1173.134045] INFO: rcu_preempt detected stalls on CPUs/tasks: {} (detected by 0, t=1155092 jiffies, g=78, c=77, q=4)
> [ 1173.134045] INFO: Stall ended before state dump start
> [ 1236.139101] INFO: rcu_preempt detected stalls on CPUs/tasks: {} (detected by 0, t=1218097 jiffies, g=78, c=77, q=4)
> [ 1236.139101] INFO: Stall ended before state dump start
> [ 1299.144059] INFO: rcu_preempt detected stalls on CPUs/tasks: {} (detected by 0, t=1281102 jiffies, g=78, c=77, q=4)
> [ 1299.144059] INFO: Stall ended before state dump start
> [ 1362.149099] INFO: rcu_preempt detected stalls on CPUs/tasks: {} (detected by 0, t=1344107 jiffies, g=78, c=77, q=4)
> [ 1362.149099] INFO: Stall ended before state dump start
> [ 1425.154059] INFO: rcu_preempt detected stalls on CPUs/tasks: {} (detected by 0, t=1407112 jiffies, g=78, c=77, q=4)
> [ 1425.154059] INFO: Stall ended before state dump start
> [ 1488.159046] INFO: rcu_preempt detected stalls on CPUs/tasks: {} (detected by 0, t=1470117 jiffies, g=78, c=77, q=4)
> [ 1488.159046] INFO: Stall ended before state dump start
> [ 1551.164045] INFO: rcu_preempt detected stalls on CPUs/tasks: {} (detected by 0, t=1533122 jiffies, g=78, c=77, q=4)
> [ 1551.164045] INFO: Stall ended before state dump start
> [ 1614.169057] INFO: rcu_preempt detected stalls on CPUs/tasks: {} (detected by 0, t=1596127 jiffies, g=78, c=77, q=4)
> [ 1614.169057] INFO: Stall ended before state dump start
> [ 1677.174060] INFO: rcu_preempt detected stalls on CPUs/tasks: {} (detected by 0, t=1659132 jiffies, g=78, c=77, q=4)
> [ 1677.174060] INFO: Stall ended before state dump start
> [ 1740.179045] INFO: rcu_preempt detected stalls on CPUs/tasks: {} (detected by 0, t=1722137 jiffies, g=78, c=77, q=4)
> [ 1740.179045] INFO: Stall ended before state dump start
> [ 1803.184075] INFO: rcu_preempt detected stalls on CPUs/tasks: {} (detected by 0, t=1785142 jiffies, g=78, c=77, q=4)
> [ 1803.184101] INFO: Stall ended before state dump start
> [ 1866.189046] INFO: rcu_preempt detected stalls on CPUs/tasks: {} (detected by 0, t=1848147 jiffies, g=78, c=77, q=4)
> [ 1866.189046] INFO: Stall ended before state dump start
> [ 1929.194045] INFO: rcu_preempt detected stalls on CPUs/tasks: {} (detected by 0, t=1911152 jiffies, g=78, c=77, q=4)
> [ 1929.194045] INFO: Stall ended before state dump start
> [ 1992.199083] INFO: rcu_preempt detected stalls on CPUs/tasks: {} (detected by 0, t=1974157 jiffies, g=78, c=77, q=4)
> [ 1992.199083] INFO: Stall ended before state dump start
> [ 2055.204098] INFO: rcu_preempt detected stalls on CPUs/tasks: {} (detected by 0, t=2037162 jiffies, g=78, c=77, q=4)
> [ 2055.204098] INFO: Stall ended before state dump start
> [ 2118.209045] INFO: rcu_preempt detected stalls on CPUs/tasks: {} (detected by 0, t=2100167 jiffies, g=78, c=77, q=4)
> [ 2118.209045] INFO: Stall ended before state dump start
> [ 2181.214098] INFO: rcu_preempt detected stalls on CPUs/tasks: {} (detected by 0, t=2163172 jiffies, g=78, c=77, q=4)
> [ 2181.214098] INFO: Stall ended before state dump start

Sorry, i made a mistake, the log above is based on v3.10.63.
I have tested the latest upstream kernel (based on ec6f34e5b552),
but my test case can't triggered RCU stall warning.

>>
>> Cheers,
>> Don
>>
>> diff --git a/kernel/watchdog.c b/kernel/watchdog.c
>> index 70bf118..833c015 100644
>> --- a/kernel/watchdog.c
>> +++ b/kernel/watchdog.c
>> @@ -209,7 +209,7 @@ void touch_nmi_watchdog(void)
>>  	 * going off.
>>  	 */
>>  	raw_cpu_write(watchdog_nmi_touch, true);
>> -	touch_softlockup_watchdog();
>> +	//touch_softlockup_watchdog();
>>  }
>>  EXPORT_SYMBOL(touch_nmi_watchdog);
>>  
>>
>> .
>>
> 


