Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752070AbaJEX5M (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2014 19:57:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16271 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751768AbaJEX5K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2014 19:57:10 -0400
Date: Mon, 6 Oct 2014 01:53:35 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>
Cc: Sasha Levin <sasha.levin@oracle.com>, Ingo Molnar <mingo@kernel.org>,
        Peter Anvin <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Denys Vlasenko <dvlasenk@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Chuck Ebbert <cebbert.lkml@gmail.com>
Subject: Re: [PATCH 0/1] stop the unbound recursion in
	preempt_schedule_context()
Message-ID: <20141005235335.GA23276@redhat.com>
References: <20140921184153.GA23727@redhat.com> <tip-0ad6e3c5199be12c9745da8f8b9e3c9f8066c235@git.kernel.org> <542E2B05.5080607@oracle.com> <20141003232631.GA3439@redhat.com> <CA+55aFwT3KFkGMgWz9Gag+xMHD=5X3RNz-iMswGD88_wnUT-Eg@mail.gmail.com> <CA+55aFxBAFMxAsSvgOcVuWy4FWH77E4NT8M3SYvQzxGBJ_qkHw@mail.gmail.com> <20141004003300.GA6297@redhat.com> <20141005202300.GA27962@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141005202300.GA27962@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

And, Frederic, this is off-topic but I am just curious...

I can't understand why exception_enter() calls context_tracking_user_exit()
unconditionally (unlike exception_exit), and why enter/exit need to check
context_tracking.state with irqs disabled.

IOW, any reason why the patch below is wrong?

Of course, context_tracking is per-cpu, so

	if (context_tracking_in_user()) {
		local_irq_save(flags);
		...

can be preempted and change the state on another CPU. But this should
be fine because the task must see the same .state on all CPU's or the
whole preempt context-tracking logic is broken?

Oleg.


--- x/include/linux/context_tracking.h
+++ x/include/linux/context_tracking.h
@@ -29,15 +29,14 @@ static inline void user_exit(void)
 
 static inline enum ctx_state exception_enter(void)
 {
-	enum ctx_state prev_ctx;
-
-	if (!context_tracking_is_enabled())
-		return 0;
-
-	prev_ctx = this_cpu_read(context_tracking.state);
-	context_tracking_user_exit();
+	if (context_tracking_is_enabled()) {
+		if (context_tracking_in_user()) {
+			context_tracking_user_exit();
+			return IN_USER;
+		}
+	}
 
-	return prev_ctx;
+	return IN_KERNEL;
 }
 
 static inline void exception_exit(enum ctx_state prev_ctx)
--- x/kernel/context_tracking.c
+++ x/kernel/context_tracking.c
@@ -74,8 +74,8 @@ void context_tracking_user_enter(void)
 	/* Kernel threads aren't supposed to go to userspace */
 	WARN_ON_ONCE(!current->mm);
 
-	local_irq_save(flags);
-	if ( __this_cpu_read(context_tracking.state) != IN_USER) {
+	if (!context_tracking_in_user()) {
+		local_irq_save(flags);
 		if (__this_cpu_read(context_tracking.active)) {
 			trace_user_enter(0);
 			/*
@@ -102,8 +102,8 @@ void context_tracking_user_enter(void)
 		 * is false because we know that CPU is not tickless.
 		 */
 		__this_cpu_write(context_tracking.state, IN_USER);
+		local_irq_restore(flags);
 	}
-	local_irq_restore(flags);
 }
 NOKPROBE_SYMBOL(context_tracking_user_enter);
 
@@ -128,8 +128,8 @@ void context_tracking_user_exit(void)
 	if (in_interrupt())
 		return;
 
-	local_irq_save(flags);
-	if (__this_cpu_read(context_tracking.state) == IN_USER) {
+	if (context_tracking_in_user()) {
+		local_irq_save(flags);
 		if (__this_cpu_read(context_tracking.active)) {
 			/*
 			 * We are going to run code that may use RCU. Inform
@@ -140,8 +140,8 @@ void context_tracking_user_exit(void)
 			trace_user_exit(0);
 		}
 		__this_cpu_write(context_tracking.state, IN_KERNEL);
+		local_irq_restore(flags);
 	}
-	local_irq_restore(flags);
 }
 NOKPROBE_SYMBOL(context_tracking_user_exit);
 

