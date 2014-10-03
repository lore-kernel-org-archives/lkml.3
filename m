Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758368AbaJCWbc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 18:31:32 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:47632 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756338AbaJCW3t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 18:29:49 -0400
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
Subject: [PATCH 3.10 140/143] oom_kill: change oom_kill.c to use for_each_thread()
Date: Fri,  3 Oct 2014 14:35:35 -0700
Message-Id: <20141003213318.671273467@linuxfoundation.org>
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

commit 1da4db0cd5c8a31d4468ec906b413e75e604b465 upstream.

Change oom_kill.c to use for_each_thread() rather than the racy
while_each_thread() which can loop forever if we race with exit.

Note also that most users were buggy even if while_each_thread() was
fine, the task can exit even _before_ rcu_read_lock().

Fortunately the new for_each_thread() only requires the stable
task_struct, so this change fixes both problems.

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
 mm/oom_kill.c |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -59,7 +59,7 @@ static bool has_intersects_mems_allowed(
 {
 	struct task_struct *start = tsk;
 
-	do {
+	for_each_thread(start, tsk) {
 		if (mask) {
 			/*
 			 * If this is a mempolicy constrained oom, tsk's
@@ -77,7 +77,7 @@ static bool has_intersects_mems_allowed(
 			if (cpuset_mems_allowed_intersects(current, tsk))
 				return true;
 		}
-	} while_each_thread(start, tsk);
+	}
 
 	return false;
 }
@@ -97,14 +97,14 @@ static bool has_intersects_mems_allowed(
  */
 struct task_struct *find_lock_task_mm(struct task_struct *p)
 {
-	struct task_struct *t = p;
+	struct task_struct *t;
 
-	do {
+	for_each_thread(p, t) {
 		task_lock(t);
 		if (likely(t->mm))
 			return t;
 		task_unlock(t);
-	} while_each_thread(p, t);
+	}
 
 	return NULL;
 }
@@ -301,7 +301,7 @@ static struct task_struct *select_bad_pr
 	unsigned long chosen_points = 0;
 
 	rcu_read_lock();
-	do_each_thread(g, p) {
+	for_each_process_thread(g, p) {
 		unsigned int points;
 
 		switch (oom_scan_process_thread(p, totalpages, nodemask,
@@ -323,7 +323,7 @@ static struct task_struct *select_bad_pr
 			chosen = p;
 			chosen_points = points;
 		}
-	} while_each_thread(g, p);
+	}
 	if (chosen)
 		get_task_struct(chosen);
 	rcu_read_unlock();
@@ -406,7 +406,7 @@ void oom_kill_process(struct task_struct
 {
 	struct task_struct *victim = p;
 	struct task_struct *child;
-	struct task_struct *t = p;
+	struct task_struct *t;
 	struct mm_struct *mm;
 	unsigned int victim_points = 0;
 	static DEFINE_RATELIMIT_STATE(oom_rs, DEFAULT_RATELIMIT_INTERVAL,
@@ -437,7 +437,7 @@ void oom_kill_process(struct task_struct
 	 * still freeing memory.
 	 */
 	read_lock(&tasklist_lock);
-	do {
+	for_each_thread(p, t) {
 		list_for_each_entry(child, &t->children, sibling) {
 			unsigned int child_points;
 
@@ -455,7 +455,7 @@ void oom_kill_process(struct task_struct
 				get_task_struct(victim);
 			}
 		}
-	} while_each_thread(p, t);
+	}
 	read_unlock(&tasklist_lock);
 
 	rcu_read_lock();


