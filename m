Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751976AbaHRPG0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 11:06:26 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:64105 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750806AbaHRPGZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 11:06:25 -0400
Message-ID: <53F21668.5090500@redhat.com>
Date: Mon, 18 Aug 2014 17:06:16 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Andreea-Cristina Bernat <bernat.ada@gmail.com>, gleb@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
CC: paulmck@linux.vnet.ibm.com, monamagarwal123@gmail.com
Subject: Re: [PATCH] eventfd: Replace rcu_assign_pointer() with RCU_INIT_POINTER()
References: <20140818150129.GA14447@ada>
In-Reply-To: <20140818150129.GA14447@ada>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 18/08/2014 17:01, Andreea-Cristina Bernat ha scritto:
> The uses of "rcu_assign_pointer()" are NULLing out the pointers.
> According to RCU_INIT_POINTER()'s block comment:
> "1.   This use of RCU_INIT_POINTER() is NULLing out the pointer"
> it is better to use it instead of rcu_assign_pointer() because it has a
> smaller overhead.
> 
> The following Coccinelle semantic patch was used:
> @@
> @@
> 
> - rcu_assign_pointer
> + RCU_INIT_POINTER
>   (..., NULL)
> 
> Signed-off-by: Andreea-Cristina Bernat <bernat.ada@gmail.com>
> ---
>  virt/kvm/eventfd.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
> index 20c3af7..a49130f 100644
> --- a/virt/kvm/eventfd.c
> +++ b/virt/kvm/eventfd.c
> @@ -278,7 +278,7 @@ static void irqfd_update(struct kvm *kvm, struct _irqfd *irqfd,
>  	struct kvm_kernel_irq_routing_entry *e;
>  
>  	if (irqfd->gsi >= irq_rt->nr_rt_entries) {
> -		rcu_assign_pointer(irqfd->irq_entry, NULL);
> +		RCU_INIT_POINTER(irqfd->irq_entry, NULL);
>  		return;
>  	}
>  
> @@ -287,7 +287,7 @@ static void irqfd_update(struct kvm *kvm, struct _irqfd *irqfd,
>  		if (e->type == KVM_IRQ_ROUTING_MSI)
>  			rcu_assign_pointer(irqfd->irq_entry, e);
>  		else
> -			rcu_assign_pointer(irqfd->irq_entry, NULL);
> +			RCU_INIT_POINTER(irqfd->irq_entry, NULL);
>  	}
>  }
>  
> @@ -473,7 +473,7 @@ kvm_irqfd_deassign(struct kvm *kvm, struct kvm_irqfd *args)
>  			 * It is paired with synchronize_srcu done by caller
>  			 * of that function.
>  			 */
> -			rcu_assign_pointer(irqfd->irq_entry, NULL);
> +			RCU_INIT_POINTER(irqfd->irq_entry, NULL);
>  			irqfd_deactivate(irqfd);
>  		}
>  	}
> 

Hi, this patch actually had been submitted already last March.  It
slipped through the cracks.  I'm now applying both of Monam Agarwal's
RCU_INIT_POINTER patches.  Sorry. :)

Thanks,

Paolo
