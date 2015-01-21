Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752015AbbAUBuI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 20:50:08 -0500
Received: from mga14.intel.com ([192.55.52.115]:60533 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751293AbbAUBuG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 20:50:06 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,438,1418112000"; 
   d="scan'208";a="673173138"
Message-ID: <54BF05CA.9070506@linux.intel.com>
Date: Wed, 21 Jan 2015 09:50:02 +0800
From: Jiang Liu <jiang.liu@linux.intel.com>
Organization: Intel
User-Agent: Mozilla/5.0 (Windows NT 6.2; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: LKML <linux-kernel@vger.kernel.org>, Joerg Roedel <joro@8bytes.org>,
        x86@kernel.org, Tony Luck <tony.luck@intel.com>,
        Borislav Petkov <bp@alien8.de>
Subject: Re: [patch 00/23] x86: Cleanup apic/ioapic/x2apic setup code
References: <20150115210458.625399149@linutronix.de> <54B8DBC1.6080205@linux.intel.com> <alpine.DEB.2.11.1501161120560.5526@nanos> <alpine.DEB.2.11.1501161203340.5526@nanos>
In-Reply-To: <alpine.DEB.2.11.1501161203340.5526@nanos>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2015/1/16 19:05, Thomas Gleixner wrote:
> On Fri, 16 Jan 2015, Thomas Gleixner wrote:
>> On Fri, 16 Jan 2015, Jiang Liu wrote:
>>> 5) x86_32, UP, IO_APIC disabled
>>> 5.1) boot: panic with following call stack:
>>> do_ono_initcall()->APIC_init_uniprocessor()->setup_local_APIC().
>>> I can't capture the full log message due to lack of serial console.
>>> It seems we have trouble with:
>>> early_initcall(APIC_init_uniprocessor);
>>
>> Hmm, worked here. Lemme find some other machine.
> 
> Found the issue, won't work. But I still want to remove that x86
> nonsense from init. So we need to do it different.
> 
> Subject: init: Get rid of x86isms
> From: Thomas Gleixner <tglx@linutronix.de>
> Date: Wed, 14 Jan 2015 14:59:48 +0100
> 
> Provide a config option and make the UP smp_init() implementation
> depend on it and confine this to x86.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> ---
>  arch/x86/Kconfig            |    4 ++++
>  arch/x86/kernel/apic/apic.c |    7 +++++++
>  include/linux/smp.h         |    6 ++++++
>  init/main.c                 |   13 -------------
>  4 files changed, 17 insertions(+), 13 deletions(-)
> 
> Index: tip/arch/x86/Kconfig
> ===================================================================
> --- tip.orig/arch/x86/Kconfig
> +++ tip/arch/x86/Kconfig
> @@ -855,6 +855,10 @@ config SCHED_MC
>  
>  source "kernel/Kconfig.preempt"
>  
> +config UP_SMP_INIT
> +       def_bool y
> +       depends on X86_UP_APIC
> +
>  config X86_UP_APIC
>  	bool "Local APIC support on uniprocessors"
>  	depends on X86_32 && !SMP && !X86_32_NON_STANDARD && !PCI_MSI
> Index: tip/arch/x86/kernel/apic/apic.c
> ===================================================================
> --- tip.orig/arch/x86/kernel/apic/apic.c
> +++ tip/arch/x86/kernel/apic/apic.c
> @@ -2265,6 +2265,13 @@ int __init APIC_init_uniprocessor(void)
>  	return 0;
>  }
>  
> +#ifdef CONFIG_UP_SMP_INIT
> +void smp_init(void)
> +{
> +	APIC_init_uniprocessor();
> +}
> +#endif
> +
>  /*
>   * Power management
>   */
> Index: tip/include/linux/smp.h
> ===================================================================
> --- tip.orig/include/linux/smp.h
> +++ tip/include/linux/smp.h
> @@ -151,6 +151,12 @@ smp_call_function_any(const struct cpuma
>  static inline void kick_all_cpus_sync(void) {  }
>  static inline void wake_up_all_idle_cpus(void) {  }
>  
> +#ifdef CONFIG_UP_SMP_INIT
> +extern void __init smp_init(void);
> +#else
> +static inline void smp_init(void) { }
> +#endif
> +
>  #endif /* !SMP */
>  
>  /*
> Index: tip/init/main.c
> ===================================================================
> --- tip.orig/init/main.c
> +++ tip/init/main.c
> @@ -87,10 +87,6 @@
>  #include <asm/sections.h>
>  #include <asm/cacheflush.h>
>  
> -#ifdef CONFIG_X86_LOCAL_APIC
> -#include <asm/smp.h>
> -#endif
> -
>  static int kernel_init(void *);
>  
>  extern void init_IRQ(void);
> @@ -351,15 +347,6 @@ __setup("rdinit=", rdinit_setup);
>  
>  #ifndef CONFIG_SMP
>  static const unsigned int setup_max_cpus = NR_CPUS;
> -#ifdef CONFIG_X86_LOCAL_APIC
> -static void __init smp_init(void)
> -{
> -	APIC_init_uniprocessor();
> -}
> -#else
> -#define smp_init()	do { } while (0)
> -#endif
> -
>  static inline void setup_nr_cpu_ids(void) { }
>  static inline void smp_prepare_cpus(unsigned int maxcpus) { }
>  #endif
Hi Thomas,
	With above patch applied, it just gives a blank screen
instead of a panic when booting on my problematic laptop.
Now I have found the root cause of the failure on my laptop.
	On i386, it triggers  BUG_ON(!apic->apic_id_registered())
in function setup_local_APIC() because apic_bsp_up_setup() is called
too late. So we need a simple patch as below. With following patch
applied, it boots successfully with your original patch.
Regards,
Gerry
--------------------------------------------------------------------
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index 6f3067807376..791148864a48 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -2245,10 +2245,9 @@ int __init apic_bsp_setup(bool upmode)
        int id;

        connect_bsp_APIC();
-       setup_local_APIC();
-
        if (upmode)
                apic_bsp_up_setup();
+       setup_local_APIC();

        if (x2apic_mode)
                id = apic_read(APIC_LDR);
---------------------------------------------------------------------
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
