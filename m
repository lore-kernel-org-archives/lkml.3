Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757357AbaFYO2B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 10:28:01 -0400
Received: from mail.active-venture.com ([67.228.131.205]:59961 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756454AbaFYO2A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 10:28:00 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <53AADC63.8080106@roeck-us.net>
Date: Wed, 25 Jun 2014 07:27:47 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
CC: Ingo Molnar <mingo@redhat.com>, Russell King <linux@arm.linux.org.uk>,
        Peter Zijlstra <peterz@infradead.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        linuxppc-dev@lists.ozlabs.org,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2] sched: Fix compiler warnings
References: <1403658329-13196-1-git-send-email-linux@roeck-us.net> <20140625071416.GM14781@pengutronix.de>
In-Reply-To: <20140625071416.GM14781@pengutronix.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/25/2014 12:14 AM, Uwe Kleine-König wrote:
> On Tue, Jun 24, 2014 at 06:05:29PM -0700, Guenter Roeck wrote:
>> Commit 143e1e28cb (sched: Rework sched_domain topology definition)
>> introduced a number of functions with a return value of 'const int'.
>> gcc doesn't know what to do with that and, if the kernel is compiled
>> with W=1, complains with the following warnings whenever sched.h
>> is included.
>>
>> include/linux/sched.h:875:25: warning:
>> 	type qualifiers ignored on function return type
>> include/linux/sched.h:882:25: warning:
>> 	type qualifiers ignored on function return type
>> include/linux/sched.h:889:25: warning:
>> 	type qualifiers ignored on function return type
>> include/linux/sched.h:1002:21: warning:
>> 	type qualifiers ignored on function return type
>>
>> Commits fb2aa855 (sched, ARM: Create a dedicated scheduler topology table)
>> and 607b45e9a (sched, powerpc: Create a dedicated topology table) introduce
>> the same warning in the arm and powerpc code.
>>
>> Drop 'const' from the function declarations to fix the problem.
>>
>> The fix for all three patches has to be applied together to avoid
>> compilation failures for the affected architectures.
>>
>> Cc: Dietmar Eggemann <dietmar.eggemann@arm.com>
>> Cc: Peter Zijlstra <peterz@infradead.org>
>> Cc: Ingo Molnar <mingo@kernel.org>
>> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
>> Cc: Vincent Guittot <vincent.guittot@linaro.org>
>> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
>> ---
>> v2: Fix problem in all affected architectures with a single patch
>>      to avoid compilation errors.
>>
>>   arch/arm/kernel/topology.c | 2 +-
>>   arch/powerpc/kernel/smp.c  | 2 +-
>>   include/linux/sched.h      | 8 ++++----
>>   3 files changed, 6 insertions(+), 6 deletions(-)
>>
>> diff --git a/arch/arm/kernel/topology.c b/arch/arm/kernel/topology.c
>> index 9d85318..e35d880 100644
>> --- a/arch/arm/kernel/topology.c
>> +++ b/arch/arm/kernel/topology.c
>> @@ -275,7 +275,7 @@ void store_cpu_topology(unsigned int cpuid)
>>   		cpu_topology[cpuid].socket_id, mpidr);
>>   }
>>
>> -static inline const int cpu_corepower_flags(void)
>> +static inline int cpu_corepower_flags(void)
>>   {
>>   	return SD_SHARE_PKG_RESOURCES  | SD_SHARE_POWERDOMAIN;
>>   }
> Maybe the author's intention was:
>
> 	static inline int cpu_corepower_flags(void) __attribute__((const));
>
> ?
> This specifies that the function has no side effects and the return value
> only depends on the (here non-existing) function arguments.
>

Possibly, but either I am missing something or this doesn't compile.

Guenter


