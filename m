Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756102AbaLIKSc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 05:18:32 -0500
Received: from terminus.zytor.com ([198.137.202.10]:52356 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754932AbaLIKS3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 05:18:29 -0500
Date: Tue, 9 Dec 2014 02:18:15 -0800
From: tip-bot for Rasmus Villemoes <tipbot@zytor.com>
Message-ID: <tip-3736708f034ae1e8c62789ed737e8b90d5b40210@git.kernel.org>
Cc: mingo@kernel.org, tglx@linutronix.de, hpa@zytor.com,
        linux@rasmusvillemoes.dk, linux-kernel@vger.kernel.org
Reply-To: linux-kernel@vger.kernel.org, linux@rasmusvillemoes.dk,
        tglx@linutronix.de, hpa@zytor.com, mingo@kernel.org
In-Reply-To: <1417208622-12264-1-git-send-email-linux@rasmusvillemoes.dk>
References: <1417208622-12264-1-git-send-email-linux@rasmusvillemoes.dk>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/asm] x86: Replace seq_printf() with seq_puts()
Git-Commit-ID: 3736708f034ae1e8c62789ed737e8b90d5b40210
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3736708f034ae1e8c62789ed737e8b90d5b40210
Gitweb:     http://git.kernel.org/tip/3736708f034ae1e8c62789ed737e8b90d5b40210
Author:     Rasmus Villemoes <linux@rasmusvillemoes.dk>
AuthorDate: Fri, 28 Nov 2014 22:03:41 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Mon, 8 Dec 2014 11:48:15 +0100

x86: Replace seq_printf() with seq_puts()

seq_puts is a lot cheaper than seq_printf, so use that to print
literal strings.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Link: http://lkml.kernel.org/r/1417208622-12264-1-git-send-email-linux@rasmusvillemoes.dk
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/cpu/proc.c    | 10 +++++-----
 arch/x86/kernel/irq.c         | 30 +++++++++++++++---------------
 arch/x86/mm/pat.c             |  2 +-
 arch/x86/platform/uv/tlb_uv.c | 26 ++++++++++++--------------
 4 files changed, 33 insertions(+), 35 deletions(-)

diff --git a/arch/x86/kernel/cpu/proc.c b/arch/x86/kernel/cpu/proc.c
index 5433658..e7d8c76 100644
--- a/arch/x86/kernel/cpu/proc.c
+++ b/arch/x86/kernel/cpu/proc.c
@@ -72,7 +72,7 @@ static int show_cpuinfo(struct seq_file *m, void *v)
 	if (c->x86_mask || c->cpuid_level >= 0)
 		seq_printf(m, "stepping\t: %d\n", c->x86_mask);
 	else
-		seq_printf(m, "stepping\t: unknown\n");
+		seq_puts(m, "stepping\t: unknown\n");
 	if (c->microcode)
 		seq_printf(m, "microcode\t: 0x%x\n", c->microcode);
 
@@ -92,12 +92,12 @@ static int show_cpuinfo(struct seq_file *m, void *v)
 	show_cpuinfo_core(m, c, cpu);
 	show_cpuinfo_misc(m, c);
 
-	seq_printf(m, "flags\t\t:");
+	seq_puts(m, "flags\t\t:");
 	for (i = 0; i < 32*NCAPINTS; i++)
 		if (cpu_has(c, i) && x86_cap_flags[i] != NULL)
 			seq_printf(m, " %s", x86_cap_flags[i]);
 
