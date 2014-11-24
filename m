Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753414AbaKXLEA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 06:04:00 -0500
Received: from mail-wg0-f44.google.com ([74.125.82.44]:45810 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752635AbaKXLD6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 06:03:58 -0500
Message-ID: <5473104D.7000305@linaro.org>
Date: Mon, 24 Nov 2014 12:02:37 +0100
From: Eric Auger <eric.auger@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Christoffer Dall <christoffer.dall@linaro.org>
CC: eric.auger@st.com, marc.zyngier@arm.com,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, alex.williamson@redhat.com, joel.schopp@amd.com,
        kim.phillips@freescale.com, paulus@samba.org, gleb@kernel.org,
        pbonzini@redhat.com, linux-kernel@vger.kernel.org, patches@linaro.org,
        will.deacon@arm.com, a.motakis@virtualopensystems.com,
        a.rigo@virtualopensystems.com, john.liuli@huawei.com,
        ming.lei@canonical.com, feng.wu@intel.com
Subject: Re: [PATCH v4 2/3] KVM: arm: add irqfd support
References: <1416765420-12057-1-git-send-email-eric.auger@linaro.org> <1416765420-12057-3-git-send-email-eric.auger@linaro.org> <20141124100040.GJ3401@cbox>
In-Reply-To: <20141124100040.GJ3401@cbox>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/24/2014 11:00 AM, Christoffer Dall wrote:
> On Sun, Nov 23, 2014 at 06:56:59PM +0100, Eric Auger wrote:
>> This patch enables irqfd on arm.
>>
>> Both irqfd and resamplefd are supported. Injection is implemented
>> in vgic.c without routing.
>>
>> This patch enables CONFIG_HAVE_KVM_EVENTFD and CONFIG_HAVE_KVM_IRQFD.
>>
>> KVM_CAP_IRQFD is now advertised. KVM_CAP_IRQFD_RESAMPLE capability
>> automatically is advertised as soon as CONFIG_HAVE_KVM_IRQFD is set.
>>
>> Signed-off-by: Eric Auger <eric.auger@linaro.org>
>>
>> ---
>>
>> v3 -> v4:
>> - reword commit message
>> - explain why we unlock the distributor before calling kvm_notify_acked_irq
>> - rename is_assigned_irq into has_notifier
>> - change EOI and injection kvm_debug format string
>> - remove error local variable in kvm_set_irq
>> - Move HAVE_KVM_IRQCHIP unset in a separate patch
>> - The rationale behind not supporting PPI irqfd injection is that
>>   any device using a PPI would be a private-to-the-CPU device (timer for
>>   instance), so its state would have to be context-switched along with the
>>   VCPU and would require in-kernel wiring anyhow. It is not a relevant use
>>   case for irqfds.
> 
> this blob could go in the commit message.
OK
> 
>> - handle case were the irqfd injection is attempted before the vgic is ready.
>>   in such a case the notifier, if any, is called immediatly
>> - use nr_irqs to test spi is within correct range
>>
>> v2 -> v3:
>> - removal of irq.h from eventfd.c put in a separate patch to increase
>>   visibility
>> - properly expose KVM_CAP_IRQFD capability in arm.c
>> - remove CONFIG_HAVE_KVM_IRQCHIP meaningfull only if irq_comm.c is used
>>
>> v1 -> v2:
>> - rebase on 3.17rc1
>> - move of the dist unlock in process_maintenance
>> - remove of dist lock in __kvm_vgic_sync_hwstate
>> - rewording of the commit message (add resamplefd reference)
>> - remove irq.h
>> ---
>>  Documentation/virtual/kvm/api.txt |  5 ++-
>>  arch/arm/include/uapi/asm/kvm.h   |  3 ++
>>  arch/arm/kvm/Kconfig              |  2 ++
>>  arch/arm/kvm/Makefile             |  2 +-
>>  arch/arm/kvm/arm.c                |  3 ++
>>  virt/kvm/arm/vgic.c               | 72 ++++++++++++++++++++++++++++++++++++---
>>  6 files changed, 81 insertions(+), 6 deletions(-)
>>
>> diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kvm/api.txt
>> index 7610eaa..4deccc0 100644
>> --- a/Documentation/virtual/kvm/api.txt
>> +++ b/Documentation/virtual/kvm/api.txt
>> @@ -2206,7 +2206,7 @@ into the hash PTE second double word).
>>  4.75 KVM_IRQFD
>>  
>>  Capability: KVM_CAP_IRQFD
>> -Architectures: x86 s390
>> +Architectures: x86 s390 arm
>>  Type: vm ioctl
>>  Parameters: struct kvm_irqfd (in)
>>  Returns: 0 on success, -1 on error
>> @@ -2232,6 +2232,9 @@ Note that closing the resamplefd is not sufficient to disable the
>>  irqfd.  The KVM_IRQFD_FLAG_RESAMPLE is only necessary on assignment
>>  and need not be specified with KVM_IRQFD_FLAG_DEASSIGN.
>>  
>> +On arm, the gsi must be a shared peripheral interrupt (SPI).
>> +This means the corresponding programmed GIC interrupt ID is gsi+32.
>> +
> 
> On ARM, the gsi field in the kvm_irqfd struct specifies the Shared
> Peripheral Interrupt (SPI) index, such that the GIC interrupt ID is
> given by gsi + 32.
OK
> 
>>  4.76 KVM_PPC_ALLOCATE_HTAB
>>  
>>  Capability: KVM_CAP_PPC_ALLOC_HTAB
>> diff --git a/arch/arm/include/uapi/asm/kvm.h b/arch/arm/include/uapi/asm/kvm.h
>> index 09ee408..77547bb 100644
>> --- a/arch/arm/include/uapi/asm/kvm.h
>> +++ b/arch/arm/include/uapi/asm/kvm.h
>> @@ -196,6 +196,9 @@ struct kvm_arch_memory_slot {
>>  /* Highest supported SPI, from VGIC_NR_IRQS */
>>  #define KVM_ARM_IRQ_GIC_MAX		127
>>  
>> +/* One single KVM irqchip, ie. the VGIC */
>> +#define KVM_NR_IRQCHIPS          1
>> +
>>  /* PSCI interface */
>>  #define KVM_PSCI_FN_BASE		0x95c1ba5e
>>  #define KVM_PSCI_FN(n)			(KVM_PSCI_FN_BASE + (n))
>> diff --git a/arch/arm/kvm/Kconfig b/arch/arm/kvm/Kconfig
>> index 9f581b1..e519a40 100644
>> --- a/arch/arm/kvm/Kconfig
>> +++ b/arch/arm/kvm/Kconfig
>> @@ -24,6 +24,7 @@ config KVM
>>  	select KVM_MMIO
>>  	select KVM_ARM_HOST
>>  	depends on ARM_VIRT_EXT && ARM_LPAE
>> +	select HAVE_KVM_EVENTFD
>>  	---help---
>>  	  Support hosting virtualized guest machines. You will also
>>  	  need to select one or more of the processor modules below.
>> @@ -55,6 +56,7 @@ config KVM_ARM_MAX_VCPUS
>>  config KVM_ARM_VGIC
>>  	bool "KVM support for Virtual GIC"
>>  	depends on KVM_ARM_HOST && OF
>> +	select HAVE_KVM_IRQFD
>>  	default y
>>  	---help---
>>  	  Adds support for a hardware assisted, in-kernel GIC emulation.
>> diff --git a/arch/arm/kvm/Makefile b/arch/arm/kvm/Makefile
>> index f7057ed..859db09 100644
>> --- a/arch/arm/kvm/Makefile
>> +++ b/arch/arm/kvm/Makefile
>> @@ -15,7 +15,7 @@ AFLAGS_init.o := -Wa,-march=armv7-a$(plus_virt)
>>  AFLAGS_interrupts.o := -Wa,-march=armv7-a$(plus_virt)
>>  
>>  KVM := ../../../virt/kvm
>> -kvm-arm-y = $(KVM)/kvm_main.o $(KVM)/coalesced_mmio.o
>> +kvm-arm-y = $(KVM)/kvm_main.o $(KVM)/coalesced_mmio.o $(KVM)/eventfd.o
>>  
>>  obj-y += kvm-arm.o init.o interrupts.o
>>  obj-y += arm.o handle_exit.o guest.o mmu.o emulate.o reset.o
>> diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
>> index 9e193c8..fb75af2 100644
>> --- a/arch/arm/kvm/arm.c
>> +++ b/arch/arm/kvm/arm.c
>> @@ -172,6 +172,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>>  	case KVM_CAP_IRQCHIP:
>>  		r = vgic_present;
>>  		break;
>> +#ifdef CONFIG_HAVE_KVM_IRQFD
>> +	case KVM_CAP_IRQFD:
>> +#endif
>>  	case KVM_CAP_DEVICE_CTRL:
>>  	case KVM_CAP_USER_MEMORY:
>>  	case KVM_CAP_SYNC_MMU:
>> diff --git a/virt/kvm/arm/vgic.c b/virt/kvm/arm/vgic.c
>> index 3aaca49..3417776 100644
>> --- a/virt/kvm/arm/vgic.c
>> +++ b/virt/kvm/arm/vgic.c
>> @@ -1446,7 +1446,10 @@ epilog:
>>  static bool vgic_process_maintenance(struct kvm_vcpu *vcpu)
>>  {
>>  	u32 status = vgic_get_interrupt_status(vcpu);
>> +	struct vgic_dist *dist = &vcpu->kvm->arch.vgic;
>>  	bool level_pending = false;
>> +	struct kvm *kvm = vcpu->kvm;
>> +	bool has_notifier;
>>  
>>  	kvm_debug("STATUS = %08x\n", status);
>>  
>> @@ -1463,6 +1466,7 @@ static bool vgic_process_maintenance(struct kvm_vcpu *vcpu)
>>  			struct vgic_lr vlr = vgic_get_lr(vcpu, lr);
>>  			WARN_ON(vgic_irq_is_edge(vcpu, vlr.irq));
>>  
>> +			spin_lock(&dist->lock);
>>  			vgic_irq_clear_queued(vcpu, vlr.irq);
>>  			WARN_ON(vlr.state & LR_STATE_MASK);
>>  			vlr.state = 0;
>> @@ -1481,6 +1485,24 @@ static bool vgic_process_maintenance(struct kvm_vcpu *vcpu)
>>  			 */
>>  			vgic_dist_irq_clear_soft_pend(vcpu, vlr.irq);
>>  
>> +			/*
>> +			 * Unlock the distributor since kvm_notify_acked_irq
>> +			 * will call kvm_set_irq to reset the IRQ level.
>> +			 * This latter attempts to grab dist->lock
> 
> reset the IRQ level, and kvm_set_irq() grabs dist->lock.
OK
> 
>> +			 */
>> +			spin_unlock(&dist->lock);
>> +
>> +			has_notifier = kvm_irq_has_notifier(kvm, 0,
>> +						vlr.irq - VGIC_NR_PRIVATE_IRQS);
>> +
>> +			if (has_notifier) {
>> +				kvm_debug("Guest EOIed vIRQ %d on CPU %d\n",
>> +					  vlr.irq, vcpu->vcpu_id);
>> +				kvm_notify_acked_irq(kvm, 0,
>> +						vlr.irq - VGIC_NR_PRIVATE_IRQS);
>> +			}
>> +			spin_lock(&dist->lock);
> 
> shouldn't the lock/unlock be moved into the if statement and only cover
> kvm_notify_acked_irq ?
well this is unlock/lock and not lock/unlock sequence? We indeed must
unlock only for kvm_notify_acked_irq.
> 
>> +
>>  			/* Any additional pending interrupt? */
>>  			if (vgic_dist_irq_get_level(vcpu, vlr.irq)) {
>>  				vgic_cpu_irq_set(vcpu, vlr.irq);
>> @@ -1490,6 +1512,8 @@ static bool vgic_process_maintenance(struct kvm_vcpu *vcpu)
>>  				vgic_cpu_irq_clear(vcpu, vlr.irq);
>>  			}
>>  
>> +			spin_unlock(&dist->lock);
>> +
>>  			/*
>>  			 * Despite being EOIed, the LR may not have
>>  			 * been marked as empty.
>> @@ -1554,14 +1578,10 @@ void kvm_vgic_flush_hwstate(struct kvm_vcpu *vcpu)
>>  
>>  void kvm_vgic_sync_hwstate(struct kvm_vcpu *vcpu)
>>  {
>> -	struct vgic_dist *dist = &vcpu->kvm->arch.vgic;
>> -
>>  	if (!irqchip_in_kernel(vcpu->kvm))
>>  		return;
>>  
>> -	spin_lock(&dist->lock);
>>  	__kvm_vgic_sync_hwstate(vcpu);
>> -	spin_unlock(&dist->lock);
>>  }
>>  
>>  int kvm_vgic_vcpu_pending_irq(struct kvm_vcpu *vcpu)
>> @@ -2477,3 +2497,47 @@ out_free_irq:
>>  	free_percpu_irq(vgic->maint_irq, kvm_get_running_vcpus());
>>  	return ret;
>>  }
>> +
>> +int kvm_irq_map_gsi(struct kvm *kvm,
>> +		    struct kvm_kernel_irq_routing_entry *entries,
>> +		    int gsi)
>> +{
>> +	return gsi;
>> +}
>> +
>> +int kvm_irq_map_chip_pin(struct kvm *kvm, unsigned irqchip, unsigned pin)
>> +{
>> +	return pin;
>> +}
>> +
>> +int kvm_set_irq(struct kvm *kvm, int irq_source_id,
>> +		u32 irq, int level, bool line_status)
>> +{
>> +	unsigned int spi = irq + VGIC_NR_PRIVATE_IRQS;
>> +
>> +	kvm_debug("irqfd sets vIRQ %d to %d\n", irq, level);
>> +
>> +	if (likely(vgic_initialized(kvm))) {
>> +		if (spi > kvm->arch.vgic.nr_irqs)
>> +			return -EINVAL;
>> +		return kvm_vgic_inject_irq(kvm, 0, spi, level);
>> +	} else if (level && kvm_irq_has_notifier(kvm, 0, irq)) {
>> +		/*
>> +		 * any IRQ injected before vgic readiness is
>> +		 * ignored and the notifier, if any, is called
>> +		 * immediately as if the virtual IRQ were completed
>> +		 * by the guest
>> +		 */
>> +		kvm_notify_acked_irq(kvm, 0, irq);
>> +		return -EAGAIN;
> 
> This looks fishy, I don't fully understand which case you're catering
> towards here (the comment is hard to understand), but my gut feeling is
> that you should back out (probably with an error) if the vgic is not
> initialized when calling this function.  Setting up the routing in the
> first place should probably error out if the vgic is not available.
The issue is related to integration with QEMU and VFIO.
Currently VFIO signaling (we tell VFIO to signal the eventfd on a
peculiar physical IRQ) and irqfd setup (we tell KVM/IRQFD to handle
previous eventfd when triggered and inject a GSI) are done by QEMU
*before* the first vcpu run. so before VGIC is ready.

Both are done in a so called QEMU machine init done notifier. It could
be done in a QEMU reset notifier but I guess the problem would be the
same. and I think the same at which QEMU initializes it is correct.

As soon as both VFIO signaling and irqfd are setup, virtual IRQ are
likely to be injected and this is what happens on some circumstances.
This happens on the 2d QEMU run after killing the 1st QEMU session. For
some reason I guess the HW device - in my case the xgmac - was released
in such a way the IRQ wire was not reset. So as soon as VFIO driver
calls request_irq, the IRQ hits.

I tried to change that this xgmac driver behavior but I must acknowledge
that for the time beeing I failed. I will continue investigating that.

Indeed I might be fixing the issue at the wrong place. But anyway this
relies on the fact the assigned device driver toggled down the IRQ
properly when releasing. At the time the signaling is setup we have not
entered yet any driver reset code.

Best Regards

Eric

> 
>> +	}
>> +	return 0;
>> +}
>> +
>> +/* MSI not implemented yet */
>> +int kvm_set_msi(struct kvm_kernel_irq_routing_entry *e,
>> +		struct kvm *kvm, int irq_source_id,
>> +		int level, bool line_status)
>> +{
>> +	return 0;
>> +}
>> -- 
>> 1.9.1
>>
> 
> Thanks,
> -Christoffer
> 

