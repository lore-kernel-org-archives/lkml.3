Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932801AbaFIIwE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 04:52:04 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:58489 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755010AbaFIIvZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 04:51:25 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>,
        Sergey Dyasly <dserrg@gmail.com>, Sameer Nanda <snanda@chromium.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mandeep Singh Baines <msb@chromium.org>,
        "Ma, Xindong" <xindong.ma@intel.com>,
        "Tu, Xiaobing" <xiaobing.tu@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 004/146] oom_kill: add rcu_read_lock() into find_lock_task_mm()
Date: Mon,  9 Jun 2014 10:48:59 +0200
Message-Id: <fbdb0229b07126b55126a95d8e2cf60d47fe9848.1402303820.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <ebe219e45dcf94c1a34281167427cff4d742faef.1402303820.git.jslaby@suse.cz>
References: <ebe219e45dcf94c1a34281167427cff4d742faef.1402303820.git.jslaby@suse.cz>
In-Reply-To: <cover.1402303820.git.jslaby@suse.cz>
References: <cover.1402303820.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Oleg Nesterov <oleg@redhat.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 4d4048be8a93769350efa31d2482a038b7de73d0 upstream.

find_lock_task_mm() expects it is called under rcu or tasklist lock, but
it seems that at least oom_unkillable_task()->task_in_mem_cgroup() and
mem_cgroup_out_of_memory()->oom_badness() can call it lockless.

Perhaps we could fix the callers, but this patch simply adds rcu lock
into find_lock_task_mm().  This also allows to simplify a bit one of its
callers, oom_kill_process().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Sergey Dyasly <dserrg@gmail.com>
Cc: Sameer Nanda <snanda@chromium.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mandeep Singh Baines <msb@chromium.org>
Cc: "Ma, Xindong" <xindong.ma@intel.com>
Reviewed-by: Michal Hocko <mhocko@suse.cz>
Cc: "Tu, Xiaobing" <xiaobing.tu@intel.com>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 mm/oom_kill.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index 7cdd05e685dc..f5bed7f17463 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -102,14 +102,19 @@ struct task_struct *find_lock_task_mm(struct task_struct *p)
 {
 	struct task_struct *t;
 
+	rcu_read_lock();
+
 	for_each_thread(p, t) {
 		task_lock(t);
 		if (likely(t->mm))
-			return t;
+			goto found;
 		task_unlock(t);
 	}
+	t = NULL;
+found:
+	rcu_read_unlock();
 
-	return NULL;
+	return t;
 }
 
 /* return true if the task is not adequate as candidate victim task. */
@@ -461,10 +466,8 @@ void oom_kill_process(struct task_struct *p, gfp_t gfp_mask, int order,
 	}
 	read_unlock(&tasklist_lock);
 
-	rcu_read_lock();
 	p = find_lock_task_mm(victim);
 	if (!p) {
-		rcu_read_unlock();
 		put_task_struct(victim);
 		return;
 	} else if (victim != p) {
@@ -490,6 +493,7 @@ void oom_kill_process(struct task_struct *p, gfp_t gfp_mask, int order,
 	 * That thread will now get access to memory reserves since it has a
 	 * pending fatal signal.
 	 */
+	rcu_read_lock();
 	for_each_process(p)
 		if (p->mm == mm && !same_thread_group(p, victim) &&
 		    !(p->flags & PF_KTHREAD)) {
-- 
1.9.3

