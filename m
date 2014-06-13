Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753254AbaFMPOG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 11:14:06 -0400
Received: from mail.active-venture.com ([67.228.131.205]:60416 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752637AbaFMPOF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 11:14:05 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <539B1534.5020603@roeck-us.net>
Date: Fri, 13 Jun 2014 08:13:56 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Vincent Guittot <vincent.guittot@linaro.org>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH] sched: Fix compiler warnings
References: <1402614493-12521-1-git-send-email-linux@roeck-us.net> <CAKfTPtAhykeqorg7SSbMYkHQ-bjoHQx4tCrxy+yubPxhSHThww@mail.gmail.com>
In-Reply-To: <CAKfTPtAhykeqorg7SSbMYkHQ-bjoHQx4tCrxy+yubPxhSHThww@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/13/2014 01:05 AM, Vincent Guittot wrote:
> Hi Guenter,
>
> There are also such kind of function in ARM and powerpc architecture
>
> with the additional changes below, you can add my
> Acked-by Vincent Guittot <vincent.guittot@linaro.org>
>

I'd prefer to fix those instances with separate patches, since they
will normally be handled by different maintainers. That simplifies
acceptance.

Guenter

> Vincent
>
> diff --git a/arch/arm/kernel/topology.c b/arch/arm/kernel/topology.c
> index 1576d05..7e56b2f 100644
> --- a/arch/arm/kernel/topology.c
> +++ b/arch/arm/kernel/topology.c
> @@ -275,7 +275,7 @@ void store_cpu_topology(unsigned int cpuid)
>    cpu_topology[cpuid].socket_id, mpidr);
>   }
>
> -static inline const int cpu_corepower_flags(void)
> +static inline int cpu_corepower_flags(void)
>   {
>    return SD_SHARE_PKG_RESOURCES  | SD_SHARE_POWERDOMAIN;
>   }
> diff --git a/arch/powerpc/kernel/smp.c b/arch/powerpc/kernel/smp.c
> index 10ffffe..49d5d4e 100644
> --- a/arch/powerpc/kernel/smp.c
> +++ b/arch/powerpc/kernel/smp.c
> @@ -768,7 +768,7 @@ int setup_profiling_timer(unsigned int multiplier)
>
>   #ifdef CONFIG_SCHED_SMT
>   /* cpumask of CPUs with asymetric SMT dependancy */
> -static const int powerpc_smt_flags(void)
> +static int powerpc_smt_flags(void)
>   {
>    int flags = SD_SHARE_CPUPOWER | SD_SHARE_PKG_RESOURCES;
>
>
> On 13 June 2014 01:08, Guenter Roeck <linux@roeck-us.net> wrote:
>> Commit 143e1e28cb (sched: Rework sched_domain topology definition)
>> introduced a number of functions with a return value of 'const int'.
>> gcc doesn't know what to do with that and, if the kernel is compiled
>> with W=1, complains with the following warnings whenever sched.h
>> is included.
>>
>> include/linux/sched.h:875:25: warning:
>>          type qualifiers ignored on function return type
>> include/linux/sched.h:882:25: warning:
>>          type qualifiers ignored on function return type
>> include/linux/sched.h:889:25: warning:
>>          type qualifiers ignored on function return type
>> include/linux/sched.h:1002:21: warning:
>>          type qualifiers ignored on function return type
>>
>> Drop 'const' from the function declarations to fix the problem.
>>
>> Cc: Vincent Guittot <vincent.guittot@linaro.org>
>> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
>> ---
>>   include/linux/sched.h | 8 ++++----
>>   1 file changed, 4 insertions(+), 4 deletions(-)
>>
>> diff --git a/include/linux/sched.h b/include/linux/sched.h
>> index ea74596..65046b3 100644
>> --- a/include/linux/sched.h
>> +++ b/include/linux/sched.h
>> @@ -872,21 +872,21 @@ enum cpu_idle_type {
>>   #define SD_NUMA                        0x4000  /* cross-node balancing */
>>
>>   #ifdef CONFIG_SCHED_SMT
>> -static inline const int cpu_smt_flags(void)
>> +static inline int cpu_smt_flags(void)
>>   {
>>          return SD_SHARE_CPUPOWER | SD_SHARE_PKG_RESOURCES;
>>   }
>>   #endif
>>
>>   #ifdef CONFIG_SCHED_MC
>> -static inline const int cpu_core_flags(void)
>> +static inline int cpu_core_flags(void)
>>   {
>>          return SD_SHARE_PKG_RESOURCES;
>>   }
>>   #endif
>>
>>   #ifdef CONFIG_NUMA
>> -static inline const int cpu_numa_flags(void)
>> +static inline int cpu_numa_flags(void)
>>   {
>>          return SD_NUMA;
>>   }
>> @@ -999,7 +999,7 @@ void free_sched_domains(cpumask_var_t doms[], unsigned int ndoms);
>>   bool cpus_share_cache(int this_cpu, int that_cpu);
>>
>>   typedef const struct cpumask *(*sched_domain_mask_f)(int cpu);
>> -typedef const int (*sched_domain_flags_f)(void);
>> +typedef int (*sched_domain_flags_f)(void);
>>
>>   #define SDTL_OVERLAP   0x01
>>
>> --
>> 1.9.1
>>
>
>

