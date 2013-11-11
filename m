Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755170Ab3KKTAG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 14:00:06 -0500
Received: from mail-ea0-f169.google.com ([209.85.215.169]:48490 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754119Ab3KKS7z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 13:59:55 -0500
Date: Mon, 11 Nov 2013 19:59:51 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jason Wessel <jason.wessel@windriver.com>
Subject: [GIT PULL] x86/uv changes for v3.13, UV KDB support
Message-ID: <20131111185951.GB15854@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-uv-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-uv-for-linus

   # HEAD: b5dfcb09debc38582c3cb72a3c1a88b919b07f2d Revert "x86/UV: Add uvtrace support"

Various SGI UV debuggability improvements, amongst them KDB support, with 
related core KDB enabling patches changing kernel/debug/kdb/.

  out-of-topic modifications in x86-uv-for-linus:
  -------------------------------------------------
  include/linux/kdb.h                # 8daaa5f: kdb: Add support for external NMI
  include/linux/kgdb.h               # 8daaa5f: kdb: Add support for external NMI
  kernel/debug/debug_core.c          # 8daaa5f: kdb: Add support for external NMI
  kernel/debug/debug_core.h          # 8daaa5f: kdb: Add support for external NMI
  kernel/debug/kdb/kdb_debugger.c    # 8daaa5f: kdb: Add support for external NMI
  kernel/debug/kdb/kdb_main.c        # 8daaa5f: kdb: Add support for external NMI

 Thanks,

	Ingo

------------------>
Ingo Molnar (2):
      x86/UV: Check for alloc_cpumask_var() failures properly in uv_nmi_setup()
      Revert "x86/UV: Add uvtrace support"

Mike Travis (7):
      x86/UV: Move NMI support
      x86/UV: Update UV support for external NMI signals
      x86/UV: Add summary of cpu activity to UV NMI handler
      x86/UV: Add kdump to UV NMI handler
      x86/UV: Add uvtrace support
      kdb: Add support for external NMI handler to call KGDB/KDB
      x86/UV: Add call to KGDB/KDB from NMI handler


 arch/x86/include/asm/uv/uv.h       |   2 +
 arch/x86/include/asm/uv/uv_hub.h   |  57 ++-
 arch/x86/include/asm/uv/uv_mmrs.h  |  31 ++
 arch/x86/kernel/apic/x2apic_uv_x.c |  70 +---
 arch/x86/platform/uv/Makefile      |   2 +-
 arch/x86/platform/uv/uv_nmi.c      | 700 +++++++++++++++++++++++++++++++++++++
 include/linux/kdb.h                |   1 +
 include/linux/kgdb.h               |   1 +
 kernel/debug/debug_core.c          |  32 +-
 kernel/debug/debug_core.h          |   3 +
 kernel/debug/kdb/kdb_debugger.c    |   5 +-
 kernel/debug/kdb/kdb_main.c        |   3 +
 12 files changed, 832 insertions(+), 75 deletions(-)
 create mode 100644 arch/x86/platform/uv/uv_nmi.c

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
diff --git a/arch/x86/include/asm/uv/uv_hub.h b/arch/x86/include/asm/uv/uv_hub.h
index 2c32df9..a30836c 100644
--- a/arch/x86/include/asm/uv/uv_hub.h
+++ b/arch/x86/include/asm/uv/uv_hub.h
@@ -502,8 +502,8 @@ struct uv_blade_info {
 	unsigned short	nr_online_cpus;
 	unsigned short	pnode;
 	short		memory_nid;
-	spinlock_t	nmi_lock;
-	unsigned long	nmi_count;
+	spinlock_t	nmi_lock;	/* obsolete, see uv_hub_nmi */
+	unsigned long	nmi_count;	/* obsolete, see uv_hub_nmi */
 };
 extern struct uv_blade_info *uv_blade_info;
 extern short *uv_node_to_blade;
@@ -576,6 +576,59 @@ static inline int uv_num_possible_blades(void)
 	return uv_possible_blades;
 }
 
