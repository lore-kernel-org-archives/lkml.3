Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936175AbaH1HAh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 03:00:37 -0400
Received: from mail-lb0-f176.google.com ([209.85.217.176]:35914 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935035AbaH1HAg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 03:00:36 -0400
MIME-Version: 1.0
In-Reply-To: <53FDB580.8050009@arm.com>
References: <1409131832-11317-1-git-send-email-byungchul.park@lge.com>
	<53FDB580.8050009@arm.com>
Date: Thu, 28 Aug 2014 16:00:34 +0900
Message-ID: <CANrsvRO6_B7HRE0HGE4gy5B8Sm7nMxnBkAWkWuMirAaii+xYjg@mail.gmail.com>
Subject: Re: [PATCH 2/2] arm64: take onlined cpus into account when setting
 irq affinity in migrate_one_irq
From: byungchul park <max.byungchul.park@gmail.com>
To: Sudeep Holla <sudeep.holla@arm.com>
Cc: "byungchul.park@lge.com" <byungchul.park@lge.com>,
        Will Deacon <Will.Deacon@arm.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        tglx@linutronix.de
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 27, 2014 at 7:40 PM, Sudeep Holla <sudeep.holla@arm.com> wrote:
>
>
> On 27/08/14 10:30, byungchul.park@lge.com wrote:
>>
>> From: Byungchul Park <byungchul.park@lge.com>
>>
>> This patch ensures that the cpu being offlined is not present in the
>> affinity mask.
>>
>
> I agree that this patch fixes the issue reported in [1] without
> disabling forced set affinity mask. However Thomas responded yesterday
> asking to disable it [2] on the original thread for ARM. I have
> responded on the thread and waiting for feedback from rmk and tglx. I
> would prefer to wait and align with ARM code if possible.

It is also good to call irq_set_affinity() with "force = false" to
solve the problem,
because it can give a chance to check if the passed affinity includes
only onlined cpus or not.
However, it totally relies on the implementation of irq_set_affinity(),
and it cannnot ensure that the function performs what we expect.
I think a code basically needs to be written to do exactly what it intends.

It is not bad to apply calling irq_set_affinity() with "force = false"
to the code if necessary.
But this patches also have to be applied, independently,
in order to make the code do exactly what it intends.

Thank you.

>
>> Signed-off-by: Byungchul Park <byungchul.park@lge.com>
>> ---
>>   arch/arm64/kernel/irq.c |    9 +++++++++
>>   1 file changed, 9 insertions(+)
>>
>> diff --git a/arch/arm64/kernel/irq.c b/arch/arm64/kernel/irq.c
>> index 473e5db..0c7b79e 100644
>> --- a/arch/arm64/kernel/irq.c
>> +++ b/arch/arm64/kernel/irq.c
>> @@ -87,6 +87,7 @@ static bool migrate_one_irq(struct irq_desc *desc)
>>   {
>>         struct irq_data *d = irq_desc_get_irq_data(desc);
>>         const struct cpumask *affinity = d->affinity;
>> +       struct cpumask tmp_affinity;
>>         struct irq_chip *c;
>>         bool ret = false;
>>
>> @@ -100,6 +101,14 @@ static bool migrate_one_irq(struct irq_desc *desc)
>>         if (cpumask_any_and(affinity, cpu_online_mask) >= nr_cpu_ids) {
>>                 affinity = cpu_online_mask;
>>                 ret = true;
>> +       } else {
>> +               /*
>> +                * when using forced irq_set_affinity we must ensure that
>> the cpu
>> +                * being offlined is not present in the affinity mask, it
>> may be
>> +                * selected as the target CPU otherwise
>> +                */
>> +               cpumask_and(&tmp_affinity, affinity, cpu_online_mask);
>
>
> In case we decide to retain forced set affinity, you can probably squash
> this cpumask_and with the above cpumask_any_and.
>
>> +               affinity = &tmp_affinity;
>>         }
>>
>>         c = irq_data_get_irq_chip(d);
>>
>
> Regards,
> Sudeep
>
> [1]
> http://lists.infradead.org/pipermail/linux-arm-kernel/2014-June/266785.html
> [2]
> http://lists.infradead.org/pipermail/linux-arm-kernel/2014-August/281548.html
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/



-- 
LG electronics CTO division
senior engineer
max.byungchul.park
