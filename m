Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752245AbaHOInw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 04:43:52 -0400
Received: from service87.mimecast.com ([91.220.42.44]:35587 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750817AbaHOInv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 04:43:51 -0400
Message-ID: <53EDC89F.4020300@arm.com>
Date: Fri, 15 Aug 2014 09:45:19 +0100
From: Sudeep Holla <sudeep.holla@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Neil Zhang <zhangwm@marvell.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>
CC: Sudeep Holla <sudeep.holla@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] arm: irq: fix the affinity when migrate a irq
References: <1408087917-22603-1-git-send-email-zhangwm@marvell.com>
In-Reply-To: <1408087917-22603-1-git-send-email-zhangwm@marvell.com>
X-OriginalArrivalTime: 15 Aug 2014 08:43:46.0962 (UTC) FILETIME=[073C1720:01CFB865]
X-MC-Unique: 114081509434901901
Content-Type: text/plain; charset=WINDOWS-1252; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Neil,

On 15/08/14 08:31, Neil Zhang wrote:
> Commit ffde1de64012 ("irqchip: Gic: Support forced affinity setting")
> has enable the forcing cpu affinity of interrupts for gic.
>
> The current code of migrate_one_irq will pass the current affinity mask
> to irq_set_affinity with force is true, it may select the cpu being
> offlined as the target CPU again, then the interrupt won't be migrated
> correctly.
>

I had posted similar patch [1] a while ago and the discussion[2] did not 
conclude. We need feedback from Thomas Gleixner.

Regards,
Sudeep

[1] 
http://lists.infradead.org/pipermail/linux-arm-kernel/2014-May/254838.html
[2] 
http://lists.infradead.org/pipermail/linux-arm-kernel/2014-June/265191.html

> Signed-off-by: Neil Zhang <zhangwm@marvell.com>
> ---
>   arch/arm/kernel/irq.c |    5 ++---
>   1 file changed, 2 insertions(+), 3 deletions(-)
>
> diff --git a/arch/arm/kernel/irq.c b/arch/arm/kernel/irq.c
> index 2c42576..6f5a878 100644
> --- a/arch/arm/kernel/irq.c
> +++ b/arch/arm/kernel/irq.c
> @@ -167,11 +167,10 @@ static bool migrate_one_irq(struct irq_desc *desc)
>   	if (irqd_is_per_cpu(d) || !cpumask_test_cpu(smp_processor_id(), affinity))
>   		return false;
>
> -	if (cpumask_any_and(affinity, cpu_online_mask) >= nr_cpu_ids) {
> -		affinity = cpu_online_mask;
> +	if (cpumask_any_and(affinity, cpu_online_mask) >= nr_cpu_ids)
>   		ret = true;
> -	}
>
> +	affinity = cpu_online_mask;
>   	c = irq_data_get_irq_chip(d);
>   	if (!c->irq_set_affinity)
>   		pr_debug("IRQ%u: unable to set affinity\n", d->irq);
>

