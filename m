Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758315AbaJCWaP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 18:30:15 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:47643 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757131AbaJCW3s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 18:29:48 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Michal Hocko <mhocko@suse.cz>, Pavel Emelyanov <xemul@parallels.com>,
        Sergey Dyasly <dserrg@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Li Zefan <lizefan@huawei.com>
Subject: [PATCH 3.10 138/143] kernel/fork.c:copy_process(): unify CLONE_THREAD-or-thread_group_leader code
Date: Fri,  3 Oct 2014 14:35:33 -0700
Message-Id: <20141003213318.613357435@linuxfoundation.org>
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
Cc: Li Zefan <lizefan@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/fork.c |   15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1448,14 +1448,6 @@ static struct task_struct *copy_process(
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
 
@@ -1472,6 +1464,13 @@ static struct task_struct *copy_process(
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


