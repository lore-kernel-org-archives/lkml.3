Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754011AbaHLAyJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 20:54:09 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:59161 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751201AbaHLAyH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 20:54:07 -0400
From: Cong Wang <xiyou.wangcong@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Cong Wang <xiyou.wangcong@gmail.com>, David Rientjes <rientjes@google.com>,
        Michal Hocko <mhocko@suse.cz>, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Subject: [Patch v2] freezer: check OOM kill while being frozen
Date: Mon, 11 Aug 2014 17:53:54 -0700
Message-Id: <1407804835-24763-1-git-send-email-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a race condition between OOM killer and freezer when
they try to operate on the same process, something like below:

        Process A       Process B               Process C
trigger page fault
then trigger oom
B=oom_scan_process_thread()
                                        cgroup freezer freeze(A, B)
                        ...
                        try_to_freeze()
                        stay in D state
oom_kill_process(B)
restart page fault
...

In this case, process A triggered a page fault in user-space,
and the kernel page fault handler triggered OOM, then kernel
selected process B as the victim, right before being killed
process B was frozen by process C therefore went to D state,
then kernel sent SIGKILL but it is already too late as
process B will not care about pending signals any more.

David Rientjes tried to fix same issue with commit
f660daac474c6f (oom: thaw threads if oom killed thread is
frozen before deferring) but it doesn't work any more, because
__thaw_task() just checks if it's frozen and then wakes it up,
but the frozen task, after waking up, will check if freezing()
is still true and continue to freeze itself if so. __thaw_task()
can't make freezing() return false since it doesn't change any
of these conditions, especially cgroup_freezing().

Fix this straightly by checking if the frozen process itself
has been killed by OOM killer, so that the frozen process will
recover itself and be killed finally.

Cc: David Rientjes <rientjes@google.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
---
 kernel/freezer.c | 19 +++++++++++--------
 mm/oom_kill.c    |  2 --
 2 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/kernel/freezer.c b/kernel/freezer.c
index aa6a8aa..1f90d70 100644
--- a/kernel/freezer.c
+++ b/kernel/freezer.c
@@ -52,6 +52,16 @@ bool freezing_slow_path(struct task_struct *p)
 }
 EXPORT_SYMBOL(freezing_slow_path);
 
+static bool i_should_thaw_myself(bool check_kthr_stop)
+{
+	if (!freezing(current) ||
+	    (check_kthr_stop && kthread_should_stop()) ||
+	    test_thread_flag(TIF_MEMDIE))
+		return true;
+	else
+		return false;
+}
+
 /* Refrigerator is place where frozen processes are stored :-). */
 bool __refrigerator(bool check_kthr_stop)
 {
@@ -67,8 +77,7 @@ bool __refrigerator(bool check_kthr_stop)
 
 		spin_lock_irq(&freezer_lock);
 		current->flags |= PF_FROZEN;
-		if (!freezing(current) ||
-		    (check_kthr_stop && kthread_should_stop()))
+		if (i_should_thaw_myself(check_kthr_stop))
 			current->flags &= ~PF_FROZEN;
 		spin_unlock_irq(&freezer_lock);
 
@@ -147,12 +156,6 @@ void __thaw_task(struct task_struct *p)
 {
 	unsigned long flags;
 
-	/*
-	 * Clear freezing and kick @p if FROZEN.  Clearing is guaranteed to
-	 * be visible to @p as waking up implies wmb.  Waking up inside
-	 * freezer_lock also prevents wakeups from leaking outside
-	 * refrigerator.
-	 */
 	spin_lock_irqsave(&freezer_lock, flags);
 	if (frozen(p))
 		wake_up_process(p);
diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index 1e11df8..112c278 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -266,8 +266,6 @@ enum oom_scan_t oom_scan_process_thread(struct task_struct *task,
 	 * Don't allow any other task to have access to the reserves.
 	 */
 	if (test_tsk_thread_flag(task, TIF_MEMDIE)) {
-		if (unlikely(frozen(task)))
-			__thaw_task(task);
 		if (!force_kill)
 			return OOM_SCAN_ABORT;
 	}
-- 
1.8.3.1

