Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751668AbaDRIP4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 04:15:56 -0400
Received: from mail-ee0-f52.google.com ([74.125.83.52]:45075 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751496AbaDRIP3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 04:15:29 -0400
Date: Fri, 18 Apr 2014 10:15:24 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Feng Tang <feng.tang@intel.com>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: tglx@lintronix.de, Clemens Ladisch <clemens@ladisch.de>,
        tglx@linutronix.de, mingo@elte.hu, hpa@zytor.com,
        linux-kernel@vger.kernel.org, John Stultz <john.stultz@linaro.org>,
        Andy Lutomirski <luto@amacapital.net>
Subject: Re: [RFC PATCH] x86, hpet: Add quirk to disable HPET for baytrail
 platform
Message-ID: <20140418081524.GB14560@gmail.com>
References: <20140328073718.GA12762@feng-snb>
 <53352DE5.2090600@ladisch.de>
 <20140328081117.GA32308@gmail.com>
 <20140415074443.GA10911@feng-snb>
 <20140415090025.GA31244@gmail.com>
 <20140415095539.GA19271@feng-snb>
 <20140415104206.GA31656@gmail.com>
 <20140415141206.GA12076@feng-snb>
 <20140416065148.GB1193@gmail.com>
 <20140418074955.GA3482@feng-snb>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140418074955.GA3482@feng-snb>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Feng Tang <feng.tang@intel.com> wrote:

> Hi All,
> 
> Please help to review this RFC patch, if you are ok with it. I'll separte them into
> 2 and repost.
> 	1. make the boot_hpet_disable extern
> 	2. add quirk for baytrail HPET.
> thanks!
> 
> - Feng
> 
> 
> 
> From 4b8c370649f1d2b320aa46a005b8b61eb59a539e Mon Sep 17 00:00:00 2001
> From: Feng Tang <feng.tang@intel.com>
> Date: Fri, 18 Apr 2014 15:43:22 +0800
> Subject: [PATCH] x86, hpet: Add quirk to disable HPET for baytrail platform
> 
> HPET on current baytrail platform has accuracy problem to be used as
> reliable clocksource/clockevent, so add a early quirk to disable it.
> 
> Signed-off-by: Feng Tang <feng.tang@intel.com>
> ---
>  arch/x86/include/asm/hpet.h    |    1 +
>  arch/x86/kernel/early-quirks.c |   14 ++++++++++++++
>  arch/x86/kernel/hpet.c         |    2 +-
>  3 files changed, 16 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/include/asm/hpet.h b/arch/x86/include/asm/hpet.h
> index b18df57..36f7125 100644
> --- a/arch/x86/include/asm/hpet.h
> +++ b/arch/x86/include/asm/hpet.h
> @@ -63,6 +63,7 @@
>  /* hpet memory map physical address */
>  extern unsigned long hpet_address;
>  extern unsigned long force_hpet_address;
> +extern int boot_hpet_disable;
>  extern u8 hpet_blockid;
>  extern int hpet_force_user;
>  extern u8 hpet_msi_disable;
> diff --git a/arch/x86/kernel/early-quirks.c b/arch/x86/kernel/early-quirks.c
> index bc4a088..1e5f6bc 100644
> --- a/arch/x86/kernel/early-quirks.c
> +++ b/arch/x86/kernel/early-quirks.c
> @@ -17,6 +17,7 @@
>  #include <asm/dma.h>
>  #include <asm/io_apic.h>
>  #include <asm/apic.h>
> +#include <asm/hpet.h>
>  #include <asm/iommu.h>
>  #include <asm/gart.h>
>  #include <asm/irq_remapping.h>
> @@ -380,6 +381,13 @@ static void __init intel_graphics_stolen(int num, int slot, int func)
>  	}
>  }
>  
> +static void __init force_disable_hpet(int num, int slot, int func)
> +{
> +	boot_hpet_disable = 1;
> +	pr_info("Will Disable HPET for this platform\n");
> +}
> +
> +
>  #define QFLAG_APPLY_ONCE 	0x1
>  #define QFLAG_APPLIED		0x2
>  #define QFLAG_DONE		(QFLAG_APPLY_ONCE|QFLAG_APPLIED)
> @@ -417,6 +425,12 @@ static struct chipset early_qrk[] __initdata = {
>  	  PCI_BASE_CLASS_BRIDGE, 0, intel_remapping_check },
>  	{ PCI_VENDOR_ID_INTEL, PCI_ANY_ID, PCI_CLASS_DISPLAY_VGA, PCI_ANY_ID,
>  	  QFLAG_APPLY_ONCE, intel_graphics_stolen },
> +	/*
> +	 * HPET on current version of Baytrail platform has accuracy
> +	 * problem, disable it for now
> +	 */
> +	{ PCI_VENDOR_ID_INTEL, 0x0f00,
> +		PCI_CLASS_BRIDGE_HOST, PCI_ANY_ID, 0, force_disable_hpet},
>  	{}
>  };
>  
> diff --git a/arch/x86/kernel/hpet.c b/arch/x86/kernel/hpet.c
> index da85a8e..913e207 100644
> --- a/arch/x86/kernel/hpet.c
> +++ b/arch/x86/kernel/hpet.c
> @@ -88,7 +88,7 @@ static inline void hpet_clear_mapping(void)
>  /*
>   * HPET command line enable / disable
>   */
> -static int boot_hpet_disable;
> +int boot_hpet_disable;
>  int hpet_force_user;
>  static int hpet_verbose;

As long as all those PCI IDs have a buggy HPET, this looks good to me.

hpa, tglx, any preferences?

Thanks,

	Ingo
