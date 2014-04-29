Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755045AbaD2VLb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 17:11:31 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33258 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751915AbaD2VLa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 17:11:30 -0400
Date: Tue, 29 Apr 2014 23:11:28 +0200
From: Jan Kara <jack@suse.cz>
To: Fabio Estevam <festevam@gmail.com>
Cc: jack@suse.cz, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Warning from kernel/printk/printk.c in linux-next
Message-ID: <20140429211128.GF29634@quack.suse.cz>
References: <CAOMZO5Bb3P20S15Hi8fKO1r8-JOQa3j8GekNBiABVb9XXN0hZw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="DKU6Jbt7q3WqK7+M"
Content-Disposition: inline
In-Reply-To: <CAOMZO5Bb3P20S15Hi8fKO1r8-JOQa3j8GekNBiABVb9XXN0hZw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--DKU6Jbt7q3WqK7+M
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

  Hello,

On Tue 29-04-14 13:33:17, Fabio Estevam wrote:
> I am running linux-next 20140429 on a mx6 board (ARM 32-bit) and after commit
> 5dc90cb49691755faa ("printk: enable interrupts before calling
> console_trylock_for_printk()") I get the following warning:
  Thanks for report. Attached patch should fix the problem I hope.

								Honza

> [ INFO: possible recursive locking detected ]
> 3.15.0-rc3-next-20140429-00001-gac246a5 #1074 Not tainted
> ---------------------------------------------
> swapper/0/0 is trying to acquire lock:
>  (console_lock){+.+...}, at: [<808c1358>] con_init+0x14/0x29c
> 
> but task is already holding lock:
>  (console_lock){+.+...}, at: [<8006deac>] vprintk_emit+0x194/0x514
> 
> other info that might help us debug this:
>  Possible unsafe locking scenario:
> 
>        CPU0
>        ----
>   lock(console_lock);
>   lock(console_lock);
> 
>  *** DEADLOCK ***
> 
>  May be due to missing lock nesting notation
> 
> 1 lock held by swapper/0/0:
>  #0:  (console_lock){+.+...}, at: [<8006deac>] vprintk_emit+0x194/0x514
> 
> stack backtrace:
> CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.15.0-rc3-next-20140429-00001-gac2464
> Backtrace:
> [<80011cbc>] (dump_backtrace) from [<80011e58>] (show_stack+0x18/0x1c)
>  r6:8114b4fc r5:00000000 r4:00000000 r3:00000000
> [<80011e40>] (show_stack) from [<8065e65c>] (dump_stack+0x88/0xa4)
> [<8065e5d4>] (dump_stack) from [<80065518>] (__lock_acquire+0x1494/0x1c10)
>  r5:808f3f70 r4:80a7d6c0
> [<80064084>] (__lock_acquire) from [<80066178>] (lock_acquire+0x68/0x7c)
>  r10:00000000 r9:412fc09a r8:8000406a r7:00000001 r6:60000153 r5:808e8000
>  r4:00000000
> [<80066110>] (lock_acquire) from [<8006c91c>] (console_lock+0x54/0x68)
>  r7:befffbc0 r6:808d6db0 r5:808c1358 r4:00000001
> [<8006c8c8>] (console_lock) from [<808c1358>] (con_init+0x14/0x29c)
>  r5:808e37a4 r4:808e37a4
> [<808c1344>] (con_init) from [<808c0ae4>] (console_init+0x24/0x38)
>  r6:808d6db0 r5:808e37a4 r4:808e37a4
> [<808c0ac0>] (console_init) from [<80894bb4>] (start_kernel+0x26c/0x3a4)
>  r5:8094d5c0 r4:ffffffff
> [<80894948>] (start_kernel) from [<80008074>] (0x80008074)
>  r7:808f5644 r6:808d6dac r5:808f0928 r4:10c5387d
> 
> Reverting this commit causes the warning to go away.
> 
> Any suggestions?
> 
> Regards,
> 
> Fabio Estevam
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

--DKU6Jbt7q3WqK7+M
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="0001-printk-Fix-lockdep-instrumentation-of-console_sem.patch"

>From 02e7e0901329f6b9ac3392be41a72b3cee4ac995 Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Mon, 28 Apr 2014 21:09:26 +0200
Subject: [PATCH] printk: Fix lockdep instrumentation of console_sem

Printk calls mutex_acquire() / mutex_release() by hand to instrument
lockdep about console_sem. However in some corner cases the
instrumentation is missing. Fix the problem by creating helper functions
for locking / unlocking console_sem which take care of lockdep
instrumentation as well.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 kernel/printk/printk.c |   46 ++++++++++++++++++++++++++++++++--------------
 1 files changed, 32 insertions(+), 14 deletions(-)

diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index 48a038b..82d19e6 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -94,6 +94,29 @@ static struct lockdep_map console_lock_dep_map = {
 #endif
 
 /*
+ * Helper macros to handle lockdep when locking/unlocking console_sem. We use
+ * macros instead of functions so that _RET_IP_ contains useful information.
+ */
+#define down_console_sem() do { \
+	down(&console_sem);\
+	mutex_acquire(&console_lock_dep_map, 0, 0, _RET_IP_);\
+} while (0)
+
+static int __down_trylock_console_sem(unsigned long ip)
+{
+	if (down_trylock(&console_sem))
+		return 1;
+	mutex_acquire(&console_lock_dep_map, 0, 1, ip);
+	return 0;
+}
+#define down_trylock_console_sem() __down_trylock_console_sem(_RET_IP_)
+
+#define up_console_sem() do { \
+	mutex_release(&console_lock_dep_map, 1, _RET_IP_);\
+	up(&console_sem);\
+} while (0)
+
+/*
  * This is used for debugging the mess that is the VT code by
  * keeping track if we have the console semaphore held. It's
  * definitely not the perfect debug tool (we don't know if _WE_
@@ -1428,7 +1451,7 @@ static int console_trylock_for_printk(void)
 	 */
 	if (!can_use_console(cpu)) {
 		console_locked = 0;
-		up(&console_sem);
+		up_console_sem();
 		return 0;
 	}
 	return 1;
