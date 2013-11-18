Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751409Ab3KROSh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 09:18:37 -0500
Received: from exprod5og115.obsmtp.com ([64.18.0.246]:58108 "HELO
	exprod5og115.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750779Ab3KROSc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 09:18:32 -0500
MIME-Version: 1.0
In-Reply-To: <3545e6650079200b6b364df14ef14a4f@www.loen.fr>
References: <1384780949-10922-1-git-send-email-vkale@apm.com>
	<1384780949-10922-3-git-send-email-vkale@apm.com>
	<3545e6650079200b6b364df14ef14a4f@www.loen.fr>
Date: Mon, 18 Nov 2013 19:48:31 +0530
Message-ID: <CAPrCYkf0KH0zKFrFwG6XK1Kz2dsKUZC1wL5ONhNGvY3BLM8QGQ@mail.gmail.com>
Subject: Re: [PATCH V3 2/2] arm64: perf: add support for percpu pmu interrupt
From: Vinayak Kale <vkale@apm.com>
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Will Deacon <will.deacon@arm.com>, patches <patches@apm.com>,
        "jcm@redhat.com" <jcm@redhat.com>, tglx <tglx@linutronix.de>,
        Tuan Phan <tphan@apm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 18, 2013 at 7:16 PM, Marc Zyngier <marc.zyngier@arm.com> wrote:
> Vinayak,
>
>
> On 2013-11-18 13:22, Vinayak Kale wrote:
>>
>> Add support for irq registration when pmu interrupt is percpu.
>>
>> Signed-off-by: Vinayak Kale <vkale@apm.com>
>> Signed-off-by: Tuan Phan <tphan@apm.com>
>> ---
>>  arch/arm64/kernel/perf_event.c |  102
>> +++++++++++++++++++++++++++++-----------
>>  1 file changed, 74 insertions(+), 28 deletions(-)
>>
>> diff --git a/arch/arm64/kernel/perf_event.c
>> b/arch/arm64/kernel/perf_event.c
>> index cea1594..23475f6 100644
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
>> @@ -363,22 +364,51 @@ validate_group(struct perf_event *event)
>>  }
>>
>>  static void
>> +armpmu_disable_percpu_irq(void *data)
>> +{
>> +       struct arm_pmu *armpmu = data;
>> +       struct platform_device *pmu_device = armpmu->plat_device;
>> +       int irq = platform_get_irq(pmu_device, 0);
>> +
>> +       cpumask_test_and_clear_cpu(smp_processor_id(),
>> &armpmu->active_irqs);
>> +       disable_percpu_irq(irq);
>> +}
>> +
>> +static void
>>  armpmu_release_hardware(struct arm_pmu *armpmu)
>>  {
>>         int i, irq, irqs;
>>         struct platform_device *pmu_device = armpmu->plat_device;
>>
>> -       irqs = min(pmu_device->num_resources, num_possible_cpus());
>> +       irq = platform_get_irq(pmu_device, 0);
>>
>> -       for (i = 0; i < irqs; ++i) {
>> -               if (!cpumask_test_and_clear_cpu(i, &armpmu->active_irqs))
>> -                       continue;
>> -               irq = platform_get_irq(pmu_device, i);
>> -               if (irq >= 0)
>> -                       free_irq(irq, armpmu);
>> +       if (irq_to_desc(irq) && irq_is_percpu(irq)) {
>
>
> Why do you need to check the irq_desc here? It really looks like a misuse of
> the API.
I don't think it's being misused. In case of invalid irq number, the
API would return null.
> Instead, you should check the value of irq itself (it should be strictly
> positive).
>
>
>> +               on_each_cpu(armpmu_disable_percpu_irq, armpmu, 1);
>> +               free_percpu_irq(irq, &cpu_hw_events);
>> +       } else {
>> +               irqs = min(pmu_device->num_resources,
>> num_possible_cpus());
>> +
>> +               for (i = 0; i < irqs; ++i) {
>> +                       if (!cpumask_test_and_clear_cpu(i,
>> &armpmu->active_irqs))
>> +                               continue;
>> +                       irq = platform_get_irq(pmu_device, i);
>> +                       if (irq >= 0)
>
>
> irq == 0 means "no-irq". You should handle it as an error case.
This part of the code (for non-percpu irq) was already present in driver as is.
Will was Okay with it as per his review on V1 here:
http://lists.infradead.org/pipermail/linux-arm-kernel/2013-November/210102.html
>
>
>> +                               free_irq(irq, armpmu);
>> +               }
>>         }
>>  }
>>
>> +static void
>> +armpmu_enable_percpu_irq(void *data)
>> +{
>> +       struct arm_pmu *armpmu = data;
>> +       struct platform_device *pmu_device = armpmu->plat_device;
>> +       int irq = platform_get_irq(pmu_device, 0);
>> +
>> +       enable_percpu_irq(irq, 0);
>> +       cpumask_set_cpu(smp_processor_id(), &armpmu->active_irqs);
>> +}
>> +
>>  static int
>>  armpmu_reserve_hardware(struct arm_pmu *armpmu)
>>  {
>> @@ -396,34 +426,50 @@ armpmu_reserve_hardware(struct arm_pmu *armpmu)
>>                 return -ENODEV;
>>         }
>>
>> -       for (i = 0; i < irqs; ++i) {
>> -               err = 0;
>> -               irq = platform_get_irq(pmu_device, i);
>> -               if (irq < 0)
>> -                       continue;
>> +       irq = platform_get_irq(pmu_device, 0);
>>
>> -               /*
>> -                * If we have a single PMU interrupt that we can't shift,
>> -                * assume that we're running on a uniprocessor machine and
>> -                * continue. Otherwise, continue without this interrupt.
>> -                */
>> -               if (irq_set_affinity(irq, cpumask_of(i)) && irqs > 1) {
>> -                       pr_warning("unable to set irq affinity (irq=%d,
>> cpu=%u)\n",
>> -                                   irq, i);
>> -                       continue;
>> -               }
>> +       if (irq_to_desc(irq) && irq_is_percpu(irq)) {
>
>
> Same comment about irq_to_desc.
>
>
>> +               err = request_percpu_irq(irq, armpmu->handle_irq,
>> +                               "arm-pmu", &cpu_hw_events);
>>
>> -               err = request_irq(irq, armpmu->handle_irq,
>> -                                 IRQF_NOBALANCING,
>> -                                 "arm-pmu", armpmu);
>>                 if (err) {
>> -                       pr_err("unable to request IRQ%d for ARM PMU
>> counters\n",
>> -                               irq);
>> +                       pr_err("unable to request percpu IRQ%d for ARM PMU
>> counters\n",
>> +                                       irq);
>>                         armpmu_release_hardware(armpmu);
>>                         return err;
>>                 }
>>
>> -               cpumask_set_cpu(i, &armpmu->active_irqs);
>> +               on_each_cpu(armpmu_enable_percpu_irq, armpmu, 1);
>> +       } else {
>> +               for (i = 0; i < irqs; ++i) {
>> +                       err = 0;
>> +                       irq = platform_get_irq(pmu_device, i);
>> +                       if (irq < 0)
>
>
> Same comment about irq == 0.
This part of the code (for non-percpu irq) was already present in driver as is.
Will was Okay with it as per his review on V1 here:
http://lists.infradead.org/pipermail/linux-arm-kernel/2013-November/210102.html
>
>
>> +                               continue;
>> +
>> +                       /*
>> +                        * If we have a single PMU interrupt that we can't
>> shift,
>> +                        * assume that we're running on a uniprocessor
>> machine and
>> +                        * continue. Otherwise, continue without this
>> interrupt.
>> +                        */
>> +                       if (irq_set_affinity(irq, cpumask_of(i)) && irqs >
>> 1) {
>> +                               pr_warning("unable to set irq affinity
>> (irq=%d, cpu=%u)\n",
>> +                                               irq, i);
>> +                               continue;
>> +                       }
>> +
>> +                       err = request_irq(irq, armpmu->handle_irq,
>> +                                       IRQF_NOBALANCING,
>> +                                       "arm-pmu", armpmu);
>> +                       if (err) {
>> +                               pr_err("unable to request IRQ%d for ARM
>> PMU counters\n",
>> +                                               irq);
>> +                               armpmu_release_hardware(armpmu);
>> +                               return err;
>> +                       }
>> +
>> +                       cpumask_set_cpu(i, &armpmu->active_irqs);
>> +               }
>>         }
>>
>>         return 0;
>
>
> --
> Fast, cheap, reliable. Pick two.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
