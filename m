Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932611AbaFIIv5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 04:51:57 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:58480 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754979AbaFIIvZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 04:51:25 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mandeep Singh Baines <msb@chromium.org>,
        "Ma, Xindong" <xindong.ma@intel.com>,
        "Tu, Xiaobing" <xiaobing.tu@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 003/146] oom_kill: has_intersects_mems_allowed() needs rcu_read_lock()
Date: Mon,  9 Jun 2014 10:48:58 +0200
Message-Id: <c7b27263d6277b2256ae088a2d6c6bed0b393aed.1402303820.git.jslaby@suse.cz>
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

commit ad96244179fbd55b40c00f10f399bc04739b8e1f upstream.

At least out_of_memory() calls has_intersects_mems_allowed() without
even rcu_read_lock(), this is obviously buggy.

Add the necessary rcu_read_lock().  This means that we can not simply
return from the loop, we need "bool ret" and "break".

While at it, swap the names of task_struct's (the argument and the
local).  This cleans up the code a little bit and avoids the unnecessary
initialization.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Reviewed-by: Sergey Dyasly <dserrg@gmail.com>
Tested-by: Sergey Dyasly <dserrg@gmail.com>
Reviewed-by: Sameer Nanda <snanda@chromium.org>
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
 mm/oom_kill.c | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index cae791c15c51..7cdd05e685dc 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -47,18 +47,20 @@ static DEFINE_SPINLOCK(zone_scan_lock);
 #ifdef CONFIG_NUMA
 /**
  * has_intersects_mems_allowed() - check task eligiblity for kill
- * @tsk: task struct of which task to consider
+ * @start: task struct of which task to consider
  * @mask: nodemask passed to page allocator for mempolicy ooms
  *
  * Task eligibility is determined by whether or not a candidate task, @tsk,
  * shares the same mempolicy nodes as current if it is bound by such a policy
  * and whether or not it has the same set of allowed cpuset nodes.
  */
-static bool has_intersects_mems_allowed(struct task_struct *tsk,
+static bool has_intersects_mems_allowed(struct task_struct *start,
 					const nodemask_t *mask)
 {
-	struct task_struct *start = tsk;
+	struct task_struct *tsk;
+	bool ret = false;
 
+	rcu_read_lock();
 	for_each_thread(start, tsk) {
 		if (mask) {
 			/*
@@ -67,19 +69,20 @@ static bool has_intersects_mems_allowed(struct task_struct *tsk,
 			 * mempolicy intersects current, otherwise it may be
 			 * needlessly killed.
 			 */
-			if (mempolicy_nodemask_intersects(tsk, mask))
-				return true;
+			ret = mempolicy_nodemask_intersects(tsk, mask);
 		} else {
 			/*
 			 * This is not a mempolicy constrained oom, so only
 			 * check the mems of tsk's cpuset.
 			 */
-			if (cpuset_mems_allowed_intersects(current, tsk))
-				return true;
+			ret = cpuset_mems_allowed_intersects(current, tsk);
 		}
+		if (ret)
+			break;
 	}
+	rcu_read_unlock();
 
-	return false;
+	return ret;
 }
 #else
 static bool has_intersects_mems_allowed(struct task_struct *tsk,
-- 
1.9.3

