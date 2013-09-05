Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754141Ab3IEWv2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 18:51:28 -0400
Received: from relay2.sgi.com ([192.48.179.30]:52492 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752831Ab3IEWuf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 18:50:35 -0400
Message-Id: <20130905225033.092853526@asylum.americas.sgi.com>
References: <20130905225032.879120272@asylum.americas.sgi.com>
User-Agent: quilt/0.46-1
Date: Thu, 05 Sep 2013 17:50:33 -0500
From: Mike Travis <travis@sgi.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Jason Wessel <jason.wessel@windriver.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Dimitri Sivanich <sivanich@sgi.com>, Hedi Berriche <hedi@sgi.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/9] x86/UV: Move NMI support
Content-Disposition: inline; filename=uv-move-nmi-support.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch moves the UV NMI support from the x2apic file to a new
separate uv_nmi.c file in preparation for the next sequence of patches.
It prevents upcoming bloat of the x2apic file, and has the added benefit
of putting the upcoming /sys/module parameters under the name 'uv_nmi'
instead of 'x2apic_uv_x', which was obscure.

Signed-off-by: Mike Travis <travis@sgi.com>
Reviewed-by: Dimitri Sivanich <sivanich@sgi.com>
Reviewed-by: Hedi Berriche <hberrich@sgi.com>
---
 arch/x86/include/asm/uv/uv.h       |    2 
 arch/x86/kernel/apic/x2apic_uv_x.c |   69 -------------------------
 arch/x86/platform/uv/Makefile      |    2 
 arch/x86/platform/uv/uv_nmi.c      |  102 +++++++++++++++++++++++++++++++++++++
 4 files changed, 105 insertions(+), 70 deletions(-)

--- linux.orig/arch/x86/include/asm/uv/uv.h
+++ linux/arch/x86/include/asm/uv/uv.h
@@ -12,6 +12,7 @@ extern enum uv_system_type get_uv_system
 extern int is_uv_system(void);
 extern void uv_cpu_init(void);
 extern void uv_nmi_init(void);
+extern void uv_register_nmi_notifier(void);
 extern void uv_system_init(void);
 extern const struct cpumask *uv_flush_tlb_others(const struct cpumask *cpumask,
 						 struct mm_struct *mm,
@@ -25,6 +26,7 @@ static inline enum uv_system_type get_uv
 static inline int is_uv_system(void)	{ return 0; }
 static inline void uv_cpu_init(void)	{ }
 static inline void uv_system_init(void)	{ }
+static inline void uv_register_nmi_notifier(void) { }
 static inline const struct cpumask *
 uv_flush_tlb_others(const struct cpumask *cpumask, struct mm_struct *mm,
 		    unsigned long start, unsigned long end, unsigned int cpu)
--- linux.orig/arch/x86/kernel/apic/x2apic_uv_x.c
+++ linux/arch/x86/kernel/apic/x2apic_uv_x.c
@@ -39,12 +39,6 @@
 #include <asm/x86_init.h>
 #include <asm/nmi.h>
 
-/* BMC sets a bit this MMR non-zero before sending an NMI */
-#define UVH_NMI_MMR				UVH_SCRATCH5
-#define UVH_NMI_MMR_CLEAR			(UVH_NMI_MMR + 8)
-#define UV_NMI_PENDING_MASK			(1UL << 63)
-DEFINE_PER_CPU(unsigned long, cpu_last_nmi_count);
-
 DEFINE_PER_CPU(int, x2apic_extra_bits);
 
 #define PR_DEVEL(fmt, args...)	pr_devel("%s: " fmt, __func__, args)
@@ -58,7 +52,6 @@ int uv_min_hub_revision_id;
 EXPORT_SYMBOL_GPL(uv_min_hub_revision_id);
 unsigned int uv_apicid_hibits;
 EXPORT_SYMBOL_GPL(uv_apicid_hibits);
-static DEFINE_SPINLOCK(uv_nmi_lock);
 
 static struct apic apic_x2apic_uv_x;
 
@@ -854,68 +847,6 @@ void uv_cpu_init(void)
 		set_x2apic_extra_bits(uv_hub_info->pnode);
 }
 
