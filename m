Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755212AbaFBNy2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 09:54:28 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:45793 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754802AbaFBNyZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 09:54:25 -0400
From: Marc Zyngier <marc.zyngier@arm.com>
To: Eric Auger <eric.auger@linaro.org>
Cc: "eric.auger\@st.com" <eric.auger@st.com>,
        "christoffer.dall\@linaro.org" <christoffer.dall@linaro.org>,
        "linux-arm-kernel\@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "kvmarm\@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        "kvm\@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "patches\@linaro.org" <patches@linaro.org>,
        "christophe.barnichon\@st.com" <christophe.barnichon@st.com>
Subject: Re: [PATCH v2] ARM: KVM: add irqfd and irq routing support
In-Reply-To: <1401694196-30861-1-git-send-email-eric.auger@linaro.org> (Eric
	Auger's message of "Mon, 2 Jun 2014 08:29:56 +0100")
Organization: ARM Ltd
References: <1401694196-30861-1-git-send-email-eric.auger@linaro.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
Date: Mon, 02 Jun 2014 14:54:12 +0100
Message-ID: <87bnub1kor.fsf@approximate.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Eric,

On Mon, Jun 02 2014 at  8:29:56 am BST, Eric Auger <eric.auger@linaro.org> wrote:
> This patch enables irqfd and irq routing on ARM.
>
> It turns on CONFIG_HAVE_KVM_EVENTFD and CONFIG_HAVE_KVM_IRQ_ROUTING
>
> irqfd framework enables to assign physical IRQs to guests.
>
> 1) user-side uses KVM_IRQFD VM ioctl to pass KVM a kvm_irqfd struct that
> associates a VM, an eventfd, an IRQ number (aka. the GSI). When an actor
> signals the eventfd (typically a VFIO platform driver), the irqfd subsystem
> injects the specified IRQ into the VM (the "GSI" takes the semantic of a
> virtual IRQ for that guest).

Just so I can understand how this works: Who EOIs (handles) the physical
interrupt? If it is the VFIO driver, then I don't see how you prevent
the interrupt from firing again immediately (unless this is an edge
interrupt?).

