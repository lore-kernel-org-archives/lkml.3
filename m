Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758010Ab3LWUkS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 15:40:18 -0500
Received: from cantor2.suse.de ([195.135.220.15]:33558 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757931Ab3LWUjz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 15:39:55 -0500
From: Jan Kara <jack@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: pmladek@suse.cz, Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, Jan Kara <jack@suse.cz>
Subject: [PATCH 10/10] printk: debug: Slow down printing to 9600 bauds
Date: Mon, 23 Dec 2013 21:39:31 +0100
Message-Id: <1387831171-5264-11-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1387831171-5264-1-git-send-email-jack@suse.cz>
References: <1387831171-5264-1-git-send-email-jack@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jan Kara <jack@suse.cz>
---
 include/trace/events/printk.h | 42 +++++++++++++++++++++++++++++++++++
 kernel/printk/printk.c        | 51 ++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 92 insertions(+), 1 deletion(-)

diff --git a/include/trace/events/printk.h b/include/trace/events/printk.h
index c008bc99f9fa..2bd0c0e241f7 100644
--- a/include/trace/events/printk.h
+++ b/include/trace/events/printk.h
@@ -22,6 +22,48 @@ TRACE_EVENT(console,
 
 	TP_printk("%s", __get_str(msg))
 );
+
+DECLARE_EVENT_CLASS(printk_class,
+	TP_PROTO(int u),
+	TP_ARGS(u),
+	TP_STRUCT__entry(
+	        __field(        int, u)
+	),
+	TP_fast_assign(
+	        __entry->u       = u;
+	),
+	TP_printk("arg=%d", __entry->u)
+);
+
+DEFINE_EVENT(printk_class, printk_hand_over,
+	TP_PROTO(int u),
+	TP_ARGS(u)
+);
+
+DEFINE_EVENT(printk_class, printk_ask_help,
+	TP_PROTO(int u),
+	TP_ARGS(u)
+);
+
+DEFINE_EVENT(printk_class, printk_send_ipi,
+	TP_PROTO(int u),
+	TP_ARGS(u)
+);
+
+DEFINE_EVENT(printk_class, printk_ipi_received,
+	TP_PROTO(int u),
+	TP_ARGS(u)
+);
+
+DEFINE_EVENT(printk_class, printk_set_wait,
+	TP_PROTO(int u),
+	TP_ARGS(u)
+);
+
+DEFINE_EVENT(printk_class, printk_sem_spin,
+	TP_PROTO(int u),
+	TP_ARGS(u)
+);
 #endif /* _TRACE_PRINTK_H */
 
 /* This part must be outside protection */
diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index 8abbb5373999..e78fe2dc280f 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -1337,6 +1337,15 @@ static void call_console_drivers(int level, const char *text, size_t len)
 	}
 }
 
+static void printk_echo(char *txt)
+{
+	unsigned long flags;
+
+	local_irq_save(flags);
+	call_console_drivers(0, txt, strlen(txt));
+	local_irq_restore(flags);
+}
+
 /*
  * Zap console related locks when oopsing. Only zap at most once
  * every 10 seconds, to leave time for slow consoles to print a
@@ -1406,10 +1415,14 @@ static int console_trylock_for_printk(void)
 		if (hand_over_cpu == cpu)
 			return 0;
 
+		printk_echo("Setting PS_WAITING\n");
+		trace_printk_set_wait(0);
 		state = cmpxchg(&printing_state, PS_HANDOVER, PS_WAITING);
 		if (state != PS_HANDOVER)
 			return 0;
 
+		printk_echo("Spinning on console_sem\n");
+		trace_printk_sem_spin(0);
 		/*
 		 * Since PS_HANDOVER state is set only in console_unlock()
 		 * we shouldn't spin for long here. And we cannot sleep because
@@ -1426,6 +1439,7 @@ static int console_trylock_for_printk(void)
 				return 0;
 			__delay(1);
 		}
+		printk_echo("Got console_sem\n");
 	}
 	/*
 	 * If we can't use the console, we need to release the console
@@ -1574,6 +1588,7 @@ asmlinkage int vprintk_emit(int facility, int level,
 	bool in_sched = false;
 	/* cpu currently holding logbuf_lock in this function */
 	static volatile unsigned int logbuf_cpu = UINT_MAX;
