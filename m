Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755602AbbAWRZ5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 12:25:57 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:42163 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752006AbbAWRZz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 12:25:55 -0500
Date: Fri, 23 Jan 2015 17:25:28 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Daniel Thompson <daniel.thompson@linaro.org>
Cc: Russell King <linux@arm.linux.org.uk>, Will Deacon <Will.Deacon@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Shawn Guo <shawn.guo@linaro.org>, Sascha Hauer <kernel@pengutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Lucas Stach <l.stach@pengutronix.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        "patches@linaro.org" <patches@linaro.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        John Stultz <john.stultz@linaro.org>,
        Sumit Semwal <sumit.semwal@linaro.org>
Subject: Re: [PATCH v5] arm: perf: Directly handle SMP platforms with one SPI
Message-ID: <20150123172528.GA10424@leverpostej>
References: <1416581603-30557-1-git-send-email-daniel.thompson@linaro.org>
 <1421756735-19699-1-git-send-email-daniel.thompson@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421756735-19699-1-git-send-email-daniel.thompson@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Daniel,

On Tue, Jan 20, 2015 at 12:25:35PM +0000, Daniel Thompson wrote:
> Some ARM platforms mux the PMU interrupt of every core into a single
> SPI. On such platforms if the PMU of any core except 0 raises an interrupt
> then it cannot be serviced and eventually, if you are lucky, the spurious
> irq detection might forcefully disable the interrupt.
> 
> On these SoCs it is not possible to determine which core raised the
> interrupt so workaround this issue by queuing irqwork on the other
> cores whenever the primary interrupt handler is unable to service the
> interrupt.
> 
> The u8500 platform has an alternative workaround that dynamically alters
> the affinity of the PMU interrupt. This workaround logic is no longer
> required so the original code is removed as is the hook it relied upon.
> 
> Tested on imx6q (which has fours cores/PMUs all muxed to a single SPI)
> using a simple soak, combined perf and CPU hotplug soak and using
> perf fuzzer's fast_repro.sh.
> 
> Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>

[...]

> diff --git a/arch/arm/kernel/perf_event_cpu.c b/arch/arm/kernel/perf_event_cpu.c
> index dd9acc95ebc0..63f7b19a5ebe 100644
> --- a/arch/arm/kernel/perf_event_cpu.c
> +++ b/arch/arm/kernel/perf_event_cpu.c
> @@ -59,6 +59,119 @@ int perf_num_counters(void)
>  }
>  EXPORT_SYMBOL_GPL(perf_num_counters);
> 
> +#ifdef CONFIG_SMP
> +/*
> + * Workaround logic that is distributed to all cores if the PMU has only
> + * a single IRQ and the CPU receiving that IRQ cannot handle it. Its
> + * job is to try to service the interrupt on the current CPU. It will
> + * also enable the IRQ again if all the other CPUs have already tried to
> + * service it.
> + */
> +static void cpu_pmu_do_percpu_work(struct irq_work *w)
> +{
> +       struct pmu_hw_events *hw_events =
> +           container_of(w, struct pmu_hw_events, work);
> +       struct arm_pmu *cpu_pmu = hw_events->percpu_pmu;
> +       int count;
> +
> +       /* Ignore the return code, we can do nothing useful with it */
> +       cpu_pmu->handle_irq(0, cpu_pmu);
> +
> +       count = atomic_dec_return(&cpu_pmu->remaining_irq_work);
> +       if (count == 0)
> +               enable_irq(cpu_pmu->muxed_spi_workaround_irq);
> +
> +       /*
> +        * Recover the count. We warn if we perform any recovery because this
> +        * code is expected to be unreachable except in the case were we lose
> +        * a race during CPU hot unplug (see cpu_pmu_handle_irq_none).
> +        */
> +       if (WARN_ON(unlikely(count < 0)))
> +               atomic_set(&cpu_pmu->remaining_irq_work, 0);

I'm not sure I follow. For this case to occur, we have to have raised
some work on a CPU that we don't think we've raised it on (so that we
perform a decrement both on said CPU and via 'count' in
cpu_pmu_handle_irq_none).

So in cpu_pmu_handle_irq_none we'd have to see the CPU as online, and
irq_work_queue_on would have to succeed yet return false. I can only see
that it can do the oppposite (more on the below).

What am I missing?

> +}
> +
> +/*
> + * Called when the main interrupt handler cannot determine the source
> + * of interrupt. It will deploy a workaround if we are running on an SMP
> + * platform with only a single muxed SPI.
> + *
> + * The workaround disables the interrupt and distributes irqwork to all
> + * other processors in the system. Hopefully one of them will clear the
> + * interrupt...
> + */
> +static irqreturn_t cpu_pmu_handle_irq_none(int irq_num, struct arm_pmu *cpu_pmu)
> +{
> +       int cpu, count = CONFIG_NR_CPUS;

I don't think 'count' is a great name here, as it's really vague (and
due to that, confusing).

You seem to be using it to count the CPUs we don't queue work on.
perhaps 'remaining' or something to that effect would be better.

> +
> +       if (irq_num != cpu_pmu->muxed_spi_workaround_irq)
> +               return IRQ_NONE;
> +
> +       disable_irq_nosync(cpu_pmu->muxed_spi_workaround_irq);
> +
> +       /*
> +        * No worker cpu will decrement remaining_irq_work to zero whilst
> +        * we have added CONFIG_NR_CPUS to it (because the current CPU will
> +        * not have work assigned to it)
> +        */
> +       atomic_add(count, &cpu_pmu->remaining_irq_work);
> +
> +       for_each_online_cpu(cpu) {

There's a fundamental race here, given CPU hotplug isn't inhibited. CPUs
can come up or go down (even repeatedly so), while we read stale values
from the cpu_online_mask.

> +               struct pmu_hw_events *hw_events =
> +                   per_cpu_ptr(cpu_pmu->hw_events, cpu);
> +
> +               if (cpu == smp_processor_id())
> +                       continue;
> +
> +               /*
> +                * There is a short race between reading the online cpu mask in
> +                * the loop logic above and dispatching work to it below. It
> +                * is unlikely we will lose the race (because the code path to
> +                * offline a CPU is relatively long). If we were to lose the
> +                * race then the interrupt will not be re-enabled and perf will
> +                * be broken until stopped and restarted. This is
> +                * not-a-good-thing (tm) but is not as bad as trying to
> +                * schedule a task to re-distribute the interrupt.
> +                */
> +               if (irq_work_queue_on(&hw_events->work, cpu))
> +                       count--;

The return value of irq_work_queue_on also cannot be relied upon if
hotplug is not inhibited. A CPU can go offline concurrently with
irq_work_queue_on, perhaps just before it calls
arch_send_call_function_single_ipi then unconditionally returns true.

So in that case, cpu_pmu->remaining_irq_work will be stuck above zero,
because we're waiting for an offline CPU to decrement it. You're dead
even with the hack in cpu_pmu_do_percpu_work.

Thanks,
Mark.

> +       }
> +
> +       if (atomic_sub_and_test(count, &cpu_pmu->remaining_irq_work))
> +               enable_irq(cpu_pmu->muxed_spi_workaround_irq);
> +
> +       return IRQ_HANDLED;
> +}
