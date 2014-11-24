Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751200AbaKXUgn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 15:36:43 -0500
Received: from mail-wi0-f169.google.com ([209.85.212.169]:39480 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750835AbaKXUgm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 15:36:42 -0500
Message-ID: <547396D0.5030309@linaro.org>
Date: Mon, 24 Nov 2014 20:36:32 +0000
From: Daniel Thompson <daniel.thompson@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Jason Cooper <jason@lakedaemon.net>, Russell King <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        patches@linaro.org, linaro-kernel@lists.linaro.org,
        John Stultz <john.stultz@linaro.org>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Dirk Behme <dirk.behme@de.bosch.com>,
        Daniel Drake <drake@endlessm.com>,
        Dmitry Pervushin <dpervushin@gmail.com>,
        Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH 3.18-rc3 v8 1/4] irqchip: gic: Make gic_raise_softirq()
 FIQ-safe
References: <1415183260-6389-1-git-send-email-daniel.thompson@linaro.org> <1415968543-29469-1-git-send-email-daniel.thompson@linaro.org> <1415968543-29469-2-git-send-email-daniel.thompson@linaro.org> <alpine.DEB.2.11.1411241918090.6439@nanos> <alpine.DEB.2.11.1411241928300.6439@nanos>
In-Reply-To: <alpine.DEB.2.11.1411241928300.6439@nanos>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24/11/14 18:48, Thomas Gleixner wrote:
> On Mon, 24 Nov 2014, Thomas Gleixner wrote:
>> On Fri, 14 Nov 2014, Daniel Thompson wrote:
>>> diff --git a/drivers/irqchip/irq-gic.c b/drivers/irqchip/irq-gic.c
>>> index 38493ff28fa5..0db62a6f1ee3 100644
>>> --- a/drivers/irqchip/irq-gic.c
>>> +++ b/drivers/irqchip/irq-gic.c
>>> @@ -73,6 +73,13 @@ struct gic_chip_data {
>>>  static DEFINE_RAW_SPINLOCK(irq_controller_lock);
>>>  
>>>  /*
>>> + * This lock may be locked for reading by FIQ handlers. Thus although
>>> + * read locking may be used liberally, write locking must only take
>>> + * place only when local FIQ handling is disabled.
>>> + */
>>> +static DEFINE_RWLOCK(fiq_safe_cpu_map_lock);
>>> +
>>> +/*
>>>   * The GIC mapping of CPU interfaces does not necessarily match
>>>   * the logical CPU numbering.  Let's use a mapping as returned
>>>   * by the GIC itself.
>>> @@ -624,7 +631,7 @@ static void gic_raise_softirq(const struct cpumask *mask, unsigned int irq)
>>>  	int cpu;
>>>  	unsigned long flags, map = 0;
>>>  
>>> -	raw_spin_lock_irqsave(&irq_controller_lock, flags);
>>> +	read_lock_irqsave(&fiq_safe_cpu_map_lock, flags);
>>
>> Just for the record:
>>
>> You might have noticed that you replace a raw lock with a non raw
>> one. That's not an issue on mainline, but that pretty much renders
>> that code broken for RT.
>>   
>> Surely nothing I worry too much about given the current state of RT.
> 
> And having a second thought here. Looking at the protection scope
> independent of the spin vs. rw lock
> 
> gic_raise_softirq()
> 
> 	lock();
> 
> 	/* Does not need any protection */
> 	for_each_cpu(cpu, mask)
>                 map |= gic_cpu_map[cpu];
> 
> 	/*
> 	 * Can be outside the lock region as well as it makes sure
> 	 * that previous writes (usually the IPI data) are visible
> 	 * before the write to the SOFTINT register.
> 	 */
> 	 dmb(ishst);
> 
> 	/* Why needs this protection? */
> 	write(map, gic_data_dist_base(&gic_data[0]) + GIC_DIST_SOFTINT));

If gic_cpu_map changed value during the execution of this function then
this could raise an IPI on the wrong CPU.

Most of the rest of this mail is explaining how this could happen.

> 	unlock();
> 
> gic_migrate_target()
> 
> 	....
> 	lock();

Also:   Value of gic_cpu_map is updated.

> 	/* Migrate all peripheral interrupts */
> 
> 	unlock();

Also:   /* Migrate all IPIs pending on the old core */

> So what's the point of that protection?
> 
> gic_raise_softirq() is used to send IPIs, which are PPIs on the target
> CPUs so they are not affected from the migration of the peripheral
> interrupts at all.
> 
> The write to the SOFTINT register in gic_migrate_target() is not
> inside the lock region. So what's serialized by the lock in
> gic_raise_softirq() at all?

At the point that gic_migrate_target() takes the lock it knows that no
further IPIs can be submitted.

Once the gic_cpu_map is updated we can permit new IPIs to be submitted
because these will be routed to the correct core.

As a result we don't actually need to hold the lock to migrate the
pending IPIs since we know that no new IPIs can possibly be sent to the
wrong core.

> Either I'm missing something really important here or this locking
> exercise in gic_raise_softirq() and therefor the rwlock conversion is
> completely pointless.

I did want to remove the lock too. However when I reviewed this code I
concluded the lock was still required. Without it I think it is possible
for gic_raise_softirq() to raise an IPI on the old core *after* the code
to migrate pending IPIs has been run.


Daniel.
