Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751980AbaHCJtZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2014 05:49:25 -0400
Received: from mail-wi0-f181.google.com ([209.85.212.181]:64278 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751340AbaHCJtX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2014 05:49:23 -0400
Message-ID: <53DE0584.2040405@linaro.org>
Date: Sun, 03 Aug 2014 11:48:52 +0200
From: Eric Auger <eric.auger@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
CC: Will Deacon <will.deacon@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [RFC PATCH 7/9] KVM: arm: vgic: allow dynamic mapping of physical/virtual
 interrupts
References: <1403688530-23273-1-git-send-email-marc.zyngier@arm.com> <1403688530-23273-8-git-send-email-marc.zyngier@arm.com>
In-Reply-To: <1403688530-23273-8-git-send-email-marc.zyngier@arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/25/2014 11:28 AM, Marc Zyngier wrote:
> In order to be able to feed physical interrupts to a guest, we need
> to be able to establish the virtual-physical mapping between the two
> worlds.
> 
> As we try to keep the injection interface simple, find out what the
> physical interrupt is (if any) when we actually build the LR.
> 
> The mapping is kept in a rbtree, indexed by virtual interrupts.

Hi Marc,

I suspect there is a piece missing here related to bitmap state
management. When using maintenance IRQ, in process_maintenance we cleared
- dist->irq_pending (and new dist->irq_level)
- vcpu->irq_queued

Now this does not exist anymore for forwarded irqs, when a subsequent
IRQ will be injected, vgic_update_irq_pending will fail in injecting the
IRQ because the states are reflecting the IRQ is still in progress.

Since I have a modified version of your code, using Christoffer patches
I may have missed some modifications you did but at least on my side I
was forced to add bitmap clearing.

It is not clear to me where to put that code however. Since user-side
can inject an IRQ while the previous one is not completed at guest and
host level, it cannot be in update_irq_pending - or we shall prevent the
user from injecting fwd IRQs - .

In my case (VFIO/IRQFD), by construction I only inject a new forwarded
IRQ when the previous one was completed so I could put it in the irqfd
injection function. But even irqfd is injected through eventfd trigger.
We shall forbid the user-side to trigger that eventfd in place of the
VFIO driver. What do you think?

A question related to guest kill. Cannot it happen the guest sometimes
does not complete the vIRQ before exiting? Currently I observe cases
where when I launch qemu-system after a kill, forwarded irqs do not work
properly. I am not yet sure this is the cause of my problem but just in
case, can the host write into GICV_EOIR in place of guest?

Besides those problems, the patch works in my test environment

Best Regards

Eric

> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  include/kvm/arm_vgic.h             | 13 ++++++
>  include/linux/irqchip/arm-gic-v3.h |  3 ++
>  include/linux/irqchip/arm-gic.h    |  1 +
>  virt/kvm/arm/vgic-v2.c             | 14 +++++-
>  virt/kvm/arm/vgic-v3.c             | 22 +++++++++-
>  virt/kvm/arm/vgic.c                | 88 ++++++++++++++++++++++++++++++++++++++
>  6 files changed, 138 insertions(+), 3 deletions(-)
> 
> diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
> index 82e00a5..5f61dfa 100644
> --- a/include/kvm/arm_vgic.h
> +++ b/include/kvm/arm_vgic.h
> @@ -134,6 +134,12 @@ struct vgic_vm_ops {
>  	int	(*vgic_init)(struct kvm *kvm, const struct vgic_params *params);
>  };
>  
> +struct irq_phys_map {
> +	struct rb_node		node;
> +	u32			virt_irq;
> +	u32			phys_irq;
> +};
> +
>  struct vgic_dist {
>  #ifdef CONFIG_KVM_ARM_VGIC
>  	spinlock_t		lock;
> @@ -190,6 +196,8 @@ struct vgic_dist {
>  	unsigned long		irq_pending_on_cpu;
>  
>  	struct vgic_vm_ops	vm_ops;
> +
> +	struct rb_root		irq_phys_map;
>  #endif
>  };
>  
> @@ -237,6 +245,8 @@ struct vgic_cpu {
>  		struct vgic_v2_cpu_if	vgic_v2;
>  		struct vgic_v3_cpu_if	vgic_v3;
>  	};
> +
> +	struct rb_root	irq_phys_map;
>  #endif
>  };
>  
> @@ -265,6 +275,9 @@ void vgic_v3_dispatch_sgi(struct kvm_vcpu *vcpu, u64 reg);
>  int kvm_vgic_vcpu_pending_irq(struct kvm_vcpu *vcpu);
>  bool vgic_handle_mmio(struct kvm_vcpu *vcpu, struct kvm_run *run,
>  		      struct kvm_exit_mmio *mmio);
> +int vgic_map_phys_irq(struct kvm_vcpu *vcpu, int virt_irq, int phys_irq);
> +int vgic_get_phys_irq(struct kvm_vcpu *vcpu, int virt_irq);
> +int vgic_unmap_phys_irq(struct kvm_vcpu *vcpu, int virt_irq, int phys_irq);
>  
>  #define irqchip_in_kernel(k)	(!!((k)->arch.vgic.in_kernel))
>  #define vgic_initialized(k)	((k)->arch.vgic.ready)
> diff --git a/include/linux/irqchip/arm-gic-v3.h b/include/linux/irqchip/arm-gic-v3.h
> index 0e74c19..7753d18 100644
> --- a/include/linux/irqchip/arm-gic-v3.h
> +++ b/include/linux/irqchip/arm-gic-v3.h
> @@ -210,9 +210,12 @@
>  
>  #define ICH_LR_EOI			(1UL << 41)
>  #define ICH_LR_GROUP			(1UL << 60)
> +#define ICH_LR_HW			(1UL << 61)
>  #define ICH_LR_STATE			(3UL << 62)
>  #define ICH_LR_PENDING_BIT		(1UL << 62)
>  #define ICH_LR_ACTIVE_BIT		(1UL << 63)
> +#define ICH_LR_PHYS_ID_SHIFT		32
> +#define ICH_LR_PHYS_ID_MASK		(0x3ffUL << ICH_LR_PHYS_ID_SHIFT)
>  
>  #define ICH_MISR_EOI			(1 << 0)
>  #define ICH_MISR_U			(1 << 1)
> diff --git a/include/linux/irqchip/arm-gic.h b/include/linux/irqchip/arm-gic.h
> index ffe3911..18c4e29 100644
> --- a/include/linux/irqchip/arm-gic.h
> +++ b/include/linux/irqchip/arm-gic.h
> @@ -64,6 +64,7 @@
>  #define GICH_LR_PENDING_BIT		(1 << 28)
>  #define GICH_LR_ACTIVE_BIT		(1 << 29)
>  #define GICH_LR_EOI			(1 << 19)
> +#define GICH_LR_HW			(1 << 31);
>  
>  #define GICH_VMCR_CTRL_SHIFT		0
>  #define GICH_VMCR_CTRL_MASK		(0x21f << GICH_VMCR_CTRL_SHIFT)
> diff --git a/virt/kvm/arm/vgic-v2.c b/virt/kvm/arm/vgic-v2.c
> index 4091078..6764d44 100644
> --- a/virt/kvm/arm/vgic-v2.c
> +++ b/virt/kvm/arm/vgic-v2.c
> @@ -58,7 +58,9 @@ static struct vgic_lr vgic_v2_get_lr(const struct kvm_vcpu *vcpu, int lr)
>  static void vgic_v2_set_lr(struct kvm_vcpu *vcpu, int lr,
>  			   struct vgic_lr lr_desc)
>  {
> -	u32 lr_val = (lr_desc.source << GICH_LR_PHYSID_CPUID_SHIFT) | lr_desc.irq;
> +	u32 lr_val;
> +
> +	lr_val = lr_desc.irq;
>  
>  	if (lr_desc.state & LR_STATE_PENDING)
>  		lr_val |= GICH_LR_PENDING_BIT;
> @@ -67,6 +69,16 @@ static void vgic_v2_set_lr(struct kvm_vcpu *vcpu, int lr,
>  	if (lr_desc.state & LR_EOI_INT)
>  		lr_val |= GICH_LR_EOI;
>  
> +	if (lr_desc.irq < VGIC_NR_SGIS) {
> +		lr_val |= (lr_desc.source << GICH_LR_PHYSID_CPUID_SHIFT);
> +	} else {
> +		int phys_irq = vgic_get_phys_irq(vcpu, lr_desc.irq);
> +		if (phys_irq >= 0) {
> +			lr_val |= ((u32)phys_irq) << GICH_LR_PHYSID_CPUID_SHIFT;
> +			lr_val |= GICH_LR_HW;
> +		}
> +	}
> +
>  	vcpu->arch.vgic_cpu.vgic_v2.vgic_lr[lr] = lr_val;
>  }
>  
> diff --git a/virt/kvm/arm/vgic-v3.c b/virt/kvm/arm/vgic-v3.c
> index d26d12f..41dee6c 100644
> --- a/virt/kvm/arm/vgic-v3.c
> +++ b/virt/kvm/arm/vgic-v3.c
> @@ -116,6 +116,15 @@ static void vgic_v3_on_v3_set_lr(struct kvm_vcpu *vcpu, int lr,
>  
>  	lr_val |= sync_lr_val(lr_desc.state);
>  
> +	if (lr_desc.irq >= VGIC_NR_SGIS) {
> +		int phys_irq;
> +		phys_irq = vgic_get_phys_irq(vcpu, lr_desc.irq);
> +		if (phys_irq >= 0) {
> +			lr_val |= ((u64)phys_irq) << ICH_LR_PHYS_ID_SHIFT;
> +			lr_val |= ICH_LR_HW;
> +		}
> +	}
> +
>  	vcpu->arch.vgic_cpu.vgic_v3.vgic_lr[LR_INDEX(lr)] = lr_val;
>  }
>  
> @@ -126,10 +135,19 @@ static void vgic_v2_on_v3_set_lr(struct kvm_vcpu *vcpu, int lr,
>  
>  	lr_val = lr_desc.irq;
>  
> -	lr_val |= (u32)lr_desc.source << GICH_LR_PHYSID_CPUID_SHIFT;
> -
>  	lr_val |= sync_lr_val(lr_desc.state);
>  
> +	if (lr_desc.irq < VGIC_NR_SGIS) {
> +		lr_val |= (u32)lr_desc.source << GICH_LR_PHYSID_CPUID_SHIFT;
> +	} else {
> +		int phys_irq;
> +		phys_irq = vgic_get_phys_irq(vcpu, lr_desc.irq);
> +		if (phys_irq >= 0) {
> +			lr_val |= ((u64)phys_irq) << ICH_LR_PHYS_ID_SHIFT;
> +			lr_val |= ICH_LR_HW;
> +		}
> +	}
> +
>  	vcpu->arch.vgic_cpu.vgic_v3.vgic_lr[LR_INDEX(lr)] = lr_val;
>  }
>  
> diff --git a/virt/kvm/arm/vgic.c b/virt/kvm/arm/vgic.c
> index e3c7189..c404682c 100644
> --- a/virt/kvm/arm/vgic.c
> +++ b/virt/kvm/arm/vgic.c
> @@ -24,6 +24,7 @@
>  #include <linux/of.h>
>  #include <linux/of_address.h>
>  #include <linux/of_irq.h>
> +#include <linux/rbtree.h>
>  #include <linux/uaccess.h>
>  
>  #include <linux/irqchip/arm-gic.h>
> @@ -1163,6 +1164,93 @@ static irqreturn_t vgic_maintenance_handler(int irq, void *data)
>  	return IRQ_HANDLED;
>  }
>  
> +static struct rb_root *vgic_get_irq_phys_map(struct kvm_vcpu *vcpu,
> +					     int virt_irq)
> +{
> +	if (virt_irq < VGIC_NR_PRIVATE_IRQS)
> +		return &vcpu->arch.vgic_cpu.irq_phys_map;
> +	else
> +		return &vcpu->kvm->arch.vgic.irq_phys_map;
> +}
> +
> +int vgic_map_phys_irq(struct kvm_vcpu *vcpu, int virt_irq, int phys_irq)
> +{
> +	struct rb_root *root = vgic_get_irq_phys_map(vcpu, virt_irq);
> +	struct rb_node **new = &root->rb_node, *parent = NULL;
> +	struct irq_phys_map *new_map;
> +
> +	/* Boilerplate rb_tree code */
> +	while (*new) {
> +		struct irq_phys_map *this;
> +
> +		this = container_of(*new, struct irq_phys_map, node);
> +		parent = *new;
> +		if (this->virt_irq < virt_irq)
> +			new = &(*new)->rb_left;
> +		else if (this->virt_irq > virt_irq)
> +			new = &(*new)->rb_right;
> +		else
> +			return -EEXIST;
> +	}
> +
> +	new_map = kzalloc(sizeof(*new_map), GFP_KERNEL);
> +	if (!new_map)
> +		return -ENOMEM;
> +
> +	new_map->virt_irq = virt_irq;
> +	new_map->phys_irq = phys_irq;
> +
> +	rb_link_node(&new_map->node, parent, new);
> +	rb_insert_color(&new_map->node, root);
> +
> +	return 0;
> +}
> +
> +static struct irq_phys_map *vgic_irq_map_search(struct kvm_vcpu *vcpu,
> +						int virt_irq)
> +{
> +	struct rb_root *root = vgic_get_irq_phys_map(vcpu, virt_irq);
> +	struct rb_node *node = root->rb_node;
> +
> +	while(node) {
> +		struct irq_phys_map *this;
> +
> +		this = container_of(node, struct irq_phys_map, node);
> +
> +		if (this->virt_irq < virt_irq)
> +			node = node->rb_left;
> +		else if (this->virt_irq > virt_irq)
> +			node = node->rb_right;
> +		else
> +			return this;
> +	}
> +
> +	return NULL;
> +}
> +
> +int vgic_get_phys_irq(struct kvm_vcpu *vcpu, int virt_irq)
> +{
> +	struct irq_phys_map *map = vgic_irq_map_search(vcpu, virt_irq);
> +
> +	if (map)
> +		return map->phys_irq;
> +
> +	return -ENOENT;
> +}
> +
> +int vgic_unmap_phys_irq(struct kvm_vcpu *vcpu, int virt_irq, int phys_irq)
> +{
> +	struct irq_phys_map *map = vgic_irq_map_search(vcpu, virt_irq);
> +
> +	if (map && map->phys_irq == phys_irq) {
> +		rb_erase(&map->node, vgic_get_irq_phys_map(vcpu, virt_irq));
> +		kfree(map);
> +		return 0;
> +	}
> +
> +	return -ENOENT;
> +}
> +
>  static void vgic_vcpu_free_maps(struct vgic_cpu *vgic_cpu)
>  {
>  	kfree(vgic_cpu->pending_shared);
> 

