Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754116AbaGOE21 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 00:28:27 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:43046 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750972AbaGOE2Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 00:28:24 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v2.0.1
X-SHieldMailCheckerPolicyVersion: FJ-ISEC-20120718-3
Message-ID: <53C4AD96.3030303@jp.fujitsu.com>
Date: Tue, 15 Jul 2014 13:27:02 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: Igor Mammedov <imammedo@redhat.com>, <tglx@linutronix.de>,
        <mingo@redhat.com>, <hpa@zytor.com>, <x86@kernel.org>,
        <toshi.kani@hp.com>, <huawei.libin@huawei.com>,
        <paul.gortmaker@windriver.com>, <linux-kernel@vger.kernel.org>,
        <srivatsa.bhat@linux.vnet.ibm.com>, <umgwanakikbuti@gmail.com>,
        <peterz@infradead.org>
Subject: Re: [PATCH] x86,cpu-hotplug: assign same CPU number to readded CPU
References: <53BE51CE.40208@jp.fujitsu.com> <20140710112609.0b0eb294@nial.usersys.redhat.com> <53BF345B.8000107@jp.fujitsu.com> <20140711105920.GC17083@pd.tnic>
In-Reply-To: <20140711105920.GC17083@pd.tnic>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-SecurityPolicyCheck-GC: OK by FENCE-Mail
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Borislav,

(2014/07/11 19:59), Borislav Petkov wrote:
> On Fri, Jul 11, 2014 at 09:48:27AM +0900, Yasuaki Ishimatsu wrote:
>>>> +static int get_cpuid(int apicid)
>
> Btw this "cpuid" is misleading. Call it "cpu_num" or so.

O.K.
I'll update it.

>
>>>> +{
>>>> +	int cpuid;
>>>> +
>>>> +	cpuid = apicid_to_cpuid[apicid];
>>>> +	if (cpuid < 0)
>>>> +		cpuid = cpumask_next_zero(-1, cpu_used_mask);
>>> Why do you need additional cpu bitmask?
>>
>> To assing new CPU number, I prepared new cpu bitmask.
>>
>> The following two steps are necessary to assign CPU number to APIC ID.
>>   1. Check whether APIC ID has been assigned CPU number
>>   2. Assign new CPU number if ACPI ID has not been assigned CPU number (it
>>      means apicid_to_cpuid[] returns -1)
>>
>> Step 1. is checked by apicid_to_cpuid[]. And step 2. assigns new CPU
>> number by using cpu_used_mask.
>>
>> To keep cpu number, cpumask must not be cleared by hot removing CPU.
>> If cpumask is cleared by hot removing CPU, the cpumask cannot be used
>> to keep CPU number.
>>
>> Currently, cpu_present_map is used to assign CPU number. But the cpumask
>> is cleared by hot removing CPU since the mask is prepared to remember
>> existed CPUs in the system. So the cpu_present_map must be cleared
>> at CPU hot remove.
>>
>> I confirmed whether present cpumasks (cpu_possible_map, cpu_online_map
>> et al) is usable or not for this purpose. But there is no cpumask that
>> can be used to keep CPU number. So I prepared new cpu bitmask.
>>
>>> How about just finding the first apicid_to_cpuid[apicid] < 0
>>> and dropping not needed anymore bitmask.
>>
>> When apicid_to_cpuid[] return -1, kernel assigns new CPU number. For
>> this, the cpu_used_mask is necessary.
>
> And we can't have that - we cannot have cores which had number X get
> number Y after hotplug.
>

> Can you send a full dmesg after you've done a physical node hotplug on a
> machine? Privately is fine too.

O.K.
I'll send dmesg.

Thanks,
Yasuaki Ishimatsu

>
> Boot with
>
> 	"ignore_loglevel log_buf_len=10M debug apic=debug show_lapic=all"
>
> please.
>
> Thanks.
>


