Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758544AbaJCWeY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 18:34:24 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:47791 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755438AbaJCWeG (ORCPT
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
Subject: [PATCH 3.10 142/143] oom_kill: add rcu_read_lock() into find_lock_task_mm()
Date: Fri,  3 Oct 2014 14:35:37 -0700
Message-Id: <20141003213318.729698290@linuxfoundation.org>
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
Cc: Li Zefan <lizefan@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/oom_kill.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -102,14 +102,19 @@ struct task_struct *find_lock_task_mm(st
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
@@ -461,10 +466,8 @@ void oom_kill_process(struct task_struct
 	}
 	read_unlock(&tasklist_lock);
 
-	rcu_read_lock();
 	p = find_lock_task_mm(victim);
 	if (!p) {
-		rcu_read_unlock();
 		put_task_struct(victim);
 		return;
 	} else if (victim != p) {
@@ -490,6 +493,7 @@ void oom_kill_process(struct task_struct
 	 * That thread will now get access to memory reserves since it has a
 	 * pending fatal signal.
 	 */
+	rcu_read_lock();
 	for_each_process(p)
 		if (p->mm == mm && !same_thread_group(p, victim) &&
 		    !(p->flags & PF_KTHREAD)) {


