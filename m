Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756600AbaD1TYZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 15:24:25 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38582 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753335AbaD1TYV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 15:24:21 -0400
Date: Mon, 28 Apr 2014 21:24:16 +0200
From: Jan Kara <jack@suse.cz>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Jan Kara <jack@suse.cz>, Peter Zijlstra <peterz@infradead.org>,
        "Shevchenko, Andriy" <andriy.shevchenko@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: lockdep warning after recent cleanup in console code
Message-ID: <20140428192416.GE9091@quack.suse.cz>
References: <1398702925.11914.292.camel@smile.fi.intel.com>
 <20140428134331.68771bf7@gandalf.local.home>
 <20140428175139.GD9091@quack.suse.cz>
 <20140428141439.3580dce9@gandalf.local.home>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="EeQfGwPcQSOJBaQU"
Content-Disposition: inline
In-Reply-To: <20140428141439.3580dce9@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--EeQfGwPcQSOJBaQU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon 28-04-14 14:14:39, Steven Rostedt wrote:
> On Mon, 28 Apr 2014 19:51:39 +0200
> Jan Kara <jack@suse.cz> wrote:
> 
> > On Mon 28-04-14 13:43:31, Steven Rostedt wrote:
> > > Things have changed with regard to printk() in linux-next. Now it
> > > appears that lockdep is going haywire over it. I don't understand the
> > > exact reason for the lockdep_off() and lockdep_on() logic that is in
> > > printk(), but it obviously seems to be causing issues with the new
> > > changes.
> > > 
> > > Care to take a look?
> >   The obvious cause is that I moved lockdep_on() somewhat earlier in
> > vprintk_emit() so lockdep now covers more of printk code. And apparently
> > something is wrong there...
> > 
> 
> Exactly, and I rather know *exactly* what is wrong before we just start
> throwing patches at the problem and hope it goes away. That's not how
> to solve a software bug.
  So I had a look and we are missing mutex_release() in
console_trylock_for_printk() if we don't have a console to print to.
Attached patch should fix the problem.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

--EeQfGwPcQSOJBaQU
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="0001-printk-Fix-lockdep-instrumentation-of-console_sem.patch"

>From e8cfbd7ec0f9a820ab38c3ce236940167fa82193 Mon Sep 17 00:00:00 2001
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
 kernel/printk/printk.c | 39 ++++++++++++++++++++++++++++-----------
 1 file changed, 28 insertions(+), 11 deletions(-)

diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index 91c554e027c5..bcaab92fe7c0 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -1877,6 +1877,26 @@ module_param_named(console_suspend, console_suspend_enabled,
 MODULE_PARM_DESC(console_suspend, "suspend console during suspend"
 	" and hibernate operations");
 
+static inline void down_console_sem(void)
+{
+	down(&console_sem);
+	mutex_acquire(&console_lock_dep_map, 0, 0, _RET_IP_);
+}
+
+static inline int down_trylock_console_sem(void)
+{
+	if (down_trylock(&console_sem))
+		return 1;
+	mutex_acquire(&console_lock_dep_map, 0, 1, _RET_IP_);
+	return 0;
+}
+
+static inline void up_console_sem(void)
+{
+	mutex_release(&console_lock_dep_map, 1, _RET_IP_);
+	up(&console_sem);
+}
+
 /**
  * suspend_console - suspend the console subsystem
  *
@@ -1889,14 +1909,14 @@ void suspend_console(void)
 	printk("Suspending console(s) (use no_console_suspend to debug)\n");
 	console_lock();
 	console_suspended = 1;
-	up(&console_sem);
+	up_console_sem();
 }
 
 void resume_console(void)
 {
 	if (!console_suspend_enabled)
 		return;
-	down(&console_sem);
+	down_console_sem();
 	console_suspended = 0;
 	console_unlock();
 }
@@ -1938,12 +1958,11 @@ void console_lock(void)
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
 
@@ -1957,15 +1976,14 @@ EXPORT_SYMBOL(console_lock);
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
@@ -2027,7 +2045,7 @@ void console_unlock(void)
 	bool retry;
 
 	if (console_suspended) {
-		up(&console_sem);
+		up_console_sem();
 		return;
 	}
 
@@ -2089,7 +2107,6 @@ skip:
 		local_irq_restore(flags);
 	}
 	console_locked = 0;
-	mutex_release(&console_lock_dep_map, 1, _RET_IP_);
 
 	/* Release the exclusive_console once it is used */
 	if (unlikely(exclusive_console))
@@ -2097,7 +2114,7 @@ skip:
 
 	raw_spin_unlock(&logbuf_lock);
 
-	up(&console_sem);
+	up_console_sem();
 
 	/*
 	 * Someone could have filled up the buffer again, so re-check if there's
@@ -2142,7 +2159,7 @@ void console_unblank(void)
 	 * oops_in_progress is set to 1..
 	 */
 	if (oops_in_progress) {
-		if (down_trylock(&console_sem) != 0)
+		if (down_trylock_console_sem() != 0)
 			return;
 	} else
 		console_lock();
-- 
1.8.1.4


--EeQfGwPcQSOJBaQU--
