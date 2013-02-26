Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759725Ab3BZXdX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 18:33:23 -0500
Received: from relay2.sgi.com ([192.48.179.30]:54134 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754656Ab3BZXdU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 18:33:20 -0500
From: Nathan Zimmer <nzimmer@sgi.com>
Cc: johnstul@us.ibm.com, tglx@linutronix.de, sboyd@codeaurora.org,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        Nathan Zimmer <nzimmer@sgi.com>
Subject: [PATCH v3 2/2] timer_list: convert timer list to be a proper seq_file
Date: Tue, 26 Feb 2013 17:33:16 -0600
Message-Id: <1361921596-9636-3-git-send-email-nzimmer@sgi.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1361921596-9636-1-git-send-email-nzimmer@sgi.com>
References: <51267626.3030308@codeaurora.org>
 <1361921596-9636-1-git-send-email-nzimmer@sgi.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When running with 4096 cores attemping to read /proc/timer_list will fail
with an ENOMEM condition.  On a sufficantly large systems the total amount
of data is more then 4mb, so it won't fit into a single buffer.  The
failure can also occur on smaller systems when memory fragmentation is
high as reported by Dave Jones.

Convert /proc/timer_list to a proper seq_file with its own iterator.  This
is a little more complex given that we have to make two passes with two
separate headers.

Signed-off-by: Nathan Zimmer <nzimmer@sgi.com>
Reported-by: Dave Jones <davej@redhat.com>
Cc: John Stultz <johnstul@us.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Stephen Boyd <sboyd@codeaurora.org>

v2: Added comments on the iteration and other fixups pointed to by Andrew.
v3: Corrected the case where max_cpus != nr_cpu_ids by exiting early.
---
 kernel/time/timer_list.c | 99 ++++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 87 insertions(+), 12 deletions(-)

diff --git a/kernel/time/timer_list.c b/kernel/time/timer_list.c
index b3dc3d6..ee0bb5e 100644
--- a/kernel/time/timer_list.c
+++ b/kernel/time/timer_list.c
@@ -253,38 +253,113 @@ static int timer_list_show(struct seq_file *m, void *v)
 	u64 now = ktime_to_ns(ktime_get());
 	int cpu;
 
-	SEQ_printf(m, "Timer List Version: v0.7\n");
-	SEQ_printf(m, "HRTIMER_MAX_CLOCK_BASES: %d\n", HRTIMER_MAX_CLOCK_BASES);
-	SEQ_printf(m, "now at %Ld nsecs\n", (unsigned long long)now);
-	SEQ_printf(m, "\n");
-
-	for_each_online_cpu(cpu)
+	if (v == (void *)1) {
+		SEQ_printf(m, "Timer List Version: v0.7\n");
+		SEQ_printf(m, "HRTIMER_MAX_CLOCK_BASES: %d\n",
+			   HRTIMER_MAX_CLOCK_BASES);
+		SEQ_printf(m, "now at %Ld nsecs\n", (unsigned long long)now);
+		SEQ_printf(m, "\n");
+	} else if (v < (void *)(unsigned long)(nr_cpu_ids + 2)) {
+		cpu = (unsigned long)(v - 2);
 		print_cpu(m, cpu, now);
-
+	}
 #ifdef CONFIG_GENERIC_CLOCKEVENTS
-	timer_list_show_tickdevices_header(m);
-	for_each_online_cpu(cpu)
+	else if (v == (void *)(unsigned long)nr_cpu_ids + 2) {
+		timer_list_show_tickdevices_header(m);
+	} else {
+		cpu = (unsigned long)(v - 3 - nr_cpu_ids);
 		print_tickdevice(m, tick_get_device(cpu), cpu);
+	}
 #endif
-
 	return 0;
 }
 
+/*
+ * This itererator really needs some explanation since it is offset and has
+ * two passes, one of which is controlled by a config option.
+ * In a hotpluggable systems some cpus, including cpu 0 and the last cpu, may
+ * be missing so we have to use cpumask_* to iterate over the cpus.
+ * For the first pass:
+ * It returns 1 for the header position.
+ * For cpu 0 it returns 2 and the final possible cpu would be nr_cpu_ids + 1.
+ * On the second pass:
+ * It returnes nr_cpu_ids + 1 for the second header position.
+ * For cpu 0 it returns nr_cpu_ids + 2
+ * The final possible cpu would be nr_cpu_ids + nr_cpu_ids + 2.
+ * It is also important to remember that cpumask_next returns >= nr_cpu_ids if
+ * no further cpus set.
+ */
+static void *timer_list_start(struct seq_file *file, loff_t *offset)
+{
+	unsigned long n = *offset;
+
+	if (n == 0)
+		return (void *) 1;
+
+	if (n < nr_cpu_ids + 1) {
+		n = cpumask_next(n - 2, cpu_online_mask);
+		if (n >= nr_cpu_ids)
+			n = nr_cpu_ids;
+		*offset = n + 1;
+		return (void *)(unsigned long)(n + 2);
+	}
+
+#ifdef CONFIG_GENERIC_CLOCKEVENTS
+	if (n == nr_cpu_ids + 1)
+		return (void *)(unsigned long)(nr_cpu_ids + 2);
+
+	if (n < nr_cpu_ids * 2 + 2) {
+		n -= (nr_cpu_ids + 2);
+		n = cpumask_next(n - 1, cpu_online_mask);
+		if (n >= nr_cpu_ids)
+			return NULL;
+		*offset = n + 2 + nr_cpu_ids;
+		return (void *)(unsigned long)(n + 3 + nr_cpu_ids);
+	}
+#endif
+
+	return NULL;
+}
+
+static void *timer_list_next(struct seq_file *file, void *data, loff_t *offset)
+{
+	(*offset)++;
+	return timer_list_start(file, offset);
+}
+
+static void timer_list_stop(struct seq_file *file, void *data)
+{
+}
+
+static const struct seq_operations timer_list_sops = {
+	.start = timer_list_start,
+	.next = timer_list_next,
+	.stop = timer_list_stop,
+	.show = timer_list_show,
+};
+
 void sysrq_timer_list_show(void)
 {
 	timer_list_show(NULL, NULL);
 }
 
+static int timer_list_release(struct inode *inode, struct file *filep)
+{
+	seq_release(inode, filep);
+
+	return 0;
+}
+
 static int timer_list_open(struct inode *inode, struct file *filp)
 {
-	return single_open(filp, timer_list_show, NULL);
+	return seq_open(filp, &timer_list_sops);
 }
 
 static const struct file_operations timer_list_fops = {
 	.open		= timer_list_open,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
-	.release	= single_release,
+	.release	= timer_list_release,
 };
 
 static int __init init_timer_list_procfs(void)
-- 
1.8.1.2

