Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754413AbaGNJ6p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 05:58:45 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:36146 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752347AbaGNJ6i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 05:58:38 -0400
Date: Mon, 14 Jul 2014 10:57:47 +0100
From: Will Deacon <will.deacon@arm.com>
To: Liu hua <sdu.liu@huawei.com>
Cc: "tglx@linutronix.de" <tglx@linutronix.de>,
        "jason@lakedaemon.net" <jason@lakedaemon.net>,
        "nicolas.pitre@linaro.org" <nicolas.pitre@linaro.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "ebiederm@xmission.com" <ebiederm@xmission.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "wangnan0@huawei.com" <wangnan0@huawei.com>,
        "liuxueliu.liu@huawei.com" <liuxueliu.liu@huawei.com>,
        "peifeiyue@huawei.com" <peifeiyue@huawei.com>,
        "liusdu@126.com" <liusdu@126.com>, Marc Zyngier <Marc.Zyngier@arm.com>
Subject: Re: [RFC PATCH 0/2] irqchip: GIC: check and clear GIC interupt
 active status
Message-ID: <20140714095747.GB1779@arm.com>
References: <1405061177-43834-1-git-send-email-sdu.liu@huawei.com>
 <20140711123507.GE12899@arm.com>
 <53C34CF2.5050209@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53C34CF2.5050209@huawei.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 14, 2014 at 04:22:26AM +0100, Liu hua wrote:
> On 2014/7/11 20:35, Will Deacon wrote:
> > On Fri, Jul 11, 2014 at 07:46:15AM +0100, Liu Hua wrote:
> >> So guys, Do you know a better way to do that? 
> > What happens if, in the crash kernel, you disable the CPU interfaces
> > (GICC_CTLR.ENABLE) then disable the distributor (GICD_CTLR.ENABLE) before
> > enabling everything again in the reverse order? Is that enough to cause the
> > GIC to drop any active states? It's not clear to me from a quick look at
> > the TRM.
> > 
> 
> I did what you said at the beginning of "gic_dist_init". The active states
> remained (panic in local timer interrupt (PPI))and the kernel failed to boot,
> Did I do that at wrong place?
> 
> -------------------
> diff --git a/drivers/irqchip/irq-gic.c b/drivers/irqchip/irq-gic.c
> index b6b0a81..94d6352 100644
> --- a/drivers/irqchip/irq-gic.c
> +++ b/drivers/irqchip/irq-gic.c
> @@ -454,6 +455,7 @@ static void __init gic_dist_init(struct gic_chip_data *gic)
>         void __iomem *base = gic_data_dist_base(gic);
>         void __iomem *cpu_base = gic_data_cpu_base(gic);
> 
> + writel_relaxed(0, base + GIC_CPU_CTRL);
>         writel_relaxed(0, base + GIC_DIST_CTRL);
> 
>         /*
> ------------------------
> 
> As shown in GIC Architecture Specification manual,I think that the GICC_CTLR.ENABLE
> and GICD_CTLR.ENABLE only control the delivering of the interrupt, not the active
> states.
> 
> As GIC manual says "For every read of a valid Interrupt ID from the GICC_IAR, the
> connected processor must perform a matching write to the GICC_EOIR". So we should
> find a way to drop the active states when booting, if we do not remain these active
> states by design.

Understood, my suggestion above was a speculative effort to see what the
hardware would do. Something along the lines of what you've done in your
patch makes sense to me, but we'll need to wait for Marc's input (he's on
holiday at the moment).

Will
