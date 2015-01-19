Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752266AbbASQff (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 11:35:35 -0500
Received: from atl4mhob01.myregisteredsite.com ([209.17.115.39]:56784 "EHLO
	atl4mhob01.myregisteredsite.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751448AbbASQfe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 11:35:34 -0500
X-TCPREMOTEIP: 68.185.59.186
X-Authenticated-UID: joshua.clayton@uniwest.com
From: Joshua Clayton <joshua.clayton@uniwest.com>
To: linux-arm-kernel@lists.infradead.org
Cc: Daniel Thompson <daniel.thompson@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>,
        Russell King <linux@arm.linux.org.uk>, linaro-kernel@lists.linaro.org,
        patches@linaro.org, Stephen Boyd <sboyd@codeaurora.org>,
        linux-kernel@vger.kernel.org, Daniel Drake <drake@endlessm.com>,
        Dmitry Pervushin <dpervushin@gmail.com>,
        Dirk Behme <dirk.behme@de.bosch.com>,
        John Stultz <john.stultz@linaro.org>, Tim Sander <tim@krieglstein.org>,
        Sumit Semwal <sumit.semwal@linaro.org>
Subject: Re: [RFC PATCH 5/5] arm: perf: Use FIQ to handle PMU events.
Date: Mon, 19 Jan 2015 08:35:29 -0800
Message-ID: <2406925.7Z4R9iEkTD@jclayton-pc>
Organization: UniWest
User-Agent: KMail/4.14.1 (Linux/3.8.0-31-generic; KDE/4.14.1; x86_64; ; )
In-Reply-To: <1421166931-14134-6-git-send-email-daniel.thompson@linaro.org>
References: <1421166931-14134-1-git-send-email-daniel.thompson@linaro.org> <1421166931-14134-6-git-send-email-daniel.thompson@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, January 13, 2015 04:35:31 PM Daniel Thompson wrote:
> Using FIQ (if it is available) gives perf a better insight into the
> system by allowing code run with interrupts disabled to be profiled.
> 
> Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
> ---
>  arch/arm/include/asm/pmu.h       |  4 ++++
>  arch/arm/kernel/perf_event.c     |  2 +-
>  arch/arm/kernel/perf_event_cpu.c | 35 ++++++++++++++++++++++++++++++++---
>  arch/arm/kernel/traps.c          |  3 ++-
>  4 files changed, 39 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/arm/include/asm/pmu.h b/arch/arm/include/asm/pmu.h
> index b1596bd59129..2a7ea97a4a14 100644
> --- a/arch/arm/include/asm/pmu.h
> +++ b/arch/arm/include/asm/pmu.h
> @@ -123,6 +123,8 @@ struct arm_pmu {
> 
>  extern const struct dev_pm_ops armpmu_dev_pm_ops;
> 
> +irqreturn_t armpmu_dispatch_irq(int irq, void *dev);
> +
>  int armpmu_register(struct arm_pmu *armpmu, int type);
> 
>  u64 armpmu_event_update(struct perf_event *event);
> @@ -136,6 +138,8 @@ int armpmu_map_event(struct perf_event *event,
>  						[PERF_COUNT_HW_CACHE_RESULT_MAX],
>  		     u32 raw_event_mask);
> 
> +void cpu_pmu_handle_fiq(int irq);
> +
>  struct pmu_probe_info {
>  	unsigned int cpuid;
>  	unsigned int mask;
> diff --git a/arch/arm/kernel/perf_event.c b/arch/arm/kernel/perf_event.c
> index f7c65adaa428..5ae9adf7f18e 100644
> --- a/arch/arm/kernel/perf_event.c
> +++ b/arch/arm/kernel/perf_event.c
> @@ -296,7 +296,7 @@ validate_group(struct perf_event *event)
>  	return 0;
>  }
> 
> -static irqreturn_t armpmu_dispatch_irq(int irq, void *dev)
> +irqreturn_t armpmu_dispatch_irq(int irq, void *dev)
>  {
>  	struct arm_pmu *armpmu;
>  	struct platform_device *plat_device;
> diff --git a/arch/arm/kernel/perf_event_cpu.c
> b/arch/arm/kernel/perf_event_cpu.c index a80309087a7b..5c4e9ce23389 100644
> --- a/arch/arm/kernel/perf_event_cpu.c
> +++ b/arch/arm/kernel/perf_event_cpu.c
> @@ -36,6 +36,9 @@
>  /* Set at runtime when we know what CPU type we are. */
>  static struct arm_pmu *cpu_pmu;
> 
> +/* Allows us to find out if an IRQ is for us (mostly used from NMI context)
> */ +static DEFINE_PER_CPU(int, cpu_pmu_irqs);
> +
>  /*
>   * Despite the names, these two functions are CPU-specific and are used
>   * by the OProfile/perf code.
> @@ -127,6 +130,24 @@ static void cpu_pmu_free_irq(struct arm_pmu *cpu_pmu)
>  	}
>  }
> 
> +/*
> + * This handler is called *unconditionally* from the default NMI/FIQ
> + * handler. The irq may not be anything to do with us so the main
> + * job of this function is to figure out if the irq passed in is ours
> + * or not.
> + */

This comment is an indicator that all the code in cpu_pmu_handle_fiq is
in the wrong place.
It (or something like it) belongs at the level of the default 
FIQ handler, and not in perf_event_cpu.c

> +void cpu_pmu_handle_fiq(int irq)
> +{
> +	int cpu = smp_processor_id();
> +
> +	if (irq != get_cpu_var(cpu_pmu_irqs))
> +		return;
> +
> +	(void)armpmu_dispatch_irq(irq,
> +				  get_cpu_ptr(&cpu_pmu->hw_events->percpu_pmu));
> +}
> +
> +
>  static int cpu_pmu_request_irq(struct arm_pmu *cpu_pmu, irq_handler_t
> handler) {
>  	int i, err, irq, irqs;
> @@ -170,9 +191,16 @@ static int cpu_pmu_request_irq(struct arm_pmu *cpu_pmu,
> irq_handler_t handler) continue;
>  			}
> 
> -			err = request_irq(irq, handler,
> -					  IRQF_NOBALANCING | IRQF_NO_THREAD, "arm-pmu",
> -					  per_cpu_ptr(&hw_events->percpu_pmu, i));
> +			err = request_nmi_irq(
> +			    irq, IRQF_NOBALANCING, "arm-pmu",
> +			    per_cpu_ptr(&hw_events->percpu_pmu, i));
> +			if (err) {
> +				err = request_irq(
> +				    irq, handler,
> +				    IRQF_NOBALANCING | IRQF_NO_THREAD,
> +				    "arm-pmu",
> +				    per_cpu_ptr(&hw_events->percpu_pmu, i));
> +			}
>  			if (err) {
>  				pr_err("unable to request IRQ%d for ARM PMU counters\n",
>  					irq);
> @@ -180,6 +208,7 @@ static int cpu_pmu_request_irq(struct arm_pmu *cpu_pmu,
> irq_handler_t handler) }
> 
>  			cpumask_set_cpu(i, &cpu_pmu->active_irqs);
> +			per_cpu(cpu_pmu_irqs, i) = irq;
>  		}
>  	}
> 
> diff --git a/arch/arm/kernel/traps.c b/arch/arm/kernel/traps.c
> index 74c752b9db68..c581e07517ff 100644
> --- a/arch/arm/kernel/traps.c
> +++ b/arch/arm/kernel/traps.c
> @@ -38,6 +38,7 @@
>  #include <asm/tls.h>
>  #include <asm/system_misc.h>
>  #include <asm/opcodes.h>
> +#include <asm/pmu.h>
> 
> 
>  static const char *handler[]= {
> @@ -485,7 +486,7 @@ asmlinkage void __exception_irq_entry
> handle_fiq_as_nmi(struct pt_regs *regs) irq = gic_ack_fiq();
> 
>  	if (irq) {
> -		/* empty - no SPI handlers (yet) */
> +		cpu_pmu_handle_fiq(irq);
>  	} else {
>  #ifdef CONFIG_SMP
>  		ipi_cpu_backtrace(regs);
> --
> 1.9.3
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel

-- 
Joshua Clayton
Software Engineer
UniWest
122 S. 4th Avenue
Pasco, WA 99301
Ph: (509) 544-0720
Fx: (509) 544-0868 
