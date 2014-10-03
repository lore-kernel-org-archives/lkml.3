Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932473AbaJCWea (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 18:34:30 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:47779 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755504AbaJCWeG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 18:34:06 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>, Sergey Dyasly <dserrg@gmail.com>,
        Sameer Nanda <snanda@chromium.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mandeep Singh Baines <msb@chromium.org>,
        "Ma, Xindong" <xindong.ma@intel.com>, Michal Hocko <mhocko@suse.cz>,
        "Tu, Xiaobing" <xiaobing.tu@intel.com>,
        David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Li Zefan <lizefan@huawei.com>
Subject: [PATCH 3.10 141/143] oom_kill: has_intersects_mems_allowed() needs rcu_read_lock()
Date: Fri,  3 Oct 2014 14:35:36 -0700
Message-Id: <20141003213318.700415452@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141003213314.470709810@linuxfoundation.org>
References: <20141003213314.470709810@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oleg Nesterov <oleg@redhat.com>

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
Cc: Li Zefan <lizefan@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/oom_kill.c |   19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

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
@@ -67,19 +69,20 @@ static bool has_intersects_mems_allowed(
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


