Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754633AbaHUL4i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 07:56:38 -0400
Received: from mail-ie0-f178.google.com ([209.85.223.178]:58435 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754019AbaHUL4h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 07:56:37 -0400
Date: Thu, 21 Aug 2014 12:56:31 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Cc: sameo@linux.intel.com, patches@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] mfd: arizona: Add additional dummy IRQ callbacks
Message-ID: <20140821115631.GA4266@lee--X1>
References: <1407851483-19207-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1407851483-19207-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Aug 2014, Charles Keepax wrote:

> We use a dummy IRQ chip to dispatch interrupts to the two seperate IRQ
> domains on the Arizona devices. Currently only the enable and disable
> callbacks are defined however, there are some situations where additional
> callbacks will be used from the IRQ core, which currently results in an
> NULL pointer deference. Add handlers for more of the IRQ callbacks and
> combine these into a single function since they are all identical.
> 
> Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
> ---
>  drivers/mfd/arizona-irq.c |   13 ++++++-------
>  1 files changed, 6 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/mfd/arizona-irq.c b/drivers/mfd/arizona-irq.c
> index d420dbc..71e8f06 100644
> --- a/drivers/mfd/arizona-irq.c
> +++ b/drivers/mfd/arizona-irq.c
> @@ -144,18 +144,17 @@ static irqreturn_t arizona_irq_thread(int irq, void *data)
>  	return IRQ_HANDLED;
>  }
>  
> -static void arizona_irq_enable(struct irq_data *data)
> -{
> -}
> -
> -static void arizona_irq_disable(struct irq_data *data)
> +static void arizona_irq_dummy(struct irq_data *data)
>  {
>  }
>  
>  static struct irq_chip arizona_irq_chip = {
>  	.name			= "arizona",
> -	.irq_disable		= arizona_irq_disable,
> -	.irq_enable		= arizona_irq_enable,
> +	.irq_disable		= arizona_irq_dummy,
> +	.irq_enable		= arizona_irq_dummy,
> +	.irq_ack		= arizona_irq_dummy,
> +	.irq_mask		= arizona_irq_dummy,
> +	.irq_unmask		= arizona_irq_dummy,

If you provide .irq_enable(), then .irq_unmask becomes redundant
and/or is checked for before invoking.  There is a chance of
.irq_mask() being called, but if this is a problem, it should be fixed
in the IRQ Chip code.  There is also one unprotected invocation of
.irq_ack(), but I think this should be fixed rather than forcing each
user of IRQ Chip to provide all of these call-backs.

>  };
>  
>  static int arizona_irq_map(struct irq_domain *h, unsigned int virq,

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
