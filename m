Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161549Ab3DKNa7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 09:30:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32044 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161287Ab3DKNa5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 09:30:57 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH 24/26] cris: Don't use create_proc_read_entry() [RFC]
To: linux-kernel@vger.kernel.org
From: David Howells <dhowells@redhat.com>
Cc: Mikael Starvik <starvik@axis.com>,
        Jesper Nilsson <jesper.nilsson@axis.com>, viro@ZenIV.linux.org.uk,
        linux-cris-kernel@axis.com
Date: Thu, 11 Apr 2013 14:30:47 +0100
Message-ID: <20130411133047.32763.25315.stgit@warthog.procyon.org.uk>
In-Reply-To: <20130411132739.32763.82609.stgit@warthog.procyon.org.uk>
References: <20130411132739.32763.82609.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't use create_proc_read_entry() as that is deprecated, but rather use
proc_create_data() and seq_file instead.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Mikael Starvik <starvik@axis.com>
cc: Jesper Nilsson <jesper.nilsson@axis.com>
cc: linux-cris-kernel@axis.com
---

 arch/cris/arch-v10/kernel/fasttimer.c |  299 +++++++++++++++------------------
 arch/cris/arch-v32/kernel/fasttimer.c |  296 +++++++++++++++------------------
 2 files changed, 265 insertions(+), 330 deletions(-)

diff --git a/arch/cris/arch-v10/kernel/fasttimer.c b/arch/cris/arch-v10/kernel/fasttimer.c
index 52bb9b5..ce6f512 100644
--- a/arch/cris/arch-v10/kernel/fasttimer.c
+++ b/arch/cris/arch-v10/kernel/fasttimer.c
@@ -25,6 +25,7 @@
 #include <arch/svinto.h>
 #include <asm/fasttimer.h>
 #include <linux/proc_fs.h>
+#include <linux/seq_file.h>
 
 
 #define DEBUG_LOG_INCLUDED
@@ -489,196 +490,162 @@ void schedule_usleep(unsigned long us)
 }
 
 #ifdef CONFIG_PROC_FS
-static int proc_fasttimer_read(char *buf, char **start, off_t offset, int len
-                       ,int *eof, void *data_unused);
-#endif /* CONFIG_PROC_FS */
-
-#ifdef CONFIG_PROC_FS
-
 /* This value is very much based on testing */
 #define BIG_BUF_SIZE (500 + NUM_TIMER_STATS * 300)
 
