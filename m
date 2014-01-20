Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752838AbaATPN6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 10:13:58 -0500
Received: from mail-ea0-f179.google.com ([209.85.215.179]:35033 "EHLO
	mail-ea0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750721AbaATPNz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 10:13:55 -0500
Date: Mon, 20 Jan 2014 16:13:52 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86 leftover fixes for v3.14
Message-ID: <20140120151352.GA16139@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-urgent-for-linus

   # HEAD: da6139e49c7cb0f4251265cb5243b8d220adb48d x86: Add check for number of available vectors before CPU down

Two leftover fixes that did not make it into v3.13.

 Thanks,

	Ingo

------------------>
Borislav Petkov (1):
      x86, cpu, amd: Add workaround for family 16h, erratum 793

Prarit Bhargava (1):
      x86: Add check for number of available vectors before CPU down


 arch/x86/include/asm/irq.h            |  1 +
 arch/x86/include/uapi/asm/msr-index.h |  1 +
 arch/x86/kernel/cpu/amd.c             | 10 +++++
 arch/x86/kernel/irq.c                 | 70 +++++++++++++++++++++++++++++++++++
 arch/x86/kernel/smpboot.c             |  6 +++
 5 files changed, 88 insertions(+)

diff --git a/arch/x86/include/asm/irq.h b/arch/x86/include/asm/irq.h
index 0ea10f27..cb6cfcd 100644
--- a/arch/x86/include/asm/irq.h
+++ b/arch/x86/include/asm/irq.h
@@ -25,6 +25,7 @@ extern void irq_ctx_init(int cpu);
 
 #ifdef CONFIG_HOTPLUG_CPU
 #include <linux/cpumask.h>
+extern int check_irq_vectors_for_cpu_disable(void);
 extern void fixup_irqs(void);
 extern void irq_force_complete_move(int);
 #endif
diff --git a/arch/x86/include/uapi/asm/msr-index.h b/arch/x86/include/uapi/asm/msr-index.h
index 37813b5..59cea18 100644
--- a/arch/x86/include/uapi/asm/msr-index.h
+++ b/arch/x86/include/uapi/asm/msr-index.h
@@ -184,6 +184,7 @@
 #define MSR_AMD64_PATCH_LOADER		0xc0010020
 #define MSR_AMD64_OSVW_ID_LENGTH	0xc0010140
 #define MSR_AMD64_OSVW_STATUS		0xc0010141
+#define MSR_AMD64_LS_CFG		0xc0011020
 #define MSR_AMD64_DC_CFG		0xc0011022
 #define MSR_AMD64_BU_CFG2		0xc001102a
 #define MSR_AMD64_IBSFETCHCTL		0xc0011030
diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index bca023b..59bfebc 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -508,6 +508,16 @@ static void early_init_amd(struct cpuinfo_x86 *c)
 			set_cpu_cap(c, X86_FEATURE_EXTD_APICID);
 	}
 #endif
+
+	/* F16h erratum 793, CVE-2013-6885 */
+	if (c->x86 == 0x16 && c->x86_model <= 0xf) {
+		u64 val;
+
+		rdmsrl(MSR_AMD64_LS_CFG, val);
+		if (!(val & BIT(15)))
+			wrmsrl(MSR_AMD64_LS_CFG, val | BIT(15));
+	}
+
 }
 
 static const int amd_erratum_383[];
diff --git a/arch/x86/kernel/irq.c b/arch/x86/kernel/irq.c
index 22d0687..4207e8d 100644
--- a/arch/x86/kernel/irq.c
+++ b/arch/x86/kernel/irq.c
@@ -262,6 +262,76 @@ __visible void smp_trace_x86_platform_ipi(struct pt_regs *regs)
 EXPORT_SYMBOL_GPL(vector_used_by_percpu_irq);
 
 #ifdef CONFIG_HOTPLUG_CPU
+/*
+ * This cpu is going to be removed and its vectors migrated to the remaining
+ * online cpus.  Check to see if there are enough vectors in the remaining cpus.
+ * This function is protected by stop_machine().
+ */
+int check_irq_vectors_for_cpu_disable(void)
+{
+	int irq, cpu;
+	unsigned int this_cpu, vector, this_count, count;
+	struct irq_desc *desc;
+	struct irq_data *data;
+	struct cpumask affinity_new, online_new;
+
+	this_cpu = smp_processor_id();
+	cpumask_copy(&online_new, cpu_online_mask);
+	cpu_clear(this_cpu, online_new);
+
+	this_count = 0;
+	for (vector = FIRST_EXTERNAL_VECTOR; vector < NR_VECTORS; vector++) {
+		irq = __this_cpu_read(vector_irq[vector]);
+		if (irq >= 0) {
+			desc = irq_to_desc(irq);
+			data = irq_desc_get_irq_data(desc);
+			cpumask_copy(&affinity_new, data->affinity);
+			cpu_clear(this_cpu, affinity_new);
+
+			/* Do not count inactive or per-cpu irqs. */
+			if (!irq_has_action(irq) || irqd_is_per_cpu(data))
+				continue;
+
+			/*
+			 * A single irq may be mapped to multiple
+			 * cpu's vector_irq[] (for example IOAPIC cluster
+			 * mode).  In this case we have two
+			 * possibilities:
+			 *
+			 * 1) the resulting affinity mask is empty; that is
+			 * this the down'd cpu is the last cpu in the irq's
+			 * affinity mask, or
+			 *
+			 * 2) the resulting affinity mask is no longer
+			 * a subset of the online cpus but the affinity
+			 * mask is not zero; that is the down'd cpu is the
+			 * last online cpu in a user set affinity mask.
+			 */
+			if (cpumask_empty(&affinity_new) ||
+			    !cpumask_subset(&affinity_new, &online_new))
+				this_count++;
+		}
+	}
+
+	count = 0;
+	for_each_online_cpu(cpu) {
+		if (cpu == this_cpu)
+			continue;
+		for (vector = FIRST_EXTERNAL_VECTOR; vector < NR_VECTORS;
+		     vector++) {
+			if (per_cpu(vector_irq, cpu)[vector] < 0)
+				count++;
+		}
+	}
+
+	if (count < this_count) {
+		pr_warn("CPU %d disable failed: CPU has %u vectors assigned and there are only %u available.\n",
+			this_cpu, this_count, count);
+		return -ERANGE;
+	}
+	return 0;
+}
+
 /* A cpu has been removed from cpu_online_mask.  Reset irq affinities. */
 void fixup_irqs(void)
 {
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 85dc05a..391ea52 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -1312,6 +1312,12 @@ void cpu_disable_common(void)
 
 int native_cpu_disable(void)
 {
+	int ret;
+
+	ret = check_irq_vectors_for_cpu_disable();
+	if (ret)
+		return ret;
+
 	clear_local_APIC();
 
 	cpu_disable_common();
