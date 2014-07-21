Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754249AbaGUKEj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 06:04:39 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46549 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753380AbaGUKEh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 06:04:37 -0400
Date: Mon, 21 Jul 2014 12:04:34 +0200
From: Jan Kara <jack@suse.cz>
To: Andreas Bombe <aeb@debian.org>
Cc: Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [REGRESSION] Boot hang with 939f04bec printk: enable interrupts
 before calling console_trylock_for_printk()
Message-ID: <20140721100434.GA26641@quack.suse.cz>
References: <20140628225050.GA3484@amos.fritz.box>
 <20140714083527.GA30550@quack.suse.cz>
 <20140716213408.GA8749@amos.fritz.box>
 <20140717083137.GA1649@quack.suse.cz>
 <20140718225005.GA17140@amos.fritz.box>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="5mCyUwZo2JvN/JJP"
Content-Disposition: inline
In-Reply-To: <20140718225005.GA17140@amos.fritz.box>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--5mCyUwZo2JvN/JJP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat 19-07-14 00:50:05, Andreas Bombe wrote:
> On Thu, Jul 17, 2014 at 10:31:37AM +0200, Jan Kara wrote:
> > On Wed 16-07-14 23:34:08, Andreas Bombe wrote:
> > > On Mon, Jul 14, 2014 at 10:35:27AM +0200, Jan Kara wrote:
> > > > On Sun 29-06-14 00:50:50, Andreas Bombe wrote:
> > > > > None of the post 3.15 kernel boot for me. They all hang at the GRUB
> > > > > screen telling me it loaded and started the kernel, but the kernel
> > > > > itself stops before it prints anything (or even replaces the GRUB
> > > > > background graphics).
> > > > > 
> > > > > I bisected it down to 939f04bec1a4ef6ba4370b0f34b01decc844b1b1 "printk:
> > > > > enable interrupts before calling console_trylock_for_printk()".
> > > > > Reverting that patch on the latest kernel (git 24b414d5a7) allows me to
> > > > > boot normally. I fixed the conflict in the revert by leaving in the "if
> > > > > (in_sched) return printed_len;".
> > > > > 
> > > > > I have the "early printk via the EFI framebuffer" option enabled,
> > > > > disabling it made no difference however.
> > > >   Thanks for report. I've been on vacation so I'm replying with a delay. I
> > > > believe this is one of the issues where this patch just uncovers underlying
> > > > problem - I belive lockdep tries to report some locking issue in console
> > > > driver code (this patch increased lockdep coverage of console driver code)
> > > > however we are holding some locks in printk code which make lockdep
> > > > deadlock. Can you try running with the attached patch?
> > > 
> > > EUNABLE
> > > 
> > > You forgot to attach a patch.
> >   Bah, sorry. Attaching now.
> 
> I don't see anything in /sys/kernel/debug/tracing/trace_pipe or
> .../trace (besides the header) with your patch applied. In case you
> meant to test it with the problematic printk change, I also tried with
> the revert reverted. That still hangs as before without any error report
> to see.
  Yes, I meant testing my lockdep patch with the problematic printk change.
Thanks for having a look. I'm puzzled why it didn't help.

> I checked the kernel logs and there is also no lockdep report anywhere.
> I get the "trace_printk() being used" notice but nothing else of
> interest around there. Though the notice should mean trace_printk() was
> used at least once?
  Yes. Anyway, I'd be grateful if you could run one more test for me so
that I can better understand what's going on. Can you take recent vanilla
kernel (with the revert) and apply attached patch to it? It again enables
interrupts when calling console_unlock() but keeps lockdep coverage
unchanged. It helped Sasha so I want to see whether your case is similar or
different. Thanks!

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

--5mCyUwZo2JvN/JJP
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="0001-printk-enable-interrupts-before-calling-console_tryl.patch"

>From c73d4093c3fd5013dbf5baccd495d6db24de31cc Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Wed, 4 Jun 2014 16:11:37 -0700
Subject: [PATCH] printk: enable interrupts before calling
 console_trylock_for_printk()

We need interrupts disabled when calling console_trylock_for_printk()
only so that cpu id we pass to can_use_console() remains valid (for
other things console_sem provides all the exclusion we need and
deadlocks on console_sem due to interrupts are impossible because we use
down_trylock()).  However if we are rescheduled, we are guaranteed to
run on an online cpu so we can easily just get the cpu id in
can_use_console().

We can lose a bit of performance when we enable interrupts in
vprintk_emit() and then disable them again in console_unlock() but OTOH
it can somewhat reduce interrupt latency caused by console_unlock().

We avoid calling console_unlock() from vprintk_emit() with lockdep
enabled as that has unveiled quite some bugs leading to system freezes
during boot (e.g. https://lkml.org/lkml/2014/5/30/242).

Signed-off-by: Jan Kara <jack@suse.cz>
---
 kernel/printk/printk.c | 31 +++++++++++++++++++++----------
 1 file changed, 21 insertions(+), 10 deletions(-)

diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index 13e839dbca07..fe4154d83fe4 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -1416,10 +1416,9 @@ static int have_callable_console(void)
 /*
  * Can we actually use the console at this time on this cpu?
  *
- * Console drivers may assume that per-cpu resources have
- * been allocated. So unless they're explicitly marked as
- * being able to cope (CON_ANYTIME) don't call them until
- * this CPU is officially up.
+ * Console drivers may assume that per-cpu resources have been allocated. So
+ * unless they're explicitly marked as being able to cope (CON_ANYTIME) don't
+ * call them until this CPU is officially up.
  */
 static inline int can_use_console(unsigned int cpu)
 {
@@ -1432,8 +1431,10 @@ static inline int can_use_console(unsigned int cpu)
  * console_lock held, and 'console_locked' set) if it
  * is successful, false otherwise.
  */
-static int console_trylock_for_printk(unsigned int cpu)
+static int console_trylock_for_printk(void)
 {
+	unsigned int cpu = smp_processor_id();
+
 	if (!console_trylock())
 		return 0;
 	/*
@@ -1608,7 +1609,8 @@ asmlinkage int vprintk_emit(int facility, int level,
 		 */
 		if (!oops_in_progress && !lockdep_recursing(current)) {
 			recursion_bug = 1;
-			goto out_restore_irqs;
+			local_irq_restore(flags);
+			return 0;
 		}
 		zap_locks();
 	}
@@ -1716,21 +1718,30 @@ asmlinkage int vprintk_emit(int facility, int level,
 
 	logbuf_cpu = UINT_MAX;
 	raw_spin_unlock(&logbuf_lock);
+	lockdep_on();
+	local_irq_restore(flags);
 
 	/* If called from the scheduler, we can not call up(). */
 	if (!in_sched) {
+		lockdep_off();
+		/*
+		 * Disable preemption to avoid being preempted while holding
+		 * console_sem which would prevent anyone from printing to
+		 * console
+		 */
+		preempt_disable();
+
 		/*
 		 * Try to acquire and then immediately release the console
 		 * semaphore.  The release will print out buffers and wake up
 		 * /dev/kmsg and syslog() users.
 		 */
-		if (console_trylock_for_printk(this_cpu))
+		if (console_trylock_for_printk())
 			console_unlock();
+		preempt_enable();
+		lockdep_on();
 	}
 
-	lockdep_on();
-out_restore_irqs:
-	local_irq_restore(flags);
 	return printed_len;
 }
 EXPORT_SYMBOL(vprintk_emit);
-- 
1.8.1.4


--5mCyUwZo2JvN/JJP--
