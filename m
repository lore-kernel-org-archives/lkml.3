Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755041AbaDOORZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 10:17:25 -0400
Received: from mail-we0-f182.google.com ([74.125.82.182]:59394 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752798AbaDOORO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 10:17:14 -0400
Message-ID: <534D3F80.9010902@linaro.org>
Date: Tue, 15 Apr 2014 16:17:36 +0200
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: linux-kernel@vger.kernel.org, mingo@elte.hu, rjw@rjwysocki.net,
        nicolas.pitre@linaro.org, linux-pm@vger.kernel.org,
        alex.shi@linaro.org, vincent.guittot@linaro.org,
        morten.rasmussen@arm.com
Subject: Re: [RFC PATCHC 2/3] idle: store the idle state the cpu is
References: <1396009796-31598-1-git-send-email-daniel.lezcano@linaro.org> <1396009796-31598-3-git-send-email-daniel.lezcano@linaro.org> <20140415124330.GK11182@twins.programming.kicks-ass.net> <20140415124437.GO13658@twins.programming.kicks-ass.net>
In-Reply-To: <20140415124437.GO13658@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/15/2014 02:44 PM, Peter Zijlstra wrote:
> On Tue, Apr 15, 2014 at 02:43:30PM +0200, Peter Zijlstra wrote:
>> On Fri, Mar 28, 2014 at 01:29:55PM +0100, Daniel Lezcano wrote:
>>> @@ -143,6 +145,10 @@ static int cpuidle_idle_call(void)
>>>   			if (!ret) {
>>>   				trace_cpu_idle_rcuidle(next_state, dev->cpu);
>>>
>>> +				*power = &drv->states[next_state].power;
>>> +
>>> +				wmb();
>>> +
>>
>> I very much suspect you meant: smp_wmb(), as I don't see the hardware
>> reading that pointer, therefore UP wouldn't care. Also, any and all
>> barriers should come with a comment that describes the data ordering and
>> points to the matchin barriers.
>
> Furthermore, this patch fails to describe the life-time rules of the
> object placed there. Can the objected pointed to ever disappear?

Hi Peter,

thanks for reviewing the patches.

There are a couple of situations where a cpuidle state can disappear:

1. For x86/acpi with dynamic c-states, when a laptop switches from 
battery to AC that could result on removing the deeper idle state. The 
acpi driver triggers:

'acpi_processor_cst_has_changed' which will call 
'cpuidle_pause_and_lock'. This one will call 
'cpuidle_uninstall_idle_handler' which in turn calls 'kick_all_cpus_sync'.

All cpus will exit their idle state and the pointed object will be set 
to NULL again.

2. The cpuidle driver is unloaded. Logically that could happen but not 
in practice because the drivers are always compiled in and 95% of the 
drivers are not coded to unregister the driver. Anyway ...

The unloading code must call 'cpuidle_unregister_device', that calls 
'cpuidle_pause_and_lock' leading to 'kick_all_cpus_sync'.

IIUC, the race can happen if we take the pointer and then one of these 
two situation occurs at the same moment.

As the function 'find_idlest_cpu' is inside a rcu_read_lock may be a 
rcu_barrier in 'cpuidle_pause_and_lock' or 
'cpuidle_uninstall_idle_handler' should suffice, no ?

Thanks

   -- Daniel


-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

