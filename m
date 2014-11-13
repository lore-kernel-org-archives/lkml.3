Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932375AbaKMJ5j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 04:57:39 -0500
Received: from mailgw01.mediatek.com ([210.61.82.183]:43613 "EHLO
	mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S932225AbaKMJ5g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 04:57:36 -0500
X-Listener-Flag: 11101
Subject: Re: [patch 07/16] genirq: Introduce helper irq_domain_set_info()
 to reduce duplicated code
From: Yingjoe Chen <yingjoe.chen@mediatek.com>
To: Thomas Gleixner <tglx@linutronix.de>
CC: LKML <linux-kernel@vger.kernel.org>, Jiang Liu <jiang.liu@linux.intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Grant Likely <grant.likely@linaro.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Yijing Wang <wangyijing@huawei.com>
In-Reply-To: <20141112134120.393705922@linutronix.de>
References: <20141112133941.647950773@linutronix.de>
	 <20141112134120.393705922@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 13 Nov 2014 17:57:29 +0800
Message-ID: <1415872649.17958.37.camel@mtksdaap41>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
X-MTK: N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2014-11-12 at 13:43 +0000, Thomas Gleixner wrote:
> plain text document attachment
> (rfc-part4-v1-02-17-genirq-introduce-helper-irq_domain_set_info-to-reduce-duplicated-code.patch)
> From: Jiang Liu <jiang.liu@linux.intel.com>
> 
> Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
> Cc: Bjorn Helgaas <bhelgaas@google.com>
> Cc: Grant Likely <grant.likely@linaro.org>
> Cc: Marc Zyngier <marc.zyngier@arm.com>
> Cc: Yingjoe Chen <yingjoe.chen@mediatek.com>
> Cc: Yijing Wang <wangyijing@huawei.com>
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> ---
>  include/linux/irqdomain.h |    5 +++++
>  kernel/irq/irqdomain.c    |   10 ++++++++++
>  2 files changed, 15 insertions(+)
> 
> Index: tip/include/linux/irqdomain.h
> ===================================================================
> --- tip.orig/include/linux/irqdomain.h
> +++ tip/include/linux/irqdomain.h
> @@ -33,6 +33,7 @@
>  #define _LINUX_IRQDOMAIN_H
>  
>  #include <linux/types.h>
> +#include <linux/irqhandler.h>
>  #include <linux/radix-tree.h>
>  
>  struct device_node;
> @@ -263,6 +264,10 @@ extern int irq_domain_set_hwirq_and_chip
>  					 irq_hw_number_t hwirq,
>  					 struct irq_chip *chip,
>  					 void *chip_data);
> +extern void irq_domain_set_info(struct irq_domain *domain, unsigned int virq,
> +				irq_hw_number_t hwirq, struct irq_chip *chip,
> +				void *chip_data, irq_flow_handler_t handler,
> +				void *handler_data, const char *handler_name);
>  extern void irq_domain_reset_irq_data(struct irq_data *irq_data);
>  extern void irq_domain_free_irqs_common(struct irq_domain *domain,
>  					int virq, int nr_irqs);
> Index: tip/kernel/irq/irqdomain.c
> ===================================================================
> --- tip.orig/kernel/irq/irqdomain.c
> +++ tip/kernel/irq/irqdomain.c
> @@ -882,6 +882,16 @@ int irq_domain_set_hwirq_and_chip(struct
>  	return 0;
>  }
>  
> +void irq_domain_set_info(struct irq_domain *domain, unsigned int virq,
> +			 irq_hw_number_t hwirq, struct irq_chip *chip,
> +			 void *chip_data, irq_flow_handler_t handler,
> +			 void *handler_data, const char *handler_name)
> +{
> +	irq_domain_set_hwirq_and_chip(domain, virq, hwirq, chip, chip_data);
> +	__irq_set_handler(virq, handler, 0, handler_name);
> +	irq_set_handler_data(virq, handler_data);
> +}
> +

Hi,

While trying to use this function, I'm not sure about its interface.
This function have 8 parameters but only save 3 function calls. After
checking uses in Jiang's original patch, I think this make code harder
to understand.

Joe.C


