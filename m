Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754336Ab3KLA27 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 19:28:59 -0500
Received: from mail-ie0-f201.google.com ([209.85.223.201]:58584 "EHLO
	mail-ie0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753845Ab3KLA2y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 19:28:54 -0500
From: Sameer Nanda <snanda@chromium.org>
To: akpm@linux-foundation.org, mhocko@suse.cz, rientjes@google.com,
        hannes@cmpxchg.org, rusty@rustcorp.com.au, semenzato@google.com,
        murzin.v@gmail.com, oleg@redhat.com, dserrg@gmail.com,
        msb@chromium.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Sameer Nanda <snanda@chromium.org>
Subject: [PATCH v4] mm, oom: Fix race when selecting process to kill
Date: Mon, 11 Nov 2013 16:21:57 -0800
Message-Id: <1384215717-2389-1-git-send-email-snanda@chromium.org>
X-Mailer: git-send-email 1.8.4.1
In-Reply-To: <20131109151639.GB14249@redhat.com>
References: <20131109151639.GB14249@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The selection of the process to be killed happens in two spots:
first in select_bad_process and then a further refinement by
looking for child processes in oom_kill_process. Since this is
a two step process, it is possible that the process selected by
select_bad_process may get a SIGKILL just before oom_kill_process
executes. If this were to happen, __unhash_process deletes this
process from the thread_group list. This results in oom_kill_process
getting stuck in an infinite loop when traversing the thread_group
list of the selected process.

Fix this race by adding a pid_alive check for the selected process
with tasklist_lock held in oom_kill_process.

Signed-off-by: Sameer Nanda <snanda@chromium.org>
---
 mm/oom_kill.c | 24 +++++++++++++++++++-----
 1 file changed, 19 insertions(+), 5 deletions(-)

diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index 6738c47..57638ef 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -413,12 +413,20 @@ void oom_kill_process(struct task_struct *p, gfp_t gfp_mask, int order,
 					      DEFAULT_RATELIMIT_BURST);
 
 	/*
+	 * while_each_thread is currently not RCU safe. Lets hold the
+	 * tasklist_lock across all invocations of while_each_thread (including
+	 * the one in find_lock_task_mm) in this function.
+	 */
+	read_lock(&tasklist_lock);
+
+	/*
 	 * If the task is already exiting, don't alarm the sysadmin or kill
 	 * its children or threads, just set TIF_MEMDIE so it can die quickly
 	 */
-	if (p->flags & PF_EXITING) {
+	if (p->flags & PF_EXITING || !pid_alive(p)) {
 		set_tsk_thread_flag(p, TIF_MEMDIE);
 		put_task_struct(p);
+		read_unlock(&tasklist_lock);
 		return;
 	}
 
@@ -436,7 +444,6 @@ void oom_kill_process(struct task_struct *p, gfp_t gfp_mask, int order,
 	 * parent.  This attempts to lose the minimal amount of work done while
 	 * still freeing memory.
 	 */
-	read_lock(&tasklist_lock);
 	do {
 		list_for_each_entry(child, &t->children, sibling) {
 			unsigned int child_points;
@@ -456,12 +463,17 @@ void oom_kill_process(struct task_struct *p, gfp_t gfp_mask, int order,
 			}
 		}
 	} while_each_thread(p, t);
-	read_unlock(&tasklist_lock);
 
-	rcu_read_lock();
 	p = find_lock_task_mm(victim);
+
+	/*
+	 * Since while_each_thread is currently not RCU safe, this unlock of
+	 * tasklist_lock may need to be moved further down if any additional
+	 * while_each_thread loops get added to this function.
+	 */
+	read_unlock(&tasklist_lock);
+
 	if (!p) {
-		rcu_read_unlock();
 		put_task_struct(victim);
 		return;
 	} else if (victim != p) {
@@ -478,6 +490,8 @@ void oom_kill_process(struct task_struct *p, gfp_t gfp_mask, int order,
 		K(get_mm_counter(victim->mm, MM_FILEPAGES)));
 	task_unlock(victim);
 
+	rcu_read_lock();
+
 	/*
 	 * Kill all user processes sharing victim->mm in other thread groups, if
 	 * any.  They don't get access to memory reserves, though, to avoid
-- 
1.8.4.1

