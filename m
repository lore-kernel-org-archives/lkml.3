Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756058AbaIIIYR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 04:24:17 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:39628 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751300AbaIIIYO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 04:24:14 -0400
Message-ID: <540EB930.6010404@linaro.org>
Date: Tue, 09 Sep 2014 09:24:16 +0100
From: Daniel Thompson <daniel.thompson@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        patches@linaro.org, linaro-kernel@lists.linaro.org,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Jason Cooper <jason@lakedaemon.net>
Subject: Re: [PATCH v3 5/5] irqchip: gic: Add support for IPI FIQ
References: <1409931198-22600-1-git-send-email-daniel.thompson@linaro.org> <1410190115-32604-1-git-send-email-daniel.thompson@linaro.org> <1410190115-32604-6-git-send-email-daniel.thompson@linaro.org> <20140908162316.GC12361@n2100.arm.linux.org.uk>
In-Reply-To: <20140908162316.GC12361@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/09/14 17:23, Russell King - ARM Linux wrote:
> On Mon, Sep 08, 2014 at 04:28:35PM +0100, Daniel Thompson wrote:
>> @@ -604,8 +731,19 @@ static void gic_raise_softirq(const struct cpumask *mask, unsigned int irq)
>>  {
>>  	int cpu;
>>  	unsigned long flags, map = 0;
>> +	unsigned long softint;
>>  
>> -	raw_spin_lock_irqsave(&irq_controller_lock, flags);
>> +	/*
>> +	 * The locking in this function ensures we don't use stale cpu mappings
>> +	 * and thus we never route an IPI to the wrong physical core during a
>> +	 * big.LITTLE switch. The switch code takes both of these locks meaning
>> +	 * we can choose whichever lock is safe to use from our current calling
>> +	 * context.
>> +	 */
>> +	if (in_nmi())
>> +		raw_spin_lock(&fiq_safe_migration_lock);
>> +	else
>> +		raw_spin_lock_irqsave(&irq_controller_lock, flags);
> 
> Firstly, why would gic_raise_softirq() be called in FIQ context?

Oops.

This code should have been removed. It *is* required for kgdb (which
needs to send FIQ to other processors via IPI and may itself be running
from FIQ) but it not needed for the currently targeted use case.


> Secondly,
> this doesn't save you.  If you were in the middle of gic_migrate_target()
> when the FIQ happened that (for some reason prompted you to call this),
> you would immediately deadlock trying to that this IRQ.

This cannot happen because gic_migrate_target() runs with FIQ disabled.


> I suggest not even trying to solve this "race" which I don't think is
> one which needs to even be considered (due to the first point.)

As mentioned above I believe it eventually needs to be addressed by some
means but it certainly doesn't belong in the current patchset.

I will remove it.