-static int proc_fasttimer_read(char *buf, char **start, off_t offset, int len
-                       ,int *eof, void *data_unused)
+static int proc_fasttimer_show(struct seq_file *m, void *v)
 {
-  unsigned long flags;
-  int i = 0;
-  int num_to_show;
+	unsigned long flags;
+	int i = 0;
+	int num_to_show;
 	struct fasttime_t tv;
-  struct fast_timer *t, *nextt;
-  static char *bigbuf = NULL;
-  static unsigned long used;
-
-  if (!bigbuf && !(bigbuf = vmalloc(BIG_BUF_SIZE)))
-  {
-    used = 0;
-	if (buf)
-		buf[0] = '\0';
-    return 0;
-  }
-
-  if (!offset || !used)
-  {
-    do_gettimeofday_fast(&tv);
-
-    used = 0;
-    used += sprintf(bigbuf + used, "Fast timers added:     %i\n",
-                    fast_timers_added);
-    used += sprintf(bigbuf + used, "Fast timers started:   %i\n",
-                    fast_timers_started);
-    used += sprintf(bigbuf + used, "Fast timer interrupts: %i\n",
-                    fast_timer_ints);
-    used += sprintf(bigbuf + used, "Fast timers expired:   %i\n",
-                    fast_timers_expired);
-    used += sprintf(bigbuf + used, "Fast timers deleted:   %i\n",
-                    fast_timers_deleted);
-    used += sprintf(bigbuf + used, "Fast timer running:    %s\n",
-                    fast_timer_running ? "yes" : "no");
-    used += sprintf(bigbuf + used, "Current time:          %lu.%06lu\n",
-			(unsigned long)tv.tv_jiff,
-                    (unsigned long)tv.tv_usec);
+	struct fast_timer *t, *nextt;
+
+	do_gettimeofday_fast(&tv);
+
+	seq_printf(m, "Fast timers added:     %i\n", fast_timers_added);
+	seq_printf(m, "Fast timers started:   %i\n", fast_timers_started);
+	seq_printf(m, "Fast timer interrupts: %i\n", fast_timer_ints);
+	seq_printf(m, "Fast timers expired:   %i\n", fast_timers_expired);
+	seq_printf(m, "Fast timers deleted:   %i\n", fast_timers_deleted);
+	seq_printf(m, "Fast timer running:    %s\n",
+		   fast_timer_running ? "yes" : "no");
+	seq_printf(m, "Current time:          %lu.%06lu\n",
+		   (unsigned long)tv.tv_jiff,
+		   (unsigned long)tv.tv_usec);
 #ifdef FAST_TIMER_SANITY_CHECKS
-    used += sprintf(bigbuf + used, "Sanity failed:         %i\n",
-                    sanity_failed);
+	seq_printf(m, "Sanity failed:         %i\n", sanity_failed);
 #endif
-    used += sprintf(bigbuf + used, "\n");
+	seq_putc(m, '\n');
 
 #ifdef DEBUG_LOG_INCLUDED
-    {
-      int end_i = debug_log_cnt;
-      i = 0;
-
-      if (debug_log_cnt_wrapped)
-      {
-        i = debug_log_cnt;
-      }
-
-      while ((i != end_i || (debug_log_cnt_wrapped && !used)) &&
-             used+100 < BIG_BUF_SIZE)
-      {
-        used += sprintf(bigbuf + used, debug_log_string[i],
-                        debug_log_value[i]);
-        i = (i+1) % DEBUG_LOG_MAX;
-      }
-    }
-    used += sprintf(bigbuf + used, "\n");
+	{
+		int end_i = debug_log_cnt;
+		i = 0;
+
+		if (debug_log_cnt_wrapped)
+			i = debug_log_cnt;
+
+		while (i != end_i || debug_log_cnt_wrapped) {
+			if (seq_printf(m, debug_log_string[i], debug_log_value[i]) < 0)
+				return 0;
+			i = (i+1) % DEBUG_LOG_MAX;
+		}
+	}
+	seq_putc(m, '\n');
 #endif
 
-    num_to_show = (fast_timers_started < NUM_TIMER_STATS ? fast_timers_started:
-                   NUM_TIMER_STATS);
-    used += sprintf(bigbuf + used, "Timers started: %i\n", fast_timers_started);
-    for (i = 0; i < num_to_show && (used+100 < BIG_BUF_SIZE) ; i++)
-    {
-      int cur = (fast_timers_started - i - 1) % NUM_TIMER_STATS;
+	num_to_show = (fast_timers_started < NUM_TIMER_STATS ? fast_timers_started:
+		       NUM_TIMER_STATS);
+	seq_printf(m, "Timers started: %i\n", fast_timers_started);
+	for (i = 0; i < num_to_show; i++) {
+		int cur = (fast_timers_started - i - 1) % NUM_TIMER_STATS;
 
 #if 1 //ndef FAST_TIMER_LOG
-      used += sprintf(bigbuf + used, "div: %i freq: %i delay: %i"
-                      "\n",
-                      timer_div_settings[cur],
-                      timer_freq_settings[cur],
-                      timer_delay_settings[cur]
-                      );
+		seq_printf(m, "div: %i freq: %i delay: %i"
+			   "\n",
+			   timer_div_settings[cur],
+			   timer_freq_settings[cur],
+			   timer_delay_settings[cur]);
 #endif
 #ifdef FAST_TIMER_LOG
-      t = &timer_started_log[cur];
-      used += sprintf(bigbuf + used, "%-14s s: %6lu.%06lu e: %6lu.%06lu "
-                      "d: %6li us data: 0x%08lX"
-                      "\n",
-                      t->name,
-			(unsigned long)t->tv_set.tv_jiff,
-                      (unsigned long)t->tv_set.tv_usec,
-			(unsigned long)t->tv_expires.tv_jiff,
-                      (unsigned long)t->tv_expires.tv_usec,
-                      t->delay_us,
-                      t->data
-                      );
+		t = &timer_started_log[cur];
+		if (seq_printf(m, "%-14s s: %6lu.%06lu e: %6lu.%06lu "
+			       "d: %6li us data: 0x%08lX"
+			       "\n",
+			       t->name,
+			       (unsigned long)t->tv_set.tv_jiff,
+			       (unsigned long)t->tv_set.tv_usec,
+			       (unsigned long)t->tv_expires.tv_jiff,
+			       (unsigned long)t->tv_expires.tv_usec,
+			       t->delay_us,
+			       t->data) < 0)
+			return 0;
 #endif
-    }
-    used += sprintf(bigbuf + used, "\n");
+	}
+	seq_putc(m, '\n');
 
 #ifdef FAST_TIMER_LOG
-    num_to_show = (fast_timers_added < NUM_TIMER_STATS ? fast_timers_added:
-                   NUM_TIMER_STATS);
-    used += sprintf(bigbuf + used, "Timers added: %i\n", fast_timers_added);
-    for (i = 0; i < num_to_show && (used+100 < BIG_BUF_SIZE); i++)
-    {
-      t = &timer_added_log[(fast_timers_added - i - 1) % NUM_TIMER_STATS];
-      used += sprintf(bigbuf + used, "%-14s s: %6lu.%06lu e: %6lu.%06lu "
-                      "d: %6li us data: 0x%08lX"
-                      "\n",
-                      t->name,
-			(unsigned long)t->tv_set.tv_jiff,
-                      (unsigned long)t->tv_set.tv_usec,
-			(unsigned long)t->tv_expires.tv_jiff,
-                      (unsigned long)t->tv_expires.tv_usec,
-                      t->delay_us,
-                      t->data
-                      );
-    }
-    used += sprintf(bigbuf + used, "\n");
-
-    num_to_show = (fast_timers_expired < NUM_TIMER_STATS ? fast_timers_expired:
-                   NUM_TIMER_STATS);
-    used += sprintf(bigbuf + used, "Timers expired: %i\n", fast_timers_expired);
-    for (i = 0; i < num_to_show && (used+100 < BIG_BUF_SIZE); i++)
-    {
-      t = &timer_expired_log[(fast_timers_expired - i - 1) % NUM_TIMER_STATS];
-      used += sprintf(bigbuf + used, "%-14s s: %6lu.%06lu e: %6lu.%06lu "
-                      "d: %6li us data: 0x%08lX"
-                      "\n",
-                      t->name,
-			(unsigned long)t->tv_set.tv_jiff,
-                      (unsigned long)t->tv_set.tv_usec,
-			(unsigned long)t->tv_expires.tv_jiff,
-                      (unsigned long)t->tv_expires.tv_usec,
-                      t->delay_us,
-                      t->data
-                      );
-    }
-    used += sprintf(bigbuf + used, "\n");
+	num_to_show = (fast_timers_added < NUM_TIMER_STATS ? fast_timers_added:
+		       NUM_TIMER_STATS);
+	seq_printf(m, "Timers added: %i\n", fast_timers_added);
+	for (i = 0; i < num_to_show; i++) {
+		t = &timer_added_log[(fast_timers_added - i - 1) % NUM_TIMER_STATS];
+		if (seq_printf(m, "%-14s s: %6lu.%06lu e: %6lu.%06lu "
+			       "d: %6li us data: 0x%08lX"
+			       "\n",
+			       t->name,
+			       (unsigned long)t->tv_set.tv_jiff,
+			       (unsigned long)t->tv_set.tv_usec,
+			       (unsigned long)t->tv_expires.tv_jiff,
+			       (unsigned long)t->tv_expires.tv_usec,
+			       t->delay_us,
+			       t->data) < 0)
+			return 0;
+	}
+	seq_putc(m, '\n');
+
+	num_to_show = (fast_timers_expired < NUM_TIMER_STATS ? fast_timers_expired:
+		       NUM_TIMER_STATS);
+	seq_printf(m, "Timers expired: %i\n", fast_timers_expired);
+	for (i = 0; i < num_to_show; i++) {
+		t = &timer_expired_log[(fast_timers_expired - i - 1) % NUM_TIMER_STATS];
+		if (seq_printf(m, "%-14s s: %6lu.%06lu e: %6lu.%06lu "
+			       "d: %6li us data: 0x%08lX"
+			       "\n",
+			       t->name,
+			       (unsigned long)t->tv_set.tv_jiff,
+			       (unsigned long)t->tv_set.tv_usec,
+			       (unsigned long)t->tv_expires.tv_jiff,
+			       (unsigned long)t->tv_expires.tv_usec,
+			       t->delay_us,
+			       t->data) < 0)
+			return 0;
+	}
+	seq_putc(m, '\n');
 #endif
 
-    used += sprintf(bigbuf + used, "Active timers:\n");
-    local_irq_save(flags);
-    t = fast_timer_list;
-    while (t != NULL && (used+100 < BIG_BUF_SIZE))
-    {
-      nextt = t->next;
-      local_irq_restore(flags);
-      used += sprintf(bigbuf + used, "%-14s s: %6lu.%06lu e: %6lu.%06lu "
-                      "d: %6li us data: 0x%08lX"
+	seq_puts(m, "Active timers:\n");
+	local_irq_save(flags);
+	t = fast_timer_list;
+	while (t) {
+		nextt = t->next;
+		local_irq_restore(flags);
+		if (seq_printf(m, "%-14s s: %6lu.%06lu e: %6lu.%06lu "
+			       "d: %6li us data: 0x%08lX"
 /*                      " func: 0x%08lX" */
-                      "\n",
-                      t->name,
-			(unsigned long)t->tv_set.tv_jiff,
-                      (unsigned long)t->tv_set.tv_usec,
-			(unsigned long)t->tv_expires.tv_jiff,
-                      (unsigned long)t->tv_expires.tv_usec,
-                      t->delay_us,
-                      t->data
+			       "\n",
+			       t->name,
+			       (unsigned long)t->tv_set.tv_jiff,
+			       (unsigned long)t->tv_set.tv_usec,
+			       (unsigned long)t->tv_expires.tv_jiff,
+			       (unsigned long)t->tv_expires.tv_usec,
+			       t->delay_us,
+			       t->data
 /*                      , t->function */
-                      );
-	local_irq_save(flags);
-      if (t->next != nextt)
-      {
-        printk(KERN_WARNING "timer removed!\n");
-      }
-      t = nextt;
-    }
-    local_irq_restore(flags);
-  }
-
-  if (used - offset < len)
-  {
-    len = used - offset;
-  }
+			       ) < 0)
+			return 0;
+		local_irq_save(flags);
+		if (t->next != nextt)
+			printk(KERN_WARNING "timer removed!\n");
+		t = nextt;
+	}
+	local_irq_restore(flags);
 
-  memcpy(buf, bigbuf + offset, len);
-  *start = buf;
-  *eof = 1;
+	return 0;
+}
 
