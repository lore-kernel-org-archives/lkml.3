Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757416AbaIRVUx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 17:20:53 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:41943 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751978AbaIRVUv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 17:20:51 -0400
Message-ID: <541B4CB0.8040705@linaro.org>
Date: Thu, 18 Sep 2014 14:20:48 -0700
From: Daniel Thompson <daniel.thompson@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        patches@linaro.org, linaro-kernel@lists.linaro.org,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Jason Cooper <jason@lakedaemon.net>
Subject: Re: [PATCH 3.17-rc4 v7 4/6] irqchip: gic: Add support for IPI FIQ
References: <1410970218-28847-1-git-send-email-daniel.thompson@linaro.org> <1410970218-28847-5-git-send-email-daniel.thompson@linaro.org> <20140918081739.GA5182@n2100.arm.linux.org.uk>
In-Reply-To: <20140918081739.GA5182@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18/09/14 01:17, Russell King - ARM Linux wrote:
> On Wed, Sep 17, 2014 at 09:10:16AM -0700, Daniel Thompson wrote:
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
> BTW, I see this code is still here...

Quite so.

I'm afraid I haven't yet re-written it to use r/w locks (as proposed in
mails from the weekend) but I had to respin the default FIQ handler
patch to fix the CONFIG_FIQ build problem I introduced.




