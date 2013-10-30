Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753550Ab3J3Jam (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 05:30:42 -0400
Received: from mail.lemote.com ([222.92.8.138]:58881 "EHLO mail.lemote.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751908Ab3J3Jal (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 05:30:41 -0400
X-Greylist: delayed 379 seconds by postgrey-1.27 at vger.kernel.org; Wed, 30 Oct 2013 05:30:41 EDT
Message-ID: <fd7ba5f27786bbd812c19dcd6c589eb2.squirrel@mail.lemote.com>
In-Reply-To: <alpine.DEB.2.02.1310291402490.8257@ionos.tec.linutronix.de>
References: <1380334284-12690-1-git-send-email-chenhc@lemote.com>
    <alpine.DEB.2.02.1310291402490.8257@ionos.tec.linutronix.de>
Date: Wed, 30 Oct 2013 17:24:17 +0800
Subject: Re: [PATCH] genirq: Avoid NULL OOPS in irq handling
From: =?gb2312?Q?=22=B3=C2=BB=AA=B2=C5=22?= <chenhc@lemote.com>
To: "Thomas Gleixner" <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.22
MIME-Version: 1.0
Content-Type: text/plain;charset=gb2312
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I use a Loongson-3(MIPS-series CPU) machine, there is a serial port
integrated in the CPU (but it iss buggy), and it use handle_percpu_irq()
as the irq handler. Maybe I should move the checking into
handle_percpu_irq()?

Huacai

> On Sat, 28 Sep 2013, Huacai Chen wrote:
>
>> Some devices (e.g. serial port) setup irq handler at dev open and free
>> it at dev close. So, sometimes there is no irqaction for a specific
>> irq. But some buggy devices may send irqs at any time. This patch avoid
>> the NULL OOPS when irqaction isn't registered.
>
> All callers except the real per cpu interrupts are checking whether
> there is a valid action before calling. And serial ports are not
> routed to real per cpu interrupts. Can you provide more detailed
> information about the problem you are trying to solve please?
>
> Thanks,
>
> 	tglx
>
>> Signed-off-by: Huacai Chen <chenhc@lemote.com>
>> ---
>>  kernel/irq/handle.c |    4 ++++
>>  1 files changed, 4 insertions(+), 0 deletions(-)
>>
>> diff --git a/kernel/irq/handle.c b/kernel/irq/handle.c
>> index 131ca17..1c78e69 100644
>> --- a/kernel/irq/handle.c
>> +++ b/kernel/irq/handle.c
>> @@ -135,6 +135,9 @@ handle_irq_event_percpu(struct irq_desc *desc,
>> struct irqaction *action)
>>  	irqreturn_t retval = IRQ_NONE;
>>  	unsigned int flags = 0, irq = desc->irq_data.irq;
>>
>> +	if (!action)
>> +		goto out;
>> +
>>  	do {
>>  		irqreturn_t res;
>>
>> @@ -174,6 +177,7 @@ handle_irq_event_percpu(struct irq_desc *desc,
>> struct irqaction *action)
>>
>>  	add_interrupt_randomness(irq, flags);
>>
>> +out:
>>  	if (!noirqdebug)
>>  		note_interrupt(irq, desc, retval);
>>  	return retval;
>> --
>> 1.7.7.3
>>
>>
>


