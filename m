Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755496Ab3C0A4o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 20:56:44 -0400
Received: from relay3.sgi.com ([192.48.152.1]:33225 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755340Ab3C0A4h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 20:56:37 -0400
From: Nathan Zimmer <nzimmer@sgi.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        Nathan Zimmer <nzimmer@sgi.com>, John Stultz <johnstul@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Stephen Boyd <sboyd@codeaurora.org>
Subject: [PATCH 2/2] timer_list: convert timer list to be a proper seq_file
Date: Tue, 26 Mar 2013 19:56:30 -0500
Message-Id: <1364345790-14577-3-git-send-email-nzimmer@sgi.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1364345790-14577-1-git-send-email-nzimmer@sgi.com>
References: <alpine.LFD.2.02.1303251651200.22263@ionos>
 <1364345790-14577-1-git-send-email-nzimmer@sgi.com>
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

sysrq_timer_list_show also needed to be updated to reflect the fact that
now timer_list_show only does one cpu at at time.

Signed-off-by: Nathan Zimmer <nzimmer@sgi.com>
Reported-by: Dave Jones <davej@redhat.com>
Cc: John Stultz <johnstul@us.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Stephen Boyd <sboyd@codeaurora.org>

v2: Added comments on the iteration and other fixups pointed to by Andrew.
v3: Corrected the case where max_cpus != nr_cpu_ids by exiting early.
v5: Use seq_open_private and supply a proper iterator rather then a big mess.
---
 kernel/time/timer_list.c | 89 +++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 77 insertions(+), 12 deletions(-)

diff --git a/kernel/time/timer_list.c b/kernel/time/timer_list.c
index 380a589..3bdf283 100644
--- a/kernel/time/timer_list.c
+++ b/kernel/time/timer_list.c
@@ -20,6 +20,13 @@
 
 #include <asm/uaccess.h>
 
+
+struct timer_list_iter {
+	int cpu;
+	bool second_pass;
+	u64 now;
+};
+
 typedef void (*print_fn_t)(struct seq_file *m, unsigned int *classes);
 
 DECLARE_PER_CPU(struct hrtimer_cpu_base, hrtimer_bases);
@@ -247,43 +254,101 @@ static void timer_list_show_tickdevices_header(struct seq_file *m)
 }
 #endif
 
-static int timer_list_show(struct seq_file *m, void *v)
+static inline void timer_list_header(struct seq_file *m, u64 now)
 {
-	u64 now = ktime_to_ns(ktime_get());
-	int cpu;
-
 	SEQ_printf(m, "Timer List Version: v0.7\n");
 	SEQ_printf(m, "HRTIMER_MAX_CLOCK_BASES: %d\n", HRTIMER_MAX_CLOCK_BASES);
 	SEQ_printf(m, "now at %Ld nsecs\n", (unsigned long long)now);
 	SEQ_printf(m, "\n");
+}
+
+static int timer_list_show(struct seq_file *m, void *v)
+{
+	struct timer_list_iter *iter = v;
+	u64 now = ktime_to_ns(ktime_get());
+
+	if (iter->cpu == -1 && !iter->second_pass)
+		timer_list_header(m, now);
+	else if (!iter->second_pass)
+		print_cpu(m, iter->cpu, iter->now);
+#ifdef CONFIG_GENERIC_CLOCKEVENTS
+	else if (iter->cpu == -1 && iter->second_pass)
+		timer_list_show_tickdevices_header(m);
+	else
+		print_tickdevice(m, tick_get_device(iter->cpu), iter->cpu);
+#endif
+	return 0;
+}
+
+void sysrq_timer_list_show(void)
+{
+	u64 now = ktime_to_ns(ktime_get());
+	int cpu;
+
+	timer_list_header(NULL, now);
 
 	for_each_online_cpu(cpu)
-		print_cpu(m, cpu, now);
+		print_cpu(NULL, cpu, now);
 
 #ifdef CONFIG_GENERIC_CLOCKEVENTS
-	timer_list_show_tickdevices_header(m);
+	timer_list_show_tickdevices_header(NULL);
 	for_each_online_cpu(cpu)
-		print_tickdevice(m, tick_get_device(cpu), cpu);
+		print_tickdevice(NULL, tick_get_device(cpu), cpu);
 #endif
+	return;
+}
 
-	return 0;
+static void *timer_list_start(struct seq_file *file, loff_t *offset)
+{
+	struct timer_list_iter *iter = file->private;
+
+	if (!*offset) {
+		iter->cpu = -1;
+		iter->now = ktime_to_ns(ktime_get());
+	} else if (iter->cpu >= nr_cpu_ids) {
+#ifdef CONFIG_GENERIC_CLOCKEVENTS
+		if (!iter->second_pass) {
+			iter->cpu = -1;
+			iter->second_pass = true;
+		} else
+			return NULL;
+#else
+		return NULL;
+#endif
+	}
+	return iter;
 }
 
-void sysrq_timer_list_show(void)
+static void *timer_list_next(struct seq_file *file, void *v, loff_t *offset)
 {
-	timer_list_show(NULL, NULL);
+	struct timer_list_iter *iter = file->private;
+	iter->cpu = cpumask_next(iter->cpu, cpu_online_mask);
+	++*offset;
+	return timer_list_start(file, offset);
 }
 
+static void timer_list_stop(struct seq_file *seq, void *v)
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
 static int timer_list_open(struct inode *inode, struct file *filp)
 {
-	return single_open(filp, timer_list_show, NULL);
+	return seq_open_private(filp, &timer_list_sops,
+			sizeof(struct timer_list_iter));
 }
 
 static const struct file_operations timer_list_fops = {
 	.open		= timer_list_open,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
-	.release	= single_release,
+	.release	= seq_release_private,
 };
 
 static int __init init_timer_list_procfs(void)
-- 
1.8.1.2

