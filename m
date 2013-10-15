Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759679Ab3JOTNO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 15:13:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1606 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756979Ab3JOTNN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 15:13:13 -0400
Date: Tue, 15 Oct 2013 15:12:17 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Cc: hpa@linux.intel.com, ebiederm@xmission.com, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org, bp@alien8.de, akpm@linux-foundation.org,
        fengguang.wu@intel.com, jingbai.ma@hp.com
Subject: Re: [PATCH v2 1/2] x86, apic: Add boot_cpu_is_bsp() to check if boot
 cpu is BSP
Message-ID: <20131015191217.GN31215@redhat.com>
References: <20131015054214.13666.11737.stgit@localhost6.localdomain6>
 <20131015054322.13666.31465.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131015054322.13666.31465.stgit@localhost6.localdomain6>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 15, 2013 at 02:43:22PM +0900, HATAYAMA Daisuke wrote:
> Kexec can enter the kdump 2nd kernel on AP if crash happens on AP. To
> check if boot cpu is BSP, introduce a helper function
> boot_cpu_is_bsp().
> 
> Signed-off-by: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
> ---
>  arch/x86/include/asm/mpspec.h |    7 +++++++
>  arch/x86/kernel/apic/apic.c   |   16 ++++++++++++++++
>  arch/x86/kernel/setup.c       |    2 ++
>  3 files changed, 25 insertions(+)
> 
> diff --git a/arch/x86/include/asm/mpspec.h b/arch/x86/include/asm/mpspec.h
> index 626cf70..54d5f98 100644
> --- a/arch/x86/include/asm/mpspec.h
> +++ b/arch/x86/include/asm/mpspec.h
> @@ -47,11 +47,18 @@ extern int mp_bus_id_to_type[MAX_MP_BUSSES];
>  extern DECLARE_BITMAP(mp_bus_not_pci, MAX_MP_BUSSES);
>  
>  extern unsigned int boot_cpu_physical_apicid;
> +extern bool boot_cpu_is_bsp;
>  extern unsigned int max_physical_apicid;
>  extern int mpc_default_type;
>  extern unsigned long mp_lapic_addr;
>  
>  #ifdef CONFIG_X86_LOCAL_APIC
> +extern void boot_cpu_is_bsp_init(void);
> +#else
> +static inline void boot_cpu_is_bsp_init(void) { };
> +#endif
> +
> +#ifdef CONFIG_X86_LOCAL_APIC
>  extern int smp_found_config;
>  #else
>  # define smp_found_config 0
> diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
> index a7eb82d..62ee365 100644
> --- a/arch/x86/kernel/apic/apic.c
> +++ b/arch/x86/kernel/apic/apic.c
> @@ -64,6 +64,12 @@ unsigned disabled_cpus;
>  unsigned int boot_cpu_physical_apicid = -1U;
>  
>  /*

[..]
> + * Indicates whether the processor that is doing the boot up, is BSP
> + * processor or not.
> + */
> +bool boot_cpu_is_bsp;

Should we set it to true by default? I think in most of the cases boot cpu
is going to be bsp too?

> +
> +/*
>   * The highest APIC ID seen during enumeration.
>   */
>  unsigned int max_physical_apicid;
> @@ -2589,3 +2595,13 @@ static int __init lapic_insert_resource(void)
>   * that is using request_resource
>   */
>  late_initcall(lapic_insert_resource);
> +
> +void __init boot_cpu_is_bsp_init(void)
> +{
> +	if (cpu_has_apic) {
> +		u32 l, h;
> +
> +		rdmsr_safe(MSR_IA32_APICBASE, &l, &h);
> +		boot_cpu_is_bsp = (l & MSR_IA32_APICBASE_BSP) ? true : false;

I came across following thread.

https://lkml.org/lkml/2012/4/18/370

Can we hit above read msr on old P5 class machines? Or is it safe to
call unconditionally.

Thanks
Vivek
