Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755284Ab3FRIzZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 04:55:25 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:38571 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754470Ab3FRIzU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 04:55:20 -0400
MIME-Version: 1.0
In-Reply-To: <51BFCF53.9050302@linux.vnet.ibm.com>
References: <1370825362-11145-1-git-send-email-grant.likely@linaro.org>
 <1370825362-11145-9-git-send-email-grant.likely@linaro.org> <51BFCF53.9050302@linux.vnet.ibm.com>
From: Grant Likely <grant.likely@linaro.org>
Date: Tue, 18 Jun 2013 09:54:58 +0100
X-Google-Sender-Auth: qczB4DpQ-Gw0Wmwhcj0olrLRX10
Message-ID: <CACxGe6uTCL7jK4FDNfY0UdpiAQaXMJ8uwO=cWYE6iwQz94=4Ww@mail.gmail.com>
Subject: Re: [RFC 08/10] irqdomain: Refactor irq_domain_associate_many()
To: Mike Qiu <qiudayu@linux.vnet.ibm.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 18, 2013 at 4:09 AM, Mike Qiu <qiudayu@linux.vnet.ibm.com> wrote:
> 于 2013/6/10 8:49, Grant Likely 写道:
>
>> Originally, irq_domain_associate_many() was designed to unwind the
>> mapped irqs on a failure of any individual association. However, that
>> proved to be a problem with certain IRQ controllers. Some of them only
>> support a subset of irqs, and will fail when attempting to map a
>> reserved IRQ. In those cases we want to map as many IRQs as possible, so
>> instead it is better for irq_domain_associate_many() to make a
>> best-effort attempt to map irqs, but not fail if any or all of them
>> don't succeed. If a caller really cares about how many irqs got
>> associated, then it should instead go back and check that all of the
>> irqs is cares about were mapped.
>>
>> The original design open-coded the individual association code into the
>> body of irq_domain_associate_many(), but with no longer needing to
>> unwind associations, the code becomes simpler to split out
>> irq_domain_associate() to contain the bulk of the logic, and
>> irq_domain_associate_many() to be a simple loop wrapper.
>>
>> This patch also adds a new error check to the associate path to make
>> sure it isn't called for an irq larger than the controller can handle,
>> and adds locking so that the irq_domain_mutex is held while setting up a
>> new association.
>>
>> Signed-off-by: Grant Likely <grant.likely@linaro.org>
[...]
>> -int irq_domain_associate_many(struct irq_domain *domain, unsigned int
>> irq_base,
>> -                             irq_hw_number_t hwirq_base, int count)
>> +int irq_domain_associate(struct irq_domain *domain, unsigned int virq,
>> +                        irq_hw_number_t hwirq)
>>   {
>> -       unsigned int virq = irq_base;
>> -       irq_hw_number_t hwirq = hwirq_base;
>> -       int i, ret;>> +       struct irq_data *irq_data = irq_get_irq_data(virq);
>> +       int ret;
>>
>> -       pr_debug("%s(%s, irqbase=%i, hwbase=%i, count=%i)\n", __func__,
>> -               of_node_full_name(domain->of_node), irq_base,
>> (int)hwirq_base, count);
>> +       if (WARN(hwirq >= domain->hwirq_max,
>> +                "error: hwirq 0x%x is too large for %s\n", (int)hwirq,
>> domain->name))
>> +               return -EINVAL;
>> +       if (WARN(!irq_data, "error: virq%i is not allocated", virq))
>> +               return -EINVAL;
>> +       if (WARN(irq_data->domain, "error: virq%i is already associated",
>> virq))
>> +               return -EINVAL;
>
>
> Hi Grant,
>
> I have a qestion here, assume that we have three hwirqs and alloc three
> virqs, for first irq, it check irq_data
> and irq_data->domain pass, but the second is failed, then this code do
> nothing with failed( in
>
> irq_domain_associate_many()) and continue to associated the third one.
>
>
> This should be very dangours, even though I have no idea of when this could
> happen.

Define what you mean by "dangerous". You are correct that it is a bad
situation, and the kernel will complain very loudly if it happens.
However, the users of irq_domain_associate_many() are usually irq
controllers using a legacy domain that needs to be set up during early
boot. If the IRQ controller setup fails and gets unwound, then it is
very likely that there will be no output at all from the kernel. This
has actually been a problem on a number of platforms and it is a big
part of why this irqdomain refactoring series wasn't merged 6 months
ago.

I think it is better to relax the behaviour of
irq_domain_associate_many() so that if something fails, then at least
it can limp along and try to get at least some of the irqs associated.
That way we can find and fix problematic platforms rather than failing
silently.

Also, I don't see anything particularly dangerous about this behaviour
other than having some of the hwirqs not being associated with a virq.
The code protects against this path and if an irq controller receives
an IRQ on a unassociated hwirq, then the kernel will also log that as
an error.

g.
