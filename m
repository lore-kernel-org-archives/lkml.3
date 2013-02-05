Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751187Ab3BEF2b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 00:28:31 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:54366 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750786Ab3BEF2a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 00:28:30 -0500
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <51109858.8040000@jp.fujitsu.com>
Date: Tue, 5 Feb 2013 14:27:52 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: liguang <lig.fnst@cn.fujitsu.com>
CC: <linux-kernel@vger.kernel.org>, <linux-acpi@vger.kernel.org>,
        <x86@kernel.org>, <rientjes@google.com>
Subject: Re: [PATCH v2 2/4] numa: avoid export acpi_numa variable
References: <1360031838-26898-1-git-send-email-lig.fnst@cn.fujitsu.com> <1360031838-26898-3-git-send-email-lig.fnst@cn.fujitsu.com>
In-Reply-To: <1360031838-26898-3-git-send-email-lig.fnst@cn.fujitsu.com>
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/02/05 11:37, liguang wrote:
> acpi_numa is used to prevent srat table
> being parsed, seems a little miss-named,
> if 'noacpi' was specified by cmdline and
> CONFIG_ACPI_NUMA was enabled, acpi_numa
> will be operated directly from everywhere
> it needed to disable/enable numa in acpi
> mode which was a bad thing, so, try to
> export a fuction to get srat table
> enable/disable info.

The patch is wrong.
By the patch, acpi_numa is set to one of three values, either -1, false(0), 1.
By this, x86_acpi_numa_init() goes wrong.

How about using bool to acpi_numa?

Thanks,
Yasuaki Ishimatsu

> Reviewed-by: David Rientjes <rientjes@google.com>
> Signed-off-by: liguang <lig.fnst@cn.fujitsu.com>
> ---
>   arch/x86/include/asm/acpi.h |    2 +-
>   arch/x86/kernel/acpi/srat.c |   15 ++++++++++-----
>   arch/x86/mm/numa.c          |    2 +-
>   arch/x86/xen/enlighten.c    |    2 +-
>   4 files changed, 13 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/x86/include/asm/acpi.h b/arch/x86/include/asm/acpi.h
> index 0c44630..6b9c861 100644
> --- a/arch/x86/include/asm/acpi.h
> +++ b/arch/x86/include/asm/acpi.h
> @@ -181,7 +181,7 @@ static inline void disable_acpi(void) { }
>   #define ARCH_HAS_POWER_INIT	1
>   
>   #ifdef CONFIG_ACPI_NUMA
> -extern int acpi_numa;
> +extern void disable_acpi_numa(void);
>   extern int x86_acpi_numa_init(void);
>   #endif /* CONFIG_ACPI_NUMA */
>   
> diff --git a/arch/x86/kernel/acpi/srat.c b/arch/x86/kernel/acpi/srat.c
> index 4ddf497..0a4d7ee 100644
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
> +{
> +	acpi_numa = false;
> +}
> +
> +static void __init bad_srat(void)
>   {
> -	printk(KERN_ERR "SRAT: SRAT not used.\n");
>   	acpi_numa = -1;
> +	printk(KERN_ERR "SRAT: SRAT will not be used.\n");
>   }
>   
> -static __init inline int srat_disabled(void)
> +static bool __init srat_disabled(void)
>   {
> -	return acpi_numa < 0;
> +	return acpi_numa;
>   }
>   
>   /* Callback for SLIT parsing */
> diff --git a/arch/x86/mm/numa.c b/arch/x86/mm/numa.c
> index 2d125be..870ca6b 100644
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
> index 138e566..a5f6353 100644
> --- a/arch/x86/xen/enlighten.c
> +++ b/arch/x86/xen/enlighten.c
> @@ -1415,7 +1415,7 @@ asmlinkage void __init xen_start_kernel(void)
>   	 * any NUMA information the kernel tries to get from ACPI will
>   	 * be meaningless.  Prevent it from trying.
>   	 */
> -	acpi_numa = -1;
> +	disable_acpi_numa();
>   #endif
>   
>   	/* Don't do the full vcpu_info placement stuff until we have a
> 


