Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752277AbaAOPBY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 10:01:24 -0500
Received: from cantor2.suse.de ([195.135.220.15]:50820 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752137AbaAOPBT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 10:01:19 -0500
From: Michal Hocko <mhocko@suse.cz>
To: <linux-mm@kvack.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
        David Rientjes <rientjes@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [RFC 1/3] memcg: notify userspace about OOM only when and action is due
Date: Wed, 15 Jan 2014 16:01:06 +0100
Message-Id: <1389798068-19885-2-git-send-email-mhocko@suse.cz>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1389798068-19885-1-git-send-email-mhocko@suse.cz>
References: <1389798068-19885-1-git-send-email-mhocko@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Userspace is currently notified about OOM condition after reclaim
fails to uncharge any memory after MEM_CGROUP_RECLAIM_RETRIES rounds.
This usually means that the memcg is really in troubles and an
OOM action (either done by userspace or kernel) has to be taken.
The kernel OOM killer however bails out and doesn't kill anything
if it sees an already dying/exiting task in a good hope a memory
will be released and the OOM situation will be resolved.

Therefore it makes sense to notify userspace only after really all
measures have been taken and an userspace action is required or
the kernel kills a task.

This patch is based on idea by David Rientjes to not notify
userspace when the current task is killed or in a late exiting.
The original patch, however, didn't handle in kernel oom killer
back offs which is implemtented by this patch.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
---
 include/linux/memcontrol.h | 5 +++++
 mm/memcontrol.c            | 9 +++++----
 mm/oom_kill.c              | 3 +++
 3 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index abd0113b6620..8aeb7c441533 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -134,6 +134,7 @@ unsigned long mem_cgroup_get_lru_size(struct lruvec *lruvec, enum lru_list);
 void mem_cgroup_update_lru_size(struct lruvec *, enum lru_list, int);
 extern void mem_cgroup_print_oom_info(struct mem_cgroup *memcg,
 					struct task_struct *p);
+extern void mem_cgroup_oom_notify(struct mem_cgroup *memcg);
 extern void mem_cgroup_replace_page_cache(struct page *oldpage,
 					struct page *newpage);
 
@@ -369,6 +370,10 @@ mem_cgroup_print_oom_info(struct mem_cgroup *memcg, struct task_struct *p)
 {
 }
 
+static inline void mem_cgroup_oom_notify(struct mem_cgroup *memcg)
+{
+}
+
 static inline void mem_cgroup_begin_update_page_stat(struct page *page,
 					bool *locked, unsigned long *flags)
 {
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index f016d26adfd3..491d368ae488 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2232,15 +2232,16 @@ bool mem_cgroup_oom_synchronize(bool handle)
 
 	locked = mem_cgroup_oom_trylock(memcg);
 
-	if (locked)
-		mem_cgroup_oom_notify(memcg);
-
 	if (locked && !memcg->oom_kill_disable) {
 		mem_cgroup_unmark_under_oom(memcg);
 		finish_wait(&memcg_oom_waitq, &owait.wait);
+		/* calls mem_cgroup_oom_notify if there is a task to kill */
 		mem_cgroup_out_of_memory(memcg, current->memcg_oom.gfp_mask,
 					 current->memcg_oom.order);
 	} else {
+		if (locked && memcg->oom_kill_disable)
+			mem_cgroup_oom_notify(memcg);
+
 		schedule();
 		mem_cgroup_unmark_under_oom(memcg);
 		finish_wait(&memcg_oom_waitq, &owait.wait);
@@ -5620,7 +5621,7 @@ static int mem_cgroup_oom_notify_cb(struct mem_cgroup *memcg)
 	return 0;
 }
 
-static void mem_cgroup_oom_notify(struct mem_cgroup *memcg)
+void mem_cgroup_oom_notify(struct mem_cgroup *memcg)
 {
 	struct mem_cgroup *iter;
 
diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index 054ff47c4478..96b97027fc4d 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -476,6 +476,9 @@ void oom_kill_process(struct task_struct *p, gfp_t gfp_mask, int order,
 		victim = p;
 	}
 
+	if (memcg)
+		mem_cgroup_oom_notify(memcg);
+
 	/* mm cannot safely be dereferenced after task_unlock(victim) */
 	mm = victim->mm;
 	pr_err("Killed process %d (%s) total-vm:%lukB, anon-rss:%lukB, file-rss:%lukB\n",
-- 
1.8.5.2

