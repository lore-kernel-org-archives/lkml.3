Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751604Ab3KROkl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 09:40:41 -0500
Received: from inca-roads.misterjones.org ([213.251.177.50]:57341 "EHLO
	inca-roads.misterjones.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751030Ab3KROke (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 09:40:34 -0500
To: Vinayak Kale <vkale@apm.com>
Subject: Re: [PATCH V3 2/2] arm64: perf: add support for percpu pmu interrupt
X-PHP-Originating-Script: 0:main.inc
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Mon, 18 Nov 2013 14:40:32 +0000
From: Marc Zyngier <marc.zyngier@arm.com>
Cc: Will Deacon <will.deacon@arm.com>, patches <patches@apm.com>,
        linux-kernel <linux-kernel@vger.kernel.org>, <jcm@redhat.com>,
        tglx <tglx@linutronix.de>, Tuan Phan <tphan@apm.com>,
        <linux-arm-kernel@lists.infradead.org>
Organization: ARM Ltd
In-Reply-To: <CAPrCYkf0KH0zKFrFwG6XK1Kz2dsKUZC1wL5ONhNGvY3BLM8QGQ@mail.gmail.com>
References: <1384780949-10922-1-git-send-email-vkale@apm.com>
 <1384780949-10922-3-git-send-email-vkale@apm.com>
 <3545e6650079200b6b364df14ef14a4f@www.loen.fr>
 <CAPrCYkf0KH0zKFrFwG6XK1Kz2dsKUZC1wL5ONhNGvY3BLM8QGQ@mail.gmail.com>
Message-ID: <4103ca6ab0e769ce07a327fcb5ade0d1@www.loen.fr>
User-Agent: Roundcube Webmail/0.7.2
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Rcpt-To: vkale@apm.com, will.deacon@arm.com, patches@apm.com, linux-kernel@vger.kernel.org, jcm@redhat.com, tglx@linutronix.de, tphan@apm.com, linux-arm-kernel@lists.infradead.org
X-SA-Exim-Mail-From: marc.zyngier@arm.com
X-SA-Exim-Scanned: No (on cheepnis.misterjones.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013-11-18 14:18, Vinayak Kale wrote:
> On Mon, Nov 18, 2013 at 7:16 PM, Marc Zyngier <marc.zyngier@arm.com> 
> wrote:
>> Vinayak,
>>
>>
>> On 2013-11-18 13:22, Vinayak Kale wrote:
>>>
>>> Add support for irq registration when pmu interrupt is percpu.
>>>
>>> Signed-off-by: Vinayak Kale <vkale@apm.com>
>>> Signed-off-by: Tuan Phan <tphan@apm.com>
>>> ---
>>>  arch/arm64/kernel/perf_event.c |  102
>>> +++++++++++++++++++++++++++++-----------
>>>  1 file changed, 74 insertions(+), 28 deletions(-)
>>>
>>> diff --git a/arch/arm64/kernel/perf_event.c
>>> b/arch/arm64/kernel/perf_event.c
>>> index cea1594..23475f6 100644
>>> --- a/arch/arm64/kernel/perf_event.c
>>> +++ b/arch/arm64/kernel/perf_event.c
>>> @@ -22,6 +22,7 @@
>>>
>>>  #include <linux/bitmap.h>
>>>  #include <linux/interrupt.h>
>>> +#include <linux/irq.h>
>>>  #include <linux/kernel.h>
>>>  #include <linux/export.h>
>>>  #include <linux/perf_event.h>
>>> @@ -363,22 +364,51 @@ validate_group(struct perf_event *event)
>>>  }
>>>
>>>  static void
>>> +armpmu_disable_percpu_irq(void *data)
>>> +{
>>> +       struct arm_pmu *armpmu = data;
>>> +       struct platform_device *pmu_device = armpmu->plat_device;
>>> +       int irq = platform_get_irq(pmu_device, 0);
>>> +
>>> +       cpumask_test_and_clear_cpu(smp_processor_id(),
>>> &armpmu->active_irqs);
>>> +       disable_percpu_irq(irq);
>>> +}
>>> +
>>> +static void
>>>  armpmu_release_hardware(struct arm_pmu *armpmu)
>>>  {
>>>         int i, irq, irqs;
>>>         struct platform_device *pmu_device = armpmu->plat_device;
>>>
>>> -       irqs = min(pmu_device->num_resources, num_possible_cpus());
>>> +       irq = platform_get_irq(pmu_device, 0);
>>>
>>> -       for (i = 0; i < irqs; ++i) {
>>> -               if (!cpumask_test_and_clear_cpu(i, 
>>> &armpmu->active_irqs))
>>> -                       continue;
>>> -               irq = platform_get_irq(pmu_device, i);
>>> -               if (irq >= 0)
>>> -                       free_irq(irq, armpmu);
>>> +       if (irq_to_desc(irq) && irq_is_percpu(irq)) {
>>
>>
>> Why do you need to check the irq_desc here? It really looks like a 
>> misuse of
>> the API.
> I don't think it's being misused. In case of invalid irq number, the
> API would return null.

And feeding an error code to irq_to_desc() doesn't disturb you?
Do you call that a normal use of the API? Humfff....

         M.
-- 
Fast, cheap, reliable. Pick two.
