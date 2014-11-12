Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753507AbaKLS7E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 13:59:04 -0500
Received: from cantor2.suse.de ([195.135.220.15]:48094 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753294AbaKLS7A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 13:59:00 -0500
From: Michal Hocko <mhocko@suse.cz>
To: LKML <linux-kernel@vger.kernel.org>
Cc: <linux-mm@kvack.org>, linux-pm@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "\\\"Rafael J. Wysocki\\\"" <rjw@rjwysocki.net>,
        David Rientjes <rientjes@google.com>, Oleg Nesterov <oleg@redhat.com>,
        Cong Wang <xiyou.wangcong@gmail.com>
Subject: [RFC 1/4] OOM, PM: Do not miss OOM killed frozen tasks
Date: Wed, 12 Nov 2014 19:58:49 +0100
Message-Id: <1415818732-27712-2-git-send-email-mhocko@suse.cz>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1415818732-27712-1-git-send-email-mhocko@suse.cz>
References: <20141110163055.GC18373@dhcp22.suse.cz>
 <1415818732-27712-1-git-send-email-mhocko@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Although the freezer code ignores tasks which are killed by the OOM
killer (in freezing_slow_path) there are two problems why this is not
suitable for the PM freezer:
	- The information gets lost on its way from freezing path
	  because it is interpreted as if the task doesn't _need_ to be
	  frozen which is true also for other reasons
	- The killed task might be frozen (in cgroup) already but hasn't
	  woken up yet. We do not have an easy way to wait for such a
	  task

This means that try_to_freeze_tasks will consider all tasks frozen
despite there is an OOM victim waiting for its slice to wake up. The
OOM might have happened anytime before OOM exlusion started so it might
leak without PM freezer noticing and access already suspended devices.
Fix this by checking TIF_MEMDIE for each task in freeze_task and consider
such a task as blocking the freezer.

Also change the return value semantic as the current one is little bit
awkward. There is just one caller (try_to_freeze_tasks) which checks
the return value and it is only interested whether the request was
successful or the task blocks the freezing progress. It is natural to
reflect the success by true rather than false.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
---
 kernel/freezer.c       | 15 ++++++++++++---
 kernel/power/process.c |  5 ++---
 2 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/kernel/freezer.c b/kernel/freezer.c
index a8900a3bc27a..93bd3fc65371 100644
--- a/kernel/freezer.c
+++ b/kernel/freezer.c
@@ -113,7 +113,8 @@ static void fake_signal_wake_up(struct task_struct *p)
  * thread).
  *
  * RETURNS:
- * %false, if @p is not freezing or already frozen; %true, otherwise
+ * %false, if @p cannot get frozen; %true, if successful, already frozen or
+ * ignored by the freezer altogether.
  */
 bool freeze_task(struct task_struct *p)
 {
@@ -129,12 +130,20 @@ bool freeze_task(struct task_struct *p)
 	 * normally.
 	 */
 	if (freezer_should_skip(p))
+		return true;
+
+	/*
+	 * Do not check freezing state or attempt to freeze a task
+	 * which has been killed by OOM killer. We are just waiting
+	 * for the task to wake up and die.
+	 */
+	if (!test_tsk_thread_flag(p, TIF_MEMDIE))
 		return false;
 
 	spin_lock_irqsave(&freezer_lock, flags);
 	if (!freezing(p) || frozen(p)) {
 		spin_unlock_irqrestore(&freezer_lock, flags);
-		return false;
+		return true;
 	}
 
 	if (!(p->flags & PF_KTHREAD))
@@ -143,7 +152,7 @@ bool freeze_task(struct task_struct *p)
 		wake_up_state(p, TASK_INTERRUPTIBLE);
 
 	spin_unlock_irqrestore(&freezer_lock, flags);
-	return true;
+	return false;
 }
 
 void __thaw_task(struct task_struct *p)
diff --git a/kernel/power/process.c b/kernel/power/process.c
index 5a6ec8678b9a..3d528f291da8 100644
--- a/kernel/power/process.c
+++ b/kernel/power/process.c
@@ -47,11 +47,10 @@ static int try_to_freeze_tasks(bool user_only)
 		todo = 0;
 		read_lock(&tasklist_lock);
 		for_each_process_thread(g, p) {
-			if (p == current || !freeze_task(p))
+			if (p != current && freeze_task(p))
 				continue;
 
-			if (!freezer_should_skip(p))
-				todo++;
+			todo++;
 		}
 		read_unlock(&tasklist_lock);
 
-- 
2.1.1

