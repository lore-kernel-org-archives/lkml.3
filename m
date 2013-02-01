Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757903Ab3BAWQm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 17:16:42 -0500
Received: from mail-wi0-f172.google.com ([209.85.212.172]:46959 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757877Ab3BAWQi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 17:16:38 -0500
Message-ID: <510C3EC5.3060709@linaro.org>
Date: Fri, 01 Feb 2013 23:16:37 +0100
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Len Brown <lenb@kernel.org>
CC: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] intel_idle: stop using driver_data for static flags
References: <1359691896-23567-1-git-send-email-lenb@kernel.org> <9a38405338d7464c852c4524465f84f8a2ac22fb.1359691799.git.len.brown@intel.com> <510B8059.5040609@linaro.org> <510C0C22.4000801@kernel.org>
In-Reply-To: <510C0C22.4000801@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/01/2013 07:40 PM, Len Brown wrote:
> On 02/01/2013 03:44 AM, Daniel Lezcano wrote:
>> On 02/01/2013 05:11 AM, Len Brown wrote:
>>> From: Len Brown <len.brown@intel.com>
>>>
>>> The commit, 4202735e8ab6ecfb0381631a0d0b58fefe0bd4e2
>>> (cpuidle: Split cpuidle_state structure and move per-cpu statistics fields)
>>> observed that the MWAIT flags for Cn on every processor to date were the
>>> same, and created get_driver_data() to supply them.
>>>
>>> Unfortunately, that assumption is false, going forward.
>>> So here we restore the MWAIT flags to the cpuidle_state table.
>>> However, instead restoring the old "driver_data" field,
>>> we put the flags into the existing "flags" field,
>>> where they probalby should have lived all along.
>>
>> Removing the driver_data is a good thing but I am not sure it is the
>> case by moving the MWAIT flags to the cpuidle_state's flags field. We
>> are mixing arch specific flags with a generic code.
>>
>> This is prone to errors because new flags could appear for the cpuidle
>> core code and could collide with the arch specific flags.
>>
>> Wouldn't make sense to add a private field in the struct cpuidle_state
>> structure to let the driver/arch specific to store whatever is needed ?
>>
>> struct cpuidle_state {
>>
>> 	...
>> 	unsigned long private;
>> 	...
>>
>> }
> 
> The top half of the flags are reserved for the driver,
> as noted by the definition of CPUIDLE_DRIVER_FLAGS_MASK
> with the generic flag definitions:
> 
> #define CPUIDLE_FLAG_TIME_VALID (0x01) /* is residency time measurable? */
> #define CPUIDLE_FLAG_COUPLED    (0x02) /* state applies to multiple cpus */
> 
> #define CPUIDLE_DRIVER_FLAGS_MASK (0xFFFF0000)
> 
> intel_idle already uses a driver-specific flag:
> 
> #define CPUIDLE_FLAG_TLB_FLUSHED        0x10000
> 
> This patch just uses 4 more bits along with that one.

Ok. In this case it would make sense to move this flag out of the
generic core code to the intel_idle.c file ? and move the [dec/en]coding
macro flags_2_MWAIT_EAX and MWAIT_EAX_2_flags (with a more appropriate
name for a generic code) to the cpuidle.h file ?

  -- Daniel



> Sure, if we run out of space, we can add an additional field.
> But I don't see an immediate need for it.
> 
> thanks,
> Len Brown
> Intel Open Source Technology Center
> 


-- 
 <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

