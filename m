Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752330Ab3LJHaa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 02:30:30 -0500
Received: from exprod5og109.obsmtp.com ([64.18.0.188]:33228 "HELO
	exprod5og109.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750885Ab3LJHa1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 02:30:27 -0500
MIME-Version: 1.0
In-Reply-To: <20131209165003.GJ13908@mudshark.cambridge.arm.com>
References: <1386151791-4881-1-git-send-email-vkale@apm.com>
	<1386151791-4881-3-git-send-email-vkale@apm.com>
	<20131209165003.GJ13908@mudshark.cambridge.arm.com>
Date: Tue, 10 Dec 2013 13:00:26 +0530
Message-ID: <CAPrCYkfS9h_yoQMcrQDXpW_3FcSfiPz0aeNX+_gc=G4exSEVWg@mail.gmail.com>
Subject: Re: [PATCH V7 2/2] arm64: perf: add support for percpu pmu interrupt
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

Hi Will,


On Mon, Dec 9, 2013 at 10:20 PM, Will Deacon <will.deacon@arm.com> wrote:
> Hi Vinayak,
>
> On Wed, Dec 04, 2013 at 10:09:51AM +0000, Vinayak Kale wrote:
>> Add support for irq registration when pmu interrupt is percpu.
>
> Getting closer...
>
>> Signed-off-by: Vinayak Kale <vkale@apm.com>
>> Signed-off-by: Tuan Phan <tphan@apm.com>
>> ---
>>  arch/arm64/kernel/perf_event.c |  108 +++++++++++++++++++++++++++++-----------
>>  1 file changed, 78 insertions(+), 30 deletions(-)
>>
>> diff --git a/arch/arm64/kernel/perf_event.c b/arch/arm64/kernel/perf_event.c
>> index cea1594..d8e6667 100644
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
>> @@ -363,26 +364,52 @@ validate_group(struct perf_event *event)
>>  }
>>
>>  static void
>> +armpmu_disable_percpu_irq(void *data)
>> +{
>> +     disable_percpu_irq((long)data);
>> +}
>
> Given that we wait for the CPUs to finish enabling/disabling the IRQ, I
> actually meant pass the pointer to the IRQ, which removes the horrible
> casts in the caller.
>
>> +     if (irq_is_percpu(irq)) {
>> +             cpumask_clear(&armpmu->active_irqs);
>
> Thanks for moving the mask manipulation out. It now makes it obvious that we
> don't care about the mask at all for PPIs, so that can be removed (the code
> you have is racy against hotplug anyway).
>
> I took the liberty of writing a fixup for you (see below). Can you test it
> on your platform please?

Below fixup works fine on APM platform.
Do you want me to send this fixup as part of next revision of the
patch or will you apply it yourself? (For later case, you have my ack)

>
> Cheers,
>
> Will
>
> --->8
>
> diff --git a/arch/arm64/kernel/perf_event.c b/arch/arm64/kernel/perf_event.c
> index 503c1eeedc1c..5b1cd792274a 100644
> --- a/arch/arm64/kernel/perf_event.c
> +++ b/arch/arm64/kernel/perf_event.c
> @@ -366,7 +366,8 @@ validate_group(struct perf_event *event)
>  static void
>  armpmu_disable_percpu_irq(void *data)
>  {
> -       disable_percpu_irq((long)data);
> +       unsigned int irq = *(unsigned int *)data;
> +       disable_percpu_irq(irq);
>  }
>
>  static void
> @@ -385,8 +386,7 @@ armpmu_release_hardware(struct arm_pmu *armpmu)
>                 return;
>
>         if (irq_is_percpu(irq)) {
> -               cpumask_clear(&armpmu->active_irqs);
> -               on_each_cpu(armpmu_disable_percpu_irq, (void *)(long)irq, 1);
> +               on_each_cpu(armpmu_disable_percpu_irq, &irq, 1);
>                 free_percpu_irq(irq, &cpu_hw_events);
>         } else {
>                 for (i = 0; i < irqs; ++i) {
> @@ -402,7 +402,8 @@ armpmu_release_hardware(struct arm_pmu *armpmu)
>  static void
>  armpmu_enable_percpu_irq(void *data)
>  {
> -       enable_percpu_irq((long)data, IRQ_TYPE_NONE);
> +       unsigned int irq = *(unsigned int *)data;
> +       enable_percpu_irq(irq, IRQ_TYPE_NONE);
>  }
>
>  static int
> @@ -440,8 +441,7 @@ armpmu_reserve_hardware(struct arm_pmu *armpmu)
>                         return err;
>                 }
>
> -               on_each_cpu(armpmu_enable_percpu_irq, (void *)(long)irq, 1);
> -               cpumask_setall(&armpmu->active_irqs);
> +               on_each_cpu(armpmu_enable_percpu_irq, &irq, 1);
>         } else {
>                 for (i = 0; i < irqs; ++i) {
>                         err = 0;

Acked-by: Vinayak Kale <vkale@apm.com>
