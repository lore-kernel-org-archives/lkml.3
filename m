Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752502AbaBNMfn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 07:35:43 -0500
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:24048 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751788AbaBNMfm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 07:35:42 -0500
Date: Fri, 14 Feb 2014 12:35:36 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Kirill Tkhai <ktkhai@parallels.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>, tkhai@yandex.ru
Subject: Re: [PATCH] sched/core: Create new task with twice disabled
 preemption
Message-ID: <20140214123536.GA12304@arm.com>
References: <1392306716.5384.3.camel@tkhai>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392306716.5384.3.camel@tkhai>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 13, 2014 at 07:51:56PM +0400, Kirill Tkhai wrote:
> Preemption state on enter in finish_task_switch() is different
> in cases of context_switch() and schedule_tail().
> 
> In the first case we have it twice disabled: at the start of
> schedule() and during spin locking. In the second it is only
> once: the value which was set in init_task_preempt_count().
> 
> For archs without __ARCH_WANT_UNLOCKED_CTXSW set this means
> that all newly created tasks execute finish_arch_post_lock_switch()
> and post_schedule() with preemption enabled.
> 
> It seems there is possible a problem in rare situations on arm64,
> when one freshly created thread preempts another before
> finish_arch_post_lock_switch() has finished. If mm is the same,
> then TIF_SWITCH_MM on the second won't be set.
> 
> The second rare but possible issue is zeroing of post_schedule()
> on a wrong cpu.
> 
> So, lets fix this and unify preempt_count state.

An alternative to your patch:

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index b46131ef6aab..b932b6a4c716 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2210,6 +2210,10 @@ asmlinkage void schedule_tail(struct task_struct *prev)
 {
 	struct rq *rq = this_rq();
 
+#ifndef __ARCH_WANT_UNLOCKED_CTXSW
+	/* In this case, finish_task_switch reenables preemption */
+	preempt_disable();
+#endif
 	finish_task_switch(rq, prev);
 
 	/*
@@ -2218,10 +2222,7 @@ asmlinkage void schedule_tail(struct task_struct *prev)
 	 */
 	post_schedule(rq);
 
-#ifdef __ARCH_WANT_UNLOCKED_CTXSW
-	/* In this case, finish_task_switch does not reenable preemption */
 	preempt_enable();
-#endif
 	if (current->set_child_tid)
 		put_user(task_pid_vnr(current), current->set_child_tid);
 }

-- 
Catalin
