Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752171AbaKWR6r (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2014 12:58:47 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:60768 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752137AbaKWR6m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2014 12:58:42 -0500
From: Eric Auger <eric.auger@linaro.org>
To: eric.auger@st.com, eric.auger@linaro.org, christoffer.dall@linaro.org,
        marc.zyngier@arm.com, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        alex.williamson@redhat.com, joel.schopp@amd.com,
        kim.phillips@freescale.com, paulus@samba.org, gleb@kernel.org,
        pbonzini@redhat.com
Cc: linux-kernel@vger.kernel.org, patches@linaro.org, will.deacon@arm.com,
        a.motakis@virtualopensystems.com, a.rigo@virtualopensystems.com,
        john.liuli@huawei.com, ming.lei@canonical.com, feng.wu@intel.com
Subject: [PATCH v4 3/3] KVM: arm64: add irqfd support
Date: Sun, 23 Nov 2014 18:57:00 +0100
Message-Id: <1416765420-12057-4-git-send-email-eric.auger@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1416765420-12057-1-git-send-email-eric.auger@linaro.org>
References: <1416765420-12057-1-git-send-email-eric.auger@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joel Schopp <joel.schopp@amd.com>

This patch enables irqfd for arm64.

Signed-off-by: Joel Schopp <joel.schopp@amd.com>
Signed-off-by: Eric Auger <eric.auger@linaro.org>

---

[Eric Auger]
- originates from Joel's [RFC PATCH] arm64: KVM: add irqfd support
  http://www.spinics.net/lists/kvm-arm/msg10798.html
- isolates modifications really related to irqfd
---
 Documentation/virtual/kvm/api.txt | 4 ++--
 arch/arm64/include/uapi/asm/kvm.h | 3 +++
 arch/arm64/kvm/Kconfig            | 2 ++
 arch/arm64/kvm/Makefile           | 2 +-
 4 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kvm/api.txt
index 4deccc0..c76ce04 100644
--- a/Documentation/virtual/kvm/api.txt
+++ b/Documentation/virtual/kvm/api.txt
@@ -2206,7 +2206,7 @@ into the hash PTE second double word).
 4.75 KVM_IRQFD
 
 Capability: KVM_CAP_IRQFD
-Architectures: x86 s390 arm
+Architectures: x86 s390 arm arm64
 Type: vm ioctl
 Parameters: struct kvm_irqfd (in)
 Returns: 0 on success, -1 on error
@@ -2232,7 +2232,7 @@ Note that closing the resamplefd is not sufficient to disable the
 irqfd.  The KVM_IRQFD_FLAG_RESAMPLE is only necessary on assignment
 and need not be specified with KVM_IRQFD_FLAG_DEASSIGN.
 
-On arm, the gsi must be a shared peripheral interrupt (SPI).
+On arm/arm64, the gsi must be a shared peripheral interrupt (SPI).
 This means the corresponding programmed GIC interrupt ID is gsi+32.
 
 4.76 KVM_PPC_ALLOCATE_HTAB
diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
index 8e38878..1ed4417 100644
--- a/arch/arm64/include/uapi/asm/kvm.h
+++ b/arch/arm64/include/uapi/asm/kvm.h
@@ -182,6 +182,9 @@ struct kvm_arch_memory_slot {
 /* Highest supported SPI, from VGIC_NR_IRQS */
 #define KVM_ARM_IRQ_GIC_MAX		127
 
+/* One single KVM irqchip, ie. the VGIC */
+#define KVM_NR_IRQCHIPS          1
+
 /* PSCI interface */
 #define KVM_PSCI_FN_BASE		0x95c1ba5e
 #define KVM_PSCI_FN(n)			(KVM_PSCI_FN_BASE + (n))
diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
index 279e1a0..09c25c2 100644
--- a/arch/arm64/kvm/Kconfig
+++ b/arch/arm64/kvm/Kconfig
@@ -26,6 +26,7 @@ config KVM
 	select KVM_ARM_HOST
 	select KVM_ARM_VGIC
 	select KVM_ARM_TIMER
+	select HAVE_KVM_EVENTFD
 	---help---
 	  Support hosting virtualized guest machines.
 
@@ -50,6 +51,7 @@ config KVM_ARM_MAX_VCPUS
 config KVM_ARM_VGIC
 	bool
 	depends on KVM_ARM_HOST && OF
+	select HAVE_KVM_IRQFD
 	---help---
 	  Adds support for a hardware assisted, in-kernel GIC emulation.
 
diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
index 32a0961..2e6b827 100644
--- a/arch/arm64/kvm/Makefile
+++ b/arch/arm64/kvm/Makefile
@@ -11,7 +11,7 @@ ARM=../../../arch/arm/kvm
 
 obj-$(CONFIG_KVM_ARM_HOST) += kvm.o
 
-kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/kvm_main.o $(KVM)/coalesced_mmio.o
+kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/kvm_main.o $(KVM)/coalesced_mmio.o $(KVM)/eventfd.o
 kvm-$(CONFIG_KVM_ARM_HOST) += $(ARM)/arm.o $(ARM)/mmu.o $(ARM)/mmio.o
 kvm-$(CONFIG_KVM_ARM_HOST) += $(ARM)/psci.o $(ARM)/perf.o
 
-- 
1.9.1

