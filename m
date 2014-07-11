Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752156AbaGKAtY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 20:49:24 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:49219 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751565AbaGKAtW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 20:49:22 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v2.0.1
X-SHieldMailCheckerPolicyVersion: FJ-ISEC-20120718-3
Message-ID: <53BF345B.8000107@jp.fujitsu.com>
Date: Fri, 11 Jul 2014 09:48:27 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Igor Mammedov <imammedo@redhat.com>
CC: <tglx@linutronix.de>, <mingo@redhat.com>, <hpa@zytor.com>,
        <x86@kernel.org>, <toshi.kani@hp.com>, <bp@alien8.de>,
        <huawei.libin@huawei.com>, <paul.gortmaker@windriver.com>,
        <linux-kernel@vger.kernel.org>, <srivatsa.bhat@linux.vnet.ibm.com>,
        <umgwanakikbuti@gmail.com>, <peterz@infradead.org>
Subject: Re: [PATCH] x86,cpu-hotplug: assign same CPU number to readded CPU
References: <53BE51CE.40208@jp.fujitsu.com> <20140710112609.0b0eb294@nial.usersys.redhat.com>
In-Reply-To: <20140710112609.0b0eb294@nial.usersys.redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-SecurityPolicyCheck-GC: OK by FENCE-Mail
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/07/10 18:26), Igor Mammedov wrote:
> On Thu, 10 Jul 2014 17:41:50 +0900
> Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com> wrote:
>
>> llc_shared_map is not cleared even if CPU is offline or hot removed.
>> So when hot-plugging CPU and assigning new CPU number to hot-added CPU,
>> the mask has wrong value. The mask is used by CSF schduler to create
>> sched_domain. So it breaks CFS scheduler.
>>
>> Here is a example on my system.
>> My system has 4 sockets and each socket has 15 cores and HT is enabled.
>> In this case, each core of sockes is numbered as follows:
>>
>>            | CPU#
>> Socket#0 | 0-14 , 60-74
>> Socket#1 | 15-29, 75-89
>> Socket#2 | 30-44, 90-104
>> Socket#3 | 45-59, 105-119
>>
>> Then llc_shared_mask of CPU#30 has 0x3fff80000001fffc0000000.
>> It means that last level cache of Socket#2 is shared with
>> CPU#30-44 and 90-104.
>>
>> When hot-removing socket#2 and #3, each core of sockets is numbered
>> as follows:
>>
>>            | CPU#
>> Socket#0 | 0-14 , 60-74
>> Socket#1 | 15-29, 75-89
>>
>> But llc_shared_mask is not cleared. So llc_shared_mask of CPU#30 remains
>> having 0x3fff80000001fffc0000000.
>>
>> After that, when hot-adding socket#2 and #3, each core of sockets is
>> numbered as follows:
>>
>>            | CPU#
>> Socket#0 | 0-14 , 60-74
>> Socket#1 | 15-29, 75-89
>> Socket#2 | 30-59
>> Socket#3 | 90-119
>>
>> Then llc_shared_mask of CPU#30 becomes 0x3fff8000fffffffc0000000.
>> It means that last level cache of Socket#2 is shared with CPU#30-59
>> and 90-104. So the mask has wrong value.
>>
>> At first, I cleared hot-removed CPU number's bit from llc_shared_map
>> when hot removing CPU. But Borislav suggested that the problem will
>> disappear if readded CPU is assigned same CPU number. And llc_shared_map
>> must not be changed.
>>
>> So the patch assigns same CPU number to readded CPU by linking CPU
>> number to APIC ID. And by the patch, the problem disappers.
>>
>> Signed-off-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
>> Suggested-by: Borislav Petkov <bp@alien8.de1>
>> ---
>>    arch/x86/kernel/apic/apic.c | 32 +++++++++++++++++++++++++++++++-
>>    1 file changed, 31 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
>> index ad28db7..1cc715b 100644
>> --- a/arch/x86/kernel/apic/apic.c
>> +++ b/arch/x86/kernel/apic/apic.c
>> @@ -220,6 +220,22 @@ static void apic_pm_activate(void);
>>    static unsigned long apic_phys;
>>
>>    /*
>> + * Bind ACPI ID to CPU ID
>> + * CPU ID to APIC ID does not change by this array even if CPU is
>> + * hotplugged. So don't clear the array even if CPU is hot-removed
>> + */
>> +static int apicid_to_cpuid[MAX_LOCAL_APIC] = {
>> +	[0 ... MAX_LOCAL_APIC-1] = -1,
>> +};
>> +
>> +/*
>> + * Represent CPU ID bound to APIC
>> + * Don't clear a bit even if CPU is hot-removed
>> + */
>> +static DECLARE_BITMAP(cpu_used_bits, CONFIG_NR_CPUS);
>> +static struct cpumask *const cpu_used_mask = to_cpumask(cpu_used_bits);
>> +
>> +/*
>>     * Get the LAPIC version
>>     */
>>    static inline int lapic_get_version(void)
>> @@ -2122,6 +2138,17 @@ void disconnect_bsp_APIC(int virt_wire_setup)
>>    	apic_write(APIC_LVT1, value);
>>    }
>>