-  return len;
+static int proc_fasttimer_open(struct inode *inode, struct file *file)
+{
+	return single_open_size(file, proc_fasttimer_show, PDE_DATA(inode), BIG_BUF_SIZE);
 }
+
+static const struct file_operations proc_fasttimer_fops = {
+	.open		= proc_fasttimer_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= seq_release,
+};
 #endif /* PROC_FS */
 
 #ifdef FAST_TIMER_TEST
@@ -856,7 +823,7 @@ int fast_timer_init(void)
     }
 #endif
 #ifdef CONFIG_PROC_FS
-   create_proc_read_entry("fasttimer", 0, NULL, proc_fasttimer_read, NULL);
+   proc_create("fasttimer", 0, NULL, &proc_fasttimer_fops);
 #endif /* PROC_FS */
     if(request_irq(TIMER1_IRQ_NBR, timer1_handler, 0,
                    "fast timer int", NULL))
diff --git a/arch/cris/arch-v32/kernel/fasttimer.c b/arch/cris/arch-v32/kernel/fasttimer.c
index dd1c998..e43dd70 100644
--- a/arch/cris/arch-v32/kernel/fasttimer.c
+++ b/arch/cris/arch-v32/kernel/fasttimer.c
@@ -23,6 +23,7 @@
 #include <hwregs/timer_defs.h>
 #include <asm/fasttimer.h>
 #include <linux/proc_fs.h>
