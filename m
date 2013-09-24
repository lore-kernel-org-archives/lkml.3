Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751305Ab3IXIh7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 04:37:59 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53235 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750724Ab3IXIhz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 04:37:55 -0400
Date: Tue, 24 Sep 2013 01:37:25 -0700
From: tip-bot for Mike Travis <tipbot@zytor.com>
Message-ID: <tip-1e019421bca68cfae1a61a09d9d49cf6a9e2143b@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
        mingo@kernel.org, jason.wessel@windriver.com, a.p.zijlstra@chello.nl,
        travis@sgi.com, acme@ghostprotocols.net, hedi@sgi.com,
        sivanich@sgi.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, travis@sgi.com, a.p.zijlstra@chello.nl,
        jason.wessel@windriver.com, acme@ghostprotocols.net, hedi@sgi.com,
        sivanich@sgi.com, tglx@linutronix.de
In-Reply-To: <20130923212500.183295611@asylum.americas.sgi.com>
References: <20130923212500.183295611@asylum.americas.sgi.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/uv] x86/UV: Move NMI support
Git-Commit-ID: 1e019421bca68cfae1a61a09d9d49cf6a9e2143b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Tue, 24 Sep 2013 01:37:33 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1e019421bca68cfae1a61a09d9d49cf6a9e2143b
Gitweb:     http://git.kernel.org/tip/1e019421bca68cfae1a61a09d9d49cf6a9e2143b
Author:     Mike Travis <travis@sgi.com>
AuthorDate: Mon, 23 Sep 2013 16:25:00 -0500
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 24 Sep 2013 09:02:02 +0200

x86/UV: Move NMI support

This patch moves the UV NMI support from the x2apic file to a
new separate uv_nmi.c file in preparation for the next sequence
of patches. It prevents upcoming bloat of the x2apic file, and
has the added benefit of putting the upcoming /sys/module
parameters under the name 'uv_nmi' instead of 'x2apic_uv_x',
which was obscure.

Signed-off-by: Mike Travis <travis@sgi.com>
Reviewed-by: Dimitri Sivanich <sivanich@sgi.com>
Reviewed-by: Hedi Berriche <hedi@sgi.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Jason Wessel <jason.wessel@windriver.com>
Link: http://lkml.kernel.org/r/20130923212500.183295611@asylum.americas.sgi.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/include/asm/uv/uv.h       |   2 +
 arch/x86/kernel/apic/x2apic_uv_x.c |  69 -------------------------
 arch/x86/platform/uv/Makefile      |   2 +-
 arch/x86/platform/uv/uv_nmi.c      | 102 +++++++++++++++++++++++++++++++++++++
 4 files changed, 105 insertions(+), 70 deletions(-)

diff --git a/arch/x86/include/asm/uv/uv.h b/arch/x86/include/asm/uv/uv.h
index 062921e..6b964a0 100644
--- a/arch/x86/include/asm/uv/uv.h
+++ b/arch/x86/include/asm/uv/uv.h
@@ -12,6 +12,7 @@ extern enum uv_system_type get_uv_system_type(void);
 extern int is_uv_system(void);
 extern void uv_cpu_init(void);
 extern void uv_nmi_init(void);
+extern void uv_register_nmi_notifier(void);
 extern void uv_system_init(void);
 extern const struct cpumask *uv_flush_tlb_others(const struct cpumask *cpumask,
 						 struct mm_struct *mm,
@@ -25,6 +26,7 @@ static inline enum uv_system_type get_uv_system_type(void) { return UV_NONE; }
 static inline int is_uv_system(void)	{ return 0; }
 static inline void uv_cpu_init(void)	{ }
 static inline void uv_system_init(void)	{ }
+static inline void uv_register_nmi_notifier(void) { }
 static inline const struct cpumask *
 uv_flush_tlb_others(const struct cpumask *cpumask, struct mm_struct *mm,
 		    unsigned long start, unsigned long end, unsigned int cpu)
diff --git a/arch/x86/kernel/apic/x2apic_uv_x.c b/arch/x86/kernel/apic/x2apic_uv_x.c
index 1191ac1..9e47c06 100644
--- a/arch/x86/kernel/apic/x2apic_uv_x.c
+++ b/arch/x86/kernel/apic/x2apic_uv_x.c
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
 
@@ -847,68 +840,6 @@ void uv_cpu_init(void)
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
diff --git a/arch/x86/platform/uv/Makefile b/arch/x86/platform/uv/Makefile
index 6c40995..52079be 100644
--- a/arch/x86/platform/uv/Makefile
+++ b/arch/x86/platform/uv/Makefile
@@ -1 +1 @@
-obj-$(CONFIG_X86_UV)		+= tlb_uv.o bios_uv.o uv_irq.o uv_sysfs.o uv_time.o
+obj-$(CONFIG_X86_UV)		+= tlb_uv.o bios_uv.o uv_irq.o uv_sysfs.o uv_time.o uv_nmi.o
diff --git a/arch/x86/platform/uv/uv_nmi.c b/arch/x86/platform/uv/uv_nmi.c
new file mode 100644
index 0000000..37feb60
--- /dev/null
+++ b/arch/x86/platform/uv/uv_nmi.c
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