+	bool irq_off = irqs_disabled();
 
 	if (level == -2) {
 		level = -1;
@@ -1628,6 +1643,8 @@ asmlinkage int vprintk_emit(int facility, int level,
 	if (in_sched)
 		text_len = scnprintf(text, sizeof(textbuf),
 				     KERN_WARNING "[sched_delayed] ");
+	if (irq_off)
+		text[text_len++] = 'X';
 
 	text_len += vscnprintf(text + text_len,
 			       sizeof(textbuf) - text_len, fmt, args);
@@ -2094,6 +2111,8 @@ out:
 /* Handler for IPI to take over printing from another CPU */
 static void printk_take_over(void *info)
 {
+	printk_echo("IPI received\n");
+	trace_printk_ipi_received(smp_processor_id());
 	/*
 	 * We have to clear printk_ipi_sent only after we succeed / fail the
 	 * trylock. That way we make sure there is at most one IPI spinning
@@ -2116,13 +2135,17 @@ static void printk_take_over(void *info)
 static bool cpu_stop_printing(int printed_chars)
 {
 	cpumask_var_t mask;
+	char buf[80];
 
 	/* Oops? Print everything now to maximize chances user will see it */
 	if (oops_in_progress)
 		return false;
 	/* Someone is waiting. Stop printing. */
-	if (printing_state == PS_WAITING)
+	if (printing_state == PS_WAITING) {
+		printk_echo("Handing over printing\n");
+		trace_printk_hand_over(0);
 		return true;
+	}
 	if (!printk_offload_chars || printed_chars <= printk_offload_chars)
 		return false;
 	if (printing_state == PS_PRINTING) {
@@ -2130,8 +2153,13 @@ static bool cpu_stop_printing(int printed_chars)
 		/* Paired with smp_rmb() in console_trylock_for_printk() */
 		smp_wmb();
 		printing_state = PS_HANDOVER;
+		printk_echo("Asking for help\n");
+		trace_printk_ask_help(0);
 		return false;
 	}
+
+	sprintf(buf, "Checking IPI: %d %d > %d\n", (int)printk_ipi_sent, printed_chars, 2*printk_offload_chars);
+	printk_echo(buf);
 	/*
 	 * We ping another CPU with IPI only if noone took over printing for a
 	 * long time - we prefer other printk() to take over printing since it
@@ -2140,6 +2168,8 @@ static bool cpu_stop_printing(int printed_chars)
 	if (!printk_ipi_sent && printed_chars > 2 * printk_offload_chars) {
 		struct call_single_data *csd = &hand_over_csd[current_csd];
 
+		trace_printk_send_ipi(hand_over_cpu);
+		printk_echo("Sending IPI\n");
 		/* Ping another cpu to take printing from us */
 		cpumask_copy(mask, cpu_online_mask);
 		cpumask_clear_cpu(hand_over_cpu, mask);
@@ -2245,6 +2275,7 @@ skip:
 		call_console_drivers(level, text, len);
 		start_critical_timings();
 		printed_chars += len;
+		mdelay(len);
 		local_irq_restore(flags);
 	}
 
@@ -2588,9 +2619,27 @@ int unregister_console(struct console *console)
 }
 EXPORT_SYMBOL(unregister_console);
 
+void do_print(struct work_struct *work)
+{
+	char buf[75];
+	int i;
+
+	sprintf(buf, "%p: aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa\n", work);
+	for (i = 0; i < 15; i++)
+		printk(buf);
+}
+
+static struct delayed_work print_work[100];
+
 static int __init printk_late_init(void)
 {
 	struct console *con;
+	int i;
+
+	for (i = 0; i < 100; i++) {
+		INIT_DELAYED_WORK(&print_work[i], do_print);
+		schedule_delayed_work(&print_work[i], HZ * 180);
+	}
 
 	for_each_console(con) {
 		if (!keep_bootcon && con->flags & CON_BOOT) {
-- 
1.8.1.4

