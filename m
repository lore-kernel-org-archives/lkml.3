Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752640AbaAPLDU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 06:03:20 -0500
Received: from mail-we0-f182.google.com ([74.125.82.182]:46679 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752280AbaAPLDR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 06:03:17 -0500
Message-ID: <52D7BC71.9010908@linaro.org>
Date: Thu, 16 Jan 2014 12:03:13 +0100
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Alex Shi <alex.shi@linaro.org>, Peter Zijlstra <peterz@infradead.org>
CC: mingo@redhat.com, tglx@linutronix.de, vincent.guittot@linaro.org,
        morten.rasmussen@arm.com, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, fengguang.wu@intel.com,
        linaro-kernel@lists.linaro.org,
        Michael wang <wangyun@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH] sched: find the latest idle cpu
References: <1389758879-19951-1-git-send-email-alex.shi@linaro.org> <20140115073533.GU31570@twins.programming.kicks-ass.net> <52D69D44.4090504@linaro.org>
In-Reply-To: <52D69D44.4090504@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/15/2014 03:37 PM, Alex Shi wrote:
> On 01/15/2014 03:35 PM, Peter Zijlstra wrote:
>> On Wed, Jan 15, 2014 at 12:07:59PM +0800, Alex Shi wrote:
>>> Currently we just try to find least load cpu. If some cpus idled,
>>> we just pick the first cpu in cpu mask.
>>>
>>> In fact we can get the interrupted idle cpu or the latest idled cpu,
>>> then we may get the benefit from both latency and power.
>>> The selected cpu maybe not the best, since other cpu may be interrupted
>>> during our selecting. But be captious costs too much.
>>
>> No, we should not do anything like this without first integrating
>> cpuidle.
>>
>> At which point we have a sane view of the idle states and can make a
>> sane choice between them.
>>
>
>
> Daniel,
>
> Any comments to make it better?

Hi Alex,

it is a nice optimization attempt but I agree with Peter we should focus 
on integrating cpuidle.

The question is "how do we integrate cpuidle ?"

IMHO, the main problem are the governors, especially the menu governor.

The menu governor tries to predict the events per cpu. This approach 
which gave us a nice benefit for the power saving may not fit well for 
the scheduler.

I think we can classify the events in three categories:

1. fully predictable (timers)
2. partially predictable (eg. MMC, sdd or network)
3. unpredictable (eg. keyboard, network ingress after quiescent period)

The menu governor mix 2 and 3 with statistics and a performance 
multiplier to reach shallow states based on heuristic and 
experimentation for a specific platform.

I was wondering if we shouldn't create a per task io latency tracking.

Mostly based on io_schedule and io_schedule_timeout, we track the 
latency for each task for each device, keeping up to date a rb-tree 
where the left-most leaf is the minimum latency for all the tasks 
running on a specific cpu. That allows better tracking when moving tasks 
across cpus.

With this approach, we have something consistent with the per load task 
tracking.

This io latency tracking gives us the next wake up event we can inject 
to the cpuidle framework directly. That removes all the code related to 
the menu governor statistics based on IO events and simplify a lot the 
menu governor code. So we replaced a piece of the cpuidle code by a 
scheduler code which I hope could be better for prediction, leading to a 
part of integration.

In order to finish integrating the cpuidle framework in the scheduler, 
there are pending questions about the impact in the current design.

Peter or Ingo, if you have time, could you have a look at the email I 
sent previously [1] ?

Thanks

   -- Daniel


[1] https://lkml.org/lkml/2013/12/17/106

-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