>> +static int get_cpuid(int apicid)
>> +{
>> +	int cpuid;
>> +
>> +	cpuid = apicid_to_cpuid[apicid];
>> +	if (cpuid < 0)
>> +		cpuid = cpumask_next_zero(-1, cpu_used_mask);
> Why do you need additional cpu bitmask?

To assing new CPU number, I prepared new cpu bitmask.

The following two steps are necessary to assign CPU number to APIC ID.
  1. Check whether APIC ID has been assigned CPU number
  2. Assign new CPU number if ACPI ID has not been assigned CPU number (it
     means apicid_to_cpuid[] returns -1)

Step 1. is checked by apicid_to_cpuid[]. And step 2. assigns new CPU
number by using cpu_used_mask.

To keep cpu number, cpumask must not be cleared by hot removing CPU.
If cpumask is cleared by hot removing CPU, the cpumask cannot be used
to keep CPU number.

Currently, cpu_present_map is used to assign CPU number. But the cpumask
is cleared by hot removing CPU since the mask is prepared to remember
existed CPUs in the system. So the cpu_present_map must be cleared
at CPU hot remove.

I confirmed whether present cpumasks (cpu_possible_map, cpu_online_map
et al) is usable or not for this purpose. But there is no cpumask that
can be used to keep CPU number. So I prepared new cpu bitmask.

> How about just finding the first apicid_to_cpuid[apicid] < 0
> and dropping not needed anymore bitmask.

When apicid_to_cpuid[] return -1, kernel assigns new CPU number. For
this, the cpu_used_mask is necessary.

Thanks,
Yasuaki Ishimatsu

>
>> +
>> +	return cpuid;
>> +}
>> +
>>    int generic_processor_info(int apicid, int version)
>>    {
>>    	int cpu, max = nr_cpu_ids;
>> @@ -2199,7 +2226,9 @@ int generic_processor_info(int apicid, int version)
>>    		 */
>>    		cpu = 0;
>>    	} else
>> -		cpu = cpumask_next_zero(-1, cpu_present_mask);
>> +		cpu = get_cpuid(apicid);
>> +
>> +	apicid_to_cpuid[apicid] = cpu;
>>
>>    	/*
>>    	 * Validate version
>> @@ -2228,6 +2257,7 @@ int generic_processor_info(int apicid, int version)
>>    	early_per_cpu(x86_cpu_to_logical_apicid, cpu) =
>>    		apic->x86_32_early_logical_apicid(cpu);
>>    #endif
>> +	cpumask_set_cpu(cpu, cpu_used_mask);
>>    	set_cpu_possible(cpu, true);
>>    	set_cpu_present(cpu, true);
>>
>>
>


