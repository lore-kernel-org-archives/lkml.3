Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751291AbaDYAsg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 20:48:36 -0400
Received: from imx12.toshiba.co.jp ([61.202.160.132]:39489 "EHLO
	imx12.toshiba.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750717AbaDYAsf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 20:48:35 -0400
From: Daniel Sangorrin <daniel.sangorrin@toshiba.co.jp>
To: tglx@linutronix.de, rdunlap@infradead.org, john.stultz@linaro.org
Cc: linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        viresh.kumar@linaro.org
Subject: [PATCH v2] timer_stats: add core information to event counters
Date: Fri, 25 Apr 2014 09:47:55 +0900
Message-Id: <1398386875-11998-1-git-send-email-daniel.sangorrin@toshiba.co.jp>
X-Mailer: git-send-email 1.8.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add information specifying the CPU core where timer callbacks (events)
were executed to the output of /proc/timer_stats.

Signed-off-by: Daniel Sangorrin <daniel.sangorrin@toshiba.co.jp>
Signed-off-by: Yoshitake Kobayashi <yoshitake.kobayashi@toshiba.co.jp>
---
 Documentation/timers/timer_stats.txt | 43 ++++++++++++++++++++----------------
 kernel/time/timer_stats.c            | 20 +++++++++--------
 2 files changed, 35 insertions(+), 28 deletions(-)

diff --git a/Documentation/timers/timer_stats.txt b/Documentation/timers/timer_stats.txt
index 8abd40b..aeb467f 100644
--- a/Documentation/timers/timer_stats.txt
+++ b/Documentation/timers/timer_stats.txt
@@ -21,7 +21,7 @@ Linux system over a sample period:
 - the name of the process which initialized the timer
 - the function where the timer was initialized
 - the callback function which is associated to the timer
-- the number of events (callbacks)
+- the number of events (callbacks) executed per core
 
 timer_stats adds an entry to /proc: /proc/timer_stats
 
@@ -45,24 +45,29 @@ readouts.
 
 Sample output of /proc/timer_stats:
 
-Timerstats sample period: 3.888770 s
-  12,     0 swapper          hrtimer_stop_sched_tick (hrtimer_sched_tick)
-  15,     1 swapper          hcd_submit_urb (rh_timer_func)
-   4,   959 kedac            schedule_timeout (process_timeout)
-   1,     0 swapper          page_writeback_init (wb_timer_fn)
-  28,     0 swapper          hrtimer_stop_sched_tick (hrtimer_sched_tick)
-  22,  2948 IRQ 4            tty_flip_buffer_push (delayed_work_timer_fn)
-   3,  3100 bash             schedule_timeout (process_timeout)
-   1,     1 swapper          queue_delayed_work_on (delayed_work_timer_fn)
-   1,     1 swapper          queue_delayed_work_on (delayed_work_timer_fn)
-   1,     1 swapper          neigh_table_init_no_netlink (neigh_periodic_timer)
-   1,  2292 ip               __netdev_watchdog_up (dev_watchdog)
-   1,    23 events/1         do_cache_clean (delayed_work_timer_fn)
-90 total events, 30.0 events/sec
-
-The first column is the number of events, the second column the pid, the third
-column is the name of the process. The forth column shows the function which
-initialized the timer and in parenthesis the callback function which was
+Timer Stats Version: v0.3
+Sample period: 4.365 s
+Collection: inactive
+     0,   4366,     0 swapper/1        tick_setup_sched_timer (tick_sched_timer)
+  4366,      0,     1 swapper/0        tick_setup_sched_timer (tick_sched_timer)
+     0,      5,  1132 sshd             sk_reset_timer (tcp_write_timer)
+     0,      4,   515 apache2          schedule_hrtimeout_range_clock (hrtimer_wakeup)
+    16,      0,     0 swapper/0        usb_hcd_poll_rh_status (rh_timer_func)
+    16,      0,     0 swapper/0        usb_hcd_poll_rh_status (rh_timer_func)
+    16,      0,     0 swapper/0        usb_hcd_poll_rh_status (rh_timer_func)
+    16,      0,     0 swapper/0        usb_hcd_poll_rh_status (rh_timer_func)
+    16,      0,     0 swapper/0        usb_hcd_poll_rh_status (rh_timer_func)
+     0,      7,     0 swapper/1        sk_reset_timer (tcp_delack_timer)
+     3,      4,     0 swapper/0        clocksource_watchdog (clocksource_watchdog)
+    0D,     3D,    13 kworker/1:0      queue_delayed_work_on (delayed_work_timer_fn)
+    3D,     0D,    22 kworker/0:1      queue_delayed_work_on (delayed_work_timer_fn)
+     1,      0,    22 kworker/0:1      e1000_watchdog_task (e1000_watchdog)
+8842 total events, 2025.658 events/sec
+
+The first comma-separated columns represent the number of events (one
+column per present core), the next column the pid, and the next one is the
+name of the process. The last column shows the function which
+initialized the timer and in parentheses the callback function which was
 executed on expiry.
 
     Thomas, Ingo
diff --git a/kernel/time/timer_stats.c b/kernel/time/timer_stats.c
index 1fb08f2..53d1544 100644
--- a/kernel/time/timer_stats.c
+++ b/kernel/time/timer_stats.c
@@ -67,7 +67,7 @@ struct entry {
 	/*
 	 * Number of timeout events:
 	 */
-	unsigned long		count;
+	unsigned long		count[NR_CPUS];
 	unsigned int		timer_flag;
 
 	/*
@@ -203,7 +203,7 @@ static struct entry *tstat_lookup(struct entry *entry, char *comm)
 	curr = alloc_entry();
 	if (curr) {
 		*curr = *entry;
-		curr->count = 0;
+		memset(curr->count, 0, sizeof(curr->count));
 		curr->next = NULL;
 		memcpy(curr->comm, comm, TASK_COMM_LEN);
 
@@ -259,7 +259,7 @@ void timer_stats_update_stats(void *timer, pid_t pid, void *startf,
 
 	entry = tstat_lookup(&input, comm);
 	if (likely(entry))
-		entry->count++;
+		entry->count[raw_smp_processor_id()]++;
 	else
 		atomic_inc(&overflow_count);
 
@@ -284,7 +284,7 @@ static int tstats_show(struct seq_file *m, void *v)
 	unsigned long ms;
 	long events = 0;
 	ktime_t time;
-	int i;
+	int i, cpu;
 
 	mutex_lock(&show_mutex);
 	/*
@@ -307,19 +307,21 @@ static int tstats_show(struct seq_file *m, void *v)
 	for (i = 0; i < nr_entries; i++) {
 		entry = entries + i;
 		if (entry->timer_flag & TIMER_STATS_FLAG_DEFERRABLE) {
-			seq_printf(m, "%4luD, %5d %-16s ",
-				entry->count, entry->pid, entry->comm);
+			for_each_present_cpu(cpu)
+				seq_printf(m, "%5luD, ", entry->count[cpu]);
 		} else {
-			seq_printf(m, " %4lu, %5d %-16s ",
-				entry->count, entry->pid, entry->comm);
+			for_each_present_cpu(cpu)
+				seq_printf(m, " %5lu, ", entry->count[cpu]);
 		}
+		seq_printf(m, "%5d %-16s ", entry->pid, entry->comm);
 
 		print_name_offset(m, (unsigned long)entry->start_func);
 		seq_puts(m, " (");
 		print_name_offset(m, (unsigned long)entry->expire_func);
 		seq_puts(m, ")\n");
 
-		events += entry->count;
+		for_each_present_cpu(cpu)
+			events += entry->count[cpu];
 	}
 
 	ms += period.tv_sec * 1000;
-- 
1.8.1.1

