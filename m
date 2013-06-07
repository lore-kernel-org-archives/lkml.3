Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964787Ab3FGXF7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 19:05:59 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:65054 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757699Ab3FGXDy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 19:03:54 -0400
From: David Daney <ddaney.cavm@gmail.com>
To: linux-mips@linux-mips.org, ralf@linux-mips.org, kvm@vger.kernel.org,
        Sanjay Lal <sanjayl@kymasys.com>
Cc: linux-kernel@vger.kernel.org, David Daney <david.daney@cavium.com>
Subject: [PATCH 26/31] mips/kvm: Split up Kconfig and Makefile definitions in preperation for MIPSVZ.
Date: Fri,  7 Jun 2013 16:03:30 -0700
Message-Id: <1370646215-6543-27-git-send-email-ddaney.cavm@gmail.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1370646215-6543-1-git-send-email-ddaney.cavm@gmail.com>
References: <1370646215-6543-1-git-send-email-ddaney.cavm@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Daney <david.daney@cavium.com>

Create the symbol KVM_MIPSTE, and use it to select the trap and
emulate specific things.

Signed-off-by: David Daney <david.daney@cavium.com>
---
 arch/mips/kvm/Kconfig  | 14 +++++++++-----
 arch/mips/kvm/Makefile | 14 ++++++++------
 2 files changed, 17 insertions(+), 11 deletions(-)

diff --git a/arch/mips/kvm/Kconfig b/arch/mips/kvm/Kconfig
index 2c15590..95c0d22 100644
--- a/arch/mips/kvm/Kconfig
+++ b/arch/mips/kvm/Kconfig
@@ -16,18 +16,22 @@ menuconfig VIRTUALIZATION
 if VIRTUALIZATION
 
 config KVM
-	tristate "Kernel-based Virtual Machine (KVM) support"
-	depends on HAVE_KVM
+	tristate
 	select PREEMPT_NOTIFIERS
+
+config KVM_MIPSTE
+	tristate "Kernel-based Virtual Machine (KVM) 32-bit trap-and-emulate"
+	depends on HAVE_KVM
+	select KVM
 	select ANON_INODES
 	select KVM_MMIO
 	---help---
-	  Support for hosting Guest kernels.
+	  Support for hosting Guest kernels with modified address space layout.
 	  Currently supported on MIPS32 processors.
 
 config KVM_MIPS_DYN_TRANS
 	bool "KVM/MIPS: Dynamic binary translation to reduce traps"
-	depends on KVM
+	depends on KVM_MIPSTE
 	---help---
 	  When running in Trap & Emulate mode patch privileged
 	  instructions to reduce the number of traps.
@@ -36,7 +40,7 @@ config KVM_MIPS_DYN_TRANS
 
 config KVM_MIPS_DEBUG_COP0_COUNTERS
 	bool "Maintain counters for COP0 accesses"
-	depends on KVM
+	depends on KVM_MIPSTE
 	---help---
 	  Maintain statistics for Guest COP0 accesses.
 	  A histogram of COP0 accesses is printed when the VM is
diff --git a/arch/mips/kvm/Makefile b/arch/mips/kvm/Makefile
index 78d87bb..3377197 100644
--- a/arch/mips/kvm/Makefile
+++ b/arch/mips/kvm/Makefile
@@ -1,13 +1,15 @@
 # Makefile for KVM support for MIPS
 #
 
-common-objs = $(addprefix ../../../virt/kvm/, kvm_main.o coalesced_mmio.o)
+common-objs = $(addprefix ../../../virt/kvm/, kvm_main.o)
 
 EXTRA_CFLAGS += -Ivirt/kvm -Iarch/mips/kvm
 
-kvm-objs := $(common-objs) kvm_mips.o kvm_mips_emul.o kvm_locore.o \
-	    kvm_mips_int.o kvm_mips_stats.o kvm_mips_commpage.o \
-	    kvm_mips_dyntrans.o kvm_trap_emul.o
+kvm_mipste-objs		:= kvm_mips_emul.o kvm_locore.o kvm_mips_int.o \
+			   kvm_mips_stats.o kvm_mips_commpage.o \
+			   kvm_mips_dyntrans.o kvm_trap_emul.o kvm_cb.o \
+			   kvm_tlb.o \
+			   $(addprefix ../../../virt/kvm/, coalesced_mmio.o)
 
-obj-$(CONFIG_KVM)	+= kvm.o
-obj-y			+= kvm_cb.o kvm_tlb.o
+obj-$(CONFIG_KVM)		+= $(common-objs) kvm_mips.o
+obj-$(CONFIG_KVM_MIPSTE)	+= kvm_mipste.o
-- 
1.7.11.7

