Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754321Ab3LQOsV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 09:48:21 -0500
Received: from cantor2.suse.de ([195.135.220.15]:57448 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752358Ab3LQOsS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 09:48:18 -0500
From: Jan Kara <jack@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, mhocko@suse.cz, pmladek@suse.cz,
        Steven Rostedt <rostedt@goodmis.org>, Jan Kara <jack@suse.cz>
Subject: [PATCH 1/3] printk: Release lockbuf_lock before calling console_trylock_for_printk()
Date: Tue, 17 Dec 2013 15:48:08 +0100
Message-Id: <1387291691-2224-2-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1387291691-2224-1-git-send-email-jack@suse.cz>
References: <1387291691-2224-1-git-send-email-jack@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's no reason to hold lockbuf_lock when entering
console_trylock_for_printk(). The first thing this function does is
calling down_trylock(console_sem) and if that fails it immediately
unlocks lockbuf_lock. So lockbuf_lock isn't needed for that branch.
When down_trylock() succeeds, the rest of console_trylock() is OK
without lockbuf_lock (it is called without it from other places), and
the only remaining thing in console_trylock_for_printk() is
can_use_console() call. For that call console_sem is enough (it
iterates all consoles and checks CON_ANYTIME flag).

So we drop logbuf_lock before entering console_trylock_for_printk()
which simplifies the code.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 kernel/printk/printk.c | 49 +++++++++++++++++--------------------------------
 1 file changed, 17 insertions(+), 32 deletions(-)

diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index be7c86bae576..72ec3637115f 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -250,9 +250,6 @@ static char __log_buf[__LOG_BUF_LEN] __aligned(LOG_ALIGN);
 static char *log_buf = __log_buf;
 static u32 log_buf_len = __LOG_BUF_LEN;
 
-/* cpu currently holding logbuf_lock */
-static volatile unsigned int logbuf_cpu = UINT_MAX;
-
 /* human readable text of the record */
 static char *log_text(const struct printk_log *msg)
 {
@@ -1338,36 +1335,22 @@ static inline int can_use_console(unsigned int cpu)
  * messages from a 'printk'. Return true (and with the
  * console_lock held, and 'console_locked' set) if it
  * is successful, false otherwise.
- *
- * This gets called with the 'logbuf_lock' spinlock held and
- * interrupts disabled. It should return with 'lockbuf_lock'
- * released but interrupts still disabled.
  */
 static int console_trylock_for_printk(unsigned int cpu)
-	__releases(&logbuf_lock)
 {
-	int retval = 0, wake = 0;
-
-	if (console_trylock()) {
-		retval = 1;
-
-		/*
-		 * If we can't use the console, we need to release
-		 * the console semaphore by hand to avoid flushing
-		 * the buffer. We need to hold the console semaphore
-		 * in order to do this test safely.
-		 */
-		if (!can_use_console(cpu)) {
-			console_locked = 0;
-			wake = 1;
-			retval = 0;
-		}
-	}
-	logbuf_cpu = UINT_MAX;
-	raw_spin_unlock(&logbuf_lock);
-	if (wake)
+	if (!console_trylock())
+		return 0;
+	/*
+	 * If we can't use the console, we need to release the console
+	 * semaphore by hand to avoid flushing the buffer. We need to hold the
+	 * console semaphore in order to do this test safely.
+	 */
+	if (!can_use_console(cpu)) {
+		console_locked = 0;
 		up(&console_sem);
-	return retval;
+		return 0;
+	}
+	return 1;
 }
 
 int printk_delay_msec __read_mostly;
@@ -1500,6 +1483,9 @@ asmlinkage int vprintk_emit(int facility, int level,
 	unsigned long flags;
 	int this_cpu;
 	int printed_len = 0;
+	/* cpu currently holding logbuf_lock in this function */
+	static volatile unsigned int logbuf_cpu = UINT_MAX;
+
 
 	boot_delay_msec(level);
 	printk_delay();
@@ -1612,13 +1598,12 @@ asmlinkage int vprintk_emit(int facility, int level,
 	}
 	printed_len += text_len;
 
+	logbuf_cpu = UINT_MAX;
+	raw_spin_unlock(&logbuf_lock);
 	/*
 	 * Try to acquire and then immediately release the console semaphore.
 	 * The release will print out buffers and wake up /dev/kmsg and syslog()
 	 * users.
-	 *
-	 * The console_trylock_for_printk() function will release 'logbuf_lock'
-	 * regardless of whether it actually gets the console semaphore or not.
 	 */
 	if (console_trylock_for_printk(this_cpu))
 		console_unlock();
-- 
1.8.1.4

