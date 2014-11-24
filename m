Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754474AbaKXSlD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 13:41:03 -0500
Received: from mail-wi0-f178.google.com ([209.85.212.178]:62661 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752589AbaKXSlB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 13:41:01 -0500
Message-ID: <54737BB3.8060205@linaro.org>
Date: Mon, 24 Nov 2014 18:40:51 +0000
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
References: <1415183260-6389-1-git-send-email-daniel.thompson@linaro.org> <1415968543-29469-1-git-send-email-daniel.thompson@linaro.org> <1415968543-29469-2-git-send-email-daniel.thompson@linaro.org> <alpine.DEB.2.11.1411241918090.6439@nanos>
In-Reply-To: <alpine.DEB.2.11.1411241918090.6439@nanos>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24/11/14 18:20, Thomas Gleixner wrote:
> On Fri, 14 Nov 2014, Daniel Thompson wrote:
>> diff --git a/drivers/irqchip/irq-gic.c b/drivers/irqchip/irq-gic.c
>> index 38493ff28fa5..0db62a6f1ee3 100644
>> --- a/drivers/irqchip/irq-gic.c
>> +++ b/drivers/irqchip/irq-gic.c
>> @@ -73,6 +73,13 @@ struct gic_chip_data {
>>  static DEFINE_RAW_SPINLOCK(irq_controller_lock);
>>  
>>  /*
>> + * This lock may be locked for reading by FIQ handlers. Thus although
>> + * read locking may be used liberally, write locking must only take
>> + * place only when local FIQ handling is disabled.
>> + */
>> +static DEFINE_RWLOCK(fiq_safe_cpu_map_lock);
>> +
>> +/*
>>   * The GIC mapping of CPU interfaces does not necessarily match
>>   * the logical CPU numbering.  Let's use a mapping as returned
>>   * by the GIC itself.
>> @@ -624,7 +631,7 @@ static void gic_raise_softirq(const struct cpumask *mask, unsigned int irq)
>>  	int cpu;
>>  	unsigned long flags, map = 0;
>>  
>> -	raw_spin_lock_irqsave(&irq_controller_lock, flags);
>> +	read_lock_irqsave(&fiq_safe_cpu_map_lock, flags);
> 
> Just for the record:
> 
> You might have noticed that you replace a raw lock with a non raw
> one. That's not an issue on mainline, but that pretty much renders
> that code broken for RT.

Indeed. For that reason I've been pretty anxious to hear your views on
this one.

Older versions of this patch did retain the raw lock but the code ends
up looking a bit weird and resulted in negative comments during review:

if (in_nmi())
        raw_spin_lock(&fiq_exclusive_cpu_map_lock);
else
        raw_spin_lock_irqsave(&irq_controller_lock, flags);

The above form relies for correctness on the fact the b.L switcher code
can take both locks and already runs with FIQ disabled.


> Surely nothing I worry too much about given the current state of RT.

Hobby or not, I don't want to make your work here any harder. I could go
back to the old form.

Alternatively I could provide a patch to go in -rt that converts the rw
locks to spin locks but that just sounds like a maintenance hassle for you.


Daniel.

