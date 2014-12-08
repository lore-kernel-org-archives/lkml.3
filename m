Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755739AbaLHPFe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 10:05:34 -0500
Received: from smtprelay0165.hostedemail.com ([216.40.44.165]:56048 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752334AbaLHPFd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 10:05:33 -0500
X-Session-Marker: 6E657665747340676F6F646D69732E6F7267
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,rostedt@goodmis.org,:::::::::::,RULES_HIT:69:305:327:355:379:421:541:960:966:967:968:973:982:988:989:1260:1277:1311:1313:1314:1345:1431:1437:1515:1516:1518:1593:1594:1605:1730:1747:1777:1792:1801:1981:2194:2196:2198:2199:2200:2201:2393:2525:2538:2560:2563:2682:2685:2693:2731:2859:2861:2892:2895:2897:2898:2899:2901:2911:2923:2924:2925:2926:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3165:3743:3865:3866:3867:3868:3870:3871:3872:3873:3874:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4250:4321:4385:4425:4605:5007:6261:7875:7903:7904:7974:8531:8599:8603:8660:9025:9038:9592:10226:10848:10913:11026:11657:11914:12043:12291:12296:12438:12517:12519:12555:12679:12683:12783:13148:13161:13163:13184:13229:13230:13846:13869:14096:14097:21060:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:2:0
X-HE-Tag: start68_12df85bc95a50
X-Filterd-Recvd-Size: 43190
Date: Mon, 8 Dec 2014 10:05:28 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Jiri Kosina <jkosina@suse.cz>,
        Petr Mladek <pmladek@suse.cz>
Subject: [GIT PULL] tracing/NMI/printk: Use seq_buf for safe printing from
 NMI context
Message-ID: <20141208100528.5f97106f@gandalf.local.home>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Linus,

You and Andrew brought up some issues with the original patch set.
Here's the thread:

  http://lkml.kernel.org/r/20140619213329.478113470@goodmis.org

Your concern was moving "trace_seq.c" into lib/ as a file named
"trace_" and functions starting with "trace_" had nothing to do with
the generic functionality that was used. I agreed and made a seq_buf.c
file with seq_buf_* functions and moved all the generic code out of
trace_seq.c.

I also feel that we addressed all of Andrew's concerns as well.

I forked this branch from my other work as I wanted to give you the
choice of pulling it or not, without the decision affecting any of the
other ftrace work. We hope that you pull it :-)

Anyway...


This code is a fork from the trace-3.19 pull as it needed the trace_seq
clean ups from that branch.

This code solves the issue of performing stack dumps from NMI context.
The issue is that printk() is not safe from NMI context as if the NMI
were to trigger when a printk() was being performed, the NMI could
deadlock from the printk() internal locks. This has been seen in practice.

With lots of review from Petr Mladek, this code went through several
iterations, and we feel that it is now at a point of quality to be
accepted into mainline.

Here's what is contained in this patch set:

 o Creates a "seq_buf" generic buffer utility that allows a descriptor
   to be passed around where functions can write their own "printk()"
   formatted strings into it. The generic version was pulled out of
   the trace_seq() code that was made specifically for tracing.

 o The seq_buf code was change to model the seq_file code. I have
   a patch (not included for 3.19) that converts the seq_file.c code
   over to use seq_buf.c like the trace_seq.c code does. This was done
   to make sure that seq_buf.c is compatible with seq_file.c. I may
   try to get that patch in for 3.20.

 o The seq_buf.c file was moved to lib/ to remove it from being dependent
   on CONFIG_TRACING.

 o The printk() was updated to allow for a per_cpu "override" of
   the internal calls. That is, instead of writing to the console, a call
   to printk() may do something else. This made it easier to allow the
   NMI to change what printk() does in order to call dump_stack() without
   needing to update that code as well.

 o Finally, the dump_stack from all CPUs via NMI code was converted to
   use the seq_buf code. The caller to trigger the NMI code would wait
   till all the NMIs finished, and then it would print the seq_buf
   data to the console safely from a non NMI context.

Please pull the latest trace-seq-buf-3.19 tree, which can be found at:


  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
trace-seq-buf-3.19

Tag SHA1: f3505b20958eafce21b07101df09efb04f22d4c7
Head SHA1: db0865543739b3edb2ee9bf340380cf4986b58ff


Sasha Levin (1):
      x86/nmi: Fix use of unallocated cpumask_var_t

Steven Rostedt (Red Hat) (16):
      tracing: Create seq_buf layer in trace_seq
      tracing: Convert seq_buf_path() to be like seq_path()
      tracing: Convert seq_buf fields to be like seq_file fields
      tracing: Add a seq_buf_clear() helper and clear len and readpos in init
      seq_buf: Create seq_buf_used() to find out how much was written
      tracing: Clean up tracing_fill_pipe_page()
      tracing: Use trace_seq_used() and seq_buf_used() instead of len
      tracing: Add paranoid size check in trace_printk_seq()
      seq_buf: Add seq_buf_can_fit() helper function
      tracing: Have seq_buf use full buffer
      tracing: Add seq_buf_get_buf() and seq_buf_commit() helper functions
      seq-buf: Make seq_buf_bprintf() conditional on CONFIG_BINARY_PRINTF
      seq_buf: Move the seq_buf code to lib/
      printk: Add per_cpu printk func to allow printk to be diverted
      x86/nmi: Perform a safe NMI stack trace on all CPUs
      printk/percpu: Define printk_func when printk is not defined

----
 arch/x86/kernel/apic/hw_nmi.c        |  91 ++++++++-
 include/linux/percpu.h               |   4 +
 include/linux/printk.h               |   2 +
 include/linux/seq_buf.h              | 136 +++++++++++++
 include/linux/trace_seq.h            |  30 ++-
 kernel/printk/printk.c               |  41 +++-
 kernel/trace/trace.c                 |  65 +++++--
 kernel/trace/trace_events.c          |   9 +-
 kernel/trace/trace_functions_graph.c |  11 +-
 kernel/trace/trace_seq.c             | 177 ++++++++---------
 lib/Makefile                         |   2 +-
 lib/seq_buf.c                        | 359 +++++++++++++++++++++++++++++++++++
 12 files changed, 783 insertions(+), 144 deletions(-)
