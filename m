Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753866Ab3IWJq1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 05:46:27 -0400
Received: from mail.windriver.com ([147.11.1.11]:48412 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753827Ab3IWJqE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 05:46:04 -0400
From: Ming Liu <ming.liu@windriver.com>
To: <akpm@linux-foundation.org>, <rientjes@google.com>, <mhocko@suse.cz>,
        <rusty@rustcorp.com.au>, <hannes@cmpxchg.org>
CC: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] oom: avoid killing init if it assume the oom killed thread's mm
Date: Mon, 23 Sep 2013 17:45:28 +0800
Message-ID: <1379929528-19179-1-git-send-email-ming.liu@windriver.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After selecting a task to kill, the oom killer iterates all processes and
kills all other user threads that share the same mm_struct in different
thread groups.

But in some extreme cases, the selected task happens to be a vfork child
of init process sharing the same mm_struct with it, which causes kernel
panic on init getting killed. This panic is observed in a busybox shell
that busybox itself is init, with a kthread keeps consuming memories.

Signed-off-by: Ming Liu <ming.liu@windriver.com>
---
 mm/oom_kill.c |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index 314e9d2..7db4881 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -479,17 +479,17 @@ void oom_kill_process(struct task_struct *p, gfp_t gfp_mask, int order,
 	task_unlock(victim);
 
 	/*
-	 * Kill all user processes sharing victim->mm in other thread groups, if
-	 * any.  They don't get access to memory reserves, though, to avoid
-	 * depletion of all memory.  This prevents mm->mmap_sem livelock when an
-	 * oom killed thread cannot exit because it requires the semaphore and
-	 * its contended by another thread trying to allocate memory itself.
-	 * That thread will now get access to memory reserves since it has a
-	 * pending fatal signal.
+	 * Kill all user processes except init sharing victim->mm in other
+	 * thread groups, if any.  They don't get access to memory reserves,
+	 * though, to avoid depletion of all memory.  This prevents mm->mmap_sem
+	 * livelock when an oom killed thread cannot exit because it requires
+	 * the semaphore and its contended by another thread trying to allocate
+	 * memory itself. That thread will now get access to memory reserves
+	 * since it has a pending fatal signal.
 	 */
 	for_each_process(p)
 		if (p->mm == mm && !same_thread_group(p, victim) &&
-		    !(p->flags & PF_KTHREAD)) {
+		    !(p->flags & PF_KTHREAD) && !is_global_init(p)) {
 			if (p->signal->oom_score_adj == OOM_SCORE_ADJ_MIN)
 				continue;
 
-- 
1.7.0.4

