Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756993AbbAIOX0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 09:23:26 -0500
Received: from mail-wi0-f181.google.com ([209.85.212.181]:62476 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751003AbbAIOXZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 09:23:25 -0500
Message-ID: <54AFE45C.2050607@linaro.org>
Date: Fri, 09 Jan 2015 14:23:24 +0000
From: Daniel Thompson <daniel.thompson@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Will Deacon <will.deacon@arm.com>
CC: Russell King <linux@arm.linux.org.uk>,
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
Subject: Re: [PATCH v3] arm: perf: Directly handle SMP platforms with one
 SPI
References: <1416581603-30557-1-git-send-email-daniel.thompson@linaro.org> <1420633698-11742-1-git-send-email-daniel.thompson@linaro.org> <20150108173019.GV11583@arm.com>
In-Reply-To: <20150108173019.GV11583@arm.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/01/15 17:30, Will Deacon wrote:
> Hi Daniel,
> 
> Some minor comments below...
> 
> On Wed, Jan 07, 2015 at 12:28:18PM +0000, Daniel Thompson wrote:
>> Some ARM platforms mux the PMU interrupt of every core into a single
>> SPI. On such platforms if the PMU of any core except 0 raises an interrupt
>> then it cannot be serviced and eventually, if you are lucky, the spurious
>> irq detection might forcefully disable the interrupt.
>>
>> On these SoCs it is not possible to determine which core raised the
>> interrupt so workaround this issue by queuing irqwork on the other
>> cores whenever the primary interrupt handler is unable to service the
>> interrupt.
>>
>> The u8500 platform has an alternative workaround that dynamically alters
>> the affinity of the PMU interrupt. This workaround logic is no longer
>> required so the original code is removed as is the hook it relied upon.
>>
>> Tested on imx6q (which has fours cores/PMUs all muxed to a single SPI).
>>
>> Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
> 
> [...]
> 
>> diff --git a/arch/arm/kernel/perf_event_cpu.c b/arch/arm/kernel/perf_event_cpu.c
>> index dd9acc95ebc0..3d51c5f442eb 100644
>> --- a/arch/arm/kernel/perf_event_cpu.c
>> +++ b/arch/arm/kernel/perf_event_cpu.c
>> @@ -59,6 +59,116 @@ int perf_num_counters(void)
>>  }
>>  EXPORT_SYMBOL_GPL(perf_num_counters);
>>
>> +#ifdef CONFIG_SMP
>> +/*
>> + * Workaround logic that is distributed to all cores if the PMU has only
>> + * a single IRQ and the CPU receiving that IRQ cannot handle it. Its
>> + * job is to try to service the interrupt on the current CPU. It will
>> + * also enable the IRQ again if all the other CPUs have already tried to
>> + * service it.
>> + */
>> +static void cpu_pmu_do_percpu_work(struct irq_work *w)
>> +{
>> +       struct pmu_hw_events *hw_events =
>> +           container_of(w, struct pmu_hw_events, work);
>> +       struct arm_pmu *cpu_pmu = hw_events->percpu_pmu;
>> +
>> +       atomic_set(&hw_events->work_ret,
>> +                  cpu_pmu->handle_irq(0, cpu_pmu));
> 
> Do you need a memory barrier here, or is that implued by enable_irq?

We are more getting away without a memory barrier... the spurious
interrupt detector won't really mind if we see an out of date value
(since it can tolerate getting the value wrong sometimes).

I think we can moot this issue though by removing the code. See below...


>> +       if (atomic_dec_and_test(&cpu_pmu->remaining_work))
>> +               enable_irq(cpu_pmu->muxed_spi_workaround_irq);
>> +}
>> +
>> +/*
>> + * Called when the main interrupt handler cannot determine the source
>> + * of interrupt. It will deploy a workaround if we are running on an SMP
>> + * platform with only a single muxed SPI.
>> + *
>> + * The workaround disables the interrupt and distributes irqwork to all
>> + * other processors in the system. Hopefully one of them will clear the
>> + * interrupt...
>> + */
>> +static irqreturn_t cpu_pmu_handle_irq_none(int irq_num, struct arm_pmu *cpu_pmu)
>> +{
>> +       irqreturn_t ret = IRQ_NONE;
>> +       cpumask_t deploy_on_mask;
>> +       int cpu, work_ret;
>> +       if (irq_num != cpu_pmu->muxed_spi_workaround_irq)
>> +               return IRQ_NONE;
> 
> return ret ?

In general I prefer only to take return variables from variables on
control paths where the return value is not constant.

However this will also become moot if I remove the work_ret logic.


>> +
>> +       disable_irq_nosync(cpu_pmu->muxed_spi_workaround_irq);
>> +
>> +       cpumask_copy(&deploy_on_mask, cpu_online_mask);
>> +       cpumask_clear_cpu(smp_processor_id(), &deploy_on_mask);
>> +       atomic_add(cpumask_weight(&deploy_on_mask), &cpu_pmu->remaining_work);
>> +       smp_mb__after_atomic();
> 
> What's this barrier needed for?

It pairs up with the implicit barrier in atomic_dec_and_test() and
ensures the increment happens before the decrement (and therefore that
the interrupt will be re-enabled).

It can be removed providing we can rely on there being an implicit
barrier in irq_work_queue_on(). Internally this function uses
arch_send_call_function_single_ipi() there is definitely a barrier for
that all current arm and arm64 platforms.

I will remove this.


>> +
>> +       for_each_cpu(cpu, &deploy_on_mask) {
> 
> Why not for_each_online_cpu and then continue if cpu == smp_processor_id() ?
> I  assume the race against hotplug is benign, as the interrupt will no longer
> be asserted to the GIC if the source CPU goes offline?

If cpu_online_mask changes after we have performed the atomic_add() but
before (or during) the loop then we would mis-manage the value of
remaining_work might fail to re-enable the interrupt.


>> +               struct pmu_hw_events *hw_events =
>> +                   per_cpu_ptr(cpu_pmu->hw_events, cpu);
>> +
>> +               /*
>> +                * The workaround code exits immediately without waiting to
>> +                * see if the interrupt was handled by another CPU. This makes
>> +                * it hard for us to decide between IRQ_HANDLED and IRQ_NONE.
>> +                * However, the handler isn't shared so we don't have to worry
>> +                * about being a good citizen, only about keeping the spurious
>> +                * interrupt detector working. This allows us to return the
>> +                * result of our *previous* attempt to deploy workaround.
>> +                */
>> +               work_ret = atomic_read(&hw_events->work_ret);
>> +               if (work_ret != IRQ_NONE)
>> +                       ret = work_ret;
> 
> Is this actually necessary, or can we always return handled?

Ultimately it depends if we need the spurious interrupt detection logic
to work. The work_ret approach is rather nasty (and most of your review
comments are linked to it one way or another). Thus I think I'm OK to
remove this altogether; spurious interrupts are very unlikely for the
PMU IRQ.


>> +
>> +               if (!irq_work_queue_on(&hw_events->work, cpu))
>> +                       if (atomic_dec_and_test(&cpu_pmu->remaining_work))
> 
> I'm not convinced that we can't have old work racing on the remaining work
> field with a subsequent interrupt.

I don't think that can happen.

For the interrupt to be re-enabled all cores must the started executing
their irq_work handlers and called atomic_dec_and_test(). Even though
they may not have completed the pending flag is cleared before they are
called making it safe to re-trigger them.

In fact even if that were not the case the error path for
irq_work_queue_on() would resolve the problem for us (at the cost of
re-entering the interrupt handler during races).


>> +                               enable_irq(cpu_pmu->muxed_spi_workaround_irq);
> 
> "This function (enable_irq) may be called from IRQ context only when
>  desc->irq_data.chip->bus_lock and desc->chip->bus_sync_unlock are NULL !"
> 
> Can we guarantee that in the general case?

For the PMU I think we can.

The irqchips that use these callbacks are found in one of the following
directories:

  arch/mips
  drivers/base/regmap
  drivers/gpio
  drivers/mfd
  drivers/platform/x86

All of above would be a pretty astonishing way to hook up an intimate
peripheral like the PMU.

>> +       }
>> +
>> +       return ret;
>> +}
>> +
>> +static int cpu_pmu_muxed_spi_workaround_init(struct arm_pmu *cpu_pmu)
>> +{
>> +       struct platform_device *pmu_device = cpu_pmu->plat_device;
>> +       int cpu;
>> +
>> +       for_each_possible_cpu(cpu) {
>> +               struct pmu_hw_events *hw_events =
>> +                   per_cpu_ptr(cpu_pmu->hw_events, cpu);
>> +
>> +               init_irq_work(&hw_events->work, cpu_pmu_do_percpu_work);
>> +               atomic_set(&hw_events->work_ret, IRQ_HANDLED);
>> +       }
>> +
>> +       aomic_set(cpu_pmu->remaining_work, 0);
> 
> So you didn't even build this...

Oh no.

I built... I found that typo... I fixed... I soak tested for an hour on
i.MX6 (because I had changed the function from which we deploy the
workaround since v2).

After all that overlooking regenerating the patch before posting it
really was rather foolish.

Sorry.

BTW I have just done a side by side diff with what I posted and what is
in my git repo. The only other difference between what I tested and what
I posted was a minor whitespace change.
