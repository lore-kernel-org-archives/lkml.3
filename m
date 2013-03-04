Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758941Ab3CDX54 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 18:57:56 -0500
Received: from terminus.zytor.com ([198.137.202.10]:55610 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753742Ab3CDX5y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 18:57:54 -0500
Date: Mon, 4 Mar 2013 15:55:53 -0800
From: tip-bot for Borislav Petkov <tipbot@zytor.com>
Message-ID: <tip-6276a074c6519946c527f03e2ab69770a62652d9@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        kys@microsoft.com, haiyangz@microsoft.com, dtor@vmware.com,
        tglx@linutronix.de, hpa@linux.intel.com, bp@suse.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        kys@microsoft.com, haiyangz@microsoft.com, dtor@vmware.com,
        tglx@linutronix.de, hpa@linux.intel.com, bp@suse.de
In-Reply-To: <1362428421-9244-3-git-send-email-bp@alien8.de>
References: <1362428421-9244-3-git-send-email-bp@alien8.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/paravirt] x86: Make Linux guest support optional
Git-Commit-ID: 6276a074c6519946c527f03e2ab69770a62652d9
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Mon, 04 Mar 2013 15:56:00 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6276a074c6519946c527f03e2ab69770a62652d9
Gitweb:     http://git.kernel.org/tip/6276a074c6519946c527f03e2ab69770a62652d9
Author:     Borislav Petkov <bp@suse.de>
AuthorDate: Mon, 4 Mar 2013 21:20:21 +0100
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Mon, 4 Mar 2013 13:14:25 -0800

x86: Make Linux guest support optional

Put all config options needed to run Linux as a guest behind a
CONFIG_HYPERVISOR_GUEST menu so that they don't get built-in by default
but be selectable by the user. Also, make all units which depend on
x86_hyper, depend on this new symbol so that compilation doesn't fail
when CONFIG_HYPERVISOR_GUEST is disabled but those units assume its
presence.

Sort options in the new HYPERVISOR_GUEST menu, adapt config text and
drop redundant select.

Signed-off-by: Borislav Petkov <bp@suse.de>
Link: http://lkml.kernel.org/r/1362428421-9244-3-git-send-email-bp@alien8.de
Cc: Dmitry Torokhov <dtor@vmware.com>
Cc: K. Y. Srinivasan <kys@microsoft.com>
Cc: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/Kconfig                  | 89 ++++++++++++++++++++-------------------
 arch/x86/include/asm/hypervisor.h | 16 ++++---
 arch/x86/kernel/cpu/Makefile      |  3 +-
 arch/x86/lguest/Kconfig           |  3 +-
 arch/x86/xen/Kconfig              |  2 +-
 drivers/hv/Kconfig                |  2 +-
 drivers/misc/Kconfig              |  2 +-
 7 files changed, 62 insertions(+), 55 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index f922a9b..e9e4623 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -389,7 +389,7 @@ config X86_NUMACHIP
 
 config X86_VSMP
 	bool "ScaleMP vSMP"
-	select PARAVIRT_GUEST
+	select HYPERVISOR_GUEST
 	select PARAVIRT
 	depends on X86_64 && PCI
 	depends on X86_EXTENDED_PLATFORM
@@ -596,44 +596,17 @@ config SCHED_OMIT_FRAME_POINTER
 
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
@@ -643,6 +616,13 @@ config PARAVIRT
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
 	depends on PARAVIRT && SMP
@@ -656,17 +636,38 @@ config PARAVIRT_SPINLOCKS
 
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
index 86095ed..2d4b5e6 100644
--- a/arch/x86/include/asm/hypervisor.h
+++ b/arch/x86/include/asm/hypervisor.h
@@ -20,13 +20,11 @@
 #ifndef _ASM_X86_HYPERVISOR_H
 #define _ASM_X86_HYPERVISOR_H
 
+#ifdef CONFIG_HYPERVISOR_GUEST
+
 #include <asm/kvm_para.h>
 #include <asm/xen/hypervisor.h>
 
-extern void init_hypervisor(struct cpuinfo_x86 *c);
-extern void init_hypervisor_platform(void);
-extern bool hypervisor_x2apic_available(void);
-
 /*
  * x86 hypervisor information
  */
@@ -55,4 +53,12 @@ extern const struct hypervisor_x86 x86_hyper_ms_hyperv;
 extern const struct hypervisor_x86 x86_hyper_xen_hvm;
 extern const struct hypervisor_x86 x86_hyper_kvm;
 
-#endif
+extern void init_hypervisor(struct cpuinfo_x86 *c);
+extern void init_hypervisor_platform(void);
+extern bool hypervisor_x2apic_available(void);
+#else
+static inline void init_hypervisor(struct cpuinfo_x86 *c) { }
+static inline void init_hypervisor_platform(void) { }
+static inline bool hypervisor_x2apic_available(void) { return false; }
+#endif /* CONFIG_HYPERVISOR_GUEST */
+#endif /* _ASM_X86_HYPERVISOR_H */
diff --git a/arch/x86/kernel/cpu/Makefile b/arch/x86/kernel/cpu/Makefile
index a0e067d..5f81bce 100644
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
index 29043d2..4a0890f 100644
--- a/arch/x86/lguest/Kconfig
+++ b/arch/x86/lguest/Kconfig
@@ -1,7 +1,6 @@
 config LGUEST_GUEST
 	bool "Lguest guest support"
-	select PARAVIRT
-	depends on X86_32
+	depends on X86_32 && PARAVIRT
 	select TTY
 	select VIRTUALIZATION
 	select VIRTIO
diff --git a/arch/x86/xen/Kconfig b/arch/x86/xen/Kconfig
index 131dacd..1a3c765 100644
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
index 64630f1..0403b51 100644
--- a/drivers/hv/Kconfig
+++ b/drivers/hv/Kconfig
@@ -2,7 +2,7 @@ menu "Microsoft Hyper-V guest support"
 
 config HYPERV
 	tristate "Microsoft Hyper-V client drivers"
-	depends on X86 && ACPI && PCI && X86_LOCAL_APIC
+	depends on X86 && ACPI && PCI && X86_LOCAL_APIC && HYPERVISOR_GUEST
 	help
 	  Select this option to run Linux as a Hyper-V client operating
 	  system.
diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
index e83fdfe..891123e 100644
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
