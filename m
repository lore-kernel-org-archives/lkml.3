Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934052Ab3JPAyz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 20:54:55 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:34980 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933711Ab3JPAyy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 20:54:54 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.8.9
X-SHieldMailCheckerPolicyVersion: FJ-ISEC-20120718-2
Message-ID: <525DE35A.7040205@jp.fujitsu.com>
Date: Wed, 16 Oct 2013 09:52:42 +0900
From: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: hpa@linux.intel.com, ebiederm@xmission.com, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org, bp@alien8.de, akpm@linux-foundation.org,
        fengguang.wu@intel.com, jingbai.ma@hp.com
Subject: Re: [PATCH v2 1/2] x86, apic: Add boot_cpu_is_bsp() to check if boot
 cpu is BSP
References: <20131015054214.13666.11737.stgit@localhost6.localdomain6> <20131015054322.13666.31465.stgit@localhost6.localdomain6> <20131015191217.GN31215@redhat.com>
In-Reply-To: <20131015191217.GN31215@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/10/16 4:12), Vivek Goyal wrote:
> On Tue, Oct 15, 2013 at 02:43:22PM +0900, HATAYAMA Daisuke wrote:
>> Kexec can enter the kdump 2nd kernel on AP if crash happens on AP. To
>> check if boot cpu is BSP, introduce a helper function
>> boot_cpu_is_bsp().
>>
>> Signed-off-by: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
>> ---
>>   arch/x86/include/asm/mpspec.h |    7 +++++++
>>   arch/x86/kernel/apic/apic.c   |   16 ++++++++++++++++
>>   arch/x86/kernel/setup.c       |    2 ++
>>   3 files changed, 25 insertions(+)
>>
>> diff --git a/arch/x86/include/asm/mpspec.h b/arch/x86/include/asm/mpspec.h
>> index 626cf70..54d5f98 100644
>> --- a/arch/x86/include/asm/mpspec.h
>> +++ b/arch/x86/include/asm/mpspec.h
>> @@ -47,11 +47,18 @@ extern int mp_bus_id_to_type[MAX_MP_BUSSES];
>>   extern DECLARE_BITMAP(mp_bus_not_pci, MAX_MP_BUSSES);
>>
>>   extern unsigned int boot_cpu_physical_apicid;
>> +extern bool boot_cpu_is_bsp;
>>   extern unsigned int max_physical_apicid;
>>   extern int mpc_default_type;
>>   extern unsigned long mp_lapic_addr;
>>
>>   #ifdef CONFIG_X86_LOCAL_APIC
>> +extern void boot_cpu_is_bsp_init(void);
>> +#else
>> +static inline void boot_cpu_is_bsp_init(void) { };
>> +#endif
>> +
>> +#ifdef CONFIG_X86_LOCAL_APIC
>>   extern int smp_found_config;
>>   #else
>>   # define smp_found_config 0
>> diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
>> index a7eb82d..62ee365 100644
>> --- a/arch/x86/kernel/apic/apic.c
>> +++ b/arch/x86/kernel/apic/apic.c
>> @@ -64,6 +64,12 @@ unsigned disabled_cpus;
>>   unsigned int boot_cpu_physical_apicid = -1U;
>>
>>   /*
>
> [..]
>> + * Indicates whether the processor that is doing the boot up, is BSP
>> + * processor or not.
>> + */
>> +bool boot_cpu_is_bsp;
>
> Should we set it to true by default? I think in most of the cases boot cpu
> is going to be bsp too?
>

Agreed. Most likely value should be default.

The reason why I wrote so would be that -- if there's reason -- I wanted to
write it uniform to other variables around it and wanted to avoid to let it
have static storage in binary file.

>> +
>> +/*
>>    * The highest APIC ID seen during enumeration.
>>    */
>>   unsigned int max_physical_apicid;
>> @@ -2589,3 +2595,13 @@ static int __init lapic_insert_resource(void)
>>    * that is using request_resource
>>    */
>>   late_initcall(lapic_insert_resource);
>> +
>> +void __init boot_cpu_is_bsp_init(void)
>> +{
>> +	if (cpu_has_apic) {
>> +		u32 l, h;
>> +
>> +		rdmsr_safe(MSR_IA32_APICBASE, &l, &h);
>> +		boot_cpu_is_bsp = (l & MSR_IA32_APICBASE_BSP) ? true : false;
>
> I came across following thread.
>
> https://lkml.org/lkml/2012/4/18/370
>
> Can we hit above read msr on old P5 class machines? Or is it safe to
> call unconditionally.
>

No, it's dangerous to cause #UD, and current implementation doesn't check
exception value returned by rdmsr_safe. It's meaningless to call rdmsr_safe.

At least, checking boot_cpu_data.x86 >= 6 satisfies support of IA32_APIC_BASE
MSR and this at the same time satisfies support of rdmsr instruction since the
instruction was introduced at Pentium processor. So,

if (boot_cpu_data.x86 >= 6 && cpu_has_apic()) {
     u32 l, h;

     rdmsr(MSR_IA32_APICBASE, &l, &h);
     boot_cpu_is_bsp = (l & MSR_IA32_APICBASE_BSP) ? true : false;  
}

-- 
Thanks.
HATAYAMA, Daisuke

