Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753934Ab3GODqU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jul 2013 23:46:20 -0400
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:35396 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753910Ab3GODqN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jul 2013 23:46:13 -0400
Message-ID: <51E36FF3.1050909@linux.vnet.ibm.com>
Date: Mon, 15 Jul 2013 09:13:47 +0530
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Morten Rasmussen <morten.rasmussen@arm.com>
CC: Arjan van de Ven <arjan@linux.intel.com>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "vincent.guittot@linaro.org" <vincent.guittot@linaro.org>,
        "alex.shi@intel.com" <alex.shi@intel.com>,
        "efault@gmx.de" <efault@gmx.de>, "pjt@google.com" <pjt@google.com>,
        "len.brown@intel.com" <len.brown@intel.com>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
Subject: Re: [RFC][PATCH 0/9] sched: Power scheduler design proposal
References: <1373385338-12983-1-git-send-email-morten.rasmussen@arm.com> <51DC414F.5050900@linux.intel.com> <51DE9859.8090405@linux.vnet.ibm.com> <20130712134811.GG20960@e103034-lin>
In-Reply-To: <20130712134811.GG20960@e103034-lin>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13071503-5490-0000-0000-000003D12BFA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Morten,

On 07/12/2013 07:18 PM, Morten Rasmussen wrote:
> On Thu, Jul 11, 2013 at 12:34:49PM +0100, Preeti U Murthy wrote:
>> Hi Morten,
>>
>> I have a few quick comments.
>>
>> I am concerned too about scheduler making its load balancing decisions
>> based on the cpu frequency for the reason that it could create an
>> imbalance in the load across cpus.
>>
>> Scheduler could keep loading a cpu, because its cpu frequency goes on
>> increasing, and it could keep un-loading a cpu because its cpu frequency
>> goes on decreasing. This increase and decrease as an effect of the load
>> itself. This is of course assuming that the driver would make its
>> decisions proportional to the cpu load. There could be many more
>> complications, if the driver makes its decisions on factors unknown to
>> the scheduler.
>>
>> Therefore my suggestion is that we should simply have the scheduler
>> asking for increase/decrease in the frequency and letting it at that.
> 
> If I understand correctly your concern is about the effect of frequency
> scaling on load-balancing when using tracked load (PJT's) for the task
> loads as it is done in Alex Shi's patches.
> 
> That problem is present even with the existing cpufreq governors and has
> not been addressed yet. Tasks on cpus at low frequencies appear bigger
> since they run longer, which will cause the load-balancer to think the
> cpu loaded and move tasks to other cpus. That will cause cpufreq to
> lower the frequency of that cpu and make any remaining tasks look even
> bigger. The story repeats itself.
> 
> One might be tempted to suggest to use arch_scale_freq_power to tell the
> load-balancer about frequency scaling. But in its current form it will
> actually make it worse, as cpu_power is currently used to indicate max
> compute capacity and not the current one.
> 
> I don't understand how a simple up/down request from the scheduler would
> solve that problem. It would just make frequency scaling slower if you
> only go up or down one step at the time. Much like the existing
> conservative cpufreq governor that nobody uses. Maybe I am missing
> something?
> 
> I think we should look into scaling the tracked load by some metric that
> represents the current performance of the cpu whenever the tracked load
> is updated as it was suggested by Arjan in our previous discussion. I
> included it in my power scheduler design proposal, but I haven't done
> anything about it yet.
> 
> In short, I agree that there is a problem around load-balancing and
> frequency scaling that needs to be fixed. Without Alex's patches the
> problem is not present as task load doesn't depend on the cpu load of the
> task.

My concern is something like this:

Scheduler sees a cpu loaded, asks the driver for an increase in its
frequency. Let us assume now that the driver agrees to increase the
frequency. Next time the scheduler checks this cpu, it has higher
capacity due to the increase in the frequency. It loads it more. Now the
load is high again, an increase in cpu frequency is asked. This cycle if
it repeats will see a few cpus heavily loaded with the maximum frequency
that it could possibly run at, while the rest are not at all. Will this
patch result in such a see-saw situation? This is something I am unable
to make out.

Currently the scheduler sees all cpus alike at a core level. So the bias
towards some cpu is based only on the load. But in this patch, the bias
in scheduling can be based on cpu frequency as well. What kind of an
impact can this have on load balancing? This is my primary concern.
Probably you will be able to see this in your testing. But just bringing
out this point.

>  
>> Secondly, I think we should spend more time on when to make a call to
>> the frequency driver in your patchset regarding the change in the
>> frequency of the CPU, the scheduler wishes to request. The reason being,
>> the whole effort of integrating the knowledge of cpu frequency
>> statistics into the scheduler is being done because the scheduler can
>> call the frequency driver at times *complimenting* load balancing,
>> unlike now.
> 
> I don't think I get your point here. The current policy in this patch
> set is just a prototype that should be improved. The power scheduler
> does complement the load-balancer already by asking for frequency
> changes as the cpu load changes.

Scenario : Lets say the scheduler at some point finds that load
balancing cannot be done for performance at some point in time. At this
time, it would be good to have the frequencies of the cpus boosted.

In the existing implementation, the cpu frequency governor gets called
after certain intervals of time, asynchronous with the load balancing.
In the above scenario the frequency governor would probably not come to
the rescue in time to ask for a boost in the frequency of the cpus. Your
patch has the potential to solve this. We are now considering calling
calculate_cpu_capacities() in the scheduler tick. Will this solve the
above mentioned scenario? Or is the above scenario hypothetical?
  I am just thinking out loud.

Regards
Preeti U Murthy

