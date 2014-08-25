Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755544AbaHYMTe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 08:19:34 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:51909 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753027AbaHYMTd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 08:19:33 -0400
From: Eric Auger <eric.auger@linaro.org>
To: eric.auger@st.com, eric.auger@linaro.org, christoffer.dall@linaro.org,
        marc.zyngier@arm.com, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        alex.williamson@redhat.com, joel.schopp@amd.com
Cc: linux-kernel@vger.kernel.org, patches@linaro.org, will.deacon@arm.com,
        a.motakis@virtualopensystems.com, a.rigo@virtualopensystems.com,
        john.liuli@huawei.com
Subject: [PATCH v2 0/2] irqfd support for ARM
Date: Mon, 25 Aug 2014 14:18:57 +0200
Message-Id: <1408969139-14700-1-git-send-email-eric.auger@linaro.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch serie enables irqfd on ARM.

irqfd framework enables to inject a virtual IRQ into a guest upon an
eventfd trigger. User-side uses KVM_IRQFD VM ioctl to provide KVM with
a kvm_irqfd struct that associates a VM, an eventfd, an IRQ number
(aka. the gsi). When an actor signals the eventfd (typically a VFIO
platform driver), the kvm irqfd subsystem injects the provided virtual
IRQ into the guest.

Resamplefd also is supported for level sensitive interrupts, ie. the
user can provide another eventfd that is triggered when the completion
of the virtual IRQ (gsi) is detected by the GIC.

The gsi must correspond to a shared peripheral interrupt (SPI), ie the
GIC interrupt ID is gsi + 32. It is still under discussion whether PPI
injection support is needed.

this patch enables CONFIG_HAVE_KVM_EVENTFD and CONFIG_HAVE_KVM_IRQFD.

No IRQ routing table is used.

2 patch files are included:
- the 1st one simply removes the inclusion of irq.h. After Paul
  Mackerras' eventfd rework, I think it is no more needed
- the second patch brings the irqfd integration for ARM, without
  routing

This patch serie deprecates integration with GSI routing
(https://patches.linaro.org/32261/)

can be found at git://git.linaro.org/people/eric.auger/linux.git
on branch irqfd_integ_v5

This work was tested with Calxeda Midway xgmac main interrupt with
qemu-system-arm and QEMU VFIO platform device.

- rebase on 3.17rc1
- move of the dist unlock in process_maintenance
- remove of dist lock in __kvm_vgic_sync_hwstate
- remove irq.h

Eric Auger (2):
  KVM: EVENTFD: remove inclusion of irq.h
  KVM: ARM: add irqfd support

 Documentation/virtual/kvm/api.txt |  5 +++-
 arch/arm/include/uapi/asm/kvm.h   |  3 +++
 arch/arm/kvm/Kconfig              |  3 ++-
 arch/arm/kvm/Makefile             |  2 +-
 virt/kvm/arm/vgic.c               | 56 ++++++++++++++++++++++++++++++++++++---
 virt/kvm/eventfd.c                |  1 -
 6 files changed, 62 insertions(+), 8 deletions(-)

-- 
1.9.1

