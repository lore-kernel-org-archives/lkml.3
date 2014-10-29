Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934719AbaJ2QyM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 12:54:12 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:44083 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934602AbaJ2Qxl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 12:53:41 -0400
Message-ID: <54511B79.9080005@gmail.com>
Date: Wed, 29 Oct 2014 09:53:13 -0700
From: Florian Fainelli <f.fainelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Kevin Cernekee <cernekee@gmail.com>, tglx@linutronix.de,
        jason@lakedaemon.net, ralf@linux-mips.org
CC: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        mbizon@freebox.fr, jogo@openwrt.org, linux-mips@linux-mips.org
Subject: Re: [PATCH 02/11] irqchip: brcmstb-l2: Eliminate dependency on ARM
 code
References: <1414555138-6500-1-git-send-email-cernekee@gmail.com> <1414555138-6500-2-git-send-email-cernekee@gmail.com>
In-Reply-To: <1414555138-6500-2-git-send-email-cernekee@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/28/2014 08:58 PM, Kevin Cernekee wrote:
> The irq-brcmstb-l2 driver has a single dependency on the ARM code, the
> do_bad_IRQ macro.  Expand this macro in-place so that the driver can be
> built on non-ARM platforms.
> 
> Signed-off-by: Kevin Cernekee <cernekee@gmail.com>

Acked-by: Florian Fainelli <f.fainelli@gmail.com>

> ---
>  drivers/irqchip/irq-brcmstb-l2.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/irqchip/irq-brcmstb-l2.c b/drivers/irqchip/irq-brcmstb-l2.c
> index c15c840..c9bdf20 100644
> --- a/drivers/irqchip/irq-brcmstb-l2.c
> +++ b/drivers/irqchip/irq-brcmstb-l2.c
> @@ -19,6 +19,7 @@
>  #include <linux/slab.h>
>  #include <linux/module.h>
>  #include <linux/platform_device.h>
> +#include <linux/spinlock.h>
>  #include <linux/of.h>
>  #include <linux/of_irq.h>
>  #include <linux/of_address.h>
> @@ -30,8 +31,6 @@
>  #include <linux/irqchip.h>
>  #include <linux/irqchip/chained_irq.h>
>  
> -#include <asm/mach/irq.h>
> -
>  #include "irqchip.h"
>  
>  /* Register offsets in the L2 interrupt controller */
> @@ -63,7 +62,9 @@ static void brcmstb_l2_intc_irq_handle(unsigned int irq, struct irq_desc *desc)
>  		~(__raw_readl(b->base + CPU_MASK_STATUS));
>  
>  	if (status == 0) {
> -		do_bad_IRQ(irq, desc);
> +		raw_spin_lock(&desc->lock);
> +		handle_bad_irq(irq, desc);
> +		raw_spin_unlock(&desc->lock);
>  		goto out;
>  	}
>  
> 

