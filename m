Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754637Ab3KTR2y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 12:28:54 -0500
Received: from exprod5og113.obsmtp.com ([64.18.0.26]:34456 "HELO
	exprod5og113.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754301Ab3KTR2v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 12:28:51 -0500
MIME-Version: 1.0
In-Reply-To: <528CB5AC.5080007@arm.com>
References: <1384946021-22100-1-git-send-email-vkale@apm.com>
	<1384946021-22100-3-git-send-email-vkale@apm.com>
	<528CB5AC.5080007@arm.com>
Date: Wed, 20 Nov 2013 22:58:50 +0530
Message-ID: <CAPrCYkcu7wVjoV5Q=pd55Zn8+PR30n3WJ8F6t=qV4BMLhZFcxA@mail.gmail.com>
Subject: Re: [PATCH V4 2/2] arm64: perf: add support for percpu pmu interrupt
From: Vinayak Kale <vkale@apm.com>
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Will Deacon <Will.Deacon@arm.com>, "jcm@redhat.com" <jcm@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>, Tuan Phan <tphan@apm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Marc,

On Wed, Nov 20, 2013 at 6:44 PM, Marc Zyngier <marc.zyngier@arm.com> wrote:
> [dropped patches@apm.com]
>
> Vinayak,
>
> Please keep reviewers on CC, as it makes easier to track the changes.
Sure, will do.
>
> On 20/11/13 11:13, Vinayak Kale wrote:
>> Add support for irq registration when pmu interrupt is percpu.
>>
>> Signed-off-by: Vinayak Kale <vkale@apm.com>
>> Signed-off-by: Tuan Phan <tphan@apm.com>
>> ---
>>  arch/arm64/kernel/perf_event.c |  108 ++++++++++++++++++++++++++++++----------
>>  1 file changed, 81 insertions(+), 27 deletions(-)
>>
>> diff --git a/arch/arm64/kernel/perf_event.c b/arch/arm64/kernel/perf_event.c
>> index cea1594..de12ba8 100644
>> --- a/arch/arm64/kernel/perf_event.c
>> +++ b/arch/arm64/kernel/perf_event.c
>> @@ -22,6 +22,7 @@
>>
>>  #include <linux/bitmap.h>
>>  #include <linux/interrupt.h>
>> +#include <linux/irq.h>
>>  #include <linux/kernel.h>
>>  #include <linux/export.h>
>>  #include <linux/perf_event.h>
>> @@ -363,22 +364,55 @@ validate_group(struct perf_event *event)
>>  }
>>
>>  static void
>> +armpmu_disable_percpu_irq(void *data)
>> +{
>> +     struct arm_pmu *armpmu = data;
>> +     struct platform_device *pmu_device = armpmu->plat_device;
>> +     int irq = platform_get_irq(pmu_device, 0);
>> +
>> +     cpumask_test_and_clear_cpu(smp_processor_id(), &armpmu->active_irqs);
>> +     disable_percpu_irq(irq);
>> +}
>> +
>> +static void
>>  armpmu_release_hardware(struct arm_pmu *armpmu)
>>  {
>>       int i, irq, irqs;
>>       struct platform_device *pmu_device = armpmu->plat_device;
>>
>>       irqs = min(pmu_device->num_resources, num_possible_cpus());
>> +     if (irqs < 1)
>> +             return;
>>
>> -     for (i = 0; i < irqs; ++i) {
>> -             if (!cpumask_test_and_clear_cpu(i, &armpmu->active_irqs))
>> -                     continue;
>> -             irq = platform_get_irq(pmu_device, i);
>> -             if (irq >= 0)
>> -                     free_irq(irq, armpmu);
>> +     irq = platform_get_irq(pmu_device, 0);
>> +     if (irq < 0)
>
> So I'm going to sound like a stuck record: irq == 0 is not a valid IRQ
> number, full stop. This is how we express the fact that there is no IRQ.
>
> If you're touching that code, you might as well fix this buglet.
In Will's existing code, I think he was taking care of 'no IRQ' case
by comparing pmu_device->num_resources. Do you think this is not
enough and we must enforce the check after each platform_get_irq()?
Existing driver code snippet as below for quick reference.

[snip]
static int
armpmu_reserve_hardware(struct arm_pmu *armpmu)
{
        int i, err, irq, irqs;
        struct platform_device *pmu_device = armpmu->plat_device;

        if (!pmu_device) {
                pr_err("no PMU device registered\n");
                return -ENODEV;
        }

        irqs = min(pmu_device->num_resources, num_possible_cpus());
        if (irqs < 1) {
                pr_err("no irqs for PMUs defined\n");
                return -ENODEV;
        }
        for (i = 0; i < irqs; ++i) {
                err = 0;
                irq = platform_get_irq(pmu_device, i);
                if (irq < 0)
                         continue;

[snip]
>
>> +             return;
>> +
>> +     if (irq_is_percpu(irq)) {
>> +             on_each_cpu(armpmu_disable_percpu_irq, armpmu, 1);
>> +             free_percpu_irq(irq, &cpu_hw_events);
>> +     } else {
>> +             for (i = 0; i < irqs; ++i) {
>> +                     if (!cpumask_test_and_clear_cpu(i, &armpmu->active_irqs))
>> +                             continue;
>> +                     irq = platform_get_irq(pmu_device, i);
>> +                     if (irq >= 0)
>
> Same here.
>
>> +                             free_irq(irq, armpmu);
>> +             }
>>       }
>>  }
>>
>> +static void
>> +armpmu_enable_percpu_irq(void *data)
>> +{
>> +     struct arm_pmu *armpmu = data;
>> +     struct platform_device *pmu_device = armpmu->plat_device;
>> +     int irq = platform_get_irq(pmu_device, 0);
>> +
>> +     enable_percpu_irq(irq, 0);
>> +     cpumask_set_cpu(smp_processor_id(), &armpmu->active_irqs);
>> +}
>> +
>>  static int
>>  armpmu_reserve_hardware(struct arm_pmu *armpmu)
>>  {
>> @@ -396,34 +430,54 @@ armpmu_reserve_hardware(struct arm_pmu *armpmu)
>>               return -ENODEV;
>>       }
>>
>> -     for (i = 0; i < irqs; ++i) {
>> -             err = 0;
>> -             irq = platform_get_irq(pmu_device, i);
>> -             if (irq < 0)
>> -                     continue;
>> +     irq = platform_get_irq(pmu_device, 0);
>> +     if (irq < 0) {
>
> And here.
>
>> +             pr_err("failed to get an irq for PMU device\n");
>> +             return -ENODEV;
>> +     }
>>
>> -             /*
>> -              * If we have a single PMU interrupt that we can't shift,
>> -              * assume that we're running on a uniprocessor machine and
>> -              * continue. Otherwise, continue without this interrupt.
>> -              */
>> -             if (irq_set_affinity(irq, cpumask_of(i)) && irqs > 1) {
>> -                     pr_warning("unable to set irq affinity (irq=%d, cpu=%u)\n",
>> -                                 irq, i);
>> -                     continue;
>> -             }
>> +     if (irq_is_percpu(irq)) {
>> +             err = request_percpu_irq(irq, armpmu->handle_irq,
>> +                             "arm-pmu", &cpu_hw_events);
>>
>> -             err = request_irq(irq, armpmu->handle_irq,
>> -                               IRQF_NOBALANCING,
>> -                               "arm-pmu", armpmu);
>>               if (err) {
>> -                     pr_err("unable to request IRQ%d for ARM PMU counters\n",
>> -                             irq);
>> +                     pr_err("unable to request percpu IRQ%d for ARM PMU counters\n",
>> +                                     irq);
>>                       armpmu_release_hardware(armpmu);
>>                       return err;
>>               }
>>
>> -             cpumask_set_cpu(i, &armpmu->active_irqs);
>> +             on_each_cpu(armpmu_enable_percpu_irq, armpmu, 1);
>> +     } else {
>> +             for (i = 0; i < irqs; ++i) {
>> +                     err = 0;
>> +                     irq = platform_get_irq(pmu_device, i);
>> +                     if (irq < 0)
>
> And here.
>
>> +                             continue;
>> +
>> +                     /*
>> +                      * If we have a single PMU interrupt that we can't shift,
>> +                      * assume that we're running on a uniprocessor machine and
>> +                      * continue. Otherwise, continue without this interrupt.
>> +                      */
>> +                     if (irq_set_affinity(irq, cpumask_of(i)) && irqs > 1) {
>> +                             pr_warning("unable to set irq affinity (irq=%d, cpu=%u)\n",
>> +                                             irq, i);
>> +                             continue;
>> +                     }
>> +
>> +                     err = request_irq(irq, armpmu->handle_irq,
>> +                                     IRQF_NOBALANCING,
>> +                                     "arm-pmu", armpmu);
>> +                     if (err) {
>> +                             pr_err("unable to request IRQ%d for ARM PMU counters\n",
>> +                                             irq);
>> +                             armpmu_release_hardware(armpmu);
>> +                             return err;
>> +                     }
>> +
>> +                     cpumask_set_cpu(i, &armpmu->active_irqs);
>> +             }
>>       }
>>
>>       return 0;
>>
>
>         M.
> --
> Jazz is not dead. It just smells funny...
>
