Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934206AbaKMUXq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 15:23:46 -0500
Received: from service87.mimecast.com ([91.220.42.44]:53273 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934041AbaKMUXn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 15:23:43 -0500
Message-ID: <5465134B.7070709@arm.com>
Date: Thu, 13 Nov 2014 20:23:39 +0000
From: Marc Zyngier <marc.zyngier@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Jiang Liu <jiang.liu@linux.intel.com>
CC: Bjorn Helgaas <bhelgaas@google.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Yijing Wang <wangyijing@huawei.com>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>,
        Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Alexander Gordeev <agordeev@redhat.com>,
        Tony Luck <tony.luck@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [Patch V1 3/6] genirq: Introduce msi_domain_{alloc|free}_irqs()
References: <1415879029-20098-1-git-send-email-jiang.liu@linux.intel.com> <1415879029-20098-4-git-send-email-jiang.liu@linux.intel.com>
In-Reply-To: <1415879029-20098-4-git-send-email-jiang.liu@linux.intel.com>
X-Enigmail-Version: 1.4.6
X-OriginalArrivalTime: 13 Nov 2014 20:23:40.0758 (UTC) FILETIME=[B6AA5760:01CFFF7F]
X-MC-Unique: 114111320234100201
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13/11/14 11:43, Jiang Liu wrote:
> Introduce msi_domain_{alloc|free}_irqs() to alloc/free interrupts
> from generic MSI irqdomain.
> 
> Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
> ---
>  include/linux/msi.h |   35 ++++++++++++++++++++++++++++++
>  kernel/irq/msi.c    |   59 +++++++++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 94 insertions(+)
> 
> diff --git a/include/linux/msi.h b/include/linux/msi.h
> index 714716a3ffdd..6b356a1410b2 100644
> --- a/include/linux/msi.h
> +++ b/include/linux/msi.h
> @@ -3,6 +3,7 @@
>  
>  #include <linux/kobject.h>
>  #include <linux/list.h>
> +#include <asm/hw_irq.h>		/* for msi_alloc_info_t */
>  
>  struct msi_msg {
>  	u32	address_lo;	/* low 32 bits of msi message address */
> @@ -100,7 +101,26 @@ struct irq_chip;
>  struct device_node;
>  struct msi_domain_info;
>  
> +#ifndef NUM_MSI_ALLOC_SCRATCHPAD_REGS
> +#define NUM_MSI_ALLOC_SCRATCHPAD_REGS	2
> +#endif
> +
> +/*
> + * Default structure for MSI interrupt allocation.
> + * Arch may overwrite it by define msi_alloc_info_t.
> + */
> +struct msi_alloc_info {
> +	struct msi_desc *desc;
> +	irq_hw_number_t hwirq;
> +	long		scratchpad[NUM_MSI_ALLOC_SCRATCHPAD_REGS];

As much as I'm relieved to see a generic structure here, could
scratchpad be slightly less awkward to use? Something like:

struct msi_alloc_info {
	[...]
	union	{
		unsigned long ul;
		void *ptr;
	} scratchpad[NUM_MSI_ALLOC_SCRATCHPAD_REGS];
};

That would avoid some very ugly casting.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...

