Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753502AbaLCQNO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 11:13:14 -0500
Received: from mail-wg0-f41.google.com ([74.125.82.41]:44737 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753047AbaLCQIx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 11:08:53 -0500
From: Eric Auger <eric.auger@linaro.org>
To: eric.auger@st.com, eric.auger@linaro.org, christoffer.dall@linaro.org,
        marc.zyngier@arm.com, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        alex.williamson@redhat.com, agraf@suse.de, joel.schopp@amd.com,
        gleb@kernel.org, pbonzini@redhat.com, borntraeger@de.ibm.com,
        cornelia.huck@de.ibm.com
Cc: linux-kernel@vger.kernel.org, patches@linaro.org,
        a.motakis@virtualopensystems.com
Subject: [PATCH v5 0/5] irqfd support for arm/arm64
Date: Wed,  3 Dec 2014 17:07:07 +0100
Message-Id: <1417622832-5460-1-git-send-email-eric.auger@linaro.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series enables irqfd on arm and arm64.

Irqfd framework enables to inject a virtual IRQ into a guest upon an
eventfd trigger. User-side uses KVM_IRQFD VM ioctl to provide KVM with
a kvm_irqfd struct that associates a VM, an eventfd, a virtual IRQ number
(aka. the gsi). When an actor signals the eventfd (typically a VFIO
platform driver), the kvm irqfd subsystem injects the gsi into the VM.

Resamplefd also is supported for level sensitive interrupts, ie. the
user can provide another eventfd that is triggered when the completion
of the virtual IRQ (gsi) is detected by the GIC.

The gsi must correspond to a shared peripheral interrupt (SPI), ie the
GIC interrupt ID is gsi + 32.

The rationale behind not supporting PPI irqfd injection is that
any device using a PPI would be a private-to-the-CPU device (timer for
instance), so its state would have to be context-switched along with the
VCPU and would require in-kernel wiring anyhow. It is not a relevant use
case for irqfds.

This patch enables CONFIG_HAVE_KVM_EVENTFD and CONFIG_HAVE_KVM_IRQFD.

No IRQ routing table is used, enabling to remove CONFIG_HAVE_KVM_IRQCHIP

The ARM virtual interrupt controller, the VGIC, is dynamically
instantiated. The user-space may attempt to assign an irqfd before
the virtual interrupt controller is ready. For that reason a
check is added in the generic irqfd code to test whether the virtual
interrupt controller is ready. This is a new functionality in v5.

This work was tested with Calxeda Midway xgmac main interrupt with
qemu-system-arm and QEMU VFIO platform device. Also irqfd was proven
functional on several vhost-net prototypes.

v4 -> v5:
- add the capability to check whether vgic is initialized when
  assigning an irqfd.  objective is to avoid injecting IRQ before
  this vgic is ready: this corresponds to new patch files 2, 3, 4.
- do not specifically handle early virtual IRQ injections in
  kvm_set_irq.  In case of injection when vgic is not yet ready,
  simply return an error.  User-space now has means to force vgic
  init and get notified if irqfd assign takes place too early.
- squash [PATCH v4 2/3] KVM: arm: add irqfd support and
         [PATCH v4 3/3] KVM: arm64: add irqfd support
- add Acked-by's in KVM: arm/arm64: unset CONFIG_HAVE_KVM_IRQCHIP
- some comment rewording in vgic

v3 -> v4:
- rebase on 3.18rc5
- vgic dynamic instantiation brought new challenges:
  handling of irqfd injection when vgic is not ready
- unset of CONFIG_HAVE_KVM_IRQCHIP in a separate patch
- add arm64 enable
- vgic.c style modifications according to Christoffer comments

v2 -> v3:
- removal of irq.h from eventfd.c put in a separate patch to increase
  visibility
- properly expose KVM_CAP_IRQFD capability in arm.c
- remove CONFIG_HAVE_KVM_IRQCHIP meaningfull only if irq_comm.c is used

v1 -> v2:
- rebase on 3.17rc1
- move of the dist unlock in process_maintenance
- remove of dist lock in __kvm_vgic_sync_hwstate
- rewording of the commit message (add resamplefd reference)
- remove irq.h


Eric Auger (5):
  KVM: arm/arm64: unset CONFIG_HAVE_KVM_IRQCHIP
  KVM: introduce kvm_arch_is_virtual_intc_initialized
  KVM: arm/arm64: implement kvm_arch_is_virtual_intc_initialized
  KVM: irqfd: use kvm_arch_is_virtual_intc_initialized
  KVM: arm/arm64: add irqfd support

 Documentation/virtual/kvm/api.txt |  6 +++-
 arch/arm/include/asm/kvm_host.h   |  6 ++++
 arch/arm/include/uapi/asm/kvm.h   |  3 ++
 arch/arm/kvm/Kconfig              |  4 +--
 arch/arm/kvm/Makefile             |  2 +-
 arch/arm/kvm/arm.c                |  8 +++++
 arch/arm64/include/asm/kvm_host.h |  5 ++++
 arch/arm64/include/uapi/asm/kvm.h |  3 ++
 arch/arm64/kvm/Kconfig            |  3 +-
 arch/arm64/kvm/Makefile           |  2 +-
 include/linux/kvm_host.h          | 12 ++++++++
 virt/kvm/arm/vgic.c               | 63 ++++++++++++++++++++++++++++++++++++---
 virt/kvm/eventfd.c                |  3 ++
 13 files changed, 110 insertions(+), 10 deletions(-)

-- 
1.9.1

