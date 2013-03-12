Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755726Ab3CLTjN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 15:39:13 -0400
Received: from relay1.sgi.com ([192.48.179.29]:42458 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755607Ab3CLTi1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 15:38:27 -0400
Message-Id: <20130312193825.244350065@gulag1.americas.sgi.com>
References: <20130312193823.212544181@gulag1.americas.sgi.com>
User-Agent: quilt/0.46-1
Date: Tue, 12 Mar 2013 14:38:36 -0500
From: Mike Travis <travis@sgi.com>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: Dimitri Sivanich <sivanich@sgi.com>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        kgdb-bugreport@lists.sourceforge.net, x86@kernel.org,
        linux-kernel@vger.kernel.org, Russ Anderson <rja@sgi.com>,
        Alexander Gordeev <agordeev@redhat.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Steffen Persvold <sp@numascale.com>
Subject: [PATCH 13/14] x86/UV: Update UV support for external NMI signals
Content-Disposition: inline; filename=uv-update-nmi-support.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch updates the UV NMI handler for the external SMM
'POWER NMI' command.  This command sets a special flag in one
of the MMRs on each HUB and sends the NMI signal to all cpus
in the system.

The code has also been optimized to minimize reading of the MMRs as
much as possible, by using a per HUB atomic NMI flag.  Too high a
rate of reading MMRs not only disrupts the UV Hub's primary function
of directing NumaLink traffic, but can also cause problems.  And to
avoid excessive overhead when perf tools are causing millions of
NMIs per second (when running on a large number of CPUS), this
handler uses primarily the NMI_UNKNOWN notifier chain.

There is an exception where the NMI_LOCAL notifier chain is used.
When the perf tools are in use, it's possible that our NMI was
captured by some other NMI handler and then ignored.  We set a
per_cpu flag for those CPUs that ignored the initial NMI, and then
send them an IPI NMI signal.

There are also some new parameters introduced to alter and tune the
behavior of the NMI handler.  These parameters are not documented in
Documentation/kernel-parameters.txt as they are only useful to SGI
support personnel, and are not generally useful to system users.

Cc: Russ Anderson <rja@sgi.com>
Cc: Alexander Gordeev <agordeev@redhat.com>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Steffen Persvold <sp@numascale.com>
Reviewed-by: Dimitri Sivanich <sivanich@sgi.com>
Signed-off-by: Mike Travis <travis@sgi.com>
---
 arch/x86/include/asm/uv/uv_hub.h   |   57 +++
 arch/x86/include/asm/uv/uv_mmrs.h  |   31 +
 arch/x86/kernel/apic/x2apic_uv_x.c |    1 
 arch/x86/platform/uv/uv_nmi.c      |  600 ++++++++++++++++++++++++++++++++++---
 4 files changed, 648 insertions(+), 41 deletions(-)

--- linux.orig/arch/x86/include/asm/uv/uv_hub.h
+++ linux/arch/x86/include/asm/uv/uv_hub.h
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
@@ -576,6 +576,59 @@ static inline int uv_num_possible_blades
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
--- linux.orig/arch/x86/include/asm/uv/uv_mmrs.h
+++ linux/arch/x86/include/asm/uv/uv_mmrs.h
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
--- linux.orig/arch/x86/kernel/apic/x2apic_uv_x.c
+++ linux/arch/x86/kernel/apic/x2apic_uv_x.c
@@ -925,6 +925,7 @@ void __init uv_system_init(void)
 	map_mmr_high(max_pnode);
 	map_mmioh_high(min_pnode, max_pnode);
 
+	uv_nmi_setup();
 	uv_cpu_init();
 	uv_scir_register_cpu_notifier();
 	uv_register_nmi_notifier();
--- linux.orig/arch/x86/platform/uv/uv_nmi.c
+++ linux/arch/x86/platform/uv/uv_nmi.c
@@ -20,79 +20,574 @@
  */
 
 #include <linux/cpu.h>
+#include <linux/delay.h>
 #include <linux/module.h>
 #include <linux/nmi.h>
+#include <linux/sched.h>
+#include <linux/slab.h>
+
+#if defined(CONFIG_KEXEC)
+#include <linux/kexec.h>
+#endif
 
 #include <asm/apic.h>
+#include <asm/current.h>
+#include <asm/kdebug.h>
 #include <asm/uv/uv.h>
 #include <asm/uv/uv_hub.h>
 #include <asm/uv/uv_mmrs.h>
 
-/* BMC sets a bit this MMR non-zero before sending an NMI */
-#define UVH_NMI_MMR				UVH_SCRATCH5
-#define UVH_NMI_MMR_CLEAR			(UVH_NMI_MMR + 8)
-#define UV_NMI_PENDING_MASK			(1UL << 63)
-DEFINE_PER_CPU(unsigned long, cpu_last_nmi_count);
-static DEFINE_SPINLOCK(uv_nmi_lock);
-
 void (*uv_trace_func)(const char *f, const int l, const char *fmt, ...);
 EXPORT_SYMBOL(uv_trace_func);
 
 void (*uv_trace_nmi_func)(int cpu, struct pt_regs *regs, int ignored);
 EXPORT_SYMBOL(uv_trace_nmi_func);
 
+/*
+ * UV handler for NMI
+ *
+ * Handle system-wide NMI events generated by the global 'power nmi' command.
+ *
+ * Basic operation is to field the NMI interrupt on each cpu and wait
+ * until all cpus have arrived into the nmi handler.  If some cpus do not
+ * make it into the handler, try and force them in with the IPI(NMI) signal.
+ *
+ * We also have to lessen MMR accesses as much as possible as this disrupts
+ * the UV Hub's primary mission of directing NumaLink traffic.
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
+static cpumask_var_t uv_nmi_cpu_mask;
+
+static int param_get_atomic(char *buffer, const struct kernel_param *kp)
+{
+	return sprintf(buffer, "%d\n", atomic_read((atomic_t *)kp->arg));
+}
+
+static int param_set_atomic(const char *val, const struct kernel_param *kp)
+{
+	/* clear on any write */
+	atomic_set((atomic_t *)kp->arg, 0);
+	return 0;
+}
+
+static struct kernel_param_ops param_ops_atomic = {
+	.get = param_get_atomic,
+	.set = param_set_atomic,
+};
+#define param_check_atomic(name, p) __param_check(name, p, atomic_t)
+
+static atomic_t uv_nmi_count;
+module_param_named(nmi_count, uv_nmi_count, atomic, 0644);
+
+static atomic_t uv_nmi_misses;
+module_param_named(nmi_misses, uv_nmi_misses, atomic, 0644);
+
+static atomic_t uv_nmi_ping_count;
+module_param_named(ping_count, uv_nmi_ping_count, atomic, 0644);
+
+static atomic_t uv_nmi_ping_misses;
+module_param_named(ping_misses, uv_nmi_ping_misses, atomic, 0644);
+
+static int uv_nmi_loglevel = 1;
+module_param_named(dump_loglevel, uv_nmi_loglevel, int, 0644);
+
+static int uv_nmi_ips_only;
+module_param_named(dump_ips_only, uv_nmi_ips_only, int, 0644);
+
+static int uv_nmi_kdump_requested;
+module_param_named(nmi_does_kdump, uv_nmi_kdump_requested, int, 0644);
+
+static int uv_nmi_initial_delay = 100;
+module_param_named(initial_delay, uv_nmi_initial_delay, int, 0644);
+
+static int uv_nmi_slave_delay = 100;
+module_param_named(slave_delay, uv_nmi_slave_delay, int, 0644);
+
+static int uv_nmi_loop_delay = 100;
+module_param_named(loop_delay, uv_nmi_loop_delay, int, 0644);
+
+static int uv_nmi_wait_count = 100;
+module_param_named(wait_count, uv_nmi_wait_count, int, 0644);
+
+static int uv_nmi_retry_count = 500;
+module_param_named(retry_count, uv_nmi_retry_count, int, 0644);
+
+#if defined(CONFIG_KEXEC)
+static void uv_nmi_kdump(struct pt_regs *regs)
+{
+	if (!kexec_crash_image) {
+		pr_err("UV: NMI kdump error: crash kernel not loaded\n");
+		return;
+	}
+
+	/* Call crash to dump system state */
+	pr_err("UV: NMI executing kdump [crash_kexec] on CPU%d\n",
+		smp_processor_id());
+	crash_kexec(regs);
+
+	/* If the above call returned then something didn't work */
+	pr_err("UV: NMI kdump error: crash_kexec failed!\n");
+}
+
+#else /* !CONFIG_KEXEC */
+static inline void uv_nmi_kdump(struct pt_regs *regs)
+{
+	pr_err("UV: NMI kdump error: KEXEC not supported in this kernel\n");
+}
+
+#endif /* !CONFIG_KEXEC */
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
+		pr_info("UV: SMM NMI support: %s\n", UVH_NMI_MMRX_TYPE);
+	} else {
+		nmi_mmr = UVH_NMI_MMR;
+		nmi_mmr_clear = UVH_NMI_MMR_CLEAR;
+		nmi_mmr_pending = 1UL << UVH_NMI_MMR_SHIFT;
+		pr_info("UV: SMM NMI support: %s\n", UVH_NMI_MMR_TYPE);
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
 
 /*
- * When NMI is received, print a stack trace.
+ * If first cpu in on this hub, set hub_nmi "in_nmi" and "owner" values and
+ * return true.  If first cpu in on the system, set global "in_nmi" flag.
  */
-int uv_handle_nmi(unsigned int reason, struct pt_regs *regs)
+static int uv_set_in_nmi(int cpu, struct uv_hub_nmi_s *hub_nmi)
 {
-	unsigned long real_uv_nmi;
-	int bid;
+	int first = atomic_add_unless(&hub_nmi->in_nmi, 1, 1);
 
-	/*
-	 * Each blade has an MMR that indicates when an NMI has been sent
-	 * to cpus on the blade. If an NMI is detected, atomically
-	 * clear the MMR and update a per-blade NMI count used to
-	 * cause each cpu on the blade to notice a new NMI.
-	 */
-	bid = uv_numa_blade_id();
-	real_uv_nmi = (uv_read_local_mmr(UVH_NMI_MMR) & UV_NMI_PENDING_MASK);
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
+	atomic_inc(&uv_nmi_count);
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
+		/*
+		 * check system-wide uv_in_nmi flag
+		 * (this check because on large UV1000 systems, the NMI signal
+		 * may arrive before the BMC has set this hub's NMI flag in
+		 * the MMR.)
+		 */
+		if (!nmi) {
+			nmi = atomic_read(&uv_in_nmi);
+			if (nmi)
+				uv_set_in_nmi(cpu, hub_nmi);
+		}
+
+	} while (0);
+
+	if (!nmi)
+		atomic_inc(&uv_nmi_misses);
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
+	/* (can't use pr_* with variable fmt) */
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
 
-	if (unlikely(real_uv_nmi)) {
-		spin_lock(&uv_blade_info[bid].nmi_lock);
-		real_uv_nmi = (uv_read_local_mmr(UVH_NMI_MMR) &
-				UV_NMI_PENDING_MASK);
-		if (real_uv_nmi) {
-			uv_blade_info[bid].nmi_count++;
-			uv_write_local_mmr(UVH_NMI_MMR_CLEAR,
-						UV_NMI_PENDING_MASK);
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
+static int uv_nmi_wait_cpus(int cpu, int first)
+{
+	int i, j, k, n = num_online_cpus();
+	int last_k = 0, waiting = 0;
+
+	if (first) {
+		cpumask_copy(uv_nmi_cpu_mask, cpu_online_mask);
+		k = 0;
+	} else
+		k = n - cpumask_weight(uv_nmi_cpu_mask);
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
+		if (last_k != k) {	/* abort if none coming in */
+			last_k = k;
+			waiting = 0;
+		} else if (++waiting > uv_nmi_wait_count)
+			break;
+
+		/* extend delay if only waiting for cpu that sent the nmi */
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
+/* Wait until all cpus have entered NMI handler */
+static int uv_nmi_wait(int cpu)
+{
+	/* indicate this cpu is in */
+	atomic_set(&uv_cpu_nmi.state, UV_NMI_STATE_IN);
+
+	/* if we are not the first cpu in, we are a slave cpu */
+	if (atomic_read(&uv_nmi_cpu) != cpu)
+		return -1;
+
+	do {
+		/* wait for all other cpus to gather here */
+		if (!uv_nmi_wait_cpus(cpu, 1))
+			break;
+
+		/* if not all made it in, send IPI NMI to them */
+		uv_nmi_nr_cpus_pr(
+			"UV: Sending NMI IPI to %d non-responding CPUs: %s\n");
+		uv_nmi_nr_cpus_ping();
+
+		/* if some cpus are still not in, ignore them */
+		if (!uv_nmi_wait_cpus(cpu, 0))
+			break;
+
+		uv_nmi_nr_cpus_pr("UV: %d CPUs not in NMI loop: %s\n");
+	} while (0);
+
+	pr_err("UV: %d of %d CPUs in NMI\n",
+		atomic_read(&uv_nmi_cpus_in_nmi), num_online_cpus());
+
+	return cpu;
+}
+
+static void uv_nmi_dump_cpu_ip_hdr(void)
+{
+	printk("UV: NMI %4s %6s %16s  %16s   [PID 0 suppressed]\n",
+		"CPU", "PID", "COMMAND", "IP");
+}
+
+static void uv_nmi_dump_cpu_ip(int cpu, struct pt_regs *regs)
+{
+	printk("UV: NMI %4d %6d %-32.32s ",
+		cpu, current->pid, current->comm);
+
+	printk_address(regs->ip, 1);
+}
+
+/* Dump this cpu's state */
+static void uv_nmi_dump_state_cpu(int cpu, struct pt_regs *regs, int ignored)
+{
+	char *dots = " ................................. ";
+
+	/* call possible nmi trace function */
+	if (unlikely(uv_trace_nmi_func))
+		(uv_trace_nmi_func)(cpu, regs, ignored);
+
+	/* otherwise if dump has been requested */
+	else if (uv_nmi_loglevel) {
+		int saved_console_loglevel = console_loglevel;
+		console_loglevel = uv_nmi_loglevel;
+
+		if (uv_nmi_ips_only) {
+			if (cpu == 0)
+				uv_nmi_dump_cpu_ip_hdr();
+
+			if (ignored)
+				printk("UV: NMI %4d%signored NMI\n", cpu, dots);
+
+			else if (current->pid != 0)
+				uv_nmi_dump_cpu_ip(cpu, regs);
+
+		} else {
+			if (ignored) {
+				printk(
+				       "UV:%sNMI ignored on CPU %d\n",
+					dots, cpu);
+			} else {
+				printk("UV:%sNMI process trace for CPU %d\n",
+					dots, cpu);
+				show_regs(regs);
+			}
+		}
+		console_loglevel = saved_console_loglevel;
+	}
+	atomic_set(&uv_cpu_nmi.state, UV_NMI_STATE_DUMP_DONE);
+}
+
+/* Trigger a slave cpu to dump it's state */
+static void uv_nmi_trigger_dump(int cpu)
+{
+	int retry = 10000;
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
+	pr_err("UV: CPU %d stuck in process dump function\n", cpu);
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
+		atomic_set(&uv_nmi_slave_continue, 0);
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
+
+		pr_err("UV: tracing %s for %d CPUs from CPU %d\n",
+			uv_nmi_ips_only ? "IPs" : "processes",
+			atomic_read(&uv_nmi_cpus_in_nmi), cpu);
+
+		atomic_set(&uv_nmi_slave_continue, 2);
+		for_each_online_cpu(tcpu) {
+			if (cpumask_test_cpu(tcpu, uv_nmi_cpu_mask))
+				uv_nmi_dump_state_cpu(tcpu, regs, 1);
+			else if (tcpu == cpu)
+				uv_nmi_dump_state_cpu(tcpu, regs, 0);
+			else
+				uv_nmi_trigger_dump(tcpu);
 		}
-		spin_unlock(&uv_blade_info[bid].nmi_lock);
+		pr_err("UV: process trace complete\n");
+	} else {
+		while (!atomic_read(&uv_nmi_slave_continue))
+			cpu_relax();
+		while (atomic_read(&uv_cpu_nmi.state) != UV_NMI_STATE_DUMP)
+			cpu_relax();
+		uv_nmi_dump_state_cpu(cpu, regs, 0);
 	}
+	uv_nmi_sync_exit(master);
+}
 
-	if (likely(__get_cpu_var(cpu_last_nmi_count) ==
-			uv_blade_info[bid].nmi_count))
+static void uv_nmi_touch_watchdogs(void)
+{
+	touch_softlockup_watchdog_sync();
+	clocksource_touch_watchdog();
+	rcu_cpu_stall_reset();
+	touch_nmi_watchdog();
+}
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
+	/* If not a UV Global NMI, ignore */
+	if (!atomic_read(&uv_cpu_nmi.pinging) && !uv_check_nmi(hub_nmi)) {
+		local_irq_restore(flags);
 		return NMI_DONE;
+	}
 
-	__get_cpu_var(cpu_last_nmi_count) = uv_blade_info[bid].nmi_count;
+	/* Pause until all cpus are in NMI handler */
+	if (cpu == uv_nmi_wait(cpu))
+		master = 1;
+
+	/* If NMI kdump requested, attempt to do it */
+	if (master && uv_nmi_kdump_requested)
+		uv_nmi_kdump(regs);
+
+	/* Dump state of each cpu */
+	uv_nmi_dump_state(cpu, regs, master);
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
 
-	/*
-	 * Use a lock so only one cpu prints at a time.
-	 * This prevents intermixed output.
-	 */
-	spin_lock(&uv_nmi_lock);
-	pr_info("UV NMI stack dump cpu %u:\n", smp_processor_id());
-	dump_stack();
-	spin_unlock(&uv_nmi_lock);
+	uv_nmi_touch_watchdogs();
+	local_irq_restore(flags);
 
 	return NMI_HANDLED;
 }
 
+/*
+ * NMI handler for pulling in CPUs when perf events are grabbing our NMI
+ */
+int uv_handle_nmi_ping(unsigned int reason, struct pt_regs *regs)
+{
+	int ret;
+
+	uv_cpu_nmi.queries++;
+	if (!atomic_read(&uv_cpu_nmi.pinging)) {
+		atomic_inc(&uv_nmi_ping_misses);
+		return NMI_DONE;
+	}
+
+	uv_cpu_nmi.pings++;
+	atomic_inc(&uv_nmi_ping_count);
+	ret = uv_handle_nmi(reason, regs);
+	atomic_set(&uv_cpu_nmi.pinging, 0);
+	return ret;
+}
+
 void uv_register_nmi_notifier(void)
 {
 	if (register_nmi_handler(NMI_UNKNOWN, uv_handle_nmi, 0, "uv"))
 		pr_warn("UV NMI handler failed to register\n");
+
+	if (register_nmi_handler(NMI_LOCAL, uv_handle_nmi_ping, 0, "uvping"))
+		pr_warn("UV PING NMI handler failed to register\n");
 }
 
 void uv_nmi_init(void)
@@ -107,3 +602,30 @@ void uv_nmi_init(void)
 	apic_write(APIC_LVT1, value);
 }
 
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
+	alloc_cpumask_var(&uv_nmi_cpu_mask, GFP_KERNEL);
+	BUG_ON(!uv_nmi_cpu_mask);
+}
+
+

-- 
