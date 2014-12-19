Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752493AbaLSNP3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 08:15:29 -0500
Received: from www.linutronix.de ([62.245.132.108]:34247 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752197AbaLSNP2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 08:15:28 -0500
Date: Fri, 19 Dec 2014 14:15:20 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [GIT pull] irq core updates for 3.19
Message-ID: <alpine.DEB.2.11.1412191413410.17382@nanos>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

please pull the latest irq-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git irq-urgent-for-linus

A single fix plugging a long standing race between proc/stat and
proc/interrupts access and freeing of interrupt descriptors.

Thanks,

	tglx

------------------>
Thomas Gleixner (1):
      genirq: Prevent proc race against freeing of irq descriptors


 fs/proc/stat.c              |  2 +-
 include/linux/kernel_stat.h |  1 +
 kernel/irq/internals.h      |  4 ++++
 kernel/irq/irqdesc.c        | 52 +++++++++++++++++++++++++++++++++++++++++++++
 kernel/irq/proc.c           | 22 ++++++++++++++++++-
 5 files changed, 79 insertions(+), 2 deletions(-)

diff --git a/fs/proc/stat.c b/fs/proc/stat.c
index bf2d03f8fd3e..510413eb25b8 100644
--- a/fs/proc/stat.c
+++ b/fs/proc/stat.c
@@ -159,7 +159,7 @@ static int show_stat(struct seq_file *p, void *v)
 
 	/* sum again ? it could be updated? */
 	for_each_irq_nr(j)
-		seq_put_decimal_ull(p, ' ', kstat_irqs(j));
+		seq_put_decimal_ull(p, ' ', kstat_irqs_usr(j));
 
 	seq_printf(p,
 		"\nctxt %llu\n"
diff --git a/include/linux/kernel_stat.h b/include/linux/kernel_stat.h
index b9376cd5a187..25a822f6f000 100644
--- a/include/linux/kernel_stat.h
+++ b/include/linux/kernel_stat.h
@@ -68,6 +68,7 @@ static inline unsigned int kstat_softirqs_cpu(unsigned int irq, int cpu)
  * Number of interrupts per specific IRQ source, since bootup
  */
 extern unsigned int kstat_irqs(unsigned int irq);
+extern unsigned int kstat_irqs_usr(unsigned int irq);
 
 /*
  * Number of interrupts per cpu, since bootup
diff --git a/kernel/irq/internals.h b/kernel/irq/internals.h
index 4332d766619d..df553b0af936 100644
--- a/kernel/irq/internals.h
+++ b/kernel/irq/internals.h
@@ -78,8 +78,12 @@ extern void unmask_threaded_irq(struct irq_desc *desc);
 
 #ifdef CONFIG_SPARSE_IRQ
 static inline void irq_mark_irq(unsigned int irq) { }
+extern void irq_lock_sparse(void);
+extern void irq_unlock_sparse(void);
 #else
 extern void irq_mark_irq(unsigned int irq);
+static inline void irq_lock_sparse(void) { }
+static inline void irq_unlock_sparse(void) { }
 #endif
 
 extern void init_kstat_irqs(struct irq_desc *desc, int node, int nr);
diff --git a/kernel/irq/irqdesc.c b/kernel/irq/irqdesc.c
index a1782f88f0af..99793b9b6d23 100644
--- a/kernel/irq/irqdesc.c
+++ b/kernel/irq/irqdesc.c
@@ -132,6 +132,16 @@ static void free_masks(struct irq_desc *desc)
 static inline void free_masks(struct irq_desc *desc) { }
 #endif
 
+void irq_lock_sparse(void)
+{
+	mutex_lock(&sparse_irq_lock);
+}
+
+void irq_unlock_sparse(void)
+{
+	mutex_unlock(&sparse_irq_lock);
+}
+
 static struct irq_desc *alloc_desc(int irq, int node, struct module *owner)
 {
 	struct irq_desc *desc;
@@ -168,6 +178,12 @@ static void free_desc(unsigned int irq)
 
 	unregister_irq_proc(irq, desc);
 
+	/*
+	 * sparse_irq_lock protects also show_interrupts() and
+	 * kstat_irq_usr(). Once we deleted the descriptor from the
+	 * sparse tree we can free it. Access in proc will fail to
+	 * lookup the descriptor.
+	 */
 	mutex_lock(&sparse_irq_lock);
 	delete_irq_desc(irq);
 	mutex_unlock(&sparse_irq_lock);
@@ -574,6 +590,15 @@ void kstat_incr_irq_this_cpu(unsigned int irq)
 	kstat_incr_irqs_this_cpu(irq, irq_to_desc(irq));
 }
 
+/**
+ * kstat_irqs_cpu - Get the statistics for an interrupt on a cpu
+ * @irq:	The interrupt number
+ * @cpu:	The cpu number
+ *
+ * Returns the sum of interrupt counts on @cpu since boot for
+ * @irq. The caller must ensure that the interrupt is not removed
+ * concurrently.
+ */
 unsigned int kstat_irqs_cpu(unsigned int irq, int cpu)
 {
 	struct irq_desc *desc = irq_to_desc(irq);
@@ -582,6 +607,14 @@ unsigned int kstat_irqs_cpu(unsigned int irq, int cpu)
 			*per_cpu_ptr(desc->kstat_irqs, cpu) : 0;
 }
 
+/**
+ * kstat_irqs - Get the statistics for an interrupt
+ * @irq:	The interrupt number
+ *
+ * Returns the sum of interrupt counts on all cpus since boot for
+ * @irq. The caller must ensure that the interrupt is not removed
+ * concurrently.
+ */
 unsigned int kstat_irqs(unsigned int irq)
 {
 	struct irq_desc *desc = irq_to_desc(irq);
@@ -594,3 +627,22 @@ unsigned int kstat_irqs(unsigned int irq)
 		sum += *per_cpu_ptr(desc->kstat_irqs, cpu);
 	return sum;
 }
+
+/**
+ * kstat_irqs_usr - Get the statistics for an interrupt
+ * @irq:	The interrupt number
+ *
+ * Returns the sum of interrupt counts on all cpus since boot for
+ * @irq. Contrary to kstat_irqs() this can be called from any
+ * preemptible context. It's protected against concurrent removal of
+ * an interrupt descriptor when sparse irqs are enabled.
+ */
+unsigned int kstat_irqs_usr(unsigned int irq)
+{
+	int sum;
+
+	irq_lock_sparse();
+	sum = kstat_irqs(irq);
+	irq_unlock_sparse();
+	return sum;
+}
diff --git a/kernel/irq/proc.c b/kernel/irq/proc.c
index ac1ba2f11032..9dc9bfd8a678 100644
--- a/kernel/irq/proc.c
+++ b/kernel/irq/proc.c
@@ -15,6 +15,23 @@
 
 #include "internals.h"
 
+/*
+ * Access rules:
+ *
+ * procfs protects read/write of /proc/irq/N/ files against a
+ * concurrent free of the interrupt descriptor. remove_proc_entry()
+ * immediately prevents new read/writes to happen and waits for
+ * already running read/write functions to complete.
+ *
+ * We remove the proc entries first and then delete the interrupt
+ * descriptor from the radix tree and free it. So it is guaranteed
+ * that irq_to_desc(N) is valid as long as the read/writes are
+ * permitted by procfs.
+ *
+ * The read from /proc/interrupts is a different problem because there
+ * is no protection. So the lookup and the access to irqdesc
+ * information must be protected by sparse_irq_lock.
+ */
 static struct proc_dir_entry *root_irq_dir;
 
 #ifdef CONFIG_SMP
@@ -437,9 +454,10 @@ int show_interrupts(struct seq_file *p, void *v)
 		seq_putc(p, '\n');
 	}
 
+	irq_lock_sparse();
 	desc = irq_to_desc(i);
 	if (!desc)
-		return 0;
+		goto outsparse;
 
 	raw_spin_lock_irqsave(&desc->lock, flags);
 	for_each_online_cpu(j)
@@ -479,6 +497,8 @@ int show_interrupts(struct seq_file *p, void *v)
 	seq_putc(p, '\n');
 out:
 	raw_spin_unlock_irqrestore(&desc->lock, flags);
+outsparse:
+	irq_unlock_sparse();
 	return 0;
 }
 #endif
