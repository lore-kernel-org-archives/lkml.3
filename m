Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754670Ab3C0KaI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 06:30:08 -0400
Received: from mail-bk0-f43.google.com ([209.85.214.43]:35236 "EHLO
	mail-bk0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754282Ab3C0KaG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 06:30:06 -0400
MIME-Version: 1.0
In-Reply-To: <5152B215.2040808@intel.com>
References: <1363955155-18382-1-git-send-email-vincent.guittot@linaro.org>
	<1363955155-18382-6-git-send-email-vincent.guittot@linaro.org>
	<1364302359.5053.21.camel@laptop>
	<CAKfTPtD=_oS5gJeynUG=ft-Y1zEdxZEMhUPH9hSXx+H2pi4xgA@mail.gmail.com>
	<1364308932.5053.46.camel@laptop>
	<CAKfTPtDo3dmEZU-R62unQH9j5CxZWJj+Ws5CTBptOzTohkNJMA@mail.gmail.com>
	<51527C17.3070901@intel.com>
	<CAKfTPtDK6vSDhGa9=ReaHt_oO8Xz2agZZ4x3q5Wvv6gXjhFevg@mail.gmail.com>
	<5152B215.2040808@intel.com>
Date: Wed, 27 Mar 2013 11:30:03 +0100
Message-ID: <CAKfTPtD0zYuskipbvukVWRh5rzqTaBiHsuMR8cBwmYieP=v=mQ@mail.gmail.com>
Subject: Re: [RFC PATCH v3 5/6] sched: pack the idle load balance
From: Vincent Guittot <vincent.guittot@linaro.org>
To: Alex Shi <alex.shi@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linaro-kernel@lists.linaro.org,
        mingo@kernel.org, linux@arm.linux.org.uk, pjt@google.com,
        santosh.shilimkar@ti.com, morten.rasmussen@arm.com,
        chander.kashyap@linaro.org, cmetcalf@tilera.com, tony.luck@intel.com,
        preeti@linux.vnet.ibm.com, paulmck@linux.vnet.ibm.com,
        tglx@linutronix.de, len.brown@intel.com, arjan@linux.intel.com,
        amit.kucheria@linaro.org, corbet@lwn.net
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27 March 2013 09:47, Alex Shi <alex.shi@intel.com> wrote:
>
>>>>>> So supposing the current ILB is 6, we'll only check 4, not 0-3, even
>>>>>> though there might be a perfectly idle cpu in there.
>>>> We will check 4,5,7 at MC level in order to pack in the group of A15
>>>> (because they are not sharing the same power domain). If none of them
>>>> are idle, we will look at CPU level and will check CPUs 0-3.
>>>
>>> So you increase a fixed step here.
>>
>> I have modified the find_new_ilb function to look for the best idle
>> CPU instead of just picking the first CPU of idle_cpus_mask.
>
> That's better.
> But using a fixed buddy is still not flexible, and involve more checking
> in this time critical balancing.
> Consider the most of SMP system, cpu is equal, so any of other cpu can
> play the role of buddy in your design. That means no buddy cpu is
> better, like my version packing.
>
>>
>>>>
>>>>>>
>>>>>> Also, your scheme fails to pack when cpus 0,4 are filled, even when
>>>>>> there's idle cores around.
>>>> The primary target is to pack the tasks only when we are in a not busy
>>>> system so you will have a power improvement without performance
>>>> decrease. is_light_task function returns false and  is_buddy_busy
>>>> function true before the buddy is fully loaded and the scheduler will
>>>> fall back into the default behavior which spreads tasks and races to
>>>> idle.
>>>>
>>>> We can extend the buddy CPU and the packing mechanism to fill one CPU
>>>> before filling another buddy but it's not always the best choice for
>>>> performance and/or power and thus it will imply to have a knob to
>>>> select this full packing mode.
>>>
>>> Just one buddy to pack tasks for whole level cpus definitely has
>>> scalability problem. That is not good for powersaving in most of scenarios.
>>>
>>
>> This patch doesn't want to pack all kind of tasks in all scenario but
>> only the small tasks that run less that 10ms and when the CPU is not
>> already too busy with other tasks so you don't have to cope with long
>> wake up latency and performance regression and only one CPU will be
>> powered up for these background activities. Nevertheless, I can extend
>> the packing small tasks to pack all tasks in any scenario in as few
>> CPUs as possible. This will imply to choose a new buddy CPU when the
>> previous one is full during the ILB selection as an example and to add
>> a knob to select this mode which will modify the performance of the
>> system. But the primary target is not to have a knob and not to reduce
>> performance in most of scenario.
>
> Arguing the performance/power balance does no much sense without
> detailed scenario. We just want to seek a flexible compromise way.
> But fixed buddy cpu is not flexible. and it may lose many possible
> powersaving fit scenarios on x86 system. Like if 2 SMT cpu can handle
> all tasks, we don't need to wake another core. or if 2 cores in one
> socket can handle tasks, we also don't need to wakeup another socket.

Using 2 SMT for all tasks implies to accept latency and to share
resources like cache and memory bandwidth so it means that you also
accept some potential performance decrease which implies that someone
must select this mode with a knob.
The primary goal of the patchset is not to select between powersaving
and performance but to stay in performance mode. We pack the small
tasks in one CPU so the performance will not decrease but the low load
scenario will consume less power. Then, I can add another step which
will be more power saving aggressive with a potential cost of
performance and i this case the buddy CPU will be updated dynamically
according to the system load

>>
>> Regards,
>> Vincent
>>
>>>
>>> --
>>> Thanks Alex
>
>
> --
> Thanks Alex
