Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751913AbaBBQDz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Feb 2014 11:03:55 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:41899 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751801AbaBBQDx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Feb 2014 11:03:53 -0500
Message-ID: <52EE6B91.3080205@linux.vnet.ibm.com>
Date: Sun, 02 Feb 2014 21:30:17 +0530
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>,
        Viresh Kumar <viresh.kumar@linaro.org>
CC: Preeti Murthy <preeti.lkml@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Lei Wen <adrian.wenl@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
Subject: Re: Is it ok for deferrable timer wakeup the idle cpu?
References: <CALZhoSQZQcM0yKTw1=ZkYz3Z_3X2QxLk0vCw6gKXW55HSrVEdw@mail.gmail.com> <alpine.DEB.2.02.1401221459590.4260@ionos.tec.linutronix.de> <CALZhoSSSOZKwDok2ZHumeZAs0R88SC6bU2BaL54U3TU6jgoaZA@mail.gmail.com> <CAKohpomMZ0TAN2e6N76_g4ZRzxd5vZ1XfuZfxrP7GMxfTNiLVw@mail.gmail.com> <CAM4v1pPnHuSKX9UAjnqzappThKS0a6_6-PEqpiiCPpjQ_3anQQ@mail.gmail.com> <20140131163034.GB21061@localhost.localdomain>
In-Reply-To: <20140131163034.GB21061@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14020216-0928-0000-0000-000005EC86D5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Frederic,

On 01/31/2014 10:00 PM, Frederic Weisbecker wrote:
> On Wed, Jan 29, 2014 at 10:57:59AM +0530, Preeti Murthy wrote:
>> Hi,
>>
>> On Thu, Jan 23, 2014 at 11:22 AM, Viresh Kumar <viresh.kumar@linaro.org> wrote:
>>
>>> Hi Guys,
>>>
>>> So the first question is why cpufreq needs it and is it really stupid?
>>> Yes, it is stupid but that's how its implemented since a long time. It does
>>> so to get data about the load on CPUs, so that freq can be scaled up/down.
>>>
>>> Though there is a solution in discussion currently, which will take
>>> inputs from scheduler and so these background timers would go away.
>>> But we need to wait until that time.
>>>
>>> Now, why do we need that for every cpu, while that for a single cpu might
>>> be enough? The answer is cpuidle here: What if the cpu responsible for
>>> running timer goes to sleep? Who will evaluate the load then? And if we
>>> make this timer run on one cpu in non-deferrable mode then that cpu
>>> would be waken up again and again from idle. So, it was decided to have
>>> a per-cpu deferrable timer. Though to improve efficiency, once it is fired
>>> on any cpu, timer for all other CPUs are rescheduled, so that they don't
>>> fire before 5ms (sampling time)..
>>
>> How about simplifying this design by doing the below?
>>
>> 1. Since anyway cpufreq governors monitor load on the cpu once every
>> 5ms, *tie it with tick_sched_timer*, which also gets deferred when the cpu
>> enters nohz_idle.
>>
>> 2. To overcome the problem of running this job of monitoring the load
>> on every cpu, have the *time keeping* cpu do it for you.
>>
>> The time keeping cpu has the property that if it has to go to idle, it will do
>> so and let the next cpu that runs the periodic timer become the time keeper.
>> Hence no cpu is prevented from entering nohz_idle and the cpu that is busy
>> and first executes periodic timer will take over as the time keeper.
>>
>> The result would be:
>>
>> 1. One cpu at any point in time will be monitoring cpu load, at every sched tick
>> as long as its busy. If it goes to sleep, then it gives up this duty
>> and enters idle.
>> The next cpu that runs the periodic timer becomes the cpu to monitor the load
>> and will continue to do so as long as its busy. Hence we do not miss monitoring
>> the cpu load.
> 
> Well that's basically what an unbound deferrable timer does. It's deferrable so
> it's doesn't prevent from entering dynticks idle mode and it's not affine to any
> particular CPU so it's going to be tied to a buzy CPU according to the scheduler
> (see get_nohz_timer_target()).
> 
>>
>> 2. This will avoid an additional timer for cpufreq.
> 
> That doesn't look like a problem.
> 
>>
>> 3. It avoids sending IPIs each time this timer gets modified since there is just
>> one CPU doing the monitoring.
> 
> If we fix the initial issue properly, we shouldn't need to send an IPI anymore.

That's right. I am sorry I missed that we were completely avoiding IPIs
in case of deferrable timers.
> 
>>
>> 4. The downside to this could be that we are stretching the functions of the
>>  periodic timer into the power management domain which does not seem like
>> the right thing to do.
> 
> Indeed, that's what I'm worried about. The tick has grown into a Big Kernel Timer
> where any subsystem can hook into for any kind of periodic event. This is why it
> was not easy to implement full dynticks, and it's not even complete yet due
> to the complicated dependencies involved.

I see your point. Yes point 4 is a bad idea.

> 
>>
>> Having said the above, the fix that Viresh has proposed along with the nohz_full
>> condition that Frederick added looks to solve this problem.
> 
> In any case I believe we want Viresh patch since there are other users
> of deferrable timers that can profit from this.
> 
> So I'm queueing it.

Yeah it solves the problem reported.

But on a different note, I was wondering if we could avoid running this
timer on every CPU by having a model similar to the time-keeping CPU.
Like the cpu-frequency tracking CPU which moves dynamically and serves
its purpose at all points in time as long as there are busy CPUs. This
will help avoid IPIs to busy CPUs indicating that they modify their
timers to delay their respective updates of frequency, each time one of
the CPUs does it on their behalf.

Viresh?

But your below point is very true, we will need to see if cpu frequency
can use statistics about cpu load from the scheduler and avoid having to
re-calculate it. Let me take a look at this.
> 
>>
>> But just a thought on if there is scope to improve this part of the
>> cpufreq code.
>> What do you all think?
> 
> I fear I don't know the problem well enough to display any serious advice.
> It depends what kind of measurement is needed. For example, isn't there some
> loads statistics that are already available from the scheduler that you could reuse?
> 
> The scheduler alone takes gazillions of different loads and power statistics taken
> in interesting path such as the tick or sched switches. Aren't there some read-only metrics
> that could be interesting?
> 
Thanks

Regards
Preeti U Murthy

