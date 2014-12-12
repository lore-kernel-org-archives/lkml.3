Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934877AbaLLPY4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 10:24:56 -0500
Received: from mga02.intel.com ([134.134.136.20]:21486 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750704AbaLLPYz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 10:24:55 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,564,1413270000"; 
   d="scan'208";a="622807091"
From: Feng Wu <feng.wu@intel.com>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        gleb@kernel.org, pbonzini@redhat.com, dwmw2@infradead.org,
        joro@8bytes.org, alex.williamson@redhat.com, jiang.liu@linux.intel.com
Cc: eric.auger@linaro.org, linux-kernel@vger.kernel.org,
        iommu@lists.linux-foundation.org, kvm@vger.kernel.org,
        Feng Wu <feng.wu@intel.com>
Subject: [v3 00/26] Add VT-d Posted-Interrupts support
Date: Fri, 12 Dec 2014 23:14:34 +0800
Message-Id: <1418397300-10870-1-git-send-email-feng.wu@intel.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

VT-d Posted-Interrupts is an enhancement to CPU side Posted-Interrupt.
With VT-d Posted-Interrupts enabled, external interrupts from
direct-assigned devices can be delivered to guests without VMM
intervention when guest is running in non-root mode.

You can find the VT-d Posted-Interrtups Spec. in the following URL:
http://www.intel.com/content/www/us/en/intelligent-systems/intel-technology/vt-directed-io-spec.html

v1->v2:
* Use VFIO framework to enable this feature, the VFIO part of this series is
  base on Eric's patch "[PATCH v3 0/8] KVM-VFIO IRQ forward control"
* Rebase this patchset on git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git,
  then revise some irq logic based on the new hierarchy irqdomain patches provided
  by Jiang Liu <jiang.liu@linux.intel.com>

v2->v3:
* Adjust the Posted-interrupts Descriptor updating logic when vCPU is
  preempted or blocked.
* KVM_DEV_VFIO_DEVICE_POSTING_IRQ --> KVM_DEV_VFIO_DEVICE_POST_IRQ
* __KVM_HAVE_ARCH_KVM_VFIO_POSTING --> __KVM_HAVE_ARCH_KVM_VFIO_POST
* Add KVM_DEV_VFIO_DEVICE_UNPOST_IRQ attribute for VFIO irq, which
  can be used to change back to remapping mode.
* Fix typo

This patch series is made of the following groups:
1-6: Some preparation changes in iommu and irq component, this is based on the
     new hierarchy irqdomain logic.
7-9, 26: IOMMU changes for VT-d Posted-Interrupts, such as, feature detection,
          command line parameter.
10-17, 22-25: Changes related to KVM itself.
18-20: Changes in VFIO component, this part was previously sent out as
"[RFC PATCH v2 0/2] kvm-vfio: implement the vfio skeleton for VT-d Posted-Interrupts"
21: x86 irq related changes

Feng Wu (26):
  genirq: Introduce irq_set_vcpu_affinity() to target an interrupt to a
    VCPU
  iommu: Add new member capability to struct irq_remap_ops
  iommu, x86: Define new irte structure for VT-d Posted-Interrupts
  iommu, x86: Implement irq_set_vcpu_affinity for intel_ir_chip
  x86, irq: Implement irq_set_vcpu_affinity for pci_msi_ir_controller
  iommu, x86: No need to migrating irq for VT-d Posted-Interrupts
  iommu, x86: Add cap_pi_support() to detect VT-d PI capability
  iommu, x86: Add intel_irq_remapping_capability() for Intel
  iommu, x86: define irq_remapping_cap()
  KVM: change struct pi_desc for VT-d Posted-Interrupts
  KVM: Add some helper functions for Posted-Interrupts
  KVM: Initialize VT-d Posted-Interrupts Descriptor
  KVM: Define a new interface kvm_find_dest_vcpu() for VT-d PI
  KVM: Get Posted-Interrupts descriptor address from struct kvm_vcpu
  KVM: add interfaces to control PI outside vmx
  KVM: Make struct kvm_irq_routing_table accessible
  KVM: make kvm_set_msi_irq() public
  KVM: kvm-vfio: User API for VT-d Posted-Interrupts
  KVM: kvm-vfio: implement the VFIO skeleton for VT-d Posted-Interrupts
  KVM: x86: kvm-vfio: VT-d posted-interrupts setup
  x86, irq: Define a global vector for VT-d Posted-Interrupts
  KVM: Define a wakeup worker thread for vCPU
  KVM: Update Posted-Interrupts Descriptor when vCPU is preempted
  KVM: Update Posted-Interrupts Descriptor when vCPU is blocked
  KVM: Suppress posted-interrupt when 'SN' is set
  iommu/vt-d: Add a command line parameter for VT-d posted-interrupts

 Documentation/kernel-parameters.txt        |   1 +
 Documentation/virtual/kvm/devices/vfio.txt |   9 ++
 arch/x86/include/asm/entry_arch.h          |   2 +
 arch/x86/include/asm/hardirq.h             |   1 +
 arch/x86/include/asm/hw_irq.h              |   2 +
 arch/x86/include/asm/irq_remapping.h       |  11 ++
 arch/x86/include/asm/irq_vectors.h         |   1 +
 arch/x86/include/asm/kvm_host.h            |  12 ++
 arch/x86/kernel/apic/msi.c                 |   1 +
 arch/x86/kernel/entry_64.S                 |   2 +
 arch/x86/kernel/irq.c                      |  27 ++++
 arch/x86/kernel/irqinit.c                  |   2 +
 arch/x86/kvm/Makefile                      |   2 +-
 arch/x86/kvm/kvm_vfio_x86.c                |  77 +++++++++
 arch/x86/kvm/vmx.c                         | 244 ++++++++++++++++++++++++++++-
 arch/x86/kvm/x86.c                         |  22 ++-
 drivers/iommu/intel_irq_remapping.c        |  68 +++++++-
 drivers/iommu/irq_remapping.c              |  24 ++-
 drivers/iommu/irq_remapping.h              |   8 +
 include/linux/dmar.h                       |  32 ++++
 include/linux/intel-iommu.h                |   1 +
 include/linux/irq.h                        |   7 +
 include/linux/kvm_host.h                   |  46 ++++++
 include/uapi/linux/kvm.h                   |  11 ++
 kernel/irq/chip.c                          |  14 ++
 kernel/irq/manage.c                        |  20 +++
 virt/kvm/irq_comm.c                        |  43 ++++-
 virt/kvm/irqchip.c                         |  11 --
 virt/kvm/kvm_main.c                        |  15 ++
 virt/kvm/vfio.c                            | 107 +++++++++++++
 30 files changed, 795 insertions(+), 28 deletions(-)
 create mode 100644 arch/x86/kvm/kvm_vfio_x86.c

-- 
1.9.1

