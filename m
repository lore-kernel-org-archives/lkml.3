Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754038AbaKRJ1O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 04:27:14 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:58138 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754004AbaKRJ1M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 04:27:12 -0500
Message-ID: <546B10D2.4050300@huawei.com>
Date: Tue, 18 Nov 2014 17:26:42 +0800
From: "Yun Wu (Abel)" <wuyun.wu@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: LKML <linux-kernel@vger.kernel.org>, Jiang Liu <jiang.liu@linux.intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "Grant Likely" <grant.likely@linaro.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>,
        Yijing Wang <wangyijing@huawei.com>
Subject: Re: [patch 04/16] genirq: Introduce irq_chip.irq_compose_msi_msg()
 to support stacked irqchip
References: <20141112133941.647950773@linutronix.de> <20141112134120.137871641@linutronix.de>
In-Reply-To: <20141112134120.137871641@linutronix.de>
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.24.136]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/11/12 21:42, Thomas Gleixner wrote:

> From: Jiang Liu <jiang.liu@linux.intel.com>
> 
> Add callback irq_compose_msi_msg to struct irq_chip, which will be used
> to support stacked irqchip.
> 
> Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
> Cc: Bjorn Helgaas <bhelgaas@google.com>
> Cc: Grant Likely <grant.likely@linaro.org>
> Cc: Marc Zyngier <marc.zyngier@arm.com>
> Cc: Yingjoe Chen <yingjoe.chen@mediatek.com>
> Cc: Yijing Wang <wangyijing@huawei.com>
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> ---
>  include/linux/irq.h |    5 +++++
>  kernel/irq/chip.c   |   17 +++++++++++++++++
>  2 files changed, 22 insertions(+)
> 
> diff --git a/include/linux/irq.h b/include/linux/irq.h
> index 0adcbbbf2e87..536b7fc6c8f4 100644
> --- a/include/linux/irq.h
> +++ b/include/linux/irq.h
> @@ -29,6 +29,7 @@ struct seq_file;
>  struct module;
>  struct irq_desc;
>  struct irq_data;
> +struct msi_msg;
>  typedef	void (*irq_flow_handler_t)(unsigned int irq,
>  					    struct irq_desc *desc);
>  typedef	void (*irq_preflow_handler_t)(struct irq_data *data);
> @@ -320,6 +321,7 @@ static inline irq_hw_number_t irqd_to_hwirq(struct irq_data *d)
>   *				any other callback related to this irq
>   * @irq_release_resources:	optional to release resources acquired with
>   *				irq_request_resources
> + * @irq_compose_msi_msg:	optional to compose message content for MSI
>   * @flags:		chip specific flags
>   */
>  struct irq_chip {
> @@ -356,6 +358,8 @@ struct irq_chip {
>  	int		(*irq_request_resources)(struct irq_data *data);
>  	void		(*irq_release_resources)(struct irq_data *data);
>  
> +	void		(*irq_compose_msi_msg)(struct irq_data *data, struct msi_msg *msg);
> +
>  	unsigned long	flags;
>  };
>  
> @@ -443,6 +447,7 @@ extern void handle_percpu_devid_irq(unsigned int irq, struct irq_desc *desc);
>  extern void handle_bad_irq(unsigned int irq, struct irq_desc *desc);
>  extern void handle_nested_irq(unsigned int irq);
>  
> +extern int irq_chip_compose_msi_msg(struct irq_data *data, struct msi_msg *msg);
>  #ifdef	CONFIG_IRQ_DOMAIN_HIERARCHY
>  extern void irq_chip_ack_parent(struct irq_data *data);
>  extern int irq_chip_retrigger_hierarchy(struct irq_data *data);
> diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
> index 12f3e72449eb..8f362db17a8a 100644
> --- a/kernel/irq/chip.c
> +++ b/kernel/irq/chip.c
> @@ -867,3 +867,20 @@ int irq_chip_retrigger_hierarchy(struct irq_data *data)
>  	return -ENOSYS;
>  }
>  #endif
> +
> +int irq_chip_compose_msi_msg(struct irq_data *data, struct msi_msg *msg)
> +{
> +	struct irq_data *pos = NULL;
> +
> +#ifdef	CONFIG_IRQ_DOMAIN_HIERARCHY
> +	for (; data; data = data->parent_data)
> +#endif
> +		if (data->chip && data->chip->irq_compose_msi_msg)
> +			pos = data;
> +	if (!pos)
> +		return -ENOSYS;
> +
> +	pos->chip->irq_compose_msi_msg(pos, msg);
> +
> +	return 0;
> +}

Adding message composing routine to struct irq_chip is OK to me, and it should
be because it is interrupt controllers' duty to compose messages (so that they
can parse the messages correctly without any pre-defined rules that endpoint
devices absolutely need not to know).
However a problem comes out when deciding which parameters should be passed to
this routine. A message can associate with multiple interrupts, which makes me
think composing messages for each interrupt is not that appropriate. And we
can take a look at the new routine irq_chip_compose_msi_msg(). It is called by
msi_domain_activate() which will be called by irq_domain_activate_irq() in
irq_startup() for each interrupt descriptor, result in composing a message for
each interrupt, right? (Unless requiring a judge on the parameter @data when
implementing the irq_compose_msi_msg() callback that only compose message for
the first entry of that message. But I really don't like that...)

Regards,
	Abel

