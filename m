Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752988AbaEOF0j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 01:26:39 -0400
Received: from mail-vc0-f172.google.com ([209.85.220.172]:53148 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751178AbaEOF0h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 01:26:37 -0400
MIME-Version: 1.0
X-Originating-IP: [182.73.239.130]
In-Reply-To: <1399639528-2462-1-git-send-email-eric.auger@linaro.org>
References: <1399639528-2462-1-git-send-email-eric.auger@linaro.org>
Date: Thu, 15 May 2014 10:56:36 +0530
Message-ID: <CAAhSdy2o5Wd0uknLObWa0PfjGqDMKU8B47pu-Fo0N1bwt3Dg4A@mail.gmail.com>
Subject: Re: [PATCH] ARM: KVM: add irqfd and irq routing support
From: Anup Patel <anup@brainfault.org>
To: Eric Auger <eric.auger@linaro.org>
Cc: eric.auger@st.com, Christoffer Dall <christoffer.dall@linaro.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        KVM General <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        "patches@linaro.org" <patches@linaro.org>, christophe.barnichon@st.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 9, 2014 at 6:15 PM, Eric Auger <eric.auger@linaro.org> wrote:
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
>
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

I have a doubt here:
"Why are we not using EOImode here?"
OR
"Is de-prioritization of routed IRQs taken care by different patch?"

As-per GICv2 spec, ARM recommends using GICC_CTRL.EOImodeNS=1 for
routing physical IRQs as virtual IRQs. Xen already uses it for both arm32 and
arm64. The EOImode is recommended here because we need to de-prioritize
routed IRQs before forwarding them to Guest as virtual IRQs. Later, when
Guests is done processing virtual IRQ it will do EOI after which we can
de-activate the physical IRQ using GICC_DIR register.

Regards,
Anup

>
> Signed-off-by: Eric Auger <eric.auger@linaro.org>
>
> Conflicts:
>         Documentation/virtual/kvm/api.txt
>         arch/arm/kvm/Kconfig
> ---
>  Documentation/virtual/kvm/api.txt |   4 +-
>  arch/arm/include/uapi/asm/kvm.h   |   8 +++
>  arch/arm/kvm/Kconfig              |   2 +
>  arch/arm/kvm/Makefile             |   1 +
>  arch/arm/kvm/irq.h                |  25 ++++++++
>  virt/kvm/arm/vgic.c               | 124 ++++++++++++++++++++++++++++++++++++--
>  6 files changed, 158 insertions(+), 6 deletions(-)
>  create mode 100644 arch/arm/kvm/irq.h
>
> diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kvm/api.txt
> index a9380ba5..202d63e3 100644
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
> -Architectures: x86
> +Architectures: x86 arm
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
> +
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
> index 56ff9be..a041c29 100644
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
> @@ -1172,6 +1175,8 @@ static bool vgic_process_maintenance(struct kvm_vcpu *vcpu)
>  {
>         struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
>         bool level_pending = false;
> +       struct kvm *kvm;
> +       int is_assigned_irq;
>
>         kvm_debug("MISR = %08x\n", vgic_cpu->vgic_misr);
>
> @@ -1189,12 +1194,22 @@ static bool vgic_process_maintenance(struct kvm_vcpu *vcpu)
>                         vgic_irq_clear_active(vcpu, irq);
>                         vgic_cpu->vgic_lr[lr] &= ~GICH_LR_EOI;
>
> +                       kvm = vcpu->kvm;
> +                       is_assigned_irq = kvm_irq_has_notifier(kvm, 0, irq);
> +
>                         /* Any additional pending interrupt? */
> -                       if (vgic_dist_irq_is_pending(vcpu, irq)) {
> -                               vgic_cpu_irq_set(vcpu, irq);
> -                               level_pending = true;
> -                       } else {
> +                       if (is_assigned_irq) {
>                                 vgic_cpu_irq_clear(vcpu, irq);
> +                               kvm_debug("EOI irqchip routed vIRQ %d\n", irq);
> +                               kvm_notify_acked_irq(kvm, 0, irq);
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
> @@ -1627,6 +1642,8 @@ int kvm_vgic_create(struct kvm *kvm)
>         kvm->arch.vgic.vgic_dist_base = VGIC_ADDR_UNDEF;
>         kvm->arch.vgic.vgic_cpu_base = VGIC_ADDR_UNDEF;
>
> +       set_default_routing_table(kvm);
> +
>  out_unlock:
>         for (; vcpu_lock_idx >= 0; vcpu_lock_idx--) {
>                 vcpu = kvm_get_vcpu(kvm, vcpu_lock_idx);
> @@ -2017,3 +2034,102 @@ struct kvm_device_ops kvm_arm_vgic_v2_ops = {
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
> +       /* only SPI can be assigned in current implementation */
> +       if (e->irqchip.pin < 32)
> +               return -EINVAL;
> +
> +       if (irq_source_id == KVM_USERSPACE_IRQ_SOURCE_ID) {
> +               /*
> +                * This path is not tested yet,
> +                * only irqchip with resampler was exercised
> +                */
> +               kvm_vgic_inject_irq(kvm, 0, e->irqchip.pin, level);
> +       } else if (irq_source_id == KVM_IRQFD_RESAMPLE_IRQ_SOURCE_ID) {
> +               if (level == 1) {
> +                       kvm_debug("Inject irqchip routed vIRQ %d\n",
> +                                       e->irqchip.pin);
> +                       kvm_vgic_inject_irq(kvm, 0, e->irqchip.pin, level);
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
> +
> +
> +
> +
> --
> 1.9.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
