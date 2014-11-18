Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754092AbaKRJ12 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 04:27:28 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:58301 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754004AbaKRJ1Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 04:27:25 -0500
Message-ID: <546B10DF.7020807@huawei.com>
Date: Tue, 18 Nov 2014 17:26:55 +0800
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
Subject: Re: [patch 08/16] genirq: Introduce callback irq_chip.irq_write_msi_msg
References: <20141112133941.647950773@linutronix.de> <20141112134120.474411359@linutronix.de>
In-Reply-To: <20141112134120.474411359@linutronix.de>
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.24.136]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas, Jiang,
On 2014/11/12 21:43, Thomas Gleixner wrote:

> From: Jiang Liu <jiang.liu@linux.intel.com>
> 
> Introduce callback irq_chip.irq_write_msi_msg, so we can share common
> code among MSI alike interrupt controllers, such as HPET and DMAR.
> 
> Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
> Cc: Bjorn Helgaas <bhelgaas@google.com>
> Cc: Grant Likely <grant.likely@linaro.org>
> Cc: Marc Zyngier <marc.zyngier@arm.com>
> Cc: Yingjoe Chen <yingjoe.chen@mediatek.com>
> Cc: Yijing Wang <wangyijing@huawei.com>
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> ---
>  include/linux/irq.h |    8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> Index: tip/include/linux/irq.h
> ===================================================================
> --- tip.orig/include/linux/irq.h
> +++ tip/include/linux/irq.h
> @@ -322,6 +322,7 @@ static inline irq_hw_number_t irqd_to_hw
>   * @irq_release_resources:	optional to release resources acquired with
>   *				irq_request_resources
>   * @irq_compose_msi_msg:	optional to compose message content for MSI
> + * @irq_write_msi_msg:	optional to write message content for MSI
>   * @flags:		chip specific flags
>   */
>  struct irq_chip {
> @@ -359,6 +360,7 @@ struct irq_chip {
>  	void		(*irq_release_resources)(struct irq_data *data);
>  
>  	void		(*irq_compose_msi_msg)(struct irq_data *data, struct msi_msg *msg);
> +	void		(*irq_write_msi_msg)(struct irq_data *data, struct msi_msg *msg);

Hmm... It's really weird.
I don't think it's the interrupt controllers' responsibility to write messages
for all the endpoint devices since the methods of configuring message registers
may different between these devices. And theoretically, the endpoint devices
themselves should take the responsibility to configure their message registers.
To say the least, the write_msg callback here still need to call some certain
interfaces provided by the corresponding device.
There would be lots of ARM new devices capable of sending message based interrupts
to interrupt controllers, does all the drivers of the devices need to expose a
write_msg callback to interrupt controllers?

Regards,
	Abel

>  
>  	unsigned long	flags;
>  };
> @@ -453,6 +455,12 @@ extern void irq_chip_ack_parent(struct i
>  extern int irq_chip_retrigger_hierarchy(struct irq_data *data);
>  #endif
>  
> +static inline void irq_chip_write_msi_msg(struct irq_data *data,
> +					  struct msi_msg *msg)
> +{
> +	data->chip->irq_write_msi_msg(data, msg);
> +}
> +
>  /* Handling of unhandled and spurious interrupts: */
>  extern void note_interrupt(unsigned int irq, struct irq_desc *desc,
>  			   irqreturn_t action_ret);
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> .
> 
> 



