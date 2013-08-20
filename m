Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751907Ab3HTVeQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 17:34:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5538 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751822Ab3HTVdo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 17:33:44 -0400
From: Richard Guy Briggs <rgb@redhat.com>
To: linux-audit@redhat.com, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org
Cc: Richard Guy Briggs <rgb@redhat.com>, Eric Paris <eparis@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        John Johansen <john.johansen@canonical.com>,
        James Morris <james.l.morris@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Kentaro Takeda <takedakn@nttdata.co.jp>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 11/12] pid: rewrite task helper functions avoiding task->pid and task->tgid
Date: Tue, 20 Aug 2013 17:32:03 -0400
Message-Id: <bbf1d1952bd17e3b19ecbafb1d1603d0bed72381.1377032086.git.rgb@redhat.com>
In-Reply-To: <cover.1377032086.git.rgb@redhat.com>
References: <cover.1377032086.git.rgb@redhat.com>
In-Reply-To: <cover.1377032086.git.rgb@redhat.com>
References: <cover.1377032086.git.rgb@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This stops these four task helper functions from using the deprecated and
error-prone task->pid and task->tgid.

(informed by ebiederman's ea5a4d01)
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
---
 include/linux/sched.h |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 8e69807..46e739d 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1579,7 +1579,7 @@ static inline int pid_alive(struct task_struct *p)
  */
 static inline int is_global_init(struct task_struct *tsk)
 {
-	return tsk->pid == 1;
+	return task_pid_nr(tsk) == 1;
 }
 
 extern struct pid *cad_pid;
@@ -1930,7 +1930,7 @@ extern struct task_struct *idle_task(int cpu);
  */
 static inline bool is_idle_task(const struct task_struct *p)
 {
-	return p->pid == 0;
+	return task_pid(p) == &init_struct_pid;
 }
 extern struct task_struct *curr_task(int cpu);
 extern void set_curr_task(int cpu, struct task_struct *p);
@@ -2203,13 +2203,13 @@ static inline bool thread_group_leader(struct task_struct *p)
  */
 static inline int has_group_leader_pid(struct task_struct *p)
 {
-	return p->pid == p->tgid;
+	return task_pid(p) == task_tgid(p);
 }
 
 static inline
 int same_thread_group(struct task_struct *p1, struct task_struct *p2)
 {
-	return p1->tgid == p2->tgid;
+	return task_tgid(p1) == task_tgid(p2);
 }
 
 static inline struct task_struct *next_thread(const struct task_struct *p)
-- 
1.7.1

