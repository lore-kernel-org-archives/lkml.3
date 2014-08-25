Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755140AbaHYKyq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 06:54:46 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:58497 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751894AbaHYKyp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 06:54:45 -0400
From: Kautuk Consul <consul.kautuk@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>,
        Michal Hocko <mhocko@suse.cz>, David Rientjes <rientjes@google.com>,
        Ionut Alexa <ionut.m.alexa@gmail.com>,
        Guillaume Morin <guillaume@morinfr.org>, linux-kernel@vger.kernel.org
Cc: Kautuk Consul <consul.kautuk@gmail.com>
Subject: [PATCH 1/1] do_exit(): Solve possibility of BUG() due to race with try_to_wake_up()
Date: Mon, 25 Aug 2014 16:24:24 +0530
Message-Id: <1408964064-21447-1-git-send-email-consul.kautuk@gmail.com>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I encountered a BUG() scenario within do_exit() on an ARM system.

The problem is due to a race scenario between do_exit() and try_to_wake_up()
on different CPUs due to usage of sleeping primitives such as __down_common
and wait_for_common.

Race Scenario
=============

Let us assume there are 2 CPUs A and B execute code in the following order:
1)	CPU A was running in user-mode and enters kernel mode via some
	syscall/exception handler.
2)	CPU A sets the current task(t) state to TASK_INTERRUPTIBLE via __down_common
	or wait_for_common.
3)	CPU A checks for signal_pending() and returns due to TIF_SIGPENDING
	being set in t's threadinfo due to a previous signal(say SIGKILL) being
	received on this task t.
4)	CPU A returns returns back to the assembly trap handler and calls
	do_work_pending() -> do_signal() -> get_signal() -> do_group_exit()
	 -> do_exit()
	CPU A  has not yet executed the following line of code before the final
	call to schedule:
    /* causes final put_task_struct in finish_task_switch(). */
    tsk->state = TASK_DEAD;
5)	CPU B tries to send a signal to task t (currently executing on CPU A)
	and thus enters: signal_wake_up_state() -> wake_up_state() ->
					 try_to_wake_up()
6)	CPU B executes all code in try_to_wake_up() till the call to
	ttwu_queue -> ttwu_do_activate -> ttwu_do_wakeup().
	CPU B has still not executed the following code in ttwu_do_wakeup():
	p->state = TASK_RUNNING;
7)	CPU A executes the following line of code:
    /* causes final put_task_struct in finish_task_switch(). */
    tsk->state = TASK_DEAD;
8)	CPU B executes the following code in ttwu_do_wakeup():
	p->state = TASK_RUNNING;
9)	CPU A continues to the call to do_exit() -> schedule().
	Since the tsk->state is TASK_RUNNING, the call to schedule() returns and
	do_exit() -> BUG() is hit on CPU A.

Alternate Solution
==================

An alternate solution would be to simply set the current task state to
TASK_RUNNING in __down_common(), wait_for_common() and all other interruptible
sleeping primitives in their if(signal_pending/signal_pending_state) conditional
blocks.

But this change seems to me to be more logical because:
i)		This will involve lesser changes to the kernel core code.
ii)		Any further sleeping primitives in the kernel also need not suffer from
		this kind of race scenario.

Signed-off-by: Kautuk Consul <consul.kautuk@gmail.com>
---
 kernel/exit.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/kernel/exit.c b/kernel/exit.c
index 32c58f7..69a8231 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -824,14 +824,16 @@ void do_exit(long code)
 	 *     (or hypervisor of virtual machine switches to other guest)
 	 *  As a result, we may become TASK_RUNNING after becoming TASK_DEAD
 	 *
-	 * To avoid it, we have to wait for releasing tsk->pi_lock which
-	 * is held by try_to_wake_up()
+	 * To solve this, we have to compete for tsk->pi_lock which is held by
+	 * try_to_wake_up().
 	 */
-	smp_mb();
-	raw_spin_unlock_wait(&tsk->pi_lock);
+	raw_spin_lock(&tsk->pi_lock);
 
 	/* causes final put_task_struct in finish_task_switch(). */
 	tsk->state = TASK_DEAD;
+
+	raw_spin_unlock(&tsk->pi_lock);
+
 	tsk->flags |= PF_NOFREEZE;	/* tell freezer to ignore us */
 	schedule();
 	BUG();
-- 
1.7.9.5

