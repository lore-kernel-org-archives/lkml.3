Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755677AbbAWO0B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 09:26:01 -0500
Received: from mail-wg0-f48.google.com ([74.125.82.48]:38819 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755482AbbAWOYP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 09:24:15 -0500
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
        Tim Sander <tim@krieglstein.org>
Subject: [PATCH 3.19-rc2 v15 5/8] printk: Simple implementation for NMI backtracing
Date: Fri, 23 Jan 2015 14:22:29 +0000
Message-Id: <1422022952-31552-6-git-send-email-daniel.thompson@linaro.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1422022952-31552-1-git-send-email-daniel.thompson@linaro.org>
References: <1422022952-31552-1-git-send-email-daniel.thompson@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently there is a quite a pile of code sitting in
arch/x86/kernel/apic/hw_nmi.c to support safe all-cpu backtracing from NMI.
The code is inaccessible to backtrace implementations for other
architectures, which is a shame because they would probably like to be
safe too.

Copy this code into printk. We'll port the x86 NMI backtrace to it in a
later patch.

Incidentally, technically I think it might be safe to call
prepare_nmi_printk() from NMI, providing care were taken to honour the
return code. complete_nmi_printk() cannot be called from NMI but could
be scheduled using irq_work_queue(). However honouring the return code
means sometimes it is impossible to get the message out so I'd say using
this code in such a way should probably attract sympathy and/or derision
rather than admiration.

Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
---
 arch/Kconfig           |   3 ++
 include/linux/printk.h |  22 +++++++++
 kernel/printk/printk.c | 122 +++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 147 insertions(+)

diff --git a/arch/Kconfig b/arch/Kconfig
index 05d7a8a458d5..50c9412a77d0 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -309,6 +309,9 @@ config ARCH_WANT_OLD_COMPAT_IPC
 	select ARCH_WANT_COMPAT_IPC_PARSE_VERSION
 	bool
 
+config ARCH_WANT_NMI_PRINTK
+	bool
+
 config HAVE_ARCH_SECCOMP_FILTER
 	bool
 	help
diff --git a/include/linux/printk.h b/include/linux/printk.h
index c8f170324e64..188fdc2c1efd 100644
--- a/include/linux/printk.h
+++ b/include/linux/printk.h
@@ -219,6 +219,28 @@ static inline void show_regs_print_info(const char *log_lvl)
 }
 #endif
 
+#ifdef CONFIG_ARCH_WANT_NMI_PRINTK
+extern __printf(1, 0) int nmi_vprintk(const char *fmt, va_list args);
+
+struct cpumask;
+extern int prepare_nmi_printk(struct cpumask *cpus);
+extern void complete_nmi_printk(struct cpumask *cpus);
+
+/*
+ * Replace printk to write into the NMI seq.
+ *
+ * To avoid include hell this is a macro rather than an inline function
+ * (printk_func is not declared in this header file).
+ */
+#define this_cpu_begin_nmi_printk() ({ \
+	printk_func_t __orig = this_cpu_read(printk_func); \
+	this_cpu_write(printk_func, nmi_vprintk); \
+	__orig; \
+})
+#define this_cpu_end_nmi_printk(fn) this_cpu_write(printk_func, fn)
+
+#endif
+
 extern asmlinkage void dump_stack(void) __cold;
 
 #ifndef pr_fmt
diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index 02d6b6d28796..774119e27e0b 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -1805,6 +1805,127 @@ asmlinkage int printk_emit(int facility, int level,
 }
 EXPORT_SYMBOL(printk_emit);
 
+#ifdef CONFIG_ARCH_WANT_NMI_PRINTK
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
+
+/* "in progress" flag of NMI printing */
+static unsigned long nmi_print_flag;
+
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
+ *
+ * This is not a generic printk() implementation and must be used with
+ * great care. In particular there is a static limit on the quantity of
+ * data that may be emitted during NMI, only one client can be active at
+ * one time (arbitrated by the return value of begin_nmi_printk() and
+ * it is required that something at task or interrupt context be scheduled
+ * to issue the output.
+ */
+int nmi_vprintk(const char *fmt, va_list args)
+{
+	struct nmi_seq_buf *s = this_cpu_ptr(&nmi_print_seq);
+	unsigned int len = seq_buf_used(&s->seq);
+
+	seq_buf_vprintf(&s->seq, fmt, args);
+	return seq_buf_used(&s->seq) - len;
+}
+EXPORT_SYMBOL_GPL(nmi_vprintk);
+
+/*
+ * Check for concurrent usage and set up per_cpu seq_buf buffers that the NMIs
+ * running on the other CPUs will write to. Provides the mask of CPUs it is
+ * safe to write from (i.e. a copy of the online mask).
+ */
+int prepare_nmi_printk(struct cpumask *cpus)
+{
+	struct nmi_seq_buf *s;
+	int cpu;
+
+	if (test_and_set_bit(0, &nmi_print_flag)) {
+		/*
+		 * If something is already using the NMI print facility we
+		 * can't allow a second one...
+		 */
+		return -EBUSY;
+	}
+
+	cpumask_copy(cpus, cpu_online_mask);
+
+	for_each_cpu(cpu, cpus) {
+		s = &per_cpu(nmi_print_seq, cpu);
+		seq_buf_init(&s->seq, s->buffer, NMI_BUF_SIZE);
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(prepare_nmi_printk);
+
+static void print_seq_line(struct nmi_seq_buf *s, int start, int end)
+{
+	const char *buf = s->buffer + start;
+
+	printk("%.*s", (end - start) + 1, buf);
+}
+
+void complete_nmi_printk(struct cpumask *cpus)
+{
+	struct nmi_seq_buf *s;
+	int len;
+	int cpu;
+	int i;
+
+	/*
+	 * Now that all the NMIs have triggered, we can dump out their
+	 * back traces safely to the console.
+	 */
+	for_each_cpu(cpu, cpus) {
+		int last_i = 0;
+
+		s = &per_cpu(nmi_print_seq, cpu);
+
+		len = seq_buf_used(&s->seq);
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
+		/* Check if there was a partial line. */
+		if (last_i < len) {
+			print_seq_line(s, last_i, len - 1);
+			pr_cont("\n");
+		}
+	}
+
+	clear_bit(0, &nmi_print_flag);
+	smp_mb__after_atomic();
+}
+EXPORT_SYMBOL_GPL(complete_nmi_printk);
+
+#endif /* CONFIG_ARCH_WANT_NMI_PRINTK */
+
 int vprintk_default(const char *fmt, va_list args)
 {
 	int r;
@@ -1829,6 +1950,7 @@ EXPORT_SYMBOL_GPL(vprintk_default);
  */
 DEFINE_PER_CPU(printk_func_t, printk_func) = vprintk_default;
 
+
 /**
  * printk - print a kernel message
  * @fmt: format string
-- 
1.9.3

