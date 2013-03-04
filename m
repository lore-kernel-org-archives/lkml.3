Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756561Ab3CDJRn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 04:17:43 -0500
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:43114 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755596Ab3CDJRi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 04:17:38 -0500
Message-ID: <1362388648.3592.7.camel@ThinkPad-T5421.cn.ibm.com>
Subject: Re: [RFC PATCH] context_tracking/rcu: don't function trace before
 rcu_user_exit() finishes
From: Li Zhong <zhong@linux.vnet.ibm.com>
To: paulmck@linux.vnet.ibm.com
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Date: Mon, 04 Mar 2013 17:17:28 +0800
In-Reply-To: <20130228163847.GA3566@linux.vnet.ibm.com>
References: <1362039970.18895.28.camel@ThinkPad-T5421.cn.ibm.com>
	 <20130228163847.GA3566@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13030409-3568-0000-0000-0000033CBEF9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This updated version adds notrace to these functions directly:

I saw some RCU illegal usage from idle complaints when function tracer
is enabled with forced context tracking.

It seems that __schedule() might be called in function_trace_call() when
it re-enables preemption(if preemption and irqs are both enabled). 

So at the places where we call rcu_user_exit(), we need make sure that
no function tracer hooks could be called in preemption/irqs both enabled
environment before rcu_user_exit() finishes, or we might cause illegal
RCU usage in __schedule(). 

This patch tries to add notrace attribute to a couple of functions where
the above could happen, including user_exit(), and a few callers of
user_exit(). 

Signed-off-by: Li Zhong <zhong@linux.vnet.ibm.com>
--
 arch/x86/kernel/ptrace.c  | 4 ++--
 arch/x86/kernel/signal.c  | 2 +-
 kernel/context_tracking.c | 2 +-
 kernel/sched/core.c       | 2 +-
 4 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/ptrace.c b/arch/x86/kernel/ptrace.c
index 29a8120..ce9f12e 100644
--- a/arch/x86/kernel/ptrace.c
+++ b/arch/x86/kernel/ptrace.c
@@ -1488,7 +1488,7 @@ void send_sigtrap(struct task_struct *tsk, struct pt_regs *regs,
  * We must return the syscall number to actually look up in the table.
  * This can be -1L to skip running any syscall at all.
  */
-long syscall_trace_enter(struct pt_regs *regs)
+long notrace syscall_trace_enter(struct pt_regs *regs)
 {
 	long ret = 0;
 
@@ -1538,7 +1538,7 @@ out:
 	return ret ?: regs->orig_ax;
 }
 
-void syscall_trace_leave(struct pt_regs *regs)
+void notrace syscall_trace_leave(struct pt_regs *regs)
 {
 	bool step;
 
diff --git a/arch/x86/kernel/signal.c b/arch/x86/kernel/signal.c
index 6956299..7b60210 100644
--- a/arch/x86/kernel/signal.c
+++ b/arch/x86/kernel/signal.c
@@ -732,7 +732,7 @@ static void do_signal(struct pt_regs *regs)
  * notification of userspace execution resumption
  * - triggered by the TIF_WORK_MASK flags
  */
-void
+void notrace
 do_notify_resume(struct pt_regs *regs, void *unused, __u32 thread_info_flags)
 {
 	user_exit();
diff --git a/kernel/context_tracking.c b/kernel/context_tracking.c
index 65349f0..f598f61 100644
--- a/kernel/context_tracking.c
+++ b/kernel/context_tracking.c
@@ -83,7 +83,7 @@ void user_enter(void)
  * This call supports re-entrancy. This way it can be called from any exception
  * handler without needing to know if we came from userspace or not.
  */
-void user_exit(void)
+void notrace user_exit(void)
 {
 	unsigned long flags;
 
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 7f12624..178a6af 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2971,7 +2971,7 @@ asmlinkage void __sched schedule(void)
 EXPORT_SYMBOL(schedule);
 
 #ifdef CONFIG_CONTEXT_TRACKING
-asmlinkage void __sched schedule_user(void)
+asmlinkage void __sched notrace schedule_user(void)
 {
 	/*
 	 * If we come here after a random call to set_need_resched(),


