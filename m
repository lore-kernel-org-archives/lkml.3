Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752263AbaL2Mcl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2014 07:32:41 -0500
Received: from cantor2.suse.de ([195.135.220.15]:36988 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752215AbaL2Mce (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2014 07:32:34 -0500
From: Michal Hocko <mhocko@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Rientjes <rientjes@google.com>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Oleg Nesterov <oleg@redhat.com>, <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/2] oom: Make sure that TIF_MEMDIE is set under task_lock
Date: Mon, 29 Dec 2014 13:32:07 +0100
Message-Id: <1419856327-673-3-git-send-email-mhocko@suse.cz>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1419856327-673-1-git-send-email-mhocko@suse.cz>
References: <1419856327-673-1-git-send-email-mhocko@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OOM killer tries to exclude tasks which do not have mm_struct associated
because killing such a task wouldn't help much. The OOM victim gets
TIF_MEMDIE set to disable OOM killer while the current victim releases
the memory and then enables the OOM killer again by dropping the flag.

oom_kill_process is currently prone to a race condition when the OOM
victim is already exiting and TIF_MEMDIE is set after the task releases
its address space. This might theoretically lead to OOM livelock if
the OOM victim blocks on an allocation later during exiting because
it wouldn't kill any other process and the exiting one won't be able
to exit. The situation is highly unlikely because the OOM victim is
expected to release some memory which should help to sort out OOM
situation.

Fix this by checking task->mm and setting TIF_MEMDIE flag under task_lock
which will serialize the OOM killer with exit_mm which sets task->mm to
NULL.
Setting the flag for current is not necessary because check and set is
not racy.

Reported-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Michal Hocko <mhocko@suse.cz>
---
 mm/oom_kill.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index f82dd13cca68..294493a7ae4b 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -438,11 +438,14 @@ void oom_kill_process(struct task_struct *p, gfp_t gfp_mask, int order,
 	 * If the task is already exiting, don't alarm the sysadmin or kill
 	 * its children or threads, just set TIF_MEMDIE so it can die quickly
 	 */
-	if (task_will_free_mem(p)) {
+	task_lock(p);
+	if (p->mm && task_will_free_mem(p)) {
 		set_tsk_thread_flag(p, TIF_MEMDIE);
+		task_unlock(p);
 		put_task_struct(p);
 		return;
 	}
+	task_unlock(p);
 
 	if (__ratelimit(&oom_rs))
 		dump_header(p, gfp_mask, order, memcg, nodemask);
@@ -492,6 +495,7 @@ void oom_kill_process(struct task_struct *p, gfp_t gfp_mask, int order,
 
 	/* mm cannot safely be dereferenced after task_unlock(victim) */
 	mm = victim->mm;
+	set_tsk_thread_flag(victim, TIF_MEMDIE);
 	pr_err("Killed process %d (%s) total-vm:%lukB, anon-rss:%lukB, file-rss:%lukB\n",
 		task_pid_nr(victim), victim->comm, K(victim->mm->total_vm),
 		K(get_mm_counter(victim->mm, MM_ANONPAGES)),
@@ -522,7 +526,6 @@ void oom_kill_process(struct task_struct *p, gfp_t gfp_mask, int order,
 		}
 	rcu_read_unlock();
 
-	set_tsk_thread_flag(victim, TIF_MEMDIE);
 	do_send_sig_info(SIGKILL, SEND_SIG_FORCED, victim, true);
 	put_task_struct(victim);
 }
-- 
2.1.4

