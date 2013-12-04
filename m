Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754736Ab3LDG0a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 01:26:30 -0500
Received: from exprod5og105.obsmtp.com ([64.18.0.180]:54795 "HELO
	exprod5og105.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753845Ab3LDG02 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 01:26:28 -0500
MIME-Version: 1.0
In-Reply-To: <20131203135002.GJ1169@mudshark.cambridge.arm.com>
References: <1385976843-13280-1-git-send-email-vkale@apm.com>
	<1385976843-13280-3-git-send-email-vkale@apm.com>
	<20131203135002.GJ1169@mudshark.cambridge.arm.com>
Date: Wed, 4 Dec 2013 11:56:27 +0530
Message-ID: <CAPrCYkewEkD4MvVht88ddW+nUPpzGXd=vCurwzFujiWOJWj2Ow@mail.gmail.com>
Subject: Re: [PATCH V6 2/2] arm64: perf: add support for percpu pmu interrupt
From: Vinayak Kale <vkale@apm.com>
To: Will Deacon <will.deacon@arm.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "patches@apm.com" <patches@apm.com>, "jcm@redhat.com" <jcm@redhat.com>,
        "sboyd@codeaurora.org" <sboyd@codeaurora.org>,
        Marc Zyngier <Marc.Zyngier@arm.com>, Tuan Phan <tphan@apm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 3, 2013 at 7:20 PM, Will Deacon <will.deacon@arm.com> wrote:
> On Mon, Dec 02, 2013 at 09:34:03AM +0000, Vinayak Kale wrote:
>>  static void
>> +armpmu_disable_percpu_irq(void *data)
>> +{
>> +     struct arm_pmu *armpmu = data;
>> +     struct platform_device *pmu_device = armpmu->plat_device;
>> +     int irq = platform_get_irq(pmu_device, 0);
>> +
>> +     cpumask_test_and_clear_cpu(smp_processor_id(), &armpmu->active_irqs);
>
> Why not just cpumask_clear_cpu?

Yes, that would have serve the purpose. It was due to dumb copy/paste
from non-percpu counterpart.

>
>> +     disable_percpu_irq(irq);
>> +}
>> +
>> +static void
>>  armpmu_release_hardware(struct arm_pmu *armpmu)
>>  {
>> -     int i, irq, irqs;
>> +     int irq;
>> +     unsigned int i, irqs;
>>       struct platform_device *pmu_device = armpmu->plat_device;
>>
>>       irqs = min(pmu_device->num_resources, num_possible_cpus());
>> +     if (!irqs)
>> +             return;
>>
>> -     for (i = 0; i < irqs; ++i) {
>> -             if (!cpumask_test_and_clear_cpu(i, &armpmu->active_irqs))
>> -                     continue;
>> -             irq = platform_get_irq(pmu_device, i);
>> -             if (irq >= 0)
>> -                     free_irq(irq, armpmu);
>> +     irq = platform_get_irq(pmu_device, 0);
>> +     if (irq <= 0)
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
>> +                     if (irq > 0)
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
>> +     enable_percpu_irq(irq, IRQ_TYPE_NONE);
>> +     cpumask_set_cpu(smp_processor_id(), &armpmu->active_irqs);
>
> Hmm, wouldn't it make more sense to pass the irq in data, then deal with the
> mask in the caller? (since the mask will *always* be updated by each CPU).
>
> Similarly for the disable path.

Okay.
