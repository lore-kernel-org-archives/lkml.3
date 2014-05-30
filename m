Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755777AbaE3LgL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 07:36:11 -0400
Received: from e06smtp10.uk.ibm.com ([195.75.94.106]:50362 "EHLO
	e06smtp10.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755662AbaE3LgI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 07:36:08 -0400
Date: Fri, 30 May 2014 13:36:01 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrea Righi <andrea@betterlinux.com>,
        Eric Dumazet <eric.dumazet@gmail.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        Hendrik Brueckner <brueckner@linux.vnet.ibm.com>,
        Thorsten Diehl <thorsten.diehl@de.ibm.com>,
        Ian Kent <raven@themaw.net>,
        "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Subject: [PATCH] fs: proc/stat: use seq_file iterator interface
Message-ID: <20140530113601.GB4732@osiris>
References: <20140521122521.GB7471@osiris>
 <20140521143229.GA32011@infradead.org>
 <20140528085841.GA4219@osiris>
 <20140528090153.GC4219@osiris>
 <20140528153704.b2a3f46dc39ebf8f681d528a@linux-foundation.org>
 <20140530083830.GA4732@osiris>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140530083830.GA4732@osiris>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14053011-4966-0000-0000-0000003597D9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Well... I'll try to come up with something better. Even though I only
> forward ported an existing patch to address a memory allocation failure.

How about the patch below then?

>From 52a050f85256d7586933365da1b98c6227651449 Mon Sep 17 00:00:00 2001
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Date: Tue, 27 May 2014 12:41:00 +0200
Subject: [PATCH] fs: proc/stat: use seq_file iterator interface

This is the forward port of a patch from KAMEZAWA Hiroyuki with a couple
of additional small changess.
The original patch was posted here: https://lkml.org/lkml/2012/1/23/41.

/proc/stat uses single_open() for showing information. This means all data
will be gathered and buffered once into a big buffer.

The size of the buffer depends on the nubmer of possible cpus and therefore
may get very large. This may lead to large memory allocations, which can
fail if memory is fragmented (e.g. for num_possible_cpus() == 256):

sadc: page allocation failure: order:4, mode:0x1040d0
CPU: 1 PID: 192063 Comm: sadc Not tainted 3.10.0-123.el7.s390x #1
[...]
Call Trace:
([<0000000000111fbe>] show_trace+0xe6/0x130)
[<0000000000112074>] show_stack+0x6c/0xe8
[<000000000020d356>] warn_alloc_failed+0xd6/0x138
[<00000000002114d2>] __alloc_pages_nodemask+0x9da/0xb68
[<000000000021168e>] __get_free_pages+0x2e/0x58
[<000000000025a05c>] kmalloc_order_trace+0x44/0xc0
[<00000000002f3ffa>] stat_open+0x5a/0xd8
[<00000000002e9aaa>] proc_reg_open+0x8a/0x140
[<0000000000273b64>] do_dentry_open+0x1bc/0x2c8
[<000000000027411e>] finish_open+0x46/0x60
[<000000000028675a>] do_last+0x382/0x10d0
[<0000000000287570>] path_openat+0xc8/0x4f8
[<0000000000288bde>] do_filp_open+0x46/0xa8
[<000000000027541c>] do_sys_open+0x114/0x1f0
[<00000000005b1c1c>] sysc_tracego+0x14/0x1a

This in turn means that reading /proc/stat doesn't work at all in such
situations.

To address this issue convert /proc/stat to use the seq_file iterator
interface. The existing output is split into several pieces so that each
piece fits into a single page before it is copied to user space.  That way
the higher order allocation goes away.

Unfortunately this has user space visible side effects. Unlike before,
reading /proc/stat may now require several read system calls, even if the
buffer provided by user space would be large enough to hold the entire
data.  Howewer it seems to be unlikely that such user space programs exist,
since the content of /proc/stat varies all the time anyway.

Furthermore the code that generated the output gathered per cpu statistics
without any locking. So while a process read /proc/stat the data is
changed concurrently leading potentially to inconsistent data. This is
still the case after the change, however because of the iterator interface,
and the additional latencies we get with that, the per cpu statistics may
get more inconsistent than before.
If this is really an issue remains to be seen.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---
 fs/proc/stat.c | 278 +++++++++++++++++++++++++++++++++++++++++----------------
 1 file changed, 203 insertions(+), 75 deletions(-)

diff --git a/fs/proc/stat.c b/fs/proc/stat.c
index 9d231e9e5f0e..141c4b773ec1 100644
--- a/fs/proc/stat.c
+++ b/fs/proc/stat.c
@@ -77,22 +77,109 @@ static u64 get_iowait_time(int cpu)
 
 #endif
 
-static int show_stat(struct seq_file *p, void *v)
+enum proc_stat_stage /* The numbers are used as *pos and iter->stage */
+{
+	SHOW_TOTAL_CPU_STAT,
+	SHOW_PERCPU_STAT,
+	SHOW_TOTAL_IRQS,
+	SHOW_IRQ_DETAILS,
+	SHOW_TIMES,
+	SHOW_TOTAL_SOFTIRQ,
+	SHOW_SOFTIRQ_DETAILS,
+	SHOW_EOL,
+	END_STATS,
+};
+
+/*
+ * To reduce the number of ->next(), ->show() calls IRQ numbers are
+ * handled in batch.
+ */
+struct seq_stat_iter {
+	int stage;
+	unsigned long jiffies;
+	int cpu_iter;
+	int irq_iter;
+	int softirq_iter;
+	/* cached information */
+	u64 irq_sum;
+	u64 softirq_sum;
+	u32 per_softirq_sums[NR_SOFTIRQS];
+};
+
+static void *proc_stat_start(struct seq_file *p, loff_t *pos)
+{
+	struct seq_stat_iter *iter = p->private;
+
+	/* At lseek(), *pos==0 is passed (see traverse() in seq_file.c. */
+	if (!*pos) {
+		struct timespec boottime;
+
+		memset(iter, 0, sizeof(*iter));
+		iter->stage = SHOW_TOTAL_CPU_STAT;
+		getboottime(&boottime);
+		iter->jiffies = boottime.tv_sec;
+	}
+	if (iter->stage == END_STATS)
+		return NULL;
+	return iter;
+}
+
+static void proc_stat_stop(struct seq_file *p, void *v)
+{
+}
+
+static void *proc_stat_next(struct seq_file *p, void *v, loff_t *pos)
+{
+	struct seq_stat_iter *iter = p->private;
+	int index;
+
+	switch (iter->stage) {
+	case SHOW_TOTAL_CPU_STAT:
+		iter->stage = SHOW_PERCPU_STAT;
+		iter->cpu_iter = cpumask_first(cpu_online_mask);
+		break;
+	case SHOW_PERCPU_STAT:
+		index = cpumask_next(iter->cpu_iter, cpu_online_mask);
+		if (index >= nr_cpu_ids)
+			iter->stage = SHOW_TOTAL_IRQS;
+		else
+			iter->cpu_iter = index;
+		break;
+	case SHOW_TOTAL_IRQS:
+		iter->stage = SHOW_IRQ_DETAILS;
+		iter->irq_iter = 0;
+		break;
+	case SHOW_IRQ_DETAILS:
+		if (iter->irq_iter >= nr_irqs)
+			iter->stage = SHOW_TIMES;
+		break;
+	case SHOW_TIMES:
+		iter->stage = SHOW_TOTAL_SOFTIRQ;
+		break;
+	case SHOW_TOTAL_SOFTIRQ:
+		iter->stage = SHOW_SOFTIRQ_DETAILS;
+		break;
+	case SHOW_SOFTIRQ_DETAILS:
+		iter->stage = SHOW_EOL;
+		break;
+	case SHOW_EOL:
+		iter->stage = END_STATS;
+		return NULL;
+	default:
+		break;
+	}
+	return iter;
+}
+
+static int show_total_cpu_stat(struct seq_file *p, struct seq_stat_iter *iter)
 {
-	int i, j;
-	unsigned long jif;
 	u64 user, nice, system, idle, iowait, irq, softirq, steal;
 	u64 guest, guest_nice;
-	u64 sum = 0;
-	u64 sum_softirq = 0;
-	unsigned int per_softirq_sums[NR_SOFTIRQS] = {0};
-	struct timespec boottime;
+	int i, j;
 
-	user = nice = system = idle = iowait =
-		irq = softirq = steal = 0;
+	user = nice = system = idle = iowait = 0;
+	irq = softirq = steal = 0;
 	guest = guest_nice = 0;
-	getboottime(&boottime);
-	jif = boottime.tv_sec;
 
 	for_each_possible_cpu(i) {
 		user += kcpustat_cpu(i).cpustat[CPUTIME_USER];
@@ -105,17 +192,17 @@ static int show_stat(struct seq_file *p, void *v)
 		steal += kcpustat_cpu(i).cpustat[CPUTIME_STEAL];
 		guest += kcpustat_cpu(i).cpustat[CPUTIME_GUEST];
 		guest_nice += kcpustat_cpu(i).cpustat[CPUTIME_GUEST_NICE];
-		sum += kstat_cpu_irqs_sum(i);
-		sum += arch_irq_stat_cpu(i);
+		iter->irq_sum += kstat_cpu_irqs_sum(i);
+		iter->irq_sum += arch_irq_stat_cpu(i);
 
 		for (j = 0; j < NR_SOFTIRQS; j++) {
 			unsigned int softirq_stat = kstat_softirqs_cpu(j, i);
 
-			per_softirq_sums[j] += softirq_stat;
-			sum_softirq += softirq_stat;
+			iter->per_softirq_sums[j] += softirq_stat;
+			iter->softirq_sum += softirq_stat;
 		}
 	}
-	sum += arch_irq_stat();
+	iter->irq_sum += arch_irq_stat();
 
 	seq_puts(p, "cpu ");
 	seq_put_decimal_ull(p, ' ', cputime64_to_clock_t(user));
@@ -129,20 +216,31 @@ static int show_stat(struct seq_file *p, void *v)
 	seq_put_decimal_ull(p, ' ', cputime64_to_clock_t(guest));
 	seq_put_decimal_ull(p, ' ', cputime64_to_clock_t(guest_nice));
 	seq_putc(p, '\n');
+	return 0;
+}
+
+static int show_online_cpu_stat(struct seq_file *p, struct seq_stat_iter *iter)
+{
+	u64 user, nice, system, idle, iowait, irq, softirq, steal;
+	u64 guest, guest_nice;
+	int i, cpu, index;
 
-	for_each_online_cpu(i) {
+	/* Handle 32 cpus at a time, to avoid lots of seqfile iterations. */
+	cpu = index = iter->cpu_iter;
+	for (i = 0; i < 32 && index < nr_cpu_ids; i++) {
+		cpu = index;
 		/* Copy values here to work around gcc-2.95.3, gcc-2.96 */
-		user = kcpustat_cpu(i).cpustat[CPUTIME_USER];
-		nice = kcpustat_cpu(i).cpustat[CPUTIME_NICE];
-		system = kcpustat_cpu(i).cpustat[CPUTIME_SYSTEM];
-		idle = get_idle_time(i);
-		iowait = get_iowait_time(i);
-		irq = kcpustat_cpu(i).cpustat[CPUTIME_IRQ];
-		softirq = kcpustat_cpu(i).cpustat[CPUTIME_SOFTIRQ];
-		steal = kcpustat_cpu(i).cpustat[CPUTIME_STEAL];
-		guest = kcpustat_cpu(i).cpustat[CPUTIME_GUEST];
-		guest_nice = kcpustat_cpu(i).cpustat[CPUTIME_GUEST_NICE];
-		seq_printf(p, "cpu%d", i);
+		user = kcpustat_cpu(cpu).cpustat[CPUTIME_USER];
+		nice = kcpustat_cpu(cpu).cpustat[CPUTIME_NICE];
+		system = kcpustat_cpu(cpu).cpustat[CPUTIME_SYSTEM];
+		idle = get_idle_time(cpu);
+		iowait = get_iowait_time(cpu);
+		irq = kcpustat_cpu(cpu).cpustat[CPUTIME_IRQ];
+		softirq = kcpustat_cpu(cpu).cpustat[CPUTIME_SOFTIRQ];
+		steal = kcpustat_cpu(cpu).cpustat[CPUTIME_STEAL];
+		guest = kcpustat_cpu(cpu).cpustat[CPUTIME_GUEST];
+		guest_nice = kcpustat_cpu(cpu).cpustat[CPUTIME_GUEST_NICE];
+		seq_printf(p, "cpu%d", cpu);
 		seq_put_decimal_ull(p, ' ', cputime64_to_clock_t(user));
 		seq_put_decimal_ull(p, ' ', cputime64_to_clock_t(nice));
 		seq_put_decimal_ull(p, ' ', cputime64_to_clock_t(system));
@@ -154,66 +252,96 @@ static int show_stat(struct seq_file *p, void *v)
 		seq_put_decimal_ull(p, ' ', cputime64_to_clock_t(guest));
 		seq_put_decimal_ull(p, ' ', cputime64_to_clock_t(guest_nice));
 		seq_putc(p, '\n');
+		index = cpumask_next(cpu, cpu_online_mask);
 	}
-	seq_printf(p, "intr %llu", (unsigned long long)sum);
-
-	/* sum again ? it could be updated? */
-	for_each_irq_nr(j)
-		seq_put_decimal_ull(p, ' ', kstat_irqs(j));
-
-	seq_printf(p,
-		"\nctxt %llu\n"
-		"btime %lu\n"
-		"processes %lu\n"
-		"procs_running %lu\n"
-		"procs_blocked %lu\n",
-		nr_context_switches(),
-		(unsigned long)jif,
-		total_forks,
-		nr_running(),
-		nr_iowait());
-
-	seq_printf(p, "softirq %llu", (unsigned long long)sum_softirq);
-
-	for (i = 0; i < NR_SOFTIRQS; i++)
-		seq_put_decimal_ull(p, ' ', per_softirq_sums[i]);
-	seq_putc(p, '\n');
+	iter->cpu_iter = cpu;
+	return 0;
+}
+
+static int show_irq_details(struct seq_file *p, struct seq_stat_iter *iter)
+{
+	int ret;
+
+	/*
+	 * we update iterater in ->show()...seems ugly but for avoiding
+	 * tons of function calls, print out here as much as possible
+	 */
+	do {
+		ret = seq_put_decimal_ull(p, ' ', kstat_irqs(iter->irq_iter));
+		if (!ret)
+			iter->irq_iter += 1;
+	} while (!ret && iter->irq_iter < nr_irqs);
 
 	return 0;
 }
 
+static int show_softirq_details(struct seq_file *p, struct seq_stat_iter *iter)
+{
+	int ret;
+
+	do {
+		ret = seq_put_decimal_ull(p, ' ',
+				iter->per_softirq_sums[iter->softirq_iter]);
+		if (!ret)
+			iter->softirq_iter += 1;
+	} while (!ret && iter->softirq_iter < NR_SOFTIRQS);
+	return 0;
+}
+
+static int proc_stat_show(struct seq_file *p, void *v)
+{
+	struct seq_stat_iter *iter = v;
+
+	switch (iter->stage) {
+	case SHOW_TOTAL_CPU_STAT:
+		return show_total_cpu_stat(p, iter);
+	case SHOW_PERCPU_STAT:
+		return show_online_cpu_stat(p, iter);
+	case SHOW_TOTAL_IRQS:
+		return seq_printf(p, "intr %llu",
+				  (unsigned long long)iter->irq_sum);
+	case SHOW_IRQ_DETAILS:
+		return show_irq_details(p, iter);
+	case SHOW_TIMES:
+		return seq_printf(p,
+				  "\nctxt %llu\n"
+				  "btime %lu\n"
+				  "processes %lu\n"
+				  "procs_running %lu\n"
+				  "procs_blocked %lu\n",
+				  nr_context_switches(),
+				  (unsigned long)iter->jiffies,
+				  total_forks,
+				  nr_running(),
+				  nr_iowait());
+	case SHOW_TOTAL_SOFTIRQ:
+		return seq_printf(p, "softirq %llu",
+				  (unsigned long long)iter->softirq_sum);
+	case SHOW_SOFTIRQ_DETAILS:
+		return show_softirq_details(p, iter);
+	case SHOW_EOL:
+		return seq_putc(p, '\n');
+	}
+	return 0;
+}
+
+static const struct seq_operations show_stat_op = {
+	.start = proc_stat_start,
+	.next  = proc_stat_next,
+	.stop  = proc_stat_stop,
+	.show  = proc_stat_show,
+};
+
 static int stat_open(struct inode *inode, struct file *file)
 {
-	size_t size = 1024 + 128 * num_possible_cpus();
-	char *buf;
-	struct seq_file *m;
-	int res;
-
-	/* minimum size to display an interrupt count : 2 bytes */
-	size += 2 * nr_irqs;
-
-	/* don't ask for more than the kmalloc() max size */
-	if (size > KMALLOC_MAX_SIZE)
-		size = KMALLOC_MAX_SIZE;
-	buf = kmalloc(size, GFP_KERNEL);
-	if (!buf)
-		return -ENOMEM;
-
-	res = single_open(file, show_stat, NULL);
-	if (!res) {
-		m = file->private_data;
-		m->buf = buf;
-		m->size = ksize(buf);
-	} else
-		kfree(buf);
-	return res;
+	return seq_open_private(file, &show_stat_op, sizeof(struct seq_stat_iter));
 }
 
 static const struct file_operations proc_stat_operations = {
 	.open		= stat_open,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
-	.release	= single_release,
+	.release	= seq_release_private,
 };
 
 static int __init proc_stat_init(void)
-- 
1.8.5.5

