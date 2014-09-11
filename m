Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755488AbaIKOEI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 10:04:08 -0400
Received: from mga09.intel.com ([134.134.136.24]:26194 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755444AbaIKOED (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 10:04:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,506,1406617200"; 
   d="scan'208";a="476886056"
Message-ID: <1410444181.7023.25.camel@linux.intel.com>
Subject: Re: Ask help about pre_init_apic_IRQ0()
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Jiang Liu <jiang.liu@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        x86@kernel.org
Date: Thu, 11 Sep 2014 17:03:01 +0300
In-Reply-To: <alpine.DEB.2.10.1409111225380.4178@nanos>
References: <54116106.5090904@linux.intel.com>
	 <alpine.DEB.2.10.1409111225380.4178@nanos>
Organization: Intel Finland Oy
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.5-1+b1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-09-11 at 14:58 +0200, Thomas Gleixner wrote:
[]

> According to the MID code the apbt horror is only used for moorestown.
> Medfield and later use the local apic timer without the apbt nonsense.
> 
> The best thing we can do is to drop moorestown support and get rid of
> that apbt nonsense alltogether.

Alan Cox removed Moorestown (as a platform) support in 2012 IIRC.
So, AFAIK you may safely remove those leftovers.

> I don't think anyone deeply cares about it not being supported from
> 3.18 on. The number of devices which sport a moorestown should be
> pretty limited and the only relevant use case of those is to act as a
> pocket heater with short battery life time. Its pretty pointless to
> update kernels on pocket heaters except for bragging reasons.
> 
> If someone at Intel really thinks that we need to keep moorestown
> alive for other than documentary and sentimental reasons, then we can
> move the apbt setup to x86_init.timers.setup_percpu_clockev(). At that
> point the IOAPIC is setup already, so it should just work. Untested
> patch below.

Suddenly I have one priority work to do and my Medfield tablet doesn't
boot by some reason. I would try to test it as soon as I can.

> 
> Thanks,
> 
> 	tglx
> 
> ------------------
> Index: linux/arch/x86/platform/intel-mid/intel-mid.c
> ===================================================================
> --- linux.orig/arch/x86/platform/intel-mid/intel-mid.c
> +++ linux/arch/x86/platform/intel-mid/intel-mid.c
> @@ -81,26 +81,34 @@ static unsigned long __init intel_mid_ca
>  	return 0;
>  }
>  
> +static void __init intel_mid_setup_bp_timer(void)
> +{
> +	apbt_time_init();
> +	setup_boot_APIC_clock();
> +}
> +
>  static void __init intel_mid_time_init(void)
>  {
>  	sfi_table_parse(SFI_SIG_MTMR, NULL, NULL, sfi_parse_mtmr);
> +
>  	switch (intel_mid_timer_options) {
>  	case INTEL_MID_TIMER_APBT_ONLY:
>  		break;
>  	case INTEL_MID_TIMER_LAPIC_APBT:
> -		x86_init.timers.setup_percpu_clockev = setup_boot_APIC_clock;
> +		/* Use apbt and local apic */
> +		x86_init.timers.setup_percpu_clockev = intel_mid_setup_bp_timer;
>  		x86_cpuinit.setup_percpu_clockev = setup_secondary_APIC_clock;
> -		break;
> +		return;
>  	default:
>  		if (!boot_cpu_has(X86_FEATURE_ARAT))
>  			break;
> +		/* Lapic only, no apbt */
>  		x86_init.timers.setup_percpu_clockev = setup_boot_APIC_clock;
>  		x86_cpuinit.setup_percpu_clockev = setup_secondary_APIC_clock;
>  		return;
>  	}
> -	/* we need at least one APB timer */
> -	pre_init_apic_IRQ0();
> -	apbt_time_init();
> +
> +	x86_init.timers.setup_percpu_clockev = apbt_time_init;
>  }
>  
>  static void intel_mid_arch_setup(void)


-- 
Andy Shevchenko <andriy.shevchenko@intel.com>
Intel Finland Oy

