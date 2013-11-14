Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753469Ab3KNLRa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 06:17:30 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:46416 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752323Ab3KNLR1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 06:17:27 -0500
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.8.9
X-SHieldMailCheckerPolicyVersion: FJ-ISEC-20120718-2
Message-ID: <5284B11C.3020103@jp.fujitsu.com>
Date: Thu, 14 Nov 2013 20:16:44 +0900
From: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: hpa@linux.intel.com
CC: ebiederm@xmission.com, vgoyal@redhat.com, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org, bp@alien8.de, akpm@linux-foundation.org,
        fengguang.wu@intel.com, jingbai.ma@hp.com
Subject: Re: [PATCH v5 1/3] x86, apic: add bsp_physical_apicid
References: <20131112094952.4902.72689.stgit@localhost6.localdomain6> <20131112095153.4902.51290.stgit@localhost6.localdomain6>
In-Reply-To: <20131112095153.4902.51290.stgit@localhost6.localdomain6>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello HPA,

I have another question relevant to http://lkml.org/lkml/2013/11/12/311.

(2013/11/12 18:51), HATAYAMA Daisuke wrote:
<cut>
> @@ -2589,3 +2593,14 @@ static int __init lapic_insert_resource(void)
>    * that is using request_resource
>    */
>   late_initcall(lapic_insert_resource);
> +
> +void __init bsp_physical_apicid_init(void)
> +{
> +	u32 l, h;
> +
> +	if (boot_cpu_data.x86 >= 6 && cpu_has_apic) {
> +		rdmsr(MSR_IA32_APICBASE, l, h);
> +		if (!(l & MSR_IA32_APICBASE_BSP))
> +			bsp_physical_apicid = boot_cpu_data.initial_apicid;
> +	}
> +}

So, rigrously, we should not use rdmsr for MSR_IA32_APICBASE here since this can
return wrong value on some clustered system?

At least all the mpparse.c, amdtopology.c and visws_quirks.c has referred to
MP table only, so there's no issue by simply dropping this code.

> diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
> index 2793d1f..28bea2c 100644
> --- a/arch/x86/kernel/cpu/common.c
> +++ b/arch/x86/kernel/cpu/common.c
> @@ -681,7 +681,7 @@ static void identify_cpu_without_cpuid(struct cpuinfo_x86 *c)
>  /*
>   * Do minimum CPU detection early.
>   * Fields really needed: vendor, cpuid_level, family, model, mask,
> - * cache alignment.
> + * cache alignment, initial_apicid.
>   * The others are not touched to avoid unwanted side effects.
>   *
>   * WARNING: this function is only called on the BP.  Don't add code here
> @@ -725,6 +725,9 @@ static void __init early_identify_cpu(struct cpuinfo_x86 *c)
>  		this_cpu->c_bsp_init(c);
>
>  	setup_force_cpu_cap(X86_FEATURE_ALWAYS);
> +
> +	if (c->cpuid_level >= 0x00000001)
> +		c->initial_apicid = (cpuid_ebx(1) >> 24) & 0xFF;
>  }

Can the initial APID IDs obtained in this way using cpuid duplicate on some
clustered system?

Can we consider each apic->get_apic_id() method return *initial* APIC ID?
According to 8.4 Multiple-Processor (MP) Initialization, Intel System Programming
Guide, the APID IDs written into MADT and MP table are the initial ones.
So, APID IDs to be compared with these must be the initial ones.

-- 
Thanks.
HATAYAMA, Daisuke

