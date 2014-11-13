Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932633AbaKMKwS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 05:52:18 -0500
Received: from mga11.intel.com ([192.55.52.93]:22471 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932292AbaKMKwN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 05:52:13 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,376,1413270000"; 
   d="scan'208";a="631309272"
Message-ID: <54648CDD.1000205@linux.intel.com>
Date: Thu, 13 Nov 2014 18:50:05 +0800
From: "Li, Aubrey" <aubrey.li@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Peter Zijlstra <peterz@infradead.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "Brown, Len" <len.brown@intel.com>,
        "alan@linux.intel.com" <alan@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        "linux-pm@vger.kernel.org >> Linux PM list" 
	<linux-pm@vger.kernel.org>
Subject: Re: [PATCH v2] PM / Sleep: Timer quiesce in freeze state
References: <5446787E.60202@linux.intel.com> <20141024153656.GM12706@worktop.programming.kicks-ass.net> <544DE5CF.9040501@linux.intel.com> <20141027074419.GE10501@worktop.programming.kicks-ass.net> <544F4B31.7050308@linux.intel.com> <20141028082503.GN3337@twins.programming.kicks-ass.net> <5450253B.5020802@linux.intel.com> <20141029082432.GV3337@twins.programming.kicks-ass.net> <5451A94F.1090200@linux.intel.com> <alpine.DEB.2.11.1411121558280.3935@nanos> <20141113013707.GQ29390@twins.programming.kicks-ass.net> <54641576.3040506@linux.intel.com> <alpine.DEB.2.11.1411131017390.3935@nanos>
In-Reply-To: <alpine.DEB.2.11.1411131017390.3935@nanos>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/11/13 17:19, Thomas Gleixner wrote:
> On Thu, 13 Nov 2014, Li, Aubrey wrote:
>> On 2014/11/13 9:37, Peter Zijlstra wrote:
>>> On Wed, Nov 12, 2014 at 10:09:47PM +0100, Thomas Gleixner wrote:
>>>> On Thu, 30 Oct 2014, Li, Aubrey wrote:
>>>>
>>>>> Freeze is a general power saving state that processes are frozen, devices
>>>>> are suspended and CPUs are in idle state. However, when the system enters
>>>>> freeze state, there are a few timers keep ticking and hence consumes more
>>>>> power unnecessarily. The observed timer events in freeze state are:
>>>>> - tick_sched_timer
>>>>> - watchdog lockup detector
>>>>> - realtime scheduler period timer
>>>>>
>>>>> The system power consumption in freeze state will be reduced significantly
>>>>> if we quiesce these timers.
>>>>
>>>> So the obvious question is why dont we quiesce these timers by telling
>>>> the subsystems which manage these timers to shut them down?
>>>>
>>>> I really want a proper answer for this in the first place, but let me
>>>> look at the proposed "solution" as well.
>>>
>>> Two arguments here:
>>>
>>>  1) the current suspend modes don't care, so if this suspend mode starts
>>>  to care, its likely to 'break' in the future simply because people
>>>  never cared about timers.
>>>
>>>  2) there could be userland timers, userland is frozen but they'll still
>>>  have their timers set and those can and will fire.
>>>
>>> But sure, we can add suspend notifiers to stuff to shut down timers; I
>>> should have a patch for at least one of the offenders somewhere. But I
>>> really think that we should not be looking at the individual timers for
>>> this, none of the other suspend modes care about active timers.
>>>
>>>> But before we do that we want a proper explanation why the interrupt
>>>> fires at all. The lack of explanation cleary documents that this is a
>>>> 'hacked it into submission' approach.
>>>
>>> >From what I remember its the waking interrupt that ends up in the
>>> timekeeping code, Li should have a backtrace somwhere.
>>
>> There are two race conditions:
>>
>> The first one occurs after the interrupt is disabled and before we
>> suspend lapic. In this time slot, if apic timer interrupt occurs, the
>> interrupt is pending there because the interrupt is disabled. Then we
>> suspend timekeeping, and then we enter idle and exit idle with interrupt
>> re-enabled, the timer interrupt is handled with timekeeping is
>> suspended.
>>
>> The other occurs after timekeeping_suspended = 1 and before we suspend
>> lapic. In this time slot, if apic timer interrupt occurs, we invoke the
>> timer interrupt while timekeeping is suspended as above.
> 
> And that race exists for every implementation and is not at all apic
> timer specific. So we fix it at the core and not at some random place
> in the architecture code.
> 
You're right, will refine this in the next patch version.

Thanks,
-Aubrey
