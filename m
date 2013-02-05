Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754265Ab3BEH4h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 02:56:37 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:38331 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751177Ab3BEH4e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 02:56:34 -0500
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <5110BB0C.3020004@jp.fujitsu.com>
Date: Tue, 5 Feb 2013 16:55:56 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: liguang <lig.fnst@cn.fujitsu.com>
CC: <linux-kernel@vger.kernel.org>, <linux-acpi@vger.kernel.org>,
        <x86@kernel.org>, <rientjes@google.com>
Subject: Re: [PATCH v3 2/4] numa: avoid export acpi_numa variable
References: <1360049762-6349-1-git-send-email-lig.fnst@cn.fujitsu.com> <1360049762-6349-3-git-send-email-lig.fnst@cn.fujitsu.com>
In-Reply-To: <1360049762-6349-3-git-send-email-lig.fnst@cn.fujitsu.com>
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/02/05 16:36, liguang wrote:
> acpi_numa is used to prevent srat table
> being parsed, seems a little miss-named,
> if 'noacpi' was specified by cmdline and
> CONFIG_ACPI_NUMA was enabled, acpi_numa
> will be operated directly from everywhere
> it needed to disable/enable numa in acpi
> mode which was a bad thing, so, try to
> export a fuction to get srat table
> enable/disable info.
> 
> Signed-off-by: liguang <lig.fnst@cn.fujitsu.com>
> ---

Hmm. Did you test the patch?
By the patch, srat_disable() returns false(0) or 1. As a result,
acpi_numa_x2apic_affinity_init(), acpi_numa_processor_affinity_init()
and acpi_numa_memory_affinity_init() go wrong at following if sentence.

---
	if (srat_disable())
		return -1;
---

When you change a return value of function, you should check othe
functions which use it carefully.

And if you use acpi_numa as bool, you should use "acpi_numa = true"
instead of "acpi_numa = 1"

Thanks,
Yasuaki Ishimatsu

>   arch/x86/include/asm/acpi.h |    2 +-
>   arch/x86/kernel/acpi/srat.c |   17 +++++++++++------
>   arch/x86/mm/numa.c          |    2 +-
>   arch/x86/xen/enlighten.c    |    2 +-
>   4 files changed, 14 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/x86/include/asm/acpi.h b/arch/x86/include/asm/acpi.h
> index b31bf97..449e12a 100644
> --- a/arch/x86/include/asm/acpi.h
> +++ b/arch/x86/include/asm/acpi.h
> @@ -177,7 +177,7 @@ static inline void disable_acpi(void) { }
>   #define ARCH_HAS_POWER_INIT	1
>   
>   #ifdef CONFIG_ACPI_NUMA
> -extern int acpi_numa;
> +extern void disable_acpi_numa(void);
>   extern int x86_acpi_numa_init(void);
>   #endif /* CONFIG_ACPI_NUMA */
>   
> diff --git a/arch/x86/kernel/acpi/srat.c b/arch/x86/kernel/acpi/srat.c
> index cdd0da9..8d7f3f8 100644
> --- a/arch/x86/kernel/acpi/srat.c
> +++ b/arch/x86/kernel/acpi/srat.c
> @@ -24,22 +24,27 @@
>   #include <asm/apic.h>
>   #include <asm/uv/uv.h>
>   
> -int acpi_numa __initdata;
> +static bool acpi_numa __initdata;
>   
>   static __init int setup_node(int pxm)
>   {
>   	return acpi_map_pxm_to_node(pxm);
>   }
>   
> -static __init void bad_srat(void)
> +void __init disable_acpi_numa(void)
>   {
> -	printk(KERN_ERR "SRAT: SRAT not used.\n");
> -	acpi_numa = -1;
> +	acpi_numa = false;
>   }
>   
> -static __init inline int srat_disabled(void)
> +static void __init bad_srat(void)
>   {
> -	return acpi_numa < 0;
> +	disable_acpi_numa();
> +	printk(KERN_ERR "SRAT: SRAT will not be used.\n");
> +}
> +
> +static bool __init srat_disabled(void)
> +{
> +	return acpi_numa;
>   }
>   
>   /* Callback for SLIT parsing */
> diff --git a/arch/x86/mm/numa.c b/arch/x86/mm/numa.c
> index 245a4ba..1ebc907 100644
> --- a/arch/x86/mm/numa.c
> +++ b/arch/x86/mm/numa.c
> @@ -47,7 +47,7 @@ static __init int numa_setup(char *opt)
>   #endif
>   #ifdef CONFIG_ACPI_NUMA
>   	if (!strncmp(opt, "noacpi", 6))
> -		acpi_numa = -1;
> +		disable_acpi_numa();
>   #endif
>   	return 0;
>   }
> diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
> index 657eca9..3636bc6 100644
> --- a/arch/x86/xen/enlighten.c
> +++ b/arch/x86/xen/enlighten.c
> @@ -1447,7 +1447,7 @@ asmlinkage void __init xen_start_kernel(void)
>   	 * any NUMA information the kernel tries to get from ACPI will
>   	 * be meaningless.  Prevent it from trying.
>   	 */
> -	acpi_numa = -1;
> +	disable_acpi_numa();
>   #endif
>   
>   	/* Don't do the full vcpu_info placement stuff until we have a
> 


