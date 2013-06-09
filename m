Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751697Ab3FIREa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jun 2013 13:04:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59903 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751598Ab3FIRE1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jun 2013 13:04:27 -0400
Date: Sun, 9 Jun 2013 19:00:26 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Michal Hocko <mhocko@suse.cz>,
        Pavel Emelyanov <xemul@parallels.com>,
        Sergey Dyasly <dserrg@gmail.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] copy_process: unify
	CLONE_THREAD-or-thread_group_leader code
Message-ID: <20130609170026.GA5236@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130609170007.GA5215@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cleanup and preparation for the next changes.

Move the "if (clone_flags & CLONE_THREAD)" code down under
"if (likely(p->pid))" and turn it into into the "else" branch.
This makes the process/thread initialization more symmetrical
and removes one check.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/fork.c |   15 +++++++--------
 1 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/kernel/fork.c b/kernel/fork.c
index 987b28a..7bc4146 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1446,14 +1446,6 @@ static struct task_struct *copy_process(unsigned long clone_flags,
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
 
@@ -1470,6 +1462,13 @@ static struct task_struct *copy_process(unsigned long clone_flags,
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
1.5.5.1