---------------------------
diff --git a/arch/x86/kernel/apic/hw_nmi.c b/arch/x86/kernel/apic/hw_nmi.c
index 6a1e71bde323..6873ab925d00 100644
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
+static cpumask_t printtrace_mask;
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
 
+static void print_seq_line(struct nmi_seq_buf *s, int start, int end)
+{
+	const char *buf = s->buffer + start;
+
+	printk("%.*s", (end - start) + 1, buf);
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
+	cpumask_copy(&printtrace_mask, to_cpumask(backtrace_mask));
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
@@ -65,11 +97,58 @@ void arch_trigger_all_cpu_backtrace(bool include_self)
 		touch_softlockup_watchdog();
 	}
 
+	/*
+	 * Now that all the NMIs have triggered, we can dump out their
+	 * back traces safely to the console.
+	 */
+	for_each_cpu(cpu, &printtrace_mask) {
+		int last_i = 0;
+
+		s = &per_cpu(nmi_print_seq, cpu);
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
+	unsigned int len = seq_buf_used(&s->seq);
+
+	seq_buf_vprintf(&s->seq, fmt, args);
+	return seq_buf_used(&s->seq) - len;
+}
+
 static int
 arch_trigger_all_cpu_backtrace_handler(unsigned int cmd, struct pt_regs *regs)
 {
@@ -78,12 +157,14 @@ arch_trigger_all_cpu_backtrace_handler(unsigned int cmd, struct pt_regs *regs)
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
diff --git a/include/linux/percpu.h b/include/linux/percpu.h
index a3aa63e47637..caebf2a758dc 100644
--- a/include/linux/percpu.h
+++ b/include/linux/percpu.h
@@ -5,6 +5,7 @@
 #include <linux/preempt.h>
 #include <linux/smp.h>
 #include <linux/cpumask.h>
+#include <linux/printk.h>
 #include <linux/pfn.h>
 #include <linux/init.h>
 
@@ -134,4 +135,7 @@ extern phys_addr_t per_cpu_ptr_to_phys(void *addr);
 	(typeof(type) __percpu *)__alloc_percpu(sizeof(type),		\
 						__alignof__(type))
 
+/* To avoid include hell, as printk can not declare this, we declare it here */
+DECLARE_PER_CPU(printk_func_t, printk_func);
+
 #endif /* __LINUX_PERCPU_H */
diff --git a/include/linux/printk.h b/include/linux/printk.h
index d78125f73ac4..c69be9ee8f48 100644
--- a/include/linux/printk.h
+++ b/include/linux/printk.h
@@ -124,6 +124,8 @@ static inline __printf(1, 2) __cold
 void early_printk(const char *s, ...) { }
 #endif
 
+typedef int(*printk_func_t)(const char *fmt, va_list args);
+
 #ifdef CONFIG_PRINTK
 asmlinkage __printf(5, 0)
 int vprintk_emit(int facility, int level,
diff --git a/include/linux/seq_buf.h b/include/linux/seq_buf.h
new file mode 100644
index 000000000000..9aafe0e24c68
--- /dev/null
+++ b/include/linux/seq_buf.h
@@ -0,0 +1,136 @@
+#ifndef _LINUX_SEQ_BUF_H
+#define _LINUX_SEQ_BUF_H
+
+#include <linux/fs.h>
+
+/*
+ * Trace sequences are used to allow a function to call several other functions
+ * to create a string of data to use.
+ */
+
+/**
+ * seq_buf - seq buffer structure
+ * @buffer:	pointer to the buffer
+ * @size:	size of the buffer
+ * @len:	the amount of data inside the buffer
+ * @readpos:	The next position to read in the buffer.
+ */
+struct seq_buf {
+	char			*buffer;
+	size_t			size;
+	size_t			len;
+	loff_t			readpos;
+};
+
+static inline void seq_buf_clear(struct seq_buf *s)
+{
+	s->len = 0;
+	s->readpos = 0;
+}
+
+static inline void
+seq_buf_init(struct seq_buf *s, unsigned char *buf, unsigned int size)
+{
+	s->buffer = buf;
+	s->size = size;
+	seq_buf_clear(s);
+}
+
+/*
+ * seq_buf have a buffer that might overflow. When this happens
+ * the len and size are set to be equal.
+ */
+static inline bool
+seq_buf_has_overflowed(struct seq_buf *s)
+{
+	return s->len > s->size;
+}
+
+static inline void
+seq_buf_set_overflow(struct seq_buf *s)
+{
+	s->len = s->size + 1;
+}
+
+/*
+ * How much buffer is left on the seq_buf?
+ */
+static inline unsigned int
+seq_buf_buffer_left(struct seq_buf *s)
+{
+	if (seq_buf_has_overflowed(s))
+		return 0;
+
+	return s->size - s->len;
+}
+
+/* How much buffer was written? */
+static inline unsigned int seq_buf_used(struct seq_buf *s)
+{
+	return min(s->len, s->size);
+}
+
+/**
+ * seq_buf_get_buf - get buffer to write arbitrary data to
+ * @s: the seq_buf handle
+ * @bufp: the beginning of the buffer is stored here
+ *
+ * Return the number of bytes available in the buffer, or zero if
+ * there's no space.
+ */
+static inline size_t seq_buf_get_buf(struct seq_buf *s, char **bufp)
+{
+	WARN_ON(s->len > s->size + 1);
+
+	if (s->len < s->size) {
+		*bufp = s->buffer + s->len;
+		return s->size - s->len;
+	}
+
+	*bufp = NULL;
+	return 0;
+}
+
+/**
+ * seq_buf_commit - commit data to the buffer
+ * @s: the seq_buf handle
+ * @num: the number of bytes to commit
+ *
+ * Commit @num bytes of data written to a buffer previously acquired
+ * by seq_buf_get.  To signal an error condition, or that the data
+ * didn't fit in the available space, pass a negative @num value.
+ */
+static inline void seq_buf_commit(struct seq_buf *s, int num)
+{
+	if (num < 0) {
+		seq_buf_set_overflow(s);
+	} else {
+		/* num must be negative on overflow */
+		BUG_ON(s->len + num > s->size);
+		s->len += num;
+	}
+}
+
+extern __printf(2, 3)
+int seq_buf_printf(struct seq_buf *s, const char *fmt, ...);
+extern __printf(2, 0)
+int seq_buf_vprintf(struct seq_buf *s, const char *fmt, va_list args);
+extern int seq_buf_print_seq(struct seq_file *m, struct seq_buf *s);
+extern int seq_buf_to_user(struct seq_buf *s, char __user *ubuf,
+			   int cnt);
+extern int seq_buf_puts(struct seq_buf *s, const char *str);
+extern int seq_buf_putc(struct seq_buf *s, unsigned char c);
+extern int seq_buf_putmem(struct seq_buf *s, const void *mem, unsigned int len);
+extern int seq_buf_putmem_hex(struct seq_buf *s, const void *mem,
+			      unsigned int len);
+extern int seq_buf_path(struct seq_buf *s, const struct path *path, const char *esc);
+
+extern int seq_buf_bitmask(struct seq_buf *s, const unsigned long *maskp,
+			   int nmaskbits);
+
+#ifdef CONFIG_BINARY_PRINTF
+extern int
+seq_buf_bprintf(struct seq_buf *s, const char *fmt, const u32 *binary);
+#endif
+
+#endif /* _LINUX_SEQ_BUF_H */
diff --git a/include/linux/trace_seq.h b/include/linux/trace_seq.h
index db8a73224f1a..cfaf5a1d4bad 100644
--- a/include/linux/trace_seq.h
+++ b/include/linux/trace_seq.h
@@ -1,7 +1,7 @@
 #ifndef _LINUX_TRACE_SEQ_H
 #define _LINUX_TRACE_SEQ_H
 
-#include <linux/fs.h>
+#include <linux/seq_buf.h>
 
 #include <asm/page.h>
 
@@ -12,20 +12,36 @@
 
 struct trace_seq {
 	unsigned char		buffer[PAGE_SIZE];
-	unsigned int		len;
-	unsigned int		readpos;
+	struct seq_buf		seq;
 	int			full;
 };
 
 static inline void
 trace_seq_init(struct trace_seq *s)
 {
-	s->len = 0;
-	s->readpos = 0;
+	seq_buf_init(&s->seq, s->buffer, PAGE_SIZE);
 	s->full = 0;
 }
 
 /**
+ * trace_seq_used - amount of actual data written to buffer
+ * @s: trace sequence descriptor
+ *
+ * Returns the amount of data written to the buffer.
+ *
+ * IMPORTANT!
+ *
+ * Use this instead of @s->seq.len if you need to pass the amount
+ * of data from the buffer to another buffer (userspace, or what not).
+ * The @s->seq.len on overflow is bigger than the buffer size and
+ * using it can cause access to undefined memory.
+ */
+static inline int trace_seq_used(struct trace_seq *s)
+{
+	return seq_buf_used(&s->seq);
+}
+
+/**
  * trace_seq_buffer_ptr - return pointer to next location in buffer
  * @s: trace sequence descriptor
  *
@@ -37,7 +53,7 @@ trace_seq_init(struct trace_seq *s)
 static inline unsigned char *
 trace_seq_buffer_ptr(struct trace_seq *s)
 {
-	return s->buffer + s->len;
+	return s->buffer + seq_buf_used(&s->seq);
 }
 
 /**
@@ -49,7 +65,7 @@ trace_seq_buffer_ptr(struct trace_seq *s)
  */
 static inline bool trace_seq_has_overflowed(struct trace_seq *s)
 {
-	return s->full || s->len > PAGE_SIZE - 1;
+	return s->full || seq_buf_has_overflowed(&s->seq);
 }
 
 /*
diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index ced2b84b1cb7..5af2b8bc88f0 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -1807,6 +1807,30 @@ asmlinkage int printk_emit(int facility, int level,
 }
 EXPORT_SYMBOL(printk_emit);
 
+int vprintk_default(const char *fmt, va_list args)
+{
+	int r;
+
+#ifdef CONFIG_KGDB_KDB
+	if (unlikely(kdb_trap_printk)) {
+		r = vkdb_printf(fmt, args);
+		return r;
+	}
+#endif
+	r = vprintk_emit(0, -1, NULL, 0, fmt, args);
+
+	return r;
+}
+EXPORT_SYMBOL_GPL(vprintk_default);
+
+/*
+ * This allows printk to be diverted to another function per cpu.
+ * This is useful for calling printk functions from within NMI
+ * without worrying about race conditions that can lock up the
+ * box.
+ */
+DEFINE_PER_CPU(printk_func_t, printk_func) = vprintk_default;
+
 /**
  * printk - print a kernel message
  * @fmt: format string
@@ -1830,19 +1854,15 @@ EXPORT_SYMBOL(printk_emit);
  */
 asmlinkage __visible int printk(const char *fmt, ...)
 {
+	printk_func_t vprintk_func;
 	va_list args;
 	int r;
 
-#ifdef CONFIG_KGDB_KDB
-	if (unlikely(kdb_trap_printk)) {
-		va_start(args, fmt);
-		r = vkdb_printf(fmt, args);
-		va_end(args);
-		return r;
-	}
-#endif
 	va_start(args, fmt);
-	r = vprintk_emit(0, -1, NULL, 0, fmt, args);
+	preempt_disable();
+	vprintk_func = this_cpu_read(printk_func);
+	r = vprintk_func(fmt, args);
+	preempt_enable();
 	va_end(args);
 
 	return r;
@@ -1876,6 +1896,9 @@ static size_t msg_print_text(const struct printk_log *msg, enum log_flags prev,
 			     bool syslog, char *buf, size_t size) { return 0; }
 static size_t cont_print_text(char *text, size_t size) { return 0; }
 
+/* Still needs to be defined for users */
+DEFINE_PER_CPU(printk_func_t, printk_func);
+
 #endif /* CONFIG_PRINTK */
 
 #ifdef CONFIG_EARLY_PRINTK
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 3ce3c4ccfc94..26facec4625e 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -939,19 +939,20 @@ out:
 	return ret;
 }
 
+/* TODO add a seq_buf_to_buffer() */
 static ssize_t trace_seq_to_buffer(struct trace_seq *s, void *buf, size_t cnt)
 {
 	int len;
 
-	if (s->len <= s->readpos)
+	if (trace_seq_used(s) <= s->seq.readpos)
 		return -EBUSY;
 
-	len = s->len - s->readpos;
+	len = trace_seq_used(s) - s->seq.readpos;
 	if (cnt > len)
 		cnt = len;
-	memcpy(buf, s->buffer + s->readpos, cnt);
+	memcpy(buf, s->buffer + s->seq.readpos, cnt);
 
-	s->readpos += cnt;
+	s->seq.readpos += cnt;
 	return cnt;
 }
 
@@ -4315,6 +4316,8 @@ static int tracing_open_pipe(struct inode *inode, struct file *filp)
 		goto out;
 	}
 
+	trace_seq_init(&iter->seq);
+
 	/*
 	 * We make a copy of the current tracer to avoid concurrent
 	 * changes on it while we are reading.
@@ -4511,18 +4514,18 @@ waitagain:
 	trace_access_lock(iter->cpu_file);
 	while (trace_find_next_entry_inc(iter) != NULL) {
 		enum print_line_t ret;
-		int len = iter->seq.len;
+		int save_len = iter->seq.seq.len;
 
 		ret = print_trace_line(iter);
 		if (ret == TRACE_TYPE_PARTIAL_LINE) {
 			/* don't print partial lines */
-			iter->seq.len = len;
+			iter->seq.seq.len = save_len;
 			break;
 		}
 		if (ret != TRACE_TYPE_NO_CONSUME)
 			trace_consume(iter);
 
