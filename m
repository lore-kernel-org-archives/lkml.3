Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758208AbaCTPBx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 11:01:53 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:52585 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757146AbaCTPBv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 11:01:51 -0400
Message-ID: <532B02DC.5000306@gmail.com>
Date: Thu, 20 Mar 2014 08:01:48 -0700
From: Dirk Brandewie <dirk.brandewie@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
CC: dirk.brandewie@gmail.com, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, patrick.marlier@gmail.com,
        viresh.kumar@linaro.org, srivatsa.bhat@linux.vnet.ibm.com,
        Dirk Brandewie <dirk.j.brandewie@intel.com>
Subject: Re: [PATCH 1/2] cpufreq: Add stop callback to cpufreq_driver interface
References: <1395243954-28262-1-git-send-email-dirk.j.brandewie@intel.com> <1395243954-28262-2-git-send-email-dirk.j.brandewie@intel.com> <3686462.d0rjfgiuqO@vostro.rjw.lan> <2400024.pvKZSBQzVt@vostro.rjw.lan>
In-Reply-To: <2400024.pvKZSBQzVt@vostro.rjw.lan>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/19/2014 08:28 PM, Rafael J. Wysocki wrote:
> On Wednesday, March 19, 2014 11:31:31 PM Rafael J. Wysocki wrote:
>> On Wednesday, March 19, 2014 08:45:53 AM dirk.brandewie@gmail.com wrote:
>>> From: Dirk Brandewie <dirk.j.brandewie@intel.com>
>>>
>>> This callback allows the driver to do clean up before the CPU is
>>> completely down and its state cannot be modified.  This is used
>>> by the intel_pstate driver to reduce the requested P state prior to
>>> the core going away.  This is required because the requested P state
>>> of the offline core is used to select the package P state. This
>>> effectively sets the floor package P state to the requested P state on
>>> the offline core.
>>>
>>> Signed-off-by: Dirk Brandewie <dirk.j.brandewie@intel.com>
>
> To speed up things a bit I changed the name of the new callback to ->stop_cpu
> and made it void.
>
> I also modified patch [2/2] accordingly and queued the both of them up for 3.15.
>
> Please check the bleeding-edge branch.
>
> I wouldn't like to need to do anything like that any more in the future, though.

Sorry had appointments yesterday afternoon.

bleeding-edge looks good


>
>>> ---
>>>   Documentation/cpu-freq/cpu-drivers.txt | 8 +++++++-
>>>   drivers/cpufreq/cpufreq.c              | 3 ++-
>>>   include/linux/cpufreq.h                | 1 +
>>>   3 files changed, 10 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/Documentation/cpu-freq/cpu-drivers.txt b/Documentation/cpu-freq/cpu-drivers.txt
>>> index 8b1a445..79def80 100644
>>> --- a/Documentation/cpu-freq/cpu-drivers.txt
>>> +++ b/Documentation/cpu-freq/cpu-drivers.txt
>>> @@ -61,7 +61,13 @@ target_index		-	See below on the differences.
>>>
>>>   And optionally
>>>
>>> -cpufreq_driver.exit -		A pointer to a per-CPU cleanup function.
>>> +cpufreq_driver.exit -		A pointer to a per-CPU cleanup
>>> +		    		function called during CPU_POST_DEAD
>>> +		    		phase of cpu hotplug process.
>>> +
>>> +cpufreq_driver.stop -		A pointer to a per-CPU stop function
>>> +			    	called during CPU_DOWN_PREPARE phase of
>>> +				cpu hotplug process.
>>>
>>>   cpufreq_driver.resume -		A pointer to a per-CPU resume function
>>>   				which is called with interrupts disabled
>>> diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
>>> index cf485d9..bb20292 100644
>>> --- a/drivers/cpufreq/cpufreq.c
>>> +++ b/drivers/cpufreq/cpufreq.c
>>> @@ -1336,7 +1336,8 @@ static int __cpufreq_remove_dev_prepare(struct device *dev,
>>>   						__func__, new_cpu, cpu);
>>>   			}
>>>   		}
>>> -	}
>>> +	} else if (cpufreq_driver->stop && cpufreq_driver->setpolicy)
>>> +		cpufreq_driver->stop(policy);
>>
>> Nit: Why is it an int function if the only caller doesn't check the
>> return value?  It should be void.
>>
>>>
>>>   	return 0;
>>>   }
>>> diff --git a/include/linux/cpufreq.h b/include/linux/cpufreq.h
>>> index 4d89e0e..ff8db19 100644
>>> --- a/include/linux/cpufreq.h
>>> +++ b/include/linux/cpufreq.h
>>> @@ -224,6 +224,7 @@ struct cpufreq_driver {
>>>   	int	(*bios_limit)	(int cpu, unsigned int *limit);
>>>
>>>   	int	(*exit)		(struct cpufreq_policy *policy);
>>> +	int	(*stop)		(struct cpufreq_policy *policy);
>>>   	int	(*suspend)	(struct cpufreq_policy *policy);
>>>   	int	(*resume)	(struct cpufreq_policy *policy);
>>>   	struct freq_attr	**attr;
>>>
>>
>>
>

