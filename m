Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754792Ab3AXRhL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 12:37:11 -0500
Received: from mail.skyhub.de ([78.46.96.112]:52937 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754298Ab3AXRhF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 12:37:05 -0500
From: Borislav Petkov <bp@alien8.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: X86 ML <x86@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>, devel@linuxdriverproject.org,
        olaf@aepfle.de, apw@canonical.com, jasowang@redhat.com,
        Thomas Gleixner <tglx@linutronix.de>, JBeulich@suse.com,
        Borislav Petkov <bp@suse.de>
Subject: [PATCH 2/2] x86: Make Linux guest support optional
Date: Thu, 24 Jan 2013 18:39:54 +0100
Message-Id: <1359049194-17505-2-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 1.8.1.rc3
In-Reply-To: <1359049194-17505-1-git-send-email-bp@alien8.de>
References: <20130124173555.GJ13463@pd.tnic>
 <1359049194-17505-1-git-send-email-bp@alien8.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

Put all config options needed to run Linux as a guest behind a
CONFIG_HYPERVISOR_GUEST menu so that they don't get built-in by default
but selected by the user.

While at it, adjust text to changes, remove redundant select.

Signed-off-by: Borislav Petkov <bp@suse.de>
---
 arch/x86/Kconfig                  | 20 ++++++++++----------
 arch/x86/include/asm/hypervisor.h | 12 ++++++++----
 arch/x86/kernel/cpu/Makefile      |  3 ++-
 3 files changed, 20 insertions(+), 15 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index fb3f76510be1..7a91a980745d 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -383,7 +383,7 @@ config X86_NUMACHIP
 
 config X86_VSMP
 	bool "ScaleMP vSMP"
-	select PARAVIRT_GUEST
+	select HYPERVISOR_GUEST
 	select PARAVIRT
 	depends on X86_64 && PCI
 	depends on X86_EXTENDED_PLATFORM
@@ -611,15 +611,16 @@ config KVMTOOL_TEST_ENABLE
 	select NET_9P
 	select NET_9P_VIRTIO
 
-menuconfig PARAVIRT_GUEST
-	bool "Paravirtualized guest support"
+menuconfig HYPERVISOR_GUEST
+	bool "Linux guest support"
 	---help---
-	  Say Y here to get to see options related to running Linux under
-	  various hypervisors.  This option alone does not add any kernel code.
+	  Say Y here to enable options for running Linux under various hypervisors.
+	  This option enables basic hypervisor detection and platform setup.
 
-	  If you say N, all options in this submenu will be skipped and disabled.
+	  If you say N, all options in this submenu will be skipped and
+	  disabled, and Linux guest support won't be built in.
 
-if PARAVIRT_GUEST
+if HYPERVISOR_GUEST
 
 config PARAVIRT_TIME_ACCOUNTING
 	bool "Paravirtual steal time accounting"
@@ -638,9 +639,8 @@ source "arch/x86/xen/Kconfig"
 config KVM_GUEST
 	bool "KVM Guest support (including kvmclock)"
 	select PARAVIRT
-	select PARAVIRT
 	select PARAVIRT_CLOCK
-	default y if PARAVIRT_GUEST
+	default y
 	---help---
 	  This option enables various optimizations for running under the KVM
 	  hypervisor. It includes a paravirtualized clock, so that instead
@@ -681,7 +681,7 @@ config PARAVIRT_DEBUG
 	  Enable to debug paravirt_ops internals.  Specifically, BUG if
 	  a paravirt_op is missing when it is called.
 
-endif #PARAVIRT_GUEST
+endif #HYPERVISOR_GUEST
 
 config NO_BOOTMEM
 	def_bool y
diff --git a/arch/x86/include/asm/hypervisor.h b/arch/x86/include/asm/hypervisor.h
index b518c7509933..cd06ed8733cb 100644
--- a/arch/x86/include/asm/hypervisor.h
+++ b/arch/x86/include/asm/hypervisor.h
@@ -23,9 +23,6 @@
 #include <asm/kvm_para.h>
 #include <asm/xen/hypervisor.h>
 
-extern void init_hypervisor(struct cpuinfo_x86 *c);
-extern void init_hypervisor_platform(void);
-
 /*
  * x86 hypervisor information
  */
@@ -60,4 +57,11 @@ static inline bool hypervisor_x2apic_available(void)
 	return false;
 }
 
-#endif
+#ifdef CONFIG_PARAVIRT
+extern void init_hypervisor(struct cpuinfo_x86 *c);
+extern void init_hypervisor_platform(void);
+#else
+static inline void init_hypervisor(struct cpuinfo_x86 *c) { }
+static inline void init_hypervisor_platform(void) { }
+#endif /* CONFIG_PARAVIRT */
+#endif /* _ASM_X86_HYPERVISOR_H */
diff --git a/arch/x86/kernel/cpu/Makefile b/arch/x86/kernel/cpu/Makefile
index a0e067d3d96c..8d04c7cd7cd3 100644
--- a/arch/x86/kernel/cpu/Makefile
+++ b/arch/x86/kernel/cpu/Makefile
@@ -14,7 +14,6 @@ CFLAGS_common.o		:= $(nostackp)
 
 obj-y			:= intel_cacheinfo.o scattered.o topology.o
 obj-y			+= proc.o capflags.o powerflags.o common.o
-obj-y			+= vmware.o hypervisor.o mshyperv.o
 obj-y			+= rdrand.o
 obj-y			+= match.o
 
@@ -42,6 +41,8 @@ obj-$(CONFIG_MTRR)			+= mtrr/
 
 obj-$(CONFIG_X86_LOCAL_APIC)		+= perfctr-watchdog.o perf_event_amd_ibs.o
 
+obj-$(CONFIG_PARAVIRT)			+= vmware.o hypervisor.o mshyperv.o
+
 quiet_cmd_mkcapflags = MKCAP   $@
       cmd_mkcapflags = $(PERL) $(srctree)/$(src)/mkcapflags.pl $< $@
 
-- 
1.8.1.rc3

