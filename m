Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755226AbaCNCSn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 22:18:43 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:36996 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754547AbaCNCSm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 22:18:42 -0400
Message-ID: <5322661A.9090004@linux.vnet.ibm.com>
Date: Fri, 14 Mar 2014 07:44:50 +0530
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Vincent Guittot <vincent.guittot@linaro.org>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "tony.luck@intel.com" <tony.luck@intel.com>,
        "fenghua.yu@intel.com" <fenghua.yu@intel.com>,
        "schwidefsky@de.ibm.com" <schwidefsky@de.ibm.com>,
        "james.hogan@imgtec.com" <james.hogan@imgtec.com>,
        "cmetcalf@tilera.com" <cmetcalf@tilera.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>
Subject: Re: [RFC 4/6] sched: powerpc: create a dedicated topology table
References: <1394003906-11630-1-git-send-email-vincent.guittot@linaro.org> <1394003906-11630-5-git-send-email-vincent.guittot@linaro.org> <531EE087.7050707@linux.vnet.ibm.com> <CAKfTPtCJEX7qknTb85FqJfuT03oNFN3rTOncy5Df37w65+GX8Q@mail.gmail.com> <531FE5B4.6090502@linux.vnet.ibm.com> <CAKfTPtDLzOMpVGUqBpMFiN_cwKERFDCqH1zLKsRbrqeD11DzWw@mail.gmail.com>
In-Reply-To: <CAKfTPtDLzOMpVGUqBpMFiN_cwKERFDCqH1zLKsRbrqeD11DzWw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14031402-6688-0000-0000-00000059F74B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/12/2014 01:14 PM, Vincent Guittot wrote:
> On 12 March 2014 05:42, Preeti U Murthy <preeti@linux.vnet.ibm.com> wrote:
>> On 03/11/2014 06:48 PM, Vincent Guittot wrote:
>>> On 11 March 2014 11:08, Preeti U Murthy <preeti@linux.vnet.ibm.com> wrote:
>>>> Hi Vincent,
>>>>
>>>> On 03/05/2014 12:48 PM, Vincent Guittot wrote:
>>>>> Create a dedicated topology table for handling asymetric feature.
>>>>> The current proposal creates a new level which describes which groups of CPUs
>>>>> take adavantge of SD_ASYM_PACKING. The useless level will be removed during the
>>>>> build of the sched_domain topology.
>>>>>
>>>>> Another solution would be to set SD_ASYM_PACKING in the sd_flags of SMT level
>>>>> during the boot sequence and before the build of the sched_domain topology.
>>>>
>>>> Is the below what you mean as the other solution? If it is so, I would
>>>> strongly recommend this approach rather than adding another level to the
>>>> topology level to represent the asymmetric behaviour.
>>>>
>>>> +static struct sched_domain_topology_level powerpc_topology[] = {
>>>> +#ifdef CONFIG_SCHED_SMT
>>>> +       { cpu_smt_mask, SD_SHARE_CPUPOWER | SD_SHARE_PKG_RESOURCES,
>>>> SD_INIT_NAME(SMT) | arch_sd_sibling_asym_packing() },
>>>> +#endif
>>>> +       { cpu_cpu_mask, SD_INIT_NAME(DIE) },
>>>> +       { NULL, },
>>>> +};
>>>
>>> Not exactly like that but something like below
>>>
>>> +static struct sched_domain_topology_level powerpc_topology[] = {
>>> +#ifdef CONFIG_SCHED_SMT
>>> + { cpu_smt_mask, SD_SHARE_CPUPOWER | SD_SHARE_PKG_RESOURCES,
>>> SD_INIT_NAME(SMT) },
>>> +#endif
>>> + { cpu_cpu_mask, SD_INIT_NAME(DIE) },
>>> + { NULL, },
>>> +};
>>> +
>>> +static void __init set_sched_topology(void)
>>> +{
>>> +#ifdef CONFIG_SCHED_SMT
>>> + powerpc_topology[0].sd_flags |= arch_sd_sibling_asym_packing();
>>> +#endif
>>> + sched_domain_topology = powerpc_topology;
>>> +}
>>
>> I think we can set it in powerpc_topology[] and not bother about setting
>> additional flags outside of this array. It is clearer this way.
> 
> IIRC, the arch_sd_sibling_asym_packing of powerpc can be set at
> runtime which prevents it from being put directly in the table. Or it
> means that we should use a function pointer in the table for setting
> flags instead of a static value like the current proposal.

Oh yes you are right. Then the above looks good to me. So we define the
table as usual and set the asymmetric flag in set_sched_topology().
> 
>>
>> On an additional note, on powerpc we would want to clear the
>> SD_SHARE_POWERDOMAIN flag at the CPU domain. On Power8, considering we
>> have 8 threads per core, we would want to consolidate tasks atleast upto
>> 4 threads without significant performance impact before spilling over to
>> the other cores. By doing so, besides making use of the higher power of
>> the core we could do cpuidle management at the core level for the
>> remaining idle cores as a result of this consolidation.
> 
> OK. i will add the SD_SHARE_POWERDOMAIN like below

Thanks!

Regards
Preeti U Murthy
> 
> Thanks
> Vincent
> 
>>
>> So the powerpc_topology[] would be something like the below:
>>
>> +static struct sched_domain_topology_level powerpc_topology[] = {
>> +#ifdef CONFIG_SCHED_SMT
>> +       { cpu_smt_mask, SD_SHARE_CPUPOWER | SD_SHARE_PKG_RESOURCES,
>> SD_INIT_NAME(SMT) | arch_sd_sibling_asym_packing() | SD_SHARE_POWERDOMAIN },
>> +#endif
>> +       { cpu_cpu_mask, SD_INIT_NAME(DIE) },
>> +       { NULL, },
>> +};
>>
>> The amount of consolidation to the threads in a core, we will probably
>> take care of it in cpu capacity or a similar parameter, but the above
>> topology level would be required to request the scheduler to try
>> consolidating tasks to cores till the cpu capacity(3/4/5 threads) has
>> exceeded.
>>
>> Regards
>> Preeti U Murthy
>>
>>
> 

