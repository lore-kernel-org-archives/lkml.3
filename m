Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751402AbaEYIQr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2014 04:16:47 -0400
Received: from mail-we0-f182.google.com ([74.125.82.182]:35103 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750811AbaEYIQn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2014 04:16:43 -0400
Message-ID: <1401005799.15399.44.camel@marge.simpson.net>
Subject: [patch v2] rt/sched: fix resursion when CONTEXT_TRACKING and
 PREEMPT_LAZY are enabled
From: Mike Galbraith <umgwanakikbuti@gmail.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-rt-users <linux-rt-users@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, rostedt@goodmis.org,
        John Kacur <jkacur@redhat.com>
Date: Sun, 25 May 2014 10:16:39 +0200
In-Reply-To: <1400248411.5877.10.camel@marge.simpson.net>
References: <20140509181214.GK29014@linutronix.de>
	 <1399695303.5146.21.camel@marge.simpson.net>
	 <20140513154002.GD15049@linutronix.de>
	 <1400248411.5877.10.camel@marge.simpson.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-05-16 at 15:53 +0200, Mike Galbraith wrote: 
> On Tue, 2014-05-13 at 17:40 +0200, Sebastian Andrzej Siewior wrote: 
> > * Mike Galbraith | 2014-05-10 06:15:03 [+0200]:
> > 
> > >On Fri, 2014-05-09 at 20:12 +0200, Sebastian Andrzej Siewior wrote:
> > >
> > >> Known issues:
> > >> 
> > >>       - bcache is disabled.
> > >> 
> > >>       - lazy preempt on x86_64 leads to a crash with some load.
> > >
> > >That is only with NO_HZ_FUL enabled here.  Box blows the stack during
> > >task exit, eyeballing hasn't spotted the why.
> > 
> > Even if I disable NO_HZ_FULL it explodes as soon as hackbench starts.
> 
> Ah, you didn't turn CONTEXT_TRACKING off too.  The below made the dirty
> little SOB die here.

Something obviously went wrong with retest after deciding to do..

> --- a/include/linux/preempt_mask.h
> +++ b/include/linux/preempt_mask.h
> @@ -118,9 +118,15 @@ extern int in_serving_softirq(void);
>  		((preempt_count() & ~PREEMPT_ACTIVE) != PREEMPT_CHECK_OFFSET)
>  
>  #ifdef CONFIG_PREEMPT_COUNT
> -# define preemptible()	(preempt_count() == 0 && !irqs_disabled())
> +# define preemptible()		(preempt_count() == 0 && !irqs_disabled())
> +#ifdef CONFIG_PREEMPT_LAZY
> +# define preemptible_lazy()	(preempt_lazy_count() !=0 && !need_resched_now())
                             ahem ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

..that preemptible_lazy() bit.  Turn that back right side up.

(or you can do something completely different, like make it just not go
there ala 12-rt, or do the fold thing for rt as well, vs flag being set
meaning try to schedule and bail if not allowed [as usual])

If context tracking is enabled, we can recurse, and explode violently.
Add missing checks to preempt_schedule_context().

Fix other inconsistencies spotted while searching for the little SOB.

Signed-off-by: Mike Galbraith <umgwanakikbuti@gmail.com>
---
 arch/x86/include/asm/thread_info.h |    1 +
 include/linux/preempt.h            |    2 +-
 include/linux/preempt_mask.h       |   10 ++++++++--
 kernel/context_tracking.c          |    2 +-
 kernel/fork.c                      |    1 +
 kernel/sched/core.c                |   16 +++++-----------
 kernel/sched/fair.c                |    2 +-
 7 files changed, 18 insertions(+), 16 deletions(-)

--- a/arch/x86/include/asm/thread_info.h
+++ b/arch/x86/include/asm/thread_info.h
@@ -51,6 +51,7 @@ struct thread_info {
 	.flags		= 0,			\
 	.cpu		= 0,			\
 	.saved_preempt_count = INIT_PREEMPT_COUNT,	\
+	.preempt_lazy_count = 0,		\
 	.addr_limit	= KERNEL_DS,		\
 	.restart_block = {			\
 		.fn = do_no_restart_syscall,	\
--- a/include/linux/preempt.h
+++ b/include/linux/preempt.h
@@ -91,8 +91,8 @@ do { \
 
 #define preempt_lazy_enable() \
 do { \
-	dec_preempt_lazy_count(); \
 	barrier(); \
+	dec_preempt_lazy_count(); \
 	preempt_check_resched(); \
 } while (0)
 
--- a/include/linux/preempt_mask.h
+++ b/include/linux/preempt_mask.h
@@ -118,9 +118,15 @@ extern int in_serving_softirq(void);
 		((preempt_count() & ~PREEMPT_ACTIVE) != PREEMPT_CHECK_OFFSET)
 
 #ifdef CONFIG_PREEMPT_COUNT
-# define preemptible()	(preempt_count() == 0 && !irqs_disabled())
+# define preemptible()		(preempt_count() == 0 && !irqs_disabled())
+#ifdef CONFIG_PREEMPT_LAZY
+# define preemptible_lazy()	(preempt_lazy_count() == 0 || need_resched_now())
 #else
-# define preemptible()	0
+# define preemptible_lazy()	1
+#endif
+#else
+# define preemptible()		0
+# define preemptible_lazy()	0
 #endif
 
 #endif /* LINUX_PREEMPT_MASK_H */
--- a/kernel/context_tracking.c
+++ b/kernel/context_tracking.c
@@ -124,7 +124,7 @@ asmlinkage void __sched notrace preempt_
 {
 	enum ctx_state prev_ctx;
 
-	if (likely(!preemptible()))
+	if (likely(!preemptible() || !preemptible_lazy()))
 		return;
 
 	/*
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -329,6 +329,7 @@ static struct task_struct *dup_task_stru
 	setup_thread_stack(tsk, orig);
 	clear_user_return_notifier(tsk);
 	clear_tsk_need_resched(tsk);
+	clear_tsk_need_resched_lazy(tsk);
 	stackend = end_of_stack(tsk);
 	*stackend = STACK_END_MAGIC;	/* for overflow detection */
 
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2866,8 +2866,8 @@ void migrate_enable(void)
 		p->migrate_disable = 0;
 
 	unpin_current_cpu();
-	preempt_enable();
 	preempt_lazy_enable();
+	preempt_enable();
 }
 EXPORT_SYMBOL(migrate_enable);
 #else
@@ -3101,19 +3101,13 @@ asmlinkage void __sched notrace preempt_
 {
 	/*
 	 * If there is a non-zero preempt_count or interrupts are disabled,
-	 * we do not want to preempt the current task. Just return..
+	 * we do not want to preempt the current task. Just return.  For
+	 * lazy preemption we also check for non-zero preempt_count_lazy,
+	 * and bail if no immediate preemption is required.
 	 */
-	if (likely(!preemptible()))
+	if (likely(!preemptible() || !preemptible_lazy()))
 		return;
 
-#ifdef CONFIG_PREEMPT_LAZY
-	/*
-	 * Check for lazy preemption
-	 */
-	if (current_thread_info()->preempt_lazy_count &&
-			!test_thread_flag(TIF_NEED_RESCHED))
-		return;
-#endif
 	do {
 		__preempt_count_add(PREEMPT_ACTIVE);
 		/*
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4447,7 +4447,7 @@ static void check_preempt_wakeup(struct
 	 * prevents us from potentially nominating it as a false LAST_BUDDY
 	 * below.
 	 */
-	if (test_tsk_need_resched(curr))
+	if (test_tsk_need_resched(curr) || test_tsk_need_resched_lazy(curr))
 		return;
 
 	/* Idle tasks are by definition preempted by non-idle tasks. */


