Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753338AbaHDXWm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 19:22:42 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:38805 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752156AbaHDXWl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 19:22:41 -0400
Message-ID: <53E015BF.4060701@codeaurora.org>
Date: Mon, 04 Aug 2014 16:22:39 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Nicolas Pitre <nicolas.pitre@linaro.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Jason Cooper <jason@lakedaemon.net>,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] irqchip: gic: Allow gic_arch_extn hooks to call into
 scheduler
References: <1407191616-31829-1-git-send-email-sboyd@codeaurora.org> <alpine.LFD.2.11.1408041858570.6061@knanqh.ubzr>
In-Reply-To: <alpine.LFD.2.11.1408041858570.6061@knanqh.ubzr>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/04/14 16:20, Nicolas Pitre wrote:
> On Mon, 4 Aug 2014, Stephen Boyd wrote:
>
>> diff --git a/drivers/irqchip/irq-gic.c b/drivers/irqchip/irq-gic.c
>> index 7c131cf7cc13..824c1e2ac403 100644
>> --- a/drivers/irqchip/irq-gic.c
>> +++ b/drivers/irqchip/irq-gic.c
>> @@ -72,6 +72,8 @@ struct gic_chip_data {
>>  };
>>  
>>  static DEFINE_RAW_SPINLOCK(irq_controller_lock);
>> +/* Synchronize switching CPU interface and sending SGIs */
>> +static DEFINE_RAW_SPINLOCK(gic_sgi_lock);
> I'd suggest moving this below gic_cpu_map[] definition for the comment 
> block right above it to also apply to this lock.

Ok.

>
>>  
>>  /*
>>   * The GIC mapping of CPU interfaces does not necessarily match
>> @@ -658,7 +660,7 @@ static void gic_raise_softirq(const struct cpumask *mask, unsigned int irq)
>>  	int cpu;
>>  	unsigned long flags, map = 0;
>>  
>> -	raw_spin_lock_irqsave(&irq_controller_lock, flags);
>> +	raw_spin_lock_irqsave(&gic_sgi_lock, flags);
>>  
>>  	/* Convert our logical CPU mask into a physical one. */
>>  	for_each_cpu(cpu, mask)
>> @@ -673,7 +675,7 @@ static void gic_raise_softirq(const struct cpumask *mask, unsigned int irq)
>>  	/* this always happens on GIC0 */
>>  	writel_relaxed(map << 16 | irq, gic_data_dist_base(&gic_data[0]) + GIC_DIST_SOFTINT);
>>  
>> -	raw_spin_unlock_irqrestore(&irq_controller_lock, flags);
>> +	raw_spin_unlock_irqrestore(&gic_sgi_lock, flags);
>>  }
>>  #endif
>>  
>> @@ -742,6 +744,7 @@ void gic_migrate_target(unsigned int new_cpu_id)
>>  	cur_target_mask = 0x01010101 << cur_cpu_id;
>>  	ror_val = (cur_cpu_id - new_cpu_id) & 31;
>>  
>> +	raw_spin_lock(&gic_sgi_lock);
>>  	raw_spin_lock(&irq_controller_lock);
> According to your call trace, you would now take irq_controller_lock and 
> then gic_sgi_lock.  Here you're doing it in the opposite order with an 
> AB-BA deadlock potential.  I'd suggest reversing them here.
>

Ah thanks. I guess I didn't see it on lockdep because this code never
runs. Actually I don't think we need to hold it across this piece of
code at all. See v2.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

