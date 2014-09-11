Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752832AbaIKDJo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 23:09:44 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:60631 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751758AbaIKDJk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 23:09:40 -0400
Date: Thu, 11 Sep 2014 05:09:38 +0200
From: Christoffer Dall <christoffer.dall@linaro.org>
To: Eric Auger <eric.auger@linaro.org>
Cc: eric.auger@st.com, marc.zyngier@arm.com,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, alex.williamson@redhat.com, joel.schopp@amd.com,
        kim.phillips@freescale.com, paulus@samba.org, gleb@kernel.org,
        pbonzini@redhat.com, linux-kernel@vger.kernel.org, patches@linaro.org,
        will.deacon@arm.com, a.motakis@virtualopensystems.com,
        a.rigo@virtualopensystems.com, john.liuli@huawei.com
Subject: Re: [PATCH v3] ARM: KVM: add irqfd support
Message-ID: <20140911030938.GB2784@lvm>
References: <1409561584-8050-1-git-send-email-eric.auger@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1409561584-8050-1-git-send-email-eric.auger@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 01, 2014 at 10:53:04AM +0200, Eric Auger wrote:
> This patch enables irqfd on ARM.
> 
> irqfd framework enables to inject a virtual IRQ into a guest upon an
> eventfd trigger. User-side uses KVM_IRQFD VM ioctl to provide KVM with
> a kvm_irqfd struct that associates a VM, an eventfd, a virtual IRQ number
> (aka. the gsi). When an actor signals the eventfd (typically a VFIO
> platform driver), the kvm irqfd subsystem injects the provided virtual
> IRQ into the guest.
> 
> Resamplefd also is supported for level sensitive interrupts, ie. the
> user can provide another eventfd that is triggered when the completion
> of the virtual IRQ (gsi) is detected by the GIC.
> 
> The gsi must correspond to a shared peripheral interrupt (SPI), ie the
> GIC interrupt ID is gsi+32.
> 
> this patch enables CONFIG_HAVE_KVM_EVENTFD and CONFIG_HAVE_KVM_IRQFD.
> CONFIG_HAVE_KVM_IRQCHIP is removed. No IRQ routing table is used
> (irqchip.c and irqcomm.c are not used).
> 
> Both KVM_CAP_IRQFD & KVM_CAP_IRQFD_RESAMPLE capabilities are exposed
> 
> Signed-off-by: Eric Auger <eric.auger@linaro.org>
> 
> ---
> 
> This patch serie deprecates the previous serie featuring GSI routing
> (https://patches.linaro.org/32261/)
> 
> The patch serie has the following dependencies:
> - arm/arm64: KVM: Various VGIC cleanups and improvements
>   https://lists.cs.columbia.edu/pipermail/kvmarm/2014-June/009979.html
> - "KVM: EVENTFD: remove inclusion of irq.h"
> 
> All pieces can be found on git://git.linaro.org/people/eric.auger/linux.git
> branch irqfd_norouting_integ_v3
> 
> This work was tested with Calxeda Midway xgmac main interrupt with
> qemu-system-arm and QEMU VFIO platform device.
> 
> v2 -> v3:
> - removal of irq.h from eventfd.c put in a separate patch to increase
>   visibility
> - properly expose KVM_CAP_IRQFD capability in arm.c
> - remove CONFIG_HAVE_KVM_IRQCHIP meaningfull only if irq_comm.c is used
> 
> v1 -> v2:
> - rebase on 3.17rc1
> - move of the dist unlock in process_maintenance
> - remove of dist lock in __kvm_vgic_sync_hwstate
> - rewording of the commit message (add resamplefd reference)
> - remove irq.h
> ---
>  Documentation/virtual/kvm/api.txt |  5 +++-
>  arch/arm/include/uapi/asm/kvm.h   |  3 +++
>  arch/arm/kvm/Kconfig              |  4 +--
>  arch/arm/kvm/Makefile             |  2 +-
>  arch/arm/kvm/arm.c                |  3 +++
>  virt/kvm/arm/vgic.c               | 56 ++++++++++++++++++++++++++++++++++++---
>  6 files changed, 65 insertions(+), 8 deletions(-)
> 
> diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kvm/api.txt
> index beae3fd..8118b12 100644
> --- a/Documentation/virtual/kvm/api.txt
> +++ b/Documentation/virtual/kvm/api.txt
> @@ -2204,7 +2204,7 @@ into the hash PTE second double word).
>  4.75 KVM_IRQFD
>  
>  Capability: KVM_CAP_IRQFD
> -Architectures: x86 s390
> +Architectures: x86 s390 arm
>  Type: vm ioctl
>  Parameters: struct kvm_irqfd (in)
>  Returns: 0 on success, -1 on error
> @@ -2230,6 +2230,9 @@ Note that closing the resamplefd is not sufficient to disable the
>  irqfd.  The KVM_IRQFD_FLAG_RESAMPLE is only necessary on assignment
>  and need not be specified with KVM_IRQFD_FLAG_DEASSIGN.
>  
> +On ARM/arm64 the injected must be a shared peripheral interrupt (SPI).
> +This means the programmed GIC interrupt ID is gsi+32.
> +

