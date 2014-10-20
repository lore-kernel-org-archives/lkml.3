Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753253AbaJTT7k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 15:59:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32628 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751680AbaJTT7i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 15:59:38 -0400
Date: Mon, 20 Oct 2014 21:56:18 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Michal Hocko <mhocko@suse.cz>
Cc: Cong Wang <xiyou.wangcong@gmail.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Tejun Heo <tj@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: oom && coredump
Message-ID: <20141020195618.GA606@redhat.com>
References: <20141017171904.GA12263@redhat.com> <20141020184657.GA505@dhcp22.suse.cz> <20141020190620.GA21882@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141020190620.GA21882@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/20, Oleg Nesterov wrote:
>
> And I agree that it
> is hardly possible to close this race, and this patch makes the things
> better.

speaking of "partial" fixes for oom problems...

Perhaps the patch below makes sense? Sure, it is racy, but probably
better than nothing. And in any case (imo) this SIGNAL_GROUP_COREDUMP
check doesn't look bad, the coredumping task can consume more memory,
and we can't assume it is going to actually exit soon.

And at least we can kill that ugly and wrong ptrace check.

What do you think?

Oleg.

--- x/mm/oom_kill.c
+++ x/mm/oom_kill.c
@@ -254,6 +254,12 @@ static enum oom_constraint constrained_alloc(struct zonelist *zonelist,
 }
 #endif
 
+static inline bool task_will_free_mem(struct task_struct *task)
+{
+	return (task->flags & PF_EXITING) &&
+		!(task->signal->flags & SIGNAL_GROUP_COREDUMP);
+}
+
 enum oom_scan_t oom_scan_process_thread(struct task_struct *task,
 		unsigned long totalpages, const nodemask_t *nodemask,
 		bool force_kill)
@@ -281,14 +287,9 @@ enum oom_scan_t oom_scan_process_thread(struct task_struct *task,
 	if (oom_task_origin(task))
 		return OOM_SCAN_SELECT;
 
-	if (task->flags & PF_EXITING && !force_kill) {
-		/*
-		 * If this task is not being ptraced on exit, then wait for it
-		 * to finish before killing some other task unnecessarily.
-		 */
-		if (!(task->group_leader->ptrace & PT_TRACE_EXIT))
-			return OOM_SCAN_ABORT;
-	}
+	if (task_will_free_mem(task) && !force_kill)
+		return OOM_SCAN_ABORT;
+
 	return OOM_SCAN_OK;
 }
 
@@ -426,7 +427,7 @@ void oom_kill_process(struct task_struct *p, gfp_t gfp_mask, int order,
 	 * If the task is already exiting, don't alarm the sysadmin or kill
 	 * its children or threads, just set TIF_MEMDIE so it can die quickly
 	 */
-	if (p->flags & PF_EXITING) {
+	if (task_will_free_mem(p)) {
 		set_tsk_thread_flag(p, TIF_MEMDIE);
 		put_task_struct(p);
 		return;
@@ -632,7 +633,7 @@ void out_of_memory(struct zonelist *zonelist, gfp_t gfp_mask,
 	 * select it.  The goal is to allow it to allocate so that it may
 	 * quickly exit and free its memory.
 	 */
-	if (fatal_signal_pending(current) || current->flags & PF_EXITING) {
+	if (fatal_signal_pending(current) || task_will_free_mem(current)) {
 		set_thread_flag(TIF_MEMDIE);
 		return;
 	}

