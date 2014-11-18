Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932651AbaKRVKZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 16:10:25 -0500
Received: from cantor2.suse.de ([195.135.220.15]:38563 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753300AbaKRVKX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 16:10:23 -0500
From: Michal Hocko <mhocko@suse.cz>
To: LKML <linux-kernel@vger.kernel.org>
Cc: <linux-mm@kvack.org>, linux-pm@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "\\\"Rafael J. Wysocki\\\"" <rjw@rjwysocki.net>,
        David Rientjes <rientjes@google.com>, Oleg Nesterov <oleg@redhat.com>,
        Cong Wang <xiyou.wangcong@gmail.com>
Subject: [RFC 1/2] oom: add helper for setting and clearing TIF_MEMDIE
Date: Tue, 18 Nov 2014 22:10:05 +0100
Message-Id: <1416345006-8284-1-git-send-email-mhocko@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141118210833.GE23640@dhcp22.suse.cz>
References: <20141118210833.GE23640@dhcp22.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is just a preparatory and it doesn't introduce any functional
change.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
---
 include/linux/oom.h |  4 ++++
 kernel/exit.c       |  2 +-
 mm/memcontrol.c     |  2 +-
 mm/oom_kill.c       | 16 +++++++++++++---
 4 files changed, 19 insertions(+), 5 deletions(-)

diff --git a/include/linux/oom.h b/include/linux/oom.h
index e8d6e1058723..8f7e74f8ab3a 100644
--- a/include/linux/oom.h
+++ b/include/linux/oom.h
@@ -47,6 +47,10 @@ static inline bool oom_task_origin(const struct task_struct *p)
 	return !!(p->signal->oom_flags & OOM_FLAG_ORIGIN);
 }
 
+void mark_tsk_oom_victim(struct task_struct *tsk);
+
+void unmark_tsk_oom_victim(struct task_struct *tsk);
+
 extern unsigned long oom_badness(struct task_struct *p,
 		struct mem_cgroup *memcg, const nodemask_t *nodemask,
 		unsigned long totalpages);
diff --git a/kernel/exit.c b/kernel/exit.c
index 5d30019ff953..323882973b4b 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -459,7 +459,7 @@ static void exit_mm(struct task_struct *tsk)
 	task_unlock(tsk);
 	mm_update_next_owner(mm);
 	mmput(mm);
-	clear_thread_flag(TIF_MEMDIE);
+	unmark_tsk_oom_victim(current);
 }
 
 /*
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index d6ac0e33e150..302e0fc6d121 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1735,7 +1735,7 @@ static void mem_cgroup_out_of_memory(struct mem_cgroup *memcg, gfp_t gfp_mask,
 	 * quickly exit and free its memory.
 	 */
 	if (fatal_signal_pending(current) || current->flags & PF_EXITING) {
-		set_thread_flag(TIF_MEMDIE);
+		mark_tsk_oom_victim(current);
 		return;
 	}
 
diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index 5340f6b91312..8b6e14136f4f 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -421,6 +421,16 @@ void note_oom_kill(void)
 	atomic_inc(&oom_kills);
 }
 
+void mark_tsk_oom_victim(struct task_struct *tsk)
+{
+	set_tsk_thread_flag(tsk, TIF_MEMDIE);
+}
+
+void unmark_tsk_oom_victim(struct task_struct *tsk)
+{
+	clear_thread_flag(TIF_MEMDIE);
+}
+
 #define K(x) ((x) << (PAGE_SHIFT-10))
 /*
  * Must be called while holding a reference to p, which will be released upon
@@ -444,7 +454,7 @@ void oom_kill_process(struct task_struct *p, gfp_t gfp_mask, int order,
 	 * its children or threads, just set TIF_MEMDIE so it can die quickly
 	 */
 	if (p->flags & PF_EXITING) {
-		set_tsk_thread_flag(p, TIF_MEMDIE);
+		mark_tsk_oom_victim(p);
 		put_task_struct(p);
 		return;
 	}
@@ -527,7 +537,7 @@ void oom_kill_process(struct task_struct *p, gfp_t gfp_mask, int order,
 		}
 	rcu_read_unlock();
 
-	set_tsk_thread_flag(victim, TIF_MEMDIE);
+	mark_tsk_oom_victim(victim);
 	do_send_sig_info(SIGKILL, SEND_SIG_FORCED, victim, true);
 	put_task_struct(victim);
 }
@@ -650,7 +660,7 @@ void out_of_memory(struct zonelist *zonelist, gfp_t gfp_mask,
 	 * quickly exit and free its memory.
 	 */
 	if (fatal_signal_pending(current) || current->flags & PF_EXITING) {
-		set_thread_flag(TIF_MEMDIE);
+		mark_tsk_oom_victim(current);
 		return;
 	}
 
-- 
2.1.3

