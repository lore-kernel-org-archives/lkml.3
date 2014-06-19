Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966292AbaFSVj7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 17:39:59 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:59725 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S965603AbaFSVjz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 17:39:55 -0400
Message-Id: <20140619213952.360076309@goodmis.org>
User-Agent: quilt/0.63-1
Date: Thu, 19 Jun 2014 17:33:32 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Kosina <jkosina@suse.cz>, Michal Hocko <mhocko@suse.cz>,
        Jan Kara <jack@suse.cz>, Frederic Weisbecker <fweisbec@gmail.com>,
        Dave Anderson <anderson@redhat.com>, Petr Mladek <pmladek@suse.cz>
Subject: [RFC][PATCH 3/3] x86/nmi: Perform a safe NMI stack trace on all CPUs
References: <20140619213329.478113470@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=0003-x86-nmi-Perform-a-safe-NMI-stack-trace-on-all-CPUs.patch
X-RR-Connecting-IP: 107.14.168.130:25
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
printk in a per_cpu trace_seq descriptor. After all NMIs have finished
recording its data, the trace_seqs are printed in a safe context.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86/kernel/apic/hw_nmi.c | 66 ++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 62 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/apic/hw_nmi.c b/arch/x86/kernel/apic/hw_nmi.c
index c3fcb5de5083..6731604bb1cd 100644
--- a/arch/x86/kernel/apic/hw_nmi.c
+++ b/arch/x86/kernel/apic/hw_nmi.c
@@ -18,6 +18,7 @@
 #include <linux/nmi.h>
 #include <linux/module.h>
 #include <linux/delay.h>
+#include <linux/trace_seq.h>
 
 #ifdef CONFIG_HARDLOCKUP_DETECTOR
 u64 hw_nmi_get_sample_period(int watchdog_thresh)
@@ -30,11 +31,30 @@ u64 hw_nmi_get_sample_period(int watchdog_thresh)
 /* For reliability, we're prepared to waste bits here. */
 static DECLARE_BITMAP(backtrace_mask, NR_CPUS) __read_mostly;
 
+/* Safe printing in NMI context */
+static DEFINE_PER_CPU(struct trace_seq, nmi_print_seq);
+
 /* "in progress" flag of arch_trigger_all_cpu_backtrace */
 static unsigned long backtrace_flag;
 
+static void print_seq_line(struct trace_seq *s, int last, int pos)
+{
+	const char *buf = s->buffer + last;
+
+	/* Chop off the saved log level and update the length */
+	if (printk_get_level(buf)) {
+		buf += 2;
+		last += 2;
+	}
+
+	pr_emerg("%.*s", (pos - last) + 1, buf);
+}
+
 void arch_trigger_all_cpu_backtrace(void)
 {
+	struct trace_seq *s;
+	int len;
+	int cpu;
 	int i;
 
 	if (test_and_set_bit(0, &backtrace_flag))
@@ -44,6 +64,11 @@ void arch_trigger_all_cpu_backtrace(void)
 		 */
 		return;
 
+	for_each_possible_cpu(i) {
+		s = &per_cpu(nmi_print_seq, i);
+		trace_seq_init(s);
+	}
+
 	cpumask_copy(to_cpumask(backtrace_mask), cpu_online_mask);
 
 	printk(KERN_INFO "sending NMI to all CPUs:\n");
@@ -56,8 +81,39 @@ void arch_trigger_all_cpu_backtrace(void)
 		mdelay(1);
 	}
 
+	for_each_possible_cpu(cpu) {
+		int last_i = 0;
+
+		s = &per_cpu(nmi_print_seq, cpu);
+		len = s->len;
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
+	return true;
+}
+
+static int nmi_vprintk(const char *fmt, va_list args)
+{
+	struct trace_seq *s = this_cpu_ptr(&nmi_print_seq);
+	int len = s->len;
+
+	trace_seq_vprintf(s, fmt, args);
+	return s->len - len;
 }
 
 static int
@@ -68,12 +124,14 @@ arch_trigger_all_cpu_backtrace_handler(unsigned int cmd, struct pt_regs *regs)
 	cpu = smp_processor_id();
 
 	if (cpumask_test_cpu(cpu, to_cpumask(backtrace_mask))) {
-		static arch_spinlock_t lock = __ARCH_SPIN_LOCK_UNLOCKED;
+		printk_func_t printk_func_save = this_cpu_read(printk_func);
 
-		arch_spin_lock(&lock);
-		printk(KERN_WARNING "NMI backtrace for cpu %d\n", cpu);
+		/* Replace printk to write into the NMI seq */
+		this_cpu_write(printk_func, nmi_vprintk);
+		printk("NMI backtrace for cpu %d\n", cpu);
 		show_regs(regs);
-		arch_spin_unlock(&lock);
+		this_cpu_write(printk_func, printk_func_save);
+
 		cpumask_clear_cpu(cpu, to_cpumask(backtrace_mask));
 		return NMI_HANDLED;
 	}
-- 
2.0.0.rc2