@@ -1977,16 +2000,14 @@ void suspend_console(void)
 	printk("Suspending console(s) (use no_console_suspend to debug)\n");
 	console_lock();
 	console_suspended = 1;
-	up(&console_sem);
-	mutex_release(&console_lock_dep_map, 1, _RET_IP_);
+	up_console_sem();
 }
 
 void resume_console(void)
 {
 	if (!console_suspend_enabled)
 		return;
-	down(&console_sem);
-	mutex_acquire(&console_lock_dep_map, 0, 0, _RET_IP_);
+	down_console_sem();
 	console_suspended = 0;
 	console_unlock();
 }
@@ -2028,12 +2049,11 @@ void console_lock(void)
 {
 	might_sleep();
 
-	down(&console_sem);
+	down_console_sem();
 	if (console_suspended)
 		return;
 	console_locked = 1;
 	console_may_schedule = 1;
-	mutex_acquire(&console_lock_dep_map, 0, 0, _RET_IP_);
 }
 EXPORT_SYMBOL(console_lock);
 
@@ -2047,15 +2067,14 @@ EXPORT_SYMBOL(console_lock);
  */
 int console_trylock(void)
 {
-	if (down_trylock(&console_sem))
+	if (down_trylock_console_sem())
 		return 0;
 	if (console_suspended) {
-		up(&console_sem);
+		up_console_sem();
 		return 0;
 	}
 	console_locked = 1;
 	console_may_schedule = 0;
-	mutex_acquire(&console_lock_dep_map, 0, 1, _RET_IP_);
 	return 1;
 }
 EXPORT_SYMBOL(console_trylock);
@@ -2117,7 +2136,7 @@ void console_unlock(void)
 	bool retry;
 
 	if (console_suspended) {
-		up(&console_sem);
+		up_console_sem();
 		return;
 	}
 
@@ -2179,7 +2198,6 @@ skip:
 		local_irq_restore(flags);
 	}
 	console_locked = 0;
-	mutex_release(&console_lock_dep_map, 1, _RET_IP_);
 
 	/* Release the exclusive_console once it is used */
 	if (unlikely(exclusive_console))
@@ -2187,7 +2205,7 @@ skip:
 
 	raw_spin_unlock(&logbuf_lock);
 
-	up(&console_sem);
+	up_console_sem();
 
 	/*
 	 * Someone could have filled up the buffer again, so re-check if there's
@@ -2232,7 +2250,7 @@ void console_unblank(void)
 	 * oops_in_progress is set to 1..
 	 */
 	if (oops_in_progress) {
-		if (down_trylock(&console_sem) != 0)
+		if (down_trylock_console_sem() != 0)
 			return;
 	} else
 		console_lock();
-- 
1.6.0.2


--DKU6Jbt7q3WqK7+M--
