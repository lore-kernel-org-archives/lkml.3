Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752423Ab3DVFtK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 01:49:10 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:42462 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751941Ab3DVFtI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 01:49:08 -0400
Message-ID: <5174CE96.3060805@linux.vnet.ibm.com>
Date: Mon, 22 Apr 2013 11:15:58 +0530
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Vincent Guittot <vincent.guittot@linaro.org>
CC: Peter Zijlstra <peterz@infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        Ingo Molnar <mingo@kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Paul Turner <pjt@google.com>, Santosh <santosh.shilimkar@ti.com>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        Chander Kashyap <chander.kashyap@linaro.org>,
        "cmetcalf@tilera.com" <cmetcalf@tilera.com>,
        "tony.luck@intel.com" <tony.luck@intel.com>,
        Alex Shi <alex.shi@intel.com>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, Len Brown <len.brown@intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Amit Kucheria <amit.kucheria@linaro.org>,
        Jonathan Corbet <corbet@lwn.net>
Subject: Re: [RFC PATCH v3 5/6] sched: pack the idle load balance
References: <1363955155-18382-1-git-send-email-vincent.guittot@linaro.org> <1363955155-18382-6-git-send-email-vincent.guittot@linaro.org> <1364302359.5053.21.camel@laptop> <CAKfTPtD=_oS5gJeynUG=ft-Y1zEdxZEMhUPH9hSXx+H2pi4xgA@mail.gmail.com> <1364308932.5053.46.camel@laptop> <CAKfTPtArtgkH5MU_xFAKjLDS-i32g2qQMdvyW=LLkG84tH8Hhg@mail.gmail.com>
In-Reply-To: <CAKfTPtArtgkH5MU_xFAKjLDS-i32g2qQMdvyW=LLkG84tH8Hhg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13042205-3568-0000-0000-000003784B64
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vincent,

On 04/05/2013 04:38 PM, Vincent Guittot wrote:
> Peter,
> 
> After some toughts about your comments,I can update the buddy cpu
> during ILB or periofdic LB to a new idle core and extend the packing
> mechanism  Does this additional mechanism sound better for you ?

If the primary goal of this patchset is to pack small tasks in fewer
power domains then why not see if the power aware scheduler patchset by
Alex does the same for you? The reason being:

a.The power aware scheduler also checks if a task is small enough to be
packed on a cpu which has just enough capacity to take on that
task(leader cpu). This cpu belongs to a scheduler group which is nearly
full(group_leader),so we end up packing tasks.

b.The overhead of assigning a buddy cpu gets eliminated because the best
cpu for packing is decided during wake up.

c.This is a scalable solution because if the leader cpu is busy,then any
other idle cpu from that group_leader is chosen.Eventually you end up
packing anyway.

The reason that I am suggesting this is that we could unify the power
awareness of the scheduler under one umbrella.And i believe that the
current power aware scheduler patchset is flexible enough to do this and
that we must cash in on it.

Thanks

Regards
Preeti U Murthy
> 
> Vincent
> 
> On 26 March 2013 15:42, Peter Zijlstra <peterz@infradead.org> wrote:
>> On Tue, 2013-03-26 at 15:03 +0100, Vincent Guittot wrote:
>>>> But ha! here's your NO_HZ link.. but does the above DTRT and ensure
>>>> that the ILB is a little core when possible?
>>>
>>> The loop looks for an idle CPU as close as possible to the buddy CPU
>>> and the buddy CPU is the 1st CPU has been chosen. So if your buddy is
>>> a little and there is an idle little, the ILB will be this idle
>>> little.
>>
>> Earlier you wrote:
>>
>>>       | Cluster 0   | Cluster 1   |
>>>       | CPU0 | CPU1 | CPU2 | CPU3 |
>>> -----------------------------------
>>> buddy | CPU0 | CPU0 | CPU0 | CPU2 |
>>
>> So extrapolating that to a 4+4 big-little you'd get something like:
>>
>>       |   little  A9  ||   big A15     |
>>       | 0 | 1 | 2 | 3 || 4 | 5 | 6 | 7 |
>> ------+---+---+---+---++---+---+---+---+
>> buddy | 0 | 0 | 0 | 0 || 0 | 4 | 4 | 4 |
>>
>> Right?
>>
>> So supposing the current ILB is 6, we'll only check 4, not 0-3, even
>> though there might be a perfectly idle cpu in there.
>>
>> Also, your scheme fails to pack when cpus 0,4 are filled, even when
>> there's idle cores around.
>>
>> If we'd use the ILB as packing cpu, we would simply select a next pack
>> target once the old one fills up.
>>
> 