-	seq_printf(m, "\nbugs\t\t:");
+	seq_puts(m, "\nbugs\t\t:");
 	for (i = 0; i < 32*NBUGINTS; i++) {
 		unsigned int bug_bit = 32*NCAPINTS + i;
 
@@ -118,7 +118,7 @@ static int show_cpuinfo(struct seq_file *m, void *v)
 	seq_printf(m, "address sizes\t: %u bits physical, %u bits virtual\n",
 		   c->x86_phys_bits, c->x86_virt_bits);
 
-	seq_printf(m, "power management:");
+	seq_puts(m, "power management:");
 	for (i = 0; i < 32; i++) {
 		if (c->x86_power & (1 << i)) {
 			if (i < ARRAY_SIZE(x86_power_flags) &&
@@ -131,7 +131,7 @@ static int show_cpuinfo(struct seq_file *m, void *v)
 		}
 	}
 
-	seq_printf(m, "\n\n");
+	seq_puts(m, "\n\n");
 
 	return 0;
 }
diff --git a/arch/x86/kernel/irq.c b/arch/x86/kernel/irq.c
index 922d285..6307a0f 100644
--- a/arch/x86/kernel/irq.c
+++ b/arch/x86/kernel/irq.c
@@ -59,78 +59,78 @@ int arch_show_interrupts(struct seq_file *p, int prec)
 	seq_printf(p, "%*s: ", prec, "NMI");
 	for_each_online_cpu(j)
 		seq_printf(p, "%10u ", irq_stats(j)->__nmi_count);
-	seq_printf(p, "  Non-maskable interrupts\n");
+	seq_puts(p, "  Non-maskable interrupts\n");
 #ifdef CONFIG_X86_LOCAL_APIC
 	seq_printf(p, "%*s: ", prec, "LOC");
 	for_each_online_cpu(j)
 		seq_printf(p, "%10u ", irq_stats(j)->apic_timer_irqs);
-	seq_printf(p, "  Local timer interrupts\n");
+	seq_puts(p, "  Local timer interrupts\n");
 
 	seq_printf(p, "%*s: ", prec, "SPU");
 	for_each_online_cpu(j)
 		seq_printf(p, "%10u ", irq_stats(j)->irq_spurious_count);
-	seq_printf(p, "  Spurious interrupts\n");
+	seq_puts(p, "  Spurious interrupts\n");
 	seq_printf(p, "%*s: ", prec, "PMI");
 	for_each_online_cpu(j)
 		seq_printf(p, "%10u ", irq_stats(j)->apic_perf_irqs);
-	seq_printf(p, "  Performance monitoring interrupts\n");
+	seq_puts(p, "  Performance monitoring interrupts\n");
 	seq_printf(p, "%*s: ", prec, "IWI");
 	for_each_online_cpu(j)
 		seq_printf(p, "%10u ", irq_stats(j)->apic_irq_work_irqs);
-	seq_printf(p, "  IRQ work interrupts\n");
+	seq_puts(p, "  IRQ work interrupts\n");
 	seq_printf(p, "%*s: ", prec, "RTR");
 	for_each_online_cpu(j)
 		seq_printf(p, "%10u ", irq_stats(j)->icr_read_retry_count);
-	seq_printf(p, "  APIC ICR read retries\n");
+	seq_puts(p, "  APIC ICR read retries\n");
 #endif
 	if (x86_platform_ipi_callback) {
 		seq_printf(p, "%*s: ", prec, "PLT");
 		for_each_online_cpu(j)
 			seq_printf(p, "%10u ", irq_stats(j)->x86_platform_ipis);
-		seq_printf(p, "  Platform interrupts\n");
+		seq_puts(p, "  Platform interrupts\n");
 	}
 #ifdef CONFIG_SMP
 	seq_printf(p, "%*s: ", prec, "RES");
 	for_each_online_cpu(j)
 		seq_printf(p, "%10u ", irq_stats(j)->irq_resched_count);
-	seq_printf(p, "  Rescheduling interrupts\n");
+	seq_puts(p, "  Rescheduling interrupts\n");
 	seq_printf(p, "%*s: ", prec, "CAL");
 	for_each_online_cpu(j)
 		seq_printf(p, "%10u ", irq_stats(j)->irq_call_count -
 					irq_stats(j)->irq_tlb_count);
-	seq_printf(p, "  Function call interrupts\n");
+	seq_puts(p, "  Function call interrupts\n");
 	seq_printf(p, "%*s: ", prec, "TLB");
 	for_each_online_cpu(j)
 		seq_printf(p, "%10u ", irq_stats(j)->irq_tlb_count);
-	seq_printf(p, "  TLB shootdowns\n");
+	seq_puts(p, "  TLB shootdowns\n");
 #endif
 #ifdef CONFIG_X86_THERMAL_VECTOR
 	seq_printf(p, "%*s: ", prec, "TRM");
 	for_each_online_cpu(j)
 		seq_printf(p, "%10u ", irq_stats(j)->irq_thermal_count);
-	seq_printf(p, "  Thermal event interrupts\n");
+	seq_puts(p, "  Thermal event interrupts\n");
 #endif
 #ifdef CONFIG_X86_MCE_THRESHOLD
 	seq_printf(p, "%*s: ", prec, "THR");
 	for_each_online_cpu(j)
 		seq_printf(p, "%10u ", irq_stats(j)->irq_threshold_count);
-	seq_printf(p, "  Threshold APIC interrupts\n");
+	seq_puts(p, "  Threshold APIC interrupts\n");
 #endif
 #ifdef CONFIG_X86_MCE
 	seq_printf(p, "%*s: ", prec, "MCE");
 	for_each_online_cpu(j)
 		seq_printf(p, "%10u ", per_cpu(mce_exception_count, j));
-	seq_printf(p, "  Machine check exceptions\n");
+	seq_puts(p, "  Machine check exceptions\n");
 	seq_printf(p, "%*s: ", prec, "MCP");
 	for_each_online_cpu(j)
 		seq_printf(p, "%10u ", per_cpu(mce_poll_count, j));
-	seq_printf(p, "  Machine check polls\n");
+	seq_puts(p, "  Machine check polls\n");
 #endif
 #if IS_ENABLED(CONFIG_HYPERV) || defined(CONFIG_XEN)
 	seq_printf(p, "%*s: ", prec, "THR");
 	for_each_online_cpu(j)
 		seq_printf(p, "%10u ", irq_stats(j)->irq_hv_callback_count);
-	seq_printf(p, "  Hypervisor callback interrupts\n");
+	seq_puts(p, "  Hypervisor callback interrupts\n");
 #endif
 	seq_printf(p, "%*s: %10u\n", prec, "ERR", atomic_read(&irq_err_count));
 #if defined(CONFIG_X86_IO_APIC)
diff --git a/arch/x86/mm/pat.c b/arch/x86/mm/pat.c
index 6574388..c7eddbe 100644
--- a/arch/x86/mm/pat.c
+++ b/arch/x86/mm/pat.c
@@ -824,7 +824,7 @@ static void *memtype_seq_start(struct seq_file *seq, loff_t *pos)
 {
 	if (*pos == 0) {
 		++*pos;
-		seq_printf(seq, "PAT memtype list:\n");
+		seq_puts(seq, "PAT memtype list:\n");
 	}
 
 	return memtype_get_idx(*pos);
diff --git a/arch/x86/platform/uv/tlb_uv.c b/arch/x86/platform/uv/tlb_uv.c
index 3968d67..ab4062c 100644
--- a/arch/x86/platform/uv/tlb_uv.c
+++ b/arch/x86/platform/uv/tlb_uv.c
@@ -1367,20 +1367,18 @@ static int ptc_seq_show(struct seq_file *file, void *data)
 
 	cpu = *(loff_t *)data;
 	if (!cpu) {
-		seq_printf(file,
-		 "# cpu bauoff sent stime self locals remotes ncpus localhub ");
-		seq_printf(file,
-			"remotehub numuvhubs numuvhubs16 numuvhubs8 ");
-		seq_printf(file,
-			"numuvhubs4 numuvhubs2 numuvhubs1 dto snacks retries ");
-		seq_printf(file,
-			"rok resetp resett giveup sto bz throt disable ");
-		seq_printf(file,
-			"enable wars warshw warwaits enters ipidis plugged ");
-		seq_printf(file,
-			"ipiover glim cong swack recv rtime all one mult ");
-		seq_printf(file,
-			"none retry canc nocan reset rcan\n");
+		seq_puts(file,
+			 "# cpu bauoff sent stime self locals remotes ncpus localhub ");
+		seq_puts(file, "remotehub numuvhubs numuvhubs16 numuvhubs8 ");
+		seq_puts(file,
+			 "numuvhubs4 numuvhubs2 numuvhubs1 dto snacks retries ");
+		seq_puts(file,
+			 "rok resetp resett giveup sto bz throt disable ");
+		seq_puts(file,
+			 "enable wars warshw warwaits enters ipidis plugged ");
+		seq_puts(file,
+			 "ipiover glim cong swack recv rtime all one mult ");
+		seq_puts(file, "none retry canc nocan reset rcan\n");
 	}
 	if (cpu < num_possible_cpus() && cpu_online(cpu)) {
 		bcp = &per_cpu(bau_control, cpu);
