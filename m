Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751215AbaLQQVY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 11:21:24 -0500
Received: from plane.gmane.org ([80.91.229.3]:54502 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750885AbaLQQVX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 11:21:23 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [v3 16/26] KVM: Make struct kvm_irq_routing_table accessible
Date: Wed, 17 Dec 2014 17:17:45 +0100
Message-ID: <5491ACA9.5020507@redhat.com>
References: <1418397300-10870-1-git-send-email-feng.wu@intel.com> <1418397300-10870-17-git-send-email-feng.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
Cc: iommu@lists.linux-foundation.org, kvm@vger.kernel.org
X-Gmane-NNTP-Posting-Host: net-2-35-193-40.cust.vodafonedsl.it
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
In-Reply-To: <1418397300-10870-17-git-send-email-feng.wu@intel.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 12/12/2014 16:14, Feng Wu wrote:
> Move struct kvm_irq_routing_table from irqchip.c to kvm_host.h,
> so we can use it outside of irqchip.c.
> 
> Signed-off-by: Feng Wu <feng.wu@intel.com>
> ---
>  include/linux/kvm_host.h | 19 +++++++++++++++++++
>  virt/kvm/irqchip.c       | 11 -----------
>  2 files changed, 19 insertions(+), 11 deletions(-)
> 
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 0b9659d..cfa85ac 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -335,6 +335,25 @@ struct kvm_kernel_irq_routing_entry {
>  	struct hlist_node link;
>  };
>  
> +#ifdef CONFIG_HAVE_KVM_IRQ_ROUTING
> +
> +struct kvm_irq_routing_table {
> +	int chip[KVM_NR_IRQCHIPS][KVM_IRQCHIP_NUM_PINS];
> +	struct kvm_kernel_irq_routing_entry *rt_entries;
> +	u32 nr_rt_entries;
> +	/*
> +	 * Array indexed by gsi. Each entry contains list of irq chips
> +	 * the gsi is connected to.
> +	 */
> +	struct hlist_head map[0];
> +};
> +
> +#else
> +
> +struct kvm_irq_routing_table {};

If possible, just make this "struct kvm_irq_routing_table;" and pull
this line to include/linux/kvm_types.h.

Paolo

> +
> +#endif
> +
>  #ifndef KVM_PRIVATE_MEM_SLOTS
>  #define KVM_PRIVATE_MEM_SLOTS 0
>  #endif
> diff --git a/virt/kvm/irqchip.c b/virt/kvm/irqchip.c
> index 7f256f3..cdf29a6 100644
> --- a/virt/kvm/irqchip.c
> +++ b/virt/kvm/irqchip.c
> @@ -31,17 +31,6 @@
>  #include <trace/events/kvm.h>
>  #include "irq.h"
>  
> -struct kvm_irq_routing_table {
> -	int chip[KVM_NR_IRQCHIPS][KVM_IRQCHIP_NUM_PINS];
> -	struct kvm_kernel_irq_routing_entry *rt_entries;
> -	u32 nr_rt_entries;
> -	/*
> -	 * Array indexed by gsi. Each entry contains list of irq chips
> -	 * the gsi is connected to.
> -	 */
> -	struct hlist_head map[0];
> -};
> -
>  int kvm_irq_map_gsi(struct kvm *kvm,
>  		    struct kvm_kernel_irq_routing_entry *entries, int gsi)
>  {
> 