+/* Per Hub NMI support */
+extern void uv_nmi_setup(void);
+
+/* BMC sets a bit this MMR non-zero before sending an NMI */
+#define UVH_NMI_MMR		UVH_SCRATCH5
+#define UVH_NMI_MMR_CLEAR	UVH_SCRATCH5_ALIAS
+#define UVH_NMI_MMR_SHIFT	63
+#define	UVH_NMI_MMR_TYPE	"SCRATCH5"
+
+/* Newer SMM NMI handler, not present in all systems */
+#define UVH_NMI_MMRX		UVH_EVENT_OCCURRED0
+#define UVH_NMI_MMRX_CLEAR	UVH_EVENT_OCCURRED0_ALIAS
+#define UVH_NMI_MMRX_SHIFT	(is_uv1_hub() ? \
+					UV1H_EVENT_OCCURRED0_EXTIO_INT0_SHFT :\
+					UVXH_EVENT_OCCURRED0_EXTIO_INT0_SHFT)
+#define	UVH_NMI_MMRX_TYPE	"EXTIO_INT0"
+
+/* Non-zero indicates newer SMM NMI handler present */
+#define UVH_NMI_MMRX_SUPPORTED	UVH_EXTIO_INT0_BROADCAST
+
+/* Indicates to BIOS that we want to use the newer SMM NMI handler */
+#define UVH_NMI_MMRX_REQ	UVH_SCRATCH5_ALIAS_2
+#define UVH_NMI_MMRX_REQ_SHIFT	62
+
+struct uv_hub_nmi_s {
+	raw_spinlock_t	nmi_lock;
+	atomic_t	in_nmi;		/* flag this node in UV NMI IRQ */
+	atomic_t	cpu_owner;	/* last locker of this struct */
+	atomic_t	read_mmr_count;	/* count of MMR reads */
+	atomic_t	nmi_count;	/* count of true UV NMIs */
+	unsigned long	nmi_value;	/* last value read from NMI MMR */
+};
+
+struct uv_cpu_nmi_s {
+	struct uv_hub_nmi_s	*hub;
+	atomic_t		state;
+	atomic_t		pinging;
+	int			queries;
+	int			pings;
+};
+
+DECLARE_PER_CPU(struct uv_cpu_nmi_s, __uv_cpu_nmi);
+#define uv_cpu_nmi			(__get_cpu_var(__uv_cpu_nmi))
+#define uv_hub_nmi			(uv_cpu_nmi.hub)
+#define uv_cpu_nmi_per(cpu)		(per_cpu(__uv_cpu_nmi, cpu))
+#define uv_hub_nmi_per(cpu)		(uv_cpu_nmi_per(cpu).hub)
+
+/* uv_cpu_nmi_states */
+#define	UV_NMI_STATE_OUT		0
+#define	UV_NMI_STATE_IN			1
+#define	UV_NMI_STATE_DUMP		2
+#define	UV_NMI_STATE_DUMP_DONE		3
+
 /* Update SCIR state */
 static inline void uv_set_scir_bits(unsigned char value)
 {
diff --git a/arch/x86/include/asm/uv/uv_mmrs.h b/arch/x86/include/asm/uv/uv_mmrs.h
index bd5f80e..e42249b 100644
--- a/arch/x86/include/asm/uv/uv_mmrs.h
+++ b/arch/x86/include/asm/uv/uv_mmrs.h
@@ -461,6 +461,23 @@ union uvh_event_occurred0_u {
 
 
 /* ========================================================================= */
+/*                         UVH_EXTIO_INT0_BROADCAST                          */
+/* ========================================================================= */
+#define UVH_EXTIO_INT0_BROADCAST 0x61448UL
+#define UVH_EXTIO_INT0_BROADCAST_32 0x3f0
+
+#define UVH_EXTIO_INT0_BROADCAST_ENABLE_SHFT		0
+#define UVH_EXTIO_INT0_BROADCAST_ENABLE_MASK		0x0000000000000001UL
+
+union uvh_extio_int0_broadcast_u {
+	unsigned long	v;
+	struct uvh_extio_int0_broadcast_s {
+		unsigned long	enable:1;			/* RW */
+		unsigned long	rsvd_1_63:63;
+	} s;
+};
+
+/* ========================================================================= */
 /*                         UVH_GR0_TLB_INT0_CONFIG                           */
 /* ========================================================================= */
 #define UVH_GR0_TLB_INT0_CONFIG 0x61b00UL
@@ -2606,6 +2623,20 @@ union uvh_scratch5_u {
 };
 
 /* ========================================================================= */
+/*                            UVH_SCRATCH5_ALIAS                             */
+/* ========================================================================= */
+#define UVH_SCRATCH5_ALIAS 0x2d0208UL
+#define UVH_SCRATCH5_ALIAS_32 0x780
+
+
+/* ========================================================================= */
+/*                           UVH_SCRATCH5_ALIAS_2                            */
+/* ========================================================================= */
+#define UVH_SCRATCH5_ALIAS_2 0x2d0210UL
+#define UVH_SCRATCH5_ALIAS_2_32 0x788
+
+
+/* ========================================================================= */
 /*                          UVXH_EVENT_OCCURRED2                             */
 /* ========================================================================= */
 #define UVXH_EVENT_OCCURRED2 0x70100UL
diff --git a/arch/x86/kernel/apic/x2apic_uv_x.c b/arch/x86/kernel/apic/x2apic_uv_x.c
index 1191ac1..0a5a4b8 100644
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
@@ -1046,6 +977,7 @@ void __init uv_system_init(void)
 	map_mmr_high(max_pnode);
 	map_mmioh_high(min_pnode, max_pnode);
 
+	uv_nmi_setup();
 	uv_cpu_init();
 	uv_scir_register_cpu_notifier();
 	uv_register_nmi_notifier();
diff --git a/arch/x86/platform/uv/Makefile b/arch/x86/platform/uv/Makefile
index 6c40995..52079be 100644
--- a/arch/x86/platform/uv/Makefile
+++ b/arch/x86/platform/uv/Makefile
@@ -1 +1 @@
-obj-$(CONFIG_X86_UV)		+= tlb_uv.o bios_uv.o uv_irq.o uv_sysfs.o uv_time.o
+obj-$(CONFIG_X86_UV)		+= tlb_uv.o bios_uv.o uv_irq.o uv_sysfs.o uv_time.o uv_nmi.o
diff --git a/arch/x86/platform/uv/uv_nmi.c b/arch/x86/platform/uv/uv_nmi.c
new file mode 100644
index 0000000..2e863ad
--- /dev/null
+++ b/arch/x86/platform/uv/uv_nmi.c
@@ -0,0 +1,700 @@
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
+#include <linux/delay.h>
+#include <linux/kdb.h>
+#include <linux/kexec.h>
+#include <linux/kgdb.h>
+#include <linux/module.h>
+#include <linux/nmi.h>
+#include <linux/sched.h>
+#include <linux/slab.h>
+
+#include <asm/apic.h>
+#include <asm/current.h>
+#include <asm/kdebug.h>
+#include <asm/local64.h>
+#include <asm/nmi.h>
+#include <asm/traps.h>
+#include <asm/uv/uv.h>
+#include <asm/uv/uv_hub.h>
+#include <asm/uv/uv_mmrs.h>
+
+/*
+ * UV handler for NMI
+ *
+ * Handle system-wide NMI events generated by the global 'power nmi' command.
+ *
+ * Basic operation is to field the NMI interrupt on each cpu and wait
+ * until all cpus have arrived into the nmi handler.  If some cpus do not
+ * make it into the handler, try and force them in with the IPI(NMI) signal.
+ *
+ * We also have to lessen UV Hub MMR accesses as much as possible as this
+ * disrupts the UV Hub's primary mission of directing NumaLink traffic and
+ * can cause system problems to occur.
+ *
+ * To do this we register our primary NMI notifier on the NMI_UNKNOWN
+ * chain.  This reduces the number of false NMI calls when the perf
+ * tools are running which generate an enormous number of NMIs per
+ * second (~4M/s for 1024 cpu threads).  Our secondary NMI handler is
+ * very short as it only checks that if it has been "pinged" with the
+ * IPI(NMI) signal as mentioned above, and does not read the UV Hub's MMR.
+ *
+ */
+
+static struct uv_hub_nmi_s **uv_hub_nmi_list;
+
+DEFINE_PER_CPU(struct uv_cpu_nmi_s, __uv_cpu_nmi);
+EXPORT_PER_CPU_SYMBOL_GPL(__uv_cpu_nmi);
+
+static unsigned long nmi_mmr;
+static unsigned long nmi_mmr_clear;
+static unsigned long nmi_mmr_pending;
+
+static atomic_t	uv_in_nmi;
+static atomic_t uv_nmi_cpu = ATOMIC_INIT(-1);
+static atomic_t uv_nmi_cpus_in_nmi = ATOMIC_INIT(-1);
+static atomic_t uv_nmi_slave_continue;
+static atomic_t uv_nmi_kexec_failed;
+static cpumask_var_t uv_nmi_cpu_mask;
+
+/* Values for uv_nmi_slave_continue */
+#define SLAVE_CLEAR	0
+#define SLAVE_CONTINUE	1
+#define SLAVE_EXIT	2
+
+/*
+ * Default is all stack dumps go to the console and buffer.
+ * Lower level to send to log buffer only.
+ */
+static int uv_nmi_loglevel = 7;
+module_param_named(dump_loglevel, uv_nmi_loglevel, int, 0644);
+
+/*
+ * The following values show statistics on how perf events are affecting
+ * this system.
+ */
+static int param_get_local64(char *buffer, const struct kernel_param *kp)
+{
+	return sprintf(buffer, "%lu\n", local64_read((local64_t *)kp->arg));
+}
+
+static int param_set_local64(const char *val, const struct kernel_param *kp)
+{
+	/* clear on any write */
+	local64_set((local64_t *)kp->arg, 0);
+	return 0;
+}
+
+static struct kernel_param_ops param_ops_local64 = {
+	.get = param_get_local64,
+	.set = param_set_local64,
+};
+#define param_check_local64(name, p) __param_check(name, p, local64_t)
+
+static local64_t uv_nmi_count;
+module_param_named(nmi_count, uv_nmi_count, local64, 0644);
+
+static local64_t uv_nmi_misses;
+module_param_named(nmi_misses, uv_nmi_misses, local64, 0644);
+
+static local64_t uv_nmi_ping_count;
+module_param_named(ping_count, uv_nmi_ping_count, local64, 0644);
+
+static local64_t uv_nmi_ping_misses;
+module_param_named(ping_misses, uv_nmi_ping_misses, local64, 0644);
+
+/*
+ * Following values allow tuning for large systems under heavy loading
+ */
+static int uv_nmi_initial_delay = 100;
+module_param_named(initial_delay, uv_nmi_initial_delay, int, 0644);
+
+static int uv_nmi_slave_delay = 100;
+module_param_named(slave_delay, uv_nmi_slave_delay, int, 0644);
+
+static int uv_nmi_loop_delay = 100;
+module_param_named(loop_delay, uv_nmi_loop_delay, int, 0644);
+
+static int uv_nmi_trigger_delay = 10000;
+module_param_named(trigger_delay, uv_nmi_trigger_delay, int, 0644);
+
+static int uv_nmi_wait_count = 100;
+module_param_named(wait_count, uv_nmi_wait_count, int, 0644);
+
+static int uv_nmi_retry_count = 500;
+module_param_named(retry_count, uv_nmi_retry_count, int, 0644);
+
+/*
+ * Valid NMI Actions:
+ *  "dump"	- dump process stack for each cpu
+ *  "ips"	- dump IP info for each cpu
+ *  "kdump"	- do crash dump
+ *  "kdb"	- enter KDB/KGDB (default)
+ */
+static char uv_nmi_action[8] = "kdb";
+module_param_string(action, uv_nmi_action, sizeof(uv_nmi_action), 0644);
+
+static inline bool uv_nmi_action_is(const char *action)
+{
+	return (strncmp(uv_nmi_action, action, strlen(action)) == 0);
+}
+
+/* Setup which NMI support is present in system */
+static void uv_nmi_setup_mmrs(void)
+{
+	if (uv_read_local_mmr(UVH_NMI_MMRX_SUPPORTED)) {
+		uv_write_local_mmr(UVH_NMI_MMRX_REQ,
+					1UL << UVH_NMI_MMRX_REQ_SHIFT);
+		nmi_mmr = UVH_NMI_MMRX;
+		nmi_mmr_clear = UVH_NMI_MMRX_CLEAR;
+		nmi_mmr_pending = 1UL << UVH_NMI_MMRX_SHIFT;
+		pr_info("UV: SMI NMI support: %s\n", UVH_NMI_MMRX_TYPE);
+	} else {
+		nmi_mmr = UVH_NMI_MMR;
+		nmi_mmr_clear = UVH_NMI_MMR_CLEAR;
+		nmi_mmr_pending = 1UL << UVH_NMI_MMR_SHIFT;
+		pr_info("UV: SMI NMI support: %s\n", UVH_NMI_MMR_TYPE);
+	}
+}
+
+/* Read NMI MMR and check if NMI flag was set by BMC. */
+static inline int uv_nmi_test_mmr(struct uv_hub_nmi_s *hub_nmi)
+{
+	hub_nmi->nmi_value = uv_read_local_mmr(nmi_mmr);
+	atomic_inc(&hub_nmi->read_mmr_count);
+	return !!(hub_nmi->nmi_value & nmi_mmr_pending);
+}
+
+static inline void uv_local_mmr_clear_nmi(void)
+{
+	uv_write_local_mmr(nmi_mmr_clear, nmi_mmr_pending);
+}
+
+/*
+ * If first cpu in on this hub, set hub_nmi "in_nmi" and "owner" values and
+ * return true.  If first cpu in on the system, set global "in_nmi" flag.
+ */
+static int uv_set_in_nmi(int cpu, struct uv_hub_nmi_s *hub_nmi)
+{
+	int first = atomic_add_unless(&hub_nmi->in_nmi, 1, 1);
+
+	if (first) {
+		atomic_set(&hub_nmi->cpu_owner, cpu);
+		if (atomic_add_unless(&uv_in_nmi, 1, 1))
+			atomic_set(&uv_nmi_cpu, cpu);
+
+		atomic_inc(&hub_nmi->nmi_count);
+	}
+	return first;
+}
+
+/* Check if this is a system NMI event */
+static int uv_check_nmi(struct uv_hub_nmi_s *hub_nmi)
+{
+	int cpu = smp_processor_id();
+	int nmi = 0;
+
+	local64_inc(&uv_nmi_count);
+	uv_cpu_nmi.queries++;
+
+	do {
+		nmi = atomic_read(&hub_nmi->in_nmi);
+		if (nmi)
+			break;
+
+		if (raw_spin_trylock(&hub_nmi->nmi_lock)) {
+
+			/* check hub MMR NMI flag */
+			if (uv_nmi_test_mmr(hub_nmi)) {
+				uv_set_in_nmi(cpu, hub_nmi);
+				nmi = 1;
+				break;
+			}
+
+			/* MMR NMI flag is clear */
+			raw_spin_unlock(&hub_nmi->nmi_lock);
+
+		} else {
+			/* wait a moment for the hub nmi locker to set flag */
+			cpu_relax();
+			udelay(uv_nmi_slave_delay);
+
+			/* re-check hub in_nmi flag */
+			nmi = atomic_read(&hub_nmi->in_nmi);
+			if (nmi)
+				break;
+		}
+
+		/* check if this BMC missed setting the MMR NMI flag */
+		if (!nmi) {
+			nmi = atomic_read(&uv_in_nmi);
+			if (nmi)
+				uv_set_in_nmi(cpu, hub_nmi);
+		}
+
+	} while (0);
+
+	if (!nmi)
+		local64_inc(&uv_nmi_misses);
+
+	return nmi;
+}
+
+/* Need to reset the NMI MMR register, but only once per hub. */
+static inline void uv_clear_nmi(int cpu)
+{
+	struct uv_hub_nmi_s *hub_nmi = uv_hub_nmi;
+
+	if (cpu == atomic_read(&hub_nmi->cpu_owner)) {
+		atomic_set(&hub_nmi->cpu_owner, -1);
+		atomic_set(&hub_nmi->in_nmi, 0);
+		uv_local_mmr_clear_nmi();
+		raw_spin_unlock(&hub_nmi->nmi_lock);
+	}
+}
+
+/* Print non-responding cpus */
+static void uv_nmi_nr_cpus_pr(char *fmt)
+{
+	static char cpu_list[1024];
+	int len = sizeof(cpu_list);
+	int c = cpumask_weight(uv_nmi_cpu_mask);
+	int n = cpulist_scnprintf(cpu_list, len, uv_nmi_cpu_mask);
+
+	if (n >= len-1)
+		strcpy(&cpu_list[len - 6], "...\n");
+
+	printk(fmt, c, cpu_list);
+}
+
+/* Ping non-responding cpus attemping to force them into the NMI handler */
+static void uv_nmi_nr_cpus_ping(void)
+{
+	int cpu;
+
+	for_each_cpu(cpu, uv_nmi_cpu_mask)
+		atomic_set(&uv_cpu_nmi_per(cpu).pinging, 1);
+
+	apic->send_IPI_mask(uv_nmi_cpu_mask, APIC_DM_NMI);
+}
+
+/* Clean up flags for cpus that ignored both NMI and ping */
+static void uv_nmi_cleanup_mask(void)
+{
+	int cpu;
+
+	for_each_cpu(cpu, uv_nmi_cpu_mask) {
+		atomic_set(&uv_cpu_nmi_per(cpu).pinging, 0);
+		atomic_set(&uv_cpu_nmi_per(cpu).state, UV_NMI_STATE_OUT);
+		cpumask_clear_cpu(cpu, uv_nmi_cpu_mask);
+	}
+}
+
+/* Loop waiting as cpus enter nmi handler */
+static int uv_nmi_wait_cpus(int first)
+{
+	int i, j, k, n = num_online_cpus();
+	int last_k = 0, waiting = 0;
+
+	if (first) {
+		cpumask_copy(uv_nmi_cpu_mask, cpu_online_mask);
+		k = 0;
+	} else {
+		k = n - cpumask_weight(uv_nmi_cpu_mask);
+	}
+
+	udelay(uv_nmi_initial_delay);
+	for (i = 0; i < uv_nmi_retry_count; i++) {
+		int loop_delay = uv_nmi_loop_delay;
+
+		for_each_cpu(j, uv_nmi_cpu_mask) {
+			if (atomic_read(&uv_cpu_nmi_per(j).state)) {
+				cpumask_clear_cpu(j, uv_nmi_cpu_mask);
+				if (++k >= n)
+					break;
+			}
+		}
+		if (k >= n) {		/* all in? */
+			k = n;
+			break;
+		}
+		if (last_k != k) {	/* abort if no new cpus coming in */
+			last_k = k;
+			waiting = 0;
+		} else if (++waiting > uv_nmi_wait_count)
+			break;
+
+		/* extend delay if waiting only for cpu 0 */
+		if (waiting && (n - k) == 1 &&
+		    cpumask_test_cpu(0, uv_nmi_cpu_mask))
+			loop_delay *= 100;
+
+		udelay(loop_delay);
+	}
+	atomic_set(&uv_nmi_cpus_in_nmi, k);
+	return n - k;
+}
+
+/* Wait until all slave cpus have entered UV NMI handler */
+static void uv_nmi_wait(int master)
+{
+	/* indicate this cpu is in */
+	atomic_set(&uv_cpu_nmi.state, UV_NMI_STATE_IN);
+
+	/* if not the first cpu in (the master), then we are a slave cpu */
+	if (!master)
+		return;
+
+	do {
+		/* wait for all other cpus to gather here */
+		if (!uv_nmi_wait_cpus(1))
+			break;
+
+		/* if not all made it in, send IPI NMI to them */
+		uv_nmi_nr_cpus_pr(KERN_ALERT
+			"UV: Sending NMI IPI to %d non-responding CPUs: %s\n");
+		uv_nmi_nr_cpus_ping();
+
+		/* if all cpus are in, then done */
+		if (!uv_nmi_wait_cpus(0))
+			break;
+
+		uv_nmi_nr_cpus_pr(KERN_ALERT
+			"UV: %d CPUs not in NMI loop: %s\n");
+	} while (0);
+
+	pr_alert("UV: %d of %d CPUs in NMI\n",
+		atomic_read(&uv_nmi_cpus_in_nmi), num_online_cpus());
+}
+
+static void uv_nmi_dump_cpu_ip_hdr(void)
+{
+	printk(KERN_DEFAULT
+		"\nUV: %4s %6s %-32s %s   (Note: PID 0 not listed)\n",
+		"CPU", "PID", "COMMAND", "IP");
+}
+
+static void uv_nmi_dump_cpu_ip(int cpu, struct pt_regs *regs)
+{
+	printk(KERN_DEFAULT "UV: %4d %6d %-32.32s ",
+		cpu, current->pid, current->comm);
+
+	printk_address(regs->ip, 1);
+}
+
+/* Dump this cpu's state */
+static void uv_nmi_dump_state_cpu(int cpu, struct pt_regs *regs)
+{
+	const char *dots = " ................................. ";
+
+	if (uv_nmi_action_is("ips")) {
+		if (cpu == 0)
+			uv_nmi_dump_cpu_ip_hdr();
+
+		if (current->pid != 0)
+			uv_nmi_dump_cpu_ip(cpu, regs);
+
+	} else if (uv_nmi_action_is("dump")) {
+		printk(KERN_DEFAULT
+			"UV:%sNMI process trace for CPU %d\n", dots, cpu);
+		show_regs(regs);
+	}
+	atomic_set(&uv_cpu_nmi.state, UV_NMI_STATE_DUMP_DONE);
+}
+
+/* Trigger a slave cpu to dump it's state */
+static void uv_nmi_trigger_dump(int cpu)
+{
+	int retry = uv_nmi_trigger_delay;
+
+	if (atomic_read(&uv_cpu_nmi_per(cpu).state) != UV_NMI_STATE_IN)
+		return;
+
+	atomic_set(&uv_cpu_nmi_per(cpu).state, UV_NMI_STATE_DUMP);
+	do {
+		cpu_relax();
+		udelay(10);
+		if (atomic_read(&uv_cpu_nmi_per(cpu).state)
+				!= UV_NMI_STATE_DUMP)
+			return;
+	} while (--retry > 0);
+
+	pr_crit("UV: CPU %d stuck in process dump function\n", cpu);
+	atomic_set(&uv_cpu_nmi_per(cpu).state, UV_NMI_STATE_DUMP_DONE);
+}
+
+/* Wait until all cpus ready to exit */
+static void uv_nmi_sync_exit(int master)
+{
+	atomic_dec(&uv_nmi_cpus_in_nmi);
+	if (master) {
+		while (atomic_read(&uv_nmi_cpus_in_nmi) > 0)
+			cpu_relax();
+		atomic_set(&uv_nmi_slave_continue, SLAVE_CLEAR);
+	} else {
+		while (atomic_read(&uv_nmi_slave_continue))
+			cpu_relax();
+	}
+}
+
+/* Walk through cpu list and dump state of each */
+static void uv_nmi_dump_state(int cpu, struct pt_regs *regs, int master)
+{
+	if (master) {
+		int tcpu;
+		int ignored = 0;
+		int saved_console_loglevel = console_loglevel;
+
+		pr_alert("UV: tracing %s for %d CPUs from CPU %d\n",
+			uv_nmi_action_is("ips") ? "IPs" : "processes",
+			atomic_read(&uv_nmi_cpus_in_nmi), cpu);
+
+		console_loglevel = uv_nmi_loglevel;
+		atomic_set(&uv_nmi_slave_continue, SLAVE_EXIT);
+		for_each_online_cpu(tcpu) {
+			if (cpumask_test_cpu(tcpu, uv_nmi_cpu_mask))
+				ignored++;
+			else if (tcpu == cpu)
+				uv_nmi_dump_state_cpu(tcpu, regs);
+			else
+				uv_nmi_trigger_dump(tcpu);
+		}
+		if (ignored)
+			printk(KERN_DEFAULT "UV: %d CPUs ignored NMI\n",
+				ignored);
+
+		console_loglevel = saved_console_loglevel;
+		pr_alert("UV: process trace complete\n");
+	} else {
+		while (!atomic_read(&uv_nmi_slave_continue))
+			cpu_relax();
+		while (atomic_read(&uv_cpu_nmi.state) != UV_NMI_STATE_DUMP)
+			cpu_relax();
+		uv_nmi_dump_state_cpu(cpu, regs);
+	}
+	uv_nmi_sync_exit(master);
+}
+
+static void uv_nmi_touch_watchdogs(void)
+{
+	touch_softlockup_watchdog_sync();
+	clocksource_touch_watchdog();
+	rcu_cpu_stall_reset();
+	touch_nmi_watchdog();
+}
+
+#if defined(CONFIG_KEXEC)
+static void uv_nmi_kdump(int cpu, int master, struct pt_regs *regs)
+{
+	/* Call crash to dump system state */
+	if (master) {
+		pr_emerg("UV: NMI executing crash_kexec on CPU%d\n", cpu);
+		crash_kexec(regs);
+
+		pr_emerg("UV: crash_kexec unexpectedly returned, ");
+		if (!kexec_crash_image) {
+			pr_cont("crash kernel not loaded\n");
+			atomic_set(&uv_nmi_kexec_failed, 1);
+			uv_nmi_sync_exit(1);
+			return;
+		}
+		pr_cont("kexec busy, stalling cpus while waiting\n");
+	}
+
+	/* If crash exec fails the slaves should return, otherwise stall */
+	while (atomic_read(&uv_nmi_kexec_failed) == 0)
+		mdelay(10);
+
+	/* Crash kernel most likely not loaded, return in an orderly fashion */
+	uv_nmi_sync_exit(0);
+}
+
+#else /* !CONFIG_KEXEC */
+static inline void uv_nmi_kdump(int cpu, int master, struct pt_regs *regs)
+{
+	if (master)
+		pr_err("UV: NMI kdump: KEXEC not supported in this kernel\n");
+}
+#endif /* !CONFIG_KEXEC */
+
+#ifdef CONFIG_KGDB_KDB
+/* Call KDB from NMI handler */
+static void uv_call_kdb(int cpu, struct pt_regs *regs, int master)
+{
+	int ret;
+
+	if (master) {
+		/* call KGDB NMI handler as MASTER */
+		ret = kgdb_nmicallin(cpu, X86_TRAP_NMI, regs,
+					&uv_nmi_slave_continue);
+		if (ret) {
+			pr_alert("KDB returned error, is kgdboc set?\n");
+			atomic_set(&uv_nmi_slave_continue, SLAVE_EXIT);
+		}
+	} else {
+		/* wait for KGDB signal that it's ready for slaves to enter */
+		int sig;
+
+		do {
+			cpu_relax();
+			sig = atomic_read(&uv_nmi_slave_continue);
+		} while (!sig);
+
+		/* call KGDB as slave */
+		if (sig == SLAVE_CONTINUE)
+			kgdb_nmicallback(cpu, regs);
+	}
+	uv_nmi_sync_exit(master);
+}
+
+#else /* !CONFIG_KGDB_KDB */
+static inline void uv_call_kdb(int cpu, struct pt_regs *regs, int master)
+{
+	pr_err("UV: NMI error: KGDB/KDB is not enabled in this kernel\n");
+}
+#endif /* !CONFIG_KGDB_KDB */
+
+/*
+ * UV NMI handler
+ */
+int uv_handle_nmi(unsigned int reason, struct pt_regs *regs)
+{
+	struct uv_hub_nmi_s *hub_nmi = uv_hub_nmi;
+	int cpu = smp_processor_id();
+	int master = 0;
+	unsigned long flags;
+
+	local_irq_save(flags);
+
+	/* If not a UV System NMI, ignore */
+	if (!atomic_read(&uv_cpu_nmi.pinging) && !uv_check_nmi(hub_nmi)) {
+		local_irq_restore(flags);
+		return NMI_DONE;
+	}
+
+	/* Indicate we are the first CPU into the NMI handler */
+	master = (atomic_read(&uv_nmi_cpu) == cpu);
+
+	/* If NMI action is "kdump", then attempt to do it */
+	if (uv_nmi_action_is("kdump"))
+		uv_nmi_kdump(cpu, master, regs);
+
+	/* Pause as all cpus enter the NMI handler */
+	uv_nmi_wait(master);
+
+	/* Dump state of each cpu */
+	if (uv_nmi_action_is("ips") || uv_nmi_action_is("dump"))
+		uv_nmi_dump_state(cpu, regs, master);
+
+	/* Call KDB if enabled */
+	else if (uv_nmi_action_is("kdb"))
+		uv_call_kdb(cpu, regs, master);
+
+	/* Clear per_cpu "in nmi" flag */
+	atomic_set(&uv_cpu_nmi.state, UV_NMI_STATE_OUT);
+
+	/* Clear MMR NMI flag on each hub */
+	uv_clear_nmi(cpu);
+
+	/* Clear global flags */
+	if (master) {
+		if (cpumask_weight(uv_nmi_cpu_mask))
+			uv_nmi_cleanup_mask();
+		atomic_set(&uv_nmi_cpus_in_nmi, -1);
+		atomic_set(&uv_nmi_cpu, -1);
+		atomic_set(&uv_in_nmi, 0);
+	}
+
+	uv_nmi_touch_watchdogs();
+	local_irq_restore(flags);
+
+	return NMI_HANDLED;
+}
+
+/*
+ * NMI handler for pulling in CPUs when perf events are grabbing our NMI
+ */
+int uv_handle_nmi_ping(unsigned int reason, struct pt_regs *regs)
+{
+	int ret;
+
+	uv_cpu_nmi.queries++;
+	if (!atomic_read(&uv_cpu_nmi.pinging)) {
+		local64_inc(&uv_nmi_ping_misses);
+		return NMI_DONE;
+	}
+
+	uv_cpu_nmi.pings++;
+	local64_inc(&uv_nmi_ping_count);
+	ret = uv_handle_nmi(reason, regs);
+	atomic_set(&uv_cpu_nmi.pinging, 0);
+	return ret;
+}
+
+void uv_register_nmi_notifier(void)
+{
+	if (register_nmi_handler(NMI_UNKNOWN, uv_handle_nmi, 0, "uv"))
+		pr_warn("UV: NMI handler failed to register\n");
+
+	if (register_nmi_handler(NMI_LOCAL, uv_handle_nmi_ping, 0, "uvping"))
+		pr_warn("UV: PING NMI handler failed to register\n");
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
+void uv_nmi_setup(void)
+{
+	int size = sizeof(void *) * (1 << NODES_SHIFT);
+	int cpu, nid;
+
+	/* Setup hub nmi info */
+	uv_nmi_setup_mmrs();
+	uv_hub_nmi_list = kzalloc(size, GFP_KERNEL);
+	pr_info("UV: NMI hub list @ 0x%p (%d)\n", uv_hub_nmi_list, size);
+	BUG_ON(!uv_hub_nmi_list);
+	size = sizeof(struct uv_hub_nmi_s);
+	for_each_present_cpu(cpu) {
+		nid = cpu_to_node(cpu);
+		if (uv_hub_nmi_list[nid] == NULL) {
+			uv_hub_nmi_list[nid] = kzalloc_node(size,
+							    GFP_KERNEL, nid);
+			BUG_ON(!uv_hub_nmi_list[nid]);
+			raw_spin_lock_init(&(uv_hub_nmi_list[nid]->nmi_lock));
+			atomic_set(&uv_hub_nmi_list[nid]->cpu_owner, -1);
+		}
+		uv_hub_nmi_per(cpu) = uv_hub_nmi_list[nid];
+	}
+	BUG_ON(!alloc_cpumask_var(&uv_nmi_cpu_mask, GFP_KERNEL));
+}
+
+
diff --git a/include/linux/kdb.h b/include/linux/kdb.h
index 7f6fe6e..290db12 100644
--- a/include/linux/kdb.h
+++ b/include/linux/kdb.h
@@ -109,6 +109,7 @@ typedef enum {
 	KDB_REASON_RECURSE,	/* Recursive entry to kdb;
 				 * regs probably valid */
 	KDB_REASON_SSTEP,	/* Single Step trap. - regs valid */
+	KDB_REASON_SYSTEM_NMI,	/* In NMI due to SYSTEM cmd; regs valid */
 } kdb_reason_t;
 
 extern int kdb_trap_printk;
diff --git a/include/linux/kgdb.h b/include/linux/kgdb.h
index c6e091b..dfb4f2f 100644
--- a/include/linux/kgdb.h
+++ b/include/linux/kgdb.h
@@ -310,6 +310,7 @@ extern int
 kgdb_handle_exception(int ex_vector, int signo, int err_code,
 		      struct pt_regs *regs);
 extern int kgdb_nmicallback(int cpu, void *regs);
+extern int kgdb_nmicallin(int cpu, int trapnr, void *regs, atomic_t *snd_rdy);
 extern void gdbstub_exit(int status);
 
 extern int			kgdb_single_step;
diff --git a/kernel/debug/debug_core.c b/kernel/debug/debug_core.c
index 0506d44..7d2f35e 100644
--- a/kernel/debug/debug_core.c
+++ b/kernel/debug/debug_core.c
@@ -575,8 +575,12 @@ return_normal:
 		raw_spin_lock(&dbg_slave_lock);
 
 #ifdef CONFIG_SMP
+	/* If send_ready set, slaves are already waiting */
+	if (ks->send_ready)
+		atomic_set(ks->send_ready, 1);
+
 	/* Signal the other CPUs to enter kgdb_wait() */
-	if ((!kgdb_single_step) && kgdb_do_roundup)
+	else if ((!kgdb_single_step) && kgdb_do_roundup)
 		kgdb_roundup_cpus(flags);
 #endif
 
@@ -678,11 +682,11 @@ kgdb_handle_exception(int evector, int signo, int ecode, struct pt_regs *regs)
 	if (arch_kgdb_ops.enable_nmi)
 		arch_kgdb_ops.enable_nmi(0);
 
+	memset(ks, 0, sizeof(struct kgdb_state));
 	ks->cpu			= raw_smp_processor_id();
 	ks->ex_vector		= evector;
 	ks->signo		= signo;
 	ks->err_code		= ecode;
-	ks->kgdb_usethreadid	= 0;
 	ks->linux_regs		= regs;
 
 	if (kgdb_reenter_check(ks))
@@ -732,6 +736,30 @@ int kgdb_nmicallback(int cpu, void *regs)
 	return 1;
 }
 
+int kgdb_nmicallin(int cpu, int trapnr, void *regs, atomic_t *send_ready)
+{
+#ifdef CONFIG_SMP
+	if (!kgdb_io_ready(0) || !send_ready)
+		return 1;
+
+	if (kgdb_info[cpu].enter_kgdb == 0) {
+		struct kgdb_state kgdb_var;
+		struct kgdb_state *ks = &kgdb_var;
+
+		memset(ks, 0, sizeof(struct kgdb_state));
+		ks->cpu			= cpu;
+		ks->ex_vector		= trapnr;
+		ks->signo		= SIGTRAP;
+		ks->err_code		= KGDB_KDB_REASON_SYSTEM_NMI;
+		ks->linux_regs		= regs;
+		ks->send_ready		= send_ready;
+		kgdb_cpu_enter(ks, regs, DCPU_WANT_MASTER);
+		return 0;
+	}
+#endif
+	return 1;
+}
+
 static void kgdb_console_write(struct console *co, const char *s,
    unsigned count)
 {
diff --git a/kernel/debug/debug_core.h b/kernel/debug/debug_core.h
index 2235967..572aa4f 100644
--- a/kernel/debug/debug_core.h
+++ b/kernel/debug/debug_core.h
@@ -26,6 +26,7 @@ struct kgdb_state {
 	unsigned long		threadid;
 	long			kgdb_usethreadid;
 	struct pt_regs		*linux_regs;
+	atomic_t		*send_ready;
 };
 
 /* Exception state values */
@@ -74,11 +75,13 @@ extern int kdb_stub(struct kgdb_state *ks);
 extern int kdb_parse(const char *cmdstr);
 extern int kdb_common_init_state(struct kgdb_state *ks);
 extern int kdb_common_deinit_state(void);
+#define KGDB_KDB_REASON_SYSTEM_NMI KDB_REASON_SYSTEM_NMI
 #else /* ! CONFIG_KGDB_KDB */
 static inline int kdb_stub(struct kgdb_state *ks)
 {
 	return DBG_PASS_EVENT;
 }
+#define KGDB_KDB_REASON_SYSTEM_NMI 0
 #endif /* CONFIG_KGDB_KDB */
 
 #endif /* _DEBUG_CORE_H_ */
diff --git a/kernel/debug/kdb/kdb_debugger.c b/kernel/debug/kdb/kdb_debugger.c
index 328d18e..8859ca3 100644
--- a/kernel/debug/kdb/kdb_debugger.c
+++ b/kernel/debug/kdb/kdb_debugger.c
@@ -69,7 +69,10 @@ int kdb_stub(struct kgdb_state *ks)
 	if (atomic_read(&kgdb_setting_breakpoint))
 		reason = KDB_REASON_KEYBOARD;
 
-	if (in_nmi())
+	if (ks->err_code == KDB_REASON_SYSTEM_NMI && ks->signo == SIGTRAP)
+		reason = KDB_REASON_SYSTEM_NMI;
+
+	else if (in_nmi())
 		reason = KDB_REASON_NMI;
 
 	for (i = 0, bp = kdb_breakpoints; i < KDB_MAXBPT; i++, bp++) {
diff --git a/kernel/debug/kdb/kdb_main.c b/kernel/debug/kdb/kdb_main.c
index 00eb8f7..0b097c8 100644
--- a/kernel/debug/kdb/kdb_main.c
+++ b/kernel/debug/kdb/kdb_main.c
@@ -1200,6 +1200,9 @@ static int kdb_local(kdb_reason_t reason, int error, struct pt_regs *regs,
 			   instruction_pointer(regs));
 		kdb_dumpregs(regs);
 		break;
+	case KDB_REASON_SYSTEM_NMI:
+		kdb_printf("due to System NonMaskable Interrupt\n");
+		break;
 	case KDB_REASON_NMI:
 		kdb_printf("due to NonMaskable Interrupt @ "
 			   kdb_machreg_fmt "\n",
