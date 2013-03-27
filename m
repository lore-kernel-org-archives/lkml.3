Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755980Ab3C0IF1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 04:05:27 -0400
Received: from mail-bk0-f44.google.com ([209.85.214.44]:62699 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751289Ab3C0IFV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 04:05:21 -0400
MIME-Version: 1.0
In-Reply-To: <51527C17.3070901@intel.com>
References: <1363955155-18382-1-git-send-email-vincent.guittot@linaro.org>
	<1363955155-18382-6-git-send-email-vincent.guittot@linaro.org>
	<1364302359.5053.21.camel@laptop>
	<CAKfTPtD=_oS5gJeynUG=ft-Y1zEdxZEMhUPH9hSXx+H2pi4xgA@mail.gmail.com>
	<1364308932.5053.46.camel@laptop>
	<CAKfTPtDo3dmEZU-R62unQH9j5CxZWJj+Ws5CTBptOzTohkNJMA@mail.gmail.com>
	<51527C17.3070901@intel.com>
Date: Wed, 27 Mar 2013 09:05:18 +0100
Message-ID: <CAKfTPtDK6vSDhGa9=ReaHt_oO8Xz2agZZ4x3q5Wvv6gXjhFevg@mail.gmail.com>
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

On 27 March 2013 05:56, Alex Shi <alex.shi@intel.com> wrote:
> On 03/26/2013 11:55 PM, Vincent Guittot wrote:
>>> > So extrapolating that to a 4+4 big-little you'd get something like:
>>> >
>>> >       |   little  A9  ||   big A15     |
>>> >       | 0 | 1 | 2 | 3 || 4 | 5 | 6 | 7 |
>>> > ------+---+---+---+---++---+---+---+---+
>>> > buddy | 0 | 0 | 0 | 0 || 0 | 4 | 4 | 4 |
>>> >
>>> > Right?
>> yes
>>
>>> >
>>> > So supposing the current ILB is 6, we'll only check 4, not 0-3, even
>>> > though there might be a perfectly idle cpu in there.
>> We will check 4,5,7 at MC level in order to pack in the group of A15
>> (because they are not sharing the same power domain). If none of them
>> are idle, we will look at CPU level and will check CPUs 0-3.
>
> So you increase a fixed step here.

I have modified the find_new_ilb function to look for the best idle
CPU instead of just picking the first CPU of idle_cpus_mask.

>>
>>> >
>>> > Also, your scheme fails to pack when cpus 0,4 are filled, even when
>>> > there's idle cores around.
>> The primary target is to pack the tasks only when we are in a not busy
>> system so you will have a power improvement without performance
>> decrease. is_light_task function returns false and  is_buddy_busy
>> function true before the buddy is fully loaded and the scheduler will
>> fall back into the default behavior which spreads tasks and races to
>> idle.
>>
>> We can extend the buddy CPU and the packing mechanism to fill one CPU
>> before filling another buddy but it's not always the best choice for
>> performance and/or power and thus it will imply to have a knob to
>> select this full packing mode.
>
> Just one buddy to pack tasks for whole level cpus definitely has
> scalability problem. That is not good for powersaving in most of scenarios.
>

This patch doesn't want to pack all kind of tasks in all scenario but
only the small tasks that run less that 10ms and when the CPU is not
already too busy with other tasks so you don't have to cope with long
wake up latency and performance regression and only one CPU will be
powered up for these background activities. Nevertheless, I can extend
the packing small tasks to pack all tasks in any scenario in as few
CPUs as possible. This will imply to choose a new buddy CPU when the
previous one is full during the ILB selection as an example and to add
a knob to select this mode which will modify the performance of the
system. But the primary target is not to have a knob and not to reduce
performance in most of scenario.

Regards,
Vincent

>
> --
> Thanks Alex
