Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751521Ab3KRO4W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 09:56:22 -0500
Received: from exprod5og106.obsmtp.com ([64.18.0.182]:52367 "HELO
	exprod5og106.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751030Ab3KRO4Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 09:56:16 -0500
MIME-Version: 1.0
In-Reply-To: <4103ca6ab0e769ce07a327fcb5ade0d1@www.loen.fr>
References: <1384780949-10922-1-git-send-email-vkale@apm.com>
	<1384780949-10922-3-git-send-email-vkale@apm.com>
	<3545e6650079200b6b364df14ef14a4f@www.loen.fr>
	<CAPrCYkf0KH0zKFrFwG6XK1Kz2dsKUZC1wL5ONhNGvY3BLM8QGQ@mail.gmail.com>
	<4103ca6ab0e769ce07a327fcb5ade0d1@www.loen.fr>
Date: Mon, 18 Nov 2013 20:26:15 +0530
Message-ID: <CAPrCYkdgkwt5mi9kd038cYRcunL4_ujNwjwmqhuu=GjUjuHVDQ@mail.gmail.com>
Subject: Re: [PATCH V3 2/2] arm64: perf: add support for percpu pmu interrupt
From: Vinayak Kale <vkale@apm.com>
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Will Deacon <will.deacon@arm.com>, patches <patches@apm.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "jcm@redhat.com" <jcm@redhat.com>, tglx <tglx@linutronix.de>,
        Tuan Phan <tphan@apm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 18, 2013 at 8:10 PM, Marc Zyngier <marc.zyngier@arm.com> wrote:
> On 2013-11-18 14:18, Vinayak Kale wrote:
>>
>> On Mon, Nov 18, 2013 at 7:16 PM, Marc Zyngier <marc.zyngier@arm.com>
>> wrote:
>>>
>>> Vinayak,
>>>
>>>
>>> On 2013-11-18 13:22, Vinayak Kale wrote:
>>>>
>>>>
>>>> Add support for irq registration when pmu interrupt is percpu.
>>>>
>>>> Signed-off-by: Vinayak Kale <vkale@apm.com>
>>>> Signed-off-by: Tuan Phan <tphan@apm.com>
>>>> ---
>>>>  arch/arm64/kernel/perf_event.c |  102
>>>> +++++++++++++++++++++++++++++-----------
>>>>  1 file changed, 74 insertions(+), 28 deletions(-)
>>>>
>>>> diff --git a/arch/arm64/kernel/perf_event.c
>>>> b/arch/arm64/kernel/perf_event.c
>>>> index cea1594..23475f6 100644
>>>> --- a/arch/arm64/kernel/perf_event.c
>>>> +++ b/arch/arm64/kernel/perf_event.c
>>>> @@ -22,6 +22,7 @@
>>>>
>>>>  #include <linux/bitmap.h>
>>>>  #include <linux/interrupt.h>
>>>> +#include <linux/irq.h>
>>>>  #include <linux/kernel.h>
>>>>  #include <linux/export.h>
>>>>  #include <linux/perf_event.h>
>>>> @@ -363,22 +364,51 @@ validate_group(struct perf_event *event)
>>>>  }
>>>>
>>>>  static void
>>>> +armpmu_disable_percpu_irq(void *data)
>>>> +{
>>>> +       struct arm_pmu *armpmu = data;
>>>> +       struct platform_device *pmu_device = armpmu->plat_device;
>>>> +       int irq = platform_get_irq(pmu_device, 0);
>>>> +
>>>> +       cpumask_test_and_clear_cpu(smp_processor_id(),
>>>> &armpmu->active_irqs);
>>>> +       disable_percpu_irq(irq);
>>>> +}
>>>> +
>>>> +static void
>>>>  armpmu_release_hardware(struct arm_pmu *armpmu)
>>>>  {
>>>>         int i, irq, irqs;
>>>>         struct platform_device *pmu_device = armpmu->plat_device;
>>>>
>>>> -       irqs = min(pmu_device->num_resources, num_possible_cpus());
>>>> +       irq = platform_get_irq(pmu_device, 0);
>>>>
>>>> -       for (i = 0; i < irqs; ++i) {
>>>> -               if (!cpumask_test_and_clear_cpu(i,
>>>> &armpmu->active_irqs))
>>>> -                       continue;
>>>> -               irq = platform_get_irq(pmu_device, i);
>>>> -               if (irq >= 0)
>>>> -                       free_irq(irq, armpmu);
>>>> +       if (irq_to_desc(irq) && irq_is_percpu(irq)) {
>>>
>>>
>>>
>>> Why do you need to check the irq_desc here? It really looks like a misuse
>>> of
>>> the API.
>>
>> I don't think it's being misused. In case of invalid irq number, the
>> API would return null.
>
>
> And feeding an error code to irq_to_desc() doesn't disturb you?
Since the API handles the error condition and returns null, so it
won't break stuff.
But I think your earlier suggestion of checking invalid irq number
beforehand is better, since it would help to avoid wasting time in
searching the irq desc.
> Do you call that a normal use of the API? Humfff....
>
>         M.
>
> --
> Fast, cheap, reliable. Pick two.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
