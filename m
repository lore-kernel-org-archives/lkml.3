Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751931AbaHDJnX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 05:43:23 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:46546 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751181AbaHDJnV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 05:43:21 -0400
Message-ID: <53DF55AC.5030705@arm.com>
Date: Mon, 04 Aug 2014 10:43:08 +0100
From: Marc Zyngier <marc.zyngier@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Liu Hua <sdu.liu@huawei.com>
CC: Will Deacon <Will.Deacon@arm.com>,
        "nicolas.pitre@linaro.org" <nicolas.pitre@linaro.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "peifeiyue@huawei.com" <peifeiyue@huawei.com>,
        "liusdu@126.com" <liusdu@126.com>,
        "wangnan0@huawei.com" <wangnan0@huawei.com>,
        "ebiederm@xmission.com" <ebiederm@xmission.com>
Subject: Re: [PATCH V2 1/1] GIC: introduce method to deactive interupts
References: <1407125860-37718-1-git-send-email-sdu.liu@huawei.com> <1407125860-37718-2-git-send-email-sdu.liu@huawei.com>
In-Reply-To: <1407125860-37718-2-git-send-email-sdu.liu@huawei.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Liu,

On 04/08/14 05:17, Liu Hua wrote:
> When using kdump on ARM platform, if kernel panics in interrupt handler
> (maybe PPI), the capture kernel can not recive certain interrupt, and 
> fails to boot.
> 
> On this situation, We have read register GICC_IAR. But we have no chance
> to write relative bit to register GICC_EOIR (kernel paniced before). So
> the state of this type interrupt remains active. And that makes gic not
> deliver this type interrupt to cpu interface.
> 
> So we should not assume that all interrut states of GIC are inactive when
> kernel inittailize the GIC. This patch will identify these type interrupts
> and deactive them
> 
> Signed-off-by: Liu Hua <sdu.liu@huawei.com>
> ---
>  drivers/irqchip/irq-gic.c | 26 ++++++++++++++++++++++++++
>  1 file changed, 26 insertions(+)
> 
> diff --git a/drivers/irqchip/irq-gic.c b/drivers/irqchip/irq-gic.c
> index b2648fc..7708df1 100644
> --- a/drivers/irqchip/irq-gic.c
> +++ b/drivers/irqchip/irq-gic.c
> @@ -351,12 +351,37 @@ static u8 gic_get_cpumask(struct gic_chip_data *gic)
>  	return mask;
>  }
>  
> +void gic_eois(u32 active, int irq_off, void __iomem *cpu_base)
> +{
> +	int bit = -1;
> +
> +	for_each_set_bit(bit, (unsigned long *)&active, 32)
> +		writel_relaxed(bit + irq_off, cpu_base + GIC_CPU_EOI);
> +}
> +
> +void gic_dist_clear_active(void __iomem *dist_base,
> +			void __iomem *cpu_base, int gic_irqs)
> +{
> +	int irq, offset;
> +	u32 active;
> +
> +	for (irq = 0; irq < gic_irqs; irq += 32) {
> +		offset = GIC_DIST_ACTIVE_SET + irq * 4 / 32;
> +		active = readl_relaxed(dist_base + offset);
> +		if (!active)
> +			continue;
> +		gic_eois(active, irq, cpu_base);
> +	}
> +}
> +
> +
>  static void __init gic_dist_init(struct gic_chip_data *gic)
>  {
>  	unsigned int i;
>  	u32 cpumask;
>  	unsigned int gic_irqs = gic->gic_irqs;
>  	void __iomem *base = gic_data_dist_base(gic);
> +	void __iomem *cpu_base = gic_data_cpu_base(gic);
>  
>  	writel_relaxed(0, base + GIC_DIST_CTRL);
>  
> @@ -371,6 +396,7 @@ static void __init gic_dist_init(struct gic_chip_data *gic)
>  
>  	gic_dist_config(base, gic_irqs, NULL);
>  
> +	gic_dist_clear_active(base, cpu_base, gic_irqs);
>  	writel_relaxed(1, base + GIC_DIST_CTRL);
>  }

So while this is solving a real issue, I don't think you can just fix it
for the UP case. You'll have to fix the same thing for secondary CPUs
(shouldn't be too hard to split things between local and global interrupts).

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
