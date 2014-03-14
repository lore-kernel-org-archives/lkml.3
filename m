Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756674AbaCQG4s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 02:56:48 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60712 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756173AbaCQGyy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 02:54:54 -0400
From: Jan Kara <jack@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, pmladek@suse.cz,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jan Kara <jack@suse.cz>
Subject: [PATCH 2/8] printk: Release lockbuf_lock before calling console_trylock_for_printk()
Date: Fri, 14 Mar 2014 17:21:46 +0100
Message-Id: <1394814112-20200-3-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1394814112-20200-1-git-send-email-jack@suse.cz>
References: <1394814112-20200-1-git-send-email-jack@suse.cz>
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
index bd7ee2a9f960..7a8ffd89875c 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -249,9 +249,6 @@ static char __log_buf[__LOG_BUF_LEN] __aligned(LOG_ALIGN);
 static char *log_buf = __log_buf;
 static u32 log_buf_len = __LOG_BUF_LEN;
 
-/* cpu currently holding logbuf_lock */
-static volatile unsigned int logbuf_cpu = UINT_MAX;
-
 /* human readable text of the record */
 static char *log_text(const struct printk_log *msg)
 {
@@ -1332,36 +1329,22 @@ static inline int can_use_console(unsigned int cpu)
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
@@ -1494,6 +1477,9 @@ asmlinkage int vprintk_emit(int facility, int level,
 	unsigned long flags;
 	int this_cpu;
 	int printed_len = 0;
+	/* cpu currently holding logbuf_lock in this function */
+	static volatile unsigned int logbuf_cpu = UINT_MAX;
+
 
 	boot_delay_msec(level);
 	printk_delay();
@@ -1609,13 +1595,12 @@ asmlinkage int vprintk_emit(int facility, int level,
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

