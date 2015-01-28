Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934037AbbA1EU0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 23:20:26 -0500
Received: from mail.kernel.org ([198.145.29.136]:39174 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934010AbbA1EUV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 23:20:21 -0500
From: lizf@kernel.org
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Michal Hocko <mhocko@suse.cz>, Pavel Emelyanov <xemul@parallels.com>,
        Sergey Dyasly <dserrg@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Zefan Li <lizefan@huawei.com>
Subject: [PATCH 3.4 071/177] kernel/fork.c:copy_process(): unify CLONE_THREAD-or-thread_group_leader code
Date: Wed, 28 Jan 2015 12:08:28 +0800
Message-Id: <1422418236-12852-141-git-send-email-lizf@kernel.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422418050-12581-1-git-send-email-lizf@kernel.org>
References: <1422418050-12581-1-git-send-email-lizf@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Oleg Nesterov <oleg@redhat.com>

3.4.106-rc1 review patch.  If anyone has any objections, please let me know.

------------------


commit 80628ca06c5d42929de6bc22c0a41589a834d151 upstream.

Cleanup and preparation for the next changes.

Move the "if (clone_flags & CLONE_THREAD)" code down under "if
(likely(p->pid))" and turn it into into the "else" branch.  This makes the
process/thread initialization more symmetrical and removes one check.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Sergey Dyasly <dserrg@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 kernel/fork.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/kernel/fork.c b/kernel/fork.c
index 878dcb2..0a189c0 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1412,14 +1412,6 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 		goto bad_fork_free_pid;
 	}
 
-	if (clone_flags & CLONE_THREAD) {
-		current->signal->nr_threads++;
-		atomic_inc(&current->signal->live);
-		atomic_inc(&current->signal->sigcnt);
-		p->group_leader = current->group_leader;
-		list_add_tail_rcu(&p->thread_group, &p->group_leader->thread_group);
-	}
-
 	if (likely(p->pid)) {
 		ptrace_init_task(p, (clone_flags & CLONE_PTRACE) || trace);
 
@@ -1434,6 +1426,13 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 			list_add_tail(&p->sibling, &p->real_parent->children);
 			list_add_tail_rcu(&p->tasks, &init_task.tasks);
 			__this_cpu_inc(process_counts);
+		} else {
+			current->signal->nr_threads++;
+			atomic_inc(&current->signal->live);
+			atomic_inc(&current->signal->sigcnt);
+			p->group_leader = current->group_leader;
+			list_add_tail_rcu(&p->thread_group,
+					  &p->group_leader->thread_group);
 		}
 		attach_pid(p, PIDTYPE_PID, pid);
 		nr_threads++;
-- 
1.9.1

