Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932457Ab3AYR5F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 12:57:05 -0500
Received: from mail.skyhub.de ([78.46.96.112]:39406 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932294Ab3AYR4x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 12:56:53 -0500
From: Borislav Petkov <bp@alien8.de>
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>
Cc: X86 ML <x86@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>, devel@linuxdriverproject.org,
        olaf@aepfle.de, apw@canonical.com, jasowang@redhat.com,
        Thomas Gleixner <tglx@linutronix.de>, JBeulich@suse.com,
        Borislav Petkov <bp@suse.de>, Dmitry Torokhov <dtor@vmware.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: [PATCH -v2 2/2] x86: Make Linux guest support optional
Date: Fri, 25 Jan 2013 18:59:37 +0100
Message-Id: <1359136777-4512-2-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 1.8.1.rc3
In-Reply-To: <20130125100655.GC23404@pd.tnic>
References: <20130125100655.GC23404@pd.tnic>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

Put all config options needed to run Linux as a guest behind a
CONFIG_HYPERVISOR_GUEST menu so that they don't get built-in by
default but selected by the user. Also, move x86_hyper into an
unconditionally-built compilation unit because it is exported with the
non-GPL flavour and we can't know whatever uses it on the outside.

Then, make sure x86 hypervisor platform descriptor is present and do a
proper check whether we're running on a vmware hypervisor by looking at
its name before continuing with the initialization further.

While at it, adjust text to changes, remove redundant select.

Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: Dmitry Torokhov <dtor@vmware.com>
Cc: K. Y. Srinivasan <kys@microsoft.com>
Cc: Haiyang Zhang <haiyangz@microsoft.com>
Cc: devel@linuxdriverproject.org
---
 arch/x86/Kconfig                  | 21 +++++++++++----------
 arch/x86/include/asm/hypervisor.h | 12 ++++++++----
 arch/x86/kernel/cpu/Makefile      |  3 ++-
 arch/x86/kernel/cpu/hypervisor.c  |  3 ---
 arch/x86/kernel/setup.c           |  4 +++-
 drivers/hv/vmbus_drv.c            |  2 +-
 drivers/misc/vmw_balloon.c        |  2 +-
 7 files changed, 26 insertions(+), 21 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 201b8aa93f8f..2380a52f0c8c 100644
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
@@ -568,15 +568,17 @@ config SCHED_OMIT_FRAME_POINTER
 
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
+if HYPERVISOR_GUEST
 
 config PARAVIRT_TIME_ACCOUNTING
 	bool "Paravirtual steal time accounting"
@@ -595,9 +597,8 @@ source "arch/x86/xen/Kconfig"
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
@@ -638,7 +639,7 @@ config PARAVIRT_DEBUG
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
 
diff --git a/arch/x86/kernel/cpu/hypervisor.c b/arch/x86/kernel/cpu/hypervisor.c
index a8f8fa9769d6..fd6e77f6765e 100644
--- a/arch/x86/kernel/cpu/hypervisor.c
+++ b/arch/x86/kernel/cpu/hypervisor.c
@@ -42,9 +42,6 @@ static const __initconst struct hypervisor_x86 * const hypervisors[] =
 #endif
 };
 
-const struct hypervisor_x86 *x86_hyper;
-EXPORT_SYMBOL(x86_hyper);
-
 static inline void __init
 detect_hypervisor_vendor(void)
 {
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 00f6c1472b85..bdf61408e1af 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -127,7 +127,6 @@ unsigned long max_pfn_mapped;
 RESERVE_BRK(dmi_alloc, 65536);
 #endif
 
-
 static __initdata unsigned long _brk_start = (unsigned long)__brk_base;
 unsigned long _brk_end = (unsigned long)__brk_base;
 
@@ -145,6 +144,9 @@ int default_check_phys_apicid_present(int phys_apicid)
 
 struct boot_params boot_params;
 
+const struct hypervisor_x86 *x86_hyper;
+EXPORT_SYMBOL(x86_hyper);
+
 /*
  * Machine setup..
  */
diff --git a/drivers/hv/vmbus_drv.c b/drivers/hv/vmbus_drv.c
index 8e1a9ec53003..cb467656e684 100644
--- a/drivers/hv/vmbus_drv.c
+++ b/drivers/hv/vmbus_drv.c
@@ -724,7 +724,7 @@ static int __init hv_acpi_init(void)
 {
 	int ret, t;
 
-	if (x86_hyper != &x86_hyper_ms_hyperv)
+	if (!x86_hyper || strncmp(x86_hyper->name, "VMware", 6))
 		return -ENODEV;
 
 	init_completion(&probe_event);
diff --git a/drivers/misc/vmw_balloon.c b/drivers/misc/vmw_balloon.c
index cb56e270da11..85f15a6d8798 100644
--- a/drivers/misc/vmw_balloon.c
+++ b/drivers/misc/vmw_balloon.c
@@ -786,7 +786,7 @@ static int __init vmballoon_init(void)
 	 * Check if we are running on VMware's hypervisor and bail out
 	 * if we are not.
 	 */
-	if (x86_hyper != &x86_hyper_vmware)
+	if (!x86_hyper || strncmp(x86_hyper->name, "VMware", 6))
 		return -ENODEV;
 
 	INIT_LIST_HEAD(&balloon.pages);
-- 
1.8.1.rc3

