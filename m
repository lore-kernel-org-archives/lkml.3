Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932581Ab3BNDJD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 22:09:03 -0500
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:46056 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932405Ab3BNDI7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 22:08:59 -0500
Message-ID: <511C5503.5010103@linux.vnet.ibm.com>
Date: Thu, 14 Feb 2013 08:37:47 +0530
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Paul Turner <pjt@google.com>
CC: Alex Shi <alex.shi@intel.com>, Peter Zijlstra <peterz@infradead.org>,
        torvalds@linux-foundation.org, mingo@redhat.com, tglx@linutronix.de,
        akpm@linux-foundation.org, arjan@linux.intel.com, bp@alien8.de,
        namhyung@kernel.org, efault@gmx.de, vincent.guittot@linaro.org,
        gregkh@linuxfoundation.org, viresh.kumar@linaro.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch v4 08/18] Revert "sched: Introduce temporary FAIR_GROUP_SCHED
 dependency for load-tracking"
References: <1358996820-23036-1-git-send-email-alex.shi@intel.com> <1358996820-23036-9-git-send-email-alex.shi@intel.com> <1360664874.4485.18.camel@laptop> <511BAFDB.6050908@intel.com> <CAPM31RLi+e=2kmwxDOewe=+LHrHGiVTuo-+3WeAFEmsWmi1fnw@mail.gmail.com>
In-Reply-To: <CAPM31RLi+e=2kmwxDOewe=+LHrHGiVTuo-+3WeAFEmsWmi1fnw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13021403-8878-0000-0000-000005E4049C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everyone,

On 02/13/2013 09:15 PM, Paul Turner wrote:
> On Wed, Feb 13, 2013 at 7:23 AM, Alex Shi <alex.shi@intel.com> wrote:
>> On 02/12/2013 06:27 PM, Peter Zijlstra wrote:
>>> On Thu, 2013-01-24 at 11:06 +0800, Alex Shi wrote:
>>>> Remove CONFIG_FAIR_GROUP_SCHED that covers the runnable info, then
>>>> we can use runnable load variables.
>>>>
>>> It would be nice if we could quantify the performance hit of doing so.
>>> Haven't yet looked at later patches to see if we remove anything to
>>> off-set this.
>>>
>>
>> In our rough testing, no much clear performance changes.
>>
> 
> I'd personally like this to go with a series that actually does
> something with it.
> 
> There's been a few proposals floating around on _how_ to do this; but
> the challenge is in getting it stable enough that all of the wake-up
> balancing does not totally perforate your stability gains into the
> noise.  select_idle_sibling really is your nemesis here.
> 
> It's a small enough patch that it can go at the head of any such
> series (and indeed; it was originally structured to make such a patch
> rather explicit.)
> 
>> --
>> Thanks
>>     Alex
> 

Paul,what exactly do you mean by select_idle_sibling() is our nemesis
here? What we observed through our experiments was that:
1.With the per entity load tracking(runnable_load_avg) in load
balancing,the load is distributed appropriately across the cpus.
2.However when a task sleeps and wakes up,select_idle_sibling() searches
for the idlest group top to bottom.If a suitable candidate is not
found,it wakes up the task on the prev_cpu/waker_cpu.This would increase
the runqueue size and load of prev_cpu/waker_cpu respectively.
3.The load balancer would then come to the rescue and redistribute the load.

As a consequence,

*The primary observation was that there is no performance degradation
with the integration of per entity load tracking into the load balancer
but there was a good increase in the number of migrations*. This  as I
see it, is due to the point2 and point3 above.Is this what you call as
the nemesis? OR

select_idle_sibling() does a top to bottom search of the chosen domain
for an idlest group and is very likely to spread the waking task to a
far off group,in case of underutilized systems.This would prove costly
for the software buddies in finding each other due to the time taken for
the search and the possible spreading of the software buddy tasks.Is
this what you call nemesis?

Another approach to remove the above two nemesis,if they are so,would be
to use blocked_load+runnable_load for balancing.But when waking up a
task,use select_idle_sibling() only to search the L2 cache domains for
an idlest group.If unsuccessful,return the prev_cpu which has already
accounted for the task in the blocked_load,hence this move would not
increase its load.Would you recommend going in this direction?

Thank you

Regards
Preeti U Murthy

