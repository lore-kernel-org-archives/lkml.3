Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752037AbbA0Fdr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 00:33:47 -0500
Received: from mga02.intel.com ([134.134.136.20]:25140 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750864AbbA0Fdm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 00:33:42 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,472,1418112000"; 
   d="scan'208";a="518071440"
Message-ID: <54C72333.7060601@linux.intel.com>
Date: Tue, 27 Jan 2015 13:33:39 +0800
From: Jiang Liu <jiang.liu@linux.intel.com>
Organization: Intel
User-Agent: Mozilla/5.0 (Windows NT 6.2; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Marc Zyngier <marc.zyngier@arm.com>, Thomas Gleixner <tglx@linutronix.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] genirq: MSI: Fix freeing of unallocated MSI
References: <1422299419-6051-1-git-send-email-marc.zyngier@arm.com>
In-Reply-To: <1422299419-6051-1-git-send-email-marc.zyngier@arm.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2015/1/27 3:10, Marc Zyngier wrote:
> While debugging an unrelated issue with the GICv3 ITS driver, the
> following trace triggered:
> 
> WARNING: CPU: 1 PID: 1 at kernel/irq/irqdomain.c:1121 irq_domain_free_irqs+0x160/0x17c()
> NULL pointer, cannot free irq
> Modules linked in:
> CPU: 1 PID: 1 Comm: swapper/0 Tainted: G        W      3.19.0-rc6+ #3690
> Hardware name: FVP Base (DT)
> Call trace:
> [<ffffffc000089398>] dump_backtrace+0x0/0x13c
> [<ffffffc0000894e4>] show_stack+0x10/0x1c
> [<ffffffc00066d134>] dump_stack+0x74/0x94
> [<ffffffc0000a92f8>] warn_slowpath_common+0x9c/0xd4
> [<ffffffc0000a938c>] warn_slowpath_fmt+0x5c/0x80
> [<ffffffc0000ee04c>] irq_domain_free_irqs+0x15c/0x17c
> [<ffffffc0000ef918>] msi_domain_free_irqs+0x58/0x74
> [<ffffffc000386f58>] free_msi_irqs+0xb4/0x1c0
> 
>     // The msi_prepare callback fails here
> 
> [<ffffffc0003872c0>] pci_enable_msix+0x25c/0x3d4
> [<ffffffc00038746c>] pci_enable_msix_range+0x34/0x80
> [<ffffffc0003924ac>] vp_try_to_find_vqs+0xec/0x528
> [<ffffffc000392954>] vp_find_vqs+0x6c/0xa8
> [<ffffffc0003ee2a8>] init_vq+0x120/0x248
> [<ffffffc0003eefb0>] virtblk_probe+0xb0/0x6bc
> [<ffffffc00038fc34>] virtio_dev_probe+0x17c/0x214
> [<ffffffc0003d4a04>] driver_probe_device+0x7c/0x23c
> [<ffffffc0003d4cb0>] __driver_attach+0x98/0xa0
> [<ffffffc0003d2c60>] bus_for_each_dev+0x60/0xb4
> [<ffffffc0003d455c>] driver_attach+0x1c/0x28
> [<ffffffc0003d41b0>] bus_add_driver+0x150/0x208
> [<ffffffc0003d54c0>] driver_register+0x64/0x130
> [<ffffffc00038f9e8>] register_virtio_driver+0x24/0x68
> [<ffffffc00091320c>] init+0x70/0xac
> [<ffffffc0000828f0>] do_one_initcall+0x94/0x1d0
> [<ffffffc0008e9b00>] kernel_init_freeable+0x144/0x1e4
> [<ffffffc00066a434>] kernel_init+0xc/0xd8
> ---[ end trace f9ee562a77cc7bae ]---
> 
> The ITS msi_prepare callback having failed, we end-up trying to
> free MSIs that have never been allocated. Oddly enough, the kernel
> is pretty upset about it.
> 
> It turns out that this behaviour was expected before the MSI domain
> was introduced (and dealt with in arch_teardown_msi_irqs).
> 
> The obvious fix is to detect this early enough and bail out.
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  kernel/irq/msi.c | 11 +++++++++--
>  1 file changed, 9 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/irq/msi.c b/kernel/irq/msi.c
> index 3e18163..474de5c 100644
> --- a/kernel/irq/msi.c
> +++ b/kernel/irq/msi.c
> @@ -310,8 +310,15 @@ void msi_domain_free_irqs(struct irq_domain *domain, struct device *dev)
>  	struct msi_desc *desc;
>  
>  	for_each_msi_entry(desc, dev) {
> -		irq_domain_free_irqs(desc->irq, desc->nvec_used);
> -		desc->irq = 0;
> +		/*
> +		 * We might have failed to allocate an MSI early
> +		 * enough that there is no IRQ associated to this
> +		 * entry. If that's the case, don't do anything.
> +		 */
> +		if (desc->irq) {
> +			irq_domain_free_irqs(desc->irq, desc->nvec_used);
> +			desc->irq = 0;
> +		}
>  	}
>  }
>  
> 
Review-by: Jiang Liu <jiang.liu@linux.intel.com>