-/*
- * When NMI is received, print a stack trace.
- */
-int uv_handle_nmi(unsigned int reason, struct pt_regs *regs)
-{
-	unsigned long real_uv_nmi;
-	int bid;
-
-	/*
-	 * Each blade has an MMR that indicates when an NMI has been sent
-	 * to cpus on the blade. If an NMI is detected, atomically
-	 * clear the MMR and update a per-blade NMI count used to
-	 * cause each cpu on the blade to notice a new NMI.
-	 */
-	bid = uv_numa_blade_id();
-	real_uv_nmi = (uv_read_local_mmr(UVH_NMI_MMR) & UV_NMI_PENDING_MASK);
-
-	if (unlikely(real_uv_nmi)) {
-		spin_lock(&uv_blade_info[bid].nmi_lock);
-		real_uv_nmi = (uv_read_local_mmr(UVH_NMI_MMR) & UV_NMI_PENDING_MASK);
-		if (real_uv_nmi) {
-			uv_blade_info[bid].nmi_count++;
-			uv_write_local_mmr(UVH_NMI_MMR_CLEAR, UV_NMI_PENDING_MASK);
-		}
-		spin_unlock(&uv_blade_info[bid].nmi_lock);
-	}
-
-	if (likely(__get_cpu_var(cpu_last_nmi_count) == uv_blade_info[bid].nmi_count))
-		return NMI_DONE;
-
-	__get_cpu_var(cpu_last_nmi_count) = uv_blade_info[bid].nmi_count;
-
-	/*
-	 * Use a lock so only one cpu prints at a time.
-	 * This prevents intermixed output.
-	 */
-	spin_lock(&uv_nmi_lock);
-	pr_info("UV NMI stack dump cpu %u:\n", smp_processor_id());
-	dump_stack();
-	spin_unlock(&uv_nmi_lock);
-
-	return NMI_HANDLED;
-}
-
-void uv_register_nmi_notifier(void)
-{
-	if (register_nmi_handler(NMI_UNKNOWN, uv_handle_nmi, 0, "uv"))
-		printk(KERN_WARNING "UV NMI handler failed to register\n");
-}
-
-void uv_nmi_init(void)
-{
-	unsigned int value;
-
-	/*
-	 * Unmask NMI on all cpus
-	 */
-	value = apic_read(APIC_LVT1) | APIC_DM_NMI;
-	value &= ~APIC_LVT_MASKED;
-	apic_write(APIC_LVT1, value);
-}
-
 void __init uv_system_init(void)
 {
 	union uvh_rh_gam_config_mmr_u  m_n_config;
--- linux.orig/arch/x86/platform/uv/Makefile
+++ linux/arch/x86/platform/uv/Makefile
@@ -1 +1 @@
-obj-$(CONFIG_X86_UV)		+= tlb_uv.o bios_uv.o uv_irq.o uv_sysfs.o uv_time.o
+obj-$(CONFIG_X86_UV)		+= tlb_uv.o bios_uv.o uv_irq.o uv_sysfs.o uv_time.o uv_nmi.o
--- /dev/null
+++ linux/arch/x86/platform/uv/uv_nmi.c
@@ -0,0 +1,102 @@
+/*
+ * SGI NMI support routines
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2 of the License, or
+ *  (at your option) any later version.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to the Free Software
+ *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA
+ *
+ *  Copyright (c) 2009-2013 Silicon Graphics, Inc.  All Rights Reserved.
+ *  Copyright (c) Mike Travis
+ */
+
+#include <linux/cpu.h>
+#include <linux/nmi.h>
+
+#include <asm/apic.h>
+#include <asm/nmi.h>
+#include <asm/uv/uv.h>
+#include <asm/uv/uv_hub.h>
+#include <asm/uv/uv_mmrs.h>
+
+/* BMC sets a bit this MMR non-zero before sending an NMI */
+#define UVH_NMI_MMR				UVH_SCRATCH5
+#define UVH_NMI_MMR_CLEAR			(UVH_NMI_MMR + 8)
+#define UV_NMI_PENDING_MASK			(1UL << 63)
+DEFINE_PER_CPU(unsigned long, cpu_last_nmi_count);
+static DEFINE_SPINLOCK(uv_nmi_lock);
+
+/*
+ * When NMI is received, print a stack trace.
+ */
+int uv_handle_nmi(unsigned int reason, struct pt_regs *regs)
+{
+	unsigned long real_uv_nmi;
+	int bid;
+
+	/*
+	 * Each blade has an MMR that indicates when an NMI has been sent
+	 * to cpus on the blade. If an NMI is detected, atomically
+	 * clear the MMR and update a per-blade NMI count used to
+	 * cause each cpu on the blade to notice a new NMI.
+	 */
+	bid = uv_numa_blade_id();
+	real_uv_nmi = (uv_read_local_mmr(UVH_NMI_MMR) & UV_NMI_PENDING_MASK);
+
+	if (unlikely(real_uv_nmi)) {
+		spin_lock(&uv_blade_info[bid].nmi_lock);
+		real_uv_nmi = (uv_read_local_mmr(UVH_NMI_MMR) &
+				UV_NMI_PENDING_MASK);
+		if (real_uv_nmi) {
+			uv_blade_info[bid].nmi_count++;
+			uv_write_local_mmr(UVH_NMI_MMR_CLEAR,
+						UV_NMI_PENDING_MASK);
+		}
+		spin_unlock(&uv_blade_info[bid].nmi_lock);
+	}
+
+	if (likely(__get_cpu_var(cpu_last_nmi_count) ==
+			uv_blade_info[bid].nmi_count))
+		return NMI_DONE;
+
+	__get_cpu_var(cpu_last_nmi_count) = uv_blade_info[bid].nmi_count;
+
+	/*
+	 * Use a lock so only one cpu prints at a time.
+	 * This prevents intermixed output.
+	 */
+	spin_lock(&uv_nmi_lock);
+	pr_info("UV NMI stack dump cpu %u:\n", smp_processor_id());
+	dump_stack();
+	spin_unlock(&uv_nmi_lock);
+
+	return NMI_HANDLED;
+}
+
+void uv_register_nmi_notifier(void)
+{
+	if (register_nmi_handler(NMI_UNKNOWN, uv_handle_nmi, 0, "uv"))
+		pr_warn("UV NMI handler failed to register\n");
+}
+
+void uv_nmi_init(void)
+{
+	unsigned int value;
+
+	/*
+	 * Unmask NMI on all cpus
+	 */
+	value = apic_read(APIC_LVT1) | APIC_DM_NMI;
+	value &= ~APIC_LVT_MASKED;
+	apic_write(APIC_LVT1, value);
+}
+

-- 
