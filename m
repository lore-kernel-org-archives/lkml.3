Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752540AbaKJWAl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 17:00:41 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48608 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752397AbaKJWAj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 17:00:39 -0500
Date: Mon, 10 Nov 2014 23:00:29 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Aaron Tomlin <atomlin@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Roland McGrath <roland@hack.frob.com>,
        Sterling Alexander <stalexan@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/5] exit: reparent: use ->ptrace_entry rather than
	->sibling for EXIT_DEAD tasks
Message-ID: <20141110220029.GA31231@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141110215959.GA31106@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

reparent_leader() reuses ->sibling as a list node to add an EXIT_DEAD
task into dead_children list we are going to release. This obviously
removes the dead task from its real_parent->children list and this is
even good; the parent can do nothing with the EXIT_DEAD reparented
zombie, it only makes do_wait() slower.

But, this also means that it can not be reparented once again, so if
its new parent dies too nobody will update ->parent/real_parent, they
can point to the freed memory even before release_task() we are going
to call, this breaks the code which relies on pid_alive() to access
->real_parent/parent.

Fortunately this is mostly theoretical, this can only happen if init
or PR_SET_CHILD_SUBREAPER process ignores SIGCHLD and the new parent
sub-thread exits right after we drop tasklist_lock.

Change this code to use ->ptrace_entry instead, we know that the child
is not traced so nobody can ever use this member. This also allows to
unify this logic with exit_ptrace(), see the next changes.

Note: we really need to change release_task() to nullify real_parent/
parent/group_leader pointers, but we need to change the current users
first somehow. And it would be better to reap this zombie immediately
but release_task_locked() we need is complicated by proc_flush_task().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/exit.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/exit.c b/kernel/exit.c
index 5d30019..4a9b4c0 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -548,7 +548,7 @@ static void reparent_leader(struct task_struct *father, struct task_struct *p,
 	    p->exit_state == EXIT_ZOMBIE && thread_group_empty(p)) {
 		if (do_notify_parent(p, p->exit_signal)) {
 			p->exit_state = EXIT_DEAD;
-			list_move_tail(&p->sibling, dead);
+			list_add(&p->ptrace_entry, dead);
 		}
 	}
 
@@ -587,8 +587,8 @@ static void forget_original_parent(struct task_struct *father)
 
 	BUG_ON(!list_empty(&father->children));
 
-	list_for_each_entry_safe(p, n, &dead_children, sibling) {
-		list_del_init(&p->sibling);
+	list_for_each_entry_safe(p, n, &dead_children, ptrace_entry) {
+		list_del_init(&p->ptrace_entry);
 		release_task(p);
 	}
 }
-- 
1.5.5.1