See above comment.

>  4.76 KVM_PPC_ALLOCATE_HTAB
>  
>  Capability: KVM_CAP_PPC_ALLOC_HTAB
> diff --git a/arch/arm/include/uapi/asm/kvm.h b/arch/arm/include/uapi/asm/kvm.h
> index e6ebdd3..3034c66 100644
> --- a/arch/arm/include/uapi/asm/kvm.h
> +++ b/arch/arm/include/uapi/asm/kvm.h
> @@ -194,6 +194,9 @@ struct kvm_arch_memory_slot {
>  /* Highest supported SPI, from VGIC_NR_IRQS */
>  #define KVM_ARM_IRQ_GIC_MAX		127
>  
> +/* One single KVM irqchip, ie. the VGIC */
> +#define KVM_NR_IRQCHIPS          1
> +
>  /* PSCI interface */
>  #define KVM_PSCI_FN_BASE		0x95c1ba5e
>  #define KVM_PSCI_FN(n)			(KVM_PSCI_FN_BASE + (n))
> diff --git a/arch/arm/kvm/Kconfig b/arch/arm/kvm/Kconfig
> index 466bd29..e519a40 100644
> --- a/arch/arm/kvm/Kconfig
> +++ b/arch/arm/kvm/Kconfig
> @@ -24,6 +24,7 @@ config KVM
>  	select KVM_MMIO
>  	select KVM_ARM_HOST
>  	depends on ARM_VIRT_EXT && ARM_LPAE
> +	select HAVE_KVM_EVENTFD
>  	---help---
>  	  Support hosting virtualized guest machines. You will also
>  	  need to select one or more of the processor modules below.
> @@ -55,7 +56,7 @@ config KVM_ARM_MAX_VCPUS
>  config KVM_ARM_VGIC
>  	bool "KVM support for Virtual GIC"
>  	depends on KVM_ARM_HOST && OF
> -	select HAVE_KVM_IRQCHIP
> +	select HAVE_KVM_IRQFD
>  	default y
>  	---help---
>  	  Adds support for a hardware assisted, in-kernel GIC emulation.
> @@ -63,7 +64,6 @@ config KVM_ARM_VGIC
>  config KVM_ARM_TIMER
>  	bool "KVM support for Architected Timers"
>  	depends on KVM_ARM_VGIC && ARM_ARCH_TIMER
> -	select HAVE_KVM_IRQCHIP
>  	default y
>  	---help---
>  	  Adds support for the Architected Timers in virtual machines
> diff --git a/arch/arm/kvm/Makefile b/arch/arm/kvm/Makefile
> index f7057ed..859db09 100644
> --- a/arch/arm/kvm/Makefile
> +++ b/arch/arm/kvm/Makefile
> @@ -15,7 +15,7 @@ AFLAGS_init.o := -Wa,-march=armv7-a$(plus_virt)
>  AFLAGS_interrupts.o := -Wa,-march=armv7-a$(plus_virt)
>  
>  KVM := ../../../virt/kvm
> -kvm-arm-y = $(KVM)/kvm_main.o $(KVM)/coalesced_mmio.o
> +kvm-arm-y = $(KVM)/kvm_main.o $(KVM)/coalesced_mmio.o $(KVM)/eventfd.o
>  
>  obj-y += kvm-arm.o init.o interrupts.o
>  obj-y += arm.o handle_exit.o guest.o mmu.o emulate.o reset.o
> diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
> index a99e0cd..6ba454a 100644
> --- a/arch/arm/kvm/arm.c
> +++ b/arch/arm/kvm/arm.c
> @@ -181,6 +181,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>  	case KVM_CAP_IRQCHIP:
>  		r = vgic_present;
>  		break;
> +#ifdef CONFIG_HAVE_KVM_IRQFD
> +	case KVM_CAP_IRQFD:
> +#endif
>  	case KVM_CAP_DEVICE_CTRL:
>  	case KVM_CAP_USER_MEMORY:
>  	case KVM_CAP_SYNC_MMU:
> diff --git a/virt/kvm/arm/vgic.c b/virt/kvm/arm/vgic.c
> index 7164d2e..586bd11 100644
> --- a/virt/kvm/arm/vgic.c
> +++ b/virt/kvm/arm/vgic.c
> @@ -1334,7 +1334,10 @@ epilog:
>  static bool vgic_process_maintenance(struct kvm_vcpu *vcpu)
>  {
>  	u32 status = vgic_get_interrupt_status(vcpu);
> +	struct vgic_dist *dist = &vcpu->kvm->arch.vgic;
>  	bool level_pending = false;
> +	struct kvm *kvm = vcpu->kvm;
> +	int is_assigned_irq;
>  
>  	kvm_debug("STATUS = %08x\n", status);
>  
> @@ -1351,6 +1354,7 @@ static bool vgic_process_maintenance(struct kvm_vcpu *vcpu)
>  			struct vgic_lr vlr = vgic_get_lr(vcpu, lr);
>  			BUG_ON(vgic_irq_is_edge(vcpu, vlr.irq));
>  
> +			spin_lock(&dist->lock);
>  			vgic_irq_clear_queued(vcpu, vlr.irq);
>  			WARN_ON(vlr.state & LR_STATE_MASK);
>  			vlr.state = 0;
> @@ -1363,6 +1367,18 @@ static bool vgic_process_maintenance(struct kvm_vcpu *vcpu)
>  			 * interrupt.
>  			 */
>  			vgic_dist_irq_clear_soft_pend(vcpu, vlr.irq);
> +			spin_unlock(&dist->lock);

may be worth a small comment saying that we unlock the distributor
lock to allow kvm_notify_acked_irq() to come back to injecting an IRQ
which grabs the dist->lock again.

> +
> +			is_assigned_irq = kvm_irq_has_notifier(kvm, 0,
> +						vlr.irq - VGIC_NR_PRIVATE_IRQS);

is is_assigned_irq really accurately describing the state you are
determining here?  Can't you have an irqfd without a resamplefd, or did
I get this wrong?  In any case, this code may be simpler if you simply
inline the call to kvm_irq_has_notifier or name the variable
'irq_has_notifier'.

> +
> +			if (is_assigned_irq) {
> +				kvm_debug("EOI irqchip routed vIRQ %d\n",
> +					  vlr.irq);

EOI irqchip routed vIRQ X?

-ECANTPARSE, how about "Guest EOIed vIRQ %d on CPU %d\n" ?

> +				kvm_notify_acked_irq(kvm, 0,
> +					vlr.irq - VGIC_NR_PRIVATE_IRQS);
> +			}
> +			spin_lock(&dist->lock);
>  
>  			/* Any additional pending interrupt? */
>  			if (vgic_dist_irq_get_level(vcpu, vlr.irq)) {
> @@ -1377,6 +1393,8 @@ static bool vgic_process_maintenance(struct kvm_vcpu *vcpu)
>  				vgic_cpu_irq_clear(vcpu, vlr.irq);
>  			}
>  
> +			spin_unlock(&dist->lock);
> +
>  			/*
>  			 * Despite being EOIed, the LR may not have
>  			 * been marked as empty.
> @@ -1441,14 +1459,10 @@ void kvm_vgic_flush_hwstate(struct kvm_vcpu *vcpu)
>  
>  void kvm_vgic_sync_hwstate(struct kvm_vcpu *vcpu)
>  {
> -	struct vgic_dist *dist = &vcpu->kvm->arch.vgic;
> -
>  	if (!irqchip_in_kernel(vcpu->kvm))
>  		return;
>  
> -	spin_lock(&dist->lock);
>  	__kvm_vgic_sync_hwstate(vcpu);
> -	spin_unlock(&dist->lock);
>  }
>  
>  int kvm_vgic_vcpu_pending_irq(struct kvm_vcpu *vcpu)
> @@ -2183,3 +2197,37 @@ struct kvm_device_ops kvm_arm_vgic_v2_ops = {
>  	.get_attr = vgic_get_attr,
>  	.has_attr = vgic_has_attr,
>  };
> +
> +int kvm_irq_map_gsi(struct kvm *kvm,
> +		    struct kvm_kernel_irq_routing_entry *entries,
> +		    int gsi)
> +{
> +	return gsi;
> +}
> +
> +int kvm_irq_map_chip_pin(struct kvm *kvm, unsigned irqchip, unsigned pin)
> +{
> +	return pin;
> +}
> +
> +int kvm_set_irq(struct kvm *kvm, int irq_source_id,
> +		u32 irq, int level, bool line_status)

what does line_status indicate?

> +{
> +	int r = -EINVAL;
> +	unsigned int spi = irq + VGIC_NR_PRIVATE_IRQS;
> +
> +	if (spi > KVM_ARM_IRQ_GIC_MAX)
> +		return r;

can you just do 'return -EINVAL' here and not initialize r above.

> +
> +	kvm_debug("Inject irqchip routed vIRQ %d\n", irq);
> +	r = kvm_vgic_inject_irq(kvm, 0, spi, level);
> +	return r;
> +}
> +
> +/* MSI not implemented yet */
> +int kvm_set_msi(struct kvm_kernel_irq_routing_entry *e,
> +		struct kvm *kvm, int irq_source_id,
> +		int level, bool line_status)
> +{
> +	return 0;
> +}
> -- 
> 1.9.1
> 

Besides the cosmetics and the missing PPI support, this is looking good!

Thanks,
-Christoffer
