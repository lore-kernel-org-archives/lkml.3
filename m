Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753808AbaKXO55 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 09:57:57 -0500
Received: from mga09.intel.com ([134.134.136.24]:35261 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750726AbaKXO54 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 09:57:56 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,449,1413270000"; 
   d="scan'208";a="613136593"
Message-ID: <5473476E.5070305@linux.intel.com>
Date: Mon, 24 Nov 2014 22:57:50 +0800
From: Jiang Liu <jiang.liu@linux.intel.com>
Organization: Intel
User-Agent: Mozilla/5.0 (Windows NT 6.2; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Marc Zyngier <marc.zyngier@arm.com>, Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Bjorn Helgaas <bhelgaas@google.com>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>,
        Will Deacon <will.deacon@arm.com>,
        Catalin marinas <catalin.marinas@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>,
        Robert Richter <robert.richter@caviumnetworks.com>,
        "Yun Wu (Abel)" <wuyun.wu@huawei.com>
Subject: Re: [PATCH v3 06/13] irqchip: GICv3: ITS: LPI allocator
References: <1416839720-18400-1-git-send-email-marc.zyngier@arm.com> <1416839720-18400-7-git-send-email-marc.zyngier@arm.com>
In-Reply-To: <1416839720-18400-7-git-send-email-marc.zyngier@arm.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 2014/11/24 22:35, Marc Zyngier wrote:
> LPIs are the type of interrupts that are used by the ITS. Given
> the size of the namespace (anywhere between 16 and 32bit), interrupt
> IDs are allocated in chunks of 32.
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  drivers/irqchip/irq-gic-v3-its.c | 103 +++++++++++++++++++++++++++++++++++++++
>  1 file changed, 103 insertions(+)
> 
> diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
> index d24bebd..4154a16 100644
> --- a/drivers/irqchip/irq-gic-v3-its.c
> +++ b/drivers/irqchip/irq-gic-v3-its.c
> @@ -586,3 +586,106 @@ static struct irq_chip its_irq_chip = {
>  	.irq_eoi		= its_eoi_irq,
>  	.irq_set_affinity	= its_set_affinity,
>  };
> +
> +/*
> + * How we allocate LPIs:
> + *
> + * The GIC has id_bits bits for interrupt identifiers. From there, we
> + * must subtract 8192 which are reserved for SGIs/PPIs/SPIs. Then, as
> + * we allocate LPIs by chunks of 32, we can shift the whole thing by 5
> + * bits to the right.
Just curious, why 32? sizeof(long) is 4 on ARM64?
