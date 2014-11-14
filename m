Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754973AbaKNSaU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 13:30:20 -0500
Received: from service87.mimecast.com ([91.220.42.44]:57852 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754696AbaKNSaQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 13:30:16 -0500
Message-ID: <54664A32.5070200@arm.com>
Date: Fri, 14 Nov 2014 18:30:10 +0000
From: Marc Zyngier <marc.zyngier@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Yingjoe Chen <yingjoe.chen@mediatek.com>
CC: Thomas Gleixner <tglx@linutronix.de>,
        Jiang Liu <jiang.liu@linux.intel.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <Pawel.Moll@arm.com>,
        Mark Rutland <Mark.Rutland@arm.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Jason Cooper <jason@lakedaemon.net>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Yijing Wang <wangyijing@huawei.com>,
        "srv_heupstream@mediatek.com" <srv_heupstream@mediatek.com>,
        "yingjoe.chen@gmail.com" <yingjoe.chen@gmail.com>,
        "hc.yen@mediatek.com" <hc.yen@mediatek.com>,
        "eddie.huang@mediatek.com" <eddie.huang@mediatek.com>,
        "nathan.chung@mediatek.com" <nathan.chung@mediatek.com>,
        "yh.chen@mediatek.com" <yh.chen@mediatek.com>,
        Sascha Hauer <kernel@pengutronix.de>
Subject: Re: [PATCH v6 3/6] irqchip: gic: Support hierarchy irq domain.
References: <1415893029-2971-1-git-send-email-yingjoe.chen@mediatek.com> <1415893029-2971-4-git-send-email-yingjoe.chen@mediatek.com>
In-Reply-To: <1415893029-2971-4-git-send-email-yingjoe.chen@mediatek.com>
X-Enigmail-Version: 1.4.6
X-OriginalArrivalTime: 14 Nov 2014 18:30:12.0521 (UTC) FILETIME=[070D9190:01D00039]
X-MC-Unique: 114111418301401201
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13/11/14 15:37, Yingjoe Chen wrote:
> Add support to use gic as a parent for stacked irq domain.
> 
> Signed-off-by: Yingjoe Chen <yingjoe.chen@mediatek.com>
> ---
>  drivers/irqchip/Kconfig   |  1 +
>  drivers/irqchip/irq-gic.c | 80 ++++++++++++++++++++++++++++++++---------------
>  2 files changed, 55 insertions(+), 26 deletions(-)
> 
> diff --git a/drivers/irqchip/Kconfig b/drivers/irqchip/Kconfig
> index b21f12f..7f34138 100644
> --- a/drivers/irqchip/Kconfig
> +++ b/drivers/irqchip/Kconfig
> @@ -5,6 +5,7 @@ config IRQCHIP
>  config ARM_GIC
>  	bool
>  	select IRQ_DOMAIN
> +	select IRQ_DOMAIN_HIERARCHY
>  	select MULTI_IRQ_HANDLER
>  
>  config GIC_NON_BANKED
> diff --git a/drivers/irqchip/irq-gic.c b/drivers/irqchip/irq-gic.c
> index 38493ff..fe9ab93 100644
> --- a/drivers/irqchip/irq-gic.c
> +++ b/drivers/irqchip/irq-gic.c
> @@ -788,17 +788,16 @@ static int gic_irq_domain_map(struct irq_domain *d, unsigned int irq,
>  {
>  	if (hw < 32) {
>  		irq_set_percpu_devid(irq);
> -		irq_set_chip_and_handler(irq, &gic_chip,
> -					 handle_percpu_devid_irq);
> +		irq_domain_set_info(d, irq, hw, &gic_chip, d->host_data,
> +				    handle_percpu_devid_irq, NULL, NULL);
>  		set_irq_flags(irq, IRQF_VALID | IRQF_NOAUTOEN);
>  	} else {
> -		irq_set_chip_and_handler(irq, &gic_chip,
> -					 handle_fasteoi_irq);
> +		irq_domain_set_info(d, irq, hw, &gic_chip, d->host_data,
> +				    handle_fasteoi_irq, NULL, NULL);
>  		set_irq_flags(irq, IRQF_VALID | IRQF_PROBE);
>  
>  		gic_routable_irq_domain_ops->map(d, irq, hw);
>  	}
> -	irq_set_chip_data(irq, d->host_data);
>  	return 0;
>  }
>  
> @@ -814,8 +813,6 @@ static int gic_irq_domain_xlate(struct irq_domain *d,
>  {
>  	unsigned long ret = 0;
>  
> -	if (d->of_node != controller)
> -		return -EINVAL;

I'm not sure if removing that check is the right thing to do. You had to
remove it because your sysirq driver passes its own of_phandle_args
directly to the GIC code. I think that's a bad idea, and you should fix
the sysirq layer instead.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...

