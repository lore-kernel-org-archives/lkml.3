Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754692Ab3K2L7O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 06:59:14 -0500
Received: from www.linutronix.de ([62.245.132.108]:33264 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753168Ab3K2L7I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 06:59:08 -0500
Date: Fri, 29 Nov 2013 12:58:48 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Preeti U Murthy <preeti@linux.vnet.ibm.com>
cc: fweisbec@gmail.com, paul.gortmaker@windriver.com, paulus@samba.org,
        shangw@linux.vnet.ibm.com, rjw@sisk.pl, galak@kernel.crashing.org,
        benh@kernel.crashing.org, paulmck@linux.vnet.ibm.com, arnd@arndb.de,
        linux-pm@vger.kernel.org, rostedt@goodmis.org, michael@ellerman.id.au,
        john.stultz@linaro.org, chenhui.zhao@freescale.com,
        deepthi@linux.vnet.ibm.com, r58472@freescale.com, geoff@infradead.org,
        linux-kernel@vger.kernel.org, srivatsa.bhat@linux.vnet.ibm.com,
        schwidefsky@de.ibm.com, svaidy@linux.vnet.ibm.com,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH V4 6/9] cpuidle/ppc: Add basic infrastructure to enable
 the broadcast framework on ppc
In-Reply-To: <20131129104303.651.40279.stgit@preeti.in.ibm.com>
Message-ID: <alpine.DEB.2.02.1311291256180.30673@ionos.tec.linutronix.de>
References: <20131129104010.651.23117.stgit@preeti.in.ibm.com> <20131129104303.651.40279.stgit@preeti.in.ibm.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 Nov 2013, Preeti U Murthy wrote:
> diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
> index b44b52c..cafa788 100644
> --- a/arch/powerpc/Kconfig
> +++ b/arch/powerpc/Kconfig
> @@ -129,6 +129,8 @@ config PPC
>  	select GENERIC_CMOS_UPDATE
>  	select GENERIC_TIME_VSYSCALL_OLD
>  	select GENERIC_CLOCKEVENTS
> +	select GENERIC_CLOCKEVENTS_BROADCAST
> +	select ARCH_HAS_TICK_BROADCAST if GENERIC_CLOCKEVENTS_BROADCAST

What's the point of this config switch? It's nowhere used.

> +static int broadcast_set_next_event(unsigned long evt,
> +					struct clock_event_device *dev)
> +{
> +	return 0;
> +}
> +
> +static void broadcast_set_mode(enum clock_event_mode mode,
> +				 struct clock_event_device *dev)
> +{
> +	if (mode != CLOCK_EVT_MODE_ONESHOT)
> +		broadcast_set_next_event(DECREMENTER_MAX, dev);

What's the point of calling an empty function?  

> +}
> +
>  static void decrementer_set_mode(enum clock_event_mode mode,
>  				 struct clock_event_device *dev)
>  {
> @@ -840,6 +869,19 @@ static void register_decrementer_clockevent(int cpu)
>  	clockevents_register_device(dec);
>  }
>  
> +static void register_broadcast_clockevent(int cpu)
> +{
> +	struct clock_event_device *bc_evt = &bc_timer;
> +
> +	*bc_evt = broadcast_clockevent;
> +	bc_evt->cpumask = cpu_possible_mask;
> +
> +	printk_once(KERN_DEBUG "clockevent: %s mult[%x] shift[%d] cpu[%d]\n",
> +		    bc_evt->name, bc_evt->mult, bc_evt->shift, cpu);
> +
> +	clockevents_register_device(bc_evt);
> +}
> +
>  static void __init init_decrementer_clockevent(void)
>  {
>  	int cpu = smp_processor_id();
> @@ -854,6 +896,19 @@ static void __init init_decrementer_clockevent(void)
>  	register_decrementer_clockevent(cpu);
>  }
>  
> +static void __init init_broadcast_clockevent(void)
> +{
> +	int cpu = smp_processor_id();
> +
> +	clockevents_calc_mult_shift(&broadcast_clockevent, ppc_tb_freq, 4);
> +
> +	broadcast_clockevent.max_delta_ns =
> +		clockevent_delta2ns(DECREMENTER_MAX, &broadcast_clockevent);
> +	broadcast_clockevent.min_delta_ns =
> +		clockevent_delta2ns(2, &broadcast_clockevent);

clockevents_config()

Thanks,

	tglx
