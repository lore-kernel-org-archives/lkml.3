Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932094AbbAWOYV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 09:24:21 -0500
Received: from mail-wg0-f50.google.com ([74.125.82.50]:42106 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932070AbbAWOYR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 09:24:17 -0500
From: Daniel Thompson <daniel.thompson@linaro.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Daniel Thompson <daniel.thompson@linaro.org>,
        Jason Cooper <jason@lakedaemon.net>,
        Russell King <linux@arm.linux.org.uk>,
        Will Deacon <will.deacon@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Stephen Boyd <sboyd@codeaurora.org>,
        John Stultz <john.stultz@linaro.org>,
        Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, patches@linaro.org,
        linaro-kernel@lists.linaro.org, Sumit Semwal <sumit.semwal@linaro.org>,
        Dirk Behme <dirk.behme@de.bosch.com>,
        Daniel Drake <drake@endlessm.com>,
        Dmitry Pervushin <dpervushin@gmail.com>,
        Tim Sander <tim@krieglstein.org>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
Subject: [PATCH 3.19-rc2 v15 6/8] x86/nmi: Use common printk functions
Date: Fri, 23 Jan 2015 14:22:30 +0000
Message-Id: <1422022952-31552-7-git-send-email-daniel.thompson@linaro.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1422022952-31552-1-git-send-email-daniel.thompson@linaro.org>
References: <1422022952-31552-1-git-send-email-daniel.thompson@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Much of the code sitting in arch/x86/kernel/apic/hw_nmi.c to support safe
all-cpu backtracing from NMI has been copied to printk.c to make it
accessible to other architectures.

Port the x86 NMI backtrace to the generic code.

Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org
---
 arch/x86/Kconfig              |  1 +
 arch/x86/kernel/apic/hw_nmi.c | 97 ++++---------------------------------------
 2 files changed, 8 insertions(+), 90 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index ba397bde7948..f36d3058968e 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -138,6 +138,7 @@ config X86
 	select HAVE_ACPI_APEI_NMI if ACPI
 	select ACPI_LEGACY_TABLES_LOOKUP if ACPI
 	select X86_FEATURE_NAMES if PROC_FS
+	select ARCH_WANT_NMI_PRINTK if X86_LOCAL_APIC
 
 config INSTRUCTION_DECODER
 	def_bool y
diff --git a/arch/x86/kernel/apic/hw_nmi.c b/arch/x86/kernel/apic/hw_nmi.c
index 6873ab925d00..e15c3131636e 100644
--- a/arch/x86/kernel/apic/hw_nmi.c
+++ b/arch/x86/kernel/apic/hw_nmi.c
@@ -32,56 +32,23 @@ u64 hw_nmi_get_sample_period(int watchdog_thresh)
 static DECLARE_BITMAP(backtrace_mask, NR_CPUS) __read_mostly;
 static cpumask_t printtrace_mask;
 
-#define NMI_BUF_SIZE		4096
-
-struct nmi_seq_buf {
-	unsigned char		buffer[NMI_BUF_SIZE];
-	struct seq_buf		seq;
-};
-
-/* Safe printing in NMI context */
-static DEFINE_PER_CPU(struct nmi_seq_buf, nmi_print_seq);
-
-/* "in progress" flag of arch_trigger_all_cpu_backtrace */
-static unsigned long backtrace_flag;
-
-static void print_seq_line(struct nmi_seq_buf *s, int start, int end)
-{
-	const char *buf = s->buffer + start;
-
-	printk("%.*s", (end - start) + 1, buf);
-}
-
 void arch_trigger_all_cpu_backtrace(bool include_self)
 {
-	struct nmi_seq_buf *s;
-	int len;
-	int cpu;
 	int i;
 	int this_cpu = get_cpu();
 
-	if (test_and_set_bit(0, &backtrace_flag)) {
+	if (0 != prepare_nmi_printk(to_cpumask(backtrace_mask))) {
 		/*
-		 * If there is already a trigger_all_cpu_backtrace() in progress
-		 * (backtrace_flag == 1), don't output double cpu dump infos.
+		 * If there is already an nmi printk sequence in
+		 * progress then just give up...
 		 */
 		put_cpu();
 		return;
 	}
 
-	cpumask_copy(to_cpumask(backtrace_mask), cpu_online_mask);
 	if (!include_self)
 		cpumask_clear_cpu(this_cpu, to_cpumask(backtrace_mask));
-
 	cpumask_copy(&printtrace_mask, to_cpumask(backtrace_mask));
-	/*
-	 * Set up per_cpu seq_buf buffers that the NMIs running on the other
-	 * CPUs will write to.
-	 */
-	for_each_cpu(cpu, to_cpumask(backtrace_mask)) {
-		s = &per_cpu(nmi_print_seq, cpu);
-		seq_buf_init(&s->seq, s->buffer, NMI_BUF_SIZE);
-	}
 
 	if (!cpumask_empty(to_cpumask(backtrace_mask))) {
 		pr_info("sending NMI to %s CPUs:\n",
@@ -97,73 +64,23 @@ void arch_trigger_all_cpu_backtrace(bool include_self)
 		touch_softlockup_watchdog();
 	}
 
-	/*
-	 * Now that all the NMIs have triggered, we can dump out their
-	 * back traces safely to the console.
-	 */
-	for_each_cpu(cpu, &printtrace_mask) {
-		int last_i = 0;
-
-		s = &per_cpu(nmi_print_seq, cpu);
-		len = seq_buf_used(&s->seq);
-		if (!len)
-			continue;
-
-		/* Print line by line. */
-		for (i = 0; i < len; i++) {
-			if (s->buffer[i] == '\n') {
-				print_seq_line(s, last_i, i);
-				last_i = i + 1;
-			}
-		}
-		/* Check if there was a partial line. */
-		if (last_i < len) {
-			print_seq_line(s, last_i, len - 1);
-			pr_cont("\n");
-		}
-	}
-
-	clear_bit(0, &backtrace_flag);
-	smp_mb__after_atomic();
+	complete_nmi_printk(&printtrace_mask);
 	put_cpu();
 }
 
-/*
- * It is not safe to call printk() directly from NMI handlers.
- * It may be fine if the NMI detected a lock up and we have no choice
- * but to do so, but doing a NMI on all other CPUs to get a back trace
- * can be done with a sysrq-l. We don't want that to lock up, which
- * can happen if the NMI interrupts a printk in progress.
- *
- * Instead, we redirect the vprintk() to this nmi_vprintk() that writes
- * the content into a per cpu seq_buf buffer. Then when the NMIs are
- * all done, we can safely dump the contents of the seq_buf to a printk()
- * from a non NMI context.
- */
-static int nmi_vprintk(const char *fmt, va_list args)
-{
-	struct nmi_seq_buf *s = this_cpu_ptr(&nmi_print_seq);
-	unsigned int len = seq_buf_used(&s->seq);
-
-	seq_buf_vprintf(&s->seq, fmt, args);
-	return seq_buf_used(&s->seq) - len;
-}
-
 static int
 arch_trigger_all_cpu_backtrace_handler(unsigned int cmd, struct pt_regs *regs)
 {
 	int cpu;
+	printk_func_t orig;
 
 	cpu = smp_processor_id();
 
 	if (cpumask_test_cpu(cpu, to_cpumask(backtrace_mask))) {
-		printk_func_t printk_func_save = this_cpu_read(printk_func);
-
-		/* Replace printk to write into the NMI seq */
-		this_cpu_write(printk_func, nmi_vprintk);
+		orig = this_cpu_begin_nmi_printk();
 		printk(KERN_WARNING "NMI backtrace for cpu %d\n", cpu);
 		show_regs(regs);
-		this_cpu_write(printk_func, printk_func_save);
+		this_cpu_end_nmi_printk(orig);
 
 		cpumask_clear_cpu(cpu, to_cpumask(backtrace_mask));
 		return NMI_HANDLED;
-- 
1.9.3

