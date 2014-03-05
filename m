Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755249AbaCEKvD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 05:51:03 -0500
Received: from mail-pd0-f175.google.com ([209.85.192.175]:59632 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755166AbaCEKu5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 05:50:57 -0500
From: Sebastian Capella <sebastian.capella@linaro.org>
To: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        linaro-kernel@lists.linaro.org, linux-arm-kernel@lists.infradead.org
Cc: Russ Dill <Russ.Dill@ti.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Sebastian Capella <sebastian.capella@linaro.org>,
        Russell King <linux@arm.linux.org.uk>, Len Brown <len.brown@intel.com>,
        Nicolas Pitre <nico@linaro.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Will Deacon <will.deacon@arm.com>,
        Jonathan Austin <jonathan.austin@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Laura Abbott <lauraa@codeaurora.org>, Jiang Liu <liuj97@gmail.com>,
        Sricharan R <r.sricharan@ti.com>,
        Victor Kamensky <victor.kamensky@linaro.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Ben Dooks <ben.dooks@codethink.co.uk>
Subject: [PATCH v7 2/2] ARM hibernation / suspend-to-disk
Date: Wed,  5 Mar 2014 02:50:05 -0800
Message-Id: <1394016605-24120-3-git-send-email-sebastian.capella@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1394016605-24120-1-git-send-email-sebastian.capella@linaro.org>
References: <1394016605-24120-1-git-send-email-sebastian.capella@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Russ Dill <Russ.Dill@ti.com>

Enable hibernation for ARM architectures and provide ARM
architecture specific calls used during hibernation.

The swsusp hibernation framework depends on the
platform first having functional suspend/resume.

Then, in order to enable hibernation on a given platform, a
platform_hibernation_ops structure may need to be registered with
the system in order to save/restore any SoC-specific / cpu specific
state needing (re)init over a suspend-to-disk/resume-from-disk cycle.

For example:

     - "secure" SoCs that have different sets of control registers
       and/or different CR reg access patterns.

     - SoCs with L2 caches as the activation sequence there is
       SoC-dependent; a full off-on cycle for L2 is not done
       by the hibernation support code.

     - SoCs requiring steps on wakeup _before_ the "generic" parts
       done by cpu_suspend / cpu_resume can work correctly.

     - SoCs having persistent state which is maintained during suspend
       and resume, but will be lost during the power off cycle after
       suspend-to-disk.

This is a rebase/rework of Frank Hofmann's v5 hibernation patchset.

Acked-by: Russ Dill <Russ.Dill@ti.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Signed-off-by: Sebastian Capella <sebastian.capella@linaro.org>
Acked-by: Pavel Machek <pavel@ucw.cz>
Reviewed-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Len Brown <len.brown@intel.com>
Cc: Nicolas Pitre <nico@linaro.org>
Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Jonathan Austin <jonathan.austin@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: "Uwe Kleine-König" <u.kleine-koenig@pengutronix.de>
Cc: Stephen Boyd <sboyd@codeaurora.org>
Cc: Laura Abbott <lauraa@codeaurora.org>
Cc: Jiang Liu <liuj97@gmail.com>
Cc: Sricharan R <r.sricharan@ti.com>
Cc: Victor Kamensky <victor.kamensky@linaro.org>
Cc: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: Ben Dooks <ben.dooks@codethink.co.uk>
---
 arch/arm/include/asm/memory.h |    1 +
 arch/arm/kernel/Makefile      |    1 +
 arch/arm/kernel/hibernate.c   |  108 +++++++++++++++++++++++++++++++++++++++++
 arch/arm/mm/Kconfig           |    5 ++
 include/linux/suspend.h       |    2 +
 5 files changed, 117 insertions(+)
 create mode 100644 arch/arm/kernel/hibernate.c

diff --git a/arch/arm/include/asm/memory.h b/arch/arm/include/asm/memory.h
index 8756e4b..d32adbb 100644
--- a/arch/arm/include/asm/memory.h
+++ b/arch/arm/include/asm/memory.h
@@ -291,6 +291,7 @@ static inline void *phys_to_virt(phys_addr_t x)
  */
 #define __pa(x)			__virt_to_phys((unsigned long)(x))
 #define __va(x)			((void *)__phys_to_virt((phys_addr_t)(x)))
+#define __pa_symbol(x)		__pa((unsigned long)(x))
 #define pfn_to_kaddr(pfn)	__va((pfn) << PAGE_SHIFT)
 
 extern phys_addr_t (*arch_virt_to_idmap)(unsigned long x);
diff --git a/arch/arm/kernel/Makefile b/arch/arm/kernel/Makefile
index a30fc9b..8afa848 100644
--- a/arch/arm/kernel/Makefile
+++ b/arch/arm/kernel/Makefile
@@ -39,6 +39,7 @@ obj-$(CONFIG_ARTHUR)		+= arthur.o
 obj-$(CONFIG_ISA_DMA)		+= dma-isa.o
 obj-$(CONFIG_PCI)		+= bios32.o isa.o
 obj-$(CONFIG_ARM_CPU_SUSPEND)	+= sleep.o suspend.o
+obj-$(CONFIG_HIBERNATION)	+= hibernate.o
 obj-$(CONFIG_SMP)		+= smp.o
 ifdef CONFIG_MMU
 obj-$(CONFIG_SMP)		+= smp_tlb.o
diff --git a/arch/arm/kernel/hibernate.c b/arch/arm/kernel/hibernate.c
new file mode 100644
index 0000000..656718a
--- /dev/null
+++ b/arch/arm/kernel/hibernate.c
@@ -0,0 +1,108 @@
+/*
+ * Hibernation support specific for ARM
+ *
+ * Derived from work on ARM hibernation support by:
+ *
+ * Ubuntu project, hibernation support for mach-dove
+ * Copyright (C) 2010 Nokia Corporation (Hiroshi Doyu)
+ * Copyright (C) 2010 Texas Instruments, Inc. (Teerth Reddy et al.)
+ *  https://lkml.org/lkml/2010/6/18/4
+ *  https://lists.linux-foundation.org/pipermail/linux-pm/2010-June/027422.html
+ *  https://patchwork.kernel.org/patch/96442/
+ *
+ * Copyright (C) 2006 Rafael J. Wysocki <rjw@sisk.pl>
+ *
+ * License terms: GNU General Public License (GPL) version 2
+ */
+
+#include <linux/mm.h>
+#include <linux/suspend.h>
+#include <asm/system_misc.h>
+#include <asm/idmap.h>
+#include <asm/suspend.h>
+
+extern const void __nosave_begin, __nosave_end;
+
+int pfn_is_nosave(unsigned long pfn)
+{
+	unsigned long nosave_begin_pfn =
+			__pa_symbol(&__nosave_begin) >> PAGE_SHIFT;
+	unsigned long nosave_end_pfn =
+			PAGE_ALIGN(__pa_symbol(&__nosave_end)) >> PAGE_SHIFT;
+
+	return (pfn >= nosave_begin_pfn) && (pfn < nosave_end_pfn);
+}
+
+void notrace save_processor_state(void)
+{
+	WARN_ON(num_online_cpus() != 1);
+	local_fiq_disable();
+}
+
+void notrace restore_processor_state(void)
+{
+	local_fiq_enable();
+}
+
+/*
+ * Snapshot kernel memory and reset the system.
+ *
+ * swsusp_save() is executed in the suspend finisher so that the CPU
+ * context pointer and memory are part of the saved image, which is
+ * required by the resume kernel image to restart execution from
+ * swsusp_arch_suspend().
+ *
+ * soft_restart is not technically needed, but is used to get success
+ * returned from cpu_suspend.
+ *
+ * When soft reboot completes, the hibernation snapshot is written out.
+ */
+static int notrace arch_save_image(unsigned long unused)
+{
+	int ret;
+
+	ret = swsusp_save();
+	if (ret == 0)
+		soft_restart(virt_to_phys(cpu_resume));
+	return ret;
+}
+
+/*
+ * Save the current CPU state before suspend / poweroff.
+ */
+int notrace swsusp_arch_suspend(void)
+{
+	return cpu_suspend(0, arch_save_image);
+}
+
+/*
+ * Restore page contents for physical pages that were in use during loading
+ * hibernation image.  Switch to idmap_pgd so the physical page tables
+ * are overwritten with the same contents.
+ */
+static void notrace arch_restore_image(void *unused)
+{
+	struct pbe *pbe;
+
+	cpu_switch_mm(idmap_pgd, &init_mm);
+	for (pbe = restore_pblist; pbe; pbe = pbe->next)
+		copy_page(pbe->orig_address, pbe->address);
+
+	soft_restart(virt_to_phys(cpu_resume));
+}
+
+static u64 resume_stack[PAGE_SIZE/2/sizeof(u64)] __nosavedata;
+
+/*
+ * Resume from the hibernation image.
+ * Due to the kernel heap / data restore, stack contents change underneath
+ * and that would make function calls impossible; switch to a temporary
+ * stack within the nosave region to avoid that problem.
+ */
+int swsusp_arch_resume(void)
+{
+	extern void call_with_stack(void (*fn)(void *), void *arg, void *sp);
+	call_with_stack(arch_restore_image, 0,
+		resume_stack + ARRAY_SIZE(resume_stack));
+	return 0;
+}
diff --git a/arch/arm/mm/Kconfig b/arch/arm/mm/Kconfig
index 1f8fed9..83707702 100644
--- a/arch/arm/mm/Kconfig
+++ b/arch/arm/mm/Kconfig
@@ -611,6 +611,11 @@ config CPU_USE_DOMAINS
 config IO_36
 	bool
 
+config ARCH_HIBERNATION_POSSIBLE
+	bool
+	depends on MMU
+	default y if CPU_ARM920T || CPU_ARM926T || CPU_SA1100 || CPU_XSCALE || CPU_XSC3 || CPU_V6 || CPU_V6K || CPU_V7
+
 comment "Processor Features"
 
 config ARM_LPAE
diff --git a/include/linux/suspend.h b/include/linux/suspend.h
index f73cabf..38bbf95 100644
--- a/include/linux/suspend.h
+++ b/include/linux/suspend.h
@@ -320,6 +320,8 @@ extern unsigned long get_safe_page(gfp_t gfp_mask);
 extern void hibernation_set_ops(const struct platform_hibernation_ops *ops);
 extern int hibernate(void);
 extern bool system_entering_hibernation(void);
+asmlinkage int swsusp_save(void);
+extern struct pbe *restore_pblist;
 #else /* CONFIG_HIBERNATION */
 static inline void register_nosave_region(unsigned long b, unsigned long e) {}
 static inline void register_nosave_region_late(unsigned long b, unsigned long e) {}
-- 
1.7.9.5