+#include <linux/seq_file.h>
 
 /*
  * timer0 is running at 100MHz and generating jiffies timer ticks
@@ -463,194 +464,161 @@ void schedule_usleep(unsigned long us)
 }
 
 #ifdef CONFIG_PROC_FS
-static int proc_fasttimer_read(char *buf, char **start, off_t offset, int len
-                       ,int *eof, void *data_unused);
-#endif /* CONFIG_PROC_FS */
-
-#ifdef CONFIG_PROC_FS
-
 /* This value is very much based on testing */
 #define BIG_BUF_SIZE (500 + NUM_TIMER_STATS * 300)
 
-static int proc_fasttimer_read(char *buf, char **start, off_t offset, int len
-                       ,int *eof, void *data_unused)
+static int proc_fasttimer_show(struct seq_file *m, void *v)
 {
-  unsigned long flags;
-  int i = 0;
-  int num_to_show;
+	unsigned long flags;
+	int i = 0;
+	int num_to_show;
 	struct fasttime_t tv;
-  struct fast_timer *t, *nextt;
-  static char *bigbuf = NULL;
-  static unsigned long used;
-
-	if (!bigbuf) {
-		bigbuf = vmalloc(BIG_BUF_SIZE);
-		if (!bigbuf) {
-			used = 0;
-			if (buf)
-				buf[0] = '\0';
-			return 0;
-		}
-	}
-
-	if (!offset || !used) {
-    do_gettimeofday_fast(&tv);
-
-    used = 0;
-    used += sprintf(bigbuf + used, "Fast timers added:     %i\n",
-                    fast_timers_added);
-    used += sprintf(bigbuf + used, "Fast timers started:   %i\n",
-                    fast_timers_started);
-    used += sprintf(bigbuf + used, "Fast timer interrupts: %i\n",
-                    fast_timer_ints);
-    used += sprintf(bigbuf + used, "Fast timers expired:   %i\n",
-                    fast_timers_expired);
-    used += sprintf(bigbuf + used, "Fast timers deleted:   %i\n",
-                    fast_timers_deleted);
-    used += sprintf(bigbuf + used, "Fast timer running:    %s\n",
-                    fast_timer_running ? "yes" : "no");
-    used += sprintf(bigbuf + used, "Current time:          %lu.%06lu\n",
-			(unsigned long)tv.tv_jiff,
-                    (unsigned long)tv.tv_usec);
+	struct fast_timer *t, *nextt;
+
+	do_gettimeofday_fast(&tv);
+
+	seq_printf(m, "Fast timers added:     %i\n", fast_timers_added);
+	seq_printf(m, "Fast timers started:   %i\n", fast_timers_started);
+	seq_printf(m, "Fast timer interrupts: %i\n", fast_timer_ints);
+	seq_printf(m, "Fast timers expired:   %i\n", fast_timers_expired);
+	seq_printf(m, "Fast timers deleted:   %i\n", fast_timers_deleted);
+	seq_printf(m, "Fast timer running:    %s\n",
+		   fast_timer_running ? "yes" : "no");
+	seq_printf(m, "Current time:          %lu.%06lu\n",
+		   (unsigned long)tv.tv_jiff,
+		   (unsigned long)tv.tv_usec);
 #ifdef FAST_TIMER_SANITY_CHECKS
-    used += sprintf(bigbuf + used, "Sanity failed:         %i\n",
-                    sanity_failed);
+	seq_printf(m, "Sanity failed:         %i\n", sanity_failed);
 #endif
-    used += sprintf(bigbuf + used, "\n");
+	seq_putc(m, '\n');
 
 #ifdef DEBUG_LOG_INCLUDED
-    {
-      int end_i = debug_log_cnt;
-      i = 0;
-
-			if (debug_log_cnt_wrapped)
-        i = debug_log_cnt;
-
-      while ((i != end_i || (debug_log_cnt_wrapped && !used)) &&
-             used+100 < BIG_BUF_SIZE)
-      {
-        used += sprintf(bigbuf + used, debug_log_string[i],
-                        debug_log_value[i]);
-        i = (i+1) % DEBUG_LOG_MAX;
-      }
-    }
-    used += sprintf(bigbuf + used, "\n");
+	{
+		int end_i = debug_log_cnt;
+		i = 0;
+
+		if (debug_log_cnt_wrapped)
+			i = debug_log_cnt;
+
+		while ((i != end_i || debug_log_cnt_wrapped)) {
+			if (seq_printf(m, debug_log_string[i], debug_log_value[i]) < 0)
+				return 0;
+			i = (i+1) % DEBUG_LOG_MAX;
+		}
+	}
+	seq_putc(m, '\n');
 #endif
 
-    num_to_show = (fast_timers_started < NUM_TIMER_STATS ? fast_timers_started:
-                   NUM_TIMER_STATS);
-    used += sprintf(bigbuf + used, "Timers started: %i\n", fast_timers_started);
-    for (i = 0; i < num_to_show && (used+100 < BIG_BUF_SIZE) ; i++)
-    {
-      int cur = (fast_timers_started - i - 1) % NUM_TIMER_STATS;
+	num_to_show = (fast_timers_started < NUM_TIMER_STATS ? fast_timers_started:
+		       NUM_TIMER_STATS);
+	seq_printf(m, "Timers started: %i\n", fast_timers_started);
+	for (i = 0; i < num_to_show; i++) {
+		int cur = (fast_timers_started - i - 1) % NUM_TIMER_STATS;
 
 #if 1 //ndef FAST_TIMER_LOG
-      used += sprintf(bigbuf + used, "div: %i delay: %i"
-                      "\n",
-                      timer_div_settings[cur],
-                      timer_delay_settings[cur]
-                      );
+		seq_printf(m, "div: %i delay: %i"
+			   "\n",
+			   timer_div_settings[cur],
+			   timer_delay_settings[cur]);
 #endif
 #ifdef FAST_TIMER_LOG
-      t = &timer_started_log[cur];
-      used += sprintf(bigbuf + used, "%-14s s: %6lu.%06lu e: %6lu.%06lu "
-                      "d: %6li us data: 0x%08lX"
-                      "\n",
-                      t->name,
-				(unsigned long)t->tv_set.tv_jiff,
-                      (unsigned long)t->tv_set.tv_usec,
-				(unsigned long)t->tv_expires.tv_jiff,
-                      (unsigned long)t->tv_expires.tv_usec,
-                      t->delay_us,
-                      t->data
-                      );
+		t = &timer_started_log[cur];
+		if (seq_printf(m, "%-14s s: %6lu.%06lu e: %6lu.%06lu "
+			       "d: %6li us data: 0x%08lX"
+			       "\n",
+			       t->name,
+			       (unsigned long)t->tv_set.tv_jiff,
+			       (unsigned long)t->tv_set.tv_usec,
+			       (unsigned long)t->tv_expires.tv_jiff,
+			       (unsigned long)t->tv_expires.tv_usec,
+			       t->delay_us,
+			       t->data) < 0)
+			return 0;
 #endif
-    }
-    used += sprintf(bigbuf + used, "\n");
+	}
+	seq_putc(m, '\n');
 
 #ifdef FAST_TIMER_LOG
-    num_to_show = (fast_timers_added < NUM_TIMER_STATS ? fast_timers_added:
-                   NUM_TIMER_STATS);
-    used += sprintf(bigbuf + used, "Timers added: %i\n", fast_timers_added);
-    for (i = 0; i < num_to_show && (used+100 < BIG_BUF_SIZE); i++)
-    {
-      t = &timer_added_log[(fast_timers_added - i - 1) % NUM_TIMER_STATS];
-      used += sprintf(bigbuf + used, "%-14s s: %6lu.%06lu e: %6lu.%06lu "
-                      "d: %6li us data: 0x%08lX"
-                      "\n",
-                      t->name,
-				(unsigned long)t->tv_set.tv_jiff,
-                      (unsigned long)t->tv_set.tv_usec,
-				(unsigned long)t->tv_expires.tv_jiff,
-                      (unsigned long)t->tv_expires.tv_usec,
-                      t->delay_us,
-                      t->data
-                      );
-    }
-    used += sprintf(bigbuf + used, "\n");
-
-    num_to_show = (fast_timers_expired < NUM_TIMER_STATS ? fast_timers_expired:
-                   NUM_TIMER_STATS);
-    used += sprintf(bigbuf + used, "Timers expired: %i\n", fast_timers_expired);
-    for (i = 0; i < num_to_show && (used+100 < BIG_BUF_SIZE); i++)
-    {
-      t = &timer_expired_log[(fast_timers_expired - i - 1) % NUM_TIMER_STATS];
-      used += sprintf(bigbuf + used, "%-14s s: %6lu.%06lu e: %6lu.%06lu "
-                      "d: %6li us data: 0x%08lX"
-                      "\n",
-                      t->name,
-				(unsigned long)t->tv_set.tv_jiff,
-                      (unsigned long)t->tv_set.tv_usec,
-				(unsigned long)t->tv_expires.tv_jiff,
-                      (unsigned long)t->tv_expires.tv_usec,
-                      t->delay_us,
-                      t->data
-                      );
-    }
-    used += sprintf(bigbuf + used, "\n");
+	num_to_show = (fast_timers_added < NUM_TIMER_STATS ? fast_timers_added:
+		       NUM_TIMER_STATS);
+	seq_printf(m, "Timers added: %i\n", fast_timers_added);
+	for (i = 0; i < num_to_show; i++) {
+		t = &timer_added_log[(fast_timers_added - i - 1) % NUM_TIMER_STATS];
+		if (seq_printf(m, "%-14s s: %6lu.%06lu e: %6lu.%06lu "
+			       "d: %6li us data: 0x%08lX"
+			       "\n",
+			       t->name,
+			       (unsigned long)t->tv_set.tv_jiff,
+			       (unsigned long)t->tv_set.tv_usec,
+			       (unsigned long)t->tv_expires.tv_jiff,
+			       (unsigned long)t->tv_expires.tv_usec,
+			       t->delay_us,
+			       t->data) < 0)
+			return 0;
+	}
+	seq_putc(m, '\n');
+
+	num_to_show = (fast_timers_expired < NUM_TIMER_STATS ? fast_timers_expired:
+		       NUM_TIMER_STATS);
+	seq_printf(m, "Timers expired: %i\n", fast_timers_expired);
+	for (i = 0; i < num_to_show; i++){
+		t = &timer_expired_log[(fast_timers_expired - i - 1) % NUM_TIMER_STATS];
+		if (seq_printf(m, "%-14s s: %6lu.%06lu e: %6lu.%06lu "
+			       "d: %6li us data: 0x%08lX"
+			       "\n",
+			       t->name,
+			       (unsigned long)t->tv_set.tv_jiff,
+			       (unsigned long)t->tv_set.tv_usec,
+			       (unsigned long)t->tv_expires.tv_jiff,
+			       (unsigned long)t->tv_expires.tv_usec,
+			       t->delay_us,
+			       t->data) < 0)
+			return 0;
+	}
+	seq_putc(m, '\n');
 #endif
 
-    used += sprintf(bigbuf + used, "Active timers:\n");
-    local_irq_save(flags);
-    t = fast_timer_list;
-    while (t != NULL && (used+100 < BIG_BUF_SIZE))
-    {
-      nextt = t->next;
-      local_irq_restore(flags);
-      used += sprintf(bigbuf + used, "%-14s s: %6lu.%06lu e: %6lu.%06lu "
-			"d: %6li us data: 0x%08lX"
+	seq_puts(m, "Active timers:\n");
+	local_irq_save(flags);
+	t = fast_timer_list;
+	while (t != NULL){
+		nextt = t->next;
+		local_irq_restore(flags);
+		if (seq_printf(m, "%-14s s: %6lu.%06lu e: %6lu.%06lu "
+			       "d: %6li us data: 0x%08lX"
 /*			" func: 0x%08lX" */
-			"\n",
-			t->name,
-			(unsigned long)t->tv_set.tv_jiff,
-			(unsigned long)t->tv_set.tv_usec,
-			(unsigned long)t->tv_expires.tv_jiff,
-			(unsigned long)t->tv_expires.tv_usec,
-                      t->delay_us,
-                      t->data
+			       "\n",
+			       t->name,
+			       (unsigned long)t->tv_set.tv_jiff,
+			       (unsigned long)t->tv_set.tv_usec,
+			       (unsigned long)t->tv_expires.tv_jiff,
+			       (unsigned long)t->tv_expires.tv_usec,
+			       t->delay_us,
+			       t->data
 /*                      , t->function */
-                      );
-			local_irq_save(flags);
-      if (t->next != nextt)
-      {
-        printk("timer removed!\n");
-      }
-      t = nextt;
-    }
-    local_irq_restore(flags);
-  }
+			       ) < 0)
+			return 0;
+		local_irq_save(flags);
+		if (t->next != nextt)
+			printk("timer removed!\n");
+		t = nextt;
+	}
+	local_irq_restore(flags);
+	return 0;
+}
 
-  if (used - offset < len)
-  {
-    len = used - offset;
-  }
+static int proc_fasttimer_open(struct inode *inode, struct file *file)
+{
+	return single_open_size(file, proc_fasttimer_show, PDE_DATA(inode), BIG_BUF_SIZE);
+}
 
-  memcpy(buf, bigbuf + offset, len);
-  *start = buf;
-  *eof = 1;
+static const struct file_operations proc_fasttimer_fops = {
+	.open		= proc_fasttimer_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= seq_release,
+};
 
-  return len;
-}
 #endif /* PROC_FS */
 
 #ifdef FAST_TIMER_TEST
@@ -815,7 +783,7 @@ int fast_timer_init(void)
     printk("fast_timer_init()\n");
 
 #ifdef CONFIG_PROC_FS
-    create_proc_read_entry("fasttimer", 0, NULL, proc_fasttimer_read, NULL);
+    proc_create("fasttimer", 0, NULL, &proc_fasttimer_fops);
 #endif /* PROC_FS */
 		if (request_irq(TIMER0_INTR_VECT, timer_trig_interrupt,
 				IRQF_SHARED | IRQF_DISABLED,

