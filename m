Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757244Ab3AOVqR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 16:46:17 -0500
Received: from relay1.sgi.com ([192.48.179.29]:35549 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752637Ab3AOVqO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 16:46:14 -0500
From: Nathan Zimmer <nzimmer@sgi.com>
To: mingo@redhat.com, peterz@infradead.org, tglx@linutronix.de,
        johnstul@us.ibm.com
Cc: linux-kernel@vger.kernel.org, Nathan Zimmer <nzimmer@sgi.com>
Subject: [PATCH RESEND 3/4] timer_list: split timer_list_show_tickdevices
Date: Tue, 15 Jan 2013 15:46:11 -0600
Message-Id: <1358286372-13777-4-git-send-email-nzimmer@sgi.com>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1358286372-13777-1-git-send-email-nzimmer@sgi.com>
References: <1358286372-13777-1-git-send-email-nzimmer@sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Split timer_list_show_tickdevices out the header and just pull the rest up
to timer_list_show.  Also tweak the location of the whitespace.  This is all
to prep for the fix.

CC: John Stultz <johnstul@us.ibm.com>
CC: Thomas Gleixner <tglx@linutronix.de>
Reported-by: Dave Jones <davej@redhat.com>
Signed-off-by: Nathan Zimmer <nzimmer@sgi.com>
---
 kernel/time/timer_list.c |   20 +++++++++-----------
 1 files changed, 9 insertions(+), 11 deletions(-)

diff --git a/kernel/time/timer_list.c b/kernel/time/timer_list.c
index af5a7e9..b3dc3d6 100644
--- a/kernel/time/timer_list.c
+++ b/kernel/time/timer_list.c
@@ -133,7 +133,6 @@ static void print_cpu(struct seq_file *m, int cpu, u64 now)
 	struct hrtimer_cpu_base *cpu_base = &per_cpu(hrtimer_bases, cpu);
 	int i;
 
-	SEQ_printf(m, "\n");
 	SEQ_printf(m, "cpu: %d\n", cpu);
 	for (i = 0; i < HRTIMER_MAX_CLOCK_BASES; i++) {
 		SEQ_printf(m, " clock %d:\n", i);
@@ -187,6 +186,7 @@ static void print_cpu(struct seq_file *m, int cpu, u64 now)
 
 #undef P
 #undef P_ns
+	SEQ_printf(m, "\n");
 }
 
 #ifdef CONFIG_GENERIC_CLOCKEVENTS
@@ -195,7 +195,6 @@ print_tickdevice(struct seq_file *m, struct tick_device *td, int cpu)
 {
 	struct clock_event_device *dev = td->evtdev;
 
-	SEQ_printf(m, "\n");
 	SEQ_printf(m, "Tick Device: mode:     %d\n", td->mode);
 	if (cpu < 0)
 		SEQ_printf(m, "Broadcast device\n");
@@ -230,12 +229,11 @@ print_tickdevice(struct seq_file *m, struct tick_device *td, int cpu)
 	print_name_offset(m, dev->event_handler);
 	SEQ_printf(m, "\n");
 	SEQ_printf(m, " retries:        %lu\n", dev->retries);
+	SEQ_printf(m, "\n");
 }
 
-static void timer_list_show_tickdevices(struct seq_file *m)
+static void timer_list_show_tickdevices_header(struct seq_file *m)
 {
-	int cpu;
-
 #ifdef CONFIG_GENERIC_CLOCKEVENTS_BROADCAST
 	print_tickdevice(m, tick_get_broadcast_device(), -1);
 	SEQ_printf(m, "tick_broadcast_mask: %08lx\n",
@@ -246,12 +244,8 @@ static void timer_list_show_tickdevices(struct seq_file *m)
 #endif
 	SEQ_printf(m, "\n");
 #endif
-	for_each_online_cpu(cpu)
-		print_tickdevice(m, tick_get_device(cpu), cpu);
 	SEQ_printf(m, "\n");
 }
-#else
-static void timer_list_show_tickdevices(struct seq_file *m) { }
 #endif
 
 static int timer_list_show(struct seq_file *m, void *v)
@@ -262,12 +256,16 @@ static int timer_list_show(struct seq_file *m, void *v)
 	SEQ_printf(m, "Timer List Version: v0.7\n");
 	SEQ_printf(m, "HRTIMER_MAX_CLOCK_BASES: %d\n", HRTIMER_MAX_CLOCK_BASES);
 	SEQ_printf(m, "now at %Ld nsecs\n", (unsigned long long)now);
+	SEQ_printf(m, "\n");
 
 	for_each_online_cpu(cpu)
 		print_cpu(m, cpu, now);
 
-	SEQ_printf(m, "\n");
-	timer_list_show_tickdevices(m);
+#ifdef CONFIG_GENERIC_CLOCKEVENTS
+	timer_list_show_tickdevices_header(m);
+	for_each_online_cpu(cpu)
+		print_tickdevice(m, tick_get_device(cpu), cpu);
+#endif
 
 	return 0;
 }
-- 
1.6.0.2

