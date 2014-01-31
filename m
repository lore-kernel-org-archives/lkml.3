Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754438AbaAaPuc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 10:50:32 -0500
Received: from mga11.intel.com ([192.55.52.93]:41049 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754173AbaAaPua (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 10:50:30 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,758,1384329600"; 
   d="scan'208";a="467851553"
Message-ID: <52EBC645.2040607@linux.intel.com>
Date: Fri, 31 Jan 2014 07:50:29 -0800
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Daniel Lezcano <daniel.lezcano@linaro.org>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>, Len Brown <len.brown@intel.com>
CC: Preeti Murthy <preeti.lkml@gmail.com>, nicolas.pitre@linaro.org,
        mingo@redhat.com, Thomas Gleixner <tglx@linutronix.de>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>
Subject: Re: [RFC PATCH 3/3] idle: store the idle state index in the struct
 rq
References: <1391090962-15032-1-git-send-email-daniel.lezcano@linaro.org> <1391090962-15032-4-git-send-email-daniel.lezcano@linaro.org> <20140130153150.GD5002@laptop.programming.kicks-ass.net> <52EA7D8A.6080604@linaro.org> <20140130163501.GG5002@laptop.programming.kicks-ass.net> <52EA8B07.6020206@linaro.org> <CAM4v1pPwmRUOtNeGh5sZmj+wAsC8RstofNA5Gx862SEECvW-Lg@mail.gmail.com> <20140131090230.GM5002@laptop.programming.kicks-ass.net> <52EB6F65.8050008@linux.vnet.ibm.com> <52EBBC23.8020603@linux.intel.com> <52EBC33A.6080101@linaro.org>
In-Reply-To: <52EBC33A.6080101@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/31/2014 7:37 AM, Daniel Lezcano wrote:
> On 01/31/2014 04:07 PM, Arjan van de Ven wrote:
>>>>>
>>>>> Hence I think this patch would make sense only with additional
>>>>> information
>>>>> like exit_latency or target_residency is present for the scheduler.
>>>>> The idle
>>>>> state index alone will not be sufficient.
>>>>
>>>> Alternatively, can we enforce sanity on the cpuidle infrastructure to
>>>> make the index naturally ordered? If not, please explain why :-)
>>>
>>> The commit id 71abbbf856a0e70 says that there are SOCs which could have
>>> their target_residency and exit_latency values change at runtime. This
>>> commit thus removed the ordering of the idle states according to their
>>> target_residency/exit_latency. Adding Len and Arjan to the CC.
>>
>> the ARM folks wanted a dynamic exit latency, so.... it makes much more
>> sense
>> to me to store the thing you want to use (exit latency) than the number
>> of the state.
>>
>> more than that, you can order either by target residency OR by exit
>> latency,
>> if you sort by one, there is no guarantee that you're also sorted by the
>> other
>
> IMO, it would be preferable to store the index for the moment as we are integrating cpuidle with the scheduler. The index allows to access more informations. Then when
> everything is fully integrated we can improve the result, no ?

more information, yes. but if the information isn't actually accurate (because it keeps changing
in the datastructure away from what it was for the cpu)... are you really achieving what you want?

on x86 I don't care; we don't actually change these dynamically much[1]. But if you have 1 or 2 things in mind to use,
I would suggest copying those 2 integers instead as we go, rather than the index.
Saves refcounting/locking etc etc nightmare as well on the other subsystems' datastructures..
... which you likely need to do to actually follow that index.



[1] Although in an ACPI world, the total number of C states can vary, for example it used to be quite common
that you got an extra C state on battery versus on wall power. This sort of dynamic thing requires refcounting
if more than the local cpuidle uses the data structures.

