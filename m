Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754563AbaD2VH4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 17:07:56 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33233 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754260AbaD2VHz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 17:07:55 -0400
Date: Tue, 29 Apr 2014 23:07:50 +0200
From: Jan Kara <jack@suse.cz>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Jan Kara <jack@suse.cz>, Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: lockdep warning after recent cleanup in console code
Message-ID: <20140429210750.GE29634@quack.suse.cz>
References: <1398702925.11914.292.camel@smile.fi.intel.com>
 <20140428134331.68771bf7@gandalf.local.home>
 <20140428175139.GD9091@quack.suse.cz>
 <20140428141439.3580dce9@gandalf.local.home>
 <20140428192416.GE9091@quack.suse.cz>
 <1398760684.23470.1.camel@smile.fi.intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="Nq2Wo0NMKNjxTN9z"
Content-Disposition: inline
In-Reply-To: <1398760684.23470.1.camel@smile.fi.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Nq2Wo0NMKNjxTN9z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue 29-04-14 11:38:04, Andy Shevchenko wrote:
> On Mon, 2014-04-28 at 21:24 +0200, Jan Kara wrote:
> > On Mon 28-04-14 14:14:39, Steven Rostedt wrote:
> > > On Mon, 28 Apr 2014 19:51:39 +0200
> > > Jan Kara <jack@suse.cz> wrote:
> > > 
> > > > On Mon 28-04-14 13:43:31, Steven Rostedt wrote:
> > > > > Things have changed with regard to printk() in linux-next. Now it
> > > > > appears that lockdep is going haywire over it. I don't understand the
> > > > > exact reason for the lockdep_off() and lockdep_on() logic that is in
> > > > > printk(), but it obviously seems to be causing issues with the new
> > > > > changes.
> > > > > 
> > > > > Care to take a look?
> > > >   The obvious cause is that I moved lockdep_on() somewhat earlier in
> > > > vprintk_emit() so lockdep now covers more of printk code. And apparently
> > > > something is wrong there...
> > > > 
> > > 
> > > Exactly, and I rather know *exactly* what is wrong before we just start
> > > throwing patches at the problem and hope it goes away. That's not how
> > > to solve a software bug.
> >   So I had a look and we are missing mutex_release() in
> > console_trylock_for_printk() if we don't have a console to print to.
> > Attached patch should fix the problem.
> 
> Besides it doesn't apply clearly on top of today's linux-next, it
> doesn't fix the issue, but modifies it a bit.
  Sorry, I was too tired and missed conversion of one place. Attached is a
new version of the patch which also applies cleanly against linux-next.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

--Nq2Wo0NMKNjxTN9z
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


--Nq2Wo0NMKNjxTN9z--