> 2) the other use case is user-side does 1) and uses KVM_SET_GSI_ROUTING
> VM ioctl to create an association between a VM, a physical IRQ (aka GSI) and
> a virtual IRQ (aka irchip.pin).  This creates a so-called GSI routing entry.
> When someone triggers the eventfd, irqfd handles it but uses the specified
> routing and eventually injects irqchip.pin virtual IRQ into the guest. In that
> context the GSI takes the semantic of a physical IRQ while the irqchip.pin
> takes the semantic of a virtual IRQ.
>
> in 1) routing is used by irqfd but an identity routing is created by default
> making the gsi = irqchip.pin. Note on ARM there is a single interrupt
> controller kind, the GIC.
>
> GSI routing mostly is implemented in generic irqchip.c.
> The tiny ARM specific part is directly implemented in the virtual interrupt
> controller (vgic.c) as it is done for powerpc for instance. This option was
> prefered compared to implementing other #ifdef in irq_comm.c (x86 and ia64).
> Hence irq_comm.c is not used at all.
>
> Routing currently is not used for anything else than irqfd IRQ injection. Only
> SPI can be injected. This means the vgic is not totally hidden behind the
> irqchip. There are separate discussions on PPI/SGI routing.
>
> Only level sensitive IRQs are supported (with a registered resampler). As a
> reminder the resampler is a second eventfd called by irqfd framework when the
> virtual IRQ is completed by the guest. This eventfd is supposed to be handled
> on user-side
>
> MSI routing is not supported yet.
>
> This work was tested with Calxeda Midway xgmac main interrupt (with and without
> explicit user routing) with qemu-system-arm and QEMU VFIO platform device.
>
> changes v1 -> v2:
> 2 fixes:
> - v1 assumed gsi/irqchip.pin was already incremented by VGIC_NR_PRIVATE_IRQS.
>   This is now vgic_set_assigned_irq that increments it before injection.
> - v2 now handles the case where a pending assigned irq is cleared through
>   MMIO access. The irq is properly acked allowing the resamplefd handler
>   to possibly unmask the physical IRQ.
>
> Signed-off-by: Eric Auger <eric.auger@linaro.org>
>
> Conflicts:
>         Documentation/virtual/kvm/api.txt
>         arch/arm/kvm/Kconfig
>
> Conflicts:
>         Documentation/virtual/kvm/api.txt
> ---
>  Documentation/virtual/kvm/api.txt |   4 +-
>  arch/arm/include/uapi/asm/kvm.h   |   8 +++
>  arch/arm/kvm/Kconfig              |   2 +
>  arch/arm/kvm/Makefile             |   1 +
>  arch/arm/kvm/irq.h                |  25 +++++++
>  virt/kvm/arm/vgic.c               | 141 ++++++++++++++++++++++++++++++++++++--
>  6 files changed, 174 insertions(+), 7 deletions(-)
>  create mode 100644 arch/arm/kvm/irq.h
>
> diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kvm/api.txt
> index b4f5365..b376334 100644
> --- a/Documentation/virtual/kvm/api.txt
> +++ b/Documentation/virtual/kvm/api.txt
> @@ -1339,7 +1339,7 @@ KVM_ASSIGN_DEV_IRQ. Partial deassignment of host or guest IRQ is allowed.
>  4.52 KVM_SET_GSI_ROUTING
>
>  Capability: KVM_CAP_IRQ_ROUTING
> -Architectures: x86 ia64 s390
> +Architectures: x86 ia64 s390 arm
>  Type: vm ioctl
>  Parameters: struct kvm_irq_routing (in)
>  Returns: 0 on success, -1 on error
> @@ -2126,7 +2126,7 @@ into the hash PTE second double word).
>  4.75 KVM_IRQFD
>
>  Capability: KVM_CAP_IRQFD
> -Architectures: x86 s390
> +Architectures: x86 s390 arm
>  Type: vm ioctl
>  Parameters: struct kvm_irqfd (in)
>  Returns: 0 on success, -1 on error
> diff --git a/arch/arm/include/uapi/asm/kvm.h b/arch/arm/include/uapi/asm/kvm.h
> index ef0c878..89b864d 100644
> --- a/arch/arm/include/uapi/asm/kvm.h
> +++ b/arch/arm/include/uapi/asm/kvm.h
> @@ -192,6 +192,14 @@ struct kvm_arch_memory_slot {
>  /* Highest supported SPI, from VGIC_NR_IRQS */
>  #define KVM_ARM_IRQ_GIC_MAX            127
>
> +/* needed by IRQ routing */
> +
> +/* One single KVM irqchip, ie. the VGIC */
> +#define KVM_NR_IRQCHIPS          1
> +
> +/* virtual interrupt controller input pins (max 480 SPI, 32 SGI/PPI) */
> +#define KVM_IRQCHIP_NUM_PINS     256

Gahhhh... Please don't. We're trying hard to move away from hard-coded
definitions such as this, since GICv3 has much higher limits. And the
comment you've added perfectly outlines why this is such a bad idea
(even on GICv2, we can have up to 960 SPIs).

Have a look at what's brewing in my kvm-arm64/vgic-dyn branch.

>  /* PSCI interface */
>  #define KVM_PSCI_FN_BASE               0x95c1ba5e
>  #define KVM_PSCI_FN(n)                 (KVM_PSCI_FN_BASE + (n))
> diff --git a/arch/arm/kvm/Kconfig b/arch/arm/kvm/Kconfig
> index 4be5bb1..096692c 100644
> --- a/arch/arm/kvm/Kconfig
> +++ b/arch/arm/kvm/Kconfig
> @@ -24,6 +24,7 @@ config KVM
>         select KVM_MMIO
>         select KVM_ARM_HOST
>         depends on ARM_VIRT_EXT && ARM_LPAE && !CPU_BIG_ENDIAN
> +       select HAVE_KVM_EVENTFD
>         ---help---
>           Support hosting virtualized guest machines. You will also
>           need to select one or more of the processor modules below.
> @@ -56,6 +57,7 @@ config KVM_ARM_VGIC
>         bool "KVM support for Virtual GIC"
>         depends on KVM_ARM_HOST && OF
>         select HAVE_KVM_IRQCHIP
> +       select HAVE_KVM_IRQ_ROUTING
>         default y
>         ---help---
>           Adds support for a hardware assisted, in-kernel GIC emulation.
> diff --git a/arch/arm/kvm/Makefile b/arch/arm/kvm/Makefile
> index 789bca9..29de111 100644
> --- a/arch/arm/kvm/Makefile
> +++ b/arch/arm/kvm/Makefile
> @@ -21,4 +21,5 @@ obj-y += kvm-arm.o init.o interrupts.o
>  obj-y += arm.o handle_exit.o guest.o mmu.o emulate.o reset.o
>  obj-y += coproc.o coproc_a15.o coproc_a7.o mmio.o psci.o perf.o
>  obj-$(CONFIG_KVM_ARM_VGIC) += $(KVM)/arm/vgic.o
> +obj-$(CONFIG_HAVE_KVM_EVENTFD) += $(KVM)/eventfd.o $(KVM)/irqchip.o
>  obj-$(CONFIG_KVM_ARM_TIMER) += $(KVM)/arm/arch_timer.o
> diff --git a/arch/arm/kvm/irq.h b/arch/arm/kvm/irq.h
> new file mode 100644
> index 0000000..4d6fcc6
> --- /dev/null
> +++ b/arch/arm/kvm/irq.h
> @@ -0,0 +1,25 @@
> +/*
> + * Copyright (C) 2014, STMicroelectronics
> + * Authors: Eric Auger <eric.auger@st.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License, version 2, as
> + * published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + */
> +
> +#ifndef __IRQ_H
> +#define __IRQ_H
> +
> +#include <linux/kvm_host.h>
> +/*
> + * Placeholder for irqchip and irq/msi routing declarations
> + * included in irqchip.c
> + */
> +
> +#endif
> diff --git a/virt/kvm/arm/vgic.c b/virt/kvm/arm/vgic.c
> index 56ff9be..39afa0d 100644
> --- a/virt/kvm/arm/vgic.c
> +++ b/virt/kvm/arm/vgic.c
> @@ -93,6 +93,9 @@ static struct device_node *vgic_node;
>  #define ACCESS_WRITE_VALUE     (3 << 1)
>  #define ACCESS_WRITE_MASK(x)   ((x) & (3 << 1))
>
> +static struct kvm_irq_routing_entry identity_table[VGIC_NR_IRQS];
> +static int set_default_routing_table(struct kvm *kvm);
> +
>  static void vgic_retire_disabled_irqs(struct kvm_vcpu *vcpu);
>  static void vgic_update_state(struct kvm *kvm);
>  static void vgic_kick_vcpus(struct kvm *kvm);
> @@ -408,11 +411,27 @@ static bool handle_mmio_clear_pending_reg(struct kvm_vcpu *vcpu,
>                                           struct kvm_exit_mmio *mmio,
>                                           phys_addr_t offset)
>  {
> -       u32 *reg = vgic_bitmap_get_reg(&vcpu->kvm->arch.vgic.irq_state,
> +       struct vgic_dist *dist = &vcpu->kvm->arch.vgic;
> +       unsigned int i;
> +       bool is_assigned_irq;
> +       DECLARE_BITMAP(old, VGIC_NR_SHARED_IRQS);
> +       DECLARE_BITMAP(diff, VGIC_NR_SHARED_IRQS);
> +       unsigned long *pending =
> +               vgic_bitmap_get_shared_map(&dist->irq_state);
> +       u32 *reg;
> +       bitmap_copy(old, pending, VGIC_NR_SHARED_IRQS);

That's really heavy. You could find out which interrupts are potentially
affected (only 32 of them) and just handle those. Also, you do the copy
on both the read and write paths. Not great.

> +       reg = vgic_bitmap_get_reg(&vcpu->kvm->arch.vgic.irq_state,
>                                        vcpu->vcpu_id, offset);
>         vgic_reg_access(mmio, reg, offset,
>                         ACCESS_READ_VALUE | ACCESS_WRITE_CLEARBIT);
>         if (mmio->is_write) {
> +               pending = vgic_bitmap_get_shared_map(&dist->irq_state);
> +               bitmap_xor(diff, old, pending, VGIC_NR_SHARED_IRQS);
> +               for_each_set_bit(i, diff, VGIC_NR_SHARED_IRQS) {
> +                       is_assigned_irq = kvm_irq_has_notifier(vcpu->kvm, 0, i);
> +                       if (is_assigned_irq)
> +                               kvm_notify_acked_irq(vcpu->kvm, 0, i);

Are you saying that a masked interrupt should be treated the same as an
EOI-ed interrupt? That seems wrong from my PoV.

> +               }
>                 vgic_update_state(vcpu->kvm);
>                 return true;
>         }
> @@ -1172,6 +1191,8 @@ static bool vgic_process_maintenance(struct kvm_vcpu *vcpu)
>  {
>         struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
>         bool level_pending = false;
> +       struct kvm *kvm;
> +       int is_assigned_irq;
>
>         kvm_debug("MISR = %08x\n", vgic_cpu->vgic_misr);
>
> @@ -1189,12 +1210,23 @@ static bool vgic_process_maintenance(struct kvm_vcpu *vcpu)
>                         vgic_irq_clear_active(vcpu, irq);
>                         vgic_cpu->vgic_lr[lr] &= ~GICH_LR_EOI;
>
> +                       kvm = vcpu->kvm;
> +                       is_assigned_irq =
> +                               kvm_irq_has_notifier(kvm, 0, irq-VGIC_NR_PRIVATE_IRQS);
>                         /* Any additional pending interrupt? */
> -                       if (vgic_dist_irq_is_pending(vcpu, irq)) {
> -                               vgic_cpu_irq_set(vcpu, irq);
> -                               level_pending = true;
> -                       } else {
> +                       if (is_assigned_irq) {
>                                 vgic_cpu_irq_clear(vcpu, irq);
> +                               kvm_debug("EOI irqchip routed vIRQ %d\n", irq);
> +                               kvm_notify_acked_irq(kvm, 0,
> +                                       irq-VGIC_NR_PRIVATE_IRQS);
> +                               vgic_dist_irq_clear(vcpu, irq);
> +                       } else {
> +                               if (vgic_dist_irq_is_pending(vcpu, irq)) {
> +                                       vgic_cpu_irq_set(vcpu, irq);
> +                                       level_pending = true;
> +                               } else {
> +                                       vgic_cpu_irq_clear(vcpu, irq);
> +                               }
>                         }
>
>                         /*
> @@ -1627,6 +1659,8 @@ int kvm_vgic_create(struct kvm *kvm)
>         kvm->arch.vgic.vgic_dist_base = VGIC_ADDR_UNDEF;
>         kvm->arch.vgic.vgic_cpu_base = VGIC_ADDR_UNDEF;
>
> +       set_default_routing_table(kvm);
> +
>  out_unlock:
>         for (; vcpu_lock_idx >= 0; vcpu_lock_idx--) {
>                 vcpu = kvm_get_vcpu(kvm, vcpu_lock_idx);
> @@ -2017,3 +2051,100 @@ struct kvm_device_ops kvm_arm_vgic_v2_ops = {
>         .get_attr = vgic_get_attr,
>         .has_attr = vgic_has_attr,
>  };
> +
> +
> +/*
> + * set up a default identity routing table
> + * The user-side can further change the routing table using
> + * KVM_SET_GSI_ROUTING VM ioctl
> + */
> +
> +static int set_default_routing_table(struct kvm *kvm)
> +{
> +       struct kvm_irq_routing_entry;
> +       int i;
> +       for (i = 0; i < VGIC_NR_IRQS; i++)      {
> +               identity_table[i].gsi = i;
> +               identity_table[i].type = KVM_IRQ_ROUTING_IRQCHIP;
> +               identity_table[i].u.irqchip.irqchip = 0;
> +               identity_table[i].u.irqchip.pin = i;
> +       }
> +       return kvm_set_irq_routing(kvm, identity_table,
> +                                  ARRAY_SIZE(identity_table), 0);
> +}
> +
> +
> +/*
> + * Functions needed for GSI routing (used by irqchip.c)
> + * implemented in irq_comm.c for x86 and ia64
> + * in architecture specific files for some other archictures (powerpc)
> + */
> +
> +static int vgic_set_assigned_irq(struct kvm_kernel_irq_routing_entry *e,
> +                          struct kvm *kvm, int irq_source_id, int level,
> +                          bool line_status)
> +{
> +       unsigned int spi = e->irqchip.pin + VGIC_NR_PRIVATE_IRQS;
> +
> +       if (irq_source_id == KVM_USERSPACE_IRQ_SOURCE_ID) {
> +               /*
> +                * This path is not tested yet,
> +                * only irqchip with resampler was exercised
> +                */
> +               kvm_vgic_inject_irq(kvm, 0, spi, level);
> +       } else if (irq_source_id == KVM_IRQFD_RESAMPLE_IRQ_SOURCE_ID) {
> +               if (level == 1) {
> +                       kvm_debug("Inject irqchip routed vIRQ %d\n",
> +                                       e->irqchip.pin);
> +                       kvm_vgic_inject_irq(kvm, 0, spi, level);
> +                       /*
> +                        * toggling down vIRQ wire is directly handled in
> +                        * process_maintenance for this reason:
> +                        * irqfd_resampler_ack is called in
> +                        * process_maintenance which holds the dist lock.
> +                        * irqfd_resampler_ack calls kvm_set_irq
> +                        * which ends_up calling kvm_vgic_inject_irq.
> +                        * This later attempts to take the lock -> deadlock!
> +                        */
> +               }
> +       }
> +       return 0;
> +
> +}
> +
> +/* void implementation requested to compile irqchip.c */
> +
> +int kvm_set_msi(struct kvm_kernel_irq_routing_entry *e,
> +               struct kvm *kvm, int irq_source_id, int level, bool line_status)
> +{
> +       return 0;
> +}
> +
> +int kvm_set_routing_entry(struct kvm_irq_routing_table *rt,
> +                         struct kvm_kernel_irq_routing_entry *e,
> +                         const struct kvm_irq_routing_entry *ue)
> +{
> +       int r = -EINVAL;
> +
> +       switch (ue->type) {
> +       case KVM_IRQ_ROUTING_IRQCHIP:
> +               e->set = vgic_set_assigned_irq;
> +               e->irqchip.irqchip = ue->u.irqchip.irqchip;
> +               e->irqchip.pin = ue->u.irqchip.pin;
> +               if (e->irqchip.pin >= KVM_IRQCHIP_NUM_PINS)
> +                       goto out;
> +               /* chip[0][virtualID] = physicalID  */
> +               rt->chip[ue->u.irqchip.irqchip][e->irqchip.pin] = ue->gsi;
> +               break;
> +       default:
> +               goto out;
> +       }
> +
> +       r = 0;
> +out:
> +       return r;
> +}

I clearly need to do some more reading about all of this, but some of
the questions/remarks I've outlined above need anwers.

Also, how does this combine with the work the VOS guys are doing?

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny.
