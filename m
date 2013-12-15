Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754249Ab3LOKmu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Dec 2013 05:42:50 -0500
Received: from mail-pb0-f44.google.com ([209.85.160.44]:62548 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753275Ab3LOKms (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Dec 2013 05:42:48 -0500
Date: Sun, 15 Dec 2013 02:42:42 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-input@vger.kernel.org,
        Stephen Boyd <sboyd@codeaurora.org>
Subject: Re: [PATCH 5/7] genirq: Add devm_request_any_context_irq()
Message-ID: <20131215104242.GD20197@core.coreip.homeip.net>
References: <1386718996-3733-1-git-send-email-sboyd@codeaurora.org>
 <1386718996-3733-6-git-send-email-sboyd@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386718996-3733-6-git-send-email-sboyd@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 10, 2013 at 03:43:14PM -0800, Stephen Boyd wrote:
> Some drivers use request_any_context_irq() but there isn't a
> devm_* function for it. Add one so that these drivers don't need
> to explicitly free the irq on driver detach.
> 
> Cc: Thomas Gleixner <tglx@linutronix.de>

Thomas, would it be OK with me picking this patch through my tree if you
do not have issues with it?

Thanks.

> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> ---
>  include/linux/interrupt.h |  5 +++++
>  kernel/irq/devres.c       | 45 +++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 50 insertions(+)
> 
> diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
> index c9e831d..8334f9b 100644
> --- a/include/linux/interrupt.h
> +++ b/include/linux/interrupt.h
> @@ -160,6 +160,11 @@ devm_request_irq(struct device *dev, unsigned int irq, irq_handler_t handler,
>  					 devname, dev_id);
>  }
>  
> +extern int __must_check
> +devm_request_any_context_irq(struct device *dev, unsigned int irq,
> +		 irq_handler_t handler, unsigned long irqflags,
> +		 const char *devname, void *dev_id);
> +
>  extern void devm_free_irq(struct device *dev, unsigned int irq, void *dev_id);
>  
>  /*
> diff --git a/kernel/irq/devres.c b/kernel/irq/devres.c
> index bd8e788..f71e9ff 100644
> --- a/kernel/irq/devres.c
> +++ b/kernel/irq/devres.c
> @@ -73,6 +73,51 @@ int devm_request_threaded_irq(struct device *dev, unsigned int irq,
>  EXPORT_SYMBOL(devm_request_threaded_irq);
>  
>  /**
> + *	devm_request_any_context_irq - allocate an interrupt line for a managed device
> + *	@dev: device to request interrupt for
> + *	@irq: Interrupt line to allocate
> + *	@handler: Function to be called when the IRQ occurs
> + *	@thread_fn: function to be called in a threaded interrupt context. NULL
> + *		    for devices which handle everything in @handler
> + *	@irqflags: Interrupt type flags
> + *	@devname: An ascii name for the claiming device
> + *	@dev_id: A cookie passed back to the handler function
> + *
> + *	Except for the extra @dev argument, this function takes the
> + *	same arguments and performs the same function as
> + *	request_any_context_irq().  IRQs requested with this function will be
> + *	automatically freed on driver detach.
> + *
> + *	If an IRQ allocated with this function needs to be freed
> + *	separately, devm_free_irq() must be used.
> + */
> +int devm_request_any_context_irq(struct device *dev, unsigned int irq,
> +			      irq_handler_t handler, unsigned long irqflags,
> +			      const char *devname, void *dev_id)
> +{
> +	struct irq_devres *dr;
> +	int rc;
> +
> +	dr = devres_alloc(devm_irq_release, sizeof(struct irq_devres),
> +			  GFP_KERNEL);
> +	if (!dr)
> +		return -ENOMEM;
> +
> +	rc = request_any_context_irq(irq, handler, irqflags, devname, dev_id);
> +	if (rc) {
> +		devres_free(dr);
> +		return rc;
> +	}
> +
> +	dr->irq = irq;
> +	dr->dev_id = dev_id;
> +	devres_add(dev, dr);
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL(devm_request_any_context_irq);
> +
> +/**
>   *	devm_free_irq - free an interrupt
>   *	@dev: device to free interrupt for
>   *	@irq: Interrupt line to free
> -- 
> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
> hosted by The Linux Foundation
> 

-- 
Dmitry
