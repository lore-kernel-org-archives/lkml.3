Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756351AbaCYR56 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 13:57:58 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58455 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756211AbaCYRzU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 13:55:20 -0400
From: Jan Kara <jack@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, pmladek@suse.cz,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>, Jan Kara <jack@suse.cz>
Subject: [PATCH 7/8] kernel: Avoid softlockups in stop_machine() during heavy printing
Date: Tue, 25 Mar 2014 18:55:00 +0100
Message-Id: <1395770101-24534-8-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1395770101-24534-1-git-send-email-jack@suse.cz>
References: <1395770101-24534-1-git-send-email-jack@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When there are lots of messages accumulated in printk buffer, printing
them (especially over serial console) can take a long time (tens of
seconds). stop_machine() will effectively make all cpus spin in
multi_cpu_stop() waiting for the CPU doing printing to print all the
messages which triggers NMI softlockup watchdog and RCU stall detector
which add even more to the messages to print. Since machine doesn't do
anything (except serving interrupts) during this time, also network
connections are dropped and other disturbances may happen.

Paper over the problem by waiting for printk buffer to be empty before
starting to stop CPUs. In theory a burst of new messages can be appended
to the printk buffer before CPUs enter multi_cpu_stop() so this isn't a 100%
solution but it works OK in practice and I'm not aware of a reasonably
simple better solution.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 include/linux/console.h |  1 +
 kernel/printk/printk.c  | 22 ++++++++++++++++++++++
 kernel/stop_machine.c   |  9 +++++++++
 3 files changed, 32 insertions(+)

diff --git a/include/linux/console.h b/include/linux/console.h
index 7571a16bd653..c61c169f85b3 100644
--- a/include/linux/console.h
+++ b/include/linux/console.h
@@ -150,6 +150,7 @@ extern int console_trylock(void);
 extern void console_unlock(void);
 extern void console_conditional_schedule(void);
 extern void console_unblank(void);
+extern void console_flush(void);
 extern struct tty_driver *console_device(int *);
 extern void console_stop(struct console *);
 extern void console_start(struct console *);
diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index 8d981b2b5bb1..1c0577383af5 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -2306,6 +2306,28 @@ struct tty_driver *console_device(int *index)
 }
 
 /*
+ * Wait until all messages accumulated in the printk buffer are printed to
+ * console. Note that as soon as this function returns, new messages may be
+ * added to the printk buffer by other CPUs.
+ */
+void console_flush(void)
+{
+	bool retry;
+	unsigned long flags;
+
+	while (1) {
+		raw_spin_lock_irqsave(&logbuf_lock, flags);
+		retry = console_seq != log_next_seq;
+		raw_spin_unlock_irqrestore(&logbuf_lock, flags);
+		if (!retry || console_suspended)
+			break;
+		/* Cycle console_sem to wait for outstanding printing */
+		console_lock();
+		console_unlock();
+	}
+}
+
+/*
  * Prevent further output on the passed console device so that (for example)
  * serial drivers can disable console output before suspending a port, and can
  * re-enable output afterwards.
diff --git a/kernel/stop_machine.c b/kernel/stop_machine.c
index 84571e09c907..14ac740e0c7f 100644
--- a/kernel/stop_machine.c
+++ b/kernel/stop_machine.c
@@ -21,6 +21,7 @@
 #include <linux/smpboot.h>
 #include <linux/atomic.h>
 #include <linux/lglock.h>
+#include <linux/console.h>
 
 /*
  * Structure to determine completion condition and record errors.  May
@@ -574,6 +575,14 @@ int __stop_machine(int (*fn)(void *), void *data, const struct cpumask *cpus)
 		return ret;
 	}
 
+	/*
+	 * If there are lots of outstanding messages, printing them can take a
+	 * long time and all cpus would be spinning waiting for the printing to
+	 * finish thus triggering NMI watchdog, RCU lockups etc. Wait for the
+	 * printing here to avoid these.
+	 */
+	console_flush();
+
 	/* Set the initial state and stop all online cpus. */
 	set_state(&msdata, MULTI_STOP_PREPARE);
 	return stop_cpus(cpu_online_mask, multi_cpu_stop, &msdata);
-- 
1.8.1.4

