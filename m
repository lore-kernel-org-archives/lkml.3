Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753494AbaCXOS0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 10:18:26 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:65065 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753215AbaCXOSF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 10:18:05 -0400
Message-ID: <53303E99.70509@gmail.com>
Date: Mon, 24 Mar 2014 07:18:01 -0700
From: Dirk Brandewie <dirk.brandewie@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Thomas Gleixner <tglx@linutronix.de>, dirk.j.brandewie@intel.com
CC: dirk.brandewie@gmail.com, LKML <linux-kernel@vger.kernel.org>,
        Julia Lawall <Julia.Lawall@lip6.fr>,
        Andrew Morton <akpm@linux-foundation.org>,
        cpufreq <cpufreq@vger.kernel.org>, pm <linux-pm@vger.kernel.org>
Subject: Re: [patch 15/16] cpufreq: intel-pstate: Use del_timer_sync in intel_pstate_cpu_exit()
References: <20140323150557.288925975@linutronix.de> <20140323150754.272874059@linutronix.de> <2311758.L3eN8OTkba@vostro.rjw.lan>
In-Reply-To: <2311758.L3eN8OTkba@vostro.rjw.lan>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,
On 03/23/2014 06:56 PM, Rafael J. Wysocki wrote:
> On Sunday, March 23, 2014 03:09:32 PM Thomas Gleixner wrote:
>> We are about to free the data structure. Make sure no timer callback
>> is running. I might be paranoid, but the ->exit callback can be
>> invoked from so many places, that it is not entirely clear whether
>> del_timer is always called on the cpu on which it is enqueued.
>>
>> While looking through the call sites I noticed, that
>> cpufreq_init_policy() can fail and invoke cpufreq_driver->exit() but
>> it does not return the failure and the callsite happily proceeds.
>>

The call to del_timer() has been moved to a new callback in material
in Rafaels pull request for v3.15.

I will send a patch adding this change to the v3.15 material.

--Dirk
>> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
>> Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
>> Cc: cpufreq <cpufreq@vger.kernel.org>
>> Cc: pm <linux-pm@vger.kernel.org>
>
> Dirk?
>
>> ---
>>
>>   drivers/cpufreq/intel_pstate.c |    2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> Index: tip/drivers/cpufreq/intel_pstate.c
>> ===================================================================
>> --- tip.orig/drivers/cpufreq/intel_pstate.c
>> +++ tip/drivers/cpufreq/intel_pstate.c
>> @@ -777,7 +777,7 @@ static int intel_pstate_cpu_exit(struct
>>   {
>>   	int cpu = policy->cpu;
>>
>> -	del_timer(&all_cpu_data[cpu]->timer);
>> +	del_timer_sync(&all_cpu_data[cpu]->timer);
>>   	kfree(all_cpu_data[cpu]);
>>   	all_cpu_data[cpu] = NULL;
>>   	return 0;
>>
>>
>

