Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753840AbbAIDAp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 22:00:45 -0500
Received: from mga01.intel.com ([192.55.52.88]:11181 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753364AbbAIDAn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 22:00:43 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,727,1413270000"; 
   d="scan'208";a="634672782"
Message-ID: <54AF4449.2040004@linux.intel.com>
Date: Fri, 09 Jan 2015 11:00:25 +0800
From: Jiang Liu <jiang.liu@linux.intel.com>
Organization: Intel
User-Agent: Mozilla/5.0 (Windows NT 6.2; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Marc Zyngier <marc.zyngier@arm.com>, Thomas Gleixner <tglx@linutronix.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] genirq: Abstract access to irq_chip flags
References: <1420738365-22063-1-git-send-email-marc.zyngier@arm.com> <1420738365-22063-2-git-send-email-marc.zyngier@arm.com>
In-Reply-To: <1420738365-22063-2-git-send-email-marc.zyngier@arm.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2015/1/9 1:32, Marc Zyngier wrote:
> In order to safely migrate to a cumulative set of flags, start by
> abstracting the way we look at these flags. There is otherwise no
> change in semantics here.
<snit>
> diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
> index 8069237..b2a43e0 100644
> --- a/kernel/irq/manage.c
> +++ b/kernel/irq/manage.c
> @@ -491,7 +491,7 @@ static int set_irq_wake_real(unsigned int irq, unsigned int on)
>  	struct irq_desc *desc = irq_to_desc(irq);
>  	int ret = -ENXIO;
>  
> -	if (irq_desc_get_chip(desc)->flags &  IRQCHIP_SKIP_SET_WAKE)
> +	if (irq_desc_get_chip_flags(desc) &  IRQCHIP_SKIP_SET_WAKE)
>  		return 0;
>  
>  	if (desc->irq_data.chip->irq_set_wake)
> @@ -589,7 +589,7 @@ int __irq_set_trigger(struct irq_desc *desc, unsigned int irq,
>  
>  	flags &= IRQ_TYPE_SENSE_MASK;
>  
> -	if (chip->flags & IRQCHIP_SET_TYPE_MASKED) {
> +	if (irq_desc_get_chip_flags(desc) & IRQCHIP_SET_TYPE_MASKED) {
>  		if (!irqd_irq_masked(&desc->irq_data))
>  			mask_irq(desc);
>  		if (!irqd_irq_disabled(&desc->irq_data))
> @@ -1043,7 +1043,7 @@ __setup_irq(unsigned int irq, struct irq_desc *desc, struct irqaction *new)
>  	 * chip flags, so we can avoid the unmask dance at the end of
>  	 * the threaded handler for those.
>  	 */
> -	if (desc->irq_data.chip->flags & IRQCHIP_ONESHOT_SAFE)
> +	if (irq_desc_get_chip_flags(desc) & IRQCHIP_ONESHOT_SAFE)
>  		new->flags &= ~IRQF_ONESHOT;
>  
>  	/*
Hi Mark,
	Seems you missed on instance of IRQCHIP_ONESHOT_SAFE in
__setup_irq() as below.
Thanks!
Gerry
-----------------------------------------------------------------
        } else if (new->handler == irq_default_primary_handler &&
                   !(desc->irq_data.chip->flags & IRQCHIP_ONESHOT_SAFE)) {
------------------------------------------------------------------

> diff --git a/kernel/irq/pm.c b/kernel/irq/pm.c
> index 3ca5325..8ed029d 100644
> --- a/kernel/irq/pm.c
> +++ b/kernel/irq/pm.c
> @@ -88,7 +88,7 @@ static bool suspend_device_irq(struct irq_desc *desc, int irq)
>  	 * chip level. The chip implementation indicates that with
>  	 * IRQCHIP_MASK_ON_SUSPEND.
>  	 */
> -	if (irq_desc_get_chip(desc)->flags & IRQCHIP_MASK_ON_SUSPEND)
> +	if (irq_desc_get_chip_flags(desc) & IRQCHIP_MASK_ON_SUSPEND)
>  		mask_irq(desc);
>  	return true;
>  }
> 
