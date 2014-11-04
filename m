Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754722AbaKDQCs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 11:02:48 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.230]:24663 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754661AbaKDQCb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 11:02:31 -0500
Message-Id: <20141104160223.310714394@goodmis.org>
User-Agent: quilt/0.61-1
Date: Tue, 04 Nov 2014 10:52:49 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Jiri Kosina <jkosina@suse.cz>, Petr Mladek <pmladek@suse.cz>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [RFC][PATCH 12/12 v3] x86/nmi: Perform a safe NMI stack trace on all CPUs
References: <20141104155237.228431433@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=0012-x86-nmi-Perform-a-safe-NMI-stack-trace-on-all-CPUs.patch
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

When trigger_all_cpu_backtrace() is called on x86, it will trigger an
NMI on each CPU and call show_regs(). But this can lead to a hard lock
up if the NMI comes in on another printk().

In order to avoid this, when the NMI triggers, it switches the printk
routine for that CPU to call a NMI safe printk function that records the
printk in a per_cpu seq_buf descriptor. After all NMIs have finished
recording its data, the trace_seqs are printed in a safe context.

Link: http://lkml.kernel.org/p/20140619213952.360076309@goodmis.org

Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86/kernel/apic/hw_nmi.c | 90 ++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 85 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/apic/hw_nmi.c b/arch/x86/kernel/apic/hw_nmi.c
index 6a1e71bde323..6e7bb0bc6fcd 100644
--- a/arch/x86/kernel/apic/hw_nmi.c
+++ b/arch/x86/kernel/apic/hw_nmi.c
@@ -18,6 +18,7 @@
 #include <linux/nmi.h>
 #include <linux/module.h>
 #include <linux/delay.h>
+#include <linux/seq_buf.h>
 
 #ifdef CONFIG_HARDLOCKUP_DETECTOR
 u64 hw_nmi_get_sample_period(int watchdog_thresh)
@@ -29,14 +30,35 @@ u64 hw_nmi_get_sample_period(int watchdog_thresh)
 #ifdef arch_trigger_all_cpu_backtrace
 /* For reliability, we're prepared to waste bits here. */
 static DECLARE_BITMAP(backtrace_mask, NR_CPUS) __read_mostly;
+static cpumask_var_t printtrace_mask;
+
+#define NMI_BUF_SIZE		4096
+
+struct nmi_seq_buf {
+	unsigned char		buffer[NMI_BUF_SIZE];
+	struct seq_buf		seq;
+};
+
+/* Safe printing in NMI context */
+static DEFINE_PER_CPU(struct nmi_seq_buf, nmi_print_seq);
 
 /* "in progress" flag of arch_trigger_all_cpu_backtrace */
 static unsigned long backtrace_flag;
 
+static void print_seq_line(struct nmi_seq_buf *s, int last, int pos)
+{
+	const char *buf = s->buffer + last;
+
+	printk("%.*s", (pos - last) + 1, buf);
+}
+
 void arch_trigger_all_cpu_backtrace(bool include_self)
 {
+	struct nmi_seq_buf *s;
+	int len;
+	int cpu;
 	int i;
-	int cpu = get_cpu();
+	int this_cpu = get_cpu();
 
 	if (test_and_set_bit(0, &backtrace_flag)) {
 		/*
@@ -49,7 +71,17 @@ void arch_trigger_all_cpu_backtrace(bool include_self)
 
 	cpumask_copy(to_cpumask(backtrace_mask), cpu_online_mask);
 	if (!include_self)
-		cpumask_clear_cpu(cpu, to_cpumask(backtrace_mask));
+		cpumask_clear_cpu(this_cpu, to_cpumask(backtrace_mask));
+
+	cpumask_copy(printtrace_mask, to_cpumask(backtrace_mask));
+	/*
+	 * Set up per_cpu seq_buf buffers that the NMIs running on the other
+	 * CPUs will write to.
+	 */
+	for_each_cpu(cpu, to_cpumask(backtrace_mask)) {
+		s = &per_cpu(nmi_print_seq, cpu);
+		seq_buf_init(&s->seq, s->buffer, NMI_BUF_SIZE);
+	}
 
 	if (!cpumask_empty(to_cpumask(backtrace_mask))) {
 		pr_info("sending NMI to %s CPUs:\n",
@@ -65,11 +97,57 @@ void arch_trigger_all_cpu_backtrace(bool include_self)
 		touch_softlockup_watchdog();
 	}
 
+	/*
+	 * Now that all the NMIs have triggered, we can dump out their
+	 * back traces safely to the console.
+	 */
+	for_each_cpu(cpu, printtrace_mask) {
+		int last_i = 0;
+
+		s = &per_cpu(nmi_print_seq, cpu);
+		len = s->seq.len;
+		if (!len)
+			continue;
+
+		/* Print line by line. */
+		for (i = 0; i < len; i++) {
+			if (s->buffer[i] == '\n') {
+				print_seq_line(s, last_i, i);
+				last_i = i + 1;
+			}
+		}
+		if (last_i < i - 1) {
+			print_seq_line(s, last_i, i);
+			pr_cont("\n");
+		}
+	}
+
 	clear_bit(0, &backtrace_flag);
 	smp_mb__after_atomic();
 	put_cpu();
 }
 
+/*
+ * It is not safe to call printk() directly from NMI handlers.
+ * It may be fine if the NMI detected a lock up and we have no choice
+ * but to do so, but doing a NMI on all other CPUs to get a back trace
+ * can be done with a sysrq-l. We don't want that to lock up, which
+ * can happen if the NMI interrupts a printk in progress.
+ *
+ * Instead, we redirect the vprintk() to this nmi_vprintk() that writes
+ * the content into a per cpu seq_buf buffer. Then when the NMIs are
+ * all done, we can safely dump the contents of the seq_buf to a printk()
+ * from a non NMI context.
+ */
+static int nmi_vprintk(const char *fmt, va_list args)
+{
+	struct nmi_seq_buf *s = this_cpu_ptr(&nmi_print_seq);
+	unsigned int len = s->seq.len;
+
+	seq_buf_vprintf(&s->seq, fmt, args);
+	return s->seq.len - len;
+}
+
 static int
 arch_trigger_all_cpu_backtrace_handler(unsigned int cmd, struct pt_regs *regs)
 {
@@ -78,12 +156,14 @@ arch_trigger_all_cpu_backtrace_handler(unsigned int cmd, struct pt_regs *regs)
 	cpu = smp_processor_id();
 
 	if (cpumask_test_cpu(cpu, to_cpumask(backtrace_mask))) {
-		static arch_spinlock_t lock = __ARCH_SPIN_LOCK_UNLOCKED;
+		printk_func_t printk_func_save = this_cpu_read(printk_func);
 
-		arch_spin_lock(&lock);
+		/* Replace printk to write into the NMI seq */
+		this_cpu_write(printk_func, nmi_vprintk);
 		printk(KERN_WARNING "NMI backtrace for cpu %d\n", cpu);
 		show_regs(regs);
-		arch_spin_unlock(&lock);
+		this_cpu_write(printk_func, printk_func_save);
+
 		cpumask_clear_cpu(cpu, to_cpumask(backtrace_mask));
 		return NMI_HANDLED;
 	}
-- 
2.1.1


