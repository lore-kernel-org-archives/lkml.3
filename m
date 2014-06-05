Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752731AbaFEOkA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 10:40:00 -0400
Received: from mail-la0-f50.google.com ([209.85.215.50]:55626 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751418AbaFEOj4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 10:39:56 -0400
Date: Thu, 5 Jun 2014 16:39:50 +0200
From: Christoffer Dall <christoffer.dall@linaro.org>
To: Eric Auger <eric.auger@linaro.org>
Cc: eric.auger@st.com, marc.zyngier@arm.com,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org, patches@linaro.org,
        christophe.barnichon@st.com
Subject: Re: [PATCH v2] ARM: KVM: add irqfd and irq routing support
Message-ID: <20140605143950.GA10079@lvm>
References: <1401694196-30861-1-git-send-email-eric.auger@linaro.org>
 <20140605102831.GA3994@lvm>
 <53906D63.9040508@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53906D63.9040508@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 05, 2014 at 03:15:15PM +0200, Eric Auger wrote:
> On 06/05/2014 12:28 PM, Christoffer Dall wrote:
> > On Mon, Jun 02, 2014 at 09:29:56AM +0200, Eric Auger wrote:
> >> This patch enables irqfd and irq routing on ARM.
> >>
> >> It turns on CONFIG_HAVE_KVM_EVENTFD and CONFIG_HAVE_KVM_IRQ_ROUTING
> >>
> >> irqfd framework enables to assign physical IRQs to guests.
> >>
> >> 1) user-side uses KVM_IRQFD VM ioctl to pass KVM a kvm_irqfd struct that
> >> associates a VM, an eventfd, an IRQ number (aka. the GSI). When an actor
> >> signals the eventfd (typically a VFIO platform driver), the irqfd subsystem
> >> injects the specified IRQ into the VM (the "GSI" takes the semantic of a
> >> virtual IRQ for that guest).
> >>
> >> 2) the other use case is user-side does 1) and uses KVM_SET_GSI_ROUTING
> >> VM ioctl to create an association between a VM, a physical IRQ (aka GSI) and
> >> a virtual IRQ (aka irchip.pin).  This creates a so-called GSI routing entry.
> >> When someone triggers the eventfd, irqfd handles it but uses the specified
> >> routing and eventually injects irqchip.pin virtual IRQ into the guest. In that
> >> context the GSI takes the semantic of a physical IRQ while the irqchip.pin
> >> takes the semantic of a virtual IRQ.
> >>
> >> in 1) routing is used by irqfd but an identity routing is created by default
> >> making the gsi = irqchip.pin. Note on ARM there is a single interrupt
> >> controller kind, the GIC.
> >>
> >> GSI routing mostly is implemented in generic irqchip.c.
> >> The tiny ARM specific part is directly implemented in the virtual interrupt
> >> controller (vgic.c) as it is done for powerpc for instance. This option was
> >> prefered compared to implementing other #ifdef in irq_comm.c (x86 and ia64).
> >> Hence irq_comm.c is not used at all.
> >>
> >> Routing currently is not used for anything else than irqfd IRQ injection. Only
> >> SPI can be injected. This means the vgic is not totally hidden behind the
> >> irqchip. There are separate discussions on PPI/SGI routing.
> > 
> > What do you mean here?  Is there an ongoing discussion on the mailing
> > list somewhere?
> 
> Hi Christoffer,
> 
> Thanks for the review.
> 
> I was refering to that thread where it was invoked to put the whole vgic
> behind irqchip:
> http://www.spinics.net/lists/kvm-arm/msg08413.html
> > 
> >>
> >> Only level sensitive IRQs are supported (with a registered resampler). As a
> > 
> > Is it not trivial to add edge-triggered support in the same go?
> Yes it shouldn't be a problem. It is more a matter of testing.
> > 
> >> reminder the resampler is a second eventfd called by irqfd framework when the
> >> virtual IRQ is completed by the guest. This eventfd is supposed to be handled
> >> on user-side
> >>
> >> MSI routing is not supported yet.
> >>
> >> This work was tested with Calxeda Midway xgmac main interrupt (with and without
> >> explicit user routing) with qemu-system-arm and QEMU VFIO platform device.
> >>
> >> changes v1 -> v2:
> >> 2 fixes:
> >> - v1 assumed gsi/irqchip.pin was already incremented by VGIC_NR_PRIVATE_IRQS.
> >>   This is now vgic_set_assigned_irq that increments it before injection.
> >> - v2 now handles the case where a pending assigned irq is cleared through
> >>   MMIO access. The irq is properly acked allowing the resamplefd handler
> >>   to possibly unmask the physical IRQ.
> >>
> >> Signed-off-by: Eric Auger <eric.auger@linaro.org>
> >>
> >> Conflicts:
> >> 	Documentation/virtual/kvm/api.txt
> >> 	arch/arm/kvm/Kconfig
> >>
> >> Conflicts:
> >> 	Documentation/virtual/kvm/api.txt
> > 
> > We usually don't include these conflict notices when sending out
> > patches.
> 
> OK I will remove them
> > 
> >> ---
> >>  Documentation/virtual/kvm/api.txt |   4 +-
> >>  arch/arm/include/uapi/asm/kvm.h   |   8 +++
> >>  arch/arm/kvm/Kconfig              |   2 +
> >>  arch/arm/kvm/Makefile             |   1 +
> >>  arch/arm/kvm/irq.h                |  25 +++++++
> >>  virt/kvm/arm/vgic.c               | 141 ++++++++++++++++++++++++++++++++++++--
> >>  6 files changed, 174 insertions(+), 7 deletions(-)
> >>  create mode 100644 arch/arm/kvm/irq.h
> >>
> >> diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kvm/api.txt
> >> index b4f5365..b376334 100644
> >> --- a/Documentation/virtual/kvm/api.txt
> >> +++ b/Documentation/virtual/kvm/api.txt
> >> @@ -1339,7 +1339,7 @@ KVM_ASSIGN_DEV_IRQ. Partial deassignment of host or guest IRQ is allowed.
> >>  4.52 KVM_SET_GSI_ROUTING
> >>  
> >>  Capability: KVM_CAP_IRQ_ROUTING
> >> -Architectures: x86 ia64 s390
> >> +Architectures: x86 ia64 s390 arm
> >>  Type: vm ioctl
> >>  Parameters: struct kvm_irq_routing (in)
> >>  Returns: 0 on success, -1 on error
> >> @@ -2126,7 +2126,7 @@ into the hash PTE second double word).
> >>  4.75 KVM_IRQFD
> >>  
> >>  Capability: KVM_CAP_IRQFD
> >> -Architectures: x86 s390
> >> +Architectures: x86 s390 arm
> >>  Type: vm ioctl
> >>  Parameters: struct kvm_irqfd (in)
> >>  Returns: 0 on success, -1 on error
> >> diff --git a/arch/arm/include/uapi/asm/kvm.h b/arch/arm/include/uapi/asm/kvm.h
> >> index ef0c878..89b864d 100644
> >> --- a/arch/arm/include/uapi/asm/kvm.h
> >> +++ b/arch/arm/include/uapi/asm/kvm.h
> >> @@ -192,6 +192,14 @@ struct kvm_arch_memory_slot {
> >>  /* Highest supported SPI, from VGIC_NR_IRQS */
> >>  #define KVM_ARM_IRQ_GIC_MAX		127
> >>  
> >> +/* needed by IRQ routing */
> >> +
> >> +/* One single KVM irqchip, ie. the VGIC */
> >> +#define KVM_NR_IRQCHIPS          1
> >> +
> >> +/* virtual interrupt controller input pins (max 480 SPI, 32 SGI/PPI) */
> >> +#define KVM_IRQCHIP_NUM_PINS     256
> > 
> > I don't even see how the comment correlates to the define.  Hmmm.  But
> > since Marc asked you to change this anyhow, maybe this doesn't matter
> > now.
> 
> yes you're right. Those were the figures I was able to find in GIC400
> TRM and I was confused by the fact I was not able to find them in the
> code so I eventually put the same value as VGIC_NR_IRQS. I started
> looking at kvm-arm64/vgic-dyn and found this dist nr_irqs but need more
> time to investigate. Nethertheless his KVM_IRQCHIP_NUM_PINS is used in
> generic code (irqchip).
> > 
> >> +
> >>  /* PSCI interface */
> >>  #define KVM_PSCI_FN_BASE		0x95c1ba5e
> >>  #define KVM_PSCI_FN(n)			(KVM_PSCI_FN_BASE + (n))
> >> diff --git a/arch/arm/kvm/Kconfig b/arch/arm/kvm/Kconfig
> >> index 4be5bb1..096692c 100644
> >> --- a/arch/arm/kvm/Kconfig
> >> +++ b/arch/arm/kvm/Kconfig
> >> @@ -24,6 +24,7 @@ config KVM
> >>  	select KVM_MMIO
> >>  	select KVM_ARM_HOST
> >>  	depends on ARM_VIRT_EXT && ARM_LPAE && !CPU_BIG_ENDIAN
> >> +	select HAVE_KVM_EVENTFD
> >>  	---help---
> >>  	  Support hosting virtualized guest machines. You will also
> >>  	  need to select one or more of the processor modules below.
> >> @@ -56,6 +57,7 @@ config KVM_ARM_VGIC
> >>  	bool "KVM support for Virtual GIC"
> >>  	depends on KVM_ARM_HOST && OF
> >>  	select HAVE_KVM_IRQCHIP
> >> +	select HAVE_KVM_IRQ_ROUTING
> >>  	default y
> >>  	---help---
> >>  	  Adds support for a hardware assisted, in-kernel GIC emulation.
> >> diff --git a/arch/arm/kvm/Makefile b/arch/arm/kvm/Makefile
> >> index 789bca9..29de111 100644
> >> --- a/arch/arm/kvm/Makefile
> >> +++ b/arch/arm/kvm/Makefile
> >> @@ -21,4 +21,5 @@ obj-y += kvm-arm.o init.o interrupts.o
> >>  obj-y += arm.o handle_exit.o guest.o mmu.o emulate.o reset.o
> >>  obj-y += coproc.o coproc_a15.o coproc_a7.o mmio.o psci.o perf.o
> >>  obj-$(CONFIG_KVM_ARM_VGIC) += $(KVM)/arm/vgic.o
> >> +obj-$(CONFIG_HAVE_KVM_EVENTFD) += $(KVM)/eventfd.o $(KVM)/irqchip.o
> >>  obj-$(CONFIG_KVM_ARM_TIMER) += $(KVM)/arm/arch_timer.o
> >> diff --git a/arch/arm/kvm/irq.h b/arch/arm/kvm/irq.h
> >> new file mode 100644
> >> index 0000000..4d6fcc6
> >> --- /dev/null
> >> +++ b/arch/arm/kvm/irq.h
> >> @@ -0,0 +1,25 @@
> >> +/*
> >> + * Copyright (C) 2014, STMicroelectronics
> >> + * Authors: Eric Auger <eric.auger@st.com>
> > 
> > please use the Linaro copyright notice for this.  You can add your
> > @st.com e-mail in addition to the Linaro one in case you want that for
> > long-term support.
> 
> OK I will do
> > 
> >> + *
> >> + * This program is free software; you can redistribute it and/or modify
> >> + * it under the terms of the GNU General Public License, version 2, as
> >> + * published by the Free Software Foundation.
> >> + *
> >> + * This program is distributed in the hope that it will be useful,
> >> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> >> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> >> + * GNU General Public License for more details.
> >> + *
> >> + */
> >> +
> >> +#ifndef __IRQ_H
> >> +#define __IRQ_H
> >> +
> >> +#include <linux/kvm_host.h>
> >> +/*
> >> + * Placeholder for irqchip and irq/msi routing declarations
> >> + * included in irqchip.c
> >> + */
> > 
> > But none needed now?
> 
> Yes nothing for the time being.
> > 
> >> +
> >> +#endif
> >> diff --git a/virt/kvm/arm/vgic.c b/virt/kvm/arm/vgic.c
> >> index 56ff9be..39afa0d 100644
> >> --- a/virt/kvm/arm/vgic.c
> >> +++ b/virt/kvm/arm/vgic.c
> >> @@ -93,6 +93,9 @@ static struct device_node *vgic_node;
> >>  #define ACCESS_WRITE_VALUE	(3 << 1)
> >>  #define ACCESS_WRITE_MASK(x)	((x) & (3 << 1))
> >>  
> >> +static struct kvm_irq_routing_entry identity_table[VGIC_NR_IRQS];
> >> +static int set_default_routing_table(struct kvm *kvm);
> >> +
> >>  static void vgic_retire_disabled_irqs(struct kvm_vcpu *vcpu);
> >>  static void vgic_update_state(struct kvm *kvm);
> >>  static void vgic_kick_vcpus(struct kvm *kvm);
> >> @@ -408,11 +411,27 @@ static bool handle_mmio_clear_pending_reg(struct kvm_vcpu *vcpu,
> >>  					  struct kvm_exit_mmio *mmio,
> >>  					  phys_addr_t offset)
> >>  {
> >> -	u32 *reg = vgic_bitmap_get_reg(&vcpu->kvm->arch.vgic.irq_state,
> >> +	struct vgic_dist *dist = &vcpu->kvm->arch.vgic;
> >> +	unsigned int i;
> >> +	bool is_assigned_irq;
> >> +	DECLARE_BITMAP(old, VGIC_NR_SHARED_IRQS);
> >> +	DECLARE_BITMAP(diff, VGIC_NR_SHARED_IRQS);
> >> +	unsigned long *pending =
> >> +		vgic_bitmap_get_shared_map(&dist->irq_state);
> >> +	u32 *reg;
> > 
> > please add a blank line between your declarations and the actual code.
> 
> OK
> > 
> >> +	bitmap_copy(old, pending, VGIC_NR_SHARED_IRQS);
> >> +	reg = vgic_bitmap_get_reg(&vcpu->kvm->arch.vgic.irq_state,
> >>  				       vcpu->vcpu_id, offset);
> >>  	vgic_reg_access(mmio, reg, offset,
> >>  			ACCESS_READ_VALUE | ACCESS_WRITE_CLEARBIT);
> >>  	if (mmio->is_write) {
> >> +		pending = vgic_bitmap_get_shared_map(&dist->irq_state);
> >> +		bitmap_xor(diff, old, pending, VGIC_NR_SHARED_IRQS);
> >> +		for_each_set_bit(i, diff, VGIC_NR_SHARED_IRQS) {
> >> +			is_assigned_irq = kvm_irq_has_notifier(vcpu->kvm, 0, i);
> >> +			if (is_assigned_irq)
> >> +				kvm_notify_acked_irq(vcpu->kvm, 0, i);
> >> +		}
> > 
> > As Mark pointed out, just copy the vgic reg value and do a simple xor on
> > the two instead, and factor out the two lines that check for
> > is_assigned_irq and calles notify_acked so that you can give a small
> > static function a semantically meaningful name and call that from both
> > this function and the process_maintenance function.
> 
> Yes I corrected this after looking into more details at the register
> semantic.
> > 
> > That being said, this whole thing feels a bit weird, I'll comment on the
> > other thread.
> OK
> > 
> >>  		vgic_update_state(vcpu->kvm);
> >>  		return true;
> >>  	}
> >> @@ -1172,6 +1191,8 @@ static bool vgic_process_maintenance(struct kvm_vcpu *vcpu)
> >>  {
> >>  	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
> >>  	bool level_pending = false;
> >> +	struct kvm *kvm;
> >> +	int is_assigned_irq;
> >>  
> >>  	kvm_debug("MISR = %08x\n", vgic_cpu->vgic_misr);
> >>  
> >> @@ -1189,12 +1210,23 @@ static bool vgic_process_maintenance(struct kvm_vcpu *vcpu)
> >>  			vgic_irq_clear_active(vcpu, irq);
> >>  			vgic_cpu->vgic_lr[lr] &= ~GICH_LR_EOI;
> >>  
> >> +			kvm = vcpu->kvm;
> >> +			is_assigned_irq =
> >> +				kvm_irq_has_notifier(kvm, 0, irq-VGIC_NR_PRIVATE_IRQS);
> > 
> > I think the preferred style is to keep the function call name on the
> > same line as the assignment, and the do a line break on the parameter
> > that doesn't fit in the line width and align that to the opening
> > parenthesis on the funciton call.  At least I prefer it that way.
> 
> OK I will change this.
> > 
> > also spaces around the '-', please.
> > 
> >>  			/* Any additional pending interrupt? */
> > 
> > This comment seems to only aplly for non-assigned IRQs now, right?
> 
> yes it does
> > 

so move the comment in the else-clause, if it's an assigned irq then
that's not what you're handling here.  But come to think of it, don't we
need to check if the line is still high?

> >> -			if (vgic_dist_irq_is_pending(vcpu, irq)) {
> >> -				vgic_cpu_irq_set(vcpu, irq);
> >> -				level_pending = true;
> >> -			} else {
> >> +			if (is_assigned_irq) {
> >>  				vgic_cpu_irq_clear(vcpu, irq);
> >> +				kvm_debug("EOI irqchip routed vIRQ %d\n", irq);
> >> +				kvm_notify_acked_irq(kvm, 0,
> >> +					irq-VGIC_NR_PRIVATE_IRQS);
> > 
> > spaces around the '-', please.
> OK
> > 
> >> +				vgic_dist_irq_clear(vcpu, irq);
> >> +			} else {
> >> +				if (vgic_dist_irq_is_pending(vcpu, irq)) {
> >> +					vgic_cpu_irq_set(vcpu, irq);
> >> +					level_pending = true;
> >> +				} else {
> >> +					vgic_cpu_irq_clear(vcpu, irq);
> >> +				}
> >>  			}
> >>  
> >>  			/*
> >> @@ -1627,6 +1659,8 @@ int kvm_vgic_create(struct kvm *kvm)
> >>  	kvm->arch.vgic.vgic_dist_base = VGIC_ADDR_UNDEF;
> >>  	kvm->arch.vgic.vgic_cpu_base = VGIC_ADDR_UNDEF;
> >>  
> >> +	set_default_routing_table(kvm);
> >> +
> >>  out_unlock:
> >>  	for (; vcpu_lock_idx >= 0; vcpu_lock_idx--) {
> >>  		vcpu = kvm_get_vcpu(kvm, vcpu_lock_idx);
> >> @@ -2017,3 +2051,100 @@ struct kvm_device_ops kvm_arm_vgic_v2_ops = {
> >>  	.get_attr = vgic_get_attr,
> >>  	.has_attr = vgic_has_attr,
> >>  };
> >> +
> >> +
> >> +/*
> >> + * set up a default identity routing table
> >> + * The user-side can further change the routing table using
> >> + * KVM_SET_GSI_ROUTING VM ioctl
> >> + */
> >> +
> > 
> > don't add this whitespace between comments and a function declaration,
> > please check the entire patch for this.
> OK
> > 
> >> +static int set_default_routing_table(struct kvm *kvm)
> >> +{
> >> +	struct kvm_irq_routing_entry;
> >> +	int i;
> >> +	for (i = 0; i < VGIC_NR_IRQS; i++)	{
> >> +		identity_table[i].gsi = i;
> >> +		identity_table[i].type = KVM_IRQ_ROUTING_IRQCHIP;
> >> +		identity_table[i].u.irqchip.irqchip = 0;
> >> +		identity_table[i].u.irqchip.pin = i;
> >> +	}
> >> +	return kvm_set_irq_routing(kvm, identity_table,
> >> +				   ARRAY_SIZE(identity_table), 0);
> > 
> > is identity table used after this stage?  If not, could you not
> > dynamically allocate it and free it after use so we don't waste this
> > staic allocation of memory in the kernel?
> 
> yes this definitively can be optimized.
> > 
> >> +}
> >> +
> >> +
> >> +/*
> >> + * Functions needed for GSI routing (used by irqchip.c)
> >> + * implemented in irq_comm.c for x86 and ia64
> >> + * in architecture specific files for some other archictures (powerpc)
> >> + */
> > 
> > Hmmm, this comment seems rather pointless in this file.  If you want to
> > describe what this function does, then just document this functionality
> > and the parameters/return value, i.e.
> > 
> > vgic_set_assigned_irq - set state of IRQs driven by irqfd
> > 
> > When an IRQ is raised or lowered.... blah blah blah blah.
> > 
> > @e:   the routing entry describing...
> > @kvm: the kvm struct
> > and so on.
> 
> > 
> > return 0 on success, -error on errors.
> > 
> 
> OK
> >> +
> >> +static int vgic_set_assigned_irq(struct kvm_kernel_irq_routing_entry *e,
> >> +			   struct kvm *kvm, int irq_source_id, int level,
> >> +			   bool line_status)
> >> +{
> >> +	unsigned int spi = e->irqchip.pin + VGIC_NR_PRIVATE_IRQS;
> > 
> > I noticed this in the changelogs too, where's the rationale/API
> > documentaiton for the use of irqchip.pin and its semantics on ARM?
> > 
> > Should we add something in Documentation/virtual/kvm/api.txt ?
> 
> - in 4.24 KVM_CREATE_IRQCHIP I might add that similarly to s390 a dummy
> identity table is created.
> 
> - KVM_CAP_IRQFD says "kvm_irqfd.gsi specifies the irqchip pin toggled by
> this event.  When an event is triggered on the eventfd, an interrupt is
> injected into the guest using the specified gsi pin"
> 
> Assuming the standard use case is to use an identity/dummy GSI table the
> irqchip.pin still remains the "irqchip pin" toggled on eventfd.
> 
> By the way I might remove the mention to the use case where the gsi !=
> irqchip.pin.
> 
> Now when reading 4.25 KVM_IRQ_LINE, it is said that it is used to inject
> a GSI as well.
> 
> Now on ARM The GSI has the following content.
> 
>   bits:  | 31 ... 24 | 23  ... 16 | 15    ...    0 |
>   field: | irq_type  | vcpu_index |     irq_id     |
> 
> As such that's true that currently there is an inconsistency.
> 
> Currently my GSI == spi number whereas the GSI as injected by
> KVM_IRQ_LINE has the above format.

But the ARM use of KVM_IRQFD is not clearly documented.

I think this patch needs to include adding arm to the "Architectures"
list in api.txt and clearly document what the semantics of the fields of
the struct kvm_irqfd are.

> > 
> >> +
> >> +	if (irq_source_id == KVM_USERSPACE_IRQ_SOURCE_ID) {
> >> +		/*
> >> +		 * This path is not tested yet,
> >> +		 * only irqchip with resampler was exercised
> >> +		 */
> >> +		kvm_vgic_inject_irq(kvm, 0, spi, level);
> > 
> > hmmm, stuff like this definitely makes this patch an RFC.
> 
> Yes I acknowledge I shall step back to RFC. I was a bit eager.

The alternative is to return an error and put a big fat comment saying
this is NOT IMPLEMENTED yet.

> > 
> >> +	} else if (irq_source_id == KVM_IRQFD_RESAMPLE_IRQ_SOURCE_ID) {
> >> +		if (level == 1) {
> > 
> > This seems very wrong.  What if an external device raises a
> > level-triggered IRQ, but then lowers it again, without the guest was
> > ever running, now you have to wait until the guest sees the (now
> > inactive) interrupt and EOIs it before the interrupt is lowered on the
> > vgic?
> Hum I am bit confused here. when you enter that code, this means an
> irqfd was triggered. This irqfd was registered by some user code that is
> supposed to be alive and do the proper action to complete the IRQ. in my
> case the xgmac toggles down the IRQ if anyone resets the IRQ status
> register? this action is done in the xgmac guest ISR. A device
> reset/error? might provoke the IRQ pin toggling done. Do you see any
> other events?

Sure, ok, forget about the 'guest wasn't running', but if the guest ISR
is run with guest interrupts disabled and resets the xgmac device (or
imagine some other device that just lowers the level triggered interrupt
after some timeout), then how does the current code handle this?

> > 
> >> +			kvm_debug("Inject irqchip routed vIRQ %d\n",
> >> +					e->irqchip.pin);
> >> +			kvm_vgic_inject_irq(kvm, 0, spi, level);
> >> +			/*
> >> +			 * toggling down vIRQ wire is directly handled in
> >> +			 * process_maintenance for this reason:
> >> +			 * irqfd_resampler_ack is called in
> >> +			 * process_maintenance which holds the dist lock.
> >> +			 * irqfd_resampler_ack calls kvm_set_irq
> >> +			 * which ends_up calling kvm_vgic_inject_irq.
> >> +			 * This later attempts to take the lock -> deadlock!
> >> +			 */
> > 
> > Not sure I understand this comment.  What are we trying to achieve, are
> > we using some sort of a workaround to avoid a deadlock?
> 
> What I wanted to point out here is I would have prefered to handle both
> levels 0 and 1 in a symetrical manner. irqfd_resampler_ack (in eventfd)
> is calling kvm_set_irq with level 0. This would be the prefered way to
> toggle down the SPI at GIC input instead of doing this in
> process_maintenance in a dirty manner. However this does work because
> irqfd_resampler_ack is called in process_maintenance (the place where
> the EOI is analyzed). process_maintenance holds the dist lock and would
> eventually call kvm_vgic_inject_irq which also attempts to take the lock.
> 	

I'm afraid that's too much of a hack.  There's an external mechanism to
set an interrupt line to active (level=1) or inactive (level=0) and we
must support both.

The fact that vgic_process_maintenance() can set the interrupt line to
inactive is just something we exploit to properly handle level-triggered
interrupts, but the main API to the VGIC must absolutely be supported.

Am I completely wrong here?

The locking issue can be solved by splitting up the locking into a finer
granularity as needed or deferring the call to irqfd_resampler_ack()
until after unlocking the distributor lock in kvm_vgic_sync_hwstate().

> > 
> >> +		}
> >> +	}
> >> +	return 0;
> >> +
> >> +}
> >> +
> >> +/* void implementation requested to compile irqchip.c */
> >> +
> > 
> > hmm, "TODO: MSI routing not yet implemented" seems more appropriate.
> 
> OK
> > 
> >> +int kvm_set_msi(struct kvm_kernel_irq_routing_entry *e,
> >> +		struct kvm *kvm, int irq_source_id, int level, bool line_status)
> >> +{
> >> +	return 0;
> >> +}
> >> +
> >> +int kvm_set_routing_entry(struct kvm_irq_routing_table *rt,
> >> +			  struct kvm_kernel_irq_routing_entry *e,
> >> +			  const struct kvm_irq_routing_entry *ue)
> >> +{
> >> +	int r = -EINVAL;
> >> +
> >> +	switch (ue->type) {
> >> +	case KVM_IRQ_ROUTING_IRQCHIP:
> >> +		e->set = vgic_set_assigned_irq;
> >> +		e->irqchip.irqchip = ue->u.irqchip.irqchip;
> >> +		e->irqchip.pin = ue->u.irqchip.pin;
> >> +		if (e->irqchip.pin >= KVM_IRQCHIP_NUM_PINS)
> >> +			goto out;
> >> +		/* chip[0][virtualID] = physicalID  */
> >> +		rt->chip[ue->u.irqchip.irqchip][e->irqchip.pin] = ue->gsi;
> > 
> > did we verify ue->u.irqchip.irqchip anywhere before reaching this code?
> 
> No you are right. Should add this check.

ouch! ;)

-Christoffer
