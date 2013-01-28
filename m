Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755316Ab3A1KQG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 05:16:06 -0500
Received: from mail.skyhub.de ([78.46.96.112]:44999 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753606Ab3A1KQE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 05:16:04 -0500
From: Borislav Petkov <bp@alien8.de>
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>
Cc: X86 ML <x86@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>, devel@linuxdriverproject.org,
        olaf@aepfle.de, apw@canonical.com, jasowang@redhat.com,
        Thomas Gleixner <tglx@linutronix.de>, JBeulich@suse.com,
        Borislav Petkov <bp@suse.de>, Dmitry Torokhov <dtor@vmware.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: [PATCH -v3.1] x86: Make Linux guest support optional
Date: Mon, 28 Jan 2013 11:18:47 +0100
Message-Id: <1359368327-29339-1-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 1.8.1.rc3
In-Reply-To: <20130127110616.GD8894@pd.tnic>
References: <20130127110616.GD8894@pd.tnic>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

Put all config options needed to run Linux as a guest behind a
CONFIG_HYPERVISOR_GUEST menu so that they don't get built-in by default
but be selectable by the user. Also, make all units which depend on
x86_hyper, depend on this new symbol so that compilation doesn't fail
when CONFIG_HYPERVISOR_GUEST is disabled but those units assume its
presence.

Sort options in the new HYPERVISOR_GUEST menu, adapt config text and
drop redundant select.

Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: Dmitry Torokhov <dtor@vmware.com>
Cc: K. Y. Srinivasan <kys@microsoft.com>
Cc: Haiyang Zhang <haiyangz@microsoft.com>
Cc: devel@linuxdriverproject.org
---
 arch/x86/Kconfig                  | 89 ++++++++++++++++++++-------------------
 arch/x86/include/asm/hypervisor.h | 12 ++++--
 arch/x86/kernel/cpu/Makefile      |  3 +-
 arch/x86/lguest/Kconfig           |  3 +-
 arch/x86/xen/Kconfig              |  2 +-
 drivers/hv/Kconfig                |  2 +-
 drivers/misc/Kconfig              |  2 +-
 7 files changed, 59 insertions(+), 54 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 201b8aa93f8f..9224f1055b59 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -379,7 +379,7 @@ config X86_NUMACHIP
 
 config X86_VSMP
 	bool "ScaleMP vSMP"
-	select PARAVIRT_GUEST
+	select HYPERVISOR_GUEST
 	select PARAVIRT
 	depends on X86_64 && PCI
 	depends on X86_EXTENDED_PLATFORM
@@ -568,44 +568,17 @@ config SCHED_OMIT_FRAME_POINTER
 
 	  If in doubt, say "Y".
 
-menuconfig PARAVIRT_GUEST
-	bool "Paravirtualized guest support"
+menuconfig HYPERVISOR_GUEST
+	bool "Linux guest support"
 	---help---
-	  Say Y here to get to see options related to running Linux under
-	  various hypervisors.  This option alone does not add any kernel code.
+	  Say Y here to enable options for running Linux under various hyper-
+	  visors. This option enables basic hypervisor detection and platform
+	  setup.
 
-	  If you say N, all options in this submenu will be skipped and disabled.
+	  If you say N, all options in this submenu will be skipped and
+	  disabled, and Linux guest support won't be built in.
 
-if PARAVIRT_GUEST
-
-config PARAVIRT_TIME_ACCOUNTING
-	bool "Paravirtual steal time accounting"
-	select PARAVIRT
-	default n
-	---help---
-	  Select this option to enable fine granularity task steal time
-	  accounting. Time spent executing other tasks in parallel with
-	  the current vCPU is discounted from the vCPU power. To account for
-	  that, there can be a small performance impact.
-
-	  If in doubt, say N here.
-
-source "arch/x86/xen/Kconfig"
-
-config KVM_GUEST
-	bool "KVM Guest support (including kvmclock)"
-	select PARAVIRT
-	select PARAVIRT
-	select PARAVIRT_CLOCK
-	default y if PARAVIRT_GUEST
-	---help---
-	  This option enables various optimizations for running under the KVM
-	  hypervisor. It includes a paravirtualized clock, so that instead
-	  of relying on a PIT (or probably other) emulation by the
-	  underlying device model, the host provides the guest with
-	  timing infrastructure such as time of day, and system time
-
-source "arch/x86/lguest/Kconfig"
+if HYPERVISOR_GUEST
 
 config PARAVIRT
 	bool "Enable paravirtualization code"
@@ -615,6 +588,13 @@ config PARAVIRT
 	  over full virtualization.  However, when run without a hypervisor
 	  the kernel is theoretically slower and slightly larger.
 
+config PARAVIRT_DEBUG
+	bool "paravirt-ops debugging"
+	depends on PARAVIRT && DEBUG_KERNEL
+	---help---
+	  Enable to debug paravirt_ops internals.  Specifically, BUG if
+	  a paravirt_op is missing when it is called.
+
 config PARAVIRT_SPINLOCKS
 	bool "Paravirtualization layer for spinlocks"
 	depends on PARAVIRT && SMP && EXPERIMENTAL
@@ -628,17 +608,38 @@ config PARAVIRT_SPINLOCKS
 
 	  If you are unsure how to answer this question, answer N.
 
-config PARAVIRT_CLOCK
-	bool
+source "arch/x86/xen/Kconfig"
 
-config PARAVIRT_DEBUG
-	bool "paravirt-ops debugging"
-	depends on PARAVIRT && DEBUG_KERNEL
+config KVM_GUEST
+	bool "KVM Guest support (including kvmclock)"
+	depends on PARAVIRT
+	select PARAVIRT_CLOCK
+	default y
 	---help---
-	  Enable to debug paravirt_ops internals.  Specifically, BUG if
-	  a paravirt_op is missing when it is called.
+	  This option enables various optimizations for running under the KVM
+	  hypervisor. It includes a paravirtualized clock, so that instead
+	  of relying on a PIT (or probably other) emulation by the
+	  underlying device model, the host provides the guest with
+	  timing infrastructure such as time of day, and system time
+
+source "arch/x86/lguest/Kconfig"
+
+config PARAVIRT_TIME_ACCOUNTING
+	bool "Paravirtual steal time accounting"
+	depends on PARAVIRT
+	default n
+	---help---
+	  Select this option to enable fine granularity task steal time
+	  accounting. Time spent executing other tasks in parallel with
+	  the current vCPU is discounted from the vCPU power. To account for
+	  that, there can be a small performance impact.
+
+	  If in doubt, say N here.
+
+config PARAVIRT_CLOCK
+	bool
 
-endif #PARAVIRT_GUEST
+endif #HYPERVISOR_GUEST
 
 config NO_BOOTMEM
 	def_bool y
diff --git a/arch/x86/include/asm/hypervisor.h b/arch/x86/include/asm/hypervisor.h
index b518c7509933..5e77c4418dc1 100644
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
+#ifdef CONFIG_HYPERVISOR_GUEST
+extern void init_hypervisor(struct cpuinfo_x86 *c);
+extern void init_hypervisor_platform(void);
+#else
+static inline void init_hypervisor(struct cpuinfo_x86 *c) { }
+static inline void init_hypervisor_platform(void) { }
+#endif /* CONFIG_HYPERVISOR_GUEST */
+#endif /* _ASM_X86_HYPERVISOR_H */
diff --git a/arch/x86/kernel/cpu/Makefile b/arch/x86/kernel/cpu/Makefile
index a0e067d3d96c..5f81bcefbe14 100644
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
 
+obj-$(CONFIG_HYPERVISOR_GUEST)		+= vmware.o hypervisor.o mshyperv.o
+
 quiet_cmd_mkcapflags = MKCAP   $@
       cmd_mkcapflags = $(PERL) $(srctree)/$(src)/mkcapflags.pl $< $@
 
diff --git a/arch/x86/lguest/Kconfig b/arch/x86/lguest/Kconfig
index 7872a3330fb5..a77d8eacd74b 100644
--- a/arch/x86/lguest/Kconfig
+++ b/arch/x86/lguest/Kconfig
@@ -1,7 +1,6 @@
 config LGUEST_GUEST
 	bool "Lguest guest support"
-	select PARAVIRT
-	depends on X86_32
+	depends on X86_32 && PARAVIRT
 	select VIRTUALIZATION
 	select VIRTIO
 	select VIRTIO_CONSOLE
diff --git a/arch/x86/xen/Kconfig b/arch/x86/xen/Kconfig
index 131dacd2748a..1a3c76505649 100644
--- a/arch/x86/xen/Kconfig
+++ b/arch/x86/xen/Kconfig
@@ -4,7 +4,7 @@
 
 config XEN
 	bool "Xen guest support"
-	select PARAVIRT
+	depends on PARAVIRT
 	select PARAVIRT_CLOCK
 	select XEN_HAVE_PVMMU
 	depends on X86_64 || (X86_32 && X86_PAE && !X86_VISWS)
diff --git a/drivers/hv/Kconfig b/drivers/hv/Kconfig
index b38ef6d8d049..e05efc46744f 100644
--- a/drivers/hv/Kconfig
+++ b/drivers/hv/Kconfig
@@ -2,7 +2,7 @@ menu "Microsoft Hyper-V guest support"
 
 config HYPERV
 	tristate "Microsoft Hyper-V client drivers"
-	depends on X86 && ACPI && PCI
+	depends on X86 && ACPI && PCI && HYPERVISOR_GUEST
 	help
 	  Select this option to run Linux as a Hyper-V client operating
 	  system.
diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
index b151b7c1bd59..c7092d5078e1 100644
--- a/drivers/misc/Kconfig
+++ b/drivers/misc/Kconfig
@@ -418,7 +418,7 @@ config TI_DAC7512
 
 config VMWARE_BALLOON
 	tristate "VMware Balloon Driver"
-	depends on X86
+	depends on X86 && HYPERVISOR_GUEST
 	help
 	  This is VMware physical memory management driver which acts
 	  like a "balloon" that can be inflated to reclaim physical pages
-- 
1.8.1.rc3

