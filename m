Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761239Ab3DBLSg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 07:18:36 -0400
Received: from mail-ea0-f179.google.com ([209.85.215.179]:36682 "EHLO
	mail-ea0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761236Ab3DBLSc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 07:18:32 -0400
Message-ID: <515ABE83.3070200@linaro.org>
Date: Tue, 02 Apr 2013 13:18:27 +0200
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: jonghwa3.lee@samsung.com
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, cpufreq@vger.kernel.org,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Lukasz Majewski <l.majewski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>, sw0312.kim@samsung.com,
        m.szyprowski@samsung.com
Subject: Re: [RFC PATCH 1/2] cpuidle: Add idle enter/exit time stamp for notifying
 current idle state.
References: <1364804657-16590-1-git-send-email-jonghwa3.lee@samsung.com> <1364804657-16590-2-git-send-email-jonghwa3.lee@samsung.com> <515A65DB.8070803@linaro.org> <515A77FC.70008@samsung.com> <515A8A21.6070509@linaro.org> <515AA6C3.3060408@samsung.com> <515AAE2C.3040407@linaro.org> <515ABC0C.1090102@samsung.com>
In-Reply-To: <515ABC0C.1090102@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/02/2013 01:07 PM, jonghwa3.lee@samsung.com wrote:
> On 2013년 04월 02일 19:08, Daniel Lezcano wrote:
> 
>> On 04/02/2013 11:37 AM, jonghwa3.lee@samsung.com wrote:
>>> On 2013년 04월 02일 16:34, Daniel Lezcano wrote:
>>>
>>>> On 04/02/2013 08:17 AM, jonghwa3.lee@samsung.com wrote:
>>>>> On 2013년 04월 02일 14:00, Daniel Lezcano wrote:
>>>>>
>>>>>> On 04/01/2013 10:24 AM, Jonghwa Lee wrote:
>>>>>>> This patch adds idle state time stamp to cpuidle device structure to
>>>>>>> notify its current idle state. If last enter time is newer than last
>>>>>>> exit time, then it means that the core is in idle now.
>>>>>>>
>>>>>>> Signed-off-by: Jonghwa Lee <jonghwa3.lee@samsung.com>
>>>>>>> ---
>>>>>>
>>>>>> The patch description does not explain what problem you want to solve,
>>>>>> how to solve it and the patch itself shows nothing.
>>>>>>
>>>>>> Could you elaborate ?
>>>>>
>>>>>
>>>>> I'm sorry for lacking description. I supplement more.
>>>>>
>>>>> This patch does add time-stamp for idle enter/exit only nothing more.
>>>>> The reason why I needed them is that I wanted to know current cpu idle
>>>>> state. It is hard to know whether cpu is in idle or not now.
>>>>
>>>> Did you looked at:
>>>>
>>>> include/linux/sched.h:extern int idle_cpu(int cpu);
>>>>
>>>
>>>
>>> Yes, I did.
>>>
>>>> ?
>>>>
>>>>> When I check the cpuidle state usage, sometimes the information is wrong.
>>>>> Because it is updated only when the cpu exits the idle state. So while the
>>>>> cpu is idling, the cpuidle state usage holds past one. Therefore I put
>>>>> the time-stamp for cpuidle enter/exit for checking current idling and
>>>>> calculating idle state usage correctly.
>>>>>
>>>>> I just make this patch temporary for my cpufreq governor work. So, it just
>>>>> use time-stamp for all idle state together. After RFC working, I have a plan
>>>>> to update this patch to use timestamp for each idle state.
>>>>
>>>> I suggest you look at the enter_idle / exit_idle function and make your
>>>> governor to subscribe to the IDLE_START/EXIT notifiers.
>>>>
>>>> arch/x86/kernel/process.c
>>>>
>>>> These are defined for the x86 architecture, maybe worth to add it to
>>>> another architecture.
>>>>
>>>
>>>
>>> Thanks for your opinion.
>>>
>>> Actually, I work on ARM architecture and I knew that the attempt of applying
>>> idle notifier was failed. You probably knew it, because the link you gave me
>>> before is that attempt. (https://lkml.org/lkml/2012/2/7/504) :)
>>
>> Yeah, now I recall this thread.
>>
> 
> 
> Oh my, I thought you gave the link but you didn't. It was Viresh Kumar from
> other patch of the patchset. Sorry.
> 
>>> Currently, there
>>> is only notifying call which is for led in arch/arm/kernel/process.c and I think
>>> it isn't for me to use. Anyway, Do you really think it is better way to use
>>> notifier than my way? Because I think it is too heavy for me. On my board,
>>> sometimes entering idle happened hundreds times during the 100ms. I don't want
>>> to call notifier that much time. IMO, just moving local variable to per-cpu
>>> variable for showing the enter/exit time looks better although it requires code
>>> modification on cpudile side.  What do you think?
>>
>> Sorry, but it is hard to figure out what you are trying to achieve with
>> a single patch.
>>
>> IIUC, you want to know how long the cpu is idle including the current
>> state, right ? So you need to know if the cpu is idle and when it
>> entered the idle state, correct ?
>>
> 
> 
> Exactly.
> 
>  
>> If the cpu is idle and the information is per cpu, how will you read
>> this value from another cpu without introducing a locking mechanism ?
>>
> 
> 
> I think it might be tolerated for incoherency of that data. Governor reads the
> data only, and if recoded start time or end time are different in few usec with
> real one then it doesn't effect to the result much.
> 
> 
>> Does it mean the cpufreq governor needs cpuidle ? I am wondering if
>> these informations shouldn't be retrieved from the scheduler, not from
>> cpuidle.
>>
> 
> 
> Yes, tick_sched per-cpu variable has all information that I need. But it isn't
> global variable. And I'm afraid to change static variable to global one as my
> pleases.

It is a global variable but there is a function to get access:

extern struct tick_sched *tick_get_tick_sched(int cpu);

Does it fit better for what you want to achieve ?

Thanks
  -- Daniel


-- 
 <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

