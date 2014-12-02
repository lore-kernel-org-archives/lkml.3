Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933152AbaLBVdQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 16:33:16 -0500
Received: from mail-wg0-f49.google.com ([74.125.82.49]:64571 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932844AbaLBVdP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 16:33:15 -0500
Message-ID: <547E3012.30508@linaro.org>
Date: Tue, 02 Dec 2014 21:33:06 +0000
From: Daniel Thompson <daniel.thompson@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Mark Rutland <mark.rutland@arm.com>
CC: Russell King <linux@arm.linux.org.uk>, Will Deacon <Will.Deacon@arm.com>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "patches@linaro.org" <patches@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Sascha Hauer <kernel@pengutronix.de>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>, Shawn Guo <shawn.guo@linaro.org>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Lucas Stach <l.stach@pengutronix.de>
Subject: Re: [PATCH] arm: perf: Directly handle SMP platforms with one SPI
References: <1416581603-30557-1-git-send-email-daniel.thompson@linaro.org> <1417021147-20735-1-git-send-email-daniel.thompson@linaro.org> <20141202144914.GK23671@leverpostej>
In-Reply-To: <20141202144914.GK23671@leverpostej>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/12/14 14:49, Mark Rutland wrote:
> Hi Daniel,
> 
> On Wed, Nov 26, 2014 at 04:59:07PM +0000, Daniel Thompson wrote:
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
> 
> I agree that the workaround for this design "feature" should live in the
> architectural perf code rather than in board files.
> 
> I had intended to implement that atop of my heterogeneous CPUs series
> [1] (so as to only target the subset of cores for a given PMU), but I
> only had an affinity bouncing implementation, and the general approach
> looks like it has the potential to be far better in terms of latency.
> 
> Hwoever, I have some concerns with the implementation below.
> 
>>
>> Tested on imx6q (which has fours cores/PMUs all muxed to a single SPI).
>>
>> Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
>> ---
>>
>> Notes:
>>     v2:
>>      * Fixed build problems on systems without SMP.
>>
>>     v1:
>>      * Thanks to Lucas Stach, Russell King and Thomas Gleixner for
>>        critiquing an older, completely different way to tackle the
>>        same problem.
>>
>>
>>  arch/arm/include/asm/pmu.h       |  12 ++++
>>  arch/arm/kernel/perf_event.c     |  13 ++--
>>  arch/arm/kernel/perf_event_cpu.c | 126 +++++++++++++++++++++++++++++++++++++++
>>  arch/arm/mach-ux500/cpu-db8500.c |  29 ---------
>>  4 files changed, 143 insertions(+), 37 deletions(-)
>>
>> diff --git a/arch/arm/include/asm/pmu.h b/arch/arm/include/asm/pmu.h
>> index 0b648c541293..771201ff0988 100644
>> --- a/arch/arm/include/asm/pmu.h
>> +++ b/arch/arm/include/asm/pmu.h
>> @@ -81,6 +81,12 @@ struct pmu_hw_events {
>>         raw_spinlock_t          pmu_lock;
>>  };
>>
>> +struct arm_pmu_work {
>> +       struct irq_work work;
>> +       struct arm_pmu *arm_pmu;
>> +       atomic_t ret;
>> +};
>> +
>>  struct arm_pmu {
>>         struct pmu      pmu;
>>         cpumask_t       active_irqs;
>> @@ -108,6 +114,12 @@ struct arm_pmu {
>>         u64             max_period;
>>         struct platform_device  *plat_device;
>>         struct pmu_hw_events    *(*get_hw_events)(void);
>> +#ifdef CONFIG_SMP
>> +       irqreturn_t     (*handle_irq_none)(struct arm_pmu *);
> 
> I don't think this needs to live on the struct arm_pmu; we're unlikely
> to need a different callback given this is already generic to CPUs, so
> we can just call it directly.
> 
> Once Will's arm-perf-3.19 tag hits mainline (with my perf cleanups
> series) the CCI will be decoupled [2] and the arm_pmu framework will
> only be used by CPU PMUs.

I didn't much like this either but it allowed all the workaround code to
be in the same place (and to easily decide whether to deploy the
workaround).

I will take a closer look at the new code.


>> +       int             single_irq;
> 
> With my heterogeneous PMUs series you shouldn't need this, there will be
> an irq_map with a single entry instead.

Ok.


>> +       struct arm_pmu_work __percpu *work;
> 
> In my cleanups series I folded all the percpu data into the
> pmu_hw_events. It would be nice to fold this too if possible, so as to
> make allocation and freeing simpler. We already have a percpu_pmu
> pointer with my series applied, so we don't need the arm_pmu pointer.

I'll have a look. All this codes needs is for an irq_work structure and
arm_pmu pointer to be part of the same structure (for container_of).


> If it feels like we're straying too far from hw events data we can
> rename the structure to pmu_cpu_data or something like that.
> 
>> +       atomic_t        remaining_work;
>> +#endif
>>  };
>>
>>  #define to_arm_pmu(p) (container_of(p, struct arm_pmu, pmu))
>> diff --git a/arch/arm/kernel/perf_event.c b/arch/arm/kernel/perf_event.c
>> index b50a770f8c99..ba67d6309e1e 100644
>> --- a/arch/arm/kernel/perf_event.c
>> +++ b/arch/arm/kernel/perf_event.c
>> @@ -306,22 +306,19 @@ validate_group(struct perf_event *event)
>>  static irqreturn_t armpmu_dispatch_irq(int irq, void *dev)
>>  {
>>         struct arm_pmu *armpmu;
>> -       struct platform_device *plat_device;
>> -       struct arm_pmu_platdata *plat;
>>         int ret;
>>         u64 start_clock, finish_clock;
>>
>>         if (irq_is_percpu(irq))
>>                 dev = *(void **)dev;
>>         armpmu = dev;
>> -       plat_device = armpmu->plat_device;
>> -       plat = dev_get_platdata(&plat_device->dev);
>>
>>         start_clock = sched_clock();
>> -       if (plat && plat->handle_irq)
>> -               ret = plat->handle_irq(irq, dev, armpmu->handle_irq);
>> -       else
>> -               ret = armpmu->handle_irq(irq, dev);
>> +       ret = armpmu->handle_irq(irq, dev);
>> +#ifdef CONFIG_SMP
>> +       if (ret == IRQ_NONE && armpmu->handle_irq_none)
>> +               ret = armpmu->handle_irq_none(dev);
>> +#endif
>>         finish_clock = sched_clock();
>>
>>         perf_sample_event_took(finish_clock - start_clock);
>> diff --git a/arch/arm/kernel/perf_event_cpu.c b/arch/arm/kernel/perf_event_cpu.c
>> index eb2c4d55666b..5605d4a4c01f 100644
>> --- a/arch/arm/kernel/perf_event_cpu.c
>> +++ b/arch/arm/kernel/perf_event_cpu.c
>> @@ -88,6 +88,120 @@ static void cpu_pmu_disable_percpu_irq(void *data)
>>         disable_percpu_irq(irq);
>>  }
>>
>> +#ifdef CONFIG_SMP
>> +
>> +/*
>> + * Workaround logic that is distributed to all cores if the PMU has only
>> + * a single IRQ and the CPU receiving that IRQ cannot handle it. Its
>> + * job is to try to service the interrupt on the current CPU. It will
>> + * also enable the IRQ again if all the other CPUs have already tried to
>> + * service it.
>> + */
>> +static void cpu_pmu_do_percpu_work(struct irq_work *w)
>> +{
>> +       struct arm_pmu_work *work = container_of(w, struct arm_pmu_work, work);
>> +       struct arm_pmu *cpu_pmu = work->arm_pmu;
>> +
>> +       atomic_set(&work->ret,
>> +                  cpu_pmu->handle_irq(cpu_pmu->single_irq, cpu_pmu));
>> +
>> +       if (atomic_dec_and_test(&cpu_pmu->remaining_work))
>> +               enable_irq(cpu_pmu->single_irq);
>> +}
>> +
>> +/*
>> + * This callback, which is enabled only on SMP platforms that are
>> + * running with a single IRQ, is called when the PMU handler running in
>> + * the current CPU cannot service the interrupt.
>> + *
>> + * It will disable the interrupt and distribute irqwork to all other
>> + * processors in the system. Hopefully one of them will clear the
>> + * interrupt...
>> + */
>> +static irqreturn_t cpu_pmu_handle_irq_none(struct arm_pmu *cpu_pmu)
>> +{
>> +       int num_online = num_online_cpus();
>> +       irqreturn_t ret = IRQ_NONE;
>> +       int cpu, cret;
> 
> s/cret/cpu_ret/ -- it's slightly more typing but easier to read IMO.

Ok.

>> +
>> +       if (num_online <= 1)
>> +               return IRQ_NONE;
> 
> Surely num_online can never be below one here?

You are right. This check will probably never fire and, even if it did,
the code below will (mostly) cope.

> We didn't get the online CPUs, so can't other CPUs may shut down between
> the call to num_online_cpus() and portions of the below code?
>
> Could that prevent us from re-enabling the interrupt? Or are we
> protected from that someehow?

We can't get_online_cpus() since we are running in an interrupt handler.

Still looking at the least racy way to handle that...

We could copy the online mask and use that to manipulate the atomic and
iterate over the map. That would make it impossible for the workaround
function to mismanage remaining_work although we do rely on the
irq_work_queue_on() actually resulting in the work being done. It looks
like that code relies on winning a race with the CPU_DYING notifier
chain to achieve that but I'm not 100% sure.


>> +
>> +       disable_irq_nosync(cpu_pmu->single_irq);
>> +       atomic_add(num_online, &cpu_pmu->remaining_work);
>> +       smp_mb__after_atomic();
>> +
>> +       for_each_online_cpu(cpu) {
>> +               struct arm_pmu_work *work = per_cpu_ptr(cpu_pmu->work, cpu);
>> +
>> +               if (cpu == smp_processor_id())
>> +                       continue;
>> +
>> +               /*
>> +                * We can be extremely relaxed about memory ordering
>> +                * here. All we are doing is gathering information
>> +                * about the past to help us give a return value that
>> +                * will keep the spurious interrupt detector both happy
>> +                * *and* functional. We are not shared so we can
>> +                * tolerate the occasional spurious IRQ_HANDLED.
>> +                */
>> +               cret = atomic_read(&work->ret);
>> +               if (cret != IRQ_NONE)
>> +                       ret = cret;
> 
> I'm a little confused as to what's going on here. Why are we checking
> the return code for the work triggered by the _previous_ interrupt
> before queueing up the next work item?

The workaround exits immediately without waiting for the results from
other CPUs. That means we can't figure out whether to return IRQ_NONE or
IRQ_HANDLED.

We could unconditionally return IRQ_HANDLED but this would de-fang the
spurious interrupt detector so instead we use the previous values to
make an informed guess about the likelihood of the interrupt being real.
This code will not trigger the spurious interrupt detector in normal
cases but will if the interrupt really did get wedged due to a bad DT or
something like that.

Should I expand the comment or just return IRQ_HANDLED in all cases?


> As far as I can tell, work_ret was never initialised, so what does this
> do for the first round?

Sends back a stupid value. I'll fix this.

>> +
>> +               if (!irq_work_queue_on(&work->work, cpu))
>> +                       atomic_dec(&cpu_pmu->remaining_work);
> 
> What context does queued work run in? Will we sample the expected set of
> registers (e.g. can we sample userspace)?

hardirq, sampling userspace should not be a problem (and was working
fine in my tests).

>> +       }
>> +
>> +       if (atomic_dec_and_test(&cpu_pmu->remaining_work))
>> +               enable_irq(cpu_pmu->single_irq);
> 
> If we initialise remaining work to the number of CPUs minus one, we can
> drop this last bit, and another CPU will always re-enable the interrupt.

My code originally did that but if we do that then we have to add an
atomic_dec_and_test()/enable_irq() into the main loop. I didn't really
like that because it was harder to scan for mismatched up disable/enables.

I've no idea how the extra atomic manipulation trades off against the
extra memory barriers if we use atomic_dec_and_test() in the loop.

> 
>> +
>> +       return ret;
>> +}
>> +
>> +static int cpu_pmu_single_irq_workaround_init(struct arm_pmu *cpu_pmu)
>> +{
>> +       struct platform_device *pmu_device = cpu_pmu->plat_device;
>> +       int cpu;
>> +
>> +       cpu_pmu->handle_irq_none = cpu_pmu_handle_irq_none;
>> +       cpu_pmu->single_irq = platform_get_irq(pmu_device, 0);
>> +
>> +       cpu_pmu->work = alloc_percpu(struct arm_pmu_work);
>> +       if (!cpu_pmu->work) {
>> +               pr_err("no memory for shared IRQ workaround\n");
>> +               return -ENOMEM;
>> +       }
>> +
>> +       for_each_possible_cpu(cpu) {
>> +               struct arm_pmu_work *w = per_cpu_ptr(cpu_pmu->work, cpu);
>> +
>> +               init_irq_work(&w->work, cpu_pmu_do_percpu_work);
>> +               w->arm_pmu = cpu_pmu;
>> +       }
>> +
>> +       return 0;
>> +}
>> +
>> +static void cpu_pmu_single_irq_workaround_term(struct arm_pmu *cpu_pmu)
>> +{
>> +       cpu_pmu->handle_irq_none = cpu_pmu_handle_irq_none;
> 
> Huh? We set that up identically in cpu_pmu_single_irq_workaround_init.
> 
> I think the handle_irq_none member should go.

Should have been NULL. However if we remove handle_irq_none then there's
no problem here.

> 
>> +       free_percpu(cpu_pmu->work);
>> +}
>> +
>> +#else /* CONFIG_SMP */
>> +
>> +static int cpu_pmu_single_irq_workaround_init(struct arm_pmu *cpu_pmu)
>> +{
>> +       return 0;
>> +}
>> +
>> +static void cpu_pmu_single_irq_workaround_term(struct arm_pmu *cpu_pmu)
>> +{
>> +}
>> +
>> +#endif /* CONFIG_SMP */
>> +
>>  static void cpu_pmu_free_irq(struct arm_pmu *cpu_pmu)
>>  {
>>         int i, irq, irqs;
>> @@ -107,6 +221,8 @@ static void cpu_pmu_free_irq(struct arm_pmu *cpu_pmu)
>>                         if (irq >= 0)
>>                                 free_irq(irq, cpu_pmu);
>>                 }
>> +
>> +               cpu_pmu_single_irq_workaround_term(cpu_pmu);
>>         }
>>  }
>>
>> @@ -162,6 +278,16 @@ static int cpu_pmu_request_irq(struct arm_pmu *cpu_pmu, irq_handler_t handler)
>>
>>                         cpumask_set_cpu(i, &cpu_pmu->active_irqs);
>>                 }
>> +
>> +               /*
>> +                * If we are running SMP and have only one interrupt source
>> +                * then get ready to share that single irq among the cores.
>> +                */
>> +               if (nr_cpu_ids > 1 && irqs == 1) {
>> +                       err = cpu_pmu_single_irq_workaround_init(cpu_pmu);
>> +                       if (err)
>> +                               return err;
>> +               }
> 
> What does this do for systems using PPIs, where there's a single percpu
> interrupt (e.g. Krait)?

This code is not reached on such a system (code here is added to the
else clause of the "am I using PPIs" test).

> 
> Thanks,
> Mark.
> 
> [1] http://lists.infradead.org/pipermail/linux-arm-kernel/2014-November/300748.html
> [2] https://git.kernel.org/cgit/linux/kernel/git/will/linux.git/tag/?h=perf/updates&id=arm-perf-3.19
> [3] https://git.kernel.org/cgit/linux/kernel/git/will/linux.git/commit/?h=perf/updates&id=c6f85cb4305bd80658d19f7b097a7c36ef9912e2
> 

