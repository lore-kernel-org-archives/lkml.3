Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752218AbaGVCkr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 22:40:47 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.231]:36621 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751759AbaGVCkq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 22:40:46 -0400
Date: Mon, 21 Jul 2014 22:40:39 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, x86-ml <x86@kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86, TSC: Add a software TSC offset
Message-ID: <20140721224039.5d8b5faa@gandalf.local.home>
In-Reply-To: <20140719130602.GA5101@pd.tnic>
References: <20140719130602.GA5101@pd.tnic>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Your patch inspired me to write this hack. I was curious to know how
the TSCs of my boxes were with respect to each other, and wanted to get
an idea. Maybe there's a better way, but I decided to waste an hour and
write this hack up.

Here's what it does. It creates the file /sys/kernel/debug/rdtsc_test,
and when you read it, it does some whacky things.

1) A table is set up with the number of possible CPUs. The cable
consists of: index, TSC count, CPU.

2) A atomic variable is set to the number of online CPUS.

3) An IPI is sent to each of the other CPUs to run the test.

4) The test decrements the atomic, and then spins until it reaches zero.

5) The caller of smp_call_function() then calls the test iself, being
the last to decrement the counter causing it to go to zero and all CPUs
then fight for a spinlock.

6) When the spin lock is taken, it records which place it was in (order
of spinlock taken, and records its own TSC. Then it releases the lock.

7) It then records in the table where its position is, its TSC counter
and CPU number.


Finally, the read will show the results of the table. Looks something
like this:

# cat /debug/rdtsc_test 
    0)  1305910016816  (cpu:5)
    1)  1305910017550  (cpu:7)
    2)  1305910017712  (cpu:1)
    3)  1305910017910  (cpu:6)
    4)  1305910018042  (cpu:2)
    5)  1305910018226  (cpu:3)
    6)  1305910018416  (cpu:4)
    7)  1305910018540  (cpu:0)

As long as the TSC counts are in order of the index, the TSC is moving
forward nicely. If they are not in order, then the TSCs are not in sync.

Yes, this is a hack, but I think it's a somewhat useful hack.

Not-for-inclusion-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/Makefile     |    1 
 kernel/rdtsc_test.c |  127 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 128 insertions(+)

Index: linux-trace.git/kernel/Makefile
===================================================================
--- linux-trace.git.orig/kernel/Makefile	2014-07-16 14:10:47.210980652 -0400
+++ linux-trace.git/kernel/Makefile	2014-07-21 18:23:23.990246141 -0400
@@ -28,6 +28,7 @@
 obj-y += irq/
 obj-y += rcu/
 
+obj-$(CONFIG_DEBUG_FS) += rdtsc_test.o
 obj-$(CONFIG_CHECKPOINT_RESTORE) += kcmp.o
 obj-$(CONFIG_FREEZER) += freezer.o
 obj-$(CONFIG_PROFILING) += profile.o
Index: linux-trace.git/kernel/rdtsc_test.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-trace.git/kernel/rdtsc_test.c	2014-07-21 22:32:16.531878062 -0400
@@ -0,0 +1,127 @@
+#include <linux/spinlock.h>
+#include <linux/seq_file.h>
+#include <linux/debugfs.h>
+#include <linux/percpu.h>
+#include <linux/delay.h>
+#include <linux/slab.h>
+#include <linux/init.h>
+#include <linux/cpu.h>
+
+static unsigned int rdtsc_count __read_mostly;
+static unsigned int rdtsc_index;
+static u64 *rdtsc_counts;
+static unsigned int *rdtsc_cpus;
+
+static DEFINE_RAW_SPINLOCK(rdtsc_lock);
+static DEFINE_MUTEX(rdtsc_mutex);
+
+static atomic_t rdtsc_start;
+
+static void read_rdtsc_test(void *data)
+{
+	unsigned int idx;
+	u64 cnt;
+
+	atomic_dec(&rdtsc_start);
+	while (atomic_read(&rdtsc_start))
+		cpu_relax();
+
+	raw_spin_lock(&rdtsc_lock);
+	idx = rdtsc_index++;
+	rdtscll(cnt);
+	raw_spin_unlock(&rdtsc_lock);
+
+	if (idx >= rdtsc_count)
+		return;
+
+	rdtsc_counts[idx] = cnt;
+	rdtsc_cpus[idx] = smp_processor_id();
+}
+
+static void run_rdtsc_test(void)
+{
+	int i = 0;
+
+	get_online_cpus();
+	mutex_lock(&rdtsc_mutex);
+	atomic_set(&rdtsc_start, num_online_cpus());
+	rdtsc_index = 0;
+	memset(rdtsc_counts, 0, sizeof(*rdtsc_counts) * rdtsc_count);
+	memset(rdtsc_cpus, 0, sizeof(*rdtsc_cpus) * rdtsc_count);
+
+	/* Don't let us get migrated */
+	preempt_disable();
+	smp_call_function(read_rdtsc_test, NULL, 0);
+
+	/* Run the test without being disturbed. */
+	local_irq_disable();
+	read_rdtsc_test(NULL);
+	local_irq_enable();
+
+	preempt_enable();
+
+	/* We didn't wait for smp_call_function() to complete on other CPUS */
+	while (rdtsc_index < num_online_cpus() && i++ < 1000)
+		msleep(1);
+
+	mutex_unlock(&rdtsc_mutex);
+	WARN_ON(rdtsc_index < num_online_cpus());
+	put_online_cpus();
+}
+
+static int rdtsc_test_show(struct seq_file *m, void *v)
+{
+	unsigned int i;
+
+	mutex_lock(&rdtsc_mutex);
+
+	for (i = 0; i < rdtsc_count; i++) {
+		seq_printf(m, "%5u)  %9llu  (cpu:%u)\n",
+			   i, rdtsc_counts[i], rdtsc_cpus[i]);
+	}
+
+	mutex_unlock(&rdtsc_mutex);
+
+	return 0;
+}
+
+static int rdtsc_test_open(struct inode *inode, struct file *filp)
+{
+	run_rdtsc_test();
+
+	return single_open(filp, rdtsc_test_show, inode->i_private);
+}
+
+static const struct file_operations rdtsc_test_fops = {
+	.open = rdtsc_test_open,
+	.read = seq_read,
+	.llseek = generic_file_llseek,
+};
+
+static __init int init_rdtsc_test(void)
+{
+	struct dentry *ret;
+
+	rdtsc_count = num_possible_cpus();
+	rdtsc_counts = kmalloc(sizeof(*rdtsc_counts) * rdtsc_count, GFP_KERNEL);
+	if (!rdtsc_counts) {
+		pr_warn("Could not create rdtsc_test counts\n");
+		return -ENOMEM;
+	}
+
+	rdtsc_cpus = kmalloc(sizeof(*rdtsc_cpus) * rdtsc_count, GFP_KERNEL);
+	if (!rdtsc_cpus) {
+		kfree(rdtsc_counts);
+		pr_warn("Could not create rdtsc_test cpus\n");
+		return -ENOMEM;
+	}
+
+	ret = debugfs_create_file("rdtsc_test", 0x400, NULL, NULL,
+				  &rdtsc_test_fops);
+	if (!ret)
+		pr_warn("Could not create debugfs rdtsc_test entry\n");
+	return ret;
+}
+
+fs_initcall(init_rdtsc_test);
+
