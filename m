Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754368AbaHFDEc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 23:04:32 -0400
Received: from mga01.intel.com ([192.55.52.88]:61183 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750922AbaHFDE3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 23:04:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="368497876"
Message-ID: <53E19AAD.4070308@intel.com>
Date: Wed, 06 Aug 2014 11:02:05 +0800
From: Lan Tianyu <tianyu.lan@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
CC: lenb@kernel.org, linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Chen, Gong" <gong.chen@linux.intel.com>
Subject: Re: [PATCH] ACPI/Processor: Add CPU_STARTING_FROZEN check in the
 acpi_cpu_soft_notify()
References: <1406798426-16483-1-git-send-email-tianyu.lan@intel.com> <1560513.OlLhy0HTTU@vostro.rjw.lan> <53DB00C2.2040500@intel.com> <2440957.I2MrVyXYIg@vostro.rjw.lan>
In-Reply-To: <2440957.I2MrVyXYIg@vostro.rjw.lan>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014年08月06日 09:30, Rafael J. Wysocki wrote:
> On Friday, August 01, 2014 10:51:46 AM Lan Tianyu wrote:
>> On 2014年08月01日 05:20, Rafael J. Wysocki wrote:
>>> On Thursday, July 31, 2014 05:20:26 PM Lan Tianyu wrote:
>>>> The callback of CPU_STARTING event can't sleep and so acpi_cpu_soft_notify()
>>>> return directly when CPU_STARTING event is triggered. But cpu hotplug also
>>>> happens during S2RAM. The action will become CPU_STARTING_FROZEN. This
>>>> patch is to fix missing check the frozen event.
> 
> OK
> 
> What's the impact of the bug you're fixing?  Do we sleep when we shouldn't?
> 
> In particular, are there any bugs reported that are related to it?

So far, there is such bug report. I found the issue when test my patch
of parallel non-boot cpu up with resuming device for S2RAM. Because
original code will wait all cpu up and then do other resume task, the
semaphore of ACPICA can always be get in the cpu notify callback and it
will not fall in the sleep. It's different situation for paralleling
non-boot cpu. The lock will be held by other threads and fall into
sleep. Further thinking, this may not cause bug in the old kernel and it
isn't needed by stable tree but the code should consider cpu frozen event.

> 
>>>> Signed-off-by: Lan Tianyu <tianyu.lan@intel.com>
>>>
>>> There is work to restructure the handling of CPU_TASKS_FROZEN under way
>>> and Chen Gong is driving it.  That's likely to conflict with the last
>>> two patches from you.  Can you please coordinate with Gong?
>>
>> Hi Rafael:
>>
>> Thanks for reminder. I just checked Chen Gong's patchset "Gloabl CPU
>> Hot-plug flag _FROZEN Clean up". There is no conflict between our
>> patches. Gong's patch is to remove the following macro.
>>
>> CPU_ONLINE_FROZEN
>> CPU_UP_PREPARE_FROZEN
>> CPU_UP_CANCELED_FROZEN
>> CPU_DOWN_PREPARE_FROZEN
>> CPU_DOWN_FAILED_FROZEN
>> CPU_DEAD_FROZEN
>> CPU_DYING_FROZEN
>> CPU_STARTING_FROZEN
>>
>> CPU_TASKS_FROZEN is still available and the CPU events during S2RAM
>> are still (CPU_xxx | CPU_TASKS_FROZEN).
> 
> OK
> 
>> BTW, this is a bug fix from my opinion and it should be backported to
>> stable tree.
> 
> We'll see.
> 
> 
>>>> ---
>>>>  drivers/acpi/processor_driver.c | 2 +-
>>>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>>>
>>>> diff --git a/drivers/acpi/processor_driver.c b/drivers/acpi/processor_driver.c
>>>> index 4fcbd67..66e2249 100644
>>>> --- a/drivers/acpi/processor_driver.c
>>>> +++ b/drivers/acpi/processor_driver.c
>>>> @@ -125,7 +125,7 @@ static int acpi_cpu_soft_notify(struct notifier_block *nfb,
>>>>  	 * CPU_STARTING and CPU_DYING must not sleep. Return here since
>>>>  	 * acpi_bus_get_device() may sleep.
>>>>  	 */
>>>> -	if (action == CPU_STARTING || action == CPU_DYING)
>>>> +	if ((action & ~CPU_TASKS_FROZEN) == CPU_STARTING || action == CPU_DYING)
>>>>  		return NOTIFY_DONE;
>>>>  
>>>>  	if (!pr || acpi_bus_get_device(pr->handle, &device))
>>>>
>>>
>>
>>
>>
> 


-- 
Best regards
Tianyu Lan
