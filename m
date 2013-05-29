Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966331Ab3E2OnY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 10:43:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11386 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966095Ab3E2OnX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 10:43:23 -0400
Date: Wed, 29 May 2013 16:39:38 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Michal Hocko <mhocko@suse.cz>,
        Sergey Dyasly <dserrg@gmail.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] don't use task->pid/tgid in
	same_thread_group/has_group_leader_pid
Message-ID: <20130529143938.GA22211@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

task_struct->pid/tgid should go away.

1. Change same_thread_group() to use task->signal for comparison.

2. Change has_group_leader_pid(task) to compare task_pid(task) with
   signal->leader_pid.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 include/linux/sched.h |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 178a8d9..ce51dfd 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2179,15 +2179,15 @@ static inline bool thread_group_leader(struct task_struct *p)
  * all we care about is that we have a task with the appropriate
  * pid, we don't actually care if we have the right task.
  */
-static inline int has_group_leader_pid(struct task_struct *p)
+static inline bool has_group_leader_pid(struct task_struct *p)
 {
-	return p->pid == p->tgid;
+	return task_pid(p) == p->signal->leader_pid;
 }
 
 static inline
-int same_thread_group(struct task_struct *p1, struct task_struct *p2)
+bool same_thread_group(struct task_struct *p1, struct task_struct *p2)
 {
-	return p1->tgid == p2->tgid;
+	return p1->signal == p2->signal;
 }
 
 static inline struct task_struct *next_thread(const struct task_struct *p)
-- 
1.5.5.1


