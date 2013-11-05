Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755836Ab3KEX11 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 18:27:27 -0500
Received: from mail-ve0-f201.google.com ([209.85.128.201]:64867 "EHLO
	mail-ve0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755462Ab3KEX10 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 18:27:26 -0500
From: Sameer Nanda <snanda@chromium.org>
To: akpm@linux-foundation.org, mhocko@suse.cz, rientjes@google.com,
        hannes@cmpxchg.org, rusty@rustcorp.com.au
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Sameer Nanda <snanda@chromium.org>
Subject: [PATCH] mm, oom: Fix race when selecting process to kill
Date: Tue,  5 Nov 2013 15:26:27 -0800
Message-Id: <1383693987-14171-1-git-send-email-snanda@chromium.org>
X-Mailer: git-send-email 1.8.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The selection of the process to be killed happens in two spots -- first
in select_bad_process and then a further refinement by looking for
child processes in oom_kill_process. Since this is a two step process,
it is possible that the process selected by select_bad_process may get a
SIGKILL just before oom_kill_process executes. If this were to happen,
__unhash_process deletes this process from the thread_group list. This
then results in oom_kill_process getting stuck in an infinite loop when
traversing the thread_group list of the selected process.

Fix this race by holding the tasklist_lock across the calls to both
select_bad_process and oom_kill_process.

Change-Id: I8f96b106b3257b5c103d6497bac7f04f4dff4e60
Signed-off-by: Sameer Nanda <snanda@chromium.org>
---
 mm/oom_kill.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index 6738c47..7bd3587 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -436,7 +436,6 @@ void oom_kill_process(struct task_struct *p, gfp_t gfp_mask, int order,
 	 * parent.  This attempts to lose the minimal amount of work done while
 	 * still freeing memory.
 	 */
-	read_lock(&tasklist_lock);
 	do {
 		list_for_each_entry(child, &t->children, sibling) {
 			unsigned int child_points;
@@ -456,7 +455,6 @@ void oom_kill_process(struct task_struct *p, gfp_t gfp_mask, int order,
 			}
 		}
 	} while_each_thread(p, t);
-	read_unlock(&tasklist_lock);
 
 	rcu_read_lock();
 	p = find_lock_task_mm(victim);
@@ -641,6 +639,7 @@ void out_of_memory(struct zonelist *zonelist, gfp_t gfp_mask,
 	mpol_mask = (constraint == CONSTRAINT_MEMORY_POLICY) ? nodemask : NULL;
 	check_panic_on_oom(constraint, gfp_mask, order, mpol_mask);
 
+	read_lock(&tasklist_lock);
 	if (sysctl_oom_kill_allocating_task && current->mm &&
 	    !oom_unkillable_task(current, NULL, nodemask) &&
 	    current->signal->oom_score_adj != OOM_SCORE_ADJ_MIN) {
@@ -663,6 +662,7 @@ void out_of_memory(struct zonelist *zonelist, gfp_t gfp_mask,
 		killed = 1;
 	}
 out:
+	read_unlock(&tasklist_lock);
 	/*
 	 * Give the killed threads a good chance of exiting before trying to
 	 * allocate memory again.
-- 
1.8.4.1