-		if (iter->seq.len >= cnt)
+		if (trace_seq_used(&iter->seq) >= cnt)
 			break;
 
 		/*
@@ -4538,7 +4541,7 @@ waitagain:
 
 	/* Now copy what we have to the user */
 	sret = trace_seq_to_user(&iter->seq, ubuf, cnt);
-	if (iter->seq.readpos >= iter->seq.len)
+	if (iter->seq.seq.readpos >= trace_seq_used(&iter->seq))
 		trace_seq_init(&iter->seq);
 
 	/*
@@ -4572,20 +4575,33 @@ static size_t
 tracing_fill_pipe_page(size_t rem, struct trace_iterator *iter)
 {
 	size_t count;
+	int save_len;
 	int ret;
 
 	/* Seq buffer is page-sized, exactly what we need. */
 	for (;;) {
-		count = iter->seq.len;
+		save_len = iter->seq.seq.len;
 		ret = print_trace_line(iter);
-		count = iter->seq.len - count;
-		if (rem < count) {
-			rem = 0;
-			iter->seq.len -= count;
+
+		if (trace_seq_has_overflowed(&iter->seq)) {
+			iter->seq.seq.len = save_len;
 			break;
 		}
+
+		/*
+		 * This should not be hit, because it should only
+		 * be set if the iter->seq overflowed. But check it
+		 * anyway to be safe.
+		 */
 		if (ret == TRACE_TYPE_PARTIAL_LINE) {
-			iter->seq.len -= count;
+			iter->seq.seq.len = save_len;
+			break;
+		}
+
+		count = trace_seq_used(&iter->seq) - save_len;
+		if (rem < count) {
+			rem = 0;
+			iter->seq.seq.len = save_len;
 			break;
 		}
 
@@ -4666,13 +4682,13 @@ static ssize_t tracing_splice_read_pipe(struct file *filp,
 		/* Copy the data into the page, so we can start over. */
 		ret = trace_seq_to_buffer(&iter->seq,
 					  page_address(spd.pages[i]),
-					  iter->seq.len);
+					  trace_seq_used(&iter->seq));
 		if (ret < 0) {
 			__free_page(spd.pages[i]);
 			break;
 		}
 		spd.partial[i].offset = 0;
-		spd.partial[i].len = iter->seq.len;
+		spd.partial[i].len = trace_seq_used(&iter->seq);
 
 		trace_seq_init(&iter->seq);
 	}
@@ -5673,7 +5689,8 @@ tracing_stats_read(struct file *filp, char __user *ubuf,
 	cnt = ring_buffer_read_events_cpu(trace_buf->buffer, cpu);
 	trace_seq_printf(s, "read events: %ld\n", cnt);
 
-	count = simple_read_from_buffer(ubuf, count, ppos, s->buffer, s->len);
+	count = simple_read_from_buffer(ubuf, count, ppos,
+					s->buffer, trace_seq_used(s));
 
 	kfree(s);
 
@@ -6636,11 +6653,19 @@ void
 trace_printk_seq(struct trace_seq *s)
 {
 	/* Probably should print a warning here. */
-	if (s->len >= TRACE_MAX_PRINT)
-		s->len = TRACE_MAX_PRINT;
+	if (s->seq.len >= TRACE_MAX_PRINT)
+		s->seq.len = TRACE_MAX_PRINT;
+
+	/*
+	 * More paranoid code. Although the buffer size is set to
+	 * PAGE_SIZE, and TRACE_MAX_PRINT is 1000, this is just
+	 * an extra layer of protection.
+	 */
+	if (WARN_ON_ONCE(s->seq.len >= s->seq.size))
+		s->seq.len = s->seq.size - 1;
 
 	/* should be zero ended, but we are paranoid. */
-	s->buffer[s->len] = 0;
+	s->buffer[s->seq.len] = 0;
 
 	printk(KERN_TRACE "%s", s->buffer);
 
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index f9d0cbe014b7..935cbea78532 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -1044,7 +1044,8 @@ event_filter_read(struct file *filp, char __user *ubuf, size_t cnt,
 	mutex_unlock(&event_mutex);
 
 	if (file)
-		r = simple_read_from_buffer(ubuf, cnt, ppos, s->buffer, s->len);
+		r = simple_read_from_buffer(ubuf, cnt, ppos,
+					    s->buffer, trace_seq_used(s));
 
 	kfree(s);
 
@@ -1210,7 +1211,8 @@ subsystem_filter_read(struct file *filp, char __user *ubuf, size_t cnt,
 	trace_seq_init(s);
 
 	print_subsystem_event_filter(system, s);
-	r = simple_read_from_buffer(ubuf, cnt, ppos, s->buffer, s->len);
+	r = simple_read_from_buffer(ubuf, cnt, ppos,
+				    s->buffer, trace_seq_used(s));
 
 	kfree(s);
 
@@ -1265,7 +1267,8 @@ show_header(struct file *filp, char __user *ubuf, size_t cnt, loff_t *ppos)
 	trace_seq_init(s);
 
 	func(s);
-	r = simple_read_from_buffer(ubuf, cnt, ppos, s->buffer, s->len);
+	r = simple_read_from_buffer(ubuf, cnt, ppos,
+				    s->buffer, trace_seq_used(s));
 
 	kfree(s);
 
diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
index 100288d10e1f..ec35468349a7 100644
--- a/kernel/trace/trace_functions_graph.c
+++ b/kernel/trace/trace_functions_graph.c
@@ -1153,14 +1153,17 @@ print_graph_comment(struct trace_seq *s, struct trace_entry *ent,
 			return ret;
 	}
 
+	if (trace_seq_has_overflowed(s))
+		goto out;
+
 	/* Strip ending newline */
-	if (s->buffer[s->len - 1] == '\n') {
-		s->buffer[s->len - 1] = '\0';
-		s->len--;
+	if (s->buffer[s->seq.len - 1] == '\n') {
+		s->buffer[s->seq.len - 1] = '\0';
+		s->seq.len--;
 	}
 
 	trace_seq_puts(s, " */\n");
-
+ out:
 	return trace_handle_return(s);
 }
 
diff --git a/kernel/trace/trace_seq.c b/kernel/trace/trace_seq.c
index fabfa0f190a3..f8b45d8792f9 100644
--- a/kernel/trace/trace_seq.c
+++ b/kernel/trace/trace_seq.c
@@ -27,10 +27,19 @@
 #include <linux/trace_seq.h>
 
 /* How much buffer is left on the trace_seq? */
-#define TRACE_SEQ_BUF_LEFT(s) ((PAGE_SIZE - 1) - (s)->len)
+#define TRACE_SEQ_BUF_LEFT(s) seq_buf_buffer_left(&(s)->seq)
 
 /* How much buffer is written? */
-#define TRACE_SEQ_BUF_USED(s) min((s)->len, (unsigned int)(PAGE_SIZE - 1))
+#define TRACE_SEQ_BUF_USED(s) seq_buf_used(&(s)->seq)
+
+/*
+ * trace_seq should work with being initialized with 0s.
+ */
+static inline void __trace_seq_init(struct trace_seq *s)
+{
+	if (unlikely(!s->seq.size))
+		trace_seq_init(s);
+}
 
 /**
  * trace_print_seq - move the contents of trace_seq into a seq_file
@@ -43,10 +52,11 @@
  */
 int trace_print_seq(struct seq_file *m, struct trace_seq *s)
 {
-	unsigned int len = TRACE_SEQ_BUF_USED(s);
 	int ret;
 
-	ret = seq_write(m, s->buffer, len);
+	__trace_seq_init(s);
+
+	ret = seq_buf_print_seq(m, &s->seq);
 
 	/*
 	 * Only reset this buffer if we successfully wrote to the
@@ -72,24 +82,23 @@ int trace_print_seq(struct seq_file *m, struct trace_seq *s)
  */
 void trace_seq_printf(struct trace_seq *s, const char *fmt, ...)
 {
-	unsigned int len = TRACE_SEQ_BUF_LEFT(s);
+	unsigned int save_len = s->seq.len;
 	va_list ap;
-	int ret;
 
-	if (s->full || !len)
+	if (s->full)
 		return;
 
+	__trace_seq_init(s);
+
 	va_start(ap, fmt);
-	ret = vsnprintf(s->buffer + s->len, len, fmt, ap);
+	seq_buf_vprintf(&s->seq, fmt, ap);
 	va_end(ap);
 
 	/* If we can't write it all, don't bother writing anything */
-	if (ret >= len) {
+	if (unlikely(seq_buf_has_overflowed(&s->seq))) {
+		s->seq.len = save_len;
 		s->full = 1;
-		return;
 	}
-
-	s->len += ret;
 }
 EXPORT_SYMBOL_GPL(trace_seq_printf);
 
@@ -104,14 +113,19 @@ EXPORT_SYMBOL_GPL(trace_seq_printf);
 void trace_seq_bitmask(struct trace_seq *s, const unsigned long *maskp,
 		      int nmaskbits)
 {
-	unsigned int len = TRACE_SEQ_BUF_LEFT(s);
-	int ret;
+	unsigned int save_len = s->seq.len;
 
-	if (s->full || !len)
+	if (s->full)
 		return;
 
-	ret = bitmap_scnprintf(s->buffer + s->len, len, maskp, nmaskbits);
-	s->len += ret;
+	__trace_seq_init(s);
+
+	seq_buf_bitmask(&s->seq, maskp, nmaskbits);
+
+	if (unlikely(seq_buf_has_overflowed(&s->seq))) {
+		s->seq.len = save_len;
+		s->full = 1;
+	}
 }
 EXPORT_SYMBOL_GPL(trace_seq_bitmask);
 
@@ -128,21 +142,20 @@ EXPORT_SYMBOL_GPL(trace_seq_bitmask);
  */
 void trace_seq_vprintf(struct trace_seq *s, const char *fmt, va_list args)
 {
-	unsigned int len = TRACE_SEQ_BUF_LEFT(s);
-	int ret;
+	unsigned int save_len = s->seq.len;
 
-	if (s->full || !len)
+	if (s->full)
 		return;
 
-	ret = vsnprintf(s->buffer + s->len, len, fmt, args);
+	__trace_seq_init(s);
+
+	seq_buf_vprintf(&s->seq, fmt, args);
 
 	/* If we can't write it all, don't bother writing anything */
-	if (ret >= len) {
+	if (unlikely(seq_buf_has_overflowed(&s->seq))) {
+		s->seq.len = save_len;
 		s->full = 1;
-		return;
 	}
-
-	s->len += ret;
 }
 EXPORT_SYMBOL_GPL(trace_seq_vprintf);
 
@@ -163,21 +176,21 @@ EXPORT_SYMBOL_GPL(trace_seq_vprintf);
  */
 void trace_seq_bprintf(struct trace_seq *s, const char *fmt, const u32 *binary)
 {
-	unsigned int len = TRACE_SEQ_BUF_LEFT(s);
-	int ret;
+	unsigned int save_len = s->seq.len;
 
-	if (s->full || !len)
+	if (s->full)
 		return;
 
-	ret = bstr_printf(s->buffer + s->len, len, fmt, binary);
+	__trace_seq_init(s);
+
+	seq_buf_bprintf(&s->seq, fmt, binary);
 
 	/* If we can't write it all, don't bother writing anything */
-	if (ret >= len) {
+	if (unlikely(seq_buf_has_overflowed(&s->seq))) {
+		s->seq.len = save_len;
 		s->full = 1;
 		return;
 	}
-
-	s->len += ret;
 }
 EXPORT_SYMBOL_GPL(trace_seq_bprintf);
 
@@ -198,13 +211,14 @@ void trace_seq_puts(struct trace_seq *s, const char *str)
 	if (s->full)
 		return;
 
+	__trace_seq_init(s);
+
 	if (len > TRACE_SEQ_BUF_LEFT(s)) {
 		s->full = 1;
 		return;
 	}
 
-	memcpy(s->buffer + s->len, str, len);
-	s->len += len;
+	seq_buf_putmem(&s->seq, str, len);
 }
 EXPORT_SYMBOL_GPL(trace_seq_puts);
 
@@ -223,12 +237,14 @@ void trace_seq_putc(struct trace_seq *s, unsigned char c)
 	if (s->full)
 		return;
 
+	__trace_seq_init(s);
+
 	if (TRACE_SEQ_BUF_LEFT(s) < 1) {
 		s->full = 1;
 		return;
 	}
 
-	s->buffer[s->len++] = c;
+	seq_buf_putc(&s->seq, c);
 }
 EXPORT_SYMBOL_GPL(trace_seq_putc);
 
@@ -247,19 +263,17 @@ void trace_seq_putmem(struct trace_seq *s, const void *mem, unsigned int len)
 	if (s->full)
 		return;
 
+	__trace_seq_init(s);
+
 	if (len > TRACE_SEQ_BUF_LEFT(s)) {
 		s->full = 1;
 		return;
 	}
 
-	memcpy(s->buffer + s->len, mem, len);
-	s->len += len;
+	seq_buf_putmem(&s->seq, mem, len);
 }
 EXPORT_SYMBOL_GPL(trace_seq_putmem);
 
-#define MAX_MEMHEX_BYTES	8U
-#define HEX_CHARS		(MAX_MEMHEX_BYTES*2 + 1)
-
 /**
  * trace_seq_putmem_hex - write raw memory into the buffer in ASCII hex
  * @s: trace sequence descriptor
@@ -273,32 +287,26 @@ EXPORT_SYMBOL_GPL(trace_seq_putmem);
 void trace_seq_putmem_hex(struct trace_seq *s, const void *mem,
 			 unsigned int len)
 {
-	unsigned char hex[HEX_CHARS];
-	const unsigned char *data = mem;
-	unsigned int start_len;
-	int i, j;
+	unsigned int save_len = s->seq.len;
 
 	if (s->full)
 		return;
 
-	while (len) {
-		start_len = min(len, HEX_CHARS - 1);
-#ifdef __BIG_ENDIAN
-		for (i = 0, j = 0; i < start_len; i++) {
-#else
-		for (i = start_len-1, j = 0; i >= 0; i--) {
-#endif
-			hex[j++] = hex_asc_hi(data[i]);
-			hex[j++] = hex_asc_lo(data[i]);
-		}
-		if (WARN_ON_ONCE(j == 0 || j/2 > len))
-			break;
-
-		/* j increments twice per loop */
-		len -= j / 2;
-		hex[j++] = ' ';
-
-		trace_seq_putmem(s, hex, j);
+	__trace_seq_init(s);
+
+	/* Each byte is represented by two chars */
+	if (len * 2 > TRACE_SEQ_BUF_LEFT(s)) {
+		s->full = 1;
+		return;
+	}
+
+	/* The added spaces can still cause an overflow */
+	seq_buf_putmem_hex(&s->seq, mem, len);
+
+	if (unlikely(seq_buf_has_overflowed(&s->seq))) {
+		s->seq.len = save_len;
+		s->full = 1;
+		return;
 	}
 }
 EXPORT_SYMBOL_GPL(trace_seq_putmem_hex);
@@ -317,30 +325,27 @@ EXPORT_SYMBOL_GPL(trace_seq_putmem_hex);
  */
 int trace_seq_path(struct trace_seq *s, const struct path *path)
 {
-	unsigned char *p;
+	unsigned int save_len = s->seq.len;
 
 	if (s->full)
 		return 0;
 
+	__trace_seq_init(s);
+
 	if (TRACE_SEQ_BUF_LEFT(s) < 1) {
 		s->full = 1;
 		return 0;
 	}
 
-	p = d_path(path, s->buffer + s->len, PAGE_SIZE - s->len);
-	if (!IS_ERR(p)) {
-		p = mangle_path(s->buffer + s->len, p, "\n");
-		if (p) {
-			s->len = p - s->buffer;
-			return 1;
-		}
-	} else {
-		s->buffer[s->len++] = '?';
-		return 1;
+	seq_buf_path(&s->seq, path, "\n");
+
+	if (unlikely(seq_buf_has_overflowed(&s->seq))) {
+		s->seq.len = save_len;
+		s->full = 1;
+		return 0;
 	}
 
-	s->full = 1;
-	return 0;
+	return 1;
 }
 EXPORT_SYMBOL_GPL(trace_seq_path);
 
@@ -366,25 +371,7 @@ EXPORT_SYMBOL_GPL(trace_seq_path);
  */
 int trace_seq_to_user(struct trace_seq *s, char __user *ubuf, int cnt)
 {
-	int len;
-	int ret;
-
-	if (!cnt)
-		return 0;
-
-	if (s->len <= s->readpos)
-		return -EBUSY;
-
-	len = s->len - s->readpos;
-	if (cnt > len)
-		cnt = len;
-	ret = copy_to_user(ubuf, s->buffer + s->readpos, cnt);
-	if (ret == cnt)
-		return -EFAULT;
-
-	cnt -= ret;
-
-	s->readpos += cnt;
-	return cnt;
+	__trace_seq_init(s);
+	return seq_buf_to_user(&s->seq, ubuf, cnt);
 }
 EXPORT_SYMBOL_GPL(trace_seq_to_user);
diff --git a/lib/Makefile b/lib/Makefile
index 7512dc978f18..a1aa1e81ed36 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -13,7 +13,7 @@ lib-y := ctype.o string.o vsprintf.o cmdline.o \
 	 sha1.o md5.o irq_regs.o reciprocal_div.o argv_split.o \
 	 proportions.o flex_proportions.o ratelimit.o show_mem.o \
 	 is_single_threaded.o plist.o decompress.o kobject_uevent.o \
-	 earlycpio.o
+	 earlycpio.o seq_buf.o
 
 obj-$(CONFIG_ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS) += usercopy.o
 lib-$(CONFIG_MMU) += ioremap.o
diff --git a/lib/seq_buf.c b/lib/seq_buf.c
new file mode 100644
index 000000000000..4eedfedb9e31
--- /dev/null
+++ b/lib/seq_buf.c
@@ -0,0 +1,359 @@
+/*
+ * seq_buf.c
+ *
+ * Copyright (C) 2014 Red Hat Inc, Steven Rostedt <srostedt@redhat.com>
+ *
+ * The seq_buf is a handy tool that allows you to pass a descriptor around
+ * to a buffer that other functions can write to. It is similar to the
+ * seq_file functionality but has some differences.
+ *
+ * To use it, the seq_buf must be initialized with seq_buf_init().
+ * This will set up the counters within the descriptor. You can call
+ * seq_buf_init() more than once to reset the seq_buf to start
+ * from scratch.
+ */
+#include <linux/uaccess.h>
+#include <linux/seq_file.h>
+#include <linux/seq_buf.h>
+
+/**
+ * seq_buf_can_fit - can the new data fit in the current buffer?
+ * @s: the seq_buf descriptor
+ * @len: The length to see if it can fit in the current buffer
+ *
+ * Returns true if there's enough unused space in the seq_buf buffer
+ * to fit the amount of new data according to @len.
+ */
+static bool seq_buf_can_fit(struct seq_buf *s, size_t len)
+{
+	return s->len + len <= s->size;
+}
+
+/**
+ * seq_buf_print_seq - move the contents of seq_buf into a seq_file
+ * @m: the seq_file descriptor that is the destination
+ * @s: the seq_buf descriptor that is the source.
+ *
+ * Returns zero on success, non zero otherwise
+ */
+int seq_buf_print_seq(struct seq_file *m, struct seq_buf *s)
+{
+	unsigned int len = seq_buf_used(s);
+
+	return seq_write(m, s->buffer, len);
+}
+
+/**
+ * seq_buf_vprintf - sequence printing of information.
+ * @s: seq_buf descriptor
+ * @fmt: printf format string
+ * @args: va_list of arguments from a printf() type function
+ *
+ * Writes a vnprintf() format into the sequencce buffer.
+ *
+ * Returns zero on success, -1 on overflow.
+ */
+int seq_buf_vprintf(struct seq_buf *s, const char *fmt, va_list args)
+{
+	int len;
+
+	WARN_ON(s->size == 0);
+
+	if (s->len < s->size) {
+		len = vsnprintf(s->buffer + s->len, s->size - s->len, fmt, args);
+		if (seq_buf_can_fit(s, len)) {
+			s->len += len;
+			return 0;
+		}
+	}
+	seq_buf_set_overflow(s);
+	return -1;
+}
+
+/**
+ * seq_buf_printf - sequence printing of information
+ * @s: seq_buf descriptor
+ * @fmt: printf format string
+ *
+ * Writes a printf() format into the sequence buffer.
+ *
+ * Returns zero on success, -1 on overflow.
+ */
+int seq_buf_printf(struct seq_buf *s, const char *fmt, ...)
+{
+	va_list ap;
+	int ret;
+
+	va_start(ap, fmt);
+	ret = seq_buf_vprintf(s, fmt, ap);
+	va_end(ap);
+
+	return ret;
+}
+
+/**
+ * seq_buf_bitmask - write a bitmask array in its ASCII representation
+ * @s:		seq_buf descriptor
+ * @maskp:	points to an array of unsigned longs that represent a bitmask
+ * @nmaskbits:	The number of bits that are valid in @maskp
+ *
+ * Writes a ASCII representation of a bitmask string into @s.
+ *
+ * Returns zero on success, -1 on overflow.
+ */
+int seq_buf_bitmask(struct seq_buf *s, const unsigned long *maskp,
+		    int nmaskbits)
+{
+	unsigned int len = seq_buf_buffer_left(s);
+	int ret;
+
+	WARN_ON(s->size == 0);
+
+	/*
+	 * Note, because bitmap_scnprintf() only returns the number of bytes
+	 * written and not the number that would be written, we use the last
+	 * byte of the buffer to let us know if we overflowed. There's a small
+	 * chance that the bitmap could have fit exactly inside the buffer, but
+	 * it's not that critical if that does happen.
+	 */
+	if (len > 1) {
+		ret = bitmap_scnprintf(s->buffer + s->len, len, maskp, nmaskbits);
+		if (ret < len) {
+			s->len += ret;
+			return 0;
+		}
+	}
+	seq_buf_set_overflow(s);
+	return -1;
+}
+
+#ifdef CONFIG_BINARY_PRINTF
+/**
+ * seq_buf_bprintf - Write the printf string from binary arguments
+ * @s: seq_buf descriptor
+ * @fmt: The format string for the @binary arguments
+ * @binary: The binary arguments for @fmt.
+ *
+ * When recording in a fast path, a printf may be recorded with just
+ * saving the format and the arguments as they were passed to the
+ * function, instead of wasting cycles converting the arguments into
+ * ASCII characters. Instead, the arguments are saved in a 32 bit
+ * word array that is defined by the format string constraints.
+ *
+ * This function will take the format and the binary array and finish
+ * the conversion into the ASCII string within the buffer.
+ *
+ * Returns zero on success, -1 on overflow.
+ */
+int seq_buf_bprintf(struct seq_buf *s, const char *fmt, const u32 *binary)
+{
+	unsigned int len = seq_buf_buffer_left(s);
+	int ret;
+
+	WARN_ON(s->size == 0);
+
+	if (s->len < s->size) {
+		ret = bstr_printf(s->buffer + s->len, len, fmt, binary);
+		if (seq_buf_can_fit(s, ret)) {
+			s->len += ret;
+			return 0;
+		}
+	}
+	seq_buf_set_overflow(s);
+	return -1;
+}
+#endif /* CONFIG_BINARY_PRINTF */
+
+/**
+ * seq_buf_puts - sequence printing of simple string
+ * @s: seq_buf descriptor
+ * @str: simple string to record
+ *
+ * Copy a simple string into the sequence buffer.
+ *
+ * Returns zero on success, -1 on overflow
+ */
+int seq_buf_puts(struct seq_buf *s, const char *str)
+{
+	unsigned int len = strlen(str);
+
+	WARN_ON(s->size == 0);
+
+	if (seq_buf_can_fit(s, len)) {
+		memcpy(s->buffer + s->len, str, len);
+		s->len += len;
+		return 0;
+	}
+	seq_buf_set_overflow(s);
+	return -1;
+}
+
+/**
+ * seq_buf_putc - sequence printing of simple character
+ * @s: seq_buf descriptor
+ * @c: simple character to record
+ *
+ * Copy a single character into the sequence buffer.
+ *
+ * Returns zero on success, -1 on overflow
+ */
+int seq_buf_putc(struct seq_buf *s, unsigned char c)
+{
+	WARN_ON(s->size == 0);
+
+	if (seq_buf_can_fit(s, 1)) {
+		s->buffer[s->len++] = c;
+		return 0;
+	}
+	seq_buf_set_overflow(s);
+	return -1;
+}
+
+/**
+ * seq_buf_putmem - write raw data into the sequenc buffer
+ * @s: seq_buf descriptor
+ * @mem: The raw memory to copy into the buffer
+ * @len: The length of the raw memory to copy (in bytes)
+ *
+ * There may be cases where raw memory needs to be written into the
+ * buffer and a strcpy() would not work. Using this function allows
+ * for such cases.
+ *
+ * Returns zero on success, -1 on overflow
+ */
+int seq_buf_putmem(struct seq_buf *s, const void *mem, unsigned int len)
+{
+	WARN_ON(s->size == 0);
+
+	if (seq_buf_can_fit(s, len)) {
+		memcpy(s->buffer + s->len, mem, len);
+		s->len += len;
+		return 0;
+	}
+	seq_buf_set_overflow(s);
+	return -1;
+}
+
+#define MAX_MEMHEX_BYTES	8U
+#define HEX_CHARS		(MAX_MEMHEX_BYTES*2 + 1)
+
+/**
+ * seq_buf_putmem_hex - write raw memory into the buffer in ASCII hex
+ * @s: seq_buf descriptor
+ * @mem: The raw memory to write its hex ASCII representation of
+ * @len: The length of the raw memory to copy (in bytes)
+ *
+ * This is similar to seq_buf_putmem() except instead of just copying the
+ * raw memory into the buffer it writes its ASCII representation of it
+ * in hex characters.
+ *
+ * Returns zero on success, -1 on overflow
+ */
+int seq_buf_putmem_hex(struct seq_buf *s, const void *mem,
+		       unsigned int len)
+{
+	unsigned char hex[HEX_CHARS];
+	const unsigned char *data = mem;
+	unsigned int start_len;
+	int i, j;
+
+	WARN_ON(s->size == 0);
+
+	while (len) {
+		start_len = min(len, HEX_CHARS - 1);
+#ifdef __BIG_ENDIAN
+		for (i = 0, j = 0; i < start_len; i++) {
+#else
+		for (i = start_len-1, j = 0; i >= 0; i--) {
+#endif
+			hex[j++] = hex_asc_hi(data[i]);
+			hex[j++] = hex_asc_lo(data[i]);
+		}
+		if (WARN_ON_ONCE(j == 0 || j/2 > len))
+			break;
+
+		/* j increments twice per loop */
+		len -= j / 2;
+		hex[j++] = ' ';
+
+		seq_buf_putmem(s, hex, j);
+		if (seq_buf_has_overflowed(s))
+			return -1;
+	}
+	return 0;
+}
+
+/**
+ * seq_buf_path - copy a path into the sequence buffer
+ * @s: seq_buf descriptor
+ * @path: path to write into the sequence buffer.
+ * @esc: set of characters to escape in the output
+ *
+ * Write a path name into the sequence buffer.
+ *
+ * Returns the number of written bytes on success, -1 on overflow
+ */
+int seq_buf_path(struct seq_buf *s, const struct path *path, const char *esc)
+{
+	char *buf;
+	size_t size = seq_buf_get_buf(s, &buf);
+	int res = -1;
+
+	WARN_ON(s->size == 0);
+
+	if (size) {
+		char *p = d_path(path, buf, size);
+		if (!IS_ERR(p)) {
+			char *end = mangle_path(buf, p, esc);
+			if (end)
+				res = end - buf;
+		}
+	}
+	seq_buf_commit(s, res);
+
+	return res;
+}
+
+/**
+ * seq_buf_to_user - copy the squence buffer to user space
+ * @s: seq_buf descriptor
+ * @ubuf: The userspace memory location to copy to
+ * @cnt: The amount to copy
+ *
+ * Copies the sequence buffer into the userspace memory pointed to
+ * by @ubuf. It starts from the last read position (@s->readpos)
+ * and writes up to @cnt characters or till it reaches the end of
+ * the content in the buffer (@s->len), which ever comes first.
+ *
+ * On success, it returns a positive number of the number of bytes
+ * it copied.
+ *
+ * On failure it returns -EBUSY if all of the content in the
+ * sequence has been already read, which includes nothing in the
+ * sequence (@s->len == @s->readpos).
+ *
+ * Returns -EFAULT if the copy to userspace fails.
+ */
+int seq_buf_to_user(struct seq_buf *s, char __user *ubuf, int cnt)
+{
+	int len;
+	int ret;
+
+	if (!cnt)
+		return 0;
+
+	if (s->len <= s->readpos)
+		return -EBUSY;
+
+	len = seq_buf_used(s) - s->readpos;
+	if (cnt > len)
+		cnt = len;
+	ret = copy_to_user(ubuf, s->buffer + s->readpos, cnt);
+	if (ret == cnt)
+		return -EFAULT;
+
+	cnt -= ret;
+
+	s->readpos += cnt;
+	return cnt;
+}
